--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_d76e7d26(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Zurzeit bin ich hier Magd,\naber seit meiner Kindheit tr[UNI00e4]ume\nich davon, Schneiderin zu werden."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Tr[UNI00e4]ume werden nie wahr,\ndeshalb nenne ich es einen Traum.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_d76e7d26
