--!strict
-- Shared monster helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_28faa04b()
	monster.ResetMove()
	helper_442b9962()
	monster.ResetMotion()
end

return helper_28faa04b
