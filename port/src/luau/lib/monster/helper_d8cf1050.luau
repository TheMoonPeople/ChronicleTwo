--!strict
-- Shared monster helper used by 24 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")

--- Helper function.
local function helper_d8cf1050()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	helper_0ba23e4e()
	monster.set_action_status(1)
end

return helper_d8cf1050
