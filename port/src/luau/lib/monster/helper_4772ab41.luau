--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_45797ccb = require("@lib/monster/helper_45797ccb")

--- Helper function.
local function helper_4772ab41()
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	monster.end_throw()
	helper_45797ccb(10)
	helper_317bfc18(1)
	monster.reset_motion()
end

return helper_4772ab41
