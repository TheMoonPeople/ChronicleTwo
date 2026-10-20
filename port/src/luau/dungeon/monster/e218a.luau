--!strict
-- dungeon/monster/e218a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_206033b2 = require("@lib/monster/helper_206033b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_28faa04b = require("@lib/monster/helper_28faa04b")
local helper_2db2fc96 = require("@lib/monster/helper_2db2fc96")
local helper_2e729f21 = require("@lib/monster/helper_2e729f21")
local helper_2f2adeb4 = require("@lib/monster/helper_2f2adeb4")
local helper_3c99e866 = require("@lib/monster/helper_3c99e866")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_48852a90 = require("@lib/monster/helper_48852a90")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_59867820 = require("@lib/monster/helper_59867820")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_7e925497 = require("@lib/monster/helper_7e925497")
local helper_83dc8947 = require("@lib/monster/helper_83dc8947")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_905c94a1 = require("@lib/monster/helper_905c94a1")
local helper_97663440 = require("@lib/monster/helper_97663440")
local helper_a2d828a7 = require("@lib/monster/helper_a2d828a7")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aada6ba2 = require("@lib/monster/helper_aada6ba2")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_b3b48995 = require("@lib/monster/helper_b3b48995")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_de1504df = require("@lib/monster/helper_de1504df")
local helper_e2fdabb9 = require("@lib/monster/helper_e2fdabb9")

--- Helper function.
local function helper_1c5c()
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
local function helper_f3c4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: any)
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
		if var22 >= 40.0 or var22 <= 0.0 then
			var8 = vm.f32(var8 - var14)
			var14 = 0.0
		end
		var20 = monster.GetDistVector2(var7, var8, var9, arg0, arg1, arg2) or var20
		if var20 < vm.f32(arg3 + arg4) then
			return 1
		end
		var24 = helper_de1504df(var7, var8, var9, arg3, var11)
		if var24 ~= 0 then
			return var24
		end
		monster.SetPos(var7, var8, var9)
		monster.CopyVector(var7, var8, var9)
		helper_0ba23e4e()
		var23 = vm.i32(var23 + 1)
	end
	return 0
end

--- Helper function.
local function helper_17e38(arg0: any)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local chara_id: s32 = 0
	monster.SetMos("立ち", -1, 4)
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	helper_f3c4(pos_x, 25.0, pos_z, 0.875, 10.0, 5.0, 150)
	while true do
		helper_0ba23e4e()
		chara_id = monster.GetUserMonsId() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(90.0) == 0 then
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(vm.f32(4.8))
			end
			monster.SetMos("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_1821c()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	chara_id = monster.GetUserMonsId() or chara_id
	if chara_id > -1 then
		helper_17e38(monster_id)
	end
end

--- Helper function.
local function helper_11bc0(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var18: s32 = 0
	var7, var8, var9 = helper_125e5305(arg2, arg3, var7, var8, var9)
	arg2 = monster.GetRefAngle(var7, var8, var9) or arg2
	if arg2 > vm.f32(3.1415927) then
		arg2 = vm.f32(arg2 - vm.f32(6.2831855))
	end
	if arg2 <= vm.f32(-3.1415927) then
		arg2 = vm.f32(arg2 + vm.f32(6.2831855))
	end
	helper_595cbf61(helper_28452e16(arg2), arg1)
	helper_442b9962()
	var18 = helper_f3c4(var7, var8, var9, arg0, arg4, arg5, arg6)
	return var18
end

--- Helper function.
local function helper_19b50()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		var3 = monster.GetRndf(30.0) or var3
		var4 = monster.GetRndf(30.0) or var4
		var4 = vm.f32(var4 + 140.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.SetMos("歩き", -1, 0)
		helper_11bc0(1.75, 10.0, var3, var4, 42.0, 40.0, 60)
		helper_890ee63a(10.0)
	else
		monster.SetMos("立ち", -1, 0)
		helper_7ca8a12f(42.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_10b10(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
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
	local var22: s32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	for var21 = 0, arg5 - 1 do
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		var19 = helper_57b569a8(var19)
		var7 = vm.f32(var19 + arg3)
		do
			local out1, out2, out3 = monster.CopyVector(var6, var7, var8)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.SubVector(var15, var16, var17, var9, var10, var11)
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
			local out1, out2, out3 = monster.ScaleVector(var15, var16, var17, arg0)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.AddVector(var9, var10, var11, var15, var16, var17)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = monster.GetRefRot_6(var9, var10, var11)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		var20 = monster.GetHigh2(var9, var10, var11) or var20
		if var20 >= 40.0 or var20 <= 0.0 then
			var10 = vm.f32(var10 - var16)
			var16 = 0.0
		end
		var18 = monster.GetDistVector2(var9, var10, var11, var6, var7, var8) or var18
		if var18 < vm.f32(arg0 + arg2) then
			return 1
		end
		var22 = helper_de1504df(var9, var10, var11, arg0, var13)
		if var22 ~= 0 then
			print("hit------------------\n")
			return var22
		end
		monster.SetPos(var9, var10, var11)
		if arg4 ~= 0 then
			monster.SetRot(var12, var13, var14)
		else
			monster.SetRot(0.0, var13, 0.0)
		end
		helper_0ba23e4e()
	end
	return 0
end

--- Helper function.
local function helper_18a7c(arg0: any)
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local chara_type: s32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local attack: s32 = 0
	local var19: s32 = 0
	local var20: s32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("立ち", -1, 0)
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		helper_f3c4(pos_x, pos_y, pos_z, 1.5, 0.0, 40.0, 30)
	end
	monster.ResetMotion()
	monster.SetMos("攻撃１", -1, 6)
	helper_48852a90(10.0, vm.f32(0.688), vm.f32(0.02))
	chara_type = monster.GetUserid() or chara_type
	var16 = 0
	do
		local out1, out2, out3 = monster.GetFramePos("dcol_00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.GetRot()
	attack = monster.GetBaseAttack_1() or attack
	var13 = 12.0
	var12 = vm.f32(0.28)
	var11 = 0.0
	var17 = 0
	var14 = 0.0
	var19 = 90
	var20 = 15
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	monster.EsmCreate_1("火弾Ｌ２")
	monster.EsmSetUserId(-1, chara_type)
	monster.EsmSetTargetId(-1, var16)
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var8, var9, var10)
	monster.EsmSetValue(-1, 0, attack)
	monster.EsmSetValueFloat(-1, 1, var13)
	monster.EsmSetValueFloat(-1, 2, var12)
	monster.EsmSetValueFloat(-1, 3, var11)
	monster.EsmSetValue(-1, 4, var17)
	monster.EsmSetValueFloat(-1, 5, var14)
	monster.EsmSetValue(-1, 6, var19)
	monster.EsmSetValue(-1, 7, var20)
	helper_56d63eae()
end

--- Helper function.
local function helper_1172c(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	var15 = monster.GetRndf(arg4) or var15
	var16 = monster.GetRndf(arg3) or var16
	var15 = vm.f32(var15 + arg2)
	helper_595cbf61(var16, arg1)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.GetRot()
		var12 = out2 or var12
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var12) * var15))
	pos_y = pos_y
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var12) * var15))
	local _ = helper_f3c4(pos_x, pos_y, pos_z, arg0, arg5, arg6, arg7)
end

--- Helper function.
local function helper_1b7e8()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 5 then
		monster.SetMos("歩き", -1, 0)
		helper_10b10(1.5, 10.0, 14.0, 20.0, 0, 60)
		monster.SetMos("立ち", -1, 0)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 75 then
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(10.0)
			helper_18a7c(33.0)
		else
			var1 = helper_e2fdabb9(var1)
			argc = monster.GetRnd(100) or argc
			if argc < 70 then
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					var2 = -30.0
				else
					var2 = 30.0
				end
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(10.0)
				monster.SetMos("歩き", -1, 0)
				helper_11bc0(1.75, 10.0, var2, var1, 140.0, 40.0, 45)
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(10.0)
				monster.SetMos("立ち", -1, 0)
				helper_7ca8a12f(42.0, 45.0, 30)
			else
				monster.SetMos("歩き", -1, 0)
				helper_1172c(1.75, 10.0, 60.0, 180.0, 30.0, 42.0, 40.0, 60)
				monster.SetMos("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_19608(arg0: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.SetMos("攻撃２in", -1, 2)
	helper_56d63eae()
	monster.SetMos("攻撃２loop", -1, 4)
	var2 = helper_10b10(4.0, 10.0, 1.5, 5.0, 0, vm.i32(20 * arg0))
	monster.SetMos("攻撃２out", -1, 6)
	helper_56d63eae()
	if var2 == -1 or var2 == 1 then
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		helper_f3c4(pos_x, pos_y, pos_z, 1.5, 0.0, 40.0, 30)
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			helper_18a7c(5.0)
		end
	end
	monster.SetMos("立ち", -1, 0)
end

--- Helper function.
local function helper_1b018()
	local var3: f32 = 0
	local argc: s32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 90 then
		argc = monster.GetRnd(100) or argc
		if argc < 70 then
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(10.0)
			helper_18a7c(17.0)
		else
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				var5 = -45.0
			else
				var5 = 45.0
			end
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(10.0)
			monster.SetMos("走り", -1, 0)
			helper_11bc0(1.75, 10.0, var5, var3, 42.0, 40.0, 60)
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(10.0)
			monster.SetMos("立ち", -1, 0)
			var6 = helper_7ca8a12f(42.0, 45.0, 30)
			if var6 == 1 then
				helper_19608(3)
			end
		end
	else
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(10.0)
		monster.SetMos("走り", -1, 0)
		helper_10b10(2.0, 10.0, 14.0, 15.0, 0, 90)
		monster.SetMos("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_13154(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	monster.GetTargetPos()
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.GetRot()
		var11 = out2 or var11
	end
	var13 = vm.f32(var11 + vm.f32(3.1415927))
	if var13 > vm.f32(3.1415927) then
		var13 = vm.f32(var13 - vm.f32(6.2831855))
	end
	if var13 <= vm.f32(-3.1415927) then
		var13 = vm.f32(var13 + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var13) * var14))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var13) * var14))
	helper_f3c4(pos_x, pos_y, pos_z, arg0, arg1, arg2, arg3)
end

--- Helper function.
local function helper_11f70(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	helper_595cbf61(arg2, arg0)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(vm.f32(arg2 * vm.f32(0.017453292))) * arg3))
	pos_y = pos_y
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(vm.f32(arg2 * vm.f32(0.017453292))) * arg3))
	local _ = helper_f3c4(pos_x, pos_y, pos_z, arg1, arg4, arg5, arg6)
end

--- Helper function.
local function helper_1a908()
	local argc: s32 = 0
	local var2: f32 = 0
	monster.GetMonsterLifeInt()
	argc = monster.GetRnd(100) or argc
	if argc < 70 then
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(10.0)
		argc = monster.GetRnd(2) or argc
		helper_19608(vm.i32(1 + argc))
		monster.SetMos("立ち", -1, 0)
		helper_c3e8ae39(3)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(10.0)
			monster.SetMos("ステップ後", -1, 0)
			helper_13154(2.25, 10.0, 40.0, 60)
			monster.SetMos("立ち", -1)
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(10.0)
			helper_18a7c(5.0)
		else
			var2 = monster.GetTargetAngle() or var2
			monster.SetMos("歩き", -1, 0)
			helper_11f70(10.0, 1.5, helper_28452e16(vm.f32(var2 + vm.f32(3.1415927))), 100.0, 10.0, 40.0, 60)
			monster.SetMos("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_1c09c()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
		if gekirin <= 0 then
			return
		end
		var3 = helper_e2fdabb9(var3)
		if var3 > 330.0 then
			vm.wait()
			return
		end
		priority = monster.GetPriority() or priority
		if priority > 4 then
			helper_19b50()
			continue
		end
		if var3 < 330.0 and var3 >= 220.0 then
			helper_1b7e8()
		elseif var3 < 220.0 and var3 >= 140.0 then
			helper_1b018()
		else
			helper_1a908()
		end
	end
end

--- Helper function.
local function helper_12760(
	arg0: f32,
	arg1: f32,
	arg2: f32,
	arg3: f32,
	arg4: f32,
	arg5: f32,
	arg6: f32,
	arg7: f32,
	arg8: f32,
	arg9: s32
)
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	var17 = vm.f32(arg6 * vm.f32(0.017453292))
	var18 = monster.GetRefAngle(arg0, arg1, arg2) or var18
	var18 = vm.f32(var18 - vm.f32(3.1415927))
	var18 = vm.f32(var18 + var17)
	if var18 > vm.f32(3.1415927) then
		var18 = vm.f32(var18 - vm.f32(6.2831855))
	end
	if var18 <= vm.f32(-3.1415927) then
		var18 = vm.f32(var18 + vm.f32(6.2831855))
	end
	var10 = vm.f32(arg0 + vm.f32(arg5 * vm.sin(var18)))
	var11 = 0.0
	var12 = vm.f32(arg2 + vm.f32(arg5 * vm.cos(var18)))
	arg6 = monster.GetRefAngle(var10, var11, var12) or arg6
	helper_595cbf61(helper_28452e16(arg6), arg4)
	helper_442b9962()
	local _ = helper_f3c4(var10, var11, var12, arg3, arg7, arg8, arg9)
end

--- Helper function.
local function helper_122fc(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	arg1 = helper_787df986(arg1)
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(arg1) * arg2))
	pos_y = pos_y
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(arg1) * arg2))
	local _ = helper_f3c4(pos_x, pos_y, pos_z, arg0, arg3, arg4, arg5)
end

--- Helper function.
local function helper_15680()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var15: f32 = 0
	local var18: f32 = 0
	local var20: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	helper_0ba23e4e()
	argc = monster.GetRnd(100) or argc
	if argc < 10 then
	else
	end
	monster.VPush2(0, 0)
	monster.GetTargetDist()
	do
		local out1, out2, out3 = monster.GetPlacePos_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var5 = monster.GetDistVector2(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or var5
	do
		local _, out2, _ = monster.GetRot()
		var15 = out2 or var15
	end
	var18 = monster.SearchArea(100.0, 0.0) or var18
	if var18 < 42.0 then
		print("1------------------------------------------------\n")
		var7 = monster.GetRndf(360.0) or var7
		monster.SetMos("歩き", -1, 0)
		helper_595cbf61(var7, vm.f32(4.8))
		var18 = monster.SearchArea(100.0, 0.0) or var18
		var18 = vm.f32(var18 - 42.0)
		if var18 > 0.0 then
			helper_11f70(vm.f32(4.8), 1.75, var7, var18, 42.0, 40.0, 30)
		end
		monster.SetMos("立ち", -1, 0)
	end
	if var5 > 300.0 then
		argc = monster.GetRnd(100) or argc
		if argc < 90 then
			if var5 > 800.0 then
				do
					local out1, out2, out3 = monster.GetPos_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				do
					local _, out2, _ = monster.GetTargetPos()
					var20 = out2 or var20
				end
				monster.SetPlacePos(pos_x, var20 + 40.0, pos_z)
			end
			argc = monster.GetRnd(100) or argc
			if argc < 30 then
				print("2------------------------------------------------\n")
				monster.VPush2(0, 4)
				argc = monster.GetRnd(100) or argc
				var22 = monster.GetRndf(360.0) or var22
				var5 = monster.GetRndf(150.0) or var5
				if argc < 50 then
					var22 = vm.f32(-var22 - 30.0)
				else
					var22 = vm.f32(var22 + 30.0)
				end
				monster.SetMos("歩き", -1, 0)
				helper_12760(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), var5, var22, 42.0, 40.0, 60)
				var23 = monster.GetRndf(180.0) or var23
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					var23 = vm.f32(var23 * -1.0)
				end
				helper_595cbf61(var23, vm.f32(4.8))
				monster.SetMos("立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.VPush2(0, 8)
				monster.SetMos("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.GetRnd(100) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
			return
		end
	end
	argc = monster.GetRnd(100) or argc
	if argc < 35 then
		argc = monster.GetRnd(100) or argc
		if argc < 80 then
			monster.VPush2(0, 8)
			monster.SetMos("立ち", -1, 0)
			helper_7e925497(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.VPush2(0, 16)
			var7 = monster.GetRndf(180.0) or var7
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.SetMos("歩き", -1, 0)
			helper_595cbf61(var7, vm.f32(4.8))
			monster.SetMos("立ち", -1, 0)
		end
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					print("5------------------------------------------------\n")
					monster.VPush2(0, 4)
					argc = monster.GetRnd(100) or argc
					var24 = monster.GetRndf(180.0) or var24
					var25 = monster.GetRndf(30.0) or var25
					var26 = monster.GetTargetDist() or var26
					var25 = vm.f32(var25 + var26)
					if argc < 50 then
						var24 = vm.f32(var24 * -1.0)
					end
					argc = monster.GetRnd(100) or argc
					if argc < 50 then
						var24 = vm.f32(-var24 - 30.0)
					else
						var24 = vm.f32(var24 + 30.0)
					end
					monster.SetMos("歩き", -1, 0)
					var1 = helper_11bc0(1.75, vm.f32(4.8), var24, var25, 42.0, 40.0, 60)
					var27 = monster.GetRndf(360.0) or var27
					argc = monster.GetRnd(100) or argc
					if argc < 50 then
						var27 = vm.f32(var27 * -1.0)
					end
					helper_595cbf61(var27, vm.f32(4.8))
					monster.SetMos("立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.VPush2(0, 32)
					monster.SetMos("歩き", -1, 0)
					do
						local _, out2, _ = monster.GetRot()
						var15 = out2 or var15
					end
					var7 = helper_28452e16(var15)
					if var7 > vm.f32(3.1415927) then
						var7 = vm.f32(var7 - vm.f32(6.2831855))
					end
					if var7 <= vm.f32(-3.1415927) then
						var7 = vm.f32(var7 + vm.f32(6.2831855))
					end
					helper_122fc(1.75, var7, 1000.0, 42.0, 40.0, 60)
					monster.SetMos("立ち", -1, 0)
				end
			else
				monster.VPush2(0, 8)
				monster.SetMos("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
		elseif var2 == 8 then
			print("7------------------------------------------------\n")
			monster.VPush(0, 1)
			argc = monster.GetRnd(120) or argc
			var5 = monster.GetTargetDist() or var5
			argc = vm.i32(argc + 15)
			monster.SetMos("歩き", -1, 0)
			helper_1172c(1.75, vm.f32(4.8), var5, 360.0, 40.0, 42.0, 40.0, argc)
			monster.SetMos("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_19fc4()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	while true do
		vm.wait()
		var3 = helper_e2fdabb9(var3)
		if var3 > 330.0 then
			vm.wait()
			return
		end
		priority = monster.GetPriority() or priority
		if priority > 5 then
			helper_19b50()
			continue
		end
		if var3 < 140.0 then
			argc = monster.GetRnd(100) or argc
			if argc < 85 then
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(10.0)
				argc = monster.GetRnd(2) or argc
				helper_19608(vm.i32(3 + argc))
			else
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(10.0)
				monster.SetMos("ステップ後", -1, 0)
				helper_13154(2.25, 10.0, 40.0, 60)
				monster.SetMos("立ち", -1)
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(10.0)
				helper_18a7c(5.0)
			end
		else
			argc = monster.GetRnd(100) or argc
			if argc < 60 then
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(10.0)
				if var3 < 220.0 and var3 >= 140.0 then
					helper_18a7c(17.0)
				else
					helper_18a7c(33.0)
				end
			else
				monster.SetMos("走り", -1, 0)
				helper_10b10(2.0, 10.0, 42.0, 15.0, 0, 90)
				monster.SetMos("立ち", -1, 0)
			end
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local get_not_used_texb: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local grade: s32 = 0
	monster.SetDmg2("通常攻撃", 3.0, "攻撃２loop", 0.0, 1.0, 1)
	monster.SetDmg2("通常攻撃", 3.0, "攻撃２loop", 0.0, 1.0, 2)
	monster.SetDmg2("通常攻撃", 3.0, "攻撃２loop", 0.0, 1.0, 3)
	monster.SetDmg2("通常攻撃", 3.0, "攻撃２loop", 0.0, 1.0, 4)
	monster.SetDmg2("吹っ飛び攻撃", 3.0, "攻撃２out", 0.0, 0.2, 1)
	monster.SetDmg2("吹っ飛び攻撃", 3.0, "攻撃２out", 0.0, 0.2, 2)
	monster.SetDmg2("通常攻撃", 3.0, "攻撃２out", 0.0, 0.2, 3)
	monster.SetDmg2("通常攻撃", 3.0, "攻撃２out", 0.0, 0.2, 4)
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		monster.LoadEffectScript("火弾Ｆ")
		monster.LoadEffectScript("火弾Ｌ２")
		monster.LoadEffectScript("火弾Ｈ")
		if (if (if var1 ~= 0 then 1 else var2) ~= 0 then 1 else var3) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	monster.SwEffect(0, "攻撃２in", 0.7, 0.82, "kiseki0", "kiseki1", 100, 5, 50)
	monster.SwEffect(1, "攻撃２in", 0.7, 0.82, "kiseki2", "kiseki3", 100, 5, 50)
	monster.SwEffect(0, "攻撃２loop", 0.0, 0.12, "kiseki0", "kiseki1", 100, 5, 50)
	monster.SwEffect(1, "攻撃２loop", 0.0, 0.12, "kiseki2", "kiseki3", 100, 5, 50)
	helper_b3b48995()
	helper_ac26cdde(60.0)
	helper_1c5c()
	grade = monster.GetMonsGrade_2(-1) or grade
	if grade == 0 then
		monster.SetScoop("攻撃２loop", 0.0, 1.0, 1006)
	end
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local gekirin: s32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
		if gekirin > 0 then
			helper_1821c()
			var0 = helper_e2fdabb9(var0)
			if var0 < 330.0 then
				helper_1c09c()
			else
				helper_15680()
			end
		else
			helper_19fc4()
		end
	end
end

--- Reacts to a hit while greyed out, or to a hit that greys it out.
function script.on_status_hit()
	local var0: s32 = 0
	helper_5d37e9f4()
	print("damage stop action-------------\n")
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(0.0, 0.0, 0)
	var0 = 1
	while var0 ~= 0 do
		var0 = monster.GetStsAttr(40) or var0
		vm.wait()
	end
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_28faa04b()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_a2d828a7()
	monster.SetMos("吹っ飛び", -1, 6)
	monster.BlowStart(3.0, 0.05, 20)
	helper_56d63eae()
	monster.SetActStatus(1)
	helper_c3e8ae39(30)
	monster.SetActStatus(0)
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	monster.SetMos("立ち")
	helper_905c94a1()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.ResetMotion()
	monster.SetMos("ガード", -1, 4)
	monster.BlowStart(3.0, 0.0, 2)
	helper_c3e8ae39(8)
	monster.SetMos("立ち")
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	monster.SetMos("歩き", -1, 0)
	helper_890ee63a(10.0)
	monster.SetMos("ステップ後", -1, 2)
	helper_13154(2.25, 10.0, 40.0, 60)
	monster.SetMos("立ち", -1)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.ResetMove()
	helper_442b9962()
	monster.ResetMotion()
	monster.SetMos("ガード", -1, 4)
	monster.BlowStart(3.0, 0.0, 2)
	helper_c3e8ae39(8)
	monster.SetMos("立ち")
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_83dc8947()
	monster.SetMos("死に", -1, 6)
	helper_56d63eae()
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_2db2fc96()
	monster.SetMos("じたばた", -1, 4)
	helper_206033b2()
	helper_206033b2()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	local var3: f32 = 0
	helper_2f2adeb4()
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_97663440(10)
	monster.ResetMotion()
	monster.SetMos("起き上がり", -1, 6)
	helper_3c99e866()
	helper_2e729f21()
	var3 = helper_57b569a8(var3)
	monster.SetMos("歩き", -1, 0)
	helper_0ba23e4e()
end

--- Stuns the monster.
function script.on_stun()
	helper_59867820()
	monster.SetMos("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	helper_aada6ba2()
	monster.SetMos("歩き", -1, 0)
end

return script
