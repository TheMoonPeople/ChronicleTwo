--!strict
--- Monica's wind magic projectile that spirals toward its target.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Launches a wind blast, steering it toward the target, and creates the wind hit effect on impact.
function script.on_start()
	local owner_id: s32 = 0
	local target_id: s32 = 0
	local power: f32 = 0
	local spiral_angle: f32 = 0
	local facing_angle: f32 = 0
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
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local waypoint_yaw_offset: f32 = 0
	local waypoint_x: f32 = 0
	local waypoint_y: f32 = 0
	local waypoint_z: f32 = 0
	local sprites_allocated: s32 = 0
	local segment_step_x: f32 = 0
	local segment_step_y: f32 = 0
	local segment_step_z: f32 = 0
	local trail_x: f32 = 0
	local trail_y: f32 = 0
	local trail_z: f32 = 0
	local frame: s32 = 0
	local sprite_index: s32 = 0
	local hit_result: s32 = 0
	local speed: f32 = 0
	local target_pitch: f32 = 0
	local target_yaw: f32 = 0
	local is_angle_aligned: s32 = 0
	owner_id = effect.get_owner_character() or owner_id
	target_id = effect.get_target_character() or target_id
	power = 0.0
	power = effect.get_script_value_float(0) or power
	spiral_angle = 0.0
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
		target_x = vm.f32(vm.f32(vm.sin(facing_angle) * 400.0) + owner_x)
		target_y = vm.f32(20.0 + owner_y)
		target_z = vm.f32(vm.f32(vm.cos(facing_angle) * 400.0) + owner_z)
	else
		do
			local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
	end
	waypoint_yaw_offset = effect.get_random_number(2.0943952) or waypoint_yaw_offset
	waypoint_yaw_offset = vm.f32(waypoint_yaw_offset - vm.f32(1.0471976))
	facing_angle = vm.f32(facing_angle + waypoint_yaw_offset)
	facing_angle = effect.wrap_angle(facing_angle) or facing_angle
	waypoint_x = vm.f32(vm.f32(vm.sin(facing_angle) * 30.0) + owner_x)
	waypoint_y = vm.f32(40.0 + owner_y)
	waypoint_z = vm.f32(vm.f32(vm.cos(facing_angle) * 30.0) + owner_z)
	facing_angle = effect.get_scene_character_rotation_2(owner_id) or facing_angle
	sprites_allocated = effect.allocate_sprites_2(20) or sprites_allocated
	if sprites_allocated == 0 then
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
	frame = 0
	while frame < 10 do
		do
			local out1, out2, out3 = effect.copy_vector(waypoint_x, waypoint_y, waypoint_z)
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
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(previous_x, previous_y, previous_z)
			segment_step_x = out1 or segment_step_x
			segment_step_y = out2 or segment_step_y
			segment_step_z = out3 or segment_step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(segment_step_x, segment_step_y, segment_step_z, bolt_x, bolt_y, bolt_z)
			segment_step_x = out1 or segment_step_x
			segment_step_y = out2 or segment_step_y
			segment_step_z = out3 or segment_step_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(segment_step_x, segment_step_y, segment_step_z, 2)
			segment_step_x = out1 or segment_step_x
			segment_step_y = out2 or segment_step_y
			segment_step_z = out3 or segment_step_z
		end
		effect.spread_sprite_positions(sprite_index, trail_x, trail_y, trail_z, segment_step_x, segment_step_y, segment_step_z, 0.0, 0.0, 0.0, 2)
		effect.spread_sprite_colors(sprite_index, 128.0, 128.0, 128.0, 128.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 2)
		effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0, 6.0, 2)
		effect.spread_sprite_scales(sprite_index, 1.0 + vm.f32(1.0 * power), 1.0 + vm.f32(1.0 * power), 0.0, -0.04, 0.0, 0.0, 2)
		effect.ease_sprite_scale(
			sprite_index,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * power),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * power),
			4.0,
			2
		)
		effect.spread_sprite_rotations(sprite_index, spiral_angle, -0.6, 0.0, 2)
		spiral_angle = vm.f32(spiral_angle + vm.f32(1.2))
		spiral_angle = effect.wrap_angle(spiral_angle) or spiral_angle
		sprite_index = sprite_index + 2
		if sprite_index >= 20 then
			sprite_index = 0
		end
		effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			effect.create_effect_1("モニカ魔法－風ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, power)
			break
		else
			frame = frame + 1
			vm.wait()
		end
	end
	speed = 1.0
	facing_angle = effect.get_rotation_toward_7(bolt_x, bolt_y, bolt_z, target_x, target_y, target_z) or facing_angle
	do
		local out1, out2, out3 = effect.get_rotation_toward_9(bolt_x, bolt_y, bolt_z, target_x, target_y, target_z)
		bolt_pitch = out1 or bolt_pitch
		bolt_yaw = out2 or bolt_yaw
		bolt_roll = out3 or bolt_roll
	end
	bolt_pitch = effect.get_random_number(0.5235988) or bolt_pitch
	bolt_pitch = vm.f32(bolt_pitch + vm.f32(0.2617994))
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
	sprite_index = 0
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
		speed = vm.f32(speed * 2.0)
		if speed > 16.0 then
			speed = 16.0
		end
		do
			local out1, out2, out3 = effect.copy_vector(bolt_x, bolt_y, bolt_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(previous_x, previous_y, previous_z)
			segment_step_x = out1 or segment_step_x
			segment_step_y = out2 or segment_step_y
			segment_step_z = out3 or segment_step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(segment_step_x, segment_step_y, segment_step_z, bolt_x, bolt_y, bolt_z)
			segment_step_x = out1 or segment_step_x
			segment_step_y = out2 or segment_step_y
			segment_step_z = out3 or segment_step_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(segment_step_x, segment_step_y, segment_step_z, 2)
			segment_step_x = out1 or segment_step_x
			segment_step_y = out2 or segment_step_y
			segment_step_z = out3 or segment_step_z
		end
		effect.spread_sprite_positions(sprite_index, trail_x, trail_y, trail_z, segment_step_x, segment_step_y, segment_step_z, 0.0, 0.0, 0.0, 2)
		effect.spread_sprite_colors(sprite_index, 128.0, 128.0, 128.0, 128.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 2)
		effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0, 6.0, 2)
		effect.spread_sprite_scales(sprite_index, 1.0 + vm.f32(1.0 * power), 1.0 + vm.f32(1.0 * power), 0.0, -0.04, 0.0, 0.0, 2)
		effect.ease_sprite_scale(
			sprite_index,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * power),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * power),
			4.0,
			2
		)
		effect.spread_sprite_rotations(sprite_index, spiral_angle, -0.6, 0.0, 2)
		spiral_angle = vm.f32(spiral_angle + vm.f32(1.2))
		spiral_angle = effect.wrap_angle(spiral_angle) or spiral_angle
		sprite_index = sprite_index + 2
		if sprite_index >= 20 then
			sprite_index = 0
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, bolt_x, bolt_y, bolt_z)
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			effect.create_effect_1("モニカ魔法－風ヒット")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			effect.set_effect_value_float(0, power)
			break
		else
			effect.set_collision_primitive_shape(bolt_x, bolt_y, bolt_z, 10.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				effect.create_effect_1("モニカ魔法－風ヒット")
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
	while frame < 30 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
