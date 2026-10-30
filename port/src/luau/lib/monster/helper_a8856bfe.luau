--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_b765e6cd = require("@lib/monster/helper_b765e6cd")

--- Helper function.
local function helper_a8856bfe()
	monster.set_motion("歩き", -1, 0)
	helper_83e135e0(vm.f32(4.2))
	monster.set_motion("遊び", -1, 6)
	helper_b765e6cd(vm.f32(4.2), helper_9df6409a(67))
	monster.set_motion("立ち", -1, 0)
end

return helper_a8856bfe
