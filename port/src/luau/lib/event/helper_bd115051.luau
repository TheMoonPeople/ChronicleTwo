--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_bd115051(arg0: any)
	event.set_camera_sequence_position(-221.89, 93.35, -18.76)
	event.set_camera_sequence_look_at(-248.13, 94.53, -3.27)
	event.set_object_sequence_position(0, -245.08, 50.51, -6.05)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -245.08, 50.51, -6.05)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_motion(0, "驚く", 6)
	event.set_object_sequence_motion(1, "驚く", 6)
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(1070030)
	event.reset_mouth_texture_animations()
	wait_objects(0)
	wait_objects(1)
end

return helper_bd115051
