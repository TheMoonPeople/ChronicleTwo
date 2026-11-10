--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_79d6eaca = require("@lib/monster/helper_79d6eaca")

--- Helper function.
local function helper_c9f11562()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	helper_79d6eaca()
	monster.call_command(141) -- retail: command 141 is not registered
end

return helper_c9f11562
