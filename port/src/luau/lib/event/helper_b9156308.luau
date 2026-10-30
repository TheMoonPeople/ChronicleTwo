--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_b9156308(arg0: any)
	local projection: f32 = 0
	event.set_camera_sequence_position(-13.56, 50.69, -99.84)
	event.set_camera_sequence_look_at(47.32, 59.3, -184.47)
	projection = event.get_event_projection() or projection
	event.set_event_projection(471.9)
	event.set_object_sequence_position(0, -17.08, -0.02, -207.87)
	event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_object_sequence_position(1, 34.05, -0.02, -143.69)
	event.set_object_sequence_rotation(1, 0.0, 2.73, 0.0)
	event.set_object_sequence_motion(1, "上を見るL", 4)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
	event.move_camera_sequence_eased(-13.56, 18.54, -99.84, 47.32, 27.15, -184.47, 90, 2, 0.4)
	wait_camera()
	event.set_object_sequence_motion(0, "歩き", 0)
	event.move_object_sequence(0, 8.7, -0.02, -189.32, 45)
	event.rotate_object_sequence(0, 0.0, 0.3, 0.0, 45)
	event.move_object_sequence(0, 16.96, -0.02, -159.01, 45)
	wait_objects(0)
	event.rotate_object_sequence(0, 0.0, 1.74, 0.0, 10)
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	wait_objects(0)
	wait_frames(10)
	event.set_event_projection(projection)
end

return helper_b9156308
