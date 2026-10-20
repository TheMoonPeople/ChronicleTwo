--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")

--- Helper function.
local function helper_a0d4bba7()
	monster.SetDeadOff()
	while true do
		helper_0ba23e4e()
	end
end

return helper_a0d4bba7
