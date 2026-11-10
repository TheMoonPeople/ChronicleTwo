--!strict
-- dungeon/eff_script/m_hball_c_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local pitch: f32 = 0
	local yaw: f32 = 0
	local var5: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local value: f32 = 0
	local var16: s32 = 0
	local value_2: s32 = 0
	local var19: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	value_2 = 0
	value = 0.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	value_2 = effect.get_script_value(0) or value_2
	value = effect.get_script_value_float(1) or value
	effect.get_script_value(2)
	do
		local out1, out2, out3 = effect.normalize_vector(var9, var10, var11)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.scale_vector(var9, var10, var11, value)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.set_effect_character_motion("冷気弾（発射）")
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(value_2)
	do
		local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	var16 = 0
	while var16 < 90 do
		do
			local out1, out2, out3 = effect.add_vectors(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(var0, var1, var2)
			pitch = out1 or pitch
			yaw = out2 or yaw
			var5 = out3 or var5
		end
		effect.set_effect_character_position(var0, var1, var2)
		effect.rotate_effect_character_toward(pitch, yaw, var5)
		effect.set_collision_primitive_shape(var0, var1, var2, 10.0)
		var19 = effect.get_collision_primitive_hit_count() or var19
		if var19 > 0 then
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var20 = out1 or var20
				var21 = out2 or var21
				var22 = out3 or var22
				var19 = out4 or var19
			end
			if var19 >= 0 then
				effect.create_effect_1("氷柱")
				effect.set_effect_first_work_vector(var20, var21, var22)
				break
			else
				do
					local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				vm.wait()
				var16 = var16 + 1
			end
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
