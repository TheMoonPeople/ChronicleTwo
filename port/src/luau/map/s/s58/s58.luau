--!strict
-- map/s/s58/s58.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_b8ac()
	local var0: s32 = 0
	vm.section(function()
		event.set_save_flag(600, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4527)
		var0 = event.load_sound_effect_file_2(4527) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.set_character_active(0, 0)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_2(1, "s58_2")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(0, 0.0, -120.0, -20000.0)
		event.set_object_handle_position(1, 0.0, 0.0, -20000.0)
		event.init_screen_raster_effect(0.0, 0.0, 0.0)
		event.start_screen_raster_effect(4.0, 0.15707964, 0.10471976, 0)
		event.move_object_sequence(0, 0.0, -120.0, 2800.0, 120)
		event.move_object_sequence(1, 0.0, 0.0, 2800.0, 120)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(146.6, -71.67, 641.16)
		event.set_camera_sequence_look_at(119.77, -62.2, 581.41)
		event.fade_in_screen(30)
		helper_888ab2a3(60)
		event.play_sound_effect(var0, 2)
		wait_objects(0)
		event.fade_out_screen(10)
		helper_888ab2a3(10)
	end)
	event.cancel_drama_scene_skip()
	event.stop_screen_raster_effect(0.0, 0.0, 0.0, 0)
	event.set_character_active(0)
	event.set_save_data_value(0, 8)
	event.stop_all_sound_effects()
	event.set_sound_reverb_enabled(0)
	event.show_chapter_title(6)
	vm.wait(4)
	event.set_sound_reverb_enabled(1)
	event.fade_out_screen(0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_b8ac

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_b8ac()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s31", 500)
	vm.wait(2)
end

return script
