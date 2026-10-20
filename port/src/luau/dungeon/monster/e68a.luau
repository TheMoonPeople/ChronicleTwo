--!strict
-- dungeon/monster/e68a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_06e3d1fa = require("@lib/monster/helper_06e3d1fa")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ae935f0 = require("@lib/monster/helper_1ae935f0")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_2cbec963 = require("@lib/monster/helper_2cbec963")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_6f1cb0ef = require("@lib/monster/helper_6f1cb0ef")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b0d7af09 = require("@lib/monster/helper_b0d7af09")
local helper_bf1e34ad = require("@lib/monster/helper_bf1e34ad")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_c6577076 = require("@lib/monster/helper_c6577076")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

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
local function helper_12420()
	local argc: s32 = 0
	vm.wait()
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("立ち", -1, 0)
		helper_890ee63a(10.0)
		helper_1ae935f0(12.0, 20.0, 0.5, 30)
		monster.SetMos("立ち", -1, 0)
		helper_c3e8ae39(15)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			monster.SetMos("立ち", -1, 0)
			helper_7ca8a12f(100.0, 45.0, 30)
		else
			monster.SetMos("立ち", -1, 0)
			helper_890ee63a(10.0)
			helper_c6577076()
		end
	end
end

--- Helper function.
local function helper_12008()
	local argc: s32 = 0
	vm.wait()
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("立ち", -1, 0)
		helper_890ee63a(10.0)
		helper_1ae935f0(9.0, 10.0, 0.5, 30)
		monster.SetMos("立ち", -1, 0)
		helper_c3e8ae39(15)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			monster.SetMos("立ち", -1, 0)
			helper_890ee63a(10.0)
			helper_b0d7af09()
		else
			monster.SetMos("立ち", -1, 0)
			helper_890ee63a(10.0)
			helper_c6577076()
		end
	end
end

--- Helper function.
local function helper_11b9c()
	local argc: s32 = 0
	local var2: f32 = 0
	monster.GetMonsterLifeInt()
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("立ち", -1, 0)
		helper_890ee63a(10.0)
		helper_b0d7af09()
		var2 = monster.GetTargetDist() or var2
		if var2 < 50.0 then
			argc = monster.GetRnd(3) or argc
			helper_2cbec963(vm.i32(1 + argc))
			monster.SetMos("立ち", -1, 0)
		end
	else
		monster.SetMos("立ち", -1, 0)
		helper_890ee63a(10.0)
		helper_1ae935f0(4.0, 0.0, 0.5, 32)
		monster.SetMos("立ち", -1, 0)
		helper_c3e8ae39(15)
	end
end

--- Helper function.
local function helper_12850()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		helper_06e3d1fa()
		var3 = monster.GetTargetDist() or var3
		if var3 > 280.0 then
			vm.wait()
			return
		end
		gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
		if gekirin == 0 then
			vm.wait()
			return
		end
		priority = monster.GetPriority() or priority
		if priority > 4 then
			helper_bf1e34ad()
			continue
		end
		if var3 < 280.0 and var3 >= 150.0 then
			helper_12420()
		elseif var3 < 150.0 and var3 >= 80.0 then
			helper_12008()
		else
			helper_11b9c()
		end
		vm.wait()
	end
end

--- Helper function.
local function helper_1121c()
	local var3: f32 = 0
	local priority: s32 = 0
	local argc: s32 = 0
	local var6: f32 = 0
	while true do
		vm.wait()
		var3 = monster.GetTargetDist() or var3
		if var3 > 280.0 then
			vm.wait()
			return
		end
		priority = monster.GetPriority() or priority
		if priority > 5 then
			helper_bf1e34ad()
			continue
		end
		if var3 < 80.0 then
			argc = monster.GetRnd(100) or argc
			if argc < 40 then
				monster.SetMos("立ち", -1, 0)
				helper_890ee63a(10.0)
				helper_b0d7af09()
				var6 = monster.GetTargetDist() or var6
				if var6 < 50.0 then
					argc = monster.GetRnd(3) or argc
					helper_2cbec963(vm.i32(1 + argc))
					monster.SetMos("立ち", -1, 0)
				end
			else
				monster.SetMos("立ち", -1, 0)
				helper_890ee63a(10.0)
				helper_1ae935f0(4.0, 0.0, 0.5, 32)
				monster.SetMos("立ち", -1, 0)
			end
		elseif var3 <= 280.0 and var3 > 150.0 then
			monster.SetMos("立ち", -1, 0)
			helper_890ee63a(10.0)
			helper_1ae935f0(12.0, 20.0, 0.5, 30)
			monster.SetMos("立ち", -1, 0)
			helper_c3e8ae39(2)
		else
			monster.SetMos("立ち", -1, 0)
			helper_890ee63a(10.0)
			helper_1ae935f0(9.0, 10.0, 0.5, 30)
			monster.SetMos("立ち", -1, 0)
			helper_c3e8ae39(2)
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
	monster.SetDmg2("Ｍ連撃１", 6.6, "攻撃１", 0.25, 0.38, 0)
	monster.SetDmg2("Ｍ連撃１", 6.6, "攻撃１", 0.438, 0.59, 1)
	get_not_used_texb = monster.EsmGetNotuesdTexb() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.LoadEffectScript("毒液2L", get_not_used_texb) or var1
		var2 = monster.LoadEffectScript("毒液H", get_not_used_texb) or var2
		if (if var1 ~= 0 then 1 else var2) ~= 0 then
			monster.EsmAddTexb()
		end
	end
	helper_1c5c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local gekirin: s32 = 0
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetAttrib(128, 1)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
		if gekirin > 0 then
			helper_06e3d1fa()
			helper_6f1cb0ef()
			helper_12850()
		else
			helper_1121c()
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
	helper_c3e8ae39(12)
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d8cf1050()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.SetMos("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.ResetMotion()
	monster.SetMos("ガード入り", -1, 6)
	helper_56d63eae()
	monster.SetMos("ガード", -1, 0)
	helper_c3e8ae39(8)
	monster.SetMos("立ち")
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.SetMos("立ち", -1, 0)
	helper_890ee63a(10.0)
	helper_1ae935f0(12.0, 20.0, 0.5, 30)
	monster.SetMos("立ち", -1, 0)
	helper_c3e8ae39(15)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	monster.SetMos("死に", -1, 6)
	helper_56d63eae()
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.SetMos("ダメージ", -1, 6)
	helper_56d63eae()
	helper_e05438b5()
end

return script
