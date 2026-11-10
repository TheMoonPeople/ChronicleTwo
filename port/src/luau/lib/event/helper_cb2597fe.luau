--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_cb2597fe(se_id: s32)
	event.set_camera_sequence_position(50.99, 20.54, -99.77)
	event.set_camera_sequence_look_at(50.2, 23.69, -140.94)
	event.set_object_sequence_position(0, 59.55, -1.12, -135.97)
	event.set_object_sequence_rotation(0, 0.0, -2.24, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4, -1.0, 1)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, 0.72, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_position(2, 62.85, 11.43, -176.07)
	event.set_object_sequence_rotation(2, 0.0, -0.72, 0.0)
	wait_frames(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "ガッツポーズ", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050360)
	event.reset_mouth_texture_animations()
end

return helper_cb2597fe
