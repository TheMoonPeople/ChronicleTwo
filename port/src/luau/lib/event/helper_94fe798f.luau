--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_94fe798f(arg0: any)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-127.04, 86.04, -2182.12)
	event.set_camera_sequence_look_at(-120.48, 84.44, -1718.57)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_object_sequence_position(10, -120.0, 0.0, -1690.0)
	event.move_camera_sequence_eased(-126.85, 86.09, -2262.29, -120.48, 84.44, -1718.57, 20, 2, 0.4)
	event.move_object_sequence(10, -120.0, 0.0, -2100.0, 45)
	wait_frames(45)
end

return helper_94fe798f
