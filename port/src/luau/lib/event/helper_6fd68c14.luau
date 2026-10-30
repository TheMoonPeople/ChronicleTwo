--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_20c1506c = require("@lib/event/helper_20c1506c")
local helper_4c63ac5c = require("@lib/event/helper_4c63ac5c")
local helper_61258276 = require("@lib/event/helper_61258276")
local helper_82963f1e = require("@lib/event/helper_82963f1e")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_cad4e361 = require("@lib/event/helper_cad4e361")
local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_6fd68c14()
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local now_map_no: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var29: any = 0
	local var30: s32 = 0
	local var31: s32 = 0
	local var32: s32 = 0
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.set_character_motion(0, "立ち")
	event.set_character_motion(var1, "立ち")
	event.initialize_event()
	event.apply_message_window_preset(1, 0)
	var4 = 0
	if var2 == 18 then
		var4 = 20
	end
	if var2 == 25 then
		var4 = 24
	end
	if var2 == 12 or var2 == 17 then
		var4 = 28
	end
	if var2 == 7 then
		var4 = 32
	end
	if var2 == 10 or var2 == 6 or var2 == 24 then
		var4 = 40
	end
	if var2 == 8 or var2 == 1 or var2 == 2 or var2 == 3 or var2 == 15 or var2 == 16 or var2 == 21 then
		var4 = 44
	end
	if var2 == 4 or var2 == 19 or var2 == 20 or var2 == 22 then
		var4 = 48
	end
	if var2 == 5 or var2 == 11 or var2 == 23 or var2 == 13 then
		var4 = 52
	end
	if var2 == 9 then
		var4 = 56
	end
	event.set_message_window_option(1, 4, 30, 60, 168, -1)
	event.set_message_window_option(1, 9, 20 + var4, 16)
	do
		local out1, _, out3 = event.get_character_position(0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local out1, _, out3 = event.get_character_rotation(0)
		var14 = out1 or var14
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.get_character_position(var1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = event.get_character_rotation(var1)
		var8 = out1 or var8
		var10 = out3 or var10
	end
	var17 = event.get_look_angle(var5 - var11, var7 - var13) or var17
	event.set_character_rotation(0, var14, var17, var16)
	var18 = event.get_look_angle(var11 - var5, var13 - var7) or var18
	event.set_character_rotation(var1, var8, var18, var10)
	now_map_no = event.get_current_map() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.get_function_point_position("", "gcamp")
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		event.set_camera_position(var20, var21, var22)
		event.set_camera_look_at(var5, var6 + 30.0, var7)
		var18 = event.get_look_angle(var20 - var5, var22 - var7) or var18
		event.set_character_rotation(var1, var8, var18, var10)
	else
		pos_x = vm.f32(vm.sin(var18) * 30.0)
		pos_x = vm.f32(pos_x + var5)
		pos_y = vm.f32(var6 + 33.0)
		pos_z = vm.f32(vm.cos(var18) * 30.0)
		pos_z = vm.f32(pos_z + var7)
		event.set_camera_position(pos_x, pos_y, pos_z)
		pos_x_2 = var5
		pos_y_2 = vm.f32(var6 + 30.0)
		pos_z_2 = var7
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	end
	event.set_character_active(0, 0)
	vm.wait(1)
	event.start_crossfade(10)
	var29 = 0
	while true do
		set_window_mode(3, 1)
		helper_82963f1e(3, var2)
		var30 = -1
		event.set_message_draw_speed(3, 0, 0)
		set_window_mode(1, 8)
		event.set_message_draw_speed(1, 0, 0)
		var31 = event.get_npc_message_number_3(var2, 0) or var31
		event.set_message_item_system_message(1, 1, var31)
		open_message(1, 1, 1, 0, 0)
		set_window_mode(2, 2)
		do
			local out1, out2 = event.get_npc_message_number_4(var2, 4)
			var30 = out1 or var30
			var32 = out2 or var32
		end
		if var32 == 3 then
			var30 = 30
		end
		if var32 == 4 then
			event.set_message_item_system_message(2, 1, var30)
			var30 = 31
		end
		if var32 == 5 then
			event.set_message_item_system_message(2, 1, var30)
			event.set_message_item_system_message(2, 2, vm.i32(var30 + 1))
			var30 = 32
		end
		var29 = helper_bac0e30d(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_61258276()
				event.start_crossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.fade_out_screen(25)
				wait_frames(30)
				event.set_npc_party_status(var2, 1)
				event.open_party_select_menu()
				vm.wait(5)
				helper_61258276()
				event.fade_in_screen(30)
				return
			end
			set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			event.open_message_window_2(3, "[(!)]Ahora no puedes hacer eso. [UNI00a1]Antes tienes que\nllevar a Lin al faro!")
			show_message(3, -1, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if var29 == 1 then
			set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			var30 = event.get_npc_message_number_3(var2, 3) or var30
			show_message(3, var30, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.set_save_data_value(2)
						event.open_message_window_2(3, "Perfecto, [UNI00a1]hemos terminado las reparaciones!")
						show_message(3, -1, 3, 256, 208)
						helper_61258276()
						event.start_crossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_4c63ac5c(6)
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_4c63ac5c(23)
						return
					end
					if var2 == 4 then
						if helper_cad4e361(3) ~= 0 then
							helper_4c63ac5c(33)
							return
						end
					end
				end
				if var29 == 4 then
					break
				end
				if var29 == -1 then
					break
				end
			else
				if var29 == 2 then
					if var2 == 15 then
						helper_4c63ac5c(0)
					end
					if var2 == 12 then
						helper_4c63ac5c(1)
					end
					if var2 == 6 then
						helper_4c63ac5c(2)
					end
					if var2 == 7 then
						helper_4c63ac5c(3)
					end
					if var2 == 2 then
						helper_4c63ac5c(7)
					end
					if var2 == 3 then
						helper_4c63ac5c(8)
					end
					if var2 == 5 then
						helper_4c63ac5c(9)
					end
					if var2 == 8 then
						helper_4c63ac5c(10)
					end
					if var2 == 10 then
						helper_4c63ac5c(11)
					end
					if var2 == 11 then
						helper_4c63ac5c(12)
					end
					if var2 == 13 then
						helper_4c63ac5c(13)
					end
					if var2 == 16 then
						helper_4c63ac5c(14)
					end
					if var2 == 18 then
						helper_4c63ac5c(15)
					end
					if var2 == 19 then
						helper_4c63ac5c(16)
					end
					if var2 == 20 then
						helper_4c63ac5c(17)
					end
					if var2 == 21 then
						helper_4c63ac5c(18)
					end
					if var2 == 22 then
						helper_4c63ac5c(19)
					end
					if var2 == 23 then
						helper_4c63ac5c(20)
					end
					if var2 == 24 then
						helper_4c63ac5c(21)
					end
					if var2 == 25 then
						helper_4c63ac5c(22)
					end
					if var2 == 17 then
						helper_4c63ac5c(32)
					end
					if var2 == 9 then
						helper_20c1506c()
						show_message(3, -1, 3, 256, 208)
						helper_61258276()
						event.start_crossfade(10)
					end
					if var2 == 14 then
						event.fade_out_screen(25)
						wait_frames(30)
						event.open_event_menu(25)
						vm.wait(36)
						helper_61258276()
						event.fade_in_screen(30)
					end
					return
				end
				if var29 == 3 then
					break
				end
				if var29 == -1 then
					break
				end
			end
		else
			if var29 == 2 then
				break
			end
			if var29 == -1 then
				break
			end
		end
	end
	helper_61258276()
	event.start_crossfade(10)
end

return helper_6fd68c14
