--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_72fec261 = require("@lib/monster/helper_72fec261")

--- Helper function.
local function helper_0799d76b()
	local var0: f32 = 0
	monster.set_motion("攻撃１", -1, 2)
	helper_72fec261(vm.f32(0.6), -1.0)
	var0 = monster.get_target_distance() or var0
	if var0 < 70.0 then
		monster.set_motion("攻撃１", -1, 0)
		helper_72fec261(vm.f32(0.6), -1.0)
	end
	var0 = monster.get_target_distance() or var0
	if var0 < 70.0 then
		monster.set_motion("攻撃１", -1, 0)
		helper_72fec261(vm.f32(0.6), -1.0)
	end
	helper_56d63eae()
end

return helper_0799d76b
