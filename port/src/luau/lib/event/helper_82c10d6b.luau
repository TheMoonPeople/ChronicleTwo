--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_82c10d6b(se_id: s32)
	event.set_camera_sequence_position(-408.29, 60.12, 94.13)
	event.set_camera_sequence_look_at(-475.86, 71.34, 81.15)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -492.64, 50.09, 76.79)
	event.set_object_sequence_rotation(0, 0.0, 1.2, 0.0)
	event.set_object_sequence_motion(0, "プルプル", 4, -1.0, 1)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -492.64, 50.09, 76.79)
	event.set_object_sequence_rotation(1, 0.0, 1.2, 0.0)
	event.set_object_sequence_motion(1, "プルプル", 4)
	event.play_sound_effect(se_id, 0)
	wait_frames(50)
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(0, "ジャンプ", 6, 0.4)
	event.set_object_sequence_motion(1, "ジャンプ", 6, 0.4)
	event.delay_object_sequence_position_track(0, 3)
	event.delay_object_sequence_position_track(1, 3)
	event.jump_object_sequence(0, -739.96, 133.89, -9.49, -0.28, 33)
	event.jump_object_sequence(1, -739.96, 133.89, -9.49, -0.28, 33)
	event.wait_object_sequence_motion_end(0)
	event.wait_object_sequence_motion_end(1)
	event.move_camera_sequence_eased(-408.29, 60.12, 94.13, -709.98, 167.81, 0.97, 25, 0, 0.4)
	wait_objects(0)
	wait_objects(1)
	event.stop_sound_effect(se_id, 0)
end

return helper_82c10d6b
