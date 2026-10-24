--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_d2a24b1b(arg0: s32)
	event.CmrsSetPos(-211.94, 92.54, -16.62)
	event.CmrsSetRef(-237.74, 91.77, -7.1)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -245.08, 50.51, -6.05)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -245.08, 50.51, -6.05)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.ObjsResetDaPosition(0)
	event.SndSeStop(arg0, 0)
	helper_e34416e2(1070020)
end

return helper_d2a24b1b
