--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_517ab114(arg0: any)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -0.79, 50.09, 122.71)
	event.ObjsSetRot(0, 0.0, -3.14, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CharaActive(1, 8)
	event.ObjsSetPos(1, 0.0, 50.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetScale(1, 1.5, 1.5, 1.5)
	helper_0958ca60(0)
	helper_0958ca60(1)
	helper_c624bc16()
end

return helper_517ab114
