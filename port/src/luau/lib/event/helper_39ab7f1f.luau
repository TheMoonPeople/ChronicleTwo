--!strict
-- Shared event helper used by 46 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_39ab7f1f(arg0: f32, arg1: f32, arg2: s32)
	local var3: s32 = 0
	var3 = event.GetEquipItemno(0, 0) or var3
	do
		local out1, out2, out3 = event.SphidaGetCulbDef(var3)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	return arg0, arg1, arg2
end

return helper_39ab7f1f
