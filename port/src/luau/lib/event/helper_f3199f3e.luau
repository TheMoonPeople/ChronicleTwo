--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Helper function.
local function helper_f3199f3e(arg0: s32)
	event.CmrsSetPos(-326.52, 113.91, -1579.31)
	event.CmrsSetRef(-22.58, 118.56, -2134.59)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSeStop(arg0, 10)
	event.SndSePlay(arg0, 12)
	event.ObjsMove(11, -200.0, 0.0, 0.0, 285)
	event.ObjsMove(12, 200.0, 0.0, 0.0, 285)
	helper_0958ca60(11)
	helper_0958ca60(12)
	helper_25abe6d2(30)
end

return helper_f3199f3e
