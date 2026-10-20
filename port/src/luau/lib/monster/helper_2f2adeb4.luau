--!strict
-- Shared monster helper used by 9 scripts, translated by tools/luau/stb2luau.

local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_97663440 = require("@lib/monster/helper_97663440")

--- Helper function.
local function helper_2f2adeb4()
	monster.SetAttrib(32, 0)
	monster.ResetMove()
	monster.SetShrowEnd()
	helper_97663440(10)
	helper_317bfc18(1)
	monster.ResetMotion()
end

return helper_2f2adeb4
