--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_2768ff79(arg0: any)
	event.set_camera_sequence_position(24.93, 29.64, -79.63)
	event.set_camera_sequence_look_at(-8.31, 36.32, -96.0)
	event.set_character_position(34, 0.05, 10.14, -94.36)
	event.set_character_rotation(34, 0.0, 0.0, 0.0)
	event.set_object_sequence_texture_animation(2, 0)
	event.set_object_sequence_texture_animation(2, 1, "目とじ～目あけ")
	event.set_object_sequence_motion(2, "下向き立ち", 4)
	wait_objects(2)
	event.set_object_sequence_texture_animation(2, 0)
	event.set_object_sequence_texture_animation(2, 1, "しんけん顔")
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090190)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1090200)
	event.reset_mouth_texture_animations()
end

return helper_2768ff79
