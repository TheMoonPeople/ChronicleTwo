--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_452267a4 = require("@lib/event/helper_452267a4")
local helper_5e1f717d = require("@lib/event/helper_5e1f717d")
local helper_6a3c485f = require("@lib/event/helper_6a3c485f")
local helper_73eddd6a = require("@lib/event/helper_73eddd6a")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c0869c7f = require("@lib/event/helper_c0869c7f")
local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_dae6aadb(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var11: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local rot_x_2: f32 = 0
	local rot_y: f32 = 0
	local rot_z_2: f32 = 0
	local var24: any = 0
	local var25: s32 = 0
	local var26: s32 = 0
	local var27: s32 = 0
	local var28: s32 = 0
	local argc_2: s32 = 0
	if arg1 == 1 then
		argc = 1
	elseif arg1 == 2 then
		argc = 2
	elseif arg1 == 3 then
		argc = 13
	else
		argc = event.get_local_event_counter(arg0) or argc
	end
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if argc == now_party_chara_id then
		return
	end
	event.set_character_motion(0, "立ち")
	event.initialize_event()
	event.apply_message_window_preset(1, 0)
	var4 = 0
	if argc == 10 or argc == 18 then
		var4 = 8
	end
	if argc == 1 or argc == 6 or argc == 17 then
		var4 = 16
	end
	if argc == 2 or argc == 15 or argc == 16 or argc == 19 or argc == 20 or argc == 21 or argc == 22 then
		var4 = 24
	end
	if argc == 3 or argc == 4 or argc == 5 or argc == 7 or argc == 8 or argc == 23 or argc == 24 then
		var4 = 32
	end
	if argc == 9 or argc == 11 or argc == 13 then
		var4 = 40
	end
	event.set_message_window_option(1, 4, 30, 60, 144, -1)
	event.set_message_window_option(1, 9, 20 + var4, 16)
	event.set_eye_view_map_parts(1)
	if arg1 ~= 0 then
		event.attach_object_handle_to_character(0, arg0)
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			var9 = out2 or var9
		end
	else
		var11 = event.get_villager_training_value(1, argc) or var11
		do
			local out1, out2, out3, out4 = event.get_train_seat_position(var11)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
			var9 = out4 or var9
		end
		event.attach_object_handle_to_character(0, arg0)
		event.set_object_handle_position(0, var5, var6, var7)
		event.set_object_handle_rotation(0, 0.0, var9, 0.0)
		event.set_character_motion(arg0, "立ち", 4)
	end
	pos_x = vm.f32(vm.sin(var9) * 75.0)
	pos_x = vm.f32(pos_x + var5)
	pos_y = vm.f32(var6 + 45.0)
	pos_z = vm.f32(vm.cos(var9) * 75.0)
	pos_z = vm.f32(pos_z + var7)
	event.set_camera_position(pos_x, pos_y, pos_z)
	pos_x_2 = var5
	pos_y_2 = vm.f32(var6 + 30.0)
	pos_z_2 = var7
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	pos_x_3 = vm.f32(vm.sin(var9) * 30.0)
	pos_x_3 = vm.f32(pos_x_3 + var5)
	pos_y_3 = var6
	pos_z_3 = vm.f32(vm.cos(var9) * 30.0)
	pos_z_3 = vm.f32(pos_z_3 + var7)
	event.set_character_position(0, pos_x_3, pos_y_3, pos_z_3)
	rot_x_2 = 0
	rot_y = vm.f32(var9 + vm.f32(3.1415927))
	if rot_y > vm.f32(3.1415927) then
		rot_y = vm.f32(rot_y - vm.f32(6.2831855))
	end
	rot_z_2 = 0
	event.set_character_rotation(0, rot_x_2, rot_y, rot_z_2)
	vm.wait(1)
	event.start_crossfade(10)
	var24 = 0
	while true do
		set_window_mode(3, 1)
		var26 = event.get_chapter() or var26
		if var26 ~= 8 then
			var25 = event.get_npc_message_number_3(argc, 2) or var25
		else
			helper_6a3c485f(3, argc)
			var25 = -1
		end
		event.set_message_draw_speed(3, 0, 0)
		open_message(3, var25, 3, 256, 208)
		set_window_mode(1, 8)
		event.set_message_draw_speed(1, 0, 0)
		var27 = event.get_npc_message_number_3(argc, 0) or var27
		event.set_message_item_system_message(1, 1, var27)
		open_message(1, 1, 1, 0, 0)
		set_window_mode(2, 2)
		do
			local out1, out2 = event.get_npc_message_number_4(argc, 4)
			var25 = out1 or var25
			var28 = out2 or var28
		end
		if var28 == 3 then
			var25 = 30
		end
		if var28 == 4 then
			event.set_message_item_system_message(2, 1, var25)
			var25 = 31
		end
		if var28 == 5 then
			event.set_message_item_system_message(2, 1, var25)
			event.set_message_item_system_message(2, 2, vm.i32(var25 + 1))
			var25 = 32
		end
		var24 = helper_bac0e30d(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		close_message(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.fade_out_screen(25)
				helper_888ab2a3(30)
				if arg1 == 0 then
					event.set_character_active(0, arg0)
					argc_2 = event.find_local_event_counter(now_party_chara_id) or argc_2
					if 0 <= argc_2 then
						event.set_character_active(argc_2)
					end
				end
				event.set_npc_party_status(argc, 1)
				event.open_party_select_menu()
				vm.wait(4)
				helper_452267a4(arg0, arg1)
				event.fade_in_screen(30)
				return
			end
			set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			event.open_message_window_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			show_message(3, -1, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if var24 == 1 then
			set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			var25 = event.get_npc_message_number_3(argc, 3) or var25
			show_message(3, var25, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if 3 < var28 then
			if var28 == 5 then
				if var24 == 2 then
					if argc == 1 then
						event.set_save_data_value(2)
						event.open_message_window_2(3, "よし、これで\n修理完了じゃ！")
						show_message(3, -1, 3, 256, 208)
						helper_452267a4(arg0, arg1)
						event.start_crossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_5e1f717d(arg0, arg1, 6)
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_5e1f717d(arg0, arg1, 23)
						return
					end
					if argc == 4 then
						if helper_73eddd6a() ~= 0 then
							helper_5e1f717d(arg0, arg1, 33)
							return
						end
					end
				end
				if var24 == 4 then
					break
				end
				if var24 == -1 then
					break
				end
			else
				if var24 == 2 then
					if argc == 15 then
						helper_5e1f717d(arg0, arg1, 0)
					end
					if argc == 12 then
						helper_5e1f717d(arg0, arg1, 1)
					end
					if argc == 6 then
						helper_5e1f717d(arg0, arg1, 2)
					end
					if argc == 7 then
						helper_5e1f717d(arg0, arg1, 3)
					end
					if argc == 2 then
						helper_5e1f717d(arg0, arg1, 7)
					end
					if argc == 3 then
						helper_5e1f717d(arg0, arg1, 8)
					end
					if argc == 5 then
						helper_5e1f717d(arg0, arg1, 9)
					end
					if argc == 8 then
						helper_5e1f717d(arg0, arg1, 10)
					end
					if argc == 10 then
						helper_5e1f717d(arg0, arg1, 11)
					end
					if argc == 11 then
						helper_5e1f717d(arg0, arg1, 12)
					end
					if argc == 13 then
						helper_5e1f717d(arg0, arg1, 13)
					end
					if argc == 16 then
						helper_5e1f717d(arg0, arg1, 14)
					end
					if argc == 18 then
						helper_5e1f717d(arg0, arg1, 15)
					end
					if argc == 19 then
						helper_5e1f717d(arg0, arg1, 16)
					end
					if argc == 20 then
						helper_5e1f717d(arg0, arg1, 17)
					end
					if argc == 21 then
						helper_5e1f717d(arg0, arg1, 18)
					end
					if argc == 22 then
						helper_5e1f717d(arg0, arg1, 19)
					end
					if argc == 23 then
						helper_5e1f717d(arg0, arg1, 20)
					end
					if argc == 24 then
						helper_5e1f717d(arg0, arg1, 21)
					end
					if argc == 25 then
						helper_5e1f717d(arg0, arg1, 22)
					end
					if argc == 17 then
						helper_5e1f717d(arg0, arg1, 32)
					end
					if argc == 9 then
						helper_c0869c7f()
						event.set_message_draw_speed(3, 0.6, 0.6)
						show_message(3, -1, 3, 256, 208)
						helper_452267a4(arg0, arg1)
						event.start_crossfade(10)
					end
					if argc == 14 then
						event.fade_out_screen(25)
						helper_888ab2a3(30)
						event.open_event_menu(25)
						vm.wait(35)
						helper_452267a4(arg0, arg1)
						event.fade_in_screen(30)
					end
					return
				end
				if var24 == 3 then
					break
				end
				if var24 == -1 then
					break
				end
			end
		else
			if var24 == 2 then
				break
			end
			if var24 == -1 then
				break
			end
		end
	end
	helper_452267a4(arg0, arg1)
	event.start_crossfade(10)
end

return helper_dae6aadb
