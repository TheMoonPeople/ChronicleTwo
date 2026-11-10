--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4a39d2ab = require("@lib/monster/helper_4a39d2ab")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")

--- Helper function.
local function helper_49286904()
	local var0: f32 = 0
	monster.set_motion("攻撃１", -1, 2)
	helper_4a39d2ab(vm.f32(0.6), -1.0)
	var0 = monster.get_target_distance() or var0
	if var0 < 70.0 then
		monster.set_motion("攻撃１", -1, 0)
		helper_4a39d2ab(vm.f32(0.6), -1.0)
	end
	var0 = monster.get_target_distance() or var0
	if var0 < 70.0 then
		monster.set_motion("攻撃１", -1, 0)
		helper_4a39d2ab(vm.f32(0.6), -1.0)
	end
	helper_cbe4d8e2()
end

return helper_49286904
