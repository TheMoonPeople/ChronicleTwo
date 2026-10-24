--!strict
-- Shared event helper used by 60 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4d24be45 = require("@lib/event/helper_4d24be45")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_d5638365 = require("@lib/event/helper_d5638365")

--- Helper function.
local function helper_b8950300(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4d24be45(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_d5638365(arg0, 0, var5)
		end
		helper_7e2956fd(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_4d24be45(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_d5638365(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_7e2956fd(arg0)
end

return helper_b8950300
