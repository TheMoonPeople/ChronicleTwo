--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_79d6eaca = require("@lib/monster/helper_79d6eaca")

--- Helper function.
local function helper_56845ba9()
	monster.get_attack_power_0()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	helper_79d6eaca()
end

return helper_56845ba9
