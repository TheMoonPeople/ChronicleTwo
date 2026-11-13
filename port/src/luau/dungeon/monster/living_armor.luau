--!strict
--- Controls the Living Armor monster: a sword-wielding armor that approaches and circles the player, swings its sword and guards against hits.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the clip distance, using an unlimited distance for bosses.
local function apply_default_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Idles facing the player until the player is no longer transformed.
local function face_player_while_transformed(monster_kind: any)
	local player_transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		timer.wait_one_frame()
		player_transform_id = monster.get_player_transform_id() or player_transform_id
		if player_transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait(vm.f32(2.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Starts facing the player when the player has transformed.
local function react_to_player_transformation()
	local player_transform_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	player_transform_id = monster.get_player_transform_id() or player_transform_id
	if player_transform_id > -1 then
		face_player_while_transformed(monster_id)
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
		distance_offset = vm.f32(distance_offset + 95.0)
		if roll < 50 then
			side_offset_degrees = vm.f32(-side_offset_degrees - 30.0)
		else
			side_offset_degrees = vm.f32(side_offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_around_target(vm.f32(1.2), vm.f32(2.8), side_offset_degrees, distance_offset, 49.0, 30)
		movement.turn_toward_target_and_wait(vm.f32(2.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(49.0, 45.0, 30)
	end
end

--- Waits, turns, chases or circles the player at medium range, depending on random rolls.
local function act_at_mid_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local life: f32 = 0
	local side_offset_degrees: f32 = 0
	life = 0.0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 60 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(100.0, 60.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 55 then
			life = monster.get_life() or life
			if life < vm.f32(0.3) then
				monster.set_motion("歩き", -1, 0)
				movement.chase_target(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1, 0)
				movement.chase_target(vm.f32(1.2), vm.f32(2.8), 49.0, 90)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				side_offset_degrees = -30.0
			else
				side_offset_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(2.8))
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(1.2), vm.f32(2.8), side_offset_degrees, target_distance, 1.0, 45)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(49.0, 45.0, 30)
		end
	end
end

--- Plays the first sword swing while turning toward the player.
local function swing_first_attack()
	monster.set_variable(0, 1)
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_finished_facing_target(vm.f32(2.8))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Plays the second sword attack while tracking the player.
local function swing_second_attack()
	monster.set_variable(0, 2)
	monster.set_motion("攻撃２", -1, 6)
	movement.track_target(vm.f32(2.8), calc.pass_through(38))
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(9)
end

--- Swings the sword, chases or circles the player at close range.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_offset_degrees: f32 = 0
	monster.get_life()
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 65 then
		if target_distance < 50.0 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				swing_first_attack()
			else
				swing_second_attack()
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.chase_target(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.chase_target(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			side_offset_degrees = monster.get_random_whole_number(60.0) or side_offset_degrees
			if roll < 50 then
				side_offset_degrees = vm.f32(-side_offset_degrees - 30.0)
			else
				side_offset_degrees = vm.f32(side_offset_degrees + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.walk_around_target(vm.f32(1.2), vm.f32(2.8), side_offset_degrees, 98.0, 1.0, 25)
			movement.turn_toward_target_and_wait(vm.f32(2.8))
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(9)
		end
	end
end

--- Picks an approach or attack by distance while the player is in range, until the player leaves range or the armor enrages.
local function fight_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		monster.get_life()
		react_to_player_transformation()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 225.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			reposition_near_target()
			continue
		end
		if target_distance < 225.0 and target_distance >= 145.0 then
			behavior.read_distance_and_roll()
		elseif target_distance < 145.0 and target_distance >= 95.0 then
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
	timer.wait_one_frame()
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
	if clear_distance < 49.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle(turn_angle_degrees, vm.f32(2.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 49.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction(vm.f32(2.8), vm.f32(1.3), turn_angle_degrees, clear_distance, 49.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance_from_home > 250.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance_from_home > 550.0 then
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
				movement.walk_around_position_unguarded(home_x, home_y, home_z, vm.f32(1.3), vm.f32(2.8), distance_from_home, orbit_angle_degrees, 49.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle(final_turn_degrees, vm.f32(2.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening(100.0, 60.0, 35.0, vm.f32(1.2), 30)
				if threat_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 93 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(100.0, 60.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle(turn_angle_degrees, vm.f32(2.8))
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
					threat_result = movement.walk_around_target(vm.f32(1.3), vm.f32(2.8), approach_angle_degrees, approach_distance, 49.0, 60)
					closing_turn_degrees = monster.get_random_whole_number(360.0) or closing_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						closing_turn_degrees = vm.f32(closing_turn_degrees * -1.0)
					end
					movement.turn_to_angle(closing_turn_degrees, vm.f32(2.8))
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
					movement.move_in_direction(vm.f32(1.3), turn_angle_degrees, 1000.0, 49.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				threat_result = sense.wait_until_target_threatening(100.0, 60.0, 35.0, vm.f32(1.2), 30)
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
			movement.wander_unguarded(vm.f32(1.3), vm.f32(2.8), distance_from_home, 360.0, 40.0, 49.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Swings and chases aggressively while the player is within range, returning once the player moves away.
local function fight_while_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	monster.get_life()
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 225.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			reposition_near_target()
			continue
		end
		if target_distance < 95.0 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				if target_distance < 75.0 then
					swing_first_attack()
				else
					swing_second_attack()
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.chase_target(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 65 then
				swing_second_attack()
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("歩き", -1, 0)
					movement.chase_target(vm.f32(1.2), vm.f32(2.8), 49.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					movement.chase_target(vm.f32(1.2), vm.f32(5.6), 49.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
	end
end

local script = {}

--- Does nothing because the monster needs no load-time setup.
function script.setup() end

--- Registers the sword hit windows and sword trails and applies the clip-distance default.
function script.init()
	monster.register_damage_hit("吹っ飛び弱", 5.0, "攻撃１", 0.279, 0.414, 0, 1)
	monster.register_damage_hit("中攻撃", 5.0, "攻撃２", 0.6, 0.7, 0, 1)
	monster.add_sword_trail(0, "攻撃１", 0.31, 0.315, "dcol0", "dcol1", 45, 10, 45)
	monster.add_sword_trail(0, "攻撃２", 0.3, 0.305, "dcol0", "dcol1", 45, 10, 45)
	monster.set_variable(0, 0)
	apply_default_clip_distance()
end

--- Clears the mask flags and repeatedly picks between fighting, roaming and the enraged routine.
function script.loop()
	local target_distance: f32 = 0
	local rage_hits_left: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			react_to_player_transformation()
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 225.0 then
				fight_in_range()
			else
				roam_around_home()
			end
		else
			fight_while_enraged()
		end
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
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage motion, knocks the armor back and stays staggered briefly.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Knocks the armor back, waits and plays the get-up motion.
function script.on_knockdown()
	state.lock_and_face_target()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("起き上がり")
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	state.unlock_and_clear_action()
end

--- Plays the guard-in, guard and guard-out motions, knocking the armor back slightly.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock()
end

--- Locks and unlocks the monster without dodging.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Locks and unlocks the monster without dodging.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the death motion and then the death effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine's default is not used.
function script.on_caught() end

--- Finishes the throw and returns to the idle state.
function script.on_land()
	combat.finish_throw()
	state.do_nothing_hook()
	return 1
end

--- Plays the knocked-over and get-up motions and stays stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
