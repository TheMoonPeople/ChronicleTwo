--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")

--- Helper function.
local function helper_2ab15efa()
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(8.4))
	monster.set_motion("攻撃２", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
	helper_ee5b84d4(9)
end

return helper_2ab15efa
