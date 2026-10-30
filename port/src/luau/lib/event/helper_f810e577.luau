--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")

--- Helper function.
local function helper_f810e577(arg0: any)
	event.set_camera_sequence_position(-0.73, 30.22, -58.88)
	event.set_camera_sequence_look_at(0.18, 32.06, -95.16)
	event.set_character_position(34, 0.22, 5.19, -94.18)
	event.set_character_rotation(34, 0.0, 0.0, 0.0)
	event.move_camera_sequence_eased(-0.4, 30.22, -71.81, 0.18, 32.06, -95.16, 100, 0, 0.4)
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090080)
	event.reset_mouth_texture_animations()
	wait_camera()
end

return helper_f810e577
