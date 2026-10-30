--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_11a8d6f3()
	event.initialize_event()
	event.clear_camera_sequence()
	event.set_camera_sequence_position(118.52, 56.61, 357.81)
	event.set_camera_sequence_look_at(114.8, 23.48, 466.86)
	event.set_character_position(0, 47.34, -13.91, 606.83)
	event.set_character_rotation(0, 0.0, 2.82, 0.0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.fade_in_screen(30)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.move_object_sequence(0, 112.99, 3.46, 468.16, 60, 1)
	wait_frames(60)
	event.set_object_handle_footstep_sound(0, 0)
end

return helper_11a8d6f3
