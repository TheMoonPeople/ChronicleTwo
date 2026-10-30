--!strict
-- Shared monster helper used by 93 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_d30a9fa2()
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	helper_442b9962()
	monster.reset_motion()
end

return helper_d30a9fa2
