--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_bc7aeb92(arg0: any)
	event.CharaActive(0, 33)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ぼうぜん顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.CmrsSetPos(8.87, 61.22, 40.34)
	event.CmrsSetRef(2.69, 59.0, 20.67)
	event.CmrsMove2(7.72, 61.22, 36.68, 2.69, 59.0, 20.67, 450, 2, 0.4)
	helper_e34416e2(2030030)
	helper_e34416e2(2030040)
	event.PlayBgm(0)
end

return helper_bc7aeb92
