--!strict
-- Shared event helper used by 35 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_5fe3030d = require("@lib/event/helper_5fe3030d")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")

--- Helper function.
local function helper_c049c42a(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_27ff0b8f(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_5fe3030d(arg0, 0, var6)
		end
		helper_dd7a6f53(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_27ff0b8f(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_5fe3030d(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_dd7a6f53(arg0)
end

return helper_c049c42a
