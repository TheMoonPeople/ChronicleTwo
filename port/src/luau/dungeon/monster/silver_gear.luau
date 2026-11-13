--!strict
--- Behaviour for the Silver Gear family, a gear-bodied archer that fires poison arrows and sometimes revives itself.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
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
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(3.5)
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

--- Strafes beside the target or waits in front of it.
local function act_passively()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_offset = monster.get_random_whole_number(30.0) or side_offset
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 60.0)
		if roll < 50 then
			side_offset = vm.f32(-side_offset - 30.0)
		else
			side_offset = vm.f32(side_offset + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(1.8), 10.0, side_offset, distance, 34.0, 30)
		movement.turn_toward_target_and_wait_guarded(10.0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(34.0, 45.0, 30)
	end
end

--- Fires a poison arrow at the target.
local function shoot_poison_arrow()
	local attack_power: s32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(9))
	monster.get_frame_position("dcol0")
	monster.get_rotation()
	attack_power = monster.get_attack_power_1() or attack_power
	monster.get_character_number()
	monster.create_effect_1("ギア毒矢")
	monster.set_effect_value(-1, 0, attack_power)
	motion.wait_until_finished_guarded()
end

--- Shoots, strafes at a run or wanders while the target is at long range.
local function act_at_long_range()
	local roll: s32 = 0
	local side_angle_degrees: f32 = 0
	local strafe_angle_degrees: f32 = 0
	local target_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 20 then
		roll = monster.get_random(100) or roll
		side_angle_degrees = monster.get_random_whole_number(90.0) or side_angle_degrees
		if roll < 50 then
			side_angle_degrees = vm.f32(-side_angle_degrees - 60.0)
		else
			side_angle_degrees = vm.f32(side_angle_degrees + 60.0)
		end
		monster.set_motion("走り", -1, 0)
		movement.walk_to_point_near_target(3.5, 10.0, side_angle_degrees, 68.0, 60.0, 25)
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		shoot_poison_arrow()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(3)
	else
		roll = monster.get_random(100) or roll
		if roll < 60 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			shoot_poison_arrow()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		else
			roll = monster.get_random(100) or roll
			if roll < 70 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					strafe_angle_degrees = -30.0
				else
					strafe_angle_degrees = 30.0
				end
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				monster.set_motion("歩き", -1, 0)
				target_distance = monster.get_target_distance() or target_distance
				movement.walk_to_point_near_target(vm.f32(1.8), 10.0, strafe_angle_degrees, target_distance, 60.0, 45)
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					shoot_poison_arrow()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(3)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(10.0)
					monster.set_motion("立ち", -1, 0)
					sense.wait_until_target_in_front(34.0, 45.0, 30)
				end
			else
				monster.set_motion("歩き", -1, 0)
				movement.wander(vm.f32(1.8), 10.0, 30.0, 180.0, 30.0, 34.0, 25)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Aims and fires an arrow at the target.
local function shoot_arrow(unused_count: any)
	local attack_power: s32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃１in", -1, 6)
	motion.wait_until_finished_facing_target_guarded(10.0)
	monster.set_motion("攻撃１", -1, 6)
	monster.get_frame_position("dcol0")
	monster.get_rotation()
	timer.wait_frames_with_guard_update(1)
	monster.get_character_number()
	attack_power = monster.get_attack_power_1() or attack_power
	monster.create_effect_1("ギア矢")
	monster.set_effect_value(-1, 0, attack_power)
	motion.wait_until_finished_guarded()
end

--- Hops backward away from the target.
local function step_back_from_target(move_speed: f32)
	local pos_x: f32 = 0
	local approach_y: f32 = 0
	local pos_z: f32 = 0
	local target_distance: f32 = 0
	local random_extra: f32 = 0
	local current_y: f32 = 0
	monster.set_monster_attributes(32, 1)
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	random_extra = monster.get_random_whole_number(10.0) or random_extra
	target_distance = vm.f32(target_distance + vm.f32(30.0 + random_extra))
	pos_x, approach_y, pos_z = movement.get_approach_point(0.0, target_distance, pos_x, approach_y, pos_z)
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(pos_x, current_y, pos_z, move_speed, move_speed + 1.0)
	timer.wait_frames_with_guard_update(calc.pass_through(3))
	monster.set_monster_attributes(32, 0)
	timer.wait_frames_with_guard_update(calc.pass_through(17))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Shoots, strafes, retreats or hops back while the target is at medium range.
local function act_at_mid_range()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 60 then
		roll = monster.get_random(100) or roll
		if roll < 40 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(10.0)
			shoot_arrow(30)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(10.0)
			shoot_poison_arrow()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 60 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				strafe_angle_degrees = -30.0
			else
				strafe_angle_degrees = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(5.0)
			monster.set_motion("走り", -1, 0)
			target_distance = monster.get_target_distance() or target_distance
			movement.walk_to_point_near_target(3.5, 10.0, strafe_angle_degrees, target_distance, 34.0, 20)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 15 then
				target_angle = monster.get_target_angle() or target_angle
				monster.set_motion("歩き", -1, 0)
				movement.turn_and_move_in_direction_guarded(10.0, vm.f32(1.8), calc.radians_to_degrees(vm.f32(target_angle + vm.f32(3.1415927))), 300.0, 17.0, 30)
				monster.set_motion("立ち", -1, 0)
			else
				roll = monster.get_random(3) or roll
				for index = 0, roll - 1 do
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(10.0)
					step_back_from_target(vm.f32(2.16))
					movement.turn_toward_target_and_wait_guarded(10.0)
				end
			end
		end
	end
end

--- Shoots, retreats or hops back while the target is close.
local function attack_at_close_range()
	local roll: s32 = 0
	local target_angle: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 45 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(10.0)
			shoot_arrow(10)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait_guarded(10.0)
			shoot_poison_arrow()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 30 then
			target_angle = monster.get_target_angle() or target_angle
			monster.set_motion("歩き", -1, 0)
			movement.turn_and_move_in_direction_guarded(10.0, vm.f32(1.8), calc.radians_to_degrees(vm.f32(target_angle + vm.f32(3.1415927))), 300.0, 10.0, 25)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(3) or roll
			for index = 0, roll - 1 do
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(10.0)
				step_back_from_target(vm.f32(2.16))
				movement.turn_toward_target_and_wait_guarded(10.0)
			end
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
		if target_distance > 280.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left <= 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			act_passively()
			continue
		end
		if target_distance < 280.0 and target_distance >= 160.0 then
			act_at_long_range()
		elseif target_distance < 160.0 and target_distance >= 60.0 then
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
	if clear_distance < 34.0 then
		heading_degrees = monster.get_random_whole_number(360.0) or heading_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(heading_degrees, 3.5)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 34.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(3.5, vm.f32(1.8), heading_degrees, clear_distance, 34.0, 30)
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
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.8), 3.5, distance_from_home, orbit_degrees, 34.0, 60)
				turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_degrees = vm.f32(turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(turn_degrees, 3.5)
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
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(heading_degrees, 3.5)
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
					monster.set_motion("歩き", -1.0, 0)
					is_target_threatening = movement.walk_to_point_near_target(vm.f32(1.8), 3.5, orbit_angle_degrees, orbit_radius, 34.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_degrees, 3.5)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
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
					movement.move_in_direction_guarded(vm.f32(1.8), heading_degrees, 1000.0, 34.0, 60)
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
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.8), 3.5, distance_from_home, 360.0, 40.0, 34.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs after the target and usually fires a poison arrow.
local function chase_then_shoot_poison_arrow()
	local roll: s32 = 0
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(3.5, 10.0, 160.0, 90)
	monster.set_motion("立ち", -1, 0)
	roll = monster.get_random(100) or roll
	if roll < 70 then
		shoot_poison_arrow()
	end
end

--- Fights the target by distance each frame until rage hits are available.
local function fight_without_rage_hits()
	local cached_target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	local target_angle: f32 = 0
	local strafe_angle_degrees: f32 = 0
	local target_distance: f32 = 0
	local retreat_angle: f32 = 0
	while true do
		reaction.update_and_wait_frame()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 5 then
			act_passively()
			continue
		end
		if cached_target_distance < 60.0 then
			roll = monster.get_random(100) or roll
			if roll < 30 then
				roll = monster.get_random(100) or roll
				if roll < 30 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(10.0)
					shoot_arrow(10)
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(3)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(10.0)
					shoot_poison_arrow()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(3)
				end
			else
				roll = monster.get_random(100) or roll
				if roll < 45 then
					target_angle = monster.get_target_angle() or target_angle
					monster.set_motion("走り", -1, 0)
					movement.turn_and_move_in_direction_guarded(15.0, 3.5, calc.radians_to_degrees(vm.f32(target_angle + vm.f32(3.1415927))), 300.0, 10.0, 15)
					monster.set_motion("立ち", -1, 0)
				else
					roll = monster.get_random(3) or roll
					for index = 0, roll - 1 do
						monster.set_motion("歩き", -1, 0)
						movement.turn_toward_target_and_wait_guarded(10.0)
						step_back_from_target(vm.f32(2.16))
						movement.turn_toward_target_and_wait_guarded(10.0)
					end
				end
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 75 then
				roll = monster.get_random(100) or roll
				if roll < 20 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(10.0)
					shoot_arrow(30)
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(1)
				else
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(10.0)
					shoot_poison_arrow()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_guard_update(1)
				end
			else
				roll = monster.get_random(100) or roll
				if roll < 60 then
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_angle_degrees = -30.0
					else
						strafe_angle_degrees = 30.0
					end
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(10.0)
					monster.set_motion("走り", -1, 0)
					target_distance = monster.get_target_distance() or target_distance
					movement.walk_to_point_near_target(3.5, 15.0, strafe_angle_degrees, target_distance, 34.0, 15)
					monster.set_motion("立ち", -1, 0)
				else
					roll = monster.get_random(100) or roll
					if roll < 10 then
						retreat_angle = monster.get_target_angle() or retreat_angle
						monster.set_motion("走り", -1, 0)
						movement.turn_and_move_in_direction_guarded(15.0, 3.5, calc.radians_to_degrees(vm.f32(retreat_angle + vm.f32(3.1415927))), 300.0, 17.0, 15)
						monster.set_motion("立ち", -1, 0)
					else
						roll = monster.get_random(3) or roll
						for hop_index = 0, roll - 1 do
							monster.set_motion("歩き", -1, 0)
							movement.turn_toward_target_and_wait_guarded(10.0)
							step_back_from_target(vm.f32(2.16))
							movement.turn_toward_target_and_wait_guarded(10.0)
						end
					end
				end
			end
		end
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
			if target_distance < 280.0 then
				fight_with_rage_hits_left()
			else
				wander_while_unengaged()
			end
		else
			guard_range = state.get_secondary_float(guard_range)
			if target_distance < guard_range then
				if target_distance < 280.0 then
					reaction.set_guard_active(0)
					fight_with_rage_hits_left()
				else
					chase_then_shoot_poison_arrow()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage_hits()
	end
end

--- Steps sideways to the left or right around the target.
local function sidestep_around_target()
	local roll: s32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local pos_y: f32 = 0
	local target_distance: f32 = 0
	local side_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 34.0 then
		target_distance = 34.0
	end
	monster.set_monster_attributes(32, 1)
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		side_angle_degrees = 30.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		side_angle_degrees = -30.0
	end
	target_x, target_y, target_z = movement.get_approach_point(side_angle_degrees, target_distance, target_x, target_y, target_z)
	timer.wait_frames_with_guard_update(calc.pass_through(5))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(target_x, pos_y - 10.0, target_z, 1.8, 1.8)
	timer.wait_frames_with_guard_update(calc.pass_through(5))
	monster.set_monster_attributes(32, 0)
	timer.wait_frames_with_guard_update(calc.pass_through(6))
	monster.stop_moving()
	motion.wait_until_finished_guarded()
	monster.stop_moving()
end

local script = {}

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Loads the arrow effects when the monster is placed.
function script.init()
	local texture_block: s32 = 0
	local poison_arrow_loaded: s32 = 0
	local arrow_loaded: s32 = 0
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		poison_arrow_loaded = monster.load_effect_script("ギア毒矢", texture_block) or poison_arrow_loaded
		arrow_loaded = monster.load_effect_script("ギア矢", texture_block) or arrow_loaded
		if (if poison_arrow_loaded ~= 0 then 1 else arrow_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
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
	timer.wait_frames_with_guard_update(12)
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
	timer.wait_frames_with_guard_update(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Raises a guard against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.get_random(100)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Sidesteps or hops back.
function script.on_dodge_1()
	local roll: s32 = 0
	state.lock_and_reset_motion()
	roll = monster.get_random(20) or roll
	if roll < 20 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(10.0)
		sidestep_around_target()
	else
		monster.set_motion("ステップ後", -1, 0)
		step_back_from_target(vm.f32(2.6999998))
	end
	state.unlock()
end

--- Dodges in response to the target's second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
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
		timer.wait_frames_with_guard_update(30)
		monster.set_motion("起き上がり", -1, 2)
		motion.wait_until_finished_guarded()
		revive_life = monster.get_random_whole_number(0.3) or revive_life
		revive_life = vm.f32(revive_life + vm.f32(0.2))
		monster.set_life(revive_life)
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
	reaction.recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_guard_update(10)
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
