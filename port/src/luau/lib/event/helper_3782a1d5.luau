--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_3782a1d5(arg0: any)
	event.CmrsSetPos(-24.3, 23.42, -18.85)
	event.CmrsSetRef(2.59, 28.72, -60.25)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, 0.65, 5.43, -39.63)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "下向き立ち", 4)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(1090060)
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "通常口パク")
	helper_e34416e2(1090070)
	event.ResetPakuAnim()
end

return helper_3782a1d5
