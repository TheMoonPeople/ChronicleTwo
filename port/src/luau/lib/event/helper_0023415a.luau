--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_0023415a(arg0: any)
	event.CmrsSetPos(-281.2, 51.82, -2024.16)
	event.CmrsSetRef(-258.93, 59.56, -1963.26)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -247.36, 36.72, -1936.73)
	event.ObjsSetRot(1, 0.0, -0.08, 0.0)
	event.ObjsSetMotion(1, "腰に手L", 4)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -257.07, 36.72, -1857.99)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(2, "会話", 4)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -281.38, 36.72, -1863.87)
	event.ObjsSetRot(3, 0.0, 2.8, 0.0)
	event.ObjsSetMotion(3, "会話", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_e34416e2(1090250)
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク")
	helper_e34416e2(1090260)
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_e34416e2(1090270)
	event.ResetPakuAnim()
end

return helper_0023415a
