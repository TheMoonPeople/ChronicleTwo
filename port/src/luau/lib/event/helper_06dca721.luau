--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_06dca721()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 1858.52, -189.52, 1308.84)
	event.set_object_sequence_rotation(0, 0.0, -2.22, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.set_camera_sequence_position(1910.24, -159.5, 1350.91)
	event.set_camera_sequence_look_at(1816.64, -159.5, 1274.78)
	event.move_object_sequence(0, 1816.64, -189.5, 1274.78, 60)
	event.fade_in_screen(30)
	wait_frames(60)
	event.set_object_handle_footstep_sound(0, -1)
	event.reset_follow_camera(0)
	event.finish_event()
end

return helper_06dca721
