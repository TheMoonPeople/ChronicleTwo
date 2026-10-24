--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47c3d81b = require("@lib/event/helper_47c3d81b")
local helper_60a0926b = require("@lib/event/helper_60a0926b")
local helper_7bb59d61 = require("@lib/event/helper_7bb59d61")

--- Helper function.
local function helper_72506d21(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_7bb59d61(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_60a0926b(arg0, 0, var6)
		end
		helper_47c3d81b(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_7bb59d61(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_60a0926b(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_47c3d81b(arg0)
end

return helper_72506d21
