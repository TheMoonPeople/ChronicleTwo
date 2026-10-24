--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_82705ce2 = require("@lib/event/helper_82705ce2")

--- Helper function.
local function helper_b0ba06d3()
	event.SetMesWindowMode(1, 7)
	event.SetMesPreset(1, 2)
	event.MesMake_2(1, "(O)でストップ")
	helper_82705ce2(1, -1, 15, 0, 0)
end

return helper_b0ba06d3
