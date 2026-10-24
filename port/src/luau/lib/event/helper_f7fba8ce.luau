--!strict
-- Shared event helper used by 46 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_f7fba8ce(arg0: f32, arg1: f32, arg2: f32)
	local var3: s32 = 0
	var3 = event.AngleCmp(arg0, arg1, arg2) or var3
	return var3
end

return helper_f7fba8ce
