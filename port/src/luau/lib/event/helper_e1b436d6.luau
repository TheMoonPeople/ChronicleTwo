--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1f882600 = require("@lib/event/helper_1f882600")
local helper_62fc4cea = require("@lib/event/helper_62fc4cea")
local helper_97c04530 = require("@lib/event/helper_97c04530")

--- Helper function.
local function helper_e1b436d6(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_97c04530(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_1f882600(arg0, 0, var6)
		end
		helper_62fc4cea(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_97c04530(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_1f882600(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_62fc4cea(arg0)
end

return helper_e1b436d6
