--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_c35aab18(arg0: s32)
	event.CmrsSetPos(-1.63, 28.5, -58.54)
	event.CmrsSetRef(-1.54, 28.17, -29.76)
	event.SetCharaPos(33, -1.6, 4.14, -22.85)
	event.SetCharaRot(33, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(1, "腕組み", 4)
	helper_0958ca60(1)
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(1090100)
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "腕組み会話", 6)
	event.ObjsNextMotion(1, "腕組み", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(1090110)
	event.ResetPakuAnim()
	helper_0958ca60(1)
end

return helper_c35aab18
