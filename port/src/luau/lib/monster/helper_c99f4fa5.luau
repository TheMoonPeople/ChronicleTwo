--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_8a90bb2e = require("@lib/monster/helper_8a90bb2e")

--- Helper function.
local function helper_c99f4fa5()
	monster.set_life("気絶", -1)
	helper_8a90bb2e()
	monster.call_command(119, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 0) -- retail: the handler rejects 2 arguments
end

return helper_c99f4fa5
