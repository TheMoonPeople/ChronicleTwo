--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_207a478f(arg0: any)
	event.CmrsSetPos(17.24, 26.0, -9.56)
	event.CmrsSetRef(5.22, 26.46, -42.09)
	event.ObjsSetPos(1, -4.35, 5.29, -42.32)
	event.ObjsSetRot(1, 0.0, 2.92, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "下見向き立ち", 4)
	helper_0958ca60(1)
	helper_0958ca60(2)
	event.SetPakuAnim(2, "通常口パク")
	helper_e34416e2(1090140)
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_e34416e2(1090150)
	event.ResetPakuAnim()
	helper_e34416e2(1090160)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_e34416e2(1090170)
	event.ResetPakuAnim()
	helper_0958ca60(1)
end

return helper_207a478f
