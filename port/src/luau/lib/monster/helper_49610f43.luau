--!strict
-- Shared monster helper used by 96 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_49610f43()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	helper_442b9962()
	monster.ResetMove()
end

return helper_49610f43
