--!strict
-- dungeon/eff_script/e110pol1.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local value_3: s32 = 0
	local value_4: f32 = 0
	local value_4_int = true
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	user_id = effect.get_owner_character() or user_id
	effect.set_sprite_texture("plucas_kirakira")
	effect.allocate_sprites_1(60)
	effect.reset_sprites(0, 60)
	effect.set_sprite_blend_mode(0, 2, 60)
	effect.set_sprite_visible(0, 1, 60)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 60)
	effect.set_sprite_size(0, 8.0, 8.0, 60)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 60)
	var11 = 0
	var10 = 0
	while var10 < 90 do
		do
			local out1, out2, out3 = effect.get_scene_character_position(user_id)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_y = vm.f32(pos_y + 25.0)
		if vm.imod(var10, 1) == 0 then
			for var14 = 0, 3 do
				value_3 = effect.get_random_number_int(4) or value_3
				effect.set_sprite_texture_rect(
					var11,
					vm.i32(vm.imod(value_3, 2) * 32),
					vm.i32(vm.idiv(value_3, 2) * 32),
					32.0,
					32.0
				)
				value = effect.get_random_number(work_vect1_x) or value
				value = vm.f32(vm.f32(value - vm.f32(work_vect1_x / 2.0)) + pos_x)
				value_2 = effect.get_random_number(work_vect1_y) or value_2
				value_2 = vm.f32(vm.f32(value_2 - vm.f32(work_vect1_y / 2.0)) + pos_y)
				var9 = effect.get_random_number(work_vect1_z) or var9
				var9 = vm.f32(vm.f32(var9 - vm.f32(work_vect1_z / 2.0)) + pos_z)
				effect.set_sprite_position(var11, value, value_2, var9)
				value_4 = (if value_4_int then vm.float_bits(effect.get_random_number(1.0)) else effect.get_random_number(1.0)) or value_4
				value_4 = vm.f32(value_4 - 0.5)
				value_4_int = false
				effect.set_sprite_scale(var11, value_4, value_4)
				effect.set_sprite_color(var11, 128.0, 128.0, 128.0, 0.0)
				effect.set_sprite_color_velocity(var11, 0.0, 0.0, 0.0, 32)
				effect.set_sprite_color_acceleration(var11, 0.0, 0.0, 0.0, -4)
				effect.set_sprite_blinking(var11, 0.0, 0.0, 0.0, 64.0, 0.3926991)
				value_2 = effect.get_random_number(-0.3) or value_2
				value_2 = vm.f32(value_2 - vm.f32(0.3))
				effect.set_sprite_velocity(var11, 0.0, value_2, 0.0)
				var9 = effect.get_random_number(6.2831855) or var9
				var9 = vm.f32(var9 - vm.f32(3.1415927))
				var9 = effect.wrap_angle(var9) or var9
				effect.set_sprite_rotation(var11, var9)
				if value_3 ~= 3 then
					var9 = effect.get_random_number(0.4) or var9
					var9 = vm.f32(var9 - vm.f32(0.2))
					effect.set_sprite_angular_velocity(var11, var9)
				end
				var11 = var11 + 1
				if var11 >= 60 then
					var11 = 0
				end
			end
		end
		var10 = var10 + 1
		vm.wait()
	end
	var10 = 0
	while var10 < 30 do
		var10 = var10 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
