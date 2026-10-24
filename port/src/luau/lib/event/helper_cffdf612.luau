--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_cffdf612(arg0: any)
	local var1: f32 = 0
	event.CmrsSetPos(1.35, 30.21, -27.45)
	event.CmrsSetRef(0.24, 29.22, -88.19)
	event.GetProjection() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.SetProjection(950.9)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "座り", 4)
	event.CharaActive(0, 35)
	event.EohSetShow(13, 1)
	event.ObjsSetMotion(2, "立ちあがる", 6)
	event.ObjsNextMotion(2, "立ちあがるL")
	helper_0958ca60(2)
	event.SetPakuAnim(2, "通常口パク")
	helper_e34416e2(1090010)
	event.ResetPakuAnim()
	event.SetProjection(var1)
end

return helper_cffdf612
