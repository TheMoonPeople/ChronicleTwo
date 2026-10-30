--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_5c86001d = require("@lib/monster/helper_5c86001d")

--- Helper function.
local function helper_3dad8a79()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_5c86001d(10)
	monster.reset_motion()
end

return helper_3dad8a79
