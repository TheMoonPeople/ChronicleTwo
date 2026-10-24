--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_9a91aa45(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mi tienda est[UNI00e1]\nespecializada en espadas.<page>Tengo pistolas,\npero las armas de fuego\nno son lo m[UNI00ed]o."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_9a91aa45
