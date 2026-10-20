--!strict
-- Shared monster helper used by 107 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_5d37e9f4()
	monster.ResetMove()
	helper_442b9962()
	monster.ResetMotion()
	monster.SetActStatus(0)
end

return helper_5d37e9f4
