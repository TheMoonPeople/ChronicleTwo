--!strict
-- Shared event helper used by 961 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- The value with its sign flipped.
local function negate(value: f32)
	return vm.f32(-1.0 * value)
end

return negate
