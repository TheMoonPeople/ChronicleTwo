--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_27f80314 = require("@lib/monster/helper_27f80314")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_4403befa = require("@lib/monster/helper_4403befa")

--- Helper function.
local function helper_aada6ba2()
	monster.SetMos("気絶", -1)
	helper_27f80314()
	helper_317bfc18(1)
	helper_4403befa()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
end

return helper_aada6ba2
