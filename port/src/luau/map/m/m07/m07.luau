--!strict
--- Event script for map m07, which plays the rain run scene and jumps to map s42.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

--- Plays a voice line with its message window and closes the window when the line ends or the frame limit passes.
local function play_voiced_message(voice_id: s32, max_frames: s32)
	event.open_voice_stream_wave(1, voice_id)
	sound.wait_voice_stream_ready(1)
	event.open_message_window_2(0, voice_id)
	message.open(0, -1, 5, 0, 0)
	event.play_voice_stream(1)
	message.wait_voice_stopping_for(0, max_frames)
	message.close(0)
end

--- Plays the opening chapter 1 scene of the hero running through the rain to a door after the narrated lines.
local function play_rain_run_scene()
	local sound_id: s32 = 0
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
		play_voiced_message(10010, 160)
		play_voiced_message(10020, 110)
		play_voiced_message(10025, 120)
		play_voiced_message(10030, 210)
		event.set_sound_reverb_enabled(1)
		event.set_event_sprite_draw_pass(0, 0)
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(1)
		camera.wait_until_done()
		event.open_voice_stream_wave(1, 10040)
		sound.wait_voice_stream_ready(1)
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
		camera.wait_until_done()
		object.wait_until_done(0)
		event.start_crossfade(60)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 120)
		event.add_object_sequence_path_point(0, 64.69, 0.0, -50.33)
		event.add_object_sequence_path_point(0, 195.57, 0.0, -50.59)
		event.add_object_sequence_path_point(0, 314.04, 0.0, -37.39)
		event.start_object_sequence_path(0)
		event.set_camera_sequence_follow_object(0, 5.0, 20.0, 0.0, 1.88, -15.0, 45.0)
		object.wait_until_done(0)
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
		wait.for_frame_count(60)
		event.move_camera_sequence_eased(716.83, 119.9, -60.37, 476.49, 49.88, 99.17, 200, 1, 1.0)
		wait.for_frame_count(70)
		event.set_object_handle_footstep_sound(0, 2)
		wait.for_frame_count(60)
		event.set_rain_splash_character(-1)
		object.wait_until_done(0)
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 30)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "ドア開け", 2)
		wait.for_frame_count(60)
		sound_id = event.get_sound_id(2) or sound_id
		event.play_sound_effect(sound_id, 66)
		event.fade_out_music(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
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
	wait.for_frame_count(4)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
end

--- Plays the rain run scene and jumps to map s42.
local function cutscene_rain_run()
	local stage: number = 0
	return vm.guard(function()
		stage = 1
		vm.entry(1)
		event.fade_out_screen(0)
		stage = 2
		vm.wait(2)
		event.set_save_flag(4, 1)
		stage = 3
		play_rain_run_scene()
		event.jump_to_map_3(-1, "s42", 500)
		return
	end, function(received: { any })
		if stage <= 3 then
			if stage <= 2 then
				stage = 3
				play_rain_run_scene()
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

--- Does nothing at load time.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Overrides entry handling with nothing.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

script.cutscene_rain_run = cutscene_rain_run
script[151] = script.cutscene_rain_run

--- Stops the music and runs the rain run scene.
function script.cutscene_rain_run_after_music_stop()
	local stage: number = 0
	return vm.guard(function()
		event.stop_music(0)
		event.stop_environment_music()
		stage = 1
		wait.for_frame_count(6)
		stage = 2
		cutscene_rain_run()
		return
	end, function(received: { any })
		if stage <= 2 then
			if stage <= 1 then
				stage = 2
				cutscene_rain_run()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[10010] = script.cutscene_rain_run_after_music_stop

return script
