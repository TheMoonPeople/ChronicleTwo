--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_fb2b6b13 = require("@lib/event/helper_fb2b6b13")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_fe1b9147(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_fb2b6b13(arg1, arg0)
	event.open_message_window_2(0, "Grrr, grrr..")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir con\neso de que qu[UNI00e9] estoy murmullando?<page>Estoy intentando\nrecordar la combinaci[UNI00f3]n de la caja fuerte."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir?\n[UNI00bf]Qu[UNI00e9] caja?<page>La caja fuerte escondida\ndetr[UNI00e1]s del cuadro de mi despacho, claro..."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	helper_fb2b6b13(arg0, arg1)
	event.set_character_motion(arg0, "会話")
	event.open_message_window_2(
		0,
		"[UNI00a1]Ah, qu[UNI00e9] susto!<page>[UNI00a1]Porras!<page>Me he ido y he desvelado\nmi mayor secreto.<page>Bueno, ya lo sabes.<page>A lo mejor me puedes\nechar una mano."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Tengo muchos problemas\nporque he olvidado\nla combinaci[UNI00f3]n de la caja fuerte.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Es un n[UNI00fa]mero de\n4 d[UNI00ed]gitos. Us[UNI00e9]\nla fecha de nacimiento de Claire\npara no olvidarme nunca."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "[UNI00bf]C[UNI00f3]mo lo habr[UNI00e9] olvidado?<page>Vaya padre soy...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]El alcalde parece muy preocupado.\n Escucha lo que te dice sobre\nel cumplea[UNI00f1]os de Claire y trata de descifrar la combinaci[UNI00f3]n."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

return helper_fe1b9147
