--!strict
-- map/s/s20/s20_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_402d163f = require("@lib/event/helper_402d163f")
local helper_43d1778f = require("@lib/event/helper_43d1778f")
local helper_55215ed6 = require("@lib/event/helper_55215ed6")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d86a01e1 = require("@lib/event/helper_d86a01e1")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(5684)
	event.set_function_point_enabled("", "useitem_00", 0)
	event.set_function_point_enabled("", "dun_entrance", 1)
	event.set_function_point_enabled("", "entrance", 1)
	flag = event.get_save_flag(516) or flag
	event.get_item_count(372)
	if flag == 0 then
		event.set_function_point_enabled("", "useitem_00", 1)
	end
	if flag == 1 then
		event.attach_object_handle_to_map_part_2(0, "p03_s2001")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(0, "p04_s2001")
		event.set_object_handle_visible(0, 1)
	end
	event.attach_object_handle_to_map_part_2(0, "p01_battleship")
	event.set_object_handle_visible(0, 0)
	flag_2 = event.get_save_flag(520) or flag_2
	if flag_2 ~= 0 then
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

--- Helper function.
local function helper_11618()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: any = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local active_chr_no_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 20, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			at = 3
			wait_frames(10)
			event.set_character_position(0, -2074.0, -7.0, 3098.8)
			event.set_character_rotation(0, 0.0, 3.05, 0.0)
			event.set_camera_position(-2086.23, 51.55, 3226.23)
			event.set_camera_look_at(-2074.0, 22.99, 3098.82)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		flag = event.get_save_flag(516) or flag
		flag_2 = event.get_save_flag(520) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var3 = 1
		else
			at = 4
			var3 = helper_ed4dc120(2, -1)
		end
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var3 == 0 then
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
			at = 5
			wait_frames(40)
			event.fade_out_screen(20)
			at = 6
			wait_frames(20)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			var7 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 40.0) + var4)
			var8 = 0.0
			var9 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 40.0) + var6)
			event.move_object_sequence(0, var7, var8, var9, 30, 1)
			event.turn_object_sequence_toward(0, var7, var8, var9, 10)
			event.set_object_sequence_motion(0, "歩き")
			var10 = 0
			while var10 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var4 = out1 or var4
					var5 = out2 or var5
					var6 = out3 or var6
				end
				var5 = vm.f32(var5 + 30.0)
				event.set_camera_look_at(var4, var5, var6)
				var10 = var10 + 1
				at = 7
				vm.wait(7)
			end
			event.set_object_sequence_motion(0, "立ち")
		end
		if flag ~= 0 and flag_2 == 0 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			active_chr_no_2 = event.get_playable_character() or active_chr_no_2
			if active_chr_no_2 == 0 then
				event.open_message_window_2(0, "Es ist Zeit, sich im\nRidepod zu wehren!")
			else
				event.open_message_window_2(0, "Es ist Zeit, sich im\nRidepod zu wehren, Max!")
			end
			at = 8
			helper_75684dd8(0, -1, 5, 256, 208)
		end
		event.set_object_handle_footstep_sound(0, 0)
		event.reset_follow_camera(0)
		event.finish_event()
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				wait_frames_skipping(10)
			end
			return 0
		end
		if at <= 6 then
			if at == 4 then
				var3 = received[1] :: number
			end
			if at <= 4 then
				wait_frames_skipping(40)
			end
			if at <= 5 then
				wait_frames_skipping(20)
			end
			return 1
		end
		if at <= 8 then
			if at <= 7 then
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_1292c()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: any = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local flag_3: s32 = 0
	local active_chr_no_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 20, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			at = 3
			wait_frames(10)
			event.set_character_position(0, 1459.7, -279.01, 2009.85)
			event.set_character_rotation(0, 0.0, -1.77, 0.0)
			event.set_camera_position(1584.28, -250.6, 2035.61)
			event.set_camera_look_at(1459.7, -249.01, 2009.85)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		flag = event.get_save_flag(516) or flag
		flag_2 = event.get_save_flag(520) or flag_2
		if flag == 0 or flag_2 == 0 then
			var3 = 1
		else
			at = 4
			var3 = helper_ed4dc120(1, -1)
		end
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var3 == 0 then
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
			at = 5
			wait_frames(40)
			event.fade_out_screen(20)
			at = 6
			wait_frames(20)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			var7 = vm.f32(vm.f32(vm.sin(-2.0) * 50.0) + var4)
			var8 = 0.0
			var9 = vm.f32(vm.f32(vm.cos(-2.0) * 50.0) + var6)
			event.move_object_sequence(0, var7, var8, var9, 30, 1)
			event.turn_object_sequence_toward(0, var7, var8, var9, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 30)
			event.set_object_sequence_motion(0, "立ち")
			var10 = 0
			while var10 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var4 = out1 or var4
					var5 = out2 or var5
					var6 = out3 or var6
				end
				var5 = vm.f32(var5 + 30.0)
				event.set_camera_look_at(var4, var5, var6)
				var10 = var10 + 1
				at = 7
				vm.wait(7)
			end
		end
		if flag == 0 or flag_2 == 0 then
			flag_3 = event.get_save_flag(508) or flag_3
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			active_chr_no_2 = event.get_playable_character() or active_chr_no_2
			if active_chr_no_2 == 0 then
				if flag == 0 then
					if flag_3 == 0 then
						event.open_message_window_2(
							0,
							"Diese Maschine scheint den\nFeuerregen zu erzeugen.<page>Du musst etwas dagegen\ntun! Aber was blo[UNI00df]?"
						)
					else
						event.open_message_window_2(0, "Wir m[UNI00fc]ssen die Feuer-B[UNI00f6]e\nzerst[UNI00f6]ren!")
					end
				else
					event.open_message_window_2(0, "Es ist Zeit, sich im\nRidepod zu wehren!")
				end
			elseif flag == 0 then
				if flag_3 == 0 then
					event.open_message_window_2(
						0,
						"Diese Maschine scheint den\nFeuerregen zu erzeugen.<page>Du musst etwas dagegen\ntun! Aber was blo[UNI00df]?"
					)
				else
					event.open_message_window_2(0, "Die Feuer-B[UNI00f6]e ist nicht hier.")
				end
			else
				event.open_message_window_2(0, "Es ist Zeit, sich im\nRidepod zu wehren, Max!")
			end
			at = 8
			helper_75684dd8(0, -1, 5, 256, 208)
		end
		event.set_object_handle_footstep_sound(0, 0)
		event.reset_follow_camera(0)
		event.finish_event()
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				wait_frames_skipping(10)
			end
			return 0
		end
		if at <= 6 then
			if at == 4 then
				var3 = received[1] :: number
			end
			if at <= 4 then
				wait_frames_skipping(40)
			end
			if at <= 5 then
				wait_frames_skipping(20)
			end
			return 1
		end
		if at <= 8 then
			if at <= 7 then
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event_99()
	flag = event.get_save_flag(508) or flag
	flag_2 = event.get_save_flag(512) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_d86a01e1()
	else
		helper_402d163f()
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	vm.wait(1)
	helper_c956b4a2(64)
	event.finish_event()
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local item: s32 = 0
	local argc: s32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.apply_message_window_preset(0, 4)
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 22, 8, 0, 0)
			else
				at = 2
				helper_75684dd8(0, 23, 8, 0, 0)
			end
			event.finish_event()
			return
		end
		var1 = event.get_triggered_event_data_2(6) or var1
		if var1 == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			argc = event.get_item_count(372) or argc
			if argc <= 0 then
				event.open_message_window_2(0, "Wir brauchen etwas, das\ndas zerst[UNI00f6]ren kann.\n(Ggst. benutzen mit (#).)")
			else
				event.open_message_window_2(0, "Die Feuer-B[UNI00f6]e.\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)")
			end
			at = 3
			var4 = helper_c292fa16(0, -1, 5, 256, 208, var4)
			if var4 == 1 then
				var1 = 2
			end
		end
		if var1 == 2 then
			event.open_use_item_menu(372)
			at = 4
			vm.wait(4)
			item = vmhost.used_item() or item
			if item > 0 then
				if item == 372 then
					event.fade_out_screen(15)
					at = 5
					wait_frames(15)
					event.switch_dungeon_main_character(0)
					at = 6
					helper_55215ed6()
					event.set_save_control_bits(1, 1)
					event.set_function_point_enabled("", "dun_entrance", 0)
					event.set_function_point_enabled("", "entrance", 0)
					event.set_character_change_enabled(3, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_character_change_enabled(1, 0)
					event.set_character_change_unmasked(1, 0)
					event.initialize_event()
					at = 7
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
					at = 8
					helper_5fb66cb1()
				end
			end
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 23, 8, 0, 0)
			end
			return 0
		end
		if at <= 7 then
			if at == 3 then
				var4 = received[2] :: number
			end
			if at <= 3 then
				local _ = var1 == 1
				var1 = 2
			end
			if at <= 4 then
				wait_frames_skipping(15)
			end
			if at <= 5 then
				at = 6
				helper_55215ed6()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 1)
					event.set_function_point_enabled("", "dun_entrance", 0)
					event.set_function_point_enabled("", "entrance", 0)
					event.set_character_change_enabled(3, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_character_change_enabled(1, 0)
					event.set_character_change_unmasked(1, 0)
					event.initialize_event()
					at = 7
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
		if at <= 8 then
			return 0
		end
		return nil
	end)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		wait_frames(20)
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
		at = 2
		helper_43d1778f()
		event.set_save_control_bits(1, 0)
		event.set_function_point_enabled("", "dun_entrance", 1)
		event.set_function_point_enabled("", "entrance", 1)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_43d1778f()
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

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	if helper_11618() ~= 0 then
		event.load_event_script("d05/d05.stb", 1000)
	end
end

--- Event 551, which map data, a script or the engine runs by number.
function script.event_551()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	if helper_1292c() ~= 0 then
		stage_id = event.get_dungeon_stage_id() or stage_id
		var1 = event.get_dungeon_floor() or var1
		argc = event.get_dungeon_next_floor(var1, 0) or argc
		event.set_dungeon_floor(argc)
		event.set_dungeon_floor_info(stage_id, var1, 5, 2)
		event.set_dungeon_floor_info(stage_id, argc, 5, 1)
		event.load_event_script("d05/d05.stb", 1000)
	end
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.stop_music(0)
	wait_frames(4)
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

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- Event 15120, which map data, a script or the engine runs by number.
script.event_15120 = helper_d86a01e1

--- Event 15160, which map data, a script or the engine runs by number.
script.event_15160 = helper_55215ed6

--- Event 15200, which map data, a script or the engine runs by number.
script.event_15200 = helper_43d1778f

return script
