--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")

--- Helper function.
local function helper_c0e39287(arg0: any)
	event.set_camera_sequence_position(-281.2, 51.82, -2024.16)
	event.set_camera_sequence_look_at(-258.93, 59.56, -1963.26)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, -247.36, 36.72, -1936.73)
	event.set_object_sequence_rotation(1, 0.0, -0.08, 0.0)
	event.set_object_sequence_motion(1, "腰に手L", 4)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -257.07, 36.72, -1857.99)
	event.set_object_sequence_rotation(2, 0.0, -3.12, 0.0)
	event.set_object_sequence_motion(2, "会話", 4)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -281.38, 36.72, -1863.87)
	event.set_object_sequence_rotation(3, 0.0, 2.8, 0.0)
	event.set_object_sequence_motion(3, "会話", 4)
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(1090250)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(2, "口パク")
	helper_4116e6bb(1090260)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(3, "口パク")
	helper_4116e6bb(1090270)
	event.reset_mouth_texture_animations()
end

return helper_c0e39287
