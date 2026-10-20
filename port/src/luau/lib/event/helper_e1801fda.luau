--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_26b14944 = require("@lib/event/helper_26b14944")
local helper_3869ef54 = require("@lib/event/helper_3869ef54")
local helper_609fc1cb = require("@lib/event/helper_609fc1cb")

--- Helper function.
local function helper_e1801fda(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3869ef54(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_609fc1cb(arg0, 0, var5)
		end
		helper_26b14944(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_3869ef54(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_609fc1cb(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_26b14944(arg0)
end

return helper_e1801fda
