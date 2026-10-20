--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_34e58157 = require("@lib/event/helper_34e58157")
local helper_46b52105 = require("@lib/event/helper_46b52105")
local helper_ab850a0e = require("@lib/event/helper_ab850a0e")

--- Helper function.
local function helper_c35fec39(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_ab850a0e(arg0)
		return arg5
	end
	local _ = helper_46b52105(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_34e58157(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_ab850a0e(arg0)
	return arg5
end

return helper_c35fec39
