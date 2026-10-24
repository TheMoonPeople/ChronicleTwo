--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_a3d45606(arg0: any)
	event.SpriteSetPutsize(0, 512.0, 416.0)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetPos(10, 256.0, 208.0, 10.0)
	event.ObjsSetColor(10, 128.0, 128.0, 128.0, 128.0, 30)
	helper_e34416e2(2030050)
end

return helper_a3d45606
