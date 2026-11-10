--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_fa983e23()
	event.set_object_sequence_motion(1, "のぞきこむ", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "のぞきこむL", 0)
	event.set_object_sequence_motion(2, "ぷるぷる", 4)
	helper_888ab2a3(16)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(2, "知るかー！", 6)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(2, "歩き", 4)
	event.delay_object_sequence_motion_track(2, 5)
	event.set_object_sequence_motion(2, "走り", 4)
	event.rotate_object_sequence(2, 0.0, -1.68, 0.0, 5)
	event.delay_object_sequence_position_track(2, 10)
	event.move_object_sequence(2, -34.77, 0.0, 141.26, 10)
	helper_888ab2a3(20)
end

return helper_fa983e23
