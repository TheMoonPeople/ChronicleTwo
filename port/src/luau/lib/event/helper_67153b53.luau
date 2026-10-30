--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_67153b53(arg0: any)
	local projection: f32 = 0
	event.set_camera_sequence_position(-0.29, 27.55, -25.02)
	event.set_camera_sequence_look_at(-1.02, 29.45, -94.81)
	event.get_event_projection(projection)
	event.set_event_projection(871.9)
	event.set_character_position(34, 0.22, 5.19, -94.18)
	event.set_character_rotation(34, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(2, "前を見るL", 4)
	wait_objects(2)
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090120)
	event.reset_mouth_texture_animations()
	wait_objects(2)
	event.set_event_projection(projection)
end

return helper_67153b53
