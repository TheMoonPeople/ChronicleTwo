--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_461f64ff = require("@lib/monster/helper_461f64ff")

--- Helper function.
local function helper_09acbcc2()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	helper_442b9962()
	helper_461f64ff()
	helper_317bfc18(0)
	monster.set_action_status(1)
end

return helper_09acbcc2
