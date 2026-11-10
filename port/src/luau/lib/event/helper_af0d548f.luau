--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_af0d548f(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Il negozio [UNI00e8] chiuso. Dovrai andare\nin quello del mio vecchio.<page>Cerca le zucche, non puoi sbagliare!\n[UNI00c8] proprio in cima a quella scala."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_af0d548f
