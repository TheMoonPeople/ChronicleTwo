--!strict
-- dungeon/eff_script/majin_beam.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local vector_z: f32 = 0
	local var25: s32 = 0
	local hit_num: s32 = 0
	local value: s32 = 0
	local user_id: s32 = 0
	local value_2: s32 = 0
	hit_num = 0
	user_id = 0
	effect.set_sprite_texture("nana_rinpun")
	effect.allocate_sprites_1(400)
	effect.reset_sprites(0, 400)
	effect.set_sprite_blend_mode(0, 2, 400)
	effect.set_sprite_visible(0, 1, 400)
	effect.set_sprite_position(0, 0.0, -1000.0, 0.0, 400)
	effect.set_sprite_size(0, 4.5, 4.5, 400)
	effect.set_sprite_texture_rect(0, 129.0, 1.0, 126.0, 126.0, 400)
	user_id = effect.get_owner_character() or user_id
	effect.get_target_character()
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	value = effect.get_script_value(1) or value
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol2")
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.copy_vector(var0, -20.0, var2)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	effect.create_collision_primitive("中ＢＧＣ")
	effect.set_collision_primitive_damage(value)
	var25 = 0
	while true do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol2")
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.copy_vector(var12, -20.0, var14)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var9, var10, var11, var0, 0.0, var2)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.normalize_vector(var9, var10, var11)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.scale_vector(var9, var10, var11, 4.5)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.add_vectors(var3, var4, var5, var9, 0.0, var11)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		var4 = -20.0
		do
			local out1, out2, out3 = effect.copy_vector(var3, var4, var5)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var6, var7, var8, var0, var1, var2)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.divide_vector(var6, var7, var8, 400.0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.spread_sprite_positions(0, var0, var1, var2, var6, var7, var8, 0.0, 0.0, 0.0, 400)
		effect.set_collision_primitive_shape(var3, var4, var5, 20.0)
		hit_num = effect.get_collision_primitive_hit_count() or hit_num
		if hit_num > 0 then
			break
		else
			if vm.imod(var25, 6) == 0 then
				effect.create_effect_1("魔人ビームＨ")
				effect.set_effect_first_work_vector(var3, var4, var5)
				effect.set_effect_value(0, value)
			end
			value_2 = effect.get_script_value(0) or value_2
			if value_2 == 2 then
				break
			else
				vm.wait()
				var25 = vm.i32(var25 + 1)
			end
		end
	end
	if hit_num <= 0 then
		do
			local out1, out2, out3 = effect.get_scene_character_position(0)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		effect.copy_vector(var16, var17, vector_z)
		do
			local out1, out2, out3 = effect.copy_vector(var12, var13, var14)
			var16 = out1 or var16
			var17 = out2 or var17
			vector_z = out3 or vector_z
		end
		var25 = 0
		while true do
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol2")
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			do
				local out1, out2, out3 = effect.get_scene_character_position(0)
				var12 = out1 or var12
				var13 = out2 or var13
				var14 = out3 or var14
			end
			do
				local out1, out2, out3 = effect.copy_vector(var12, var13, var14)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(var9, var10, var11, var3, var4, var5)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			do
				local out1, out2, out3 = effect.normalize_vector(var9, var10, var11)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			do
				local out1, out2, out3 = effect.scale_vector(var9, var10, var11, 4.5)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			do
				local out1, out2, out3 = effect.add_vectors(var3, var4, var5, var9, var10, var11)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
			var4 = vm.f32(var13 - 10.0)
			do
				local out1, out2, out3 = effect.copy_vector(var3, var4, var5)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(var6, var7, var8, var0, var1, var2)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			do
				local out1, out2, out3 = effect.divide_vector(var6, var7, var8, 400.0)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			effect.spread_sprite_positions(0, var0, var1, var2, var6, var7, var8, 0.0, 0.0, 0.0, 400)
			effect.set_collision_primitive_shape(var3, var4, var5, 20.0)
			if vm.imod(var25, 6) == 0 then
				effect.create_effect_1("魔人ビームＨ")
				effect.set_effect_first_work_vector(var3, var4, var5)
				effect.set_effect_value(0, value)
			end
			hit_num = effect.get_collision_primitive_hit_count() or hit_num
			if hit_num > 0 then
				break
			end
			value_2 = effect.get_script_value(0) or value_2
			if value_2 == 3 then
				break
			end
			effect.copy_vector(var16, var17, vector_z)
			do
				local out1, out2, out3 = effect.copy_vector(var12, var13, var14)
				var16 = out1 or var16
				var17 = out2 or var17
				vector_z = out3 or vector_z
			end
			vm.wait()
			var25 = vm.i32(var25 + 1)
		end
	end
	var25 = 0
	effect.set_sprite_color_velocity(0, 128.0, 128.0, 128.0, vm.fdiv(128.0, 60), 400)
	effect.set_sprite_scale_velocity(0, -0.1, 0.0, 400)
	while var25 < 60 do
		do
			local out1, out2 = effect.get_sprite_scale(0)
			var16 = out1 or var16
			var17 = out2 or var17
		end
		if var16 <= 0.0 then
			break
		else
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol2")
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			do
				local out1, out2, out3 = effect.add_vectors(var3, var4, var5, var9, var10, var11)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
			do
				local out1, out2, out3 = effect.copy_vector(var3, var4, var5)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(var6, var7, var8, var0, var1, var2)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			do
				local out1, out2, out3 = effect.divide_vector(var6, var7, var8, 400.0)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			effect.spread_sprite_positions(0, var0, var1, var2, var6, var7, var8, 0.0, 0.0, 0.0, 400)
			if vm.imod(var25, 6) == 0 then
				effect.create_effect_1("魔人ビームＨ")
				effect.set_effect_first_work_vector(var3, 0.0, var5)
			end
			vm.wait()
			var25 = var25 + 1
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
