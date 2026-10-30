--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_f8bbcc57 = require("@lib/event/helper_f8bbcc57")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_f4d83329(arg0: s32)
	local at: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(1, 4)
		set_window_mode(1, 4)
		if arg0 == 0 then
			at = 1
			return helper_bac0e30d(1, 1000 + arg0, 7, 0, 0, 2, 0)
		end
		if arg0 == 1 then
			at = 2
			return helper_bac0e30d(1, 1000 + arg0, 7, 0, 0, 3, 0)
		end
		return 0
	end, function(received: { any })
		if at <= 1 then
			return helper_f8bbcc57(1, vm.i32(1000 + arg0), 7, 0, 0, 2, 0)
		end
		if at <= 2 then
			return helper_f8bbcc57(1, vm.i32(1000 + arg0), 7, 0, 0, 3, 0)
		end
		return nil
	end)
end

return helper_f4d83329
