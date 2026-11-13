--!strict
--- Monica's ice magic bolt that homes toward its target, trailing ice sprites until it hits and spawns the ice hit effect.

local vm = require("@lib/vm")

local script = {}

--- Performs no setup for the ice bolt.
function script.setup() end

--- Flies a homing ice bolt from the caster toward the target while leaving frost sprites, then spawns the ice hit effect on impact.
function script.on_start()
	local caster_id: s32 = 0
	local target_id: s32 = 0
	local charge_level: f32 = 0
	local speed: f32 = 0
	local caster_yaw: f32 = 0
	local caster_x: f32 = 0
	local caster_y: f32 = 0
	local caster_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local bolt_x: f32 = 0
	local bolt_y: f32 = 0
	local bolt_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local distance_factor: f32 = 0
	local temp_value: f32 = 0
	local temp_value_y: f32 = 0
	local temp_value_z: f32 = 0
	local sprite_handle: s32 = 0
	local sprite_index: s32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local frame: s32 = 0
	local target_pitch: f32 = 0
	local target_yaw: f32 = 0
	local is_yaw_aligned: s32 = 0
	local trail_x: f32 = 0
	local trail_y: f32 = 0
	local trail_z: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local hit_result: s32 = 0
	caster_id = effect.get_owner_character() or caster_id
	target_id = effect.get_target_character() or target_id
	charge_level = effect.get_script_value_float(0) or charge_level
	charge_level = 0.0
	speed = vm.f32(8.0 + vm.f32(4.0 * charge_level))
	do
		local out1, out2, out3 = effect.get_scene_character_position(caster_id)
		caster_x = out1 or caster_x
		caster_y = out2 or caster_y
		caster_z = out3 or caster_z
	end
	caster_yaw = effect.get_scene_character_rotation_2(caster_id) or caster_yaw
	if target_id <= -1 then
		target_x = vm.f32(vm.f32(vm.sin(caster_yaw) * 300.0) + caster_x)
		target_y = vm.f32(20.0 + caster_y)
		target_z = vm.f32(vm.f32(vm.cos(caster_yaw) * 300.0) + caster_z)
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
		pitch = out1 or pitch
		yaw = out2 or yaw
		roll = out3 or roll
	end
	pitch = 0.0
	yaw = 0.0
	roll = 0.0
	if pitch == 0.0 and yaw == 0.0 and roll == 0.0 then
		distance_factor = vm.f32(0.4)
		if target_id > 0 then
			distance_factor = effect.get_distance_between(caster_x, caster_y, caster_z, target_x, target_y, target_z) or distance_factor
			distance_factor = vm.f32(distance_factor * vm.f32(0.001))
		end
		pitch = effect.get_random_number(vm.f32(-3.1415927) * distance_factor) or pitch
		yaw = effect.get_random_number(vm.f32(3.1415927) * distance_factor) or yaw
		yaw = vm.f32(vm.f32(yaw - vm.f32(0.5235988)) + caster_yaw)
		yaw = effect.wrap_angle(yaw) or yaw
		roll = 0.0
		do
			local out1, out2, out3 = effect.get_direction_vector(pitch, yaw, roll)
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
			local out1, out2, out3 = effect.copy_vector(pitch, yaw, roll)
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
	temp_value = vm.f32(vm.f32(1.0 + vm.f32(3.0 * charge_level)) + 1.0)
	effect.set_effect_character_scale(temp_value, temp_value, temp_value)
	sprite_handle = effect.allocate_sprites_2(28) or sprite_handle
	if sprite_handle == 0 then
		return
	end
	effect.set_sprite_texture("c02cold")
	effect.reset_sprites(0, 28)
	effect.set_sprite_visible(0, 1, 28)
	effect.set_sprite_blend_mode(0, 2, 28)
	effect.set_sprite_size(0, 6.0, 6.0, 28)
	effect.set_sprite_texture_rect(0, 0.0, 64.0, 64.0, 64.0, 28)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 28)
	sprite_index = 0
	frame = 0
	while frame < 120 do
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
		is_yaw_aligned = effect.compare_angles(yaw, target_yaw, 1.6) or is_yaw_aligned
		if is_yaw_aligned == 0 then
			target_pitch = vm.f32(target_pitch - pitch)
			target_pitch = effect.wrap_angle(target_pitch) or target_pitch
			target_pitch = vm.f32(target_pitch / 6.0)
			pitch = vm.f32(pitch + target_pitch)
			pitch = effect.wrap_angle(pitch) or pitch
			target_yaw = vm.f32(target_yaw - yaw)
			target_yaw = effect.wrap_angle(target_yaw) or target_yaw
			target_yaw = vm.f32(target_yaw / 6.0)
			yaw = vm.f32(yaw + target_yaw)
			yaw = effect.wrap_angle(yaw) or yaw
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(pitch, yaw, roll)
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
		effect.set_effect_character_position(bolt_x, bolt_y, bolt_z)
		effect.rotate_effect_character_toward(pitch + vm.f32(1.5707964), yaw, roll)
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
			local out1, out2, out3 = effect.divide_vector(trail_x, trail_y, trail_z, 2)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		effect.spread_sprite_positions(sprite_index, current_x, current_y, current_z, trail_x, trail_y, trail_z, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 92.0, 2)
		effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0, 5.0, 2)
		temp_value = vm.f32(1.0 + vm.f32(3.0 * charge_level))
		effect.set_sprite_scale(sprite_index, temp_value, temp_value, 2)
		for i = 0, 1 do
			temp_value = effect.get_random_number(1.0) or temp_value
			temp_value = vm.f32(vm.f32(temp_value + 3.0) + vm.f32(5.0 * charge_level))
			effect.ease_sprite_scale(sprite_index + i, temp_value, temp_value, 4.0)
			temp_value = effect.get_random_number(6.2831855) or temp_value
			temp_value = vm.f32(temp_value - vm.f32(3.1415927))
			effect.set_sprite_rotation(sprite_index + i, temp_value)
			temp_value = effect.get_random_number(1.0 + vm.f32(1.0 * charge_level)) or temp_value
			temp_value = vm.f32(temp_value - vm.f32(vm.f32(1.0 + vm.f32(1.0 * charge_level)) / 2.0))
			temp_value_y = effect.get_random_number(1.0 + vm.f32(1.0 * charge_level)) or temp_value_y
			temp_value_y = vm.f32(temp_value_y - vm.f32(vm.f32(1.0 + vm.f32(1.0 * charge_level)) / 2.0))
			temp_value_z = effect.get_random_number(1.0 + vm.f32(1.0 * charge_level)) or temp_value_z
			temp_value_z = vm.f32(temp_value_z - vm.f32(vm.f32(1.0 + vm.f32(1.0 * charge_level)) / 2.0))
			effect.set_sprite_velocity(sprite_index + i, temp_value, temp_value_y, temp_value_z)
		end
		sprite_index = sprite_index + 2
		if sprite_index >= 28 then
			sprite_index = 0
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, bolt_x, bolt_y, bolt_z)
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.create_effect_1("モニカ魔法－氷ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, charge_level)
			break
		else
			effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("モニカ魔法－氷ヒット")
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
	effect.set_effect_character_visible(0, 1, 0.06)
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
