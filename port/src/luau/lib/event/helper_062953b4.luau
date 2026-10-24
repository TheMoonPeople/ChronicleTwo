--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_062953b4(arg0: s32)
	event.CmrsSetPos(79.6, 44.59, -39.31)
	event.CmrsSetRef(-7.3, 30.03, -86.44)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "座り", 4)
	helper_0958ca60(2)
	event.SetFadeIn(30)
	event.SndSePlay(arg0, 2)
	helper_25abe6d2(66)
	event.CmrsMove2(79.6, 44.59, -39.31, 39.97, 30.03, 52.15, 90, 2, 0.4)
	helper_c624bc16()
end

return helper_062953b4
