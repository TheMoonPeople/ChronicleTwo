--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_12864d2e()
	local value: s32 = 0
	value = monster.VPop(5) or value
	helper_c3e8ae39(value)
	monster.VPush(5, 20)
end

return helper_12864d2e
