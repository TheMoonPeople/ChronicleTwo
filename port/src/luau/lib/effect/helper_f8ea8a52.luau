--!strict
-- Shared effect helper used by 2 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_f8ea8a52(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	do
		local out1, out2, out3 = effect.ChrGetPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = effect.SubVector(arg0, arg1, arg2, pos_x, pos_y, pos_z)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	var7 = effect.Atan2f(arg0, arg2) or var7
	arg3 = var7
	return arg3
end

return helper_f8ea8a52
