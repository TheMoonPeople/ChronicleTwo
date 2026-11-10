--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_79d6eaca = require("@lib/monster/helper_79d6eaca")

--- Helper function.
local function helper_63eb9d5b()
	monster.set_photo_opportunity(32, 0)
	monster.call_command(119, 1, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	helper_79d6eaca()
	monster.get_attack_power_0()
end

return helper_63eb9d5b
