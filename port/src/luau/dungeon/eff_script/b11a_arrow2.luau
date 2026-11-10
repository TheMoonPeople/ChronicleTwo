--!strict
-- dungeon/eff_script/b11a_arrow2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value_6: s32 = 0
	local value_7: s32 = 0
	local value_8: s32 = 0
	local var25: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: s32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: f32 = 0
	value_6 = 0
	value = 0.0
	value_2 = 0.0
	value_3 = 0.0
	value_4 = 0.0
	var25 = 0
	value_6 = effect.get_script_value(0) or value_6
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
	effect.set_collision_primitive_damage(value_6)
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
	effect.get_direction_vector(var6, yaw, var8)
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
		var29 = out1 or var29
		var30 = out2 or var30
		var31 = out3 or var31
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(var29, var30, var31, var0, var1, var2)
		var29 = out1 or var29
		var30 = out2 or var30
		var31 = out3 or var31
	end
	do
		local out1, out2, out3 = effect.normalize_vector(var29, var30, var31)
		var29 = out1 or var29
		var30 = out2 or var30
		var31 = out3 or var31
	end
	var32 = vm.f32(vm.f32(var29 * vm.cos(value_4)) + vm.f32(var31 * vm.sin(value_4)))
	var33 = var30
	var34 = vm.f32(vm.f32(var29 * -vm.sin(value_4)) + vm.f32(var31 * vm.cos(value_4)))
	var37 = vm.sin(vm.f32(-1.5707964))
	var36 = vm.cos(vm.f32(-1.5707964))
	var38 = vm.f32(1.0 - var36)
	pos_x = vm.f32(
		vm.f32(
			vm.f32(var32 * vm.f32(var36 + vm.f32(vm.f32(var38 * var29) * var29)))
				+ vm.f32(var33 * vm.f32(vm.f32(vm.f32(var38 * var29) * var30) + vm.f32(var31 * var37)))
		) + vm.f32(var34 * vm.f32(vm.f32(vm.f32(var38 * var29) * var31) + vm.f32(var30 * var37)))
	)
	pos_y = vm.f32(
		vm.f32(
			vm.f32(var32 * vm.f32(vm.f32(vm.f32(var38 * var29) * var30) - vm.f32(var31 * var37)))
				+ vm.f32(var33 * vm.f32(var36 + vm.f32(vm.f32(var38 * var30) * var30)))
		) + vm.f32(var34 * vm.f32(vm.f32(vm.f32(var38 * var30) * var31) + vm.f32(var29 * var37)))
	)
	pos_z = vm.f32(
		vm.f32(
			vm.f32(var32 * vm.f32(vm.f32(vm.f32(var38 * var31) * var29) + vm.f32(var30 * var37)))
				+ vm.f32(var33 * vm.f32(vm.f32(vm.f32(var38 * var30) * var31) - vm.f32(var29 * var37)))
		) + vm.f32(var34 * vm.f32(var36 + vm.f32(vm.f32(var38 * var31) * var31)))
	)
	do
		local out1, out2, out3 = effect.copy_vector(pos_x, pos_y, pos_z)
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
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_y = vm.f32(pos_y + 20.0)
	var19 = 0
	while var19 < 150 do
		value = vm.f32(value - value_2)
		if value_7 ~= 0 then
			do
				local out1, out2, out3 = effect.get_scene_character_position(0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
		end
		var29 = vm.f32(pos_x - var0)
		var30 = vm.f32(pos_y - var1)
		var31 = vm.f32(pos_z - var2)
		do
			local out1, out2, out3 = effect.normalize_vector(var29, var30, var31)
			var29 = out1 or var29
			var30 = out2 or var30
			var31 = out3 or var31
		end
		do
			local out1, out2, out3 = effect.scale_vector(var29, var30, var31, value_3)
			var29 = out1 or var29
			var30 = out2 or var30
			var31 = out3 or var31
		end
		do
			local out1, out2, out3 = effect.scale_vector(var32, var33, var34, 1.0 - value_3)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3 = effect.add_vectors(var32, var33, var34, var29, var30, var31)
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
		do
			local out1, out2, out3 = effect.copy_vector(var32, var33, var34)
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
			break
		else
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
				effect.set_effect_character_position(var40, var41, var42)
				var25 = 1
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
				var19 = var19 + 1
			end
		end
	end
	effect.delete_collision_primitive(-1)
	if var25 ~= 0 then
		var19 = 0
		effect.set_effect_character_visible(0, 1, -0.5)
		while var19 < 60 do
			vm.wait()
			var19 = var19 + 1
		end
	end
	effect.set_effect_character_visible(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
