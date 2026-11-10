--!strict
-- dungeon/eff_script/b11a_arrow.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value_4: f32 = 0
	local var19: s32 = 0
	local user_id: s32 = 0
	local value_5: s32 = 0
	local value_7: s32 = 0
	local var24: s32 = 0
	local var25: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var39: s32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: f32 = 0
	value = 0.0
	value_2 = 0.0
	value_3 = 0.0
	value_4 = 0.0
	effect.get_script_value(0)
	value = effect.get_script_value_float(2) or value
	value_2 = effect.get_script_value_float(3) or value_2
	value_7 = effect.get_script_value(4) or value_7
	value_3 = effect.get_script_value_float(5) or value_3
	value_4 = effect.get_script_value_float(6) or value_4
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
		value_5 = effect.get_script_value(1) or value_5
		if value_5 ~= 0 then
			break
		else
			vm.wait()
		end
	end
	effect.create_collision_primitive("通常攻撃")
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
	var24 = 0
	var19 = 0
	while var19 < 9 do
		value = vm.f32(value + value_2)
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
		do
			local out1, out2, out3 = effect.add_vectors(var0, var1, var2, var3, var4, var5)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var25 = effect.get_collision_primitive_hit_count() or var25
		if var25 > 0 then
			var24 = 1
			break
		else
			do
				local _, _, _, out4 = effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var25 = out4 or var25
			end
			if var25 >= 0 then
				var24 = 1
				break
			else
				effect.set_effect_character_position(var0, var1, var2)
				effect.set_collision_primitive_shape(var0, var1, var2, 6.0)
				do
					local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				vm.wait()
				var19 = var19 + 1
			end
		end
	end
	if var24 == 0 then
		do
			local out1, out2, out3 = effect.get_scene_character_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_y = vm.f32(pos_y + 30.0)
		do
			local out1, out2, out3 = effect.get_effect_character_position()
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.copy_vector(pos_x, pos_y, pos_z)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var32, var33, var34, var0, var1, var2)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3 = effect.normalize_vector(var32, var33, var34)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		x = vm.f32(vm.f32(var32 * vm.cos(value_4)) + vm.f32(var34 * vm.sin(value_4)))
		y = var33
		z = vm.f32(vm.f32(var32 * -vm.sin(value_4)) + vm.f32(var34 * vm.cos(value_4)))
		var19 = 0
		while var19 < 60 do
			value = vm.f32(value + value_2)
			if value_7 ~= 0 then
				do
					local out1, out2, out3 = effect.get_scene_character_position(0)
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
			end
			var32 = vm.f32(pos_x - var0)
			var33 = vm.f32(pos_y - var1)
			var34 = vm.f32(pos_z - var2)
			do
				local out1, out2, out3 = effect.normalize_vector(var32, var33, var34)
				var32 = out1 or var32
				var33 = out2 or var33
				var34 = out3 or var34
			end
			do
				local out1, out2, out3 = effect.scale_vector(var32, var33, var34, value_3)
				var32 = out1 or var32
				var33 = out2 or var33
				var34 = out3 or var34
			end
			do
				local out1, out2, out3 = effect.scale_vector(x, y, z, 1.0 - value_3)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = effect.add_vectors(x, y, z, var32, var33, var34)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = effect.normalize_vector(x, y, z)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = effect.copy_vector(x, y, z)
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
			var39 = effect.get_collision_primitive_hit_count() or var39
			if var39 > 0 then
				effect.create_effect_1("ＤＥ矢Ｈ")
				effect.set_effect_first_work_vector(var0, var1, var2)
				var24 = 1
				break
			end
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var40 = out1 or var40
				var41 = out2 or var41
				var42 = out3 or var42
				var39 = out4 or var39
			end
			if var39 >= 0 then
				effect.create_effect_1("ＤＥ矢Ｈ")
				effect.set_effect_first_work_vector(var40, var41, var42)
				var24 = 1
				break
			end
			effect.set_effect_character_position(var0, var1, var2)
			effect.rotate_effect_character_toward(var6, yaw, var8)
			effect.set_collision_primitive_shape(var0, var1, var2, 6.0)
			do
				local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
				vector_x = out1 or vector_x
				vector_y = out2 or vector_y
				vector_z = out3 or vector_z
			end
			vm.wait()
			var19 = var19 + 1
		end
	end
	effect.delete_collision_primitive(-1)
	var19 = 0
	effect.set_effect_character_visible(0, 1, -3.0)
	while var19 < 15 do
		vm.wait()
		var19 = var19 + 1
	end
	effect.set_effect_character_visible(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
