--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2e8cfc5c = require("@lib/event/helper_2e8cfc5c")
local helper_46426a6e = require("@lib/event/helper_46426a6e")
local helper_be5e42c1 = require("@lib/event/helper_be5e42c1")

--- Helper function.
local function helper_b8b453c5(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2e8cfc5c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_46426a6e(arg0, 0, var6)
		end
		helper_be5e42c1(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_2e8cfc5c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_46426a6e(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_be5e42c1(arg0)
end

return helper_b8b453c5
