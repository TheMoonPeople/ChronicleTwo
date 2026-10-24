--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_54bbe647(arg0: any)
	event.CmrsSetPos(212.25, 205.2, 623.4)
	event.CmrsSetRef(236.71, 212.83, 651.45)
	event.ObjsSetPos(4, 258.83, 197.74, 677.01)
	event.ObjsSetRot(4, 0.0, -3.0, 0.0)
	event.ObjsSetMotion(4, "前を見るL", 4)
	helper_0958ca60(4)
	event.SetPakuAnim(4, "口パク")
	helper_e34416e2(1090320)
	event.ResetPakuAnim()
	event.CmrsInit()
	event.CmrsFadeOut(100, 0.0, 0.0, 0.0)
	helper_c624bc16()
end

return helper_54bbe647
