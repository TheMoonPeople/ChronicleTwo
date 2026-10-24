--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_fa983e23()
	event.ObjsSetMotion(1, "のぞきこむ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "のぞきこむL", 0)
	event.ObjsSetMotion(2, "ぷるぷる", 4)
	helper_888ab2a3(16)
	helper_888ab2a3(30)
	event.ObjsSetMotion(2, "知るかー！", 6)
	helper_888ab2a3(30)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMotionDelay(2, 5)
	event.ObjsSetMotion(2, "走り", 4)
	event.ObjsRotation(2, 0.0, -1.68, 0.0, 5)
	event.ObjsPosDelay(2, 10)
	event.ObjsMove(2, -34.77, 0.0, 141.26, 10)
	helper_888ab2a3(20)
end

return helper_fa983e23
