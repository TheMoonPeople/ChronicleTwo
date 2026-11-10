--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_70e4c90a(arg0: any)
	local projection: f32 = 0
	event.set_camera_sequence_position(1.35, 30.21, -27.45)
	event.set_camera_sequence_look_at(0.24, 29.22, -88.19)
	event.get_event_projection(projection)
	event.set_event_projection(950.9)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, 0.22, 5.19, -94.18)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(2, "座り", 4)
	event.set_character_active(0, 35)
	event.set_object_handle_visible(13, 1)
	event.set_object_sequence_motion(2, "立ちあがる", 6)
	event.queue_object_sequence_next_motion(2, "立ちあがるL")
	wait_objects(2)
	event.set_mouth_texture_animations(2, "通常口パク")
	helper_4116e6bb(1090010)
	event.reset_mouth_texture_animations()
	event.set_event_projection(projection)
end

return helper_70e4c90a
