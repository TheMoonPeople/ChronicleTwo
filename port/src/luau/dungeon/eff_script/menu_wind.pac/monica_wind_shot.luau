--!strict
--- Monica's wind magic projectile that curves toward its target, leaving a trail of wind sprites until it hits.

local vm = require("@lib/vm")

local script = {}

--- Performs no setup for the wind projectile.
function script.setup() end

--- Launches the homing wind projectile, animates its trail and spawns the hit effect on collision.
function script.on_start()
	local caster_id: s32 = 0
	local target_id: s32 = 0
	local size_boost: f32 = 0
	local sprite_angle: f32 = 0
	local yaw: f32 = 0
	local caster_x: f32 = 0
	local caster_y: f32 = 0
	local caster_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local projectile_x: f32 = 0
	local projectile_y: f32 = 0
	local projectile_z: f32 = 0
	local heading_yaw: f32 = 0
	local heading_pitch: f32 = 0
	local heading_roll: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local random_angle_offset: f32 = 0
	local launch_x: f32 = 0
	local launch_y: f32 = 0
	local launch_z: f32 = 0
	local sprite_allocation: s32 = 0
	local trail_length_x: f32 = 0
	local trail_length_y: f32 = 0
	local trail_length_z: f32 = 0
	local trail_start_x: f32 = 0
	local trail_start_y: f32 = 0
	local trail_start_z: f32 = 0
	local frame_count: s32 = 0
	local sprite_index: s32 = 0
	local collision_result: s32 = 0
	local step_length: f32 = 0
	local desired_yaw: f32 = 0
	local desired_pitch: f32 = 0
	local is_aligned: s32 = 0
	caster_id = effect.get_owner_character() or caster_id
	target_id = effect.get_target_character() or target_id
	size_boost = effect.get_script_value_float(0) or size_boost
	size_boost = 0.0
	sprite_angle = 0.0
	do
		local out1, out2, out3 = effect.get_scene_character_position(caster_id)
		caster_x = out1 or caster_x
		caster_y = out2 or caster_y
		caster_z = out3 or caster_z
	end
	yaw = effect.get_scene_character_rotation_2(caster_id) or yaw
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		projectile_x = out1 or projectile_x
		projectile_y = out2 or projectile_y
		projectile_z = out3 or projectile_z
	end
	if target_id <= -1 then
		target_x = vm.f32(vm.f32(vm.sin(yaw) * 400.0) + caster_x)
		target_y = vm.f32(20.0 + caster_y)
		target_z = vm.f32(vm.f32(vm.cos(yaw) * 400.0) + caster_z)
	else
		do
			local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
	end
	random_angle_offset = effect.get_random_number(2.0943952) or random_angle_offset
	random_angle_offset = vm.f32(random_angle_offset - vm.f32(1.0471976))
	yaw = vm.f32(yaw + random_angle_offset)
	yaw = effect.wrap_angle(yaw) or yaw
	launch_x = vm.f32(vm.f32(vm.sin(yaw) * 30.0) + caster_x)
	launch_y = vm.f32(40.0 + caster_y)
	launch_z = vm.f32(vm.f32(vm.cos(yaw) * 30.0) + caster_z)
	yaw = effect.get_scene_character_rotation_2(caster_id) or yaw
	sprite_allocation = effect.allocate_sprites_2(20) or sprite_allocation
	if sprite_allocation == 0 then
		return
	end
	effect.set_sprite_texture("c02wind")
	effect.reset_sprites(0, 20)
	effect.set_sprite_blend_mode(0, 2, 20)
	effect.set_sprite_visible(0, 1, 20)
	effect.set_sprite_size(0, 20.0, 20.0, 20)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 20)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 20)
	sprite_index = 0
	frame_count = 0
	while frame_count < 10 do
		do
			local out1, out2, out3 = effect.copy_vector(launch_x, launch_y, launch_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, projectile_x, projectile_y, projectile_z)
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
			local out1, out2, out3 = effect.copy_vector(projectile_x, projectile_y, projectile_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(projectile_x, projectile_y, projectile_z, step_x, step_y, step_z)
			projectile_x = out1 or projectile_x
			projectile_y = out2 or projectile_y
			projectile_z = out3 or projectile_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(projectile_x, projectile_y, projectile_z)
			trail_start_x = out1 or trail_start_x
			trail_start_y = out2 or trail_start_y
			trail_start_z = out3 or trail_start_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(previous_x, previous_y, previous_z)
			trail_length_x = out1 or trail_length_x
			trail_length_y = out2 or trail_length_y
			trail_length_z = out3 or trail_length_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(trail_length_x, trail_length_y, trail_length_z, projectile_x, projectile_y, projectile_z)
			trail_length_x = out1 or trail_length_x
			trail_length_y = out2 or trail_length_y
			trail_length_z = out3 or trail_length_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(trail_length_x, trail_length_y, trail_length_z, 2)
			trail_length_x = out1 or trail_length_x
			trail_length_y = out2 or trail_length_y
			trail_length_z = out3 or trail_length_z
		end
		effect.spread_sprite_positions(sprite_index, trail_start_x, trail_start_y, trail_start_z, trail_length_x, trail_length_y, trail_length_z, 0.0, 0.0, 0.0, 2)
		effect.spread_sprite_colors(sprite_index, 128.0, 128.0, 128.0, 128.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 2)
		effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0, 6.0, 2)
		effect.spread_sprite_scales(sprite_index, 1.0 + vm.f32(1.0 * size_boost), 1.0 + vm.f32(1.0 * size_boost), 0.0, -0.04, 0.0, 0.0, 2)
		effect.ease_sprite_scale(
			sprite_index,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * size_boost),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * size_boost),
			4.0,
			2
		)
		effect.spread_sprite_rotations(sprite_index, sprite_angle, -0.6, 0.0, 2)
		sprite_angle = vm.f32(sprite_angle + vm.f32(1.2))
		sprite_angle = effect.wrap_angle(sprite_angle) or sprite_angle
		sprite_index = sprite_index + 2
		if sprite_index >= 20 then
			sprite_index = 0
		end
		effect.set_collision_primitive_shape(projectile_x, projectile_y, projectile_z, 10.0)
		collision_result = effect.get_collision_primitive_hit_count() or collision_result
		if collision_result > 0 then
			effect.create_effect_1("モニカ魔法－風ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, size_boost)
			break
		else
			frame_count = frame_count + 1
			vm.wait()
		end
	end
	step_length = 1.0
	yaw = effect.get_rotation_toward_7(projectile_x, projectile_y, projectile_z, target_x, target_y, target_z) or yaw
	do
		local out1, out2, out3 = effect.get_rotation_toward_9(projectile_x, projectile_y, projectile_z, target_x, target_y, target_z)
		heading_yaw = out1 or heading_yaw
		heading_pitch = out2 or heading_pitch
		heading_roll = out3 or heading_roll
	end
	heading_yaw = effect.get_random_number(0.5235988) or heading_yaw
	heading_yaw = vm.f32(heading_yaw + vm.f32(0.2617994))
	heading_roll = 0.0
	do
		local out1, out2, out3 = effect.get_direction_vector(heading_yaw, heading_pitch, heading_roll)
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
	sprite_index = 0
	frame_count = 0
	while frame_count < 90 do
		do
			local out1, out2, out3 = effect.copy_vector(projectile_x, projectile_y, projectile_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(projectile_x, projectile_y, projectile_z, step_x, step_y, step_z)
			projectile_x = out1 or projectile_x
			projectile_y = out2 or projectile_y
			projectile_z = out3 or projectile_z
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
			local out1, out2, _ = effect.get_rotation_toward_9(projectile_x, projectile_y, projectile_z, target_x, target_y, target_z)
			desired_yaw = out1 or desired_yaw
			desired_pitch = out2 or desired_pitch
		end
		is_aligned = effect.compare_angles(heading_pitch, desired_pitch, 1.6) or is_aligned
		if is_aligned == 0 then
			desired_yaw = vm.f32(desired_yaw - heading_yaw)
			desired_yaw = effect.wrap_angle(desired_yaw) or desired_yaw
			desired_yaw = vm.f32(desired_yaw / 6.0)
			heading_yaw = vm.f32(heading_yaw + desired_yaw)
			heading_yaw = effect.wrap_angle(heading_yaw) or heading_yaw
			desired_pitch = vm.f32(desired_pitch - heading_pitch)
			desired_pitch = effect.wrap_angle(desired_pitch) or desired_pitch
			desired_pitch = vm.f32(desired_pitch / 6.0)
			heading_pitch = vm.f32(heading_pitch + desired_pitch)
			heading_pitch = effect.wrap_angle(heading_pitch) or heading_pitch
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(heading_yaw, heading_pitch, heading_roll)
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
			local out1, out2, out3 = effect.copy_vector(projectile_x, projectile_y, projectile_z)
			trail_start_x = out1 or trail_start_x
			trail_start_y = out2 or trail_start_y
			trail_start_z = out3 or trail_start_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(previous_x, previous_y, previous_z)
			trail_length_x = out1 or trail_length_x
			trail_length_y = out2 or trail_length_y
			trail_length_z = out3 or trail_length_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(trail_length_x, trail_length_y, trail_length_z, projectile_x, projectile_y, projectile_z)
			trail_length_x = out1 or trail_length_x
			trail_length_y = out2 or trail_length_y
			trail_length_z = out3 or trail_length_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(trail_length_x, trail_length_y, trail_length_z, 2)
			trail_length_x = out1 or trail_length_x
			trail_length_y = out2 or trail_length_y
			trail_length_z = out3 or trail_length_z
		end
		effect.spread_sprite_positions(sprite_index, trail_start_x, trail_start_y, trail_start_z, trail_length_x, trail_length_y, trail_length_z, 0.0, 0.0, 0.0, 2)
		effect.spread_sprite_colors(sprite_index, 128.0, 128.0, 128.0, 128.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 2)
		effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0, 6.0, 2)
		effect.spread_sprite_scales(sprite_index, 1.0 + vm.f32(1.0 * size_boost), 1.0 + vm.f32(1.0 * size_boost), 0.0, -0.04, 0.0, 0.0, 2)
		effect.ease_sprite_scale(
			sprite_index,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * size_boost),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * size_boost),
			4.0,
			2
		)
		effect.spread_sprite_rotations(sprite_index, sprite_angle, -0.6, 0.0, 2)
		sprite_angle = vm.f32(sprite_angle + vm.f32(1.2))
		sprite_angle = effect.wrap_angle(sprite_angle) or sprite_angle
		sprite_index = sprite_index + 2
		if sprite_index >= 20 then
			sprite_index = 0
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, projectile_x, projectile_y, projectile_z)
			collision_result = out4 or collision_result
		end
		if collision_result >= 0 then
			break
		else
			effect.set_collision_primitive_shape(projectile_x, projectile_y, projectile_z, 10.0)
			collision_result = effect.get_collision_primitive_hit_count() or collision_result
			if collision_result > 0 then
				effect.create_effect_1("モニカ魔法－風ヒット")
				effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
				effect.set_effect_value_float(0, size_boost)
				break
			else
				frame_count = frame_count + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
	frame_count = 0
	while frame_count < 30 do
		frame_count = frame_count + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
