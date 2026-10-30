--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_1e7d5c6e(arg0: any)
	event.set_camera_sequence_position(3.57, 18.33, -44.95)
	event.set_camera_sequence_look_at(-13.94, 26.79, -26.13)
	event.set_character_position(33, -12.31, 3.85, -22.31)
	event.set_character_rotation(33, 0.0, -3.12, 0.0)
	event.set_object_sequence_motion(1, "そうじゃ！", 6)
	event.queue_object_sequence_next_motion(1, "そうじゃ！L", 0)
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(1090180)
	event.reset_mouth_texture_animations()
	wait_objects(1)
end

return helper_1e7d5c6e
