--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_a4d18817 = require("@lib/event/helper_a4d18817")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_e631fe2d(arg0: s32)
	event.set_camera_sequence_position(-49.42, 28.58, -9.71)
	event.set_camera_sequence_look_at(5.37, 27.75, -69.7)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, -3.78, 5.43, -7.31)
	event.set_object_sequence_rotation(1, 0.0, -3.12, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, 0.22, 5.19, -94.18)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(2, "立ちあがるL", 4)
	event.set_object_sequence_motion(1, "歩き", 4)
	event.delay_object_sequence_motion_track(1, 69)
	event.set_object_sequence_motion(1, "立ち", 2)
	event.move_object_sequence(1, 1.5, 5.43, -38.55, 70)
	helper_a4d18817(arg0, 70)
	wait_frames(5)
end

return helper_e631fe2d
