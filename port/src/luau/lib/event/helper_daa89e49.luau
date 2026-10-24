--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6b5bfb87 = require("@lib/event/helper_6b5bfb87")
local helper_81254767 = require("@lib/event/helper_81254767")
local helper_db54c1e4 = require("@lib/event/helper_db54c1e4")

--- Helper function.
local function helper_daa89e49(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6b5bfb87(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_db54c1e4(arg0, 0, var5)
		end
		helper_81254767(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_6b5bfb87(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_db54c1e4(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_81254767(arg0)
end

return helper_daa89e49
