--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6fc8ed77 = require("@lib/event/helper_6fc8ed77")

--- Helper function.
local function helper_4541d180()
	local var2: s32 = 0
	local flag: s32 = 0
	event.set_dungeon_stage_id(1)
	event.open_event_menu(3, 1)
	vm.wait(1)
	do
		local _, _, out3, _ = event.get_menu_results_4()
		var2 = out3 or var2
	end
	vm.wait(2)
	if var2 == 0 then
		helper_6fc8ed77()
	else
		if var2 == 6 then
			event.jump_to_map_3(-1, "s05", 100)
			vm.wait(4)
			return
		end
		flag = event.get_save_flag(212) or flag
		if var2 == 2 and flag == 0 or var2 == 14 then
			event.skip_next_music_load()
		end
		event.go_to_dungeon(1, var2, 1010)
	end
end

return helper_4541d180
