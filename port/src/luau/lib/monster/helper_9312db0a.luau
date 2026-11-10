--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0682d2de = require("@lib/monster/helper_0682d2de")
local helper_125e5305 = require("@lib/monster/helper_125e5305")

--- Helper function.
local function helper_9312db0a(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local target_3: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var16: f32 = 0
	var16 = monster.get_target_distance() or var16
	var7, var8, target_3 = helper_125e5305(arg1, var16, var7, var8, target_3)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(var7, var8, target_3) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var10, var11, var12, pos_x, pos_y, pos_z)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var10, var11, var12)
		var10 = out1 or var10
		var11 = out2 or var11
		var12 = out3 or var12
	end
	var16 = monster.get_clear_distance(100.0, 0.0) or var16
	if var16 < 100.0 then
		var7 = vm.f32(pos_x + vm.f32(var10 * var16))
		var8 = pos_y
		target_3 = vm.f32(pos_z + vm.f32(var12 * var16))
		var16 = vm.f32(var16 - arg2)
		if var16 < arg2 then
			return
		end
	end
	monster.move_toward_position(var7, pos_y, target_3, arg0, arg0)
	local _ = helper_0682d2de(arg2, arg3)
	monster.stop_moving()
end

return helper_9312db0a
