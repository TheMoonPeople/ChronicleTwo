--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_ab804989(se_id: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: s32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: s32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local kind: s32 = 0
	local pin_col: s32 = 0
	local ball_col: s32 = 0
	local var47: s32 = 0
	local var48: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var52: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	var5 = vm.f32(-6.051593)
	var5 = event.wrap_angle(var5) or var5
	event.set_camera_control_enabled(1)
	event.set_camera_look_at(-11.1, 88.729996, 1309.96)
	var1 = vm.f32(vm.f32(vm.sin(var5) * 100.0) + vm.f32(-11.1))
	var2 = vm.f32(93.729996)
	var3 = vm.f32(vm.f32(vm.cos(var5) * 100.0) + vm.f32(1309.96))
	event.set_camera_position(var1, var2, var3)
	var5 = vm.f32(-2.91)
	var1 = 0.0
	var2 = vm.f32(65.57)
	var3 = vm.f32(1305.04)
	var12 = -1.0
	do
		local out1, out2, out3 = event.zero_vector()
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.copy_vector(var1, var2, var3)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var20 = 0
	event.play_sound_effect(se_id, 12)
	var11 = vm.f32(41.8)
	var10 = vm.f32(0.218166)
	var11 = vm.f32(var11 - vm.f32(var11 * var10))
	var21 = vm.f32(vm.sin(var5) * vm.f32(var11 * vm.cos(var10)))
	var22 = vm.f32(var11 * vm.sin(var10))
	var23 = vm.f32(vm.cos(var5) * vm.f32(var11 * vm.cos(var10)))
	var15 = vm.f32(vm.f32(var15 * vm.f32(3.1415927)) / 2.0)
	var16 = vm.f32(vm.f32(vm.f32(-var23 * var12) * var14) * vm.f32(0.4))
	var14 = vm.f32(vm.f32(vm.f32(-var21 * var12) * var14) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var28 = 180.0
	var29 = -50.0
	var30 = 0
	var13 = 0
	var43 = 0
	var47 = 0
	while true do
		if var2 >= var28 then
			var21 = vm.f32(var21 * vm.f32(0.999))
			var22 = vm.f32(var22 + vm.f32(vm.f32(-0.0098) * (var47 + 1)))
			var23 = vm.f32(var23 * vm.f32(0.999))
		else
			var42 = event.get_segment_collision_9(12, var1, var2, var3, var1, vm.f32(var2 - 3.0) - vm.f32(0.01), var3, 0)
				or var42
			if var13 == 1 and var42 >= 0 then
				var21 = vm.f32(var21 * vm.f32(0.94))
				var22 = vm.f32(var22 + vm.f32(vm.f32(-0.00045) * (var47 + 1)))
				var23 = vm.f32(var23 * vm.f32(0.94))
				var21 = vm.f32(var21 + var14)
				var23 = vm.f32(var23 + var16)
				var14 = vm.f32(var14 * vm.f32(0.8))
				var16 = vm.f32(var16 * vm.f32(0.8))
			else
				var21 = vm.f32(var21 * vm.f32(0.999))
				var22 = vm.f32(var22 + vm.f32(vm.f32(-0.0045) * (var47 + 1)))
				var23 = vm.f32(var23 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(var1, var2, var3, var21, var22, var23)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		if var15 ~= 0.0 then
			var10 = event.get_direction_angle(var17, var18, var19, var1, var2, var3) or var10
			var10 = vm.f32(var10 + var15)
			var10 = event.wrap_angle(var10) or var10
			var21 = vm.f32(var21 + vm.f32(vm.f32(vm.sin(var10) / 10.0) * var12))
			var23 = vm.f32(var23 + vm.f32(vm.f32(vm.cos(var10) / 10.0) * var12))
		end
		var41 = event.get_vector_length(var14, 0.0, var16) or var41
		if var41 > vm.f32(0.01) then
			var24 = event.get_vector_length(var14, 0.0, var16) or var24
			var10 = event.get_direction_angle(var17, var18, var19, var17 + var14, var18, var19 + var16) or var10
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			event.set_character_rotation(8, var4, var10, var6)
			event.offset_character_rotation(8, var24 * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, var4, var10, var6)
			event.offset_character_rotation(9, var24 * 12.0, 0.0, 0.0)
		else
			var24 = event.get_vector_length(var21, 0.0, var23) or var24
			var10 = event.get_direction_angle(var17, var18, var19, var1, var2, var3) or var10
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			event.set_character_rotation(8, var4, var10, var6)
			event.offset_character_rotation(8, var24 / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, var4, var10, var6)
			event.offset_character_rotation(9, var24 / 10.0, 0.0, 0.0)
		end
		var24 = event.get_vector_length(var21, var22, var23) or var24
		var40 = var24
		var10 = event.get_direction_angle(var17, var18, var19, var1, var2, var3) or var10
		var37 = vm.f32(vm.sin(vm.f32(var10 - vm.f32(1.5707964))) * 3.0)
		var39 = vm.f32(vm.cos(vm.f32(var10 - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			var1 - var37,
			var2,
			var3 - var39,
			vm.f32(var1 + var37) + var37,
			var2,
			vm.f32(var3 + var39) + var39
		)
		do
			local out1, out2, out3 = event.copy_vector(var21, var22, var23)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.normalize_vector(var37, var38, var39)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.scale_vector(var37, var38, var39, 3.0)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, var17, var18, var19, var1 + var37, var2 + var38, var3 + var39, 0)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var42 = out4 or var42
			kind = out5 or kind
		end
		if var42 >= 0 and kind == 1 then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(var31, var32, var33)
			if var43 <= 0 then
				event.play_sound_effect(se_id, 11)
				var43 = 20
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, var17, var18, var19, var1 + var37, var2 + var38, var3 + var39, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
		end
		while var42 >= 0 do
			var15 = 0.0
			if var24 > 8.0 then
				helper_79d90c82()
			end
			if var43 <= 0 then
				event.play_sound_effect(se_id, 6)
				var43 = 20
			end
			do
				local out1, out2, out3 = event.copy_vector(-var21, -var22, -var23)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = event.normalize_vector(var21, var22, var23)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = event.scale_vector(var21, var22, var23, 3.0)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = event.add_vectors(var31, var32, var33, var21, var22, var23)
				var31 = out1 or var31
				var32 = out2 or var32
				var33 = out3 or var33
			end
			do
				local out1, out2, out3 = event.subtract_vectors(var17, var18, var19, var31, var32, var33)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			var41 = event.get_vector_length(var17, var18, var19) or var41
			var41 = vm.f32(var40 - var41)
			if var41 <= 0.0 then
				break
			else
				var40 = var41
				do
					local out1, out2, out3 = event.copy_vector(-var21, -var22, -var23)
					var21 = out1 or var21
					var22 = out2 or var22
					var23 = out3 or var23
				end
				if var22 < 0.0 and var35 > 0.0 then
					var21 = vm.f32(var14 * 2.0)
					var22 = 0.0
					var23 = vm.f32(var16 * 2.0)
					var14 = vm.f32(var14 * vm.f32(0.2))
					var16 = vm.f32(var16 * vm.f32(0.2))
				else
					if
						var21 < 0.0 and var34 > 0.0
						or var21 > 0.0 and var34 < 0.0
						or var23 < 0.0 and var36 > 0.0
						or var23 > 0.0 and var36 < 0.0
					then
						var14 = 0.0
						var16 = 0.0
					end
					var21 = 0.0
					var22 = 0.0
					var23 = 0.0
				end
				var21 = vm.f32(vm.f32(vm.f32(var34 * var24) * vm.f32(0.9)) + var21)
				var22 = vm.f32(vm.f32(vm.f32(var35 * var24) * vm.f32(0.58)) + var22)
				var23 = vm.f32(vm.f32(vm.f32(var36 * var24) * vm.f32(0.9)) + var23)
				do
					local out1, out2, out3 = event.copy_vector(var31, var32, var33)
					var17 = out1 or var17
					var18 = out2 or var18
					var19 = out3 or var19
				end
				do
					local out1, out2, out3 = event.copy_vector(var21, var22, var23)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.normalize_vector(var37, var38, var39)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.scale_vector(var37, var38, var39, 3.0)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.scale_vector(var34, var35, var36, var41)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				do
					local out1, out2, out3 = event.copy_vector(var31, var32, var33)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				do
					local out1, out2, out3 = event.add_vectors(var1, var2, var3, var34, var35, var36)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
						12,
						var17,
						var18,
						var19,
						var1 + var37,
						var2 + var38,
						var3 + var39,
						1
					)
					var31 = out1 or var31
					var32 = out2 or var32
					var33 = out3 or var33
					var34 = out4 or var34
					var35 = out5 or var35
					var36 = out6 or var36
					var42 = out7 or var42
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, var1, var2, var3, var1, var2 - 3.0, var3, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
			kind = out8 or kind
		end
		if var42 >= 0 then
			var15 = 0.0
			var2 = vm.f32(var32 + 3.0)
			var41 = event.get_vector_length(var21, 0.0, var23) or var41
			if var41 < vm.f32(2.4) or var22 >= -1.0 and var22 <= 0.0 then
				var22 = 0.0
				var13 = 1
			else
				var21 = vm.f32(var21 * vm.f32(0.9))
				var22 = -vm.f32(var22 * vm.f32(0.58))
				var23 = vm.f32(var23 * vm.f32(0.9))
				var21 = vm.f32(var21 + vm.f32(var14 * 2.0))
				var23 = vm.f32(var23 + vm.f32(var16 * 2.0))
				var14 = vm.f32(var14 * vm.f32(0.2))
				var16 = vm.f32(var16 * vm.f32(0.2))
				if var24 > 8.0 then
					helper_79d90c82()
				end
				if var43 <= 0 then
					event.play_sound_effect(se_id, 5)
					var43 = 20
				end
			end
			var41 = event.get_vector_length(var14, 0.0, var16) or var41
			if var22 == 0.0 and var24 < vm.f32(1.6) and var41 < vm.f32(0.4) then
				if not (kind == 6) then
					break
				end
				var30 = 1
				break
			end
		end
		if var2 < -500.0 then
			var30 = 1
			break
		elseif var47 >= 300 then
			var30 = 1
			break
		else
			pin_col = event.get_sphida_pin_color() or pin_col
			ball_col = event.get_sphida_ball_color() or ball_col
			var48 = 1.0
			x = vm.f32(pos_x - var1)
			y = vm.f32(pos_y - var2)
			z = vm.f32(pos_z - var3)
			var48 = event.get_vector_length(x, y, z) or var48
			if ball_col ~= pin_col then
				var52 = event.get_point_to_segment_distance(var17, var18, var19, var1, var2, var3, pos_x, pos_y, pos_z) or var52
				if var52 >= 0.0 and var52 <= 30.0 then
					var20 = 1
					break
				end
				if var48 ~= 0.0 then
					if var48 <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), var48))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.add_vectors(var1, var2, var3, x, y, z)
							var1 = out1 or var1
							var2 = out2 or var2
							var3 = out3 or var3
						end
						do
							local out1, out2, out3 = event.add_vectors(var21, var22, var23, x, y, z)
							var21 = out1 or var21
							var22 = out2 or var22
							var23 = out3 or var23
						end
					end
				else
					var20 = 1
					break
				end
			elseif var48 ~= 0.0 then
				if var48 <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, var48))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var1, var2, var3, x, y, z)
						var1 = out1 or var1
						var2 = out2 or var2
						var3 = out3 or var3
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var21, var22, var23, x, y, z)
						var21 = out1 or var21
						var22 = out2 or var22
						var23 = out3 or var23
					end
				end
			end
			event.set_character_position(8, var1, var2, var3)
			event.set_character_position(9, var1, var2, var3)
			do
				local out1, out2, out3 = event.copy_vector(var1, var2, var3)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			if var2 <= var29 then
				event.set_follow_camera_following(0)
				if var30 >= 30 then
					if var30 >= 50 then
						break
					end
				else
					event.set_camera_look_at(var1, var2, var3)
				end
				var30 = var30 + 1
			elseif var47 >= 20 then
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_camera_speed(6.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				do
					local out1, out2, out3 = event.get_camera_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				event.set_follow_camera_height(30.0)
				event.set_follow_camera_distance(200.0)
				yaw = event.get_direction_angle(
					vm.f32(var1 + var21) + var21,
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.set_follow_camera_angle(yaw)
				event.set_follow_camera_target_alternate(
					vm.f32(var1 + var21) + var21,
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23
				)
				event.step_follow_camera(1)
			end
			event.set_sphida_ball_position(var1, var2, var3)
			vm.wait(1)
			if var43 > 0 then
				var43 = var43 - 1
			end
			var47 = var47 + 1
		end
	end
	if var20 ~= 1 then
		wait_frames(30)
	end
	event.set_character_position(8, var1, var2, var3)
	event.set_character_position(9, var1, var2, var3)
	vm.wait(3)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(1, 12)
	event.set_character_position(12, pos_x, pos_y, pos_z)
	event.set_character_motion(12, "発動", 6)
	event.play_sound_effect(se_id, 17)
	var47 = 0
	while var47 < 2 do
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
		event.set_camera_speed(12.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(0.0)
		event.set_follow_camera_distance(100.0)
		event.step_follow_camera(1)
		var47 = var47 + 1
		vm.wait(4)
	end
	event.set_character_active(0, 10)
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var47 = 0
	while var47 < 100 do
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
		event.set_camera_speed(12.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(0.0)
		event.set_follow_camera_distance(100.0)
		event.step_follow_camera(1)
		var47 = var47 + 1
		vm.wait(5)
	end
	event.set_character_active(0, 11)
	wait_frames(54)
	event.set_camera_control_enabled(1)
	event.set_follow_camera_following(0)
end

return helper_ab804989
