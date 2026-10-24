--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_4a3f6e53()
	event.ObjsSetMotion(2, "起きる", 6)
	event.ObjsNextMotion(2, "起きるL", 0)
	helper_888ab2a3(13)
	helper_888ab2a3(30)
end

return helper_4a3f6e53
