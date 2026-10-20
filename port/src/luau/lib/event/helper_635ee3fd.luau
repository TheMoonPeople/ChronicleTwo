--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a3a86b9a = require("@lib/event/helper_a3a86b9a")
local helper_cc5a75ce = require("@lib/event/helper_cc5a75ce")
local helper_d759a0ab = require("@lib/event/helper_d759a0ab")

--- Helper function.
local function helper_635ee3fd(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a3a86b9a(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_cc5a75ce(arg0, 0, var5)
		end
		helper_d759a0ab(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_a3a86b9a(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_cc5a75ce(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_d759a0ab(arg0)
end

return helper_635ee3fd
