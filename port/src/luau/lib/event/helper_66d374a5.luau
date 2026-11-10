--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")

--- Helper function.
local function helper_66d374a5(arg0: any)
	event.set_character_active(0, 33)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "ぼうぜん顔")
	event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
	event.set_camera_sequence_position(8.87, 61.22, 40.34)
	event.set_camera_sequence_look_at(2.69, 59.0, 20.67)
	event.move_camera_sequence_eased(7.72, 61.22, 36.68, 2.69, 59.0, 20.67, 450, 2, 0.4)
	helper_4116e6bb(2030030)
	helper_4116e6bb(2030040)
	event.play_music(0)
end

return helper_66d374a5
