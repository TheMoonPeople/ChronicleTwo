--!strict
-- dungeon/monster/b06a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_1029a353 = require("@lib/monster/helper_1029a353")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b33c6f49 = require("@lib/monster/helper_b33c6f49")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_de1504df = require("@lib/monster/helper_de1504df")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

--- Helper function.
local function helper_1dc70()
	for var0 = 0, 5 do
		monster.VPush(12 + var0, 999999)
	end
end

--- Helper function.
local function helper_1f5c()
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
local function helper_18c8()
	local value: s32 = 0
	local life: f32 = 0
	life = 0.0
	life = monster.GetMonsterLife() or life
	if life < 0.5 then
		value = monster.VPop(8) or value
		if value == 0 then
			monster.MySeStop(4)
			monster.MySeStop(5)
			monster.MySeStop(7)
			monster.MySeStop(15)
			monster.MySeStop(39)
			monster.VPush(8, 1)
			monster.RunEventScript(502)
		end
	end
end

--- Helper function.
local function helper_1c00()
	helper_18c8()
end

--- Helper function.
local function helper_1c74()
	helper_1c00()
	vm.wait()
end

--- Helper function.
local function helper_1e34()
	local var0: s32 = 0
	while true do
		helper_1c74()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_1cf4(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_1c74()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_182a4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local argc: s32 = 0
	local chara_type: s32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	monster.VPush(13, 1)
	monster.SetAttrib(32, 1)
	chara_type = monster.GetUserid() or chara_type
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.EsmCreate_1("サンワープ")
	monster.EsmSetVect1(-1, pos_x, pos_y + 8.0, pos_z)
	monster.EsmSetUserId(-1, chara_type)
	monster.SetMos("テレポート飛び", -1, 2)
	helper_1e34()
	monster.SetMos("テレポート中", -1, 4)
	helper_1cf4(15)
	monster.SetModelLightSwitch(0)
	var9 = 128.0
	var10 = 0
	while var10 < 15 do
		monster.SetModelLightColor(128.0, 128.0, 128.0, var9)
		var9 = vm.f32(var9 - vm.f32(8.533334))
		helper_1c74()
		var10 = var10 + 1
	end
	monster.SetModelLightSwitch(1)
	var3 = monster.GetTargetAngle() or var3
	argc = monster.GetRnd(9) or argc
	if argc == 0 then
		var0 = vm.f32(-327.07)
		var1 = 35.0
		var2 = vm.f32(309.72)
	end
	if argc == 1 then
		var0 = vm.f32(-108.6)
		var1 = 35.0
		var2 = vm.f32(483.43)
	end
	if argc == 2 then
		var0 = -19.5
		var1 = 35.0
		var2 = vm.f32(478.12)
	end
	if argc == 3 then
		var0 = vm.f32(169.15)
		var1 = 35.0
		var2 = vm.f32(330.21)
	end
	if argc == 4 then
		var0 = 269.25
		var1 = 35.0
		var2 = vm.f32(305.36)
	end
	if argc >= 5 then
		var0 = 0.0
		var1 = 35.0
		var2 = 120.0
	end
	monster.SetPos(var0, var1, var2)
	helper_1c74()
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.SetMos("テレポート着地", -1, 6)
	var3 = monster.GetTargetAngle() or var3
	monster.SetRot(0.0, var3, 0.0)
	helper_1c74()
	monster.SetModelLightSwitch(0)
	var9 = 0.0
	var10 = 0
	while var10 < 28 do
		monster.SetModelLightColor(128.0, 128.0, 128.0, var9)
		var9 = vm.f32(var9 + vm.f32(4.571429))
		helper_1c74()
		var10 = var10 + 1
	end
	monster.SetModelLightColor(128.0, 128.0, 128.0, 128.0)
	monster.SetModelLightSwitch(1)
	monster.SetAttrib(32, 0)
	monster.VPush(13, 0)
end

--- Helper function.
local function helper_2d88(arg0: f32, arg1: f32, arg2: f32)
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
			helper_1c74()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_5cb0(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.GetTargetAngle() or var5
	local _ = helper_2d88(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_4c38(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	if arg1 == -1.0 then
		arg1 = vm.f32(0.03)
	end
	var3 = 0
	while true do
		helper_1c74()
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
local function helper_bc34(arg0: f32, arg1: s32)
	local var2: f32 = 0
	local _ = helper_787df986(arg0)
	for var4 = 0, arg1 - 1 do
		var2 = monster.GetTargetAngle() or var2
		monster.SetNextRot(var2, arg0)
		helper_1c74()
	end
	helper_442b9962()
end

--- Helper function.
local function helper_1ddf8()
	local value: s32 = 0
	for var0 = 0, 5 do
		value = monster.VPop(12 + var0) or value
		if value ~= 999999 then
			monster.EsmFinish(value)
			monster.VPush(12 + var0, 999999)
		end
	end
end

--- Helper function.
local function helper_1e138(arg0: any)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local attack: s32 = 0
	local var9: s32 = 0
	local var10: { s32 } = table.create(6, 0)
	var9 = 30
	var7 = 15.0
	attack = monster.GetBaseAttack_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(0.45)))
	monster.SetIntFlag(2, 1)
	do
		local out1, out2, out3 = monster.GetPos_3()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	if var4 > -200.0 and var4 < 200.0 then
		var1 = vm.f32(-154.46)
		var2 = vm.f32(93.65)
		var3 = vm.f32(-29.71)
	end
	if var4 < -200.0 then
		var1 = vm.f32(-759.58)
		var2 = vm.f32(93.65)
		var3 = vm.f32(-0.93)
	end
	if var4 > 200.0 then
		var1 = vm.f32(760.43)
		var2 = vm.f32(93.65)
		var3 = vm.f32(-0.18)
	end
	var10[1] = monster.EsmCreate_2("バラ") or var10[1]
	monster.EsmSetVect1(var10[1], var1, var2 + 15.0, var3)
	monster.EsmSetVect2(var10[1], var4 + vm.f32(vm.sin(0.0) * 30.0), var5 + 15.0, var6 + vm.f32(vm.cos(0.0) * 30.0))
	monster.EsmSetValue(var10[1], 0, attack)
	monster.EsmSetValueFloat(var10[1], 1, var7)
	monster.EsmSetValue(var10[1], 2, var9)
	var10[2] = monster.EsmCreate_2("バラ") or var10[2]
	monster.EsmSetVect1(var10[2], var1, var2 + 15.0, var3)
	monster.EsmSetVect2(
		var10[2],
		var4 + vm.f32(vm.sin(vm.f32(1.0471976)) * 30.0),
		var5 + 15.0,
		var6 + vm.f32(vm.cos(vm.f32(1.0471976)) * 30.0)
	)
	monster.EsmSetValue(var10[2], 0, attack)
	monster.EsmSetValueFloat(var10[2], 1, var7)
	monster.EsmSetValue(var10[2], 2, var9)
	var10[3] = monster.EsmCreate_2("バラ") or var10[3]
	monster.EsmSetVect1(var10[3], var1, var2 + 15.0, var3)
	monster.EsmSetVect2(
		var10[3],
		var4 + vm.f32(vm.sin(vm.f32(2.0943952)) * 30.0),
		var5 + 15.0,
		var6 + vm.f32(vm.cos(vm.f32(2.0943952)) * 30.0)
	)
	monster.EsmSetValue(var10[3], 0, attack)
	monster.EsmSetValueFloat(var10[3], 1, var7)
	monster.EsmSetValue(var10[3], 2, var9)
	if var4 > -200.0 and var4 < 200.0 then
		var1 = vm.f32(153.97)
		var2 = vm.f32(93.65)
		var3 = vm.f32(-30.21)
	end
	if var4 < -200.0 then
		var1 = vm.f32(-713.73)
		var2 = vm.f32(93.65)
		var3 = vm.f32(-261.19)
	end
	if var4 > 200.0 then
		var1 = vm.f32(714.34)
		var2 = vm.f32(93.65)
		var3 = vm.f32(-260.45)
	end
	var10[4] = monster.EsmCreate_2("バラ") or var10[4]
	monster.EsmSetVect1(var10[4], var1, var2 + 15.0, var3)
	monster.EsmSetVect2(
		var10[4],
		var4 + vm.f32(vm.sin(vm.f32(3.1415927)) * 30.0),
		var5 + 15.0,
		var6 + vm.f32(vm.cos(vm.f32(3.1415927)) * 30.0)
	)
	monster.EsmSetValue(var10[4], 0, attack)
	monster.EsmSetValueFloat(var10[4], 1, var7)
	monster.EsmSetValue(var10[4], 2, var9)
	var10[5] = monster.EsmCreate_2("バラ") or var10[5]
	monster.EsmSetVect1(var10[5], var1, var2 + 15.0, var3)
	monster.EsmSetVect2(
		var10[5],
		var4 + vm.f32(vm.sin(vm.f32(4.1887903)) * 30.0),
		var5 + 15.0,
		var6 + vm.f32(vm.cos(vm.f32(4.1887903)) * 30.0)
	)
	monster.EsmSetValue(var10[5], 0, attack)
	monster.EsmSetValueFloat(var10[5], 1, var7)
	monster.EsmSetValue(var10[5], 2, var9)
	var10[6] = monster.EsmCreate_2("バラ") or var10[6]
	monster.EsmSetVect1(var10[6], var1, var2 + 15.0, var3)
	monster.EsmSetVect2(
		var10[6],
		var4 + vm.f32(vm.sin(vm.f32(5.2359877)) * 30.0),
		var5 + 15.0,
		var6 + vm.f32(vm.cos(vm.f32(1.0471976)) * 30.0)
	)
	monster.EsmSetValue(var10[6], 0, attack)
	monster.EsmSetValueFloat(var10[6], 1, var7)
	monster.EsmSetValue(var10[6], 2, var9)
	for var16 = 0, 5 do
		monster.VPush(12 + var16, var10[var16 + 1])
	end
	helper_1cf4(var9)
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	do
		local out1, out2, out3 = monster.GetPos_3()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var7 = 1.25
	monster.EsmSetVect1(var10[1], var4, var5 + 15.0, var6)
	monster.EsmSetValueFloat(var10[1], 1, var7)
	monster.EsmSetValue(var10[1], 7, 1)
	monster.EsmSetValueFloat(var10[1], 4, -0.043633234)
	monster.EsmSetValueFloat(var10[1], 5, 0.0)
	monster.EsmSetValueFloat(var10[1], 3, 0.043633234)
	monster.EsmSetVect1(var10[2], var4, var5 + 15.0, var6)
	monster.EsmSetValueFloat(var10[2], 1, var7)
	monster.EsmSetValue(var10[2], 7, 1)
	monster.EsmSetValueFloat(var10[2], 4, 0.043633234)
	monster.EsmSetValueFloat(var10[2], 5, 1.0471976)
	monster.EsmSetValueFloat(var10[2], 3, 0.043633234)
	monster.EsmSetVect1(var10[3], var4, var5 + 15.0, var6)
	monster.EsmSetValueFloat(var10[3], 1, var7)
	monster.EsmSetValue(var10[3], 7, 1)
	monster.EsmSetValueFloat(var10[3], 4, 0.043633234)
	monster.EsmSetValueFloat(var10[3], 5, 2.0943952)
	monster.EsmSetValueFloat(var10[3], 3, -0.043633234)
	monster.EsmSetVect1(var10[4], var4, var5 + 15.0, var6)
	monster.EsmSetValueFloat(var10[4], 1, var7)
	monster.EsmSetValue(var10[4], 7, 1)
	monster.EsmSetValueFloat(var10[4], 4, 0.043633234)
	monster.EsmSetValueFloat(var10[4], 5, 3.1415927)
	monster.EsmSetValueFloat(var10[4], 3, 0.043633234)
	monster.EsmSetVect1(var10[5], var4, var5 + 15.0, var6)
	monster.EsmSetValueFloat(var10[5], 1, var7)
	monster.EsmSetValue(var10[5], 7, 1)
	monster.EsmSetValueFloat(var10[5], 4, -0.043633234)
	monster.EsmSetValueFloat(var10[5], 5, 4.1887903)
	monster.EsmSetValueFloat(var10[5], 3, -0.043633234)
	monster.EsmSetVect1(var10[6], var4, var5 + 15.0, var6)
	monster.EsmSetValueFloat(var10[6], 1, var7)
	monster.EsmSetValue(var10[6], 7, 1)
	monster.EsmSetValueFloat(var10[6], 4, 0.043633234)
	monster.EsmSetValueFloat(var10[6], 5, 5.2359877)
	monster.EsmSetValueFloat(var10[6], 3, 0.043633234)
	monster.SetMos("歩き", -1.0, 0)
	helper_bc34(5.0, var9)
	monster.SetMos("歩き", -1.0, 0)
	helper_5cb0(5.0)
	monster.MySePlay(5)
	monster.SetMos("攻撃１", -1, 2)
	helper_4c38(vm.f32(0.453), -1.0)
	attack = monster.GetBaseAttack_1() or attack
	var7 = 20.0
	monster.MySePlay(6)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	monster.EsmSetVect2(var10[1], var4, var5 + 3.0, var6)
	monster.EsmSetValue(var10[1], 0, attack)
	monster.EsmSetValueFloat(var10[1], 1, var7)
	monster.EsmSetValue(var10[1], 2, 90)
	monster.EsmSetValue(var10[1], 7, 1)
	helper_1cf4(9)
	monster.MySePlay(6)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	monster.EsmSetVect2(var10[2], var4, var5 + 3.0, var6)
	monster.EsmSetValue(var10[2], 0, attack)
	monster.EsmSetValueFloat(var10[2], 1, var7)
	monster.EsmSetValue(var10[2], 2, 90)
	monster.EsmSetValue(var10[2], 7, 1)
	helper_1cf4(9)
	monster.MySePlay(6)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	monster.EsmSetVect2(var10[3], var4, var5 + 3.0, var6)
	monster.EsmSetValue(var10[3], 0, attack)
	monster.EsmSetValueFloat(var10[3], 1, var7)
	monster.EsmSetValue(var10[3], 2, 90)
	monster.EsmSetValue(var10[3], 7, 1)
	helper_1cf4(9)
	monster.MySePlay(6)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	monster.EsmSetVect2(var10[4], var4, var5 + 3.0, var6)
	monster.EsmSetValue(var10[4], 0, attack)
	monster.EsmSetValueFloat(var10[4], 1, var7)
	monster.EsmSetValue(var10[4], 2, 90)
	monster.EsmSetValue(var10[4], 7, 1)
	helper_1cf4(9)
	monster.MySePlay(6)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	monster.EsmSetVect2(var10[5], var4, var5 + 3.0, var6)
	monster.EsmSetValue(var10[5], 0, attack)
	monster.EsmSetValueFloat(var10[5], 1, var7)
	monster.EsmSetValue(var10[5], 2, 90)
	monster.EsmSetValue(var10[5], 7, 1)
	helper_1cf4(9)
	monster.MySePlay(6)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	monster.EsmSetVect2(var10[6], var4, var5 + 3.0, var6)
	monster.EsmSetValue(var10[6], 0, attack)
	monster.EsmSetValueFloat(var10[6], 1, var7)
	monster.EsmSetValue(var10[6], 2, 90)
	monster.EsmSetValue(var10[6], 7, 1)
	helper_1dc70()
	helper_1e34()
	monster.SetMos("立ち", -1, 0)
	helper_1cf4(30)
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	helper_1ddf8()
end

--- Helper function.
local function helper_50e0(arg0: f32, arg1: f32)
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
	local _ = helper_2d88(helper_28452e16(arg0), helper_28452e16(arg1), vm.f32(vm.fdiv(360.0, helper_28452e16(arg1))))
	helper_442b9962()
end

--- Helper function.
local function helper_198a4(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	if arg2 ~= 0.0 then
		arg3 = vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(arg0 - vm.f32(arg1 * arg2)) * 2.0), arg2)), arg2))
	else
		arg3 = 0.0
	end
	return arg3
end

--- Helper function.
local function helper_19438(arg0: f32, arg1: f32, arg2: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var11: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var6 = monster.GetDistVector2(pos_x, pos_y, pos_z, arg0, arg1, arg2) or var6
	var11 = monster.GetRefAngle(arg0, arg1, arg2) or var11
	if helper_de1504df(arg0, arg1, arg2, var6, var11) ~= 0 then
		return 0
	end
	if arg1 < 0.0 or arg1 > 50.0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_19a44(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: any, arg5: f32, arg6: any, arg7: any)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
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
	local var25: f32 = 0
	local var26: s32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = monster.SubVector(var11, var12, var13, pos_x, pos_y, pos_z)
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
	var14 = arg3
	var26 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var21 = monster.GetDistVector2(arg0, arg1, arg2, pos_x, pos_y, pos_z) or var21
	var25 = helper_198a4(var21, var14, vm.f32(vm.fdiv(vm.f32(vm.f32(var21 + arg5) * vm.f32(1.9)), var14)), var25)
	while var26 < arg7 do
		var14 = vm.f32(var14 + var25)
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.GetPos_3()
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		if pos_z < 92.0 then
			helper_182a4()
		end
		do
			local out1, out2, out3 = monster.CopyVector(var11, var12, var13)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var18, var19, var20, var14)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		do
			local out1, out2, out3 = monster.AddVector(var15, var16, var17, var18, var19, var20)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		if var14 < 0.0 then
			return
		end
		if helper_19438(var15, var16, var17) == 0 then
			return
		end
		monster.SetPos(var15, var16, var17)
		monster.CopyVector(var15, var16, var17)
		helper_1c74()
		var26 = vm.i32(var26 + 1)
	end
end

--- Helper function.
local function helper_1c190()
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local argc: s32 = 0
	argc = monster.GetRnd(7) or argc
	if argc == 0 then
		var3 = -159.75
		var4 = 35.0
		var5 = vm.f32(336.53)
	end
	if argc == 1 then
		var3 = vm.f32(27.98)
		var4 = 35.0
		var5 = vm.f32(390.28)
	end
	if argc == 2 then
		var3 = vm.f32(202.6)
		var4 = 35.0
		var5 = vm.f32(335.46)
	end
	if argc == 3 then
		var3 = vm.f32(19.08)
		var4 = 35.0
		var5 = vm.f32(170.05)
	end
	if argc >= 4 then
		var3 = vm.f32(0.26)
		var4 = 35.0
		var5 = 120.0
	end
	var6 = monster.GetRefAngle(var3, var4, var5) or var6
	monster.SetMos("歩き", -1.0, 0)
	if var6 > vm.f32(3.1415927) then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if var6 <= vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	helper_50e0(helper_28452e16(var6), 5.0)
	monster.SetMos("走り", -1.0, 0)
	helper_19a44(var3, var4, var5, vm.f32(9.8), vm.f32(9.8), 0.0, vm.f32(0.8), 180)
	helper_1029a353()
end

--- Helper function.
local function helper_22a58()
	local argc: s32 = 0
	local pos_y: f32 = 0
	monster.SetMos("歩き", -1.0, 0)
	helper_5cb0(5.0)
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	if pos_y > 45.0 then
		monster.MySePlay(4)
		monster.SetMos("攻撃１in", -1, 2)
		helper_4c38(vm.f32(0.328), -1.0)
		argc = monster.GetRnd(90) or argc
		argc = vm.i32(argc + 90)
		helper_1e138(argc)
	else
		helper_1c190()
		return
	end
	monster.SetMos("立ち", -1, 0)
end

--- Helper function.
local function helper_24610()
	local value: s32 = 0
	value = monster.VPop(11) or value
	monster.VPush(11, vm.i32(value + 1))
	helper_18c8()
	helper_182a4()
	helper_22a58()
end

--- Helper function.
local function helper_1bb18(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: any, arg6: any)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local pos_y: f32 = 0
	local height: f32 = 0
	var7, var8, var9 = helper_125e5305(arg2, arg3, var7, var8, var9)
	monster.GetTargetPos()
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	arg2 = monster.GetRefAngle(var7, var8, var9) or arg2
	if arg2 > vm.f32(3.1415927) then
		arg2 = vm.f32(arg2 - vm.f32(6.2831855))
	end
	if arg2 <= vm.f32(-3.1415927) then
		arg2 = vm.f32(arg2 + vm.f32(6.2831855))
	end
	helper_50e0(helper_28452e16(arg2), arg1)
	helper_442b9962()
	monster.SetMos("走り", -1.0, 0)
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	height = monster.GetHigh() or height
	height = vm.f32(pos_y - height)
	arg4 = vm.f32(arg4 + height)
	helper_19a44(var7, arg4, var9, arg0, arg0, 0.0, vm.f32(0.8), 180)
	monster.ResetMove()
end

--- Helper function.
local function helper_24130()
	local var0: f32 = 0
	local argc: s32 = 0
	local value: s32 = 0
	local var3: f32 = 0
	value = monster.VPop(11) or value
	monster.VPush(11, vm.i32(value + 1))
	helper_18c8()
	helper_1c190()
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		var3 = monster.GetRndf(60.0) or var3
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		var0 = monster.GetTargetDist() or var0
		monster.SetMos("歩き", -1, 0)
		helper_1bb18(10.0, 5.0, var3, var0, 80.0, 35.0, 30)
		helper_5cb0(5.0)
		monster.SetMos("立ち", -1, 0)
		helper_1cf4(3)
	end
	helper_22a58()
end

--- Helper function.
local function helper_1a580(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: s32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	helper_5cb0(5.0)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	helper_19a44(var5, var6, var7, arg0, arg0, arg2, arg3, arg4)
end

--- Helper function.
local function helper_1d59c()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	attack = monster.GetBaseAttack_1() or attack
	monster.SetMos("歩き", -1.0, 0)
	helper_5cb0(5.0)
	monster.SetMos("走り", 0.75, 0)
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	helper_19a44(var4, var5, var6, 10.0, 10.0, 35.0, vm.f32(0.08), 180)
	monster.MySePlay(7)
	monster.ResetMotion()
	monster.SetMos("攻撃２", -1, 6)
	helper_bc34(5.0, 26)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.EsmCreate_1("サンの竜巻")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetValue(-1, 0, attack)
	helper_1e34()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetMos("立ち", -1, 0)
end

--- Helper function.
local function helper_23e30()
	local argc: s32 = 0
	local value: s32 = 0
	value = monster.VPop(11) or value
	monster.VPush(11, vm.i32(value + 1))
	helper_18c8()
	argc = monster.GetRnd(100) or argc
	if argc < 18 then
		monster.SetMos("歩き", -1.0, 0)
		helper_5cb0(5.0)
		monster.SetMos("走り", -1.0, 0)
		helper_1a580(30.0, 5.0, 35.0, vm.f32(0.8), 180)
		helper_1d59c()
	end
end

--- Helper function.
local function helper_22e4c(arg0: s32)
	monster.VPush(11, 0)
	helper_1c74()
	if arg0 == 1 then
		monster.VPush(9, 1)
	end
	if arg0 == 0 then
		monster.VPush(9, 0)
		helper_1c190()
	end
end

--- Helper function.
local function helper_2475c()
	local value: s32 = 0
	helper_24130()
	value = monster.VPop(11) or value
	if value == 0 then
		helper_24610()
	end
	if value == 1 then
		helper_23e30()
	end
	if value == 2 then
		helper_24130()
	end
	if value >= 3 then
		helper_22e4c(1)
	end
end

--- Helper function.
local function helper_23028()
	local value: s32 = 0
	local argc: s32 = 0
	value = monster.VPop(11) or value
	monster.VPush(11, vm.i32(value - 1))
	helper_18c8()
	monster.SetMos("歩き", -1.0, 0)
	helper_5cb0(5.0)
	monster.SetMos("走り", -1.0, 0)
	helper_1a580(30.0, 5.0, 35.0, vm.f32(0.8), 180)
	helper_1d59c()
	argc = monster.GetRnd(100) or argc
	if argc < 60 then
		helper_1d59c()
	end
end

--- Helper function.
local function helper_109cc(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
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
		if var20 >= 35.0 or var20 <= 0.0 then
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
		helper_1c74()
	end
end

--- Helper function.
local function helper_23340()
	local var0: f32 = 0
	local value: s32 = 0
	local argc: s32 = 0
	local var3: f32 = 0
	value = monster.VPop(11) or value
	monster.VPush(11, vm.i32(value - 1))
	helper_18c8()
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		var3 = monster.GetRndf(60.0) or var3
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		var0 = monster.GetTargetDist() or var0
		monster.SetMos("歩き", -1, 0)
		helper_1bb18(10.5, 5.0, var3, var0, 5.0, 35.0, 30)
		helper_5cb0(5.0)
		monster.SetMos("立ち", -1, 0)
		helper_1cf4(3)
	else
		monster.SetMos("歩き", -1.0, 0)
		helper_5cb0(5.0)
		monster.SetMos("走り", -1.0, 0)
		helper_109cc(10.0, 5.0, 35.0, 5.0, 0, 90)
		helper_1d59c()
		argc = monster.GetRnd(100) or argc
		if argc < 60 then
			helper_1d59c()
		end
	end
end

--- Helper function.
local function helper_23a10()
	local value: s32 = 0
	local argc: s32 = 0
	value = monster.VPop(11) or value
	if value == 0 then
		helper_23028()
		monster.SetMos("歩き", -1.0, 0)
		helper_5cb0(5.0)
		monster.SetMos("走り", -1.0, 0)
		helper_1a580(30.0, 5.0, 35.0, vm.f32(0.8), 180)
		helper_1d59c()
		argc = monster.GetRnd(100) or argc
		if argc < 80 then
			helper_1d59c()
		end
	end
	if value == -1 then
		helper_23340()
	end
	if value == -2 then
		helper_23028()
	end
	if value <= -3 then
		helper_22e4c(0)
	end
end

--- Helper function.
local function helper_24974()
	local value: s32 = 0
	helper_18c8()
	value = monster.VPop(9) or value
	if value == 0 then
		helper_2475c()
	end
	if value == 1 then
		helper_23a10()
	end
end

--- Helper function.
local function helper_1e058()
	monster.SetDefRate(1.0)
	monster.SetAttrib(32, 0)
end

--- Helper function.
local function helper_cb24()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	helper_1c74()
	monster.SetActStatus(1)
end

--- Helper function.
local function helper_f280(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: any)
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
		if var22 >= 35.0 or var22 <= 0.0 then
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
		helper_1c74()
		var23 = vm.i32(var23 + 1)
	end
end

--- Helper function.
local function helper_1adb0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local argc: s32 = 0
	monster.SetMos("歩き", -1, 0)
	helper_5cb0(10.0)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.GetRot()
		var4 = out2 or var4
	end
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("ステップ左", -1, 6)
		var10 = vm.f32(var4 + vm.f32(1.5707964))
	else
		monster.SetMos("ステップ右", -1, 6)
		var10 = vm.f32(var4 - vm.f32(1.5707964))
	end
	var9 = 100.0
	if var10 > vm.f32(3.1415927) then
		var10 = vm.f32(var10 - vm.f32(6.2831855))
	end
	if var10 <= vm.f32(-3.1415927) then
		var10 = vm.f32(var10 + vm.f32(6.2831855))
	end
	var6 = vm.f32(pos_x + vm.f32(vm.sin(var10) * var9))
	var7 = pos_y
	var8 = vm.f32(pos_z + vm.f32(vm.cos(var10) * var9))
	helper_1cf4(3)
	monster.SetAttrib(32, 1)
	helper_f280(var6, var7, var8, vm.f32(9.8), vm.f32(9.8), pos_y, 6)
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	helper_1e34()
	monster.SetMos("立ち", -1, 0)
end

--- Dodges the target's second kind of attack.
local function on_dodge_2()
	local value: s32 = 0
	local height: f32 = 0
	local var3: f32 = 0
	local argc: s32 = 0
	value = monster.VPop(15) or value
	if value == 0 then
		helper_1ddf8()
		return
	end
	helper_1e058()
	helper_1e058()
	helper_49610f43()
	helper_18c8()
	height = monster.GetHigh() or height
	if true then
		var3 = monster.GetTargetAngle() or var3
		if var3 > vm.f32(3.1415927) then
			var3 = vm.f32(var3 - vm.f32(6.2831855))
		end
		if var3 <= vm.f32(-3.1415927) then
			var3 = vm.f32(var3 + vm.f32(6.2831855))
		end
		monster.SetRot(0.0, var3, 0.0)
		helper_1c74()
		helper_1adb0()
		monster.SetMos("立ち", -1, 0)
		argc = monster.GetRnd(100) or argc
		if argc < 85 then
			height = monster.GetHigh() or height
			helper_24130()
			if height > 45.0 then
				helper_22a58()
			else
				monster.SetMos("歩き", -1.0, 0)
				helper_5cb0(5.0)
				monster.SetMos("走り", -1.0, 0)
				helper_1a580(30.0, 5.0, 35.0, vm.f32(0.8), 180)
				helper_1d59c()
			end
		end
	else
		monster.SetMos("歩き", -1.0, 0)
		helper_5cb0(5.0)
		monster.SetMos("走り", -1.0, 0)
		helper_1a580(30.0, 5.0, 35.0, vm.f32(0.8), 180)
		helper_1d59c()
	end
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	helper_a551797e()
end

--- Helper function.
local function helper_1ca90()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local chara_type: s32 = 0
	local var9: f32 = 0
	monster.VPush(13, 1)
	monster.SetAttrib(32, 1)
	chara_type = monster.GetUserid() or chara_type
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.EsmCreate_1("サンワープ")
	monster.EsmSetVect1(-1, pos_x, pos_y + 8.0, pos_z)
	monster.EsmSetUserId(-1, chara_type)
	monster.SetMos("テレポート飛び", -1, 2)
	helper_1e34()
	monster.SetMos("テレポート中", -1, 4)
	monster.SetModelLightSwitch(0)
	var9 = 128.0
	for var10 = 0, 14 do
		monster.SetModelLightColor(128.0, 128.0, 128.0, var9)
		var9 = vm.f32(var9 - vm.f32(8.533334))
		helper_1c74()
	end
	monster.SetModelLightSwitch(1)
end

--- Helper function.
local function helper_1d08c()
	local var3: f32 = 0
	local var4: f32 = 0
	monster.GetPos_3()
	monster.SetMos("テレポート着地", -1, 6)
	var3 = monster.GetTargetAngle() or var3
	monster.SetRot(0.0, var3, 0.0)
	helper_1c74()
	monster.SetModelLightSwitch(0)
	var4 = 0.0
	for var5 = 0, 27 do
		monster.SetModelLightColor(128.0, 128.0, 128.0, var4)
		var4 = vm.f32(var4 + vm.f32(4.571429))
		helper_1c74()
	end
	monster.SetModelLightColor(128.0, 128.0, 128.0, 128.0)
	monster.SetModelLightSwitch(1)
	monster.SetAttrib(32, 0)
	monster.VPush(13, 0)
end

--- Helper function.
local function helper_1a714()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.GetRot()
		var4 = out2 or var4
	end
	var6 = vm.f32(var4 + vm.f32(3.1415927))
	if var6 > vm.f32(3.1415927) then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if var6 <= vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(var6)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(var6)))
	monster.SetMos("ステップ後", -1, 6)
	helper_1cf4(2)
	monster.SetAttrib(32, 1)
	helper_f280(pos_x, pos_y, pos_z, 10.5, 10.5, pos_y, 24)
	monster.ResetMove()
	monster.SetAttrib(32, 0)
	helper_1e34()
	monster.SetMos("立ち", -1, 0)
end

--- Helper function.
local function helper_d83c()
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_1cf4(10)
	monster.ResetMotion()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetDmg2("通常攻撃", 6.0, "攻撃１", 0.28, 0.4, 0)
	monster.LoadEffectScript("バラ")
	monster.LoadEffectScript("バラヒット")
	monster.LoadEffectScript("サンの竜巻")
	monster.LoadEffectScript("ギルトーニシールド")
	monster.LoadEffectScript("サンワープ")
	monster.SetClipDist(9999.9)
	helper_1029a353()
	monster.SetAttrib(4, 1)
	monster.SetAttrib(8, 1)
	monster.VPush(8, 0)
	monster.VPush(9, 0)
	monster.VPush(10, 0)
	monster.VPush(11, 0)
	monster.SetCameraMode(4)
	monster.VPush(15, 0)
	monster.VPush(13, 0)
	helper_1dc70()
	monster.SetScoop(1026)
	helper_1f5c()
	helper_b33c6f49()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local value_2: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	value_2 = monster.VPop(13) or value_2
	if value_2 ~= 0 then
		monster.SetModelLightSwitch(0)
		monster.SetModelLightColor(128.0, 128.0, 128.0, 128.0)
		monster.SetModelLightSwitch(1)
	end
	monster.SetMuteki(0)
	value = monster.VPop(15) or value
	if value == 0 then
		helper_24610()
		var2 = vm.f32(-0.3)
		var3 = vm.f32(78.62)
		var4 = vm.f32(327.79)
		monster.SetIntFlag(1, 1)
		monster.SetIntFlag(2, 1)
		var5 = monster.GetRefAngle(var2, var3, var4) or var5
		monster.SetMos("歩き", -1.0, 0)
		if var5 > vm.f32(3.1415927) then
			var5 = vm.f32(var5 - vm.f32(6.2831855))
		end
		if var5 <= vm.f32(-3.1415927) then
			var5 = vm.f32(var5 + vm.f32(6.2831855))
		end
		helper_50e0(helper_28452e16(var5), 5.0)
		monster.SetMos("走り", -1.0, 0)
		helper_19a44(var2, var3, var4, vm.f32(11.2), vm.f32(9.8), 0.0, vm.f32(0.8), 180)
		helper_1029a353()
		monster.SetIntFlag(1, 0)
		monster.SetIntFlag(2, 0)
		monster.VPush(15, 1)
	end
	while true do
		helper_1c74()
		helper_24974()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	local value: s32 = 0
	value = monster.VPop(15) or value
	if value == 0 then
		helper_1ddf8()
	else
		helper_18c8()
		helper_1e058()
		helper_5d37e9f4()
		helper_1ddf8()
		helper_18c8()
		monster.ResetMotion()
		monster.SetMos("ダメージ", -1, 6)
		monster.BlowStart(4.0, 0.0, 3)
		helper_1e34()
		helper_1cf4(12)
		monster.SetMos("立ち", -1, 0)
		helper_1ef0d4b2()
		monster.SetIntFlag(1, 0)
		monster.SetIntFlag(2, 0)
	end
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	local value: s32 = 0
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local height: f32 = 0
	local var6: f32 = 0
	value = monster.VPop(15) or value
	if value == 0 then
		helper_1ddf8()
		return
	else
		helper_18c8()
		helper_1e058()
		helper_cb24()
		helper_1029a353()
		helper_1ddf8()
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			height = monster.GetHigh() or height
			do
				local out1, out2, out3 = monster.GetPos_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			height = vm.f32(pos_y - height)
			monster.SetPos(pos_x, height + 5.0, pos_z)
			monster.SetMos("吹っ飛び", -1, 6)
			monster.BlowStart(3.0, 0.05, 20)
			helper_1e34()
			monster.SetActStatus(1)
			helper_1cf4(3)
			monster.SetActStatus(0)
			monster.SetMos("起き上がり", -1, 6)
			helper_1e34()
			monster.SetMos("立ち", -1, 0)
		else
			var6 = monster.GetTargetDist() or var6
			if var6 < 60.0 then
				monster.SetMos("歩き", -1.0, 0)
				helper_5cb0(5.0)
				monster.SetMos("走り", -1.0, 0)
				helper_1a580(30.0, 5.0, 35.0, vm.f32(0.8), 180)
			end
			helper_1d59c()
		end
		helper_6a21fe95()
	end
end

--- Guards against a hit.
function script.on_guard()
	local value: s32 = 0
	local argc: s32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	value = monster.VPop(15) or value
	if value == 0 then
		helper_1ddf8()
		return
	else
		argc = monster.GetRnd(100) or argc
		if argc < 30 then
			on_dodge_2()
		else
			helper_18c8()
			helper_1e058()
			helper_ab4b367a()
			helper_1029a353()
			helper_1ddf8()
			monster.ResetMotion()
			var2 = monster.GetTargetAngle() or var2
			monster.SetRot(0.0, var2, 0.0)
			monster.SetMos("ガードL", -1, 4)
			monster.BlowStart(3.0, 0.0, 2)
			helper_1c74()
			monster.SetMuteki(30)
			do
				local out1, out2, out3 = monster.GetPos_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = monster.GetRot()
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			monster.EsmCreate_1("ギルトーニシールド")
			monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
			monster.EsmSetVect2(-1, var6, var7, var8)
			helper_1cf4(60)
			monster.SetMuteki(0)
			monster.SetMos("ガード戻り", -1, 6)
			helper_1e34()
			monster.SetMos("立ち")
			helper_a551797e()
			monster.SetIntFlag(1, 0)
			monster.SetIntFlag(2, 0)
		end
	end
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local value: s32 = 0
	local height: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	value = monster.VPop(15) or value
	if value == 0 then
		helper_1ddf8()
		return
	end
	helper_18c8()
	helper_1e058()
	helper_1e058()
	helper_49610f43()
	helper_1ddf8()
	do
		local out1, _, out3 = monster.CopyVector(0.0, 0.0, 333.0)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = monster.GetTargetPos()
		var12 = out1 or var12
		var14 = out3 or var14
	end
	var11 = monster.GetDistVector2(var5, 0.0, var7, var12, 0.0, var14) or var11
	if var11 < 300.0 then
		helper_1ca90()
		var8, var9, var10 = helper_125e5305(180.0, 35.0, var8, var9, var10)
		monster.SetPos(var8, var9, var10)
		helper_1c74()
		helper_1d08c()
		monster.SetMos("歩き", -1.0, 0)
		helper_5cb0(5.0)
		monster.SetMos("走り", -1.0, 0)
		helper_1a580(30.0, 5.0, 35.0, vm.f32(0.8), 180)
		helper_1d59c()
	else
		height = monster.GetHigh() or height
		if height < 40.0 then
			var4 = monster.GetTargetAngle() or var4
			if var4 > vm.f32(3.1415927) then
				var4 = vm.f32(var4 - vm.f32(6.2831855))
			end
			if var4 <= vm.f32(-3.1415927) then
				var4 = vm.f32(var4 + vm.f32(6.2831855))
			end
			monster.SetRot(0.0, var4, 0.0)
			helper_1c74()
			helper_1a714()
			monster.SetMos("立ち", -1, 0)
		else
			helper_1ca90()
			var15, var16, var17 = helper_125e5305(180.0, 35.0, var15, var16, var17)
			monster.SetPos(var15, var16, var17)
			helper_1c74()
			helper_1d08c()
			monster.SetMos("歩き", -1.0, 0)
			helper_5cb0(5.0)
			monster.SetMos("走り", -1.0, 0)
			helper_1a580(30.0, 5.0, 35.0, vm.f32(0.8), 180)
			helper_1d59c()
		end
	end
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	helper_a551797e()
end

script.on_dodge_2 = on_dodge_2

--- Runs the monster's death.
function script.on_death()
	monster.SetAttrib(2, 1)
	monster.MySeStop(4)
	monster.MySeStop(5)
	monster.MySeStop(7)
	monster.MySeStop(15)
	monster.MySeStop(39)
	helper_1e058()
	helper_02ce7891()
	helper_1029a353()
	helper_1ddf8()
	monster.SetMos("死に", -1, 6)
	helper_1e34()
	monster.SetMos("死にL", -1, 4)
	monster.RunEventScript(504)
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_1ddf8()
	while true do
		helper_1c74()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_d83c()
	helper_1ddf8()
	helper_1e058()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	helper_1ddf8()
	helper_1e058()
	helper_e05438b5()
end

return script
