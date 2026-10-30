--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ce837ecc = require("@lib/event/helper_ce837ecc")

--- Helper function.
local function helper_1214600e()
	local var2: s32 = 0
	event.set_dungeon_stage_id(0)
	event.open_event_menu(3, 0)
	vm.wait(1)
	do
		local _, _, out3, _ = event.get_menu_results_4()
		var2 = out3 or var2
	end
	if var2 == 0 then
		event.jump_to_map_2(-1, "d01e01")
		vm.wait(2)
	elseif var2 == 8 then
		helper_ce837ecc()
	else
		event.go_to_dungeon(0, var2, 1010)
	end
end

return helper_1214600e
