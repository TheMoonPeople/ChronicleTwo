--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c43045c = require("@lib/event/helper_1c43045c")
local helper_26b14944 = require("@lib/event/helper_26b14944")
local helper_609fc1cb = require("@lib/event/helper_609fc1cb")

--- Helper function.
local function helper_a77b24cf(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1c43045c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_609fc1cb(arg0, 0, var6)
		end
		helper_26b14944(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_1c43045c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_609fc1cb(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_26b14944(arg0)
end

return helper_a77b24cf
