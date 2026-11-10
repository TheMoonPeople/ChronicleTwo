--!strict
-- Shared monster helper used by 93 scripts, translated by tools/luau/stb2luau.

local helper_27f80314 = require("@lib/monster/helper_27f80314")

--- Helper function.
local function helper_e05438b5()
	monster.set_motion("気絶", -1)
	helper_27f80314()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

return helper_e05438b5
