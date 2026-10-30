--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_8b00d8f9(arg0: any)
	event.set_camera_sequence_position(-355.99, 88.75, 12.43)
	event.set_camera_sequence_look_at(-376.3, 90.49, 31.84)
	event.set_character_active(1, 0)
	event.set_character_active(1, 9)
	event.set_object_sequence_motion(0, "あれ？", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(0, "あれ？L")
	event.set_object_sequence_motion(1, "あれ？", 6)
	event.queue_object_sequence_next_motion(1, "あれ？L")
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(1070010)
	event.reset_mouth_texture_animations()
	wait_objects(0)
	wait_objects(1)
	event.set_object_sequence_position(0, -348.51, 50.51, -12.26)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -348.51, 50.51, -12.26)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
end

return helper_8b00d8f9
