--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_6fc8ed77()
	event.initialize_event()
	event.set_camera_sequence_position(-625.66, 104.24, -868.06)
	event.set_camera_sequence_look_at(-903.96, 23.48, -831.72)
	event.set_character_active(1, 0)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -1023.6, 0.0, -838.96)
	event.set_object_sequence_rotation(0, 0.0, 1.58, 0.0)
	event.fade_in_screen(30)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.move_object_sequence(0, -778.4, 0.0, -836.7, 60)
	event.move_camera_sequence_eased(-625.66, 104.24, -868.06, -778.4, 20.0, -836.7, 48, 2, 0.4)
	wait_frames(60)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.reset_follow_camera(0)
end

return helper_6fc8ed77
