--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_735361a0(arg0: any)
	event.fade_in_screen(30)
	wait_frames(30)
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_motion(1, "腰に手", 4)
	event.set_object_sequence_motion(2, "斜め向き立ち", 4)
	event.set_object_sequence_motion(3, "石炭", 4)
	event.move_camera_sequence_eased(41.03, 65.52, -72.49, 1.22, 60.93, 25.12, 60, 0, 1.0)
	wait_camera()
	wait_frames(20)
end

return helper_735361a0
