--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2fc80090 = require("@lib/event/helper_2fc80090")
local helper_d633a414 = require("@lib/event/helper_d633a414")
local helper_d84b5170 = require("@lib/event/helper_d84b5170")

--- Helper function.
local function helper_0cbe7543(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2fc80090(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_d633a414(arg0, 0, var5)
		end
		helper_d84b5170(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_2fc80090(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_d633a414(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_d84b5170(arg0)
end

return helper_0cbe7543
