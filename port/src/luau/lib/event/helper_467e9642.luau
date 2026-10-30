--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_467e9642(arg0: s32, se_id: s32)
	event.set_camera_sequence_position(-98.46, 29.02, -221.77)
	event.set_camera_sequence_look_at(-133.84, 25.44, -219.86)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -143.53, -12.49, -220.28)
	event.set_object_sequence_rotation(0, 0.0, 1.61, 0.0)
	event.set_object_sequence_position(2, -79.25, -13.53, -223.34)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_position(3, -143.53, -12.49, -220.28)
	event.set_object_sequence_rotation(3, 0.0, 1.61, 0.0)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(3)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(3, "立ち（スティーブ）", 4)
	event.fade_in_screen(30)
	wait_frames(30)
	wait_frames(45)
	event.play_sound_effect(se_id, 6)
	event.play_sound_effect(se_id, 8)
	event.set_object_handle_frame_draw_flag(3, "light", arg0)
	wait_frames(45)
end

return helper_467e9642
