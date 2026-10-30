--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_4e7ad90f(arg0: any)
	event.set_camera_sequence_position(-292.76, 173.19, -1582.23)
	event.set_camera_sequence_look_at(-228.24, 151.8, -1773.02)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_object_sequence_position(10, -120.0, 0.0, -1690.0)
	event.move_object_sequence(10, -120.0, 0.0, -3050.0, 90)
	wait_frames(90)
end

return helper_4e7ad90f
