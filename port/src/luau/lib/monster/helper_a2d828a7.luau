--!strict
-- Shared monster helper used by 9 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_a2d828a7()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	helper_442b9962()
	helper_0ba23e4e()
	helper_317bfc18(0)
	monster.SetActStatus(1)
end

return helper_a2d828a7
