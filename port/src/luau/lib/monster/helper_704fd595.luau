--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07b5f915 = require("@lib/monster/helper_07b5f915")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")

--- Helper function.
local function helper_704fd595()
	helper_ac26cdde(vm.f32(999.9))
	helper_07b5f915(50.0)
	monster.SetClipDist(600.0)
	helper_317bfc18(1)
end

return helper_704fd595
