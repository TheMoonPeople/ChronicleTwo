--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_10779a34(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Qualunque cosa vi serva, far[UNI00f2]\ndel mio meglio per aiutarvi.<page>Lasciate fare a me.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Non so se potete aiutarmi...<page>Comunque ascoltate.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Sono 30 anni che lavoro\nsodo in questa casa.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Il lavoro [UNI00e8] la mia vita, ma\nun hobby ce l’ho: la lettura.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "C'[UNI00e8] un libro raro e prezioso,\nora in vendita all'asta.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "La gente fa a botte per averlo.\nCredo che un'offerta di circa\n1000 Gilda possa bastare.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Non ho tanto denaro e, se lo\nchiedessi al padrone, andrebbe su tutte\nle furie e io dovrei andarmene."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Siete la mia unica speranza.<page>Ma questo non significa che se\nnon mi aiutate io non aiuter[UNI00f2] voi."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Malgrado le sue parole, Stewart non vi\n   aiuter[UNI00e0] se non gli darete 1000 Gilda.\n   Bisogner[UNI00e0] racimolare soldi!"
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

return helper_10779a34
