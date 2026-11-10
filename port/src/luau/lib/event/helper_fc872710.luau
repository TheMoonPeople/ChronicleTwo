--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")

--- Helper function.
local function helper_fc872710(se_id: s32)
	event.play_sound_effect(se_id, 0)
	event.set_camera_sequence_position(39.97, 95.45, -42.29)
	event.set_camera_sequence_look_at(-401.26, 72.44, 58.46)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -167.59, 50.0, 2.86)
	event.set_object_sequence_rotation(0, 0.0, 1.77, 0.0)
	event.set_object_sequence_motion(0, "勝利のポーズ", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -167.59, 50.0, 2.86)
	event.set_object_sequence_rotation(1, 0.0, 1.77, 0.0)
	event.set_object_sequence_motion(1, "勝利のポーズ", 4)
	event.set_character_active(0, 10)
	event.move_camera_sequence_eased(-117.38, 95.45, -6.36, -401.26, 72.44, 58.46, 20, 2, 0.4)
	wait_camera()
end

return helper_fc872710
