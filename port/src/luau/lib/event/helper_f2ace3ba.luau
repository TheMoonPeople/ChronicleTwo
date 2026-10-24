--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5c123176 = require("@lib/event/helper_5c123176")
local helper_5e48b35f = require("@lib/event/helper_5e48b35f")
local helper_e1d6e191 = require("@lib/event/helper_e1d6e191")

--- Helper function.
local function helper_f2ace3ba(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e1d6e191(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_5e48b35f(arg0, 0, var5)
		end
		helper_5c123176(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_e1d6e191(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_5e48b35f(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_5c123176(arg0)
end

return helper_f2ace3ba
