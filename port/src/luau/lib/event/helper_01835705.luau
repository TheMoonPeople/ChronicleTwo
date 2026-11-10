--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_01835705()
	local var0: s32 = 0
	event.initialize_event()
	vm.wait(1)
	var0 = event.get_triggered_event_data_2(9) or var0
	event.attach_object_handle_to_map_part_3(0, var0, "d07w10_5-m0")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(1, var0, "d07w10_4-m0")
	event.set_object_handle_visible(1, 0)
	event.finish_event()
end

return helper_01835705
