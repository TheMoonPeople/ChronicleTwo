--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_29d0ac90(arg0: any)
	event.set_camera_sequence_position(24.93, 29.64, -79.63)
	event.set_camera_sequence_look_at(-8.31, 36.32, -96.0)
	event.set_object_sequence_position(2, 0.05, 10.14, -94.36)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_texture_animation(2, 0)
	event.set_object_sequence_texture_animation(2, 1, "目とじ～目あけ")
	event.set_object_sequence_motion(2, "前を見る", 2)
	event.queue_object_sequence_next_motion(2, "前を見るL")
	wait_objects(2)
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090240)
	event.reset_mouth_texture_animations()
	vm.wait(3)
end

return helper_29d0ac90
