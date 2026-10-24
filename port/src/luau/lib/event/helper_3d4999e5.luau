--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_3d4999e5(arg0: s32)
	event.CmrsSetPos(-3.62, 25.14, -51.33)
	event.CmrsSetRef(12.22, 28.93, -35.31)
	event.ObjsSetPos(1, 12.17, 5.43, -29.98)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.SndSePlay(arg0, 3)
	event.ObjsSetMotion(1, "バカもん！", 6)
	event.ObjsNextMotion(1, "バカもん！L", 6)
	event.ObjsNextMotion(1, "バカもん！戻り", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_e34416e2(1090130)
	event.ResetPakuAnim()
	helper_0958ca60(1)
	event.SetPakuAnim(1, "大口パク")
	helper_e34416e2(1090131)
	event.ResetPakuAnim()
	helper_0958ca60(1)
end

return helper_3d4999e5
