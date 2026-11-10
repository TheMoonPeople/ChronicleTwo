--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_aedd1ee8(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Davvero? Hai bisogno di una mano?<page>Lascia che ti ponga un quesito.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Le candele nella chiesa sono\ngestite da un piccolo meccanismo.<page>Se sono accese le spegne\ne se sono spente le accende.<page>Se una di loro cambia,\nanche le candele accanto cambiano."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Se sarai cos[UNI00ec] saggio da spegnere\ntutte le candele, verr[UNI00f2] con te.<page>Se ci riesci, bene! Senn[UNI00f2], cerca\ndi capire: non posso aiutarti!"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Ecco un altro enigma. Fai\n   qualche tentativo e sfrutta\n   quel che apprendi ogni volta."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Se rientri in chiesa, le\n   candele tornano come prima.\n   Quindi non temere, se sbagli.\n   La risposta [UNI00e8] semplice."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

return helper_aedd1ee8
