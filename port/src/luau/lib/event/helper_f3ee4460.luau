--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_f3ee4460(se_id: s32)
	event.play_music(0)
	event.set_camera_sequence_position(-133.46, 84.21, 3.17)
	event.set_camera_sequence_look_at(44.81, 76.82, -5.13)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_position(1, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 10.66, 50.0, -0.04)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.delay_camera_sequence_shake_track(6)
	event.shake_camera_sequence(0.0, 1.5, 0.0, 24)
	event.delay_camera_sequence_position_track(30)
	event.set_camera_sequence_position(82.22, 91.62, -68.3)
	event.set_camera_sequence_look_at(-234.51, 58.39, 145.67)
	event.set_object_sequence_motion(2, "着地", 6)
	event.wait_object_sequence_motion_end(2)
	helper_888ab2a3(43)
	event.play_sound_effect(se_id, 4)
	wait_objects(2)
	wait_camera()
end

return helper_f3ee4460
