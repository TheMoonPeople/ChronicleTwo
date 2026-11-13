--!strict
--- Mguil's second fire bolt, which homes toward the player trailing embers and erupts into a fire pillar on impact.

local vm = require("@lib/vm")

--- Spawns a batch of ember sprites around the midpoint between two positions and returns the next free sprite index.
local function spawn_ember_sprites(first_sprite: any, start_x: f32, start_y: f32, start_z: f32, end_x: f32, end_y: f32, end_z: f32)
	local ember_x: f32 = 0
	local ember_y: f32 = 0
	local ember_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	for index = 0, 7 do
		value = 1.0
		value_2 = 1.0
		value_3 = 1.0
		value = effect.get_random_number(360.0) or value
		value_2 = effect.get_random_number(15.0) or value_2
		value_3 = effect.get_random_number(8.0) or value_3
		value_4 = effect.get_random_number(400.0) or value_4
		effect.get_random_number(800.0)
		value = vm.f32(vm.f32(value / 180.0) * vm.f32(3.1415927))
		value_4 = vm.f32(value_4 / 100.0)
		value_4 = vm.f32(value_4 + 2.0)
		ember_x = vm.f32(vm.f32(vm.f32(start_x + end_x) / 2.0) + vm.f32(vm.sin(value) * value_2))
		ember_y = vm.f32(vm.f32(vm.f32(vm.f32(start_y + end_y) / 2.0) - value_3) + 4.0)
		ember_z = vm.f32(vm.f32(vm.f32(start_z + end_z) / 2.0) + vm.f32(vm.cos(value) * value_2))
		effect.set_sprite_visible(vm.wrap(index + first_sprite), 1)
		effect.set_sprite_color(vm.wrap(index + first_sprite), 128.0, 128.0, 128.0, 128.0)
		effect.set_sprite_scale(vm.wrap(index + first_sprite), value_4, value_4)
		effect.set_sprite_position(vm.wrap(index + first_sprite), ember_x, ember_y, ember_z)
		effect.set_sprite_color_velocity(vm.wrap(index + first_sprite), 0.0, 0.0, 0.0, -7.0)
	end
	first_sprite = vm.wrap(first_sprite + 8)
	if first_sprite >= 160 then
		first_sprite = 0
	end
	return first_sprite
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Flies a damaging homing fire bolt that sheds ember sprites until it hits something or burns out.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local target_direction_x: f32 = 0
	local target_direction_y: f32 = 0
	local target_direction_z: f32 = 0
	local heading_x: f32 = 0
	local heading_y: f32 = 0
	local heading_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local cos_angle: f32 = 0
	local sin_angle: f32 = 0
	local one_minus_cos: f32 = 0
	local frame: s32 = 0
	local result: s32 = 0
	local target_id: s32 = 0
	local value: s32 = 0
	local sprite_cursor: any = 0
	local hitbox_deleted: s32 = 0
	local value_2: s32 = 0
	local color_w: f32 = 0
	hitbox_deleted = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	target_id = effect.get_target_character() or target_id
	value_2 = effect.get_script_value(1) or value_2
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(pos_x, pos_y, pos_z)
		target_direction_x = out1 or target_direction_x
		target_direction_y = out2 or target_direction_y
		target_direction_z = out3 or target_direction_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(target_direction_x, target_direction_y, target_direction_z, position_x, position_y, position_z)
		target_direction_x = out1 or target_direction_x
		target_direction_y = out2 or target_direction_y
		target_direction_z = out3 or target_direction_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(target_direction_x, target_direction_y, target_direction_z)
		target_direction_x = out1 or target_direction_x
		target_direction_y = out2 or target_direction_y
		target_direction_z = out3 or target_direction_z
	end
	value = effect.get_script_value(0) or value
	effect.create_collision_primitive("Ｍギル火柱１")
	effect.set_collision_primitive_damage(value)
	effect.set_effect_character_scale(2.0, 2.0, 2.0)
	one_minus_cos = vm.f32(1.5707964)
	cos_angle = vm.cos(one_minus_cos)
	sin_angle = vm.sin(one_minus_cos)
	heading_x = vm.f32(vm.f32(target_direction_x * cos_angle) + vm.f32(target_direction_z * sin_angle))
	heading_y = target_direction_y
	heading_z = vm.f32(vm.f32(target_direction_x * -sin_angle) + vm.f32(target_direction_z * cos_angle))
	do
		local out1, out2, out3 = effect.normalize_vector(heading_x, heading_y, heading_z)
		heading_x = out1 or heading_x
		heading_y = out2 or heading_y
		heading_z = out3 or heading_z
	end
	work_vect2_z = vm.f32(vm.f32(work_vect2_z / 180.0) * vm.f32(3.1415927))
	cos_angle = vm.cos(work_vect2_z)
	sin_angle = vm.sin(work_vect2_z)
	one_minus_cos = vm.f32(1.0 - cos_angle)
	rotation_x = vm.f32(
		vm.f32(
			vm.f32(heading_x * vm.f32(cos_angle + vm.f32(vm.f32(one_minus_cos * target_direction_x) * target_direction_x)))
				+ vm.f32(heading_y * vm.f32(vm.f32(vm.f32(one_minus_cos * target_direction_x) * target_direction_y) + vm.f32(target_direction_z * sin_angle)))
		) + vm.f32(heading_z * vm.f32(vm.f32(vm.f32(one_minus_cos * target_direction_x) * target_direction_z) + vm.f32(target_direction_y * sin_angle)))
	)
	rotation_y = vm.f32(
		vm.f32(
			vm.f32(heading_x * vm.f32(vm.f32(vm.f32(one_minus_cos * target_direction_x) * target_direction_y) - vm.f32(target_direction_z * sin_angle)))
				+ vm.f32(heading_y * vm.f32(cos_angle + vm.f32(vm.f32(one_minus_cos * target_direction_y) * target_direction_y)))
		) + vm.f32(heading_z * vm.f32(vm.f32(vm.f32(one_minus_cos * target_direction_y) * target_direction_z) + vm.f32(target_direction_x * sin_angle)))
	)
	rotation_z = vm.f32(
		vm.f32(
			vm.f32(heading_x * vm.f32(vm.f32(vm.f32(one_minus_cos * target_direction_z) * target_direction_x) + vm.f32(target_direction_y * sin_angle)))
				+ vm.f32(heading_y * vm.f32(vm.f32(vm.f32(one_minus_cos * target_direction_y) * target_direction_z) - vm.f32(target_direction_x * sin_angle)))
		) + vm.f32(heading_z * vm.f32(cos_angle + vm.f32(vm.f32(one_minus_cos * target_direction_z) * target_direction_z)))
	)
	do
		local out1, out2, out3 = effect.copy_vector(rotation_x, rotation_y, rotation_z)
		heading_x = out1 or heading_x
		heading_y = out2 or heading_y
		heading_z = out3 or heading_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(heading_x, heading_y, heading_z)
		heading_x = out1 or heading_x
		heading_y = out2 or heading_y
		heading_z = out3 or heading_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	result = effect.allocate_sprites_2(160) or result
	if result == 0 then
		return
	end
	effect.set_sprite_texture("hinoko2")
	effect.reset_sprites(0, 160)
	effect.set_sprite_blend_mode(0, 2, 160)
	effect.set_sprite_texture_rect(0, 64.0, 64.0, 128.0, 128.0, 160)
	effect.set_sprite_size(0, 1.2, 1.2, 160)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 160)
	effect.set_sprite_visible(0, 0, 160)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 160)
	sprite_cursor = 0
	frame = 0
	while frame < 90 do
		if target_id == 1 then
			do
				local out1, out2, out3 = effect.get_scene_character_position(0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
		end
		target_direction_x = vm.f32(pos_x - position_x)
		target_direction_y = vm.f32(pos_y - position_y)
		target_direction_z = vm.f32(pos_z - position_z)
		do
			local out1, out2, out3 = effect.normalize_vector(target_direction_x, target_direction_y, target_direction_z)
			target_direction_x = out1 or target_direction_x
			target_direction_y = out2 or target_direction_y
			target_direction_z = out3 or target_direction_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(target_direction_x, target_direction_y, target_direction_z, work_vect2_y * 100.0)
			target_direction_x = out1 or target_direction_x
			target_direction_y = out2 or target_direction_y
			target_direction_z = out3 or target_direction_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(heading_x, heading_y, heading_z, vm.f32(1.0 - work_vect2_y) * 100.0)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(heading_x, heading_y, heading_z, target_direction_x, target_direction_y, target_direction_z)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(heading_x, heading_y, heading_z)
			heading_x = out1 or heading_x
			heading_y = out2 or heading_y
			heading_z = out3 or heading_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(heading_x, heading_y, heading_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, work_vect2_x)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		if frame > 10 then
			do
				local out1, out2, out3, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
				rotation_x = out1 or rotation_x
				rotation_y = out2 or rotation_y
				rotation_z = out3 or rotation_z
				result = out4 or result
			end
			if result >= 0 and frame <= 82 then
				do
					local out1, out2, out3 = effect.get_effect_character_rotation_toward(position_x, position_y, position_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				effect.delete_collision_primitive(-1)
				effect.create_effect_1("Ｍギル火柱１")
				effect.set_effect_first_work_vector(rotation_x, rotation_y, rotation_z)
				effect.set_effect_second_work_vector(previous_x, previous_y, previous_z)
				effect.set_effect_value(0, value)
				effect.set_effect_value(1, value_2)
				break
			end
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(position_x, position_y, position_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_character_position(position_x, position_y, position_z)
		effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
		effect.set_collision_primitive_shape(step_x, step_y, step_z, 10.0)
		for sprite_index = 0, 159 do
			result = effect.is_sprite_visible(sprite_index) or result
			if result == 1 then
				do
					local out1, out2, out3, out4 = effect.get_sprite_color(sprite_index)
					rotation_x = out1 or rotation_x
					rotation_y = out2 or rotation_y
					rotation_z = out3 or rotation_z
					color_w = out4 or color_w
				end
				if color_w <= 0.0 then
					effect.set_sprite_visible(sprite_index, 0)
				else
					do
						local out1, out2, out3 = effect.get_sprite_position(sprite_index)
						rotation_x = out1 or rotation_x
						rotation_y = out2 or rotation_y
						rotation_z = out3 or rotation_z
					end
					rotation_y = vm.f32(rotation_y - vm.f32(-0.8))
					effect.set_sprite_position(sprite_index, rotation_x, rotation_y, rotation_z)
				end
			end
		end
		sprite_cursor = spawn_ember_sprites(sprite_cursor, position_x, position_y, position_z, previous_x, previous_y, previous_z)
		if frame == 77 then
			effect.set_effect_character_visible(0, 1, -10.0)
			hitbox_deleted = 1
			effect.delete_collision_primitive(-1)
		end
		do
			local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		frame = frame + 1
		vm.wait()
	end
	frame = 0
	while frame < 16 do
		vm.wait()
		frame = frame + 1
	end
	if hitbox_deleted == 0 then
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
