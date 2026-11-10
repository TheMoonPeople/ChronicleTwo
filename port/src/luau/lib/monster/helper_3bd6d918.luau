--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_3bd6d918()
	monster.set_photo_opportunity(32, 0)
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	monster.call_command(143) -- retail: command 143 is not registered
	helper_c3e8ae39(10)
	monster.get_attack_power_0()
end

return helper_3bd6d918
