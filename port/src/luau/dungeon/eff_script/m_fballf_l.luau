--!strict
-- dungeon/eff_script/m_fballf_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local scale: f32 = 0
	local scale_2: f32 = 0
	local var23: f32 = 0
	local var25: s32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: s32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
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
	effect.set_effect_character_motion("火炎弾ループ")
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	var18 = 0
	while var18 < 10 do
		vm.wait()
		var18 = var18 + 1
	end
	effect.create_collision_primitive("火弾")
	effect.set_collision_primitive_damage(value)
	var18 = 0
	while var18 < 60 do
		scale = vm.f32(vm.f32(1.5 * vm.cos(0.0)) * var18)
		scale_2 = vm.f32(
			vm.f32(vm.f32(1.5 * vm.sin(0.0)) * var18) - vm.f32(vm.f32(vm.f32(vm.f32(0.025) * var18) * var18) / 2)
		)
		do
			local out1, out2, out3 = effect.copy_vector(var6, var7, var8)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.scale_vector(var9, var23, var11, scale)
			var9 = out1 or var9
			var23 = out2 or var23
			var11 = out3 or var11
		end
		var10 = 1.0
		do
			local out1, out2, out3 = effect.scale_vector(var23, var10, vm.bits_float(var25) :: number, scale_2)
			var23 = out1 or var23
			var10 = out2 or var10
			var25 = vm.float_bits(out3) or var25
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
		effect.set_collision_primitive_shape(var0, var1, var2, 10.0)
		do
			local out1, out2, out3, out4 = effect.get_collision_primitive_knockback()
			reversed = out1 or reversed
			revers_vec_x = out2 or revers_vec_x
			revers_vec_y = out3 or revers_vec_y
			revers_vec_z = out4 or revers_vec_z
		end
		if reversed > 0 then
			effect.call_command(250, var0, var1, var2) -- retail: command 250 is not registered
			break
		else
			var25 = effect.get_collision_primitive_hit_count() or var25
			if var25 > 0 then
				effect.create_effect_1("火弾Ｈ")
				effect.set_effect_first_work_vector(var0, var1, var2)
				effect.set_effect_second_work_vector(var3, var4, var5)
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
					var25 = out4 or var25
				end
				if var25 >= 0 then
					do
						local out1, out2, out3 = effect.normalize_vector(var9, var10, var11)
						var9 = out1 or var9
						var10 = out2 or var10
						var11 = out3 or var11
					end
					do
						local out1, out2, out3 = effect.scale_vector(var9, var10, var11, 9.6)
						var9 = out1 or var9
						var10 = out2 or var10
						var11 = out3 or var11
					end
					do
						local out1, out2, out3 = effect.copy_vector(var26, var27, var28)
						var29 = out1 or var29
						var30 = out2 or var30
						var31 = out3 or var31
					end
					do
						local out1, out2, out3 = effect.add_vectors(var29, var30, var31, -var9, -var10, -var11)
						var29 = out1 or var29
						var30 = out2 or var30
						var31 = out3 or var31
					end
					effect.create_effect_1("火弾Ｈ")
					effect.set_effect_first_work_vector(var29, var30, var31)
					effect.set_effect_second_work_vector(var3, var4, var5)
					break
				else
					vm.wait()
					var18 = var18 + 1
				end
			end
		end
	end
	effect.delete_collision_primitive(-1)
	vm.wait()
	if reversed > 0 then
		effect.create_collision_primitive("火弾", 0)
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
			effect.set_collision_primitive_shape(var0, var1, var2, 6.0)
			var32 = effect.get_collision_primitive_hit_count() or var32
			if var32 > 0 then
				effect.create_effect_1("火弾Ｈ")
				effect.set_effect_first_work_vector(var0, var1, var2)
				effect.set_effect_second_work_vector(var3, var4, var5)
				break
			else
				do
					local out1, out2, out3, out4 =
						effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
					var32 = out4 or var32
				end
				if var32 >= 0 then
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
						local out1, out2, out3 = effect.copy_vector(var33, var34, var35)
						var36 = out1 or var36
						var37 = out2 or var37
						var38 = out3 or var38
					end
					do
						local out1, out2, out3 = effect.add_vectors(var36, var37, var38, -var9, -var10, -var11)
						var36 = out1 or var36
						var37 = out2 or var37
						var38 = out3 or var38
					end
					effect.create_effect_1("火弾Ｈ")
					effect.set_effect_first_work_vector(var36, var37, var38)
					effect.set_effect_second_work_vector(var3, var4, var5)
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
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
