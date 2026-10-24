--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3395610c = require("@lib/event/helper_3395610c")
local helper_83663e22 = require("@lib/event/helper_83663e22")
local helper_f8aba7e6 = require("@lib/event/helper_f8aba7e6")

--- Helper function.
local function helper_9d160cf5(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3395610c(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_83663e22(arg0, 0, var5)
		end
		helper_f8aba7e6(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_3395610c(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_83663e22(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_f8aba7e6(arg0)
end

return helper_9d160cf5
