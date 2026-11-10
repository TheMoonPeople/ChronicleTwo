--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_c72a3649()
	helper_888ab2a3(10)
	event.delay_object_sequence_motion_track(0, 10)
	event.delay_object_sequence_motion_track(1, 20)
	event.set_object_sequence_motion(0, "下を見る", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(0, "下を見るL", 0)
	event.set_object_sequence_motion(1, "下を見る", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "下を見るL", 0)
	event.set_object_sequence_motion(2, "飛び降り", 6)
	helper_888ab2a3(81)
end

return helper_c72a3649
