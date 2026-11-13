--!strict
--- Event staging for Palm Brinks Square: its crowd characters, map parts and the Starbre walk.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")

local palm_brinks_square_event = {}

--- Deletes the six crowd characters.
function palm_brinks_square_event.delete_crowd_characters()
	for index = 0, 5 do
		event.delete_character(13 + index)
	end
end

--- Loads the six crowd characters from the chara directory, hides them and binds them to object sequences 5 to 10.
function palm_brinks_square_event.load_crowd_characters()
	event.change_directory("chara/")
	event.load_character(5, "p03_37a.gltf", "info", 13)
	event.load_character(5, "p03_38a.gltf", "info", 14)
	event.load_character(5, "p03_39a.gltf", "info", 15)
	event.load_character(5, "p03_20a.gltf", "info", 16)
	event.load_character(5, "p03_22a.gltf", "info", 17)
	event.load_character(5, "p03_24a.gltf", "info", 18)
	event.change_directory("")
	for index = 0, 5 do
		event.set_character_active(1, 13 + index)
		event.attach_object_handle_to_character(5 + index, 13 + index)
		event.clear_object_sequence(5 + index)
		event.set_object_sequence_object(5 + index, 5 + index)
	end
end

--- Sets the position and rotation of the six crowd members.
function palm_brinks_square_event.place_crowd_members()
	event.set_object_sequence_position(5, 2265.95, 0.0, 2154.92)
	event.set_object_sequence_rotation(5, 0.0, -0.24, 0.0)
	event.set_object_sequence_position(6, 2153.43, -0.63, 2262.11)
	event.set_object_sequence_rotation(6, 0.0, -1.08, 0.0)
	event.set_object_sequence_position(7, 2156.97, 0.0, 2112.93)
	event.set_object_sequence_rotation(7, 0.0, -0.6, 0.0)
	event.set_object_sequence_position(8, 2126.92, 0.0, 2216.07)
	event.set_object_sequence_rotation(8, 0.0, 1.48, 0.0)
	event.set_object_sequence_position(9, 2138.89, 5.59, 2279.54)
	event.set_object_sequence_rotation(9, 0.0, 3.04, 0.0)
	event.set_object_sequence_position(10, 2243.43, 0.0, 2156.37)
	event.set_object_sequence_rotation(10, 0.0, -2.76, 0.0)
end

--- Plays the cutscene of Starbre walking away from the camera across the square, then restores the screen.
function palm_brinks_square_event.play_starbre_walk()
	vm.section(function()
		event.initialize_event()
		event.load_map_sounds(1240)
		event.load_sound_effect_file_2(1240)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/e100/e109/e109_starbre.gltf", "info", 32)
		event.attach_object_handle_to_character(0, 32)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.attach_object_handle_to_map_part_2(1, "p01_e03h03-0")
		event.set_object_handle_visible(1, 0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.set_camera_sequence_position(1992.97, 34.74, 2905.51)
		event.set_camera_sequence_look_at(2030.46, 40.14, 2965.77)
		event.set_object_sequence_position(0, 2129.53, 0.0, 3073.66)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.move_camera_sequence_eased(1713.52, 39.48, 2489.48, 1730.42, 46.55, 2524.75, 150, 2, 0.4)
		event.set_object_sequence_motion(0, "歩き２", 4)
		event.move_object_sequence(0, 2128.59, 26.83, 3265.59, 150, 1)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(120)
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
		event.clear_camera_sequence()
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.delete_character(32)
	event.set_character_active(1, 0)
	event.fade_in_screen(30)
end

--- Sets the standing, walking, running and sitting motions of the crowd.
function palm_brinks_square_event.set_crowd_idle_motions()
	event.set_object_sequence_motion(5, "立ち", 4)
	event.set_object_sequence_motion(6, "立ち", 4)
	event.set_object_sequence_motion(7, "歩き", 4)
	event.set_object_sequence_motion(8, "走り", 4)
	event.set_object_sequence_motion(9, "座り", 4)
	event.set_object_sequence_motion(10, "歩き", 4)
end

--- Attaches two map parts and shows one of them depending on save data value 6.
function palm_brinks_square_event.show_map_part_by_save_data()
	local save_data_value: s32 = 0
	event.attach_object_handle_to_map_part_2(0, "p06_e03h03-0")
	event.attach_object_handle_to_map_part_2(1, "p07_e03h03-0")
	save_data_value = event.get_save_data_value(6) or save_data_value
	if save_data_value == 1 then
		event.set_object_handle_visible(0, 0)
		event.set_object_handle_visible(1, 1)
	else
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_visible(1, 0)
	end
end

--- Loads the crowd characters, places them and sets their idle motions.
function palm_brinks_square_event.spawn_crowd()
	palm_brinks_square_event.load_crowd_characters()
	palm_brinks_square_event.place_crowd_members()
	palm_brinks_square_event.set_crowd_idle_motions()
end

return palm_brinks_square_event
