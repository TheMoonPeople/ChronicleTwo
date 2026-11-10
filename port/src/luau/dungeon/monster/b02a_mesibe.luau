--!strict
-- dungeon/monster/b02a_mesibe.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_f683d690 = require("@lib/monster/helper_f683d690")

--- Helper function.
local function helper_2d6c()
	monster.set_motion("待機", -1, 4)
	while true do
		helper_1ef0d4b2()
		vm.wait()
	end
	helper_f683d690()
end

--- Helper function.
local function helper_2460()
	local value: s32 = 0
	local value_2: s32 = 0
	value = monster.get_variable(17) or value
	if value ~= 7 then
		return
	end
	monster.create_effect_1("ラフレシア花粉")
	value_2 = monster.get_variable(8) or value_2
	if value_2 == 0 then
		monster.set_variable(8, 16)
	end
end

--- Helper function.
local function helper_2670()
	local value: s32 = 0
	monster.set_motion("もちあがる", -1, 2)
	monster.play_sound(3)
	helper_56d63eae()
	monster.play_sound(2)
	value = monster.get_variable(17) or value
	value = vm.i32(value + 1)
	monster.set_variable(17, value)
	if value == 6 then
		monster.set_variable(17, 7)
	end
	monster.set_motion("ゆれる", -1, 4)
	helper_2460()
	while true do
		vm.wait()
		value = monster.get_variable(17) or value
		if value == 0 then
			break
		elseif value == 7 then
			value = monster.get_variable(8) or value
			if value == 0 then
				monster.set_variable(17, 0)
				break
			end
		end
	end
	helper_f683d690()
	monster.stop_sound(2)
	monster.set_motion("たれる", -1, 6)
	monster.play_sound(4)
	helper_56d63eae()
	monster.set_life(1.0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(1, 1)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_clip_distance(9999.9)
	monster.set_monster_attributes(4, 1)
	monster.load_effect_script("ラフレシア花粉")
	monster.load_effect_script("ラフレシア花粉サブ")
	monster.register_entry_object(0, "shokushu")
	monster.set_body(0, 12.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	while true do
		helper_2d6c()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.set_motion("もちあがる", -1, 2)
	monster.play_sound(3)
	helper_56d63eae()
	monster.set_motion("たれる", -1, 6)
	monster.play_sound(4)
	helper_56d63eae()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.set_motion("もちあがる", -1, 2)
	monster.play_sound(3)
	helper_56d63eae()
	monster.set_motion("たれる", -1, 6)
	monster.play_sound(4)
	helper_56d63eae()
end

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
script.on_death = helper_2670

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
		height = monster.get_height_above_ground() or height
		if height < vm.f32(0.1) then
			helper_c3e8ae39(3)
			monster.end_throw()
			monster.stop_moving()
			helper_c3e8ae39(30)
			return 1
		end
		vm.wait()
	end
end

return script
