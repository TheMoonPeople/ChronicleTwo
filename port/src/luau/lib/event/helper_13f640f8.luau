--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_13f640f8(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Ah, das passt ja bestens!\nIch wollte mit dir reden.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Du wei[UNI00df]t ja sicher, dass\nich f[UNI00fc]r meine Forschungen auch\nS[UNI00fc][UNI00df]igkeiten aus aller Welt mache."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Es gibt ein Gericht\nnamens Castagnaccio,")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "f[UNI00fc]r das man Castarna braucht.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Diese Castarna wachsen\nauf den gleichen\nB[UNI00e4]umen wie Kastanien.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Da dachte ich, ich nehme einfach\nKastanien, aber es ist\nmerkw[UNI00fc]rdig - die sind [UNI00fc]berall ausverkauft."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Der B[UNI00fc]rgermeister soll alle\ngekauft haben. Kannst du mir helfen?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
	event.set_quest_request(0, 3, 1)
end

return helper_13f640f8
