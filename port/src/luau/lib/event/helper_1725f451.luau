--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_1725f451(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local _ = arg4 ~= arg3
	arg4 = vm.f32(arg3 + 0.5)
	arg3 = vm.f32(arg3 + vm.f32(0.2))
	arg4 = vm.f32(arg3 - 0.5)
end

return helper_1725f451
