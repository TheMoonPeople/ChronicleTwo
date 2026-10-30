--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_886b50d7(se_id: s32)
	event.set_camera_sequence_position(-129.32, 99.43, 13.13)
	event.set_camera_sequence_look_at(-44.6, 102.72, 11.17)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 9.11, 50.0, -10.14)
	event.set_object_sequence_rotation(2, 0.0, -1.44, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.set_object_sequence_motion(2, "立ち", 4)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 1.54, 105.26, 40.3)
	event.set_object_sequence_rotation(3, 0.0, -1.8, 0.0)
	event.set_object_sequence_motion(3, "オーッホッホ", 4)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.play_sound_effect(se_id, 1)
	event.set_object_sequence_motion(2, "パオーン", 6)
	event.queue_object_sequence_next_motion(2, "立ち", 0)
	event.set_mouth_texture_animations(3, "わらい口パク")
	helper_4116e6bb(1080040)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(3, "わらい口パク")
	helper_4116e6bb(1080041)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(3, "わらい口パク")
	helper_4116e6bb(1080042)
	event.reset_mouth_texture_animations()
	wait_objects(2)
	wait_objects(3)
end

return helper_886b50d7
