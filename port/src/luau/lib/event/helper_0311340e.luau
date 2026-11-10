--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_0311340e()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_camera_sequence_position(-1091.22, 50.0, -610.47)
	event.set_camera_sequence_look_at(-951.89, 30.0, -531.81)
	event.set_object_sequence_position(0, -996.5, 0.0, -556.99)
	event.set_object_sequence_rotation(0, 0.0, 1.06, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.move_object_sequence(0, -951.89, 0.0, -531.81, 45)
	event.fade_in_screen(30)
	wait_frames(30)
	event.set_object_handle_footstep_sound(0, 0)
end

return helper_0311340e
