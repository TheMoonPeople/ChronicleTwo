--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_e2a5293f(arg0: any)
	event.SetCameraPos(-393.89, 100.04, -2.57)
	event.SetCameraRef(-194.23, 107.31, -159.8)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CmrsMove2(-393.89, 100.04, -2.57, -266.2, 107.31, 189.14, 150, 0, 0.4)
	helper_c624bc16()
end

return helper_e2a5293f
