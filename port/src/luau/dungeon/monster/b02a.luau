--!strict
-- dungeon/monster/b02a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_14c68180 = require("@lib/monster/helper_14c68180")
local helper_327ff876 = require("@lib/monster/helper_327ff876")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_bf1b4ec0 = require("@lib/monster/helper_bf1b4ec0")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_f683d690 = require("@lib/monster/helper_f683d690")

local global0: s32 = 0

--- Helper function.
local function helper_398c()
	local value: s32 = 0
	local no_damage_cnt: s32 = 0
	value = monster.VPop(18) or value
	if value == 0 then
		no_damage_cnt = monster.GetNoDamageCnt() or no_damage_cnt
		if 1 <= no_damage_cnt then
			monster.VPush(18, 1)
			monster.RunEventScript(507)
		end
	end
end

--- Helper function.
local function helper_23a8(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32)
	local var6: f32 = 0
	local var7: f32 = 0
	var6 = vm.f32(vm.sin(arg2) * arg3)
	var7 = vm.f32(vm.cos(arg2) * arg3)
	var6 = vm.f32(var6 + arg0)
	var7 = vm.f32(var7 + arg1)
	arg4 = var6
	arg5 = var7
	return arg4, arg5
end

--- Helper function.
local function helper_25b4()
	local var0: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	if global0 == 0 then
		return
	end
	do
		local out1, _, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var2 = out3 or var2
	end
	var3 = monster.Atan2f(var0 - vm.f32(268.8), var2 - vm.f32(-322.4)) or var3
	if var3 > vm.f32(3.1415927) then
		var3 = vm.f32(var3 - vm.f32(6.2831855))
	end
	if var3 <= vm.f32(-3.1415927) then
		var3 = vm.f32(var3 + vm.f32(6.2831855))
	end
	var4, var5 = helper_23a8(vm.f32(268.8), vm.f32(-322.4), var3, 800.0, var4, var5)
	monster.SetCameraNextPos(var4, 850.0, var5)
	monster.SetCameraNextRef(268.8, 1050.0, -322.4)
end

--- Helper function.
local function helper_3b5c(arg0: f32, arg1: f32, arg2: s32)
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	monster.SetMos("歩き")
	while true do
		helper_398c()
		if arg2 ~= 0 then
			value = monster.VPop(8) or value
			if value == 16 then
				return 5
			end
		end
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.GetRot()
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		if pos_y == arg0 and var8 == arg1 then
			return 0
		end
		var10 = vm.f32(arg0 - pos_y)
		if var10 < -2.0 then
			pos_y = vm.f32(pos_y - 2.0)
		elseif var10 < 2.0 then
			pos_y = arg0
		else
			pos_y = vm.f32(pos_y + 2.0)
		end
		monster.SetPos(pos_x, pos_y, pos_z)
		var11 = vm.f32(arg1 - var8)
		if var11 > vm.f32(3.1415927) then
			var11 = vm.f32(var11 - vm.f32(6.2831855))
		end
		if var11 <= vm.f32(-3.1415927) then
			var11 = vm.f32(var11 + vm.f32(6.2831855))
		end
		if var11 < vm.f32(-0.05) then
			var8 = vm.f32(var8 - vm.f32(0.05))
		elseif var11 < vm.f32(0.05) then
			var8 = arg1
		else
			var8 = vm.f32(var8 + vm.f32(0.05))
		end
		if var8 > vm.f32(3.1415927) then
			var8 = vm.f32(var8 - vm.f32(6.2831855))
		end
		if var8 <= vm.f32(-3.1415927) then
			var8 = vm.f32(var8 + vm.f32(6.2831855))
		end
		monster.SetRot(var7, var8, var9)
		helper_25b4()
		vm.wait()
	end
	return 0
end

--- Helper function.
local function helper_451c(arg0: f32)
	local pos_y: f32 = 0
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	helper_3b5c(pos_y, arg0, 1)
	return 0
end

--- Helper function.
local function helper_37cc(arg0: s32)
	local chara_type: s32 = 0
	chara_type = monster.GetUserid() or chara_type
	monster.MonsSePlay(chara_type, arg0)
end

--- Helper function.
local function helper_38ac(arg0: s32)
	local chara_type: s32 = 0
	chara_type = monster.GetUserid() or chara_type
	monster.MonsSeStop(chara_type, arg0)
end

--- Helper function.
local function helper_57c0()
	local var0: f32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	do
		local out1, _, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, _, out3 = monster.GetRot()
		var6 = out1 or var6
		var8 = out3 or var8
	end
	var9 = monster.Atan2f(var0 - pos_x, var2 - pos_z) or var9
	var10 = helper_451c(var9)
	if var10 == 5 then
		return 5
	end
	monster.SetMos("りんぷん")
	monster.MonsVolCtrl(1)
	helper_37cc(6)
	var11 = 0
	while var11 < 120 do
		if vm.imod(var11, 60) == 0 then
			monster.EsmCreate_1("蝶りんぷん")
			monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
			monster.EsmSetVect2(-1, var6, var9, var8)
			monster.EsmSetValue(-1, 0, 24)
			monster.EsmSetTargetId(-1, 0)
		end
		var11 = var11 + 1
		vm.wait()
	end
	helper_f683d690()
	helper_38ac(6)
	monster.MonsVolCtrl(2)
	return 2
end

--- Helper function.
local function helper_4638()
	local var0: f32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local slot: s32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	local attack: s32 = 0
	local value: s32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local pos_x_3: f32 = 0
	local pos_z_3: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	do
		local out1, _, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var2 = out3 or var2
	end
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var6 = monster.Atan2f(var0 - pos_x, var2 - pos_z) or var6
	var7 = helper_3b5c(1050.0, var6, 1)
	if var7 == 5 then
		return 5
	end
	monster.SetMos("ビーム構え", -1, 2)
	helper_56d63eae()
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	monster.SetMos("ビーム", -1, 4)
	monster.MonsVolCtrl(1)
	helper_37cc(8)
	var14 = pos_x_2
	var15 = var9
	var16 = pos_z_2
	var17 = var8
	var18 = var9
	var19 = var10
	slot = monster.EsmCreate_2("蝶ビーム") or slot
	do
		local out1, out2, out3 = monster.GetObjPos("obj17")
		var24 = out1 or var24
		var25 = out2 or var25
		var26 = out3 or var26
	end
	monster.EsmSetVect1(slot, var24, var25, var26)
	attack = monster.GetBaseAttack_1() or attack
	var27 = 0
	while var27 < 60 do
		value = monster.VPop(8) or value
		if value == 16 then
			monster.EsmFinish(slot)
			helper_38ac(8)
			monster.MonsVolCtrl(2)
			return 5
		end
		var30 = helper_bf1b4ec0(var14, var17, vm.f32(vm.fdiv(var27, 60)))
		var31 = helper_bf1b4ec0(var15, var18, vm.f32(vm.fdiv(var27, 60)))
		var32 = helper_bf1b4ec0(var16, var19, vm.f32(vm.fdiv(var27, 60)))
		monster.EsmSetVect2(slot, var30, var31, var32)
		var27 = var27 + 1
		if vm.imod(var27, 3) == 0 then
			monster.EsmCreate_1("七色蝶の火柱")
			monster.EsmSetVect1(-1, var30, var31, var32)
			monster.EsmSetValue(-1, 0, attack)
		end
		if var27 == 44 then
			monster.EsmFinish(slot)
		end
		vm.wait()
	end
	helper_38ac(8)
	monster.MonsVolCtrl(2)
	monster.SetMos("ビーム戻り", -1, 6)
	helper_56d63eae()
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x_3 = out1 or pos_x_3
		pos_z_3 = out3 or pos_z_3
	end
	var36 = monster.Atan2f(pos_x_3 - vm.f32(268.8), pos_z_3 - vm.f32(-322.4)) or var36
	var37 = vm.f32(var36 + vm.f32(1.5707964))
	if var37 > vm.f32(3.1415927) then
		var37 = vm.f32(var37 - vm.f32(6.2831855))
	end
	if var37 <= vm.f32(-3.1415927) then
		var37 = vm.f32(var37 + vm.f32(6.2831855))
	end
	local _ = helper_3b5c(850.0, var37, 1)
	if var7 == 5 then
		return 5
	end
	return 1
end

--- Helper function.
local function helper_69d8()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local value: s32 = 0
	local var13: f32 = 0
	monster.SetMos("歩き")
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var3 = monster.Atan2f(pos_x - vm.f32(268.8), pos_z - vm.f32(-322.4)) or var3
	var4 = vm.f32(var3 + vm.f32(1.5707964))
	if var4 > vm.f32(3.1415927) then
		var4 = vm.f32(var4 - vm.f32(6.2831855))
	end
	if var4 <= vm.f32(-3.1415927) then
		var4 = vm.f32(var4 + vm.f32(6.2831855))
	end
	var5 = helper_451c(var4)
	if var5 == 5 then
		return 5
	end
	var6 = 90
	var7 = 0
	var8 = 0.0
	var9 = 1
	while true do
		helper_398c()
		value = monster.VPop(8) or value
		if value == 16 then
			return 5
		end
		if var6 < var7 then
			var9 = 0
			if var8 <= 0.0 then
				var13 = monster.GetTargetDist() or var13
				if var13 < 1000.0 then
					return 6
				else
					return 2
				end
			end
		end
		var10, var11 = helper_23a8(vm.f32(268.8), vm.f32(-322.4), var3, 800.0, var10, var11)
		monster.SetPos(var10, 850.0, var11)
		monster.SetRot(0.0, var4, 0.0)
		if var9 ~= 0 then
			if var8 < vm.f32(0.02) then
				var8 = vm.f32(var8 + vm.f32(0.0005))
			end
		elseif 0 < var8 then
			var8 = vm.f32(var8 - vm.f32(0.0005))
		end
		var3 = vm.f32(var3 + var8)
		if var3 > vm.f32(3.1415927) then
			var3 = vm.f32(var3 - vm.f32(6.2831855))
		end
		if var3 <= vm.f32(-3.1415927) then
			var3 = vm.f32(var3 + vm.f32(6.2831855))
		end
		var4 = vm.f32(var3 + vm.f32(1.5707964))
		if var4 > vm.f32(3.1415927) then
			var4 = vm.f32(var4 - vm.f32(6.2831855))
		end
		if var4 <= vm.f32(-3.1415927) then
			var4 = vm.f32(var4 + vm.f32(6.2831855))
		end
		vm.wait()
		var7 = vm.i32(var7 + 1)
	end
	return 0
end

--- Helper function.
local function helper_83b8()
	local value: s32 = 0
	monster.SetAlpha(0.0)
	while true do
		vm.wait()
		value = monster.VPop(8) or value
		if value == 9 then
			return 3
		end
	end
	return 0
end

--- Helper function.
local function helper_8534(arg0: s32)
	if arg0 ~= 0 then
		monster.SetPause(6, 1)
		global0 = 1
	else
		monster.SetCameraFollow(1)
		monster.SetPause(6, 0)
		global0 = 0
	end
end

--- Helper function.
local function helper_5f44(arg0: f32, arg1: f32)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	while true do
		helper_398c()
		do
			local out1, _, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.GetRot()
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		var9 = helper_14c68180(pos_x, pos_z, var6, arg0, arg1)
		if vm.f32(0.01) < var9 or var9 < vm.f32(-0.01) then
			if 0 < var9 then
				var8 = var9
				if vm.f32(0.05) < var8 then
					var8 = vm.f32(0.05)
				end
			else
				var8 = var9
				if var8 < vm.f32(-0.05) then
					var8 = vm.f32(-0.05)
				end
			end
		else
			break
		end
		var10 = vm.f32(var6 + var8)
		if var10 > vm.f32(3.1415927) then
			var10 = vm.f32(var10 - vm.f32(6.2831855))
		end
		if var10 <= vm.f32(-3.1415927) then
			var10 = vm.f32(var10 + vm.f32(6.2831855))
		end
		monster.SetRot(var5, var10, var7)
		helper_25b4()
		vm.wait()
	end
	while true do
		helper_398c()
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		var17 = monster.GetDistVector2(pos_x_2, pos_y_2, pos_z_2, arg0, pos_y_2, arg1) or var17
		if vm.f32(0.01) < var17 then
			if 5.0 <= var17 then
				var18 = monster.Atan2f(arg0 - pos_x_2, arg1 - pos_z_2) or var18
				var19, var20 = helper_327ff876(var18, 5.0, var19, var20)
				var14 = vm.f32(pos_x_2 + var19)
				var15 = pos_y_2
				var16 = vm.f32(pos_z_2 + var20)
			else
				var14 = arg0
				var15 = pos_y_2
				var16 = arg1
			end
		else
			return
		end
		monster.SetPos(var14, var15, var16)
		helper_25b4()
		vm.wait()
	end
end

--- Helper function.
local function helper_91f4()
	local var0: s32 = 0
	local value: s32 = 0
	local slot: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	helper_c3e8ae39(120)
	helper_8534(1)
	monster.SetPause(65536, 1)
	while true do
		value = monster.VPop(8) or value
		if value == 0 then
			break
		else
			helper_25b4()
			vm.wait()
		end
	end
	helper_8534(0)
	monster.SetPause(65536, 0)
	slot = monster.EsmCreate_2("蝶合体") or slot
	monster.EsmSetVect1(slot, 268.8, 1050.0, -322.4)
	monster.RunEventScript(513)
	monster.MonsVolCtrl(1)
	helper_37cc(10)
	var0 = 0
	while var0 < 60 do
		helper_25b4()
		vm.wait()
		var0 = var0 + 1
	end
	monster.SetPos(268.8, 1050.0, -322.4)
	monster.SetAlpha(0.0)
	monster.SetMos("合体")
	var0 = 0
	while var0 < 90 do
		var3 = helper_bf1b4ec0(0.0, 1.0, vm.f32(vm.fdiv(var0, 90)))
		monster.SetAlpha(var3)
		helper_25b4()
		vm.wait()
		var0 = var0 + 1
	end
	monster.SetAlpha(1.0)
	monster.SetAttrib(1, 0)
	monster.EsmFinish(slot)
	monster.RunEventScript(510)
	helper_5f44(vm.f32(268.8), vm.f32(477.6))
	var4 = vm.f32(1.5707964)
	helper_3b5c(850.0, var4, 1)
	return 1
end

--- Helper function.
local function helper_8728()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local slot: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local value: s32 = 0
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	helper_8534(1)
	monster.SetPause(65536, 1)
	var3 = monster.Atan2f(pos_x - vm.f32(268.8), pos_z - vm.f32(-322.4)) or var3
	monster.SetPos(pos_x, 1050.0, pos_z)
	monster.SetRot(0.0, var3, 0.0)
	monster.SetMos("歩き")
	helper_5f44(vm.f32(268.8), vm.f32(-322.4))
	slot = monster.EsmCreate_2("蝶合体") or slot
	monster.EsmSetVect1(slot, 268.8, 1050.0, -322.4)
	monster.RunEventScript(512)
	monster.MonsVolCtrl(1)
	helper_37cc(9)
	var5 = 0
	while var5 < 90 do
		var5 = var5 + 1
		var6 = helper_bf1b4ec0(1.0, 0.0, vm.f32(vm.fdiv(var5, 90)))
		monster.SetAlpha(var6)
		helper_25b4()
		vm.wait()
	end
	monster.SetAttrib(1, 1)
	monster.SetAlpha(0.0)
	monster.SetMos("歩き", -1, 1)
	monster.EsmFinish(slot)
	monster.VPush(8, 17)
	monster.RunEventScript(511)
	var5 = 0
	while var5 < 60 do
		helper_25b4()
		vm.wait()
		var5 = var5 + 1
	end
	monster.VPush(8, 1)
	value = monster.VPop(18) or value
	if value == 0 then
		helper_25b4()
		monster.VPush(18, 1)
		monster.RunEventScript(502)
		vm.wait()
	end
	helper_8534(0)
	monster.SetPause(65536, 0)
	return 4
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetPriorityLimmit(15)
	monster.SetAttrib(8, 1)
	monster.SetAttrib(16, 1)
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetClipDist(999999.9)
	monster.SetAttrib(4, 1)
	monster.SetPos(260.0, 850.0, -320.0)
	monster.LoadEffectScript("蝶ビーム")
	monster.LoadEffectScript("七色蝶の火柱")
	monster.LoadEffectScript("蝶合体")
	monster.LoadEffectScript("蝶りんぷん")
	monster.LoadEffectScript("蝶りんぷんＨ")
	monster.LoadEffectScript("蝶ねばＬ")
	monster.LoadEffectScript("ねばねばＨ")
	monster.SetScoop("合体", 0.0, 1.0, 1015)
	monster.SetObj(0, "body2--a40")
	monster.SetBody(0, 12.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: s32 = 0
	local chara_type: s32 = 0
	monster.MonsVolCtrl(2)
	var0 = 1
	while true do
		global0 = 0
		if var0 == 6 then
			var0 = helper_57c0()
		end
		if var0 == 2 then
			var0 = helper_4638()
		end
		if var0 == 1 then
			var0 = helper_69d8()
		end
		if var0 == 4 then
			var0 = helper_83b8()
		end
		if var0 == 3 then
			var0 = helper_91f4()
		end
		if var0 == 5 then
			chara_type = monster.GetUserid() or chara_type
			monster.EsmAllClear(chara_type)
			var0 = helper_8728()
		end
		if var0 == 0 then
			monster.MonsVolCtrl(0)
			return
		end
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_damage() end

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
-- Defined empty, so the engine runs this instead of its default.
function script.on_death() end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	local height: f32 = 0
	while true do
		height = monster.GetHigh() or height
		if height < vm.f32(0.1) then
			helper_c3e8ae39(3)
			monster.SetShrowEnd()
			monster.ResetMove()
			helper_c3e8ae39(30)
			return 1
		end
		vm.wait()
	end
end

return script
