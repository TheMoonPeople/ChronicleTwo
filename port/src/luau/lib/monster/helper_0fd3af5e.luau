--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_b8f0234c = require("@lib/monster/helper_b8f0234c")

--- Helper function.
local function helper_0fd3af5e()
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_b8f0234c(10)
	monster.ResetMotion()
end

return helper_0fd3af5e
