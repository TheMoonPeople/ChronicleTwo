--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_81254767 = require("@lib/event/helper_81254767")
local helper_db54c1e4 = require("@lib/event/helper_db54c1e4")
local helper_e03e89ed = require("@lib/event/helper_e03e89ed")

--- Helper function.
local function helper_951d9474(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_e03e89ed(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_db54c1e4(arg0, 0, var6)
		end
		helper_81254767(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_e03e89ed(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_db54c1e4(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_81254767(arg0)
end

return helper_951d9474
