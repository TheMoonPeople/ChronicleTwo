--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_7c8e4fcc()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	helper_442b9962()
	helper_b9fff8e1()
	helper_317bfc18(0)
	monster.SetActStatus(1)
end

return helper_7c8e4fcc
