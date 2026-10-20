--!strict
-- Shared monster helper used by 57 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_c94eec30(arg0: s32, arg1: s32)
	local value: s32 = 0
	local value_2: s32 = 0
	value = monster.VPop2(6) or value
	value_2 = monster.VPop2(7) or value_2
	arg0 = value
	arg1 = value_2
	return arg0, arg1
end

return helper_c94eec30
