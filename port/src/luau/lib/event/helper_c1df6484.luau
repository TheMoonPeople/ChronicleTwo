--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_c1df6484()
	event.set_object_sequence_motion(0, "上向く会話", 2)
	event.queue_object_sequence_next_motion(0, "上向くL", 4)
	helper_4116e6bb(2850030)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.set_object_sequence_motion(1, "歩き", 4)
	event.rotate_object_sequence(0, 0.0, 0.2, 0.0, 15)
	event.rotate_object_sequence(1, 0.0, 0.0, 0.0, 15)
	wait_frames(15)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(30)
	event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 120)
	event.add_object_sequence_path_point(0, 13.4, 6.52, 613.7)
	event.add_object_sequence_path_point(0, 16.54, 2.3, 632.93)
	event.add_object_sequence_path_point(0, 19.85, -3.85, 662.84)
	event.add_object_sequence_path_point(0, 22.02, -8.04, 684.68)
	event.add_object_sequence_path_point(0, 24.22, -12.54, 709.74)
	event.add_object_sequence_path_point(0, 26.96, -12.32, 737.33)
	event.start_object_sequence_path(0)
	event.clear_object_sequence_path(1)
	event.set_object_sequence_path_frames(1, 120)
	event.add_object_sequence_path_point(1, 47.24, 7.54, 600.38)
	event.add_object_sequence_path_point(1, 49.86, 2.84, 624.2)
	event.add_object_sequence_path_point(1, 51.55, -2.15, 651.95)
	event.add_object_sequence_path_point(1, 52.91, -6.17, 674.31)
	event.add_object_sequence_path_point(1, 55.85, -12.79, 722.8)
	event.start_object_sequence_path(1)
	wait_frames(60)
end

return helper_c1df6484
