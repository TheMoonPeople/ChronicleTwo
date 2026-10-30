--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_f3a279da(arg0: any)
	event.set_camera_sequence_position(-245.6, 62.76, -1902.65)
	event.set_camera_sequence_look_at(-246.75, 59.85, -1937.73)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, -247.36, 36.72, -1936.73)
	event.set_object_sequence_rotation(1, 0.0, 0.04, 0.0)
	event.play_music(1)
	event.set_object_sequence_motion(1, "出発じゃ！", 6)
	event.queue_object_sequence_next_motion(1, "出発じゃ！L", 2)
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(1090310)
	event.reset_mouth_texture_animations()
	wait_objects(1)
end

return helper_f3a279da
