--!strict
-- Shared event helper used by 100 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_653feda2 = require("@lib/event/helper_653feda2")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")

--- Helper function.
local function helper_625a66bc(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.wait(1)
		at = 2
		vm.wait(2)
		event.MesMake_2(arg0, arg1)
		event.SetMesAutoset(arg0, arg2, arg3)
		at = 3
		return helper_653feda2(arg0, arg4, arg5, 0)
	end, function(received: { any })
		if at <= 3 then
			return helper_d793ae41(arg0, arg4, arg5, 0)
		end
		return nil
	end)
end

return helper_625a66bc
