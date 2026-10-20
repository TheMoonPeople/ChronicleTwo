--!strict
-- Shared monster helper used by 17 scripts, translated by tools/luau/stb2luau.

local helper_97663440 = require("@lib/monster/helper_97663440")

--- Helper function.
local function helper_aa93a1aa()
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_97663440(10)
	monster.ResetMotion()
end

return helper_aa93a1aa
