--!strict
-- map/s/s23/s23_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27407073 = require("@lib/event/helper_27407073")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_cd710052 = require("@lib/event/helper_cd710052")
local helper_eb498127 = require("@lib/event/helper_eb498127")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local var0: s32 = 0
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(7685)
	var0 = event.get_save_data_value(0) or var0
	if var0 < 10 then
		flag = event.get_save_flag(58) or flag
		if flag == 1 then
			event.set_function_point_enabled("way200", "door01", 1)
			event.set_function_point_enabled("way200", "door02", 1)
		end
	else
		event.set_function_point_enabled("", "e712", 0)
	end
	event.set_dungeon_pause_flags(8192, 1)
	event.set_character_change_unmasked(2, 0)
	event.set_character_change_unmasked(3, 0)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.set_save_control_bits(1, 1)
end

--- Helper function.
local function helper_1147c()
	local var0: s32 = 0
	local var1: s32 = 0
	local result_x: s32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_save_flag(712, 1)
		event.set_character_motion(0, "立ち")
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.start_background_file_loads_2("event/e700/e712/e712_1.txt", "snd2/event/ev_130_125.sound.json")
		at = 1
		vm.wait(1)
		at = 2
		helper_479dc9e9()
		event.load_message_file(0, 5, "event/e700/e712/e712_1.txt")
		var0 = event.load_sound_effect_file_3(4, "snd2/event/ev_130_125.sound.json") or var0
		var1 = 0
		at = 3
		helper_4116e6bb(7120020)
		event.fade_out_screen(10)
		at = 4
		wait_frames(10)
		event.set_menu_value(0, "you must first speak his true name.", "SIRUS", 0)
		event.open_event_menu(5)
		at = 5
		vm.wait(5)
		event.fade_in_screen(10)
		at = 6
		wait_frames(10)
		result_x = event.get_menu_results_1() or result_x
		if result_x == 1 then
			event.set_save_flag(58, 1)
			at = 7
			helper_4116e6bb(7120040)
			event.set_function_point_enabled("way200", "door01", 1)
			event.set_function_point_enabled("way200", "door02", 1)
			event.play_sound_effect(var0, 0)
			var3 = vm.bits_float(event.get_triggered_event_data_2(11)) or var3
			var3 = vm.f32(var3 - vm.f32(3.1415927))
			var3 = event.wrap_angle(var3) or var3
			var4 = 0
			while var4 < 30 do
				event.swing_camera_control_to_angle(var3)
				event.move_camera_control_with_pad(0)
				event.step_camera_control()
				var4 = var4 + 1
				at = 8
				vm.wait(8)
			end
			event.reset_follow_camera(0)
			at = 9
			wait_frames(60)
			var1 = 1
		else
			at = 10
			helper_4116e6bb(7120030)
			var1 = 0
			event.fade_out_screen(30, 255, 255, 255)
			at = 11
			wait_frames(30)
		end
		event.load_message_file(0, -1)
		event.finish_event()
		return var1
	end, function(received: { any })
		if at <= 11 then
			if at <= 1 then
				helper_344d6cd8()
			end
			if at <= 2 then
				var1 = 0
				helper_8cd371d7(7120020)
			end
			if at <= 3 then
				wait_frames_skipping(10)
			end
			if at <= 5 then
				wait_frames_skipping(10)
			end
			if at <= 6 then
				helper_8cd371d7(7120040)
			end
			if at <= 7 then
				var3 = vm.f32(var3 - vm.f32(3.1415927))
				var4 = 0
				local _ = var4 < 30
				var4 = var4 + 1
			end
			if at <= 8 then
				wait_frames_skipping(60)
			end
			if at <= 9 then
				var1 = 1
				helper_8cd371d7(7120030)
			end
			if at <= 10 then
				var1 = 0
				wait_frames_skipping(30)
			end
			return var1
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
	event_99()
	event.set_character_position(0, 0.0, 0.0, 170.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_look_at(0.0, 30.0, 170.0)
	event.set_camera_position(0.0, 40.0, 270.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	vm.wait(1)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_cd710052() ~= 0 then
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

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(58) or flag
	if flag == 0 then
		flag_2 = event.get_save_flag(748) or flag_2
		if flag_2 == 0 then
			helper_27407073()
		elseif helper_1147c() == 0 then
			event.go_to_georama_edit(109, 100)
			return
		end
	elseif helper_eb498127() ~= 0 then
		event.set_character_visible(1, 1)
		event.set_character_visible(2, 1)
		event.set_dungeon_pause_flags(8192, 0)
		event.reset_action_character_motion(0)
		event.set_character_change_unmasked(2, 1)
		event.set_character_change_unmasked(3, 1)
		event.set_save_control_bits(1, 0)
		event.load_dungeon_map("d06b01")
		event.load_event_script("d06b01/d06b01.stb", 100)
	end
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

return script
