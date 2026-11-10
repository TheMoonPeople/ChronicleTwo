--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f51aa7a3 = require("@lib/event/helper_f51aa7a3")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_7c78bc02(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local at: number = 0
	return vm.guard(function()
		local _ = open_message(arg0, arg1, arg2, arg3, arg4)
		at = 1
		var8 = helper_f51aa7a3(arg0, arg5, arg6, 0)
		event.set_message_bubble_screen_slot(arg0, 0)
		return var8
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var8 = received[1] :: number
			end
			return var8
		end
		return nil
	end)
end

return helper_7c78bc02
