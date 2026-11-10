--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_cc653a3e(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Je vois... J'aimerais vraiment\npouvoir t'aider.\nTu le sais.<page>Mais je n'ai vraiment pas\nassez confiance en moi."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"J'abandonne toujours tout [UNI00e0] mi-\nchemin, je n'ai jamais rien fini.<page>J'ai toujours voulu devenir\ncouturi[UNI00e8]re, mais je n'ai jamais\ntermin[UNI00e9] un seul v[UNI00ea]tement."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Si je venais avec toi,\nje ne ferais que t'emb[UNI00ea]ter.<page>Alors, d[UNI00e9]sol[UNI00e9]e, mais c'est non."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh non, Ad[UNI00e8]le a perdu toute\n   confiance en elle. C'est un probl[UNI00e8]me.\n   Faisons-lui faire de nouveaux habits."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

return helper_cc653a3e
