--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_9bde0a9a(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"...<page>[UNI00a1]Ah! [UNI00a1]Hola!\n[UNI00da]ltimamente no oigo muy bien.<page>No te entiendo si no\nme hablas m[UNI00e1]s despacio."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_9bde0a9a
