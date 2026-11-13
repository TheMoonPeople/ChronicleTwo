--!strict
--- Behaviour for the Bone Lord family, a skeleton swordsman that launches sword waves and sometimes revives itself.

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

--- Sets the guard thresholds and clip distance when the monster is placed.
local function configure_defaults()
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

--- Idles facing the target until the player is no longer transformed.
local function wait_while_player_transformed(monster_kind: any)
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		reaction.update_and_wait_frame()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Starts waiting when the player is transformed.
local function check_player_transformation()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		wait_while_player_transformed(monster_kind)
	end
end

--- Plays idle animations and sometimes steps back while waiting for the target to come in front.
local function pace_in_front_of_target(repeat_count: s32)
	local target_seen: s32 = 0
	local roll: s32 = 0
	for index = 0, repeat_count - 1 do
		reaction.update_and_wait_frame()
		monster.reset_motion()
		monster.set_motion("遊び", -1, 2)
		target_seen = sense.wait_until_target_in_front(39.0, 90.0, 56)
		if target_seen == 1 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
				movement.step_back_guarded()
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
				monster.set_motion("立ち", -1, 0)
			end
		end
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(39.0, 90.0, 30)
	end
end

--- Waits in front of the target, strafes beside it or paces.
local function act_passively()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(39.0, 90.0, 30)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			side_offset = monster.get_random_whole_number(30.0) or side_offset
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 85.0)
			if roll < 50 then
				side_offset = vm.f32(-side_offset - 30.0)
			else
				side_offset = vm.f32(side_offset + 30.0)
			end
			monster.set_motion("歩き", 0.6, 0)
			local _ = movement.walk_to_point_near_target(1.5, vm.f32(3.2), side_offset, distance, 39.0, 40)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			roll = monster.get_random(2) or roll
			pace_in_front_of_target(roll)
		end
	end
end

--- Swings the sword and launches a wave along the ground.
local function attack_with_sword_wave()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local height: f32 = 0
	local ground_y: f32 = 0
	local attack_power: s32 = 0
	attack_power = monster.get_attack_power_1() or attack_power
	monster.set_motion("攻撃１", -1, 6)
	movement.turn_until_motion_progress(vm.f32(3.2), vm.f32(0.6), vm.f32(0.015))
	height = monster.get_height_above_ground() or height
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	ground_y = vm.f32(pos_y - height)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	monster.create_effect_1("ＳウェーブＬ")
	monster.set_effect_first_vector(-1, pos_x, ground_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	motion.wait_until_finished_guarded()
	monster.set_motion("歩き", -1, 0)
	timer.wait_frames_guarded(6)
end

--- Chases the target, attacks with the sword wave, wanders or paces at long range.
local function act_at_long_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			monster.set_motion("歩き", 0.6, 0)
			movement.chase_target_guarded(1.5, vm.f32(3.2), 85.0, 75)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			attack_with_sword_wave()
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 10 then
			monster.set_motion("歩き", 0.6, 0)
			movement.wander(1.5, vm.f32(3.2), 30.0, 180.0, 30.0, 85.0, 45)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			roll = monster.get_random(2) or roll
			pace_in_front_of_target(roll)
		end
	end
end

--- Attacks with a swing or the sword wave, chases or paces at medium range.
local function act_at_mid_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 15 then
		roll = monster.get_random(100) or roll
		if roll < 5 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_with_offset_guarded(vm.f32(3.2), 20.0, 15)
			combat.play_second_attack_guarded()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_guarded(6)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			attack_with_sword_wave()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_guarded(6)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			monster.set_motion("歩き", 0.6, 0)
			movement.chase_target_guarded(1.5, vm.f32(3.2), 39.0, 60)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			pace_in_front_of_target(1)
		end
	end
end

--- Picks a melee combo, step back or strafe while the target is close.
local function attack_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_offset: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 85 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_with_offset_guarded(vm.f32(3.2), 20.0, 15)
				combat.play_second_attack_guarded()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_guarded(6)
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", 0.65, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
					attack_with_sword_wave()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_guarded(6)
				else
					monster.set_motion("歩き", 0.65, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
					combat.play_two_hit_combo_guarded()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_guarded(6)
				end
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_with_offset_guarded(vm.f32(3.2), 20.0, 25)
				combat.play_slow_two_hit_combo_guarded()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_guarded(6)
			else
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
				combat.play_repeating_attack_guarded()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_guarded(6)
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 40 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			movement.step_back_guarded()
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			side_offset = monster.get_random_whole_number(30.0) or side_offset
			target_distance = monster.get_random_whole_number(10.0) or target_distance
			if roll < 50 then
				side_offset = vm.f32(-side_offset - 30.0)
			else
				side_offset = vm.f32(side_offset + side_offset)
			end
			target_distance = monster.get_target_distance() or target_distance
			monster.set_motion("歩き", 0.65, 0)
			movement.walk_to_point_near_target(1.5, vm.f32(3.2), calc.radians_to_degrees(side_offset), target_distance, 1.0, 15)
		end
	end
end

--- Fights the target by distance each frame until it moves away or no rage hits remain.
local function fight_with_rage_hits_left()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		check_player_transformation()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 290.0 then
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
			act_passively()
			continue
		end
		if target_distance < 290.0 and target_distance >= 140.0 then
			act_at_long_range()
		elseif target_distance < 140.0 and target_distance >= 85.0 then
			act_at_mid_range()
		else
			attack_at_close_range()
		end
		reaction.update_and_wait_frame()
	end
end

--- Roams around its home position, turning and waiting for the target while nothing engages it.
local function wander_while_unengaged()
	local roll: s32 = 0
	local is_target_threatening: s32 = 0
	local unused_selector: s32 = 0
	local distance_from_home: f32 = 0
	local heading_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_degrees: f32 = 0
	local turn_degrees: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local orbit_radius: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
	reaction.update_and_wait_frame()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	distance_from_home = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or distance_from_home
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 39.0 then
		heading_degrees = monster.get_random_whole_number(360.0) or heading_degrees
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_to_angle_and_wait(heading_degrees, vm.f32(3.2))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 39.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(3.2), vm.f32(1.4), heading_degrees, clear_distance, 39.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance_from_home > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance_from_home > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_degrees = monster.get_random_whole_number(360.0) or orbit_degrees
				distance_from_home = monster.get_random_whole_number(150.0) or distance_from_home
				if roll < 50 then
					orbit_degrees = vm.f32(-orbit_degrees - 30.0)
				else
					orbit_degrees = vm.f32(orbit_degrees + 30.0)
				end
				monster.set_motion("歩き", 0.6, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.4), vm.f32(3.2), distance_from_home, orbit_degrees, 39.0, 60)
				turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_degrees = vm.f32(turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(turn_degrees, vm.f32(3.2))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				is_target_threatening = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if is_target_threatening == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			heading_degrees = monster.get_random_whole_number(180.0) or heading_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				heading_degrees = vm.f32(heading_degrees * -1.0)
			end
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_to_angle_and_wait(heading_degrees, vm.f32(3.2))
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
					orbit_angle_degrees = monster.get_random_whole_number(180.0) or orbit_angle_degrees
					orbit_radius = monster.get_random_whole_number(30.0) or orbit_radius
					target_distance = monster.get_target_distance() or target_distance
					orbit_radius = vm.f32(orbit_radius + target_distance)
					if roll < 50 then
						orbit_angle_degrees = vm.f32(orbit_angle_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
					else
						orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", 0.6, 0)
					is_target_threatening = movement.walk_to_point_near_target(vm.f32(1.4), vm.f32(3.2), orbit_angle_degrees, orbit_radius, 39.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_degrees, vm.f32(3.2))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", 0.6, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					heading_degrees = calc.radians_to_degrees(rotation_y)
					if heading_degrees > vm.f32(3.1415927) then
						heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
					end
					if heading_degrees <= vm.f32(-3.1415927) then
						heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(vm.f32(1.4), heading_degrees, 1000.0, 39.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				is_target_threatening = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if is_target_threatening == 1 then
					return
				end
			end
		elseif unused_selector == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance_from_home = monster.get_target_distance() or distance_from_home
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", 0.6, 0)
			movement.wander(vm.f32(1.4), vm.f32(3.2), distance_from_home, 360.0, 40.0, 39.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Walks after the target for a while.
local function chase_target()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_guarded(1.5, vm.f32(3.2), 39.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Fights the target by distance each frame until rage hits are available.
local function fight_without_rage_hits()
	local cached_target_distance: f32 = 0
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	local roll: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
				monster.set_motion("歩き", 0.6, 0)
				movement.chase_target_guarded(3.0, vm.f32(3.2), 1.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				motion.idle_for_frames(30)
			end
			continue
		end
		if cached_target_distance < 290.0 and cached_target_distance >= 140.0 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_with_offset_guarded(vm.f32(6.4), 30.0, 15)
				attack_with_sword_wave()
			else
				monster.set_motion("歩き", 0.65, 0)
				movement.chase_target_guarded(3.0, vm.f32(3.2), 1.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 85.0 then
				roll = monster.get_random(100) or roll
				if roll < 70 then
					roll = monster.get_random(100) or roll
					if roll < 70 then
						combat.play_slow_two_hit_combo_guarded()
					else
						combat.play_repeating_attack_guarded()
					end
				else
					roll = monster.get_random(100) or roll
					if roll < 35 then
						monster.set_motion("歩き", 0.6, 0)
						movement.chase_target_guarded(1.5, vm.f32(3.2), 39.0, 45)
						combat.play_second_attack_guarded()
					else
						monster.set_motion("歩き", 0.6, 0)
						movement.chase_target_guarded(1.5, vm.f32(3.2), 39.0, 45)
						attack_with_sword_wave()
					end
				end
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
					attack_with_sword_wave()
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", 0.65, 0)
					movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
					monster.set_motion("歩き", 0.6, 0)
					movement.chase_target_guarded(3.0, vm.f32(3.2), 1.0, 75)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
		reaction.update_and_wait_frame()
	end
end

--- Picks the fighting, roaming or guarding behaviour from the rage state, guard state and target distance.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_range: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		check_player_transformation()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 290.0 then
				fight_with_rage_hits_left()
			else
				wander_while_unengaged()
			end
		else
			guard_range = state.get_secondary_float(guard_range)
			if target_distance < guard_range then
				if target_distance < 140.0 then
					monster.set_monster_guard_rate(-1, 1.0)
					reaction.set_guard_active(0)
					fight_with_rage_hits_left()
				else
					monster.set_monster_guard_rate(-1, 10.0)
					chase_target()
				end
			else
				monster.set_monster_guard_rate(-1, 1.0)
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage_hits()
	end
end

local script = {}

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Registers the sword attacks, trails and photo pose when the monster is placed.
function script.init()
	local grade: s32 = 0
	monster.register_damage_hit("通常攻撃", 2.5, "攻撃１", 0.5, 0.75, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 3.0, "攻撃１", 0.5, 0.75, 1)
	monster.register_damage_hit("通常攻撃", 2.5, "攻撃２", 0.5, 0.8, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 3.0, "攻撃２", 0.5, 0.8, 1)
	monster.register_damage_hit("通常攻撃", 6.0, "攻撃２", 0.15, 0.8, 2)
	monster.add_sword_trail(0, "攻撃１", 0.32, 0.37, "dcol1", "dcol0", 77, 20, 20)
	monster.add_sword_trail(0, "攻撃２", 0.5, 0.53, "dcol1", "dcol0", 77, 20, 20)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("気絶", 0.0, 1.0, 1005)
	end
	monster.load_effect_script("ＳウェーブＬ")
	configure_defaults()
end

--- Runs the behaviour update every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		update_behavior()
	end
end

--- Plays the damage pose until the status ailment ends.
function script.on_status_hit()
	local ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailments = 1
	while ailments ~= 0 do
		ailments = monster.get_status_ailments(40) or ailments
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers and recovers after a normal hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_guarded(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown, lies on the ground and gets back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	monster.set_action_status(1)
	timer.wait_frames_guarded(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Raises a guard against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_guarded(8)
	monster.set_motion("立ち")
	state.unlock()
end

--- Turns toward the target and sidesteps or steps back.
function script.on_dodge_1()
	local target_angle: f32 = 0
	local roll: s32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	reaction.update_and_wait_frame()
	roll = monster.get_random(20) or roll
	if roll < 20 then
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
		movement.sidestep_guarded()
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
		monster.set_motion("立ち", -1, 0)
	else
		target_angle = monster.get_target_angle() or target_angle
		monster.set_rotation(0.0, target_angle, 0.0)
		reaction.update_and_wait_frame()
		movement.step_back_guarded()
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_toward_target_and_wait_guarded(vm.f32(3.2))
		monster.set_motion("立ち", -1, 0)
	end
	state.unlock()
end

--- Dodges in response to the target's second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_guarded(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Revives itself with some life ten percent of the time and otherwise plays the death animation and effects.
function script.on_death()
	local revive_life: f32 = 0
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 10 then
		monster.stop_moving()
		movement.stop_turning()
		monster.set_mask_flags(1, 1)
		monster.set_mask_flags(2, 1)
		monster.set_monster_attributes(32, 1)
		monster.set_motion("死に", -1, 2)
		motion.wait_until_finished_guarded()
		revive_life = monster.get_random_whole_number(0.3) or revive_life
		revive_life = vm.f32(revive_life + vm.f32(0.2))
		monster.set_life(revive_life)
		timer.wait_frames_guarded(45)
		monster.set_motion("起き上がり", -1, 2)
		motion.wait_until_finished_guarded()
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
		monster.set_monster_attributes(32, 0)
		return
	end
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while held by the player.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Recovers after landing from a throw.
function script.on_land()
	combat.finish_throw_guarded()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_guarded(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	state.do_nothing_hook()
	return 1
end

--- Plays the stun recovery.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
