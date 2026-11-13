--!strict
--- Controls the King Mimic, a chest monster that fights the target at close range.

local vm = require("@lib/vm")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

local ground_y: f32 = 0

--- Sets the King Mimic's clip distance, unlimited for bosses and short otherwise.
local function configure_clip_distance()
	local boss: s32 = 0
	ground_y = 0.0
	boss = monster.is_boss() or boss
	if boss == 0 then
		do
			local _, out2, _ = monster.get_position_3()
			ground_y = out2 or ground_y
		end
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
	ground_y = 0.0
end

--- Turns to the target and sidesteps left or right around it at the given speed.
local function sidestep_around_target(speed: f32)
	local roll: s32 = 0
	local approach_x: f32 = 0
	local approach_y: f32 = 0
	local approach_z: f32 = 0
	local target_distance: f32 = 0
	local offset_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(6.0)
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.reset_motion()
		monster.set_motion("歩き右", -1, 6)
		offset_degrees = 30.0
	else
		monster.reset_motion()
		monster.set_motion("歩き左", -1, 6)
		offset_degrees = -30.0
	end
	timer.wait_frames(13)
	approach_x, approach_y, approach_z = movement.get_approach_point(offset_degrees, target_distance, approach_x, approach_y, approach_z)
	monster.move_toward_position(approach_x, ground_y, approach_z, speed, speed)
	monster.set_monster_attributes(32, 1)
	timer.wait_frames(9)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	motion.wait_until_finished()
end

--- Picks a random close-range attack, sidestep, retreat or circling move.
local function choose_close_range_move()
	local roll: s32 = 0
	local strafe_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 34 then
			combat.lunge_forward_short()
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				combat.perform_strike_2()
			else
				combat.perform_strike_3()
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 40 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				sidestep_around_target(3.0)
			else
				movement.retreat_long(3.0)
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_degrees = -30.0
				monster.set_motion("歩き左", -1, 4)
			else
				strafe_degrees = 30.0
				monster.set_motion("歩き右", -1, 4)
			end
			for step = 0, 2 do
				timer.wait_frames(13)
				movement.circle_target(vm.f32(2.5500002), strafe_degrees, 3.0, 9)
				monster.stop_moving()
				timer.wait_frames(3)
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(3.0)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Loops choosing moves by target distance until the target leaves range or rage hits run out.
local function fight_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 200.0 then
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
			movement.wander_step_slow()
			continue
		end
		if target_distance < 200.0 and target_distance >= 140.0 then
			combat.choose_move_or_swing()
		elseif target_distance < 140.0 and target_distance >= 100.0 then
			combat.choose_move_or_slam()
		else
			choose_close_range_move()
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the King Mimic's attack hits and sets its clip distance when it is placed.
function script.init()
	monster.register_damage_hit("通常攻撃", 8.0, "攻撃１", 0.353, 0.42, 0)
	monster.register_damage_hit("通常攻撃", 6.0, "攻撃２", 0.321, 0.536, 1)
	monster.register_damage_hit("弱攻撃", 8.0, "攻撃３", 0.5, 0.607, 2)
	configure_clip_distance()
end

--- Runs the King Mimic's normal combat behaviour.
function script.loop()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.get_rage_hits_left()
	while true do
		movement.wander_until_target_in_range()
		fight_target()
		vm.wait()
	end
end

--- Plays the King Mimic's stagger reaction to a normal hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Handles the King Mimic being knocked down.
function script.on_knockdown()
	state.lock_and_face_target()
	state.unlock_and_clear_action()
end

--- Handles the King Mimic guarding against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	movement.retreat_long(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	sidestep_around_target(3.0)
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the King Mimic's death.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Handles the King Mimic being caught and lifted.
function script.on_caught() end

--- Recovers the King Mimic after it lands from a throw.
function script.on_land()
	combat.finish_throw()
	state.do_nothing_hook()
	return 1
end

--- Stuns the King Mimic until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	timer.wait_frames(3)
	reaction.stun_until_recovered()
end

return script
