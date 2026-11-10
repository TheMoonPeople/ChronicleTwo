--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9959c129()
	event.set_character_active(1, 0)
	event.set_character_position(0, -687.4, 0.0, -77.8)
	event.set_character_rotation(0, 0.0, 1.62, 0.0)
	event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.finish_event()
	vm.wait(1)
end

return helper_9959c129
