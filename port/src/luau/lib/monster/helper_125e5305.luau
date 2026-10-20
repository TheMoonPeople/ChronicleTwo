--!strict
-- Shared monster helper used by 92 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_125e5305(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	var5 = vm.f32(arg0 * vm.f32(0.017453292))
	var6 = monster.GetTargetAngle() or var6
	var6 = vm.f32(var6 - vm.f32(3.1415927))
	var6 = vm.f32(var6 + var5)
	if var6 > vm.f32(3.1415927) then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if var6 <= vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.GetTargetRefPos(var6, arg1)
		arg2 = out1 or arg2
		arg3 = out2 or arg3
		arg4 = out3 or arg4
	end
	return arg2, arg3, arg4
end

return helper_125e5305
