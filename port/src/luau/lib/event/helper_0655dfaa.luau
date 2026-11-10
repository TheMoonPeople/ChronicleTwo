--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_0655dfaa(arg0: any, arg1: any)
	event.set_camera_sequence_position(-38.62, 34.71, -174.94)
	event.set_camera_sequence_look_at(37.54, 15.45, -157.32)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, 16.25, -0.02, -166.37)
	event.set_object_sequence_rotation(0, 0.0, 1.16, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_character_active(1, 32)
	event.set_object_sequence_motion(1, "腰に手L", 4)
	event.set_character_active(1, 25)
	wait_frames(30)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050330)
	event.reset_mouth_texture_animations()
end

return helper_0655dfaa
