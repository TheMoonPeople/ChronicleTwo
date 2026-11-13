--!strict
--- Mount Gundor Peak events: the Firesquall, the battleship assault and the two exits to the dungeon.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local mount_gundor_peak = require("@lib/event/mount_gundor_peak")
local wait = require("@lib/event/wait")

--- Loads the peak sounds and shows or hides the map parts by progress flags.
local function initialize_peak()
	local assault_flag: s32 = 0
	local battle_done_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(5684)
	event.set_function_point_enabled("", "useitem_00", 0)
	event.set_function_point_enabled("", "dun_entrance", 1)
	event.set_function_point_enabled("", "entrance", 1)
	assault_flag = event.get_save_flag(516) or assault_flag
	event.get_item_count(372)
	if assault_flag == 0 then
		event.set_function_point_enabled("", "useitem_00", 1)
	end
	if assault_flag == 1 then
		event.attach_object_handle_to_map_part_2(0, "p03_s2001")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(0, "p04_s2001")
		event.set_object_handle_visible(0, 1)
	end
	event.attach_object_handle_to_map_part_2(0, "p01_battleship")
	event.set_object_handle_visible(0, 0)
	battle_done_flag = event.get_save_flag(520) or battle_done_flag
	if battle_done_flag ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p04_s2001", "s2006-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(0, "firesquall")
		event.set_object_handle_visible(0, 0)
		event.set_function_point_enabled("p04_s2001", "eff_s20ef-0", 0)
		event.set_function_point_enabled("p04_s2001", "eff_s20ef-1", 0)
		event.set_function_point_enabled("p04_s2001", "eff_s20ef-2", 0)
		event.set_function_point_enabled("p04_s2001", "eff_s20ef-3", 0)
	end
end

--- Walks the player to the first exit, asking whether to leave there once the battleship battle is won, and returns 1 when leaving and 0 otherwise.
local function confirm_leave_at_first_exit()
	local active_character: s32 = 0
	local assault_flag: s32 = 0
	local battle_done_flag: s32 = 0
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local i: s32 = 0
	local speaking_character: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				step = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				step = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			step = 3
			wait.frames(10)
			event.set_character_position(0, -2074.0, -7.0, 3098.8)
			event.set_character_rotation(0, 0.0, 3.05, 0.0)
			event.set_camera_position(-2086.23, 51.55, 3226.23)
			event.set_camera_look_at(-2074.0, 22.99, 3098.82)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		assault_flag = event.get_save_flag(516) or assault_flag
		battle_done_flag = event.get_save_flag(520) or battle_done_flag
		if assault_flag ~= 0 and battle_done_flag == 0 then
			answer = 1
		else
			step = 4
			answer = message.ask_yes_no(2, -1)
		end
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-2067.37, 112.9, 2821.78)
			event.set_camera_sequence_look_at(-2002.24, 24.33, 3103.52)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -2000.28, 0.23, 3105.85)
			event.add_object_sequence_path_point(0, -2010.93, -14.79, 3194.18)
			event.add_object_sequence_path_point(0, -2000.43, -24.24, 3288.22)
			event.add_object_sequence_path_point(0, -1957.41, -49.2, 3404.27)
			event.start_object_sequence_path(0)
			step = 5
			wait.frames(40)
			event.fade_out_screen(20)
			step = 6
			wait.frames(20)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				player_x = out1 or player_x
				player_y = out2 or player_y
				player_z = out3 or player_z
			end
			destination_x = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 40.0) + player_x)
			destination_y = 0.0
			destination_z = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 40.0) + player_z)
			event.move_object_sequence(0, destination_x, destination_y, destination_z, 30, 1)
			event.turn_object_sequence_toward(0, destination_x, destination_y, destination_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					player_x = out1 or player_x
					player_y = out2 or player_y
					player_z = out3 or player_z
				end
				player_y = vm.f32(player_y + 30.0)
				event.set_camera_look_at(player_x, player_y, player_z)
				i = i + 1
				step = 7
				vm.wait(7)
			end
			event.set_object_sequence_motion(0, "立ち")
		end
		if assault_flag ~= 0 and battle_done_flag == 0 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			speaking_character = event.get_playable_character() or speaking_character
			if speaking_character == 0 then
				event.open_message_window_2(0, "Time to fight back in the Ride Pod!")
			else
				event.open_message_window_2(0, "Max, time to fight back in\nthe Ride Pod!")
			end
			step = 8
			message.show_and_wait(0, -1, 5, 256, 208)
		end
		event.set_object_handle_footstep_sound(0, 0)
		event.reset_follow_camera(0)
		event.finish_event()
		return 0
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			if step <= 2 then
				wait.frames_skipping(10)
			end
			return 0
		end
		if step <= 6 then
			if step == 4 then
				answer = received[1] :: number
			end
			if step <= 4 then
				wait.frames_skipping(40)
			end
			if step <= 5 then
				wait.frames_skipping(20)
			end
			return 1
		end
		if step <= 8 then
			if step <= 7 then
				message.show_and_wait_skipping(0, -1, 5, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Walks the player to the second exit, asking whether to leave there once the battleship battle is won, and returns 1 when leaving and 0 otherwise.
local function confirm_leave_at_second_exit()
	local active_character: s32 = 0
	local assault_flag: s32 = 0
	local battle_done_flag: s32 = 0
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local i: s32 = 0
	local firesquall_appeared_flag: s32 = 0
	local speaking_character: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				step = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				step = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			step = 3
			wait.frames(10)
			event.set_character_position(0, 1459.7, -279.01, 2009.85)
			event.set_character_rotation(0, 0.0, -1.77, 0.0)
			event.set_camera_position(1584.28, -250.6, 2035.61)
			event.set_camera_look_at(1459.7, -249.01, 2009.85)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		assault_flag = event.get_save_flag(516) or assault_flag
		battle_done_flag = event.get_save_flag(520) or battle_done_flag
		if assault_flag == 0 or battle_done_flag == 0 then
			answer = 1
		else
			step = 4
			answer = message.ask_yes_no(1, -1)
		end
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(1237.07, -178.87, 1868.72)
			event.set_camera_sequence_look_at(1400.74, -221.62, 1965.01)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, 1494.73, -279.24, 2020.78)
			event.add_object_sequence_path_point(0, 1549.77, -279.45, 2063.4)
			event.add_object_sequence_path_point(0, 1615.07, -279.45, 2101.81)
			event.add_object_sequence_path_point(0, 1681.3, -279.46, 2136.65)
			event.start_object_sequence_path(0)
			step = 5
			wait.frames(40)
			event.fade_out_screen(20)
			step = 6
			wait.frames(20)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				player_x = out1 or player_x
				player_y = out2 or player_y
				player_z = out3 or player_z
			end
			destination_x = vm.f32(vm.f32(vm.sin(-2.0) * 50.0) + player_x)
			destination_y = 0.0
			destination_z = vm.f32(vm.f32(vm.cos(-2.0) * 50.0) + player_z)
			event.move_object_sequence(0, destination_x, destination_y, destination_z, 30, 1)
			event.turn_object_sequence_toward(0, destination_x, destination_y, destination_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 30)
			event.set_object_sequence_motion(0, "立ち")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					player_x = out1 or player_x
					player_y = out2 or player_y
					player_z = out3 or player_z
				end
				player_y = vm.f32(player_y + 30.0)
				event.set_camera_look_at(player_x, player_y, player_z)
				i = i + 1
				step = 7
				vm.wait(7)
			end
		end
		if assault_flag == 0 or battle_done_flag == 0 then
			firesquall_appeared_flag = event.get_save_flag(508) or firesquall_appeared_flag
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			speaking_character = event.get_playable_character() or speaking_character
			if speaking_character == 0 then
				if assault_flag == 0 then
					if firesquall_appeared_flag == 0 then
						event.open_message_window_2(
							0,
							"It looks like that machine's\nthe one making it rain fire.<page>You have to do something about\nthis! But what should you do?"
						)
					else
						event.open_message_window_2(0, "We have to destroy the Firesquall!")
					end
				else
					event.open_message_window_2(0, "Time to fight back in the Ride Pod!")
				end
			elseif assault_flag == 0 then
				if firesquall_appeared_flag == 0 then
					event.open_message_window_2(
						0,
						"It looks like that machine's\nthe one making it rain fire.<page>You have to do something about\nthis! But what should you do?"
					)
				else
					event.open_message_window_2(0, "The Firesquall isn't here.")
				end
			else
				event.open_message_window_2(0, "Max, time to fight back in\nthe Ride Pod!")
			end
			step = 8
			message.show_and_wait(0, -1, 5, 256, 208)
		end
		event.set_object_handle_footstep_sound(0, 0)
		event.reset_follow_camera(0)
		event.finish_event()
		return 0
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			if step <= 2 then
				wait.frames_skipping(10)
			end
			return 0
		end
		if step <= 6 then
			if step == 4 then
				answer = received[1] :: number
			end
			if step <= 4 then
				wait.frames_skipping(40)
			end
			if step <= 5 then
				wait.frames_skipping(20)
			end
			return 1
		end
		if step <= 8 then
			if step <= 7 then
				message.show_and_wait_skipping(0, -1, 5, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script loads.
function script.setup() end

script.initialize_peak = initialize_peak
script[99] = script.initialize_peak

--- Starts the peak, playing the Firesquall arrival scene when due.
function script.default_event()
	local firesquall_appeared_flag: s32 = 0
	local arrival_scene_seen_flag: s32 = 0
	initialize_peak()
	firesquall_appeared_flag = event.get_save_flag(508) or firesquall_appeared_flag
	arrival_scene_seen_flag = event.get_save_flag(512) or arrival_scene_seen_flag
	if firesquall_appeared_flag == 1 and arrival_scene_seen_flag == 0 then
		mount_gundor_peak.play_firesquall_arrival_scene()
	else
		mount_gundor_peak.run_in_from_entrance()
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default.
function script.key_open() end

--- Waits for the confirm button.
function script.wait_for_confirm_button()
	vm.wait(1)
	wait.until_button_pressed(64)
	event.finish_event()
end
script[151] = script.wait_for_confirm_button

--- Lets the player examine the Firesquall and use the item that starts the battleship assault.
function script.examine_firesquall()
	local active_character: s32 = 0
	local trigger_mode: s32 = 0
	local used_item: s32 = 0
	local item_count: s32 = 0
	local confirmed: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.apply_message_window_preset(0, 4)
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				step = 1
				message.show_and_wait(0, 22, 8, 0, 0)
			else
				step = 2
				message.show_and_wait(0, 23, 8, 0, 0)
			end
			event.finish_event()
			return
		end
		trigger_mode = event.get_triggered_event_data_2(6) or trigger_mode
		if trigger_mode == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			item_count = event.get_item_count(372) or item_count
			if item_count <= 0 then
				event.open_message_window_2(0, "We have to find something that\ncan destroy this.\n(Press (#) to use Items.)")
			else
				event.open_message_window_2(0, "The Firesquall.\n(Press (#) to open Menu)")
			end
			step = 3
			confirmed = message.ask_confirmation(0, -1, 5, 256, 208, confirmed)
			if confirmed == 1 then
				trigger_mode = 2
			end
		end
		if trigger_mode == 2 then
			event.open_use_item_menu(372)
			step = 4
			vm.wait(4)
			used_item = vmhost.used_item() or used_item
			if used_item > 0 then
				if used_item == 372 then
					event.fade_out_screen(15)
					step = 5
					wait.frames(15)
					event.switch_dungeon_main_character(0)
					step = 6
					mount_gundor_peak.play_battleship_assault_scene()
					event.set_save_control_bits(1, 1)
					event.set_function_point_enabled("", "dun_entrance", 0)
					event.set_function_point_enabled("", "entrance", 0)
					event.set_character_change_enabled(3, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_character_change_enabled(1, 0)
					event.set_character_change_unmasked(1, 0)
					event.initialize_event()
					step = 7
					vm.wait(7)
					event.attach_object_handle_to_map_part_2(0, "p01_battleship")
					event.set_object_handle_visible(0, 1)
					event.load_dungeon_monster(517, 1)
					event.load_dungeon_monster(518, 0)
					event.load_dungeon_monster(519, 0)
					event.place_dungeon_monster(517, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.fade_in_screen(15)
					return
				else
					step = 8
					character.shake_head()
				end
			end
		end
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				message.show_and_wait_skipping(0, 23, 8, 0, 0)
			end
			return 0
		end
		if step <= 7 then
			if step == 3 then
				confirmed = received[2] :: number
			end
			if step <= 3 then
				local _ = trigger_mode == 1
				trigger_mode = 2
			end
			if step <= 4 then
				wait.frames_skipping(15)
			end
			if step <= 5 then
				step = 6
				mount_gundor_peak.play_battleship_assault_scene()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 1)
					event.set_function_point_enabled("", "dun_entrance", 0)
					event.set_function_point_enabled("", "entrance", 0)
					event.set_character_change_enabled(3, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_character_change_enabled(1, 0)
					event.set_character_change_unmasked(1, 0)
					event.initialize_event()
					step = 7
					vm.wait(7)
					event.attach_object_handle_to_map_part_2(0, "p01_battleship")
					event.set_object_handle_visible(0, 1)
					event.load_dungeon_monster(517, 1)
					event.load_dungeon_monster(518, 0)
					event.load_dungeon_monster(519, 0)
					event.place_dungeon_monster(517, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.fade_in_screen(15)
					return
				end)
			end
			return 0
		end
		if step <= 8 then
			return 0
		end
		return nil
	end)
end
script[502] = script.examine_firesquall

--- Resets the party and plays the Guiltoni fight scene.
function script.cutscene_guiltoni_fight()
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		step = 1
		wait.frames(20)
		event.clear_event_battle_monsters(-1)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.return_monica_items_to_inventory()
		event.set_party_member(3, 0)
		event.set_character_change_enabled(3, 0)
		event.set_character_change_unmasked(3, 0)
		event.set_party_member(1, 0)
		event.set_character_change_enabled(1, 0)
		event.set_character_change_unmasked(1, 0)
		step = 2
		mount_gundor_peak.play_guiltoni_fight_scene()
		event.set_save_control_bits(1, 0)
		event.set_function_point_enabled("", "dun_entrance", 1)
		event.set_function_point_enabled("", "entrance", 1)
		event.finish_event()
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				step = 2
				mount_gundor_peak.play_guiltoni_fight_scene()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 0)
					event.set_function_point_enabled("", "dun_entrance", 1)
					event.set_function_point_enabled("", "entrance", 1)
					event.finish_event()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[503] = script.cutscene_guiltoni_fight

--- Loads the next dungeon after confirming the first exit.
function script.leave_via_first_exit()
	if confirm_leave_at_first_exit() ~= 0 then
		event.load_event_script("d05/d05.stb", 1000)
	end
end
script[550] = script.leave_via_first_exit

--- Advances the floor and loads the next dungeon after confirming the second exit.
function script.leave_via_second_exit()
	local stage_id: s32 = 0
	local current_floor: s32 = 0
	local next_floor: s32 = 0
	if confirm_leave_at_second_exit() ~= 0 then
		stage_id = event.get_dungeon_stage_id() or stage_id
		current_floor = event.get_dungeon_floor() or current_floor
		next_floor = event.get_dungeon_next_floor(current_floor, 0) or next_floor
		event.set_dungeon_floor(next_floor)
		event.set_dungeon_floor_info(stage_id, current_floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
		event.load_event_script("d05/d05.stb", 1000)
	end
end
script[551] = script.leave_via_second_exit

--- Starts the battleship battle with its music and monsters.
function script.start_battleship_battle()
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(32)
	event.play_music(0)
	event.set_character_position(0, -1755.3, 0.0, 2614.3)
	event.attach_object_handle_to_map_part_2(0, "p01_battleship")
	event.set_object_handle_visible(0, 1)
	event.load_dungeon_monster(517, 1)
	event.load_dungeon_monster(518, 0)
	event.load_dungeon_monster(519, 0)
	event.place_dungeon_monster(517, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(518, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(519, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	vm.wait(2)
	event.finish_event()
end
script[600] = script.start_battleship_battle

--- Runs the silent defeat sequence when the party is defeated here.
function script.on_defeat()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_defeat

--- Event 15120, which map data, a script or the engine runs by number.
script[15120] = mount_gundor_peak.play_firesquall_arrival_scene

--- Event 15160, which map data, a script or the engine runs by number.
script[15160] = mount_gundor_peak.play_battleship_assault_scene

--- Event 15200, which map data, a script or the engine runs by number.
script[15200] = mount_gundor_peak.play_guiltoni_fight_scene

return script
