--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_3b2844b6(arg0: any)
	event.set_camera_sequence_position(-13.07, 25.09, -70.71)
	event.set_camera_sequence_look_at(1.86, 31.3, -95.34)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, 0.22, 5.19, -94.18)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(2, "立ちあがるL", 4)
	event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090040)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(2, "ため息", 6)
	event.wait_object_sequence_motion_end(2)
	event.reset_object_sequence_motion(2)
	event.set_object_sequence_motion(2, "下向き立ち")
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090050)
	event.reset_mouth_texture_animations()
	wait_objects(2)
end

return helper_3b2844b6
