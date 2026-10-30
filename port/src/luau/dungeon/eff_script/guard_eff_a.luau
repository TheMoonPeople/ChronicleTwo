--!strict
-- dungeon/eff_script/guard_eff_a.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: s32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	value = 0
	effect.copy_vector(0.0, 0.0, 0.0)
	value = effect.get_script_value(0) or value
	effect.get_second_work_vector()
	effect.copy_vector(96.0, 128.0, 96.0)
	value = 0
	if value == 0 then
		effect.set_sprite_texture("effect01")
		effect.allocate_sprites_1(2)
		effect.reset_sprites(0)
		effect.set_sprite_blend_mode(0, 2)
		effect.set_sprite_visible(0, 1)
		effect.set_sprite_position(0, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(0, 30.0, 30.0)
		effect.set_sprite_texture_rect(0, 0, 0, 128.0, 128.0)
		effect.set_sprite_color(0, 96.0, 128.0, 96.0, 128.0)
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 0)
		effect.set_sprite_position(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(1, 25.0, 25.0)
		effect.set_sprite_texture_rect(1, 0, 0, 128.0, 128.0)
		effect.set_sprite_color(1, 96.0, 128.0, 96.0, 64.0)
		effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -8.0)
		effect.set_sprite_color_velocity(1, 0.0, 0.0, 0.0, -2.0)
		var9 = 1.0
		var10 = 1.0
		var11 = 0
		while var11 <= 36 do
			effect.set_sprite_scale(0, var9, var9)
			effect.set_sprite_scale(1, var10, var10)
			var9 = vm.f32(var9 + vm.f32(0.03))
			if var11 == 4 then
				effect.set_sprite_visible(1, 1)
			end
			if var11 > 4 then
				var10 = vm.f32(var10 + vm.f32(0.02))
			end
			var11 = var11 + 1
			vm.wait()
		end
	end
	if value == 1 then
		effect.set_sprite_texture("effect01")
		effect.allocate_sprites_1(3)
		effect.reset_sprites(0)
		effect.set_sprite_blend_mode(0, 2)
		effect.set_sprite_visible(0, 1)
		effect.set_sprite_position(0, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(0, 60.0, 60.0)
		effect.set_sprite_texture_rect(0, 128.0, 0.0, 128.0, 128.0)
		effect.set_sprite_color(0, 96.0, 128.0, 96.0, 128.0)
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 0)
		effect.set_sprite_position(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(1, 42.0, 42.0)
		effect.set_sprite_texture_rect(1, 128.0, 0.0, 128.0, 128.0)
		effect.set_sprite_color(1, 96.0, 128.0, 96.0, 128.0)
		effect.reset_sprites(2)
		effect.set_sprite_blend_mode(2, 2)
		effect.set_sprite_visible(2, 0)
		effect.set_sprite_position(2, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(2, 32.0, 32.0)
		effect.set_sprite_texture_rect(2, 128.0, 0.0, 128.0, 128.0)
		effect.set_sprite_color(2, 96.0, 128.0, 96.0, 32.0)
		effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -8.0)
		effect.set_sprite_color_velocity(1, 0.0, 0.0, 0.0, -8.0)
		effect.set_sprite_color_velocity(2, 0.0, 0.0, 0.0, -2.0)
		var12 = 1.0
		var13 = 1.0
		var14 = 1.0
		var15 = 0
		effect.set_sprite_visible(0, 0)
		effect.set_sprite_angular_velocity(1, 0.03)
		effect.set_sprite_angular_acceleration(1, 0.015, 0.015, 0.015)
		while var15 <= 36 do
			effect.set_sprite_scale(0, var12, var12)
			effect.set_sprite_scale(1, var13, var13)
			effect.set_sprite_scale(2, var14, var14)
			var12 = vm.f32(var12 - vm.f32(0.02))
			if var15 == 0 then
				effect.set_sprite_visible(1, 1)
			end
			if var15 > 0 then
				var13 = vm.f32(var13 - vm.f32(0.04))
			end
			if var13 <= vm.f32(0.6) then
				break
			end
			var15 = vm.i32(var15 + 1)
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
