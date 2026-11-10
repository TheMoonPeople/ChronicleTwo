--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_4076b655(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Capisco...vorrei\npotervi aiutare... davvero!\nPi[UNI00f9] di qualsiasi altra cosa.<page>Ma non ho alcuna\nfiducia in me stessa."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Mi arrendo sempre a met[UNI00e0] strada e\nnon porto mai a termine nulla.<page>Da bambina, sognavo di fare la\nsarta, ma iniziavo sempre a fare\nvestiti, senza mai finirli."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Sono sicura che se venissi con\nvoi, sarei solo d'impaccio.<page>Quindi, mi spiace: dico di no."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh, Adel non ha fiducia in\n   s[UNI00e9], e non va bene. Facciamole\n   tornare la voglia di cucire!"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

return helper_4076b655
