--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c81fece = require("@lib/event/helper_1c81fece")
local helper_f7e38aa5 = require("@lib/event/helper_f7e38aa5")

--- Helper function.
local function helper_fa0364e1(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_1c81fece(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_f7e38aa5(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

return helper_fa0364e1
