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

-- Runs a region of an event script up to a skip end. When skip mode stops it at a wait, skip (if the region has one)
-- runs the rest of the region as skip mode would, with the values the call it stopped in handed back; it returns
-- false when the region is left by a return, which skip mode continues in the caller. Reaching the skip end in skip
-- mode ends it: the script suspends here and carries on after the region. The region's return values come back packed.
function vm.section(body: () -> ...any, skip: (({ any }) -> boolean)?): any?
    local results = table.pack(pcall(body))
    if results[1] then
        -- Reaching the skip end with the skip flag set (skip mode was requested at the previous skip end) suspends too.
        if vmhost.skip_end() then
            coroutine.yield()
        end
        return results[2]
    end
    local err = results[2]
    if getmetatable(err) ~= SKIPPED then
        error(err, 0)
    end
    local stop = err :: Skipped
    if skip ~= nil and not skip(stop.values or {}) then
        error(err, 0)
    end
    if vmhost.skip_end() then
        coroutine.yield()
    end
    return nil
end

-- Runs the body of a function that skip mode must not pass through silently. When skip mode stops it at a wait, tail
-- runs the rest of the function as skip mode would and returns what the function returns (its result, then its
-- references), and the stop goes on to the caller carrying those values.
function vm.guard(body: () -> ...any, tail: ({ any }) -> ...any): ...any
    local results = table.pack(pcall(body))
    if results[1] then
        return table.unpack(results, 2, results.n)
    end
    local err = results[2]
    if getmetatable(err) ~= SKIPPED then
        error(err, 0)
    end
    local stop = err :: Skipped
    error(skipped(stop.site, table.pack(tail(stop.values or {}))), 0)
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

-- A skip end outside a section. It counts, and when skip mode was running the script to it, the script suspends here.
function vm.skip_end(): ()
    if vmhost.skip_end() then
        coroutine.yield()
    end
end

return vm
