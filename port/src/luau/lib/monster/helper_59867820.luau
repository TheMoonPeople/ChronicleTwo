--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_59867820()
	monster.SetAttrib(32, 0)
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	helper_317bfc18(0)
	monster.ResetMove()
	helper_442b9962()
	monster.ResetMotion()
end

return helper_59867820
