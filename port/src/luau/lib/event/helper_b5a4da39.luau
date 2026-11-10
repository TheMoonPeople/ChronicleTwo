--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_b5a4da39(se_id: s32)
	event.set_camera_sequence_position(-120.34, 23.49, -175.84)
	event.set_camera_sequence_look_at(-120.44, 21.93, -203.94)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
	wait_objects(0)
	wait_objects(1)
	event.play_sound_effect(se_id, 1)
	wait_frames(50)
end

return helper_b5a4da39
