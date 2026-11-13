--!strict
--- Monica's lightning magic: a trail of sprites shoots from the caster, curves toward the target and spawns the impact effect on contact.

local vm = require("@lib/vm")

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Flies a crackling lightning bolt from the caster toward the target, creating the impact effect on collision.
function script.on_start()
	local caster_id: s32 = 0
	local target_id: s32 = 0
	local power_scale: f32 = 0
	local facing_angle: f32 = 0
	local caster_x: f32 = 0
	local caster_y: f32 = 0
	local caster_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local bolt_x: f32 = 0
	local bolt_y: f32 = 0
	local bolt_z: f32 = 0
	local bolt_yaw: f32 = 0
	local bolt_pitch: f32 = 0
	local bolt_roll: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local angle_jitter: f32 = 0
	local waypoint_x: f32 = 0
	local waypoint_y: f32 = 0
	local waypoint_z: f32 = 0
	local sprite_allocation: s32 = 0
	local trail_x: f32 = 0
	local trail_y: f32 = 0
	local trail_z: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local jitter_x: f32 = 0
	local jitter_y: f32 = 0
	local jitter_z: f32 = 0
	local frame: s32 = 0
	local sprite_cursor: s32 = 0
	local burst_index: s32 = 0
	local random_roll: s32 = 0
	local hit_result: s32 = 0
	local step_length: f32 = 0
	local target_yaw: f32 = 0
	local target_pitch: f32 = 0
	local is_aligned: s32 = 0
	caster_id = effect.get_owner_character() or caster_id
	target_id = effect.get_target_character() or target_id
	power_scale = effect.get_script_value_float(0) or power_scale
	power_scale = 0.0
	do
		local out1, out2, out3 = effect.get_scene_character_position(caster_id)
		caster_x = out1 or caster_x
		caster_y = out2 or caster_y
		caster_z = out3 or caster_z
	end
	facing_angle = effect.get_scene_character_rotation_2(caster_id) or facing_angle
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		bolt_x = out1 or bolt_x
		bolt_y = out2 or bolt_y
		bolt_z = out3 or bolt_z
	end
	if target_id <= -1 then
		target_x = vm.f32(vm.f32(vm.sin(facing_angle) * 400.0) + caster_x)
		target_y = vm.f32(20.0 + caster_y)
		target_z = vm.f32(vm.f32(vm.cos(facing_angle) * 400.0) + caster_z)
	else
		do
			local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
	end
	angle_jitter = effect.get_random_number(2.0943952) or angle_jitter
	angle_jitter = vm.f32(angle_jitter - vm.f32(1.0471976))
	facing_angle = vm.f32(facing_angle + angle_jitter)
	facing_angle = effect.wrap_angle(facing_angle) or facing_angle
	waypoint_x = vm.f32(vm.f32(vm.sin(facing_angle) * 30.0) + caster_x)
	waypoint_y = vm.f32(40.0 + caster_y)
	waypoint_z = vm.f32(vm.f32(vm.cos(facing_angle) * 30.0) + caster_z)
	facing_angle = effect.get_scene_character_rotation_2(caster_id) or facing_angle
	sprite_allocation = effect.allocate_sprites_2(40) or sprite_allocation
	if sprite_allocation == 0 then
		return
	end
	effect.set_sprite_texture("c02lightning_hit")
	effect.reset_sprites(0, 40)
	effect.set_sprite_blend_mode(0, 2, 40)
	effect.set_sprite_visible(0, 1, 40)
	effect.set_sprite_size(0, 20.0, 20.0, 40)
	effect.set_sprite_texture_rect(0, 0.0, 48.0, 48.0, 48.0, 40)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 40)
	effect.set_sprite_scale(0, 1.0 + vm.f32(1.0 * power_scale), 1.0 + vm.f32(1.0 * power_scale), 40)
	sprite_cursor = 1
	frame = 0
	while frame < 10 do
		do
			local out1, out2, out3 = effect.copy_vector(waypoint_x, waypoint_y, waypoint_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, bolt_x, bolt_y, bolt_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(step_x, step_y, step_z, 3.0)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(bolt_x, bolt_y, bolt_z, step_x, step_y, step_z)
			bolt_x = out1 or bolt_x
			bolt_y = out2 or bolt_y
			bolt_z = out3 or bolt_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(previous_x, previous_y, previous_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(trail_x, trail_y, trail_z, bolt_x, bolt_y, bolt_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(trail_x, trail_y, trail_z, 4)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		effect.set_sprite_position(0, current_x, current_y, current_z)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0)
		effect.spread_sprite_positions(sprite_cursor, current_x, current_y, current_z, trail_x, trail_y, trail_z, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(sprite_cursor, 128.0, 128.0, 128.0, 64.0, 4)
		effect.ease_sprite_color(sprite_cursor, 128.0, 128.0, 128.0, -64.0, 6.0, 4)
		effect.set_sprite_blinking(sprite_cursor, 0.0, 0.0, 0.0, 64.0, 1.5707964, 4)
		effect.set_sprite_scale(sprite_cursor, 1.0 + vm.f32(1.0 * power_scale), 1.0 + vm.f32(1.0 * power_scale), 4)
		effect.ease_sprite_scale(
			sprite_cursor,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * power_scale),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * power_scale),
			4.0,
			4
		)
		burst_index = 0
		while burst_index < 4 do
			random_roll = effect.get_random_number_int(100) or random_roll
			if vm.imod(random_roll, 2) == 0 then
				effect.set_sprite_texture_rect(sprite_cursor + burst_index, 16.0, 96.0, 32.0, 32.0)
				effect.set_sprite_size(sprite_cursor + burst_index, 20.0, 20.0)
			else
				random_roll = effect.get_random_number_int(4) or random_roll
				effect.set_sprite_texture_rect(sprite_cursor + burst_index, vm.i32(vm.i32(random_roll * 20) + 48), 0, 20, 128)
				effect.set_sprite_size(sprite_cursor + burst_index, 4.0, 25.6)
				jitter_x = effect.get_random_number(6.2831855) or jitter_x
				jitter_x = vm.f32(jitter_x - vm.f32(3.1415927))
				effect.set_sprite_rotation(sprite_cursor + burst_index, jitter_x)
			end
			jitter_x = effect.get_random_number(4.0 + vm.f32(4.0 * power_scale)) or jitter_x
			jitter_x = vm.f32(jitter_x - vm.f32(vm.f32(4.0 + vm.f32(4.0 * power_scale)) / 2.0))
			jitter_y = effect.get_random_number(4.0 + vm.f32(4.0 * power_scale)) or jitter_y
			jitter_y = vm.f32(jitter_y - vm.f32(vm.f32(4.0 + vm.f32(4.0 * power_scale)) / 2.0))
			jitter_z = effect.get_random_number(4.0 + vm.f32(4.0 * power_scale)) or jitter_z
			jitter_z = vm.f32(jitter_z - vm.f32(vm.f32(4.0 + vm.f32(4.0 * power_scale)) / 2.0))
			effect.offset_sprite_position(sprite_cursor + burst_index, jitter_x, jitter_y, jitter_z)
			burst_index = burst_index + 1
		end
		sprite_cursor = sprite_cursor + 4
		if sprite_cursor >= 40 then
			sprite_cursor = 1
		end
		effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			effect.create_effect_1("モニカ魔法－雷ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, power_scale)
			break
		else
			frame = frame + 1
			vm.wait()
		end
	end
	step_length = 1.0
	facing_angle = effect.get_rotation_toward_7(bolt_x, bolt_y, bolt_z, target_x, target_y, target_z) or facing_angle
	do
		local out1, out2, out3 = effect.get_rotation_toward_9(bolt_x, bolt_y, bolt_z, target_x, target_y, target_z)
		bolt_yaw = out1 or bolt_yaw
		bolt_pitch = out2 or bolt_pitch
		bolt_roll = out3 or bolt_roll
	end
	bolt_yaw = effect.get_random_number(0.5235988) or bolt_yaw
	bolt_yaw = vm.f32(bolt_yaw + vm.f32(0.2617994))
	bolt_roll = 0.0
	do
		local out1, out2, out3 = effect.get_direction_vector(bolt_yaw, bolt_pitch, bolt_roll)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, step_length)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	sprite_cursor = 1
	frame = 0
	while frame < 90 do
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(bolt_x, bolt_y, bolt_z, step_x, step_y, step_z)
			bolt_x = out1 or bolt_x
			bolt_y = out2 or bolt_y
			bolt_z = out3 or bolt_z
		end
		if target_id >= 0 then
			do
				local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
		end
		do
			local out1, out2, _ = effect.get_rotation_toward_9(bolt_x, bolt_y, bolt_z, target_x, target_y, target_z)
			target_yaw = out1 or target_yaw
			target_pitch = out2 or target_pitch
		end
		is_aligned = effect.compare_angles(bolt_pitch, target_pitch, 1.6) or is_aligned
		if is_aligned == 0 then
			target_yaw = vm.f32(target_yaw - bolt_yaw)
			target_yaw = effect.wrap_angle(target_yaw) or target_yaw
			target_yaw = vm.f32(target_yaw / 6.0)
			bolt_yaw = vm.f32(bolt_yaw + target_yaw)
			bolt_yaw = effect.wrap_angle(bolt_yaw) or bolt_yaw
			target_pitch = vm.f32(target_pitch - bolt_pitch)
			target_pitch = effect.wrap_angle(target_pitch) or target_pitch
			target_pitch = vm.f32(target_pitch / 6.0)
			bolt_pitch = vm.f32(bolt_pitch + target_pitch)
			bolt_pitch = effect.wrap_angle(bolt_pitch) or bolt_pitch
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(bolt_yaw, bolt_pitch, bolt_roll)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, step_length)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		step_length = vm.f32(step_length * 2.0)
		if step_length > 16.0 then
			step_length = 16.0
		end
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(previous_x, previous_y, previous_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(trail_x, trail_y, trail_z, bolt_x, bolt_y, bolt_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(trail_x, trail_y, trail_z, 4)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		effect.spread_sprite_positions(0, current_x, current_y, current_z, -trail_x, -trail_y, -trail_z, 0.0, 0.0, 0.0, 1)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 1)
		effect.spread_sprite_positions(sprite_cursor, current_x, current_y, current_z, trail_x, trail_y, trail_z, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(sprite_cursor, 128.0, 128.0, 128.0, 64.0, 4)
		effect.ease_sprite_color(sprite_cursor, 128.0, 128.0, 128.0, -64.0, 6.0, 4)
		effect.set_sprite_blinking(sprite_cursor, 0.0, 0.0, 0.0, 64.0, 1.5707964, 4)
		effect.set_sprite_scale(sprite_cursor, 1.0 + vm.f32(1.0 * power_scale), 1.0 + vm.f32(1.0 * power_scale), 4)
		effect.ease_sprite_scale(
			sprite_cursor,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * power_scale),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * power_scale),
			4.0,
			4
		)
		burst_index = 0
		while burst_index < 4 do
			random_roll = effect.get_random_number_int(100) or random_roll
			if vm.imod(random_roll, 3) == 0 then
				effect.set_sprite_texture_rect(sprite_cursor + burst_index, 16.0, 96.0, 32.0, 32.0)
				effect.set_sprite_size(sprite_cursor + burst_index, 20.0, 20.0)
			else
				random_roll = effect.get_random_number_int(4) or random_roll
				effect.set_sprite_texture_rect(sprite_cursor + burst_index, vm.i32(vm.i32(random_roll * 20) + 48), 0, 20, 128)
				effect.set_sprite_size(sprite_cursor + burst_index, 4.0, 25.6)
				jitter_x = effect.get_random_number(6.2831855) or jitter_x
				jitter_x = vm.f32(jitter_x - vm.f32(3.1415927))
				effect.set_sprite_rotation(sprite_cursor + burst_index, jitter_x)
			end
			jitter_x = effect.get_random_number(4.0 + vm.f32(4.0 * power_scale)) or jitter_x
			jitter_x = vm.f32(jitter_x - vm.f32(vm.f32(4.0 + vm.f32(4.0 * power_scale)) / 2.0))
			jitter_y = effect.get_random_number(4.0 + vm.f32(4.0 * power_scale)) or jitter_y
			jitter_y = vm.f32(jitter_y - vm.f32(vm.f32(4.0 + vm.f32(4.0 * power_scale)) / 2.0))
			jitter_z = effect.get_random_number(4.0 + vm.f32(4.0 * power_scale)) or jitter_z
			jitter_z = vm.f32(jitter_z - vm.f32(vm.f32(4.0 + vm.f32(4.0 * power_scale)) / 2.0))
			effect.offset_sprite_position(sprite_cursor + burst_index, jitter_x, jitter_y, jitter_z)
			burst_index = burst_index + 1
		end
		sprite_cursor = sprite_cursor + 4
		if sprite_cursor >= 40 then
			sprite_cursor = 1
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, bolt_x, bolt_y, bolt_z)
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.create_effect_1("モニカ魔法－雷ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, power_scale)
			break
		else
			effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("モニカ魔法－雷ヒット")
				effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
				effect.set_effect_value_float(0, power_scale)
				break
			else
				frame = frame + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
	effect.set_sprite_visible(0, 0)
	frame = 0
	while frame < 10 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
