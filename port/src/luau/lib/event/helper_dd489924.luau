--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_dd489924(se_id: s32)
	event.set_camera_sequence_position(-185.33, 99.15, 43.77)
	event.set_camera_sequence_look_at(13.63, 115.02, 19.38)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 10.66, 50.0, -0.04)
	event.set_object_sequence_rotation(2, 0.0, -1.32, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.set_object_sequence_motion(2, "立ち", 4)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 35.03, 189.68, 41.92)
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.play_sound_effect(se_id, 6)
	event.set_object_sequence_motion(3, "浮遊", 4)
	event.move_object_sequence(3, 35.03, 137.05, 41.92, 100)
	wait_objects(3)
end

return helper_dd489924
