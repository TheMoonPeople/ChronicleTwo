--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_a3aca423(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"[UNI00c8] fondamentale negli affari\navere la fiducia dei tuoi clienti.<page>Non devi mai darla\nper scontata!"
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_a3aca423
