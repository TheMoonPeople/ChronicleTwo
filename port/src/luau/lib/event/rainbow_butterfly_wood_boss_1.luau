--!strict
--- Boss room 1 staging and state handling of the Rainbow Butterfly Wood.

local vm = require("@lib/vm")
local wait = vm.module("@lib/event/wait")

local rainbow_butterfly_wood_boss_1 = {}

--- Restores the boss room map parts and function points from the save flags and stops the music.
function rainbow_butterfly_wood_boss_1.restore_boss_room_state()
	local save_flag: s32 = 0
	event.stop_music(0)
	save_flag = event.get_save_flag(24) or save_flag
	if save_flag ~= 0 then
		event.set_function_point_enabled("", "e255", 0)
		rainbow_butterfly_wood_boss_1.set_boss_room_stage(2)
		save_flag = event.get_save_flag(260) or save_flag
		if save_flag ~= 0 then
			event.set_function_point_enabled("", "e256", 0)
			rainbow_butterfly_wood_boss_1.set_boss_room_stage(1)
		else
			event.set_function_point_enabled("", "e256", 1)
		end
	else
		event.set_function_point_enabled("", "e255", 1)
		event.set_function_point_enabled("", "e256", 0)
		save_flag = event.get_save_flag(23) or save_flag
		if save_flag ~= 0 then
			rainbow_butterfly_wood_boss_1.set_boss_room_stage(0)
		else
			rainbow_butterfly_wood_boss_1.set_boss_room_stage(3)
		end
	end
end

--- Fades in and runs the player along the passage into the boss room.
function rainbow_butterfly_wood_boss_1.run_in_with_fade_in()
	event.initialize_event()
	event.clear_camera_sequence()
	event.set_camera_sequence_position(118.52, 56.61, 357.81)
	event.set_camera_sequence_look_at(114.8, 23.48, 466.86)
	event.set_character_position(0, 47.34, -13.91, 606.83)
	event.set_character_rotation(0, 0.0, 2.82, 0.0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.fade_in_screen(30)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.move_object_sequence(0, 112.99, 3.46, 468.16, 60, 1)
	wait.frames(60)
	event.set_object_handle_footstep_sound(0, 0)
end

--- Runs the player back out of the boss room and fades out.
function rainbow_butterfly_wood_boss_1.run_out_with_fade_out()
	event.initialize_event()
	event.clear_camera_sequence()
	event.set_camera_sequence_position(118.52, 56.61, 357.81)
	event.set_camera_sequence_look_at(114.8, 23.48, 466.86)
	event.set_character_position(0, 112.99, 3.46, 468.16)
	event.set_character_rotation(0, 0.0, -0.3215928, 0.0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.move_object_sequence(0, 47.34, -13.91, 606.83, 60, 1)
	wait.frames(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_object_handle_footstep_sound(0, 0)
end

--- Shows the map parts of the boss room that match the given progress stage.
function rainbow_butterfly_wood_boss_1.set_boss_room_stage(stage: s32)
	event.attach_object_handle_to_map_part_2(10, "p05_d02b01")
	event.attach_object_handle_to_map_part_2(11, "p02_d02b01")
	event.attach_object_handle_to_map_part_2(14, "p03_d02b01")
	event.attach_object_handle_to_map_part_2(17, "p04_d02b01")
	event.attach_object_handle_to_map_part_3(20, "bero", "03bossbero")
	event.attach_object_handle_to_map_part_3(21, "bero-1", "03bossbero")
	event.attach_object_handle_to_map_part_3(22, "bero-2", "03bossbero")
	event.attach_object_handle_to_map_part_3(23, "bero-3", "03bossbero")
	event.attach_object_handle_to_map_part_3(24, "bero-4", "03bossbero")
	event.attach_object_handle_to_map_part_3(25, "bero-5", "03bossbero")
	event.attach_object_handle_to_map_part_3(26, "bero-6", "03bossbero")
	event.attach_object_handle_to_map_part_3(27, "bero-7", "03bossbero")
	event.attach_object_handle_to_map_part_3(28, "neba", "neba3")
	if stage == 0 then
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 0)
		event.set_object_handle_visible(14, 0)
		event.set_object_handle_visible(17, 1)
		event.set_object_handle_visible(20, 0)
		event.set_object_handle_visible(21, 0)
		event.set_object_handle_visible(22, 0)
		event.set_object_handle_visible(23, 0)
		event.set_object_handle_visible(24, 0)
		event.set_object_handle_visible(25, 0)
		event.set_object_handle_visible(26, 0)
		event.set_object_handle_visible(27, 0)
		event.set_object_handle_visible(28, 0)
	end
	if stage == 1 then
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 1)
		event.set_object_handle_visible(14, 1)
		event.set_object_handle_visible(17, 0)
		event.set_object_handle_visible(20, 1)
		event.set_object_handle_visible(21, 1)
		event.set_object_handle_visible(22, 1)
		event.set_object_handle_visible(23, 1)
		event.set_object_handle_visible(24, 1)
		event.set_object_handle_visible(25, 1)
		event.set_object_handle_visible(26, 1)
		event.set_object_handle_visible(27, 1)
		event.set_object_handle_visible(28, 0)
	end
	if stage == 2 then
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 1)
		event.set_object_handle_visible(14, 1)
		event.set_object_handle_visible(17, 0)
		event.set_object_handle_visible(20, 1)
		event.set_object_handle_visible(21, 1)
		event.set_object_handle_visible(22, 1)
		event.set_object_handle_visible(23, 1)
		event.set_object_handle_visible(24, 1)
		event.set_object_handle_visible(25, 1)
		event.set_object_handle_visible(26, 1)
		event.set_object_handle_visible(27, 1)
		event.set_object_handle_visible(28, 1)
	end
	if stage == 3 then
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 0)
		event.set_object_handle_visible(14, 0)
		event.set_object_handle_visible(17, 1)
		event.set_object_handle_visible(20, 0)
		event.set_object_handle_visible(21, 0)
		event.set_object_handle_visible(22, 0)
		event.set_object_handle_visible(23, 0)
		event.set_object_handle_visible(24, 0)
		event.set_object_handle_visible(25, 0)
		event.set_object_handle_visible(26, 0)
		event.set_object_handle_visible(27, 0)
		event.set_object_handle_visible(28, 0)
	end
end

--- Locks or unlocks dungeon controls, party display, character switching and saving together.
function rainbow_butterfly_wood_boss_1.set_controls_locked(is_locked: s32)
	event.set_dungeon_pause_flags(8192, is_locked)
	rainbow_butterfly_wood_boss_1.set_party_display_visible(if is_locked == 0 then 1 else 0)
	if is_locked == 0 then
		event.reset_action_character_motion(0, 4)
	end
	event.set_character_change_unmasked(2, if is_locked == 0 then 1 else 0)
	event.set_character_change_unmasked(3, if is_locked == 0 then 1 else 0)
	event.set_save_control_bits(1, is_locked)
end

--- Shows or hides the party objects and the dungeon status bar.
function rainbow_butterfly_wood_boss_1.set_party_display_visible(is_visible: s32)
	event.attach_object_handle_to_character(0, 1)
	event.attach_object_handle_to_character(1, 2)
	event.set_object_handle_visible(0, is_visible)
	event.set_object_handle_visible(1, is_visible)
	event.show_dungeon_status_bar(is_visible, 1.0)
end

return rainbow_butterfly_wood_boss_1
