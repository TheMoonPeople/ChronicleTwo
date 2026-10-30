--!strict
-- dungeon/monster/f20a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_7000e3dd = require("@lib/monster/helper_7000e3dd")
local helper_a0d4bba7 = require("@lib/monster/helper_a0d4bba7")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_dbfe0a16 = require("@lib/monster/helper_dbfe0a16")

--- Helper function.
local function helper_1b98()
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
	monster.register_damage_hit("吹っ飛び攻撃", 12.0, "攻撃２", 0.216, 0.432, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 12.0, "攻撃２", 0.216, 0.432, 1)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	monster.set_variable(4, 0)
	monster.set_monster_attributes(32, 1)
	monster.set_monster_attributes(1, 1)
	monster.set_clip_distance(9999.9)
	helper_1b98()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local argc: s32 = 0
	local value: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	value = monster.get_variable(9) or value
	if value ~= 0 then
		monster.set_life(0.0)
		argc = monster.get_random(4) or argc
		if argc == 0 then
			monster.set_position(33.44, -22.94, 363.45)
			monster.move_toward_position(-7.18, 10.11, 543.91, 6.0, 6.0)
		end
		if argc == 1 then
			monster.set_position(257.2, -38.39, 408.11)
			monster.move_toward_position(241.39, -7.5200005, 515.61, 6.0, 6.0)
		end
		if argc == 2 then
			monster.set_position(471.54, -26.47, 459.18)
			monster.move_toward_position(457.83, -4.71, 537.63, 5.0, 5.0)
		end
		if argc == 3 then
			monster.set_position(-279.93, -35.18, 325.86)
			monster.move_toward_position(-296.07, -2.6000004, 437.14, 5.0, 5.0)
		end
		helper_c3e8ae39(30)
		monster.stop_moving()
		monster.set_life(1.0)
	else
		monster.set_variable(9, 1)
		monster.set_position(-81.2, 1.8, 851.5)
		monster.set_rotation(0.0, 3.1415927, 0.0)
	end
	monster.set_motion("通常", -1, 4)
	while true do
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	local value: s32 = 0
	helper_5d37e9f4()
	value = monster.get_variable(4) or value
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("立ち")
	monster.set_variable(4, vm.i32(value + 1))
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d8cf1050()
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_dbfe0a16()
	helper_7000e3dd()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	helper_a551797e()
end

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
	local value: s32 = 0
	value = monster.get_variable(8) or value
	if value == 128 then
		monster.set_monster_attributes(2, 1)
		monster.set_life(0.0)
		helper_02ce7891()
		monster.set_motion("死に", -1, 2)
		helper_56d63eae()
		monster.spawn_death_effects()
		while true do
			vm.wait()
		end
	end
	helper_aa93a1aa()
	monster.stop_moving()
	monster.end_throw()
	helper_b44b0a55()
	monster.set_monster_attributes(2, 1)
	monster.set_life(0.0)
	helper_02ce7891()
	monster.set_motion("死に", -1, 2)
	helper_56d63eae()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	helper_a0d4bba7()
	return 1
end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
