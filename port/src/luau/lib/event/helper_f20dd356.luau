--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_f20dd356(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Das Wichtigste in diesem Gesch[UNI00e4]ft\nist das Vertrauen der Kunden.<page>Das darf man nie\neinfach voraussetzen."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_f20dd356
