--!strict
--- Flies Monica's fire magic bolt from the owner toward the target, trailing flame sprites until it hits and spawns the fire hit effect.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Steers the fire bolt toward the target each frame, leaving flame sprites, and spawns the fire hit effect on impact.
function script.on_start()
	local owner_id: s32 = 0
	local target_id: s32 = 0
	local charge_ratio: f32 = 0
	local speed: f32 = 0
	local facing_angle: f32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local aim_x: f32 = 0
	local aim_y: f32 = 0
	local aim_z: f32 = 0
	local bolt_x: f32 = 0
	local bolt_y: f32 = 0
	local bolt_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local spread: f32 = 0
	local sprites_allocated: s32 = 0
	local sprite_index: s32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local frame: s32 = 0
	local target_pitch: f32 = 0
	local target_yaw: f32 = 0
	local angle_mismatch: s32 = 0
	local half_step_x: f32 = 0
	local half_step_y: f32 = 0
	local half_step_z: f32 = 0
	local sprite_origin_x: f32 = 0
	local sprite_origin_y: f32 = 0
	local sprite_origin_z: f32 = 0
	local scratch_value: f32 = 0
	local sprite_velocity_y: f32 = 0
	local sprite_velocity_z: f32 = 0
	local hit_result: s32 = 0
	owner_id = effect.get_owner_character() or owner_id
	target_id = effect.get_target_character() or target_id
	charge_ratio = 0.0
	charge_ratio = effect.get_script_value_float(0) or charge_ratio
	speed = vm.f32(8.0 + vm.f32(4.0 * charge_ratio))
	do
		local out1, out2, out3 = effect.get_scene_character_position(owner_id)
		owner_x = out1 or owner_x
		owner_y = out2 or owner_y
		owner_z = out3 or owner_z
	end
	facing_angle = effect.get_scene_character_rotation_2(owner_id) or facing_angle
	if target_id <= -1 then
		aim_x = vm.f32(vm.f32(vm.sin(facing_angle) * 300.0) + owner_x)
		aim_y = vm.f32(20.0 + owner_y)
		aim_z = vm.f32(vm.f32(vm.cos(facing_angle) * 300.0) + owner_z)
	else
		do
			local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
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
		spread = vm.f32(0.4)
		if target_id > 0 then
			spread = effect.get_distance_between(owner_x, owner_y, owner_z, aim_x, aim_y, aim_z) or spread
			spread = vm.f32(vm.f32(0.4) - vm.f32(vm.f32(vm.fdiv(vm.f32(0.4), spread)) * 10))
		end
		pitch = effect.get_random_number(vm.f32(-3.1415927) * spread) or pitch
		yaw = effect.get_random_number(vm.f32(3.1415927) * spread) or yaw
		yaw = vm.f32(vm.f32(yaw - vm.f32(0.5235988)) + facing_angle)
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
				aim_x = out1 or aim_x
				aim_y = out2 or aim_y
				aim_z = out3 or aim_z
			end
		end
		do
			local out1, out2, _ = effect.get_rotation_toward_9(bolt_x, bolt_y, bolt_z, aim_x, aim_y, aim_z)
			target_pitch = out1 or target_pitch
			target_yaw = out2 or target_yaw
		end
		angle_mismatch = effect.compare_angles(yaw, target_yaw, 1.6) or angle_mismatch
		if angle_mismatch == 0 then
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
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			sprite_origin_x = out1 or sprite_origin_x
			sprite_origin_y = out2 or sprite_origin_y
			sprite_origin_z = out3 or sprite_origin_z
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
		effect.spread_sprite_positions(0, sprite_origin_x, sprite_origin_y, sprite_origin_z, -half_step_x, -half_step_y, -half_step_z, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 4)
		effect.ease_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 4.0, 4)
		effect.spread_sprite_scales(0, 1.5 + vm.f32(1.5 * charge_ratio), 1.5 + vm.f32(1.5 * charge_ratio), 0.1, 0.1, 0.0, 0.0, 4)
		effect.set_sprite_blend_mode(sprite_index, 2, 2)
		effect.set_sprite_texture_rect(sprite_index, 0.0, 0.0, 64.0, 64.0, 2)
		effect.spread_sprite_positions(sprite_index, sprite_origin_x, sprite_origin_y, sprite_origin_z, half_step_x, half_step_y, half_step_z, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 128.0, 2)
		effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.set_sprite_scale(sprite_index, 1.0 + vm.f32(1.0 * charge_ratio), 1.0 + vm.f32(1.0 * charge_ratio), 2)
		effect.set_sprite_blend_mode(sprite_index + 2, 3, 2)
		effect.set_sprite_texture_rect(sprite_index + 2, 64.0, 64.0, 64.0, 64.0, 2)
		do
			local out1, out2, out3 = effect.scale_vector(half_step_x, half_step_y, half_step_z, 2.0)
			half_step_x = out1 or half_step_x
			half_step_y = out2 or half_step_y
			half_step_z = out3 or half_step_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(sprite_origin_x, sprite_origin_y, sprite_origin_z, half_step_x, half_step_y, half_step_z)
			sprite_origin_x = out1 or sprite_origin_x
			sprite_origin_y = out2 or sprite_origin_y
			sprite_origin_z = out3 or sprite_origin_z
		end
		effect.spread_sprite_positions(sprite_index + 2, sprite_origin_x, sprite_origin_y, sprite_origin_z, half_step_x, half_step_y, half_step_z, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(sprite_index + 2, 128.0, 128.0, 128.0, 32.0, 2)
		effect.ease_sprite_color(sprite_index + 2, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.set_sprite_scale(sprite_index + 2, 1.0 + vm.f32(1.0 * charge_ratio), 1.0 + vm.f32(1.0 * charge_ratio), 2)
		for i = 0, 3 do
			scratch_value = effect.get_random_number(3.1415927) or scratch_value
			scratch_value = vm.f32(vm.f32(scratch_value + 2.0) + vm.f32(2.0 * charge_ratio))
			effect.ease_sprite_scale(sprite_index + i, scratch_value, scratch_value, 4.0)
			scratch_value = effect.get_random_number(6.2831855) or scratch_value
			scratch_value = vm.f32(scratch_value - vm.f32(3.1415927))
			effect.set_sprite_rotation(sprite_index + i, scratch_value)
			scratch_value = effect.get_random_number(1.0 + vm.f32(1.0 * charge_ratio)) or scratch_value
			scratch_value = vm.f32(scratch_value - vm.f32(vm.f32(1.0 + vm.f32(1.0 * charge_ratio)) / 2.0))
			sprite_velocity_y = effect.get_random_number(1.0 + vm.f32(1.0 * charge_ratio)) or sprite_velocity_y
			sprite_velocity_y = vm.f32(sprite_velocity_y - vm.f32(vm.f32(1.0 + vm.f32(1.0 * charge_ratio)) / 2.0))
			sprite_velocity_z = effect.get_random_number(1.0 + vm.f32(1.0 * charge_ratio)) or sprite_velocity_z
			sprite_velocity_z = vm.f32(sprite_velocity_z - vm.f32(vm.f32(1.0 + vm.f32(1.0 * charge_ratio)) / 2.0))
			effect.set_sprite_velocity(sprite_index + i, scratch_value, sprite_velocity_y, sprite_velocity_z)
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
			effect.set_effect_value_float(0, charge_ratio)
			break
		else
			effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("モニカ魔法－火ヒット")
				effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
				effect.set_effect_value_float(0, charge_ratio)
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
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
