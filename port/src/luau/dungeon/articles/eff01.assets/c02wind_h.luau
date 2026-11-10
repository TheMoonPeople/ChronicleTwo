--!strict
-- dungeon/articles/eff01.assets/c02wind_h.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local value: f32 = 0
	local var4: s32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var8: s32 = 0
	local value_5: s32 = 0
	local var10: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = effect.get_script_value_float(0) or value
	var4 = effect.allocate_sprites_2(24) or var4
	if var4 == 0 then
		return
	end
	effect.set_sprite_texture("c02wind")
	effect.reset_sprites(0, 24)
	effect.set_sprite_blend_mode(0, 2, 24)
	effect.set_sprite_visible(0, 1, 24)
	effect.set_sprite_size(0, 20.0, 20.0, 24)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 24)
	effect.set_sprite_scale(0, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 24)
	if value < 1.0 then
		effect.play_battle_sound(73, work_vect1_x, work_vect1_y, work_vect1_z)
	else
		effect.play_battle_sound(79, work_vect1_x, work_vect1_y, work_vect1_z)
	end
	var10 = 0
	var8 = 0
	while var8 < 20 do
		if vm.imod(var8, 1) == 0 then
			value_5 = effect.get_random_number_int(100) or value_5
			if vm.imod(value_5, 2) == 0 then
				effect.set_sprite_texture_rect(var10, 64.0, 0.0, 64.0, 64.0)
			else
				effect.set_sprite_texture_rect(var10, 64.0, 64.0, 64.0, 64.0)
			end
			value_2 = effect.get_random_number(10.0 + vm.f32(10.0 * value)) or value_2
			value_2 = vm.f32(vm.f32(value_2 - vm.f32(vm.f32(10.0 + vm.f32(10.0 * value)) / 2.0)) + work_vect1_x)
			value_3 = effect.get_random_number(10.0 + vm.f32(10.0 * value)) or value_3
			value_3 = vm.f32(-value_3 + work_vect1_y)
			value_4 = effect.get_random_number(10.0 + vm.f32(10.0 * value)) or value_4
			value_4 = vm.f32(vm.f32(value_4 - vm.f32(vm.f32(10.0 + vm.f32(10.0 * value)) / 2.0)) + work_vect1_z)
			effect.set_sprite_position(var10, value_2, value_3, value_4)
			effect.set_sprite_velocity(var10, 0.0, 1.0 + vm.f32(1.0 * value), 0.0)
			effect.set_sprite_acceleration(var10, 0.0, vm.f32(0.1) + vm.f32(vm.f32(0.1) * value), 0.0)
			effect.set_sprite_color(var10, 128.0, 128.0, 128.0, -20.0)
			effect.set_sprite_color_velocity(var10, 0.0, 0.0, 0.0, 25.6)
			effect.set_sprite_color_acceleration(var10, 0.0, 0.0, 0.0, -6.4)
			var10 = var10 + 1
			if var10 >= 24 then
				var10 = 0
			end
		end
		var8 = var8 + 1
		vm.wait()
	end
	var8 = 0
	while var8 < 10 do
		var8 = var8 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
