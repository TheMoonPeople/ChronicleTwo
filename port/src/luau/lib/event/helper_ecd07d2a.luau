--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_ecd07d2a()
	event.initialize_event()
	event.fade_out_screen(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-971.07, 66.21, -121.97)
	event.set_camera_sequence_look_at(-826.79, 21.3, 58.4)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -949.3, 0.0, 34.7)
	event.set_object_sequence_rotation(0, 0.0, 1.36, 0.0)
	event.set_object_sequence_motion(0, "走り", 4)
	event.move_object_sequence(0, -806.69, 0.0, 85.01, 60)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_frames(60)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.reset_follow_camera(0)
end

return helper_ecd07d2a
