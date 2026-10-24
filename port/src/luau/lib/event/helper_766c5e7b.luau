--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f724af6 = require("@lib/event/helper_0f724af6")
local helper_46b52105 = require("@lib/event/helper_46b52105")

--- Helper function.
local function helper_766c5e7b(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_46b52105(arg0, arg1, arg2, arg3, arg4)
			var8 = helper_0f724af6(arg0, arg5, arg6, 0)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_46b52105(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_0f724af6(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

return helper_766c5e7b
