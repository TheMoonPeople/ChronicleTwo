--!strict
-- Shared monster helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_56d63eae = require("@lib/monster/helper_56d63eae")

--- Helper function.
local function helper_b0d7af09()
	monster.ResetMotion()
	monster.SetMos("攻撃１", -1, 6)
	helper_56d63eae()
end

return helper_b0d7af09
