--!strict
-- dungeon/monster/b10a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_754712d9 = require("@lib/monster/helper_754712d9")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_b9b0f992 = require("@lib/monster/helper_b9b0f992")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_f2cf0297 = require("@lib/monster/helper_f2cf0297")

--- Helper function.
local function helper_1c54()
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
local function helper_11da8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	monster.SetMos("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	monster.SetMos("攻撃４", -1, 6)
	do
		local out1, out2, out3 = monster.GetPos_3()
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
	monster.EsmCreate_1("グリコンボ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var3, var4, var5)
	helper_c3e8ae39(helper_9df6409a(119))
	monster.CameraQuake(3.0, 45)
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
	helper_c3e8ae39(helper_9df6409a(15))
end

--- Helper function.
local function helper_1229c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local argument_count: s32 = 0
	monster.SetMos("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	monster.SetMos("攻撃３", -1, 6)
	helper_c3e8ae39(helper_9df6409a(33))
	var6 = monster.GetTargetDist() or var6
	do
		local out1, out2, out3 = monster.GetPos_3()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	monster.GetRot()
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var7 = vm.f32(vm.fdiv(var6, 31))
	monster.SetNextPos(var0, var1, var2, var7, var7)
	helper_c3e8ae39(helper_9df6409a(31))
	monster.ResetMove()
	monster.CameraQuake(3.0, 45)
	helper_56d63eae()
	argument_count = monster.GetUserAttr() or argument_count
	if argument_count == 8 then
		helper_11da8()
	end
end

--- Helper function.
local function helper_1283c(arg0: s32)
	local var1: s32 = 0
	local argument_count: s32 = 0
	local value: s32 = 0
	value = monster.VPop(5) or value
	var1 = 0
	while var1 < arg0 do
		argument_count = monster.GetUserAttr() or argument_count
		if argument_count == 8 and value <= 0 then
			helper_1229c()
			value = 90
		end
		vm.wait()
		var1 = var1 + 1
		value = vm.i32(value - 1)
	end
	value = 0
	monster.VPush(5, value)
end

--- Helper function.
local function helper_142c4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	monster.SetMos("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	helper_1283c(1)
	monster.SetMos("攻撃３", -1, 6)
	helper_c3e8ae39(helper_9df6409a(33))
	do
		local out1, out2, out3 = monster.GetPos_3()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	monster.GetRot()
	var8 = monster.GetTargetAngle() or var8
	monster.SetRot(0.0, var8, 0.0)
	var7 = 3.0
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var6 = monster.GetTargetDist() or var6
	var7 = vm.f32(vm.fdiv(var6, helper_9df6409a(30)))
	monster.SetNextPos(var0, var1, var2, var7, var7)
	helper_c3e8ae39(helper_9df6409a(31))
	monster.ResetMove()
	monster.CameraQuake(3.0, 45)
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
end

--- Helper function.
local function helper_1311c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local attack: s32 = 0
	attack = monster.GetBaseAttack_1() or attack
	monster.SetMos("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	monster.SetMos("構え立ち", -1, 0)
	helper_1283c(1)
	monster.SetMos("攻撃２", -1, 6)
	helper_754712d9(vm.f32(4.2), helper_9df6409a(23))
	do
		local out1, out2, out3 = monster.GetFramePos("dcol_r")
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
	pos_y = 0.0
	var10 = 0
	monster.GetRnd(100)
	var10 = 1
	var9 = monster.GetRndf(0.25) or var9
	var9 = vm.f32(var9 + vm.f32(0.2))
	monster.EsmCreate_1("グリＳＷＦ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var6, var7, var8)
	monster.EsmCreate_1("グリＳＷＬ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var6, var7, var8)
	monster.EsmSetValue(-1, 0, attack)
	monster.EsmSetValueFloat(-1, 1, var9)
	monster.EsmSetValue(-1, 2, var10)
	monster.EsmSetValue(-1, 3, 0)
	monster.EsmSetValueFloat(-1, 4, -1.5707964)
	helper_754712d9(vm.f32(4.2), helper_9df6409a(24))
	do
		local out1, out2, out3 = monster.GetFramePos("dcol_l")
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
	pos_y = 0.0
	var10 = 0
	monster.GetRnd(100)
	var10 = 1
	var9 = monster.GetRndf(0.25) or var9
	var9 = vm.f32(var9 + vm.f32(0.2))
	monster.EsmCreate_1("グリＳＷＦ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var6, var7, var8)
	monster.EsmCreate_1("グリＳＷＬ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var6, var7, var8)
	monster.EsmSetValue(-1, 0, attack)
	monster.EsmSetValueFloat(-1, 1, var9)
	monster.EsmSetValue(-1, 2, var10)
	monster.EsmSetValue(-1, 3, 0)
	monster.EsmSetValueFloat(-1, 4, 1.5707964)
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
	helper_1283c(9)
end

--- Helper function.
local function helper_15448()
	local var0: f32 = 0
	local argc: s32 = 0
	print("far range--------------------\n")
	var0 = monster.GetTargetDist() or var0
	if var0 > 650.0 then
		monster.SetMos("構え歩き", -1, 0)
		helper_890ee63a(vm.f32(4.2))
		helper_142c4()
	end
	argc = monster.GetRnd(100) or argc
	if argc < 85 then
		monster.SetMos("構え歩き", -1, 0)
		helper_890ee63a(vm.f32(4.2))
		helper_1311c()
	else
		monster.SetMos("構え歩き", -1, 0)
		helper_b9b0f992(2.0, vm.f32(4.2), 55.0, 90)
		monster.SetMos("構え立ち", -1, 0)
	end
end

--- Helper function.
local function helper_12b74()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	attack = monster.GetBaseAttack_1() or attack
	monster.SetMos("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	helper_1283c(1)
	monster.SetMos("攻撃１", -1, 6)
	helper_754712d9(vm.f32(4.2), helper_9df6409a(38))
	monster.CameraQuake(3.0, helper_9df6409a(45))
	do
		local out1, out2, out3 = monster.GetPos_3()
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
	monster.EsmCreate_1("グリ衝撃波")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var3, var4, var5)
	monster.EsmSetValue(-1, 0, attack)
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
	helper_1283c(9)
end

--- Helper function.
local function helper_14cf0()
	local argc: s32 = 0
	print("mid range---------------------\n")
	argc = monster.GetRnd(100) or argc
	if argc < 65 then
		argc = monster.GetRnd(100) or argc
		if argc < 15 then
			helper_12b74()
		else
			argc = monster.GetRnd(100) or argc
			if argc < 70 then
				monster.SetMos("構え歩き", -1, 0)
				helper_890ee63a(vm.f32(4.2))
				helper_1311c()
			else
				helper_142c4()
			end
		end
	else
		argc = monster.GetRnd(100) or argc
		if argc < 70 then
			monster.SetMos("構え歩き", -1, 0)
			helper_f2cf0297(2.0, vm.f32(4.2), 55.0, 90)
			monster.SetMos("構え立ち", -1, 0)
		else
			argc = monster.GetRnd(100) or argc
			if argc < 30 then
				monster.SetMos("構え歩き", -1, 0)
				helper_890ee63a(vm.f32(4.2))
				helper_1311c()
			elseif argc > 30 and argc < 65 then
				monster.SetMos("構え歩き", -1, 0)
				helper_f2cf0297(2.0, vm.f32(4.2), 55.0, 90)
				monster.SetMos("構え立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_11738()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.SetMos("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(vm.f32(var4 + vm.f32(3.1415927))) * 200.0))
	pos_y = pos_y
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(vm.f32(var4 + vm.f32(3.1415927))) * 200.0))
	monster.SetMos("ステップ後", -1, 6)
	helper_c3e8ae39(helper_9df6409a(9))
	monster.SetAttrib(32, 1)
	monster.SetNextPos(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	helper_c3e8ae39(helper_9df6409a(15))
	monster.ResetMove()
	monster.SetAttrib(32, 0)
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
end

--- Helper function.
local function helper_103c8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	monster.SetMos("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	var6 = monster.GetTargetDist() or var6
	if var6 < 110.0 then
		var8 = 1
		var7 = vm.f32(3.6000001)
		do
			local _, out2, _ = monster.GetRot()
			var4 = out2 or var4
		end
		var4 = vm.f32(var4 - vm.f32(1.5707964))
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(pos_x + vm.f32(vm.sin(var4) * 200.0))
		pos_y = pos_y
		pos_z = vm.f32(pos_z + vm.f32(vm.cos(var4) * 200.0))
	else
		var8 = 0
		var6 = 85.0
		var7 = vm.f32(vm.fdiv(var6, helper_9df6409a(14)))
		pos_x, pos_y, pos_z = helper_125e5305(30.0, var6, pos_x, pos_y, pos_z)
	end
	monster.SetMos("ステップ右", -1, 6)
	helper_c3e8ae39(helper_9df6409a(10))
	monster.SetAttrib(32, 1)
	monster.SetNextPos(pos_x, pos_y, pos_z, var7, var7)
	if var8 ~= 0 then
		helper_c3e8ae39(helper_9df6409a(14))
	else
		helper_754712d9(vm.f32(4.2), helper_9df6409a(14))
	end
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
end

--- Helper function.
local function helper_10d68()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var8: s32 = 0
	monster.SetMos("構え歩き", -1, 0)
	helper_890ee63a(vm.f32(4.2))
	var6 = monster.GetTargetDist() or var6
	if var6 < 110.0 then
		var8 = 1
		do
			local _, out2, _ = monster.GetRot()
			var4 = out2 or var4
		end
		var4 = vm.f32(var4 + vm.f32(1.5707964))
		do
			local out1, out2, out3 = monster.GetPos_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(pos_x + vm.f32(vm.sin(var4) * 200.0))
		pos_y = pos_y
		pos_z = vm.f32(pos_z + vm.f32(vm.cos(var4) * 200.0))
	else
		var8 = 0
		var6 = 85.0
		pos_x, pos_y, pos_z = helper_125e5305(-30.0, var6, pos_x, pos_y, pos_z)
	end
	monster.SetMos("ステップ左", -1, 6)
	helper_c3e8ae39(helper_9df6409a(10))
	monster.SetAttrib(32, 1)
	monster.SetNextPos(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	if var8 ~= 0 then
		helper_c3e8ae39(helper_9df6409a(14))
	else
		helper_754712d9(vm.f32(4.2), helper_9df6409a(14))
	end
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
end

--- Helper function.
local function helper_14934()
	local var0: f32 = 0
	local var1: f32 = 0
	local argc: s32 = 0
	print("near range---------------------\n")
	argc = monster.GetRnd(100) or argc
	if argc < 70 then
		argc = monster.GetRnd(100) or argc
		if argc < 85 then
			helper_12b74()
		else
			argc = monster.GetRnd(100) or argc
			if argc < 90 then
				helper_1311c()
			else
				helper_142c4()
			end
		end
	elseif var0 < 110.0 then
		helper_11738()
	else
		monster.GetTargetAngle() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
		if var1 < 0.0 then
			helper_103c8()
		else
			helper_10d68()
		end
	end
end

--- Helper function.
local function helper_15848()
	local var0: f32 = 0
	var0 = monster.GetTargetDist() or var0
	if var0 < 9999.0 and var0 >= 300.0 then
		helper_15448()
	elseif var0 < 300.0 and var0 >= 120.0 then
		helper_14cf0()
	else
		helper_14934()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local chara_type: s32 = 0
	local slot: s32 = 0
	monster.SetDmg2("吹っ飛び強", 7.4, "攻撃３", 0.578, 0.627, 0)
	monster.SetDmg2("吹っ飛び強", 7.4, "攻撃３", 0.578, 0.627, 1)
	monster.SetDmg2("グリコンボ", 20.0, "攻撃４", 0.107, 0.214, 0)
	monster.SetDmg2("グリコンボ", 20.0, "攻撃４", 0.221, 0.279, 1)
	monster.SetDmg2("グリコンボ", 20.0, "攻撃４", 0.286, 0.336, 0)
	monster.SetDmg2("グリコンボ", 20.0, "攻撃４", 0.343, 0.4, 1)
	monster.SetDmg2("グリコンボ", 20.0, "攻撃４", 0.407, 0.457, 0)
	monster.SetDmg2("グリコンボ", 20.0, "攻撃４", 0.464, 0.543, 1)
	monster.SetDmg2("グリコンボ２", 20.0, "攻撃４", 0.636, 0.707, 0)
	monster.LoadEffectScript("グリコンボ")
	monster.LoadEffectScript("グリＳＷＦ")
	monster.LoadEffectScript("グリＳＷＬ")
	monster.LoadEffectScript("グリ衝撃波")
	monster.LoadEffectScript("グリ炎")
	chara_type = monster.GetUserid() or chara_type
	slot = monster.EsmCreate_2("グリ炎") or slot
	monster.EsmSetUserId(slot, chara_type)
	monster.VPush(6, slot)
	monster.SetClipDist(9999.9)
	monster.SetCameraMode(4)
	monster.SetMonsterLife(0.34)
	monster.VPush(5, 0)
	monster.VPush(7, 0)
	helper_1c54()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetMos("構え立ち", -1, 4)
	while true do
		vm.wait()
		helper_15848()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(helper_9df6409a(12))
	monster.SetMos("構え立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d8cf1050()
	helper_6a21fe95()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local argc: s32 = 0
	local var1: f32 = 0
	helper_49610f43()
	vm.wait()
	argc = monster.GetRnd(100) or argc
	if argc < 70 then
		helper_11738()
	else
		var1 = monster.GetTargetAngle() or var1
		if var1 < 0.0 then
			helper_103c8()
		else
			helper_10d68()
		end
	end
	monster.SetMos("構え立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local argc: s32 = 0
	local var1: f32 = 0
	helper_49610f43()
	argc = monster.GetRnd(100) or argc
	if argc < 70 then
		monster.SetMos("構え歩き", -1, 0)
		helper_890ee63a(vm.f32(4.2))
		helper_1311c()
	else
		var1 = monster.GetTargetAngle() or var1
		if var1 > vm.f32(3.1415927) then
			var1 = vm.f32(var1 - vm.f32(6.2831855))
		end
		if var1 <= vm.f32(-3.1415927) then
			var1 = vm.f32(var1 + vm.f32(6.2831855))
		end
		if var1 < 0.0 then
			helper_103c8()
		else
			helper_10d68()
		end
		helper_1311c()
	end
	monster.SetMos("構え立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	local value: s32 = 0
	helper_02ce7891()
	monster.MySeStop(2)
	monster.MySeStop(3)
	monster.MySeStop(4)
	monster.MySeStop(5)
	monster.MySeStop(6)
	monster.MySeStop(7)
	monster.MySeStop(23)
	value = monster.VPop(6) or value
	monster.EsmFinish(value)
	monster.RunEventScript(502)
	monster.SetMos("死に", -1, 6)
	helper_56d63eae()
	monster.SetDeadOff()
	while true do
		vm.wait()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
