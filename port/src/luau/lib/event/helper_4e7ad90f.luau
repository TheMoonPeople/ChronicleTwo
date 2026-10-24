--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Helper function.
local function helper_4e7ad90f(arg0: any)
	event.CmrsSetPos(-292.76, 173.19, -1582.23)
	event.CmrsSetRef(-228.24, 151.8, -1773.02)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.ObjsMove(10, -120.0, 0.0, -3050.0, 90)
	helper_25abe6d2(90)
end

return helper_4e7ad90f
