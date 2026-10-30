--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_46574a08(se_id: s32)
	event.set_camera_sequence_position(-158.38, 85.25, 3.62)
	event.set_camera_sequence_look_at(-34.81, 85.07, -0.49)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 0.0, 50.0, 0.0)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_scale(2, 1.3, 1.3, 1.3)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.play_sound_effect(se_id, 1)
	event.set_object_sequence_motion(2, "死", 6)
	event.wait_object_sequence_motion_end(2)
	wait_objects(2)
end

return helper_46574a08
