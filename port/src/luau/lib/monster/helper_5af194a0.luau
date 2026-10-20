--!strict
-- Shared monster helper used by 71 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_5af194a0(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	do
		local _, out2, _ = monster.GetRot()
		var8 = out2 or var8
	end
	var10 = monster.GetTargetDist() or var10
	var11 = monster.GetTargetAngle() or var11
	var12 = monster.GetTargetSpeed() or var12
	arg1 = helper_787df986(arg1)
	if
		var10 < arg0 and var8 < vm.f32(var11 + arg1) and var8 > vm.f32(var11 - arg1)
		or var10 < arg2 and var12 > arg3
	then
		return 1
	end
	return 0
end

return helper_5af194a0
