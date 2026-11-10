--!strict
-- dungeon/articles/eff01.assets/c02_magic_tame.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local value: f32 = 0
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
	effect.set_sprite_texture("effect01")
	effect.allocate_sprites_1(5)
	effect.reset_sprites(0, 5)
	effect.set_sprite_blend_mode(0, 2, 5)
	effect.set_sprite_visible(0, 1, 5)
	effect.set_sprite_size(0, 10.24, 8.32)
	effect.set_sprite_texture_rect(0, 64.0, 128.0, 64.0, 64.0)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0)
	effect.ease_sprite_color(0, work_vect2_x, work_vect2_y, work_vect2_z, 128.0, 16.0)
	effect.set_sprite_scale(0, 0.0, 0.0)
	effect.ease_sprite_scale(0, 6.0, 6.0, 24.0)
	effect.set_sprite_size(1, 10.24, 8.32, 2)
	effect.set_sprite_texture_rect(1, 0.0, 192.0, 64.0, 64.0, 2)
	effect.set_sprite_color(1, work_vect2_x, work_vect2_y, work_vect2_z, 0.0, 2)
	effect.set_sprite_angular_velocity(1, 0.1)
	effect.set_sprite_angular_velocity(2, -0.1)
	effect.ease_sprite_color(1, work_vect2_x, work_vect2_y, work_vect2_z, 128.0, 16.0, 2)
	effect.set_sprite_scale(1, 0.0, 0.0, 2)
	effect.ease_sprite_scale(1, 1.0, 1.0, 24.0, 2)
	effect.set_sprite_size(3, 10.24, 8.32, 2)
	effect.set_sprite_texture_rect(3, 0.0, 128.0, 64.0, 64.0, 2)
	effect.set_sprite_color(3, work_vect2_x, work_vect2_y, work_vect2_z, 128.0, 2)
	effect.set_sprite_scale(3, 0.0, 0.0, 2)
	var6 = 0.0
	var8 = 0
	var7 = 0
	while var7 < 120 do
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			work_vect1_x = out1 or work_vect1_x
			work_vect1_y = out2 or work_vect1_y
			work_vect1_z = out3 or work_vect1_z
		end
		effect.set_sprite_position(1, work_vect1_x, work_vect1_y, work_vect1_z, 2)
		effect.set_sprite_position(3, work_vect1_x, work_vect1_y, work_vect1_z, 2)
		var6 = vm.f32(var6 + vm.f32(vm.f32(3.0 - var6) / 24.0))
		if vm.imod(var7, 2) == 0 then
			effect.set_sprite_position(0, work_vect1_x, work_vect1_y, work_vect1_z)
			effect.set_sprite_scale(3 + var8, var6, var6)
			effect.ease_sprite_scale(3 + var8, 0.2, 0.2, 4.0)
			value = effect.get_random_number(6.2831855) or value
			value = vm.f32(value - vm.f32(3.1415927))
			effect.set_sprite_rotation(3 + var8, value)
			var8 = var8 + 1
			if var8 >= 2 then
				var8 = 0
			end
		end
		var7 = var7 + 1
		if var7 >= 100 then
			var7 = 0
		end
		vm.wait()
	end
end

--- Ends an effect.
function script.on_finish()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var6: s32 = 0
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
	effect.reset_sprites(0, 5)
	effect.set_sprite_blend_mode(0, 2, 5)
	effect.set_sprite_visible(1, 1, 2)
	effect.set_sprite_position(1, work_vect1_x, work_vect1_y, work_vect1_z, 2)
	effect.set_sprite_visible(0, 0)
	effect.set_sprite_visible(3, 0, 2)
	effect.set_sprite_size(1, 10.24, 8.32, 2)
	effect.set_sprite_color(1, work_vect2_x, work_vect2_y, work_vect2_z, 128.0, 2)
	effect.set_sprite_scale(1, 0.0, 0.0, 2)
	effect.set_sprite_texture_rect(1, 128.0, 0.0, 128.0, 128.0)
	effect.ease_sprite_scale(1, 3.0, 3.0, 2.0)
	effect.ease_sprite_color(1, work_vect2_x, work_vect2_y, work_vect2_z, 0.0, 3.0)
	vm.wait()
	effect.set_sprite_texture_rect(2, 0.0, 0.0, 128.0, 128.0)
	effect.ease_sprite_scale(2, 1.5, 1.5, 3.0)
	effect.ease_sprite_color(2, work_vect2_x, work_vect2_y, work_vect2_z, 0.0, 4.0)
	var6 = 0
	while var6 < 30 do
		var6 = var6 + 1
		vm.wait()
	end
end

return script
