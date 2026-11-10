--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_d529ed92()
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	argc = event.get_item_limit_status() or argc
	argc_2 = event.get_overflow_item_count() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		argc_3 = event.get_main_loop_mode() or argc_3
		if argc_3 == 1 then
			event.open_event_menu(16)
			vm.wait(1)
			return
		end
		if argc_3 == 2 then
			event.open_event_menu(17)
			vm.wait(2)
			return
		end
	end
end

return helper_d529ed92
