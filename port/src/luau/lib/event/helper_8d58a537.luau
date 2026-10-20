--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b20b7578 = require("@lib/event/helper_b20b7578")
local helper_e304888c = require("@lib/event/helper_e304888c")

--- Helper function.
local function helper_8d58a537(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_e304888c(arg0, arg1, arg2, arg3, arg4)
			var8 = helper_b20b7578(arg0, arg5, arg6, 0)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_e304888c(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_b20b7578(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

return helper_8d58a537
