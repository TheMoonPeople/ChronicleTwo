--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_52f65809(arg0: any)
	event.set_camera_sequence_position(-46.87, 29.18, -9.44)
	event.set_camera_sequence_look_at(3.87, 26.86, -60.12)
	event.set_object_sequence_position(1, -0.19, 5.43, -35.38)
	event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
	event.set_object_sequence_position(2, 0.22, 5.19, -94.18)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_motion(2, "下向き立ち", 4)
	event.fade_in_screen(30)
	wait_frames(30)
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090090)
	event.reset_mouth_texture_animations()
end

return helper_52f65809
