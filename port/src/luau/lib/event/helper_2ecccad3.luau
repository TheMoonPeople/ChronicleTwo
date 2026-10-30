--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_2ecccad3(se_id: s32)
	local projection: f32 = 0
	event.set_camera_sequence_position(-84.68, 6.96, -155.87)
	event.set_camera_sequence_look_at(-202.81, 27.8, -509.36)
	event.get_event_projection(projection)
	event.set_event_projection(468.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -121.68, -12.53, -351.93)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, -121.68, -12.53, -351.93)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(10, 0)
	event.set_object_handle_visible(11, 0)
	event.set_object_sequence_rotation(12, 0.0, -1.57, 0.0)
	event.set_object_sequence_rotation(13, 0.0, 1.57, 0.0)
	event.set_object_handle_visible(14, 0)
	event.set_object_handle_visible(15, 0)
	event.fade_out_screen(0)
	wait_objects(12)
	wait_objects(13)
	event.play_sound_effect(se_id, 0)
	event.fade_in_screen(30)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -119.53, -12.53, -218.69, 100)
	event.move_object_sequence(1, -119.53, -12.53, -218.69, 100)
	wait_frames(80)
	event.play_sound_effect(se_id, 4)
	event.rotate_object_sequence(12, 0.0, 0.0, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 0.0, 0.0, 50)
	wait_objects(0)
	wait_objects(1)
	wait_camera()
	event.set_event_projection(projection)
end

return helper_2ecccad3
