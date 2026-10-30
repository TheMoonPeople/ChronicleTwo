--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_7b4134af(se_id: s32)
	event.set_camera_sequence_position(57.23, 251.57, 242.48)
	event.set_camera_sequence_look_at(21.23, 241.82, 43.83)
	event.set_character_active(1, 36)
	event.set_character_position(36, 266.91, 197.74, 696.65)
	event.set_character_rotation(36, 0.0, -3.12, 0.0)
	event.set_object_sequence_motion(4, "前を見るL", 4)
	event.move_object_sequence(10, -120.0, 0.0, -6000.0, 120)
	wait_frames(30)
	event.move_camera_sequence_angle_height_distance_eased(-2.57, 9.27, 80.0, 120, 0, 0.4)
	wait_camera()
	event.stop_sound_effect(se_id, 9)
end

return helper_7b4134af
