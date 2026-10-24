--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_afb3d40c(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Angeln ist mein Hobby.<page>Ich tr[UNI00e4]ume davon, einmal einen\nMardan Garayan zu fangen.<page>Ich respektiere nur Leute,\ndie gro[UNI00df]e Fische fangen."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_afb3d40c
