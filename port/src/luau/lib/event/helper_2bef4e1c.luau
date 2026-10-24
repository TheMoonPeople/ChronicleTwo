--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Helper function.
local function helper_2bef4e1c(arg0: s32)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CmrsSetPos(-333.13, 124.81, -2141.66)
	event.CmrsSetRef(-142.51, 84.44, -1891.87)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSePlay(arg0, 13)
	event.ObjsMove2(10, -120.0, 0.0, -2100.0, 60, 1, 1.0)
	helper_25abe6d2(60)
end

return helper_2bef4e1c
