--!strict
-- Shared monster helper used by 9 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_a2d828a7()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	helper_442b9962()
	helper_0ba23e4e()
	helper_317bfc18(0)
	monster.set_action_status(1)
end

return helper_a2d828a7
