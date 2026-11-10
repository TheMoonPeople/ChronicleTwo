--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_8b12f95c()
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
	event.fade_in_screen(15)
	event.move_object_sequence(0, 418.52, 0.01, 950.16, 75, 1)
	event.move_object_sequence(1, 399.78, 0.0, 963.89, 75, 1)
	wait_frames(75)
end

return helper_8b12f95c
