--!strict
-- Shared event helper used by 861 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Waits until an object sequence has run its commands.
local function wait_objects(sequence: s32)
	local var1: s32 = 0
	while true do
		var1 = event.is_object_sequence_running(sequence) or var1
		if var1 == 0 then
			break
		else
			vm.wait(1)
		end
	end
end

return wait_objects
