--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_aa53c510 = require("@lib/event/helper_aa53c510")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_b4bd3a08(arg0: s32)
	event.CmrsSetPos(-0.92, 28.84, -32.55)
	event.CmrsSetRef(-0.27, 28.03, 22.59)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -0.66, 0.0, 123.46)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -0.66, 0.0, 123.46)
	event.ObjsSetRot(3, 0.0, -3.14, 0.0)
	event.SndSePlay(arg0, 3)
	event.ObjsSetMotion(1, "ドア開け", 6)
	event.ObjsSetMotion(3, "ドア開け", 6)
	event.ObjsMotionWait(1)
	event.ObjsMotionWait(3)
	event.CmrsPrdelay(60)
	event.CmrsSetPos(9.38, 26.8, 22.17)
	event.CmrsSetRef(10.04, 25.99, 77.32)
	helper_aa53c510(arg0, 160)
	helper_0958ca60(1)
	helper_0958ca60(3)
	helper_c624bc16()
end

return helper_b4bd3a08
