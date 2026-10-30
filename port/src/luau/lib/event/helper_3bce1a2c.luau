--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")

--- Helper function.
local function helper_3bce1a2c(se_id: s32)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -167.59, 50.0, 2.86)
	event.set_object_sequence_rotation(0, 0.0, 1.77, 0.0)
	event.set_object_sequence_motion(0, "勝利のポーズ", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -167.59, 50.0, 2.86)
	event.set_object_sequence_rotation(1, 0.0, 1.77, 0.0)
	event.set_object_sequence_motion(1, "勝利のポーズ", 4)
	event.set_mouth_texture_animations(0, "わらい口パク")
	helper_4116e6bb(1080010)
	event.reset_mouth_texture_animations()
	event.stop_sound_effect(se_id, 0)
end

return helper_3bce1a2c
