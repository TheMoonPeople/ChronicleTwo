--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_7b4134af(arg0: s32)
	event.CmrsSetPos(57.23, 251.57, 242.48)
	event.CmrsSetRef(21.23, 241.82, 43.83)
	event.CharaActive(1, 36)
	event.SetCharaPos(36, 266.91, 197.74, 696.65)
	event.SetCharaRot(36, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(4, "前を見るL", 4)
	event.ObjsMove(10, -120.0, 0.0, -6000.0, 120)
	helper_25abe6d2(30)
	event.CmrsMoveAhd2(-2.57, 9.27, 80.0, 120, 0, 0.4)
	helper_c624bc16()
	event.SndSeStop(arg0, 9)
end

return helper_7b4134af
