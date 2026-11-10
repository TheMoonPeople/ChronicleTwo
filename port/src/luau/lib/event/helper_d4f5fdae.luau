--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_d4f5fdae()
	local var0: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_040.sound.json") or var0
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_camera_position(133.95, 349.85, 995.49)
	event.set_camera_look_at(10.87, 287.26, 1174.06)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 3)
	event.set_character_active(1, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 3.0, 263.17, 1196.78)
	event.set_object_sequence_rotation(0, 0.0, -3.08, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.attach_object_handle_to_map_part_3(10, "p08_s06", "s06_08-m1")
	event.set_object_handle_visible(10, 1)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_object_sequence_position(10, 2.90684, 312.375, 1188.04)
	event.move_object_sequence(10, 2.90684, 412.375, 1188.04, 30)
	event.play_sound_effect(var0, 0)
	event.fade_in_screen(30)
	wait_frames(15)
	event.set_object_sequence_motion(0, "走り")
	event.delay_object_sequence_motion_track(0, 30)
	event.set_object_sequence_motion(0, "立ち")
	event.move_object_sequence(0, 3.0, 263.17, 1131.27, 30)
	wait_objects(0)
	wait_objects(10)
	event.play_sound_effect(var0, 1)
	event.jump_object_sequence(10, 2.90684, 312.375, 1188.04, -0.2, 10)
	event.jump_object_sequence(10, 2.90684, 312.375, 1188.04, -0.2, 8)
	event.jump_object_sequence(10, 2.90684, 312.375, 1188.04, -0.2, 5)
	wait_frames(40)
	event.show_dungeon_status_bar(1, 0.033333335)
	event.set_character_position(0, 3.0, 263.17, 1131.27)
	event.set_object_handle_position(10, 2.90684, 312.375, 1188.04)
	event.set_camera_look_at(3.0, 293.17, 1131.27)
	event.set_camera_position(3.0, 303.17, 1011.27)
	event.reset_follow_camera(0)
	event.finish_event()
end

return helper_d4f5fdae
