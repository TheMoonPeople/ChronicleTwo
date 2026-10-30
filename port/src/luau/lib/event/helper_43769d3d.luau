--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_43769d3d()
	event.initialize_event()
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-1356.86, 83.9, -1168.92)
	event.set_camera_sequence_look_at(-1484.75, 27.8, -1316.45)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -1627.77, 0.0, -1432.14)
	event.set_object_sequence_rotation(0, 0.0, 1.12, 0.0)
	event.set_object_sequence_motion(0, "走り", 4)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 60)
	event.add_object_sequence_path_point(0, -1627.77, 0.0, -1432.14)
	event.add_object_sequence_path_point(0, -1529.23, 0.0, -1370.02)
	event.add_object_sequence_path_point(0, -1477.71, 0.0, -1329.77)
	event.start_object_sequence_path(0)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_frames(60)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

return helper_43769d3d
