--!strict
-- dungeon/monster/e213a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1029a353 = require("@lib/monster/helper_1029a353")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_19658e9b = require("@lib/monster/helper_19658e9b")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1be0f106 = require("@lib/monster/helper_1be0f106")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_211db10d = require("@lib/monster/helper_211db10d")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_28faa04b = require("@lib/monster/helper_28faa04b")
local helper_2db2fc96 = require("@lib/monster/helper_2db2fc96")
local helper_2e729f21 = require("@lib/monster/helper_2e729f21")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_57db7062 = require("@lib/monster/helper_57db7062")
local helper_59867820 = require("@lib/monster/helper_59867820")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_7c8e4fcc = require("@lib/monster/helper_7c8e4fcc")
local helper_83dc8947 = require("@lib/monster/helper_83dc8947")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_905c94a1 = require("@lib/monster/helper_905c94a1")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aada6ba2 = require("@lib/monster/helper_aada6ba2")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_de1504df = require("@lib/monster/helper_de1504df")
local helper_e2fdabb9 = require("@lib/monster/helper_e2fdabb9")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")

--- Helper function.
local function helper_2f8c()
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
local function helper_10838(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
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
		if var22 >= 45.0 or var22 <= 0.0 then
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
		helper_b9fff8e1()
	end
	return 0
end

--- Helper function.
local function helper_192cc(arg0: any)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local chara_id: s32 = 0
	monster.SetMos("前立ち", -1, 4)
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	helper_10838(pos_x, 25.0, pos_z, 0.875, 10.0, 5.0, 150)
	while true do
		helper_b9fff8e1()
		chara_id = monster.GetUserMonsId() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(90.0) == 0 then
				monster.SetMos("前歩き", -1, 0)
				helper_83e135e0(vm.f32(4.8))
			end
			monster.SetMos("前立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_196c0()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	chara_id = monster.GetUserMonsId() or chara_id
	if chara_id > -1 then
		helper_192cc(monster_id)
	end
end

--- Helper function.
local function helper_11f84(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
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
		if var20 >= 45.0 or var20 <= 0.0 then
			var10 = vm.f32(var10 - var16)
			var16 = 0.0
		end
		var18 = monster.GetDistVector2(var9, var10, var11, var6, var7, var8) or var18
		if var18 < vm.f32(arg0 + arg2) then
			return
		end
		var22 = helper_de1504df(var9, var10, var11, arg0, var13)
		if var22 ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.SetPos(var9, var10, var11)
		if arg4 ~= 0 then
			monster.SetRot(var12, var13, var14)
		else
			monster.SetRot(0.0, var13, 0.0)
		end
		helper_b9fff8e1()
	end
end

--- Helper function.
local function helper_13034(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
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
	helper_179581d3(helper_28452e16(arg2), arg1)
	helper_442b9962()
	var18 = helper_10838(var7, var8, var9, arg0, arg4, arg5, arg6)
	return var18
end

--- Helper function.
local function helper_19b14()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		var3 = monster.GetRndf(30.0) or var3
		var4 = monster.GetRndf(30.0) or var4
		var4 = vm.f32(var4 + 100.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.SetMos("前歩き", -1, 0)
		helper_13034(2.0, 3.0, var3, var4, 30.0, 45.0, 50)
		helper_83e135e0(3.0)
		monster.SetMos("前立ち", -1, 0)
	else
		monster.SetMos("前立ち", -1, 0)
		helper_e62edeb2(30.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_1bbfc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local height: f32 = 0
	monster.SetMos("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	helper_83e135e0(6.0)
	var11 = monster.GetTargetDist() or var11
	if var11 < 45.0 then
	else
	end
	monster.SetMos("歩き", -1, 0)
	helper_83e135e0(3.0)
	monster.SetMos("走り", -1, 0)
	helper_11f84(vm.f32(7.4), 6.0, 25.0, 5.0, 0, 75)
	monster.SetMos("攻撃１", -1, 6)
	helper_cbe4d8e2()
	var9 = monster.GetTargetAngle() or var9
	monster.GetTargetPos()
	monster.SetRot(0.0, var9, 0.0)
	helper_b9fff8e1()
	var9 = vm.f32(var9 + vm.f32(3.1415927))
	if var9 > vm.f32(3.1415927) then
		var9 = vm.f32(var9 - vm.f32(6.2831855))
	end
	if var9 <= vm.f32(-3.1415927) then
		var9 = vm.f32(var9 + vm.f32(6.2831855))
	end
	height = monster.GetHigh() or height
	var0 = vm.f32(var0 + vm.f32(vm.sin(var9) * 150.0))
	var1 = vm.f32(height + 45.0)
	var2 = vm.f32(var2 + vm.f32(vm.cos(var9) * 150.0))
	monster.SetMos("歩き", -1, 0)
	helper_10838(var0, var1, var2, 4.0, 6.0, 45.0, 30)
	monster.SetMos("立ち", -1, 0)
end

--- Helper function.
local function helper_1c65c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local attack: s32 = 0
	local grade: s32 = 0
	monster.VPush(0, 2)
	var9 = 10.0
	monster.SetMos("歩き", -1, 0)
	helper_83e135e0(6.0)
	monster.SetMos("攻撃２", -1, 6)
	helper_19658e9b(3.0, vm.f32(0.428), vm.f32(0.02))
	attack = monster.GetBaseAttack_1() or attack
	do
		local out1, out2, out3 = monster.GetFramePos("col_magic")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var1 = vm.f32(var1 + 20.0)
	do
		local out1, out2, out3 = monster.SubVector(var0, var1, var2, pos_x, pos_y, pos_z)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	grade = monster.GetMonsGrade_2(-1) or grade
	if grade == 0 then
		monster.EsmCreate_1("火弾Ｌ３")
	end
	if grade == 1 then
		monster.EsmCreate_1("風弾Ｌ２")
	end
	if grade == 2 then
		monster.EsmCreate_1("氷弾Ｌ２")
	end
	if grade == 3 then
		monster.EsmCreate_1("雷弾Ｌ２")
	end
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var0, var1, var2)
	monster.EsmSetValue(-1, 0, attack)
	monster.EsmSetValueFloat(-1, 1, var9)
	helper_b9fff8e1()
	helper_cbe4d8e2()
	monster.SetMos("立ち", -1, 0)
	helper_ee5b84d4(9)
end

--- Helper function.
local function helper_1e40c()
	local var0: f32 = 0
	local var1: f32 = 0
	local argc: s32 = 0
	local var4: f32 = 0
	print("far----------------\n")
	argc = monster.GetRnd(100) or argc
	if argc < 90 then
		monster.SetMos("歩き", -1, 0)
		helper_83e135e0(3.0)
		monster.SetMos("走り", -1, 0)
		helper_11f84(vm.f32(7.4), 6.0, 30.0, 5.0, 0, 120)
		monster.SetMos("立ち", -1, 0)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			monster.SetMos("歩き", -1, 0)
			var1 = monster.GetTargetDist() or var1
			monster.GetRndf(360.0) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
			helper_13034(2.0, 3.0, var0, var1, 30.0, 45.0, 50)
			monster.SetMos("立ち", -1, 0)
		else
			monster.SetMos("歩き", -1, 0)
			helper_11f84(2.0, 3.0, 30.0, 45.0, 0, 30)
			monster.SetMos("立ち", -1, 0)
		end
	end
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		var4 = monster.GetTargetDist() or var4
		if var4 < 50.0 then
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				helper_1bbfc()
			else
				helper_1c65c()
			end
		else
			helper_1c65c()
		end
	end
end

--- Helper function.
local function helper_1dcd4()
	local var0: f32 = 0
	local var1: f32 = 0
	local argc: s32 = 0
	print("mid----------------\n")
	helper_1c65c()
	argc = monster.GetRnd(100) or argc
	if argc < 90 then
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			monster.SetMos("歩き", -1, 0)
			helper_11f84(2.0, 3.0, 30.0, 45.0, 0, 30)
			helper_1c65c()
			monster.SetMos("立ち", -1, 0)
		else
			monster.SetMos("歩き", -1, 0)
			helper_83e135e0(3.0)
			monster.SetMos("走り", -1, 0)
			helper_11f84(vm.f32(7.4), 6.0, 30.0, 5.0, 0, 90)
		end
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			monster.SetMos("立ち", -1, 0)
			helper_e62edeb2(30.0, 45.0, 45)
		else
			monster.SetMos("歩き", -1, 0)
			var1 = monster.GetTargetDist() or var1
			var0 = monster.GetRndf(360.0) or var0
			helper_13034(2.0, 3.0, var0, var1, 30.0, 45.0, 50)
			monster.SetMos("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_14188(arg0: f32, arg1: f32, arg2: f32, arg3: s32, arg4: s32)
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
	helper_10838(pos_x, pos_y, pos_z, arg0, arg1, arg2, arg4)
end

--- Helper function.
local function helper_145c8(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
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
	helper_10838(pos_x, pos_y, pos_z, arg0, arg1, arg2, arg3)
end

--- Helper function.
local function helper_1d584()
	local var0: f32 = 0
	local argc: s32 = 0
	local var3: s32 = 0
	print("near----------------\n")
	helper_1c65c()
	var0 = helper_e2fdabb9(var0)
	if var0 < 70.0 then
		argc = monster.GetRnd(100) or argc
		if argc < 90 then
			helper_1bbfc()
			monster.SetMos("立ち", -1, 0)
		end
	end
	argc = monster.GetRnd(100) or argc
	if argc < 80 then
		helper_1bbfc()
		monster.SetMos("立ち", -1, 0)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				var3 = 1
			else
				var3 = 0
			end
			monster.SetMos("歩き", -1, 0)
			helper_83e135e0(3.0)
			helper_14188(1.0, 30.0, 45.0, var3, 45)
			helper_83e135e0(3.0)
			monster.SetMos("立ち", -1, 0)
		else
			monster.SetMos("歩き", -1, 0)
			helper_83e135e0(3.0)
			helper_145c8(1.0, 30.0, 45.0, 45)
			helper_83e135e0(3.0)
			monster.SetMos("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_1ec1c()
	local var3: f32 = 0
	local priority: s32 = 0
	helper_196c0()
	priority = monster.GetPriority() or priority
	if priority > 5 then
		helper_19b14()
		return
	end
	var3 = helper_e2fdabb9(var3)
	if var3 < 290.0 and var3 >= 160.0 then
		helper_1e40c()
	elseif var3 < 160.0 and var3 >= 100.0 then
		helper_1dcd4()
	else
		helper_1d584()
	end
end

--- Helper function.
local function helper_133e4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	helper_179581d3(arg2, arg0)
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
	local _ = helper_10838(pos_x, pos_y, pos_z, arg1, arg4, arg5, arg6)
end

--- Helper function.
local function helper_13bd4(
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
	helper_179581d3(helper_28452e16(arg6), arg4)
	helper_442b9962()
	local _ = helper_10838(var10, var11, var12, arg3, arg7, arg8, arg9)
end

--- Helper function.
local function helper_13770(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
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
	local _ = helper_10838(pos_x, pos_y, pos_z, arg0, arg3, arg4, arg5)
end

--- Helper function.
local function helper_12ba0(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	var15 = monster.GetRndf(arg4) or var15
	var16 = monster.GetRndf(arg3) or var16
	var15 = vm.f32(var15 + arg2)
	helper_179581d3(var16, arg1)
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
	local _ = helper_10838(pos_x, pos_y, pos_z, arg0, arg5, arg6, arg7)
end

--- Helper function.
local function helper_16af4()
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
	helper_b9fff8e1()
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
		monster.SetMos("前歩き", -1, 0)
		helper_179581d3(var7, vm.f32(4.8))
		var18 = monster.SearchArea(100.0, 0.0) or var18
		var18 = vm.f32(var18 - 30.0)
		if var18 > 0.0 then
			helper_133e4(vm.f32(4.8), 1.75, var7, var18, 30.0, 45.0, 30)
		end
		monster.SetMos("前立ち", -1, 0)
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
				monster.SetPlacePos(pos_x, var20 + 45.0, pos_z)
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
				monster.SetMos("前歩き", -1, 0)
				helper_13bd4(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), var5, var22, 30.0, 45.0, 60)
				var23 = monster.GetRndf(180.0) or var23
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					var23 = vm.f32(var23 * -1.0)
				end
				helper_179581d3(var23, vm.f32(4.8))
				monster.SetMos("前立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.VPush2(0, 8)
				monster.SetMos("前立ち", -1, 0)
				var1 = helper_57db7062(100.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			monster.SetMos("前立ち", -1, 0)
			helper_57db7062(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.VPush2(0, 16)
			var7 = monster.GetRndf(180.0) or var7
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.SetMos("前歩き", -1, 0)
			helper_179581d3(var7, vm.f32(4.8))
			monster.SetMos("前立ち", -1, 0)
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
					monster.SetMos("前歩き", -1, 0)
					var1 = helper_13034(1.75, vm.f32(4.8), var24, var25, 30.0, 45.0, 60)
					var27 = monster.GetRndf(360.0) or var27
					argc = monster.GetRnd(100) or argc
					if argc < 50 then
						var27 = vm.f32(var27 * -1.0)
					end
					helper_179581d3(var27, vm.f32(4.8))
					monster.SetMos("前立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.VPush2(0, 32)
					monster.SetMos("前歩き", -1, 0)
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
					helper_13770(1.75, var7, 1000.0, 30.0, 45.0, 60)
					monster.SetMos("前立ち", -1, 0)
				end
			else
				monster.VPush2(0, 8)
				monster.SetMos("前立ち", -1, 0)
				var1 = helper_57db7062(100.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			monster.SetMos("前歩き", -1, 0)
			helper_12ba0(1.75, vm.f32(4.8), var5, 360.0, 40.0, 30.0, 45.0, argc)
			monster.SetMos("前立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_1ef0c()
	monster.SetMos("歩き", -1, 0)
	helper_83e135e0(3.0)
	monster.SetMos("走り", -1, 0)
	helper_11f84(vm.f32(7.4), 6.0, 50.0, 5.0, 0, 120)
	monster.SetMos("立ち", -1, 0)
end

--- Helper function.
local function helper_1cff8()
	local gekirin: s32 = 0
	local argc: s32 = 0
	local var2: f32 = 0
	gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
	if gekirin > 0 then
		return
	end
	var2 = helper_e2fdabb9(var2)
	if var2 < 100.0 then
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			helper_1bbfc()
		else
			helper_1c65c()
		end
	else
		var2 = helper_e2fdabb9(var2)
		if var2 < 160.0 then
			argc = monster.GetRnd(100) or argc
			if argc < 40 then
				helper_1c65c()
			else
				monster.SetMos("走り", -1, 0)
				helper_11f84(vm.f32(7.4), 3.0, 30.0, 10.0, 0, 90)
				monster.SetMos("立ち", -1, 0)
			end
		else
			monster.SetMos("走り", -1, 0)
			helper_11f84(vm.f32(7.4), 3.0, 30.0, 10.0, 0, 90)
			monster.SetMos("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_16814()
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_ee5b84d4(10)
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
	local grade: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	monster.SetDmg2("通常攻撃", 3.0, "攻撃１", 0.28, 0.4, 0)
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		grade = monster.GetMonsGrade_2(-1) or grade
		if grade == 0 then
			var1 = monster.LoadEffectScript("火弾Ｌ３", get_not_used_texb) or var1
			var2 = monster.LoadEffectScript("火弾Ｈ", get_not_used_texb) or var2
		end
		if grade == 1 then
			var1 = monster.LoadEffectScript("風弾Ｌ２", get_not_used_texb) or var1
			var2 = monster.LoadEffectScript("風弾Ｈ", get_not_used_texb) or var2
		end
		if grade == 2 then
			var1 = monster.LoadEffectScript("氷弾Ｌ２", get_not_used_texb) or var1
			var2 = monster.LoadEffectScript("氷弾Ｈ", get_not_used_texb) or var2
		end
		if grade == 3 then
			var1 = monster.LoadEffectScript("雷弾Ｌ２", get_not_used_texb) or var1
			var2 = monster.LoadEffectScript("雷弾Ｈ", get_not_used_texb) or var2
		end
		if (if var1 ~= 0 then 1 else var2) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	monster.VPush(0, 0)
	monster.VPush(7, 2)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.GetPlacePos_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	monster.SetPos(pos_x, pos_y + 45.0, pos_z)
	monster.SetPlacePos(place_pos_x, place_pos_y + 45.0, place_pos_z)
	helper_1029a353()
	helper_1be0f106()
	helper_ac26cdde(55.0)
	helper_2f8c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local gekirin: s32 = 0
	local value: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		helper_b9fff8e1()
		gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
		if gekirin > 0 then
			if helper_a25c5b2e() == 0 then
				helper_196c0()
				var4 = helper_e2fdabb9(var4)
				if var4 < 290.0 then
					value = monster.VPop(7) or value
					if value == 2 then
						monster.VPush(7, 1)
						monster.SetMos("前歩き", -1, 0)
						helper_83e135e0(3.0)
						helper_11f84(2.0, 3.0, 30.0, 45.0, 0, 75)
						monster.SetMos("変身", -1, 2)
						helper_cbe4d8e2()
					end
					helper_1ec1c()
				else
					if value ~= 2 then
						value = monster.VPop(7) or value
						monster.VPush(7, 2)
						monster.SetMos("前立ち", -1, 6)
						helper_cbe4d8e2()
					end
					helper_16af4()
					monster.VPush(7, 1)
				end
			else
				var5 = helper_243517f2(var5)
				if var4 < var5 then
					if var4 < 160.0 then
						helper_65eb2b74(0)
						helper_1ec1c()
					else
						helper_1ef0c()
					end
				else
					helper_65eb2b74(0)
				end
			end
		else
			helper_1cff8()
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
		helper_b9fff8e1()
	end
	monster.SetMos("前立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_28faa04b()
	monster.SetMos("ダメージ", -1, 6)
	helper_cbe4d8e2()
	helper_ee5b84d4(12)
	monster.SetMos("立ち", -1, 0)
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_7c8e4fcc()
	helper_1029a353()
	monster.SetMos("ダメージ", -1, 6)
	helper_cbe4d8e2()
	helper_ee5b84d4(12)
	monster.SetMos("立ち", -1, 0)
	helper_905c94a1()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	helper_1029a353()
	monster.SetMos("歩き", -1, 0)
	helper_83e135e0(15.0)
	helper_442b9962()
	monster.SetMos("ガード", -1, 0)
	helper_ee5b84d4(8)
	monster.SetMos("立ち")
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_1029a353()
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	helper_1029a353()
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_83dc8947()
	helper_1029a353()
	monster.SetMos("死に", -1, 6)
	helper_56d63eae()
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_2db2fc96()
	monster.SetMos("じたばた", -1, 4)
	while true do
		helper_b9fff8e1()
	end
	helper_211db10d()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_16814()
	monster.SetMos("起き上がり", -1, 6)
	helper_cbe4d8e2()
	helper_2e729f21()
	monster.SetMos("歩き", -1, 0)
	helper_b9fff8e1()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_59867820()
	helper_1029a353()
	monster.SetMos("吹っ飛び", -1, 6)
	helper_cbe4d8e2()
	monster.SetMos("起き上がり", -1, 6)
	helper_cbe4d8e2()
	helper_aada6ba2()
	monster.SetMos("歩き", -1, 0)
end

return script
