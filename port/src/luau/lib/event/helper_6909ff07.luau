--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")

--- Helper function.
local function helper_6909ff07(arg0: any)
	event.set_camera_sequence_position(-24.3, 23.42, -18.85)
	event.set_camera_sequence_look_at(2.59, 28.72, -60.25)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, 0.65, 5.43, -39.63)
	event.set_object_sequence_rotation(1, 0.0, -3.12, 0.0)
	event.set_object_sequence_position(2, 0.22, 5.19, -94.18)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(2, "下向き立ち", 4)
	event.set_object_sequence_motion(1, "会話", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1090060)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090070)
	event.reset_mouth_texture_animations()
end

return helper_6909ff07
