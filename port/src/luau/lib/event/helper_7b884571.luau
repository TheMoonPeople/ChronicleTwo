--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_fb2b6b13 = require("@lib/event/helper_fb2b6b13")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_7b884571(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_fb2b6b13(arg1, arg0)
	event.open_message_window_2(0, "Ronchonnements...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Comment [UNI00e7]a, qu'est-ce que\nj'ai [UNI00e0] marmonner ?<page>J'essaie de me souvenir de la\ncombinaison du coffre."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Comment [UNI00e7]a,\nquel coffre ? Celui<page>qui est cach[UNI00e9] derri[UNI00e8]re le tableau\ndans mon bureau, bien s[UNI00fb]r..."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	helper_fb2b6b13(arg0, arg1)
	event.set_character_motion(arg0, "会話")
	event.open_message_window_2(
		0,
		"Ah, tu m'as fait peur !<page>Oh, fl[UNI00fb]te !<page>Je viens de l[UNI00e2]cher\nmon plus gros secret !<page>Bon, tant pis !<page>Tu peux peut-[UNI00ea]tre m'aider\n[UNI00e0] l'ouvrir maintenant."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"J'ai un gros probl[UNI00e8]me, je\nn'arrive plus [UNI00e0] me souvenir\nde la combinaison du coffre."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Il y a 4 chiffres alors j'ai choisi\nla date de naissance de Claire\npour [UNI00ea]tre s[UNI00fb]r de pas l'oublier."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Comment ai-je pu oublier [UNI00e7]a...<page>Quel mauvais p[UNI00e8]re je fais !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Le Maire para[UNI00ee]t tr[UNI00e8]s ennuy[UNI00e9].\n   [UNI00c9]coute ses propos sur l'anniversaire\n   de Claire pour trouver la combinaison."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

return helper_7b884571
