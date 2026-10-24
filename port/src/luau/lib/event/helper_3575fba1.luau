--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_3575fba1(arg0: any)
	event.SetCrossfade(1, 1, 60)
	event.CmrsSetPos(14.46, 268.16, 737.45)
	event.CmrsSetRef(-30.4, 237.84, 510.02)
	event.CmrsMove2(-72.53, 268.16, 754.61, -117.4, 237.84, 527.18, 120, 2, 0.4)
	helper_c624bc16()
	event.StopBgm(0)
	helper_25abe6d2(4)
	event.LoadBgm(193)
end

return helper_3575fba1
