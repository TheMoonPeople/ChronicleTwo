--!strict
-- Helper library for the script machine, loaded by transpiled scripts.
-- Scripts load it with require("@lib/vm").
local vm = {}

-- Truncates toward zero like C's float-to-integer conversion; NaN yields zero.
local function truncate(x: number): number
    if x ~= x then
        return 0
    end
    if x >= 0 then
        return math.floor(x)
    end
    return math.ceil(x)
end

-- The metatable of the error that skip mode raises at a wait, which sections and guarded functions catch.
local SKIPPED = {}

-- What skip mode raises: the number of the wait it stopped at and, once a guarded function has run its tail, the values
-- that function returns (its result first, then its references) for its caller to continue with.
export type Skipped = { site: number, values: { any }? }

local function skipped(site: number, values: { any }?): Skipped
    return setmetatable({ site = site, values = values }, SKIPPED) :: any
end

-- Suspends the script until the engine resumes it on the next frame. In skip mode a wait raises instead of suspending,
-- and a script that was suspended here when skip mode began raises as soon as it resumes. Waits of event scripts carry
-- their number.
function vm.wait(site: number?): ()
    if site ~= nil and vmhost.skipping() then
        error(skipped(site), 0)
    end
    coroutine.yield()
    if site ~= nil and vmhost.skipping() then
        error(skipped(site), 0)
    end
end

-- The metatable of what a skip function hands back when a call it made in skip mode was resumed normally.
local CONTINUE = {}

-- The rest of a section or function after such a call, which then runs as usual.
export type Continue = { body: () -> ...any }

-- Hands back the code that runs after a call a skip function made, once the script was resumed normally inside it.
function vm.continue_with(body: () -> ...any): Continue
    return setmetatable({ body = body }, CONTINUE) :: any
end

-- The stop a failed pcall raised; any other error is raised again.
local function stop_of(err: any): Skipped
    if getmetatable(err) ~= SKIPPED then
        error(err, 0)
    end
    return err :: Skipped
end

-- The start of code that skip mode can enter: the script, when skipping, stops here as it would at a wait.
function vm.entry(site: number): ()
    if vmhost.skipping() then
        error(skipped(site), 0)
    end
end

-- Runs a region of an event script up to a skip end. When skip mode stops it at a wait, skip (if the region has one)
-- runs the rest of the region as skip mode would, with the values the call it stopped in handed back; it returns
-- false when the region is left by a return, which skip mode continues in the caller. Skip mode can stop again inside
-- skip, at a call that enters a function in skip mode, and skip then runs again from that call; when the script is
-- resumed normally there, skip hands back the rest of the region, which runs as the region's body. Reaching the skip
-- end in skip mode ends it: the script suspends here and carries on after the region. The region's return values come
-- back packed.
function vm.section(body: () -> ...any, skip: (({ any }) -> boolean | Continue)?): any?
    local run: () -> ...any = body
    while true do
        local results = table.pack(pcall(run))
        if results[1] then
            -- Reaching the skip end with the skip flag set (skip mode was requested at the previous skip end) suspends too.
            if vmhost.skip_end() then
                coroutine.yield()
            end
            return results[2]
        end
        local stop = stop_of(results[2])
        -- A region without a skip function leaves nothing to execute on the way to its skip end.
        local handled: any = true
        while skip ~= nil do
            local skipping = table.pack(pcall(skip, stop.values or {}))
            if skipping[1] then
                handled = skipping[2]
                break
            end
            stop = stop_of(skipping[2])
        end
        if getmetatable(handled) == CONTINUE then
            run = (handled :: Continue).body
        elseif handled then
            if vmhost.skip_end() then
                coroutine.yield()
            end
            return nil
        else
            error(stop, 0)
        end
    end
end

-- Runs the body of a function that skip mode must not pass through silently. When skip mode stops it at a wait, tail
-- runs the rest of the function as skip mode would and returns what the function returns (its result, then its
-- references), and the stop goes on to the caller carrying those values. As in a section, the tail runs again when skip
-- mode stops inside it, and the rest of the function runs as its body when the script is resumed normally there.
function vm.guard(body: () -> ...any, tail: ({ any }) -> ...any): ...any
    local run: () -> ...any = body
    while true do
        local results = table.pack(pcall(run))
        if results[1] then
            return table.unpack(results, 2, results.n)
        end
        local stop = stop_of(results[2])
        local values: any
        repeat
            values = table.pack(pcall(tail, stop.values or {}))
            if not values[1] then
                stop = stop_of(values[2])
            end
        until values[1]
        if getmetatable(values[2]) == CONTINUE then
            run = (values[2] :: Continue).body
        else
            error(skipped(stop.site, table.pack(table.unpack(values, 2, values.n))), 0)
        end
    end
end

-- Wraps an integral value to a signed 32-bit integer.
function vm.i32(x: number): number
    local v = x % 4294967296
    if v >= 2147483648 then
        v -= 4294967296
    end
    return v
end

-- Wraps the result of an operation whose operands may be integers or floats: an integral value outside the signed
-- 32-bit range wraps as an integer does on the PS2, and any other value is returned unchanged. An integral float
-- outside that range, which retail keeps, wraps too.
function vm.wrap(x: number): number
    if x ~= x or x == math.huge or x == -math.huge or x ~= math.floor(x) then
        return x
    end
    if x >= -2147483648 and x < 2147483648 then
        return x
    end
    return vm.i32(x)
end

-- Converts a float to an integer by truncating toward zero, wrapped to 32 bits.
function vm.ftoi(x: number): number
    return vm.i32(truncate(x))
end

-- Divides two integers with C semantics, truncating toward zero and wrapping to 32 bits.
function vm.idiv(a: number, b: number): number
    if b == 0 then
        error("division by zero", 2)
    end
    return vm.i32(truncate(a / b))
end

-- Divides two numbers when either is a float. A divisor whose bits are zero (integer 0 or +0.0) raises an error, where
-- retail exits; -0.0 divides.
function vm.fdiv(a: number, b: number): number
    if b == 0 and 1 / b > 0 then
        error("division by zero", 2)
    end
    return a / b
end

-- Computes the remainder of two integers with C semantics, where the sign follows the dividend.
function vm.imod(a: number, b: number): number
    if b == 0 then
        error("modulo by zero", 2)
    end
    return vm.i32(math.fmod(a, b))
end

-- Maps a slot index computed at run time to its place in a frame table of n slots, which starts at 1.
-- An index outside the frame would reach the operand stack or the caller's frame on the PS2, so it raises an error.
function vm.index(i: number, n: number): number
    if i < 0 or i >= n or i ~= math.floor(i) then
        error(`slot index {i} is outside the frame of {n} slots`, 2)
    end
    return i + 1
end

-- Rounds a number to the nearest float32 value, as the PS2 rounds every float operation. A vector's components are
-- float32s, which makes this a native conversion.
function vm.f32(x: number): number
    return vector.create(x, 0, 0).x
end

-- The single-precision sine and cosine of the C library the game links, which the interpreter's SIN and COS call; the
-- host provides them as cmath.sinf and cmath.cosf. Rounding a double-precision sine differs in the last bit.
function vm.sin(x: number): number
    return cmath.sinf(x)
end

function vm.cos(x: number): number
    return cmath.cosf(x)
end

-- The float whose 32 bits are the integer's: what a float load of a variable reads after a handler wrote an integer
-- into it, or a handler reading a float through a reference reads of an integer variable. nil stays nil.
function vm.bits_float(x: number?): number?
    if x == nil then
        return nil
    end
    local value: number = string.unpack("<f", string.pack("<i4", vm.i32(x))) :: any
    return value
end

-- The integer whose 32 bits are the float's: what an integer load of an integer-tagged variable reads after a handler
-- wrote a float into it. nil stays nil.
function vm.float_bits(x: number?): number?
    if x == nil then
        return nil
    end
    local value: number = string.unpack("<i4", string.pack("<f", x)) :: any
    return value
end

-- The text retail prints for a float: a print of a float passes it through here, since the runtime prints a number
-- holding an integral value as an integer.
function vm.float(x: number): string
    return string.format("%f", x)
end

-- A skip end outside a section. It counts, and when skip mode was running the script to it, the script suspends here.
function vm.skip_end(): ()
    if vmhost.skip_end() then
        coroutine.yield()
    end
end

return vm
