--!strict
-- Shared monster helper used by 18 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_e2fdabb9(arg0: f32)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	do
		local out1, _, out3 = monster.GetTargetPos()
		var4 = out1 or var4
		var6 = out3 or var6
	end
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var7 = monster.GetDistVector2(var4, 0.0, var6, pos_x, 0.0, pos_z) or var7
	arg0 = var7
	return arg0
end

return helper_e2fdabb9
