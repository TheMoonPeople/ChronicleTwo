--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0a0e1163 = require("@lib/event/helper_0a0e1163")
local helper_0ba263f7 = require("@lib/event/helper_0ba263f7")
local helper_965e9542 = require("@lib/event/helper_965e9542")

--- Helper function.
local function helper_8834eba9(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_965e9542(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_0a0e1163(arg0, 0, var6)
		end
		helper_0ba263f7(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_965e9542(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_0a0e1163(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_0ba263f7(arg0)
end

return helper_8834eba9
