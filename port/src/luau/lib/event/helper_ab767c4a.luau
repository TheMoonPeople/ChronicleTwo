--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_ab767c4a()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.initialize_event()
	flag = event.get_save_flag(208) or flag
	flag_2 = event.get_save_flag(207) or flag_2
	if not (flag == 0 and flag_2 == 1) then
		event.clear_camera_sequence()
		event.set_camera_sequence_position(324.12, 34.59, 830.75)
		event.set_camera_sequence_look_at(362.46, 42.77, 960.05)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 404.68, 0.0, 1124.89)
		event.set_object_sequence_rotation(0, 0.0, -2.84, 0.0)
		event.move_camera_sequence_eased(324.12, 34.59, 830.75, 377.85, 23.14, 1003.73, 48, 2, 0.25)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_object_sequence(0, 361.74, 0.0, 957.26, 60)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
		wait_frames(60)
		event.reset_follow_camera(0)
	end
end

return helper_ab767c4a
