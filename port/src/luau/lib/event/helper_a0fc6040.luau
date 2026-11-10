--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_a0fc6040(arg0: any)
	local projection: f32 = 0
	event.set_camera_sequence_position(-51.29, 55.13, -119.05)
	event.set_camera_sequence_look_at(-104.92, 14.85, -202.28)
	projection = event.get_event_projection() or projection
	event.set_event_projection(524.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -85.21, -13.05, -197.85)
	event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.set_object_handle_visible(11, 1)
	event.set_object_sequence_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(3, "下見立ち", 4)
	event.set_object_sequence_motion(2, "上見立ち", 4)
	wait_frames(15)
	event.set_object_sequence_motion(2, "上見会話", 6)
	event.queue_object_sequence_next_motion(2, "上見立ち", 0)
	event.set_mouth_texture_animations(2, "大口パク")
	helper_4116e6bb(1060060)
	event.reset_mouth_texture_animations()
	event.set_event_projection(projection)
end

return helper_a0fc6040
