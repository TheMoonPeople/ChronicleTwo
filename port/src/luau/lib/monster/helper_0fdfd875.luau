--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_0fdfd875()
	monster.SetMos("攻撃１", -1, 2)
	helper_56d63eae()
	monster.SetMos("立ち")
	helper_c3e8ae39(12)
end

return helper_0fdfd875
