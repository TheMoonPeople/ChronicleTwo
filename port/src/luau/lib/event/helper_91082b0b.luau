--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4be4e7d3 = require("@lib/event/helper_4be4e7d3")
local helper_b90ffbb8 = require("@lib/event/helper_b90ffbb8")
local helper_cfb31f1f = require("@lib/event/helper_cfb31f1f")

--- Helper function.
local function helper_91082b0b(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4be4e7d3(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_cfb31f1f(arg0, 0, var5)
		end
		helper_b90ffbb8(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_4be4e7d3(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_cfb31f1f(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_b90ffbb8(arg0)
end

return helper_91082b0b
