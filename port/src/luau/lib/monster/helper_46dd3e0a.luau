--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4a39d2ab = require("@lib/monster/helper_4a39d2ab")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")

--- Helper function.
local function helper_46dd3e0a()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var9: f32 = 0
	local argc: s32 = 0
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
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("ステップ左", -1, 2)
		var4 = vm.f32(var4 + vm.f32(1.5707964))
	else
		monster.set_motion("ステップ右", -1, 2)
		var4 = vm.f32(var4 - vm.f32(1.5707964))
	end
	var9 = 100.0
	target = vm.f32(pos_x + vm.f32(vm.sin(var4) * var9))
	target_2 = vm.f32(pos_y - 20.0)
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(var4) * var9))
	helper_4a39d2ab(vm.f32(0.27), -1.0)
	monster.set_monster_attributes(32, 1)
	monster.move_toward_position(target, target_2, target_3, 2.25, 2.25)
	helper_4a39d2ab(vm.f32(0.63), -1.0)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
end

return helper_46dd3e0a
