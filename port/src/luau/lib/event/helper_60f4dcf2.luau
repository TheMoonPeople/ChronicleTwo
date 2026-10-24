--!strict
-- Shared event helper used by 260 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_60f4dcf2(arg0: any, arg1: any, arg2: any, arg3: any)
	vm.wait(1)
	vm.wait(2)
	event.SetMesPos(arg0, 0)
	event.MesMake_2(arg0, arg1)
	event.SetMesAutoset(arg0, arg2, arg3)
end

return helper_60f4dcf2
