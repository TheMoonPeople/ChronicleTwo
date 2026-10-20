--!strict
-- Shared monster helper used by 87 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_02ce7891()
	monster.ResetMove()
	helper_442b9962()
	monster.SetDeadStart()
end

return helper_02ce7891
