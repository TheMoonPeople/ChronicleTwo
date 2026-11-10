--!strict
-- map/s/s67/s67_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_10ea8()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.switch_dungeon_main_character(0)
		active_chr_no = 0
	end
	if active_chr_no == 3 then
		event.switch_dungeon_main_character(1)
		active_chr_no = 1
	end
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 1, "info", global1, 41)
		event.load_equipment_model(5, 1, 0, "info", global1, 42)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 1, "info", global0, 41)
		event.load_equipment_model(5, 0, 0, "info", global0, 42)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e700/e732/e732_sun.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(4, 35)
	event.clear_object_sequence(2, 35)
	event.set_object_sequence_object(2, 4)
	event.load_character(5, "event/e700/e732/e732_dark.gltf", "info", 36, 1)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(5, 36)
	event.clear_object_sequence(3, 36)
	event.set_object_sequence_object(3, 5)
	event.load_character(5, "event/e700/e732/e732_andrea.gltf", "info", 33)
	event.set_character_active(0, 33)
	event.attach_object_handle_to_map_part_2(6, "p06_d06b03-0")
	event.set_object_sequence_object(4, 6)
	event.set_object_sequence_position(4, 0.0, 20065.8, 9390.18)
	event.set_object_handle_scale(6, 6.0, 6.0, 6.0)
	event.load_character(5, "event/e700/e732/e732_dedeath.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e700/e732/e732_moonbreak_f1.gltf", "info", 43)
	event.set_character_active(0, 43)
	event.load_character(5, "event/e700/e732/e732_moonbreak_f2.gltf", "info", 44)
	event.set_character_active(0, 44)
	event.load_character(5, "event/e700/e732/e732_moonbreak_h.gltf", "info", 45)
	event.set_character_active(0, 45)
	event.load_character(5, "event/e700/e732/e732_moonbreak_light.gltf", "info", 46)
	event.set_character_active(0, 46)
	event.attach_object_handle_to_character(7, 46)
	event.clear_object_sequence(5, 46)
	event.set_object_sequence_object(5, 7)
	event.load_character(5, "event/e700/e732/e700_a_hikari.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.initialize_effect_manager(5)
	event.load_effect_base("Ｅ７３２光雨")
	event.create_effect_work_buffer(5)
	event.set_character_active(1, 41)
	event.set_character_active(1, 42)
	event.load_message_file(0, 5, "event/e700/e732/e732_1.txt")
end

--- Helper function.
local function helper_22300000()
	local var0: s32 = 0
	local _ = var0 == 2
	var0 = 0
	local _ = var0 == 3
	var0 = 1
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_108ac()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
		event.delete_character(41)
		event.delete_character(42)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
		event.delete_character(41)
		event.delete_character(42)
	end
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(43)
	event.delete_character(44)
	event.delete_character(45)
	event.delete_character(46)
	event.delete_character(33)
	event.delete_character(39)
	event.set_object_handle_scale(6, 1.0, 1.0, 1.0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

--- Helper function.
local function helper_1275c()
	local var4: s32 = 0
	local projection: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(732, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(35)
		event.load_music(113)
		event.load_map_sounds(7839)
		var4 = event.load_sound_effect_file_2(7839) or var4
		helper_10ea8()
		projection = event.get_event_projection() or projection
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_character_active(0, 41)
		event.set_character_active(0, 42)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "くるし目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(1.74, 7.93, -125.36)
		event.set_camera_sequence_look_at(0.0, 45.32, 0.0)
		event.set_object_sequence_position(2, 0.0, 0.0, -355.97)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 3.12, 0.0)
		event.set_object_sequence_position(0, -11.44, 0.0, -59.19)
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(1, 15.8, 0.0, -56.73)
		event.set_object_sequence_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_sequence_motion(3, "ぐふう", 4)
		event.set_object_sequence_motion(0, "上見構え", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上見構え", 4, -1.0, 1)
		event.set_character_active(1, 41)
		event.set_character_active(1, 42)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 1)
		event.fade_in_screen(30)
		at = 2
		wait_frames(15)
		event.set_object_sequence_motion(2, "倒れ", 4)
		at = 3
		helper_1584c528(7320010, -1)
		at = 4
		wait_frames(15)
		event.set_object_handle_frame_visible(5, "skin4", 0)
		event.set_character_position(38, 0.0, 0.0, 0.0)
		event.set_character_rotation(38, 0.0, 0.0, 0.0)
		event.set_character_motion(38, "立ち")
		event.set_character_active(1, 38)
		event.set_camera_sequence_position(20.77, 31.1, -40.75)
		event.set_camera_sequence_look_at(-2.9, 53.83, -8.05)
		event.move_camera_sequence_eased(88.65, 1.66, -134.55, -2.9, 53.83, -8.05, 150, 2, 1.0)
		at = 5
		helper_1584c528(7320020, -1)
		at = 6
		wait_camera()
		at = 7
		helper_1584c528(7320030, -1)
		event.set_character_motion(38, "笑い", 2, -1, 1)
		event.set_character_visible(36, 0, 1, 0.025)
		event.play_sound_effect(var4, 0)
		at = 8
		wait_frames(270)
		event.set_character_active(0, 41)
		event.set_character_active(0, 42)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.play_sound_effect(var4, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(27.9, 77.1, 17.22, 55.5, -0.18, -47.34)
		event.add_camera_sequence_path_point(-22.28, 77.1, -4.23, 5.32, -0.18, -68.79)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		at = 9
		wait_camera()
		event.set_camera_sequence_position(2.09, 7.26, -118.61)
		event.set_camera_sequence_look_at(1.46, 36.09, -47.77)
		event.start_crossfade(30)
		at = 10
		wait_frames(60)
		event.set_object_sequence_motion(0, "左・振り返り", 6)
		event.queue_object_sequence_next_motion(0, "左・振り返りL")
		at = 11
		wait_objects(0)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_motion(1, "走り", 4)
		event.set_camera_sequence_position(-159.57, 241.29, -121.7)
		event.set_camera_sequence_look_at(-16.11, 35.13, -290.72)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 60)
		event.add_object_sequence_path_point(0, -30.95, 0.0, -223.57)
		event.add_object_sequence_path_point(0, -29.63, 0.0, -334.52)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 60)
		event.add_object_sequence_path_point(1, 25.19, 0.0, -188.89)
		event.add_object_sequence_path_point(1, 12.96, 0.0, -294.16)
		event.start_object_sequence_path(1)
		at = 12
		wait_objects(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "心配顔")
		event.set_object_sequence_texture_animation(0, 1, "心配目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "心配顔")
		event.set_object_sequence_texture_animation(1, 1, "心配目パチ")
		event.play_music(0)
		event.set_object_sequence_position(0, -16.72, 0.0, -361.54)
		event.set_object_sequence_rotation(0, 0.0, 2.17, 0.0)
		event.set_object_sequence_position(1, 21.91, 0.0, -350.53)
		event.set_object_sequence_rotation(1, 0.0, -2.19, 0.0)
		event.set_object_sequence_motion(0, "しゃがむL", 4)
		event.set_object_sequence_motion(1, "しゃがみL", 4)
		event.set_camera_sequence_position(-34.54, 58.66, -391.76)
		event.set_camera_sequence_look_at(-3.33, 7.63, -413.95)
		event.move_camera_sequence_eased(-33.16, 58.66, -340.34, -1.95, 7.63, -362.53, 150, 2, 1.0)
		at = 13
		wait_camera()
		event.set_object_sequence_motion(2, "ユリス見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見る会話", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見るL", 4)
		at = 14
		helper_1584c528(7320040, -1)
		at = 15
		wait_frames(30)
		event.set_object_sequence_motion(2, "ユリス見る会話", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見るL", 4)
		at = 16
		helper_1584c528(7320050, -1)
		at = 17
		wait_frames(30)
		event.set_camera_sequence_position(-16.35, 40.86, -345.71)
		event.set_camera_sequence_look_at(-1.17, 7.63, -374.58)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "くるし目あき～目とじ")
		event.set_object_sequence_motion(2, "ユリス見る戻り", 2)
		event.queue_object_sequence_next_motion(2, "倒れ会話", 2)
		event.queue_object_sequence_next_motion(2, "倒れ", 4)
		at = 18
		helper_1584c528(7320060, -1)
		at = 19
		wait_frames(30)
		event.set_object_sequence_motion(2, "起きる", 2)
		event.queue_object_sequence_next_motion(2, "起きるL", 4)
		at = 20
		wait_frames(20)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "心配顔")
		event.set_object_sequence_texture_animation(0, 1, "心配目～通常目")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "心配顔")
		event.set_object_sequence_texture_animation(1, 1, "心配目～通常目")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.play_sound_effect(var4, 2)
		event.set_object_sequence_motion(0, "サン・起きあがる", 6)
		event.queue_object_sequence_next_motion(0, "サン・起きあがるL")
		event.set_object_sequence_motion(1, "サン立つ", 6)
		event.queue_object_sequence_next_motion(1, "サン立つL")
		event.set_camera_sequence_position(-0.48, 7.35, -418.26)
		event.set_camera_sequence_look_at(-0.27, 7.63, -374.61)
		at = 21
		helper_1584c528(7320062, -1)
		at = 22
		wait_frames(30)
		at = 23
		wait_objects(2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "上向き歩き", 4)
		event.set_object_sequence_motion(0, "右見る", 4)
		event.set_object_sequence_motion(1, "しゃがみ左見る", 4)
		event.set_camera_sequence_position(0.81, 64.97, -80.15)
		event.set_camera_sequence_look_at(0.0, 8.4, -355.97)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 540)
		event.add_object_sequence_path_point(2, 0.0, 0.0, -300.97)
		event.add_object_sequence_path_point(2, 0.0, 0.0, -132.95)
		event.start_object_sequence_path(2)
		event.move_camera_sequence_look_at(0.0, 8.4, -182.95, 540)
		at = 24
		helper_1584c528(7320070, -1)
		at = 25
		wait_frames(15)
		at = 26
		helper_1584c528(7320080, -1)
		at = 27
		wait_frames(15)
		at = 28
		wait_camera()
		event.set_object_sequence_motion(2, "上向くL", 4)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_event_projection(200.0)
		event.set_camera_sequence_position(-2.12, 16.61, -87.09)
		event.set_camera_sequence_look_at(-0.05, 86.09, 255.81)
		event.set_object_sequence_motion(2, "上向く会話", 2)
		at = 29
		helper_1584c528(7320085, -1)
		event.set_object_sequence_motion(2, "上向くL")
		at = 30
		wait_frames(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "くるし目パチ")
		event.set_event_projection(projection)
		event.set_camera_sequence_position(30.59, 14.36, 15.74)
		event.set_camera_sequence_look_at(0.0, 18.7, 0.0)
		event.start_crossfade(30)
		event.set_object_sequence_motion(2, "上向く会話")
		at = 31
		helper_1584c528(7320090, -1)
		event.set_object_sequence_motion(2, "上向くL")
		at = 32
		wait_frames(30)
		event.set_object_sequence_motion(2, "上向く会話")
		at = 33
		helper_1584c528(7320100, -1)
		event.set_object_sequence_motion(2, "上向くL")
		at = 34
		wait_frames(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "くるし目パチ～目とじ")
		event.set_object_sequence_motion(2, "下向く", 2)
		event.queue_object_sequence_next_motion(2, "下向く会話")
		at = 35
		helper_1584c528(7320110, -1)
		event.set_object_sequence_motion(2, "下向くL")
		at = 36
		wait_frames(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目とじ～目あき")
		event.set_object_sequence_motion(2, "下向く会話", 2)
		event.queue_object_sequence_next_motion(2, "下→上", 2)
		event.queue_object_sequence_next_motion(2, "上向く会話", 4)
		at = 37
		helper_1584c528(7320120, -1)
		event.set_object_sequence_motion(2, "上向くL")
		at = 38
		wait_frames(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_camera_sequence_position(34.66, 78.5, 33.42)
		event.set_camera_sequence_look_at(0.62, 18.7, -0.62)
		event.start_crossfade(30)
		event.set_object_sequence_motion(2, "下→上", 6)
		event.queue_object_sequence_next_motion(2, "上向く会話", 4)
		event.move_camera_sequence_eased(6.93, 54.08, 29.68, 0.62, 18.7, -0.62, 200, 2, 1.0)
		at = 39
		helper_1584c528(7320125, -1)
		event.set_object_sequence_motion(2, "上向くL")
		at = 40
		wait_frames(15)
		event.set_object_sequence_motion(2, "上向く会話")
		at = 41
		helper_1584c528(7320130, -1)
		event.set_object_sequence_motion(2, "上向くL")
		at = 42
		wait_frames(30)
		event.set_object_sequence_motion(2, "手をかざす", 6)
		event.queue_object_sequence_next_motion(2, "手をかざす会話", 4)
		at = 43
		helper_1584c528(7320140, -1)
		event.set_object_sequence_motion(2, "手をかざすL")
		event.clear_camera_sequence()
		event.fade_out_music(30)
		event.set_motion_blur(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(30)
		event.add_camera_sequence_path_point(7.14, 54.26, 29.71, 0.62, 18.7, -0.62)
		event.add_camera_sequence_path_point(116.13, 382.36, 166.44, 0.62, 18.7, -0.62)
		event.start_camera_sequence_path()
		at = 44
		wait_camera()
		event.set_motion_blur(0)
		event.set_character_position(43, 0.0, 0.0, 0.0)
		event.set_character_rotation(43, 0.0, 0.0, 0.0)
		event.set_character_position(44, 0.0, 0.0, 0.0)
		event.set_character_rotation(44, -0.9, 0.0, 0.0)
		event.set_character_position(45, 0.0, 120.78, -8.63)
		event.set_character_rotation(45, 0.0, 0.0, 0.0)
		event.set_character_position(46, 16.0, 7.55, -303.55)
		event.set_character_rotation(46, 0.0, 0.0, 0.0)
		event.set_character_active(1, 43)
		event.play_sound_effect(var4, 4)
		event.set_character_motion(43, "手をかざすL")
		event.set_character_visible(43, 1, 1, 0.025)
		event.set_event_projection(200.0)
		event.stop_sound_effect(var4, 1)
		event.play_sound_effect(var4, 3)
		event.set_camera_sequence_position(-0.18, 16.61, -42.1)
		event.set_camera_sequence_look_at(-0.05, 86.09, 255.81)
		event.move_camera_sequence_eased(-0.18, 16.61, -42.1, -0.05, 235.45, 255.81, 100, 2, 1.0)
		event.stop_music(0)
		event.play_sound_effect(var4, 5)
		event.set_character_motion(44, "手をかざすL", 2, -1, 1)
		event.set_character_active(1, 44)
		at = 45
		wait_frames(100)
		event.set_character_visible(43, 0, 1, 0.025)
		at = 46
		wait_frames(100)
		event.set_character_motion(45, "月破壊（ヒット）", 2, -1, 1)
		event.play_sound_effect(var4, 6)
		event.set_character_active(1, 45)
		at = 47
		wait_frames(60)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_position(0, 17.39, 0.0, -347.79)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 2.28, 0.0, -342.63)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_event_projection(projection)
		event.set_camera_sequence_position(49.31, 17.33, -336.13)
		event.set_camera_sequence_look_at(-69.21, 27.55, -358.14)
		event.set_object_sequence_motion(5, "発動", 6)
		event.queue_object_sequence_next_motion(5, "ループ", 4)
		event.set_character_active(1, 46)
		at = 48
		wait_frames(60)
		at = 49
		wait_frames(120)
		event.set_character_active(0, 46)
		event.create_effect("Ｅ７３２光雨")
		event.set_effect_first_vector(0.0, 140.0, 0.0)
		event.set_effect_second_vector(500.0, 0.0, 500.0)
		event.set_effect_value(0, 700)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_visible(6, 0)
		event.set_object_sequence_position(0, 13.0, 0.0, -159.19)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, -13.0, 0.0, -156.73)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "上向くL", 4)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(2.81, 138.78, 11.72, -3.06, -51.06, -141.04)
		event.add_camera_sequence_path_point(7.79, 138.78, 141.19, 1.89, -51.06, -12.32)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		event.load_music(112)
		at = 50
		wait_frames(90)
		event.play_music(0)
		at = 51
		wait_camera()
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "まんぞく目とじ")
		event.set_camera_sequence_position(24.93, 17.0, 8.96)
		event.set_camera_sequence_look_at(-1.11, 17.28, -1.22)
		event.start_crossfade(30)
		at = 52
		wait_frames(90)
		at = 53
		helper_1584c528(7320150, -1)
		at = 54
		wait_frames(30)
		event.set_character_position(39, 0.0, 42.78, 36.3)
		event.set_character_rotation(39, 0.0, -3.12, 0.0)
		event.set_character_active(1, 39)
		event.set_character_motion(39, "後光", 4, -1, 1)
		event.set_character_motion(33, "浮遊立ち")
		event.set_character_position(33, 0.0, 42.78, 36.3)
		event.set_character_rotation(33, 0.0, -3.12, 0.0)
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(-0.65, 13.67, -139.44)
		event.set_camera_sequence_look_at(-1.11, 30.17, -1.22)
		at = 55
		wait_frames(30)
		event.move_camera_sequence_eased(-0.96, 53.08, -45.59, -1.11, 64.72, -1.22, 200, 2, 1.0)
		event.set_character_motion(33, "浮遊会話")
		at = 56
		helper_1584c528(7320160, -1)
		at = 57
		wait_camera()
		event.set_character_active(0, 33)
		event.set_character_active(0, 39)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "泣き目")
		event.set_camera_sequence_position(24.93, 17.0, 8.96)
		event.set_camera_sequence_look_at(-1.11, 17.28, -1.22)
		at = 58
		helper_1584c528(7320170, -1)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "泣き目あき～目とじ")
		at = 59
		wait_frames(60)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目とじ～泣き目あき")
		event.set_object_sequence_motion(2, "振り返る", 2)
		at = 60
		wait_frames(20)
		event.rotate_object_sequence(2, 0.0, 3.1, 0.0, 30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "まんぞく目パチ")
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_camera_sequence_position(1.99, 35.18, -222.99)
		event.set_camera_sequence_look_at(-1.11, 8.64, -1.22)
		at = 61
		wait_objects(2)
		event.set_object_sequence_motion(2, "立ち2")
		at = 62
		wait_frames(20)
		event.set_object_sequence_motion(2, "会話2")
		at = 63
		helper_1584c528(7320180, -1)
		event.set_object_sequence_motion(2, "立ち2")
		at = 64
		wait_frames(30)
		event.set_object_sequence_motion(2, "会話2")
		event.set_object_sequence_motion(2, "立ち2")
		at = 65
		wait_frames(30)
		event.set_camera_sequence_position(-0.17, 20.98, -62.1)
		event.set_camera_sequence_look_at(0.0, 8.4, 0.0)
		event.set_object_sequence_motion(2, "会話2")
		at = 66
		helper_1584c528(7320190, -1)
		event.set_object_sequence_motion(2, "立ち2")
		at = 67
		wait_frames(30)
		event.set_object_sequence_motion(2, "会話2")
		at = 68
		helper_1584c528(7320200, -1)
		event.set_object_sequence_motion(2, "立ち2")
		at = 69
		wait_frames(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "まんぞく目～目とじ")
		event.set_camera_sequence_position(-30.4, 17.0, -5.26)
		event.set_camera_sequence_look_at(-1.11, 17.28, -1.22)
		event.set_object_sequence_motion(2, "上向く", 2)
		event.queue_object_sequence_next_motion(2, "死", 2)
		event.queue_object_sequence_next_motion(2, "死L", 4)
		event.play_sound_effect(var4, 7)
		at = 70
		wait_frames(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-1.15, 259.68, -39.55, -0.39, 8.4, -13.48)
		event.add_camera_sequence_path_point(-1.15, 117.74, -39.55, -0.39, 8.4, -13.48)
		event.start_camera_sequence_path()
		at = 71
		wait_camera()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22300000()
			wait_frames_skipping(15)
		end
		if at <= 2 then
			helper_52aadc70(7320010, -1)
		end
		if at <= 3 then
			wait_frames_skipping(15)
		end
		if at <= 4 then
			helper_52aadc70(7320020, -1)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_52aadc70(7320030, -1)
		end
		if at <= 7 then
			wait_frames_skipping(270)
		end
		if at <= 8 then
			helper_344d6cd8()
		end
		if at <= 9 then
			wait_frames_skipping(60)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_344d6cd8()
		end
		if at <= 13 then
			helper_52aadc70(7320040, -1)
		end
		if at <= 14 then
			wait_frames_skipping(30)
		end
		if at <= 15 then
			helper_52aadc70(7320050, -1)
		end
		if at <= 16 then
			wait_frames_skipping(30)
		end
		if at <= 17 then
			helper_52aadc70(7320060, -1)
		end
		if at <= 18 then
			wait_frames_skipping(30)
		end
		if at <= 19 then
			wait_frames_skipping(20)
		end
		if at <= 20 then
			helper_52aadc70(7320062, -1)
		end
		if at <= 21 then
			wait_frames_skipping(30)
		end
		if at <= 22 then
			helper_238b5abc(2)
		end
		if at <= 23 then
			helper_52aadc70(7320070, -1)
		end
		if at <= 24 then
			wait_frames_skipping(15)
		end
		if at <= 25 then
			helper_52aadc70(7320080, -1)
		end
		if at <= 26 then
			wait_frames_skipping(15)
		end
		if at <= 27 then
			helper_344d6cd8()
		end
		if at <= 28 then
			helper_52aadc70(7320085, -1)
		end
		if at <= 29 then
			wait_frames_skipping(30)
		end
		if at <= 30 then
			helper_52aadc70(7320090, -1)
		end
		if at <= 31 then
			wait_frames_skipping(30)
		end
		if at <= 32 then
			helper_52aadc70(7320100, -1)
		end
		if at <= 33 then
			wait_frames_skipping(30)
		end
		if at <= 34 then
			helper_52aadc70(7320110, -1)
		end
		if at <= 35 then
			wait_frames_skipping(30)
		end
		if at <= 36 then
			helper_52aadc70(7320120, -1)
		end
		if at <= 37 then
			wait_frames_skipping(30)
		end
		if at <= 38 then
			helper_52aadc70(7320125, -1)
		end
		if at <= 39 then
			wait_frames_skipping(15)
		end
		if at <= 40 then
			helper_52aadc70(7320130, -1)
		end
		if at <= 41 then
			wait_frames_skipping(30)
		end
		if at <= 42 then
			helper_52aadc70(7320140, -1)
		end
		if at <= 43 then
			helper_344d6cd8()
		end
		if at <= 44 then
			wait_frames_skipping(100)
		end
		if at <= 45 then
			wait_frames_skipping(100)
		end
		if at <= 46 then
			wait_frames_skipping(60)
		end
		if at <= 47 then
			wait_frames_skipping(60)
		end
		if at <= 48 then
			wait_frames_skipping(120)
		end
		if at <= 49 then
			wait_frames_skipping(90)
		end
		if at <= 50 then
			helper_344d6cd8()
		end
		if at <= 51 then
			wait_frames_skipping(90)
		end
		if at <= 52 then
			helper_52aadc70(7320150, -1)
		end
		if at <= 53 then
			wait_frames_skipping(30)
		end
		if at <= 54 then
			wait_frames_skipping(30)
		end
		if at <= 55 then
			helper_52aadc70(7320160, -1)
		end
		if at <= 56 then
			helper_344d6cd8()
		end
		if at <= 57 then
			helper_52aadc70(7320170, -1)
		end
		if at <= 58 then
			wait_frames_skipping(60)
		end
		if at <= 59 then
			wait_frames_skipping(20)
		end
		if at <= 60 then
			helper_238b5abc(2)
		end
		if at <= 61 then
			wait_frames_skipping(20)
		end
		if at <= 62 then
			helper_52aadc70(7320180, -1)
		end
		if at <= 63 then
			wait_frames_skipping(30)
		end
		if at <= 64 then
			wait_frames_skipping(30)
		end
		if at <= 65 then
			helper_52aadc70(7320190, -1)
		end
		if at <= 66 then
			wait_frames_skipping(30)
		end
		if at <= 67 then
			helper_52aadc70(7320200, -1)
		end
		if at <= 68 then
			wait_frames_skipping(30)
		end
		if at <= 69 then
			wait_frames_skipping(60)
		end
		if at <= 70 then
			helper_344d6cd8()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_music(60)
	event.fade_out_camera_sequence(60, 255.0, 255.0, 255.0)
	at = 72
	wait_frames(60)
	event.stop_music(0)
	event.set_event_projection(projection)
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	at = 73
	vm.wait(73)
	event.clear_effect_manager()
	at = 74
	vm.wait(74)
	helper_108ac()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_1275c()
	event.jump_to_map_3(-1, "s44", 500)
end

--- Event 17320, which map data, a script or the engine runs by number.
function script.event_17320()
	helper_1275c()
	event.jump_to_map_3(-1, "s44", 500)
end

return script
