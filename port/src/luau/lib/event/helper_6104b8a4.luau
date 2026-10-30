--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_6104b8a4(
	world_coord_pos: f32,
	world_coord_pos_2: f32,
	world_coord_pos_3: f32,
	world_coord_rot: f32
)
	local var7: s32 = 0
	local now_party_chara_id: s32 = 0
	local language_code: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(522, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var7 = event.load_sound_effect_file_3(8, "snd2/sp/sp_043.sound.json") or var7
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		event.load_character_motion_pack(5, "event/e500/e522/e522_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "立ち", 0)
		now_party_chara_id = event.get_party_npc() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.load_npc_character(0, 5, now_party_chara_id, 33)
			event.set_character_active(0, 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.set_scene_character_type(34, 4)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		language_code = event.get_language() or language_code
		if language_code == 0 then
			event.load_message_file(0, 5, "event/e500/e522/e522.txt")
		else
			event.load_message_file(0, 5, "event/e500/e522/e522_1.txt")
		end
		event.fade_out_screen(30)
		wait_frames(30)
		event.fade_in_screen(30)
		event.play_sound_effect(var7, 0)
		event.enable_drama_skip()
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(5.32, 62.92, -97.07)
		event.set_camera_sequence_look_at(11.48, 61.6, -39.43)
		event.set_object_sequence_position(0, 39.64, -0.0, 9.33)
		event.set_object_sequence_rotation(0, 0.0, -2.33, 0.0)
		event.set_object_sequence_position(1, 34.65, 0.0, 29.92)
		event.set_object_sequence_rotation(1, 0.0, -2.36, 0.0)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 0)
		event.move_camera_sequence_eased(5.32, 24.78, -97.07, 11.48, 29.98, -39.43, 90, 2, 0.4)
		wait_camera()
		event.set_character_active(0, 33)
		event.set_camera_sequence_position(25.53, 21.33, -15.17)
		event.set_camera_sequence_look_at(32.72, 21.29, -3.29)
		event.set_object_sequence_rotation(0, 0.0, -2.69, 0.0)
		event.set_character_cloth_animation_enabled(0, 0)
		event.set_character_active(1, 34)
		event.get_object_handle_frame_position(0, "atoramiria")
		event.attach_character_to_frame(0, "atoramiria", 34)
		event.set_character_position(34, 0.04, -1.42988, 0.89)
		event.delay_object_sequence_sound_track(2, 25)
		event.play_object_sequence_sound(2, var7, 1)
		event.set_object_sequence_motion(2, "発動", 6)
		event.queue_object_sequence_next_motion(2, "発動L", 0)
		event.set_object_sequence_motion(0, "アトラ見る", 6)
		event.queue_object_sequence_next_motion(0, "アトラ見るL", 0)
		wait_objects(0)
		event.set_object_sequence_motion(0, "アトラさわる", 6)
		event.queue_object_sequence_next_motion(0, "アトラさわるL", 6)
		helper_4116e6bb(5220010)
		helper_4116e6bb(5220015)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var7, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
end

return helper_6104b8a4
