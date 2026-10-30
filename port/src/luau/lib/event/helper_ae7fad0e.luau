--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_ae7fad0e()
	event.set_camera_sequence_position(1.94, 46.13, 182.69)
	event.set_camera_sequence_look_at(0.3, 9.85, 111.43)
	helper_4116e6bb(4120320)
	event.set_camera_sequence_position(12.38, 21.89, 126.92)
	event.set_camera_sequence_look_at(0.56, 16.44, 101.56)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	helper_4116e6bb(4120330)
	helper_4116e6bb(4120335)
	wait_objects(2)
	event.set_camera_sequence_position(0.07, 37.81, 61.37)
	event.set_camera_sequence_look_at(0.86, 4.93, 133.5)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	helper_4116e6bb(4120340)
	wait_objects(2)
	event.set_object_sequence_motion(0, "オズ見会話", 6)
	event.queue_object_sequence_next_motion(0, "オズ見立ち", 4)
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(4120350)
	wait_objects(0)
end

return helper_ae7fad0e
