--!strict
--- Controls the sword-fighting boss Gaspard, who casts magic, summons helpers and moonsaults around the arena.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local sense = require("@lib/monster/sense")
local timer = require("@lib/monster/timer")

--- Casts a magic attack toward the player, fanning it out in three directions at low life.
local function cast_magic()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	local life: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_motion("魔法", -1, 2)
	do
		local out1, out2, out3 = monster.get_position_3()
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
	attack = monster.get_attack_power_1() or attack
	attack = vm.i32(attack + 10)
	life = 1.0
	life = monster.get_life() or life
	if life < vm.f32(0.4) then
		rotation_y = vm.f32(rotation_y - vm.f32(0.62831855))
		monster.create_effect_1("ギルトーニ魔法")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_target(-1, 0)
		rotation_y = vm.f32(rotation_y + vm.f32(1.2566371))
		monster.create_effect_1("ギルトーニ魔法")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_target(-1, 0)
	else
		monster.create_effect_1("ギルトーニ魔法")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_target(-1, 0)
	end
	monster.set_monster_attributes(32, 1)
	timer.wait_frames(48)
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("立ち")
	timer.wait_frames(30)
end

--- Moves around the arena centre by a moonsault at low life or a running arc otherwise, then casts magic.
local function reposition_around_arena()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local distance_from_center: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local target_distance_from_center: f32 = 0
	local step_distance: f32 = 0
	local angle_from_center: f32 = 0
	local yaw: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local life: f32 = 0
	local angle: f32 = 0
	local landing_radius: f32 = 0
	local arc_step: f32 = 0
	local jump_frame: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local vertical_velocity: f32 = 0
	local run_frame: s32 = 0
	local yaw_2: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	target_distance_from_center = monster.get_distance_between(target_x, target_y, target_z, -2195.0, 488.0, -475.0) or target_distance_from_center
	distance_from_center = monster.get_distance_between(pos_x, pos_y, pos_z, -2195.0, 488.0, -475.0) or distance_from_center
	angle_from_center = monster.get_angle_between_positions(-2195.0, 488.0, -475.0, pos_x, pos_y, pos_z) or angle_from_center
	yaw = monster.get_angle_between_positions(-2195.0, 488.0, -475.0, target_x, target_y, target_z) or yaw
	life = 1.0
	life = monster.get_life() or life
	if life < vm.f32(0.4) then
		angle = vm.f32(angle_from_center - vm.f32(3.1415927))
		angle = monster.wrap_angle(angle) or angle
		landing_radius = vm.f32(340.0 - distance_from_center)
		if landing_radius > 270.0 then
			landing_radius = 270.0
		end
		destination_x = vm.f32(vm.f32(vm.sin(angle) * landing_radius) + -2195.0)
		destination_y = 488.0
		destination_z = vm.f32(vm.f32(vm.cos(angle) * landing_radius) + -475.0)
		jump_frame = 0
		monster.reset_motion()
		monster.set_motion("ムーンサルト", -1, 2)
		timer.wait_frames(8)
		monster.set_monster_attributes(53, 1)
		monster.turn_toward_angle(angle_from_center, 0.19634955)
		while jump_frame < 24 do
			vertical_velocity = vm.f32(vm.f32(vm.f32(vm.f32(destination_y - pos_y) * 2.0) - -62.5) / 50.0)
			y = pos_y
			arc_step = 0
			while arc_step < jump_frame do
				vertical_velocity = vm.f32(vertical_velocity + vm.f32(-0.1))
				y = vm.f32(y + vertical_velocity)
				arc_step = vm.f32(arc_step + 1)
			end
			if y < destination_y then
				y = destination_y
			end
			x = vm.f32(vm.f32(vm.f32(destination_x - pos_x) * vm.f32(jump_frame / 24.0)) + pos_x)
			z = vm.f32(vm.f32(vm.f32(destination_z - pos_z) * vm.f32(jump_frame / 24.0)) + pos_z)
			monster.set_position(x, y, z)
			jump_frame = jump_frame + 1
			vm.wait()
		end
		timer.wait_frames(28)
		monster.set_monster_attributes(53, 0)
		timer.wait_frames(10)
		monster.set_motion("立ち", -1, 4)
		vm.wait()
	else
		monster.set_motion("走り")
		if target_distance_from_center < distance_from_center then
			step_distance = vm.f32(vm.f32(300.0 - distance_from_center) / 60.0)
			yaw = vm.f32(yaw - angle_from_center)
			run_frame = 0
			while run_frame < 60 do
				if yaw >= 0.0 then
					angle_from_center = vm.f32(angle_from_center - vm.f32(0.05235988))
				else
					angle_from_center = vm.f32(angle_from_center + vm.f32(0.05235988))
				end
				angle_from_center = monster.wrap_angle(angle_from_center) or angle_from_center
				distance_from_center = vm.f32(distance_from_center + step_distance)
				destination_x = vm.f32(vm.f32(vm.sin(angle_from_center) * distance_from_center) + -2195.0)
				destination_y = 488.0
				destination_z = vm.f32(vm.f32(vm.cos(angle_from_center) * distance_from_center) + -475.0)
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				yaw_2 = monster.get_angle_between_positions(pos_x, pos_y, pos_z, destination_x, destination_y, destination_z) or yaw_2
				if run_frame < 56 then
					monster.turn_toward_angle(yaw_2, 0.19634955)
				else
					movement.turn_toward_target(vm.f32(0.19634955))
				end
				monster.move_toward_position(destination_x, destination_y, destination_z, 6.8, 6.8)
				run_frame = run_frame + 1
				vm.wait()
			end
			timer.wait_frames(6)
			monster.stop_moving()
		else
			if calc.compare_angles(angle_from_center, yaw, vm.f32(1.5707964)) == 0 then
				angle_from_center = vm.f32(angle_from_center - vm.f32(3.1415927))
			end
			angle_from_center = monster.wrap_angle(angle_from_center) or angle_from_center
			destination_x = vm.f32(vm.f32(vm.sin(angle_from_center) * 300.0) + -2195.0)
			destination_y = 488.0
			destination_z = vm.f32(vm.f32(vm.cos(angle_from_center) * 300.0) + -475.0)
			distance_from_center = monster.get_distance_between(pos_x, pos_y, pos_z, destination_x, destination_y, destination_z) or distance_from_center
			angle_from_center = monster.get_angle_between_positions(pos_x, pos_y, pos_z, destination_x, destination_y, destination_z) or angle_from_center
			monster.turn_toward_angle(angle_from_center, 0.19634955)
			monster.move_toward_position(destination_x, destination_y, destination_z, 6.8, 6.8)
			movement.wait_until_move_finished(vm.f32(vm.f32(distance_from_center / vm.f32(6.8)) - 10.0))
			movement.turn_toward_target(vm.f32(0.19634955))
			timer.wait_frames(16)
			monster.stop_moving()
		end
	end
	movement.stop_turning()
	cast_magic()
end

--- Performs the two-hit sword attack while turning toward the player.
local function attack_double_slash()
	local frame: s32 = 0
	monster.set_motion("2連続攻撃", -1, 2)
	frame = 0
	while frame < 18 do
		movement.turn_toward_target(vm.f32(0.19634955))
		frame = frame + 1
		vm.wait()
	end
	motion.wait_until_finished()
	monster.stop_moving()
	monster.set_motion("立ち")
	timer.wait_frames(8)
end

--- Lunges toward the player for a mid-range sword attack.
local function attack_lunge_slash()
	local lunge_distance: f32 = 0
	local step_speed: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local frame: s32 = 0
	monster.set_motion("中距離攻撃", -1, 2)
	timer.wait_frames(14)
	frame = 0
	while frame < 6 do
		lunge_distance = monster.get_target_distance() or lunge_distance
		lunge_distance = vm.f32(lunge_distance - 12.0)
		if lunge_distance > 60.0 then
			lunge_distance = 60.0
		end
		step_speed = vm.f32(lunge_distance / 10.0)
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, lunge_distance)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.move_toward_position(pos_x, pos_y, pos_z, step_speed, step_speed)
		movement.turn_toward_target(vm.f32(0.19634955))
		lunge_distance = vm.f32(lunge_distance - step_speed)
		frame = frame + 1
		vm.wait()
	end
	timer.wait_frames(4)
	monster.stop_moving()
	movement.stop_turning()
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(8)
end

--- Moonsaults away from a close player and follows up with a sword attack if the player is still near.
local function moonsault_away()
	local target_distance: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local target_angle: f32 = 0
	local angle: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.stop_moving()
	movement.stop_turning()
	vm.wait()
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 40.0 then
		monster.reset_motion()
		monster.set_motion("ムーンサルト", -1, 2)
		timer.wait_frames(8)
		monster.set_monster_attributes(49, 1)
		target_angle = monster.get_target_angle() or target_angle
		angle = vm.f32(target_angle - vm.f32(3.1415927))
		angle = monster.wrap_angle(angle) or angle
		monster.turn_toward_angle(angle, 0.1308997)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		target_distance = vm.f32(target_distance * 2.5)
		target = vm.f32(vm.f32(vm.sin(target_angle) * target_distance) + pos_x)
		target_2 = vm.f32(0.0 + pos_y)
		target_3 = vm.f32(vm.f32(vm.cos(target_angle) * target_distance) + pos_z)
		target_distance = vm.f32(target_distance / 24.0)
		monster.move_toward_position(target, target_2, target_3, target_distance, target_distance)
		timer.wait_frames(28)
		monster.set_monster_attributes(49, 0)
		timer.wait_frames(10)
		monster.set_motion("立ち", -1, 4)
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if (if target_distance < 80.0 then sense.is_facing_target_degrees(0, 45.0) else 0) ~= 0 then
			if target_distance < 50.0 then
				attack_double_slash()
			else
				attack_lunge_slash()
			end
			timer.wait_frames(8)
		end
	end
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
end

--- Optionally sidesteps around the player and then picks a close-range attack.
local function sidestep_and_attack()
	local target_distance: f32 = 0
	local roll: s32 = 0
	local side_x: f32 = 0
	local side_y: f32 = 0
	local side_z: f32 = 0
	local step_speed: f32 = 0
	local side_roll: s32 = 0
	local side_angle_degrees: s32 = 0
	local frame: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 50 then
		side_roll = monster.get_random(100) or side_roll
		if side_roll < 50 then
			side_angle_degrees = 90
			monster.reset_motion()
			monster.set_motion("ステップ右", -1, 2)
		else
			side_angle_degrees = -90
			monster.reset_motion()
			monster.set_motion("ステップ左", -1, 2)
		end
		if target_distance < 30.0 then
			target_distance = 30.0
		end
		side_x, side_y, side_z = movement.get_point_near_target(side_angle_degrees, target_distance, side_x, side_y, side_z)
		timer.wait_frames(8)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		step_speed = monster.get_distance_between(side_x, side_y, side_z, pos_x, pos_y, pos_z) or step_speed
		step_speed = vm.f32(step_speed / 10.0)
		monster.move_toward_position(side_x, side_y, side_z, step_speed, step_speed)
		frame = 0
		while frame < 13 do
			movement.turn_toward_target(vm.f32(0.19634955))
			frame = frame + 1
			vm.wait()
		end
		monster.stop_moving()
		movement.stop_turning()
	end
	if target_distance < 60.0 then
		if sense.is_facing_target_degrees(0, 45.0) ~= 0 then
			if target_distance < 50.0 then
				attack_double_slash()
			else
				attack_lunge_slash()
			end
			timer.wait_frames(16)
		else
			moonsault_away()
		end
	end
end

--- Starts a new phase at 70 and 40 percent life, summoning helpers and waiting for the player to approach.
local function check_phase_change()
	local phase_changed: s32 = 0
	local value: s32 = 0
	local life: f32 = 0
	local target_distance: f32 = 0
	phase_changed = 0
	value = 0
	value = monster.get_variable(0) or value
	life = 0.0
	life = monster.get_life() or life
	if life < vm.f32(0.4) and value == 1 then
		monster.request_event_script(510)
		monster.set_variable(0, 2)
		phase_changed = 1
	elseif life < vm.f32(0.7) and value <= 0 then
		monster.request_event_script(510)
		monster.set_variable(0, 1)
		phase_changed = 1
		monster.create_monster(513, 0.0, -100.0, 0.0)
		monster.create_monster(513, 0.0, -100.0, 0.0)
		monster.create_monster(513, 0.0, -100.0, 0.0)
		monster.create_monster(513, 0.0, -100.0, 0.0)
		monster.create_monster(513, 0.0, -100.0, 0.0)
	end
	if phase_changed == 1 then
		monster.set_monster_attributes(1, 1)
		monster.set_motion("立ち")
		timer.wait_frames(60)
		while true do
			target_distance = monster.get_target_distance() or target_distance
			if target_distance <= 400.0 then
				break
			else
				vm.wait()
			end
		end
		monster.set_monster_attributes(1, 0)
	end
end

--- Walks around the player at a fixed range, returning whether to attack or retreat.
local function strafe_around_target()
	local idle_frames: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local desired_x: f32 = 0
	local desired_y: f32 = 0
	local desired_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local facing_yaw: f32 = 0
	local target_angle_from_center: f32 = 0
	local target_distance: f32 = 0
	local yaw: f32 = 0
	local arrived: s32 = 0
	local move_speed: f32 = 0
	while true do
		check_phase_change()
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.get_rotation()
			facing_yaw = out2 or facing_yaw
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		target_angle_from_center = monster.get_angle_between_positions(target_x, target_y, target_z, -2195.0, 488.0, -475.0) or target_angle_from_center
		yaw = monster.get_angle_between_positions(pos_x, pos_y, pos_z, -2195.0, 488.0, -475.0) or yaw
		if calc.compare_angles(target_angle_from_center, yaw, vm.f32(0.3926991)) == 0 then
			monster.stop_moving()
			movement.stop_turning()
			return 0
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 160.0 then
			return 1
		end
		desired_x = vm.f32(vm.f32(vm.sin(target_angle_from_center) * 140.0) + target_x)
		desired_y = vm.f32(0.0 + target_y)
		desired_z = vm.f32(vm.f32(vm.cos(target_angle_from_center) * 140.0) + target_z)
		target_distance = monster.get_distance_between(pos_x, pos_y, pos_z, desired_x, desired_y, desired_z) or target_distance
		if target_distance <= 22.0 then
			arrived = monster.is_move_finished() or arrived
			if arrived ~= 0 then
				monster.set_motion("立ち")
			end
			if idle_frames > 90 then
				return 0
			end
			idle_frames = idle_frames + 1
			vm.wait()
			continue
		end
		idle_frames = 0
		move_speed = vm.f32(target_distance / 30.0)
		if move_speed > 1.5 then
			move_speed = 1.5
		end
		monster.move_toward_position(desired_x, desired_y, desired_z, move_speed, move_speed)
		movement.turn_toward_target(vm.f32(0.19634955))
		target_angle_from_center = monster.get_angle_between_positions(pos_x, pos_y, pos_z, desired_x, desired_y, desired_z) or target_angle_from_center
		target_angle_from_center = monster.wrap_angle(target_angle_from_center) or target_angle_from_center
		if calc.compare_angles(vm.f32(facing_yaw + vm.f32(1.5707964)), target_angle_from_center, vm.f32(0.7853982)) == 0 then
			monster.set_motion("バトル歩き(左)")
			vm.wait()
			continue
		end
		if calc.compare_angles(vm.f32(facing_yaw - vm.f32(1.5707964)), target_angle_from_center, vm.f32(0.7853982)) == 0 then
			monster.set_motion("バトル歩き(右)")
			vm.wait()
			continue
		end
		if calc.compare_angles(facing_yaw, target_angle_from_center, vm.f32(1.5707964)) == 0 then
			monster.set_motion("バトル歩き(前)")
			vm.wait()
			continue
		end
		if calc.compare_angles(vm.f32(facing_yaw + vm.f32(3.1415927)), target_angle_from_center, vm.f32(1.5707964)) == 0 then
			monster.set_motion("バトル歩き(後)")
			vm.wait()
			continue
		end
	end
	return 0
end

--- Runs to the player if far away and then attacks or moonsaults away.
local function close_in_and_attack()
	local target_distance: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local arrived: s32 = 0
	local roll: s32 = 0
	local close_distance: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance > 80.0 then
		monster.set_motion("走り")
		while true do
			do
				local out1, out2, out3 = monster.get_target_position()
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			monster.move_toward_position(target_x, target_y, target_z, 6.8, 40.0)
			movement.turn_toward_target(vm.f32(0.19634955))
			arrived = monster.is_move_finished() or arrived
			if arrived ~= 0 then
				monster.set_motion("立ち")
				break
			end
			vm.wait()
		end
	end
	roll = monster.get_random(100) or roll
	if roll > 95 then
		close_distance = monster.get_target_distance() or close_distance
		if close_distance < 50.0 then
			attack_double_slash()
		else
			attack_lunge_slash()
		end
	else
		moonsault_away()
	end
	timer.wait_frames(8)
end

--- Steps away from a near player and casts magic, or closes in if the player is not in front.
local function back_away_and_cast()
	local target_distance: f32 = 0
	local retreat_angle: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local frame: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 180.0 then
		retreat_angle = monster.get_target_angle() or retreat_angle
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		retreat_angle = vm.f32(retreat_angle - vm.f32(3.1415927))
		retreat_angle = monster.wrap_angle(retreat_angle) or retreat_angle
		target = vm.f32(vm.f32(vm.sin(retreat_angle) * 80.0) + pos_x)
		target_2 = vm.f32(0.0 + pos_y)
		target_3 = vm.f32(vm.f32(vm.cos(retreat_angle) * 80.0) + pos_z)
		monster.set_motion("ステップ後", -1, 2)
		timer.wait_frames(10)
		monster.move_toward_position(target, target_2, target_3, 8.0, 8.0)
		frame = 0
		while frame < 20 do
			movement.turn_toward_target(vm.f32(0.19634955))
			frame = frame + 1
			vm.wait()
		end
		monster.stop_moving()
		movement.stop_turning()
	elseif sense.is_facing_target_degrees(0, 90) == 0 then
		close_in_and_attack()
		return
	end
	cast_magic()
end

--- Picks the next action from the distance to the player.
local function choose_action(unused_argument: any)
	local target_distance: f32 = 0
	local life: f32 = 0
	local strafe_result: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 60.0 then
		life = 1.0
		life = monster.get_life() or life
		monster.get_random_whole_number(100.0)
		if life < vm.f32(0.4) then
		else
		end
		if false then
			reposition_around_arena()
		else
			sidestep_and_attack()
		end
		return
	end
	strafe_result = strafe_around_target()
	if strafe_result == 0 then
		close_in_and_attack()
	end
	if strafe_result == 1 then
		back_away_and_cast()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the sword hits and trails, the effect scripts and the clip distance.
function script.init()
	monster.register_entry_object(1, "ken")
	monster.register_entry_object(2, "obj86")
	monster.register_damage_hit("通常攻撃", 6.0, "2連続攻撃", 0.283, 0.391, 0)
	monster.register_damage_hit("通常攻撃", 6.0, "2連続攻撃", 0.609, 0.696, 0)
	monster.register_damage_hit("通常攻撃", 6.0, "中距離攻撃", 0.5, 0.611, 0)
	monster.add_sword_trail(0, "2連続攻撃", 0.2, 0.26, "ken01", "ken00", 77, 20, 20)
	monster.add_sword_trail(0, "2連続攻撃", 0.58, 0.6, "ken01", "ken00", 77, 20, 20)
	monster.add_sword_trail(0, "中距離攻撃", 0.41, 0.45, "ken01", "ken00", 77, 20, 20)
	monster.add_sword_trail(0, "ムーンサルト", 0.1, 0.3, "ken01", "ken00", 77, 40, 20)
	monster.set_variable(0, 0)
	monster.load_effect_script("ギルトーニシールド")
	monster.load_effect_script("ギルトーニ魔法")
	monster.load_effect_script("ギルトーニ魔法サブ")
	monster.set_clip_distance(60.0)
end

--- Repeatedly chooses and performs an action.
function script.loop()
	local unused_argument: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		choose_action(unused_argument)
		vm.wait()
	end
end

--- Staggers back and then checks for a phase change.
function script.on_damage()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	vm.wait()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	timer.wait_frames(16)
	check_phase_change()
end

--- Is knocked down, gets up and then checks for a phase change.
function script.on_knockdown()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	vm.wait()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(5.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(30)
	monster.set_action_status(0)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_monster_attributes(32, 1)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_monster_attributes(32, 0)
	check_phase_change()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
end

--- Raises a shield effect and blocks the hit.
function script.on_guard()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	vm.wait()
	do
		local out1, out2, out3 = monster.get_position_3()
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
	monster.create_effect_1("ギルトーニシールド")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	motion.wait_until_finished()
	timer.wait_frames(8)
	monster.set_motion("立ち")
end

--- Dodges the target's first kind of attack.
script.on_dodge_1 = moonsault_away

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the second dodge.
function script.on_dodge_2() end

--- Plays the death motion and requests the defeat event.
function script.on_death()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_monster_attributes(2, 1)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.start_death()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	timer.wait_frames(30)
	monster.request_event_script(501)
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores being caught.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores landing.
function script.on_land() end

return script
