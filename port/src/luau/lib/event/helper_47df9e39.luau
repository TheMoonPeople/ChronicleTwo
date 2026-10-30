--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_47df9e39()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 2492.28, 5.66, 457.27)
	event.set_object_sequence_rotation(0, 0.0, -2.76, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.move_object_sequence(0, 2466.56, 6.63, 395.9, 60)
	event.set_camera_sequence_look_at(2466.56, 36.63, 395.98)
	event.set_camera_sequence_position(2513.1, 56.63, 506.94)
	event.fade_in_screen(30)
	wait_frames(60)
	event.set_object_sequence_motion(0, "立ち")
	wait_frames(2)
	event.set_object_handle_footstep_sound(0, 0)
end

return helper_47df9e39
