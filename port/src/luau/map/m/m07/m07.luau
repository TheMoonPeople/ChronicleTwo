--!strict
-- map/m/m07/m07.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_61e5dba6 = require("@lib/event/helper_61e5dba6")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_b578(arg0: s32, arg1: s32)
	event.open_voice_stream_wave(1, arg0)
	helper_9cbdc640(1)
	event.open_message_window_2(0, arg0)
	open_message(0, -1, 5, 0, 0)
	event.play_voice_stream(1)
	helper_61e5dba6(0, arg1)
	close_message(0)
end

--- Helper function.
local function helper_b730()
	local var0: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_time_of_day_advancing(0)
		event.set_time_of_day(24)
		event.set_message_window_mode(0, 0)
		event.load_map_sounds(1200)
		event.load_music(100)
		event.stop_music(0)
		event.stop_environment_music()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/opening/p1/")
		event.load_message_file(0, 5, "op1ch1.txt")
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.change_directory("")
		event.set_object_handle_position(0, -548.51, 0.0, 56.09)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 22)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "真剣目")
		event.set_object_handle_texture_animation(0, 1, "口半開き")
		event.set_object_handle_footstep_sound(1, -1)
		event.set_object_handle_footstep_sound(2, -1)
		event.set_object_handle_footstep_sound(3, -1)
		event.set_object_handle_footstep_sound(4, -1)
		event.set_object_handle_footstep_sound(5, -1)
		event.set_rain_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 10000.0, 0.0)
		event.set_camera_sequence_look_at(0.0, 10000.0, 0.0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_size(0, 512, 416)
		event.set_event_sprite_color(0, 0, 0, 0, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.fade_in_screen(1)
		event.set_sound_reverb_enabled(0)
		helper_b578(10010, 160)
		helper_b578(10020, 110)
		helper_b578(10025, 120)
		helper_b578(10030, 210)
		event.set_sound_reverb_enabled(1)
		event.set_event_sprite_draw_pass(0, 0)
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(1)
		wait_camera()
		event.open_voice_stream_wave(1, 10040)
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.set_rain_splash_character(0)
		event.set_rain_enabled(1)
		event.play_music(0)
		event.play_environment_music(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(152.13, 71.52, -25.06)
		event.set_camera_sequence_look_at(-217.76, 200.86, -36.82)
		event.move_camera_sequence(152.13, 71.52, -25.06, -217.76, 28.14, -36.82, 350)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(300)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_position_track(0, 60)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 260)
		event.add_object_sequence_path_point(0, -548.51, 0.0, 56.09)
		event.add_object_sequence_path_point(0, -353.41, 0.0, 2.28)
		event.add_object_sequence_path_point(0, -186.76, 0.0, -36.95)
		event.add_object_sequence_path_point(0, -68.92, 0.0, -47.91)
		event.add_object_sequence_path_point(0, 64.69, 0.0, -50.33)
		event.add_object_sequence_path_point(0, 99.26, 0.0, -48.9)
		event.start_object_sequence_path(0)
		wait_camera()
		wait_objects(0)
		event.start_crossfade(60)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 120)
		event.add_object_sequence_path_point(0, 64.69, 0.0, -50.33)
		event.add_object_sequence_path_point(0, 195.57, 0.0, -50.59)
		event.add_object_sequence_path_point(0, 314.04, 0.0, -37.39)
		event.start_object_sequence_path(0)
		event.set_camera_sequence_follow_object(0, 5.0, 20.0, 0.0, 1.88, -15.0, 45.0)
		wait_objects(0)
		event.release_camera_sequence_follow_object()
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 200)
		event.add_object_sequence_path_point(0, 314.04, 0.0, -37.39)
		event.add_object_sequence_path_point(0, 467.75, 0.0, -7.6)
		event.add_object_sequence_path_point(0, 521.55, 0.0, 26.4)
		event.add_object_sequence_path_point(0, 544.99, 0.0, 49.43)
		event.add_object_sequence_path_point(0, 549.06, 3.84, 89.43)
		event.add_object_sequence_path_point(0, 543.57, 4.07, 127.02)
		event.add_object_sequence_path_point(0, 527.1, 4.07, 147.59)
		event.add_object_sequence_path_point(0, 505.16, 19.83, 153.79)
		event.add_object_sequence_path_point(0, 463.28, 49.29, 156.8)
		event.add_object_sequence_path_point(0, 357.41, 52.0, 153.32)
		event.start_object_sequence_path(0, 1)
		event.set_camera_sequence_position(716.83, 119.9, -60.37)
		event.set_camera_sequence_look_at(504.52, 49.88, 41.63)
		event.set_rain_splash_character(0)
		helper_888ab2a3(60)
		event.move_camera_sequence_eased(716.83, 119.9, -60.37, 476.49, 49.88, 99.17, 200, 1, 1.0)
		helper_888ab2a3(70)
		event.set_object_handle_footstep_sound(0, 2)
		helper_888ab2a3(60)
		event.set_rain_splash_character(-1)
		wait_objects(0)
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 30)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "ドア開け", 2)
		helper_888ab2a3(60)
		var0 = event.get_sound_id(2) or var0
		event.play_sound_effect(var0, 66)
		event.fade_out_music(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		wait_camera()
	end)
	vm.entry(17)
	event.cancel_drama_scene_skip()
	event.set_sound_reverb_enabled(1)
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
	event.delete_character_extension_packs(0)
	event.set_character_active(1, 0)
	event.set_rain_enabled(0)
	event.stop_environment_music()
	event.stop_music(0)
	helper_888ab2a3(4)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
end

--- Event 151, which map data, a script or the engine runs by number.
local function event_151()
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.entry(1)
		event.fade_out_screen(0)
		at = 2
		vm.wait(2)
		event.set_save_flag(4, 1)
		at = 3
		helper_b730()
		event.jump_to_map_3(-1, "s42", 500)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 2 then
				at = 3
				helper_b730()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s42", 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

script.event_151 = event_151

--- Event 10010, which map data, a script or the engine runs by number.
function script.event_10010()
	local at: number = 0
	return vm.guard(function()
		event.stop_music(0)
		event.stop_environment_music()
		at = 1
		helper_888ab2a3(6)
		at = 2
		event_151()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				event_151()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
