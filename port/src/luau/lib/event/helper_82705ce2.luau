--!strict
-- Shared event helper used by 462 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_82705ce2(arg0: any, arg1: any, arg2: any, arg3: any, arg4: any)
	local var5: s32 = 0
	var5 = event.MesMake_3(arg0, arg1) or var5
	event.SetMesPos(arg0, arg2)
	event.SetMesAutoset(arg0, arg3, arg4, arg3, arg4)
	return var5
end

return helper_82705ce2
