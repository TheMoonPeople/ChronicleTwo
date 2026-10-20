--!strict
-- dungeon/monster/e113a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_206033b2 = require("@lib/monster/helper_206033b2")
local helper_2db2fc96 = require("@lib/monster/helper_2db2fc96")
local helper_2e729f21 = require("@lib/monster/helper_2e729f21")
local helper_2f2adeb4 = require("@lib/monster/helper_2f2adeb4")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_48852a90 = require("@lib/monster/helper_48852a90")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65df8bdc = require("@lib/monster/helper_65df8bdc")
local helper_68e24e97 = require("@lib/monster/helper_68e24e97")
local helper_72fec261 = require("@lib/monster/helper_72fec261")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_8191476b = require("@lib/monster/helper_8191476b")
local helper_83dc8947 = require("@lib/monster/helper_83dc8947")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_905c94a1 = require("@lib/monster/helper_905c94a1")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_a2d828a7 = require("@lib/monster/helper_a2d828a7")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_b0ab6794 = require("@lib/monster/helper_b0ab6794")
local helper_b33c6f49 = require("@lib/monster/helper_b33c6f49")
local helper_beda02f3 = require("@lib/monster/helper_beda02f3")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_c8f4a8bd = require("@lib/monster/helper_c8f4a8bd")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e2fdabb9 = require("@lib/monster/helper_e2fdabb9")
local helper_f7a409dc = require("@lib/monster/helper_f7a409dc")
local helper_ff67a99d = require("@lib/monster/helper_ff67a99d")

local global1: f32 = 0

--- Helper function.
local function helper_1ba0()
	local boss: s32 = 0
	global1 = 0.0
	boss = monster.GetBossFlag() or boss
	if boss == 0 then
		do
			local _, out2, _ = monster.GetPos_3()
			global1 = out2 or global1
		end
		monster.SetClipDist(35.0)
	else
		monster.SetClipDist(999999.0)
	end
	global1 = 0.0
end

--- Helper function.
local function helper_18598()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	monster.ResetMotion()
	monster.SetMos("攻撃１", -1, 6)
	helper_48852a90(vm.f32(4.8), vm.f32(0.42), -1.0)
	helper_48852a90(vm.f32(4.8), vm.f32(0.39), -1.0)
	do
		local out1, out2, out3 = monster.GetFramePos("dcol0")
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
	attack = monster.GetBaseAttack_1() or attack
	monster.EsmCreate_1("雷弾Ｆ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var3, var4, var5)
	helper_72fec261(vm.f32(0.42), -1.0)
	monster.EsmCreate_1("雷弾Ｌ")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, var3, var4, var5)
	monster.EsmSetValue(-1, 0, attack)
	helper_56d63eae()
end

--- Helper function.
local function helper_1bdcc()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	if argc < 65 then
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		helper_18598()
		monster.SetMos("立ち", -1, 0)
		helper_c3e8ae39(15)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			var1 = -45.0
		else
			var1 = 45.0
		end
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		monster.SetMos("歩き", -1, 0)
		var2 = monster.GetTargetDist() or var2
		helper_65df8bdc(2.0, vm.f32(4.8), var1, var2, 35.0, 25.0, 60)
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(vm.f32(2.4))
		monster.SetMos("立ち", -1, 0)
		helper_7ca8a12f(35.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_18bc0(arg0: f32, arg1: f32, arg2: s32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	monster.SetMos("歩き", -1, 0)
	helper_890ee63a(vm.f32(4.8))
	var9 = monster.GetTargetDist() or var9
	var9 = vm.f32(var9 + arg0)
	arg1 = helper_787df986(arg1)
	var8 = monster.GetTargetAngle() or var8
	var8 = vm.f32(var8 - vm.f32(3.1415927))
	var8 = vm.f32(var8 + arg1)
	if var8 > vm.f32(3.1415927) then
		var8 = vm.f32(var8 - vm.f32(6.2831855))
	end
	if var8 <= vm.f32(-3.1415927) then
		var8 = vm.f32(var8 + vm.f32(6.2831855))
	end
	if arg2 == 1 then
		monster.SetMos("ステップ右", -1, 0)
	else
		monster.SetMos("ステップ左", -1, 0)
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var8) * var9))
	pos_y = global1
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var8) * var9))
	helper_68e24e97(pos_x, pos_y, pos_z, 4.0, 4.0, 5.0, vm.idiv(arg3, 2))
	helper_68e24e97(pos_x, pos_y, pos_z, 4.0, 4.0, 25.0, vm.idiv(arg3, 2))
end

--- Helper function.
local function helper_19410()
	local argc: s32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		helper_18bc0(50.0, 150.0, 1, 30)
	else
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		helper_18bc0(50.0, -150.0, 0, 30)
	end
end

--- Helper function.
local function helper_1b5cc()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 60 then
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(vm.f32(4.8))
			helper_18598()
			monster.SetMos("立ち", -1, 0)
			helper_c3e8ae39(15)
		else
			helper_19410()
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(vm.f32(9.6))
			helper_18598()
			monster.SetMos("立ち", -1, 0)
			helper_c3e8ae39(15)
		end
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			var2 = -45.0
		else
			var2 = 45.0
		end
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		monster.SetMos("歩き", -1, 0)
		var1 = monster.GetTargetDist() or var1
		var1 = vm.f32(var1 + 10.0)
		helper_65df8bdc(2.0, vm.f32(4.8), var2, var1, 35.0, 25.0, 60)
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(vm.f32(2.4))
		monster.SetMos("立ち", -1, 0)
		helper_7ca8a12f(35.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_1ac40()
	local argc: s32 = 0
	local var1: f32 = 0
	monster.GetMonsterLifeInt()
	var1 = monster.GetTargetDist() or var1
	if var1 < 40.0 then
		monster.SetMos("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		helper_18598()
		monster.SetMos("立ち", -1, 0)
		helper_c3e8ae39(21)
	end
	argc = monster.GetRnd(100) or argc
	if argc < 60 then
		argc = monster.GetRnd(100) or argc
		if argc < 60 then
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(vm.f32(4.8))
			helper_18598()
			monster.SetMos("立ち", -1, 0)
			helper_c3e8ae39(15)
		else
			helper_19410()
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(vm.f32(9.6))
			helper_18598()
			monster.SetMos("立ち", -1, 0)
			helper_c3e8ae39(15)
		end
	else
		argc = monster.GetRnd(100) or argc
		if argc < 30 then
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(vm.f32(4.8))
			helper_c8f4a8bd(3.0)
			monster.SetMos("立ち", -1, 0)
		else
			monster.SetMos("歩き", -1, 0)
			helper_890ee63a(2.0)
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				helper_beda02f3(2.0, 215.0, 100.0, 35.0, 25.0, 20)
			else
				helper_beda02f3(2.0, 145.0, 100.0, 35.0, 25.0, 20)
			end
		end
	end
end

--- Helper function.
local function helper_1c370()
	local var3: f32 = 0
	local priority: s32 = 0
	while true do
		vm.wait()
		helper_8191476b()
		var3 = monster.GetTargetDist() or var3
		if var3 > 240.0 then
			vm.wait()
			return
		end
		priority = monster.GetPriority() or priority
		if priority > 1 then
			helper_f7a409dc()
			continue
		end
		if var3 < 240.0 and var3 >= 200.0 then
			helper_1bdcc()
		elseif var3 < 200.0 and var3 >= 120.0 then
			helper_1b5cc()
		else
			helper_1ac40()
		end
	end
end

--- Helper function.
local function helper_1a3e0()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	while true do
		vm.wait()
		var3 = monster.GetTargetDist() or var3
		if var3 > 240.0 then
			vm.wait()
			return
		end
		priority = monster.GetPriority() or priority
		if priority > 2 then
			helper_f7a409dc()
			continue
		end
		if var3 < 120.0 then
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(vm.f32(4.8))
				helper_18598()
				monster.SetMos("立ち", -1, 0)
				helper_c3e8ae39(5)
			else
				helper_19410()
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(vm.f32(9.6))
				helper_18598()
				monster.SetMos("立ち", -1, 0)
				helper_c3e8ae39(5)
			end
		else
			argc = monster.GetRnd(100) or argc
			if argc < 60 then
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(vm.f32(4.8))
				helper_18598()
				monster.SetMos("立ち", -1, 0)
				helper_c3e8ae39(5)
			else
				helper_19410()
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(vm.f32(9.6))
				helper_18598()
				monster.SetMos("立ち", -1, 0)
				helper_c3e8ae39(5)
			end
		end
	end
end

--- Helper function.
local function helper_19b30()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	var4 = monster.GetTargetDist() or var4
	monster.SetAttrib(32, 1)
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("ステップ右", -1, 0)
		var5 = 60.0
	else
		monster.SetMos("ステップ左", -1, 0)
		var5 = -60.0
	end
	var1, var2, var3 = helper_125e5305(var5, var4, var1, var2, var3)
	helper_68e24e97(var1, global1, var3, 3.0, 3.0, 25.0, 10)
	monster.SetAttrib(32, 0)
	helper_b0ab6794(30)
	monster.ResetMove()
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
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.LoadEffectScript("雷弾Ｆ", get_not_used_texb) or var1
		var2 = monster.LoadEffectScript("雷弾Ｌ", get_not_used_texb) or var2
		var3 = monster.LoadEffectScript("雷弾Ｈ", get_not_used_texb) or var3
		if (if (if var1 ~= 0 then 1 else var2) ~= 0 then 1 else var3) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	helper_b33c6f49()
	helper_ac26cdde(30.0)
	helper_1ba0()
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.SetPos(pos_x, vm.f32(pos_y + 25.0) - 10.0, pos_z)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local gekirin: s32 = 0
	local var1: f32 = 0
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
		if gekirin > 0 then
			helper_8191476b()
			var1 = helper_e2fdabb9(var1)
			if var1 < 240.0 then
				helper_1c370()
			else
				helper_ff67a99d()
			end
		else
			helper_1a3e0()
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
	helper_5d37e9f4()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(16)
	monster.SetMos("立ち", -1, 0)
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_a2d828a7()
	monster.SetMos("吹っ飛び", -1, 6)
	monster.BlowStart(3.0, 0.05, 25)
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
	monster.SetMos("ガード入り", -1, 6)
	helper_56d63eae()
	monster.SetMos("ガード", -1, 6)
	monster.BlowStart(3.0, 0.0, 2)
	helper_56d63eae()
	helper_c3e8ae39(8)
	monster.SetMos("ガード戻り", -1, 6)
	helper_56d63eae()
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	monster.ResetMove()
	helper_442b9962()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	helper_93495fdf()
	vm.wait()
	monster.SetMos("歩き", -1, 0)
	helper_890ee63a(vm.f32(4.8))
	helper_19b30()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.ResetMove()
	helper_442b9962()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.SetMos("歩き", -1, 0)
	helper_890ee63a(vm.f32(4.8))
	helper_19b30()
	helper_93495fdf()
	vm.wait()
	helper_56d63eae()
	monster.SetMos("よけるもどり", -1, 6)
	helper_56d63eae()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_83dc8947()
	monster.SetMos("死に", -1, 2)
	helper_56d63eae()
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_2db2fc96()
	monster.SetMos("じたばた", -1, 4)
	helper_206033b2()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_2f2adeb4()
	helper_317bfc18(1)
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	helper_2e729f21()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.SetMos("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.SetMos("吹っ飛びループ", -1, 6)
	helper_56d63eae()
	monster.SetMos("起き上がり", -1, 6)
	helper_56d63eae()
	monster.SetMos("気絶", -1)
	helper_e05438b5()
end

return script
