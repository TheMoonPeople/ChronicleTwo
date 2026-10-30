--!strict
-- Shared monster helper used by 38 scripts, translated by tools/luau/stb2luau.

local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")

--- Helper function.
local function helper_ba87ea88()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_ee5b84d4(10)
	monster.reset_motion()
end

return helper_ba87ea88
