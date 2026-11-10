--!strict
-- Shared monster helper used by 9 scripts, translated by tools/luau/stb2luau.

local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_97663440 = require("@lib/monster/helper_97663440")

--- Helper function.
local function helper_2f2adeb4()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_97663440(10)
	helper_317bfc18(1)
	monster.reset_motion()
end

return helper_2f2adeb4
