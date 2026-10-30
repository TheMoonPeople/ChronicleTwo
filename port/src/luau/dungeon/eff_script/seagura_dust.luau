--!strict
-- dungeon/eff_script/seagura_dust.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
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
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
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
	var9 = 0
	var10 = 0
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
		if vm.imod(var9, 4) == 0 then
			do
				local out1, out2, out3 = effect.copy_vector(work_vect2_x, work_vect2_y, work_vect2_z)
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(var14, var15, var16, work_vect1_x, work_vect1_y, work_vect1_z)
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			do
				local out1, out2, out3 = effect.divide_vector(var14, var15, var16, 10)
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			do
				local out1, out2, out3 = effect.copy_vector(work_vect1_x, work_vect1_y, work_vect1_z)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			for var17 = 0, 9 do
				effect.set_sprite_position(var10, var11, var12, var13)
				effect.set_sprite_color(var10, 128.0, 128.0, 128.0, 16.0)
				effect.set_sprite_color_velocity(var10, 0.0, 0.0, 0.0, 10.24)
				effect.set_sprite_color_acceleration(var10, 0.0, 0.0, 0.0, -0.8)
				effect.set_sprite_scale(var10, 10.0, 10.0)
				effect.ease_sprite_scale(var10, 40.0, 40.0, 30.0)
				value_3 = effect.get_random_number(6.2831855) or value_3
				value_3 = vm.f32(value_3 - vm.f32(3.1415927))
				effect.set_sprite_rotation(var10, value_3)
				value_4 = effect.get_random_number_int(100) or value_4
				if value_4 < 50 then
					value_3 = vm.f32(0.14)
				else
					value_3 = vm.f32(-0.14)
				end
				effect.set_sprite_angular_velocity(var10, value_3)
				effect.set_sprite_angular_acceleration(var10, -vm.f32(value_3 * vm.f32(0.02)))
				do
					local out1, out2, out3 = effect.add_vectors(var11, var12, var13, var14, var15, var16)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				var10 = vm.i32(var10 + 1)
			end
			if var10 >= 80 then
				var10 = 0
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
		var9 = vm.i32(var9 + 1)
		vm.wait()
	end
end

--- Ends an effect.
function script.on_finish()
	local var0: s32 = 0
	effect.delete_collision_primitive(-1)
	var0 = 0
	while var0 < 30 do
		var0 = var0 + 1
		vm.wait()
	end
end

return script
