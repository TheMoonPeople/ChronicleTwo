--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_012ae4e7 = require("@lib/event/helper_012ae4e7")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_f923a201(se_id: s32)
	local projection: f32 = 0
	projection = event.get_event_projection() or projection
	event.set_event_projection(813.9)
	event.set_camera_sequence_position(-11.48, 40.92, -121.7)
	event.set_camera_sequence_look_at(-8.15, 36.49, -100.87)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, -4.0, 5.43, -39.21)
	event.set_object_sequence_rotation(1, 0.0, -3.12, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, 0.22, 5.19, -94.18)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(2, "立ちあがるL", 4)
	event.set_object_sequence_motion(1, "腰に手", 6)
	event.queue_object_sequence_next_motion(1, "腰に手L")
	wait_objects(1)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1090020)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(1, "机をたたく", 6)
	event.queue_object_sequence_next_motion(1, "机をたたくL")
	helper_012ae4e7(33, vm.f32(0.805), -1.0, 60)
	event.play_sound_effect(se_id, 6)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1090030)
	event.reset_mouth_texture_animations()
	wait_objects(1)
	event.set_event_projection(projection)
end

return helper_f923a201
