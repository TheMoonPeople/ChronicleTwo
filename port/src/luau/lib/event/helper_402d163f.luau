--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_402d163f()
	event.initialize_event()
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-2098.32, 112.9, 2914.62)
	event.set_camera_sequence_look_at(-2002.24, 24.33, 3103.52)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -1953.35, -38.07, 3352.55)
	event.set_object_sequence_rotation(0, 0.0, -2.4, 0.0)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 60)
	event.add_object_sequence_path_point(0, -1953.35, -38.07, 3352.55)
	event.add_object_sequence_path_point(0, -1973.62, -28.53, 3308.18)
	event.add_object_sequence_path_point(0, -1994.79, -9.95, 3175.09)
	event.add_object_sequence_path_point(0, -2000.28, 0.23, 3105.85)
	event.start_object_sequence_path(0)
	event.fade_in_screen(30)
	wait_frames(60)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

return helper_402d163f
