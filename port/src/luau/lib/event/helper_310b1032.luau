--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_307f5027 = require("@lib/event/helper_307f5027")
local helper_35fe0d1b = require("@lib/event/helper_35fe0d1b")
local helper_c779c42e = require("@lib/event/helper_c779c42e")

--- Helper function.
local function helper_310b1032(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_307f5027(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_c779c42e(arg0, 0, var6)
		end
		helper_35fe0d1b(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_307f5027(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_c779c42e(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_35fe0d1b(arg0)
end

return helper_310b1032
