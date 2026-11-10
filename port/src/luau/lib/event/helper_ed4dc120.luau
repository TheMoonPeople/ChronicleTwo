--!strict
-- Shared event helper used by 221 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")

--- Helper function.
local function helper_ed4dc120(arg0: s32, arg1: s32)
	local var2: any = 0
	local at: number = 0
	return vm.guard(function()
		event.set_message_selection_top_line(1, 0)
		event.set_message_window_mode(1, 5)
		event.set_message_draw_speed(1, 1)
		event.set_message_item_system_message(1, 1, vm.i32(arg1 + 20000))
		at = 1
		var2 = helper_bac0e30d(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
		event.set_message_draw_speed(1, 0)
		return var2
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var2 = received[1] :: number
			end
			return var2
		end
		return nil
	end)
end

return helper_ed4dc120
