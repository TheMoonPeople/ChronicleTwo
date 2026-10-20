--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9ac5c278(arg0: any, arg1: any, arg2: any, arg3: any, arg4: any)
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var5
	end
	if vm.skipping() then
		return skip(1)
	end
	var5 = event.MesMake_3(arg0, arg1) or var5
	event.SetMesPos(arg0, arg2)
	event.SetMesAutoset(arg0, arg3, arg4, arg3, arg4)
	return var5
end

return helper_9ac5c278
