--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_bfb26927(arg0: any)
	event.set_camera_sequence_position(-501.66, 281.73, -144.66)
	event.set_camera_sequence_look_at(-757.43, 150.05, -3.21)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -739.96, 133.89, -9.49)
	event.set_object_sequence_rotation(0, 0.0, 1.2, 0.0)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -739.96, 133.89, -9.49)
	event.set_object_sequence_rotation(1, 0.0, 1.2, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.rotate_object_sequence(0, 0.0, -1.44, 0.0, 20)
	event.rotate_object_sequence(1, 0.0, -1.44, 0.0, 20)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(100)
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -915.85, 133.64, -6.02, 150)
	event.move_object_sequence(1, -915.85, 133.64, -6.02, 150)
	wait_objects(0)
	wait_objects(1)
	wait_camera()
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
end

return helper_bfb26927
