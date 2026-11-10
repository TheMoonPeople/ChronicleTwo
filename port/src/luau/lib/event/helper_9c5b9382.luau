--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_9c5b9382()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 2123.53, 0.0, -172.9)
	event.set_object_sequence_rotation(0, 0.0, -1.54, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(2113.85, 58.0, -172.0)
	event.set_camera_sequence_look_at(1961.18, 30.0, -219.86)
	event.set_object_sequence_position(0, 2084.3, 0.0, -181.26)
	event.set_object_sequence_rotation(0, 0.0, -1.87, 0.0)
	event.move_object_sequence(0, 1961.18, 0.0, -219.86, 40)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.delay_object_sequence_motion_track(0, 40)
	event.set_object_sequence_motion(0, "立ち")
	event.fade_in_screen(15)
	wait_frames(50)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

return helper_9c5b9382
