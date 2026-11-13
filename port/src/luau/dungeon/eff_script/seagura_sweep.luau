--!strict
--- The dust cloud swept along the ground by Seagura's sweeping attack.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Lays down a line of growing dust sprites between two points while a damaging hitbox covers the sweep.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local value: f32 = 0
	local value_2: s32 = 0
	local hit_num: s32 = 0
	local frame: s32 = 0
	local sprite_cursor: s32 = 0
	local puff_x: f32 = 0
	local puff_y: f32 = 0
	local puff_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local value_3: f32 = 0
	local value_4: s32 = 0
	hit_num = 0
	value_2 = 0
	value = 0.0
	value_2 = effect.get_script_value(0) or value_2
	value = effect.get_script_value_float(1) or value
	effect.set_sprite_texture("base_eff2")
	effect.allocate_sprites_1(80)
	effect.reset_sprites(0, 80)
	effect.set_sprite_blend_mode(0, 1, 80)
	effect.set_sprite_visible(0, 1, 80)
	effect.set_sprite_size(0, 10.24, 8.32, 80)
	effect.set_sprite_texture_rect(0, 65.0, 1.0, 62.0, 62.0, 80)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 80)
	effect.create_collision_primitive("強線形敵")
	effect.set_collision_primitive_damage(value_2)
	frame = 0
	sprite_cursor = 0
	while true do
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			work_vect1_x = out1 or work_vect1_x
			work_vect1_y = out2 or work_vect1_y
			work_vect1_z = out3 or work_vect1_z
		end
		do
			local out1, out2, out3 = effect.get_second_work_vector()
			work_vect2_x = out1 or work_vect2_x
			work_vect2_y = out2 or work_vect2_y
			work_vect2_z = out3 or work_vect2_z
		end
		if vm.imod(frame, 4) == 0 then
			do
				local out1, out2, out3 = effect.copy_vector(work_vect2_x, work_vect2_y, work_vect2_z)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, work_vect1_x, work_vect1_y, work_vect1_z)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			do
				local out1, out2, out3 = effect.divide_vector(step_x, step_y, step_z, 10)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			do
				local out1, out2, out3 = effect.copy_vector(work_vect1_x, work_vect1_y, work_vect1_z)
				puff_x = out1 or puff_x
				puff_y = out2 or puff_y
				puff_z = out3 or puff_z
			end
			for step_index = 0, 9 do
				effect.set_sprite_position(sprite_cursor, puff_x, puff_y, puff_z)
				effect.set_sprite_color(sprite_cursor, 128.0, 128.0, 128.0, 16.0)
				effect.set_sprite_color_velocity(sprite_cursor, 0.0, 0.0, 0.0, 10.24)
				effect.set_sprite_color_acceleration(sprite_cursor, 0.0, 0.0, 0.0, -0.8)
				effect.set_sprite_scale(sprite_cursor, 10.0, 10.0)
				effect.ease_sprite_scale(sprite_cursor, 40.0, 40.0, 30.0)
				value_3 = effect.get_random_number(6.2831855) or value_3
				value_3 = vm.f32(value_3 - vm.f32(3.1415927))
				effect.set_sprite_rotation(sprite_cursor, value_3)
				value_4 = effect.get_random_number_int(100) or value_4
				if value_4 < 50 then
					value_3 = vm.f32(0.14)
				else
					value_3 = vm.f32(-0.14)
				end
				effect.set_sprite_angular_velocity(sprite_cursor, value_3)
				effect.set_sprite_angular_acceleration(sprite_cursor, -vm.f32(value_3 * vm.f32(0.02)))
				do
					local out1, out2, out3 = effect.add_vectors(puff_x, puff_y, puff_z, step_x, step_y, step_z)
					puff_x = out1 or puff_x
					puff_y = out2 or puff_y
					puff_z = out3 or puff_z
				end
				sprite_cursor = vm.i32(sprite_cursor + 1)
			end
			if sprite_cursor >= 80 then
				sprite_cursor = 0
			end
		end
		if hit_num <= 0 then
			effect.set_collision_primitive_shape(
				work_vect1_x,
				work_vect1_y,
				work_vect1_z,
				work_vect2_x,
				work_vect2_y,
				work_vect2_z,
				value
			)
			hit_num = effect.get_collision_primitive_hit_count() or hit_num
			if hit_num > 0 then
				effect.delete_collision_primitive(-1)
			end
		end
		frame = vm.i32(frame + 1)
		vm.wait()
	end
end

--- Removes the sweep hitbox and waits for the dust to settle.
function script.on_finish()
	local frame: s32 = 0
	effect.delete_collision_primitive(-1)
	frame = 0
	while frame < 30 do
		frame = frame + 1
		vm.wait()
	end
end

return script
