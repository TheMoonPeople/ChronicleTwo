--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_d2e16403()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	event.reset_action_character_motion(0, 4)
	event.fade_out_screen(30)
	wait_frames(30)
	event.set_dungeon_pause_flags(1, 1)
	event.clear_event_battle_monsters(-1)
	wait_frames(30)
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_360.sound.json") or var0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.show_dungeon_status_bar(0, 1.0)
	event.load_character(5, "dungeon/monster/b07a.gltf", "b07a", 8)
	event.set_character_active(1, 8)
	event.attach_object_handle_to_character(0, 8)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.fade_in_screen(15)
	event.set_camera_position(-50.62, 42.66, 812.75)
	event.set_camera_look_at(-50.82, 71.75, 656.03)
	event.set_character_active(0, 0)
	event.play_sound_effect(var0, 24)
	event.set_object_sequence_position(0, -50.62, 4.34, 553.77)
	event.set_object_sequence_rotation(0, 0.0, 0.02, 0.0)
	event.set_object_sequence_motion(0, "死に", 6)
	event.wait_object_sequence_motion_end(0)
	wait_objects(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no ~= 2 then
		event.set_camera_position(-21.21, 14.5, 728.16)
		event.set_camera_look_at(-33.94, 17.9, 751.25)
	else
		event.set_camera_position(8.06, 23.77, 675.07)
		event.set_camera_look_at(-39.51, 29.49, 761.36)
	end
	event.set_character_active(1, 0)
	event.set_character_position(0, -40.07, 1.76, 766.47)
	event.set_character_rotation(0, 0.0, -3.12, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.delete_character(8)
	event.finish_event()
end

return helper_d2e16403
