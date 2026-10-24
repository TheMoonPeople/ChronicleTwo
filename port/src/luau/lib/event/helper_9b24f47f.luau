--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_9b24f47f(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "The Firbit people will only\ngrant favours to people who are\nmore skilled than themselves.")
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_9b24f47f
