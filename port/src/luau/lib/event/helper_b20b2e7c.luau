--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_b20b2e7c(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Wenn du Probleme hast,\nfrag ruhig immer mich.")
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_b20b2e7c
