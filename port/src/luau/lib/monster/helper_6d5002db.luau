--!strict
-- Shared monster helper used by 12 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_7863d8b6 = require("@lib/monster/helper_7863d8b6")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")

--- Helper function.
local function helper_6d5002db(move_speed: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local target: f32 = 0
	local target_3: f32 = 0
	local var11: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	helper_890ee63a(arg1)
	helper_442b9962()
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var20 = monster.get_target_distance() or var20
	var21 = monster.get_clear_distance(move_speed + arg2, 0.0) or var21
	if var21 < vm.f32(move_speed + arg2) then
		return
	end
	do
		local _, out2, _ = monster.get_rotation()
		var11 = out2 or var11
	end
	target = vm.f32(pos_x + vm.f32(vm.sin(var11) * var20))
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(var11) * var20))
	monster.move_toward_position(target, pos_y - 20.0, target_3, move_speed, arg2 + move_speed)
	local _ = helper_7863d8b6(arg2, arg3)
	monster.stop_moving()
end

return helper_6d5002db
