--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")

--- Helper function.
local function helper_9845a57a()
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
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 6)
	helper_ee5b84d4(helper_9df6409a(7))
	monster.move_toward_position(pos_x, pos_y, pos_z, 3.7, 3.7)
	helper_ee5b84d4(helper_9df6409a(9))
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
end

return helper_9845a57a
