--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_c86b34db(se_id: s32)
	event.set_character_active(0, 11)
	event.set_character_active(1, 35)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
	event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
	event.play_sound_effect(se_id, 6)
	event.set_object_sequence_motion(0, "振り返る", 6)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "振り返るL", 0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_motion(3, "立ち", 4)
	wait_frames(23)
end

return helper_c86b34db
