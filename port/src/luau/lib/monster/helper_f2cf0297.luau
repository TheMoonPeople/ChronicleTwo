--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_f2cf0297(arg0: f32, rot_speed: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: s32 = 0
	rot_speed = helper_787df986(rot_speed)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	var12 = 0
	while var12 < arg3 do
		var10 = monster.get_target_distance() or var10
		if var10 < arg2 then
			helper_442b9962()
			monster.stop_moving()
			return
		end
		var11 = monster.get_target_angle() or var11
		monster.turn_toward_angle(var11, rot_speed)
		do
			local out1, out2, out3 = monster.get_target_position()
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		monster.get_rotation()
		monster.move_toward_position(var4, var5 - 20.0, var6, arg0, arg0)
		helper_0ba23e4e()
		var12 = var12 + 1
		monster.stop_moving()
		helper_442b9962()
	end
end

return helper_f2cf0297
