--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")

--- Helper function.
local function helper_efb31e92()
	local var0: any = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local box_pos_x: f32 = 0
	local box_pos_y: f32 = 0
	local box_pos_z: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	event.set_message_window_mode(0, 5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_message_selection_top_line(0, 0)
		var0 = helper_bac0e30d(0, 2002, 8, 256, 208, 2, 1)
	else
		event.set_message_selection_top_line(0, 0)
		event.open_message_window_2(0, "Move Monica to the Sphere?")
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
	end
	vm.wait(3)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_sphida_ball_position()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.get_sphida_pin_position()
		do
			local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(pos_x, pos_y, pos_z, 100.0, "point")
			var2 = out1 or var2
			var10 = out2 or var10
			var11 = out3 or var11
			var12 = out4 or var12
		end
		if var2 == 0 then
			do
				local out1, out2, out3 = event.get_nearest_map_parts_position(pos_x, pos_y, pos_z, 100.0)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
		end
		var3 = 0
		do
			local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var10, var11, var12)
			box_pos_x = out1 or box_pos_x
			box_pos_y = out2 or box_pos_y
			box_pos_z = out3 or box_pos_z
			var2 = out4 or var2
		end
		while var2 >= 0 do
			do
				local out1, out2, out3 = event.copy_vector(var10, var11, var12)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = event.subtract_vectors(var17, var18, var19, box_pos_x, box_pos_y, box_pos_z)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			var17 = vm.f32(var17 + 1.0)
			var19 = vm.f32(var19 + 1.0)
			do
				local out1, out2, out3 = event.normalize_vector(var17, var18, var19)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = event.scale_vector(var17, var18, var19, 30.1)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = event.copy_vector(box_pos_x, box_pos_y, box_pos_z)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			do
				local out1, out2, out3 = event.add_vectors(var10, var11, var12, var17, var18, var19)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			var3 = var3 + 1
			if var3 > 6 then
				break
			else
				do
					local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var10, var11, var12)
					box_pos_x = out1 or box_pos_x
					box_pos_y = out2 or box_pos_y
					box_pos_z = out3 or box_pos_z
					var2 = out4 or var2
				end
			end
		end
		var20 = event.get_direction_angle(var10, var11, var12, pos_x, pos_y, pos_z) or var20
		event.set_character_position(0, var10, var11, var12)
		event.set_character_rotation(0, 0.0, var20, 0.0)
		event.set_camera_look_at(var10, var11 + 30.0, var12)
		var20 = vm.f32(var20 - vm.f32(3.1415927))
		var20 = event.wrap_angle(var20) or var20
		var10 = vm.f32(vm.f32(vm.sin(var20) * 100.0) + var10)
		var11 = vm.f32(var11 + 30.0)
		var12 = vm.f32(vm.f32(vm.cos(var20) * 100.0) + var12)
		event.set_camera_position(var10, var11, var12)
		event.set_follow_camera_offset(0.0, 30.0, 0.0)
		event.set_follow_camera_height(5.0)
		event.set_follow_camera_distance(160.0)
		event.set_camera_speed(6.0)
		event.set_camera_rotation_cancel_mask(1)
		event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
		event.reset_follow_camera(0)
	end
end

return helper_efb31e92
