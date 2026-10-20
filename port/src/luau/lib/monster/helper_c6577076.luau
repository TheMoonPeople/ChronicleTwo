--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_56d63eae = require("@lib/monster/helper_56d63eae")

--- Helper function.
local function helper_c6577076()
	monster.ResetMotion()
	monster.SetMos("遊び", -1, 6)
	helper_56d63eae()
end

return helper_c6577076
