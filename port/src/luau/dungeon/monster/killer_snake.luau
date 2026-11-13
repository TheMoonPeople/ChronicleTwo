--!strict
--- Controls the Killer Snake family of snake monsters: they circle the player, rush in, vanish and reappear at the player's position to dodge, and bite with two attacks, fighting harder once enraged.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets guard, secondary variable and clip-distance defaults, using an unlimited clip distance for bosses.
local function apply_default_settings()
	local boss: s32 = 0
	state.set_unknown_float_8(500.0)
	state.set_unknown_float_9(80.0)
	reaction.set_guard_damage_threshold(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Walks to a random spot near the player or waits until the player is in front.
local function reposition_near_target()
	local roll: s32 = 0
	local side_offset_degrees: f32 = 0
	local distance_offset: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_offset_degrees = monster.get_random_whole_number(30.0) or side_offset_degrees
		distance_offset = monster.get_random_whole_number(30.0) or distance_offset
		distance_offset = vm.f32(distance_offset + 90.0)
		if roll < 50 then
			side_offset_degrees = vm.f32(-side_offset_degrees - 30.0)
		else
			side_offset_degrees = vm.f32(side_offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(2.0, vm.f32(4.2), side_offset_degrees, distance_offset, 46.0, 30)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(46.0, 45.0, 30)
	end
end

--- Rushes toward the player or waits for the player to face it, depending on a random roll.
local function act_at_long_range()
	local roll: s32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 25 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
		movement.rush_forward_guarded(vm.f32(3.2), vm.f32(4.2), 90.0, 45)
		monster.set_motion("立ち", -1, 0)
	else
		roll = monster.get_random(100) or roll
		if roll < 25 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(2.0, vm.f32(4.2), 90.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(46.0, 45.0, 75)
		end
	end
end

--- Dodges by vanishing and reappearing at the player's position after the given number of frames.
local function vanish_and_reappear_at_target(duration_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	monster.set_motion("避け", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_monster_attributes(1, 1)
	timer.wait_frames_with_guard_update(vm.idiv(duration_frames, 2))
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.set_position(target_x, target_y, target_z)
	timer.wait_frames_with_guard_update(vm.idiv(duration_frames, 2))
	monster.set_motion("避け戻り", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	monster.set_monster_attributes(1, 0)
end

--- Chases, dodges, rushes or circles the player at medium range, depending on random rolls.
local function act_at_mid_range()
	local roll: s32 = 0
	local side_offset_degrees: f32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		roll = monster.get_random(100) or roll
		if roll < 20 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target_guarded(2.0, vm.f32(4.2), 46.0, 60)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				combat.turn_and_play_first_attack()
			else
				combat.turn_and_play_second_attack()
			end
		else
			vanish_and_reappear_at_target(75)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 30 then
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(2.0, vm.f32(4.2), 46.0, 45)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 45 then
			else
				roll = monster.get_random(100) or roll
				side_offset_degrees = monster.get_random_whole_number(60.0) or side_offset_degrees
				if roll < 50 then
					side_offset_degrees = vm.f32(-side_offset_degrees - 30.0)
				else
					side_offset_degrees = vm.f32(side_offset_degrees + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.walk_to_point_near_target(2.0, vm.f32(4.2), side_offset_degrees, 92.0, 1.0, 25)
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(9)
			end
		end
	end
end

--- Bites with one of the two attacks, circles the player or dodges at close range.
local function act_at_close_range()
	local roll: s32 = 0
	local side_offset_degrees: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 70 then
			combat.turn_and_play_first_attack()
		else
			combat.turn_and_play_second_attack()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 75 then
			roll = monster.get_random(100) or roll
			side_offset_degrees = monster.get_random_whole_number(60.0) or side_offset_degrees
			if roll < 50 then
				side_offset_degrees = vm.f32(-side_offset_degrees - 30.0)
			else
				side_offset_degrees = vm.f32(side_offset_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.0, vm.f32(4.2), side_offset_degrees, 92.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(9)
		else
			roll = monster.get_random(30) or roll
			roll = vm.i32(roll + 15)
			vanish_and_reappear_at_target(roll)
		end
	end
end

--- Picks an approach or attack by distance while the player is in range, until the player leaves range or the snake enrages.
local function fight_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		monster.get_life()
		reaction.watch_transformation_walking()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left <= 0 then
			return
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 240.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			reposition_near_target()
			continue
		end
		if target_distance < 240.0 and target_distance >= 150.0 then
			act_at_long_range()
		elseif target_distance < 150.0 and target_distance >= 90.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
	end
end

--- Roams the area around the home position: turns away from walls, returns toward home when too far, and otherwise waits, turns, circles or wanders.
local function roam_around_home()
	local roll: s32 = 0
	local threat_result: s32 = 0
	local unused_mode: s32 = 0
	local distance_from_home: f32 = 0
	local turn_angle_degrees: f32 = 0
	local home_x: f32 = 0
	local home_y: f32 = 0
	local home_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local yaw_radians: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local approach_angle_degrees: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local closing_turn_degrees: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		home_x = out1 or home_x
		home_y = out2 or home_y
		home_z = out3 or home_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	distance_from_home = monster.get_distance_between(position_x, position_y, position_z, home_x, home_y, home_z) or distance_from_home
	do
		local _, out2, _ = monster.get_rotation()
		yaw_radians = out2 or yaw_radians
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 46.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle_degrees, vm.f32(4.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 46.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.2), 2.0, turn_angle_degrees, clear_distance, 46.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance_from_home > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance_from_home > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				monster.set_place_position(position_x, position_y, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_angle_degrees = monster.get_random_whole_number(360.0) or orbit_angle_degrees
				distance_from_home = monster.get_random_whole_number(150.0) or distance_from_home
				if roll < 50 then
					orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
				else
					orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(home_x, home_y, home_z, 2.0, vm.f32(4.2), distance_from_home, orbit_angle_degrees, 46.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 75 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle_degrees, vm.f32(4.2))
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_variable(0, 4)
					roll = monster.get_random(100) or roll
					approach_angle_degrees = monster.get_random_whole_number(180.0) or approach_angle_degrees
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if roll < 50 then
						approach_angle_degrees = vm.f32(approach_angle_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						approach_angle_degrees = vm.f32(-approach_angle_degrees - 30.0)
					else
						approach_angle_degrees = vm.f32(approach_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					threat_result = movement.walk_to_point_near_target(2.0, vm.f32(4.2), approach_angle_degrees, approach_distance, 46.0, 60)
					closing_turn_degrees = monster.get_random_whole_number(360.0) or closing_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						closing_turn_degrees = vm.f32(closing_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(closing_turn_degrees, vm.f32(4.2))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						yaw_radians = out2 or yaw_radians
					end
					turn_angle_degrees = calc.radians_to_degrees(yaw_radians)
					if turn_angle_degrees > vm.f32(3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees - vm.f32(6.2831855))
					end
					if turn_angle_degrees <= vm.f32(-3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(2.0, turn_angle_degrees, 1000.0, 46.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
		elseif unused_mode == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance_from_home = monster.get_target_distance() or distance_from_home
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(2.0, vm.f32(4.2), distance_from_home, 360.0, 40.0, 46.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Chases the player or dodges to close the distance while the player is guarding.
local function close_in_on_guarding_target()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("歩き", -1, 0)
		movement.chase_target_guarded(2.0, vm.f32(4.2), 46.0, 45)
		monster.set_motion("立ち", -1, 0)
	else
		vanish_and_reappear_at_target(60)
	end
end

--- Rushes, bites and dodges aggressively until the snake is no longer enraged.
local function fight_while_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	monster.get_life()
	while true do
		reaction.update_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			reposition_near_target()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 90.0 then
			roll = monster.get_random(100) or roll
			if roll < 90 then
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(2.0, vm.f32(8.4), 46.0, 60)
				monster.set_motion("立ち", -1, 0)
				if roll < 50 then
					combat.turn_and_play_first_attack()
				else
					combat.turn_and_play_second_attack()
				end
			else
				roll = monster.get_random(35) or roll
				roll = vm.i32(roll + 25)
				vanish_and_reappear_at_target(roll)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 10 then
				roll = monster.get_random(35) or roll
				roll = vm.i32(roll + 25)
				vanish_and_reappear_at_target(roll)
			else
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(6.2999997))
				movement.rush_forward_guarded(vm.f32(3.2), vm.f32(4.2), 46.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Chooses between fighting, roaming and closing in on a guarding player, using the enraged routine when enraged.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_range: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		reaction.watch_transformation_walking()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 240.0 then
				fight_in_range()
			else
				roam_around_home()
			end
		else
			guard_range = state.get_secondary_float(guard_range)
			if target_distance < guard_range then
				if target_distance < 90.0 then
					reaction.set_guard_active(0)
					fight_in_range()
				else
					close_in_on_guarding_target()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_while_enraged()
	end
end

local script = {}

--- Does nothing because the monster needs no load-time setup.
function script.setup() end

--- Registers the bite hit windows and applies the default settings.
function script.init()
	monster.register_damage_hit("通常ＧＣ", 8.0, "攻撃１", 0.404, 0.538, 1)
	monster.register_damage_hit("通常ＧＣ", 13.2, "攻撃１", 0.404, 0.538, 2)
	monster.register_damage_hit("弱毒", 4.0, "攻撃２", 0.292, 0.375, 0)
	monster.register_damage_hit("中ＢＧＣ", 8.0, "避け戻り", 0.0, 0.627, 3)
	monster.set_variable(0, 0)
	apply_default_settings()
end

--- Clears the mask flags and repeatedly updates the snake's behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(1, 0)
	monster.get_rage_hits_left()
	while true do
		reaction.update_and_wait_frame()
		update_behavior()
	end
end

--- Plays the damage motion and waits until the status ailment wears off.
function script.on_status_hit()
	local status_ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	status_ailments = 1
	while status_ailments ~= 0 do
		status_ailments = monster.get_status_ailments(40) or status_ailments
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage motion, knocks the snake back and stays staggered briefly.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_monster_attributes(1, 0)
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the snake is never knocked down.
function script.on_knockdown() end

--- Dodges by vanishing and reappearing at the player's position when a hit is guarded.
function script.on_guard()
	local roll: s32 = 0
	state.lock_and_stop_moving()
	monster.set_monster_attributes(1, 0)
	roll = monster.get_random(30) or roll
	roll = vm.i32(roll + 15)
	vanish_and_reappear_at_target(roll)
	state.unlock()
end

--- Dodges the player's first kind of attack by vanishing and reappearing at the player.
function script.on_dodge_1()
	local roll: s32 = 0
	state.lock_and_reset_motion()
	monster.set_monster_attributes(1, 0)
	roll = monster.get_random(30) or roll
	roll = vm.i32(roll + 15)
	vanish_and_reappear_at_target(roll)
	state.unlock()
end

--- Dodges the player's second kind of attack by vanishing and reappearing at the player.
function script.on_dodge_2()
	local roll: s32 = 0
	state.lock_and_reset_motion()
	monster.set_monster_attributes(1, 0)
	roll = monster.get_random(30) or roll
	roll = vm.i32(roll + 15)
	vanish_and_reappear_at_target(roll)
	state.unlock()
end

--- Plays the death motion and then the death effects.
function script.on_death()
	death.begin()
	monster.set_monster_attributes(1, 0)
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Resets the motion and idles while the snake is held.
function script.on_caught()
	motion.reset()
	timer.wait_forever_guarded()
end

--- Recovers from being thrown and returns to the idle state.
function script.on_land()
	reaction.recover_from_throw()
	monster.set_monster_attributes(1, 0)
	state.do_nothing_hook()
	return 1
end

--- Plays the knocked-over and get-up motions and stays stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_monster_attributes(1, 0)
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
