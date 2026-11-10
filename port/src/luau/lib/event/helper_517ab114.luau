--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_517ab114(arg0: any)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -0.79, 50.09, 122.71)
	event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.set_character_active(1, 8)
	event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(1, 1.5, 1.5, 1.5)
	wait_objects(0)
	wait_objects(1)
	wait_camera()
end

return helper_517ab114
