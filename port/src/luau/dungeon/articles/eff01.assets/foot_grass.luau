--!strict
-- dungeon/articles/eff01.assets/foot_grass.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var3: s32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_4_2: f32 = 0
	local var9: s32 = 0
	local var10: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_sprite_lighting(1)
	effect.set_sprite_texture("base_eff2")
	effect.allocate_sprites_1(3)
	effect.reset_sprites(0, 3)
	effect.set_sprite_blend_mode(0, 1, 3)
	effect.set_sprite_visible(0, 1, 3)
	effect.set_sprite_size(0, 8.0, 8.0, 3)
	effect.set_sprite_texture_rect(0, 65.0, 65.0, 62.0, 62.0, 3)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 3)
	var3 = 0
	while var3 < 3 do
		value = effect.get_random_number(10.0) or value
		value = vm.f32(vm.f32(value - 5.0) + work_vect1_x)
		value_2 = effect.get_random_number(5.0) or value_2
		value_2 = vm.f32(value_2 + work_vect1_y)
		value_3 = effect.get_random_number(10.0) or value_3
		value_3 = vm.f32(vm.f32(value_3 - 5.0) + work_vect1_z)
		effect.set_sprite_position(var3, value, value_2, value_3)
		effect.set_sprite_velocity(var3, 0.0, 0.4, 0.0)
		effect.set_sprite_acceleration(var3, 0.0, -0.03, 0.0)
		value_4 = effect.get_random_number(6.2831855) or value_4
		value_4 = vm.f32(value_4 - vm.f32(3.1415927))
		effect.set_sprite_rotation(var3, value_4)
		value_4 = effect.get_random_number(0.06544985) or value_4
		value_4 = vm.f32(value_4 - vm.f32(0.034147747))
		effect.set_sprite_angular_velocity(var3, value_4)
		var3 = var3 + 1
	end
	var9 = 0
	value_4_2 = 0.0
	var10 = 1.0
	var3 = 0
	while var3 < 30 do
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, value_4_2, 3)
		if value_4_2 >= 128.0 then
			var9 = 1
		end
		if var9 == 0 then
			value_4_2 = vm.f32(value_4_2 + vm.f32(25.6))
		else
			value_4_2 = vm.f32(value_4_2 - vm.f32(12.8))
		end
		effect.set_sprite_scale(0, var10, var10, 3)
		var10 = vm.f32(var10 + vm.f32(0.06))
		var3 = var3 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
