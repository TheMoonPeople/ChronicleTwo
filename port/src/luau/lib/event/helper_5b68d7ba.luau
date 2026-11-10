--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")

--- Helper function.
local function helper_5b68d7ba(se_id: s32)
	event.set_camera_sequence_position(-211.94, 92.54, -16.62)
	event.set_camera_sequence_look_at(-237.74, 91.77, -7.1)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -245.08, 50.51, -6.05)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -245.08, 50.51, -6.05)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.stop_sound_effect(se_id, 0)
	helper_4116e6bb(1070020)
end

return helper_5b68d7ba
