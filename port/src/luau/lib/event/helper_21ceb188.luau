--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2503c0bf = require("@lib/event/helper_2503c0bf")
local helper_d633a414 = require("@lib/event/helper_d633a414")
local helper_d84b5170 = require("@lib/event/helper_d84b5170")

--- Helper function.
local function helper_21ceb188(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_d84b5170(arg0)
		return arg5
	end
	local _ = helper_2503c0bf(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_d633a414(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_d84b5170(arg0)
	return arg5
end

return helper_21ceb188
