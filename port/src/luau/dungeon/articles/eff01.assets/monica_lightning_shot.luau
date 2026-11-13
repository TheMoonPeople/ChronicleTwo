--!strict
--- Flies Monica's lightning magic bolt from the owner toward the target as a jagged sprite trail until it hits and spawns the lightning impact effect.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Arcs the bolt out to the side of the owner, then steers it toward the target at growing speed, spawning the lightning impact effect on contact.
function script.on_start()
	local owner_id: s32 = 0
	local target_id: s32 = 0
	local charge_ratio: f32 = 0
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
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local arc_angle_offset: f32 = 0
	local arc_point_x: f32 = 0
	local arc_point_y: f32 = 0
	local arc_point_z: f32 = 0
	local sprites_allocated: s32 = 0
	local half_step_x: f32 = 0
	local half_step_y: f32 = 0
	local half_step_z: f32 = 0
	local sprite_origin_x: f32 = 0
	local sprite_origin_y: f32 = 0
	local sprite_origin_z: f32 = 0
	local spark_offset_x: f32 = 0
	local spark_offset_y: f32 = 0
	local spark_offset_z: f32 = 0
	local frame: s32 = 0
	local sprite_index: s32 = 0
	local i: s32 = 0
	local variant_roll: s32 = 0
	local hit_result: s32 = 0
	local speed: f32 = 0
	local target_pitch: f32 = 0
	local target_yaw: f32 = 0
	local angle_mismatch: s32 = 0
	owner_id = effect.get_owner_character() or owner_id
	target_id = effect.get_target_character() or target_id
	charge_ratio = 0.0
	charge_ratio = effect.get_script_value_float(0) or charge_ratio
	do
		local out1, out2, out3 = effect.get_scene_character_position(owner_id)
		owner_x = out1 or owner_x
		owner_y = out2 or owner_y
		owner_z = out3 or owner_z
	end
	facing_angle = effect.get_scene_character_rotation_2(owner_id) or facing_angle
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		bolt_x = out1 or bolt_x
		bolt_y = out2 or bolt_y
		bolt_z = out3 or bolt_z
	end
	if target_id <= -1 then
		aim_x = vm.f32(vm.f32(vm.sin(facing_angle) * 400.0) + owner_x)
		aim_y = vm.f32(20.0 + owner_y)
		aim_z = vm.f32(vm.f32(vm.cos(facing_angle) * 400.0) + owner_z)
	else
		do
			local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
	end
	arc_angle_offset = effect.get_random_number(2.0943952) or arc_angle_offset
	arc_angle_offset = vm.f32(arc_angle_offset - vm.f32(1.0471976))
	facing_angle = vm.f32(facing_angle + arc_angle_offset)
	facing_angle = effect.wrap_angle(facing_angle) or facing_angle
	arc_point_x = vm.f32(vm.f32(vm.sin(facing_angle) * 30.0) + owner_x)
	arc_point_y = vm.f32(40.0 + owner_y)
	arc_point_z = vm.f32(vm.f32(vm.cos(facing_angle) * 30.0) + owner_z)
	facing_angle = effect.get_scene_character_rotation_2(owner_id) or facing_angle
	sprites_allocated = effect.allocate_sprites_2(40) or sprites_allocated
	if sprites_allocated == 0 then
		return
	end
	effect.set_sprite_texture("c02lightning_hit")
	effect.reset_sprites(0, 40)
	effect.set_sprite_blend_mode(0, 2, 40)
	effect.set_sprite_visible(0, 1, 40)
	effect.set_sprite_size(0, 20.0, 20.0, 40)
	effect.set_sprite_texture_rect(0, 0.0, 48.0, 48.0, 48.0, 40)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 40)
	effect.set_sprite_scale(0, 1.0 + vm.f32(1.0 * charge_ratio), 1.0 + vm.f32(1.0 * charge_ratio), 40)
	sprite_index = 1
	frame = 0
	while frame < 10 do
		do
			local out1, out2, out3 = effect.copy_vector(arc_point_x, arc_point_y, arc_point_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(velocity_x, velocity_y, velocity_z, bolt_x, bolt_y, bolt_z)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(velocity_x, velocity_y, velocity_z, 3.0)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
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
			local out1, out2, out3 = effect.divide_vector(half_step_x, half_step_y, half_step_z, 4)
			half_step_x = out1 or half_step_x
			half_step_y = out2 or half_step_y
			half_step_z = out3 or half_step_z
		end
		effect.set_sprite_position(0, sprite_origin_x, sprite_origin_y, sprite_origin_z)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0)
		effect.spread_sprite_positions(sprite_index, sprite_origin_x, sprite_origin_y, sprite_origin_z, half_step_x, half_step_y, half_step_z, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 64.0, 4)
		effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, -64.0, 6.0, 4)
		effect.set_sprite_blinking(sprite_index, 0.0, 0.0, 0.0, 64.0, 1.5707964, 4)
		effect.set_sprite_scale(sprite_index, 1.0 + vm.f32(1.0 * charge_ratio), 1.0 + vm.f32(1.0 * charge_ratio), 4)
		effect.ease_sprite_scale(
			sprite_index,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * charge_ratio),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * charge_ratio),
			4.0,
			4
		)
		i = 0
		while i < 4 do
			variant_roll = effect.get_random_number_int(100) or variant_roll
			if vm.imod(variant_roll, 2) == 0 then
				effect.set_sprite_texture_rect(sprite_index + i, 16.0, 96.0, 32.0, 32.0)
				effect.set_sprite_size(sprite_index + i, 20.0, 20.0)
			else
				variant_roll = effect.get_random_number_int(4) or variant_roll
				effect.set_sprite_texture_rect(sprite_index + i, vm.i32(vm.i32(variant_roll * 20) + 48), 0, 20, 128)
				effect.set_sprite_size(sprite_index + i, 4.0, 25.6)
				spark_offset_x = effect.get_random_number(6.2831855) or spark_offset_x
				spark_offset_x = vm.f32(spark_offset_x - vm.f32(3.1415927))
				effect.set_sprite_rotation(sprite_index + i, spark_offset_x)
			end
			spark_offset_x = effect.get_random_number(4.0 + vm.f32(4.0 * charge_ratio)) or spark_offset_x
			spark_offset_x = vm.f32(spark_offset_x - vm.f32(vm.f32(4.0 + vm.f32(4.0 * charge_ratio)) / 2.0))
			spark_offset_y = effect.get_random_number(4.0 + vm.f32(4.0 * charge_ratio)) or spark_offset_y
			spark_offset_y = vm.f32(spark_offset_y - vm.f32(vm.f32(4.0 + vm.f32(4.0 * charge_ratio)) / 2.0))
			spark_offset_z = effect.get_random_number(4.0 + vm.f32(4.0 * charge_ratio)) or spark_offset_z
			spark_offset_z = vm.f32(spark_offset_z - vm.f32(vm.f32(4.0 + vm.f32(4.0 * charge_ratio)) / 2.0))
			effect.offset_sprite_position(sprite_index + i, spark_offset_x, spark_offset_y, spark_offset_z)
			i = i + 1
		end
		sprite_index = sprite_index + 4
		if sprite_index >= 40 then
			sprite_index = 1
		end
		effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			effect.create_effect_1("モニカ魔法－雷ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, charge_ratio)
			break
		else
			frame = frame + 1
			vm.wait()
		end
	end
	speed = 1.0
	facing_angle = effect.get_rotation_toward_7(bolt_x, bolt_y, bolt_z, aim_x, aim_y, aim_z) or facing_angle
	do
		local out1, out2, out3 = effect.get_rotation_toward_9(bolt_x, bolt_y, bolt_z, aim_x, aim_y, aim_z)
		pitch = out1 or pitch
		yaw = out2 or yaw
		roll = out3 or roll
	end
	pitch = effect.get_random_number(0.5235988) or pitch
	pitch = vm.f32(pitch + vm.f32(0.2617994))
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
	sprite_index = 1
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
		speed = vm.f32(speed * 2.0)
		if speed > 16.0 then
			speed = 16.0
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
			local out1, out2, out3 = effect.divide_vector(half_step_x, half_step_y, half_step_z, 4)
			half_step_x = out1 or half_step_x
			half_step_y = out2 or half_step_y
			half_step_z = out3 or half_step_z
		end
		effect.spread_sprite_positions(0, sprite_origin_x, sprite_origin_y, sprite_origin_z, -half_step_x, -half_step_y, -half_step_z, 0.0, 0.0, 0.0, 1)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 1)
		effect.spread_sprite_positions(sprite_index, sprite_origin_x, sprite_origin_y, sprite_origin_z, half_step_x, half_step_y, half_step_z, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 64.0, 4)
		effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, -64.0, 6.0, 4)
		effect.set_sprite_blinking(sprite_index, 0.0, 0.0, 0.0, 64.0, 1.5707964, 4)
		effect.set_sprite_scale(sprite_index, 1.0 + vm.f32(1.0 * charge_ratio), 1.0 + vm.f32(1.0 * charge_ratio), 4)
		effect.ease_sprite_scale(
			sprite_index,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * charge_ratio),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * charge_ratio),
			4.0,
			4
		)
		i = 0
		while i < 4 do
			variant_roll = effect.get_random_number_int(100) or variant_roll
			if vm.imod(variant_roll, 3) == 0 then
				effect.set_sprite_texture_rect(sprite_index + i, 16.0, 96.0, 32.0, 32.0)
				effect.set_sprite_size(sprite_index + i, 20.0, 20.0)
			else
				variant_roll = effect.get_random_number_int(4) or variant_roll
				effect.set_sprite_texture_rect(sprite_index + i, vm.i32(vm.i32(variant_roll * 20) + 48), 0, 20, 128)
				effect.set_sprite_size(sprite_index + i, 4.0, 25.6)
				spark_offset_x = effect.get_random_number(6.2831855) or spark_offset_x
				spark_offset_x = vm.f32(spark_offset_x - vm.f32(3.1415927))
				effect.set_sprite_rotation(sprite_index + i, spark_offset_x)
			end
			spark_offset_x = effect.get_random_number(4.0 + vm.f32(4.0 * charge_ratio)) or spark_offset_x
			spark_offset_x = vm.f32(spark_offset_x - vm.f32(vm.f32(4.0 + vm.f32(4.0 * charge_ratio)) / 2.0))
			spark_offset_y = effect.get_random_number(4.0 + vm.f32(4.0 * charge_ratio)) or spark_offset_y
			spark_offset_y = vm.f32(spark_offset_y - vm.f32(vm.f32(4.0 + vm.f32(4.0 * charge_ratio)) / 2.0))
			spark_offset_z = effect.get_random_number(4.0 + vm.f32(4.0 * charge_ratio)) or spark_offset_z
			spark_offset_z = vm.f32(spark_offset_z - vm.f32(vm.f32(4.0 + vm.f32(4.0 * charge_ratio)) / 2.0))
			effect.offset_sprite_position(sprite_index + i, spark_offset_x, spark_offset_y, spark_offset_z)
			i = i + 1
		end
		sprite_index = sprite_index + 4
		if sprite_index >= 40 then
			sprite_index = 1
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, bolt_x, bolt_y, bolt_z)
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.create_effect_1("モニカ魔法－雷ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, charge_ratio)
			break
		else
			effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("モニカ魔法－雷ヒット")
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
	effect.set_sprite_visible(0, 0)
	frame = 0
	while frame < 10 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
