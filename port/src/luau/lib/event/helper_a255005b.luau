--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ec08062 = require("@lib/event/helper_0ec08062")
local helper_83663e22 = require("@lib/event/helper_83663e22")
local helper_f8aba7e6 = require("@lib/event/helper_f8aba7e6")

--- Helper function.
local function helper_a255005b(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_0ec08062(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_83663e22(arg0, 0, var6)
		end
		helper_f8aba7e6(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_0ec08062(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_83663e22(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_f8aba7e6(arg0)
end

return helper_a255005b
