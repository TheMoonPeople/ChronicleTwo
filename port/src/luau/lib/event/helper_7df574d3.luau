--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0e75aa9e = require("@lib/event/helper_0e75aa9e")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2f8c501c = require("@lib/event/helper_2f8c501c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_705b02bc = require("@lib/event/helper_705b02bc")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_917013c0 = require("@lib/event/helper_917013c0")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_7df574d3()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var6: s32 = 0
	local projection: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(612, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(33)
		event.load_map_sounds(7810)
		var0 = event.load_sound_effect_file_2(7810) or var0
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_051.sound.json") or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e600/e612/")
		event.load_message_file(0, 5, "e612_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e612_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e612_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_equipment_model(5, 0, 0, "info", 8, 10)
			event.load_equipment_model(5, 0, 1, "info", 8, 11)
			event.load_character_motion_pack(5, "event/e600/e612/e612_mints.gltf", "info", 8)
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
			event.load_equipment_model(5, 1, 0, "info", 8, 10)
			event.load_equipment_model(5, 1, 1, "info", 8, 11)
			event.load_character_motion_pack(5, "event/e600/e612/e612_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(1, 10)
		event.set_character_active(1, 11)
		event.load_character(5, "event/e600/e612/e612_atora_a.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2, 12)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e600/e612/e612_atora_b.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(3, 13)
		event.clear_object_sequence(3, 13)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e600/e612/e612_sun.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(4, 14)
		event.clear_object_sequence(4, 14)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/e600/e612/e612_griffon.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(5, 15)
		event.clear_object_sequence(5, 15)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "event/e600/e612/e612_sun_ray.gltf", "info", 16)
		event.set_character_active(16)
		event.attach_object_handle_to_character(6, 16)
		event.clear_object_sequence(6, 16)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "event/e600/e612/e612_ghikari.gltf", "info", 17)
		event.set_character_active(17)
		event.attach_object_handle_to_character(7, 17)
		event.clear_object_sequence(7, 17)
		event.set_object_sequence_object(7, 7)
		event.load_character(5, "event/e600/e612/e612_hiraki.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_object_handle_to_character(8, 18)
		event.clear_object_sequence(8, 18)
		event.set_object_sequence_object(8, 8)
		event.load_character(5, "event/e600/e612/e612_sun_eye.gltf", "info", 19)
		event.set_character_active(19)
		event.attach_object_handle_to_character(9, 19)
		event.clear_object_sequence(9, 19)
		event.set_object_sequence_object(9, 9)
		event.set_object_handle_position(0, 18.48, 0.2, 307.68)
		event.set_object_handle_rotation(0, 0.0, -0.53, 0.0)
		event.set_object_handle_motion(0, "戦闘立ち", 4)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_position(1, -23.14, 0.2, 308.89)
		event.set_object_handle_rotation(1, 0.0, 0.23, 0.0)
		event.set_object_handle_motion(1, "剣構え", 4)
		event.set_object_handle_footstep_sound(1, 21)
		event.set_object_handle_position(4, 4.86, 0.2, 441.28)
		event.set_object_handle_rotation(4, 0.0, -3.13, 0.0)
		event.set_object_handle_motion(4, "よろよろ立ち", 4)
		event.set_object_handle_footstep_sound(4, 21)
		event.attach_character_to_frame(14, "hikari", 19)
		event.set_object_handle_visible(9, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-78.74, 78.05, 198.62)
		event.set_camera_sequence_look_at(13.39, 2.21, 381.09)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(14)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "くるし目パチ")
		at = 3
		wait_frames(60)
		event.set_camera_sequence_position(-41.54, 14.05, 496.91)
		event.set_camera_sequence_look_at(12.6, 11.66, 379.4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "くるし目～目とじ")
		event.set_object_sequence_motion(4, "よろよろ会話", 6)
		event.queue_object_sequence_next_motion(4, "よろよろ立ち", 4)
		at = 4
		helper_1584c528(6120010, -1)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(4, "倒れる", 6)
		event.queue_object_sequence_next_motion(4, "倒れるＬ", 4)
		at = 5
		wait_objects(4)
		at = 6
		wait_frames(60)
		event.set_camera_sequence_position(-88.01, 116.61, 327.84)
		event.set_camera_sequence_look_at(2.74, 11.66, 406.61)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_object_sequence_position(0, 33.71, 0.2, 365.11)
		event.set_object_sequence_rotation(0, 0.0, -0.17, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -23.96, 0.2, 368.34)
		event.set_object_sequence_rotation(1, 0.0, 0.23, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 28.35, 0.2, 422.7, 60, 1)
		event.delay_object_sequence_rotation_track(0, 30)
		event.rotate_object_sequence(0, 0.0, -0.89, 0.0, 50)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き", 4)
		event.move_object_sequence(1, -23.16, 0.2, 421.62, 70, 1)
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, 0.95, 0.0, 50)
		event.delay_object_sequence_motion_track(1, 70)
		event.set_object_sequence_motion(1, "立ち")
		at = 7
		wait_frames(90)
		at = 8
		helper_4116e6bb(6120020)
		at = 9
		helper_4116e6bb(6120030)
		event.set_camera_sequence_position(-36.88, 13.32, 371.24)
		event.set_camera_sequence_look_at(-0.58, 15.51, 433.62)
		event.set_object_sequence_position(0, 24.07, 0.2, 434.14)
		event.set_object_sequence_rotation(0, 0.0, -1.61, 0.0)
		event.set_object_sequence_motion(0, "下見立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -16.95, 0.2, 431.66)
		event.set_object_sequence_rotation(1, 0.0, 1.19, 0.0)
		event.set_object_sequence_motion(1, "下向き立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		at = 10
		wait_frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.play_sound_effect(var0, 1)
		event.set_object_sequence_motion(4, "起き上がる", 6)
		event.queue_object_sequence_next_motion(4, "石持ち立ち")
		event.set_object_sequence_motion(0, "のけぞる", 6)
		event.queue_object_sequence_next_motion(0, "のけぞるL", 4)
		event.set_object_sequence_motion(1, "のけぞり", 6)
		event.queue_object_sequence_next_motion(1, "のけぞりL", 4)
		at = 11
		wait_objects(4)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.set_camera_sequence_position(18.01, 15.67, 424.73)
		event.set_camera_sequence_look_at(26.69, 15.51, 433.92)
		event.set_character_active(12)
		event.set_object_sequence_position(4, 9.42, 0.2, 432.34)
		event.set_object_sequence_rotation(4, 0.0, 1.95, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 0 then
			event.show_atlamillia_frames(0, 0, 0)
		else
			event.show_atlamillia_frames(0, 8, 0)
		end
		event.set_object_sequence_position(2, 25.41, 12.88, 433.35)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.set_object_sequence_motion(4, "ユリスからもぎ取る", 6)
		event.set_object_sequence_motion_step(4, 0.4)
		at = 12
		wait_frames(16)
		event.play_sound_effect(var0, 2)
		event.move_object_sequence(2, 24.24, 8.61, 429.7, 3)
		at = 13
		wait_frames(6)
		event.set_character_active(0, 12)
		event.set_camera_sequence_position(-18.72, 20.05, 442.61)
		event.set_camera_sequence_look_at(-16.52, 16.03, 434.01)
		event.set_character_active(1, 13)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			event.show_atlamillia_frames(1, 0, 0)
		else
			event.show_atlamillia_frames(1, 8, 0)
		end
		event.set_object_sequence_position(4, -3.81, 0.2, 442.31)
		event.set_object_sequence_rotation(4, 0.0, -2.33, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_object_sequence_position(3, -15.16, 15.1, 434.91)
		event.set_object_sequence_rotation(3, -0.6, 0.72, 0.0)
		event.set_object_sequence_motion(1, "目で追うL", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(4, "モニカから奪う", 4)
		event.set_object_sequence_motion_step(4, 0.4)
		event.set_scene_status_flags(1, 0, 256, 0)
		at = 14
		wait_frames(10)
		event.play_sound_effect(var0, 3)
		event.move_object_sequence(3, -8.89, 18.29, 433.34, 3)
		at = 15
		wait_frames(8)
		event.set_camera_sequence_position(-32.04, 13.37, 229.44)
		event.set_camera_sequence_look_at(23.02, 3.56, 367.15)
		event.set_character_active(1, 12)
		event.set_character_active(1, 13)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(14, "aka_null", 12)
		event.attach_character_to_frame(14, "ao_null", 13)
		event.set_object_sequence_position(0, 24.07, 0.2, 434.14)
		event.set_object_sequence_rotation(0, 0.0, -1.61, 0.0)
		event.set_object_sequence_motion(0, "のけぞるL", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -16.95, 0.2, 431.66)
		event.set_object_sequence_rotation(1, 0.0, 1.19, 0.0)
		event.set_object_sequence_motion(1, "のけぞりL", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(4, 4.86, 0.2, 441.28)
		event.set_object_sequence_rotation(4, 0.0, -3.13, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_object_sequence_motion(4, "ジャンプ", 4)
		at = 16
		wait_frames(30)
		event.play_sound_effect(var0, 4)
		event.move_object_sequence(4, -4.5, 0.2, 273.3, 30)
		event.delay_object_sequence_motion_track(4, 30)
		event.queue_object_sequence_next_motion(4, "石持ち立ち")
		event.delay_object_sequence_sound_track(4, 30)
		event.play_object_sequence_sound(4, var0, 5)
		event.set_object_sequence_motion(0, "しまった！", 6)
		event.queue_object_sequence_next_motion(0, "しまった！L", 4)
		event.set_object_sequence_motion(1, "目で追う", 6)
		event.queue_object_sequence_next_motion(1, "目で追うL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 17
		helper_1584c528(6120040, 45)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 18
		helper_1584c528(6120050, 70)
		event.play_music(0)
		event.set_camera_sequence_position(-33.83, 58.84, 228.9)
		event.set_camera_sequence_look_at(2.4, 12.62, 165.61)
		event.set_object_sequence_position(4, -0.94, 0.2, 167.47)
		event.reset_object_sequence_dynamic_animation(4)
		event.play_sound_effect(var0, 6)
		event.set_object_sequence_motion(4, "振り返る", 6)
		event.rotate_object_sequence(4, 0.0, -0.01, 0.0, 30)
		event.delay_object_sequence_motion_track(4, 30)
		event.queue_object_sequence_next_motion(4, "石持ち立ち")
		at = 19
		wait_objects(4)
		at = 20
		wait_frames(30)
		event.set_object_sequence_motion(4, "不敵に笑う", 6)
		event.queue_object_sequence_next_motion(4, "不敵に笑うＬ", 4)
		event.delay_object_sequence_motion_track(4, 60)
		event.queue_object_sequence_next_motion(4, "不敵に笑う戻り", 4)
		event.queue_object_sequence_next_motion(4, "石持ち立ち", 4)
		at = 21
		helper_1584c528(6120060, -1)
		at = 22
		wait_frames(30)
		at = 23
		wait_objects(4)
		event.set_object_sequence_motion(4, "石持ち会話", 6)
		event.queue_object_sequence_next_motion(4, "石持ち立ち", 4)
		at = 24
		helper_1584c528(6120065, -1)
		at = 25
		wait_objects(4)
		event.set_camera_sequence_position(-1.12, 3.57, 211.52)
		event.set_camera_sequence_look_at(-1.09, 17.17, 165.43)
		event.set_object_sequence_motion(4, "力を込める", 6)
		event.queue_object_sequence_next_motion(4, "力を込めるＬ", 4)
		at = 26
		wait_frames(60)
		event.set_camera_sequence_position(30.46, 10.46, 194.28)
		event.set_camera_sequence_look_at(-4.46, 14.37, 169.28)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "こわれ目～赤目")
		event.set_object_handle_visible(9, 1)
		event.set_object_sequence_motion(4, "前傾姿勢", 6)
		event.queue_object_sequence_next_motion(4, "前傾姿勢Ｌ", 4)
		event.set_character_active(16)
		event.set_character_visible(16, 1, 1, 0.033333335)
		event.set_object_sequence_position(6, -0.95, 0.2, 164.64)
		event.set_object_sequence_motion(6, "前傾姿勢Ｌ")
		event.shake_camera_sequence_vertically(0.0, 0.2, 0.0, 360)
		event.play_sound_effect(var0, 7)
		at = 27
		helper_1584c528(6120070, 60)
		event.set_object_sequence_rotation(0, 0.0, -2.81, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		at = 28
		wait_frames(60)
		event.start_crossfade(30)
		event.set_camera_sequence_position(27.23, 15.0, 106.78)
		event.set_camera_sequence_look_at(5.4, 11.56, 187.66)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		at = 29
		wait_frames(90)
		event.set_camera_sequence_position(1.44, 19.01, 221.87)
		event.set_camera_sequence_look_at(-0.86, 15.58, 174.12)
		event.set_object_sequence_motion(6, "アトラミリア光る")
		at = 30
		wait_frames(60)
		event.set_camera_sequence_position(69.6, 17.0, 511.44)
		event.set_camera_sequence_look_at(42.17, 15.58, 462.62)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ")
		event.set_object_sequence_motion(6, "発光")
		event.set_object_sequence_motion_step(6, 0.2)
		at = 31
		wait_frames(15)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "！！", 6)
		event.queue_object_sequence_next_motion(0, "！！L", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "まぶしい", 6)
		event.queue_object_sequence_next_motion(1, "まぶしいL", 4)
		at = 32
		wait_frames(15)
		at = 33
		helper_1584c528(6120080, 30)
		event.fade_out_screen(30, 255, 255, 255)
		at = 34
		wait_frames(30)
		event.fade_out_music(30)
		at = 35
		wait_frames(30)
		event.set_character_active(0, 14)
		event.set_character_active(0, 19)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 16)
		event.set_character_active(15)
		event.set_object_sequence_position(5, -0.95, 0.2, 164.64)
		event.set_camera_sequence_position(-1.32, 10.92, 232.98)
		event.set_camera_sequence_look_at(-1.51, 5.74, 176.6)
		event.set_object_sequence_motion(5, "立ち（前傾）")
		at = 36
		wait_frames(30)
		event.fade_in_screen(30, 255, 255, 255)
		event.play_sound_effect(var1, 0)
		event.move_camera_sequence_eased(-1.32, 10.92, 232.98, -1.51, 45.85, 176.6, 180, 0, 0.5)
		at = 37
		wait_camera()
		at = 38
		wait_frames(30)
		event.set_camera_sequence_position(83.44, 109.23, 85.27)
		event.set_camera_sequence_look_at(11.63, 44.02, 193.11)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_position(0, 16.61, 0.2, 323.16)
		event.set_object_sequence_rotation(0, 0.0, -2.81, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -19.07, 0.2, 324.55)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(5, "身を起こす", 6)
		event.queue_object_sequence_next_motion(5, "身を起こすＬ", 4)
		event.move_camera_sequence_eased(2.49, 42.34, 46.29, 5.69, 44.02, 193.66, 120, 0, 0.5)
		at = 39
		helper_1584c528(6120090, 180)
		at = 40
		wait_camera()
		event.set_camera_sequence_position(37.69, 39.48, 235.92)
		event.set_camera_sequence_look_at(-1.18, 50.99, 170.42)
		x = vm.f32(-22.54)
		y = vm.f32(20.9)
		z = vm.f32(332.85)
		do
			local out1, out2, out3 = event.subtract_vectors(x, y, z, -8.96, 10.09, 279.73)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		event.set_wind(10, x, y, z)
		event.set_motion_blur(100)
		event.play_sound_effect(var0, 8)
		event.set_object_sequence_motion(5, "開く", 6)
		event.queue_object_sequence_next_motion(5, "開くＬ", 4)
		event.set_character_active(18)
		event.delay_object_sequence_motion_track(8, 40)
		event.set_object_sequence_motion(8, "開くＬ", 6)
		event.set_object_sequence_motion(0, "！！L", 4)
		event.set_object_sequence_motion(1, "まぶしいL", 4)
		event.move_camera_sequence_eased(56.18, 9.11, 279.47, -1.71, 41.43, 163.58, 90, 0, 0.5)
		at = 41
		wait_camera()
		event.set_camera_sequence_position(-63.65, 24.75, 289.98)
		event.set_camera_sequence_look_at(19.98, 11.48, 346.64)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ")
		event.set_object_sequence_motion(5, "立ち", 4)
		at = 42
		wait_frames(60)
		event.set_character_active(0, 18)
		event.set_camera_sequence_position(45.23, 12.53, 223.31)
		event.set_camera_sequence_look_at(1.37, 42.75, 168.22)
		event.set_wind(-1)
		event.set_motion_blur(0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(5, "会話１")
		at = 43
		helper_1584c528(6120100, -1)
		at = 44
		wait_frames(60)
		at = 45
		wait_objects(5)
		event.set_camera_sequence_position(-1.79, 7.56, 386.42)
		event.set_camera_sequence_look_at(-1.26, 25.12, 274.31)
		event.stop_music(0)
		at = 46
		wait_frames(4)
		event.load_music(167)
		event.play_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(5, "立ち１から立ち２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 47
		helper_4116e6bb(6120110)
		at = 48
		wait_objects(5)
		event.set_camera_sequence_position(-49.43, 5.59, 296.0)
		event.set_camera_sequence_look_at(-7.47, 21.65, 323.75)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "前～左～前")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 49
		helper_4116e6bb(6120120)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 50
		helper_4116e6bb(6120125)
		at = 51
		wait_objects(1)
		event.set_camera_sequence_position(-1.79, 7.56, 386.42)
		event.set_camera_sequence_look_at(-1.26, 25.12, 274.31)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		at = 52
		helper_4116e6bb(6120130)
		event.set_object_sequence_motion(5, "会話２", 4)
		event.delay_object_sequence_motion_track(5, 30)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 53
		helper_4116e6bb(6120135)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 54
		helper_4116e6bb(6120140)
		at = 55
		wait_objects(5)
		event.set_camera_sequence_position(45.23, 12.53, 223.31)
		event.set_camera_sequence_look_at(1.37, 42.75, 168.22)
		event.set_object_sequence_motion(5, "会話２", 4)
		event.delay_object_sequence_motion_track(5, 60)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 56
		helper_1584c528(6120150, 150)
		at = 57
		wait_objects(5)
		event.set_camera_sequence_position(105.2, 163.52, 42.91)
		event.set_camera_sequence_look_at(-2.23, 23.98, 214.38)
		event.set_object_sequence_motion(5, "会話２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 58
		helper_1584c528(6120160, 150)
		event.set_object_sequence_motion(5, "立ち２から立ち１", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		at = 59
		helper_1584c528(6120165, 240)
		at = 60
		wait_objects(5)
		event.set_object_sequence_motion(5, "立ち１から立ち２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		event.start_crossfade(30)
		event.set_camera_sequence_position(4.09, 53.77, 197.71)
		event.set_camera_sequence_look_at(12.21, 56.05, 168.85)
		event.set_object_sequence_motion(5, "会話２")
		event.open_voice_stream_wave(1, 6120170)
		at = 61
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.move_camera_sequence(7.33, 53.77, 186.18, 12.21, 56.05, 168.85, 350)
		event.open_message_window_2(0, 6120170)
		open_message(0, -1, 8, 0, 0)
		while var6 < 350 do
			projection = vm.f32(vm.f32(vm.f32(vm.f32(-224.90002) * var6) / 350) + vm.f32(524.9))
			event.set_event_projection(projection)
			var6 = var6 + 1
			at = 62
			vm.wait(62)
		end
		close_message(0)
		event.close_voice_stream(1)
		at = 63
		wait_camera()
		event.set_event_projection(524.9)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-26.16, 2.12, 260.08)
		event.set_camera_sequence_look_at(-0.76, 24.0, 324.82)
		event.set_object_sequence_motion(5, "立ち2", 4)
		at = 64
		helper_1584c528(6120180, 240)
		event.start_crossfade(30)
		event.set_camera_sequence_position(52.31, 50.13, 183.8)
		event.set_camera_sequence_look_at(-3.22, 50.82, 166.04)
		event.set_object_sequence_motion(5, "会話２", 6)
		event.delay_object_sequence_motion_track(5, 30)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 65
		helper_1584c528(6120185, 130)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.43, 137.04, 56.89)
		event.set_camera_sequence_look_at(-1.45, 10.06, 253.11)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 66
		helper_1584c528(6120190, 90)
		event.set_object_sequence_motion(5, "立ち２から立ち１", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.queue_object_sequence_next_motion(5, "会話１", 4)
		at = 67
		helper_1584c528(6120200, -1)
		at = 68
		wait_frames(15)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.start_crossfade(30)
		event.set_camera_sequence_position(43.9, 23.5, 203.81)
		event.set_camera_sequence_look_at(-3.91, 54.72, 160.7)
		at = 69
		wait_frames(30)
		event.play_sound_effect(var0, 9)
		event.set_object_sequence_motion(5, "握る", 6)
		event.queue_object_sequence_next_motion(5, "会話（握る）")
		event.delay_object_sequence_motion_track(5, 180)
		event.queue_object_sequence_next_motion(5, "握るL", 4)
		at = 70
		helper_1584c528(6120210, -1)
		at = 71
		wait_frames(30)
		at = 72
		wait_objects(5)
		event.delay_object_sequence_motion_track(5, 40)
		event.set_object_sequence_motion(5, "振り払う", 6)
		event.queue_object_sequence_next_motion(5, "会話（振り払う）", 4)
		event.delay_object_sequence_motion_track(5, 90)
		event.set_object_sequence_motion(5, "振り払うL")
		event.delay_object_sequence_sound_track(5, 40)
		event.play_object_sequence_sound(5, var0, 10)
		event.open_voice_stream_wave(1, 6120220)
		at = 73
		helper_9cbdc640(1)
		event.open_message_window_2(0, 6120220)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 74
		wait_frames(40)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.88, 46.09, 208.27)
		event.set_camera_sequence_look_at(-1.11, 54.76, 161.71)
		at = 75
		helper_917013c0(0, -1)
		close_message(0)
		event.close_voice_stream(1)
		at = 76
		wait_objects(5)
		at = 77
		wait_frames(30)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.43, 137.04, 56.89)
		event.set_camera_sequence_look_at(-1.45, 10.06, 253.11)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(5)
		at = 78
		wait_frames(15)
		event.set_object_sequence_motion(5, "立ち１から立ち２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 79
		helper_0e75aa9e(6120230, -1, 30)
		at = 80
		wait_objects(5)
		at = 81
		wait_frames(50)
		event.start_crossfade(30)
		event.set_camera_sequence_position(52.31, 50.13, 183.8)
		event.set_camera_sequence_look_at(-3.22, 50.82, 166.04)
		event.set_object_sequence_motion(5, "会話２", 4)
		event.open_voice_stream_wave(1, 6120240)
		at = 82
		helper_9cbdc640(1)
		event.open_message_window_2(0, 6120240)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 83
		wait_frames(150)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.16, 53.95, 203.33)
		event.set_camera_sequence_look_at(-0.35, 56.22, 163.1)
		event.move_camera_sequence(-1.0, 53.95, 195.45, -0.35, 56.22, 163.1, 60)
		at = 84
		helper_917013c0(0, -1)
		close_message(0)
		event.close_voice_stream(1)
		event.queue_object_sequence_next_motion(5, "立ち2")
		at = 85
		wait_frames(90)
		event.start_crossfade(30)
		event.set_camera_sequence_position(45.23, 12.53, 223.31)
		event.set_camera_sequence_look_at(1.37, 42.75, 168.22)
		event.set_object_sequence_motion(5, "見上げ", 6)
		event.queue_object_sequence_next_motion(5, "見上げＬ", 4)
		at = 86
		helper_1584c528(6120250, -1)
		at = 87
		wait_objects(5)
		at = 88
		wait_frames(60)
		event.set_camera_sequence_position(-41.31, 31.65, 268.93)
		event.set_camera_sequence_look_at(5.77, 11.37, 343.93)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.set_object_sequence_motion(1, "なに言ってるの？", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 89
		helper_1584c528(6120260, 210)
		at = 90
		wait_objects(1)
		at = 91
		wait_frames(30)
		event.set_camera_sequence_position(-0.97, 16.6, 262.08)
		event.set_camera_sequence_look_at(-1.15, 60.73, 165.4)
		event.set_object_sequence_motion(5, "会話２")
		at = 92
		helper_1584c528(6120270, -1)
		at = 93
		wait_frames(20)
		at = 94
		helper_1584c528(6120273, -1)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		at = 95
		wait_objects(5)
		at = 96
		wait_frames(30)
		event.set_camera_sequence_position(146.05, 155.76, 44.66)
		event.set_camera_sequence_look_at(7.17, 5.69, 214.11)
		event.set_object_sequence_motion(5, "見上げ", 6)
		event.queue_object_sequence_next_motion(5, "見上げＬ", 4)
		at = 97
		helper_1584c528(6120280, -1)
		at = 98
		wait_frames(40)
		at = 99
		helper_1584c528(6120285, -1)
		at = 100
		wait_frames(30)
		event.set_camera_sequence_position(6.43, 18.29, 287.68)
		event.set_camera_sequence_look_at(16.25, 19.34, 324.59)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.play_sound_effect(var0, 11)
		event.set_object_sequence_motion(0, "そんなこと", 6)
		event.queue_object_sequence_next_motion(0, "そんなことL", 4)
		event.delay_object_sequence_motion_track(0, 45)
		event.set_object_sequence_motion(0, "させない", 6)
		event.queue_object_sequence_next_motion(0, "させないL", 4)
		event.delay_object_sequence_sound_track(0, 70)
		event.play_object_sequence_sound(0, var0, 12)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 101
		helper_1584c528(6120290, 75)
		at = 102
		wait_frames(30)
		event.set_camera_sequence_position(-6.44, 50.54, 216.04)
		event.set_camera_sequence_look_at(-1.0, 48.49, 160.07)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(5, "会話１", 4)
		at = 103
		helper_1584c528(6120300, -1)
		at = 104
		wait_frames(30)
		event.set_object_sequence_motion(5, "指す", 2)
		event.queue_object_sequence_next_motion(5, "指す会話", 4)
		at = 105
		helper_1584c528(6120305, -1)
		event.queue_object_sequence_next_motion(5, "指すＬ", 4)
		at = 106
		wait_objects(5)
		at = 107
		wait_frames(20)
		event.set_object_sequence_motion(5, "握る２", 6)
		event.queue_object_sequence_next_motion(5, "会話（握る２）", 4)
		event.delay_object_sequence_motion_track(5, 180)
		event.set_object_sequence_motion(5, "振り払う（握る2）", 6)
		event.set_object_sequence_motion(5, "振り払うＬ（握る2）")
		event.delay_object_sequence_sound_track(5, 200)
		event.play_object_sequence_sound(5, var0, 10)
		at = 108
		helper_1584c528(6120310, -1)
		at = 109
		wait_objects(5)
		at = 110
		wait_frames(30)
		event.set_camera_sequence_position(-1.79, 7.56, 386.42)
		event.set_camera_sequence_look_at(-1.26, 25.12, 274.31)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.reset_object_sequence_dynamic_animation(5)
		at = 111
		wait_frames(20)
		event.set_object_sequence_motion(5, "会話２", 4)
		at = 112
		helper_1584c528(6120320, -1)
		event.queue_object_sequence_next_motion(5, "立ち2")
		at = 113
		wait_frames(20)
		event.set_camera_sequence_position(22.17, 49.65, 213.77)
		event.set_camera_sequence_look_at(-1.95, 51.8, 171.81)
		event.set_object_sequence_motion(5, "会話２", 4)
		at = 114
		helper_1584c528(6120323, -1)
		event.queue_object_sequence_next_motion(5, "立ち2")
		at = 115
		wait_frames(20)
		event.set_object_sequence_motion(5, "両手ゆっくり", 6)
		event.queue_object_sequence_next_motion(5, "両手ゆっくりＬ", 4)
		at = 116
		helper_1584c528(6120327, -1)
		at = 117
		wait_objects(5)
		event.set_camera_sequence_position(27.8, 20.33, 262.64)
		event.set_camera_sequence_look_at(4.57, 15.57, 325.51)
		at = 118
		wait_frames(15)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "身構え", 6)
		event.queue_object_sequence_next_motion(1, "身構えL", 4)
		at = 119
		wait_frames(60)
		event.set_camera_sequence_position(17.33, 128.97, 230.66)
		event.set_camera_sequence_look_at(0.33, 49.98, 168.45)
		event.set_character_active(17)
		event.set_character_visible(17, 1, 1, 0.033333335)
		event.set_object_sequence_position(7, -0.95, 0.2, 164.64)
		event.play_sound_effect(var0, 13)
		event.set_object_sequence_motion(5, "天に", 6)
		event.queue_object_sequence_next_motion(5, "天にＬ", 4)
		event.play_sound_effect(var0, 14)
		event.play_sound_effect(var0, 15)
		at = 120
		wait_frames(30)
		event.shake_camera_sequence_vertically(0.0, 0.3, 0.0, -1)
		event.play_sound_effect(var0, 16)
		at = 121
		wait_frames(30)
		event.set_camera_sequence_position(-6.24, 49.19, 375.53)
		event.set_camera_sequence_look_at(-1.83, 51.77, 225.87)
		at = 122
		wait_frames(90)
		event.set_camera_sequence_position(-31.26, 4.98, 277.65)
		event.set_camera_sequence_look_at(0.45, 22.39, 330.46)
		event.set_object_sequence_motion(0, "びっくり", 6)
		event.queue_object_sequence_next_motion(0, "びっくりL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "ぐらり", 6)
		event.queue_object_sequence_next_motion(1, "ぐらりL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		at = 123
		wait_frames(90)
		event.set_camera_sequence_position(57.69, 37.12, 273.28)
		event.set_camera_sequence_look_at(0.0, 49.89, 171.27)
		at = 124
		wait_frames(60)
		event.set_camera_sequence_position(-28.88, 35.65, 295.17)
		event.set_camera_sequence_look_at(-16.06, 17.38, 336.62)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 125
		helper_1584c528(6120330, -1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 126
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(4)
		end
		if at <= 2 then
			wait_frames_skipping(60)
		end
		if at <= 3 then
			helper_52aadc70(6120010, -1)
		end
		if at <= 4 then
			helper_238b5abc(4)
		end
		if at <= 5 then
			wait_frames_skipping(60)
		end
		if at <= 6 then
			wait_frames_skipping(90)
		end
		if at <= 7 then
			helper_8cd371d7(6120020)
		end
		if at <= 8 then
			helper_8cd371d7(6120030)
		end
		if at <= 9 then
			wait_frames_skipping(30)
		end
		if at <= 10 then
			helper_238b5abc(4)
		end
		if at <= 11 then
			wait_frames_skipping(16)
		end
		if at <= 12 then
			wait_frames_skipping(6)
		end
		if at <= 13 then
			wait_frames_skipping(10)
		end
		if at <= 14 then
			wait_frames_skipping(8)
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			helper_52aadc70(6120040, 45)
		end
		if at <= 17 then
			helper_52aadc70(6120050, 70)
		end
		if at <= 18 then
			helper_238b5abc(4)
		end
		if at <= 19 then
			wait_frames_skipping(30)
		end
		if at <= 20 then
			helper_52aadc70(6120060, -1)
		end
		if at <= 21 then
			wait_frames_skipping(30)
		end
		if at <= 22 then
			helper_238b5abc(4)
		end
		if at <= 23 then
			helper_52aadc70(6120065, -1)
		end
		if at <= 24 then
			helper_238b5abc(4)
		end
		if at <= 25 then
			wait_frames_skipping(60)
		end
		if at <= 26 then
			helper_52aadc70(6120070, 60)
		end
		if at <= 27 then
			wait_frames_skipping(60)
		end
		if at <= 28 then
			wait_frames_skipping(90)
		end
		if at <= 29 then
			wait_frames_skipping(60)
		end
		if at <= 30 then
			wait_frames_skipping(15)
		end
		if at <= 31 then
			wait_frames_skipping(15)
		end
		if at <= 32 then
			helper_52aadc70(6120080, 30)
		end
		if at <= 33 then
			wait_frames_skipping(30)
		end
		if at <= 34 then
			wait_frames_skipping(30)
		end
		if at <= 35 then
			wait_frames_skipping(30)
		end
		if at <= 36 then
			helper_344d6cd8()
		end
		if at <= 37 then
			wait_frames_skipping(30)
		end
		if at <= 38 then
			helper_52aadc70(6120090, 180)
		end
		if at <= 39 then
			helper_344d6cd8()
		end
		if at <= 40 then
			x = vm.f32(-22.54)
			y = vm.f32(20.9)
			z = vm.f32(332.85)
			helper_344d6cd8()
		end
		if at <= 41 then
			wait_frames_skipping(60)
		end
		if at <= 42 then
			helper_52aadc70(6120100, -1)
		end
		if at <= 43 then
			wait_frames_skipping(60)
		end
		if at <= 44 then
			helper_238b5abc(5)
		end
		if at <= 45 then
			wait_frames_skipping(4)
		end
		if at <= 46 then
			helper_8cd371d7(6120110)
		end
		if at <= 47 then
			helper_238b5abc(5)
		end
		if at <= 48 then
			helper_8cd371d7(6120120)
		end
		if at <= 49 then
			helper_8cd371d7(6120125)
		end
		if at <= 50 then
			helper_238b5abc(1)
		end
		if at <= 51 then
			helper_8cd371d7(6120130)
		end
		if at <= 52 then
			helper_8cd371d7(6120135)
		end
		if at <= 53 then
			helper_8cd371d7(6120140)
		end
		if at <= 54 then
			helper_238b5abc(5)
		end
		if at <= 55 then
			helper_52aadc70(6120150, 150)
		end
		if at <= 56 then
			helper_238b5abc(5)
		end
		if at <= 57 then
			helper_52aadc70(6120160, 150)
		end
		if at <= 58 then
			helper_52aadc70(6120165, 240)
		end
		if at <= 59 then
			helper_238b5abc(5)
		end
		if at <= 60 then
			helper_238b5abc(1)
		end
		if at <= 61 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			projection = vm.f32(vm.f32(vm.f32(vm.f32(-224.90002) * var6) / 350) + vm.f32(524.9))
			local _ = var6 < 350
			var6 = var6 + 1
		end
		if at <= 62 then
			helper_d16eef1e(0)
			helper_344d6cd8()
		end
		if at <= 63 then
			helper_52aadc70(6120180, 240)
		end
		if at <= 64 then
			helper_52aadc70(6120185, 130)
		end
		if at <= 65 then
			helper_52aadc70(6120190, 90)
		end
		if at <= 66 then
			helper_52aadc70(6120200, -1)
		end
		if at <= 67 then
			wait_frames_skipping(15)
		end
		if at <= 68 then
			wait_frames_skipping(30)
		end
		if at <= 69 then
			helper_52aadc70(6120210, -1)
		end
		if at <= 70 then
			wait_frames_skipping(30)
		end
		if at <= 71 then
			helper_238b5abc(5)
		end
		if at <= 72 then
			helper_238b5abc(1)
		end
		if at <= 73 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			wait_frames_skipping(40)
		end
		if at <= 74 then
			helper_705b02bc(0, -1)
		end
		if at <= 75 then
			helper_d16eef1e(0)
			helper_238b5abc(5)
		end
		if at <= 76 then
			wait_frames_skipping(30)
		end
		if at <= 77 then
			wait_frames_skipping(15)
		end
		if at <= 78 then
			helper_2f8c501c(6120230, -1, 30)
		end
		if at <= 79 then
			helper_238b5abc(5)
		end
		if at <= 80 then
			wait_frames_skipping(50)
		end
		if at <= 81 then
			helper_238b5abc(1)
		end
		if at <= 82 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			wait_frames_skipping(150)
		end
		if at <= 83 then
			helper_705b02bc(0, -1)
		end
		if at <= 84 then
			helper_d16eef1e(0)
			wait_frames_skipping(90)
		end
		if at <= 85 then
			helper_52aadc70(6120250, -1)
		end
		if at <= 86 then
			helper_238b5abc(5)
		end
		if at <= 87 then
			wait_frames_skipping(60)
		end
		if at <= 88 then
			helper_52aadc70(6120260, 210)
		end
		if at <= 89 then
			helper_238b5abc(1)
		end
		if at <= 90 then
			wait_frames_skipping(30)
		end
		if at <= 91 then
			helper_52aadc70(6120270, -1)
		end
		if at <= 92 then
			wait_frames_skipping(20)
		end
		if at <= 93 then
			helper_52aadc70(6120273, -1)
		end
		if at <= 94 then
			helper_238b5abc(5)
		end
		if at <= 95 then
			wait_frames_skipping(30)
		end
		if at <= 96 then
			helper_52aadc70(6120280, -1)
		end
		if at <= 97 then
			wait_frames_skipping(40)
		end
		if at <= 98 then
			helper_52aadc70(6120285, -1)
		end
		if at <= 99 then
			wait_frames_skipping(30)
		end
		if at <= 100 then
			helper_52aadc70(6120290, 75)
		end
		if at <= 101 then
			wait_frames_skipping(30)
		end
		if at <= 102 then
			helper_52aadc70(6120300, -1)
		end
		if at <= 103 then
			wait_frames_skipping(30)
		end
		if at <= 104 then
			helper_52aadc70(6120305, -1)
		end
		if at <= 105 then
			helper_238b5abc(5)
		end
		if at <= 106 then
			wait_frames_skipping(20)
		end
		if at <= 107 then
			helper_52aadc70(6120310, -1)
		end
		if at <= 108 then
			helper_238b5abc(5)
		end
		if at <= 109 then
			wait_frames_skipping(30)
		end
		if at <= 110 then
			wait_frames_skipping(20)
		end
		if at <= 111 then
			helper_52aadc70(6120320, -1)
		end
		if at <= 112 then
			wait_frames_skipping(20)
		end
		if at <= 113 then
			helper_52aadc70(6120323, -1)
		end
		if at <= 114 then
			wait_frames_skipping(20)
		end
		if at <= 115 then
			helper_52aadc70(6120327, -1)
		end
		if at <= 116 then
			helper_238b5abc(5)
		end
		if at <= 117 then
			wait_frames_skipping(15)
		end
		if at <= 118 then
			wait_frames_skipping(60)
		end
		if at <= 119 then
			wait_frames_skipping(30)
		end
		if at <= 120 then
			wait_frames_skipping(30)
		end
		if at <= 121 then
			wait_frames_skipping(90)
		end
		if at <= 122 then
			wait_frames_skipping(90)
		end
		if at <= 123 then
			wait_frames_skipping(60)
		end
		if at <= 124 then
			helper_52aadc70(6120330, -1)
		end
		if at <= 125 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 127
	vm.entry(127)
	event.cancel_drama_scene_skip()
	event.set_motion_blur(0)
	event.set_wind(-1)
	event.stop_music(0)
	event.stop_sound_effect(var0, 15)
	event.stop_sound_effect(var0, 16)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.show_atlamillia_frames(0, 0, 0)
	else
		event.show_atlamillia_frames(1, 0, 0)
	end
	event.clear_camera_sequence()
	event.skip_next_music_load()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, -1.02, 0.2, 111.04)
	event.set_character_rotation(0, 0.0, 3.11, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

return helper_7df574d3
