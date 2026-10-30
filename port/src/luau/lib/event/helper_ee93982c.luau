--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_ee93982c(arg0: any)
	event.detach_character_from_frame(33)
	event.set_character_active(0, 33)
	event.set_camera_sequence_position(-33.79, 30.18, -157.21)
	event.set_camera_sequence_look_at(24.92, 17.88, -150.76)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_object_handle_visible(1, 1)
	event.set_object_handle_visible(2, 0)
	event.set_object_sequence_motion(1, "会話2", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050250)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050260)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(1, "会話2", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050261)
	event.reset_mouth_texture_animations()
	wait_objects(1)
	event.set_object_sequence_motion(1, "立ち")
	wait_objects(1)
	wait_frames(10)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.wait_object_sequence_motion_end(0)
	wait_objects(0)
	wait_frames(15)
end

return helper_ee93982c
