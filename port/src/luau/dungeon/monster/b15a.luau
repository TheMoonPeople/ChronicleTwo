--!strict
-- dungeon/monster/b15a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_adcbef14 = require("@lib/monster/helper_adcbef14")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_2344()
	local boss: s32 = 0
	boss = monster.GetBossFlag() or boss
	if boss == 0 then
		monster.GetPos_3()
		monster.SetClipDist(35.0)
	else
		monster.SetClipDist(999999.0)
	end
end

--- Runs the monster's death.
local function on_death()
	local chara_type: s32 = 0
	local value: s32 = 0
	monster.SetCameraMode(0)
	monster.ResetCameraCtrlParam()
	chara_type = monster.GetUserid() or chara_type
	monster.VPush(68, 1)
	value = monster.VPop(66) or value
	if value == 0 then
		monster.MonsSeStop(chara_type, 2)
		monster.SetLockonMode(0)
		monster.RunEventScript(503)
		monster.VPush(66, 1)
	end
	helper_c3e8ae39(30)
	while true do
		vm.wait()
	end
end

--- Helper function.
local function helper_1bd8()
	local value: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	value = monster.VPop(4) or value
	var1 = monster.GetActiveMonsLifei(-1) or var1
	monster.VPush(4, var1)
	var2 = vm.i32(value - var1)
	var1 = monster.GetActiveMonsLifei(-1) or var1
	if var1 <= 0 then
		print("dead-------------\n")
		on_death()
	end
	var1 = monster.VPop(64) or var1
	var1 = vm.i32(var1 - var2)
	monster.VPush(64, var1)
	if var1 <= 6000 then
		monster.VPop(66)
	end
	monster.VPop(65)
	var1 = monster.VPop(64) or var1
end

--- Helper function.
local function helper_205c()
	helper_1bd8()
	vm.wait()
end

--- Helper function.
local function helper_114a4(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	arg0 = 0
	arg1 = 0
	var2 = monster.GetActiveMonsLifef(25) or var2
	if var2 > 0.0 then
		var4 = var4 + 1
	end
	var2 = monster.GetActiveMonsLifef(27) or var2
	if var2 > 0.0 then
		var4 = var4 + 1
	end
	var2 = monster.GetActiveMonsLifef(28) or var2
	if var2 > 0.0 then
		var4 = var4 + 1
	end
	var2 = monster.GetActiveMonsLifef(29) or var2
	if var2 > 0.0 then
		var4 = var4 + 1
	end
	var2 = monster.GetActiveMonsLifef(30) or var2
	if var2 > 0.0 then
		var4 = var4 + 1
	end
	var2 = monster.GetActiveMonsLifef(26) or var2
	if var2 > 0.0 then
		var3 = var3 + 1
	end
	var2 = monster.GetActiveMonsLifef(31) or var2
	if var2 > 0.0 then
		var3 = var3 + 1
	end
	var2 = monster.GetActiveMonsLifef(32) or var2
	if var2 > 0.0 then
		var3 = var3 + 1
	end
	var2 = monster.GetActiveMonsLifef(33) or var2
	if var2 > 0.0 then
		var3 = var3 + 1
	end
	var2 = monster.GetActiveMonsLifef(34) or var2
	if var2 > 0.0 then
		var3 = var3 + 1
	end
	arg0 = var3
	arg1 = var4
	return arg0, arg1
end

--- Helper function.
local function helper_11ed8()
	local var0: f32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	var1, var2 = helper_114a4(var1, var2)
	var0 = monster.GetTargetAngle() or var0
	if var1 < var2 then
		var0 = vm.f32(var0 + vm.f32(1.5707964))
	else
		var0 = vm.f32(var0 - vm.f32(1.5707964))
	end
	return var0
end

--- Helper function.
local function helper_12400(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: f32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: s32 = 0
	local var23: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.CopyVector(arg0, arg1, arg2)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = monster.SubVector(var12, var13, var14, pos_x, pos_y, pos_z)
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
	var20 = arg3
	var18 = monster.GetDistVector2(arg0, arg1, arg2, pos_x, pos_y, pos_z) or var18
	var19 = helper_adcbef14(var18, var20, vm.f32(vm.fdiv(vm.f32(var18 * vm.f32(1.9)), var20)), var19)
	var21 = 0
	while var21 < arg4 do
		var20 = vm.f32(var20 + var19)
		if var20 < 0.0 then
			break
		end
		do
			local out1, out2, out3 = monster.GetPos_3()
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var18 = monster.GetDistVector2(arg0, arg1, arg2, pos_x, pos_y, pos_z) or var18
		if var18 < var20 then
			break
		end
		do
			local out1, out2, out3 = monster.CopyVector(var12, var13, var14)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.ScaleVector(var15, var16, var17, var20)
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		do
			local out1, out2, out3 = monster.AddVector(var6, var7, var8, var15, var16, var17)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		monster.SetPos(var6, var7, var8)
		monster.SetNextRot(arg5, 0.004363323)
		helper_205c()
		var21 = var21 + 1
		helper_442b9962()
	end
	while true do
		do
			local _, out2, _ = monster.GetRot()
			var23 = out2 or var23
		end
		monster.SetNextRot(arg5, 0.004363323)
		if helper_8971d3b6(var23, arg5, vm.f32(0.004363323)) == 0 then
			break
		else
			helper_205c()
		end
	end
	helper_442b9962()
end

--- Helper function.
local function helper_132bc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	var3 = helper_11ed8()
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = monster.NormalVector(var0, var1, var2)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = monster.ScaleVector(var0, var1, var2, 1000.0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var1 = 300.0
	helper_12400(var0, var1, var2, 9.0, 180, var3)
end

--- Helper function.
local function helper_3170(arg0: f32, arg1: f32, arg2: f32)
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
			helper_205c()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_54c8(arg0: f32, arg1: f32)
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
	local _ = helper_3170(helper_28452e16(arg0), helper_28452e16(arg1), vm.f32(vm.fdiv(360.0, helper_28452e16(arg1))))
	helper_442b9962()
end

--- Helper function.
local function helper_120cc(arg0: f32)
	local var1: f32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	var2, var3 = helper_114a4(var2, var3)
	var1 = monster.GetTargetAngle() or var1
	if var2 > var3 then
		var1 = vm.f32(var1 + vm.f32(1.5707964))
	else
		var1 = vm.f32(var1 - vm.f32(1.5707964))
	end
	helper_54c8(helper_28452e16(var1), helper_28452e16(arg0))
end

--- Helper function.
local function helper_20dc(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_205c()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_13594()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local argc: s32 = 0
	helper_205c()
	helper_132bc()
	monster.VPush(8, 1)
	helper_120cc(vm.f32(0.004363323))
	helper_20dc(240)
	monster.VPush(8, 0)
	for var7 = 0, 1 do
		argc = monster.GetRnd(4) or argc
		if argc == 0 then
			var0 = vm.f32(vm.sin(0.0) * 600.0)
			var2 = vm.f32(vm.cos(0.0) * 600.0)
			var1 = 150.0
			var3 = vm.f32(vm.sin(vm.f32(1.5707964)) * 600.0)
			var5 = vm.f32(vm.cos(vm.f32(1.5707964)) * 600.0)
			var4 = 0.0
			var6 = monster.GetRefAngle(var3, var4, var5) or var6
			helper_12400(var0, var1, var2, 9.0, 180, var6)
		end
		if argc == 1 then
			var0 = vm.f32(vm.sin(vm.f32(1.5707964)) * 600.0)
			var2 = vm.f32(vm.cos(vm.f32(1.5707964)) * 600.0)
			var1 = 250.0
			var3 = vm.f32(vm.sin(vm.f32(3.1415927)) * 600.0)
			var5 = vm.f32(vm.cos(vm.f32(3.1415927)) * 600.0)
			var4 = 0.0
			var6 = monster.GetRefAngle(var3, var4, var5) or var6
			helper_12400(var0, var1, var2, 9.0, 180, var6)
		end
		if argc == 2 then
			var0 = vm.f32(vm.sin(vm.f32(3.1415927)) * 600.0)
			var2 = vm.f32(vm.cos(vm.f32(3.1415927)) * 600.0)
			var1 = 300.0
			var3 = vm.f32(vm.sin(vm.f32(4.712389)) * 600.0)
			var5 = vm.f32(vm.cos(vm.f32(4.712389)) * 600.0)
			var4 = 100.0
			var6 = monster.GetRefAngle(var3, var4, var5) or var6
			helper_12400(var0, var1, var2, 9.0, 180, var6)
		end
		if argc == 3 then
			var0 = vm.f32(vm.sin(vm.f32(4.712389)) * 600.0)
			var2 = vm.f32(vm.cos(vm.f32(4.712389)) * 600.0)
			var1 = 250.0
			var3 = vm.f32(vm.sin(0.0) * 600.0)
			var5 = vm.f32(vm.cos(0.0) * 600.0)
			var4 = 200.0
			var6 = monster.GetRefAngle(var3, var4, var5) or var6
			helper_12400(var0, var1, var2, 9.0, 180, var6)
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
	local life: s32 = 0
	local chara_type: s32 = 0
	monster.SetAttrib(4, 1)
	monster.SetAttrib(8, 1)
	monster.LinkMapToObject("p01_battleship")
	monster.SetPos(0.0, 200.0, 0.0)
	monster.SetRot(0.0, 0.0, 0.0)
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.LoadEffectScript("Ｍ汎用煙", get_not_used_texb) or var1
		var2 = monster.LoadEffectScript("軍艦ダメージ", get_not_used_texb) or var2
		if (if var1 ~= 0 then 1 else var2) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.LoadEffectScript("機関銃（小）", get_not_used_texb) or var1
		if var1 ~= 0 then
			monster.EsmAddTexb()
		end
	end
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.LoadEffectScript("Ｍ爆発大", get_not_used_texb) or var1
		var2 = monster.LoadEffectScript("砲弾", get_not_used_texb) or var2
		var3 = monster.LoadEffectScript("マズルフラッシュ", get_not_used_texb) or var3
		if (if (if var1 ~= 0 then 1 else var2) ~= 0 then 1 else var3) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	monster.VPush(8, 0)
	monster.SetLockonMode(2)
	monster.VPush(64, 0)
	monster.VPush(65, 0)
	life = monster.GetActiveMonsLifei(-1) or life
	monster.VPush(4, life)
	monster.VPush(64, life)
	monster.VPush(65, life)
	monster.VPush(66, 0)
	chara_type = monster.GetUserid() or chara_type
	monster.VPush(67, chara_type)
	monster.VPush(68, 0)
	monster.MonsSePlay(chara_type, 2)
	helper_2344()
	monster.SetPriorityLimmit(15)
	monster.SetAttrib(512, 1)
	monster.SetClipDist(999999.0)
	monster.SetCameraMode(4)
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		helper_205c()
		helper_13594()
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

script.on_death = on_death

return script
