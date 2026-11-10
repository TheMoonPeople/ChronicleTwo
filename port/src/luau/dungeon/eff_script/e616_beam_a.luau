--!strict
-- dungeon/eff_script/e616_beam_a.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var7: f32 = 0
	local var8: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: s32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local get_now_frame_wait: f32 = 0
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
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.rotate_effect_character_toward(work_vect2_x, work_vect2_y, work_vect2_z)
	effect.set_effect_character_motion("弾道", -1, 6)
	effect.set_sprite_texture("e616_tama")
	effect.allocate_sprites_1(120)
	effect.reset_sprites(0, 120)
	effect.set_sprite_blend_mode(0, 2, 120)
	effect.set_sprite_visible(0, 1, 120)
	effect.set_sprite_size(0, 200.0, 200.0, 120)
	effect.set_sprite_texture_rect(0, 1.0, 1.0, 62.0, 62.0, 120)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 120)
	effect.set_effect_character_frame_visible("tama", 0, 1)
	vm.wait()
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("tama--ba")
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	vm.wait()
	var15 = 0
	while true do
		do
			local out1, out2, out3 = effect.copy_vector(var6, var7, var8)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_frame_position("tama--ba")
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.copy_vector(var6, var7, var8)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var12, var13, var14, vector_x, vector_y, vector_z)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = effect.divide_vector(var12, var13, var14, 4)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = effect.copy_vector(vector_x, vector_y, vector_z)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		for var19 = 0, 3 do
			effect.set_sprite_position(var15, var16, var17, var18)
			effect.set_sprite_color(var15, 128.0, 128.0, 128.0, 128.0)
			effect.set_sprite_scale(var15, 1.0, 1.0)
			effect.ease_sprite_color(var15, 128.0, 128.0, 128.0, 0.0, 10)
			effect.ease_sprite_scale(var15, 0.1, 0.1, 10)
			do
				local out1, out2, out3 = effect.add_vectors(var16, var17, var18, var12, var13, var14)
				var16 = out1 or var16
				var17 = out2 or var17
				var18 = out3 or var18
			end
			var15 = vm.i32(var15 + 1)
		end
		if var15 >= 120 then
			var15 = 0
		end
		get_now_frame_wait = effect.get_effect_character_motion_progress() or get_now_frame_wait
		if get_now_frame_wait >= 1.0 then
			break
		else
			vm.wait()
		end
	end
	var15 = 0
	while var15 < 30 do
		var15 = var15 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
