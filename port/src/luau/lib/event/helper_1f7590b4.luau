--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b8751bf7 = require("@lib/event/helper_b8751bf7")
local helper_eb354717 = require("@lib/event/helper_eb354717")

--- Helper function.
local function helper_1f7590b4(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_eb354717(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_b8751bf7(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

return helper_1f7590b4
