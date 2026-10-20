--!strict
-- dungeon/monster/b13a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07b5f915 = require("@lib/monster/helper_07b5f915")
local helper_13320956 = require("@lib/monster/helper_13320956")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_84a6a4c4 = require("@lib/monster/helper_84a6a4c4")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_b3b48995 = require("@lib/monster/helper_b3b48995")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b937768e = require("@lib/monster/helper_b937768e")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_cea0e31f = require("@lib/monster/helper_cea0e31f")
local helper_d742309a = require("@lib/monster/helper_d742309a")
local helper_dd45b7cf = require("@lib/monster/helper_dd45b7cf")
local helper_de1504df = require("@lib/monster/helper_de1504df")

--- Helper function.
local function helper_2a70()
	for var0 = 0, 3 do
		monster.VPush(var0 + 96, -9999)
	end
end

--- Helper function.
local function helper_ab58()
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
local function helper_2cc0()
	local value: s32 = 0
	value = monster.VPop(96) or value
	if value ~= -9999 then
		monster.EsmFinish(value)
		monster.VPush(96, -9999)
	end
	value = monster.VPop(97) or value
	if value ~= -9999 then
		monster.EsmSetValue(value, 1, 2)
		monster.EsmFinish(value)
		monster.VPush(97, -9999)
	end
end

--- Helper function.
local function helper_54c4()
	local value: s32 = 0
	local argc: s32 = 0
	value = monster.VPop(3) or value
	if value == 1 then
		argc = monster.GetMonsterNum() or argc
		if argc > 2 then
			argc = vm.i32(argc * 2)
		end
	else
		argc = monster.GetMonsterNum() or argc
	end
end

--- Helper function.
local function helper_5790(arg0: s32, arg1: s32)
	local att_type: s32 = 0
	att_type = monster.GetAttType() or att_type
	monster.VPush(5, att_type)
	monster.VPush(6, vm.i32(arg1 - arg0))
end

--- Helper function.
local function helper_5a64()
	local life: s32 = 0
	local value: s32 = 0
	value = monster.VPop(4) or value
	life = monster.GetActiveMonsLifei(-1) or life
	if life <= 0 then
		monster.VPush(4, life)
		return 1
	end
	if vm.i32(life - value) < 0 then
		monster.VPush(4, life)
		helper_5790(life, value)
		return 2
	end
	monster.VPush(4, life)
	return 0
end

--- Helper function.
local function helper_29b4()
	local var0: s32 = 0
	var0 = helper_13320956(var0)
	helper_84a6a4c4(vm.i32(var0 + 1))
end

--- Helper function.
local function helper_452c()
	local value: s32 = 0
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	value = monster.VPop(3) or value
	if value == 2 and helper_b937768e(1) > 60 then
		argc = monster.GetMonsterNum() or argc
		if argc < 13 then
			do
				local out1, out2, out3 = monster.GetPos_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local _, out2, _ = monster.GetRot()
				var8 = out2 or var8
			end
			monster.CreateMonster(630, pos_x, pos_y - 10.0, pos_z, var8)
			helper_cea0e31f(2)
			helper_442b9962()
			helper_29b4()
		end
		helper_cea0e31f(1)
	end
end

--- Helper function.
local function helper_51f0()
	local value: s32 = 0
	value = monster.VPop(3) or value
	monster.GetMonsterNum()
	monster.VPush(13, 1)
	if value == 2 then
		print("kita-------------------\n")
		monster.SetMuteki(0)
		monster.VPush(3, 1)
	else
		monster.SetMuteki(9999)
		monster.VPush(3, 2)
	end
end

--- Helper function.
local function helper_a078()
	local value: s32 = 0
	local var1: s32 = 0
	var1 = helper_13320956(var1)
	value = monster.VPop(3) or value
	if value == 2 then
		helper_cea0e31f(0)
	end
	if value == 2 and var1 == 6 then
		print("change color blue-----------------\n")
		helper_51f0()
		helper_84a6a4c4(0)
		helper_cea0e31f(0)
	end
	if value == 1 and helper_b937768e(0) > 300 then
		print("change color red-----------------\n")
		helper_51f0()
		helper_84a6a4c4(0)
	end
end

--- Helper function.
local function helper_4900()
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	value_2 = monster.VPop(13) or value_2
	if value_2 ~= 0 then
		monster.VPush(14, 0)
		monster.VPush(13, 0)
	else
		monster.SetModelLightSwitch(1)
	end
	value = monster.VPop(14) or value
	if value < 15 then
		monster.SetModelLightSwitch(0)
		value_3 = monster.VPop(3) or value_3
		if value_3 == 1 then
			if vm.imod(value, 2) == 0 then
				monster.SetModelLightColor(128.0, 128.0, 148.0, 128.0)
			end
			if vm.imod(value, 4) == 0 then
				monster.SetModelLightColor(160.0, 160.0, 180.0, 160.0)
			end
			if vm.imod(value, 6) == 0 then
				monster.SetModelLightColor(140.0, 140.0, 160.0, 140.0)
			end
		else
			if vm.imod(value, 2) == 0 then
				monster.SetModelLightColor(148.0, 128.0, 128.0, 128.0)
			end
			if vm.imod(value, 4) == 0 then
				monster.SetModelLightColor(180.0, 160.0, 160.0, 160.0)
			end
			if vm.imod(value, 6) == 0 then
				monster.SetModelLightColor(160.0, 140.0, 140.0, 140.0)
			end
		end
		if value == 14 then
			if value_3 == 1 then
				monster.SetMuteki(0)
				monster.TransReservImg(1)
			else
				monster.SetMuteki(9999)
				monster.TransReservImg(0)
			end
		end
		monster.VPush(14, value + 1)
	end
end

--- Helper function.
local function helper_5de0(arg0: f32)
	local value: f32 = 0
	value = 0.0
	value = monster.VPopFloat(15) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_9288(arg0: f32, arg1: f32, arg2: any, arg3: f32)
	local var6: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(arg0 - pos_x)
	pos_y = vm.f32(arg1 - pos_y)
	do
		local _, _, out3 = monster.GetRefRot_6(pos_x, pos_y, pos_z)
		var6 = out3 or var6
	end
	var10 = var6
	if var10 > vm.f32(3.1415927) then
		var10 = vm.f32(var10 - vm.f32(6.2831855))
	end
	if var10 <= vm.f32(-3.1415927) then
		var10 = vm.f32(var10 + vm.f32(6.2831855))
	end
	arg3 = var10
	return arg3
end

--- Helper function.
local function helper_9698()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local value: f32 = 0
	local var18: f32 = 0
	value = 0.0
	value = monster.VPopFloat(19) or value
	value = vm.f32(value + vm.f32(0.08726647))
	var18 = vm.f32(200.0 + vm.f32(vm.sin(value) * 15.0))
	monster.VPushFloat(19, value)
	var6 = helper_5de0(var6)
	var0 = 0.0
	var1 = 0.0
	var2 = 0.0
	var3 = vm.f32(var0 + vm.f32(vm.sin(var6) * 400.0))
	var4 = vm.f32(var1 + var18)
	var5 = vm.f32(var2 + vm.f32(vm.cos(var6) * 400.0))
	var10 = helper_9288(var3, var4, var5, var10)
	var7 = monster.GetRefAngle(var3, var4, var5) or var7
	monster.SetPos(var3, var4, var5)
	monster.SetRot(0.0, var7, 0.0)
	helper_dd45b7cf(vm.f32(var6 + vm.f32(0.017453292)))
end

--- Helper function.
local function helper_1bf4(arg0: f32, arg1: f32, arg2: f32)
	local var4: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	arg0 = vm.f32(arg0 * vm.f32(0.017453292))
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = vm.f32(arg1 * vm.f32(0.017453292))
	var8 = arg2
	if arg1 < 3.0 then
		var9 = vm.f32(0.05235988)
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
			vm.wait()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_22bc(arg0: f32, arg1: f32)
	arg0 = vm.f32(arg0 * vm.f32(0.017453292))
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = vm.f32(arg1 * vm.f32(0.017453292))
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	monster.SetNextRot(arg0, arg1)
	local _ = helper_1bf4(
		vm.f32(arg0 * vm.f32(57.295776)),
		vm.f32(arg1 * vm.f32(57.295776)),
		vm.f32(vm.fdiv(360.0, vm.f32(arg1 * vm.f32(57.295776))))
	)
	helper_442b9962()
end

--- Helper function.
local function helper_5ef0(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	print("kita---------------------------\n")
	do
		local out1, out2, out3 = monster.GetPos_3()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.SubVector(var12, var13, var14, var6, var7, var8)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.NormalVector(var12, var13, var14)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.ScaleVector(var12, var13, var14, arg3)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	print("x=", arg0, "------------------\n")
	print("y=", arg1, "------------------\n")
	print("z=", arg2, "------------------\n")
	print("pos[0]=", var6, "------------------\n")
	print("pos[1]=", var7, "------------------\n")
	print("pos[2]=", var8, "------------------\n")
	print("speed=", arg3, "---------------------\n")
	print("velo[0]=", var12, "------------------\n")
	print("velo[1]=", var13, "------------------\n")
	print("velo[2]=", var14, "------------------\n")
	var16 = 0
	while var16 < arg5 do
		do
			local out1, out2, out3 = monster.AddVector(var6, var7, var8, var12, var13, var14)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local _, out2, _ = monster.GetRefRot_6(var6, var7, var8)
			var10 = out2 or var10
		end
		var15 = monster.GetDistVector2(var6, var7, var8, arg0, arg1, arg2) or var15
		if var15 < arg4 then
			break
		else
			monster.SetPos(var6, var7, var8)
			monster.SetRot(0.0, var10, 0.0)
			vm.wait()
			var16 = var16 + 1
		end
	end
end

--- Helper function.
local function helper_2c04(arg0: s32, arg1: s32)
	monster.VPush(vm.i32(arg0 + 96), arg1)
end

--- Helper function.
local function helper_3010()
	local chara_type: s32 = 0
	local slot: s32 = 0
	local attack: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var25: f32 = 0
	helper_2cc0()
	monster.SetMos("飛行ループ", -1, 0)
	var10 = monster.GetTargetAngle() or var10
	helper_22bc(vm.f32(var10 * vm.f32(57.295776)), vm.f32(1.9999999))
	attack = monster.GetBaseAttack_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.8)))
	chara_type = monster.GetUserid() or chara_type
	do
		local out1, _, _ = monster.GetScale()
		var7 = out1 or var7
	end
	var23 = 0.0
	var25 = 0.0
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var11 = monster.GetRndf(6.2831855) or var11
	var14 = vm.f32(var23 + vm.f32(vm.sin(var11) * 170.0))
	var15 = 5.0
	var16 = vm.f32(var25 + vm.f32(vm.cos(var11) * 170.0))
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	do
		local out1, out2, out3 = monster.CopyVector(var17, var18, var19)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.SubVector(var20, var21, var22, var14, var15, var16)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.NormalVector(var20, var21, var22)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	var12 = 396.0
	var13 = vm.f32(var12 / 60.0)
	do
		local out1, out2, out3 = monster.ScaleVector(var20, var21, var22, var13)
		var20 = out1 or var20
		var21 = out2 or var21
		var22 = out3 or var22
	end
	do
		local out1, out2, out3 = monster.CopyVector(var14, var15, var16)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var10 = monster.GetRefAngle(var14, var15, var16) or var10
	chara_type = monster.GetUserid() or chara_type
	monster.MonsSePlay(chara_type, 3)
	slot = monster.EsmCreate_2("魔人ビームＦ２") or slot
	helper_2c04(0, slot)
	monster.EsmSetUserId(slot, chara_type)
	monster.EsmSetValueFloat(slot, 0, var7)
	monster.EsmSetVect1(slot, var14, var15, var16)
	slot = monster.EsmCreate_2("魔人ビームＬ２") or slot
	helper_2c04(1, slot)
	monster.EsmSetUserId(slot, chara_type)
	monster.EsmSetValue(slot, 0, attack)
	monster.EsmSetValueFloat(slot, 2, var7)
	monster.EsmSetValue(slot, 1, 1)
	for var2 = 0, 89 do
		do
			local out1, out2, out3 = monster.AddVector(var4, var5, var6, var20, var21, var22)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		var10 = monster.GetRefAngle(var4, var5, var6) or var10
		monster.EsmSetVect1(slot, var4, var5, var6)
		monster.SetRot(0.0, var10, 0.0)
		vm.wait()
	end
	monster.EsmSetValue(slot, 1, 2)
	helper_c3e8ae39(90)
	helper_c3e8ae39(60)
	monster.SetMos("飛行ループ", -1, 0)
end

--- Helper function.
local function helper_9cdc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	var0 = 0.0
	var1 = 0.0
	var2 = 0.0
	monster.SetMos("飛行ループ", -1, 0)
	var3 = monster.GetRefAngle(var0, var1, var2) or var3
	helper_22bc(vm.f32(var3 * vm.f32(57.295776)), vm.f32(1.9999999))
	helper_5ef0(var0, 300.0, var2, 12.0, 50.0, 300)
	helper_3010()
	monster.SetMos("泳ぐ", -1, 0)
end

--- Helper function.
local function helper_7c90(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: any, arg7: s32)
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var28 = out1 or var28
		var29 = out2 or var29
		var30 = out3 or var30
	end
	do
		local out1, out2, out3 = monster.SubVector(var28, var29, var30, var8, var9, var10)
		var28 = out1 or var28
		var29 = out2 or var29
		var30 = out3 or var30
	end
	do
		local out1, out2, out3 = monster.NormalVector(var28, var29, var30)
		var28 = out1 or var28
		var29 = out2 or var29
		var30 = out3 or var30
	end
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = monster.SubVector(var11, var12, var13, var8, var9, var10)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = monster.NormalVector(var11, var12, var13)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	x = vm.f32(vm.f32(var11 * vm.cos(arg5)) + vm.f32(var13 * vm.sin(arg5)))
	y = var12
	z = vm.f32(vm.f32(var11 * -vm.sin(arg5)) + vm.f32(var13 * vm.cos(arg5)))
	do
		local out1, out2, out3 = monster.NormalVector(x, y, z)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	var27 = 0
	while var27 < arg7 do
		do
			local out1, out2, out3 = monster.CopyVector(var28, var29, var30)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var17, var18, var19, arg3)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = monster.AddVector(var8, var9, var10, var17, var18, var19)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local _, out2, _ = monster.GetRefRot_6(var8, var9, var10)
			var21 = out2 or var21
		end
		if var9 < 60.0 then
			var9 = 60.0
		end
		var26 = monster.GetDistVector2(var8, var9, var10, arg0, arg1, arg2) or var26
		if var26 < arg4 then
			break
		else
			monster.SetPos(var8, var9, var10)
			monster.SetRot(0.0, var21, 0.0)
			vm.wait()
			var27 = var27 + 1
		end
	end
end

--- Helper function.
local function helper_8940()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	var7 = 0.0
	var8 = 0.0
	var9 = 0.0
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.SubVector(var10, var11, var12, var7, var8, var9)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.NormalVector(var10, var11, var12)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	var6 = monster.Atan2f(var10, var12) or var6
	var6 = vm.f32(var6 + vm.f32(3.1415927))
	if var6 > vm.f32(3.1415927) then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if var6 <= vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	var6 = helper_5de0(var6)
	var6 = vm.f32(var6 + vm.f32(3.1415927))
	var0 = vm.f32(var0 + vm.f32(vm.f32(vm.sin(var6) * 220.0) * 2.0))
	var1 = 150.0
	var2 = vm.f32(var2 + vm.f32(vm.f32(vm.cos(var6) * 220.0) * 2.0))
	monster.SetMos("飛行ループ", -1, 0)
	var6 = monster.GetRefAngle(var0, var1, var2) or var6
	helper_22bc(vm.f32(var6 * vm.f32(57.295776)), vm.f32(1.9999999))
	helper_7c90(var0, var1, var2, 12.0, 100.0, vm.f32(3.1415927), vm.f32(0.2), 500)
end

--- Helper function.
local function helper_69ac(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.SubVector(var10, var11, var12, var4, var5, var6)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.NormalVector(var10, var11, var12)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	var14 = monster.GetDistVector2(arg0, arg1, arg2, var4, var5, var6) or var14
	var13 = vm.f32(vm.fdiv(var14, arg3))
	do
		local out1, out2, out3 = monster.ScaleVector(var10, var11, var12, var13)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	for var15 = 0, arg3 - 1 do
		do
			local out1, out2, out3 = monster.AddVector(var4, var5, var6, var10, var11, var12)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local _, out2, _ = monster.GetRefRot_6(var4, var5, var6)
			var8 = out2 or var8
		end
		monster.SetPos(var4, var5, var6)
		monster.SetRot(0.0, var8, 0.0)
		vm.wait()
	end
end

--- Helper function.
local function helper_7104()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local value: f32 = 0
	local var18: f32 = 0
	value = 0.0
	value = monster.VPopFloat(19) or value
	value = vm.f32(value + vm.f32(0.08726647))
	var18 = vm.f32(200.0 + vm.f32(vm.sin(value) * 30.0))
	monster.VPushFloat(19, value)
	var6 = helper_5de0(var6)
	var6 = monster.GetRndf(0.63661975) or var6
	var0 = 0.0
	var1 = 0.0
	var2 = 0.0
	var3 = vm.f32(var0 + vm.f32(vm.sin(var6) * 400.0))
	var4 = vm.f32(var1 + var18)
	var5 = vm.f32(var2 + vm.f32(vm.cos(var6) * 400.0))
	var7 = monster.GetRefAngle(var3, var4, var5) or var7
	helper_22bc(vm.f32(var7 * vm.f32(57.295776)), vm.f32(1.9999999))
	helper_69ac(var3, var4, var5, 80)
	helper_dd45b7cf(var6)
	monster.SetMos("泳ぐ", -1, 0)
end

--- Helper function.
local function helper_a3b8()
	local var2: s32 = 0
	local value: s32 = 0
	local no_damage_cnt: s32 = 0
	helper_54c4()
	var2 = helper_5a64()
	if var2 == 1 then
		monster.VPush(64, 1)
	end
	no_damage_cnt = monster.GetNoDamageCnt() or no_damage_cnt
	value = monster.VPop(14) or value
	monster.VPop(12)
	if value > 14 then
		helper_452c()
	end
	helper_a078()
	monster.VPush(12, no_damage_cnt)
	helper_4900()
	if helper_b937768e(2) < 150 then
		monster.SetAttrib(16, 1)
	else
		monster.SetAttrib(16, 0)
	end
	helper_9698()
	if helper_b937768e(2) > 300 and value > 14 then
		helper_9cdc()
		helper_8940()
		helper_7104()
		helper_cea0e31f(2)
	end
end

--- Helper function.
local function helper_a870()
	helper_a3b8()
	vm.wait()
end

--- Helper function.
local function helper_17e7c(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: any)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	local var24: s32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	var19 = helper_57b569a8(var19)
	arg1 = vm.f32(var19 + arg5)
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.SubVector(var13, var14, var15, var7, var8, var9)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.NormalVector(var13, var14, var15)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.ScaleVector(var13, var14, var15, arg3)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	monster.CopyVector(arg0, arg1, arg2)
	var11 = monster.GetRefAngle(var7 + var13, var8 + var14, var9 + var15) or var11
	var23 = 0
	while var23 < arg6 do
		do
			local out1, out2, out3 = monster.AddVector(var7, var8, var9, var13, var14, var15)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var22 = monster.GetHigh2(var7, var8, var9) or var22
		if var22 >= 200.0 or var22 <= 0.0 then
			var8 = vm.f32(var8 - var14)
			var14 = 0.0
		end
		var20 = monster.GetDistVector2(var7, var8, var9, arg0, arg1, arg2) or var20
		if var20 < vm.f32(arg3 + arg4) then
			return
		end
		var24 = helper_de1504df(var7, var8, var9, arg3, var11)
		if var24 ~= 0 then
			return
		end
		monster.SetPos(var7, var8, var9)
		monster.CopyVector(var7, var8, var9)
		helper_a870()
		var23 = vm.i32(var23 + 1)
	end
end

--- Helper function.
local function helper_a8f0(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_a870()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_16388()
	while true do
		helper_a870()
	end
end

--- Helper function.
local function helper_16438()
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_a8f0(10)
	monster.ResetMotion()
end

--- Helper function.
local function helper_aa30()
	local var0: s32 = 0
	while true do
		helper_a870()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local life: s32 = 0
	local get_not_used_texb: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local no_damage_cnt: s32 = 0
	monster.VPush(2, 0)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.SetPos(pos_x, pos_y + 10.0, pos_z)
	monster.ResetTimer()
	monster.SetAttrib(512, 1)
	monster.SetPriorityLimmit(6)
	helper_cea0e31f(0)
	helper_cea0e31f(1)
	helper_cea0e31f(2)
	helper_cea0e31f(2)
	life = monster.GetActiveMonsLifei(-1) or life
	monster.VPush(4, life)
	monster.VPush(64, 0)
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var5 = monster.LoadEffectScript("ねばねばＦ", get_not_used_texb) or var5
		var6 = monster.LoadEffectScript("ねばねばＬ", get_not_used_texb) or var6
		var7 = monster.LoadEffectScript("ねばねばＨ", get_not_used_texb) or var7
		if (if (if var5 ~= 0 then 1 else var6) ~= 0 then 1 else var7) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var5 = monster.LoadEffectScript("魔人ビームＦ２", get_not_used_texb) or var5
		var6 = monster.LoadEffectScript("魔人ビームＨ２", get_not_used_texb) or var6
		var7 = monster.LoadEffectScript("魔人ビームＬ２", get_not_used_texb) or var7
		if (if (if var5 ~= 0 then 1 else var6) ~= 0 then 1 else var7) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	helper_84a6a4c4(0)
	monster.SetScoop(249)
	monster.SetAttrib(128, 1)
	no_damage_cnt = monster.GetNoDamageCnt() or no_damage_cnt
	monster.VPush(12, no_damage_cnt)
	monster.VPush(13, 0)
	monster.VPush(14, 999999)
	monster.VPushFloat(15, 0.0)
	helper_2a70()
	monster.VPushFloat(19, 0.0)
	helper_b3b48995()
	helper_ac26cdde(250.0)
	helper_07b5f915(42.0)
	helper_ab58()
	monster.SetClipDist(999999.9)
	monster.LoadReservImg(0, "textures/dungeon/monster/b13a01.json")
	monster.LoadReservImg(1, "textures/dungeon/monster/b13a02.json")
	monster.SetCameraMode(0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetAttrib(16, 1)
	helper_2cc0()
	value = monster.VPop(2) or value
	if value == 0 then
		monster.SetMuteki(9999)
		monster.TransReservImg(0)
		monster.VPush(3, 2)
		monster.SetScale(8.0, 8.0, 8.0)
		monster.SetMos("飛行ループ入り", -1, 6)
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		helper_17e7c(pos_x, pos_y, pos_z, 2.0, 21.0, 200.0, 33)
		monster.SetMos("泳ぐ", -1, 0)
		monster.VPush(2, 1)
	end
	while true do
		monster.SetMos("泳ぐ", -1, 0)
		helper_a870()
		helper_a8f0(60)
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_2cc0()
	monster.ResetMove()
	monster.ResetMotion()
	monster.SetActStatus(0)
	monster.SetMos("空中ダメージ", -1, 6)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.SetMos("泳ぐ", -1, 0)
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
function script.on_death()
	monster.VPush(64, 1)
	monster.ResetMove()
	helper_442b9962()
	monster.SetDeadStart()
	monster.SetAttrib(4, 0)
	monster.SetAttrib(256, 0)
	monster.SetAttrib(8, 0)
	monster.SetMos("ダメージ", -1, 0)
	helper_2cc0()
	monster.SetAttrib(2, 1)
	monster.SetAttrib(64, 1)
	monster.ResetCameraCtrlParam()
	monster.SetMos("死亡", -1, 6)
	helper_56d63eae()
	monster.SetMos("死亡とめ", -1, 0)
	monster.RunEventScript(510)
	helper_c3e8ae39(30)
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_d742309a()
	monster.SetMos("じたばた", -1, 4)
	while true do
		helper_a870()
	end
	helper_16388()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_16438()
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_a8f0(10)
	monster.ResetMotion()
	monster.SetMos("起き上がり", -1, 6)
	helper_aa30()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
