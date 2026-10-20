--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0924108c = require("@lib/event/helper_0924108c")
local helper_19a74323 = require("@lib/event/helper_19a74323")
local helper_6fdd737a = require("@lib/event/helper_6fdd737a")

--- Helper function.
local function helper_bbad87b6(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_19a74323(arg0)
	end
	local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_6fdd737a(arg0, 0, var6)
	if vm.skipping() then
		return skip(1)
	end
	helper_19a74323(arg0)
end

return helper_bbad87b6
