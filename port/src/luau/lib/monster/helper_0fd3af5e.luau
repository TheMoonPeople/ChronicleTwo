--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_b8f0234c = require("@lib/monster/helper_b8f0234c")

--- Helper function.
local function helper_0fd3af5e()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_b8f0234c(10)
	monster.reset_motion()
end

return helper_0fd3af5e
