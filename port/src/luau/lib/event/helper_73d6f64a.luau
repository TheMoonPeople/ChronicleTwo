--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09fd1f10 = require("@lib/event/helper_09fd1f10")
local helper_56a731b3 = require("@lib/event/helper_56a731b3")
local helper_91637685 = require("@lib/event/helper_91637685")

--- Helper function.
local function helper_73d6f64a(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_56a731b3(arg0, 0, var6)
		end
		helper_09fd1f10(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_56a731b3(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_09fd1f10(arg0)
end

return helper_73d6f64a
