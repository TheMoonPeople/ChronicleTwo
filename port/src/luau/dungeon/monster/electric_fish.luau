--!strict
--- Controls the electric fish, which appears at one of several random spots, swims toward a point and fades out.

local vm = require("@lib/vm")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the distance beyond which the monster stops being processed, unlimited for bosses.
local function initialize_clip_distance()
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

--- Does nothing at load time.
function script.setup() end

--- Registers the attack hit windows and clears the monster variables.
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
	initialize_clip_distance()
end

--- Places the fish at a random spawn point on its first run, swims it toward a point and then idles.
function script.loop()
	local spawn_point: s32 = 0
	local has_spawned: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	has_spawned = monster.get_variable(9) or has_spawned
	if has_spawned ~= 0 then
		monster.set_life(0.0)
		spawn_point = monster.get_random(4) or spawn_point
		if spawn_point == 0 then
			monster.set_position(33.44, -22.94, 363.45)
			monster.move_toward_position(-7.18, 10.11, 543.91, 6.0, 6.0)
		end
		if spawn_point == 1 then
			monster.set_position(257.2, -38.39, 408.11)
			monster.move_toward_position(241.39, -7.5200005, 515.61, 6.0, 6.0)
		end
		if spawn_point == 2 then
			monster.set_position(471.54, -26.47, 459.18)
			monster.move_toward_position(457.83, -4.71, 537.63, 5.0, 5.0)
		end
		if spawn_point == 3 then
			monster.set_position(-279.93, -35.18, 325.86)
			monster.move_toward_position(-296.07, -2.6000004, 437.14, 5.0, 5.0)
		end
		timer.wait_frames(30)
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

--- Plays the flinch reaction and counts the hit.
function script.on_damage()
	local hit_count: s32 = 0
	state.stop_and_clear_action()
	hit_count = monster.get_variable(4) or hit_count
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	monster.set_variable(4, vm.i32(hit_count + 1))
	state.do_nothing()
end

--- Faces the target while knocked down.
function script.on_knockdown()
	state.lock_and_face_target()
	state.unlock_and_clear_action()
end

--- Restores the stance after a guard.
function script.on_guard()
	state.restore_mask_flag_2_and_stand()
	state.clear_mask_flag_2()
end

--- Dodges by resetting the motion.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Dodges by resetting the motion.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Runs the monster's death.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so that the engine skips its default death.
function script.on_death() end

--- Waits forever while held.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Plays the death motion and effects after being thrown.
function script.on_land()
	local state_flag: s32 = 0
	state_flag = monster.get_variable(8) or state_flag
	if state_flag == 128 then
		monster.set_monster_attributes(2, 1)
		monster.set_life(0.0)
		death.begin()
		monster.set_motion("死に", -1, 2)
		motion.wait_until_finished()
		monster.spawn_death_effects()
		while true do
			vm.wait()
		end
	end
	combat.finish_throw()
	monster.stop_moving()
	monster.end_throw()
	state.do_nothing_hook()
	monster.set_monster_attributes(2, 1)
	monster.set_life(0.0)
	death.begin()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	death.play_death_effects_forever()
	return 1
end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so that the engine skips its default stun.
function script.on_stun() end

return script
