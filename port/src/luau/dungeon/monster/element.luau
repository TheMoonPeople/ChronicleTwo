--!strict
-- dungeon/monster/element.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_154d7e30 = require("@lib/monster/helper_154d7e30")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1be0f106 = require("@lib/monster/helper_1be0f106")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_274f6d9a = require("@lib/monster/helper_274f6d9a")
local helper_27a31f0d = require("@lib/monster/helper_27a31f0d")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_2db2fc96 = require("@lib/monster/helper_2db2fc96")
local helper_2e729f21 = require("@lib/monster/helper_2e729f21")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_351dcd9e = require("@lib/monster/helper_351dcd9e")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_57bfae69 = require("@lib/monster/helper_57bfae69")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_708ce460 = require("@lib/monster/helper_708ce460")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_83dc8947 = require("@lib/monster/helper_83dc8947")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_905c94a1 = require("@lib/monster/helper_905c94a1")
local helper_97f462c5 = require("@lib/monster/helper_97f462c5")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_c0339fe8 = require("@lib/monster/helper_c0339fe8")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_de1504df = require("@lib/monster/helper_de1504df")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e2fdabb9 = require("@lib/monster/helper_e2fdabb9")
local helper_fbc2528f = require("@lib/monster/helper_fbc2528f")

--- Helper function.
local function helper_19c20()
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	if monster_id >= 76 and monster_id <= 79 then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_19d60()
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	if monster_id >= 80 and monster_id <= 83 then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_19ea0()
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	if monster_id >= 84 and monster_id <= 87 then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_19fe0()
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	if monster_id >= 88 and monster_id <= 91 then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_1a120()
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	if monster_id >= 92 and monster_id <= 95 then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_30d8()
	local boss: s32 = 0
	helper_1adea708(500.0)
	helper_6911bbcd(80.0)
	helper_5a759074(0)
	monster.VPush2(5, 0)
	monster.VPush2(11, 150)
	monster.VPush2(12, 0)
	boss = monster.GetBossFlag() or boss
	if boss == 0 then
		monster.GetPos_3()
		monster.SetClipDist(35.0)
	else
		monster.SetClipDist(999999.0)
	end
end

--- Helper function.
local function helper_10984(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
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
	for var23 = 0, arg6 - 1 do
		do
			local out1, out2, out3 = monster.AddVector(var7, var8, var9, var13, var14, var15)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var22 = monster.GetHigh2(var7, var8, var9) or var22
		if var22 >= 30.0 or var22 <= 0.0 then
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
		helper_274f6d9a()
	end
	return 0
end

--- Helper function.
local function helper_193f8(arg0: any)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local chara_id: s32 = 0
	monster.SetMos("立ち", -1, 4)
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	helper_10984(pos_x, 25.0, pos_z, 0.875, 10.0, 5.0, 150)
	while true do
		helper_274f6d9a()
		chara_id = monster.GetUserMonsId() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(90.0) == 0 then
				monster.SetMos("歩き", -1, 0)
				helper_708ce460(vm.f32(4.8))
			end
			monster.SetMos("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_197dc()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	chara_id = monster.GetUserMonsId() or chara_id
	if chara_id > -1 then
		helper_193f8(monster_id)
	end
end

--- Helper function.
local function helper_13180(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
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
	helper_154d7e30(helper_28452e16(arg2), arg1)
	helper_442b9962()
	var18 = helper_10984(var7, var8, var9, arg0, arg4, arg5, arg6)
	return var18
end

--- Helper function.
local function helper_1b8f4()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		var3 = monster.GetRndf(30.0) or var3
		var4 = monster.GetRndf(30.0) or var4
		var4 = vm.f32(var4 + 120.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.SetMos("歩き", -1, 0)
		local _ = helper_13180(2.0, vm.f32(4.8), var3, 60.0, 1.0, 30.0, 50)
		helper_708ce460(vm.f32(4.8))
		monster.SetMos("立ち", -1, 0)
	else
		monster.SetMos("立ち", -1, 0)
		helper_351dcd9e(30.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_120d0(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
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
		if var20 >= 30.0 or var20 <= 0.0 then
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
		helper_274f6d9a()
	end
	return 0
end

--- Helper function.
local function helper_1a3ec()
	local var0: s32 = 0
	local var1: f32 = 0
	var1 = monster.GetRndf(360.0) or var1
	monster.SetMos("歩き", -1, 0)
	helper_154d7e30(var1, vm.f32(4.8))
	monster.SetMos("立ち", -1, 0)
	helper_c0339fe8(9)
	var0 = helper_351dcd9e(290.0, 45.0, 45)
	if var0 == 1 then
		monster.SetMos("走り", -1, 0)
		helper_120d0(vm.f32(7.4), vm.f32(4.8), 30.0, 5.0, 0, 150)
		monster.SetMos("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_cf04(arg0: f32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	if arg2 == -1.0 then
		arg2 = vm.f32(0.05)
	end
	var5 = helper_787df986(arg0)
	if var5 > vm.f32(3.1415927) then
		var5 = vm.f32(var5 - vm.f32(6.2831855))
	end
	if var5 <= vm.f32(-3.1415927) then
		var5 = vm.f32(var5 + vm.f32(6.2831855))
	end
	while true do
		var3 = monster.GetTargetAngle() or var3
		monster.SetNextRot(var3, var5)
		var4 = monster.NowMosWait() or var4
		if var4 < vm.f32(arg1 + arg2) and var4 > vm.f32(arg1 - arg2) then
			break
		else
			helper_274f6d9a()
		end
	end
	helper_442b9962()
end

--- Helper function.
local function helper_5f88(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	if arg1 == -1.0 then
		arg1 = vm.f32(0.03)
	end
	var3 = 0
	while true do
		helper_274f6d9a()
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
local function helper_1ac1c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local attack: s32 = 0
	attack = monster.GetBaseAttack_1() or attack
	monster.SetMos("歩き", -1, 0)
	helper_708ce460(vm.f32(7.2000003))
	monster.SetMos("攻撃２", -1, 6)
	helper_cf04(vm.f32(4.8), vm.f32(0.592), vm.f32(0.02))
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	var7 = vm.f32(var7 + 15.0)
	do
		local out1, out2, out3 = monster.GetFramePos("face")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.GetRot()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.SubVector(var6, var7, var8, pos_x, pos_y, pos_z)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.NormalVector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	if helper_19c20() ~= 0 then
		monster.EsmCreate_1("火弾Ｆ")
	end
	if helper_19d60() ~= 0 then
		monster.EsmCreate_1("氷弾Ｆ")
	end
	if helper_19ea0() ~= 0 then
		monster.EsmCreate_1("雷弾Ｆ")
	end
	if helper_19fe0() ~= 0 then
		monster.EsmCreate_1("水弾Ｆ")
	end
	if helper_1a120() ~= 0 then
		monster.EsmCreate_1("風弾Ｆ")
	end
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var3, var4, var5)
	helper_5f88(vm.f32(0.608), vm.f32(0.02))
	if helper_19c20() ~= 0 then
		monster.EsmCreate_1("火弾Ｌ３")
	end
	if helper_19d60() ~= 0 then
		monster.EsmCreate_1("氷弾Ｌ２")
	end
	if helper_19ea0() ~= 0 then
		monster.EsmCreate_1("雷弾Ｌ２")
	end
	if helper_19fe0() ~= 0 then
		monster.EsmCreate_1("水弾Ｌ２")
	end
	if helper_1a120() ~= 0 then
		monster.EsmCreate_1("風弾Ｌ２")
	end
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var6, var7, var8)
	monster.EsmSetValue(-1, 0, attack)
	monster.EsmSetValueFloat(-1, 1, 12.0)
	helper_fbc2528f()
	monster.SetMos("立ち", -1, 0)
	helper_c0339fe8(9)
end

--- Helper function.
local function helper_1001c(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var21: s32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = monster.CopyVector(0.0, arg0, 0.0)
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
	do
		local out1, out2, out3 = monster.ScaleVector(var10, var11, var12, arg1)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	for var20 = 0, arg3 - 1 do
		do
			local out1, out2, out3 = monster.AddVector(var4, var5, var6, var10, var11, var12)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		var19 = monster.GetHigh2(var4, var5, var6) or var19
		if var19 >= 30.0 or var19 <= 0.0 then
			var5 = vm.f32(var5 - var11)
			var11 = 0.0
		end
		var17 = monster.GetDistVector2(var4, var5, var6, var4, arg0, var6) or var17
		if var17 < vm.f32(arg1 + arg2) then
			return
		end
		do
			local _, out2, _ = monster.GetRot()
			var8 = out2 or var8
		end
		var21 = helper_de1504df(var4, var5, var6, arg1, var8)
		if var21 ~= 0 then
			return
		end
		monster.SetPos(var4, var5, var6)
		monster.CopyVector(var4, var5, var6)
		helper_274f6d9a()
	end
end

--- Helper function.
local function helper_1a260()
	monster.GetPos_3()
	monster.SetMos("歩き", -1, 0)
	helper_1001c(30.0, 2.0, 30.0, 60)
end

--- Helper function.
local function helper_1ddb8()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	var2 = helper_e2fdabb9(var2)
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		if argc < 80 then
			argc = monster.GetRnd(100) or argc
			if argc < 20 then
				helper_1a3ec()
			else
				helper_1ac1c()
			end
		else
			argc = monster.GetRnd(100) or argc
			if argc < 25 then
				monster.SetMos("歩き", -1, 0)
				helper_27a31f0d(2.0, vm.f32(4.8), 120.0, 60)
				helper_120d0(2.0, vm.f32(4.8), 30.0, 30.0, 0, 90)
				monster.SetMos("立ち", -1, 0)
			else
				monster.SetMos("立ち", -1, 0)
				helper_351dcd9e(30.0, 45.0, 75)
			end
		end
	else
		monster.SetMos("走り", -1, 0)
		var1 = helper_120d0(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 90)
		if var1 < 85 and var1 ~= 1 then
			helper_1a260()
		end
		monster.SetMos("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_142d4(arg0: f32, arg1: f32, arg2: f32, arg3: s32, arg4: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	var15 = 300.0
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
	if arg3 ~= 0 then
		var14 = vm.f32(var12 - vm.f32(1.5707964))
	else
		var14 = vm.f32(var12 + vm.f32(1.5707964))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var14) * var15))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var14) * var15))
	helper_10984(pos_x, pos_y, pos_z, arg0, arg1, arg2, arg4)
end

--- Helper function.
local function helper_1d384()
	local argc: s32 = 0
	local var1: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	var4 = helper_e2fdabb9(var4)
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		if argc < 70 then
			helper_1ac1c()
		else
			argc = monster.GetRnd(100) or argc
			if argc < 30 then
				helper_1a3ec()
			else
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					argc = monster.GetRnd(100) or argc
					var6 = monster.GetRndf(60.0) or var6
					if argc < 50 then
						var6 = vm.f32(-var6 - 30.0)
					else
						var6 = vm.f32(var6 + 30.0)
					end
					monster.SetMos("歩き", -1, 0)
					helper_13180(2.0, vm.f32(4.8), var6, 60.0, 1.0, 30.0, 75)
					helper_708ce460(vm.f32(4.8))
					monster.SetMos("立ち", -1, 0)
					helper_c0339fe8(9)
				else
					argc = monster.GetRnd(100) or argc
					if argc < 50 then
						var7 = 1
						monster.SetMos("ステップ右", -1, 0)
					else
						var7 = 0
						monster.SetMos("ステップ左", -1, 0)
					end
					helper_142d4(2.0, 30.0, 30.0, var7, 60)
					monster.SetMos("立ち", -1, 0)
				end
			end
		end
	else
		monster.SetMos("走り", -1, 0)
		var1 = helper_120d0(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 60)
		if var1 < 55 and var1 ~= 1 then
			helper_1a260()
		end
		monster.SetMos("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_11520(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var21: f32 = 0
	local var23: s32 = 0
	var18 = monster.GetTargetDist() or var18
	helper_708ce460(arg1)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var9 = out3 or var9
	end
	var17 = helper_57b569a8(var17)
	var6 = vm.f32(var17 + arg3)
	do
		local out1, out2, out3 = monster.CopyVector(var5, var6, var7)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.SubVector(var14, var15, var16, var8, var9, var10)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.NormalVector(var14, var15, var16)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.ScaleVector(var14, var15, var16, arg0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local _, out2, _ = monster.GetRot()
		var12 = out2 or var12
	end
	for var22 = 0, arg4 - 1 do
		do
			local out1, out2, out3 = monster.AddVector(var8, var9, var10, var14, var15, var16)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		var21 = monster.GetHigh2(var8, var9, var10) or var21
		if var21 >= 30.0 or var21 <= 0.0 then
			var9 = vm.f32(var9 - var15)
			var15 = 0.0
		end
		var18 = monster.GetDistVector2(var8, var9, var10, var5, var6, var7) or var18
		if var18 < vm.f32(arg0 + arg2) then
			return
		end
		var23 = helper_de1504df(var8, var9, var10, arg0, var12)
		if var23 ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.SetPos(var8, var9, var10)
		helper_274f6d9a()
	end
end

--- Helper function.
local function helper_1a78c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	monster.VPush(0, 1)
	monster.SetMos("歩き", -1, 0)
	helper_708ce460(vm.f32(7.2000003))
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.ResetMotion()
	monster.SetMos("攻撃１", -1, 6)
	monster.GetTargetPos() -- retail: argument 1 is a value where the handler writes an output; the output is discarded; argument 2 is a value where the handler writes an output; the output is discarded; argument 3 is a value where the handler writes an output; the output is discarded
	var6 = helper_57bfae69(var0, var1, var2, var6)
	helper_10984(var3, var4, var5, 10.5, 10.0, 2.0, 27)
	helper_fbc2528f()
	monster.SetMos("立ち", -1, 0)
	helper_c0339fe8(9)
end

--- Helper function.
local function helper_14714(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
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
	helper_10984(pos_x, pos_y, pos_z, arg0, arg1, arg2, arg3)
end

--- Helper function.
local function helper_1c5e8()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	monster.GetMonsterLife()
	var3 = helper_e2fdabb9(var3)
	if var3 < 30.0 then
		argc = monster.GetRnd(100) or argc
		var4 = monster.GetRndf(60.0) or var4
		if argc < 50 then
			var4 = vm.f32(-var4 - 30.0)
		else
			var4 = vm.f32(var4 + 30.0)
		end
		monster.SetMos("歩き", -1, 0)
		helper_13180(2.0, vm.f32(4.8), var4, 60.0, 1.0, 30.0, 50)
		helper_708ce460(vm.f32(4.8))
		monster.SetMos("立ち", -1, 0)
		helper_c0339fe8(9)
	end
	argc = monster.GetRnd(100) or argc
	if argc < 65 then
		monster.SetMos("歩き", -1, 0)
		helper_11520(2.0, vm.f32(4.8), 30.0, 30.0, 60)
		helper_1a78c()
		monster.SetMos("立ち", -1, 0)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 15 then
			argc = monster.GetRnd(100) or argc
			var5 = monster.GetRndf(60.0) or var5
			if argc < 50 then
				var5 = vm.f32(-var5 - 30.0)
			else
				var5 = vm.f32(var5 + 30.0)
			end
			monster.SetMos("歩き", -1, 0)
			helper_13180(2.0, vm.f32(4.8), var5, 60.0, 1.0, 30.0, 50)
			helper_708ce460(vm.f32(4.8))
			monster.SetMos("立ち", -1, 0)
			helper_c0339fe8(9)
		else
			monster.SetMos("歩き", -1, 0)
			helper_708ce460(vm.f32(4.8))
			argc = monster.GetRnd(100) or argc
			if argc < 67 then
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					var6 = 1
					monster.SetMos("ステップ右", -1, 0)
				else
					var6 = 0
					monster.SetMos("ステップ左", -1, 0)
				end
				helper_142d4(2.0, 30.0, 30.0, var6, 60)
				monster.SetMos("立ち", -1, 0)
			else
				helper_14714(2.0, 30.0, 30.0, 60)
				monster.SetMos("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_1e494()
	local var0: f32 = 0
	local priority: s32 = 0
	while true do
		helper_274f6d9a()
		monster.GetMonsterLife()
		helper_197dc()
		var0 = helper_e2fdabb9(var0)
		if var0 > 290.0 then
			helper_274f6d9a()
			return
		end
		priority = monster.GetPriority() or priority
		if priority > 3 then
			helper_1b8f4()
			continue
		end
		if var0 < 290.0 and var0 >= 180.0 then
			helper_1ddb8()
		elseif var0 < 180.0 and var0 >= 120.0 then
			helper_1d384()
		else
			helper_1c5e8()
		end
	end
end

--- Helper function.
local function helper_13530(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	helper_154d7e30(arg2, arg0)
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
	local _ = helper_10984(pos_x, pos_y, pos_z, arg1, arg4, arg5, arg6)
end

--- Helper function.
local function helper_13d20(
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
	helper_154d7e30(helper_28452e16(arg6), arg4)
	helper_442b9962()
	local _ = helper_10984(var10, var11, var12, arg3, arg7, arg8, arg9)
end

--- Helper function.
local function helper_138bc(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
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
	local _ = helper_10984(pos_x, pos_y, pos_z, arg0, arg3, arg4, arg5)
end

--- Helper function.
local function helper_12cec(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	var15 = monster.GetRndf(arg4) or var15
	var16 = monster.GetRndf(arg3) or var16
	var15 = vm.f32(var15 + arg2)
	helper_154d7e30(var16, arg1)
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
	local _ = helper_10984(pos_x, pos_y, pos_z, arg0, arg5, arg6, arg7)
end

--- Helper function.
local function helper_16c40()
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
	helper_274f6d9a()
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
	if var18 < 30.0 then
		print("1------------------------------------------------\n")
		var7 = monster.GetRndf(360.0) or var7
		monster.SetMos("歩き", -1, 0)
		helper_154d7e30(var7, vm.f32(4.8))
		var18 = monster.SearchArea(100.0, 0.0) or var18
		var18 = vm.f32(var18 - 30.0)
		if var18 > 0.0 then
			helper_13530(vm.f32(4.8), 1.75, var7, var18, 30.0, 30.0, 30)
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
				monster.SetPlacePos(pos_x, var20 + 30.0, pos_z)
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
				helper_13d20(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), var5, var22, 30.0, 30.0, 60)
				var23 = monster.GetRndf(180.0) or var23
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					var23 = vm.f32(var23 * -1.0)
				end
				helper_154d7e30(var23, vm.f32(4.8))
				monster.SetMos("立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.VPush2(0, 8)
				monster.SetMos("立ち", -1, 0)
				var1 = helper_97f462c5(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.GetRnd(100) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
			return
		end
	end
	argc = monster.GetRnd(100) or argc
	if argc < 40 then
		argc = monster.GetRnd(100) or argc
		if argc < 80 then
			monster.VPush2(0, 8)
			monster.SetMos("立ち", -1, 0)
			helper_97f462c5(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.VPush2(0, 16)
			var7 = monster.GetRndf(180.0) or var7
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.SetMos("歩き", -1, 0)
			helper_154d7e30(var7, vm.f32(4.8))
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
					var1 = helper_13180(1.75, vm.f32(4.8), var24, var25, 30.0, 30.0, 60)
					var27 = monster.GetRndf(360.0) or var27
					argc = monster.GetRnd(100) or argc
					if argc < 50 then
						var27 = vm.f32(var27 * -1.0)
					end
					helper_154d7e30(var27, vm.f32(4.8))
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
					helper_138bc(1.75, var7, 1000.0, 30.0, 30.0, 60)
					monster.SetMos("立ち", -1, 0)
				end
			else
				monster.VPush2(0, 8)
				monster.SetMos("立ち", -1, 0)
				var1 = helper_97f462c5(100.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			helper_12cec(1.75, vm.f32(4.8), var5, 360.0, 40.0, 30.0, 30.0, argc)
			monster.SetMos("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_20d74()
	local var0: s32 = 0
	local argc: s32 = 0
	monster.SetMos("走り", -1, 0)
	var0 = helper_120d0(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 60)
	if var0 < 55 and var0 ~= 1 then
		helper_1a260()
	end
	monster.SetMos("立ち", -1, 0)
	argc = monster.GetRnd(100) or argc
	if argc < 70 then
		helper_1ac1c()
	end
end

--- Helper function.
local function helper_1bdf8()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local var6: s32 = 0
	local gekirin: s32 = 0
	monster.GetMonsterLife()
	while true do
		helper_274f6d9a()
		gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.GetPriority() or priority
		if priority > 5 then
			helper_1b8f4()
			continue
		end
		var3 = helper_e2fdabb9(var3)
		if var3 < 120.0 then
			argc = monster.GetRnd(100) or argc
			if argc < 90 then
				monster.SetMos("走り", -1, 0)
				var6 = helper_120d0(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 60)
				if var6 < 55 and var6 ~= 1 then
					helper_1a260()
				end
				monster.SetMos("立ち", -1, 0)
				helper_1a78c()
			else
				helper_1ac1c()
			end
		else
			argc = monster.GetRnd(100) or argc
			if argc < 80 then
				helper_1ac1c()
			else
				monster.SetMos("走り", -1, 0)
				var6 = helper_120d0(vm.f32(7.4), vm.f32(4.8), 30.0, 10.0, 0, 90)
				if var6 < 85 and var6 ~= 1 then
					helper_1a260()
				end
				monster.SetMos("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_2102c()
	local var0: f32 = 0
	local var2: f32 = 0
	local gekirin: s32 = 0
	var0 = monster.GetTargetDist() or var0
	gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
	if gekirin > 0 then
		helper_197dc()
		if helper_a25c5b2e() == 0 then
			var0 = helper_e2fdabb9(var0)
			if var0 < 290.0 then
				helper_65eb2b74(0)
				helper_1e494()
			else
				helper_16c40()
			end
		else
			var2 = helper_243517f2(var2)
			if var0 < var2 then
				if var0 < 180.0 then
					helper_65eb2b74(0)
					helper_1e494()
				else
					helper_20d74()
				end
			else
				helper_65eb2b74(0)
			end
		end
	else
		helper_1bdf8()
	end
end

--- Helper function.
local function helper_15860()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	helper_442b9962()
	helper_274f6d9a()
	helper_317bfc18(0)
	monster.SetActStatus(1)
end

--- Helper function.
local function helper_168b0()
	while true do
		helper_274f6d9a()
	end
end

--- Helper function.
local function helper_16960()
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_c0339fe8(10)
	helper_317bfc18(1)
	monster.ResetMotion()
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
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.SetDmg2("Ｍ連撃２", 3.5, "攻撃１", 0.288, 0.408, 0)
	monster.SetDmg2("Ｍ連撃２", 3.5, "攻撃１", 0.288, 0.408, 1)
	monster.SetDmg2("Ｍ連撃２", 3.5, "攻撃１", 0.432, 0.696, 0)
	monster.SetDmg2("Ｍ連撃２", 3.5, "攻撃１", 0.432, 0.696, 1)
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		if helper_19c20() ~= 0 then
			var1 = monster.LoadEffectScript("火弾Ｆ", get_not_used_texb) or var1
			var2 = monster.LoadEffectScript("火弾Ｌ３", get_not_used_texb) or var2
			var3 = monster.LoadEffectScript("火弾Ｈ", get_not_used_texb) or var3
		end
		if helper_19d60() ~= 0 then
			var1 = monster.LoadEffectScript("氷弾Ｆ", get_not_used_texb) or var1
			var2 = monster.LoadEffectScript("氷弾Ｌ２", get_not_used_texb) or var2
			var3 = monster.LoadEffectScript("氷弾Ｈ", get_not_used_texb) or var3
		end
		if helper_19ea0() ~= 0 then
			var1 = monster.LoadEffectScript("雷弾Ｆ", get_not_used_texb) or var1
			var2 = monster.LoadEffectScript("雷弾Ｌ２", get_not_used_texb) or var2
			var3 = monster.LoadEffectScript("雷弾Ｈ", get_not_used_texb) or var3
		end
		if helper_19fe0() ~= 0 then
			var1 = monster.LoadEffectScript("水弾Ｆ", get_not_used_texb) or var1
			var2 = monster.LoadEffectScript("水弾Ｌ２", get_not_used_texb) or var2
			var3 = monster.LoadEffectScript("水弾Ｈ", get_not_used_texb) or var3
		end
		if helper_1a120() ~= 0 then
			var1 = monster.LoadEffectScript("風弾Ｆ", get_not_used_texb) or var1
			var2 = monster.LoadEffectScript("風弾Ｌ２", get_not_used_texb) or var2
			var3 = monster.LoadEffectScript("風弾Ｈ", get_not_used_texb) or var3
		end
		if (if (if var1 ~= 0 then 1 else var2) ~= 0 then 1 else var3) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.SetPos(pos_x, pos_y + 20.0, pos_z)
	helper_1be0f106()
	helper_ac26cdde(45.0)
	helper_30d8()
	monster.VPush(0, 0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		helper_274f6d9a()
		helper_2102c()
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
		helper_274f6d9a()
	end
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_fbc2528f()
	helper_c0339fe8(12)
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_15860()
	monster.SetMos("吹っ飛び", -1, 6)
	monster.BlowStart(3.0, 0.05, 20)
	helper_fbc2528f()
	monster.SetActStatus(1)
	helper_c0339fe8(30)
	monster.SetActStatus(0)
	monster.SetMos("起き上がり", -1, 6)
	helper_fbc2528f()
	monster.SetMos("立ち")
	helper_905c94a1()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.SetMos("ガード", -1, 0)
	monster.BlowStart(3.0, 0.0, 2)
	helper_c0339fe8(8)
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.GetTargetAngle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.SetRot(0.0, var0, 0.0)
	helper_274f6d9a()
	monster.SetMos("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.GetTargetAngle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.SetRot(0.0, var0, 0.0)
	helper_274f6d9a()
	monster.SetMos("歩き", -1, 0)
	helper_708ce460(vm.f32(4.8))
	monster.SetMos("立ち", -1, 0)
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
	while true do
		helper_274f6d9a()
	end
	helper_168b0()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	helper_16960()
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_c0339fe8(10)
	monster.ResetMotion()
	monster.SetMos("起き上がり", -1, 6)
	helper_fbc2528f()
	helper_2e729f21()
	var3 = helper_57b569a8(var3)
	helper_274f6d9a()
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.SetPos(pos_x, var3 + 10.0, pos_z)
	helper_274f6d9a()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local height: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	helper_d30a9fa2()
	monster.SetAttrib(4, 0)
	monster.SetAttrib(8, 0)
	monster.SetMos("吹っ飛び", -1, 6)
	while true do
		height = monster.GetHigh() or height
		if height < 10.0 then
			break
		else
			helper_274f6d9a()
			var4 = monster.CheckMosEnd() or var4
			if var4 ~= 0 then
				break
			end
		end
	end
	monster.SetMos("起き上がり", -1, 6)
	while true do
		height = monster.GetHigh() or height
		if height < 10.0 then
			break
		else
			helper_274f6d9a()
			var4 = monster.CheckMosEnd() or var4
			if var4 ~= 0 then
				break
			end
		end
	end
	monster.SetAttrib(4, 1)
	monster.SetAttrib(8, 1)
	var5 = helper_57b569a8(var5)
	helper_274f6d9a()
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.SetPos(pos_x, var5 + 10.0, pos_z)
	helper_274f6d9a()
	helper_e05438b5()
end

return script
