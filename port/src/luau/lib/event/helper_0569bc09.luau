--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_87a5af10 = require("@lib/event/helper_87a5af10")
local helper_e85df3b0 = require("@lib/event/helper_e85df3b0")

--- Helper function.
local function helper_0569bc09(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_e85df3b0(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_87a5af10(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

return helper_0569bc09
