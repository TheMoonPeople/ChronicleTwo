--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_9ca592a1()
	event.set_object_sequence_motion(1, "手をはなす", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
	event.set_object_sequence_motion(2, "手をはなす", 6)
	helper_888ab2a3(30)
end

return helper_9ca592a1
