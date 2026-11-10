--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_3d7d594a(arg0: any)
	event.set_camera_sequence_position(-33.29, 24.37, -167.32)
	event.set_camera_sequence_look_at(40.27, 15.44, -159.28)
	event.set_object_sequence_position(0, 18.58, -1.12, -168.14)
	event.set_object_sequence_rotation(0, 0.0, 0.92, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4, -1.0, 1)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, -2.16, 0.0)
	wait_frames(20)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	wait_frames(15)
	event.set_object_sequence_motion(1, "会話2", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050340)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050341)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050350)
	event.reset_mouth_texture_animations()
end

return helper_3d7d594a
