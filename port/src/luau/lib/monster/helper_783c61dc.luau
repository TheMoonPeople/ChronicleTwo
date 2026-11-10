--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_783c61dc(arg0: f32, to: f32, to_2: f32, to_3: f32, arg4: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var8 = monster.get_distance_between(pos_x, pos_y, pos_z, to, to_2, to_3) or var8
	arg0 = vm.f32(vm.fdiv(var8, arg4))
	return arg0
end

return helper_783c61dc
