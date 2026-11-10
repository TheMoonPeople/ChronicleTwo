--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_938babbf()
	event.set_object_sequence_motion(2, "立ちあがる", 6)
	event.queue_object_sequence_next_motion(2, "ぷるぷる", 0)
	helper_888ab2a3(40)
	helper_888ab2a3(30)
end

return helper_938babbf
