--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_e9e764a3(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Ja, wenn ich's wieder versuche\nund diesmal etwas schaffe,\nk[UNI00f6]nnte ich wieder an mich glauben."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Aber ich habe keine Materialien.<page>K[UNI00f6]nntest du sie mir holen?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Ich brauche nur starken\nStoff, Tierhaut und einen\nKupferklumpen.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
	event.set_save_counter(8, 1)
end

return helper_e9e764a3
