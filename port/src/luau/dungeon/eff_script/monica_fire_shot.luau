--!strict
--- Monica's fire magic projectile that homes toward its target leaving a flame trail.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Flies a fire bolt toward its target, steering gradually while leaving a flame trail, and creates the fire hit effect on impact.
function script.on_start()
	local owner_id: s32 = 0
	local target_id: s32 = 0
	local power: f32 = 0
	local speed: f32 = 0
	local owner_yaw: f32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local bolt_x: f32 = 0
	local bolt_y: f32 = 0
	local bolt_z: f32 = 0
	local bolt_pitch: f32 = 0
	local bolt_yaw: f32 = 0
	local bolt_roll: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local turn_range: f32 = 0
	local sprites_allocated: s32 = 0
	local sprite_index: s32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local frame: s32 = 0
	local target_pitch: f32 = 0
	local target_yaw: f32 = 0
	local is_angle_aligned: s32 = 0
	local half_step_x: f32 = 0
	local half_step_y: f32 = 0
	local half_step_z: f32 = 0
	local trail_x: f32 = 0
	local trail_y: f32 = 0
	local trail_z: f32 = 0
	local random_x: f32 = 0
	local random_y: f32 = 0
	local random_z: f32 = 0
	local hit_result: s32 = 0
	owner_id = effect.get_owner_character() or owner_id
	target_id = effect.get_target_character() or target_id
	power = 0.0
	power = effect.get_script_value_float(0) or power
	speed = vm.f32(8.0 + vm.f32(4.0 * power))
	do
		local out1, out2, out3 = effect.get_scene_character_position(owner_id)
		owner_x = out1 or owner_x
		owner_y = out2 or owner_y
		owner_z = out3 or owner_z
	end
	owner_yaw = effect.get_scene_character_rotation_2(owner_id) or owner_yaw
	if target_id <= -1 then
		target_x = vm.f32(vm.f32(vm.sin(owner_yaw) * 300.0) + owner_x)
		target_y = vm.f32(20.0 + owner_y)
		target_z = vm.f32(vm.f32(vm.cos(owner_yaw) * 300.0) + owner_z)
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
		bolt_x = out1 or bolt_x
		bolt_y = out2 or bolt_y
		bolt_z = out3 or bolt_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		bolt_pitch = out1 or bolt_pitch
		bolt_yaw = out2 or bolt_yaw
		bolt_roll = out3 or bolt_roll
	end
	bolt_pitch = 0.0
	bolt_yaw = 0.0
	bolt_roll = 0.0
	if bolt_pitch == 0.0 and bolt_yaw == 0.0 and bolt_roll == 0.0 then
		turn_range = vm.f32(0.4)
		if target_id > 0 then
			turn_range = effect.get_distance_between(owner_x, owner_y, owner_z, target_x, target_y, target_z) or turn_range
			turn_range = vm.f32(vm.f32(0.4) - vm.f32(vm.f32(vm.fdiv(vm.f32(0.4), turn_range)) * 10))
		end
		bolt_pitch = effect.get_random_number(vm.f32(-3.1415927) * turn_range) or bolt_pitch
		bolt_yaw = effect.get_random_number(vm.f32(3.1415927) * turn_range) or bolt_yaw
		bolt_yaw = vm.f32(vm.f32(bolt_yaw - vm.f32(0.5235988)) + owner_yaw)
		bolt_yaw = effect.wrap_angle(bolt_yaw) or bolt_yaw
		bolt_roll = 0.0
		do
			local out1, out2, out3 = effect.get_direction_vector(bolt_pitch, bolt_yaw, bolt_roll)
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
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
	else
		do
			local out1, out2, out3 = effect.copy_vector(bolt_pitch, bolt_yaw, bolt_roll)
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
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
	end
	sprites_allocated = effect.allocate_sprites_2(52) or sprites_allocated
	if sprites_allocated == 0 then
		return
	end
	effect.set_sprite_texture("c02flame")
	effect.reset_sprites(0, 52)
	effect.set_sprite_visible(0, 1, 52)
	effect.set_sprite_blend_mode(0, 2, 52)
	effect.set_sprite_size(0, 10.0, 10.0, 52)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 52)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 52)
	sprite_index = 4
	frame = 0
	while frame < 60 do
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(bolt_x, bolt_y, bolt_z, velocity_x, velocity_y, velocity_z)
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
			target_pitch = out1 or target_pitch
			target_yaw = out2 or target_yaw
		end
		is_angle_aligned = effect.compare_angles(bolt_yaw, target_yaw, 1.6) or is_angle_aligned
		if is_angle_aligned == 0 then
			target_pitch = vm.f32(target_pitch - bolt_pitch)
			target_pitch = effect.wrap_angle(target_pitch) or target_pitch
			target_pitch = vm.f32(target_pitch / 6.0)
			bolt_pitch = vm.f32(bolt_pitch + target_pitch)
			bolt_pitch = effect.wrap_angle(bolt_pitch) or bolt_pitch
			target_yaw = vm.f32(target_yaw - bolt_yaw)
			target_yaw = effect.wrap_angle(target_yaw) or target_yaw
			target_yaw = vm.f32(target_yaw / 6.0)
			bolt_yaw = vm.f32(bolt_yaw + target_yaw)
			bolt_yaw = effect.wrap_angle(bolt_yaw) or bolt_yaw
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(bolt_pitch, bolt_yaw, bolt_roll)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(previous_x, previous_y, previous_z)
			half_step_x = out1 or half_step_x
			half_step_y = out2 or half_step_y
			half_step_z = out3 or half_step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(half_step_x, half_step_y, half_step_z, bolt_x, bolt_y, bolt_z)
			half_step_x = out1 or half_step_x
			half_step_y = out2 or half_step_y
			half_step_z = out3 or half_step_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(half_step_x, half_step_y, half_step_z, 2)
			half_step_x = out1 or half_step_x
			half_step_y = out2 or half_step_y
			half_step_z = out3 or half_step_z
		end
		effect.set_sprite_texture_rect(0, 0.0, 64.0, 64.0, 64.0, 4)
		effect.spread_sprite_positions(0, trail_x, trail_y, trail_z, -half_step_x, -half_step_y, -half_step_z, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 4)
		effect.ease_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 4.0, 4)
		effect.spread_sprite_scales(0, 1.5 + vm.f32(1.5 * power), 1.5 + vm.f32(1.5 * power), 0.1, 0.1, 0.0, 0.0, 4)
		effect.set_sprite_blend_mode(sprite_index, 2, 2)
		effect.set_sprite_texture_rect(sprite_index, 0.0, 0.0, 64.0, 64.0, 2)
		effect.spread_sprite_positions(sprite_index, trail_x, trail_y, trail_z, half_step_x, half_step_y, half_step_z, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 128.0, 2)
		effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.set_sprite_scale(sprite_index, 1.0 + vm.f32(1.0 * power), 1.0 + vm.f32(1.0 * power), 2)
		effect.set_sprite_blend_mode(sprite_index + 2, 3, 2)
		effect.set_sprite_texture_rect(sprite_index + 2, 64.0, 64.0, 64.0, 64.0, 2)
		do
			local out1, out2, out3 = effect.scale_vector(half_step_x, half_step_y, half_step_z, 2.0)
			half_step_x = out1 or half_step_x
			half_step_y = out2 or half_step_y
			half_step_z = out3 or half_step_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(trail_x, trail_y, trail_z, half_step_x, half_step_y, half_step_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		effect.spread_sprite_positions(sprite_index + 2, trail_x, trail_y, trail_z, half_step_x, half_step_y, half_step_z, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(sprite_index + 2, 128.0, 128.0, 128.0, 32.0, 2)
		effect.ease_sprite_color(sprite_index + 2, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.set_sprite_scale(sprite_index + 2, 1.0 + vm.f32(1.0 * power), 1.0 + vm.f32(1.0 * power), 2)
		for i = 0, 3 do
			random_x = effect.get_random_number(3.1415927) or random_x
			random_x = vm.f32(vm.f32(random_x + 2.0) + vm.f32(2.0 * power))
			effect.ease_sprite_scale(sprite_index + i, random_x, random_x, 4.0)
			random_x = effect.get_random_number(6.2831855) or random_x
			random_x = vm.f32(random_x - vm.f32(3.1415927))
			effect.set_sprite_rotation(sprite_index + i, random_x)
			random_x = effect.get_random_number(1.0 + vm.f32(1.0 * power)) or random_x
			random_x = vm.f32(random_x - vm.f32(vm.f32(1.0 + vm.f32(1.0 * power)) / 2.0))
			random_y = effect.get_random_number(1.0 + vm.f32(1.0 * power)) or random_y
			random_y = vm.f32(random_y - vm.f32(vm.f32(1.0 + vm.f32(1.0 * power)) / 2.0))
			random_z = effect.get_random_number(1.0 + vm.f32(1.0 * power)) or random_z
			random_z = vm.f32(random_z - vm.f32(vm.f32(1.0 + vm.f32(1.0 * power)) / 2.0))
			effect.set_sprite_velocity(sprite_index + i, random_x, random_y, random_z)
		end
		sprite_index = sprite_index + 4
		if sprite_index >= 52 then
			sprite_index = 4
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, bolt_x, bolt_y, bolt_z)
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.create_effect_1("モニカ魔法－火ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, power)
			break
		else
			effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("モニカ魔法－火ヒット")
				effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
				effect.set_effect_value_float(0, power)
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
--- Does nothing when the effect ends.
function script.on_finish() end

return script
