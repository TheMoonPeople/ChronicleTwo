--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1953c457 = require("@lib/event/helper_1953c457")
local helper_5c0f57bf = require("@lib/event/helper_5c0f57bf")
local helper_e797fcc8 = require("@lib/event/helper_e797fcc8")

--- Helper function.
local function helper_387fd058(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1953c457(arg0)
	end
	local _ = helper_e797fcc8(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_5c0f57bf(arg0, 0, var6)
	if vm.skipping() then
		return skip(1)
	end
	helper_1953c457(arg0)
end

return helper_387fd058
