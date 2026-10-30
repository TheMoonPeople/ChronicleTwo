--!strict
-- map/s/s54/s54.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2609f66b = require("@lib/event/helper_2609f66b")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_45a6628c = require("@lib/event/helper_45a6628c")
local helper_61e5dba6 = require("@lib/event/helper_61e5dba6")
local helper_635196bf = require("@lib/event/helper_635196bf")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a9eaf20e = require("@lib/event/helper_a9eaf20e")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_f9968159 = require("@lib/event/helper_f9968159")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(8684)
	flag = event.get_save_flag(808) or flag
	if flag == 1 then
		helper_635196bf()
	end
end

--- Helper function.
local function helper_10690()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.set_save_flag(808, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.stop_music(0)
		helper_888ab2a3(6)
		event.load_music(107)
		event.load_map_sounds(8803)
		var1 = event.load_sound_effect_file_2(8803) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e800/e808/")
		event.load_message_file(0, 5, "e808.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e808_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e808_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e808_m_polcurse.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e808_mp_jet.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_character_to_frame(10, "jet_l", 11)
		event.copy_character(5, 11, 12)
		event.set_character_active(12)
		event.attach_character_to_frame(10, "jet_r", 12)
		block = event.load_event_image_4(5, "e808telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e808telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e808/e808_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e808/e808_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, -10.0, 0.0, 0.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 10.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 0.0, 1200.0, 1200.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_scene_status_flags(1, 10, 8)
		event.enable_drama_skip()
		event.move_object_sequence(0, -10.0, 0.0, 100.0, 100)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 100)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, 10.0, 0.0, 100.0, 100)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 100)
		event.set_object_sequence_motion(1, "立ち")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-144.53, 162.53, 269.71)
		event.set_camera_sequence_look_at(9.57, 6.12, 32.98)
		event.fade_in_screen(30)
		helper_888ab2a3(70)
		event.set_camera_sequence_position(0.0, 20.0, 60.0)
		event.set_camera_sequence_look_at(0.0, 20.0, 100.0)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8080010)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(8080020)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(8080030)
		wait_objects(0)
		wait_objects(1)
		event.play_sound_effect(var1, 0)
		event.play_music(0)
		event.move_camera_sequence_eased(0.0, 55.07, 16.58, 0.0, 132.31, 102.11, 60, 0, 0.4)
		event.set_object_sequence_rotation(2, 0.8, 3.14, 0.0)
		event.move_object_sequence_eased(2, 0.0, 70.0, 80.0, 100, 2, 0.1)
		event.set_object_sequence_motion(2, "飛びループ", 4)
		event.delay_object_sequence_motion_track(2, 86)
		event.set_object_sequence_motion(2, "体返す", 2)
		event.queue_object_sequence_next_motion(2, "体返すＬ", 4)
		wait_camera()
		wait_objects(2)
		event.stop_sound_effect(var1, 0)
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -0.12, 0.0)
		event.set_mouth_motions(2, "体返す会話", 4, "体返すＬ", 0)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8080040)
		event.set_mouth_motions(2, "体返す会話", 0, "体返すＬ", 0)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8080045)
		event.set_camera_sequence_position(-2.41, 61.81, 165.8)
		event.set_camera_sequence_look_at(0.11, 17.53, 101.88)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(8080050)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(8080060)
		event.set_camera_sequence_position(0.0, 104.52, 45.06)
		event.set_camera_sequence_look_at(0.0, 124.09, 102.11)
		event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(2, "浮遊立ち会話", 4)
		event.set_mouth_motions(2, "浮遊立ち会話", 4, "浮遊立ち", 0)
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(8080070)
		event.set_mouth_motions(2, "浮遊立ち会話", 0, "浮遊立ち", 0)
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(8080075)
		wait_objects(2)
		event.play_sound_effect(var1, 1)
		event.set_object_sequence_motion(2, "オーホホホ", 2)
		event.queue_object_sequence_next_motion(2, "オーホホホＬ", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "通常目～高笑い")
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(8080080)
		event.set_camera_sequence_position(-29.09, 25.94, 131.55)
		event.set_camera_sequence_look_at(5.81, 19.33, 91.49)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "いぶかしげ顔")
		event.set_object_handle_texture_animation(0, 1, "いぶかしげ目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(8080090)
		event.set_camera_sequence_position(0.5, 125.0, 60.0)
		event.set_camera_sequence_look_at(0.5, 125.0, 92.0)
		event.move_camera_sequence_eased(0.5, 115.0, 20.0, 0.5, 115.0, 92.0, 40, 2, 0.2)
		event.play_sound_effect(var1, 2)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "ポーズ", 6)
		event.queue_object_sequence_next_motion(2, "ポーズＬ", 4)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		event.open_voice_stream_wave(1, 8080100)
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		helper_61e5dba6(0, 180)
		event.close_voice_stream(1)
		event.play_sound_effect(var1, 3)
		event.set_object_sequence_color(3, 128, 128, 128, 0, 10)
		event.set_object_sequence_motion(2, "ゴゴゴゴ", 6)
		event.queue_object_sequence_next_motion(2, "ゴゴゴゴＬ", 6)
		event.queue_object_sequence_next_motion(2, "カメラに向かう", 6)
		event.queue_object_sequence_next_motion(2, "飛びループ", 4)
		event.delay_object_sequence_rotation_track(2, 30)
		event.rotate_object_sequence(2, 0.2, 3.14, 0.0, 40)
		event.delay_object_sequence_position_track(2, 64)
		event.move_object_sequence(2, 0.0, 66.0, 0.0, 20)
		event.move_camera_sequence_eased(0.0, 90.93, -24.95, 0.0, 108.12, 88.77, 40, 0, 0.4)
		helper_888ab2a3(10)
		event.set_event_sprite_draw_pass(0, 0)
		helper_888ab2a3(50)
		event.set_object_handle_texture_animation(2, 1, "歯くいしばり")
		event.set_motion_blur(64)
		helper_888ab2a3(21)
		event.fade_out_screen(3)
		helper_888ab2a3(3)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var1, 0)
	event.stop_sound_effect(var1, 1)
	event.stop_sound_effect(var1, 2)
	event.stop_sound_effect(var1, 3)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_motion_blur(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.play_music(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.finish_event()
end

--- Event 28010, which map data, a script or the engine runs by number.
local function event_28010()
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	event.stop_music(0)
	helper_888ab2a3(6)
	event.load_music(107)
	event.play_music(0)
	event.load_dungeon_monster(628, 1)
	event.load_dungeon_monster(1006, 0)
	event.place_dungeon_monster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	helper_7d7eee8f(0.0, 0.0, 300.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, 300.0)
	event.set_camera_position(0.0, 40.0, 180.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Helper function.
local function helper_13e98()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(812, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.load_map_sounds(8806)
		var1 = event.load_sound_effect_file_2(8806) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e800/e812/")
		event.load_message_file(0, 5, "e812.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e812_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e812_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e812_m_polcurse.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e812_mp_bakuha.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.load_character(5, "e812_mp_biribiri.gltf", "info", 12)
		event.set_character_active(12)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e812/e812_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e812/e812_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, 8.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -8.0, 0.0, 100.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "あきれ顔")
		event.set_object_handle_texture_animation(1, 1, "あきれ目パチ")
		event.set_object_handle_position(2, 0.0, 0.0, 400.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(2, "ガクガク", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くやし顔")
		event.set_object_handle_texture_animation(2, 1, "やられ目パチ")
		event.set_character_position(12, 0.0, 0.0, 400.0)
		event.set_character_rotation(12, 0.0, 3.14, 0.0)
		event.set_character_position(11, 0.0, 0.0, 400.0)
		event.set_character_rotation(11, 0.0, 3.14, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 20.91, 290.09)
		event.set_camera_sequence_look_at(0.0, 17.6, 396.09)
		event.play_sound_effect(var1, 0)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(2, "やられ口パク")
		helper_4116e6bb(8120010)
		event.set_mouth_texture_animations(2, "やられ口パク")
		helper_4116e6bb(8120015)
		event.set_camera_sequence_position(-21.92, 23.66, 134.75)
		event.set_camera_sequence_look_at(-4.36, 20.87, 105.83)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(8120020)
		wait_objects(1)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(8120030)
		wait_objects(0)
		event.set_camera_sequence_position(-27.34, 30.34, 365.86)
		event.set_camera_sequence_look_at(-0.39, 25.21, 399.29)
		event.set_object_sequence_motion(2, "きっと・・・", 4)
		event.set_mouth_texture_animations(2, "やられ口パク")
		helper_4116e6bb(8120040)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.move_camera_sequence_eased(-125.62, 18.68, 243.92, -0.39, 25.21, 399.29, 60, 0, 0.2)
		event.set_object_sequence_motion(2, "ポーズ", 6)
		event.queue_object_sequence_next_motion(2, "ポーズＬ", 4)
		event.set_mouth_texture_animations(2, "やられ口パク")
		helper_4116e6bb(8120045)
		wait_objects(2)
		wait_camera()
		event.stop_sound_effect(var1, 0)
		event.play_sound_effect(var1, 1)
		event.set_character_active(1, 11)
		event.set_character_motion(11, "MP爆発", 6)
		helper_888ab2a3(10)
		event.set_character_visible(10, 0, 1, 0.1)
		event.set_character_visible(12, 0, 1, 0.1)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-91.42, 22.7, -33.42)
		event.set_camera_sequence_look_at(-1.04, 13.67, 105.35)
		event.set_character_position(11, -105.44, 0.0, 185.46)
		event.set_character_rotation(11, 0.0, -2.78, 0.0)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(8120050)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(8120060)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(17)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_sound_effect(var1, 0)
	event.stop_sound_effect(var1, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	event_99()
	helper_7d7eee8f(0.0, 0.0, 0.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, 0.0)
	event.set_camera_position(0.0, 40.0, -120.0)
	event.reset_follow_camera(0)
	flag = event.get_save_flag(808) or flag
	if flag == 0 then
		helper_10690()
		event.set_save_control_bits(1, 1)
		vm.wait(2)
		helper_7d7eee8f(0.0, 0.0, 300.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, 300.0)
		event.set_camera_position(0.0, 40.0, 180.0)
		event.reset_follow_camera(0)
		event.load_dungeon_monster(628, 1)
		event.load_dungeon_monster(1006, 0)
		event.place_dungeon_monster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	end
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = event_28010

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 20, 5, 256, 208)
		else
			helper_75684dd8(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	var1 = helper_bac0e30d(0, 10, 8, 256, 208, 2, 1)
	if var1 == 0 then
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var3 = event.get_dungeon_floor() or var3
		argc = event.get_dungeon_next_floor(var3, 0) or argc
		event.set_dungeon_floor(argc)
		event.set_dungeon_floor_info(stage_id, var3, 5, 2)
		event.set_dungeon_floor_info(stage_id, argc, 5, 1)
		event.load_event_script("d07/d07.stb", 1000)
	else
		event.finish_event()
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(20)
		event.fade_out_screen(20)
		at = 1
		helper_888ab2a3(20)
		event.stop_music(0)
		event.clear_event_battle_monsters(-1)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		at = 2
		helper_13e98()
		event.set_save_control_bits(1, 0)
		helper_635196bf()
		helper_7d7eee8f(0.0, 0.0, 700.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, 700.0)
		event.set_camera_position(0.0, 40.0, 580.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_13e98()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 0)
					helper_635196bf()
					helper_7d7eee8f(0.0, 0.0, 700.0, 0.0)
					event.set_camera_look_at(0.0, 30.0, 700.0)
					event.set_camera_position(0.0, 40.0, 580.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			helper_45a6628c()
			helper_43f02c95(0.0, 0.0, 700.0, 0.0)
			return 0
		end
		return nil
	end)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(808) or flag
		flag_2 = event.get_save_flag(812) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var2 = 0
			var2 = vm.float_bits(event.get_random_number(100)) or var2
			if var2 < 50 then
				at = 1
				helper_a9eaf20e(0, 8590060)
			else
				at = 2
				helper_a9eaf20e(0, 8590070)
			end
			return
		end
		at = 3
		helper_f9968159(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_2609f66b(0, 8590070)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 18080, which map data, a script or the engine runs by number.
function script.event_18080()
	event_99()
	helper_10690()
end

--- Event 18120, which map data, a script or the engine runs by number.
function script.event_18120()
	event_99()
	helper_13e98()
end

script.event_28010 = event_28010

return script
