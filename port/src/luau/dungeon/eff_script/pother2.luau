--!strict
-- dungeon/eff_script/pother2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var6: s32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_5: s32 = 0
	local value_6: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, _ = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
	end
	effect.set_sprite_texture("base_eff2")
	effect.allocate_sprites_1(8)
	effect.reset_sprites(0, 8)
	effect.set_sprite_blend_mode(0, 1, 8)
	effect.set_sprite_visible(0, 1, 8)
	effect.set_sprite_size(0, 10.24, 8.32, 8)
	effect.set_sprite_texture_rect(0, 1.0, 1.0, 62.0, 62.0, 8)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 8)
	effect.set_sprite_scale(0, work_vect2_x, work_vect2_y, 8)
	effect.set_sprite_scale_velocity(0, vm.f32(0.06) * work_vect2_x, vm.f32(0.06) * work_vect2_y, 8)
	var6 = 0
	while var6 < 8 do
		value = effect.get_random_number(12.0 * work_vect2_x) or value
		value = vm.f32(vm.f32(value - vm.f32(vm.f32(12.0 * work_vect2_x) / 2.0)) + work_vect1_x)
		value_2 = effect.get_random_number(vm.f32(12.0 * work_vect2_y) / 4.0) or value_2
		value_2 = vm.f32(value_2 + work_vect1_y)
		value_3 = effect.get_random_number(12.0 * work_vect2_x) or value_3
		value_3 = vm.f32(vm.f32(value_3 - vm.f32(vm.f32(12.0 * work_vect2_x) / 2.0)) + work_vect1_z)
		effect.set_sprite_position(var6, value, value_2, value_3)
		effect.set_sprite_velocity(var6, 0.0, vm.f32(0.2) * work_vect2_y, 0.0)
		effect.set_sprite_acceleration(var6, 0.0, vm.f32(-0.01) * work_vect2_y, 0.0)
		value_4 = effect.get_random_number(6.2831855) or value_4
		value_4 = vm.f32(value_4 - vm.f32(3.1415927))
		effect.set_sprite_rotation(var6, value_4)
		value_5 = 0
		value_5 = effect.get_random_number_int(100) or value_5
		if vm.imod(value_5, 2) == 0 then
			value_4 = vm.f32(0.06)
		else
			value_4 = vm.f32(-0.06)
		end
		effect.set_sprite_angular_velocity(var6, value_4)
		effect.set_sprite_angular_acceleration(var6, -vm.f32(value_4 * vm.f32(0.02)))
		value_6 = effect.get_random_number(4.0) or value_6
		value_6 = vm.f32(value_6 + 20.0)
		effect.set_sprite_color_velocity(var6, 0.0, 0.0, 0.0, value_6)
		value_6 = effect.get_random_number(2.0) or value_6
		value_6 = vm.f32(value_6 + 1.5)
		effect.set_sprite_color_acceleration(var6, 0.0, 0.0, 0.0, -value_6)
		var6 = var6 + 1
	end
	var6 = 0
	while var6 < 60 do
		var6 = var6 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
