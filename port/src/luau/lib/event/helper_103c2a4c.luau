--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_103c2a4c(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Bah, no me importa acompa[UNI00f1]arte,\npero... [UNI00bf]Hay luna en el lugar al que vamos?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "[UNI00bf]De verdad? A lo mejor te lo inventas.\nS[UNI00e9] que los humanos mienten.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"En realidad he cambiado de opini[UNI00f3]n.\nEsperar[UNI00e9] aqu[UNI00ed] a que salga la luna."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Quiz[UNI00e1] se deba a alg[UNI00fa]n suceso pasado,\npero Rufio no se f[UNI00ed]a\n nada de los humanos."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tienes que conseguir que Rufio\nte crea. Si le dieras una\nfoto de la luna quiz[UNI00e1] lo lograr[UNI00ed]as."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

return helper_103c2a4c
