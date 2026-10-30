--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4a39d2ab = require("@lib/monster/helper_4a39d2ab")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")

--- Helper function.
local function helper_3403c83a()
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(7.2000003))
	monster.set_motion("攻撃１", -1, 2)
	helper_4a39d2ab(vm.f32(0.595), -1.0)
	monster.set_motion("攻撃２", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(9)
end

return helper_3403c83a
