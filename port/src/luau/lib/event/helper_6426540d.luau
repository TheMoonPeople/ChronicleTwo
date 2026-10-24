--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_6426540d(arg0: any)
	event.CharaActive(0, 11)
	event.CharaActive(1, 33)
	event.SpriteSetPutsize(1, 512.0, 416.0)
	event.SpriteSetDraw(1, 1)
	event.ObjsSetPos(11, 256.0, 208.0, 10.0)
	event.ObjsSetColor(11, 128.0, 128.0, 128.0, 128.0, 15)
	helper_25abe6d2(15)
	event.SpriteSetDraw(0, 0)
	helper_e34416e2(2030060)
end

return helper_6426540d
