--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_0acb43ef(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mit Maschinen kennst du dich\naus, aber willst du nicht langsam\nmal etwas [UNI00fc]ber Bergbau lernen?"
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_0acb43ef
