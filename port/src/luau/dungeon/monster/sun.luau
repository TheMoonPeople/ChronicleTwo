--!strict
--- Drives the Sun boss that teleports, summons roses and tornados and dodges or shields against attacks.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")

--- Clears the six stored rose effect slots.
local function reset_rose_slots()
	for index = 0, 5 do
		monster.set_variable(12 + index, 999999)
	end
end

--- Sets the clip distance to a short range for ordinary monsters and a long range for bosses.
local function configure_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Stops the boss sounds and requests the half-life event once the life drops below half.
local function request_half_life_event()
	local value: s32 = 0
	local life: f32 = 0
	life = 0.0
	life = monster.get_life() or life
	if life < 0.5 then
		value = monster.get_variable(8) or value
		if value == 0 then
			monster.stop_sound(4)
			monster.stop_sound(5)
			monster.stop_sound(7)
			monster.stop_sound(15)
			monster.stop_sound(39)
			monster.set_variable(8, 1)
			monster.request_event_script(502)
		end
	end
end

--- Checks for the half-life event.
local function update_fight_state()
	request_half_life_event()
end

--- Updates the fight state and waits one frame.
local function wait_frame_with_updates()
	update_fight_state()
	vm.wait()
end

--- Waits until the current motion finishes.
local function wait_for_motion_end()
	local motion_finished: s32 = 0
	while true do
		wait_frame_with_updates()
		motion_finished = monster.is_motion_finished() or motion_finished
		if motion_finished ~= 0 then
			return
		end
	end
end

--- Waits the given number of frames with state updates.
local function wait_frames(frame_count: any)
	local frame: s32 = 0
	frame = 0
	while frame < frame_count do
		wait_frame_with_updates()
		frame = vm.i32(frame + 1)
	end
end

--- Warps out, fades, reappears at one of several arena points facing the target and fades back in.
local function teleport_to_random_point()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_angle: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local point_index: s32 = 0
	local chara_type: s32 = 0
	local alpha: f32 = 0
	local frame: s32 = 0
	monster.set_variable(13, 1)
	monster.set_monster_attributes(32, 1)
	chara_type = monster.get_character_number() or chara_type
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("サンワープ")
	monster.set_effect_first_vector(-1, pos_x, pos_y + 8.0, pos_z)
	monster.set_effect_owner(-1, chara_type)
	monster.set_motion("テレポート飛び", -1, 2)
	wait_for_motion_end()
	monster.set_motion("テレポート中", -1, 4)
	wait_frames(15)
	monster.set_model_lighting(0)
	alpha = 128.0
	frame = 0
	while frame < 15 do
		monster.set_model_color(128.0, 128.0, 128.0, alpha)
		alpha = vm.f32(alpha - vm.f32(8.533334))
		wait_frame_with_updates()
		frame = frame + 1
	end
	monster.set_model_lighting(1)
	target_angle = monster.get_target_angle() or target_angle
	point_index = monster.get_random(9) or point_index
	if point_index == 0 then
		x = vm.f32(-327.07)
		y = 35.0
		z = vm.f32(309.72)
	end
	if point_index == 1 then
		x = vm.f32(-108.6)
		y = 35.0
		z = vm.f32(483.43)
	end
	if point_index == 2 then
		x = -19.5
		y = 35.0
		z = vm.f32(478.12)
	end
	if point_index == 3 then
		x = vm.f32(169.15)
		y = 35.0
		z = vm.f32(330.21)
	end
	if point_index == 4 then
		x = 269.25
		y = 35.0
		z = vm.f32(305.36)
	end
	if point_index >= 5 then
		x = 0.0
		y = 35.0
		z = 120.0
	end
	monster.set_position(x, y, z)
	wait_frame_with_updates()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_motion("テレポート着地", -1, 6)
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	wait_frame_with_updates()
	monster.set_model_lighting(0)
	alpha = 0.0
	frame = 0
	while frame < 28 do
		monster.set_model_color(128.0, 128.0, 128.0, alpha)
		alpha = vm.f32(alpha + vm.f32(4.571429))
		wait_frame_with_updates()
		frame = frame + 1
	end
	monster.set_model_color(128.0, 128.0, 128.0, 128.0)
	monster.set_model_lighting(1)
	monster.set_monster_attributes(32, 0)
	monster.set_variable(13, 0)
end

--- Waits until the monster's yaw is within tolerance of the given angle or the frame limit is reached, and returns the frames waited.
local function wait_until_facing(target_angle_degrees: f32, turn_speed_degrees: f32, max_frames: f32)
	local current_yaw: f32 = 0
	local frames_waited: f32 = 0
	local frame_limit: f32 = 0
	local tolerance: f32 = 0
	target_angle_degrees = calc.degrees_to_radians(target_angle_degrees)
	if target_angle_degrees > vm.f32(3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees - vm.f32(6.2831855))
	end
	if target_angle_degrees <= vm.f32(-3.1415927) then
		target_angle_degrees = vm.f32(target_angle_degrees + vm.f32(6.2831855))
	end
	turn_speed_degrees = calc.degrees_to_radians(turn_speed_degrees)
	frame_limit = max_frames
	if turn_speed_degrees < 3.0 then
		tolerance = calc.degrees_to_radians(3.0)
	else
		tolerance = turn_speed_degrees
	end
	frames_waited = 0.0
	while frames_waited < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_yaw = out2 or current_yaw
		end
		if current_yaw > vm.f32(target_angle_degrees - tolerance) and current_yaw < vm.f32(target_angle_degrees + tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle_degrees, current_yaw, turn_speed_degrees) == 0 then
			movement.stop_turning()
			break
		elseif frames_waited >= max_frames then
			movement.stop_turning()
			break
		else
			wait_frame_with_updates()
			frames_waited = vm.f32(frames_waited + 1.0)
		end
	end
	movement.stop_turning()
	return frames_waited
end

--- Turns toward the target at the given speed and waits until it is facing it.
local function turn_to_face_target(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Waits until the current motion reaches the given progress within a tolerance or finishes.
local function wait_for_motion_progress(target_progress: f32, tolerance: f32)
	local motion_progress: f32 = 0
	local frame_count: s32 = 0
	local motion_finished: s32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.03)
	end
	frame_count = 0
	while true do
		wait_frame_with_updates()
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress < vm.f32(target_progress + tolerance) and motion_progress > vm.f32(target_progress - tolerance) then
			break
		else
			motion_finished = monster.is_motion_finished() or motion_finished
			if motion_finished ~= 0 then
				break
			else
				frame_count = vm.i32(frame_count + 1)
			end
		end
	end
end

--- Turns toward the target every frame for the given number of frames.
local function track_target_for_frames(rot_speed: f32, frame_count: s32)
	local target_angle: f32 = 0
	local _ = calc.degrees_to_radians(rot_speed)
	for frame = 0, frame_count - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		wait_frame_with_updates()
	end
	movement.stop_turning()
end

--- Finishes all active rose effects and clears their slots.
local function finish_rose_effects()
	local effect_slot: s32 = 0
	for index = 0, 5 do
		effect_slot = monster.get_variable(12 + index) or effect_slot
		if effect_slot ~= 999999 then
			monster.finish_effect(effect_slot)
			monster.set_variable(12 + index, 999999)
		end
	end
end

--- Summons six roses that circle the boss and then fire them at the target one after another.
local function attack_rose_barrage(charge_frames: any)
	local source_x: f32 = 0
	local source_y: f32 = 0
	local source_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rose_speed: f32 = 0
	local attack: s32 = 0
	local homing_frames: s32 = 0
	local roses: { s32 } = table.create(6, 0)
	homing_frames = 30
	rose_speed = 15.0
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(0.45)))
	monster.set_mask_flags(2, 1)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	if position_x > -200.0 and position_x < 200.0 then
		source_x = vm.f32(-154.46)
		source_y = vm.f32(93.65)
		source_z = vm.f32(-29.71)
	end
	if position_x < -200.0 then
		source_x = vm.f32(-759.58)
		source_y = vm.f32(93.65)
		source_z = vm.f32(-0.93)
	end
	if position_x > 200.0 then
		source_x = vm.f32(760.43)
		source_y = vm.f32(93.65)
		source_z = vm.f32(-0.18)
	end
	roses[1] = monster.create_effect_2("バラ") or roses[1]
	monster.set_effect_first_vector(roses[1], source_x, source_y + 15.0, source_z)
	monster.set_effect_second_vector(roses[1], position_x + vm.f32(vm.sin(0.0) * 30.0), position_y + 15.0, position_z + vm.f32(vm.cos(0.0) * 30.0))
	monster.set_effect_value(roses[1], 0, attack)
	monster.set_effect_value_float(roses[1], 1, rose_speed)
	monster.set_effect_value(roses[1], 2, homing_frames)
	roses[2] = monster.create_effect_2("バラ") or roses[2]
	monster.set_effect_first_vector(roses[2], source_x, source_y + 15.0, source_z)
	monster.set_effect_second_vector(
		roses[2],
		position_x + vm.f32(vm.sin(vm.f32(1.0471976)) * 30.0),
		position_y + 15.0,
		position_z + vm.f32(vm.cos(vm.f32(1.0471976)) * 30.0)
	)
	monster.set_effect_value(roses[2], 0, attack)
	monster.set_effect_value_float(roses[2], 1, rose_speed)
	monster.set_effect_value(roses[2], 2, homing_frames)
	roses[3] = monster.create_effect_2("バラ") or roses[3]
	monster.set_effect_first_vector(roses[3], source_x, source_y + 15.0, source_z)
	monster.set_effect_second_vector(
		roses[3],
		position_x + vm.f32(vm.sin(vm.f32(2.0943952)) * 30.0),
		position_y + 15.0,
		position_z + vm.f32(vm.cos(vm.f32(2.0943952)) * 30.0)
	)
	monster.set_effect_value(roses[3], 0, attack)
	monster.set_effect_value_float(roses[3], 1, rose_speed)
	monster.set_effect_value(roses[3], 2, homing_frames)
	if position_x > -200.0 and position_x < 200.0 then
		source_x = vm.f32(153.97)
		source_y = vm.f32(93.65)
		source_z = vm.f32(-30.21)
	end
	if position_x < -200.0 then
		source_x = vm.f32(-713.73)
		source_y = vm.f32(93.65)
		source_z = vm.f32(-261.19)
	end
	if position_x > 200.0 then
		source_x = vm.f32(714.34)
		source_y = vm.f32(93.65)
		source_z = vm.f32(-260.45)
	end
	roses[4] = monster.create_effect_2("バラ") or roses[4]
	monster.set_effect_first_vector(roses[4], source_x, source_y + 15.0, source_z)
	monster.set_effect_second_vector(
		roses[4],
		position_x + vm.f32(vm.sin(vm.f32(3.1415927)) * 30.0),
		position_y + 15.0,
		position_z + vm.f32(vm.cos(vm.f32(3.1415927)) * 30.0)
	)
	monster.set_effect_value(roses[4], 0, attack)
	monster.set_effect_value_float(roses[4], 1, rose_speed)
	monster.set_effect_value(roses[4], 2, homing_frames)
	roses[5] = monster.create_effect_2("バラ") or roses[5]
	monster.set_effect_first_vector(roses[5], source_x, source_y + 15.0, source_z)
	monster.set_effect_second_vector(
		roses[5],
		position_x + vm.f32(vm.sin(vm.f32(4.1887903)) * 30.0),
		position_y + 15.0,
		position_z + vm.f32(vm.cos(vm.f32(4.1887903)) * 30.0)
	)
	monster.set_effect_value(roses[5], 0, attack)
	monster.set_effect_value_float(roses[5], 1, rose_speed)
	monster.set_effect_value(roses[5], 2, homing_frames)
	roses[6] = monster.create_effect_2("バラ") or roses[6]
	monster.set_effect_first_vector(roses[6], source_x, source_y + 15.0, source_z)
	monster.set_effect_second_vector(
		roses[6],
		position_x + vm.f32(vm.sin(vm.f32(5.2359877)) * 30.0),
		position_y + 15.0,
		position_z + vm.f32(vm.cos(vm.f32(1.0471976)) * 30.0)
	)
	monster.set_effect_value(roses[6], 0, attack)
	monster.set_effect_value_float(roses[6], 1, rose_speed)
	monster.set_effect_value(roses[6], 2, homing_frames)
	for index = 0, 5 do
		monster.set_variable(12 + index, roses[index + 1])
	end
	wait_frames(homing_frames)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	rose_speed = 1.25
	monster.set_effect_first_vector(roses[1], position_x, position_y + 15.0, position_z)
	monster.set_effect_value_float(roses[1], 1, rose_speed)
	monster.set_effect_value(roses[1], 7, 1)
	monster.set_effect_value_float(roses[1], 4, -0.043633234)
	monster.set_effect_value_float(roses[1], 5, 0.0)
	monster.set_effect_value_float(roses[1], 3, 0.043633234)
	monster.set_effect_first_vector(roses[2], position_x, position_y + 15.0, position_z)
	monster.set_effect_value_float(roses[2], 1, rose_speed)
	monster.set_effect_value(roses[2], 7, 1)
	monster.set_effect_value_float(roses[2], 4, 0.043633234)
	monster.set_effect_value_float(roses[2], 5, 1.0471976)
	monster.set_effect_value_float(roses[2], 3, 0.043633234)
	monster.set_effect_first_vector(roses[3], position_x, position_y + 15.0, position_z)
	monster.set_effect_value_float(roses[3], 1, rose_speed)
	monster.set_effect_value(roses[3], 7, 1)
	monster.set_effect_value_float(roses[3], 4, 0.043633234)
	monster.set_effect_value_float(roses[3], 5, 2.0943952)
	monster.set_effect_value_float(roses[3], 3, -0.043633234)
	monster.set_effect_first_vector(roses[4], position_x, position_y + 15.0, position_z)
	monster.set_effect_value_float(roses[4], 1, rose_speed)
	monster.set_effect_value(roses[4], 7, 1)
	monster.set_effect_value_float(roses[4], 4, 0.043633234)
	monster.set_effect_value_float(roses[4], 5, 3.1415927)
	monster.set_effect_value_float(roses[4], 3, 0.043633234)
	monster.set_effect_first_vector(roses[5], position_x, position_y + 15.0, position_z)
	monster.set_effect_value_float(roses[5], 1, rose_speed)
	monster.set_effect_value(roses[5], 7, 1)
	monster.set_effect_value_float(roses[5], 4, -0.043633234)
	monster.set_effect_value_float(roses[5], 5, 4.1887903)
	monster.set_effect_value_float(roses[5], 3, -0.043633234)
	monster.set_effect_first_vector(roses[6], position_x, position_y + 15.0, position_z)
	monster.set_effect_value_float(roses[6], 1, rose_speed)
	monster.set_effect_value(roses[6], 7, 1)
	monster.set_effect_value_float(roses[6], 4, 0.043633234)
	monster.set_effect_value_float(roses[6], 5, 5.2359877)
	monster.set_effect_value_float(roses[6], 3, 0.043633234)
	monster.set_motion("歩き", -1.0, 0)
	track_target_for_frames(5.0, homing_frames)
	monster.set_motion("歩き", -1.0, 0)
	turn_to_face_target(5.0)
	monster.play_sound(5)
	monster.set_motion("攻撃１", -1, 2)
	wait_for_motion_progress(vm.f32(0.453), -1.0)
	attack = monster.get_attack_power_1() or attack
	rose_speed = 20.0
	monster.play_sound(6)
	do
		local out1, out2, out3 = monster.get_target_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_effect_second_vector(roses[1], position_x, position_y + 3.0, position_z)
	monster.set_effect_value(roses[1], 0, attack)
	monster.set_effect_value_float(roses[1], 1, rose_speed)
	monster.set_effect_value(roses[1], 2, 90)
	monster.set_effect_value(roses[1], 7, 1)
	wait_frames(9)
	monster.play_sound(6)
	do
		local out1, out2, out3 = monster.get_target_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_effect_second_vector(roses[2], position_x, position_y + 3.0, position_z)
	monster.set_effect_value(roses[2], 0, attack)
	monster.set_effect_value_float(roses[2], 1, rose_speed)
	monster.set_effect_value(roses[2], 2, 90)
	monster.set_effect_value(roses[2], 7, 1)
	wait_frames(9)
	monster.play_sound(6)
	do
		local out1, out2, out3 = monster.get_target_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_effect_second_vector(roses[3], position_x, position_y + 3.0, position_z)
	monster.set_effect_value(roses[3], 0, attack)
	monster.set_effect_value_float(roses[3], 1, rose_speed)
	monster.set_effect_value(roses[3], 2, 90)
	monster.set_effect_value(roses[3], 7, 1)
	wait_frames(9)
	monster.play_sound(6)
	do
		local out1, out2, out3 = monster.get_target_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_effect_second_vector(roses[4], position_x, position_y + 3.0, position_z)
	monster.set_effect_value(roses[4], 0, attack)
	monster.set_effect_value_float(roses[4], 1, rose_speed)
	monster.set_effect_value(roses[4], 2, 90)
	monster.set_effect_value(roses[4], 7, 1)
	wait_frames(9)
	monster.play_sound(6)
	do
		local out1, out2, out3 = monster.get_target_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_effect_second_vector(roses[5], position_x, position_y + 3.0, position_z)
	monster.set_effect_value(roses[5], 0, attack)
	monster.set_effect_value_float(roses[5], 1, rose_speed)
	monster.set_effect_value(roses[5], 2, 90)
	monster.set_effect_value(roses[5], 7, 1)
	wait_frames(9)
	monster.play_sound(6)
	do
		local out1, out2, out3 = monster.get_target_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_effect_second_vector(roses[6], position_x, position_y + 3.0, position_z)
	monster.set_effect_value(roses[6], 0, attack)
	monster.set_effect_value_float(roses[6], 1, rose_speed)
	monster.set_effect_value(roses[6], 2, 90)
	monster.set_effect_value(roses[6], 7, 1)
	reset_rose_slots()
	wait_for_motion_end()
	monster.set_motion("立ち", -1, 0)
	wait_frames(30)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	finish_rose_effects()
end

--- Turns to the given angle at the given speed and waits until it is facing it.
local function turn_to_angle(next_rot: f32, rot_speed: f32)
	next_rot = calc.degrees_to_radians(next_rot)
	if next_rot > vm.f32(3.1415927) then
		next_rot = vm.f32(next_rot - vm.f32(6.2831855))
	end
	if next_rot <= vm.f32(-3.1415927) then
		next_rot = vm.f32(next_rot + vm.f32(6.2831855))
	end
	rot_speed = calc.degrees_to_radians(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(next_rot, rot_speed)
	local _ = wait_until_facing(
		calc.radians_to_degrees(next_rot),
		calc.radians_to_degrees(rot_speed),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(rot_speed)))
	)
	movement.stop_turning()
end

--- Returns the acceleration that covers the distance in the given duration from the starting speed.
local function compute_acceleration(distance: f32, start_speed: f32, duration: f32, acceleration: f32)
	if duration ~= 0.0 then
		acceleration = vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(distance - vm.f32(start_speed * duration)) * 2.0), duration)), duration))
	else
		acceleration = 0.0
	end
	return acceleration
end

--- Returns 1 when the point is reachable and within the allowed height band.
local function can_fly_to(x: f32, y: f32, z: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local distance: f32 = 0
	local angle: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	distance = monster.get_distance_between(pos_x, pos_y, pos_z, x, y, z) or distance
	angle = monster.get_angle_to_position(x, y, z) or angle
	if sense.check_flight_destination(x, y, z, distance, angle) ~= 0 then
		return 0
	end
	if y < 0.0 or y > 50.0 then
		return 0
	end
	return 1
end

--- Glides toward a target point with a computed acceleration, teleporting when it crosses the arena edge, until it arrives, is blocked or runs out of frames.
local function glide_to_position(target_x: f32, target_y: f32, target_z: f32, start_speed: f32, end_speed: any, distance_margin: f32, unused_ratio: any, max_frames: any)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local scale: f32 = 0
	local next_x: f32 = 0
	local next_y: f32 = 0
	local next_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local distance: f32 = 0
	local acceleration: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, pos_x, pos_y, pos_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	scale = start_speed
	frame = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	distance = monster.get_distance_between(target_x, target_y, target_z, pos_x, pos_y, pos_z) or distance
	acceleration = compute_acceleration(distance, scale, vm.f32(vm.fdiv(vm.f32(vm.f32(distance + distance_margin) * vm.f32(1.9)), scale)), acceleration)
	while frame < max_frames do
		scale = vm.f32(scale + acceleration)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			next_x = out1 or next_x
			next_y = out2 or next_y
			next_z = out3 or next_z
		end
		if pos_z < 92.0 then
			teleport_to_random_point()
		end
		do
			local out1, out2, out3 = monster.copy_vector(direction_x, direction_y, direction_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, scale)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(next_x, next_y, next_z, step_x, step_y, step_z)
			next_x = out1 or next_x
			next_y = out2 or next_y
			next_z = out3 or next_z
		end
		if scale < 0.0 then
			return
		end
		if can_fly_to(next_x, next_y, next_z) == 0 then
			return
		end
		monster.set_position(next_x, next_y, next_z)
		monster.copy_vector(next_x, next_y, next_z)
		wait_frame_with_updates()
		frame = vm.i32(frame + 1)
	end
end

--- Runs to one of several random arena points on the ground.
local function run_to_random_point()
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local target_angle: f32 = 0
	local point_index: s32 = 0
	point_index = monster.get_random(7) or point_index
	if point_index == 0 then
		target = -159.75
		target_2 = 35.0
		target_3 = vm.f32(336.53)
	end
	if point_index == 1 then
		target = vm.f32(27.98)
		target_2 = 35.0
		target_3 = vm.f32(390.28)
	end
	if point_index == 2 then
		target = vm.f32(202.6)
		target_2 = 35.0
		target_3 = vm.f32(335.46)
	end
	if point_index == 3 then
		target = vm.f32(19.08)
		target_2 = 35.0
		target_3 = vm.f32(170.05)
	end
	if point_index >= 4 then
		target = vm.f32(0.26)
		target_2 = 35.0
		target_3 = 120.0
	end
	target_angle = monster.get_angle_to_position(target, target_2, target_3) or target_angle
	monster.set_motion("歩き", -1.0, 0)
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	turn_to_angle(calc.radians_to_degrees(target_angle), 5.0)
	monster.set_motion("走り", -1.0, 0)
	glide_to_position(target, target_2, target_3, vm.f32(9.8), vm.f32(9.8), 0.0, vm.f32(0.8), 180)
	movement.stop_at_current_position()
end

--- Fires the rose barrage when high enough, otherwise runs to a random point.
local function attack_rose_or_reposition()
	local charge_frames: s32 = 0
	local pos_y: f32 = 0
	monster.set_motion("歩き", -1.0, 0)
	turn_to_face_target(5.0)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	if pos_y > 45.0 then
		monster.play_sound(4)
		monster.set_motion("攻撃１in", -1, 2)
		wait_for_motion_progress(vm.f32(0.328), -1.0)
		charge_frames = monster.get_random(90) or charge_frames
		charge_frames = vm.i32(charge_frames + 90)
		attack_rose_barrage(charge_frames)
	else
		run_to_random_point()
		return
	end
	monster.set_motion("立ち", -1, 0)
end

--- Counts the attack, teleports and then performs the rose attack.
local function teleport_and_attack_rose()
	local attack_count: s32 = 0
	attack_count = monster.get_variable(11) or attack_count
	monster.set_variable(11, vm.i32(attack_count + 1))
	request_half_life_event()
	teleport_to_random_point()
	attack_rose_or_reposition()
end

--- Runs to a point offset around the target by the given angle and distance.
local function strafe_around_target(speed: f32, turn_speed_degrees: f32, angle_offset: f32, distance: f32, height_offset: f32, unused_height: any, unused_frame_limit: any)
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local pos_y: f32 = 0
	local height: f32 = 0
	target, target_2, target_3 = movement.get_approach_point(angle_offset, distance, target, target_2, target_3)
	monster.get_target_position()
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	angle_offset = monster.get_angle_to_position(target, target_2, target_3) or angle_offset
	if angle_offset > vm.f32(3.1415927) then
		angle_offset = vm.f32(angle_offset - vm.f32(6.2831855))
	end
	if angle_offset <= vm.f32(-3.1415927) then
		angle_offset = vm.f32(angle_offset + vm.f32(6.2831855))
	end
	turn_to_angle(calc.radians_to_degrees(angle_offset), turn_speed_degrees)
	movement.stop_turning()
	monster.set_motion("走り", -1.0, 0)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	height = monster.get_height_above_ground() or height
	height = vm.f32(pos_y - height)
	height_offset = vm.f32(height_offset + height)
	glide_to_position(target, height_offset, target_3, speed, speed, 0.0, vm.f32(0.8), 180)
	monster.stop_moving()
end

--- Counts the attack, runs to a random point and sometimes strafes around the target before the rose attack.
local function run_and_strafe()
	local target_distance: f32 = 0
	local roll: s32 = 0
	local attack_count: s32 = 0
	local angle_offset: f32 = 0
	attack_count = monster.get_variable(11) or attack_count
	monster.set_variable(11, vm.i32(attack_count + 1))
	request_half_life_event()
	run_to_random_point()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		angle_offset = monster.get_random_whole_number(60.0) or angle_offset
		if roll < 50 then
			angle_offset = vm.f32(-angle_offset - 30.0)
		else
			angle_offset = vm.f32(angle_offset + 30.0)
		end
		target_distance = monster.get_target_distance() or target_distance
		monster.set_motion("歩き", -1, 0)
		strafe_around_target(10.0, 5.0, angle_offset, target_distance, 80.0, 35.0, 30)
		turn_to_face_target(5.0)
		monster.set_motion("立ち", -1, 0)
		wait_frames(3)
	end
	attack_rose_or_reposition()
end

--- Faces the target and glides to its position.
local function glide_to_target(speed: f32, unused_turn_speed: any, distance_margin: f32, unused_ratio: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	turn_to_face_target(5.0)
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	glide_to_position(target_x, target_y, target_z, speed, speed, distance_margin, unused_ratio, max_frames)
end

--- Runs at the target and spawns a tornado with the second attack motion.
local function attack_tornado()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1.0, 0)
	turn_to_face_target(5.0)
	monster.set_motion("走り", 0.75, 0)
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	glide_to_position(target_x, target_y, target_z, 10.0, 10.0, 35.0, vm.f32(0.08), 180)
	monster.play_sound(7)
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	track_target_for_frames(5.0, 26)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("サンの竜巻")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_value(-1, 0, attack)
	wait_for_motion_end()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Counts the attack and occasionally chases the target and spawns a tornado.
local function chase_and_tornado()
	local roll: s32 = 0
	local attack_count: s32 = 0
	attack_count = monster.get_variable(11) or attack_count
	monster.set_variable(11, vm.i32(attack_count + 1))
	request_half_life_event()
	roll = monster.get_random(100) or roll
	if roll < 18 then
		monster.set_motion("歩き", -1.0, 0)
		turn_to_face_target(5.0)
		monster.set_motion("走り", -1.0, 0)
		glide_to_target(30.0, 5.0, 35.0, vm.f32(0.8), 180)
		attack_tornado()
	end
end

--- Resets the attack counter and switches between the air and ground phases.
local function switch_phase(next_phase: s32)
	monster.set_variable(11, 0)
	wait_frame_with_updates()
	if next_phase == 1 then
		monster.set_variable(9, 1)
	end
	if next_phase == 0 then
		monster.set_variable(9, 0)
		run_to_random_point()
	end
end

--- Runs the next attack of the air phase according to the attack counter.
local function run_air_phase_step()
	local attack_count: s32 = 0
	run_and_strafe()
	attack_count = monster.get_variable(11) or attack_count
	if attack_count == 0 then
		teleport_and_attack_rose()
	end
	if attack_count == 1 then
		chase_and_tornado()
	end
	if attack_count == 2 then
		run_and_strafe()
	end
	if attack_count >= 3 then
		switch_phase(1)
	end
end

--- Counts the attack down, chases the target and spawns one or two tornados.
local function chase_and_double_tornado()
	local attack_count: s32 = 0
	local roll: s32 = 0
	attack_count = monster.get_variable(11) or attack_count
	monster.set_variable(11, vm.i32(attack_count - 1))
	request_half_life_event()
	monster.set_motion("歩き", -1.0, 0)
	turn_to_face_target(5.0)
	monster.set_motion("走り", -1.0, 0)
	glide_to_target(30.0, 5.0, 35.0, vm.f32(0.8), 180)
	attack_tornado()
	roll = monster.get_random(100) or roll
	if roll < 60 then
		attack_tornado()
	end
end

--- Skims along the ground toward the target until it is close, blocked or out of frames.
local function skim_toward_target(speed: f32, unused_turn_speed: any, distance_margin: f32, hover_height: f32, follow_pitch: s32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local distance: f32 = 0
	local ground_height: f32 = 0
	local height_above_ground: f32 = 0
	local blocked: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	for frame = 0, max_frames - 1 do
		do
			local out1, out2, out3 = monster.get_target_position()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		ground_height = sense.get_ground_height(ground_height)
		target_y = vm.f32(ground_height + hover_height)
		do
			local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, speed)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, direction_x, direction_y, direction_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = monster.get_rotation_toward_6(position_x, position_y, position_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		height_above_ground = monster.get_height_above_ground_at(position_x, position_y, position_z) or height_above_ground
		if height_above_ground >= 35.0 or height_above_ground <= 0.0 then
			position_y = vm.f32(position_y - direction_y)
			direction_y = 0.0
		end
		distance = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance
		if distance < vm.f32(speed + distance_margin) then
			return
		end
		blocked = sense.check_flight_destination(position_x, position_y, position_z, speed, rotation_y)
		if blocked ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(position_x, position_y, position_z)
		if follow_pitch ~= 0 then
			monster.set_rotation(rotation_x, rotation_y, rotation_z)
		else
			monster.set_rotation(0.0, rotation_y, 0.0)
		end
		wait_frame_with_updates()
	end
end

--- Counts the attack down and either strafes around the target or skims toward it and spawns tornados.
local function strafe_or_skim_attack()
	local target_distance: f32 = 0
	local attack_count: s32 = 0
	local roll: s32 = 0
	local angle_offset: f32 = 0
	attack_count = monster.get_variable(11) or attack_count
	monster.set_variable(11, vm.i32(attack_count - 1))
	request_half_life_event()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		angle_offset = monster.get_random_whole_number(60.0) or angle_offset
		if roll < 50 then
			angle_offset = vm.f32(-angle_offset - 30.0)
		else
			angle_offset = vm.f32(angle_offset + 30.0)
		end
		target_distance = monster.get_target_distance() or target_distance
		monster.set_motion("歩き", -1, 0)
		strafe_around_target(10.5, 5.0, angle_offset, target_distance, 5.0, 35.0, 30)
		turn_to_face_target(5.0)
		monster.set_motion("立ち", -1, 0)
		wait_frames(3)
	else
		monster.set_motion("歩き", -1.0, 0)
		turn_to_face_target(5.0)
		monster.set_motion("走り", -1.0, 0)
		skim_toward_target(10.0, 5.0, 35.0, 5.0, 0, 90)
		attack_tornado()
		roll = monster.get_random(100) or roll
		if roll < 60 then
			attack_tornado()
		end
	end
end

--- Runs the next attack of the ground phase according to the attack counter.
local function run_ground_phase_step()
	local attack_count: s32 = 0
	local roll: s32 = 0
	attack_count = monster.get_variable(11) or attack_count
	if attack_count == 0 then
		chase_and_double_tornado()
		monster.set_motion("歩き", -1.0, 0)
		turn_to_face_target(5.0)
		monster.set_motion("走り", -1.0, 0)
		glide_to_target(30.0, 5.0, 35.0, vm.f32(0.8), 180)
		attack_tornado()
		roll = monster.get_random(100) or roll
		if roll < 80 then
			attack_tornado()
		end
	end
	if attack_count == -1 then
		strafe_or_skim_attack()
	end
	if attack_count == -2 then
		chase_and_double_tornado()
	end
	if attack_count <= -3 then
		switch_phase(0)
	end
end

--- Runs one step of the current phase's attack pattern.
local function run_phase_step()
	local phase: s32 = 0
	request_half_life_event()
	phase = monster.get_variable(9) or phase
	if phase == 0 then
		run_air_phase_step()
	end
	if phase == 1 then
		run_ground_phase_step()
	end
end

--- Restores the defense rate and clears the attack-immune attribute.
local function reset_defense()
	monster.set_defense_rate(1.0)
	monster.set_monster_attributes(32, 0)
end

--- Stops all movement and motion and faces the target to start a forced reaction.
local function begin_forced_reaction()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	wait_frame_with_updates()
	monster.set_action_status(1)
end

--- Slides along the ground toward a point until it is close, blocked or out of frames.
local function slide_to_position(target_x: f32, target_y: f32, target_z: f32, speed: f32, distance_margin: f32, hover_offset: f32, max_frames: any)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local heading: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local ground_height: f32 = 0
	local distance: f32 = 0
	local height_above_ground: f32 = 0
	local frame: s32 = 0
	local blocked: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	ground_height = sense.get_ground_height(ground_height)
	target_y = vm.f32(ground_height + hover_offset)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, speed)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	monster.copy_vector(target_x, target_y, target_z)
	heading = monster.get_angle_to_position(position_x + direction_x, position_y + direction_y, position_z + direction_z) or heading
	frame = 0
	while frame < max_frames do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, direction_x, direction_y, direction_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		height_above_ground = monster.get_height_above_ground_at(position_x, position_y, position_z) or height_above_ground
		if height_above_ground >= 35.0 or height_above_ground <= 0.0 then
			position_y = vm.f32(position_y - direction_y)
			direction_y = 0.0
		end
		distance = monster.get_distance_between(position_x, position_y, position_z, target_x, target_y, target_z) or distance
		if distance < vm.f32(speed + distance_margin) then
			return
		end
		blocked = sense.check_flight_destination(position_x, position_y, position_z, speed, heading)
		if blocked ~= 0 then
			return
		end
		monster.set_position(position_x, position_y, position_z)
		monster.copy_vector(position_x, position_y, position_z)
		wait_frame_with_updates()
		frame = vm.i32(frame + 1)
	end
end

--- Steps sideways to the left or right and slides a short distance.
local function sidestep_randomly()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local sidestep_distance: f32 = 0
	local sidestep_angle: f32 = 0
	local roll: s32 = 0
	monster.set_motion("歩き", -1, 0)
	turn_to_face_target(10.0)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ左", -1, 6)
		sidestep_angle = vm.f32(yaw + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 6)
		sidestep_angle = vm.f32(yaw - vm.f32(1.5707964))
	end
	sidestep_distance = 100.0
	if sidestep_angle > vm.f32(3.1415927) then
		sidestep_angle = vm.f32(sidestep_angle - vm.f32(6.2831855))
	end
	if sidestep_angle <= vm.f32(-3.1415927) then
		sidestep_angle = vm.f32(sidestep_angle + vm.f32(6.2831855))
	end
	destination_x = vm.f32(pos_x + vm.f32(vm.sin(sidestep_angle) * sidestep_distance))
	destination_y = pos_y
	destination_z = vm.f32(pos_z + vm.f32(vm.cos(sidestep_angle) * sidestep_distance))
	wait_frames(3)
	monster.set_monster_attributes(32, 1)
	slide_to_position(destination_x, destination_y, destination_z, vm.f32(9.8), vm.f32(9.8), pos_y, 6)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	wait_for_motion_end()
	monster.set_motion("立ち", -1, 0)
end

--- Dodges by sidestepping and then resumes attacking.
local function on_dodge_2()
	local entered: s32 = 0
	local height: f32 = 0
	local target_angle: f32 = 0
	local roll: s32 = 0
	entered = monster.get_variable(15) or entered
	if entered == 0 then
		finish_rose_effects()
		return
	end
	reset_defense()
	reset_defense()
	state.lock_and_reset_motion()
	request_half_life_event()
	height = monster.get_height_above_ground() or height
	if true then
		target_angle = monster.get_target_angle() or target_angle
		if target_angle > vm.f32(3.1415927) then
			target_angle = vm.f32(target_angle - vm.f32(6.2831855))
		end
		if target_angle <= vm.f32(-3.1415927) then
			target_angle = vm.f32(target_angle + vm.f32(6.2831855))
		end
		monster.set_rotation(0.0, target_angle, 0.0)
		wait_frame_with_updates()
		sidestep_randomly()
		monster.set_motion("立ち", -1, 0)
		roll = monster.get_random(100) or roll
		if roll < 85 then
			height = monster.get_height_above_ground() or height
			run_and_strafe()
			if height > 45.0 then
				attack_rose_or_reposition()
			else
				monster.set_motion("歩き", -1.0, 0)
				turn_to_face_target(5.0)
				monster.set_motion("走り", -1.0, 0)
				glide_to_target(30.0, 5.0, 35.0, vm.f32(0.8), 180)
				attack_tornado()
			end
		end
	else
		monster.set_motion("歩き", -1.0, 0)
		turn_to_face_target(5.0)
		monster.set_motion("走り", -1.0, 0)
		glide_to_target(30.0, 5.0, 35.0, vm.f32(0.8), 180)
		attack_tornado()
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Starts the warp effect and fades the boss out.
local function begin_teleport_out()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local chara_type: s32 = 0
	local alpha: f32 = 0
	monster.set_variable(13, 1)
	monster.set_monster_attributes(32, 1)
	chara_type = monster.get_character_number() or chara_type
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("サンワープ")
	monster.set_effect_first_vector(-1, pos_x, pos_y + 8.0, pos_z)
	monster.set_effect_owner(-1, chara_type)
	monster.set_motion("テレポート飛び", -1, 2)
	wait_for_motion_end()
	monster.set_motion("テレポート中", -1, 4)
	monster.set_model_lighting(0)
	alpha = 128.0
	for frame = 0, 14 do
		monster.set_model_color(128.0, 128.0, 128.0, alpha)
		alpha = vm.f32(alpha - vm.f32(8.533334))
		wait_frame_with_updates()
	end
	monster.set_model_lighting(1)
end

--- Lands from the warp facing the target and fades the boss back in.
local function finish_teleport_in()
	local target_angle: f32 = 0
	local alpha: f32 = 0
	monster.get_position_3()
	monster.set_motion("テレポート着地", -1, 6)
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	wait_frame_with_updates()
	monster.set_model_lighting(0)
	alpha = 0.0
	for frame = 0, 27 do
		monster.set_model_color(128.0, 128.0, 128.0, alpha)
		alpha = vm.f32(alpha + vm.f32(4.571429))
		wait_frame_with_updates()
	end
	monster.set_model_color(128.0, 128.0, 128.0, 128.0)
	monster.set_model_lighting(1)
	monster.set_monster_attributes(32, 0)
	monster.set_variable(13, 0)
end

--- Steps backward away from the target.
local function step_backward()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local back_angle: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		yaw = out2 or yaw
	end
	back_angle = vm.f32(yaw + vm.f32(3.1415927))
	if back_angle > vm.f32(3.1415927) then
		back_angle = vm.f32(back_angle - vm.f32(6.2831855))
	end
	if back_angle <= vm.f32(-3.1415927) then
		back_angle = vm.f32(back_angle + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(back_angle)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(back_angle)))
	monster.set_motion("ステップ後", -1, 6)
	wait_frames(2)
	monster.set_monster_attributes(32, 1)
	slide_to_position(pos_x, pos_y, pos_z, 10.5, 10.5, pos_y, 24)
	monster.stop_moving()
	monster.set_monster_attributes(32, 0)
	wait_for_motion_end()
	monster.set_motion("立ち", -1, 0)
end

--- Clears the held attribute and ends the throw, then resets the motion.
local function recover_from_throw()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	wait_frames(10)
	monster.reset_motion()
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers its damage hit and effects and resets its state variables.
function script.init()
	monster.register_damage_hit("通常攻撃", 6.0, "攻撃１", 0.28, 0.4, 0)
	monster.load_effect_script("バラ")
	monster.load_effect_script("バラヒット")
	monster.load_effect_script("サンの竜巻")
	monster.load_effect_script("ギルトーニシールド")
	monster.load_effect_script("サンワープ")
	monster.set_clip_distance(9999.9)
	movement.stop_at_current_position()
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.set_variable(8, 0)
	monster.set_variable(9, 0)
	monster.set_variable(10, 0)
	monster.set_variable(11, 0)
	monster.set_camera_mode(4)
	monster.set_variable(15, 0)
	monster.set_variable(13, 0)
	reset_rose_slots()
	monster.set_photo_opportunity(1026)
	configure_clip_distance()
	state.initialize_flying()
end

--- Teleports in, flies to the opening point and then cycles through its attack phases.
function script.loop()
	local entered: s32 = 0
	local teleporting: s32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local target_angle: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	teleporting = monster.get_variable(13) or teleporting
	if teleporting ~= 0 then
		monster.set_model_lighting(0)
		monster.set_model_color(128.0, 128.0, 128.0, 128.0)
		monster.set_model_lighting(1)
	end
	monster.set_invulnerable_time(0)
	entered = monster.get_variable(15) or entered
	if entered == 0 then
		teleport_and_attack_rose()
		target = vm.f32(-0.3)
		target_2 = vm.f32(78.62)
		target_3 = vm.f32(327.79)
		monster.set_mask_flags(1, 1)
		monster.set_mask_flags(2, 1)
		target_angle = monster.get_angle_to_position(target, target_2, target_3) or target_angle
		monster.set_motion("歩き", -1.0, 0)
		if target_angle > vm.f32(3.1415927) then
			target_angle = vm.f32(target_angle - vm.f32(6.2831855))
		end
		if target_angle <= vm.f32(-3.1415927) then
			target_angle = vm.f32(target_angle + vm.f32(6.2831855))
		end
		turn_to_angle(calc.radians_to_degrees(target_angle), 5.0)
		monster.set_motion("走り", -1.0, 0)
		glide_to_position(target, target_2, target_3, vm.f32(11.2), vm.f32(9.8), 0.0, vm.f32(0.8), 180)
		movement.stop_at_current_position()
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
		monster.set_variable(15, 1)
	end
	while true do
		wait_frame_with_updates()
		run_phase_step()
	end
end

--- Plays the damage motion with knockback once the boss has entered.
function script.on_damage()
	local entered: s32 = 0
	entered = monster.get_variable(15) or entered
	if entered == 0 then
		finish_rose_effects()
	else
		request_half_life_event()
		reset_defense()
		state.stop_and_clear_action()
		finish_rose_effects()
		request_half_life_event()
		monster.reset_motion()
		monster.set_motion("ダメージ", -1, 6)
		monster.start_knockback(4.0, 0.0, 3)
		wait_for_motion_end()
		wait_frames(12)
		monster.set_motion("立ち", -1, 0)
		state.do_nothing()
		monster.set_mask_flags(1, 0)
		monster.set_mask_flags(2, 0)
	end
end

--- Blows the boss away or counterattacks, depending on a roll and the target's distance.
function script.on_knockdown()
	local entered: s32 = 0
	local argc: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local height: f32 = 0
	local target_distance: f32 = 0
	entered = monster.get_variable(15) or entered
	if entered == 0 then
		finish_rose_effects()
		return
	else
		request_half_life_event()
		reset_defense()
		begin_forced_reaction()
		movement.stop_at_current_position()
		finish_rose_effects()
		argc = monster.get_random(100) or argc
		if argc < 50 then
			height = monster.get_height_above_ground() or height
			do
				local out1, out2, out3 = monster.get_position_3()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			height = vm.f32(pos_y - height)
			monster.set_position(pos_x, height + 5.0, pos_z)
			monster.set_motion("吹っ飛び", -1, 6)
			monster.start_knockback(3.0, 0.05, 20)
			wait_for_motion_end()
			monster.set_action_status(1)
			wait_frames(3)
			monster.set_action_status(0)
			monster.set_motion("起き上がり", -1, 6)
			wait_for_motion_end()
			monster.set_motion("立ち", -1, 0)
		else
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 60.0 then
				monster.set_motion("歩き", -1.0, 0)
				turn_to_face_target(5.0)
				monster.set_motion("走り", -1.0, 0)
				glide_to_target(30.0, 5.0, 35.0, vm.f32(0.8), 180)
			end
			attack_tornado()
		end
		state.unlock_and_clear_action()
	end
end

--- Dodges or raises a shield effect for a moment.
function script.on_guard()
	local entered: s32 = 0
	local argc: s32 = 0
	local target_angle: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	entered = monster.get_variable(15) or entered
	if entered == 0 then
		finish_rose_effects()
		return
	else
		argc = monster.get_random(100) or argc
		if argc < 30 then
			on_dodge_2()
		else
			request_half_life_event()
			reset_defense()
			state.lock_and_stop_moving()
			movement.stop_at_current_position()
			finish_rose_effects()
			monster.reset_motion()
			target_angle = monster.get_target_angle() or target_angle
			monster.set_rotation(0.0, target_angle, 0.0)
			monster.set_motion("ガードL", -1, 4)
			monster.start_knockback(3.0, 0.0, 2)
			wait_frame_with_updates()
			monster.set_invulnerable_time(30)
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
			wait_frames(60)
			monster.set_invulnerable_time(0)
			monster.set_motion("ガード戻り", -1, 6)
			wait_for_motion_end()
			monster.set_motion("立ち")
			state.unlock()
			monster.set_mask_flags(1, 0)
			monster.set_mask_flags(2, 0)
		end
	end
end

--- Teleports or steps away from the attack and then resumes attacking.
function script.on_dodge_1()
	local entered: s32 = 0
	local height: f32 = 0
	local target_angle: f32 = 0
	local center_x: f32 = 0
	local center_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local center_distance: f32 = 0
	local target_x: f32 = 0
	local target_z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	entered = monster.get_variable(15) or entered
	if entered == 0 then
		finish_rose_effects()
		return
	end
	request_half_life_event()
	reset_defense()
	reset_defense()
	state.lock_and_reset_motion()
	finish_rose_effects()
	do
		local out1, _, out3 = monster.copy_vector(0.0, 0.0, 333.0)
		center_x = out1 or center_x
		center_z = out3 or center_z
	end
	do
		local out1, _, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	center_distance = monster.get_distance_between(center_x, 0.0, center_z, target_x, 0.0, target_z) or center_distance
	if center_distance < 300.0 then
		begin_teleport_out()
		x, y, z = movement.get_approach_point(180.0, 35.0, x, y, z)
		monster.set_position(x, y, z)
		wait_frame_with_updates()
		finish_teleport_in()
		monster.set_motion("歩き", -1.0, 0)
		turn_to_face_target(5.0)
		monster.set_motion("走り", -1.0, 0)
		glide_to_target(30.0, 5.0, 35.0, vm.f32(0.8), 180)
		attack_tornado()
	else
		height = monster.get_height_above_ground() or height
		if height < 40.0 then
			target_angle = monster.get_target_angle() or target_angle
			if target_angle > vm.f32(3.1415927) then
				target_angle = vm.f32(target_angle - vm.f32(6.2831855))
			end
			if target_angle <= vm.f32(-3.1415927) then
				target_angle = vm.f32(target_angle + vm.f32(6.2831855))
			end
			monster.set_rotation(0.0, target_angle, 0.0)
			wait_frame_with_updates()
			step_backward()
			monster.set_motion("立ち", -1, 0)
		else
			begin_teleport_out()
			x_2, y_2, z_2 = movement.get_approach_point(180.0, 35.0, x_2, y_2, z_2)
			monster.set_position(x_2, y_2, z_2)
			wait_frame_with_updates()
			finish_teleport_in()
			monster.set_motion("歩き", -1.0, 0)
			turn_to_face_target(5.0)
			monster.set_motion("走り", -1.0, 0)
			glide_to_target(30.0, 5.0, 35.0, vm.f32(0.8), 180)
			attack_tornado()
		end
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

script.on_dodge_2 = on_dodge_2

--- Stops the boss sounds, plays the death motions and requests the defeat event.
function script.on_death()
	monster.set_monster_attributes(2, 1)
	monster.stop_sound(4)
	monster.stop_sound(5)
	monster.stop_sound(7)
	monster.stop_sound(15)
	monster.stop_sound(39)
	reset_defense()
	death.begin()
	movement.stop_at_current_position()
	finish_rose_effects()
	monster.set_motion("死に", -1, 6)
	wait_for_motion_end()
	monster.set_motion("死にL", -1, 4)
	monster.request_event_script(504)
	death.play_effects()
end

--- Clears the rose effects and idles while the boss is held.
function script.on_caught()
	finish_rose_effects()
	while true do
		wait_frame_with_updates()
	end
end

--- Recovers the boss after a throw.
function script.on_land()
	recover_from_throw()
	finish_rose_effects()
	reset_defense()
	state.do_nothing_hook()
	return 1
end

--- Clears the rose effects and waits out the stun.
function script.on_stun()
	state.clear_attribute_and_lock()
	finish_rose_effects()
	reset_defense()
	reaction.stun_until_recovered()
end

return script
