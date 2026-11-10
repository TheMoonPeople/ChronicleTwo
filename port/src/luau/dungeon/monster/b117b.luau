--!strict
-- dungeon/monster/b117b.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_0fd3af5e = require("@lib/monster/helper_0fd3af5e")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1aaed117 = require("@lib/monster/helper_1aaed117")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28c0718c = require("@lib/monster/helper_28c0718c")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_4e8d4c3a = require("@lib/monster/helper_4e8d4c3a")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9b0f992 = require("@lib/monster/helper_b9b0f992")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d8c5ceae = require("@lib/monster/helper_d8c5ceae")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

--- Helper function.
local function helper_1c5c()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_damage_hit("通常攻撃", 2.5, "攻撃１", 0.5, 0.75, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 3.0, "攻撃１", 0.5, 0.75, 1)
	monster.register_damage_hit("通常攻撃", 2.5, "攻撃２", 0.5, 0.8, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 3.0, "攻撃２", 0.5, 0.8, 1)
	monster.register_damage_hit("通常攻撃", 6.0, "攻撃２", 0.15, 0.8, 2)
	monster.add_sword_trail(0, "攻撃１", 0.32, 0.37, "dcol1", "dcol0", 77, 20, 20)
	monster.add_sword_trail(0, "攻撃２", 0.5, 0.53, "dcol1", "dcol0", 77, 20, 20)
	monster.set_variable(64, 0)
	monster.load_effect_script("ＳウェーブＬ")
	helper_1c5c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		var0 = monster.get_target_distance() or var0
		if var0 < 240.0 then
			helper_4e8d4c3a()
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			monster.set_motion("歩き", 0.6, 0)
			helper_b9b0f992(vm.f32(2.4), 4.0, 49.0, 90)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Reacts to a hit while greyed out, or to a hit that greys it out.
function script.on_status_hit()
	local var0: s32 = 0
	helper_5d37e9f4()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	var0 = 1
	while var0 ~= 0 do
		var0 = monster.get_status_ailments(40) or var0
		vm.wait()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
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
	helper_c3e8ae39(3)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("ガードin", -1, 6)
	helper_56d63eae()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_c3e8ae39(8)
	monster.set_motion("ガードout", -1, 2)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	local argc: s32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	monster.set_rotation(0.0, var0, 0.0)
	vm.wait()
	argc = monster.get_random(20) or argc
	if argc < 20 then
		monster.set_motion("歩き", 0.65, 0)
		helper_890ee63a(4.0)
		helper_28c0718c()
		monster.set_motion("歩き", 0.65, 0)
		helper_890ee63a(4.0)
		monster.set_motion("立ち", -1, 0)
	else
		var0 = monster.get_target_angle() or var0
		monster.set_rotation(0.0, var0, 0.0)
		vm.wait()
		helper_d8c5ceae()
		monster.set_motion("歩き", 0.65, 0)
		helper_890ee63a(4.0)
		monster.set_motion("立ち", -1, 0)
	end
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.set_motion("ガードin", -1, 6)
	helper_56d63eae()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_c3e8ae39(8)
	monster.set_motion("ガードout", -1, 2)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	local value: s32 = 0
	value = monster.get_variable(64) or value
	monster.set_variable(64, vm.i32(value + 1))
	helper_02ce7891()
	monster.set_motion("死に", -1, 2)
	helper_56d63eae()
	monster.spawn_death_effects()
	helper_c3e8ae39(30)
	value = monster.get_variable(64) or value
	if value == 2 then
		helper_1aaed117()
		monster.request_event_script(504)
	end
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
	helper_0fd3af5e()
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
