--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_048b6415 = require("@lib/event/helper_048b6415")
local helper_6f9f9c0e = require("@lib/event/helper_6f9f9c0e")
local helper_88c6684e = require("@lib/event/helper_88c6684e")

--- Helper function.
local function helper_941ed74e(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_6f9f9c0e(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_048b6415(arg0, 0, var6)
		end
		helper_88c6684e(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_6f9f9c0e(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_048b6415(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_88c6684e(arg0)
end

return helper_941ed74e
