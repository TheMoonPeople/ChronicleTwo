--!strict
--- Monster decision routines that pick and run actions based on distance, randomness and player state.

local vm = require("@lib/vm")
local calc = vm.module("@lib/monster/calc")
local combat = vm.module("@lib/monster/combat")
local motion = vm.module("@lib/monster/motion")
local movement = vm.module("@lib/monster/movement")
local reaction = vm.module("@lib/monster/reaction")
local sense = vm.module("@lib/monster/sense")
local state = vm.module("@lib/monster/state")
local timer = vm.module("@lib/monster/timer")

local behavior = {}

--- Randomly picks a second attack, shockwave, combo, repeating attack, backstep or strafe for a target at close range.
function behavior.act_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local strafe_angle: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 85 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_with_offset(4.0, 20.0, 15)
				combat.play_second_attack()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(3)
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", 0.65, 0)
					movement.turn_toward_target_and_wait(4.0)
					combat.play_shockwave()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames(3)
				else
					monster.set_motion("歩き", 0.65, 0)
					movement.turn_toward_target_and_wait(4.0)
					combat.play_two_hit_combo()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames(3)
				end
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 60 then
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_with_offset(4.0, 20.0, 25)
				combat.play_double_attack()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(3)
			else
				monster.set_motion("歩き", 0.65, 0)
				movement.turn_toward_target_and_wait(4.0)
				combat.play_repeating_attack()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames(3)
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 40 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			movement.step_backward_by_progress()
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			strafe_angle = monster.get_random_whole_number(30.0) or strafe_angle
			target_distance = monster.get_random_whole_number(10.0) or target_distance
			if roll < 50 then
				strafe_angle = vm.f32(-strafe_angle - 30.0)
			else
				strafe_angle = vm.f32(strafe_angle + strafe_angle)
			end
			target_distance = monster.get_target_distance() or target_distance
			monster.set_motion("歩き", 0.65, 0)
			movement.walk_around_target(vm.f32(2.4), 4.0, calc.radians_to_degrees(strafe_angle), target_distance, 1.0, 15)
		end
	end
end

--- Randomly picks a chase, shockwave, wander or idle-play action for a target at far range.
function behavior.act_far_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 95 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			monster.set_motion("歩き", 0.6, 0)
			movement.chase_target(vm.f32(2.4), 4.0, 85.0, 75)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			combat.play_shockwave()
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 10 then
			monster.set_motion("歩き", 0.6, 0)
			movement.wander_unguarded(vm.f32(2.4), 4.0, 30.0, 180.0, 30.0, 85.0, 45)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			roll = monster.get_random(2) or roll
			movement.play_idle_wander(roll)
		end
	end
end

--- Randomly picks a second attack, shockwave, chase or idle-play action for a target at medium range.
function behavior.act_medium_range()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 65 then
		roll = monster.get_random(100) or roll
		if roll < 5 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_with_offset(4.0, 20.0, 15)
			combat.play_second_attack()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(3)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			combat.play_shockwave()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(3)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			monster.set_motion("歩き", 0.6, 0)
			movement.chase_target(vm.f32(2.4), 4.0, 49.0, 60)
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			movement.play_idle_wander(1)
		end
	end
end

--- Randomly plays the fidget motion, sometimes turning toward the target first, or idles until the target is in front.
function behavior.choose_idle_action()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("立ち", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
		end
		motion.play_fidget()
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(50.0, 45.0, 30)
	end
end

--- Randomly spits poison at the target, idles until the target is in front, or turns toward the target and plays the fidget motion.
function behavior.choose_spit_or_idle()
	local roll: s32 = 0
	vm.wait()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("立ち", -1, 0)
		movement.turn_toward_target_and_wait(10.0)
		combat.spit_poison(9.0, 45.0, 0.5, 27)
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames(3)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_arc(100.0, 45.0, 30)
		else
			monster.set_motion("立ち", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			motion.play_fidget()
		end
	end
end

--- Randomly picks a wander action, walking, turning or waiting for the target depending on the distance to its home position and the clearance ahead.
function behavior.choose_wander_action()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local action_state: s32 = 0
	local distance: f32 = 0
	local heading_degrees: f32 = 0
	local place_position_x: f32 = 0
	local place_position_y: f32 = 0
	local place_position_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local target_y: f32 = 0
	local home_angle_degrees: f32 = 0
	local wander_heading_degrees: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local orbit_distance: f32 = 0
	local target_distance: f32 = 0
	local final_heading_degrees: f32 = 0
	timer.wait_one_frame()
	roll = monster.get_random(100) or roll
	if roll < 10 then
	else
	end
	monster.set_secondary_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_position_x = out1 or place_position_x
		place_position_y = out2 or place_position_y
		place_position_z = out3 or place_position_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	distance = monster.get_distance_between(position_x, position_y, position_z, place_position_x, place_position_y, place_position_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 35.0 then
		print("1------------------------------------------------\n")
		heading_degrees = monster.get_random_whole_number(360.0) or heading_degrees
		monster.set_motion("歩き", -1, 0)
		movement.turn_to_angle(heading_degrees, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 35.0)
		if clear_distance > 0.0 then
			movement.walk_toward_heading(vm.f32(4.8), 2.0, heading_degrees, clear_distance, 35.0, 25.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				do
					local _, out2, _ = monster.get_target_position()
					target_y = out2 or target_y
				end
				monster.set_place_position(position_x, target_y + 25.0, position_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				print("2------------------------------------------------\n")
				monster.set_secondary_variable(0, 4)
				roll = monster.get_random(100) or roll
				home_angle_degrees = monster.get_random_whole_number(360.0) or home_angle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					home_angle_degrees = vm.f32(-home_angle_degrees - 30.0)
				else
					home_angle_degrees = vm.f32(home_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.walk_around_position(place_position_x, place_position_y, place_position_z, 2.0, vm.f32(4.8), distance, home_angle_degrees, 35.0, 25.0, 60)
				wander_heading_degrees = monster.get_random_whole_number(180.0) or wander_heading_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					wander_heading_degrees = vm.f32(wander_heading_degrees * -1.0)
				end
				movement.turn_to_angle(wander_heading_degrees, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 35 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_secondary_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.set_secondary_variable(0, 16)
			heading_degrees = monster.get_random_whole_number(180.0) or heading_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				heading_degrees = vm.f32(heading_degrees * -1.0)
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_to_angle(heading_degrees, vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					print("5------------------------------------------------\n")
					monster.set_secondary_variable(0, 4)
					roll = monster.get_random(100) or roll
					orbit_angle_degrees = monster.get_random_whole_number(180.0) or orbit_angle_degrees
					orbit_distance = monster.get_random_whole_number(30.0) or orbit_distance
					target_distance = monster.get_target_distance() or target_distance
					orbit_distance = vm.f32(orbit_distance + target_distance)
					if roll < 50 then
						orbit_angle_degrees = vm.f32(orbit_angle_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
					else
						orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					wait_result = movement.walk_to_point_around_target(2.0, vm.f32(4.8), orbit_angle_degrees, orbit_distance, 35.0, 25.0, 60)
					final_heading_degrees = monster.get_random_whole_number(360.0) or final_heading_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_heading_degrees = vm.f32(final_heading_degrees * -1.0)
					end
					movement.turn_to_angle(final_heading_degrees, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.set_secondary_variable(0, 32)
					monster.set_motion("歩き", -1, 0)
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
					movement.walk_along_heading(2.0, heading_degrees, 1000.0, 35.0, 25.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif action_state == 8 then
			print("7------------------------------------------------\n")
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1, 0)
			movement.walk_random_heading(2.0, vm.f32(4.8), distance, 360.0, 40.0, 35.0, 25.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Either walks to a random point around the target at about 120 units and turns toward it, or idles until the target is in front.
function behavior.circle_target_or_wait_distance_120()
	local roll: s32 = 0
	local angle_offset_degrees: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		angle_offset_degrees = monster.get_random_whole_number(30.0) or angle_offset_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 120.0)
		if roll < 50 then
			angle_offset_degrees = vm.f32(-angle_offset_degrees - 30.0)
		else
			angle_offset_degrees = vm.f32(angle_offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		movement.walk_to_point_around_target(2.0, vm.f32(4.8), angle_offset_degrees, distance, 35.0, 25.0, 60)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(35.0, 45.0, 30)
	end
end

--- Either walks to a random point around the target at about 140 units and turns toward it, or idles until the target is in front.
function behavior.circle_target_or_wait_distance_140()
	local roll: s32 = 0
	local angle_offset_degrees: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		angle_offset_degrees = monster.get_random_whole_number(30.0) or angle_offset_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 140.0)
		if roll < 50 then
			angle_offset_degrees = vm.f32(-angle_offset_degrees - 30.0)
		else
			angle_offset_degrees = vm.f32(angle_offset_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		movement.walk_to_point_around_target(2.0, vm.f32(4.8), angle_offset_degrees, distance, 35.0, 25.0, 60)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(35.0, 45.0, 30)
	end
end

--- Faces the target until the transformation ends, but only if the player is currently transformed.
function behavior.face_target_if_transformed()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		behavior.face_target_while_transformed(monster_kind)
	end
end

--- Faces the target quickly until the transformation ends, but only if the player is currently transformed.
function behavior.face_target_if_transformed_fast()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		behavior.face_target_while_transformed_fast(monster_kind)
	end
end

--- Faces the target at a medium turn speed until the transformation ends, but only if the player is currently transformed.
function behavior.face_target_if_transformed_medium()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		behavior.face_target_while_transformed_medium(monster_kind)
	end
end

--- Faces the target slowly until the transformation ends, but only if the player is currently transformed.
function behavior.face_target_if_transformed_slow()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		behavior.face_target_while_transformed_slow(monster_kind)
	end
end

--- Stands idle and turns to face the target until the player's transformation ends.
function behavior.face_target_while_transformed(monster_kind: any)
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		timer.wait_one_frame()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", 0.45, 0)
				movement.turn_toward_target_and_wait(vm.f32(4.2))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Stands idle and quickly turns to face the target until the player's transformation ends.
function behavior.face_target_while_transformed_fast(monster_kind: any)
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
				movement.turn_toward_target_and_wait_guarded(vm.f32(4.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Stands idle and turns at a medium speed to face the target until the player's transformation ends.
function behavior.face_target_while_transformed_medium(monster_kind: any)
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
				movement.turn_toward_target_and_wait_guarded(3.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Stands idle and slowly turns to face the target until the player's transformation ends.
function behavior.face_target_while_transformed_slow(monster_kind: any)
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
				movement.turn_toward_target_and_wait_guarded(vm.f32(2.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Idles and turns toward the target at speed 3 without reaction checks whenever it faces away by more than 60 degrees, until the player is no longer transformed.
function behavior.face_transformed_player_plain_speed_3(monster_kind: any)
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
				movement.turn_toward_target_and_wait(3.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Idles and turns toward the target at speed 4 without reaction checks whenever it faces away by more than 60 degrees, until the player is no longer transformed.
function behavior.face_transformed_player_plain_speed_4(monster_kind: any)
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
				movement.turn_toward_target_and_wait(4.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Idles with reaction checks and turns toward the target at speed 4 whenever it faces away by more than 60 degrees, until the player is no longer transformed.
function behavior.face_transformed_player_speed_4(monster_kind: any)
	local player_transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		reaction.update_and_wait_frame()
		player_transform_id = monster.get_player_transform_id() or player_transform_id
		if player_transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Idles with reaction checks and turns toward the target at speed 4.5 whenever it faces away by more than 60 degrees, until the player is no longer transformed.
function behavior.face_transformed_player_speed_4_5(monster_kind: any)
	local player_transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		reaction.update_and_wait_frame()
		player_transform_id = monster.get_player_transform_id() or player_transform_id
		if player_transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.5)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Idles with reaction checks and turns toward the target at speed 5 whenever it faces away by more than 60 degrees, until the player is no longer transformed.
function behavior.face_transformed_player_speed_5(monster_kind: any)
	local player_transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		reaction.update_and_wait_frame()
		player_transform_id = monster.get_player_transform_id() or player_transform_id
		if player_transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(5.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Walks to a spot 5 units above the ground, then idles and turns toward the target whenever it faces away by more than 90 degrees, until the player is no longer transformed.
function behavior.face_transformed_player_wide_cone(monster_kind: any)
	local position_x: f32 = 0
	local position_z: f32 = 0
	local player_transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	movement.walk_to_position(position_x, 25.0, position_z, 1.0, 10.0, 5.0, 150)
	while true do
		timer.wait_one_frame()
		player_transform_id = monster.get_player_transform_id() or player_transform_id
		if player_transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(90.0) == 0 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait(vm.f32(4.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Turns to face the target, plays the play motion while tracking it, then returns to standing.
function behavior.play_facing_target()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(vm.f32(4.2))
	monster.set_motion("遊び", -1, 6)
	movement.track_target_guarded(vm.f32(4.2), calc.pass_through(67))
	monster.set_motion("立ち", -1, 0)
end

--- Reads the target distance and rolls a random number without using either result.
function behavior.read_distance_and_roll()
	monster.get_target_distance()
	monster.get_random(100)
end

--- Picks a random roaming action: walking around the home position when far from it, waiting for a threat, turning, strafing around the target or walking forward.
function behavior.roam()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle_degrees: f32 = 0
	local home_x: f32 = 0
	local home_y: f32 = 0
	local home_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local facing_angle: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local look_turn_degrees: f32 = 0
	local strafe_angle_degrees: f32 = 0
	local strafe_distance: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
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
	distance = monster.get_distance_between(position_x, position_y, position_z, home_x, home_y, home_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 30.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle_degrees, vm.f32(4.8))
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 30.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(vm.f32(4.8), 1.75, turn_angle_degrees, clear_distance, 30.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance > 800.0 then
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
				distance = monster.get_random_whole_number(150.0) or distance
				if roll < 50 then
					orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
				else
					orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(home_x, home_y, home_z, 1.75, vm.f32(4.8), distance, orbit_angle_degrees, 30.0, 60)
				look_turn_degrees = monster.get_random_whole_number(180.0) or look_turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					look_turn_degrees = vm.f32(look_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(look_turn_degrees, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
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
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle_degrees, vm.f32(4.8))
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
					strafe_angle_degrees = monster.get_random_whole_number(180.0) or strafe_angle_degrees
					strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
					target_distance = monster.get_target_distance() or target_distance
					strafe_distance = vm.f32(strafe_distance + target_distance)
					if roll < 50 then
						strafe_angle_degrees = vm.f32(strafe_angle_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
					else
						strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(1.75, vm.f32(4.8), strafe_angle_degrees, strafe_distance, 30.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_degrees, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						facing_angle = out2 or facing_angle
					end
					turn_angle_degrees = calc.radians_to_degrees(facing_angle)
					if turn_angle_degrees > vm.f32(3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees - vm.f32(6.2831855))
					end
					if turn_angle_degrees <= vm.f32(-3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(1.75, turn_angle_degrees, 1000.0, 30.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance = monster.get_target_distance() or distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(1.75, vm.f32(4.8), distance, 360.0, 40.0, 30.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Loops each frame, choosing an action by target distance, until the target is beyond 240 units or no rage hits remain.
function behavior.run_combat_loop()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 240.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 100 then
			movement.choose_idle_action()
			continue
		end
		if target_distance < 240.0 and target_distance >= 140.0 then
			behavior.act_far_range()
		elseif target_distance < 140.0 and target_distance >= 85.0 then
			behavior.act_medium_range()
		else
			behavior.act_close_range()
		end
		vm.wait()
	end
end

--- Randomly strafes around the target or stands idle for up to 30 frames until the target is within 64 units in front of the monster.
function behavior.strafe_or_wait()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	local strafe_distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_variable(0, 64)
		roll = monster.get_random(100) or roll
		strafe_angle_degrees = monster.get_random_whole_number(30.0) or strafe_angle_degrees
		strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
		strafe_distance = vm.f32(strafe_distance + 200.0)
		if roll < 50 then
			strafe_angle_degrees = vm.f32(-strafe_angle_degrees - 30.0)
		else
			strafe_angle_degrees = vm.f32(strafe_angle_degrees + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.walk_around_target(vm.f32(1.8), 3.0, strafe_angle_degrees, strafe_distance, 64.0, 30)
		movement.turn_toward_target_and_wait(3.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_variable(0, 16)
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(64.0, 45.0, 30)
	end
end

--- Runs the plain speed 3 face-the-player loop when the player is transformed.
function behavior.try_face_transformed_player_plain_speed_3()
	local player_transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	player_transform_id = monster.get_player_transform_id() or player_transform_id
	if player_transform_id > -1 then
		behavior.face_transformed_player_plain_speed_3(monster_kind)
	end
end

--- Runs the plain speed 4 face-the-player loop when the player is transformed.
function behavior.try_face_transformed_player_plain_speed_4()
	local player_transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	player_transform_id = monster.get_player_transform_id() or player_transform_id
	if player_transform_id > -1 then
		behavior.face_transformed_player_plain_speed_4(monster_kind)
	end
end

--- Runs the speed 4 face-the-player loop when the player is transformed.
function behavior.try_face_transformed_player_speed_4()
	local player_transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	player_transform_id = monster.get_player_transform_id() or player_transform_id
	if player_transform_id > -1 then
		behavior.face_transformed_player_speed_4(monster_kind)
	end
end

--- Runs the speed 4.5 face-the-player loop when the player is transformed.
function behavior.try_face_transformed_player_speed_4_5()
	local player_transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	player_transform_id = monster.get_player_transform_id() or player_transform_id
	if player_transform_id > -1 then
		behavior.face_transformed_player_speed_4_5(monster_kind)
	end
end

--- Runs the speed 5 face-the-player loop when the player is transformed.
function behavior.try_face_transformed_player_speed_5()
	local player_transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	player_transform_id = monster.get_player_transform_id() or player_transform_id
	if player_transform_id > -1 then
		behavior.face_transformed_player_speed_5(monster_kind)
	end
end

--- Runs the wide-cone face-the-player loop when the player is transformed.
function behavior.try_face_transformed_player_wide_cone()
	local player_transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	player_transform_id = monster.get_player_transform_id() or player_transform_id
	if player_transform_id > -1 then
		behavior.face_transformed_player_wide_cone(monster_kind)
	end
end

--- Walks or turns according to where the target is until it is within 80 units, or until a random time passes and the target is within a 200 degree arc, then clears the queued attacks and stops moving.
function behavior.wander_until_near_target()
	local frame: s32 = 0
	local wander_frames: s32 = 0
	local target_distance: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	frame = 0
	wander_frames = monster.get_random(60) or wander_frames
	wander_frames = vm.i32(wander_frames + 40)
	while true do
		target_distance = monster.get_target_distance() or target_distance
		if (if target_distance <= 80.0 then 1 else if frame >= wander_frames then sense.is_facing_target_degrees(180, 200) else 0) ~= 0 then
			state.clear_variables_1_to_4()
			movement.stop_turning()
			monster.stop_moving()
			return
		end
		if sense.is_facing_target_degrees(0, 20) ~= 0 then
			monster.set_motion("歩き", 0.55)
		elseif sense.is_facing_target_degrees(90, 180) ~= 0 then
			monster.set_motion("回転右", 0.55)
		else
			monster.set_motion("回転左", 0.55)
		end
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 3.0)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		movement.turn_toward_target(vm.f32(0.017453292))
		monster.move_toward_position(position_x, position_y, position_z, 1.6, 1.0)
		frame = vm.i32(frame + 1)
		vm.wait()
	end
end

return behavior
