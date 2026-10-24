--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31947fd7 = require("@lib/event/helper_31947fd7")
local helper_6992f518 = require("@lib/event/helper_6992f518")

--- Helper function.
local function helper_ed829512(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	vm.wait(1)
	vm.wait(2)
	event.SetMesPos(arg0, 0)
	event.MesMake_2(arg0, arg1)
	event.SetMesAutoset(arg0, arg2, arg3)
	do
		local _: any
		_, var5 = helper_31947fd7(arg0, 0, var5)
	end
	helper_6992f518(arg0)
end

return helper_ed829512
