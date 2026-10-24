--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_a120b706(arg0: any)
	event.SpriteSetPutsize(2, 512.0, 416.0)
	event.SpriteSetDraw(2, 1)
	event.ObjsSetPos(12, 256.0, 208.0, 10.0)
	event.ObjsSetColor(12, 128.0, 128.0, 128.0, 128.0, 15)
	helper_25abe6d2(15)
	event.SpriteSetDraw(1, 0)
	helper_e34416e2(2030070)
	helper_e34416e2(2030073)
end

return helper_a120b706
