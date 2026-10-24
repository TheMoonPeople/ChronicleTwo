--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_7791557a(arg0: any)
	event.SpriteSetPutsize(3, 512.0, 416.0)
	event.SpriteSetDraw(3, 1)
	event.ObjsSetPos(13, 256.0, 208.0, 0.0)
	event.ObjsSetColor(13, 128.0, 128.0, 128.0, 128.0, 15)
	helper_25abe6d2(15)
	event.SpriteSetDraw(2, 0)
	helper_e34416e2(2030080)
	helper_e34416e2(2030083)
end

return helper_7791557a
