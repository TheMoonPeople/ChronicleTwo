--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e1c3e640 = require("@lib/monster/helper_e1c3e640")

--- Helper function.
local function helper_4642a5d1()
	monster.set_motion("走り", -1, 0)
	helper_e1c3e640(vm.f32(3.2), vm.f32(4.2), 40.0, 120)
	monster.set_motion("立ち", -1, 0)
end

return helper_4642a5d1
