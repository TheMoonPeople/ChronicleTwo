--!strict
-- dungeon/eff_script/m_bt_neba_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var15: s32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	value_2 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	value = effect.get_script_value(0) or value
	value_2 = effect.get_script_value(1) or value_2
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	var7 = vm.f32(var7 + 15.0)
	do
		local out1, out2, out3 = effect.subtract_vectors(var6, var7, var8, var0, var1, var2)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.normalize_vector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.copy_vector(var6, var7, var8)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.scale_vector(var9, var10, var11, 12.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.set_effect_character_position(var0, var1, var2)
	effect.rotate_effect_character_toward(var3, var4, var5)
	effect.set_effect_character_motion("ループ")
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_visible(1, 1, 0.1)
	if value_2 == 0 then
		effect.create_collision_primitive("通常攻撃")
	end
	if value_2 == 1 then
		effect.create_collision_primitive("ねば攻撃")
	end
	effect.set_collision_primitive_damage(value)
	do
		local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var15 = 0
	while var15 < 60 do
		do
			local out1, out2, out3 = effect.add_vectors(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(var0, var1, var2)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		var18 = effect.get_collision_primitive_hit_count() or var18
		if var18 > 0 then
			effect.create_effect_1("ねばねばＨ")
			effect.set_effect_first_work_vector(var0, var1, var2)
			effect.set_effect_second_work_vector(var3, var4, var5)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
				var18 = out4 or var18
			end
			if var18 >= 0 then
				do
					local out1, out2, out3 = effect.normalize_vector(var9, var10, var11)
					var9 = out1 or var9
					var10 = out2 or var10
					var11 = out3 or var11
				end
				do
					local out1, out2, out3 = effect.scale_vector(var9, var10, var11, 10.0)
					var9 = out1 or var9
					var10 = out2 or var10
					var11 = out3 or var11
				end
				do
					local out1, out2, out3 = effect.copy_vector(var19, var20, var21)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				do
					local out1, out2, out3 = effect.add_vectors(var22, var23, var24, -var9, -var10, -var11)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				effect.create_effect_1("ねばねばＨ")
				effect.set_effect_first_work_vector(var22, var23, var24)
				effect.set_effect_second_work_vector(var3, var4, var5)
				break
			else
				effect.set_effect_character_position(var0, var1, var2)
				effect.rotate_effect_character_toward(var3, var4, var5)
				effect.set_collision_primitive_shape(var0, var1, var2, 8.400001)
				do
					local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				vm.wait()
				var15 = var15 + 1
			end
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
