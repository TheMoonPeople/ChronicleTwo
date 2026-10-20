--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_38448da1 = require("@lib/event/helper_38448da1")
local helper_62946a4e = require("@lib/event/helper_62946a4e")
local helper_e620de35 = require("@lib/event/helper_e620de35")

--- Helper function.
local function helper_3dd465f9(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e620de35(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_62946a4e(arg0, 0, var5)
		end
		helper_38448da1(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_e620de35(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_62946a4e(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_38448da1(arg0)
end

return helper_3dd465f9
