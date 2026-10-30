--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_3d13e6aa(arg0: s32)
	event.initialize_event()
	vm.wait(1)
	event.attach_object_handle_to_map_part_3(0, "p01_s19", "s19_02-a0")
	event.set_object_handle_visible(0, arg0)
	event.finish_event()
end

return helper_3d13e6aa
