--!strict
-- Shared monster helper used by 38 scripts, translated by tools/luau/stb2luau.

local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")

--- Helper function.
local function helper_ba87ea88()
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_ee5b84d4(10)
	monster.ResetMotion()
end

return helper_ba87ea88
