--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_3045af93(move_speed: f32)
	local pos_x: f32 = 0
	local var3: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local pos_y_2: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(6.0)
	monster.set_monster_attributes(32, 1)
	var5 = monster.get_target_distance() or var5
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var7 = monster.get_random_whole_number(10.0) or var7
	var5 = vm.f32(var5 + vm.f32(40.0 + var7))
	pos_x, var3, pos_z = helper_125e5305(0.0, var5, pos_x, var3, pos_z)
	monster.set_motion("歩き後", -1, 6)
	helper_c3e8ae39(8)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y_2 = out2 or pos_y_2
	end
	monster.move_toward_position(pos_x, pos_y_2, pos_z, move_speed, move_speed + 1.0)
	helper_c3e8ae39(8)
	monster.set_monster_attributes(32, 0)
	monster.stop_moving()
	helper_56d63eae()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

return helper_3045af93
