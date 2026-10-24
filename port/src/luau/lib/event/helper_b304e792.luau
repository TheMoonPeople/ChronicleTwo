--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_b304e792(arg0: any)
	event.CmrsSetPos(-13.07, 25.09, -70.71)
	event.CmrsSetRef(1.86, 31.3, -95.34)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "立ちあがるL", 4)
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_e34416e2(1090040)
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ため息", 6)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "下向き立ち")
	event.SetPakuAnim(2, "通常口パク")
	helper_e34416e2(1090050)
	event.ResetPakuAnim()
	helper_0958ca60(2)
end

return helper_b304e792
