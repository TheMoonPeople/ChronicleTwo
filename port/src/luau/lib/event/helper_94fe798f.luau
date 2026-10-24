--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Helper function.
local function helper_94fe798f(arg0: any)
	event.CmrsInit()
	event.CmrsSetPos(-127.04, 86.04, -2182.12)
	event.CmrsSetRef(-120.48, 84.44, -1718.57)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.CmrsMove2(-126.85, 86.09, -2262.29, -120.48, 84.44, -1718.57, 20, 2, 0.4)
	event.ObjsMove(10, -120.0, 0.0, -2100.0, 45)
	helper_25abe6d2(45)
end

return helper_94fe798f
