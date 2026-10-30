--!strict
-- dungeon/eff_script/beam.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	effect.set_sprite_texture("nana_rinpun")
	effect.allocate_sprites_1(600)
	effect.reset_sprites(0, 600)
	effect.set_sprite_blend_mode(0, 2, 600)
	effect.set_sprite_visible(0, 1, 600)
	effect.set_sprite_position(0, 0.0, -1000.0, 0.0, 600)
	effect.set_sprite_size(0, 4.0, 4.0, 600)
	effect.set_sprite_texture_rect(0, 129.0, 1.0, 126.0, 126.0, 600)
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
		do
			local out1, out2, out3 = effect.copy_vector(work_vect2_x, work_vect2_y, work_vect2_z)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var6, var7, var8, work_vect1_x, work_vect1_y, work_vect1_z)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.divide_vector(var6, var7, var8, 600.0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.spread_sprite_positions(0, work_vect1_x, work_vect1_y, work_vect1_z, var6, var7, var8, 0.0, 0.0, 0.0, 600)
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
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	value = 128.0
	value_2 = 128.0
	value_3 = 128.0
	value_4 = 128.0
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
		do
			local out1, out2, out3 = effect.copy_vector(work_vect2_x, work_vect2_y, work_vect2_z)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var6, var7, var8, work_vect1_x, work_vect1_y, work_vect1_z)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.divide_vector(var6, var7, var8, 600.0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.spread_sprite_positions(0, work_vect1_x, work_vect1_y, work_vect1_z, var6, var7, var8, 0.0, 0.0, 0.0, 600)
		effect.set_sprite_color(0, value, value_2, value_3, value_4, 600)
		value_4 = vm.f32(value_4 - 4.0)
		if value_4 <= 0.0 then
			break
		else
			vm.wait()
		end
	end
end

return script
