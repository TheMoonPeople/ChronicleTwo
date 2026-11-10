--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_718a1dd5(arg0: any)
	event.set_camera_sequence_position(-271.29, 59.56, -1912.06)
	event.set_camera_sequence_look_at(-269.4, 60.62, -1886.34)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -257.07, 36.72, -1857.99)
	event.set_object_sequence_rotation(2, 0.0, -3.12, 0.0)
	event.set_object_sequence_motion(2, "立ち", 4)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -281.38, 36.72, -1863.87)
	event.set_object_sequence_rotation(3, 0.0, 2.92, 0.0)
	event.set_object_sequence_motion(3, "ボルネオを見る", 6)
	event.queue_object_sequence_next_motion(3, "ボルネオを見るL", 0)
	wait_objects(3)
	event.set_mouth_texture_animations(3, "口パク")
	helper_4116e6bb(1090280)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(2, "トムを見る", 2)
	event.queue_object_sequence_next_motion(2, "トムを見るL")
	event.set_mouth_texture_animations(2, "口パク")
	helper_4116e6bb(1090290)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(3, "了解っす", 6)
	event.set_mouth_texture_animations(3, "口パク")
	helper_4116e6bb(1090300)
	event.reset_mouth_texture_animations()
end

return helper_718a1dd5
