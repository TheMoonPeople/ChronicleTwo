--!strict
--- Griffon's chamber door map with its spoken password prompt and the exits to the dungeon.

local vm = require("@lib/vm")
local dungeon = require("@lib/event/dungeon")
local griffons_chamber_door = require("@lib/event/griffons_chamber_door")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Loads the map sounds and enables the door points by progress.
local function initialize_map()
	local progress_value: s32 = 0
	local door_open_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(7685)
	progress_value = event.get_save_data_value(0) or progress_value
	if progress_value < 10 then
		door_open_flag = event.get_save_flag(58) or door_open_flag
		if door_open_flag == 1 then
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

--- Asks for the door's password and opens it when correct, returning whether it opened.
local function ask_door_password()
	local sound_effect_handle: s32 = 0
	local is_unlocked: s32 = 0
	local menu_result: s32 = 0
	local camera_angle: f32 = 0
	local i: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.set_save_flag(712, 1)
		event.set_character_motion(0, "立ち")
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.start_background_file_loads_2("event/e700/e712/e712_1.txt", "snd2/event/ev_130_125.sound.json")
		step = 1
		vm.wait(1)
		step = 2
		wait.background_load()
		event.load_message_file(0, 5, "event/e700/e712/e712_1.txt")
		sound_effect_handle = event.load_sound_effect_file_3(4, "snd2/event/ev_130_125.sound.json") or sound_effect_handle
		is_unlocked = 0
		step = 3
		message.show_voiced(7120020)
		event.fade_out_screen(10)
		step = 4
		wait.frames(10)
		event.set_menu_value(0, "Antes tienes que pronunciar su verdadero nombre.", "SIRUS", 0)
		event.open_event_menu(5)
		step = 5
		vm.wait(5)
		event.fade_in_screen(10)
		step = 6
		wait.frames(10)
		menu_result = event.get_menu_results_1() or menu_result
		if menu_result == 1 then
			event.set_save_flag(58, 1)
			step = 7
			message.show_voiced(7120040)
			event.set_function_point_enabled("way200", "door01", 1)
			event.set_function_point_enabled("way200", "door02", 1)
			event.play_sound_effect(sound_effect_handle, 0)
			camera_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or camera_angle
			camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
			camera_angle = event.wrap_angle(camera_angle) or camera_angle
			i = 0
			while i < 30 do
				event.swing_camera_control_to_angle(camera_angle)
				event.move_camera_control_with_pad(0)
				event.step_camera_control()
				i = i + 1
				step = 8
				vm.wait(8)
			end
			event.reset_follow_camera(0)
			step = 9
			wait.frames(60)
			is_unlocked = 1
		else
			step = 10
			message.show_voiced(7120030)
			is_unlocked = 0
			event.fade_out_screen(30, 255, 255, 255)
			step = 11
			wait.frames(30)
		end
		event.load_message_file(0, -1)
		event.finish_event()
		return is_unlocked
	end, function(received: { any })
		if step <= 11 then
			if step <= 1 then
				wait.background_load_skipping()
			end
			if step <= 2 then
				is_unlocked = 0
				message.show_voiced_skipping(7120020)
			end
			if step <= 3 then
				wait.frames_skipping(10)
			end
			if step <= 5 then
				wait.frames_skipping(10)
			end
			if step <= 6 then
				message.show_voiced_skipping(7120040)
			end
			if step <= 7 then
				camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
				i = 0
				local _ = i < 30
				i = i + 1
			end
			if step <= 8 then
				wait.frames_skipping(60)
			end
			if step <= 9 then
				is_unlocked = 1
				message.show_voiced_skipping(7120030)
			end
			if step <= 10 then
				is_unlocked = 0
				wait.frames_skipping(30)
			end
			return is_unlocked
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script loads.
function script.setup() end

script.initialize_map = initialize_map
script[99] = script.initialize_map

--- Starts the map in front of the door.
function script.default_event()
	initialize_map()
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
--- Does nothing so the engine skips its default.
function script.key_open() end

--- Leaves for the dungeon after confirming.
function script.leave_to_dungeon()
	if menu.confirm_leave_unless_blocked() ~= 0 then
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
script[200] = script.leave_to_dungeon

--- Handles the door by progress, asking for the password or entering the chamber.
function script.examine_door()
	local door_open_flag: s32 = 0
	local name_known_flag: s32 = 0
	door_open_flag = event.get_save_flag(58) or door_open_flag
	if door_open_flag == 0 then
		name_known_flag = event.get_save_flag(748) or name_known_flag
		if name_known_flag == 0 then
			griffons_chamber_door.show_door_message()
		elseif ask_door_password() == 0 then
			event.go_to_georama_edit(109, 100)
			return
		end
	elseif griffons_chamber_door.prompt_to_enter() ~= 0 then
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
script[500] = script.examine_door

--- Runs the silent defeat sequence when the party is defeated here.
function script.on_defeat()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_defeat

return script
