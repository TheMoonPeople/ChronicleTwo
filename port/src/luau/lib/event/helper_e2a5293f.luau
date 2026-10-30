--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")

--- Helper function.
local function helper_e2a5293f(arg0: any)
	event.set_camera_position(-393.89, 100.04, -2.57)
	event.set_camera_look_at(-194.23, 107.31, -159.8)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.move_camera_sequence_eased(-393.89, 100.04, -2.57, -266.2, 107.31, 189.14, 150, 0, 0.4)
	wait_camera()
end

return helper_e2a5293f
