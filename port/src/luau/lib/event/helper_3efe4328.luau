--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_3efe4328()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.initialize_event()
		set_window_mode(0, 4)
		event.open_message_window_2(0, "中に入る\n出発する")
		at = 1
		var0 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 0)
		if var0 == -1 then
			set_window_mode(0, 1)
			return 0
		end
		if var0 == 1 then
			event.fade_out_screen(15)
			at = 2
			helper_888ab2a3(15)
			event.open_event_menu(19, 0)
			at = 3
			vm.wait(3)
			event.fade_in_screen(15)
			at = 4
			helper_888ab2a3(15)
			return 0
		end
		return 1
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			helper_fbd9683d(0, 1)
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_038a2e4d(15)
			end
			return 0
		end
		return nil
	end)
end

return helper_3efe4328
