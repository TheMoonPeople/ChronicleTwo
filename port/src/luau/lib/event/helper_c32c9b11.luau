--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_c32c9b11(arg0: any)
	event.set_camera_sequence_position(-17.46, 142.28, 29.34)
	event.set_camera_sequence_look_at(1.26, 135.02, 26.5)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 1.21, 102.73, 26.08)
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.set_object_sequence_motion(3, "逃げちゃうの？", 4)
	event.set_object_sequence_texture_animation(3, 0)
	event.set_object_sequence_texture_animation(3, 1, "わらい顔2")
	event.set_mouth_texture_animations(3, "わらい口パク")
	helper_4116e6bb(1080050)
	event.reset_mouth_texture_animations()
	event.set_camera_sequence_position(-17.46, 142.28, 29.34)
	event.set_camera_sequence_look_at(1.26, 135.02, 26.5)
	event.set_object_sequence_texture_animation(3, 0)
	event.set_object_sequence_texture_animation(3, 1, "たかわらい顔")
	event.set_object_sequence_motion(3, "オーッホッホ", 4)
	event.set_mouth_texture_animations(3, "わらい口パク")
	helper_4116e6bb(1080060)
	event.reset_mouth_texture_animations()
	wait_objects(3)
	wait_camera()
end

return helper_c32c9b11
