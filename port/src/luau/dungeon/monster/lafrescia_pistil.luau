--!strict
--- Controls the pistil of the Lafrescia plant, which droops and releases pollen as it is hit.

local vm = require("@lib/vm")
local motion = require("@lib/monster/motion")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Plays the idle motion for as long as the pistil is alive.
local function idle_sway()
	monster.set_motion("待機", -1, 4)
	while true do
		state.do_nothing()
		vm.wait()
	end
	motion.wait_until_ended()
end

--- Spawns pollen and asks the fight to continue once the pistil has taken its final hit.
local function release_pollen_if_ready()
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

--- Counts the hit, sways while waiting for the next phase, then droops back down and recovers.
local function rise_and_sway_after_hit()
	local value: s32 = 0
	monster.set_motion("もちあがる", -1, 2)
	monster.play_sound(3)
	motion.wait_until_finished()
	monster.play_sound(2)
	value = monster.get_variable(17) or value
	value = vm.i32(value + 1)
	monster.set_variable(17, value)
	if value == 6 then
		monster.set_variable(17, 7)
	end
	monster.set_motion("ゆれる", -1, 4)
	release_pollen_if_ready()
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
	motion.wait_until_ended()
	monster.stop_sound(2)
	monster.set_motion("たれる", -1, 6)
	monster.play_sound(4)
	motion.wait_until_finished()
	monster.set_life(1.0)
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Configures the pistil's attributes, pollen effects and body.
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

--- Idles forever.
function script.loop()
	while true do
		idle_sway()
	end
end

--- Lifts the pistil and lets it droop back.
function script.on_damage()
	monster.set_motion("もちあがる", -1, 2)
	monster.play_sound(3)
	motion.wait_until_finished()
	monster.set_motion("たれる", -1, 6)
	monster.play_sound(4)
	motion.wait_until_finished()
end

--- Lifts the pistil and lets it droop back.
function script.on_knockdown()
	monster.set_motion("もちあがる", -1, 2)
	monster.play_sound(3)
	motion.wait_until_finished()
	monster.set_motion("たれる", -1, 6)
	monster.play_sound(4)
	motion.wait_until_finished()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores guarding.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the first dodge.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the second dodge.
function script.on_dodge_2() end

--- Runs the monster's death.
script.on_death = rise_and_sway_after_hit

--- Holds the pistil still while it is caught.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Waits for the pistil to touch the ground after a throw and then resets its movement.
function script.on_land()
	local height: f32 = 0
	while true do
		height = monster.get_height_above_ground() or height
		if height < vm.f32(0.1) then
			timer.wait_frames(3)
			monster.end_throw()
			monster.stop_moving()
			timer.wait_frames(30)
			return 1
		end
		vm.wait()
	end
end

return script
