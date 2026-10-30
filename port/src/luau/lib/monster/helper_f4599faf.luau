--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4a39d2ab = require("@lib/monster/helper_4a39d2ab")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")

--- Helper function.
local function helper_f4599faf()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var4 = out2 or var4
	end
	var4 = vm.f32(var4 + vm.f32(3.1415927))
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(var4)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(var4)))
	monster.set_motion("ステップ後", -1, 2)
	helper_4a39d2ab(vm.f32(0.28), -1.0)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.5, 2.5)
	helper_4a39d2ab(vm.f32(0.8), -1.0)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
end

return helper_f4599faf
