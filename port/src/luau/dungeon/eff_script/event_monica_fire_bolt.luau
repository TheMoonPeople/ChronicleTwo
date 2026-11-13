--!strict
--- Flies a homing fire bolt from the owner toward a target during an event cutscene.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Steers the bolt toward the target, leaves fire sprite trails, and spawns the hit effect on impact.
function script.on_start()
	local user_id: s32 = 0
	local target_id: s32 = 0
	local power: f32 = 0
	local launch_speed: f32 = 0
	local rot_y: f32 = 0
	local user_x: f32 = 0
	local user_y: f32 = 0
	local user_z: f32 = 0
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
	local spread_factor: f32 = 0
	local has_sprites: s32 = 0
	local sprite_base_index: s32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local frame: s32 = 0
	local target_pitch: f32 = 0
	local target_yaw: f32 = 0
	local is_facing_target: s32 = 0
	local half_step_x: f32 = 0
	local half_step_y: f32 = 0
	local half_step_z: f32 = 0
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local spark_velocity_x: f32 = 0
	local spark_velocity_y: f32 = 0
	local spark_velocity_z: f32 = 0
	local hit_result: s32 = 0
	local distance_to_target: f32 = 0
	user_id = effect.get_owner_character() or user_id
	target_id = effect.get_target_character() or target_id
	power = effect.get_script_value_float(0) or power
	power = 0.0
	launch_speed = vm.f32(8.0 + vm.f32(4.0 * power))
	do
		local out1, out2, out3 = effect.get_scene_character_position(user_id)
		user_x = out1 or user_x
		user_y = out2 or user_y
		user_z = out3 or user_z
	end
	rot_y = effect.get_scene_character_rotation_2(user_id) or rot_y
	if target_id <= -1 then
		target_x = vm.f32(vm.f32(vm.sin(rot_y) * 300.0) + user_x)
		target_y = vm.f32(20.0 + user_y)
		target_z = vm.f32(vm.f32(vm.cos(rot_y) * 300.0) + user_z)
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
		spread_factor = vm.f32(0.4)
		if target_id > 0 then
			spread_factor = effect.get_distance_between(user_x, user_y, user_z, target_x, target_y, target_z) or spread_factor
			spread_factor = vm.f32(spread_factor * vm.f32(0.001))
		end
		pitch = effect.get_random_number(vm.f32(-3.1415927) * spread_factor) or pitch
		yaw = effect.get_random_number(vm.f32(3.1415927) * spread_factor) or yaw
		yaw = vm.f32(vm.f32(yaw - vm.f32(0.5235988)) + rot_y)
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
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, launch_speed)
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
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, launch_speed)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
	end
	has_sprites = effect.allocate_sprites_2(52) or has_sprites
	if has_sprites == 0 then
		return
	end
	effect.set_sprite_texture("c02flame")
	effect.reset_sprites(0, 52)
	effect.set_sprite_visible(0, 1, 52)
	effect.set_sprite_blend_mode(0, 2, 52)
	effect.set_sprite_size(0, 10.0, 10.0, 52)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 52)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 52)
	sprite_base_index = 4
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
				local out1, out2, out3 = effect.get_scene_character_position(target_id)
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
		is_facing_target = effect.compare_angles(yaw, target_yaw, 1.6) or is_facing_target
		if is_facing_target == 0 then
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
			local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, launch_speed)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			center_x = out1 or center_x
			center_y = out2 or center_y
			center_z = out3 or center_z
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
		effect.spread_sprite_positions(0, center_x, center_y, center_z, -half_step_x, -half_step_y, -half_step_z, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 4)
		effect.ease_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 4.0, 4)
		effect.spread_sprite_scales(0, 1.5 + vm.f32(1.5 * power), 1.5 + vm.f32(1.5 * power), 0.1, 0.1, 0.0, 0.0, 4)
		effect.set_sprite_blend_mode(sprite_base_index, 2, 2)
		effect.set_sprite_texture_rect(sprite_base_index, 0.0, 0.0, 64.0, 64.0, 2)
		effect.spread_sprite_positions(sprite_base_index, center_x, center_y, center_z, half_step_x, half_step_y, half_step_z, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(sprite_base_index, 128.0, 128.0, 128.0, 128.0, 2)
		effect.ease_sprite_color(sprite_base_index, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.set_sprite_scale(sprite_base_index, 1.0 + vm.f32(1.0 * power), 1.0 + vm.f32(1.0 * power), 2)
		effect.set_sprite_blend_mode(sprite_base_index + 2, 3, 2)
		effect.set_sprite_texture_rect(sprite_base_index + 2, 64.0, 64.0, 64.0, 64.0, 2)
		do
			local out1, out2, out3 = effect.scale_vector(half_step_x, half_step_y, half_step_z, 2.0)
			half_step_x = out1 or half_step_x
			half_step_y = out2 or half_step_y
			half_step_z = out3 or half_step_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(center_x, center_y, center_z, half_step_x, half_step_y, half_step_z)
			center_x = out1 or center_x
			center_y = out2 or center_y
			center_z = out3 or center_z
		end
		effect.spread_sprite_positions(sprite_base_index + 2, center_x, center_y, center_z, half_step_x, half_step_y, half_step_z, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(sprite_base_index + 2, 128.0, 128.0, 128.0, 32.0, 2)
		effect.ease_sprite_color(sprite_base_index + 2, 128.0, 128.0, 128.0, 0.0, 4.0, 2)
		effect.set_sprite_scale(sprite_base_index + 2, 1.0 + vm.f32(1.0 * power), 1.0 + vm.f32(1.0 * power), 2)
		for sprite_offset = 0, 3 do
			spark_velocity_x = effect.get_random_number(3.1415927) or spark_velocity_x
			spark_velocity_x = vm.f32(vm.f32(spark_velocity_x + 2.0) + vm.f32(2.0 * power))
			effect.ease_sprite_scale(sprite_base_index + sprite_offset, spark_velocity_x, spark_velocity_x, 4.0)
			spark_velocity_x = effect.get_random_number(6.2831855) or spark_velocity_x
			spark_velocity_x = vm.f32(spark_velocity_x - vm.f32(3.1415927))
			effect.set_sprite_rotation(sprite_base_index + sprite_offset, spark_velocity_x)
			spark_velocity_x = effect.get_random_number(1.0 + vm.f32(1.0 * power)) or spark_velocity_x
			spark_velocity_x = vm.f32(spark_velocity_x - vm.f32(vm.f32(1.0 + vm.f32(1.0 * power)) / 2.0))
			spark_velocity_y = effect.get_random_number(1.0 + vm.f32(1.0 * power)) or spark_velocity_y
			spark_velocity_y = vm.f32(spark_velocity_y - vm.f32(vm.f32(1.0 + vm.f32(1.0 * power)) / 2.0))
			spark_velocity_z = effect.get_random_number(1.0 + vm.f32(1.0 * power)) or spark_velocity_z
			spark_velocity_z = vm.f32(spark_velocity_z - vm.f32(vm.f32(1.0 + vm.f32(1.0 * power)) / 2.0))
			effect.set_sprite_velocity(sprite_base_index + sprite_offset, spark_velocity_x, spark_velocity_y, spark_velocity_z)
		end
		sprite_base_index = sprite_base_index + 4
		if sprite_base_index >= 52 then
			sprite_base_index = 4
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, bolt_x, bolt_y, bolt_z)
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.create_effect_1("EVモニカ魔法－火ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, power)
			break
		else
			distance_to_target = effect.get_distance_between(bolt_x, bolt_y, bolt_z, target_x, target_y, target_z) or distance_to_target
			if distance_to_target < 20.0 then
				effect.create_effect_1("EVモニカ魔法－火ヒット")
				effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
				effect.set_effect_value_float(0, power)
				break
			else
				frame = frame + 1
				vm.wait()
			end
		end
	end
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
