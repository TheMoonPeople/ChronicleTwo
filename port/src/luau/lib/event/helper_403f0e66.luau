--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b96d86b = require("@lib/event/helper_0b96d86b")
local helper_5fe3030d = require("@lib/event/helper_5fe3030d")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")

--- Helper function.
local function helper_403f0e66(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0b96d86b(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_5fe3030d(arg0, 0, var5)
		end
		helper_dd7a6f53(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_0b96d86b(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_5fe3030d(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_dd7a6f53(arg0)
end

return helper_403f0e66
