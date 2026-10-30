--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_1bc83184()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(6.0)
	monster.set_motion("攻撃１", -1, 2)
	helper_c3e8ae39(12)
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
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(var4)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(var4)))
	monster.move_toward_position(pos_x, pos_y, pos_z, 2.8, 2.8)
	helper_c3e8ae39(28)
	monster.stop_moving()
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

return helper_1bc83184
