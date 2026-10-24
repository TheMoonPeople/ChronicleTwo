--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Helper function.
local function helper_8b12f95c()
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.SetFadeIn(15)
	event.ObjsMove(0, 418.52, 0.01, 950.16, 75, 1)
	event.ObjsMove(1, 399.78, 0.0, 963.89, 75, 1)
	helper_25abe6d2(75)
end

return helper_8b12f95c
