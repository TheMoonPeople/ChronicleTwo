--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_0c5f2e37()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 70)
	event.add_object_sequence_path_point(0, 2730.28, 163.23, 630.94)
	event.add_object_sequence_path_point(0, 2674.4, 138.96, 765.84)
	event.add_object_sequence_path_point(0, 2616.58, 125.16, 846.91)
	event.start_object_sequence_path(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(2590.33, 108.76, 1218.81)
	event.set_camera_sequence_look_at(2591.54, 130.16, 1030.59)
	event.fade_in_screen(15)
	wait_frames(40)
	event.fade_out_screen(15)
	wait_frames(15)
	event.set_object_handle_footstep_sound(0, 0)
	helper_9dafbc83(vm.f32(2358.3), 0.0, vm.f32(1357.7), vm.f32(0.06))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

return helper_0c5f2e37
