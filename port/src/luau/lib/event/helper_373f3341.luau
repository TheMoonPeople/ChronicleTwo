--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_373f3341(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Hai fatto qualche nuova scoperta?<page>Sai, mentre tu fai esperimenti\nsu macchine e strumenti,\nio faccio esperimenti di cucina.<page>Ogni giorno provo dei\npiatti deliziosi, che nessuno\nha mai assaggiato prima."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_373f3341
