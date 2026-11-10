--!strict
-- map/d/d05/b01/d05b01_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ebc8957 = require("@lib/event/helper_0ebc8957")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_47084b1b = require("@lib/event/helper_47084b1b")
local helper_4aae2296 = require("@lib/event/helper_4aae2296")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_724a67a8 = require("@lib/event/helper_724a67a8")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_80ad60c2 = require("@lib/event/helper_80ad60c2")
local helper_828a2144 = require("@lib/event/helper_828a2144")
local helper_92ffd5d7 = require("@lib/event/helper_92ffd5d7")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_eaa348bc = require("@lib/event/helper_eaa348bc")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_f0ee9a01 = require("@lib/event/helper_f0ee9a01")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local wait_frames = require("@lib/event/wait_frames")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(5683)
	flag = event.get_save_flag(526) or flag
	if flag == 1 then
		event.set_function_point_enabled("d05", "func", 0)
		event.attach_object_handle_to_map_part_3(0, "d05", "d05ba02-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takil")
		event.set_object_handle_scale(0, 0.43, 1.0, 1.0)
		event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takir")
		event.set_object_handle_scale(0, 0.43, 1.0, 1.0)
		event.set_function_point_enabled("p01", "invent_2023-1", 1)
	end
	flag_2 = event.get_save_flag(528) or flag_2
	if flag_2 == 0 then
		event.attach_object_handle_to_map_part_3(0, "d05", "d05ba03-a")
		event.set_object_handle_visible(0, 1)
	else
		event.set_function_point_enabled("", "e528", 0)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	event.fade_out_screen(0)
	event_99()
	event.take_memory_card_load_state()
	vm.wait(1)
	helper_9dafbc83(0.0, -30.0, 1600.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 0.0, 1600.0)
	event.set_camera_position(0.0, 10.0, 1700.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(15)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_92ffd5d7

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local active_chr_no: s32 = 0
	local var1: any = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 20, 5, 256, 208)
		else
			helper_75684dd8(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	var1 = helper_ed4dc120(2, -1)
	if var1 == 0 then
		event.fade_out_screen(15)
		wait_frames(15)
		event.load_event_script("d05/d05.stb", 1000)
	end
	event.finish_event()
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	helper_f57795f8()
	event.finish_event()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 8, 0, 0)
		else
			helper_75684dd8(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end
	var1 = event.get_triggered_event_data_2(6) or var1
	if var1 == 1 then
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		var2 = helper_c292fa16(0, 2507, 5, 256, 208, var2)
		event.set_message_window_mode(0, 7)
		event.set_message_draw_speed(0, 0)
		if var2 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait_frames(6)
		event.open_use_item_menu(354)
		vm.wait(5)
		item = vmhost.used_item() or item
		if item == 354 then
			event.set_function_point_enabled("d05", "func", 0)
			event.attach_object_handle_to_map_part_3(0, "d05", "d05ba02-a")
			event.set_object_handle_visible(0, 0)
			event.set_function_point_enabled("p01", "invent_2023-1", 1)
			helper_eaa348bc()
			return
		elseif item <= 0 then
			event.finish_event()
		else
			helper_5fb66cb1()
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		wait_frames(6)
	end
	event.finish_event()
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.set_save_control_bits(1, 1)
		event.fade_out_screen(15)
		at = 1
		wait_frames(15)
		event.set_function_point_enabled("", "e528", 0)
		at = 2
		helper_4aae2296()
		at = 3
		vm.wait(3)
		event.load_dungeon_monster(512, 1)
		event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		helper_9dafbc83(0.0, 0.0, 300.0, vm.f32(3.14))
		event.set_camera_look_at(0.0, 30.0, 300.0)
		event.set_camera_position(0.0, 40.0, 400.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_4aae2296()
				return vm.continue_with(function()
					at = 3
					vm.wait(3)
					event.load_dungeon_monster(512, 1)
					event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					helper_9dafbc83(0.0, 0.0, 300.0, vm.f32(3.14))
					event.set_camera_look_at(0.0, 30.0, 300.0)
					event.set_camera_position(0.0, 40.0, 400.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(15)
					event.finish_event()
					return
				end)
			end
			helper_43f02c95(0.0, 0.0, 300.0, vm.f32(3.14))
			return 0
		end
		return nil
	end)
end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(15)
		at = 1
		wait_frames(15)
		event.clear_event_battle_monsters(-1)
		event.set_party_member(1, 1)
		event.set_character_change_enabled(1, 1)
		event.set_character_change_unmasked(1, 1)
		event.set_party_member(3, 1)
		event.set_character_change_enabled(3, 1)
		event.set_character_change_unmasked(3, 1)
		at = 2
		helper_828a2144()
		event.skip_next_music_load()
		event.load_dungeon_map("s49")
		event.load_event_script("s49/s49.stb", 500)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_828a2144()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.load_dungeon_map("s49")
					event.load_event_script("s49/s49.stb", 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 561, which map data, a script or the engine runs by number.
function script.event_561()
	event.clear_event_running_flag()
	helper_0ebc8957()
	event.set_function_point_enabled("", "e528", 0)
	event.set_function_point_enabled("d05", "func", 0)
	event.set_function_point_enabled("p01", "invent_2023-1", 1)
	event.attach_object_handle_to_map_part_3(0, "d05", "d05ba03-a")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takil")
	event.set_object_handle_translation(0, -330.0, 0.0, 200.0)
	event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takir")
	event.set_object_handle_translation(0, 330.0, 0.0, 200.0)
	event.load_dungeon_monster(511, 1)
	event.place_dungeon_monster(511, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	event.set_character_position(0, 0.0, 0.0, 300.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.set_camera_position(0.0, 40.0, 420.0)
	event.set_camera_look_at(0.0, 30.0, 300.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(15)
	event.finish_event()
end

--- Event 570, which map data, a script or the engine runs by number.
function script.event_570()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(0)
		event.fade_out_screen(15)
		at = 1
		wait_frames(15)
		event.stop_music(0)
		event.clear_event_battle_monsters(-1)
		at = 2
		helper_724a67a8()
		event.set_dungeon_floor_info(4, 22, 5, 2)
		event.skip_next_music_load()
		event.load_dungeon_map("s49")
		event.load_event_script("s49/s49.stb", 510)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_724a67a8()
				return vm.continue_with(function()
					event.set_dungeon_floor_info(4, 22, 5, 2)
					event.skip_next_music_load()
					event.load_dungeon_map("s49")
					event.load_event_script("s49/s49.stb", 510)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 571, which map data, a script or the engine runs by number.
function script.event_571()
	event.set_save_control_bits(1, 0)
	event.clear_event_running_flag()
	helper_92ffd5d7()
	event.go_to_georama_edit(3, 500)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(35)
	event.play_music(0)
	event.set_function_point_enabled("d05", "func", 0)
	event.set_function_point_enabled("", "e528", 0)
	event.load_dungeon_monster(511, 1)
	event.place_dungeon_monster(511, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(532) or flag
		flag_2 = event.get_save_flag(536) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var1 = 0
			var1 = vm.float_bits(event.get_random_number(100)) or var1
			if var1 < 50 then
				at = 1
				helper_47084b1b(0, 8540060)
			else
				at = 2
				helper_47084b1b(0, 8540070)
			end
			return
		end
		flag_3 = event.get_save_flag(528) or flag_3
		if flag_3 ~= 0 and flag == 0 then
			var1 = 0
			var1 = vm.float_bits(event.get_random_number(100)) or var1
			if var1 < 50 then
				at = 3
				helper_47084b1b(0, 8530100)
			else
				at = 4
				helper_47084b1b(0, 8530110)
			end
			return
		end
		at = 5
		helper_f0ee9a01(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_80ad60c2(0, 8540070)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_80ad60c2(0, 8530110)
			end
			return 0
		end
		if at <= 5 then
			return 0
		end
		return nil
	end)
end

--- Event 15260, which map data, a script or the engine runs by number.
function script.event_15260()
	event.stop_music(0)
	helper_eaa348bc()
end

--- Event 15280, which map data, a script or the engine runs by number.
script.event_15280 = helper_4aae2296

--- Event 15320, which map data, a script or the engine runs by number.
function script.event_15320()
	helper_828a2144()
	event.skip_next_music_load()
	event.load_dungeon_map("s49")
	event.load_event_script("s49/s49.stb", 500)
end

--- Event 15360, which map data, a script or the engine runs by number.
function script.event_15360()
	helper_724a67a8()
	event.skip_next_music_load()
	event.load_dungeon_map("s49")
	event.load_event_script("s49/s49.stb", 510)
end

--- Event 25020, which map data, a script or the engine runs by number.
function script.event_25020()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(190)
	event.play_music(0)
	event.set_function_point_enabled("", "e528", 0)
	event.load_dungeon_monster(512, 1)
	event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end

return script
