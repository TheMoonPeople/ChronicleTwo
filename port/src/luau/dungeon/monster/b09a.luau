--!strict
-- dungeon/monster/b09a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_1eec()
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
	if life < vm.f32(0.34) then
		value = monster.VPop(7) or value
		if value == 0 then
			monster.VPush(7, 1)
			monster.RunEventScript(501)
		end
	end
end

--- Helper function.
local function helper_1ad4()
	helper_18c8()
end

--- Helper function.
local function helper_1c04()
	helper_1ad4()
	vm.wait()
end

--- Helper function.
local function helper_2da8(arg0: f32, arg1: f32, arg2: f32)
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
			helper_1c04()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_442b9962()
	return var7
end

--- Helper function.
local function helper_5cd0(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.GetTargetAngle() or var5
	local _ = helper_2da8(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

--- Helper function.
local function helper_c008(arg0: f32, arg1: s32)
	local var2: f32 = 0
	local _ = helper_787df986(arg0)
	for var4 = 0, arg1 - 1 do
		var2 = monster.GetTargetAngle() or var2
		monster.SetNextRot(var2, arg0)
		helper_1c04()
	end
	helper_442b9962()
end

--- Helper function.
local function helper_10660(arg0: s32)
	for var1 = 0, arg0 - 1 do
		helper_18c8()
		vm.wait()
	end
end

--- Helper function.
local function helper_12cb0()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	attack = monster.GetBaseAttack_1() or attack
	monster.SetMos("構え歩き", -1, 0)
	helper_5cd0(vm.f32(4.2))
	monster.SetMos("攻撃２", -1, 6)
	helper_c008(vm.f32(4.2), helper_9df6409a(15))
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
	monster.EsmCreate_1("クロスカッター")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var3, var4, var5)
	monster.EsmSetValue(-1, 0, attack)
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
	helper_10660(helper_9df6409a(9))
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

--- Helper function.
local function helper_1330c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetMos("構え歩き", -1, 0)
	helper_5cd0(vm.f32(4.2))
	monster.SetMos("攻撃３", -1, 6)
	helper_c008(vm.f32(4.2), helper_9df6409a(34))
	monster.GetRot()
	monster.GetPos_3()
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var9 = monster.GetTargetDist() or var9
	var10 = vm.f32(vm.fdiv(var9, 25))
	monster.SetNextPos(var0, var1, var2, var10, var10)
	helper_10660(helper_9df6409a(25))
	monster.ResetMove()
	monster.CameraQuake(3.0, 30)
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
	helper_10660(9)
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

--- Helper function.
local function helper_6f8c(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: s32 = 0
	arg1 = helper_787df986(arg1)
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	var12 = 0
	while var12 < arg3 do
		var10 = monster.GetTargetDist() or var10
		if var10 < arg2 then
			helper_442b9962()
			monster.ResetMove()
			return
		end
		var11 = monster.GetTargetAngle() or var11
		monster.SetNextRot(var11, arg1)
		do
			local out1, out2, out3 = monster.GetTargetPos()
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		monster.GetRot()
		monster.SetNextPos(var4, var5 - 20.0, var6, arg0, arg0)
		helper_1c04()
		var12 = var12 + 1
		monster.ResetMove()
		helper_442b9962()
	end
end

--- Helper function.
local function helper_107ac()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetMos("構え歩き", -1, 0)
	helper_5cd0(vm.f32(4.2))
	monster.SetMos("挑発", -1, 0)
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

--- Helper function.
local function helper_14530()
	local argc: s32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("構え歩き", -1, 0)
		helper_5cd0(vm.f32(4.2))
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			helper_12cb0()
		else
			helper_1330c()
		end
	else
		argc = monster.GetRnd(100) or argc
		if argc < 70 then
			monster.SetMos("構え歩き", -1, 0)
			helper_6f8c(vm.f32(1.8), vm.f32(4.2), 60.0, 90)
			monster.SetMos("構え立ち", -1, 0)
		else
			helper_107ac()
			argc = monster.GetRnd(100) or argc
			if argc < 30 then
				monster.SetMos("構え歩き", -1, 0)
				helper_5cd0(vm.f32(4.2))
				helper_12cb0()
			elseif argc > 30 and argc < 65 then
				monster.SetMos("構え歩き", -1, 0)
				helper_6f8c(vm.f32(1.8), vm.f32(4.2), 60.0, 90)
				monster.SetMos("構え立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_13e94()
	local argc: s32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 68 then
		monster.SetMos("構え歩き", -1, 0)
		helper_5cd0(vm.f32(4.2))
		argc = monster.GetRnd(100) or argc
		if argc < 30 then
			helper_12cb0()
		else
			helper_1330c()
		end
	else
		argc = monster.GetRnd(100) or argc
		if argc < 70 then
			monster.SetMos("構え歩き", -1, 0)
			helper_6f8c(vm.f32(1.8), vm.f32(4.2), 60.0, 90)
			monster.SetMos("構え立ち", -1, 0)
		else
			helper_107ac()
			argc = monster.GetRnd(100) or argc
			if argc < 30 then
				monster.SetMos("構え歩き", -1, 0)
				helper_5cd0(vm.f32(4.2))
				helper_12cb0()
			elseif argc > 30 and argc < 65 then
				monster.SetMos("構え歩き", -1, 0)
				helper_6f8c(vm.f32(1.8), vm.f32(4.2), 60.0, 90)
				monster.SetMos("構え立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_12478()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetMos("構え歩き", -1, 0)
	helper_5cd0(vm.f32(4.2))
	monster.SetMos("攻撃１", -1, 6)
	helper_c008(vm.f32(4.2), helper_9df6409a(18))
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var4) * 200.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var4) * 200.0))
	monster.SetNextPos(pos_x, pos_y, pos_z, 1.8, 1.8)
	helper_6f8c(vm.f32(1.8), vm.f32(4.2), 0.0, 1)
	monster.ResetMove()
	helper_c008(vm.f32(4.2), helper_9df6409a(40))
	monster.SetNextPos(pos_x, pos_y, pos_z, 1.8, 1.8)
	helper_c3e8ae39(helper_9df6409a(24))
	monster.CameraQuake(3.0, 30)
	monster.ResetMove()
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
	helper_10660(helper_9df6409a(9))
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

--- Helper function.
local function helper_11e08()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.SetMos("構え歩き", -1, 0)
	helper_5cd0(vm.f32(4.2))
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
	helper_10660(helper_9df6409a(9))
	monster.SetAttrib(32, 1)
	monster.SetNextPos(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	helper_10660(helper_9df6409a(15))
	monster.ResetMove()
	monster.SetAttrib(32, 0)
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
end

--- Helper function.
local function helper_10aa4()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	monster.SetMos("構え歩き", -1, 0)
	helper_5cd0(vm.f32(4.2))
	var6 = monster.GetTargetDist() or var6
	if var6 < 120.0 then
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
		var6 = 90.0
		var7 = vm.f32(vm.fdiv(var6, 14))
		pos_x, pos_y, pos_z = helper_125e5305(30.0, var6, pos_x, pos_y, pos_z)
	end
	monster.SetMos("ステップ右", -1, 6)
	helper_10660(helper_9df6409a(10))
	monster.SetAttrib(32, 1)
	monster.SetNextPos(pos_x, pos_y, pos_z, var7, var7)
	if var8 ~= 0 then
		helper_10660(helper_9df6409a(14))
	else
		helper_c008(vm.f32(4.2), helper_9df6409a(14))
	end
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
end

--- Helper function.
local function helper_11438()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var8: s32 = 0
	monster.SetMos("構え歩き", -1, 0)
	helper_5cd0(vm.f32(4.2))
	var6 = monster.GetTargetDist() or var6
	if var6 < 120.0 then
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
		var6 = 90.0
		pos_x, pos_y, pos_z = helper_125e5305(-30.0, var6, pos_x, pos_y, pos_z)
	end
	monster.SetMos("ステップ左", -1, 6)
	helper_10660(helper_9df6409a(10))
	monster.SetAttrib(32, 1)
	monster.SetNextPos(pos_x, pos_y, pos_z, 3.6000001, 3.6000001)
	if var8 ~= 0 then
		helper_10660(helper_9df6409a(14))
	else
		helper_c008(vm.f32(4.2), helper_9df6409a(14))
	end
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	helper_56d63eae()
	monster.SetMos("構え立ち", -1, 0)
end

--- Helper function.
local function helper_139dc()
	local var0: f32 = 0
	local var1: f32 = 0
	local argc: s32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 70 then
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			helper_12478()
		else
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				helper_12cb0()
			else
				helper_1330c()
			end
		end
	elseif var0 < 150.0 then
		helper_11e08()
	else
		var1 = monster.GetTargetAngle() or var1
		if var1 > vm.f32(3.1415927) then
			var1 = vm.f32(var1 - vm.f32(6.2831855))
		end
		if var1 <= vm.f32(-3.1415927) then
			var1 = vm.f32(var1 + vm.f32(6.2831855))
		end
		if var1 < 0.0 then
			helper_10aa4()
		else
			helper_11438()
		end
	end
end

--- Helper function.
local function helper_14bcc()
	local var0: f32 = 0
	var0 = monster.GetTargetDist() or var0
	if var0 < 9999.0 and var0 >= 400.0 then
		helper_14530()
	elseif var0 < 400.0 and var0 >= 150.0 then
		helper_13e94()
	else
		helper_139dc()
	end
end

--- Helper function.
local function helper_cef8()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	helper_1c04()
	monster.SetActStatus(1)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetDmg2("弱攻撃", 15.4, "攻撃１", 0.13, 0.17, 2, 1)
	monster.SetDmg2("弱攻撃", 15.4, "攻撃１", 0.13, 0.192, 4, 0)
	monster.SetDmg2("弱攻撃", 11.4, "攻撃１", 0.329, 0.363, 2, 3)
	monster.SetDmg2("通常攻撃", 11.4, "攻撃１", 0.555, 0.589, 4, 5)
	monster.SetDmg2("通常攻撃", 11.4, "攻撃１", 0.555, 0.589, 2, 3)
	monster.SetDmg2("中ＢＧＣ", 11.4, "攻撃１", 0.705, 0.74, 2, 3)
	monster.SetDmg2("中ＢＧＣ", 11.4, "攻撃１", 0.705, 0.74, 4, 5)
	monster.SetDmg2("通常ＢＧＣ", 11.4, "攻撃３", 0.602, 0.682, 4, 5)
	monster.SetDmg2("通常ＢＧＣ", 11.4, "攻撃３", 0.602, 0.682, 2, 3)
	monster.LoadEffectScript("クロスカッター")
	monster.SwEffect(0, "攻撃１", 0.123, 0.6, "dcol_l00", "dcol_l01", 75, 30, 45)
	monster.SwEffect(1, "攻撃１", 0.123, 0.6, "dcol_r00", "dcol_r01", 75, 30, 45)
	monster.SwEffect(0, "攻撃２", 0.26, 0.264, "dcol_l00", "dcol_l01", 75, 30, 45)
	monster.SwEffect(1, "攻撃２", 0.26, 0.264, "dcol_r00", "dcol_r01", 75, 30, 45)
	monster.SwEffect(0, "攻撃３", 0.477, 0.48, "dcol_l00", "dcol_l01", 75, 30, 45)
	monster.SwEffect(1, "攻撃３", 0.477, 0.48, "dcol_r00", "dcol_r01", 75, 30, 45)
	monster.SwEffect(0, "挑発", 0.28, 0.284, "dcol_l00", "dcol_l01", 75, 30, 45)
	monster.SetClipDist(9999.9)
	monster.SetCameraMode(4)
	monster.SetMonsterLife(0.67)
	monster.VPush(7, 0)
	helper_1eec()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetAttrib(32, 0)
	monster.SetMos("構え立ち", -1, 4)
	while true do
		vm.wait()
		helper_18c8()
		helper_14bcc()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_10660(helper_9df6409a(12))
	monster.SetMos("構え立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_cef8()
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
		helper_11e08()
	else
		var1 = monster.GetTargetAngle() or var1
		if var1 < 0.0 then
			helper_10aa4()
		else
			helper_11438()
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
		helper_5cd0(vm.f32(4.2))
		helper_12cb0()
	else
		var1 = monster.GetTargetAngle() or var1
		if var1 > vm.f32(3.1415927) then
			var1 = vm.f32(var1 - vm.f32(6.2831855))
		end
		if var1 <= vm.f32(-3.1415927) then
			var1 = vm.f32(var1 + vm.f32(6.2831855))
		end
		if var1 < 0.0 then
			helper_10aa4()
		else
			helper_11438()
		end
	end
	monster.SetMos("構え立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_18c8()
	monster.SetMonsterLife(0.34)
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
