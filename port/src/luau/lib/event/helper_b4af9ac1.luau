--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47c3d81b = require("@lib/event/helper_47c3d81b")
local helper_60a0926b = require("@lib/event/helper_60a0926b")
local helper_e6aec4a9 = require("@lib/event/helper_e6aec4a9")

--- Helper function.
local function helper_b4af9ac1(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e6aec4a9(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_60a0926b(arg0, 0, var5)
		end
		helper_47c3d81b(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_e6aec4a9(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_60a0926b(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_47c3d81b(arg0)
end

return helper_b4af9ac1
