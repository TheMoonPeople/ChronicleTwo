--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_2bef4e1c(se_id: s32)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.set_camera_sequence_position(-333.13, 124.81, -2141.66)
	event.set_camera_sequence_look_at(-142.51, 84.44, -1891.87)
	event.set_character_active(0, 33)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.play_sound_effect(se_id, 13)
	event.move_object_sequence_eased(10, -120.0, 0.0, -2100.0, 60, 1, 1.0)
	wait_frames(60)
end

return helper_2bef4e1c
