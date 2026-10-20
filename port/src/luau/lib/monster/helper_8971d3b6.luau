--!strict
-- Shared monster helper used by 119 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8971d3b6(arg0: f32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	var3 = vm.f32(arg0 - arg1)
	if var3 == 0.0 then
		return 0
	end
	if var3 > vm.f32(3.1415927) then
		var3 = vm.f32(var3 - vm.f32(6.2831855))
	end
	if var3 < vm.f32(-3.1415927) then
		var3 = vm.f32(var3 + vm.f32(6.2831855))
	end
	if var3 > arg2 then
		return 1
	end
	if var3 < -arg2 then
		return -1
	end
	return 0
end

return helper_8971d3b6
