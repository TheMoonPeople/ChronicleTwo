--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_5fe3030d = require("@lib/event/helper_5fe3030d")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")

--- Helper function.
local function helper_180778df(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_dd7a6f53(arg0)
		return arg5
	end
	local _ = helper_27ff0b8f(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_5fe3030d(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_dd7a6f53(arg0)
	return arg5
end

return helper_180778df
