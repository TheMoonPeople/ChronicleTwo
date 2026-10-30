--!strict
-- dungeon/eff_script/e10b_neva_momo.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local revers_vec_x: f32 = 0
	local revers_vec_y: f32 = 0
	local revers_vec_z: f32 = 0
	local var18: s32 = 0
	local value: s32 = 0
	local reversed: s32 = 0
	local var21: s32 = 0
	local scale: f32 = 0
	local scale_2: f32 = 0
	local var24: f32 = 0
	local var26: s32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	var21 = 0
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
	do
		local out1, out2, out3 = effect.get_direction_vector(var3, var4, var5)
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
		local out1, out2, out3 = effect.scale_vector(var9, var10, var11, 8.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.set_effect_character_position(var0, var1, var2)
	effect.rotate_effect_character_toward(var3, var4, var5)
	effect.set_effect_character_motion("ループ")
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.create_collision_primitive("ねば攻撃")
	effect.set_collision_primitive_damage(value)
	var18 = 0
	while var18 < 90 do
		scale = vm.f32(vm.f32(0.5 * vm.cos(0.0)) * var18)
		scale_2 = vm.f32(
			vm.f32(vm.f32(0.5 * vm.sin(0.0)) * var18) - vm.f32(vm.f32(vm.f32(vm.f32(0.005) * var18) * var18) / 2)
		)
		do
			local out1, out2, out3 = effect.copy_vector(var6, var7, var8)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.scale_vector(var9, var24, var11, scale)
			var9 = out1 or var9
			var24 = out2 or var24
			var11 = out3 or var11
		end
		var10 = 1.0
		do
			local out1, out2, out3 = effect.scale_vector(var24, var10, vm.bits_float(var26) :: number, scale_2)
			var24 = out1 or var24
			var10 = out2 or var10
			var26 = vm.float_bits(out3) or var26
		end
		do
			local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		effect.set_effect_character_position(var0, var1, var2)
		effect.set_collision_primitive_shape(var0, var1, var2, 9.0)
		do
			local out1, out2, out3, out4 = effect.get_collision_primitive_knockback()
			reversed = out1 or reversed
			revers_vec_x = out2 or revers_vec_x
			revers_vec_y = out3 or revers_vec_y
			revers_vec_z = out4 or revers_vec_z
		end
		if reversed > 0 then
			effect.create_effect_1("ガードエフェクトＡ")
			effect.set_effect_first_work_vector(var0, var1, var2)
			break
		else
			var26 = effect.get_collision_primitive_hit_count() or var26
			if var26 > 0 then
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
					var27 = out1 or var27
					var28 = out2 or var28
					var29 = out3 or var29
					var26 = out4 or var26
				end
				if var26 >= 0 then
					effect.set_effect_character_position(var27, var28, var29)
					var21 = 1
					break
				else
					vm.wait()
					var18 = var18 + 1
				end
			end
		end
	end
	effect.delete_collision_primitive(-1)
	if reversed > 0 then
		if revers_vec_x == 0.0 and revers_vec_y == 0.0 and revers_vec_z == 0.0 then
			print("reverse zero vector-----------\n")
			reversed = 0
		end
	end
	vm.wait()
	if reversed > 0 then
		effect.create_collision_primitive("ねば攻撃", 0)
		effect.set_collision_primitive_damage(value)
		do
			local out1, out2, out3 = effect.copy_vector(revers_vec_x, revers_vec_y, revers_vec_z)
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
			local out1, out2, out3 = effect.scale_vector(var9, var10, var11, 10.0)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		var18 = 0
		while var18 < 60 do
			do
				local out1, out2, out3 = effect.get_effect_character_position()
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
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
			effect.set_effect_character_position(var0, var1, var2)
			effect.rotate_effect_character_toward(var3, var4, var5)
			effect.set_collision_primitive_shape(var0, var1, var2, 5.0)
			var30 = effect.get_collision_primitive_hit_count() or var30
			if var30 > 0 then
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
					var31 = out1 or var31
					var32 = out2 or var32
					var33 = out3 or var33
					var30 = out4 or var30
				end
				if var30 >= 0 then
					effect.set_effect_character_position(var31, var32, var33)
					var21 = 1
					break
				else
					do
						local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
						vector_x = out1 or vector_x
						vector_y = out2 or vector_y
						vector_z = out3 or vector_z
					end
					vm.wait()
					var18 = var18 + 1
				end
			end
		end
		effect.delete_collision_primitive(-1)
	end
	if var21 ~= 0 then
		effect.set_effect_character_visible(0, 1, -3.0)
		var18 = 0
		while var18 < 30 do
			vm.wait()
			var18 = var18 + 1
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
