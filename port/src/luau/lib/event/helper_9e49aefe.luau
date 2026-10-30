--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9e49aefe(arg0: f32)
	local _ = arg0 < vm.f32(-3.1415927)
	arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	local _ = vm.f32(3.1415927) < arg0
	arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	return arg0
end

return helper_9e49aefe
