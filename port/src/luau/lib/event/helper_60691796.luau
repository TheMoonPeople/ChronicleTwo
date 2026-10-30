--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_84c07dcc = require("@lib/event/helper_84c07dcc")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_60691796(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Grrr, grrr..")
	helper_84c07dcc(arg0)
	event.open_message_window_2(0, "...1212,<page>No, no. Seguro que era 1122.<page>[UNI00bf]O era 1010?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Grrr, grrr..")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		'[(!)]Si ni siquiera se ha enterado\n de que le has dicho "hola".Debe de\ntener problemas graves.<page>[(!)][UNI00bf]Por qu[UNI00e9] no pruebas despu[UNI00e9]s?\n A lo mejor le puedes echar una mano\n o escucharle o algo.'
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

return helper_60691796
