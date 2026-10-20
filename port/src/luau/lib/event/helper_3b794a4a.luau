--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f9bcc71e = require("@lib/event/helper_f9bcc71e")
local helper_fd98eb80 = require("@lib/event/helper_fd98eb80")

--- Helper function.
local function helper_3b794a4a(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32, sp: number)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_fd98eb80(arg0, arg1, arg2, arg3, arg4, sp + 10)
			var8 = helper_f9bcc71e(arg0, arg5, arg6, 0, sp + 10)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_fd98eb80(arg0, arg1, arg2, arg3, arg4, sp + 10)
	var8 = helper_f9bcc71e(arg0, arg5, arg6, 0, sp + 10)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

return helper_3b794a4a
