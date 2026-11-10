--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_d61bc810(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	argc = event.get_item_limit_status() or argc
	argc_2 = event.get_overflow_item_count() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		if arg0 == 1 then
			event.fade_out_screen(10)
			helper_888ab2a3(10)
		end
		argc_3 = event.get_main_loop_mode() or argc_3
		if argc_3 == 1 then
			event.open_event_menu(16)
			vm.wait(2)
		end
		if argc_3 == 2 then
			event.open_event_menu(17)
			vm.wait(3)
		end
		if arg0 == 1 then
			event.fade_in_screen(10)
		end
	end
end

return helper_d61bc810
