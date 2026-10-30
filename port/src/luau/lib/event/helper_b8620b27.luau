--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_b8620b27(se_id: s32)
	event.set_camera_sequence_position(-130.02, 67.35, -2138.26)
	event.set_camera_sequence_look_at(-120.37, 83.46, -1843.2)
	event.set_character_active(0, 33)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.stop_sound_effect(se_id, 6)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
	event.play_sound_effect(se_id, 9)
	event.play_sound_effect(se_id, 10)
	event.set_character_active(1, 40)
	event.set_character_position(40, -116.18, 50.38, -1787.14)
	event.set_character_motion(40, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	wait_frames(30)
	event.set_character_active(1, 38)
	event.set_character_active(1, 39)
	event.attach_object_handle_to_map_part_2(8, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 8)
	event.set_object_sequence_motion(6, "ぶしゅー", 6)
	event.set_object_sequence_motion(7, "ぶしゅー", 6)
	event.set_object_sequence_position(6, -114.25, 13.26, -1653.54)
	event.set_object_sequence_rotation(6, 0.0, 3.04, 0.0)
	event.set_object_sequence_position(7, -126.53, 32.32, -1662.93)
	event.set_object_sequence_rotation(7, 0.0, -3.12, 0.0)
	event.play_sound_effect(se_id, 11)
	wait_frames(45)
	event.set_character_active(0, 40)
end

return helper_b8620b27
