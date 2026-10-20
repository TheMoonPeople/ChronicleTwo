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

-- Suspends the script until the engine resumes it on the next frame.
function vm.wait(): ()
    coroutine.yield()
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

-- Runs a region of an event script that skip mode can jump over; skip mode arrives with event scripts, so body always runs for now.
function vm.section(body: () -> ()): ()
    body()
end

-- Marks the end of a skippable region of an event script.
function vm.skip_end(): ()
end

return vm
