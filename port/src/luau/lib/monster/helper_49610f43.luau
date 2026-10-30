--!strict
-- Shared monster helper used by 96 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_49610f43()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	helper_442b9962()
	monster.stop_moving()
end

return helper_49610f43
