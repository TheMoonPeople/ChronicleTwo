--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")

--- Helper function.
local function helper_dd489924(arg0: s32)
	event.CmrsSetPos(-185.33, 99.15, 43.77)
	event.CmrsSetRef(13.63, 115.02, 19.38)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 10.66, 50.0, -0.04)
	event.ObjsSetRot(2, 0.0, -1.32, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 35.03, 189.68, 41.92)
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(3, "浮遊", 4)
	event.ObjsMove(3, 35.03, 137.05, 41.92, 100)
	helper_0958ca60(3)
end

return helper_dd489924
