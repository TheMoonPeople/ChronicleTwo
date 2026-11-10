--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_78df2e5b(arg0: any)
	event.set_camera_sequence_position(-350.38, 95.45, -59.38)
	event.set_camera_sequence_look_at(-418.26, 93.83, -69.21)
	event.set_object_sequence_motion(0, "上見戻り", 6, 0.06)
	event.set_object_sequence_motion(1, "上見戻り", 6, 0.06)
	event.wait_object_sequence_motion_end(0)
	event.wait_object_sequence_motion_end(1)
	wait_objects(0)
	wait_objects(1)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4, -1.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4, -1.0)
	event.move_camera_sequence_eased(-376.98, 95.45, -63.23, -418.26, 93.83, -69.21, 150, 2, 0.4)
	helper_4116e6bb(1080030)
	helper_4116e6bb(1080033)
	wait_camera()
end

return helper_78df2e5b
