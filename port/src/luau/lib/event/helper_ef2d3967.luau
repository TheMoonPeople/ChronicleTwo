--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_08472fdb = require("@lib/event/helper_08472fdb")
local helper_b72ef077 = require("@lib/event/helper_b72ef077")
local helper_ea62f5d8 = require("@lib/event/helper_ea62f5d8")

--- Helper function.
local function helper_ef2d3967(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_08472fdb(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_ea62f5d8(arg0, 0, var5)
		end
		helper_b72ef077(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_08472fdb(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_ea62f5d8(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_b72ef077(arg0)
end

return helper_ef2d3967
