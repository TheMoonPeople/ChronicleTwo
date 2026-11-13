--!strict
--- Controls the Gaspard boss fight: a sword-and-magic duelist who circles the arena, slashes, casts spells and dodges with a moonsault.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local sense = require("@lib/monster/sense")
local timer = require("@lib/monster/timer")

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
	timer.wait_frames(3)
end

--- Dashes at the player in short bursts while performing the mid-range sword attack.
local function attack_mid_range_slash()
	local remaining_distance: f32 = 0
	local step_speed: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local frame: s32 = 0
	monster.set_motion("中距離攻撃", -1, 2)
	timer.wait_frames(14)
	frame = 0
	while frame < 6 do
		remaining_distance = monster.get_target_distance() or remaining_distance
		remaining_distance = vm.f32(remaining_distance - 12.0)
		if remaining_distance > 60.0 then
			remaining_distance = 60.0
		end
		step_speed = vm.f32(remaining_distance / 10.0)
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, remaining_distance)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.move_toward_position(pos_x, pos_y, pos_z, step_speed, step_speed)
		movement.turn_toward_target(vm.f32(0.19634955))
		remaining_distance = vm.f32(remaining_distance - step_speed)
		frame = frame + 1
		vm.wait()
	end
	timer.wait_frames(4)
	monster.stop_moving()
	movement.stop_turning()
	motion.wait_until_finished()
	monster.set_motion("立ち")
	timer.wait_frames(3)
end

--- Casts one or two magic projectiles toward the player and stays untouchable briefly.
local function cast_magic_burst()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local roll: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.2)))
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
	print("magic---------------------\n")
	roll = monster.get_random(100) or roll
	if roll < 50 then
		rotation_y = vm.f32(rotation_y - vm.f32(0.62831855))
		monster.create_effect_1("ギル魔法２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_target(-1, 0)
		rotation_y = vm.f32(rotation_y + vm.f32(1.2566371))
		monster.create_effect_1("ギル魔法２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_target(-1, 0)
	else
		monster.create_effect_1("ギル魔法２")
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
	timer.wait_frames(3)
end

--- Casts a series of magic shots at the player, or a burst when the player is close.
local function cast_homing_magic()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local target_distance: f32 = 0
	local character_number: s32 = 0
	local attack: s32 = 0
	local cast_index: s32 = 0
	local roll: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 90.0 then
		cast_magic_burst()
		return
	end
	monster.set_motion("魔法2", -1, 6)
	motion.wait_until_finished()
	roll = monster.get_random(2) or roll
	cast_index = 0
	while cast_index < vm.i32(roll + 3) do
		monster.set_motion("魔法2発動", -1, 6)
		monster.create_effect_1("ギル２魔法Ｌ")
		do
			local out1, out2, out3 = monster.get_frame_position("magic")
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
		attack = vm.ftoi(vm.f32(attack * vm.f32(1.1)))
		character_number = monster.get_character_number(-1) or character_number
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
		monster.set_effect_owner(-1, character_number)
		monster.set_effect_target(-1, 0)
		monster.set_effect_value(-1, 0, 1)
		monster.set_effect_value(-1, 1, attack)
		motion.wait_until_finished()
		monster.set_motion("魔法2L", -1, 0)
		timer.wait_frames(9)
		cast_index = cast_index + 1
	end
	monster.set_motion("魔法2戻り", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Flips backward away from the player and may follow up with a spell or sword attack.
local function perform_moonsault()
	local target_distance: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local target_angle: f32 = 0
	local angle: f32 = 0
	local roll: s32 = 0
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
		destination_x = vm.f32(vm.f32(vm.sin(target_angle) * target_distance) + pos_x)
		destination_y = vm.f32(0.0 + pos_y)
		destination_z = vm.f32(vm.f32(vm.cos(target_angle) * target_distance) + pos_z)
		target_distance = vm.f32(target_distance / 24.0)
		monster.move_toward_position(destination_x, destination_y, destination_z, target_distance, target_distance)
		timer.wait_frames(28)
		monster.set_monster_attributes(49, 0)
		if sense.is_facing_target_degrees(0, 45.0) ~= 0 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					cast_magic_burst()
				else
					cast_homing_magic()
				end
			end
		end
		timer.wait_frames(10)
		monster.set_motion("立ち", -1, 4)
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if (if target_distance < 80.0 then sense.is_facing_target_degrees(0, 45.0) else 0) ~= 0 then
			if target_distance < 50.0 then
				attack_double_slash()
			else
				attack_mid_range_slash()
			end
			timer.wait_frames(3)
		end
	end
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
end

--- Runs up to a distant player, then attacks or performs the moonsault.
local function run_to_target_and_attack()
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
			attack_mid_range_slash()
		end
	else
		perform_moonsault()
	end
	timer.wait_frames(3)
end

--- Hops backward away from a close player and casts a spell.
local function back_step_and_cast()
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local frame: s32 = 0
	local roll: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 180.0 then
		target_angle = monster.get_target_angle() or target_angle
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		target_angle = vm.f32(target_angle - vm.f32(3.1415927))
		target_angle = monster.wrap_angle(target_angle) or target_angle
		destination_x = vm.f32(vm.f32(vm.sin(target_angle) * 80.0) + pos_x)
		destination_y = vm.f32(0.0 + pos_y)
		destination_z = vm.f32(vm.f32(vm.cos(target_angle) * 80.0) + pos_z)
		monster.set_motion("ステップ後", -1, 2)
		timer.wait_frames(10)
		monster.move_toward_position(destination_x, destination_y, destination_z, 8.0, 8.0)
		frame = 0
		while frame < 20 do
			movement.turn_toward_target(vm.f32(0.19634955))
			frame = frame + 1
			vm.wait()
		end
		monster.stop_moving()
		movement.stop_turning()
	elseif sense.is_facing_target_degrees(0, 90) == 0 then
		run_to_target_and_attack()
		return
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		cast_magic_burst()
	else
		cast_homing_magic()
	end
end

--- Moves to the ring around the arena center, leaping when badly hurt, then casts a spell.
local function reposition_around_arena_center()
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
	local target_angle_from_center: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local life: f32 = 0
	local angle: f32 = 0
	local leap_radius: f32 = 0
	local arc_step: f32 = 0
	local leap_frame: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local vertical_velocity: f32 = 0
	local circle_frame: s32 = 0
	local destination_angle: f32 = 0
	local roll: s32 = 0
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
	target_angle_from_center = monster.get_angle_between_positions(-2195.0, 488.0, -475.0, target_x, target_y, target_z) or target_angle_from_center
	life = 1.0
	life = monster.get_life() or life
	if life < vm.f32(0.4) then
		angle = vm.f32(angle_from_center - vm.f32(3.1415927))
		angle = monster.wrap_angle(angle) or angle
		leap_radius = vm.f32(340.0 - distance_from_center)
		if leap_radius > 270.0 then
			leap_radius = 270.0
		end
		destination_x = vm.f32(vm.f32(vm.sin(angle) * leap_radius) + -2195.0)
		destination_y = 488.0
		destination_z = vm.f32(vm.f32(vm.cos(angle) * leap_radius) + -475.0)
		leap_frame = 0
		monster.reset_motion()
		monster.set_motion("ムーンサルト", -1, 2)
		timer.wait_frames(8)
		monster.set_monster_attributes(53, 1)
		monster.turn_toward_angle(angle_from_center, 0.19634955)
		while leap_frame < 24 do
			vertical_velocity = vm.f32(vm.f32(vm.f32(vm.f32(destination_y - pos_y) * 2.0) - -62.5) / 50.0)
			y = pos_y
			arc_step = 0
			while arc_step < leap_frame do
				vertical_velocity = vm.f32(vertical_velocity + vm.f32(-0.1))
				y = vm.f32(y + vertical_velocity)
				arc_step = vm.f32(arc_step + 1)
			end
			if y < destination_y then
				y = destination_y
			end
			x = vm.f32(vm.f32(vm.f32(destination_x - pos_x) * vm.f32(leap_frame / 24.0)) + pos_x)
			z = vm.f32(vm.f32(vm.f32(destination_z - pos_z) * vm.f32(leap_frame / 24.0)) + pos_z)
			monster.set_position(x, y, z)
			leap_frame = leap_frame + 1
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
			target_angle_from_center = vm.f32(target_angle_from_center - angle_from_center)
			circle_frame = 0
			while circle_frame < 60 do
				if target_angle_from_center >= 0.0 then
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
				destination_angle = monster.get_angle_between_positions(pos_x, pos_y, pos_z, destination_x, destination_y, destination_z) or destination_angle
				if circle_frame < 56 then
					monster.turn_toward_angle(destination_angle, 0.19634955)
				else
					movement.turn_toward_target(vm.f32(0.19634955))
				end
				monster.move_toward_position(destination_x, destination_y, destination_z, 6.8, 6.8)
				circle_frame = circle_frame + 1
				vm.wait()
			end
			timer.wait_frames(6)
			monster.stop_moving()
		else
			if calc.compare_angles(angle_from_center, target_angle_from_center, vm.f32(1.5707964)) == 0 then
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
	roll = monster.get_random(100) or roll
	if roll < 50 then
		cast_magic_burst()
	else
		cast_homing_magic()
	end
end

--- Sidesteps around the player, then attacks if close or performs the moonsault if not facing them.
local function sidestep_and_attack()
	local target_distance: f32 = 0
	local roll: s32 = 0
	local sidestep_x: f32 = 0
	local sidestep_y: f32 = 0
	local sidestep_z: f32 = 0
	local sidestep_speed: f32 = 0
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
		sidestep_x, sidestep_y, sidestep_z = movement.get_point_near_target(side_angle_degrees, target_distance, sidestep_x, sidestep_y, sidestep_z)
		timer.wait_frames(8)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		sidestep_speed = monster.get_distance_between(sidestep_x, sidestep_y, sidestep_z, pos_x, pos_y, pos_z) or sidestep_speed
		sidestep_speed = vm.f32(sidestep_speed / 10.0)
		monster.move_toward_position(sidestep_x, sidestep_y, sidestep_z, sidestep_speed, sidestep_speed)
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
				attack_mid_range_slash()
			end
			timer.wait_frames(16)
		else
			perform_moonsault()
		end
	end
end

--- Walks to the point behind the player as seen from the arena center, returning 1 when the player is far and 0 when in position.
local function approach_far_side_of_target()
	local idle_frames: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local facing_angle: f32 = 0
	local target_angle_from_center: f32 = 0
	local distance: f32 = 0
	local self_angle_from_center: f32 = 0
	local arrived: s32 = 0
	local move_speed: f32 = 0
	while true do
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = monster.get_rotation()
			facing_angle = out2 or facing_angle
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		target_angle_from_center = monster.get_angle_between_positions(target_x, target_y, target_z, -2195.0, 488.0, -475.0) or target_angle_from_center
		self_angle_from_center = monster.get_angle_between_positions(pos_x, pos_y, pos_z, -2195.0, 488.0, -475.0) or self_angle_from_center
		if calc.compare_angles(target_angle_from_center, self_angle_from_center, vm.f32(0.3926991)) == 0 then
			monster.stop_moving()
			movement.stop_turning()
			return 0
		end
		distance = monster.get_target_distance() or distance
		if distance > 120.0 then
			return 1
		end
		destination_x = vm.f32(vm.f32(vm.sin(target_angle_from_center) * 140.0) + target_x)
		destination_y = vm.f32(0.0 + target_y)
		destination_z = vm.f32(vm.f32(vm.cos(target_angle_from_center) * 140.0) + target_z)
		distance = monster.get_distance_between(pos_x, pos_y, pos_z, destination_x, destination_y, destination_z) or distance
		if distance <= 22.0 then
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
		move_speed = vm.f32(distance / 30.0)
		if move_speed > 1.5 then
			move_speed = 1.5
		end
		monster.move_toward_position(destination_x, destination_y, destination_z, move_speed, move_speed)
		movement.turn_toward_target(vm.f32(0.19634955))
		target_angle_from_center = monster.get_angle_between_positions(pos_x, pos_y, pos_z, destination_x, destination_y, destination_z) or target_angle_from_center
		target_angle_from_center = monster.wrap_angle(target_angle_from_center) or target_angle_from_center
		if calc.compare_angles(vm.f32(facing_angle + vm.f32(1.5707964)), target_angle_from_center, vm.f32(0.7853982)) == 0 then
			monster.set_motion("バトル歩き(左)")
			vm.wait()
			continue
		end
		if calc.compare_angles(vm.f32(facing_angle - vm.f32(1.5707964)), target_angle_from_center, vm.f32(0.7853982)) == 0 then
			monster.set_motion("バトル歩き(右)")
			vm.wait()
			continue
		end
		if calc.compare_angles(facing_angle, target_angle_from_center, vm.f32(1.5707964)) == 0 then
			monster.set_motion("バトル歩き(前)")
			vm.wait()
			continue
		end
		if calc.compare_angles(vm.f32(facing_angle + vm.f32(3.1415927)), target_angle_from_center, vm.f32(1.5707964)) == 0 then
			monster.set_motion("バトル歩き(後)")
			vm.wait()
			continue
		end
	end
	return 0
end

--- Picks an approach, back step, sidestep or spell by the player's distance and the monster's life.
local function choose_action(unused_state: any)
	local roll: s32 = 0
	local target_distance: f32 = 0
	local life_fraction: f32 = 0
	local close_range_threshold: f32 = 0
	local life: f32 = 0
	local approach_result: s32 = 0
	target_distance = monster.get_target_distance() or target_distance
	life_fraction = monster.get_monster_life_fraction(-1) or life_fraction
	if life_fraction < 0.5 then
		close_range_threshold = 45.0
	else
		close_range_threshold = 60.0
	end
	if target_distance > close_range_threshold then
		roll = monster.get_random(100) or roll
		if roll < 30 then
			back_step_and_cast()
		end
	end
	if target_distance < 60.0 then
		life = 1.0
		life = monster.get_life() or life
		monster.get_random_whole_number(100.0)
		if life < vm.f32(0.4) then
		else
		end
		if false then
			reposition_around_arena_center()
		else
			sidestep_and_attack()
		end
		return
	end
	approach_result = approach_far_side_of_target()
	if approach_result == 0 then
		run_to_target_and_attack()
	end
	if approach_result == 1 then
		back_step_and_cast()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the sword, the attack hit windows and sword trails, and loads the magic and shield effects.
function script.init()
	monster.register_entry_object(1, "ken")
	monster.register_entry_object(2, "obj86")
	monster.register_damage_hit("Ｍ連撃２", 6.0, "2連続攻撃", 0.283, 0.391, 0)
	monster.register_damage_hit("Ｍ連撃２", 6.0, "2連続攻撃", 0.609, 0.696, 0)
	monster.register_damage_hit("通常攻撃", 6.0, "中距離攻撃", 0.5, 0.611, 0)
	monster.add_sword_trail(0, "2連続攻撃", 0.2, 0.26, "ken01", "ken00", 77, 20, 20)
	monster.add_sword_trail(0, "2連続攻撃", 0.58, 0.6, "ken01", "ken00", 77, 20, 20)
	monster.add_sword_trail(0, "中距離攻撃", 0.41, 0.45, "ken01", "ken00", 77, 20, 20)
	monster.add_sword_trail(0, "ムーンサルト", 0.1, 0.3, "ken01", "ken00", 77, 40, 20)
	monster.set_camera_mode(0)
	monster.load_effect_script("ギルトーニシールド")
	monster.load_effect_script("ギル魔法２")
	monster.load_effect_script("ギル魔法サブ２")
	monster.load_effect_script("ギル２魔法Ｌ")
	monster.load_effect_script("ギル２魔法Ｈ")
	monster.set_clip_distance(9999.0)
end

--- Keeps choosing actions every frame.
function script.loop()
	local unused_state: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		choose_action(unused_state)
		vm.wait()
	end
end

--- Faces the player and plays a short flinch.
function script.on_damage()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	vm.wait()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	timer.wait_frames(16)
end

--- Faces the player, is blown backward, lies down and gets back up.
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
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
end

--- Faces the player and raises a magic shield while guarding.
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
script.on_dodge_1 = perform_moonsault

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the second dodge to the engine default by defining nothing.
function script.on_dodge_2() end

--- Plays the death motion, then requests the defeat event.
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
	monster.request_event_script(560)
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves being caught to the engine default by defining nothing.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves landing to the engine default by defining nothing.
function script.on_land() end

return script
