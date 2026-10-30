--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_dce2dfeb(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Ya veo... Me gustar[UNI00ed]a\npoder ayudaros, de verdad.\nM[UNI00e1]s que nada.<page>Pero no tengo ninguna\nconfianza en m[UNI00ed] misma."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Siempre me rindo antes de tiempo\ny nunca he hecho nada hasta el final.<page>Cuando era peque[UNI00f1]a, so[UNI00f1]aba con convertirme en sastre\ne intent[UNI00e9] hacer algo muchas veces,\npero nunca termin[UNI00e9] ninguna prenda."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Si os acompa[UNI00f1]ara, estoy segura\nde que molestar[UNI00ed]a.<page>Perdonad, pero no.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Vaya por Dios, Adel ha perdido\ntoda su confianza. Eso no es nada bueno. Hay\n que lograr que haga ropa otra vez."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

return helper_dce2dfeb
