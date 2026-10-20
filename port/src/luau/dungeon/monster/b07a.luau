--!strict
-- dungeon/monster/b07a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")

--- Helper function.
local function helper_18c8(arg0: s32)
	local timer: s32 = 0
	timer = monster.GetTimer() or timer
	monster.VPush(vm.i32(14 + arg0), timer)
end

--- Helper function.
local function helper_24d4()
	local boss: s32 = 0
	boss = monster.GetBossFlag() or boss
	if boss == 0 then
		monster.GetPos_3()
		monster.SetClipDist(35.0)
	else
		monster.SetClipDist(999999.0)
	end
end

--- Helper function.
local function helper_1b18()
	local life: s32 = 0
	local value: s32 = 0
	local var2: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	life = 0
	value = 0
	value_2 = 0
	value_3 = 0
	monster.GetUserid()
	life = monster.GetActiveMonsLifei(-1) or life
	value = monster.VPop(12) or value
	var2 = vm.i32(value - life)
	monster.VPush(12, life)
	value_2 = monster.VPop(11) or value_2
	monster.VPush(11, vm.i32(value_2 + var2))
	value_3 = monster.VPop(13) or value_3
	monster.VPush(13, vm.i32(value_3 + var2))
end

--- Helper function.
local function helper_19c0(arg0: s32)
	local timer: s32 = 0
	local value: s32 = 0
	timer = monster.GetTimer() or timer
	value = monster.VPop(vm.i32(14 + arg0)) or value
	timer = vm.i32(timer - value)
	return timer
end

--- Helper function.
local function helper_1eec()
	local value: s32 = 0
	value = monster.VPop(20) or value
	if value == 0 and helper_19c0(0) > 900 then
		monster.RunEventScript(550)
		monster.VPush(20, 1)
	end
end

--- Helper function.
local function helper_20a4()
	helper_1b18()
	helper_1eec()
end

--- Helper function.
local function helper_21ec()
	helper_20a4()
	vm.wait()
end

--- Helper function.
local function helper_3390(arg0: f32, arg1: f32, arg2: f32)
	local var4: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	var8 = arg2
	if arg1 < 3.0 then
		var9 = helper_787df986(3.0)
	else
		var9 = arg1
	end
	var7 = 0.0
	while var7 < var8 do
		do
			local _, out2, _ = monster.GetRot()
			var4 = out2 or var4
		end
		if var4 > vm.f32(arg0 - var9) and var4 < vm.f32(arg0 + var9) then
			helper_442b9962()
			break
		elseif helper_8971d3b6(arg0, var4, arg1) == 0 then
			helper_442b9962()
			break
		elseif var7 >= arg2 then
			helper_442b9962()
			break
		else
			helper_21ec()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_62b8(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.GetTargetAngle() or var5
	local _ = helper_3390(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_7ab0(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: s32 = 0
	helper_62b8(arg1)
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
		helper_21ec()
		var18 = var18 + 1
		monster.ResetMove()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_5240(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	if arg1 == -1.0 then
		arg1 = vm.f32(0.03)
	end
	var3 = 0
	while true do
		helper_21ec()
		var2 = monster.NowMosWait() or var2
		if var2 < vm.f32(arg0 + arg1) and var2 > vm.f32(arg0 - arg1) then
			break
		else
			var4 = monster.CheckMosEnd() or var4
			if var4 ~= 0 then
				break
			else
				var3 = vm.i32(var3 + 1)
			end
		end
	end
end

--- Helper function.
local function helper_23ac()
	local var0: s32 = 0
	while true do
		helper_21ec()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_12064()
	local height: f32 = 0
	local slot: s32 = 0
	local chara_type: s32 = 0
	local attack: s32 = 0
	monster.SetMos("歩き", 0.9, 0)
	helper_62b8(vm.f32(4.2))
	monster.SetMos("攻撃１", -1, 2)
	helper_5240(vm.f32(0.206), -1.0)
	height = monster.GetHigh() or height
	chara_type = monster.GetUserid() or chara_type
	attack = monster.GetBaseAttack_1() or attack
	slot = monster.EsmCreate_2("シグー吐き") or slot
	monster.VPush(14, slot)
	monster.EsmSetUserId(-1, chara_type)
	monster.EsmSetValue(-1, 0, attack)
	monster.EsmSetValueFloat(-1, 1, height)
	monster.EsmSetValue(slot, 3, 0)
	helper_5240(vm.f32(0.927), -1.0)
	monster.EsmSetValue(slot, 3, 1)
	monster.VPush(14, -2)
	helper_23ac()
	monster.SetMos("立ち", -1, 0)
end

--- Helper function.
local function helper_125e4()
	local pos_y: f32 = 0
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	if pos_y >= -5.0 then
		monster.SetMos("歩き", 0.9, 0)
		helper_62b8(vm.f32(4.2))
		monster.SetMos("攻撃２", -1, 2)
		helper_23ac()
		monster.SetMos("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_226c(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_21ec()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_1151c()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	argc = monster.GetRnd(3) or argc
	if argc == 0 then
		var1 = vm.f32(-146.3)
		var2 = vm.f32(190.98)
		var3 = vm.f32(856.53)
	end
	if argc == 1 then
		var1 = vm.f32(358.6)
		var2 = vm.f32(202.17)
		var3 = vm.f32(718.47)
	end
	if argc == 2 then
		var1 = vm.f32(402.76)
		var2 = vm.f32(402.76)
		var3 = vm.f32(729.47)
	end
	monster.CreateMonster(1001, var1, var2, var3)
end

--- Helper function.
local function helper_113a0()
	local value: s32 = 0
	value = monster.VPop(14) or value
	if value ~= -2 then
		monster.EsmFinish(value)
		monster.VPush(14, -2)
	end
end

--- Helper function.
local function helper_1287c(arg0: s32)
	monster.VPush(20, 1)
	helper_113a0()
	monster.GetPos_3()
	monster.SetMos("歩き", 0.9, 0)
	helper_62b8(vm.f32(4.2))
	monster.VPush(0, 32)
	monster.VPush(8, 32)
	monster.SetMos("威嚇入り", -1, 2)
	helper_23ac()
	monster.SetMos("威嚇Ｌ", -1, 0)
	helper_226c(helper_9df6409a(arg0))
	monster.SetMos("威嚇戻り", -1, 2)
	helper_5240(vm.f32(0.408), -1.0)
	monster.VPush(0, 0)
	monster.VPush(8, 0)
	helper_23ac()
	monster.SetMos("立ち", -1, 0)
	return 0
end

--- Helper function.
local function helper_10bdc(arg0: f32, arg1: any, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: s32 = 0
	helper_62b8(vm.f32(4.2))
	var11 = helper_787df986(var11)
	var20 = 0
	while var20 < arg3 do
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local out1, out2, out3 = monster.AddVector(var4, var5, var6, var7, var8, var9)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		monster.GetRefAngle(var4, var5, var6) -- retail: argument 4 is a value where the handler writes an output; the output is discarded
		var10 = monster.GetTargetAngle() or var10
		var12 = vm.f32(-33.22)
		var14 = 763.5
		var18 = monster.GetDistVector2(var12, 0.0, var14, var4, 0.0, var6) or var18
		if var18 > 380.0 then
			helper_442b9962()
			monster.ResetMove()
			return
		end
		var19 = monster.GetTargetDist() or var19
		if var19 < arg2 then
			helper_442b9962()
			monster.ResetMove()
			return
		end
		monster.SetNextPos(var4, var5, var6, arg0, arg0)
		monster.SetRot(0.0, var10, 0.0)
		helper_21ec()
		var20 = var20 + 1
	end
	monster.ResetMove()
end

--- Helper function.
local function helper_56e8(arg0: f32, arg1: f32)
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	monster.SetNextRot(arg0, arg1)
	local _ = helper_3390(helper_28452e16(arg0), helper_28452e16(arg1), vm.f32(vm.fdiv(360.0, helper_28452e16(arg1))))
	helper_442b9962()
end

--- Helper function.
local function helper_4878(arg0: f32, arg1: any)
	local var2: s32 = 0
	local arrived: s32 = 0
	local var4: f32 = 0
	var2 = 0
	while var2 < arg1 do
		arrived = monster.ChkMoveEnd() or arrived
		var4 = monster.GetTargetDist() or var4
		if var4 < arg0 then
			monster.ResetMove()
			return
		end
		if arrived == 0 then
			helper_21ec()
		else
			monster.ResetMove()
			return
		end
		if arrived == 1 then
			monster.ResetMove()
			return
		end
		var2 = vm.i32(var2 + 1)
	end
end

--- Helper function.
local function helper_11908()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local argc: s32 = 0
	monster.VPush(0, 64)
	argc = monster.GetRnd(3) or argc
	if argc == 0 then
		var0 = vm.f32(-236.58)
		var1 = vm.f32(-34.97)
		var2 = vm.f32(336.42)
	end
	if argc == 1 then
		var0 = vm.f32(313.89)
		var1 = vm.f32(-24.87)
		var2 = vm.f32(452.05)
	end
	if argc == 2 then
		var0 = vm.f32(39.48)
		var1 = vm.f32(-23.78)
		var2 = vm.f32(405.92)
	end
	var3 = monster.GetRefAngle(var0, var1 - 100.0, var2) or var3
	monster.SetMos("歩き", -1, 0)
	helper_56e8(helper_28452e16(var3), vm.f32(4.2))
	monster.SetNextPos(var0, var1, var2, 2.4, 3.6000001)
	helper_4878(0.0, helper_9df6409a(600))
	monster.ResetMove()
	monster.VPush(0, 16)
	monster.SetMos("歩き", -1, 0)
	helper_62b8(vm.f32(4.2))
	monster.SetMos("立ち", -1, 0)
end

--- Helper function.
local function helper_12dac()
	local var1: s32 = 0
	local argc: s32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local var7: s32 = 0
	local argc_2: s32 = 0
	value = monster.VPop(3) or value
	value_2 = monster.VPop(11) or value_2
	monster.VPop(13)
	if value_2 > 150 then
		monster.SetMos("歩き", -1, 0)
		helper_62b8(vm.f32(4.2))
		helper_125e4()
		argc_2 = monster.GetMonsterNum() or argc_2
		if argc_2 == 1 then
			helper_1151c()
		end
		var7 = helper_1287c(210)
		if var7 == 0 then
			monster.VPush(11, 0)
		end
	end
	helper_1b18()
	if value == 0 then
		monster.VPush(3, 1)
		monster.SetMos("歩き", -1, 0)
		helper_10bdc(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
		helper_12064()
	end
	helper_1b18()
	if value == 1 then
		monster.VPush(3, 2)
		monster.SetMos("歩き", -1, 0)
		helper_10bdc(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
		helper_125e4()
	end
	helper_1b18()
	if value == 2 then
		monster.VPush(3, 3)
	end
	helper_1b18()
	if value == 3 then
		argc = monster.GetRnd(100) or argc
		if argc < 10 then
			helper_11908()
			monster.SetMos("立ち", -1, 0)
			argc = monster.GetRnd(30) or argc
			helper_226c(helper_9df6409a(vm.i32(30 + argc)))
		else
			monster.SetMos("歩き", -1, 0)
			helper_10bdc(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
			helper_125e4()
		end
		monster.VPush(3, 4)
		argc = monster.GetRnd(100) or argc
		if argc < 30 then
			monster.SetMos("歩き", -1, 0)
			helper_10bdc(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
			helper_12064()
		end
	end
	helper_1b18()
	if value == 4 then
		monster.VPush(3, 0)
		argc = monster.GetRnd(100) or argc
		if argc < 20 then
			monster.SetMos("歩き", -1, 0)
			helper_62b8(vm.f32(4.2))
			helper_12064()
		end
	end
	monster.VPush(2, var1 + 1)
end

--- Helper function.
local function helper_d3fc()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	helper_21ec()
	monster.SetActStatus(1)
end

--- Helper function.
local function helper_e114()
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_226c(10)
	monster.ResetMotion()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local life: s32 = 0
	local argc: s32 = 0
	monster.SetDmg2("吹っ飛び攻撃", 12.0, "攻撃２", 0.216, 0.432, 0)
	monster.SetDmg2("吹っ飛び攻撃", 12.0, "攻撃２", 0.216, 0.432, 1)
	monster.SetDmg2("吹っ飛び攻撃", 10.0, "攻撃１", 0.418, 0.655, 3)
	monster.SetScoop(1016)
	monster.LoadEffectScript("シグー吐き")
	monster.GetUserid()
	life = 0
	monster.VPush(0, 0)
	monster.VPush(1, 0)
	monster.VPush(2, 0)
	monster.VPush(3, 0)
	monster.VPush(4, 0)
	monster.VPush(8, 0)
	monster.VPush(9, 0)
	monster.VPush(14, -2)
	monster.VPush(20, 0)
	monster.ResetTimer()
	helper_18c8(0)
	monster.GetUserid()
	life = monster.GetActiveMonsLifei(-1) or life
	monster.VPush(12, life)
	monster.VPush(11, 0)
	monster.VPush(13, 0)
	monster.SetClipDist(9999.9)
	monster.SetAttrib(128, 1)
	monster.SetCameraMode(0)
	argc = monster.GetMonsterNum() or argc
	if argc == 1 then
		monster.CreateMonster(1001, -50.0, -46.69, 202.57, 0.0, 0.0, 0.0)
	end
	monster.SetCameraMode(4)
	helper_24d4()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local value: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var11: f32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetActStatus(0)
	value = monster.VPop(9) or value
	if value == 0 then
		monster.SetMos("歩き", 0.75, 0)
		helper_7ab0(vm.f32(2.4), vm.f32(4.2), 140.0, 200)
		monster.SetMos("立ち", -1, 0)
		monster.VPush(9, 1)
	end
	var0 = vm.f32(-33.22)
	var1 = vm.f32(3.88)
	var2 = 763.5
	while true do
		helper_21ec()
		do
			local out1, _, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		var3 = monster.GetDistVector2(pos_x, 0.0, pos_z, var0, 0.0, var2) or var3
		print("dist=", var3, "---------------\n")
		if var3 > 380.0 then
			argc_2 = monster.GetRnd(100) or argc_2
			if argc_2 < 15 then
				helper_12064()
			else
				if argc_2 >= 15 and argc_2 < 30 then
					helper_125e4()
				end
				if argc_2 > 30 and argc_2 < 50 then
					monster.SetMos("歩き", 0.9, 0)
					helper_62b8(vm.f32(4.2))
				end
			end
			argc_3 = monster.GetRnd(100) or argc_3
			if argc_3 < 50 then
				monster.SetMos("歩き", 0.75, 0)
				for var12 = 0, 89 do
					var11 = monster.GetRefAngle(var0, var1, var2) or var11
					monster.SetNextPos(var0, var1, var2, 2.4, 2.4)
					monster.SetNextRot(var11, helper_787df986(vm.f32(4.2)))
					helper_21ec()
				end
				monster.ResetMove()
			end
			monster.SetMos("立ち", -1, 0)
			helper_226c(30)
			continue
		end
		helper_12dac()
		argc = monster.GetMonsterNum() or argc
		if argc == 1 then
			helper_1151c()
		end
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	local value: s32 = 0
	helper_5d37e9f4()
	helper_113a0()
	value = monster.VPop(4) or value
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_23ac()
	helper_226c(12)
	monster.SetMos("立ち")
	monster.VPush(4, vm.i32(value + 1))
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d3fc()
	helper_113a0()
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	helper_113a0()
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_113a0()
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	helper_113a0()
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_113a0()
	monster.RunEventScript(510)
	helper_02ce7891()
	monster.SetAttrib(2, 1)
	monster.SetAttrib(32, 1)
	while true do
		vm.wait()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_113a0()
	monster.SetMos("じたばた", -1, 4)
	while true do
		helper_21ec()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_e114()
	helper_113a0()
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_226c(10)
	monster.ResetMotion()
	monster.SetMos("起き上がり", -1, 6)
	helper_23ac()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	local nearest_pos_x: f32 = 0
	local nearest_pos_y: f32 = 0
	local nearest_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	monster.ResetMove()
	helper_442b9962()
	monster.ResetMotion()
	value = monster.VPop(0) or value
	if value == 64 then
		return
	end
	do
		local out1, out2, out3 = monster.GetFramePos("sakana")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3, out4 = monster.GetNearMonsPos()
		nearest_pos_x = out1 or nearest_pos_x
		nearest_pos_y = out2 or nearest_pos_y
		nearest_pos_z = out3 or nearest_pos_z
		var6 = out4 or var6
	end
	value_3 = monster.VPop(5) or value_3
	monster.EsmFinish(value_3)
	var6 = monster.GetDistVector2(pos_x, pos_y, pos_z, nearest_pos_x, nearest_pos_y, nearest_pos_z) or var6
	if var6 < 60.0 then
		value = monster.VPop(0) or value
		value_2 = monster.VPop(1) or value_2
		if value == 32 then
			helper_113a0()
			monster.VPush(8, 128)
			monster.RunEventScript(500)
			helper_21ec()
		else
			monster.SetMos("歩き", 0.9, 0)
			helper_62b8(vm.f32(4.2))
			helper_125e4()
			monster.SetMos("歩き", 0.9, 0)
			helper_62b8(vm.f32(4.2))
			helper_125e4()
			value_2 = vm.i32(value_2 + 2)
			monster.VPush(1, value_2)
		end
		print("hit head-------------\n")
	elseif var6 < 90.0 then
		print("osii-----\n")
		value_2 = value_2 + 1
		monster.VPush(1, value_2)
	end
end

return script
