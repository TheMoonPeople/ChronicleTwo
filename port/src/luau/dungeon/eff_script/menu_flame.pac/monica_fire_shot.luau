--!strict
--- Monica's fire magic effect that launches a homing fireball toward the target with a flame trail and spawns the hit effect on impact.

local vm = require("@lib/vm")

local script = {}

--- Performs no setup for the fire magic effect.
function script.setup() end

--- Steers a homing fireball from the caster toward the target, emitting flame trail sprites each frame until it hits.
function script.on_start()
	local user_id: s32 = 0
	local target_id: s32 = 0
	local charge_level: f32 = 0
	local scale: f32 = 0
	local caster_rotation: f32 = 0
	local caster_x: f32 = 0
	local caster_y: f32 = 0
	local caster_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local fireball_x: f32 = 0
	local fireball_y: f32 = 0
	local fireball_z: f32 = 0
	local heading_pitch: f32 = 0
	local heading_yaw: f32 = 0
	local heading_roll: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local spread_factor: f32 = 0
	local sprite_allocation: s32 = 0
	local trail_sprite_index: s32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local frame: s32 = 0
	local desired_pitch: f32 = 0
	local desired_yaw: f32 = 0
	local is_yaw_aligned: s32 = 0
	local segment_x: f32 = 0
	local segment_y: f32 = 0
	local segment_z: f32 = 0
	local trail_x: f32 = 0
	local trail_y: f32 = 0
	local trail_z: f32 = 0
	local random_value: f32 = 0
	local random_offset_y: f32 = 0
	local random_offset_z: f32 = 0
	local hit_result: s32 = 0
	user_id = effect.get_owner_character() or user_id
	target_id = effect.get_target_character() or target_id
	charge_level = effect.get_script_value_float(0) or charge_level
	charge_level = 0.0
	scale = vm.f32(8.0 + vm.f32(4.0 * charge_level))
	do
		local out1, out2, out3 = effect.get_scene_character_position(user_id)
		caster_x = out1 or caster_x
		caster_y = out2 or caster_y
		caster_z = out3 or caster_z
	end
	caster_rotation = effect.get_scene_character_rotation_2(user_id) or caster_rotation
	if target_id <= -1 then
		target_x = vm.f32(vm.f32(vm.sin(caster_rotation) * 300.0) + caster_x)
		target_y = vm.f32(20.0 + caster_y)
		target_z = vm.f32(vm.f32(vm.cos(caster_rotation) * 300.0) + caster_z)
	else
		do
			local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
	end
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		fireball_x = out1 or fireball_x
		fireball_y = out2 or fireball_y
		fireball_z = out3 or fireball_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		heading_pitch = out1 or heading_pitch
		heading_yaw = out2 or heading_yaw
		heading_roll = out3 or heading_roll
	end
	heading_pitch = 0.0
	heading_yaw = 0.0
	heading_roll = 0.0
	if heading_pitch == 0.0 and heading_yaw == 0.0 and heading_roll == 0.0 then
		spread_factor = vm.f32(0.4)
		if target_id > 0 then
			spread_factor = effect.get_distance_between(caster_x, caster_y, caster_z, target_x, target_y, target_z) or spread_factor
			spread_factor = vm.f32(spread_factor * vm.f32(0.001))
		end
		heading_pitch = effect.get_random_number(vm.f32(-3.1415927) * spread_factor) or heading_pitch
		heading_yaw = effect.get_random_number(vm.f32(3.1415927) * spread_factor) or heading_yaw
		heading_yaw = vm.f32(vm.f32(heading_yaw - vm.f32(0.5235988)) + caster_rotation)
		heading_yaw = effect.wrap_angle(heading_yaw) or heading_yaw
		heading_roll = 0.0
		do
			local out1, out2, out3 = effect.get_direction_vector(heading_pitch, heading_yaw, heading_roll)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, scale)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
	else
		do
			local out1, out2, out3 = effect.copy_vector(heading_pitch, heading_yaw, heading_roll)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, scale)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
	end
	sprite_allocation = effect.allocate_sprites_2(52) or sprite_allocation
	if sprite_allocation == 0 then
		return
	end
	effect.set_sprite_texture("c02flame")
	effect.reset_sprites(0, 52)
	effect.set_sprite_visible(0, 1, 52)
	effect.set_sprite_blend_mode(0, 2, 52)
	effect.set_sprite_size(0, 10.0, 10.0, 52)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 52)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 52)
	trail_sprite_index = 4
	frame = 0
	while frame < 120 do
		do
			local out1, out2, out3 = effect.copy_vector(fireball_x, fireball_y, fireball_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(fireball_x, fireball_y, fireball_z, velocity_x, velocity_y, velocity_z)
			fireball_x = out1 or fireball_x
			fireball_y = out2 or fireball_y
			fireball_z = out3 or fireball_z
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
			local out1, out2, _ = effect.get_rotation_toward_9(fireball_x, fireball_y, fireball_z, target_x, target_y, target_z)
			desired_pitch = out1 or desired_pitch
			desired_yaw = out2 or desired_yaw
		end
		is_yaw_aligned = effect.compare_angles(heading_yaw, desired_yaw, 1.6) or is_yaw_aligned
		if is_yaw_aligned == 0 then
			desired_pitch = vm.f32(desired_pitch - heading_pitch)
			desired_pitch = effect.wrap_angle(desired_pitch) or desired_pitch
			desired_pitch = vm.f32(desired_pitch / 6.0)
			heading_pitch = vm.f32(heading_pitch + desired_pitch)
			heading_pitch = effect.wrap_angle(heading_pitch) or heading_pitch
			desired_yaw = vm.f32(desired_yaw - heading_yaw)
			desired_yaw = effect.wrap_angle(desired_yaw) or desired_yaw
			desired_yaw = vm.f32(desired_yaw / 6.0)
			heading_yaw = vm.f32(heading_yaw + desired_yaw)
			heading_yaw = effect.wrap_angle(heading_yaw) or heading_yaw
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(heading_pitch, heading_yaw, heading_roll)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, scale)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(fireball_x, fireball_y, fireball_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(previous_x, previous_y, previous_z)
			segment_x = out1 or segment_x
			segment_y = out2 or segment_y
			segment_z = out3 or segment_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(segment_x, segment_y, segment_z, fireball_x, fireball_y, fireball_z)
			segment_x = out1 or segment_x
			segment_y = out2 or segment_y
			segment_z = out3 or segment_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(segment_x, segment_y, segment_z, 2)
			segment_x = out1 or segment_x
			segment_y = out2 or segment_y
			segment_z = out3 or segment_z
		end
		effect.set_sprite_texture_rect(0, 0.0, 64.0, 64.0, 64.0, 4)
		effect.spread_sprite_positions(0, trail_x, trail_y, trail_z, -segment_x, -segment_y, -segment_z, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 4)
		effect.ease_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 4.0, 4)
		effect.spread_sprite_scales(0, 1.5 + vm.f32(1.5 * charge_level), 1.5 + vm.f32(1.5 * charge_level), 0.1, 0.1, 0.0, 0.0, 4)
		effect.set_sprite_blend_mode(trail_sprite_index, 2, 2)
		effect.set_sprite_texture_rect(trail_sprite_index, 0.0, 0.0, 64.0, 64.0, 2)
		effect.spread_sprite_positions(trail_sprite_index, trail_x, trail_y, trail_z, segment_x, segment_y, segment_z, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(trail_sprite_index, 128.0, 128.0, 128.0, 128.0, 2)
		effect.ease_sprite_color(trail_sprite_index, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.set_sprite_scale(trail_sprite_index, 1.0 + vm.f32(1.0 * charge_level), 1.0 + vm.f32(1.0 * charge_level), 2)
		effect.set_sprite_blend_mode(trail_sprite_index + 2, 3, 2)
		effect.set_sprite_texture_rect(trail_sprite_index + 2, 64.0, 64.0, 64.0, 64.0, 2)
		do
			local out1, out2, out3 = effect.scale_vector(segment_x, segment_y, segment_z, 2.0)
			segment_x = out1 or segment_x
			segment_y = out2 or segment_y
			segment_z = out3 or segment_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(trail_x, trail_y, trail_z, segment_x, segment_y, segment_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		effect.spread_sprite_positions(trail_sprite_index + 2, trail_x, trail_y, trail_z, segment_x, segment_y, segment_z, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(trail_sprite_index + 2, 128.0, 128.0, 128.0, 32.0, 2)
		effect.ease_sprite_color(trail_sprite_index + 2, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.set_sprite_scale(trail_sprite_index + 2, 1.0 + vm.f32(1.0 * charge_level), 1.0 + vm.f32(1.0 * charge_level), 2)
		for index = 0, 3 do
			random_value = effect.get_random_number(3.1415927) or random_value
			random_value = vm.f32(vm.f32(random_value + 2.0) + vm.f32(2.0 * charge_level))
			effect.ease_sprite_scale(trail_sprite_index + index, random_value, random_value, 4.0)
			random_value = effect.get_random_number(6.2831855) or random_value
			random_value = vm.f32(random_value - vm.f32(3.1415927))
			effect.set_sprite_rotation(trail_sprite_index + index, random_value)
			random_value = effect.get_random_number(1.0 + vm.f32(1.0 * charge_level)) or random_value
			random_value = vm.f32(random_value - vm.f32(vm.f32(1.0 + vm.f32(1.0 * charge_level)) / 2.0))
			random_offset_y = effect.get_random_number(1.0 + vm.f32(1.0 * charge_level)) or random_offset_y
			random_offset_y = vm.f32(random_offset_y - vm.f32(vm.f32(1.0 + vm.f32(1.0 * charge_level)) / 2.0))
			random_offset_z = effect.get_random_number(1.0 + vm.f32(1.0 * charge_level)) or random_offset_z
			random_offset_z = vm.f32(random_offset_z - vm.f32(vm.f32(1.0 + vm.f32(1.0 * charge_level)) / 2.0))
			effect.set_sprite_velocity(trail_sprite_index + index, random_value, random_offset_y, random_offset_z)
		end
		trail_sprite_index = trail_sprite_index + 4
		if trail_sprite_index >= 52 then
			trail_sprite_index = 4
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, fireball_x, fireball_y, fireball_z)
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.create_effect_1("モニカ魔法－火ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, charge_level)
			break
		else
			effect.set_collision_primitive_shape(fireball_x, fireball_y, fireball_z, 10.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("モニカ魔法－火ヒット")
				effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
				effect.set_effect_value_float(0, charge_level)
				break
			else
				frame = frame + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
	frame = 0
	while frame < 20 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Performs no cleanup when the fire magic effect ends.
function script.on_finish() end

return script
