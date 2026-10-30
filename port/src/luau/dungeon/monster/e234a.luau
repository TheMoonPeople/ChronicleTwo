--!strict
-- dungeon/monster/e234a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1bc83184 = require("@lib/monster/helper_1bc83184")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_3045af93 = require("@lib/monster/helper_3045af93")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_5f5c205e = require("@lib/monster/helper_5f5c205e")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_898ea8a6 = require("@lib/monster/helper_898ea8a6")
local helper_93a51a2c = require("@lib/monster/helper_93a51a2c")
local helper_95b679db = require("@lib/monster/helper_95b679db")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b6a7c54a = require("@lib/monster/helper_b6a7c54a")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

local global1: f32 = 0

--- Helper function.
local function helper_1b98()
	local boss: s32 = 0
	global1 = 0.0
	boss = monster.is_boss() or boss
	if boss == 0 then
		do
			local _, out2, _ = monster.get_position_3()
			global1 = out2 or global1
		end
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
	global1 = 0.0
end

--- Helper function.
local function helper_e0ac(arg0: f32)
	local argc: s32 = 0
	local target: f32 = 0
	local var3: f32 = 0
	local target_3: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	var5 = monster.get_target_distance() or var5
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(6.0)
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.reset_motion()
		monster.set_motion("歩き右", -1, 6)
		var6 = 30.0
	else
		monster.reset_motion()
		monster.set_motion("歩き左", -1, 6)
		var6 = -30.0
	end
	target, var3, target_3 = helper_125e5305(var6, var5, target, var3, target_3)
	helper_7ca8a12f(40.0, 45.0, 7)
	monster.move_toward_position(target, global1, target_3, arg0, arg0)
	monster.set_monster_attributes(32, 1)
	helper_7ca8a12f(40.0, 45.0, 9)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_56d63eae()
end

--- Helper function.
local function helper_fde4()
	local argc: s32 = 0
	local var4: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 50 then
		helper_1bc83184()
	else
		argc = monster.get_random(100) or argc
		if argc < 40 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				helper_e0ac(3.0)
			else
				helper_3045af93(3.0)
			end
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var4 = -30.0
				monster.set_motion("歩き左", -1, 0)
			else
				var4 = 30.0
				monster.set_motion("歩き右", -1, 0)
			end
			helper_95b679db(2.0, var4, 3.0, 45)
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_112bc()
	local var0: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		var0 = monster.get_target_distance() or var0
		if var0 > 175.0 then
			vm.wait()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			helper_93a51a2c()
			continue
		end
		if var0 < 175.0 and var0 >= 140.0 then
			helper_b6a7c54a()
		elseif var0 < 140.0 and var0 >= 90.0 then
			helper_5f5c205e()
		else
			helper_fde4()
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("通常攻撃", 5.0, "攻撃１", 0.382, 0.697, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 6.0, "攻撃２", 0.522, 0.652, 1)
	helper_1b98()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		helper_898ea8a6()
		helper_112bc()
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d8cf1050()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_56d63eae()
	monster.set_action_status(1)
	helper_c3e8ae39(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	local argc: s32 = 0
	helper_ab4b367a()
	argc = monster.get_random(100) or argc
	if argc < 65 then
		monster.reset_motion()
		monster.set_motion("ガード入り", -1, 6)
		helper_56d63eae()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		helper_c3e8ae39(8)
		monster.set_motion("ガード戻り", -1, 6)
		helper_56d63eae()
		monster.set_motion("立ち")
	else
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(15.0)
		monster.reset_motion()
		monster.set_motion("ガード入り", -1, 6)
		helper_56d63eae()
		monster.set_motion("ガード", -1, 0)
		monster.start_knockback(3.0, 0.0, 2)
		helper_c3e8ae39(60)
		monster.set_motion("ガード戻り", -1, 6)
		helper_56d63eae()
		monster.set_motion("立ち")
	end
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_3045af93(3.0)
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	helper_e0ac(3.0)
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	monster.set_motion("死に", -1, 2)
	helper_56d63eae()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_aa93a1aa()
	monster.stop_moving()
	monster.end_throw()
	helper_c3e8ae39(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_e05438b5()
end

return script
