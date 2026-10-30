--!strict
-- dungeon/eff_script/b11a_arrow3.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local yaw: f32 = 0
	local var8: f32 = 0
	local dir_x: f32 = 0
	local dir_y: f32 = 0
	local dir_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var27: s32 = 0
	local user_id: s32 = 0
	local value_4: s32 = 0
	local value_5: s32 = 0
	local var31: s32 = 0
	local value_6: s32 = 0
	local value_7: s32 = 0
	local value_8: s32 = 0
	local var35: s32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	value_5 = 0
	value = 0.0
	value_2 = 0.0
	value_3 = 0.0
	var31 = 0
	value_6 = 0
	value_7 = 0
	value_5 = effect.get_script_value(0) or value_5
	value = effect.get_script_value_float(2) or value
	value_2 = effect.get_script_value_float(3) or value_2
	value_3 = effect.get_script_value_float(4) or value_3
	value_6 = effect.get_script_value(5) or value_6
	value_7 = effect.get_script_value(6) or value_7
	user_id = effect.get_owner_character() or user_id
	effect.set_effect_character_motion("発射前", 4)
	effect.set_effect_character_visible(1, 1, 0.5)
	while true do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "arrow")
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "arrow")
			var6 = out1 or var6
			yaw = out2 or yaw
			var8 = out3 or var8
		end
		effect.set_effect_character_position(var0, var1, var2)
		effect.rotate_effect_character_toward(var6, yaw, var8)
		value_4 = effect.get_script_value(1) or value_4
		if value_4 ~= 0 then
			break
		else
			vm.wait()
		end
	end
	value_8 = 0
	value_8 = effect.get_random_number_int(6) or value_8
	if value_8 == 0 then
		effect.create_collision_primitive("通常攻撃")
	end
	if value_8 == 1 then
		effect.create_collision_primitive("呪い攻撃")
	end
	if value_8 == 2 then
		effect.create_collision_primitive("ねば攻撃")
	end
	if value_8 == 3 then
		effect.create_collision_primitive("石化攻撃")
	end
	if value_8 == 4 then
		effect.create_collision_primitive("毒液２")
	end
	if value_8 == 5 then
		effect.create_collision_primitive("ＤＥ矢")
	end
	effect.set_collision_primitive_damage(value_5)
	do
		local out1, out2, out3 = effect.get_effect_character_position()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "arrow")
		var6 = out1 or var6
		yaw = out2 or yaw
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.get_direction_vector(var6, yaw, var8)
		dir_x = out1 or dir_x
		dir_y = out2 or dir_y
		dir_z = out3 or dir_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(dir_x, dir_y, dir_z)
		var21 = out1 or var21
		var22 = out2 or var22
		var23 = out3 or var23
	end
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_y = vm.f32(pos_y + 20.0)
	do
		local out1, out2, out3 = effect.get_effect_character_position()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.copy_vector(pos_x, pos_y, pos_z)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(var18, var19, var20, var0, var1, var2)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	do
		local out1, out2, out3 = effect.normalize_vector(var18, var19, var20)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	var27 = 0
	while var27 < 150 do
		value = vm.f32(value + value_2)
		if value_6 > 0 or var27 > value_7 then
			if value_6 > 0 then
				do
					local out1, out2, out3 = effect.copy_vector(dir_x, dir_y, dir_z)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3 = effect.scale_vector(var3, var4, var5, value)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				value_6 = value_6 - 1
			else
				do
					local out1, out2, out3 = effect.copy_vector(var21, var22, var23)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3 = effect.scale_vector(var3, var4, var5, value)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
			end
		else
			print("kita-----------------\n")
			do
				local out1, out2, out3 = effect.get_scene_character_position(0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var18 = vm.f32(pos_x - var0)
			var19 = vm.f32(pos_y - var1)
			var20 = vm.f32(pos_z - var2)
			do
				local out1, out2, out3 = effect.normalize_vector(var18, var19, var20)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = effect.scale_vector(var18, var19, var20, value_3)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = effect.scale_vector(var21, var22, var23, 1.0 - value_3)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = effect.add_vectors(var21, var22, var23, var18, var19, var20)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = effect.normalize_vector(var21, var22, var23)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = effect.copy_vector(var21, var22, var23)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
			do
				local out1, out2, out3 = effect.scale_vector(var3, var4, var5, value)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
		end
		do
			local out1, out2, out3 = effect.add_vectors(var0, var1, var2, var3, var4, var5)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(var0, var1, var2)
			var6 = out1 or var6
			yaw = out2 or yaw
			var8 = out3 or var8
		end
		var35 = effect.get_collision_primitive_hit_count() or var35
		if var35 > 0 then
			effect.create_effect_1("ＤＥ矢Ｈ")
			effect.set_effect_first_work_vector(var0, var1, var2)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var36 = out1 or var36
				var37 = out2 or var37
				var38 = out3 or var38
				var35 = out4 or var35
			end
			if var35 >= 0 then
				effect.create_effect_1("ＤＥ矢Ｈ")
				effect.set_effect_first_work_vector(var36, var37, var38)
				effect.set_effect_character_position(var36, var37, var38)
				var31 = 1
				break
			else
				effect.set_effect_character_position(var0, var1, var2)
				effect.rotate_effect_character_toward(var6, yaw, var8)
				effect.set_collision_primitive_shape(vector_x, vector_y, vector_z, var0, var1, var2, 15.0)
				do
					local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				vm.wait()
				var27 = var27 + 1
			end
		end
	end
	effect.delete_collision_primitive(-1)
	if var31 ~= 0 then
		var27 = 0
		effect.set_effect_character_visible(0, 1, -0.5)
		while var27 < 60 do
			vm.wait()
			var27 = var27 + 1
		end
	end
	effect.set_effect_character_visible(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
