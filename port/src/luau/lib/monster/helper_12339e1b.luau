--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_72fec261 = require("@lib/monster/helper_72fec261")

--- Helper function.
local function helper_12339e1b()
	monster.set_motion("攻撃１", -1, 2)
	helper_72fec261(vm.f32(0.45), -1.0)
	monster.set_motion("攻撃２", -1, 2)
	helper_56d63eae()
end

return helper_12339e1b
