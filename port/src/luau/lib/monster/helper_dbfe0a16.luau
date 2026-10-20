--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_dbfe0a16()
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	monster.ResetMove()
	helper_442b9962()
end

return helper_dbfe0a16
