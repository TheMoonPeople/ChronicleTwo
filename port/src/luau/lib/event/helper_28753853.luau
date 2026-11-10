--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_28753853(se_id: s32)
	event.set_camera_sequence_position(-44.56, 149.8, 16.49)
	event.set_camera_sequence_look_at(29.9, 155.39, 35.57)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_rotation(2, 0.0, -1.32, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.set_object_sequence_motion(2, "立ち", 4)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 35.03, 137.05, 41.92)
	event.set_object_sequence_rotation(3, 0.0, -1.92, 0.0)
	event.play_sound_effect(se_id, 6)
	event.set_object_sequence_motion(3, "まわる", 6)
	event.queue_object_sequence_next_motion(3, "会話")
	event.set_mouth_texture_animations(3, "わらい口パク")
	helper_4116e6bb(1080070)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.play_sound_effect(se_id, 8)
	event.set_object_sequence_motion(2, "パオーン", 6)
	event.queue_object_sequence_next_motion(2, "立ち", 0)
	event.set_object_sequence_motion(3, "指差す", 6)
	event.move_camera_sequence_eased(-158.84, 98.6, 40.59, 12.88, 114.56, 18.64, 10, 1, 0.3)
	event.set_mouth_texture_animations(3, "わらい口パク")
	helper_1584c528(1080075, 100)
	event.reset_mouth_texture_animations()
	wait_objects(2)
	wait_objects(3)
end

return helper_28753853
