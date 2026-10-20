--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_590ef7b4 = require("@lib/event/helper_590ef7b4")
local helper_cefa61e7 = require("@lib/event/helper_cefa61e7")
local helper_ffa2b2b2 = require("@lib/event/helper_ffa2b2b2")

--- Helper function.
local function helper_0a344ece(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_ffa2b2b2(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_cefa61e7(arg0, 0, var6)
		end
		helper_590ef7b4(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_ffa2b2b2(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_cefa61e7(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_590ef7b4(arg0)
end

return helper_0a344ece
