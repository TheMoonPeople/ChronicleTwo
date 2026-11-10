--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_796ab4a2(se_id: s32)
	local projection: f32 = 0
	event.set_camera_sequence_position(17.24, 26.0, -9.56)
	event.set_camera_sequence_look_at(5.22, 26.46, -42.09)
	event.set_object_sequence_position(1, -4.35, 5.29, -42.32)
	event.set_object_sequence_rotation(1, 0.0, 2.92, 0.0)
	event.set_object_sequence_motion(1, "そうじゃ！L")
	event.set_object_sequence_position(2, 0.22, 5.19, -94.18)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(2, "前を見るL", 4)
	wait_objects(1)
	wait_objects(2)
	event.set_object_sequence_motion(1, "そうじゃ！会話", 6)
	event.queue_object_sequence_next_motion(1, "そうじゃ！L")
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(1090210)
	event.reset_mouth_texture_animations()
	wait_objects(1)
	event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
	event.set_object_sequence_motion(2, "考える", 6, 0.08)
	event.wait_object_sequence_motion_end(2)
	event.reset_object_sequence_motion(2)
	event.set_object_sequence_motion(2, "下向き立ち")
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090220)
	event.reset_mouth_texture_animations()
	wait_objects(2)
	event.play_sound_effect(se_id, 5)
	event.set_object_sequence_motion(1, "そうじゃ！会話", 6)
	event.queue_object_sequence_next_motion(1, "そうじゃ！L")
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(1090230)
	event.reset_mouth_texture_animations()
	wait_objects(1)
	wait_frames(60)
	event.set_event_projection(projection)
end

return helper_796ab4a2
