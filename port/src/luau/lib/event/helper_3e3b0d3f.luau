--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_3e3b0d3f()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 1000.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.set_camera_look_at(0.0, 30.0, 820.0)
	event.set_camera_position(0.0, 66.0, 700.0)
	event.fade_in_screen(30)
	event.move_object_sequence(0, 0.0, 0.0, 820.0, 40)
	wait_frames(20)
	event.set_object_handle_footstep_sound(0, 6)
	wait_frames(20)
	event.set_object_sequence_motion(0, "立ち")
	wait_frames(2)
end

return helper_3e3b0d3f
