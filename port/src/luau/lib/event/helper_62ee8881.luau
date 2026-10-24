--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_62ee8881(arg0: s32)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsSetMotion(0, "上見立ち", 4, -1.0, 1)
	event.ObjsSetColor(13, 0.0, 0.0, 0.0, 15)
	helper_25abe6d2(15)
	event.SpriteSetDraw(3, 0)
	event.CmrsMove2(10.91, 58.61, 33.87, 1.64, 58.99, 18.19, 300, 2, 0.4)
	helper_e34416e2(2030090)
	event.ObjsTexAnime(0, 1, "眉真剣")
	helper_e34416e2(2030100)
	event.StopBgm(0)
	event.SndSePlay(arg0, 5)
	event.CmrsQuake(0.0, 0.8, 0.0, 45)
	helper_25abe6d2(45)
end

return helper_62ee8881
