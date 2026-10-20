--!strict
-- Shared monster helper used by 93 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_d30a9fa2()
	monster.SetAttrib(32, 0)
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMove()
	helper_442b9962()
	monster.ResetMotion()
end

return helper_d30a9fa2
