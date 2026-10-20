--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3535925d = require("@lib/event/helper_3535925d")
local helper_971ac40c = require("@lib/event/helper_971ac40c")
local helper_99fc26f3 = require("@lib/event/helper_99fc26f3")

--- Helper function.
local function helper_c05f3665(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, sp: number)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_971ac40c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_99fc26f3(arg0, 0, var6, sp + 9)
		end
		helper_3535925d(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_971ac40c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_99fc26f3(arg0, 0, var6, sp + 9)
	if vm.skipping() then
		return skip(2)
	end
	helper_3535925d(arg0)
end

return helper_c05f3665
