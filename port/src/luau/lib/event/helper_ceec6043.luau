--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c43045c = require("@lib/event/helper_1c43045c")
local helper_26b14944 = require("@lib/event/helper_26b14944")
local helper_609fc1cb = require("@lib/event/helper_609fc1cb")

--- Helper function.
local function helper_ceec6043(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1c43045c(arg0, arg1, arg2, arg3, arg4)
			_, arg5 = helper_609fc1cb(arg0, 1, arg5)
		end
		helper_26b14944(arg0)
		return arg5
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_1c43045c(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_609fc1cb(arg0, 1, arg5)
	if vm.skipping() then
		return skip(2)
	end
	helper_26b14944(arg0)
	return arg5
end

return helper_ceec6043
