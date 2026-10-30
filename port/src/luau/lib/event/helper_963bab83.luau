--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_963bab83(arg0: any)
	event.set_camera_sequence_position(17.24, 26.0, -9.56)
	event.set_camera_sequence_look_at(5.22, 26.46, -42.09)
	event.set_object_sequence_position(1, -4.35, 5.29, -42.32)
	event.set_object_sequence_rotation(1, 0.0, 2.92, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_position(2, 0.22, 5.19, -94.18)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(2, "下見向き立ち", 4)
	wait_objects(1)
	wait_objects(2)
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090140)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(1, "会話", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(1090150)
	event.reset_mouth_texture_animations()
	helper_4116e6bb(1090160)
	event.set_object_sequence_motion(1, "会話", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(1090170)
	event.reset_mouth_texture_animations()
	wait_objects(1)
end

return helper_963bab83
