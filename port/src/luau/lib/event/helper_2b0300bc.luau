--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_2b0300bc(se_id: s32)
	event.set_camera_sequence_position(-1.63, 28.5, -58.54)
	event.set_camera_sequence_look_at(-1.54, 28.17, -29.76)
	event.set_character_position(33, -1.6, 4.14, -22.85)
	event.set_character_rotation(33, 0.0, -3.12, 0.0)
	event.set_object_sequence_motion(1, "腕組み", 4)
	wait_objects(1)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1090100)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "腕組み会話", 6)
	event.queue_object_sequence_next_motion(1, "腕組み", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1090110)
	event.reset_mouth_texture_animations()
	wait_objects(1)
end

return helper_2b0300bc
