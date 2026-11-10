--!strict
-- dungeon/eff_script/m_dokueki_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var20: s32 = 0
	local value: s32 = 0
	local scale: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: s32 = 0
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
	effect.set_effect_character_motion("ループ")
	effect.set_effect_character_scale(1.5, 1.5, 1.5)
	effect.set_effect_character_visible(1, 1, 0.1)
	var1 = vm.f32(var1 - 1.0)
	var23 = vm.f32(0.3)
	scale = 5.0
	var20 = 0
	while var20 < 100 do
		if var20 == 5 then
			effect.create_collision_primitive("毒液２")
			effect.set_collision_primitive_damage(value)
		end
		var24 = var10
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
		var10 = vm.f32(var24 + var23)
		if var10 > vm.f32(2.2) then
			var23 = vm.f32(-0.65)
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
		do
			local out1, out2, out3, out4 =
				effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
			var25 = out1 or var25
			var26 = out2 or var26
			var27 = out3 or var27
			var28 = out4 or var28
		end
		if var28 >= 0 then
			effect.create_effect_1("毒液H")
			effect.set_effect_first_work_vector(var25, var26 + 1.0, var27)
			break
		else
			if var20 > 5 then
				var28 = effect.get_collision_primitive_hit_count() or var28
				if var28 > 0 then
					effect.create_effect_1("毒液H")
					effect.set_effect_first_work_vector(var0, var1, var2)
					break
				end
			end
			effect.set_effect_character_position(var0, var1, var2)
			effect.rotate_effect_character_toward(var3, var4, var5)
			if var20 > 5 then
				effect.set_collision_primitive_shape(var0, var1, var2, 6.0)
			end
			vm.wait()
			var20 = var20 + 1
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
