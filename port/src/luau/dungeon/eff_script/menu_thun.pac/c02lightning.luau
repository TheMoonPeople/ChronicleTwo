--!strict
-- dungeon/eff_script/menu_thun.pac/c02lightning.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local target_id: s32 = 0
	local value: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local value_2: f32 = 0
	local vector_x_2: f32 = 0
	local vector_y_2: f32 = 0
	local vector_z_2: f32 = 0
	local var26: s32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local vector_x_3: f32 = 0
	local vector_y_3: f32 = 0
	local vector_z_3: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_5: f32 = 0
	local var36: s32 = 0
	local var37: s32 = 0
	local var38: s32 = 0
	local value_6: s32 = 0
	local var40: s32 = 0
	local scale: f32 = 0
	local var42: f32 = 0
	local var43: f32 = 0
	local var45: s32 = 0
	user_id = effect.get_owner_character() or user_id
	target_id = effect.get_target_character() or target_id
	value = effect.get_script_value_float(0) or value
	value = 0.0
	do
		local out1, out2, out3 = effect.get_scene_character_position(user_id)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var3 = effect.get_scene_character_rotation_2(user_id) or var3
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	if target_id <= -1 then
		pos_x_2 = vm.f32(vm.f32(vm.sin(var3) * 400.0) + pos_x)
		pos_y_2 = vm.f32(20.0 + pos_y)
		pos_z_2 = vm.f32(vm.f32(vm.cos(var3) * 400.0) + pos_z)
	else
		do
			local out1, out2, out3 = effect.get_scene_character_entry_object_position(target_id, 0)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
	end
	value_2 = effect.get_random_number(2.0943952) or value_2
	value_2 = vm.f32(value_2 - vm.f32(1.0471976))
	var3 = vm.f32(var3 + value_2)
	var3 = effect.wrap_angle(var3) or var3
	vector_x_2 = vm.f32(vm.f32(vm.sin(var3) * 30.0) + pos_x)
	vector_y_2 = vm.f32(40.0 + pos_y)
	vector_z_2 = vm.f32(vm.f32(vm.cos(var3) * 30.0) + pos_z)
	var3 = effect.get_scene_character_rotation_2(user_id) or var3
	var26 = effect.allocate_sprites_2(40) or var26
	if var26 == 0 then
		return
	end
	effect.set_sprite_texture("c02lightning_hit")
	effect.reset_sprites(0, 40)
	effect.set_sprite_blend_mode(0, 2, 40)
	effect.set_sprite_visible(0, 1, 40)
	effect.set_sprite_size(0, 20.0, 20.0, 40)
	effect.set_sprite_texture_rect(0, 0.0, 48.0, 48.0, 48.0, 40)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 40)
	effect.set_sprite_scale(0, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 40)
	var37 = 1
	var36 = 0
	while var36 < 10 do
		do
			local out1, out2, out3 = effect.copy_vector(vector_x_2, vector_y_2, vector_z_2)
			var19 = out1 or var19
			var20 = out2 or var20
			var21 = out3 or var21
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var19, var20, var21, var10, var11, var12)
			var19 = out1 or var19
			var20 = out2 or var20
			var21 = out3 or var21
		end
		do
			local out1, out2, out3 = effect.divide_vector(var19, var20, var21, 3.0)
			var19 = out1 or var19
			var20 = out2 or var20
			var21 = out3 or var21
		end
		do
			local out1, out2, out3 = effect.copy_vector(var10, var11, var12)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(var10, var11, var12, var19, var20, var21)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		do
			local out1, out2, out3 = effect.copy_vector(var10, var11, var12)
			vector_x_3 = out1 or vector_x_3
			vector_y_3 = out2 or vector_y_3
			vector_z_3 = out3 or vector_z_3
		end
		do
			local out1, out2, out3 = effect.copy_vector(vector_x, vector_y, vector_z)
			var27 = out1 or var27
			var28 = out2 or var28
			var29 = out3 or var29
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var27, var28, var29, var10, var11, var12)
			var27 = out1 or var27
			var28 = out2 or var28
			var29 = out3 or var29
		end
		do
			local out1, out2, out3 = effect.divide_vector(var27, var28, var29, 4)
			var27 = out1 or var27
			var28 = out2 or var28
			var29 = out3 or var29
		end
		effect.set_sprite_position(0, vector_x_3, vector_y_3, vector_z_3)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0)
		effect.spread_sprite_positions(var37, vector_x_3, vector_y_3, vector_z_3, var27, var28, var29, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(var37, 128.0, 128.0, 128.0, 64.0, 4)
		effect.ease_sprite_color(var37, 128.0, 128.0, 128.0, -64.0, 6.0, 4)
		effect.set_sprite_blinking(var37, 0.0, 0.0, 0.0, 64.0, 1.5707964, 4)
		effect.set_sprite_scale(var37, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 4)
		effect.ease_sprite_scale(
			var37,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
			4.0,
			4
		)
		var38 = 0
		while var38 < 4 do
			value_6 = effect.get_random_number_int(100) or value_6
			if vm.imod(value_6, 2) == 0 then
				effect.set_sprite_texture_rect(var37 + var38, 16.0, 96.0, 32.0, 32.0)
				effect.set_sprite_size(var37 + var38, 20.0, 20.0)
			else
				value_6 = effect.get_random_number_int(4) or value_6
				effect.set_sprite_texture_rect(var37 + var38, vm.i32(vm.i32(value_6 * 20) + 48), 0, 20, 128)
				effect.set_sprite_size(var37 + var38, 4.0, 25.6)
				value_3 = effect.get_random_number(6.2831855) or value_3
				value_3 = vm.f32(value_3 - vm.f32(3.1415927))
				effect.set_sprite_rotation(var37 + var38, value_3)
			end
			value_3 = effect.get_random_number(4.0 + vm.f32(4.0 * value)) or value_3
			value_3 = vm.f32(value_3 - vm.f32(vm.f32(4.0 + vm.f32(4.0 * value)) / 2.0))
			value_4 = effect.get_random_number(4.0 + vm.f32(4.0 * value)) or value_4
			value_4 = vm.f32(value_4 - vm.f32(vm.f32(4.0 + vm.f32(4.0 * value)) / 2.0))
			value_5 = effect.get_random_number(4.0 + vm.f32(4.0 * value)) or value_5
			value_5 = vm.f32(value_5 - vm.f32(vm.f32(4.0 + vm.f32(4.0 * value)) / 2.0))
			effect.offset_sprite_position(var37 + var38, value_3, value_4, value_5)
			var38 = var38 + 1
		end
		var37 = var37 + 4
		if var37 >= 40 then
			var37 = 1
		end
		effect.set_collision_primitive_shape(var10, var11, var12, 10.0)
		var40 = effect.get_collision_primitive_hit_count() or var40
		if var40 > 0 then
			effect.create_effect_1("モニカ魔法－雷ヒット")
			effect.set_effect_first_work_vector(vector_x, vector_y, vector_z)
			effect.set_effect_value_float(0, value)
			break
		else
			var36 = var36 + 1
			vm.wait()
		end
	end
	scale = 1.0
	var3 = effect.get_rotation_toward_7(var10, var11, var12, pos_x_2, pos_y_2, pos_z_2) or var3
	do
		local out1, out2, out3 = effect.get_rotation_toward_9(var10, var11, var12, pos_x_2, pos_y_2, pos_z_2)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	var13 = effect.get_random_number(0.5235988) or var13
	var13 = vm.f32(var13 + vm.f32(0.2617994))
	var15 = 0.0
	do
		local out1, out2, out3 = effect.get_direction_vector(var13, var14, var15)
		var19 = out1 or var19
		var20 = out2 or var20
		var21 = out3 or var21
	end
	do
		local out1, out2, out3 = effect.normalize_vector(var19, var20, var21)
		var19 = out1 or var19
		var20 = out2 or var20
		var21 = out3 or var21
	end
	do
		local out1, out2, out3 = effect.scale_vector(var19, var20, var21, scale)
		var19 = out1 or var19
		var20 = out2 or var20
		var21 = out3 or var21
	end
	var37 = 1
	var36 = 0
	while var36 < 90 do
		do
			local out1, out2, out3 = effect.copy_vector(var10, var11, var12)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(var10, var11, var12, var19, var20, var21)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
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
			local out1, out2, _ = effect.get_rotation_toward_9(var10, var11, var12, pos_x_2, pos_y_2, pos_z_2)
			var42 = out1 or var42
			var43 = out2 or var43
		end
		var45 = effect.compare_angles(var14, var43, 1.6) or var45
		if var45 == 0 then
			var42 = vm.f32(var42 - var13)
			var42 = effect.wrap_angle(var42) or var42
			var42 = vm.f32(var42 / 6.0)
			var13 = vm.f32(var13 + var42)
			var13 = effect.wrap_angle(var13) or var13
			var43 = vm.f32(var43 - var14)
			var43 = effect.wrap_angle(var43) or var43
			var43 = vm.f32(var43 / 6.0)
			var14 = vm.f32(var14 + var43)
			var14 = effect.wrap_angle(var14) or var14
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(var13, var14, var15)
			var19 = out1 or var19
			var20 = out2 or var20
			var21 = out3 or var21
		end
		do
			local out1, out2, out3 = effect.scale_vector(var19, var20, var21, scale)
			var19 = out1 or var19
			var20 = out2 or var20
			var21 = out3 or var21
		end
		scale = vm.f32(scale * 2.0)
		if scale > 16.0 then
			scale = 16.0
		end
		do
			local out1, out2, out3 = effect.copy_vector(var10, var11, var12)
			vector_x_3 = out1 or vector_x_3
			vector_y_3 = out2 or vector_y_3
			vector_z_3 = out3 or vector_z_3
		end
		do
			local out1, out2, out3 = effect.copy_vector(vector_x, vector_y, vector_z)
			var27 = out1 or var27
			var28 = out2 or var28
			var29 = out3 or var29
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(var27, var28, var29, var10, var11, var12)
			var27 = out1 or var27
			var28 = out2 or var28
			var29 = out3 or var29
		end
		do
			local out1, out2, out3 = effect.divide_vector(var27, var28, var29, 4)
			var27 = out1 or var27
			var28 = out2 or var28
			var29 = out3 or var29
		end
		effect.spread_sprite_positions(0, vector_x_3, vector_y_3, vector_z_3, -var27, -var28, -var29, 0.0, 0.0, 0.0, 1)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 1)
		effect.spread_sprite_positions(var37, vector_x_3, vector_y_3, vector_z_3, var27, var28, var29, 0.0, 0.0, 0.0, 4)
		effect.set_sprite_color(var37, 128.0, 128.0, 128.0, 64.0, 4)
		effect.ease_sprite_color(var37, 128.0, 128.0, 128.0, -64.0, 6.0, 4)
		effect.set_sprite_blinking(var37, 0.0, 0.0, 0.0, 64.0, 1.5707964, 4)
		effect.set_sprite_scale(var37, 1.0 + vm.f32(1.0 * value), 1.0 + vm.f32(1.0 * value), 4)
		effect.ease_sprite_scale(
			var37,
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
			vm.f32(0.2) + vm.f32(vm.f32(0.2) * value),
			4.0,
			4
		)
		var38 = 0
		while var38 < 4 do
			value_6 = effect.get_random_number_int(100) or value_6
			if vm.imod(value_6, 3) == 0 then
				effect.set_sprite_texture_rect(var37 + var38, 16.0, 96.0, 32.0, 32.0)
				effect.set_sprite_size(var37 + var38, 20.0, 20.0)
			else
				value_6 = effect.get_random_number_int(4) or value_6
				effect.set_sprite_texture_rect(var37 + var38, vm.i32(vm.i32(value_6 * 20) + 48), 0, 20, 128)
				effect.set_sprite_size(var37 + var38, 4.0, 25.6)
				value_3 = effect.get_random_number(6.2831855) or value_3
				value_3 = vm.f32(value_3 - vm.f32(3.1415927))
				effect.set_sprite_rotation(var37 + var38, value_3)
			end
			value_3 = effect.get_random_number(4.0 + vm.f32(4.0 * value)) or value_3
			value_3 = vm.f32(value_3 - vm.f32(vm.f32(4.0 + vm.f32(4.0 * value)) / 2.0))
			value_4 = effect.get_random_number(4.0 + vm.f32(4.0 * value)) or value_4
			value_4 = vm.f32(value_4 - vm.f32(vm.f32(4.0 + vm.f32(4.0 * value)) / 2.0))
			value_5 = effect.get_random_number(4.0 + vm.f32(4.0 * value)) or value_5
			value_5 = vm.f32(value_5 - vm.f32(vm.f32(4.0 + vm.f32(4.0 * value)) / 2.0))
			effect.offset_sprite_position(var37 + var38, value_3, value_4, value_5)
			var38 = var38 + 1
		end
		var37 = var37 + 4
		if var37 >= 40 then
			var37 = 1
		end
		do
			local _, _, _, out4 = effect.get_intersection_point_11(4, vector_x, vector_y, vector_z, var10, var11, var12)
			var40 = out4 or var40
		end
		if var40 >= 0 then
			effect.create_effect_1("モニカ魔法－雷ヒット")
			effect.set_effect_first_work_vector(vector_x, vector_y, vector_z)
			effect.set_effect_value_float(0, value)
			break
		else
			effect.set_collision_primitive_shape(var10, var11, var12, 10.0)
			var40 = effect.get_collision_primitive_hit_count() or var40
			if var40 > 0 then
				effect.create_effect_1("モニカ魔法－雷ヒット")
				effect.set_effect_first_work_vector(vector_x, vector_y, vector_z)
				effect.set_effect_value_float(0, value)
				break
			else
				var36 = var36 + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
	effect.set_sprite_visible(0, 0)
	var36 = 0
	while var36 < 10 do
		var36 = var36 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
