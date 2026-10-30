--!strict
-- map/f/f03/i04/f03i04_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_3a1e288a = require("@lib/event/helper_3a1e288a")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9cb0ca44 = require("@lib/event/helper_9cb0ca44")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_e4945fa4 = require("@lib/event/helper_e4945fa4")
local helper_ec30b150 = require("@lib/event/helper_ec30b150")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_14868()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local block_2: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e400/e448/e448_monica.gltf", "info", global1)
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
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e400/e448/e448_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e400/e448/e448_chap.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e400/e448/e448_eina_holo.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.load_character(5, "event/e400/e448/e448_mago.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(7, 40)
	event.clear_object_sequence(7, 40)
	event.set_object_sequence_object(7, 7)
	event.load_character(5, "event/e400/e448/e448_lunaken.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(8, 41)
	event.clear_object_sequence(8, 41)
	event.set_object_sequence_object(8, 8)
	event.load_character(5, "event/e400/e448/e448_hologram.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.attach_object_handle_to_map_part_3(4, "p07_f03i04", "f03i04_07-m")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(5, "p08_f03i04", "f03i04_08-m")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.attach_object_handle_to_map_part_3(6, "p05_f03i04", "f03i04_05-m")
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	block = event.load_event_image_4(5, "textures/event/e400/e448/e448a.json", 0) or block
	block_2 = event.load_event_image_4(5, "textures/event/e400/e448/e448b.json", 1) or block_2
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e44801", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e44802", block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(11, 1)
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "e44803", block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 416)
	event.set_event_sprite_size(2, 512, 416)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(12, 2)
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "e44804", block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(3, 512, 416)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(13, 3)
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "e44805", block_2)
	event.set_event_sprite_color(4, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(4, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(4, 512, 416)
	event.set_event_sprite_position(4, 256, 208)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(14, 4)
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	event.reset_event_sprite(5)
	event.set_event_sprite_type(5, 0)
	event.set_event_sprite_texture(5, "e44806", block_2)
	event.set_event_sprite_color(5, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(5, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(5, 512, 416)
	event.set_event_sprite_position(5, 256, 208)
	event.set_event_sprite_draw_pass(5, 0)
	event.attach_object_handle_to_sprite(15, 5)
	event.clear_object_sequence(15)
	event.set_object_sequence_object(15, 15)
	event.reset_event_sprite(6)
	event.set_event_sprite_type(6, 0)
	event.set_event_sprite_texture(6, "e44807", block_2)
	event.set_event_sprite_color(6, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(6, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(6, 512, 416)
	event.set_event_sprite_position(6, 256, 208)
	event.set_event_sprite_draw_pass(6, 0)
	event.attach_object_handle_to_sprite(16, 6)
	event.clear_object_sequence(16)
	event.set_object_sequence_object(16, 16)
	event.load_message_file(0, 5, "event/e400/e448/e448_1.txt")
end

--- Helper function.
local function helper_21800000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1431c()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_event_image(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_scale(4, 1.0, 1.0, 1.0)
	event.set_object_handle_visible(4, 0)
	event.set_object_handle_visible(6, 0)
	event.set_object_sequence_position(5, -1.49967, 492.015, 522.796)
	event.jump_to_map_3(-1, "s09", 500)
end

--- Helper function.
local function helper_16f18()
	local var6: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(448, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 2
		wait_frames(30)
		helper_14868()
		event.set_scene_status_flags(1, 0, 256, 1)
		event.stop_music(0)
		at = 3
		wait_frames(4)
		event.load_music(22)
		event.load_map_sounds(4509)
		var6 = event.load_sound_effect_file_2(4509) or var6
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 23)
		event.set_object_handle_footstep_sound(1, 23)
		event.set_object_handle_footstep_sound(2, 23)
		event.set_object_handle_footstep_sound(8, 23)
		event.set_object_handle_footstep_sound(7, 23)
		event.set_object_handle_scale(4, 1.0, 0.0, 1.0)
		event.set_object_handle_visible(4, 1)
		event.set_object_handle_visible(6, 0)
		event.set_object_sequence_position(5, -1.49967, 492.015, 522.796)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目パチ")
		event.set_object_sequence_texture_animation(7, 0)
		event.set_object_sequence_texture_animation(7, 1, "目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_camera_sequence_position(-956.31, 276.23, 29.53)
		event.set_camera_sequence_look_at(-426.59, 67.29, 6.63)
		event.set_object_sequence_position(1, -726.2, 116.62, -12.45)
		event.set_object_sequence_rotation(1, 0.0, 1.52, 0.0)
		event.set_object_sequence_position(0, -723.31, 115.39, 15.84)
		event.set_object_sequence_rotation(0, 0.0, 1.52, 0.0)
		event.set_object_sequence_position(2, 0.0, 14.67, 0.0)
		event.set_object_sequence_rotation(2, 0.0, -1.52, 0.0)
		event.set_object_sequence_position(3, 0.0, 14.67, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(7, 0.0, 14.67, -342.92)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.set_character_position(42, 0.0, 14.67, 0.0)
		event.set_character_rotation(42, 0.0, 3.13, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_motion(8, "立ち", 4)
		event.move_object_sequence(1, -229.42, 14.67, -11.08, 240, 1)
		event.move_object_sequence(0, -235.3, 14.67, 16.5, 240, 1)
		event.fade_in_screen(30)
		at = 4
		wait_frames(150)
		event.set_camera_sequence_position(54.63, 25.75, -14.11)
		event.set_camera_sequence_look_at(-484.75, 44.7, 19.5)
		event.set_object_sequence_motion(2, "立ち会話（やぁ）", 2)
		event.delay_object_sequence_motion_track(2, 90)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.delay_camera_sequence_position_track(90)
		event.set_camera_sequence_position(-37.91, 29.85, 18.95)
		event.set_camera_sequence_look_at(1.68, 29.5, -0.76)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 5
		helper_1584c528(4480010, 150)
		event.reset_mouth_texture_animations()
		at = 6
		helper_1584c528(4480015, -1)
		at = 7
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～口あけ")
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_position(1, -37.18, 14.67, -12.31)
		event.set_object_sequence_rotation(1, 0.0, 1.16, 0.0)
		event.set_object_sequence_position(0, -34.01, 14.67, 9.43)
		event.set_object_sequence_rotation(0, 0.0, 1.52, 0.0)
		event.set_camera_sequence_position(57.77, 30.54, 48.68)
		event.set_camera_sequence_look_at(-37.13, 36.5, -12.63)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 8
		helper_4116e6bb(4480020)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var6, 3)
		event.set_object_sequence_motion(0, "ホント！！", 6)
		event.queue_object_sequence_next_motion(0, "ホント！！L")
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 9
		helper_4116e6bb(4480030)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-29.05, 30.34, 16.9)
		event.set_camera_sequence_look_at(16.79, 33.58, -8.54)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 10
		helper_4116e6bb(4480040)
		event.reset_mouth_texture_animations()
		event.play_music(0)
		event.set_object_sequence_motion(2, "指パッチンin", 2)
		event.queue_object_sequence_next_motion(2, "指パッチンループ")
		at = 11
		wait_frames(30)
		event.set_camera_sequence_position(-239.44, 156.02, -52.82)
		event.set_camera_sequence_look_at(-191.28, 200.5, 65.31)
		event.play_sound_effect(var6, 4)
		event.set_object_sequence_scale(4, 1.0, 1.0, 1.0, 90)
		event.move_object_sequence(5, -1.49967, 300.0, 522.796, 90)
		at = 12
		wait_frames(90)
		event.set_camera_sequence_position(5.53, 370.96, 183.63)
		event.set_camera_sequence_look_at(4.24, 381.19, 324.61)
		at = 13
		wait_frames(30)
		event.set_object_handle_scale(6, 1.0, 0.0, 1.0)
		event.set_object_handle_visible(6, 1)
		event.set_object_sequence_scale(6, 1.0, 1.0, 1.0, 30)
		event.play_sound_effect(var6, 5)
		at = 14
		wait_frames(60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(0.0, 16.85, -78.07)
		event.set_camera_sequence_look_at(0.0, 87.26, 92.04)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, -25.0, 14.67, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(0, 25.0, 14.67, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(0, "のけぞる", 6, -1, 1)
		event.queue_object_sequence_next_motion(0, "のけぞるL")
		event.set_object_sequence_motion(1, "上向くL", 4, -1, 1)
		at = 15
		helper_4116e6bb(4480050)
		event.set_object_sequence_motion(2, "会話（見上げ）", 6)
		event.queue_object_sequence_next_motion(2, "立ち（見上げ）", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 16
		helper_4116e6bb(4480060)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "会話（見上げ）", 6)
		event.queue_object_sequence_next_motion(2, "立ち（見上げ）", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 17
		helper_4116e6bb(4480065)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "立ち", 2)
		at = 18
		wait_frames(15)
		event.set_character_active(0, global0)
		event.set_camera_sequence_position(36.52, 23.74, -2.78)
		event.set_camera_sequence_look_at(-80.76, 43.28, 5.58)
		event.set_object_sequence_motion(2, "会話（見上げ）", 6)
		event.queue_object_sequence_next_motion(2, "立ち（見上げ）", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 19
		helper_4116e6bb(4480070)
		event.reset_mouth_texture_animations()
		at = 20
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "うれし顔")
		event.set_object_sequence_texture_animation(0, 1, "うれし目パチ")
		event.set_character_active(1, global0)
		event.set_camera_sequence_position(7.12, 87.39, 72.51)
		event.set_camera_sequence_look_at(0.52, 31.03, 7.67)
		event.play_sound_effect(var6, 6)
		event.set_object_sequence_motion(0, "すごいよ！", 6)
		event.queue_object_sequence_next_motion(0, "すごいよ！L")
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 21
		helper_4116e6bb(4480080)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "チャップを見る", 2)
		event.queue_object_sequence_next_motion(0, "チャップを見るL")
		event.set_object_sequence_motion(2, "会話（見上げ）", 6)
		event.queue_object_sequence_next_motion(2, "立ち（見上げ）", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 22
		helper_4116e6bb(4480090)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var6, 7)
		event.set_object_sequence_motion(2, "振り向く")
		event.rotate_object_sequence(2, 0.0, -3.1, 0.0, 30)
		at = 23
		wait_objects(2)
		event.set_object_sequence_motion(2, "立ち")
		at = 24
		wait_frames(15)
		at = 25
		helper_4116e6bb(4480095)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "うれし顔")
		event.set_object_sequence_texture_animation(0, 1, "うれし目～通常目")
		event.play_sound_effect(var6, 8)
		event.set_object_sequence_motion(1, "左向く", 2, 0.5)
		event.queue_object_sequence_next_motion(1, "左向くL")
		event.set_character_active(1, 40)
		at = 26
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_rotation(1, 0.0, 2.94, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -2.74, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_camera_sequence_position(196.02, 29.8, -218.1)
		event.set_camera_sequence_look_at(0.0, 27.27, -342.92)
		event.set_object_sequence_motion(7, "歩き", 4)
		event.move_object_sequence(7, 0.0, 14.67, -111.07, 180)
		event.move_camera_sequence_look_at(0.0, 27.27, -111.07, 180)
		at = 27
		wait_objects(7)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_position(7, 0.0, 14.67, -100.0)
		event.move_object_sequence(7, 0.0, 14.67, -86.5, 30)
		event.set_camera_sequence_position(-41.41, 39.04, -154.86)
		event.set_camera_sequence_look_at(-12.51, 37.54, -79.79)
		at = 28
		wait_objects(7)
		event.set_object_sequence_motion(7, "立ち")
		event.set_object_sequence_motion(0, "ジャミング！？", 2)
		event.queue_object_sequence_next_motion(0, "ジャミング！？L")
		event.set_object_sequence_motion(1, "身構え", 2)
		event.queue_object_sequence_next_motion(1, "身構えL")
		event.play_sound_effect(var6, 9)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 29
		helper_4116e6bb(4480100)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 30
		helper_4116e6bb(4480110)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "ユリス向くin", 2)
		event.queue_object_sequence_next_motion(2, "ユリス向く（会話）", 2)
		event.queue_object_sequence_next_motion(2, "ユリス向くループ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 31
		helper_4116e6bb(4480120)
		event.reset_mouth_texture_animations()
		at = 32
		wait_frames(15)
		event.set_camera_sequence_position(-20.2, 39.04, -21.57)
		event.set_camera_sequence_look_at(0.05, 37.54, -82.59)
		at = 33
		helper_4116e6bb(4480130)
		at = 34
		wait_frames(15)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_camera_sequence_position(-41.41, 39.04, -154.86)
		event.set_camera_sequence_look_at(-12.51, 37.54, -79.79)
		event.set_object_sequence_motion(2, "立ち")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "身構え戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 35
		helper_4116e6bb(4480140)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(7, "会話1", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 36
		helper_4116e6bb(4480150)
		event.set_object_sequence_motion(7, "会話2", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 37
		helper_4116e6bb(4480155)
		at = 38
		wait_frames(30)
		event.set_camera_sequence_position(32.13, 29.73, -45.7)
		event.set_camera_sequence_look_at(-1.56, 43.07, -89.26)
		event.set_object_sequence_motion(7, "会話1", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 39
		helper_4116e6bb(4480160)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(600)
		event.add_camera_sequence_path_point(75.1, 43.14, -309.6, 77.12, 43.07, -89.97)
		event.add_camera_sequence_path_point(-81.37, 43.14, -308.16, -79.35, 43.07, -88.53)
		event.start_camera_sequence_path()
		event.set_object_sequence_motion(7, "会話1", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 40
		helper_1584c528(4480170, -1)
		event.set_object_sequence_motion(7, "会話2", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 41
		helper_1584c528(4480180, -1)
		event.set_object_sequence_motion(7, "会話1", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 42
		helper_1584c528(4480183, -1)
		at = 43
		wait_camera()
		event.set_camera_sequence_position(2.97, 138.34, 137.77)
		event.set_camera_sequence_look_at(0.19, 43.07, -24.14)
		event.set_object_sequence_motion(7, "会話2", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 44
		helper_4116e6bb(4480185)
		event.set_object_sequence_motion(7, "会話1", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 45
		helper_4116e6bb(4480188)
		event.set_object_sequence_motion(7, "立ち")
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		at = 46
		helper_4116e6bb(4480190)
		event.set_object_sequence_motion(7, "うなづく", 2)
		event.queue_object_sequence_next_motion(7, "立ち")
		at = 47
		wait_frames(30)
		event.set_camera_sequence_position(32.13, 29.73, -45.7)
		event.set_camera_sequence_look_at(-1.56, 43.07, -89.26)
		event.set_object_sequence_motion(7, "会話1", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 48
		helper_4116e6bb(4480200)
		at = 49
		wait_frames(15)
		event.set_camera_sequence_position(232.26, 353.87, 175.15)
		event.set_camera_sequence_look_at(24.92, 388.25, 507.94)
		event.move_camera_sequence_eased(205.95, 353.87, 220.9, 24.92, 388.25, 507.94, 400, 2, 1.0)
		at = 50
		helper_1584c528(4480210, -1)
		at = 51
		wait_frames(15)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(60.01, 36.76, -80.17)
		event.set_camera_sequence_look_at(-17.73, 44.3, -88.09)
		event.set_object_sequence_motion(7, "会話1", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 52
		helper_4116e6bb(4480220)
		event.set_object_sequence_motion(7, "立ち")
		at = 53
		wait_frames(30)
		event.set_camera_sequence_position(2.97, 138.34, 137.77)
		event.set_camera_sequence_look_at(0.19, 43.07, -24.14)
		event.set_object_sequence_motion(7, "会話2", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 54
		helper_4116e6bb(4480230)
		event.set_object_sequence_motion(7, "立ち")
		at = 55
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_position(1, -17.0, 14.67, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 2.94, 0.0)
		event.set_object_sequence_position(0, 17.0, 14.67, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -2.74, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(-39.51, 33.29, -31.48)
		event.set_camera_sequence_look_at(2.52, 33.3, 2.35)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 56
		helper_4116e6bb(4480240)
		event.reset_mouth_texture_animations()
		at = 57
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(1, -25.0, 14.67, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 2.94, 0.0)
		event.set_object_sequence_position(0, 25.0, 14.67, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -2.74, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(-0.1, 86.08, -136.54)
		event.set_camera_sequence_look_at(-1.59, -2.29, 3.25)
		event.set_object_sequence_motion(1, "考え", 2)
		event.queue_object_sequence_next_motion(1, "考えL")
		event.set_object_sequence_motion(7, "会話1", 2)
		event.queue_object_sequence_next_motion(7, "会話3", 4)
		at = 58
		helper_4116e6bb(4480250)
		event.set_object_sequence_motion(7, "立ち")
		event.set_object_sequence_motion(0, "いや、そんな・・・", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 59
		helper_4116e6bb(4480260)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "顔上げ", 2)
		event.queue_object_sequence_next_motion(1, "顔上げ会話")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 60
		helper_4116e6bb(4480270)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 61
		helper_4116e6bb(4480275)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "考えL")
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL")
		event.set_object_sequence_motion(2, "モニカ向くin", 6)
		event.queue_object_sequence_next_motion(2, "モニカ向くループ")
		event.set_object_sequence_motion(7, "モニカ見る", 6)
		event.queue_object_sequence_next_motion(7, "モニカ見るループ")
		at = 62
		wait_frames(30)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_position(1, -17.0, 14.67, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 2.94, 0.0)
		event.set_object_sequence_position(0, 17.0, 14.67, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.06, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(-39.51, 33.29, -31.48)
		event.set_camera_sequence_look_at(2.52, 33.3, 2.35)
		event.set_object_sequence_motion(1, "顔上げ", 2)
		event.queue_object_sequence_next_motion(1, "顔上げ会話")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 63
		helper_4116e6bb(4480280)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "考えL")
		event.set_object_sequence_motion(0, "左向く会話", 2)
		event.queue_object_sequence_next_motion(0, "左向くL")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 64
		helper_4116e6bb(4480290)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var6, 10)
		event.set_object_sequence_motion(1, "右見る", 2)
		event.queue_object_sequence_next_motion(1, "右向くL")
		event.set_object_sequence_motion(2, "モニカからユリス向く", 2)
		event.queue_object_sequence_next_motion(2, "モニカからユリス向くＬ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 65
		helper_4116e6bb(4480300)
		event.reset_mouth_texture_animations()
		at = 66
		wait_frames(30)
		event.set_object_sequence_position(1, -25.0, 14.67, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 2.94, 0.0)
		event.set_object_sequence_position(0, 25.0, 14.67, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -2.74, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(8.65, 18.02, -25.49)
		event.set_camera_sequence_look_at(26.65, 37.13, 2.87)
		event.set_object_sequence_motion(0, "左向く会話", 2)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 67
		helper_4116e6bb(4480310)
		event.reset_mouth_texture_animations()
		at = 68
		wait_frames(30)
		event.set_character_active(0, 38)
		event.set_object_sequence_motion(0, "会話", 6)
		event.set_camera_sequence_position(-17.5, 31.97, -0.13)
		event.set_camera_sequence_look_at(26.39, 34.27, 0.14)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 69
		helper_4116e6bb(4480320)
		event.reset_mouth_texture_animations()
		at = 70
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_position(1, -17.0, 14.67, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -3.1, 0.0)
		event.set_object_sequence_position(0, 17.0, 14.67, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.06, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_character_active(1, 38)
		event.set_camera_sequence_position(45.32, 50.75, -47.14)
		event.set_camera_sequence_look_at(5.0, 37.13, -3.26)
		event.set_object_sequence_motion(0, "考えるL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 71
		helper_4116e6bb(4480330)
		event.reset_mouth_texture_animations()
		event.delay_object_sequence_texture_animation_track(0, 120)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目～おこり目")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "モニカを見る", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_motion_track(2, 20)
		event.set_object_sequence_motion(2, "ユリスからモニカ向く", 2)
		event.queue_object_sequence_next_motion(2, "ユリスからモニカ向くＬ")
		event.delay_object_sequence_motion_track(1, 120)
		event.set_object_sequence_motion(1, "怒る入り", 6)
		event.queue_object_sequence_next_motion(1, "怒る会話", 2)
		event.queue_object_sequence_next_motion(1, "怒る入りL", 4)
		event.play_sound_effect(var6, 11)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 72
		helper_4116e6bb(4480340)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "引きうなづき", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 73
		helper_4116e6bb(4480350)
		event.reset_mouth_texture_animations()
		at = 74
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(8, "走り", 4)
		event.set_object_sequence_motion(1, "右向くL", 4)
		event.set_object_sequence_motion(2, "立ち", 2)
		event.set_camera_sequence_position(-16.75, 163.56, -195.26)
		event.set_camera_sequence_look_at(19.55, 31.65, -72.54)
		at = 75
		wait_frames(30)
		event.set_mouth_texture_animations(8, "通常口パク")
		at = 76
		helper_4116e6bb(4480360)
		event.reset_mouth_texture_animations()
		event.fade_out_music(30)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち")
		event.set_object_sequence_motion(1, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_motion(7, "研究員見る", 6)
		event.queue_object_sequence_next_motion(7, "研究員見るL")
		event.set_object_sequence_rotation(8, 0.0, -0.41, 0.0)
		event.set_character_active(1, 41)
		event.clear_object_sequence_path(8)
		event.set_object_sequence_path_frames(8, 50)
		event.add_object_sequence_path_point(8, 81.75, 14.67, -207.27)
		event.add_object_sequence_path_point(8, 49.31, 14.67, -124.97)
		event.start_object_sequence_path(8)
		at = 77
		wait_objects(8)
		event.set_camera_sequence_position(48.18, 36.87, -53.98)
		event.set_camera_sequence_look_at(47.39, 31.65, -127.29)
		event.set_object_sequence_motion(8, "会話(あせり）", 6)
		event.queue_object_sequence_next_motion(8, "立ち(あせり）", 4)
		event.set_mouth_texture_animations(8, "口パク")
		at = 78
		helper_4116e6bb(4480365)
		event.reset_mouth_texture_animations()
		at = 79
		wait_frames(30)
		event.stop_music(0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(8, "立ち", 4)
		event.set_camera_sequence_position(-16.75, 163.56, -195.26)
		event.set_camera_sequence_look_at(19.55, 31.65, -72.54)
		event.set_object_sequence_motion(2, "なにin", 2)
		event.queue_object_sequence_next_motion(2, "なに（会話）", 2)
		event.queue_object_sequence_next_motion(2, "なにループ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 80
		helper_4116e6bb(4480370)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "なにループ")
		at = 81
		wait_frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_position(1, -25.0, 14.67, 0.0)
		event.set_object_sequence_position(0, 25.0, 14.67, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(43.45, 19.19, -25.77)
		event.set_camera_sequence_look_at(16.15, 41.45, 12.29)
		at = 82
		helper_4116e6bb(4480380)
		at = 83
		wait_frames(15)
		event.set_camera_sequence_position(28.79, 40.99, 82.7)
		event.set_camera_sequence_look_at(27.79, 35.36, -21.36)
		event.set_object_sequence_motion(8, "礼", 6)
		event.queue_object_sequence_next_motion(8, "立ち")
		event.set_object_sequence_motion(7, "礼", 6)
		event.queue_object_sequence_next_motion(7, "立ち")
		at = 84
		wait_frames(30)
		event.set_object_sequence_motion(8, "振り返り", 6)
		event.queue_object_sequence_next_motion(8, "立ち")
		event.set_object_sequence_motion(7, "振り返り", 6)
		event.queue_object_sequence_next_motion(7, "立ち")
		event.play_sound_effect(var6, 12)
		event.rotate_object_sequence(8, 0.0, 2.38, 0.0, 30)
		event.rotate_object_sequence(7, 0.0, 2.38, 0.0, 30)
		at = 85
		wait_objects(8)
		at = 86
		wait_objects(7)
		event.set_object_sequence_motion(7, "走り")
		event.set_object_sequence_motion(8, "走り")
		event.move_object_sequence(8, 256.4, 14.67, -306.5, 120, 1)
		event.move_object_sequence(7, 214.08, 14.67, -282.13, 120, 1)
		at = 87
		helper_4116e6bb(4480390)
		event.set_object_sequence_motion(8, "立ち", 4)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_character_active(0, 40)
		event.set_character_active(0, 41)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(480)
		event.add_camera_sequence_path_point(-0.11, 39.79, -43.33, 24.6, 36.05, -0.54)
		event.add_camera_sequence_path_point(12.71, 39.79, -21.13, 24.6, 36.05, -0.54)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		at = 88
		helper_1584c528(4480400, -1)
		at = 89
		helper_1584c528(4480410, -1)
		at = 90
		wait_frames(30)
		event.fade_out_screen(30)
		at = 91
		wait_frames(30)
		event.load_music(32)
		event.clear_camera_sequence()
		event.set_object_sequence_position(1, 21.0, 14.67, -96.4)
		event.set_object_sequence_rotation(1, 0.0, -0.42, 0.0)
		event.set_object_sequence_position(0, -21.0, 14.67, -96.4)
		event.set_object_sequence_rotation(0, 0.0, 0.42, 0.0)
		event.set_object_sequence_position(2, 0.0, 14.67, -96.4)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_camera_sequence_position(-0.58, 284.23, -107.49)
		event.set_camera_sequence_look_at(-0.45, 364.5, 62.05)
		event.play_music(0)
		event.fade_in_screen(30)
		at = 92
		wait_frames(30)
		event.play_sound_effect(var6, 13)
		event.set_character_active(1, 42)
		event.set_character_motion(42, "光射出", 6, -1, 1)
		at = 93
		wait_frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(-0.44, 313.67, -237.11, 0.0, 258.09, 0.0)
		event.add_camera_sequence_path_point(-0.44, 87.87, -237.11, 0.0, 32.29, 0.0)
		event.start_camera_sequence_path()
		event.set_character_motion(42, "光射出", 6, -1, 1)
		at = 94
		wait_camera()
		at = 95
		wait_frames(30)
		event.set_camera_sequence_position(-31.6, 43.91, -71.47)
		event.set_camera_sequence_look_at(0.0, 32.29, 0.0)
		event.play_sound_effect(var6, 14)
		event.set_character_motion(42, "出現", 2, -1, 1)
		at = 96
		wait_frames(60)
		event.set_character_motion(42, "立ち", 2, -1, 1)
		event.set_character_active(1, 39)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 97
		helper_4116e6bb(4480420)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		at = 98
		wait_frames(15)
		event.set_camera_sequence_position(-26.24, 38.68, 42.72)
		event.set_camera_sequence_look_at(-5.44, 38.62, -14.16)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 99
		helper_4116e6bb(4480430)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		at = 100
		wait_frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_camera_sequence_position(-36.23, 32.89, -39.54)
		event.set_camera_sequence_look_at(-20.39, 30.89, -98.66)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 101
		helper_4116e6bb(4480440)
		event.reset_mouth_texture_animations()
		at = 102
		wait_frames(15)
		event.set_camera_sequence_position(0.93, 19.93, -42.57)
		event.set_camera_sequence_look_at(0.16, 32.65, -3.38)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 103
		helper_4116e6bb(4480450)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		at = 104
		wait_frames(15)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_rotation(1, 0.0, -1.38, 0.0)
		event.set_object_sequence_motion(2, "ユリス向くin", 2)
		event.queue_object_sequence_next_motion(2, "ユリス向くループ")
		event.set_camera_sequence_position(-40.71, 43.64, -49.96)
		event.set_camera_sequence_look_at(-5.77, 32.65, -99.78)
		event.set_object_sequence_motion(0, "うなづき", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 105
		helper_4116e6bb(4480460)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var6, 15)
		event.set_object_sequence_motion(2, "なんとin", 2)
		event.queue_object_sequence_next_motion(2, "なんと（会話）", 2)
		event.queue_object_sequence_next_motion(2, "なんとループ", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 106
		helper_4116e6bb(4480470)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 107
		helper_4116e6bb(4480480)
		event.reset_mouth_texture_animations()
		event.fade_out_music(30)
		at = 108
		wait_frames(30)
		event.stop_music(0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_rotation(1, 0.0, -0.42, 0.0)
		event.set_camera_sequence_position(-55.29, 35.05, -118.99)
		event.set_camera_sequence_look_at(-21.97, 32.65, -81.62)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 109
		helper_4116e6bb(4480490)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		at = 110
		helper_4116e6bb(4480495)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 111
		helper_4116e6bb(4480500)
		at = 112
		helper_4116e6bb(4480510)
		event.set_object_sequence_motion(3, "下向く", 6)
		event.queue_object_sequence_next_motion(3, "下向くL", 4)
		at = 113
		helper_4116e6bb(4480520)
		at = 114
		wait_frames(15)
		event.load_music(5)
		event.set_camera_sequence_position(-21.1, 62.41, -39.24)
		event.set_camera_sequence_look_at(5.13, 26.57, 9.54)
		at = 115
		wait_frames(30)
		event.play_music(0)
		event.set_object_sequence_motion(3, "下向く戻り", 6)
		event.queue_object_sequence_next_motion(3, "会話2", 4)
		event.set_mouth_texture_animations(3, "口パク")
		at = 116
		helper_4116e6bb(4480530)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		at = 117
		helper_4116e6bb(4480535)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		at = 118
		wait_frames(15)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "前向き～右向き")
		event.set_object_sequence_rotation(1, 0.0, -0.42, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_camera_sequence_position(-162.52, 46.79, -31.74)
		event.set_camera_sequence_look_at(19.74, 41.85, -50.98)
		event.set_object_sequence_motion(3, "会話", 6)
		event.queue_object_sequence_next_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 119
		helper_4116e6bb(4480540)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 120
		helper_4116e6bb(4480550)
		at = 121
		wait_frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_position(1, 17.0, 14.67, -96.4)
		event.set_object_sequence_rotation(1, 0.0, -0.42, 0.0)
		event.set_object_sequence_position(0, -17.0, 14.67, -96.4)
		event.set_object_sequence_rotation(0, 0.0, 0.06, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(30.34, 36.89, -45.36)
		event.set_camera_sequence_look_at(3.39, 33.28, -93.72)
		at = 122
		helper_4116e6bb(4480560)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		at = 123
		wait_frames(30)
		event.set_object_sequence_rotation(0, 0.0, 0.42, 0.0)
		event.set_camera_sequence_position(0.93, 19.93, -42.57)
		event.set_camera_sequence_look_at(0.16, 32.65, -3.38)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 124
		helper_4116e6bb(4480565)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		at = 125
		wait_frames(15)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_camera_sequence_position(-162.52, 46.79, -31.74)
		event.set_camera_sequence_look_at(19.74, 41.85, -50.98)
		event.set_object_sequence_motion(3, "会話", 6)
		event.queue_object_sequence_next_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 126
		helper_4116e6bb(4480570)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		at = 127
		helper_4116e6bb(4480575)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		at = 128
		wait_frames(15)
		event.set_camera_sequence_position(-55.29, 35.05, -118.99)
		event.set_camera_sequence_look_at(-21.97, 32.65, -81.62)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 129
		helper_4116e6bb(4480580)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		event.set_mouth_texture_animations(3, "口パク")
		at = 130
		helper_4116e6bb(4480590)
		event.reset_mouth_texture_animations()
		at = 131
		wait_frames(15)
		event.set_camera_sequence_position(-23.01, 33.54, -27.56)
		event.set_camera_sequence_look_at(5.73, 39.63, 4.67)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 132
		helper_4116e6bb(4480600)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		at = 133
		helper_4116e6bb(4480605)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128, 128, 128, 128, 30)
		at = 134
		helper_4116e6bb(4480610)
		at = 135
		helper_4116e6bb(4480615)
		at = 136
		helper_4116e6bb(4480620)
		at = 137
		helper_4116e6bb(4480630)
		at = 138
		helper_4116e6bb(4480635)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(11, 128, 128, 128, 128, 30)
		at = 139
		helper_4116e6bb(4480640)
		at = 140
		helper_4116e6bb(4480645)
		at = 141
		helper_4116e6bb(4480650)
		at = 142
		helper_4116e6bb(4480660)
		at = 143
		helper_4116e6bb(4480665)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(12, 128, 128, 128, 128, 30)
		at = 144
		helper_4116e6bb(4480670)
		at = 145
		helper_4116e6bb(4480680)
		at = 146
		helper_4116e6bb(4480690)
		at = 147
		helper_4116e6bb(4480700)
		at = 148
		helper_4116e6bb(4480710)
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(13, 128, 128, 128, 128, 30)
		at = 149
		helper_4116e6bb(4480720)
		at = 150
		helper_4116e6bb(4480730)
		at = 151
		helper_4116e6bb(4480735)
		at = 152
		helper_4116e6bb(4480740)
		at = 153
		helper_4116e6bb(4480750)
		at = 154
		helper_4116e6bb(4480760)
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(14, 128, 128, 128, 128, 30)
		at = 155
		helper_4116e6bb(4480770)
		at = 156
		helper_4116e6bb(4480775)
		at = 157
		helper_4116e6bb(4480780)
		at = 158
		helper_4116e6bb(4480790)
		at = 159
		helper_4116e6bb(4480795)
		event.set_event_sprite_draw_pass(5, 1)
		event.set_object_sequence_color(15, 128, 128, 128, 128, 30)
		at = 160
		helper_4116e6bb(4480800)
		at = 161
		helper_4116e6bb(4480805)
		event.set_event_sprite_draw_pass(6, 1)
		event.set_object_sequence_color(16, 128, 128, 128, 128, 30)
		at = 162
		helper_4116e6bb(4480810)
		at = 163
		helper_4116e6bb(4480815)
		event.set_camera_sequence_position(-38.5, 41.66, -29.35)
		event.set_camera_sequence_look_at(0.0, 35.62, 0.0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_draw_pass(3, 0)
		event.set_event_sprite_draw_pass(4, 0)
		event.set_event_sprite_draw_pass(5, 0)
		event.set_object_sequence_color(16, 128, 128, 128, 0, 30)
		event.set_mouth_texture_animations(3, "口パク")
		at = 164
		helper_4116e6bb(4480820)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "下向く", 6)
		event.queue_object_sequence_next_motion(3, "下向くL", 4)
		at = 165
		wait_frames(60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_rotation(1, 0.0, -1.38, 0.0)
		event.set_camera_sequence_position(-37.37, 25.85, -54.46)
		event.set_camera_sequence_look_at(-10.76, 35.62, -86.97)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 166
		helper_4116e6bb(4480830)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 167
		helper_4116e6bb(4480840)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "ユリス向くin", 2)
		event.queue_object_sequence_next_motion(2, "ユリス向くループ")
		event.set_character_cloth_animation_enabled(global0, 0)
		event.play_sound_effect(var6, 16)
		event.set_object_sequence_motion(0, "アトラさわる", 6)
		event.queue_object_sequence_next_motion(0, "アトラさわるL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 168
		helper_4116e6bb(4480850)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.set_object_sequence_motion(1, "首振り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 169
		helper_4116e6bb(4480860)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 170
		helper_4116e6bb(4480865)
		event.reset_mouth_texture_animations()
		at = 171
		wait_frames(15)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(42.2, 46.5, -67.56)
		event.set_camera_sequence_look_at(0.69, 36.17, -95.69)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 172
		helper_4116e6bb(4480870)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 173
		helper_4116e6bb(4480880)
		event.reset_mouth_texture_animations()
		at = 174
		wait_frames(15)
		event.set_camera_sequence_position(-8.37, 35.97, -85.14)
		event.set_camera_sequence_look_at(-17.52, 30.64, -95.93)
		at = 175
		helper_4116e6bb(4480890)
		at = 176
		wait_frames(15)
		event.set_camera_sequence_position(-21.1, 62.41, -39.24)
		event.set_camera_sequence_look_at(5.13, 26.57, 9.54)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 177
		helper_4116e6bb(4480900)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		at = 178
		wait_frames(15)
		event.set_character_cloth_animation_enabled(global0, 1)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_camera_sequence_position(-162.52, 46.79, -31.74)
		event.set_camera_sequence_look_at(19.74, 41.85, -50.98)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 179
		helper_4116e6bb(4480910)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 180
		helper_4116e6bb(4480920)
		event.reset_mouth_texture_animations()
		at = 181
		wait_frames(30)
		event.set_camera_sequence_position(-55.29, 35.05, -118.99)
		event.set_camera_sequence_look_at(-21.97, 32.65, -81.62)
		event.set_mouth_texture_animations(3, "口パク")
		at = 182
		helper_4116e6bb(4480930)
		event.reset_mouth_texture_animations()
		at = 183
		helper_4116e6bb(4480940)
		event.set_object_sequence_motion(3, "首ふる", 2)
		event.queue_object_sequence_next_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 184
		helper_4116e6bb(4480950)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		at = 185
		helper_4116e6bb(4480955)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		at = 186
		helper_4116e6bb(4480960)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		at = 187
		wait_frames(15)
		event.set_camera_sequence_position(-23.01, 33.54, -27.56)
		event.set_camera_sequence_look_at(5.73, 39.63, 4.67)
		at = 188
		wait_frames(30)
		event.stop_music(0)
		event.play_sound_effect(var6, 17)
		event.set_character_motion(42, "はっとする", 6, -1, 1)
		event.set_object_sequence_motion(3, "はっとする", 6)
		at = 189
		wait_frames(36)
		event.load_music(37)
		event.play_music(0)
		event.set_object_sequence_rotation(1, 0.0, -0.42, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_camera_sequence_position(-0.67, 77.75, -189.39)
		event.set_camera_sequence_look_at(0.41, 26.8, 10.88)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 190
		helper_4116e6bb(4480970)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		event.play_sound_effect(var6, 18)
		event.set_object_sequence_motion(2, "もう少しin", 6)
		event.queue_object_sequence_next_motion(2, "もう少し（会話）", 2)
		event.queue_object_sequence_next_motion(2, "もう少しループ")
		at = 191
		helper_4116e6bb(4480980)
		event.queue_object_sequence_next_motion(2, "もう少し（会話）", 2)
		event.queue_object_sequence_next_motion(2, "もう少しループ")
		at = 192
		helper_4116e6bb(4480985)
		event.set_object_sequence_motion(3, "会話", 6)
		event.queue_object_sequence_next_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 193
		helper_4116e6bb(4480990)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		event.queue_object_sequence_next_motion(2, "もう少し（会話）", 2)
		event.set_object_sequence_motion(2, "もう少しループ")
		at = 194
		helper_4116e6bb(4481000)
		at = 195
		wait_frames(30)
		event.set_camera_sequence_position(-38.5, 41.66, -29.35)
		event.set_camera_sequence_look_at(0.0, 35.62, 0.0)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 196
		helper_4116e6bb(4481010)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "会話", 6)
		event.queue_object_sequence_next_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 197
		helper_4116e6bb(4481015)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "胸に手をあてる", 6)
		event.queue_object_sequence_next_motion(3, "胸に手をあてるL", 4)
		event.set_mouth_texture_animations(3, "口パク")
		at = 198
		helper_4116e6bb(4481020)
		event.reset_mouth_texture_animations()
		at = 199
		wait_frames(15)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_camera_sequence_position(-37.37, 25.85, -54.46)
		event.set_camera_sequence_look_at(-10.76, 35.62, -86.97)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 200
		helper_4116e6bb(4481030)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "ユリス向くin", 2)
		event.queue_object_sequence_next_motion(2, "ユリス向くループ")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 201
		helper_4116e6bb(4481040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "前向き～右向き")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 202
		helper_4116e6bb(4481045)
		event.reset_mouth_texture_animations()
		at = 203
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_camera_sequence_position(-162.52, 46.79, -31.74)
		event.set_camera_sequence_look_at(19.74, 41.85, -50.98)
		event.set_object_sequence_motion(3, "会話2")
		event.set_mouth_texture_animations(3, "口パク")
		at = 204
		helper_4116e6bb(4481050)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "立ち")
		at = 205
		helper_4116e6bb(4481055)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.play_sound_effect(var6, 19)
		event.play_sound_effect(var6, 20)
		at = 206
		helper_4116e6bb(4481060)
		at = 207
		wait_frames(15)
		event.set_camera_sequence_position(0.14, 59.84, -159.42)
		event.set_camera_sequence_look_at(-0.03, 38.48, -81.63)
		event.set_character_motion(42, "消える", 6, -1, 1)
		event.set_character_visible(39, 0, 1, 0.05)
		event.play_sound_effect(var6, 21)
		at = 208
		wait_frames(60)
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, -0.11, 14.67, -49.09, 60, 1)
		at = 209
		wait_objects(2)
		event.play_sound_effect(var6, 22)
		event.set_object_sequence_motion(2, "振り向く（逆）")
		event.rotate_object_sequence(2, 0.0, 3.12, 0.0, 30)
		at = 210
		wait_objects(2)
		event.set_object_sequence_motion(2, "立ち")
		at = 211
		wait_frames(30)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 212
		helper_4116e6bb(4481070)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 213
		helper_4116e6bb(4481075)
		event.reset_mouth_texture_animations()
		at = 214
		wait_frames(30)
		event.set_camera_sequence_position(-39.91, 25.25, -77.93)
		event.set_camera_sequence_look_at(-0.1, 29.77, -48.62)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 215
		helper_4116e6bb(4481080)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 216
		helper_4116e6bb(4481090)
		event.reset_mouth_texture_animations()
		at = 217
		wait_frames(15)
		event.set_object_sequence_rotation(1, 0.0, -1.38, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_camera_sequence_position(1.03, 69.38, -3.58)
		event.set_camera_sequence_look_at(-0.03, 27.73, -81.63)
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 218
		helper_4116e6bb(4481100)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 219
		helper_4116e6bb(4481110)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 220
		helper_4116e6bb(4481115)
		event.reset_mouth_texture_animations()
		at = 221
		wait_frames(30)
		event.set_object_sequence_rotation(0, 0.0, 0.06, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(40.04, 39.75, -68.21)
		event.set_camera_sequence_look_at(-6.7, 35.75, -106.34)
		event.play_sound_effect(var6, 23)
		event.set_object_sequence_motion(0, "がっつ", 6)
		event.queue_object_sequence_next_motion(0, "がっつL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 222
		helper_4116e6bb(4481120)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var6, 24)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 223
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(30)
		end
		if at <= 2 then
			helper_21800000()
			wait_frames_skipping(4)
		end
		if at <= 3 then
			wait_frames_skipping(150)
		end
		if at <= 4 then
			helper_52aadc70(4480010, 150)
		end
		if at <= 5 then
			helper_52aadc70(4480015, -1)
		end
		if at <= 6 then
			wait_frames_skipping(30)
		end
		if at <= 7 then
			helper_8cd371d7(4480020)
		end
		if at <= 8 then
			helper_8cd371d7(4480030)
		end
		if at <= 9 then
			helper_8cd371d7(4480040)
		end
		if at <= 10 then
			wait_frames_skipping(30)
		end
		if at <= 11 then
			wait_frames_skipping(90)
		end
		if at <= 12 then
			wait_frames_skipping(30)
		end
		if at <= 13 then
			wait_frames_skipping(60)
		end
		if at <= 14 then
			helper_8cd371d7(4480050)
		end
		if at <= 15 then
			helper_8cd371d7(4480060)
		end
		if at <= 16 then
			helper_8cd371d7(4480065)
		end
		if at <= 17 then
			wait_frames_skipping(15)
		end
		if at <= 18 then
			helper_8cd371d7(4480070)
		end
		if at <= 19 then
			wait_frames_skipping(30)
		end
		if at <= 20 then
			helper_8cd371d7(4480080)
		end
		if at <= 21 then
			helper_8cd371d7(4480090)
		end
		if at <= 22 then
			helper_238b5abc(2)
		end
		if at <= 23 then
			wait_frames_skipping(15)
		end
		if at <= 24 then
			helper_8cd371d7(4480095)
		end
		if at <= 25 then
			wait_frames_skipping(30)
		end
		if at <= 26 then
			helper_238b5abc(7)
		end
		if at <= 27 then
			helper_238b5abc(7)
		end
		if at <= 28 then
			helper_8cd371d7(4480100)
		end
		if at <= 29 then
			helper_8cd371d7(4480110)
		end
		if at <= 30 then
			helper_8cd371d7(4480120)
		end
		if at <= 31 then
			wait_frames_skipping(15)
		end
		if at <= 32 then
			helper_8cd371d7(4480130)
		end
		if at <= 33 then
			wait_frames_skipping(15)
		end
		if at <= 34 then
			helper_8cd371d7(4480140)
		end
		if at <= 35 then
			helper_8cd371d7(4480150)
		end
		if at <= 36 then
			helper_8cd371d7(4480155)
		end
		if at <= 37 then
			wait_frames_skipping(30)
		end
		if at <= 38 then
			helper_8cd371d7(4480160)
		end
		if at <= 39 then
			helper_52aadc70(4480170, -1)
		end
		if at <= 40 then
			helper_52aadc70(4480180, -1)
		end
		if at <= 41 then
			helper_52aadc70(4480183, -1)
		end
		if at <= 42 then
			helper_344d6cd8()
		end
		if at <= 43 then
			helper_8cd371d7(4480185)
		end
		if at <= 44 then
			helper_8cd371d7(4480188)
		end
		if at <= 45 then
			helper_8cd371d7(4480190)
		end
		if at <= 46 then
			wait_frames_skipping(30)
		end
		if at <= 47 then
			helper_8cd371d7(4480200)
		end
		if at <= 48 then
			wait_frames_skipping(15)
		end
		if at <= 49 then
			helper_52aadc70(4480210, -1)
		end
		if at <= 50 then
			wait_frames_skipping(15)
		end
		if at <= 51 then
			helper_8cd371d7(4480220)
		end
		if at <= 52 then
			wait_frames_skipping(30)
		end
		if at <= 53 then
			helper_8cd371d7(4480230)
		end
		if at <= 54 then
			wait_frames_skipping(30)
		end
		if at <= 55 then
			helper_8cd371d7(4480240)
		end
		if at <= 56 then
			wait_frames_skipping(30)
		end
		if at <= 57 then
			helper_8cd371d7(4480250)
		end
		if at <= 58 then
			helper_8cd371d7(4480260)
		end
		if at <= 59 then
			helper_8cd371d7(4480270)
		end
		if at <= 60 then
			helper_8cd371d7(4480275)
		end
		if at <= 61 then
			wait_frames_skipping(30)
		end
		if at <= 62 then
			helper_8cd371d7(4480280)
		end
		if at <= 63 then
			helper_8cd371d7(4480290)
		end
		if at <= 64 then
			helper_8cd371d7(4480300)
		end
		if at <= 65 then
			wait_frames_skipping(30)
		end
		if at <= 66 then
			helper_8cd371d7(4480310)
		end
		if at <= 67 then
			wait_frames_skipping(30)
		end
		if at <= 68 then
			helper_8cd371d7(4480320)
		end
		if at <= 69 then
			wait_frames_skipping(30)
		end
		if at <= 70 then
			helper_8cd371d7(4480330)
		end
		if at <= 71 then
			helper_8cd371d7(4480340)
		end
		if at <= 72 then
			helper_8cd371d7(4480350)
		end
		if at <= 73 then
			wait_frames_skipping(30)
		end
		if at <= 74 then
			wait_frames_skipping(30)
		end
		if at <= 75 then
			helper_8cd371d7(4480360)
		end
		if at <= 76 then
			helper_238b5abc(8)
		end
		if at <= 77 then
			helper_8cd371d7(4480365)
		end
		if at <= 78 then
			wait_frames_skipping(30)
		end
		if at <= 79 then
			helper_8cd371d7(4480370)
		end
		if at <= 80 then
			wait_frames_skipping(30)
		end
		if at <= 81 then
			helper_8cd371d7(4480380)
		end
		if at <= 82 then
			wait_frames_skipping(15)
		end
		if at <= 83 then
			wait_frames_skipping(30)
		end
		if at <= 84 then
			helper_238b5abc(8)
		end
		if at <= 85 then
			helper_238b5abc(7)
		end
		if at <= 86 then
			helper_8cd371d7(4480390)
		end
		if at <= 87 then
			helper_52aadc70(4480400, -1)
		end
		if at <= 88 then
			helper_52aadc70(4480410, -1)
		end
		if at <= 89 then
			wait_frames_skipping(30)
		end
		if at <= 90 then
			wait_frames_skipping(30)
		end
		if at <= 91 then
			wait_frames_skipping(30)
		end
		if at <= 92 then
			wait_frames_skipping(30)
		end
		if at <= 93 then
			helper_344d6cd8()
		end
		if at <= 94 then
			wait_frames_skipping(30)
		end
		if at <= 95 then
			wait_frames_skipping(60)
		end
		if at <= 96 then
			helper_8cd371d7(4480420)
		end
		if at <= 97 then
			wait_frames_skipping(15)
		end
		if at <= 98 then
			helper_8cd371d7(4480430)
		end
		if at <= 99 then
			wait_frames_skipping(15)
		end
		if at <= 100 then
			helper_8cd371d7(4480440)
		end
		if at <= 101 then
			wait_frames_skipping(15)
		end
		if at <= 102 then
			helper_8cd371d7(4480450)
		end
		if at <= 103 then
			wait_frames_skipping(15)
		end
		if at <= 104 then
			helper_8cd371d7(4480460)
		end
		if at <= 105 then
			helper_8cd371d7(4480470)
		end
		if at <= 106 then
			helper_8cd371d7(4480480)
		end
		if at <= 107 then
			wait_frames_skipping(30)
		end
		if at <= 108 then
			helper_8cd371d7(4480490)
		end
		if at <= 109 then
			helper_8cd371d7(4480495)
		end
		if at <= 110 then
			helper_8cd371d7(4480500)
		end
		if at <= 111 then
			helper_8cd371d7(4480510)
		end
		if at <= 112 then
			helper_8cd371d7(4480520)
		end
		if at <= 113 then
			wait_frames_skipping(15)
		end
		if at <= 114 then
			wait_frames_skipping(30)
		end
		if at <= 115 then
			helper_8cd371d7(4480530)
		end
		if at <= 116 then
			helper_8cd371d7(4480535)
		end
		if at <= 117 then
			wait_frames_skipping(15)
		end
		if at <= 118 then
			helper_8cd371d7(4480540)
		end
		if at <= 119 then
			helper_8cd371d7(4480550)
		end
		if at <= 120 then
			wait_frames_skipping(15)
		end
		if at <= 121 then
			helper_8cd371d7(4480560)
		end
		if at <= 122 then
			wait_frames_skipping(30)
		end
		if at <= 123 then
			helper_8cd371d7(4480565)
		end
		if at <= 124 then
			wait_frames_skipping(15)
		end
		if at <= 125 then
			helper_8cd371d7(4480570)
		end
		if at <= 126 then
			helper_8cd371d7(4480575)
		end
		if at <= 127 then
			wait_frames_skipping(15)
		end
		if at <= 128 then
			helper_8cd371d7(4480580)
		end
		if at <= 129 then
			helper_8cd371d7(4480590)
		end
		if at <= 130 then
			wait_frames_skipping(15)
		end
		if at <= 131 then
			helper_8cd371d7(4480600)
		end
		if at <= 132 then
			helper_8cd371d7(4480605)
		end
		if at <= 133 then
			helper_8cd371d7(4480610)
		end
		if at <= 134 then
			helper_8cd371d7(4480615)
		end
		if at <= 135 then
			helper_8cd371d7(4480620)
		end
		if at <= 136 then
			helper_8cd371d7(4480630)
		end
		if at <= 137 then
			helper_8cd371d7(4480635)
		end
		if at <= 138 then
			helper_8cd371d7(4480640)
		end
		if at <= 139 then
			helper_8cd371d7(4480645)
		end
		if at <= 140 then
			helper_8cd371d7(4480650)
		end
		if at <= 141 then
			helper_8cd371d7(4480660)
		end
		if at <= 142 then
			helper_8cd371d7(4480665)
		end
		if at <= 143 then
			helper_8cd371d7(4480670)
		end
		if at <= 144 then
			helper_8cd371d7(4480680)
		end
		if at <= 145 then
			helper_8cd371d7(4480690)
		end
		if at <= 146 then
			helper_8cd371d7(4480700)
		end
		if at <= 147 then
			helper_8cd371d7(4480710)
		end
		if at <= 148 then
			helper_8cd371d7(4480720)
		end
		if at <= 149 then
			helper_8cd371d7(4480730)
		end
		if at <= 150 then
			helper_8cd371d7(4480735)
		end
		if at <= 151 then
			helper_8cd371d7(4480740)
		end
		if at <= 152 then
			helper_8cd371d7(4480750)
		end
		if at <= 153 then
			helper_8cd371d7(4480760)
		end
		if at <= 154 then
			helper_8cd371d7(4480770)
		end
		if at <= 155 then
			helper_8cd371d7(4480775)
		end
		if at <= 156 then
			helper_8cd371d7(4480780)
		end
		if at <= 157 then
			helper_8cd371d7(4480790)
		end
		if at <= 158 then
			helper_8cd371d7(4480795)
		end
		if at <= 159 then
			helper_8cd371d7(4480800)
		end
		if at <= 160 then
			helper_8cd371d7(4480805)
		end
		if at <= 161 then
			helper_8cd371d7(4480810)
		end
		if at <= 162 then
			helper_8cd371d7(4480815)
		end
		if at <= 163 then
			helper_8cd371d7(4480820)
		end
		if at <= 164 then
			wait_frames_skipping(60)
		end
		if at <= 165 then
			helper_8cd371d7(4480830)
		end
		if at <= 166 then
			helper_8cd371d7(4480840)
		end
		if at <= 167 then
			helper_8cd371d7(4480850)
		end
		if at <= 168 then
			helper_8cd371d7(4480860)
		end
		if at <= 169 then
			helper_8cd371d7(4480865)
		end
		if at <= 170 then
			wait_frames_skipping(15)
		end
		if at <= 171 then
			helper_8cd371d7(4480870)
		end
		if at <= 172 then
			helper_8cd371d7(4480880)
		end
		if at <= 173 then
			wait_frames_skipping(15)
		end
		if at <= 174 then
			helper_8cd371d7(4480890)
		end
		if at <= 175 then
			wait_frames_skipping(15)
		end
		if at <= 176 then
			helper_8cd371d7(4480900)
		end
		if at <= 177 then
			wait_frames_skipping(15)
		end
		if at <= 178 then
			helper_8cd371d7(4480910)
		end
		if at <= 179 then
			helper_8cd371d7(4480920)
		end
		if at <= 180 then
			wait_frames_skipping(30)
		end
		if at <= 181 then
			helper_8cd371d7(4480930)
		end
		if at <= 182 then
			helper_8cd371d7(4480940)
		end
		if at <= 183 then
			helper_8cd371d7(4480950)
		end
		if at <= 184 then
			helper_8cd371d7(4480955)
		end
		if at <= 185 then
			helper_8cd371d7(4480960)
		end
		if at <= 186 then
			wait_frames_skipping(15)
		end
		if at <= 187 then
			wait_frames_skipping(30)
		end
		if at <= 188 then
			wait_frames_skipping(36)
		end
		if at <= 189 then
			helper_8cd371d7(4480970)
		end
		if at <= 190 then
			helper_8cd371d7(4480980)
		end
		if at <= 191 then
			helper_8cd371d7(4480985)
		end
		if at <= 192 then
			helper_8cd371d7(4480990)
		end
		if at <= 193 then
			helper_8cd371d7(4481000)
		end
		if at <= 194 then
			wait_frames_skipping(30)
		end
		if at <= 195 then
			helper_8cd371d7(4481010)
		end
		if at <= 196 then
			helper_8cd371d7(4481015)
		end
		if at <= 197 then
			helper_8cd371d7(4481020)
		end
		if at <= 198 then
			wait_frames_skipping(15)
		end
		if at <= 199 then
			helper_8cd371d7(4481030)
		end
		if at <= 200 then
			helper_8cd371d7(4481040)
		end
		if at <= 201 then
			helper_8cd371d7(4481045)
		end
		if at <= 202 then
			wait_frames_skipping(30)
		end
		if at <= 203 then
			helper_8cd371d7(4481050)
		end
		if at <= 204 then
			helper_8cd371d7(4481055)
		end
		if at <= 205 then
			helper_8cd371d7(4481060)
		end
		if at <= 206 then
			wait_frames_skipping(15)
		end
		if at <= 207 then
			wait_frames_skipping(60)
		end
		if at <= 208 then
			helper_238b5abc(2)
		end
		if at <= 209 then
			helper_238b5abc(2)
		end
		if at <= 210 then
			wait_frames_skipping(30)
		end
		if at <= 211 then
			helper_8cd371d7(4481070)
		end
		if at <= 212 then
			helper_8cd371d7(4481075)
		end
		if at <= 213 then
			wait_frames_skipping(30)
		end
		if at <= 214 then
			helper_8cd371d7(4481080)
		end
		if at <= 215 then
			helper_8cd371d7(4481090)
		end
		if at <= 216 then
			wait_frames_skipping(15)
		end
		if at <= 217 then
			helper_8cd371d7(4481100)
		end
		if at <= 218 then
			helper_8cd371d7(4481110)
		end
		if at <= 219 then
			helper_8cd371d7(4481115)
		end
		if at <= 220 then
			wait_frames_skipping(30)
		end
		if at <= 221 then
			helper_8cd371d7(4481120)
		end
		if at <= 222 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 224
	vm.entry(224)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 225
	wait_frames(35)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.skip_next_music_load()
	helper_1431c()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local var5: s32 = 0
	local at: number = 0
	return vm.guard(function()
		helper_ec30b150()
		flag = event.get_save_flag(464) or flag
		if flag == 0 then
			at = 1
			helper_e4945fa4()
		end
		flag_2 = event.get_save_flag(444) or flag_2
		flag_3 = event.get_save_flag(448) or flag_3
		if flag_2 == 1 and flag_3 == 0 then
			event.set_save_flag(448, 1)
			at = 2
			helper_16f18()
			event.jump_to_map_3(-1, "s09", 500)
			at = 3
			vm.wait(3)
			return
		end
		flag_4 = event.get_save_flag(540) or flag_4
		flag_5 = event.get_save_flag(600) or flag_5
		if flag_4 == 1 and flag_5 == 0 then
			event.skip_next_music_load()
			event.jump_to_map_3(-1, "s53", 500)
			at = 4
			vm.wait(4)
			return
		end
		var5 = event.get_save_counter(2) or var5
		if var5 == 0 then
			helper_9dafbc83(0.0, vm.f32(310.2), vm.f32(938.3), vm.f32(3.14))
		end
		if var5 == 1 then
			helper_9dafbc83(-685.0, vm.f32(226.9), 665.0, vm.f32(2.355))
		end
		if var5 == 2 then
			helper_9dafbc83(-685.0, vm.f32(226.9), -665.0, vm.f32(0.785))
		end
		if var5 == 3 then
			helper_9dafbc83(685.0, vm.f32(226.9), -665.0, vm.f32(-0.785))
		end
		if var5 == 4 then
			helper_9dafbc83(685.0, vm.f32(226.9), 665.0, vm.f32(-2.355))
		end
		event.reset_follow_camera(1, 0.0, 10)
		event.fade_in_screen(30)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_16f18()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s09", 500)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_16f18

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	helper_3a1e288a(0.0, 1)
	event.set_save_counter(2, 0)
	event.jump_to_map_2(-1, "f03")
	vm.wait(2)
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	helper_3a1e288a(vm.f32(-0.7853982), 0)
	event.set_save_counter(2, 1)
	event.jump_to_map_2(-1, "f03")
	vm.wait(2)
end

--- Event 402, which map data, a script or the engine runs by number.
function script.event_402()
	helper_3a1e288a(vm.f32(-2.3561945), 0)
	event.set_save_counter(2, 2)
	event.jump_to_map_2(-1, "f03")
	vm.wait(2)
end

--- Event 403, which map data, a script or the engine runs by number.
function script.event_403()
	helper_3a1e288a(vm.f32(2.3561945), 0)
	event.set_save_counter(2, 3)
	event.jump_to_map_2(-1, "f03")
	vm.wait(2)
end

--- Event 404, which map data, a script or the engine runs by number.
function script.event_404()
	helper_3a1e288a(vm.f32(0.7853982), 0)
	event.set_save_counter(2, 4)
	event.jump_to_map_2(-1, "f03")
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_9cb0ca44

--- Event 14480, which map data, a script or the engine runs by number.
function script.event_14480()
	helper_16f18()
	event.jump_to_map_3(-1, "s09", 500)
	vm.wait(2)
end

--- Event 14640, which map data, a script or the engine runs by number.
script.event_14640 = helper_e4945fa4

--- Event 16000, which map data, a script or the engine runs by number.
function script.event_16000()
	event.jump_to_map_3(-1, "s53", 500)
	vm.wait(1)
end

return script
