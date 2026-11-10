--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_7316cce2(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Si necesitas algo,\nhar[UNI00e9] lo que pueda para ayudarte.<page>T[UNI00fa] d[UNI00e9]jame a m[UNI00ed]."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "No s[UNI00e9] si podr[UNI00e1]s solucionar algo,<page>pero escucha.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Me he tirado 30 a[UNI00f1]os trabajando\ncomo un mulo en esta casa.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Es todo lo que hago, pero\nmi afici[UNI00f3]n es la lectura.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "En estos momentos est[UNI00e1]n subastando\nun libro muy valioso.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "La gente se pega por [UNI00e9]l.\nCreo que con una oferta\nde 1000 Gildas bastar[UNI00ed]a.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Yo no dispongo de ese dinero y, si se\nlo pidiera a mi maestro, se escandalizar[UNI00ed]a y\nseguramente me echar[UNI00ed]a."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Eres mi [UNI00fa]nica esperanza.<page>Pero no quiere decir\nque si no me ayudas yo no vaya a echarte una mano."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]A pesar de lo que diga, Stewart seguramente\n no te ayudar[UNI00e1] si no le consigues 1000 Gildas.\n En fin, ser[UNI00e1] mejor que empieces a ahorrar."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

return helper_7316cce2
