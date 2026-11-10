--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_fdefb770(arg0: any)
	event.set_camera_sequence_position(212.25, 205.2, 623.4)
	event.set_camera_sequence_look_at(236.71, 212.83, 651.45)
	event.set_object_sequence_position(4, 258.83, 197.74, 677.01)
	event.set_object_sequence_rotation(4, 0.0, -3.0, 0.0)
	event.set_object_sequence_motion(4, "前を見るL", 4)
	wait_objects(4)
	event.set_mouth_texture_animations(4, "口パク")
	helper_4116e6bb(1090320)
	event.reset_mouth_texture_animations()
	event.clear_camera_sequence()
	event.fade_out_camera_sequence(100, 0.0, 0.0, 0.0)
	wait_camera()
end

return helper_fdefb770
