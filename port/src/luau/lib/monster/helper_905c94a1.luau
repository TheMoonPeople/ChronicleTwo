--!strict
-- Shared monster helper used by 17 scripts, translated by tools/luau/stb2luau.

local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_4403befa = require("@lib/monster/helper_4403befa")

--- Helper function.
local function helper_905c94a1()
	helper_317bfc18(1)
	helper_4403befa()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
end

return helper_905c94a1
