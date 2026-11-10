--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_4bd7f01a(arg0: f32)
	if arg0 < vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < arg0 then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	return arg0
end

return helper_4bd7f01a
