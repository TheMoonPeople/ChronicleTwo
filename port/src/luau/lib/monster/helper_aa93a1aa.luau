--!strict
-- Shared monster helper used by 17 scripts, translated by tools/luau/stb2luau.

local helper_97663440 = require("@lib/monster/helper_97663440")

--- Helper function.
local function helper_aa93a1aa()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_97663440(10)
	monster.reset_motion()
end

return helper_aa93a1aa
