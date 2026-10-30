--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_062953b4(se_id: s32)
	event.set_camera_sequence_position(79.6, 44.59, -39.31)
	event.set_camera_sequence_look_at(-7.3, 30.03, -86.44)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, 0.22, 5.19, -94.18)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(2, "座り", 4)
	wait_objects(2)
	event.fade_in_screen(30)
	event.play_sound_effect(se_id, 2)
	wait_frames(66)
	event.move_camera_sequence_eased(79.6, 44.59, -39.31, 39.97, 30.03, 52.15, 90, 2, 0.4)
	wait_camera()
end

return helper_062953b4
