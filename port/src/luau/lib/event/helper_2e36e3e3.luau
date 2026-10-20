--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_458dea2e = require("@lib/event/helper_458dea2e")
local helper_969c5ad6 = require("@lib/event/helper_969c5ad6")
local helper_fba0f4b2 = require("@lib/event/helper_fba0f4b2")

--- Helper function.
local function helper_2e36e3e3(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any, sp: number)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_458dea2e(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_fba0f4b2(arg0, 0, var5, sp + 8)
		end
		helper_969c5ad6(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_458dea2e(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_fba0f4b2(arg0, 0, var5, sp + 8)
	if vm.skipping() then
		return skip(3)
	end
	helper_969c5ad6(arg0)
end

return helper_2e36e3e3
