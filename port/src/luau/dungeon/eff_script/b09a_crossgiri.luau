--!strict
-- dungeon/eff_script/b09a_crossgiri.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local dir_x: f32 = 0
	local dir_y: f32 = 0
	local dir_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local scale: f32 = 0
	local var17: s32 = 0
	local value: s32 = 0
	local var19: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	value = effect.get_script_value(0) or value
	effect.set_effect_character_position(var0, var1, var2)
	effect.rotate_effect_character_toward(var6, var7, var8)
	effect.set_effect_character_motion("ループ")
	scale = 10.0
	do
		local out1, out2, out3 = effect.get_direction_vector(var6, var7, var8)
		dir_x = out1 or dir_x
		dir_y = out2 or dir_y
		dir_z = out3 or dir_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(dir_x, dir_y, dir_z)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.normalize_vector(var12, var13, var14)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.scale_vector(var12, var13, var14, 10.0)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	effect.create_collision_primitive("吹っ飛び中")
	effect.set_collision_primitive_damage(value)
	do
		local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var17 = 0
	while var17 < 130 do
		do
			local out1, out2, out3 = effect.copy_vector(dir_x, dir_y, dir_z)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = effect.normalize_vector(var12, var13, var14)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		do
			local out1, out2, out3 = effect.scale_vector(var12, var13, var14, scale)
			var12 = out1 or var12
			var13 = out2 or var13
			var14 = out3 or var14
		end
		scale = vm.f32(scale + vm.f32(1.2))
		vm.wait()
		do
			local out1, out2, out3 = effect.add_vectors(var0, var1, var2, var12, var13, var14)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(var0, var1, var2)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.set_effect_character_position(var0, var1, var2)
		effect.set_collision_primitive_shape(var0, var1, var2, 25.0)
		var19 = effect.get_collision_primitive_hit_count() or var19
		if var19 > 0 then
			effect.delete_collision_primitive(-1)
			if var17 < 115 then
				var17 = 115
			end
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
			var19 = out4 or var19
		end
		if var19 >= 0 then
			effect.delete_collision_primitive(-1)
			if var17 < 115 then
				var17 = 115
			end
		end
		do
			local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		if var17 == 115 then
			effect.delete_collision_primitive(-1)
			effect.set_effect_character_visible(0, 1, -0.9)
		end
		var17 = var17 + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
