--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_3575fba1(arg0: any)
	event.start_crossfade(1, 1, 60)
	event.set_camera_sequence_position(14.46, 268.16, 737.45)
	event.set_camera_sequence_look_at(-30.4, 237.84, 510.02)
	event.move_camera_sequence_eased(-72.53, 268.16, 754.61, -117.4, 237.84, 527.18, 120, 2, 0.4)
	wait_camera()
	event.stop_music(0)
	wait_frames(4)
	event.load_music(193)
end

return helper_3575fba1
