--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4a39d2ab = require("@lib/monster/helper_4a39d2ab")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")

--- Helper function.
local function helper_319fc0f3()
	monster.set_motion("攻撃１", -1, 2)
	helper_4a39d2ab(vm.f32(0.45), -1.0)
	monster.set_motion("攻撃２", -1, 2)
	helper_cbe4d8e2()
end

return helper_319fc0f3
