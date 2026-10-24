--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_a4d18817 = require("@lib/event/helper_a4d18817")

--- Helper function.
local function helper_e631fe2d(arg0: s32)
	event.CmrsSetPos(-49.42, 28.58, -9.71)
	event.CmrsSetRef(5.37, 27.75, -69.7)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -3.78, 5.43, -7.31)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "立ちあがるL", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 69)
	event.ObjsSetMotion(1, "立ち", 2)
	event.ObjsMove(1, 1.5, 5.43, -38.55, 70)
	helper_a4d18817(arg0, 70)
	helper_25abe6d2(5)
end

return helper_e631fe2d
