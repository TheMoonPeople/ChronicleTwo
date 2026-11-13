--!strict
--- Dark Element boss that alternates between a blue and a red form, shoots arrows, sweeps a beam and warps between ground and pillar phases.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local movement = require("@lib/monster/movement")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Stores the current model scale, its per-frame change and the allowed scale range.
local function set_scale_settings(scale: f32, scale_step: f32, max_scale: f32, min_scale: f32)
	monster.set_variable_float(11, scale)
	monster.set_variable_float(10, scale_step)
	monster.set_variable_float(12, max_scale)
	monster.set_variable_float(13, min_scale)
end

--- Stores the extra speed added to every movement step.
local function set_speed_bonus(speed_bonus: f32)
	monster.set_variable_float(9, speed_bonus)
end

--- Restarts the dungeon timer.
local function restart_dungeon_timer()
	monster.reset_dungeon_timer()
end

--- Stores the highest and lowest heights the monster may move to.
local function set_height_limits(max_height: f32, min_height: f32)
	monster.set_variable_float(0, max_height)
	monster.set_variable_float(1, min_height)
end

--- Stores the farthest and nearest horizontal distances the monster may move to.
local function set_distance_limits(max_distance: f32, min_distance: f32)
	monster.set_variable_float(2, max_distance)
	monster.set_variable_float(3, min_distance)
end

--- Sets the flight ceiling, clearance, clip distance and flying attributes.
local function configure_flight()
	state.set_max_flight_height(vm.f32(999.9))
	state.set_flight_clearance(39.0)
	monster.set_clip_distance(600.0)
	state.set_flying_attributes(1)
end

--- Uses a short clip distance for ordinary monsters and an unlimited one for bosses.
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

--- Returns the stored form and phase flags.
local function get_form_flags(form_flags: s32)
	local value: s32 = 0
	value = monster.get_variable(6) or value
	form_flags = value
	return form_flags
end

--- Sets or clears a form or phase flag in the stored flags.
local function set_form_flag(flag: s32, enabled: s32)
	local value: s32 = 0
	value = get_form_flags(value)
	if enabled ~= 0 then
		value = vm.i32(bit32.bor(flag, value))
	else
		value = state.clear_flags(value, flag)
	end
	monster.set_variable(6, value)
end

--- Stores the last attack type and the amount of life just lost.
local function record_damage(new_life: s32, previous_life: s32)
	local att_type: s32 = 0
	att_type = monster.get_last_attack_type() or att_type
	monster.set_variable(16, att_type)
	monster.set_variable(17, vm.i32(previous_life - new_life))
end

--- Compares the current life with the stored life and returns 1 when dead, 2 when damaged and 0 otherwise.
local function poll_life_change()
	local life: s32 = 0
	local previous_life: s32 = 0
	previous_life = monster.get_variable(15) or previous_life
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		monster.set_variable(15, life)
		return 1
	end
	if vm.i32(life - previous_life) < 0 then
		monster.set_variable(15, life)
		record_damage(life, previous_life)
		return 2
	end
	monster.set_variable(15, life)
	return 0
end

--- Adds one to the count of recent hits.
local function increment_hit_count()
	local hit_count: s32 = 0
	hit_count = monster.get_variable(18) or hit_count
	monster.set_variable(18, vm.i32(hit_count + 1))
end

--- Stores the count of recent hits.
local function set_hit_count(hit_count: s32)
	monster.set_variable(18, hit_count)
end

--- Returns the count of recent hits.
local function get_hit_count()
	local hit_count: s32 = 0
	hit_count = monster.get_variable(18) or hit_count
	return hit_count
end

--- Tracks rapid hits, forces a pause after too many, and raises the form switch and phase change flags on timers.
local function update_combat_state()
	local damage_result: s32 = 0
	damage_result = poll_life_change()
	if damage_result == 2 then
		if timer.get_elapsed_time(2) < 100 then
			increment_hit_count()
		else
			timer.start(2)
			set_hit_count(0)
		end
	end
	if get_hit_count() > 3 then
		state.do_nothing()
	end
	if timer.get_elapsed_time(0) > 600 then
		monster.set_variable(22, 1)
		timer.start(0)
	end
	if timer.get_elapsed_time(1) > 1500 then
		monster.set_variable(23, 1)
		timer.start(1)
	end
end

--- Updates the combat state and waits one frame.
local function wait_frame()
	update_combat_state()
	vm.wait()
end

--- Shows the light effect and texture of the requested form and hides the other.
local function apply_form(form_flags: s32)
	local blue_effect: s32 = 0
	local red_effect: s32 = 0
	blue_effect = monster.get_variable(4) or blue_effect
	red_effect = monster.get_variable(5) or red_effect
	if bit32.band(form_flags, 1) ~= 0 then
		monster.set_effect_value(blue_effect, 0, 1)
		monster.set_effect_value_float(blue_effect, 1, 1.0)
		monster.set_effect_value(red_effect, 0, 0)
		monster.set_effect_value_float(red_effect, 1, 1.0)
		set_form_flag(1, 1)
		set_form_flag(2, 0)
		monster.apply_reserved_image(0)
	end
	if bit32.band(form_flags, 2) ~= 0 then
		monster.set_effect_value(blue_effect, 0, 0)
		monster.set_effect_value_float(blue_effect, 1, 1.0)
		monster.set_effect_value(red_effect, 0, 1)
		monster.set_effect_value_float(red_effect, 1, 1.0)
		set_form_flag(2, 1)
		set_form_flag(1, 0)
		monster.apply_reserved_image(1)
	end
end

--- Fades the model out, swaps between the blue and red forms with matching damage rates, and fades back in.
local function switch_form()
	local form_flags: s32 = 0
	local red: f32 = 0
	local green: f32 = 0
	local blue: f32 = 0
	local alpha: f32 = 0
	local frame: s32 = 0
	monster.play_sound(12)
	do
		local out1, out2, out3 = monster.copy_vector(128.0, 128.0, 128.0)
		red = out1 or red
		green = out2 or green
		blue = out3 or blue
	end
	alpha = 128.0
	monster.set_motion("立ち", -1, 0)
	monster.set_model_lighting(0)
	frame = 0
	while frame < 32 do
		red = vm.f32(red - 4.0)
		green = vm.f32(green - 4.0)
		blue = vm.f32(blue - 4.0)
		alpha = vm.f32(alpha - 2.0)
		monster.set_model_color(red, green, blue, alpha)
		wait_frame()
		frame = frame + 1
	end
	form_flags = get_form_flags(form_flags)
	if bit32.band(form_flags, 1) ~= 0 then
		form_flags = 2
		monster.set_monster_damage_rates(-1, 48, 1.0)
		monster.set_monster_damage_rates(-1, 4047, 0.0)
	else
		form_flags = 1
		monster.set_monster_damage_rates(-1, 15, 1.0)
		monster.set_monster_damage_rates(-1, 4080, 0.0)
	end
	apply_form(form_flags)
	frame = 0
	while frame < 32 do
		red = vm.f32(red + 4.0)
		green = vm.f32(green + 4.0)
		blue = vm.f32(blue + 4.0)
		alpha = vm.f32(alpha + 2.0)
		monster.set_model_color(red, green, blue, alpha)
		wait_frame()
		frame = frame + 1
	end
	monster.set_model_color(1)
end

--- Fades the model out, repositions it on the arena ring, and fades it back in with the ground form damage rates.
local function reappear_on_ground()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local red: f32 = 0
	local green: f32 = 0
	local blue: f32 = 0
	local alpha: f32 = 0
	local model_scale: f32 = 0
	local frame: s32 = 0
	local form_flags: s32 = 0
	local effect_slot: s32 = 0
	local object_size: f32 = 0
	local ring_angle: f32 = 0
	monster.get_character_number()
	do
		local out1, _, _ = monster.get_scale()
		model_scale = out1 or model_scale
	end
	do
		local out1, out2, out3 = monster.copy_vector(128.0, 128.0, 128.0)
		red = out1 or red
		green = out2 or green
		blue = out3 or blue
	end
	alpha = 128.0
	monster.set_camera_mode(4)
	effect_slot = monster.get_variable(4) or effect_slot
	monster.set_effect_value(effect_slot, 2, 1)
	effect_slot = monster.get_variable(5) or effect_slot
	monster.set_effect_value(effect_slot, 2, 1)
	monster.set_model_color(0)
	frame = 0
	while frame < 96 do
		red = vm.f32(red - 1.0)
		green = vm.f32(green - 1.0)
		blue = vm.f32(blue - 1.0)
		alpha = vm.f32(alpha - 1.0)
		monster.set_model_color(red, green, blue, alpha)
		vm.wait()
		frame = frame + 1
	end
	monster.set_model_color(1)
	object_size = monster.get_variable_float(21) or object_size
	monster.set_entry_object_size(0, object_size)
	monster.set_variable(14, 1)
	ring_angle = monster.get_random_whole_number(6.2831855) or ring_angle
	x = vm.f32(vm.f32(vm.sin(ring_angle) * 500.0) - 50.0)
	y = 15.0
	z = vm.f32(vm.f32(vm.cos(ring_angle) * 500.0) - 50.0)
	monster.set_position(x, y, z)
	set_scale_settings(1.0, 0.0, vm.f32(999.9), 1.0)
	monster.set_scale(1.0, 1.0, 1.0)
	monster.set_variable(14, 0)
	effect_slot = monster.get_variable(4) or effect_slot
	monster.set_effect_value(effect_slot, 2, 2)
	effect_slot = monster.get_variable(5) or effect_slot
	monster.set_effect_value(effect_slot, 2, 2)
	monster.set_model_color(0)
	frame = 0
	while frame < 96 do
		red = vm.f32(red + 1.0)
		green = vm.f32(green + 1.0)
		blue = vm.f32(blue + 1.0)
		alpha = vm.f32(alpha + 1.0)
		monster.set_model_color(red, green, blue, alpha)
		vm.wait()
		frame = frame + 1
	end
	monster.set_model_color(1)
	effect_slot = monster.get_variable(4) or effect_slot
	monster.set_effect_value_float(effect_slot, 1, 1.0)
	effect_slot = monster.get_variable(5) or effect_slot
	monster.set_effect_value_float(effect_slot, 1, 1.0)
	form_flags = get_form_flags(form_flags)
	if bit32.band(form_flags, 1) ~= 0 then
		monster.set_monster_damage_rates(-1, 15, 1.0)
		monster.set_monster_damage_rates(-1, 4080, 0.0)
	else
		monster.set_monster_damage_rates(-1, 48, 1.0)
		monster.set_monster_damage_rates(-1, 4047, 0.0)
	end
	monster.set_model_color(1)
	set_distance_limits(500.0, 0.0)
	set_height_limits(50.0, 0.0)
end

--- Returns a quarter turn to the left or right at random.
local function pick_random_side_angle()
	local roll: s32 = 0
	local side_angle: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		side_angle = vm.f32(1.5707964)
	else
		side_angle = vm.f32(-1.5707964)
	end
	return side_angle
end

--- Waits until the monster faces an angle within a tolerance or a frame limit passes, and returns the frames waited.
local function wait_until_facing(target_degrees: f32, tolerance_degrees: f32, max_frames: f32)
	local rotation_y: f32 = 0
	local elapsed_frames: f32 = 0
	local frame_limit: f32 = 0
	local tolerance_radians: f32 = 0
	target_degrees = calc.degrees_to_radians(target_degrees)
	if target_degrees > vm.f32(3.1415927) then
		target_degrees = vm.f32(target_degrees - vm.f32(6.2831855))
	end
	if target_degrees <= vm.f32(-3.1415927) then
		target_degrees = vm.f32(target_degrees + vm.f32(6.2831855))
	end
	tolerance_degrees = calc.degrees_to_radians(tolerance_degrees)
	frame_limit = max_frames
	if tolerance_degrees < 3.0 then
		tolerance_radians = calc.degrees_to_radians(3.0)
	else
		tolerance_radians = tolerance_degrees
	end
	elapsed_frames = 0.0
	while elapsed_frames < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		if rotation_y > vm.f32(target_degrees - tolerance_radians) and rotation_y < vm.f32(target_degrees + tolerance_radians) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_degrees, rotation_y, tolerance_degrees) == 0 then
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

--- Turns toward the target at the given speed and waits until facing it.
local function face_target(turn_speed_degrees: f32)
	local target_angle: f32 = 0
	movement.turn_toward_target(calc.degrees_to_radians(turn_speed_degrees))
	target_angle = monster.get_target_angle() or target_angle
	local _ = wait_until_facing(calc.radians_to_degrees(target_angle), turn_speed_degrees, 360.0)
	movement.stop_turning()
end

--- Returns the speed bonus, which always evaluates to zero because the stored value is never read back.
local function get_speed_bonus(speed_bonus: f32)
	local unread_bonus: f32 = 0
	-- retail: monster.set_variable(9, var1) does nothing, since its handler stores only an integer or a float
	speed_bonus = unread_bonus
	return speed_bonus
end

--- Returns a speed increased by the speed bonus.
local function apply_speed_bonus(speed: f32)
	local speed_bonus: f32 = 0
	speed_bonus = get_speed_bonus(speed_bonus)
	speed = vm.f32(speed + speed_bonus)
	return speed
end

--- Returns the stored farthest and nearest horizontal distances.
local function get_distance_limits(max_distance: f32, min_distance: f32)
	local stored_max_distance: f32 = 0
	local stored_min_distance: f32 = 0
	stored_max_distance = monster.get_variable_float(2) or stored_max_distance
	stored_min_distance = monster.get_variable_float(3) or stored_min_distance
	max_distance = stored_max_distance
	min_distance = stored_min_distance
	return max_distance, min_distance
end

--- Returns the stored highest and lowest heights.
local function get_height_limits(max_height: f32, min_height: f32)
	local stored_max_height: f32 = 0
	local stored_min_height: f32 = 0
	stored_max_height = monster.get_variable_float(0) or stored_max_height
	stored_min_height = monster.get_variable_float(1) or stored_min_height
	max_height = stored_max_height
	min_height = stored_min_height
	return max_height, min_height
end

--- Returns 1 when a position is clear to fly to and within the height limits.
local function is_position_reachable(x: f32, y: f32, z: f32)
	local max_height: f32 = 0
	local min_height: f32 = 0
	local max_distance: f32 = 0
	local min_distance: f32 = 0
	local skips_path_check: s32 = 0
	local distance: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local angle: f32 = 0
	max_distance, min_distance = get_distance_limits(max_distance, min_distance)
	max_height, min_height = get_height_limits(max_height, min_height)
	skips_path_check = monster.get_variable(14) or skips_path_check
	if skips_path_check == 0 then
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
	end
	if y < min_height or y > max_height then
		return 0
	end
	return 1
end

--- Returns the stored scale, scale step and scale range.
local function get_scale_settings(out_scale: f32, out_scale_step: f32, out_max_scale: f32, out_min_scale: f32)
	local scale: f32 = 0
	local scale_step: f32 = 0
	local max_scale: f32 = 0
	local min_scale: f32 = 0
	do
		local out1, out2, out3 = monster.copy_vector(0.0, 0.0, 0.0)
		scale = out1 or scale
		scale_step = out2 or scale_step
		max_scale = out3 or max_scale
	end
	min_scale = 0.0
	scale = monster.get_variable_float(11) or scale
	scale_step = monster.get_variable_float(10) or scale_step
	max_scale = monster.get_variable_float(12) or max_scale
	min_scale = monster.get_variable_float(13) or min_scale
	out_scale = scale
	out_scale_step = scale_step
	out_max_scale = max_scale
	out_min_scale = min_scale
	return out_scale, out_scale_step, out_max_scale, out_min_scale
end

--- Advances the model scale by its step while it stays inside the allowed range and applies it.
local function update_scale()
	local next_scale: f32 = 0
	local scale_step: f32 = 0
	local scale: f32 = 0
	local max_scale: f32 = 0
	local min_scale: f32 = 0
	scale, scale_step, max_scale, min_scale = get_scale_settings(scale, scale_step, max_scale, min_scale)
	next_scale = vm.f32(scale + scale_step)
	if next_scale < max_scale and next_scale > min_scale then
		scale = vm.f32(scale + scale_step)
	end
	monster.set_scale(scale, scale, scale)
	monster.set_variable_float(11, scale)
end

--- Flies toward a position with a constant acceleration until it arrives, is blocked or runs out of frames.
local function fly_to_position(target_x: f32, target_y: f32, target_z: f32, start_speed: f32, unused_arrival_distance: any, distance_padding: f32, duration_scale: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local acceleration: f32 = 0
	local distance: f32 = 0
	local speed: f32 = 0
	local frame: s32 = 0
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
	acceleration = movement.get_acceleration(distance, start_speed, vm.f32(vm.f32(vm.fdiv(vm.f32(distance + distance_padding), start_speed)) * duration_scale), acceleration)
	speed = start_speed
	frame = 0
	while frame < max_frames do
		speed = vm.f32(speed + acceleration)
		speed = apply_speed_bonus(speed)
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = monster.copy_vector(direction_x, direction_y, direction_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, speed)
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
		if speed < 0.0 then
			break
		else
			distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
			if distance < speed then
				break
			elseif is_position_reachable(position_x, position_y, position_z) == 0 then
				break
			else
				monster.set_position(position_x, position_y, position_z)
				update_scale()
				wait_frame()
				frame = frame + 1
			end
		end
	end
	movement.stop_turning()
end

--- Flies toward a position along a curve that bends gradually from a side heading toward the destination.
local function fly_curved_toward(
	target_x: f32,
	target_y: f32,
	target_z: f32,
	start_speed: f32,
	arrival_distance: f32,
	heading_angle: f32,
	homing_strength: f32,
	tracks_target: s32,
	max_frames: s32
)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local heading_x: f32 = 0
	local heading_y: f32 = 0
	local heading_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local distance: f32 = 0
	local speed: f32 = 0
	local frame: s32 = 0
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
	heading_x = vm.f32(vm.f32(direction_x * vm.cos(heading_angle)) + vm.f32(direction_z * vm.sin(heading_angle)))
	heading_y = direction_y
	heading_z = vm.f32(vm.f32(direction_x * -vm.sin(heading_angle)) + vm.f32(direction_z * vm.cos(heading_angle)))
	do
		local out1, out2, out3 = monster.normalize_vector(heading_x, heading_y, heading_z)
		heading_x = out1 or heading_x
		heading_y = out2 or heading_y
		heading_z = out3 or heading_z
	end
	speed = start_speed
	frame = 0
	while frame < max_frames do
		if tracks_target ~= 0 then
			do
				local out1, out2, out3 = monster.get_target_position()
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
		end
		speed = apply_speed_bonus(speed)
		direction_x = vm.f32(target_x - position_x)
		direction_y = vm.f32(target_y - position_y)
		direction_z = vm.f32(target_z - position_z)
		do
			local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, homing_strength)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(heading_x, heading_y, heading_z, 1.0 - homing_strength)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(heading_x, heading_y, heading_z, direction_x, direction_y, direction_z)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(heading_x, heading_y, heading_z)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = monster.copy_vector(heading_x, heading_y, heading_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, speed)
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
		heading_angle = monster.get_angle_to_position(position_x, position_y, position_z) or heading_angle
		if speed <= 0.0 then
			break
		else
			distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
			if distance < arrival_distance or distance < speed then
				break
			elseif is_position_reachable(position_x, position_y, position_z) == 0 then
				break
			else
				monster.set_position(position_x, position_y, position_z)
				monster.turn_toward_angle(heading_angle, calc.degrees_to_radians(vm.f32(4.2)))
				update_scale()
				wait_frame()
				frame = frame + 1
			end
		end
	end
	movement.stop_turning()
end

--- Returns the position of whichever of the four pillars is nearest the target.
local function find_nearest_pillar(out_x: f32, out_y: f32, out_z: f32)
	local nearest_x: f32 = 0
	local nearest_y: f32 = 0
	local nearest_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local candidate_x: f32 = 0
	local candidate_y: f32 = 0
	local candidate_z: f32 = 0
	local distance: f32 = 0
	local nearest_distance: f32 = 0
	nearest_distance = 10000000.0
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	for index = 0, 3 do
		if index == 0 then
			candidate_x = vm.f32(-670.84)
			candidate_y = vm.f32(-162.23)
			candidate_z = vm.f32(-742.89)
		end
		if index == 1 then
			candidate_x = 637.25
			candidate_y = vm.f32(-178.53)
			candidate_z = vm.f32(677.62)
		end
		if index == 2 then
			candidate_x = vm.f32(-877.66)
			candidate_y = vm.f32(-178.53)
			candidate_z = vm.f32(883.13)
		end
		if index == 3 then
			candidate_x = vm.f32(632.59)
			candidate_y = vm.f32(-178.53)
			candidate_z = vm.f32(-728.83)
		end
		distance = monster.get_distance_between(candidate_x, candidate_y, candidate_z, target_x, target_y, target_z) or distance
		if distance < nearest_distance then
			nearest_distance = distance
			do
				local out1, out2, out3 = monster.copy_vector(candidate_x, candidate_y, candidate_z)
				nearest_x = out1 or nearest_x
				nearest_y = out2 or nearest_y
				nearest_z = out3 or nearest_z
			end
		end
	end
	out_x = nearest_x
	out_y = nearest_y
	out_z = nearest_z
	return out_x, out_y, out_z
end

--- Warps away, flies across the arena, and rises beneath the pillar nearest the target for the beam phase.
local function fly_to_pillar()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local scale_x: f32 = 0
	local scale_y: f32 = 0
	local initial_scale: f32 = 0
	local heading_angle: f32 = 0
	local chara_type: s32 = 0
	local effect_slot: s32 = 0
	monster.set_monster_attributes(1, 1)
	set_distance_limits(9999999.0, 0.0)
	set_height_limits(9999999.0, -999999.0)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	chara_type = monster.get_character_number() or chara_type
	do
		local out1, out2, _ = monster.get_scale()
		scale_x = out1 or scale_x
		scale_y = out2 or scale_y
	end
	initial_scale = scale_x
	monster.copy_vector(128.0, 128.0, 128.0)
	heading_angle = pick_random_side_angle()
	monster.play_sound(5)
	face_target(vm.f32(1.68))
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("サンワープ２")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_owner(-1, chara_type)
	monster.set_camera_mode(4)
	fly_to_position(pos_x, 500.0, pos_z, 24.0, 24.0, 39.0, vm.f32(1.8), 600)
	face_target(vm.f32(4.2))
	set_scale_settings(initial_scale, vm.f32(-0.1), vm.f32(999.9), 0.0)
	set_speed_bonus(1.0)
	fly_curved_toward(vm.f32(2268.62), 160.0, vm.f32(2031.08), 16.0, 39.0, heading_angle, vm.f32(0.1), 0, 600)
	set_speed_bonus(0.0)
	do
		local out1, out2, _ = monster.get_scale()
		scale_x = out1 or scale_x
		scale_y = out2 or scale_y
	end
	monster.set_variable_float(20, scale_x)
	effect_slot = monster.get_variable(4) or effect_slot
	monster.set_effect_value_float(effect_slot, 1, scale_x)
	effect_slot = monster.get_variable(5) or effect_slot
	monster.set_effect_value_float(effect_slot, 1, scale_y)
	monster.set_monster_damage_rates(-1, 4095, 1.0)
	monster.play_sound(6)
	heading_angle = monster.get_target_angle() or heading_angle
	monster.set_rotation(0.0, heading_angle, 0.0)
	face_target(vm.f32(4.2))
	effect_slot = monster.get_variable(4) or effect_slot
	monster.set_effect_value_float(effect_slot, 1, 10.0)
	effect_slot = monster.get_variable(5) or effect_slot
	monster.set_effect_value_float(effect_slot, 1, 10.0)
	pos_x, pos_y, pos_z = find_nearest_pillar(pos_x, pos_y, pos_z)
	print("pos[0] =", vm.float(pos_x), "----------\n")
	print("pos[1] =", vm.float(pos_y), "----------\n")
	print("pos[2] =", vm.float(pos_z), "----------\n")
	set_scale_settings(10.0, 0.0, 10.0, 0.0)
	monster.set_position(pos_x, -1000.0, pos_z)
	monster.set_variable(14, 1)
	fly_to_position(pos_x, -100.0, pos_z, 8.0, 8.0, 39.0, vm.f32(1.8), 600)
	monster.set_variable(14, 0)
	monster.set_monster_attributes(1, 0)
end

--- Starts the beam phase or the ground phase according to the flags and stores them.
local function enter_phase(form_flags: s32)
	local object_size: f32 = 0
	local current_scale: f32 = 0
	if bit32.band(form_flags, 4) == 0 then
		reappear_on_ground()
		monster.get_variable_float(20)
		object_size = monster.get_variable_float(21) or object_size
		monster.set_entry_object_size(0, object_size)
	end
	if bit32.band(form_flags, 4) ~= 0 then
		fly_to_pillar()
		monster.get_variable_float(20)
		do
			local out1, _, _ = monster.get_scale()
			current_scale = out1 or current_scale
		end
		object_size = monster.get_variable_float(21) or object_size
		monster.set_entry_object_size(0, object_size * current_scale)
	end
	monster.set_variable(6, form_flags)
end

--- Turns toward an angle at the given speed and waits until facing it.
local function turn_toward_angle_and_wait(next_rot: f32, rot_speed: f32)
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

--- Waits frame by frame until the current motion finishes.
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

--- Waits the given number of frames.
local function wait_frames(frames: any)
	local frame: s32 = 0
	frame = 0
	while frame < frames do
		wait_frame()
		frame = vm.i32(frame + 1)
	end
end

--- Fires a beam from a random point on the arena ring that sweeps across the target position.
local function fire_sweeping_beam()
	local chara_type: s32 = 0
	local slot: s32 = 0
	local attack: s32 = 0
	local beam_x: f32 = 0
	local beam_y: f32 = 0
	local beam_z: f32 = 0
	local model_scale: f32 = 0
	local start_angle: f32 = 0
	local sweep_distance: f32 = 0
	local step_length: f32 = 0
	local beam_angle: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local sweep_x: f32 = 0
	local sweep_y: f32 = 0
	local sweep_z: f32 = 0
	local monster_character: s32 = 0
	print("attack2--------------------------------\n")
	monster.set_motion("歩き", -1, 0)
	face_target(vm.f32(4.2))
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(1.8)))
	chara_type = monster.get_character_number() or chara_type
	do
		local out1, _, _ = monster.get_scale()
		model_scale = out1 or model_scale
	end
	start_angle = monster.get_random_whole_number(6.2831855) or start_angle
	start_x = vm.f32(vm.sin(start_angle) * 500.0)
	start_y = 0.0
	start_z = vm.f32(vm.cos(start_angle) * 500.0)
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		sweep_x = out1 or sweep_x
		sweep_y = out2 or sweep_y
		sweep_z = out3 or sweep_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(sweep_x, sweep_y, sweep_z, start_x, start_y, start_z)
		sweep_x = out1 or sweep_x
		sweep_y = out2 or sweep_y
		sweep_z = out3 or sweep_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(sweep_x, sweep_y, sweep_z)
		sweep_x = out1 or sweep_x
		sweep_y = out2 or sweep_y
		sweep_z = out3 or sweep_z
	end
	sweep_distance = 1000.0
	step_length = vm.f32(sweep_distance / 90.0)
	do
		local out1, out2, out3 = monster.scale_vector(sweep_x, sweep_y, sweep_z, step_length)
		sweep_x = out1 or sweep_x
		sweep_y = out2 or sweep_y
		sweep_z = out3 or sweep_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(start_x, start_y, start_z)
		beam_x = out1 or beam_x
		beam_y = out2 or beam_y
		beam_z = out3 or beam_z
	end
	beam_angle = monster.get_angle_to_position(start_x, start_y, start_z) or beam_angle
	turn_toward_angle_and_wait(calc.radians_to_degrees(beam_angle), vm.f32(4.2))
	monster_character = monster.get_character_number() or monster_character
	monster.play_monster_sound(monster_character, 7)
	monster.set_motion("攻撃２入り", -1, 6)
	slot = monster.create_effect_2("ＤＥビームＦ") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value_float(slot, 0, model_scale)
	monster.set_effect_first_vector(slot, start_x, start_y, start_z)
	wait_until_motion_finished()
	monster.set_motion("攻撃２ループ", -1, 0)
	slot = monster.create_effect_2("ＤＥビームＬ") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, attack)
	monster.set_effect_value_float(slot, 2, model_scale)
	monster.set_effect_value(slot, 1, 1)
	for frame = 0, 89 do
		do
			local out1, out2, out3 = monster.add_vectors(beam_x, beam_y, beam_z, sweep_x, sweep_y, sweep_z)
			beam_x = out1 or beam_x
			beam_y = out2 or beam_y
			beam_z = out3 or beam_z
		end
		beam_angle = monster.get_angle_to_position(beam_x, beam_y, beam_z) or beam_angle
		monster.set_effect_first_vector(slot, beam_x, beam_y, beam_z)
		monster.set_rotation(0.0, beam_angle, 0.0)
		wait_frame()
	end
	monster.set_motion("攻撃２戻り", -1, 6)
	monster.set_effect_value(slot, 1, 2)
	wait_until_motion_finished()
	wait_frames(60)
	monster.set_motion("立ち", -1, 0)
end

--- Fires the sweeping beam, fires again when badly hurt, then ends the beam phase and returns to the ground.
local function run_beam_phase()
	local life: f32 = 0
	local form_flags: s32 = 0
	life = 0.0
	fire_sweeping_beam()
	life = monster.get_life() or life
	if life < vm.f32(0.1) then
		fire_sweeping_beam()
	end
	set_form_flag(4, 0)
	form_flags = get_form_flags(form_flags)
	enter_phase(form_flags)
end

--- Returns the distance to the target ignoring height.
local function get_horizontal_target_distance(out_distance: f32)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local target_x: f32 = 0
	local target_z: f32 = 0
	local distance: f32 = 0
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	do
		local out1, _, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	distance = monster.get_distance_between(pos_x, 0.0, pos_z, target_x, 0.0, target_z) or distance
	out_distance = distance
	return out_distance
end

--- Runs in a curve around the target, then stands.
local function circle_target()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local curve_angle: f32 = 0
	local roll: s32 = 0
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.set_motion("歩き", -1, 0)
	face_target(vm.f32(4.2))
	roll = monster.get_random(100) or roll
	if roll < 50 then
		curve_angle = vm.f32(1.5707964)
	else
		curve_angle = vm.f32(-1.5707964)
	end
	monster.set_motion("走り", -1, 0)
	fly_curved_toward(target_x, target_y, target_z, 8.0, 39.0, curve_angle, vm.f32(0.12), 1, 600)
	monster.set_motion("立ち", -1, 0)
end

--- Turns toward the target for a number of frames.
local function track_target_for_frames(rot_speed: f32, frames: s32)
	local target_angle: f32 = 0
	local _ = calc.degrees_to_radians(rot_speed)
	for frame = 0, frames - 1 do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		wait_frame()
	end
	movement.stop_turning()
end

--- Aims and shoots a homing arrow at the target.
local function shoot_arrow()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local aim_x: f32 = 0
	local aim_y: f32 = 0
	local aim_z: f32 = 0
	local chara_type: s32 = 0
	local slot: s32 = 0
	local attack: s32 = 0
	print("attack1--------------------------------\n")
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1, 0)
	face_target(vm.f32(4.2))
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	chara_type = monster.get_character_number() or chara_type
	slot = monster.create_effect_2("ＤＥ矢３") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, attack)
	monster.set_effect_value(slot, 1, 0)
	monster.set_effect_value_float(slot, 2, 15.0)
	monster.set_effect_value_float(slot, 3, 0.01)
	monster.set_effect_value_float(slot, 4, 0.3)
	monster.set_effect_value(slot, 5, 5)
	monster.set_effect_value(slot, 6, 25)
	track_target_for_frames(vm.f32(4.2), calc.pass_through(31))
	do
		local out1, out2, out3 = monster.get_target_position()
		aim_x = out1 or aim_x
		aim_y = out2 or aim_y
		aim_z = out3 or aim_z
	end
	do
		local out1, out2, out3 = monster.get_frame_position("arrow")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
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
	monster.set_effect_value(slot, 1, 1)
	wait_until_motion_finished()
	monster.set_motion("立ち", -1, 0)
end

--- Turns toward the target until the current motion finishes.
local function track_target_until_motion_finished(rot_speed: f32)
	local target_angle: f32 = 0
	local is_finished: s32 = 0
	rot_speed = calc.degrees_to_radians(rot_speed)
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		wait_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			movement.stop_turning()
			break
		end
	end
end

--- Turns to face the target and performs the melee swing.
local function melee_attack()
	print("attack3--------------------------------\n")
	monster.set_motion("歩き", -1, 0)
	face_target(vm.f32(4.2))
	monster.set_motion("攻撃３", -1, 2)
	track_target_until_motion_finished(vm.f32(4.2))
	monster.set_motion("立ち", -1, 0)
end

--- Waits for frames while watching the player status and, at random, starts the beam phase or attacks in melee; returns 1 or 2 when it reacted and 0 otherwise.
local function react_to_player_status(frames: s32)
	local player_status: s32 = 0
	local roll: s32 = 0
	for frame = 0, frames - 1 do
		if vm.imod(frame, 3) == 0 then
			roll = monster.get_random(100) or roll
			player_status = monster.get_player_status_attribute() or player_status
			if player_status == 8 then
				if roll < 25 then
					set_form_flag(4, 1)
					player_status = get_form_flags(player_status)
					enter_phase(player_status)
					state.set_state_flag(0)
				end
				return 1
			end
			if player_status == 2 then
				if roll > 50 then
					circle_target()
					melee_attack()
				end
				return 2
			end
		end
		wait_frame()
	end
	return 0
end

--- Flies toward a position with constant acceleration while playing the shooting motion and releasing the arrow midway.
local function fly_while_firing_arrow(arrow_effect: s32, target_x: f32, target_y: f32, target_z: f32, start_speed: f32, distance_padding: f32, duration_scale: f32, unused_option: any)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local acceleration: f32 = 0
	local distance: f32 = 0
	local speed: f32 = 0
	local target_angle: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
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
	acceleration = movement.get_acceleration(distance, start_speed, vm.f32(vm.f32(vm.fdiv(vm.f32(distance + distance_padding), start_speed)) * duration_scale), acceleration)
	speed = start_speed
	monster.reset_motion()
	monster.set_motion("攻撃１", -1.0, 6)
	frame = 0
	while frame < 60 do
		speed = vm.f32(speed + acceleration)
		speed = apply_speed_bonus(speed)
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = monster.copy_vector(direction_x, direction_y, direction_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, speed)
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
		if frame == 31 then
			monster.set_effect_value(arrow_effect, 1, 1)
		end
		if speed < 0.0 then
			break
		end
		distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
		if distance < speed then
			break
		end
		if is_position_reachable(position_x, position_y, position_z) == 0 then
			do
				local out1, out2, out3 = monster.copy_vector(0.0, 0.0, 0.0)
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
		end
		target_angle = monster.get_target_angle() or target_angle
		monster.set_position(position_x, position_y, position_z)
		monster.turn_toward_angle(target_angle, calc.degrees_to_radians(vm.f32(4.2)))
		update_scale()
		wait_frame()
		frame = frame + 1
	end
	while frame < 60 do
		if frame == 31 then
			monster.set_effect_value(arrow_effect, 1, 1)
		end
		wait_frame()
		frame = frame + 1
	end
	movement.stop_turning()
end

--- Shoots a weak arrow while moving to a point around the arena center on the side of the target.
local function shoot_arrow_while_orbiting()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local orbit_angle: f32 = 0
	local target_angle: f32 = 0
	local radius: f32 = 0
	local chara_type: s32 = 0
	local slot: s32 = 0
	local attack: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	orbit_angle = monster.get_arc_tangent(pos_x, pos_z) or orbit_angle
	monster.get_target_angle(target_angle)
	if target_angle < 0.0 then
		orbit_angle = vm.f32(orbit_angle + vm.f32(0.7853982))
	else
		orbit_angle = vm.f32(orbit_angle - vm.f32(0.7853982))
	end
	attack = monster.get_attack_power_1() or attack
	attack = vm.ftoi(vm.f32(attack * vm.f32(0.4)))
	chara_type = monster.get_character_number() or chara_type
	attack = monster.get_attack_power_1() or attack
	slot = monster.create_effect_2("ＤＥ矢３") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, attack)
	monster.set_effect_value(slot, 1, 0)
	monster.set_effect_value_float(slot, 2, 15.0)
	monster.set_effect_value_float(slot, 3, 0.01)
	monster.set_effect_value_float(slot, 4, 0.3)
	monster.set_effect_value(slot, 5, 5)
	monster.set_effect_value(slot, 6, 25)
	radius = monster.get_distance_between(0.0, pos_y, 0.0, pos_x, pos_y, pos_z) or radius
	pos_x = vm.f32(vm.sin(orbit_angle) * radius)
	pos_z = vm.f32(vm.cos(orbit_angle) * radius)
	fly_while_firing_arrow(slot, pos_x, pos_y, pos_z, 8.0, 39.0, vm.f32(1.8), 60)
end

--- Chooses between circling the target, shooting an arrow and shooting while orbiting; returns 1 when the beam phase started.
local function attack_at_long_range()
	local distance: f32 = 0
	local roll: s32 = 0
	local reaction: s32 = 0
	distance = get_horizontal_target_distance(distance)
	roll = monster.get_random(100) or roll
	if roll < 10 then
		circle_target()
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			face_target(vm.f32(4.2))
			shoot_arrow()
			monster.set_motion("立ち", -1, 0)
			reaction = react_to_player_status(9)
			if reaction == 1 then
				return 1
			end
		else
			roll = monster.get_random(2) or roll
			roll = vm.i32(roll + 1)
			for index = 0, roll - 1 do
				shoot_arrow_while_orbiting()
			end
			monster.set_motion("立ち", -1, 0)
			reaction = react_to_player_status(9)
			if reaction == 1 then
				return 1
			end
		end
	end
	return 0
end

--- Moves straight toward a position until it arrives, is blocked or runs out of frames.
local function dash_toward_position(target_x: f32, target_y: f32, target_z: f32, dash_speed: any, arrival_distance: f32, max_frames: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local distance: f32 = 0
	local speed: f32 = 0
	local frame: s32 = 0
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
	do
		local out1, out2, out3 = monster.scale_vector(direction_x, direction_y, direction_z, speed)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	frame = 0
	while frame < max_frames do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, direction_x, direction_y, direction_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		if speed <= 0.0 then
			break
		else
			distance = monster.get_distance_between(target_x, target_y, target_z, position_x, position_y, position_z) or distance
			if distance < arrival_distance or distance < speed then
				break
			elseif is_position_reachable(position_x, position_y, position_z) == 0 then
				break
			else
				monster.set_position(position_x, position_y, position_z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
				wait_frame()
				frame = frame + 1
			end
		end
	end
end

--- Runs straight at the target position, then stands.
local function dash_at_target()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	monster.set_motion("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	face_target(vm.f32(4.2))
	monster.set_motion("走り", -1, 0)
	dash_toward_position(target_x, target_y, target_z, 8.0, 39.0, 300)
	monster.set_motion("立ち", -1, 0)
end

--- Chooses between dashing at the target, shooting while orbiting and shooting an arrow; returns 1 when the beam phase started.
local function attack_at_medium_range()
	local distance: f32 = 0
	local roll: s32 = 0
	local shot_index: s32 = 0
	local reaction: s32 = 0
	roll = monster.get_random(100) or roll
	distance = get_horizontal_target_distance(distance)
	if distance < 303.0 then
		roll = monster.get_random(100) or roll
		if roll < 20 then
			dash_at_target()
		else
			shot_index = 0
			roll = monster.get_random(3) or roll
			while shot_index < roll do
				shoot_arrow_while_orbiting()
				shot_index = shot_index + 1
			end
			reaction = react_to_player_status(9)
			if reaction == 1 then
				return 1
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 10 then
			circle_target()
		else
			monster.set_motion("歩き", -1, 0)
			face_target(vm.f32(4.2))
			shoot_arrow()
			monster.set_motion("立ち", -1, 0)
			reaction = react_to_player_status(9)
			if reaction == 1 then
				return 1
			end
		end
	end
	return 0
end

--- Flies at the target position, then stands.
local function fly_at_target()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.set_motion("歩き", -1, 0)
	face_target(vm.f32(4.2))
	monster.set_motion("走り", -1, 0)
	fly_to_position(target_x, target_y, target_z, 8.0, 8.0, 39.0, vm.f32(1.8), 600)
	monster.set_motion("立ち", -1, 0)
end

--- Flies to a random point on the arena ring at the given height.
local function fly_to_random_ring_point(height: f32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local angle: f32 = 0
	angle = monster.get_random_whole_number(6.2831855) or angle
	destination_x = vm.f32(vm.sin(angle) * 500.0)
	destination_y = height
	destination_z = vm.f32(vm.cos(angle) * 500.0)
	monster.set_motion("歩き", -1, 0)
	angle = monster.get_angle_to_position(destination_x, destination_y, destination_z) or angle
	turn_toward_angle_and_wait(calc.radians_to_degrees(angle), vm.f32(4.2))
	monster.set_motion("走り", -1, 0)
	fly_to_position(destination_x, destination_y, destination_z, 8.0, 8.0, 39.0, vm.f32(1.8), 150)
	monster.set_motion("立ち", -1, 0)
end

--- Chooses between flying at the target and swinging, moving to the ring, shooting while orbiting and circling the target.
local function attack_at_short_range()
	local distance: f32 = 0
	local roll: s32 = 0
	distance = get_horizontal_target_distance(distance)
	roll = monster.get_random(100) or roll
	if roll < 65 then
		fly_at_target()
		melee_attack()
	else
		roll = monster.get_random(100) or roll
		if roll < 55 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("走り", -1, 0)
				fly_to_random_ring_point(80.0)
				monster.set_motion("歩き", -1, 0)
				face_target(vm.f32(4.2))
				monster.set_motion("立ち", -1, 0)
			else
				shoot_arrow_while_orbiting()
			end
		else
			circle_target()
		end
	end
	return 0
end

--- Picks an attack by the distance to the target and counts it.
local function choose_attack()
	local distance: f32 = 0
	local attack_count: s32 = 0
	distance = get_horizontal_target_distance(distance)
	if distance > 450.0 then
		local _ = attack_at_long_range()
	elseif distance > 225.0 then
		local _ = attack_at_medium_range()
	else
		local _ = attack_at_short_range()
	end
	attack_count = state.get_state_flag(attack_count)
	attack_count = vm.i32(attack_count + 1)
	state.set_state_flag(attack_count)
end

--- Stops all movement and turning, faces the target and marks the action as being recovered.
local function prepare_knockdown_recovery()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	wait_frame()
	monster.set_action_status(1)
end

--- Steps backward, left or right by a distance with the matching motion.
local function dodge_step(speed: f32, distance: f32, direction: s32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local step_angle: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	if direction == 1 then
		monster.set_motion("ステップ後", -1, 0)
		step_angle = vm.f32(rotation_y + vm.f32(3.1415927))
	end
	if direction == 2 then
		monster.set_motion("ステップ左", -1, 0)
		step_angle = vm.f32(rotation_y + vm.f32(1.5707964))
	end
	if direction == 4 then
		monster.set_motion("ステップ右", -1, 0)
		step_angle = vm.f32(rotation_y - vm.f32(1.5707964))
	end
	if step_angle > vm.f32(3.1415927) then
		step_angle = vm.f32(step_angle - vm.f32(6.2831855))
	end
	if step_angle <= vm.f32(-3.1415927) then
		step_angle = vm.f32(step_angle + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(step_angle) * distance))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(step_angle) * distance))
	fly_to_position(pos_x, pos_y, pos_z, speed, speed, 39.0, vm.f32(1.8), max_frames)
	monster.set_motion("立ち", -1, 0)
end

local script = {}

--- Does nothing for this monster.
function script.setup() end

--- Registers the damage hits, creates the blue and red light effects, loads the beam and arrow effects and textures, and sets the starting state.
function script.init()
	local chara_type: s32 = 0
	local slot: s32 = 0
	local slot_2: s32 = 0
	local size: f32 = 0
	monster.register_damage_hit("通常攻撃", 7.8, "攻撃３", 0.195, 0.24, 1)
	monster.register_damage_hit("通常攻撃", 7.8, "攻撃３", 0.42, 0.465, 1)
	monster.register_damage_hit("吹っ飛び強", 7.8, "攻撃３", 0.705, 0.75, 1)
	chara_type = monster.get_character_number() or chara_type
	monster.load_effect_script("ＤＥ光青")
	slot = monster.create_effect_2("ＤＥ光青") or slot
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, 1)
	monster.set_effect_value_float(slot, 1, 1.0)
	monster.set_variable(4, slot)
	monster.load_effect_script("ＤＥ光赤")
	slot_2 = monster.create_effect_2("ＤＥ光赤") or slot_2
	monster.set_effect_owner(slot_2, chara_type)
	monster.set_effect_value(slot_2, 0, 0)
	monster.set_effect_value_float(slot_2, 1, 1.0)
	monster.set_variable(5, slot_2)
	monster.load_effect_script("ＤＥ矢")
	monster.load_effect_script("ＤＥ矢２")
	monster.load_effect_script("ＤＥ矢３")
	monster.load_effect_script("ＤＥ矢Ｈ")
	monster.load_effect_script("ＤＥビームＦ")
	monster.load_effect_script("ＤＥビームＬ")
	monster.load_effect_script("ＤＥビームＨ")
	monster.load_effect_script("サンワープ２")
	monster.set_camera_mode(4)
	size = monster.get_entry_object_size(0) or size
	monster.set_variable(6, 1)
	monster.set_variable_float(20, 1.0)
	monster.set_variable_float(21, size)
	monster.set_position(0.0, 45.0, 0.0)
	monster.set_variable_float(8, 0.0)
	monster.set_variable_float(9, 0.0)
	monster.set_variable_float(10, 0.0)
	monster.set_variable_float(11, 0.0)
	set_scale_settings(1.0, 0.0, 1.0, 0.0)
	set_speed_bonus(0.0)
	monster.set_variable(20, 0)
	monster.set_variable(19, 0)
	monster.set_variable(22, 0)
	monster.set_variable(23, 0)
	monster.load_reserved_image(0, "textures/dungeon/monster/b11a_g.json")
	monster.load_reserved_image(1, "textures/dungeon/monster/b11a_r.json")
	monster.set_variable(14, 0)
	restart_dungeon_timer()
	timer.start(0)
	timer.start(1)
	timer.start(2)
	movement.stop_at_current_position()
	set_height_limits(50.0, 0.0)
	set_distance_limits(500.0, 0.0)
	configure_flight()
	configure_clip_distance()
	monster.set_clip_distance(999999.9)
end

--- Picks a form on the first run, then repeatedly switches form or enters the beam phase on timers and otherwise attacks.
function script.loop()
	local value: s32 = 0
	local form_flags: s32 = 0
	local roll: s32 = 0
	local value_2: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	value = monster.get_variable(19) or value
	if value == 0 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			set_form_flag(1, 1)
		else
			set_form_flag(2, 1)
		end
		monster.set_variable(19, 1)
		switch_form()
	end
	while true do
		wait_frame()
		value_2 = monster.get_variable(22) or value_2
		if value_2 ~= 0 then
			monster.set_variable(22, 0)
			form_flags = get_form_flags(form_flags)
			if bit32.band(form_flags, 4) == 0 then
				switch_form()
			end
		else
			value_2 = monster.get_variable(23) or value_2
			if value_2 ~= 0 then
				monster.set_variable(23, 0)
				set_form_flag(4, 1)
				form_flags = get_form_flags(form_flags)
				enter_phase(form_flags)
			end
		end
		form_flags = get_form_flags(form_flags)
		if bit32.band(form_flags, 4) ~= 0 then
			run_beam_phase()
		else
			choose_attack()
		end
	end
end

--- Cancels the current action and does nothing.
function script.on_damage()
	state.stop_and_clear_action()
	state.do_nothing()
end

--- Recovers in place after a knockdown and releases the action.
function script.on_knockdown()
	prepare_knockdown_recovery()
	state.unlock_and_clear_action()
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing while guarding.
function script.on_guard() end

--- Faces the target and steps backward.
function script.on_dodge_1()
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	wait_frame()
	dodge_step(12.0, 30.0, 1, 30)
	state.unlock()
end

--- Faces the target and steps to the left or right depending on its angle.
function script.on_dodge_2()
	local target_angle: f32 = 0
	local step_direction: s32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	wait_frame()
	if target_angle < 0.0 then
		step_direction = 4
	else
		step_direction = 2
	end
	dodge_step(vm.f32(13.6), 30.0, step_direction, 30)
	state.unlock()
end

--- Removes the light effects, plays the death motion, requests the defeat event and waits.
function script.on_death()
	local value: s32 = 0
	local value_2: s32 = 0
	death.begin()
	monster.set_monster_attributes(2, 1)
	monster.set_monster_attributes(64, 1)
	monster.set_camera_mode(0)
	value = monster.get_variable(4) or value
	value_2 = monster.get_variable(5) or value_2
	monster.finish_effect(value)
	monster.finish_effect(value_2)
	monster.set_motion("死に", -1, 6)
	wait_until_motion_finished()
	monster.request_event_script(500)
	while true do
		wait_frame()
	end
	while true do
		wait_frame()
	end
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when caught.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when landing.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when stunned.
function script.on_stun() end

return script
