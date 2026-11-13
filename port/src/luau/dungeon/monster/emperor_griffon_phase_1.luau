--!strict
--- Controls the first phase of the Emperor Griffon boss fight, where it flies around shooting feathers and absorbing energy.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local state = require("@lib/monster/state")

local flicker_counter: s32 = 0

--- Sets a short clip distance for ordinary monsters and an effectively unlimited one for bosses.
local function apply_boss_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Ends the effects and starts the transition cutscene once the griffon is alone or wounded enough.
local function check_phase_transition()
	local life: f32 = 0
	local first_effect: s32 = 0
	local second_effect: s32 = 0
	local third_effect: s32 = 0
	local has_transitioned: s32 = 0
	local monster_count: s32 = 0
	life = 1.0
	monster.get_variable(27)
	monster.get_variable(28)
	monster.get_variable(29)
	first_effect = monster.get_variable(24) or first_effect
	second_effect = monster.get_variable(25) or second_effect
	third_effect = monster.get_variable(26) or third_effect
	has_transitioned = monster.get_variable(7) or has_transitioned
	life = monster.get_life() or life
	monster_count = monster.get_monster_count() or monster_count
	if (monster_count <= 1 or life < vm.f32(0.67)) and has_transitioned == 0 then
		monster.set_variable(7, 1)
		monster.finish_effect(first_effect)
		monster.finish_effect(second_effect)
		monster.finish_effect(third_effect)
		monster.set_monster_attributes(32, 1)
		monster.stop_sound(8)
		monster.request_event_script(500)
	end
end

--- Checks whether the griffon should change phase.
local function update_phase()
	check_phase_transition()
end

--- Checks for a phase change and waits one frame.
local function wait_frame()
	update_phase()
	vm.wait()
end

--- Waits until the griffon faces the given angle, within a tolerance or a frame limit, and returns the frames waited.
local function wait_until_facing_angle(target_angle: f32, turn_speed: f32, max_frames: f32)
	local current_angle: f32 = 0
	local elapsed_frames: f32 = 0
	local frame_limit: f32 = 0
	local tolerance: f32 = 0
	target_angle = calc.degrees_to_radians(target_angle)
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	turn_speed = calc.degrees_to_radians(turn_speed)
	frame_limit = max_frames
	if turn_speed < 3.0 then
		tolerance = calc.degrees_to_radians(3.0)
	else
		tolerance = turn_speed
	end
	elapsed_frames = 0.0
	while elapsed_frames < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_angle = out2 or current_angle
		end
		if current_angle > vm.f32(target_angle - tolerance) and current_angle < vm.f32(target_angle + tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle, current_angle, turn_speed) == 0 then
			movement.stop_turning()
			break
		elseif elapsed_frames >= max_frames then
			movement.stop_turning()
			break
		else
			wait_frame()
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
	end
	movement.stop_turning()
	return elapsed_frames
end

--- Turns the griffon toward an angle and waits until it faces it.
local function turn_to_angle_and_wait(next_rot: f32, rot_speed: f32)
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
	local _ = wait_until_facing_angle(
		calc.radians_to_degrees(next_rot),
		calc.radians_to_degrees(rot_speed),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(rot_speed)))
	)
	movement.stop_turning()
end

--- Flies the griffon to a point with a speed that accelerates over the distance, stopping near the point or at the arena edge.
local function fly_toward_position(target_x: f32, target_y: f32, target_z: f32, start_speed: f32, stop_distance: f32, distance_margin: f32, acceleration_factor: f32, max_frames: any)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local scale: f32 = 0
	local distance: f32 = 0
	local acceleration: f32 = 0
	local frame_index: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
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
	distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
	acceleration = calc.get_acceleration(distance, start_speed, vm.f32(vm.fdiv(vm.f32(vm.f32(distance + distance_margin) * acceleration_factor), start_speed)), acceleration)
	scale = start_speed
	frame_index = 0
	while frame_index < max_frames do
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		scale = vm.f32(scale + acceleration)
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
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		if position_y > 70.0 then
			position_y = 70.0
		end
		if scale < 0.0 then
			return
		end
		distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
		if distance < stop_distance then
			return
		end
		distance = monster.get_distance_between(0.0, 0.0, 0.0, position_x, 0.0, position_z) or distance
		if distance > 500.0 then
			return
		end
		monster.set_position(position_x, position_y, position_z)
		monster.copy_vector(position_x, position_y, position_z)
		wait_frame()
		frame_index = vm.i32(frame_index + 1)
	end
end

--- Flies to one of five perch points around the arena rim, facing it first.
local function fly_to_random_perch(speed: f32, turn_speed: any, height_offset: f32, distance_margin: f32, max_frames: s32)
	local current_y: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local ground_height: f32 = 0
	local perch_angle: f32 = 0
	local perch_index: s32 = 0
	perch_index = monster.get_random(5) or perch_index
	if perch_index == 0 then
		target_x = vm.f32(-31.76)
		target_y = 60.0
		target_z = vm.f32(367.74)
	end
	if perch_index == 1 then
		target_x = vm.f32(362.27)
		target_y = 60.0
		target_z = vm.f32(2.72)
	end
	if perch_index == 2 then
		target_x = vm.f32(2.86)
		target_y = 60.0
		target_z = vm.f32(-380.83)
	end
	if perch_index == 3 then
		target_x = vm.f32(-383.43)
		target_y = 60.0
		target_z = vm.f32(-1.28)
	end
	if perch_index == 4 then
		target_x = vm.f32(388.58)
		target_y = 60.0
		target_z = vm.f32(5.07)
	end
	ground_height = monster.get_height_above_ground() or ground_height
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	ground_height = vm.f32(current_y - ground_height)
	perch_angle = monster.get_angle_to_position(target_x, target_y, target_z) or perch_angle
	turn_to_angle_and_wait(calc.radians_to_degrees(perch_angle), vm.f32(4.2))
	fly_toward_position(target_x, vm.f32(ground_height + height_offset), target_z, speed, speed, distance_margin, vm.f32(1.9), max_frames)
end

--- Turns the griffon toward its target and waits until it faces it.
local function face_target(turn_speed: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing_angle(calc.radians_to_degrees(target_angle), turn_speed, 360.0)
	movement.stop_turning()
end

--- Flies to a random point on a circle around the target, then faces the target.
local function fly_around_target(speed: f32, turn_speed: any, height_offset: f32, distance_margin: f32, max_frames: s32)
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local ground_height: f32 = 0
	local current_y: f32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local orbit_angle: f32 = 0
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	do
		local out1, _, out3 = monster.get_target_position()
		player_x = out1 or player_x
		player_z = out3 or player_z
	end
	orbit_angle = vm.bits_float(monster.get_random(360.0)) or orbit_angle
	target_x = vm.f32(player_x + vm.f32(vm.sin(vm.f32(vm.f32(orbit_angle / 180.0) * vm.f32(3.1415927))) * 125.0))
	target_z = vm.f32(player_z + vm.f32(vm.cos(vm.f32(vm.f32(orbit_angle / 180.0) * vm.f32(3.1415927))) * 125.0))
	ground_height = monster.get_height_above_ground() or ground_height
	ground_height = vm.f32(current_y - ground_height)
	target_y = vm.f32(ground_height + height_offset)
	orbit_angle = monster.get_angle_to_position(target_x, target_y, target_z) or orbit_angle
	turn_to_angle_and_wait(calc.radians_to_degrees(orbit_angle), vm.f32(4.2))
	fly_toward_position(target_x, target_y, target_z, speed, speed, distance_margin, vm.f32(1.9), max_frames)
	face_target(vm.f32(4.2))
end

--- Waits until the current motion finishes.
local function wait_until_motion_finished()
	local is_finished: s32 = 0
	while true do
		wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			return
		end
	end
end

--- Waits until the motion reaches a progress point within a tolerance, or finishes.
local function wait_until_motion_progress(progress: f32, tolerance: f32)
	local current_progress: f32 = 0
	local frame_count: s32 = 0
	local is_finished: s32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.03)
	end
	frame_count = 0
	while true do
		wait_frame()
		current_progress = monster.get_motion_progress() or current_progress
		if current_progress < vm.f32(progress + tolerance) and current_progress > vm.f32(progress - tolerance) then
			break
		else
			is_finished = monster.is_motion_finished() or is_finished
			if is_finished ~= 0 then
				break
			else
				frame_count = vm.i32(frame_count + 1)
			end
		end
	end
end

--- Turns toward the target every frame for a number of frames.
local function track_target_for_frames(rot_speed: f32, frame_count: s32)
	local target_angle: f32 = 0
	local _ = calc.degrees_to_radians(rot_speed)
	for i = 0, frame_count - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		wait_frame()
	end
	movement.stop_turning()
end

--- Shoots four rounds of aimed feathers from the wing, pausing between each shot.
local function shoot_slow_feather_volley()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local aim_x: f32 = 0
	local aim_y: f32 = 0
	local aim_z: f32 = 0
	local motion_stage: s32 = 0
	local is_motion_finished: s32 = 0
	local attack: s32 = 0
	local round_index: s32 = 0
	monster.set_variable(30, 1)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１in", -1, 2)
	wait_until_motion_finished()
	monster.set_motion("攻撃１", -1, 6)
	wait_until_motion_progress(vm.f32(0.262), -1.0)
	round_index = 0
	motion_stage = 0
	while round_index < 4 do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(aim_x, aim_y, aim_z, pos_x, pos_y, pos_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(aim_x, aim_y, aim_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, aim_x, aim_y, aim_z)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, aim_x, aim_y, aim_z)
		monster.set_effect_value(-1, 0, attack)
		track_target_for_frames(vm.f32(4.2), calc.pass_through(6))
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(aim_x, aim_y, aim_z, pos_x, pos_y, pos_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(aim_x, aim_y, aim_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(1.5707964)) * 20.0)
		)
		monster.set_effect_second_vector(-1, aim_x, aim_y, aim_z)
		monster.set_effect_value(-1, 0, attack)
		track_target_for_frames(vm.f32(4.2), calc.pass_through(6))
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(aim_x, aim_y, aim_z, pos_x, pos_y, pos_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(aim_x, aim_y, aim_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(-1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(-1.5707964)) * 20.0)
		)
		monster.set_effect_second_vector(-1, aim_x, aim_y, aim_z)
		monster.set_effect_value(-1, 0, attack)
		track_target_for_frames(vm.f32(4.2), calc.pass_through(6))
		is_motion_finished = monster.is_motion_finished() or is_motion_finished
		if is_motion_finished ~= 0 then
			if motion_stage == 1 then
				monster.set_motion("飛び", -1, 0)
				motion_stage = motion_stage + 1
			end
			if motion_stage == 0 then
				monster.set_motion("攻撃１out", -1, 2)
				motion_stage = motion_stage + 1
			end
		end
		round_index = round_index + 1
	end
	if motion_stage == 0 then
		wait_until_motion_finished()
		monster.set_motion("攻撃１out", -1, 2)
		wait_until_motion_finished()
	end
end

--- Waits a number of frames while checking for a phase change.
local function wait_frames_updating_phase(frame_count: any)
	local frame_index: s32 = 0
	frame_index = 0
	while frame_index < frame_count do
		wait_frame()
		frame_index = vm.i32(frame_index + 1)
	end
end

--- Shoots four rounds of aimed feathers from the wing with short pauses between shots.
local function shoot_fast_feather_volley()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local aim_x: f32 = 0
	local aim_y: f32 = 0
	local aim_z: f32 = 0
	local motion_stage: s32 = 0
	local is_motion_finished: s32 = 0
	local attack: s32 = 0
	local round_index: s32 = 0
	monster.set_variable(30, 1)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１in", -1, 2)
	wait_until_motion_finished()
	monster.set_motion("攻撃１", -1, 6)
	wait_until_motion_progress(vm.f32(0.262), -1.0)
	round_index = 0
	motion_stage = 0
	while round_index < 4 do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(aim_x, aim_y, aim_z, pos_x, pos_y, pos_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(aim_x, aim_y, aim_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, aim_x, aim_y, aim_z)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, aim_x, aim_y, aim_z)
		monster.set_effect_value(-1, 0, attack)
		track_target_for_frames(vm.f32(4.2), 1)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(aim_x, aim_y, aim_z, pos_x, pos_y, pos_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(aim_x, aim_y, aim_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(1.5707964)) * 20.0)
		)
		monster.set_effect_second_vector(-1, aim_x, aim_y, aim_z)
		monster.set_effect_value(-1, 0, attack)
		track_target_for_frames(vm.f32(4.2), 1)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(aim_x, aim_y, aim_z, pos_x, pos_y, pos_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(aim_x, aim_y, aim_z)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ１")
		monster.set_effect_first_vector(
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(-1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(-1.5707964)) * 20.0)
		)
		monster.set_effect_second_vector(-1, aim_x, aim_y, aim_z)
		monster.set_effect_value(-1, 0, attack)
		track_target_for_frames(vm.f32(4.2), 6)
		is_motion_finished = monster.is_motion_finished() or is_motion_finished
		if is_motion_finished ~= 0 then
			if motion_stage == 1 then
				monster.set_motion("飛び", -1, 0)
				motion_stage = motion_stage + 1
			end
			if motion_stage == 0 then
				monster.set_motion("攻撃１out", -1, 2)
				motion_stage = motion_stage + 1
			end
		end
		round_index = round_index + 1
	end
	if motion_stage == 0 then
		wait_until_motion_finished()
		monster.set_motion("攻撃１out", -1, 2)
		wait_until_motion_finished()
	end
end

--- Holds the energy-absorbing pose, flashing the model, while all three companions are in their absorbing state.
local function hold_absorb_pose()
	local first_companion_state: s32 = 0
	local second_companion_state: s32 = 0
	local third_companion_state: s32 = 0
	local frame_index: s32 = 0
	frame_index = 0
	while true do
		check_phase_transition()
		first_companion_state = monster.get_variable(27) or first_companion_state
		second_companion_state = monster.get_variable(28) or second_companion_state
		third_companion_state = monster.get_variable(29) or third_companion_state
		if first_companion_state == 32 and second_companion_state == 32 and third_companion_state == 32 then
			monster.set_invulnerable_time(9999)
			monster.set_model_lighting(0)
			if vm.imod(frame_index, 9) == 0 then
				monster.set_model_color(132, 132, 132, 128)
			end
			if vm.imod(frame_index, 9) == 2 then
				monster.set_model_color(128, 128, 128, 128)
			end
			if vm.imod(frame_index, 9) == 5 then
				monster.set_model_color(112, 112, 112, 128)
			end
		else
			break
		end
		wait_frame()
		frame_index = vm.i32(frame_index + 1)
	end
end

--- Plays the energy absorption sequence while invulnerable.
local function absorb_energy()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, pos_y, pos_z)
	monster.stop_moving()
	wait_frame()
	monster.set_variable(30, 4)
	monster.set_motion("エネルギー吸収in", -1, 2)
	wait_until_motion_finished()
	monster.set_motion("エネルギー吸収", -1, 0)
	hold_absorb_pose()
	monster.set_model_lighting(1)
	monster.set_model_color(128, 128, 128, 128)
	monster.set_motion("エネルギー吸収out", 2)
	wait_until_motion_finished()
	monster.set_invulnerable_time(0)
end

--- Cycles the model color to flicker it.
local function flicker_model_color()
	if vm.imod(flicker_counter, 6) == 0 then
		monster.set_model_color(164, 164, 164, 164)
	end
	if vm.imod(flicker_counter, 6) == 2 then
		monster.set_model_color(132, 132, 132, 132)
	end
	if vm.imod(flicker_counter, 6) == 4 then
		monster.set_model_color(112, 112, 112, 128)
	end
	flicker_counter = vm.i32(flicker_counter + 1)
end

--- Turns toward the target every frame for a number of frames while flickering the model.
local function track_target_flickering(rot_speed: f32, frame_count: s32)
	local target_angle: f32 = 0
	local _ = calc.degrees_to_radians(rot_speed)
	for i = 0, frame_count - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		flicker_model_color()
		wait_frame()
	end
	movement.stop_turning()
end

--- Shoots feathers from both wings in several rounds, with the number of rounds growing with the monsters present.
local function shoot_wing_feather_barrage()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local feather_speed: f32 = 0
	local feather_spread: f32 = 0
	local feather_angle: f32 = 0
	local feather_variant: s32 = 0
	local motion_stage: s32 = 0
	local attack: s32 = 0
	local round_index: s32 = 0
	local monster_count: s32 = 0
	monster.set_variable(30, 2)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１in", -1, 2)
	wait_until_motion_finished()
	monster.set_motion("攻撃１", 0.45, 0)
	wait_until_motion_progress(vm.f32(0.262), -1.0)
	round_index = 0
	motion_stage = 0
	monster.set_model_lighting(0)
	monster_count = 0
	monster_count = monster.get_monster_count() or monster_count
	while round_index < vm.i32(vm.i32(vm.i32(monster_count - 1) * 5) + 1) do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_l00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		feather_speed = monster.get_random_whole_number(10.0) or feather_speed
		feather_spread = monster.get_random_whole_number(0.2) or feather_spread
		feather_angle = monster.get_random_whole_number(180.0) or feather_angle
		feather_variant = monster.get_random(2) or feather_variant
		feather_speed = 12.0
		feather_speed = vm.f32(feather_speed + 6.0)
		feather_spread = vm.f32(feather_spread + vm.f32(0.15))
		feather_angle = vm.f32(feather_angle * -1.0)
		feather_angle = vm.f32(feather_angle - 90.0)
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, feather_speed, feather_spread, feather_angle)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value(-1, 1, feather_variant)
		track_target_flickering(vm.f32(4.2), 2)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_l01")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		feather_speed = monster.get_random_whole_number(10.0) or feather_speed
		feather_spread = monster.get_random_whole_number(0.2) or feather_spread
		feather_angle = monster.get_random_whole_number(180.0) or feather_angle
		feather_variant = monster.get_random(2) or feather_variant
		feather_speed = 12.0
		feather_speed = vm.f32(feather_speed + 6.0)
		feather_spread = vm.f32(feather_spread + vm.f32(0.15))
		feather_angle = vm.f32(feather_angle * -1.0)
		feather_angle = vm.f32(feather_angle - 90.0)
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, feather_speed, feather_spread, feather_angle)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value(-1, 1, feather_variant)
		track_target_flickering(vm.f32(4.2), 3)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_r00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		feather_speed = monster.get_random_whole_number(10.0) or feather_speed
		feather_spread = monster.get_random_whole_number(0.2) or feather_spread
		feather_angle = monster.get_random_whole_number(180.0) or feather_angle
		feather_variant = monster.get_random(2) or feather_variant
		feather_speed = 12.0
		feather_speed = vm.f32(feather_speed + 6.0)
		feather_spread = vm.f32(feather_spread + vm.f32(0.15))
		feather_angle = vm.f32(feather_angle - 90.0)
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, feather_speed, feather_spread, feather_angle)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value(-1, 1, feather_variant)
		track_target_flickering(vm.f32(4.2), 2)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_r01")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		feather_speed = monster.get_random_whole_number(10.0) or feather_speed
		feather_spread = monster.get_random_whole_number(0.2) or feather_spread
		feather_angle = monster.get_random_whole_number(180.0) or feather_angle
		feather_variant = monster.get_random(2) or feather_variant
		feather_speed = 12.0
		feather_speed = vm.f32(feather_speed + 6.0)
		feather_spread = vm.f32(feather_spread + vm.f32(0.15))
		feather_angle = vm.f32(feather_angle - 90.0)
		monster.play_sound(6)
		monster.create_effect_1("グリ羽根Ｌ２")
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
		monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
		monster.set_effect_second_vector(-1, feather_speed, feather_spread, feather_angle)
		monster.set_effect_value(-1, 0, attack)
		monster.set_effect_value(-1, 1, feather_variant)
		track_target_flickering(vm.f32(4.2), 3)
		track_target_flickering(vm.f32(4.2), calc.pass_through(9))
		round_index = round_index + 1
	end
	monster.set_model_lighting(1)
	if motion_stage == 0 then
		monster.set_motion("攻撃１out", -1, 2)
		wait_until_motion_finished()
	end
end

local script = {}

--- Runs once when the script loads.
function script.setup() end

--- Sets up the griffon as a boss, spawns its three companions and loads its feather effects.
function script.init()
	local character_number: s32 = 0
	local free_texture_block: s32 = 0
	local feather_l1_loaded: s32 = 0
	local feather_l2_loaded: s32 = 0
	local feather_h_loaded: s32 = 0
	apply_boss_clip_distance()
	monster.set_visible_monster_limit(15)
	monster.set_monster_attributes(512, 1)
	monster.set_clip_distance(999999.9)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_camera_mode(4)
	character_number = monster.get_character_number() or character_number
	monster.set_variable(30, 0)
	monster.set_variable(31, character_number)
	monster.create_monster(618, 0.0, 0.0, 0.0, 0.0)
	monster.create_monster(619, 0.0, 0.0, 0.0, 0.0)
	monster.create_monster(620, 0.0, 0.0, 0.0, 0.0)
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		feather_l1_loaded = monster.load_effect_script("グリ羽根Ｌ１", free_texture_block) or feather_l1_loaded
		feather_l2_loaded = monster.load_effect_script("グリ羽根Ｌ２", free_texture_block) or feather_l2_loaded
		feather_h_loaded = monster.load_effect_script("グリ羽根Ｈ", free_texture_block) or feather_h_loaded
		if (if (if feather_l1_loaded ~= 0 then 1 else feather_l2_loaded) ~= 0 then 1 else feather_h_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(7, 0)
	flicker_counter = 0
end

--- Cycles through flying to a point, feather volleys, energy absorption and a wing feather barrage.
function script.loop()
	local roll: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	while true do
		wait_frame()
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("飛び", -1, 0)
			fly_to_random_perch(4.0, vm.f32(4.2), 60.0, 35.0, 90)
		else
			monster.set_motion("飛び", -1, 0)
			fly_around_target(4.0, vm.f32(4.2), 60.0, 35.0, 90)
		end
		monster.set_motion("飛び", -1, 0)
		face_target(vm.f32(4.2))
		shoot_slow_feather_volley()
		monster.set_variable(30, 8)
		monster.set_motion("飛び", -1, 0)
		wait_frames_updating_phase(60)
		monster.set_motion("飛び", -1, 0)
		face_target(vm.f32(4.2))
		shoot_fast_feather_volley()
		monster.set_variable(30, 8)
		monster.set_motion("飛び", -1, 0)
		wait_frames_updating_phase(60)
		monster.set_motion("飛び", -1, 0)
		face_target(vm.f32(4.2))
		absorb_energy()
		monster.set_variable(30, 8)
		monster.set_motion("飛び", -1, 0)
		face_target(vm.f32(4.2))
		shoot_wing_feather_barrage()
		monster.set_variable(30, 8)
		monster.set_motion("飛び", -1, 0)
		wait_frames_updating_phase(60)
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when hit so the griffon is never staggered.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when hit so the griffon is never knocked down.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the griffon never guards.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the griffon never dodges.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the griffon never dodges.
function script.on_dodge_2() end

--- Finishes the phase check and restores the life so the fight continues into the next phase.
function script.on_death()
	check_phase_transition()
	monster.set_life(0.67)
end

--- Struggles forever while caught.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		wait_frame()
	end
end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing on landing.
function script.on_land() end

--- Falls over, gets up and waits out the stun.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	wait_until_motion_finished()
	monster.set_motion("起き上がり", -1, 6)
	wait_until_motion_finished()
	reaction.stun_until_recovered()
end

return script
