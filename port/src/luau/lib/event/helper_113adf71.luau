--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_113adf71(arg0: any)
	event.set_camera_sequence_position(51.28, 21.78, -97.62)
	event.set_camera_sequence_look_at(50.16, 19.92, -141.52)
	event.set_object_sequence_position(0, 58.4, -0.02, -135.54)
	event.set_object_sequence_rotation(0, 0.0, -2.3, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_object_sequence_position(1, 36.44, -0.02, -151.98)
	event.set_object_sequence_rotation(1, 0.0, 0.69, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
	event.set_character_position(25, 62.85, 11.43, -176.07)
	event.set_character_rotation(25, 0.0, -0.72, 0.0)
	wait_frames(15)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050530)
	event.reset_mouth_texture_animations()
end

return helper_113adf71
