--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_aa53c510 = require("@lib/event/helper_aa53c510")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_b4bd3a08(se_id: s32)
	event.set_camera_sequence_position(-0.92, 28.84, -32.55)
	event.set_camera_sequence_look_at(-0.27, 28.03, 22.59)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, -0.66, 0.0, 123.46)
	event.set_object_sequence_rotation(1, 0.0, -3.12, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -0.66, 0.0, 123.46)
	event.set_object_sequence_rotation(3, 0.0, -3.14, 0.0)
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_motion(1, "ドア開け", 6)
	event.set_object_sequence_motion(3, "ドア開け", 6)
	event.wait_object_sequence_motion_end(1)
	event.wait_object_sequence_motion_end(3)
	event.delay_camera_sequence_position_track(60)
	event.set_camera_sequence_position(9.38, 26.8, 22.17)
	event.set_camera_sequence_look_at(10.04, 25.99, 77.32)
	helper_aa53c510(se_id, 160)
	wait_objects(1)
	wait_objects(3)
	wait_camera()
end

return helper_b4bd3a08
