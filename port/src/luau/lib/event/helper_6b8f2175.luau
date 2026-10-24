--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0349c0c2 = require("@lib/event/helper_0349c0c2")
local helper_1a1e22c8 = require("@lib/event/helper_1a1e22c8")
local helper_57e8417c = require("@lib/event/helper_57e8417c")

--- Helper function.
local function helper_6b8f2175(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_57e8417c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_0349c0c2(arg0, 0, var6)
		end
		helper_1a1e22c8(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_57e8417c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_0349c0c2(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_1a1e22c8(arg0)
end

return helper_6b8f2175
