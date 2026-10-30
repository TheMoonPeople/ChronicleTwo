--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_937d87bc(se_id: s32)
	event.set_camera_sequence_position(3.45, 77.44, 1389.54)
	event.set_camera_sequence_look_at(3.0, 63.96, 1261.17)
	for var1 = 0, 11 do
		event.rotate_object_sequence(10 + var1, 0.03, 0.0, 0.0, -1)
	end
	event.play_sound_effect(se_id, 15)
	event.set_object_sequence_position(2, 0.0, -24.0, 500.0)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.set_character_active(1, 10)
	event.set_character_position(10, 1.55, 41.98, 824.64)
	event.set_character_motion(10, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	wait_frames(30)
	event.set_character_active(0, 10)
	event.move_object_sequence_eased(2, 0.0, -24.0, 5000.0, 360, 1, 0.7)
	event.play_sound_effect(se_id, 16)
	event.set_camera_sequence_position(-423.7, 77.44, 613.24)
	event.set_camera_sequence_look_at(-149.56, 63.96, 588.35)
	wait_frames(75)
	event.set_camera_sequence_position(3.45, 77.44, 1389.54)
	event.set_camera_sequence_look_at(3.0, 63.96, 1261.17)
	event.move_camera_sequence_eased(4.3, 77.44, 1631.73, 3.0, 63.96, 1261.17, 75, 2, 0.2)
	wait_frames(75)
	event.set_camera_sequence_position(-741.43, 330.34, 349.51)
	event.set_camera_sequence_look_at(-180.96, 187.05, 261.6)
	event.move_camera_sequence_eased(-741.43, 330.34, 349.51, -335.86, 187.05, 767.89, 90, 2, 0.4)
	wait_frames(150)
	event.clear_camera_sequence()
	event.delay_camera_sequence_fade_track(135)
	event.fade_out_camera_sequence(30, 0.0, 0.0)
	event.move_camera_sequence_eased(-1416.81, 608.29, -321.97, -333.28, 187.05, 759.45, 120, 0, 0.4)
	wait_frames(165)
	event.clear_camera_sequence()
	wait_frames(180)
end

return helper_937d87bc
