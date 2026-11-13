--!strict
--- A beam of butterfly scales that homes toward the target and damages it along the way.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Steers a head position toward the target while shedding scale sprites and refreshing a damaging hitbox.
function script.on_start()
	local scale: f32 = 0
	local head_x: f32 = 0
	local head_y: f32 = 0
	local head_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local work_vect2_z: f32 = 0
	local value: s32 = 0
	local target_id: s32 = 0
	local frame: s32 = 0
	local sprite_cursor: s32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_error_x: f32 = 0
	local rotation_error_y: f32 = 0
	local value_2: s32 = 0
	local axis_index: s32 = 0
	local particle_offset: { f32 } = table.create(3, 0)
	local particle_velocity: { f32 } = table.create(3, 0)
	local value_3: f32 = 0
	local velocity_length: f32 = 0
	scale = 4.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		head_x = out1 or head_x
		head_y = out2 or head_y
		head_z = out3 or head_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		work_vect2_z = out3 or work_vect2_z
	end
	value = effect.get_script_value(0) or value
	target_id = effect.get_target_character() or target_id
	effect.allocate_sprites_1(30)
	effect.set_sprite_texture("nana_rinpun")
	effect.reset_sprites(0, 30)
	effect.set_sprite_blend_mode(0, 2, 30)
	effect.set_sprite_visible(0, 1, 30)
	effect.set_sprite_position(0, 0.0, -1000.0, 0.0, 30)
	effect.set_sprite_size(0, 10.0, 10.0, 30)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 30)
	sprite_cursor = 0
	frame = 0
	while frame < 300 do
		do
			local out1, out2, out3 = effect.get_direction_vector(rotation_x, rotation_y, work_vect2_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(step_x, step_y, step_z, scale)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(head_x, head_y, head_z, step_x, step_y, step_z)
			head_x = out1 or head_x
			head_y = out2 or head_y
			head_z = out3 or head_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_position(target_id)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_y = vm.f32(pos_y + 30.0)
		do
			local out1, out2, _ = effect.get_rotation_toward_9(head_x, head_y, head_z, pos_x, pos_y, pos_z)
			rotation_error_x = out1 or rotation_error_x
			rotation_error_y = out2 or rotation_error_y
		end
		rotation_error_x = vm.f32(rotation_error_x - rotation_x)
		rotation_error_y = vm.f32(rotation_error_y - rotation_y)
		rotation_error_x = effect.wrap_angle(rotation_error_x) or rotation_error_x
		rotation_error_y = effect.wrap_angle(rotation_error_y) or rotation_error_y
		rotation_error_x = vm.f32(rotation_error_x / 30.0)
		rotation_error_y = vm.f32(rotation_error_y / 60.0)
		rotation_x = vm.f32(rotation_x + rotation_error_x)
		rotation_y = vm.f32(rotation_y + rotation_error_y)
		rotation_x = effect.wrap_angle(rotation_x) or rotation_x
		rotation_y = effect.wrap_angle(rotation_y) or rotation_y
		axis_index = 0
		while axis_index < 3 do
			particle_offset[axis_index + 1] = effect.get_random_number(30.0) or particle_offset[axis_index + 1]
			particle_offset[axis_index + 1] = vm.f32(particle_offset[axis_index + 1] - 15.0)
			axis_index = axis_index + 1
		end
		axis_index = 0
		while axis_index < 3 do
			particle_velocity[axis_index + 1] = effect.get_random_number(30.0) or particle_velocity[axis_index + 1]
			particle_velocity[axis_index + 1] = vm.f32(particle_velocity[axis_index + 1] - 15.0)
			axis_index = axis_index + 1
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(particle_velocity[1], particle_velocity[2], particle_velocity[3], particle_offset[1], particle_offset[2], particle_offset[3])
			particle_velocity[1] = out1 or particle_velocity[1]
			particle_velocity[2] = out2 or particle_velocity[2]
			particle_velocity[3] = out3 or particle_velocity[3]
		end
		velocity_length = effect.get_vector_length(particle_velocity[1], particle_velocity[2], particle_velocity[3]) or velocity_length
		do
			local out1, out2, out3 = effect.divide_vector(particle_velocity[1], particle_velocity[2], particle_velocity[3], velocity_length)
			particle_velocity[1] = out1 or particle_velocity[1]
			particle_velocity[2] = out2 or particle_velocity[2]
			particle_velocity[3] = out3 or particle_velocity[3]
		end
		do
			local out1, out2, out3 = effect.add_vectors(particle_offset[1], particle_offset[2], particle_offset[3], head_x, head_y, head_z)
			particle_offset[1] = out1 or particle_offset[1]
			particle_offset[2] = out2 or particle_offset[2]
			particle_offset[3] = out3 or particle_offset[3]
		end
		effect.set_sprite_position(sprite_cursor, particle_offset[1], particle_offset[2], particle_offset[3])
		value_2 = effect.get_random_number_int(7) or value_2
		effect.set_sprite_texture_rect(
			sprite_cursor,
			vm.i32(vm.i32(vm.imod(value_2, 2) * 64) + 1),
			vm.i32(vm.i32(vm.idiv(value_2, 2) * 64) + 1),
			62.0,
			62.0
		)
		effect.set_sprite_color(sprite_cursor, 128.0, 128.0, 128.0, 0.0)
		value_3 = effect.get_random_number(2.0) or value_3
		value_3 = vm.f32(1.0 - vm.f32(value_3 / 10.0))
		effect.set_sprite_scale(sprite_cursor, value_3, value_3)
		effect.set_sprite_velocity(sprite_cursor, particle_velocity[1], particle_velocity[2], particle_velocity[3])
		effect.set_sprite_angular_velocity(sprite_cursor, 0.19634955)
		effect.set_sprite_color_velocity(sprite_cursor, 0.0, 0.0, 0.0, 24.0)
		effect.set_sprite_color_acceleration(sprite_cursor, 0.0, 0.0, 0.0, -1.8)
		sprite_cursor = sprite_cursor + 1
		if sprite_cursor >= 30 then
			sprite_cursor = 0
		end
		if vm.imod(frame, 6) == 0 then
			effect.delete_collision_primitive(-1)
			effect.get_owner_character()
			effect.create_collision_primitive("りんぷん")
			effect.set_collision_primitive_damage(value)
			effect.set_collision_primitive_shape(head_x, head_y, head_z, 20.0)
		end
		frame = frame + 1
		vm.wait()
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
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
