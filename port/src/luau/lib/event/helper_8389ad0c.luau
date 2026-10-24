--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")

--- Helper function.
local function helper_8389ad0c()
	helper_125385ee(1, 7)
	event.SetMesPreset(1, 2)
	event.MesMake_2(1, "Anhalten mit (O).")
	helper_82705ce2(1, -1, 15, 0, 0)
end

return helper_8389ad0c
