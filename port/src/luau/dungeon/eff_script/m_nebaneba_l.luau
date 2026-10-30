--!strict
-- dungeon/eff_script/m_nebaneba_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var23: s32 = 0
	local value: s32 = 0
	local reversed: s32 = 0
	local scale: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: s32 = 0
	effect.get_owner_character()
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
		local out1, out2, out3 = effect.scale_vector(var9, var10, var11, 3.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.set_effect_character_position(var0, var1, var2)
	effect.rotate_effect_character_toward(var3, var4, var5)
	effect.set_effect_character_motion("ネバネバ液（ループ）")
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	var1 = vm.f32(var1 - 1.0)
	var27 = vm.f32(0.3)
	scale = 5.0
	var23 = 0
	while var23 < 100 do
		if var23 == 5 then
			effect.create_collision_primitive("ねば攻撃")
			effect.set_collision_primitive_damage(value)
		end
		var28 = var10
		do
			local out1, out2, out3 = effect.copy_vector(var6, var7, var8)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.scale_vector(var9, var10, var11, scale)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		var10 = vm.f32(var28 + var27)
		if var10 > vm.f32(2.2) then
			var27 = vm.f32(-0.65)
		end
		scale = vm.f32(scale - vm.f32(0.005))
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
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(var0, var1, var2)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		if var23 > 5 then
			do
				local out1, _, _, _ = effect.get_collision_primitive_knockback()
				reversed = out1 or reversed
			end
			if reversed > 0 then
				effect.create_effect_1("ガードエフェクトＡ")
				effect.set_effect_first_work_vector(var0, var1, var2)
				effect.create_effect_1("ねばねばＨ")
				effect.set_effect_first_work_vector(var0, var1, var2)
				break
			end
		end
		do
			local out1, out2, out3, out4 =
				effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
			var29 = out1 or var29
			var30 = out2 or var30
			var31 = out3 or var31
			var32 = out4 or var32
		end
		if var32 >= 0 then
			effect.create_effect_1("ねばねばＨ")
			effect.set_effect_first_work_vector(var29, var30 + 1.0, var31)
			break
		else
			if var23 > 5 then
				var32 = effect.get_collision_primitive_hit_count() or var32
				if var32 > 0 then
					effect.create_effect_1("ねばねばＨ")
					effect.set_effect_first_work_vector(var0, var1, var2)
					break
				end
			end
			effect.set_effect_character_position(var0, var1, var2)
			effect.rotate_effect_character_toward(var3, var4, var5)
			if var23 > 5 then
				effect.set_collision_primitive_shape(var0, var1, var2, 8.400001)
			end
			vm.wait()
			var23 = var23 + 1
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
