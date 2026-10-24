--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_d251141b = require("@lib/event/helper_d251141b")

--- Helper function.
local function helper_c6718a83(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Grrr, grrr..")
	helper_d251141b(arg0)
	event.MesMake_2(0, "...1212,<page>No, no. Seguro que era 1122.<page>[UNI00bf]O era 1010?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Grrr, grrr..")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		'[(!)]Si ni siquiera se ha enterado\n de que le has dicho "hola".Debe de\ntener problemas graves.<page>[(!)][UNI00bf]Por qu[UNI00e9] no pruebas despu[UNI00e9]s?\n A lo mejor le puedes echar una mano\n o escucharle o algo.'
	)
	helper_9e7d1511(0, -1, 8, 0, 0)
	event.SetMesPreset(0, 0)
end

return helper_c6718a83
