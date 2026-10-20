--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_f2cf0297(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: s32 = 0
	arg1 = helper_787df986(arg1)
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	var12 = 0
	while var12 < arg3 do
		var10 = monster.GetTargetDist() or var10
		if var10 < arg2 then
			helper_442b9962()
			monster.ResetMove()
			return
		end
		var11 = monster.GetTargetAngle() or var11
		monster.SetNextRot(var11, arg1)
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		monster.GetRot()
		monster.SetNextPos(var4, var5 - 20.0, var6, arg0, arg0)
		helper_0ba23e4e()
		var12 = var12 + 1
		monster.ResetMove()
		helper_442b9962()
	end
end

return helper_f2cf0297
