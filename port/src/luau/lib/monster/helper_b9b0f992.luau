--!strict
-- Shared monster helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")

--- Helper function.
local function helper_b9b0f992(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	helper_890ee63a(arg1)
	arg1 = helper_787df986(arg1)
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	var18 = 0
	while var18 < arg3 do
		var13 = monster.GetTargetDist() or var13
		if var13 < arg2 then
			helper_442b9962()
			monster.ResetMove()
			return
		end
		var14 = monster.GetTargetAngle() or var14
		monster.SetNextRot(var14, arg1)
		monster.GetTargetPos()
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.GetRot()
		monster.GetTargetPos()
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.SubVector(var15, var16, var17, pos_x, pos_y, pos_z)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.NormalVector(var15, var16, var17)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var15, var16, var17, arg0 + arg2)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.AddVector(var15, var16, var17, pos_x, pos_y, pos_z)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		monster.SetNextPos(var15, pos_y - 20.0, var17, arg0, arg0)
		helper_0ba23e4e()
		var18 = var18 + 1
		monster.ResetMove()
		helper_442b9962()
	end
end

return helper_b9b0f992
