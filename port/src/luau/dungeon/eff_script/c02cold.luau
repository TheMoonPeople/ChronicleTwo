--!strict
-- dungeon/eff_script/c02cold.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local target_id: s32 = 0
	local value: f32 = 0
	local scale: f32 = 0
	local rot_y: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local work_vect2_z: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var24: s32 = 0
	local var25: s32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var29: s32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var33: s32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local vector_x_2: f32 = 0
	local vector_y_2: f32 = 0
	local vector_z_2: f32 = 0
	local var44: s32 = 0
	user_id = effect.get_owner_character() or user_id
	target_id = effect.get_target_character() or target_id
	value = 0.0
	value = effect.get_script_value_float(0) or value
	scale = vm.f32(8.0 + vm.f32(4.0 * value))
	do
		local out1, out2, out3 = effect.get_scene_character_position(user_id)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	rot_y = effect.get_scene_character_rotation_2(user_id) or rot_y
	if target_id <= -1 then
		pos_x_2 = vm.f32(vm.f32(vm.sin(rot_y) * 300.0) + pos_x)
		pos_y_2 = vm.f32(20.0 + pos_y)
		pos_z_2 = vm.f32(vm.f32(vm.cos(rot_y) * 300.0) + pos_z)
	else
		do
			local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
	end
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		var14 = out1 or var14
		var15 = out2 or var15
		work_vect2_z = out3 or work_vect2_z
	end
	var14 = 0.0
	var15 = 0.0
	work_vect2_z = 0.0
	if var14 == 0.0 and var15 == 0.0 and work_vect2_z == 0.0 then
		var20 = vm.f32(0.4)
		if target_id > 0 then
			var20 = effect.get_distance_between(pos_x, pos_y, pos_z, pos_x_2, pos_y_2, pos_z_2) or var20
			var20 = vm.f32(vm.f32(0.4) - vm.f32(vm.f32(vm.fdiv(vm.f32(0.4), var20)) * 10))
		end
		var14 = effect.get_random_number(vm.f32(-3.1415927) * var20) or var14
		var15 = effect.get_random_number(vm.f32(3.1415927) * var20) or var15
		var15 = vm.f32(vm.f32(var15 - vm.f32(0.5235988)) + rot_y)
		var15 = effect.wrap_angle(var15) or var15
		work_vect2_z = 0.0
		do
			local out1, out2, out3 = effect.get_direction_vector(var14, var15, work_vect2_z)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = effect.normalize_vector(var17, var18, var19)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = effect.scale_vector(var17, var18, var19, scale)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
	else
		do
			local out1, out2, out3 = effect.copy_vector(var14, var15, work_vect2_z)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = effect.normalize_vector(var17, var18, var19)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = effect.scale_vector(var17, var18, var19, scale)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
	end
	value_2 = vm.f32(vm.f32(1.0 + vm.f32(3.0 * value)) + 1.0)
	effect.set_effect_character_scale(value_2, value_2, value_2)
	var24 = effect.allocate_sprites_2(28) or var24
	if var24 == 0 then
		return
	end
	effect.set_sprite_texture("c02cold")
	effect.reset_sprites(0, 28)
	effect.set_sprite_visible(0, 1, 28)
	effect.set_sprite_blend_mode(0, 2, 28)
	effect.set_sprite_size(0, 6.0, 6.0, 28)
	effect.set_sprite_texture_rect(0, 0.0, 64.0, 64.0, 64.0, 28)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 28)
	var25 = 0
	var29 = 0
	while var29 < 60 do
		do
			local out1, out2, out3 = effect.copy_vector(var11, var12, var13)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(var11, var12, var13, var17, var18, var19)
			var11 = out1 or var11
			var12 = out2 or var12
			var13 = out3 or var13
		end
		if target_id >= 0 then
			do
				local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
		end
		do
			local out1, out2, _ = effect.get_rotation_toward_9(var11, var12, var13, pos_x_2, pos_y_2, pos_z_2)
			var30 = out1 or var30
			var31 = out2 or var31
		end
		var33 = effect.compare_angles(var15, var31, 1.6) or var33
		if var33 == 0 then
			var30 = vm.f32(var30 - var14)
			var30 = effect.wrap_angle(var30) or var30
			var30 = vm.f32(var30 / 6.0)
			var14 = vm.f32(var14 + var30)
			var14 = effect.wrap_angle(var14) or var14
			var31 = vm.f32(var31 - var15)
			var31 = effect.wrap_angle(var31) or var31
			var31 = vm.f32(var31 / 6.0)
			var15 = vm.f32(var15 + var31)
			var15 = effect.wrap_angle(var15) or var15
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(var14, var15, work_vect2_z)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		do
			local out1, out2, out3 = effect.scale_vector(var17, var18, var19, scale)
			var17 = out1 or var17
			var18 = out2 or var18
			var19 = out3 or var19
		end
		effect.set_effect_character_position(var11, var12, var13)
		effect.rotate_effect_character_toward(var14 + vm.f32(1.5707964), var15, work_vect2_z)
		do
			local out1, out2, out3 = effect.copy_vector(var11, var12, var13)
			vector_x_2 = out1 or vector_x_2
			vector_y_2 = out2 or vector_y_2
			vector_z_2 = out3 or vector_z_2
		end
		do
			local out1, out2, out3 = effect.copy_vector(vector_x, vector_y, vector_z)
			var34 = out1 or var34
			var35 = out2 or var35
			var36 = out3 or var36
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var34, var35, var36, var11, var12, var13)
			var34 = out1 or var34
			var35 = out2 or var35
			var36 = out3 or var36
		end
		do
			local out1, out2, out3 = effect.divide_vector(var34, var35, var36, 2)
			var34 = out1 or var34
			var35 = out2 or var35
			var36 = out3 or var36
		end
		effect.spread_sprite_positions(var25, vector_x_2, vector_y_2, vector_z_2, var34, var35, var36, 0.0, 0.0, 0.0, 2)
		effect.set_sprite_color(var25, 128.0, 128.0, 128.0, 92.0, 2)
		effect.ease_sprite_color(var25, 128.0, 128.0, 128.0, 0.0, 5.0, 2)
		value_2 = vm.f32(1.0 + vm.f32(3.0 * value))
		effect.set_sprite_scale(var25, value_2, value_2, 2)
		for var40 = 0, 1 do
			value_2 = effect.get_random_number(1.0) or value_2
			value_2 = vm.f32(vm.f32(value_2 + 3.0) + vm.f32(5.0 * value))
			effect.ease_sprite_scale(var25 + var40, value_2, value_2, 4.0)
			value_2 = effect.get_random_number(6.2831855) or value_2
			value_2 = vm.f32(value_2 - vm.f32(3.1415927))
			effect.set_sprite_rotation(var25 + var40, value_2)
			value_2 = effect.get_random_number(1.0 + vm.f32(1.0 * value)) or value_2
			value_2 = vm.f32(value_2 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			value_3 = effect.get_random_number(1.0 + vm.f32(1.0 * value)) or value_3
			value_3 = vm.f32(value_3 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			value_4 = effect.get_random_number(1.0 + vm.f32(1.0 * value)) or value_4
			value_4 = vm.f32(value_4 - vm.f32(vm.f32(1.0 + vm.f32(1.0 * value)) / 2.0))
			effect.set_sprite_velocity(var25 + var40, value_2, value_3, value_4)
		end
		var25 = var25 + 2
		if var25 >= 28 then
			var25 = 0
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var11, var12, var13)
			var44 = out4 or var44
		end
		if var44 >= 0 then
			effect.create_effect_1("モニカ魔法－氷ヒット")
			effect.set_effect_first_work_vector(vector_x, vector_y, vector_z)
			effect.set_effect_value_float(0, value)
			break
		else
			effect.set_collision_primitive_shape(var11, var12, var13, 10.0)
			var44 = effect.get_collision_primitive_hit_count() or var44
			if var44 > 0 then
				effect.create_effect_1("モニカ魔法－氷ヒット")
				effect.set_effect_first_work_vector(vector_x, vector_y, vector_z)
				effect.set_effect_value_float(0, value)
				break
			else
				var29 = var29 + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
	effect.set_effect_character_visible(0, 1, 0.06)
	var29 = 0
	while var29 < 20 do
		var29 = var29 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
