--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_39af59c5 = require("@lib/event/helper_39af59c5")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")

--- Helper function.
local function helper_8aa6dccc(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any, arg5: any)
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.wait(1)
		at = 2
		vm.wait(2)
		event.open_message_window_2(arg0, arg1)
		event.place_message_bubble(arg0, arg2, arg3)
		at = 3
		return helper_39af59c5(arg0, arg4, arg5, 0)
	end, function(received: { any })
		if at <= 3 then
			return helper_d793ae41(arg0, arg4, arg5, 0)
		end
		return nil
	end)
end

return helper_8aa6dccc
