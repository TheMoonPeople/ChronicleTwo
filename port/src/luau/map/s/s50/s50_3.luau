--!strict
-- map/s/s50/s50_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_463fb8f7 = require("@lib/event/helper_463fb8f7")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7ff88f68 = require("@lib/event/helper_7ff88f68")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(7686)
	flag = event.get_save_flag(708) or flag
	if flag == 1 then
		event.set_function_point_enabled("", "e708", 0)
		event.attach_object_handle_to_map_part_2(0, "p06s50")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_2(0, "p04s50")
		event.set_object_handle_rotation(0, 0.0, -1.22, 0.0)
		event.attach_object_handle_to_map_part_2(1, "p05s50")
		event.set_object_handle_rotation(1, 0.0, 1.22, 0.0)
	end
	event.set_dungeon_pause_flags(8192, 1)
	event.set_character_change_unmasked(2, 0)
	event.set_character_change_unmasked(3, 0)
	event.set_save_control_bits(1, 1)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 0, which map data, a script or the engine runs by number.
function script.event_0()
	local active_chr_no: s32 = 0
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.open_message_window_2(
			0,
			"-- Max' Ideensuche --\nBeim Lesen des Buchs geht Max auf,\ndass eine Erfindung bestehen k[UNI00f6]nnte aus :\n  ● einer Waffe\n  ● einer Monds[UNI00e4]ule\n  ● einem Hirschgeweih"
		)
	else
		event.open_message_window_2(
			0,
			"-- Monicas Monsterforschung --\nDiesem Text entnimmt\nMonica, dass Karos\ndurch Diamanten verletzbar sind."
		)
	end
	helper_75684dd8(0, -1, 8, 0, 0)
end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event_99()
	helper_9dafbc83(0.0, 0.0, 200.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 200.0)
	event.set_camera_position(0.0, 40.0, 320.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.initialize_event()
	event.clear_camera_sequence()
	event.shake_camera_sequence(0.0, 1.0, 0.0, 16)
	wait_camera()
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_463fb8f7(2) ~= 0 then
		event.set_character_visible(1, 1)
		event.set_character_visible(2, 1)
		event.set_dungeon_pause_flags(8192, 0)
		event.reset_action_character_motion(0)
		event.set_character_change_unmasked(2, 1)
		event.set_character_change_unmasked(3, 1)
		event.set_save_control_bits(1, 0)
		event.load_event_script("d06/d06.stb", 1000)
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local flag: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	flag = event.get_save_flag(708) or flag
	if flag == 1 then
		if helper_463fb8f7(1) ~= 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			var2 = event.get_dungeon_floor() or var2
			argc = event.get_dungeon_next_floor(var2, 0) or argc
			event.set_dungeon_floor(argc)
			event.set_dungeon_floor_info(stage_id, var2, 5, 2)
			event.set_dungeon_floor_info(stage_id, argc, 5, 1)
			event.set_character_visible(1, 1)
			event.set_character_visible(2, 1)
			event.set_dungeon_pause_flags(8192, 0)
			event.reset_action_character_motion(0)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(3, 1)
			event.set_save_control_bits(1, 0)
			event.load_event_script("d06/d06.stb", 1000)
		end
	else
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(0, "Die T[UNI00fc]r ist fest verschlossen.\nOb wohl etwas Geheimes in\ndiesem Raum ist?")
		helper_75684dd8(0, -1, 5, 0, 0)
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local item: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 22, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 23, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		var1 = event.get_triggered_event_data_2(6) or var1
		if var1 == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "Da steht eine komische Vase.\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)")
			at = 3
			var3 = helper_c292fa16(0, -1, 5, 256, 208, var3)
			if var3 == 1 then
				var1 = 2
			end
		end
		if var1 == 2 then
			event.open_use_item_menu(374)
			at = 4
			vm.wait(4)
			item = vmhost.used_item() or item
			if item > 0 then
				if item == 374 then
					event.show_dungeon_status_bar(0, 1.0)
					event.attach_object_handle_to_map_part_2(0, "p06s50")
					event.set_object_handle_visible(0, 1)
					event.set_function_point_enabled("", "e708", 0)
					event.set_function_point_enabled("", "next_floor", 1)
					event.fade_out_screen(3, 255, 255, 255)
					at = 5
					wait_frames(3)
					event.fade_in_screen(8)
					at = 6
					wait_frames(10)
					event.fade_out_screen(3, 255, 255, 255)
					at = 7
					wait_frames(3)
					event.fade_in_screen(8)
					at = 8
					wait_frames(20)
					event.fade_out_screen(30, 255, 255, 255)
					at = 9
					wait_frames(30)
					at = 10
					helper_7ff88f68()
					helper_9dafbc83(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
					event.set_camera_look_at(30.0, 27.2, -80.0)
					event.set_camera_position(30.0, 37.2, 40.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				else
					at = 11
					helper_5fb66cb1()
				end
			end
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 23, 5, 256, 208)
			end
			return 0
		end
		if at <= 10 then
			if at == 3 then
				var3 = received[2] :: number
			end
			if at <= 3 then
				local _ = var1 == 1
				var1 = 2
			end
			if at <= 4 then
				wait_frames_skipping(3)
			end
			if at <= 5 then
				wait_frames_skipping(10)
			end
			if at <= 6 then
				wait_frames_skipping(3)
			end
			if at <= 7 then
				wait_frames_skipping(20)
			end
			if at <= 8 then
				wait_frames_skipping(30)
			end
			if at <= 9 then
				at = 10
				helper_7ff88f68()
				return vm.continue_with(function()
					helper_9dafbc83(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
					event.set_camera_look_at(30.0, 27.2, -80.0)
					event.set_camera_position(30.0, 37.2, 40.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				end)
			end
			helper_43f02c95(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
			return 0
		end
		if at <= 11 then
			return 0
		end
		return nil
	end)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- Event 17080, which map data, a script or the engine runs by number.
function script.event_17080()
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	helper_7ff88f68()
end

return script
