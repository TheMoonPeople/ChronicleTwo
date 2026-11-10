--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_72a5f155()
	event.initialize_event()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -215.0, 12.66, 60.0)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "走り")
	event.set_object_sequence_texture_animation(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, -24.0, -1800.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_time_of_day(7.0)
	event.set_time_of_day_advancing(1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-746.57, 16.36, 156.44)
	event.set_camera_sequence_look_at(-199.21, 142.65, 471.29)
	wait_frames(30)
	event.move_camera_sequence(-701.67, 16.36, 428.3, -154.32, 142.65, 743.14, 400)
	event.move_object_sequence(0, -215.0, 12.66, 1700.0, 460)
	event.move_object_sequence(1, 0.0, -24.0, 5000.0, 260)
	wait_camera()
	helper_c956b4a2(64)
end

return helper_72a5f155
