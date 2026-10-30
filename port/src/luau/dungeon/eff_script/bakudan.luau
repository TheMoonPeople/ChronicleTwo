--!strict
-- dungeon/eff_script/bakudan.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	user_id = effect.get_owner_character() or user_id
	while true do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "item")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.set_effect_character_position(pos_x, pos_y, pos_z)
		vm.wait()
	end
end

--- Ends an effect.
function script.on_finish()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local user_id: s32 = 0
	local value_2: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: s32 = 0
	local value_3: s32 = 0
	local value_4: s32 = 0
	local value_5: s32 = 0
	local var21: s32 = 0
	local var22: s32 = 0
	local area_kind: s32 = 0
	local foot_sound: s32 = 0
	local var25: s32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local scale: f32 = 0
	local var37: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	user_id = effect.get_owner_character() or user_id
	effect.get_script_value(0)
	value_2 = effect.get_script_value(1) or value_2
	do
		local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "item")
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.copy_vector(work_vect1_x, work_vect1_y, work_vect1_z)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(var9, var10, var11, var0, var1, var2)
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
		local out1, out2, out3 = effect.scale_vector(var9, var10, var11, 6.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var16 = effect.get_distance_between(var0, var1, var2, work_vect1_x, work_vect1_y, work_vect1_z) or var16
	var15 = vm.f32(-0.25 + vm.f32(var16 * vm.f32(0.0004)))
	var16 = vm.f32(vm.f32(var16 / 6.0) + 1.0)
	var10 = vm.f32(
		vm.fdiv(
			vm.f32(vm.f32(vm.f32(work_vect1_y - var1) * 2.0) - vm.f32(vm.f32(var15 * var16) * var16)),
			vm.f32(var16 * 2.0)
		)
	)
	var17 = 0
	if value_2 == 304 then
		effect.create_collision_primitive("ギフト")
		value_3 = effect.get_script_value(2) or value_3
		value_4 = effect.get_script_value(3) or value_4
		value_5 = effect.get_script_value(4) or value_5
		effect.set_collision_primitive_gift(value_3, value_4, value_5)
		var17 = 1
	end
	if value_2 == 287 then
		effect.create_collision_primitive("ときめきチェリ")
		var17 = 1
	end
	if value_2 == 288 then
		effect.create_collision_primitive("ストーンベリー")
		var17 = 1
	end
	if value_2 == 289 then
		effect.create_collision_primitive("ネバピーチ")
		var17 = 1
	end
	if value_2 == 291 then
		effect.create_collision_primitive("毒りんご")
		var17 = 1
	end
	if value_2 == 281 then
		effect.create_collision_primitive("石コロ")
		var17 = 1
	end
	if var17 == 0 then
		effect.create_collision_primitive("円形チェック用")
	end
	var25 = 0
	var21 = 0
	while var21 < 60 do
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
		var10 = vm.f32(var10 + var15)
		var35 = effect.get_vector_length(var9, var10, var11) or var35
		scale = var35
		do
			local out1, out2, out3 = effect.copy_vector(var9, var10, var11)
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
			local out1, out2, out3 = effect.scale_vector(var32, var33, var34, 2.0)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8, out9 = effect.get_intersection_point_16(
				0,
				vector_x,
				vector_y,
				vector_z,
				vm.f32(var0 + var32) + var9,
				vm.f32(var1 + var33) + var10,
				vm.f32(var2 + var34) + var11
			)
			var26 = out1 or var26
			var27 = out2 or var27
			var28 = out3 or var28
			var29 = out4 or var29
			var30 = out5 or var30
			var31 = out6 or var31
			var22 = out7 or var22
			area_kind = out8 or area_kind
			foot_sound = out9 or foot_sound
		end
		if
			var25 <= 0
			and var22 >= 0
			and (var10 < 0.0 and var30 > 0.0)
			and (var9 > 0.0 and var29 > 0.0 or var9 < 0.0 and var29 < 0.0)
			and (var11 > 0.0 and var31 > 0.0 or var11 < 0.0 and var31 < 0.0)
		then
			if foot_sound == 1 or foot_sound == 13 then
				effect.create_effect_1("足芝生")
				effect.set_effect_first_work_vector(var26, var27, var28)
				effect.create_effect_1("足砂煙")
				effect.set_effect_first_work_vector(var26, var27, var28)
			end
			if foot_sound == 7 or foot_sound == 14 or foot_sound == 16 then
				effect.create_effect_1("足砂煙")
				effect.set_effect_first_work_vector(var26, var27, var28)
			end
			if foot_sound == 11 or foot_sound == 18 or (area_kind == 1 or area_kind == 7) then
				effect.create_effect_1("足水パシャ")
				effect.set_effect_first_work_vector(var26, var27, var28)
			end
			var25 = 10
		end
		if var25 > 0 then
			var25 = var25 - 1
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				effect.get_intersection_point_14(4, vector_x, vector_y, vector_z, var0 + var32, var1 + var33, var2 + var34)
			var26 = out1 or var26
			var27 = out2 or var27
			var28 = out3 or var28
			var29 = out4 or var29
			var30 = out5 or var30
			var31 = out6 or var31
			var22 = out7 or var22
		end
		if var22 >= 0 then
			var35 = vm.f32(var35 * vm.f32(0.6))
		end
		while var22 >= 0 do
			do
				local out1, out2, out3 = effect.copy_vector(-var32, -var33, -var34)
				var32 = out1 or var32
				var33 = out2 or var33
				var34 = out3 or var34
			end
			do
				local out1, out2, out3 = effect.add_vectors(var26, var27, var28, var32, var33, var34)
				var26 = out1 or var26
				var27 = out2 or var27
				var28 = out3 or var28
			end
			do
				local out1, out2, out3 = effect.copy_vector(var26, var27, var28)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			var37 = effect.get_distance_between(vector_x, vector_y, vector_z, var0, var1, var2) or var37
			do
				local out1, out2, out3 = effect.copy_vector(var29, var30, var31)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			do
				local out1, out2, out3 = effect.scale_vector(var9, var10, var11, var35)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			scale = vm.f32(scale - var37)
			if scale <= 0.0 then
				break
			else
				do
					local out1, out2, out3 = effect.scale_vector(var29, var30, var31, scale)
					var29 = out1 or var29
					var30 = out2 or var30
					var31 = out3 or var31
				end
				do
					local out1, out2, out3 = effect.copy_vector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				do
					local out1, out2, out3 = effect.add_vectors(var0, var1, var2, var29, var30, var31)
					var0 = out1 or var0
					var1 = out2 or var1
					var2 = out3 or var2
				end
				do
					local out1, out2, out3 = effect.copy_vector(var29, var30, var31)
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
					local out1, out2, out3 = effect.scale_vector(var32, var33, var34, 2.0)
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = effect.get_intersection_point_14(
						4,
						vector_x,
						vector_y,
						vector_z,
						var0 + var32,
						var1 + var33,
						var2 + var34
					)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
					var29 = out4 or var29
					var30 = out5 or var30
					var31 = out6 or var31
					var22 = out7 or var22
				end
			end
		end
		do
			local out1, out2, out3, out4 =
				effect.get_intersection_point_11(4, var0, var1, var2, var0, var1 - vm.f32(1.9), var2)
			var26 = out1 or var26
			var27 = out2 or var27
			var28 = out3 or var28
			var22 = out4 or var22
		end
		if var22 >= 0 then
			var9 = vm.f32(var9 * vm.f32(0.6))
			var10 = -vm.f32(var10 * vm.f32(0.6))
			var11 = vm.f32(var11 * vm.f32(0.6))
			do
				local out1, out2, out3 = effect.copy_vector(var26, var27 + 2.0, var28)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
		end
		effect.set_collision_primitive_shape(var0, var1, var2, 5.0)
		var22 = effect.get_collision_primitive_hit_count() or var22
		if var22 > 0 then
			break
		else
			effect.set_effect_character_position(var0, var1, var2)
			var21 = var21 + 1
			vm.wait()
		end
	end
	effect.delete_collision_primitive(-1)
	if value_2 == 276 then
		effect.create_effect_1("魔石聖")
		effect.set_effect_first_work_vector(var0, var1, var2)
		effect.set_effect_value(0, 2)
	end
	if value_2 == 290 then
		effect.create_effect_1("爆発")
		effect.set_effect_first_work_vector(var0, var1, var2)
		effect.set_effect_value(0, 4)
	end
	if value_2 == 280 then
		effect.create_effect_1("爆発")
		effect.set_effect_first_work_vector(var0, var1, var2)
		effect.set_effect_value(0, 1)
	end
	if value_2 == 390 then
		effect.create_effect_1("爆発")
		effect.set_effect_first_work_vector(var0, var1, var2)
		effect.set_effect_value(0, 2)
	end
	if value_2 == 391 then
		effect.create_effect_1("ＦボムＨ")
		effect.set_effect_first_work_vector(var0, var1, var2)
		effect.set_effect_value(0, 3)
	end
	if value_2 == 307 then
		effect.create_effect_1("電光石火")
		effect.set_effect_first_work_vector(var0, var1, var2)
		effect.set_effect_value(0, 3)
	end
	if value_2 == 282 then
		effect.create_effect_1("魔石炎")
		effect.set_effect_first_work_vector(var0, var1, var2)
	end
	if value_2 == 283 then
		effect.create_effect_1("魔石冷")
		effect.set_effect_first_work_vector(var0, var1, var2)
	end
	if value_2 == 284 then
		effect.create_effect_1("魔石雷")
		effect.set_effect_first_work_vector(var0, var1, var2)
	end
	if value_2 == 285 then
		effect.create_effect_1("魔石風")
		effect.set_effect_first_work_vector(var0, var1, var2)
	end
	if value_2 == 286 then
		effect.create_effect_1("魔石聖")
		effect.set_effect_first_work_vector(var0, var1, var2)
		effect.set_effect_value(0, 1)
	end
end

return script
