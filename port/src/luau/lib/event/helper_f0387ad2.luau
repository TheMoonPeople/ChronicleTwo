--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_f0387ad2(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Il negozio [UNI00e8] chiuso. Dovrai andare\nin quello del mio vecchio.<page>Cerca le zucche, non puoi sbagliare!\n[UNI00c8] proprio in cima a quella scala."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_f0387ad2
