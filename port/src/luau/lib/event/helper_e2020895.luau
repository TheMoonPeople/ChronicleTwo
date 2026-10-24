--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23369a5e = require("@lib/event/helper_23369a5e")
local helper_93671964 = require("@lib/event/helper_93671964")
local helper_e62dd413 = require("@lib/event/helper_e62dd413")

--- Helper function.
local function helper_e2020895(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_e62dd413(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_93671964(arg0, 0, var6)
		end
		helper_23369a5e(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_e62dd413(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_93671964(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_23369a5e(arg0)
end

return helper_e2020895
