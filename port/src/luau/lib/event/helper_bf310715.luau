--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_bf310715(se_id: s32)
	event.set_camera_sequence_position(-3.62, 25.14, -51.33)
	event.set_camera_sequence_look_at(12.22, 28.93, -35.31)
	event.set_object_sequence_position(1, 12.17, 5.43, -29.98)
	event.set_object_sequence_rotation(1, 0.0, -3.12, 0.0)
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_motion(1, "バカもん！", 6)
	event.queue_object_sequence_next_motion(1, "バカもん！L", 6)
	event.queue_object_sequence_next_motion(1, "バカもん！戻り", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(1090130)
	event.reset_mouth_texture_animations()
	wait_objects(1)
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(1090131)
	event.reset_mouth_texture_animations()
	wait_objects(1)
end

return helper_bf310715
