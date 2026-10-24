--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_735361a0(arg0: any)
	event.SetFadeIn(30)
	helper_25abe6d2(30)
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "腰に手", 4)
	event.ObjsSetMotion(2, "斜め向き立ち", 4)
	event.ObjsSetMotion(3, "石炭", 4)
	event.CmrsMove2(41.03, 65.52, -72.49, 1.22, 60.93, 25.12, 60, 0, 1.0)
	helper_c624bc16()
	helper_25abe6d2(20)
end

return helper_735361a0
