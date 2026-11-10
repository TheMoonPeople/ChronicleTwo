--!strict
-- map/i/i03/h04/i03h04_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_22a04edc = require("@lib/event/helper_22a04edc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_6a61b74b = require("@lib/event/helper_6a61b74b")
local helper_6bc9eefc = require("@lib/event/helper_6bc9eefc")
local helper_772d6241 = require("@lib/event/helper_772d6241")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_81437291 = require("@lib/event/helper_81437291")
local helper_87260223 = require("@lib/event/helper_87260223")
local helper_8aa6dccc = require("@lib/event/helper_8aa6dccc")
local helper_9aa8a95a = require("@lib/event/helper_9aa8a95a")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_bb522b21 = require("@lib/event/helper_bb522b21")
local helper_bc9be28d = require("@lib/event/helper_bc9be28d")
local helper_c7fcb51a = require("@lib/event/helper_c7fcb51a")
local helper_fd981dba = require("@lib/event/helper_fd981dba")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_12b3c()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: any = 0
	local var3: any = 0
	local at: number = 0
	return vm.guard(function()
		var0 = 24
		var1 = event.get_gyorace_value(3) or var1
		if var1 == 0 then
			event.open_message_window_2(0, "Choose your pre-race, preparation tank.")
		end
		if var1 == 1 then
			event.open_message_window_2(0, "Very nicely done!\nNow it's on to the 2nd Heat.")
			at = 1
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(0, "Now it's time to choose your\npreparation tank for the 2nd Heat.")
		end
		if var1 == 2 then
			event.open_message_window_2(
				0,
				"Wow! Congratulations! You've made it to\nthe Finals. Choose your preparation tank\ncarefully!"
			)
		end
		at = 2
		helper_1c04a0eb(var0, -1, 0, 0)
		while true do
			event.set_message_window_mode(0, 8)
			event.set_message_window_option(0, 0, 0)
			event.open_message_window_2(
				0,
				"1st Tank: Keep A Steady Pace\n2nd Tank: With All Your Might\n3rd Tank: Come Out Fighting\n4th Tank: The Last Shall Be First\n5th Tank: Settle It In The Ring\n6th Tank: Go With The Middle"
			)
			event.set_message_selection_top_line(0, 0)
			at = 3
			var2 = helper_bac0e30d(0, -1, 8, 0, 0, 6, 0)
			if var2 == -1 then
				if var1 == 0 then
					event.set_message_window_mode(0, 1)
					event.set_message_selection_top_line(0, 0)
					event.set_message_window_option(0, 0, 0)
					event.set_message_window_option(0, 4, -1, -1)
					return -1
				else
					event.set_message_selection_top_line(0, 0)
					event.set_message_window_mode(0, 5)
					event.set_message_draw_speed(0, 1)
					event.open_message_window_2(0, "If you don't choose a tank, you'll\nbe retired from this race.\nAre you sure?")
					at = 4
					var3 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
					event.set_message_window_mode(0, 1)
					if var3 == 0 then
						event.set_gyorace_value(3, 0)
						event.set_message_window_mode(0, 1)
						event.set_message_selection_top_line(0, 0)
						event.set_message_window_option(0, 0, 0)
						event.set_message_window_option(0, 4, -1, -1)
						at = 5
						vm.wait(5)
						return -1
					end
				end
			else
				break
			end
		end
		event.set_gyorace_value(0, var2)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		if var1 == 0 then
			event.open_message_window_2(0, "Now for the 1st Heat.\nYou need 1st Place to advance to the 2nd\nHeat. Good luck!")
			event.set_gyorace_value(3, 0)
			event.set_gyorace_value(4)
		end
		if var1 == 1 then
			event.open_message_window_2(
				0,
				"Time now for the 2nd Heat!\nYou need 2nd Place or better to advance\nto the Final. Good luck!"
			)
		end
		if var1 == 2 then
			event.open_message_window_2(
				0,
				"Well, you've made your preparations. Now\nthe Final is here! Place 3rd or better to\nwin a prize.<page>But, of course, your real\ngoal is to aim for the top!"
			)
		end
		at = 6
		helper_1c04a0eb(var0, -1, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 7
		wait_frames(30)
		event.stop_music(0)
		helper_81437291()
		at = 8
		vm.wait(8)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 3 then
				var2 = received[1] :: number
			end
			if at <= 1 then
				helper_9aa8a95a(var0, -1, 0, 0)
			end
			if at <= 2 then
				var2 = helper_7d54f41c(0, -1, 8, 0, 0, 6, 0)
			end
			return -1
		end
		if at <= 5 then
			if at == 4 then
				var3 = received[1] :: number
			end
			return -1
		end
		if at <= 8 then
			if at <= 6 then
				wait_frames_skipping(30)
			end
			if at <= 7 then
				helper_1ef0d4b2()
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_1621c()
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { s32 } = table.create(49, 0)
	local at: number = 0
	return vm.guard(function()
		helper_bc9be28d()
		frame[8] = event.get_gyorace_value(1) or frame[8]
		event.set_character_position(0, 126.15, 0.0, -376.23)
		event.set_character_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_motion(0, "立ち", 0)
		event.set_camera_position(136.75, 46.57, -242.89)
		event.set_camera_look_at(101.62, 35.0, -367.91)
		event.fade_in_screen(30)
		frame[9] = event.get_gyorace_value(3) or frame[9]
		if frame[9] == 0 then
			if 0 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 1)
			at = 1
			if helper_12b3c() == -1 then
				return -1
			end
		end
		if frame[9] == 1 then
			if 1 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 2)
			at = 2
			if helper_12b3c() == -1 then
				return -1
			end
		end
		if frame[9] == 2 then
			if 2 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 0)
		end
		event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
		event.set_object_handle_visible(8, 0)
		event.play_sound_effect(global0, 0)
		event.set_camera_sequence_position(-5.99, 55.55, -213.4)
		event.set_camera_sequence_look_at(0.0, 55.55, -471.19)
		at = 3
		wait_frames(30)
		event.move_camera_sequence(-5.99, 181.46, -213.4, 0.0, 181.46, -471.19, 180)
		at = 4
		wait_camera()
		event.stop_sound_effect(global0, 0)
		event.play_sound_effect(global0, 3)
		frame[6] = 1
		event.set_message_window_mode(1, 0)
		event.set_message_window_option(1, 7, 20, 100, 20, 128)
		event.set_message_window_option(1, 8, 0)
		frame[6] = 0
		frame[12] = 0
		frame[13] = 0
		frame[14] = 0
		frame[45] = event.get_language() or frame[45]
		if frame[45] == 1 then
			event.set_message_window_option(1, 2, 0.5)
		end
		while frame[6] < 6 do
			event.set_gyorace_value(5, 1, vm.i32(1 + frame[6]), frame[6])
			event.set_gyorace_value(6, 1, vm.i32(7 + frame[6]), frame[6])
			if frame[6] == frame[8] then
				frame[12] = 1
			else
				frame[7] = vm.float_bits(event.get_random_number(24)) or frame[7]
				while true do
					frame[46] = 0
					while frame[14] > frame[46] do
						if frame[vm.index(vm.i32(frame[46] + 14), 49)] == frame[7] then
							break
						else
							frame[46] = vm.i32(frame[46] + 1)
						end
					end
					if frame[14] == frame[46] then
						break
					else
						frame[7] = vm.float_bits(event.get_random_number(24)) or frame[7]
					end
				end
				frame[vm.index(vm.i32(frame[14] + 14), 49)] = frame[7]
				frame[14] = vm.i32(frame[14] + 1)
				if vm.i32(frame[6] + 1) <= 3 then
					if frame[13] == 0 then
						event.load_npc_character(0, 4, vm.i32(frame[7] + 1), 15)
					end
					if frame[13] == 1 then
						event.load_npc_character(0, 4, vm.i32(frame[7] + 1), 16)
					end
					frame[13] = vm.i32(frame[13] + 1)
				end
			end
			frame[6] = vm.i32(frame[6] + 1)
		end
		event.play_sound_effect(global0, 4)
		event.open_message_window_2(
			1,
			"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n\n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
		)
		at = 5
		helper_6bc9eefc(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(global0, 4)
		event.open_message_window_2(
			1,
			"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
		)
		at = 6
		helper_6bc9eefc(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(global0, 4)
		event.open_message_window_2(
			1,
			"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n　　　　　１　[文字列１]　[文字列７] \n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n　　　　　　　　　　　　　　　"
		)
		at = 7
		helper_6bc9eefc(1, -1, 4, 0, 0, 90)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(16, 0.0, 0.0, 0.0)
		if frame[8] == 0 then
			event.set_character_active(1, 8)
			event.set_character_position(8, 0.0, 68.97, -470.0)
			event.set_save_flag(41, 1)
			event.set_character_position(15, 30.0, 20.0, -470.0)
			event.set_character_position(16, -30.0, 16.0, -470.0)
			event.set_character_position(0, 0.0, 36.0, -470.0)
			event.set_character_motion(0, "1位", 0)
		end
		if frame[8] == 1 then
			event.set_character_position(15, 0.0, 36.0, -470.0)
			event.set_character_position(16, -30.0, 16.0, -470.0)
			event.set_character_position(0, 30.0, 20.0, -470.0)
			event.set_character_motion(0, "2位", 0)
		end
		if frame[8] == 2 then
			event.set_character_position(15, 0.0, 36.0, -470.0)
			event.set_character_position(16, 30.0, 20.0, -470.0)
			event.set_character_position(0, -30.0, 16.0, -470.0)
			event.set_character_motion(0, "3位", 0)
		end
		event.set_character_active(15)
		event.set_character_active(16)
		event.set_camera_sequence_position(-1.26, 25.59, -336.37)
		event.set_camera_sequence_look_at(0.0, 36.39, -471.19)
		event.start_crossfade(60)
		at = 8
		wait_frames(90)
		event.set_object_handle_visible(8, 1)
		frame[49] = event.get_gyorace_value(2) or frame[49]
		do
			local out1, out2 = event.get_gyorace_value(4, frame[49], vm.i32(frame[8] + 1))
			frame[47] = out1 or frame[47]
			frame[48] = out2 or frame[48]
		end
		event.play_sound_effect(global1, 0)
		at = 9
		helper_772d6241(0, vm.i32(frame[8] + 1), frame[47], frame[48])
		event.add_inventory_item(frame[47], frame[48])
		at = 10
		helper_a87eb945(1)
		if frame[8] == 0 then
			event.set_gyorace_value(7)
		end
		event.fade_out_screen(30)
		at = 11
		wait_frames(30)
		if frame[45] == 1 then
			event.set_message_window_option(1, 2, -1)
		end
		event.set_character_active(0, 8)
		event.delete_character(15)
		event.delete_character(16)
		event.set_character_position(0, 126.15, 0.0, -376.23)
		event.set_character_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_motion(0, "立ち", 0)
		event.set_camera_position(136.75, 46.57, -242.89)
		event.set_camera_look_at(101.62, 35.0, -367.91)
		event.fade_in_screen(30)
		at = 12
		wait_frames(30)
		return 1
	end, function(received: { any })
		if at <= 1 then
			return -1
		end
		if at <= 2 then
			return -1
		end
		if at <= 12 then
			if at <= 3 then
				helper_344d6cd8()
			end
			if at <= 4 then
				frame[6] = 1
				frame[6] = 0
				frame[12] = 0
				frame[13] = 0
				frame[14] = 0
				local _ = frame[45] == 1
				local _ = frame[6] < 6
				local _ = frame[6] == frame[8]
				frame[12] = 1
				frame[46] = 0
				local _ = frame[14] > frame[46]
				local _ = frame[vm.index(vm.i32(frame[46] + 14), 49)] == frame[7]
				frame[46] = vm.i32(frame[46] + 1)
				local _ = frame[14] == frame[46]
				frame[vm.index(vm.i32(frame[14] + 14), 49)] = frame[7]
				frame[14] = vm.i32(frame[14] + 1)
				local _ = vm.i32(frame[6] + 1) <= 3
				local _ = frame[13] == 0
				local _ = frame[13] == 1
				frame[13] = vm.i32(frame[13] + 1)
				frame[6] = vm.i32(frame[6] + 1)
				helper_22a04edc(1, -1, 4, 0, 0, 60)
			end
			if at <= 5 then
				helper_22a04edc(1, -1, 4, 0, 0, 60)
			end
			if at <= 6 then
				helper_22a04edc(1, -1, 4, 0, 0, 90)
			end
			if at <= 7 then
				wait_frames_skipping(90)
			end
			if at <= 8 then
				helper_c7fcb51a(0, vm.i32(frame[8] + 1), frame[47], frame[48])
			end
			if at <= 9 then
				helper_bb522b21(1)
			end
			if at <= 10 then
				wait_frames_skipping(30)
			end
			if at <= 11 then
				wait_frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_13cc4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local omake_flag: s32 = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: any = 0
	local var9: any = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local var20: s32 = 0
	local var21: any = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(0, "立ち", 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no ~= 0 then
		event.open_message_window_2(0, "Oh, would you like to try it, too, Miss?")
		helper_1c04a0eb(var0, -1, 0, 0)
		event.open_message_window_2(0, "I'm good, thank you.<page>This is Max's territory.")
		helper_0ffc2526(0, -1, 0, var0, 0)
		return
	end
	omake_flag = event.is_extra_mode() or omake_flag
	if omake_flag ~= 0 then
		event.open_event_menu(23, 0)
		vm.wait(3)
		event.fade_in_screen(15)
		do
			local out1, _, _, _ = event.get_menu_results_4()
			var3 = out1 or var3
		end
		if var3 == 1000 then
			event.fade_out_music(30)
			event.fade_out_screen(30)
			wait_frames(30)
			event.stop_music(0)
			helper_81437291()
		end
		return
	end
	var7 = event.get_gyorace_value(5) or var7
	if var7 >= 3 then
		event.open_message_window_2(0, "And that concludes the Finny Frenzy.\nHope to see you at the next one!")
		helper_1c04a0eb(var0, -1, 0, 0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
		event.stop_music(0)
		event.set_menu_value(1)
		helper_fd981dba()
		event.fade_in_screen(30)
		event.jump_to_map_2(-1, "s45")
		vm.wait(7)
	end
	event.open_message_window_2(0, "The Finny Frenzy is about to begin!\nWant to join in?")
	helper_1c04a0eb(var0, -1, 0, 0)
	while true do
		event.open_message_window_2(0, "Join in\nWhat's it all about?\nWhat are the prizes?\nGuess not")
		var8 = helper_8aa6dccc(0, -1, 0, var0, 4, 3)
		if var8 == -1 or var8 == 3 then
			event.open_message_window_2(0, "It's fun to watch, of course.\nBut taking part'll really get\nyour blood pumping!")
			helper_1c04a0eb(var0, -1, 0, 0)
			return
		end
		if var8 == 1 then
			event.open_message_window_2(
				0,
				"In each Finny Frenzy tournament,\nthere are 3 races.<page>Once a fish wins a prize, though,\nyou can't use it in any other race\nin that same tournament."
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				'Just talk to me and tell me\nyou want to join in. Then you\npick the fish you want to race.<page>You have to have your fish in\nthe "Rec Tank" in order to\nput them in a race.'
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Once you've picked your fish, you choose\nthe class you want them to take part in.<page>From Beginner to Master, try to choose\nthe class most appropriate to your\nfish's level.<page>Once a fish wins in one\nclass, though, it can only participate\nin the next higher class after that."
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Once a fish wins the highest Master\nclass, though, you can enter it as\nmany times as you want in that class.<page>Next, you choose the tank to put your\nfish in for final, pre-race preparations.<page>The water in each tank is slightly\ndifferent, and will have an effect on\nthe fish's performance."
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"If you put a fish in a tank that enhances\nits abilities, you might get some\nsurprisingly good results!<page>When your pre-race preparations are done,\nit's time to race. All you have to do now\nis relax and cheer your fish on!"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"The races go from the 1st Heat,\nto the 2nd Heat, to the Finals.\nIn order to win a prize,<page>your fish has to be 1st in the 1st Heat,\n2nd or better in the 2nd Heat,\nand then 3rd or better in the Finals.<page>But, of course, your real goal is to\nbe number one all the way through.\nGood luck!"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
		end
		if var8 == 2 then
			event.open_message_window_2(0, "Beginner\nJunior\nSenior\nMaster")
			var9 = helper_8aa6dccc(0, -1, 0, var0, 4, 0)
			if var9 ~= -1 then
				event.open_message_window_2(0, "The prizes for this race are...")
				helper_1c04a0eb(var0, -1, 0, 0)
				do
					local out1, out2 = event.get_gyorace_value(4, var9, 1)
					var10 = out1 or var10
					var13 = out2 or var13
				end
				do
					local out1, out2 = event.get_gyorace_value(4, var9, 2)
					var11 = out1 or var11
					var14 = out2 or var14
				end
				do
					local out1, out2 = event.get_gyorace_value(4, var9, 3)
					var12 = out1 or var12
					var15 = out2 or var15
				end
				helper_6a61b74b(var10, var13, var11, var14, var12, var15)
			end
		end
		if var8 == 0 then
			break
		end
	end
	var16 = event.get_gyorace_value(3) or var16
	var17 = event.get_message_window_option(0, 2) or var17
	if var17 < 1 then
		event.open_message_window_2(
			0,
			"Oops! Looks like you don't have\nany fish to enter.<page>Come back after you've raised\nsome up."
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	var7 = event.get_gyorace_value(5) or var7
	event.set_message_number(0, 1, vm.i32(var7 + 1))
	event.open_message_window_2(0, "Time now for Stage [数値１].\nChoose your fish.")
	helper_1c04a0eb(var0, -1, 0, 0)
	while true do
		event.open_event_menu(15, 0)
		vm.wait(22)
		do
			local out1, out2, out3 = event.get_menu_results_3()
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		if var18 == -1 then
			return
		elseif var20 ~= 0 then
			event.open_message_window_2(0, "This fish has already won a prize.\nPick another fish.")
			helper_1c04a0eb(var0, -1, 0, 0)
		else
			break
		end
	end
	if var16 == 0 then
		event.open_message_window_2(0, "Next, choose your fish's class.")
		helper_1c04a0eb(var0, -1, 0, 0)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "Beginner\nJunior\nSenior\nMaster")
		event.set_message_selection_top_line(0, 0)
		var21 = helper_bac0e30d(0, -1, 8, 0, 0, 4, 0)
	else
		var21 = event.get_gyorace_value(2) or var21
	end
	event.set_message_window_mode(0, 1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 0)
	event.set_message_window_option(0, 4, -1, -1)
	if var21 == -1 then
		return
	end
	if var21 == 0 and bit32.band(var19, 1) == 0 then
		event.open_message_window_2(0, "This fish already won the Beginner Class.\nWhy don't you try it in another class?")
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	if var21 == 1 and bit32.band(var19, 2) == 0 then
		event.open_message_window_2(0, "This fish already won the Junior Class.\nWhy don't you try it in another class?")
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	if var21 == 2 and bit32.band(var19, 4) == 0 then
		event.open_message_window_2(0, "This fish already won the Senior Class.\nWhy don't you try it in another class?")
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	if var16 == 0 then
		event.set_gyorace_value(2, var21)
	end
	helper_12b3c()
	vm.wait(30)
end

--- Helper function.
local function helper_e3cc()
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local var4: s32 = 0
	local omake_flag: s32 = 0
	event.get_player_character_slot()
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hello there.\nGreat weather, isn't it.")
	active_chr_no = event.get_playable_character() or active_chr_no
	var4 = event.get_chapter() or var4
	omake_flag = event.is_extra_mode() or omake_flag
	if var2 == 161 then
		if var4 < 6 then
			event.open_message_window_2(
				0,
				"Why doesn't my wife understand \nhow fun this is? Nothing could \nbe better than the Finny Frenzy!"
			)
		else
			event.open_message_window_2(
				0,
				"My fish is racking up the wins\nin the Master class.<page>Trust me, he's gonna clean up\nin this race too."
			)
		end
	end
	if var2 == 171 then
		event.open_message_window_2(
			0,
			"I came here looking for my\nhusband. He's always here.<page>Oh, my, this looks like it\nmight be kind of exciting."
		)
	end
	if var2 == 169 then
		if omake_flag == 0 then
			event.open_message_window_2(
				0,
				"The results of the race greatly\ndepend on pre-race preparations.\nChoose your tank carefully.<page>But, of course, you'll never beat\nmy fish, anyway..."
			)
		else
			event.open_message_window_2(
				0,
				"You again, eh?\nNever learn, do you.<page>If you want to race,\nfine. Just don't get\nin my fish's way!"
			)
		end
	end
	if var2 == 167 then
		if var4 < 7 then
			if active_chr_no ~= 1 then
				event.open_message_window_2(
					0,
					"Max, aren't you gonna race?\nIf you do, be sure to let me know!\nI'll cheer for you real good."
				)
			else
				event.open_message_window_2(
					0,
					"Monica, aren't you gonna race?\nIf you do, be sure to let me know!\nI'll cheer for you real good."
				)
			end
		elseif active_chr_no ~= 1 then
			event.open_message_window_2(
				0,
				"I don't like fish.\nI wanna go home!<page>How come grown-ups think this\nis such a big deal? Huh, Max?"
			)
		else
			event.open_message_window_2(
				0,
				"I don't like fish.\nI wanna go home!<page>How come grown-ups think this is\nsuch a big deal? Huh, Monica?"
			)
		end
	end
	if var2 == 166 then
		event.open_message_window_2(
			0,
			"I never gamble, really.<page>Well, my girlfriend insisted, you\nsee, and that's the only reason..."
		)
	end
	if var2 == 165 then
		if var4 < 7 then
			event.open_message_window_2(
				0,
				"I dunno why, but watching the fish\nswim really gets my blood pumping.<page>You could say it's like\nmy fountain of youth."
			)
		else
			event.open_message_window_2(
				0,
				"I brought my grandkid with me today.\nNow where did that kid go?<page>You turn your back for one second..."
			)
		end
	end
	if var2 == 160 then
		event.open_message_window_2(
			0,
			"My fish really shines\non the straightaways.<page>Which one's mine?\n*chuckle*\nThat's top secret."
		)
	end
	if var2 == 172 then
		if omake_flag == 0 then
			event.open_message_window_2(
				0,
				"Look at the scales on Number 3!\nShiny and sleek!<page>It's a definite winner. You'll see!"
			)
		else
			event.open_message_window_2(
				0,
				"I was only gonna try racing once,\nbut then I got hooked.\nNow I never miss a race!<page>(sigh) I really messed up\nmy last pre-race prep..."
			)
		end
	end
	if var2 == 158 then
		if var4 < 7 then
			event.open_message_window_2(
				0,
				"I go fishing with my dad a lot,\nbut there are all kinds of fish\nhere I've never seen before!"
			)
		else
			event.open_message_window_2(
				0,
				"Wow! Look at all the adorable\nfishes! Oh my gosh, that one\nlooks just like a horse!<page>Huh? Where did you go,\nGrandpa? Grandpa!"
			)
		end
	end
	if var2 == 159 then
		event.open_message_window_2(0, "This is the Finny Frenzy\ncompetition.<page>Now, please!\nDon't get carried away...")
	end
	if var2 == 162 then
		event.open_message_window_2(0, "These are the Finny Frenzy Races.<page>Just let your hair down\nand have a good time!")
	end
	if var2 == 168 then
		if omake_flag == 0 then
			event.open_message_window_2(
				0,
				"All fish look alike to me.\nHow can I tell them apart?<page>Guess I'll just have to follow\nmy gut."
			)
		else
			event.open_message_window_2(0, "My boyfriend's fish is gonna\nbe in the next race. I'm so\nexcited, I can't stand it!")
		end
	end
	helper_1c04a0eb(var1, -1, 0, 0)
	event.set_villager_ai_enabled(1, var1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	global0 = 0
	global1 = 0
	event.set_save_control_bits(1, 1)
	helper_bc9be28d()
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 1)
	event.set_gyorace_value(7)
	event.set_character_position(0, 0.0, 0.0, 450.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1, 3.14)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.open_message_window_2(
		0,
		"Oh, what a shame. But you should be proud\nof making it all the way to the Final!\nI'll be watching for you next time, so\nkeep on trying!"
	)
	helper_0ffc2526(0, -1, 24, 0, 0)
	global0 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global0
	global1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global1
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(global0, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	wait_frames(90)
	event.stop_sound_effect(global0, 0)
	event.play_sound_effect(global0, 3)
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	for var0 = 0, 5 do
		event.set_message_inserted_string(1, 1 + var0, "０１２３４５６７８９ ")
		event.set_message_inserted_string(1, 7 + var0, "９９：９９：９９")
	end
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n\n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	helper_6bc9eefc(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	helper_6bc9eefc(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n　　　　　１　[文字列１]　[文字列７] \n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n　　　　　　　　　　　　　　　"
	)
	show_message(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	wait_frames(35)
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local omake_flag: s32 = 0
	local var1: s32 = 0
	local var2: any = 0
	omake_flag = event.is_extra_mode() or omake_flag
	var1 = event.get_gyorace_value(5) or var1
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	vm.wait(1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	if omake_flag == 0 then
		if var1 <= 0 then
			event.open_message_window_2(0, "Leave the Finny Frenzy?")
		else
			event.open_message_window_2(0, "Once you leave the Finny Frenzy ends.\nAre you sure you want to go?")
		end
	else
		event.fade_out_screen(10)
		wait_frames(10)
		event.open_event_menu(26)
		vm.wait(3)
		event.fade_in_screen(10)
		event.open_message_window_2(0, "Return to Title Screen?")
	end
	var2 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	event.set_message_window_mode(0, 1)
	if var2 == 0 then
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
		event.stop_music(0)
		if 0 < var1 then
			event.set_menu_value(1)
		end
		helper_fd981dba()
		event.fade_in_screen(30)
		if omake_flag == 0 then
			event.jump_to_map_2(-1, "s45")
			vm.wait(6)
		else
			event.set_scene_exit_flag(1)
		end
	end
	return 1
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	print("---401----------------------------\n")
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local var0: s32 = 0
	local var1: s32 = 0
	event.initialize_event()
	event.set_save_control_bits(1, 1)
	event.load_music(193)
	global0 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global0
	global1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global1
	var0 = helper_1621c()
	event.play_music(0)
	if var0 == 0 then
		event.set_character_motion(0, "がっかりL", 0)
		var1 = event.get_gyorace_value(3) or var1
		if var1 == 0 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(0, "Oh, too bad!\nWell, don't give up. Try again!")
		end
		if var1 == 1 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"Ah! There's fierce competition in\nthe 2nd Heat. Well, never mind.\nDon't give up. Try, try again!"
			)
		end
		if var1 == 2 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"Oh, what a shame. But you should be proud\nof making it all the way to the Final!\nI'll be watching for you next time, so\nkeep on trying!"
			)
		end
		helper_0ffc2526(0, -1, 24, 0, 0)
	end
	event.delete_character_extension_packs(0)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	local var0: s32 = 0
	local language_code: s32 = 0
	event.set_save_control_bits(1, 1)
	event.initialize_event()
	event.load_music(193)
	helper_bc9be28d()
	global0 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global0
	global1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global1
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(global0, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	wait_frames(90)
	event.stop_sound_effect(global0, 0)
	event.play_sound_effect(global0, 3)
	var0 = 1
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	var0 = 0
	language_code = event.get_language() or language_code
	if language_code == 1 then
		event.set_message_window_option(1, 2, 0.5)
	end
	while var0 < 6 do
		event.set_gyorace_value(5, 1, 1 + var0, var0)
		event.set_gyorace_value(6, 1, 7 + var0, var0)
		var0 = var0 + 1
	end
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n\n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	helper_6bc9eefc(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n\n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n"
	)
	helper_6bc9eefc(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"　　　　　RANK　　　Name　　　　　　Time\n　　　　　──────────────────────\n　　　　　１　[文字列１]　[文字列７] \n\n　　　　　２　[文字列２]　[文字列８] \n\n　　　　　３　[文字列３]　[文字列９] \n\n　　　　　４　[文字列４]　[文字列１０] \n\n　　　　　５　[文字列５]　[文字列１１] \n\n　　　　　６　[文字列６]　[文字列１２] \n　　　　　　　　　　　　　　　"
	)
	show_message(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	wait_frames(35)
	event.play_music(0)
	if language_code == 1 then
		event.set_message_window_option(1, 2, -1)
	end
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(13) or var0
		if var0 == 24 then
			at = 1
			helper_13cc4()
		else
			at = 2
			helper_e3cc()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_87260223()
			end
			return 0
		end
		return nil
	end)
end

return script
