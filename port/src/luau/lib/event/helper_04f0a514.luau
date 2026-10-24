--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_219d40b9 = require("@lib/event/helper_219d40b9")
local helper_3e2628eb = require("@lib/event/helper_3e2628eb")
local helper_adf7e7bd = require("@lib/event/helper_adf7e7bd")

--- Helper function.
local function helper_04f0a514(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_3e2628eb(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_adf7e7bd(arg0, 0, var6)
		end
		helper_219d40b9(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_3e2628eb(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_adf7e7bd(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_219d40b9(arg0)
end

return helper_04f0a514
