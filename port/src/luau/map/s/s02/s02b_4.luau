--!strict
-- map/s/s02/s02b_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0226fccb = require("@lib/event/helper_0226fccb")
local helper_042a5b29 = require("@lib/event/helper_042a5b29")
local helper_09a98fcd = require("@lib/event/helper_09a98fcd")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_2000ac46 = require("@lib/event/helper_2000ac46")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_301e75ef = require("@lib/event/helper_301e75ef")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_7d730ff7 = require("@lib/event/helper_7d730ff7")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_b76e3b36 = require("@lib/event/helper_b76e3b36")
local helper_d4172c24 = require("@lib/event/helper_d4172c24")
local helper_d529ed92 = require("@lib/event/helper_d529ed92")
local helper_d552d8eb = require("@lib/event/helper_d552d8eb")
local helper_e52544df = require("@lib/event/helper_e52544df")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local helper_f41e11f3 = require("@lib/event/helper_f41e11f3")
local helper_f72a4299 = require("@lib/event/helper_f72a4299")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_27ec0()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 33
		event.load_character_motion_pack(5, "event/e200/e207/e207_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/e200/e207/e207_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e200/e207/e207_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e207/e207_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.change_directory("event/e200/e207/")
	event.load_character(5, "e207_starbre.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "e207_vorneo.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "e207_tom.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_map_part_2(5, "p01_train01")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.change_directory("")
	event.load_message_file(0, 5, "event/e200/e207/e207_1.txt")
	event.set_scene_status_flags(1, global0, 256, 1)
	event.set_scene_status_flags(1, global1, 256, 1)
end

--- Helper function.
local function helper_22200000()
	global0 = 0
	global1 = 33
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_26e74()
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
		event.delete_character_extension_packs(global1)
		event.delete_character_extension_packs(global0)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.set_event_sprite_draw_pass(5, 0)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_28e0c()
	local var0: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(207, 1)
		event.initialize_event()
		var0 = event.load_sound_effect_file_2(2211) or var0
		helper_27ec0()
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(59)
		event.set_object_handle_sound_bank(0, var0)
		event.set_object_handle_sound_bank(3, var0)
		event.set_object_handle_sound_bank(4, var0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.enable_drama_skip()
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.fade_in_screen(30)
		event.set_camera_sequence_position(-434.98, 136.35, -416.59)
		event.set_camera_sequence_look_at(-204.96, 128.86, -33.25)
		at = 3
		helper_301e75ef(var0)
		event.set_object_handle_shadow_enabled(2, 0)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(-186.23, 38.08, 632.43)
		event.set_camera_sequence_look_at(-133.81, 42.89, 555.58)
		event.set_object_sequence_position(5, 1.3, 8.0, 707.604)
		event.set_object_sequence_position(2, -7.85, 43.32, 488.75)
		event.set_object_sequence_rotation(2, 0.0, -1.2, 0.0)
		event.play_sound_effect(var0, 9)
		event.attach_object_handle_to_map_part_3(10, "p01_train01", "train11-m1")
		event.attach_object_handle_to_map_part_3(11, "p01_train01", "train12-m1")
		event.attach_object_handle_to_map_part_3(12, "p01_train01", "train12-m3")
		event.clear_object_sequence(10)
		event.clear_object_sequence(11)
		event.clear_object_sequence(12)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_object(11, 11)
		event.set_object_sequence_object(12, 12)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
		event.rotate_object_sequence(10, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(11, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(12, 0.0, -1.8, 0.0, 30)
		at = 4
		wait_frames(30)
		event.set_object_handle_footstep_sound(2, 6)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.move_object_sequence(2, -60.41, 43.32, 482.53, 90)
		at = 5
		wait_frames(90)
		event.set_object_handle_footstep_sound(2, -1)
		event.play_sound_effect(var0, 10)
		event.set_object_sequence_motion(2, "降りL", 4)
		event.jump_object_sequence(2, -121.4, 0.0, 519.8, -0.3, 16)
		at = 6
		wait_frames(16)
		at = 7
		wait_objects(2)
		event.set_object_sequence_motion(2, "着地", 6)
		event.set_object_sequence_motion(2, "立ち", 0)
		at = 8
		wait_frames(16)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
		event.set_object_handle_shadow_enabled(2, 1)
		event.clear_effect_manager()
		helper_09a98fcd()
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_character_active(1, global0)
		event.set_camera_sequence_position(-173.15, 24.27, 496.1)
		event.set_camera_sequence_look_at(-105.11, 33.85, 689.64)
		event.set_object_sequence_position(0, -115.15, 2.18, 481.7)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(2, -137.2, 0.0, 503.69)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(2, 0)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(2, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -116.24, 1.91, 584.2, 120)
		event.move_object_sequence(2, -136.14, 0.0, 621.84, 120)
		at = 9
		wait_frames(120)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(-148.61, 19.95, 659.05)
		event.set_camera_sequence_look_at(-138.99, 22.93, 629.2)
		event.set_object_sequence_position(0, -141.01, 0.0, 578.41)
		event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
		event.set_object_sequence_position(1, -158.87, 0.0, 543.98)
		event.set_object_sequence_rotation(1, 0.0, 0.48, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.24, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "頭をかく", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 10
		helper_4116e6bb(2070010)
		event.reset_mouth_texture_animations()
		event.set_effect_value(1, 0)
		event.set_camera_sequence_position(-157.72, 20.49, 508.51)
		event.set_camera_sequence_look_at(-155.0, 20.82, 540.27)
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 15)
		event.set_object_sequence_motion(0, "振り返る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "振り返るL", 0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 11
		helper_4116e6bb(2070020)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-204.87, 17.59, 518.8)
		event.set_camera_sequence_look_at(-167.74, 18.98, 537.69)
		event.set_object_sequence_position(0, -141.01, 0.0, 578.41)
		event.set_object_sequence_rotation(0, 0.0, 0.72, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, -0.48, 0.0)
		event.set_object_sequence_motion(1, "振り返る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "振り返るL", 0)
		event.play_sound_effect(var0, 11)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 12
		helper_1584c528(2070030, 90)
		event.reset_mouth_texture_animations()
		event.play_music(0)
		at = 13
		wait_frames(3)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 14
		helper_1584c528(2070035, 75)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 34)
		event.set_object_sequence_rotation(1, 0.0, -2.16, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_camera_sequence_position(-145.56, 14.05, 606.56)
		event.set_camera_sequence_look_at(-171.06, 25.18, 536.36)
		event.move_camera_sequence_angle_height_distance_eased(1.58, -11.13, 75.72, 180, 2, 0.4)
		at = 15
		wait_frames(30)
		at = 16
		helper_1584c528(2070040, 120)
		at = 17
		wait_frames(30)
		event.start_crossfade(30)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.clear_camera_sequence()
		event.set_object_sequence_rotation(0, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_camera_sequence_position(-172.35, 21.82, 561.72)
		event.set_camera_sequence_look_at(-139.13, 21.22, 572.94)
		event.move_camera_sequence_eased(-195.67, 21.82, 534.13, -163.38, 21.22, 544.2, 300, 2, 0.4)
		at = 18
		wait_frames(45)
		at = 19
		helper_1584c528(2070045, 240)
		at = 20
		wait_frames(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-98.17, 22.89, 602.25)
		event.set_camera_sequence_look_at(-133.12, 23.35, 577.23)
		event.set_object_sequence_rotation(1, 0.0, 0.48, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -2.68, 0.0)
		event.move_camera_sequence_eased(-115.83, 22.89, 589.95, -133.03, 23.35, 577.11, 510, 2, 0.4)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "振り返る2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "指差し会話", 2)
		event.queue_object_sequence_next_motion(1, "振り返る2戻り", 2)
		event.queue_object_sequence_next_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 2)
		event.queue_object_sequence_next_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_object_sequence_texture_animation(1, 1, "通常口パク")
		at = 21
		helper_1584c528(2070050, 120)
		at = 22
		helper_1584c528(2070055, 210)
		at = 23
		helper_1584c528(2070060, 180)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 24
		helper_4116e6bb(2070070)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 25
		helper_4116e6bb(2070075)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-185.14, 25.41, 532.33)
		event.set_camera_sequence_look_at(-163.43, 22.64, 546.85)
		event.set_object_sequence_rotation(0, 0.0, -2.68, 0.0)
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 26
		helper_4116e6bb(2070080)
		event.reset_mouth_texture_animations()
		at = 27
		wait_objects(0)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 128.0, 15)
		at = 28
		wait_frames(45)
		event.set_character_active(0, global0)
		event.set_camera_sequence_position(-143.73, 21.02, 571.76)
		event.set_camera_sequence_look_at(-159.34, 21.71, 544.14)
		event.set_object_sequence_motion(1, "説明", 4, -1.0, 1)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 0.0, 15)
		at = 29
		wait_frames(15)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 30
		helper_4116e6bb(2070090)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(21, 128.0, 128.0, 128.0, 128.0, 30)
		at = 31
		helper_4116e6bb(2070100)
		at = 32
		helper_4116e6bb(2070110)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(22, 128.0, 128.0, 128.0, 128.0, 15)
		at = 33
		wait_frames(15)
		event.set_event_sprite_draw_pass(1, 0)
		at = 34
		helper_4116e6bb(2070120)
		at = 35
		wait_objects(21)
		event.set_character_active(1, global0)
		event.set_camera_sequence_position(-147.89, 29.16, 595.33)
		event.set_camera_sequence_look_at(-145.3, 19.8, 562.12)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常口パク")
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_object_sequence_color(22, 128.0, 128.0, 128.0, 0.0, 15)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 36
		helper_4116e6bb(2070130)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 37
		helper_4116e6bb(2070140)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 38
		helper_4116e6bb(2070145)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(23, 128.0, 128.0, 128.0, 128.0, 30)
		at = 39
		helper_4116e6bb(2070150)
		at = 40
		helper_4116e6bb(2070160)
		event.set_camera_sequence_position(-62.39, 11.55, 592.64)
		event.set_camera_sequence_look_at(-144.81, 34.83, 558.99)
		event.set_object_sequence_position(0, -162.09, 0.0, 562.18)
		event.set_object_sequence_rotation(0, 0.0, -1.84, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.move_camera_sequence_eased(-93.73, 11.55, 579.85, -176.14, 34.83, 546.2, 300, 2, 0.4)
		event.set_object_sequence_color(23, 128.0, 128.0, 128.0, 0.0, 15)
		at = 41
		wait_frames(15)
		event.set_event_sprite_draw_pass(3, 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 42
		helper_4116e6bb(2070170)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 43
		helper_4116e6bb(2070175)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-199.01, 15.5, 557.14)
		event.set_camera_sequence_look_at(-160.33, 20.46, 548.43)
		event.set_object_sequence_motion(0, "右・モニカ見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右・モニカ見L", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 44
		helper_4116e6bb(2070180)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.set_object_sequence_motion(1, "下を向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "下を向くL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 45
		helper_4116e6bb(2070190)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 46
		helper_4116e6bb(2070200)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, global0)
		event.set_camera_sequence_position(-189.08, 26.03, 532.05)
		event.set_camera_sequence_look_at(-156.88, 20.88, 545.17)
		event.set_object_sequence_position(1, -158.87, 0.0, 543.98)
		event.set_object_sequence_rotation(1, 0.0, -2.04, 0.0)
		event.move_camera_sequence_eased(-186.83, 24.76, 532.98, -156.88, 20.88, 545.17, 90, 0, 0.4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 47
		helper_4116e6bb(2070210)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 48
		helper_4116e6bb(2070220)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 49
		helper_4116e6bb(2070230)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence()
		event.set_character_active(1, global0)
		event.set_camera_sequence_position(-184.15, 26.9, 520.44)
		event.set_camera_sequence_look_at(-163.12, 22.81, 547.31)
		event.set_object_sequence_rotation(0, 0.0, 3.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -0.12, 0.0)
		event.play_sound_effect(var0, 12)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "にぎりこぶし", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "にぎりこぶしL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 50
		helper_4116e6bb(2070240)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 51
		helper_4116e6bb(2070250)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(-192.2, 14.16, 580.57)
		event.set_camera_sequence_look_at(-164.89, 19.98, 558.98)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 52
		helper_4116e6bb(2070260)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 53
		helper_4116e6bb(2070270)
		event.reset_mouth_texture_animations()
		at = 54
		wait_frames(45)
		event.set_object_sequence_motion(0, "うなづく（モニカ見）", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 0)
		at = 55
		wait_frames(37)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 56
		helper_4116e6bb(2070280)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var0, 14)
		event.set_object_sequence_motion(1, "喜ぶ", 6)
		event.queue_object_sequence_next_motion(1, "喜ぶL", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 57
		helper_4116e6bb(2070290)
		event.reset_mouth_texture_animations()
		at = 58
		wait_objects(1)
		event.set_character_active(0, global0)
		event.set_camera_sequence_position(-161.91, 19.72, 571.63)
		event.set_camera_sequence_look_at(-157.59, 24.08, 543.43)
		event.play_sound_effect(var0, 19)
		event.set_object_sequence_motion(1, "握手", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "握手L", 0)
		at = 59
		wait_frames(30)
		at = 60
		wait_frames(30)
		event.fade_out_music(30)
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		if global0 == 0 then
			event.set_character_active(0, 37)
		end
		event.set_camera_sequence_position(-158.1, 29.71, 533.72)
		event.set_camera_sequence_look_at(-162.0, 22.25, 561.36)
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.move_camera_sequence_eased(-158.94, 29.71, 539.69, -162.85, 22.25, 567.33, 48, 2, 0.4)
		at = 61
		wait_camera()
		at = 62
		wait_frames(75)
		event.set_character_active(1, global1)
		event.set_character_active(1, 37)
		event.set_camera_sequence_position(-189.24, 15.33, 545.99)
		event.set_camera_sequence_look_at(-154.0, 23.32, 554.62)
		event.set_object_sequence_rotation(0, 0.0, 2.88, 0.0)
		event.set_object_sequence_motion(0, "握手", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "握手L", 0)
		at = 63
		wait_frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.init_sepia_effect(-1, 0)
		event.start_crossfade(30)
		event.start_sepia_effect()
		at = 64
		wait_frames(30)
		at = 65
		helper_1584c528(2070300, 330)
		event.fade_out_screen(15)
		at = 66
		wait_frames(15)
		event.end_sepia_effect()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22200000()
			wait_frames_skipping(4)
		end
		if at <= 2 then
			helper_f41e11f3(var0)
		end
		if at <= 3 then
			wait_frames_skipping(30)
		end
		if at <= 4 then
			wait_frames_skipping(90)
		end
		if at <= 5 then
			wait_frames_skipping(16)
		end
		if at <= 6 then
			helper_238b5abc(2)
		end
		if at <= 7 then
			wait_frames_skipping(16)
		end
		if at <= 8 then
			helper_344d6cd8()
			wait_frames_skipping(120)
		end
		if at <= 9 then
			helper_8cd371d7(2070010)
		end
		if at <= 10 then
			helper_8cd371d7(2070020)
		end
		if at <= 11 then
			helper_52aadc70(2070030, 90)
		end
		if at <= 12 then
			wait_frames_skipping(3)
		end
		if at <= 13 then
			helper_52aadc70(2070035, 75)
		end
		if at <= 14 then
			wait_frames_skipping(30)
		end
		if at <= 15 then
			helper_52aadc70(2070040, 120)
		end
		if at <= 16 then
			wait_frames_skipping(30)
		end
		if at <= 17 then
			wait_frames_skipping(45)
		end
		if at <= 18 then
			helper_52aadc70(2070045, 240)
		end
		if at <= 19 then
			wait_frames_skipping(30)
		end
		if at <= 20 then
			helper_52aadc70(2070050, 120)
		end
		if at <= 21 then
			helper_52aadc70(2070055, 210)
		end
		if at <= 22 then
			helper_52aadc70(2070060, 180)
		end
		if at <= 23 then
			helper_8cd371d7(2070070)
		end
		if at <= 24 then
			helper_8cd371d7(2070075)
		end
		if at <= 25 then
			helper_8cd371d7(2070080)
		end
		if at <= 26 then
			helper_238b5abc(0)
		end
		if at <= 27 then
			wait_frames_skipping(45)
		end
		if at <= 28 then
			wait_frames_skipping(15)
		end
		if at <= 29 then
			helper_8cd371d7(2070090)
		end
		if at <= 30 then
			helper_8cd371d7(2070100)
		end
		if at <= 31 then
			helper_8cd371d7(2070110)
		end
		if at <= 32 then
			wait_frames_skipping(15)
		end
		if at <= 33 then
			helper_8cd371d7(2070120)
		end
		if at <= 34 then
			helper_238b5abc(21)
		end
		if at <= 35 then
			helper_8cd371d7(2070130)
		end
		if at <= 36 then
			helper_8cd371d7(2070140)
		end
		if at <= 37 then
			helper_8cd371d7(2070145)
		end
		if at <= 38 then
			helper_8cd371d7(2070150)
		end
		if at <= 39 then
			helper_8cd371d7(2070160)
		end
		if at <= 40 then
			wait_frames_skipping(15)
		end
		if at <= 41 then
			helper_8cd371d7(2070170)
		end
		if at <= 42 then
			helper_8cd371d7(2070175)
		end
		if at <= 43 then
			helper_8cd371d7(2070180)
		end
		if at <= 44 then
			helper_8cd371d7(2070190)
		end
		if at <= 45 then
			helper_8cd371d7(2070200)
		end
		if at <= 46 then
			helper_8cd371d7(2070210)
		end
		if at <= 47 then
			helper_8cd371d7(2070220)
		end
		if at <= 48 then
			helper_8cd371d7(2070230)
		end
		if at <= 49 then
			helper_8cd371d7(2070240)
		end
		if at <= 50 then
			helper_8cd371d7(2070250)
		end
		if at <= 51 then
			helper_8cd371d7(2070260)
		end
		if at <= 52 then
			helper_8cd371d7(2070270)
		end
		if at <= 53 then
			wait_frames_skipping(45)
		end
		if at <= 54 then
			wait_frames_skipping(37)
		end
		if at <= 55 then
			helper_8cd371d7(2070280)
		end
		if at <= 56 then
			helper_8cd371d7(2070290)
		end
		if at <= 57 then
			helper_238b5abc(1)
		end
		if at <= 58 then
			wait_frames_skipping(30)
		end
		if at <= 59 then
			wait_frames_skipping(30)
		end
		if at <= 60 then
			helper_344d6cd8()
		end
		if at <= 61 then
			local _ = global0 == 0
			wait_frames_skipping(75)
		end
		if at <= 62 then
			wait_frames_skipping(30)
		end
		if at <= 63 then
			wait_frames_skipping(30)
		end
		if at <= 64 then
			helper_52aadc70(2070300, 330)
		end
		if at <= 65 then
			wait_frames_skipping(15)
		end
		return true
	end)
	vm.section(function()
		at = 67
		vm.entry(67)
		event.cancel_drama_scene_skip()
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_object_handle_shadow_enabled(2, 1)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_draw_pass(3, 0)
		event.set_event_sprite_draw_pass(4, 0)
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_position(4, 256, 208)
		event.set_event_sprite_size(4, 512, 416)
		event.set_event_sprite_color(4, 0, 0, 0, 128)
		event.set_event_sprite_draw_pass(4, 0)
		event.attach_object_handle_to_sprite(14, 4)
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.clear_camera_sequence()
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(0, 34)
		event.set_character_active(0, 36)
		event.set_character_active(0, 35)
		event.set_character_active(0, 39)
		event.set_character_active(0, 40)
		event.set_character_active(0, 41)
		event.set_character_active(0, 42)
		event.set_object_sequence_position(0, -162.09, 0.0, 562.18)
		event.set_object_sequence_position(1, -158.87, 0.0, 543.98)
		event.set_object_sequence_position(5, 1.3, 8.0, 700.0)
		event.stop_all_sounds()
		event.stop_music(0)
		event.show_chapter_title(2)
		at = 68
		vm.wait(68)
		at = 69
		wait_frames(4)
		event.set_camera_sequence_position(-189.24, 15.33, 545.99)
		event.set_camera_sequence_look_at(-167.18, -44.79, 516.47)
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(14, 0, 0, 0, 128, 0)
		event.fade_in_screen(0)
		at = 70
		vm.wait(70)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(
			0,
			"[(!)]Monica si [UNI00e8] unita al gruppo. Seleziona\n   Personaggio dal Menu principale per\n   cambiare personaggio o tieni premuto il (L3)."
		)
		at = 71
		show_message(0, -1, 8, 0, 0)
		at = 72
		helper_f38eabca(352, 5)
		event.set_message_window_mode(0, 7)
		event.set_camera_sequence_position(-114.91, 26.7, 585.59)
		event.set_camera_sequence_look_at(-547.13, 5.01, 284.33)
		event.set_object_sequence_position(0, -154.04, 0.0, 565.84)
		event.set_object_sequence_rotation(0, 0.0, -2.44, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.48, 0.0)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "指差し立ち", 4, -1.0, 1)
		event.stop_music(0)
		at = 73
		wait_frames(4)
		event.load_music(1)
		event.play_music(0)
		event.enable_drama_skip()
		event.set_object_sequence_color(14, 0, 0, 0, 0, 30)
		at = 74
		wait_frames(30)
		event.set_event_sprite_draw_pass(4, 0)
		event.set_object_sequence_motion(1, "指差し会話", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 75
		helper_1584c528(2070320, 75)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(-201.47, 17.91, 568.45)
		event.set_camera_sequence_look_at(-154.0, 21.06, 552.83)
		event.set_object_sequence_position(0, -162.09, 0.0, 562.18)
		event.set_object_sequence_rotation(0, 0.0, -1.96, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -1.68, 0.0)
		event.set_object_sequence_position(2, -72.39, 9.71, 707.79)
		event.set_object_sequence_rotation(2, 0.0, -2.64, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 76
		helper_4116e6bb(2070330)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "振り返る2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "振り返る2L", 0)
		event.set_object_sequence_motion(1, "振り返る3", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "振り返る3L", 0)
		event.set_object_sequence_motion(2, "立ち", 0)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.move_camera_sequence(-217.49, 21.55, 521.2, -180.22, 20.7, 546.04, 33)
		at = 77
		wait_frames(33)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 78
		helper_4116e6bb(2070340)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 79
		helper_4116e6bb(2070345)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(-171.0, 27.48, 601.08)
		event.set_camera_sequence_look_at(-147.93, 29.07, 706.46)
		event.set_object_sequence_position(3, -154.92, 0.0, 741.22)
		event.set_object_sequence_rotation(3, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(4, -183.74, 0.0, 742.29)
		event.set_object_sequence_rotation(4, 0.0, 2.92, 0.0)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目パチ")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		event.set_object_sequence_motion(3, "会話2", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 0)
		event.set_object_sequence_motion(4, "立ち", 0)
		event.set_mouth_texture_animations(3, "口パク")
		at = 80
		helper_4116e6bb(2070350)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		at = 81
		helper_4116e6bb(2070360)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		at = 82
		helper_4116e6bb(2070370)
		event.reset_mouth_texture_animations()
		at = 83
		wait_objects(3)
		event.set_object_sequence_motion(4, "スコップ会話2", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		event.set_mouth_texture_animations(4, "口パク")
		at = 84
		helper_4116e6bb(2070380)
		event.reset_mouth_texture_animations()
		at = 85
		wait_objects(4)
		event.set_object_handle_footstep_sound(3, 1)
		event.set_object_handle_footstep_sound(4, 1)
		event.set_object_sequence_motion(3, "歩き", 0)
		event.rotate_object_sequence(3, 0.0, 0.16, 0.0, 20)
		at = 86
		wait_frames(10)
		event.set_object_sequence_motion(4, "スコップ歩き", 0)
		event.rotate_object_sequence(4, 0.0, 0.04, 0.0, 20)
		event.delay_object_sequence_position_track(3, 10)
		event.set_object_sequence_motion(3, "走り", 0)
		event.move_object_sequence(3, -107.08, 0.0, 959.69, 45, 1)
		event.delay_object_sequence_position_track(4, 10)
		event.set_object_sequence_motion(4, "スコップ走り", 0)
		event.move_object_sequence(4, -137.0, 0.0, 955.7, 60, 1)
		at = 87
		wait_frames(60)
		event.set_camera_sequence_position(-182.22, 15.16, 581.8)
		event.set_camera_sequence_look_at(-151.21, 22.1, 543.01)
		event.set_object_sequence_position(0, -141.55, 0.0, 545.23)
		event.set_object_sequence_rotation(0, 0.0, -0.4, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.12, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "手をふる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_motion(4, "スコップ立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 88
		helper_4116e6bb(2070390)
		event.reset_mouth_texture_animations()
		at = 89
		wait_objects(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 90
		helper_4116e6bb(2070400)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "うなづく（モニカ見）", 6, -1.0, 1)
		at = 91
		wait_frames(38)
		event.set_camera_sequence_position(-105.67, 24.06, 557.69)
		event.set_camera_sequence_look_at(-158.84, 23.49, 525.23)
		event.set_object_sequence_position(0, -173.5, 0.0, 515.39)
		event.set_object_sequence_rotation(0, 0.0, -2.0, 0.0)
		event.set_object_sequence_position(1, -158.87, 0.0, 543.98)
		event.set_object_sequence_rotation(1, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.move_object_sequence(1, -170.41, 0.0, 526.61, 45)
		at = 92
		wait_frames(15)
	end)
	at = 93
	vm.entry(93)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.clear_effect_manager()
	event.fade_out_screen(30)
	at = 94
	wait_frames(30)
	event.set_character_position(0, -245.13, 0.0, -21.46)
	event.set_character_rotation(0, 0.0, -1.52, 0.0)
	helper_26e74()
	event.reset_follow_camera(1, 0.0, 20.0)
	event.set_camera_position(-300.47, 19.23, -22.1)
	event.set_camera_look_at(-236.15, 23.49, -21.6)
	event.fade_in_screen(30)
	at = 95
	wait_frames(30)
	var2 = event.get_message_window_frame() or var2
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]Ora puoi usare il treno per spostarti.\n   Seleziona Parti dal Menu Porta Treno\n   per tornare a Vallecatini a fare spese."
	)
	at = 96
	show_message(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Fai salire sul treno i tuoi\n   compagni d'avventura.\n   Puoi condurli nelle aree Diorama<page>o portarli con te nei\nlabirinti, come\npersonaggi di supporto."
	)
	at = 97
	show_message(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, var2)
end

--- Helper function.
local function helper_31ae0()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 33)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 33)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 33)
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 33)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e209/e209_conda.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e209/wine.gltf", "info", 37)
	event.attach_object_handle_to_character(5, 37)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 37)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
	for var1 = 0, 4 do
		event.load_character(5, "event/e200/e209/e209_magic1.gltf", "info", 41 + var1)
		event.attach_object_handle_to_character(10 + var1, 41 + var1)
		event.clear_object_sequence(10 + var1)
		event.set_object_sequence_object(10 + var1, 10 + var1)
		event.set_character_active(0, 41 + var1)
	end
	event.load_character(5, "event/e200/e209/e209_magic2.gltf", "info", 42)
	event.attach_object_handle_to_character(8, 42)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.set_character_active(0, 42)
	event.load_character(5, "event/e200/e209/e209_flower.gltf", "info", 40)
	event.set_character_active(1, 40)
	event.attach_object_handle_to_character(9, 40)
	event.clear_object_sequence(9, 9)
	event.set_object_sequence_object(9, 9)
	event.set_object_sequence_position(9, -885.352, 134.434, -841.894)
	event.set_object_sequence_rotation(9, 2.340434, -0.9010716, 1.0717125)
	print("sync obj------------------------------------------\n")
	event.attach_object_handle_to_map_part_2(11, "p09_s0201")
	event.set_object_handle_visible(11, 0)
	event.initialize_effect_manager(5)
	event.load_effect_base("e209魔法")
	event.create_effect_work_buffer(5)
	event.load_message_file(0, 5, "event/e200/e209/e209_1.txt")
end

--- Helper function.
local function helper_3164c()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(33)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(33)
	end
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_character(40)
	for var1 = 0, 4 do
		event.delete_character(41 + var1)
	end
	event.delete_character(42)
end

--- Helper function.
local function helper_3302c()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(209, 1)
		event.initialize_event()
		var0 = event.load_sound_effect_file_2(2223) or var0
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var1
		helper_31ae0()
		event.stop_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_scene_status_flags(1, global0, 256, 1)
		event.set_scene_status_flags(1, global1, 256, 1)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(50)
		event.play_music(0)
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 36)
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(-511.68, 40.04, -655.39)
		event.set_camera_sequence_look_at(-435.03, 32.29, -719.93)
		event.set_object_sequence_position(0, -633.03, 0.0, -833.81)
		event.set_object_sequence_rotation(0, 0.0, -1.44, 0.0)
		event.set_object_sequence_position(1, -635.79, 0.0, -814.6)
		event.set_object_sequence_rotation(1, 0.0, -1.92, 0.0)
		event.set_object_sequence_position(4, -661.7, 0.0, -828.21)
		event.set_object_sequence_rotation(4, 0.0, 1.48, 0.0)
		event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "小人見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(-531.23, 25.72, -753.68)
		event.set_camera_sequence_look_at(-442.13, 24.48, -788.67)
		event.move_camera_sequence_eased(-531.23, 25.72, -753.68, -619.77, 24.48, -800.56, 120, 2, 0.4)
		at = 2
		wait_camera()
		event.set_camera_sequence_position(-587.85, 29.47, -818.63)
		event.set_camera_sequence_look_at(-648.63, 21.46, -826.79)
		event.set_camera_sequence_position(-587.85, 29.47, -818.63)
		event.set_camera_sequence_look_at(-648.63, 21.46, -826.79)
		at = 3
		helper_4116e6bb(2090620)
		event.play_sound_effect(var0, 15)
		event.set_object_sequence_motion(4, "振り返る", 6)
		event.queue_object_sequence_next_motion(4, "振り返るL", 0)
		at = 4
		wait_frames(45)
		if global0 ~= 0 then
			event.set_character_active(0, 33)
		end
		event.set_character_active(0, global0)
		event.set_camera_sequence_position(-695.85, 6.37, -803.15)
		event.set_camera_sequence_look_at(-677.57, 12.04, -825.79)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_motion(4, "杖を振る", 6)
		event.set_object_sequence_motion(4, "杖を振るL", 0)
		do
			local out1, out2, out3 = event.get_character_position(40)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		var9 = 0
		while var9 < 10 do
			var11 = 0.0
			var10 = 0.0
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(4, "tue_saki")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			pos_x = vm.f32(-694.77)
			pos_z = vm.f32(-857.66)
			var11 = event.get_random_number(1.5707964) or var11
			var10 = event.get_random_number(20.0) or var10
			var10 = vm.f32(var10 + 15.0)
			pos_x = vm.f32(pos_x + vm.f32(vm.sin(var11) * var10))
			pos_z = vm.f32(pos_z + vm.f32(vm.cos(var11) * var10))
			event.create_effect("e209魔法")
			event.set_effect_first_vector(pos_x, pos_y, pos_z)
			event.set_effect_second_vector(var6, var7, var8)
			at = 5
			vm.wait(5)
			var9 = var9 + 1
		end
		at = 6
		helper_4116e6bb(2090630)
		event.set_character_active(0, 41)
		event.set_character_active(1, 42)
		event.set_camera_sequence_position(-620.39, 17.91, -830.69)
		event.set_camera_sequence_look_at(-657.47, 26.12, -833.22)
		event.set_object_sequence_position(8, -763.76, -38.88, -840.29)
		event.set_object_sequence_rotation(8, 0.0, 1.68, 0.0)
		event.play_sound_effect(var0, 17)
		event.set_object_sequence_motion(8, "キラキラ", 4)
		at = 7
		wait_frames(30)
		event.set_object_sequence_motion(8, "消える", 6)
		event.wait_object_sequence_motion_end(8)
		event.set_character_model_lighting(40, 0)
		event.set_motion_blur(1)
		var13 = 128.0
		var12 = 1.0
		while var9 < 82 do
			if var13 < vm.f32(2.1333334) then
				var13 = 0.0
			else
				var13 = vm.f32(var13 - vm.f32(2.1333334))
			end
			event.set_character_model_color(40, 128.0, 128.0, 128.0, var13)
			event.set_character_scale(40, var12, var12, var12)
			var12 = vm.f32(var12 - vm.f32(0.01))
			at = 8
			vm.wait(8)
			var9 = var9 + 1
		end
		at = 9
		wait_objects(8)
		if global0 ~= 0 then
			event.set_character_active(1, 33)
		end
		event.set_character_active(1, global0)
		event.set_character_active(0, 36)
		event.set_camera_sequence_position(-671.41, 16.73, -811.28)
		event.set_camera_sequence_look_at(-644.75, 19.15, -824.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_motion(0, "驚く", 6, -1.0, 1)
		at = 10
		wait_frames(23)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(-607.66, 36.8, -768.32)
		event.set_camera_sequence_look_at(-624.43, 27.66, -792.8)
		event.set_camera_sequence_position(-620.75, 27.66, -778.33)
		event.set_camera_sequence_look_at(-631.0, 24.74, -796.76)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
		event.play_sound_effect(var0, 18)
		event.set_object_sequence_motion(4, "振り返る2", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		at = 11
		wait_frames(36)
		event.set_object_sequence_motion(4, "会話", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		at = 12
		helper_4116e6bb(2090640)
		at = 13
		helper_4116e6bb(2090650)
		at = 14
		helper_4116e6bb(2090660)
		event.set_object_sequence_motion(4, "会話", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		at = 15
		helper_4116e6bb(2090670)
		event.set_camera_sequence_position(-686.13, 14.37, -802.47)
		event.set_camera_sequence_look_at(-665.83, 15.3, -815.79)
		event.set_camera_sequence_position(-683.22, 14.18, -807.51)
		event.set_camera_sequence_look_at(-662.33, 17.31, -817.61)
		event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "小人見会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
		event.set_object_sequence_motion(0, "もっともだ", 6)
		event.queue_object_sequence_next_motion(0, "小人見立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 16
		helper_4116e6bb(2090680)
		event.reset_mouth_texture_animations()
		at = 17
		wait_objects(1)
		at = 18
		helper_4116e6bb(2090690)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 19
		helper_4116e6bb(2090700)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-618.98, 20.59, -766.84)
		event.set_camera_sequence_look_at(-645.79, 21.42, -821.23)
		event.set_camera_sequence_position(-620.75, 27.66, -778.33)
		event.set_camera_sequence_look_at(-631.0, 24.74, -796.76)
		event.reset_object_sequence_dynamic_animation(0)
		at = 20
		helper_4116e6bb(2090710)
		event.set_object_sequence_texture_animation(1, 1, "目あき～目あきれ")
		event.play_sound_effect(var0, 19)
		event.set_object_sequence_motion(1, "はぁ？", 6)
		event.queue_object_sequence_next_motion(1, "はぁ？L", 4)
		at = 21
		helper_4116e6bb(2090720)
		event.set_object_sequence_motion(1, "う・・・", 2)
		event.queue_object_sequence_next_motion(1, "う・・・L", 0)
		at = 22
		helper_4116e6bb(2090730)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(4, "会話", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		at = 23
		helper_4116e6bb(2090740)
		event.set_character_active(1, 37)
		event.attach_character_to_frame(36, "wine", 37)
		event.set_object_sequence_motion(4, "ぶどう酒を渡す", 6)
		event.queue_object_sequence_next_motion(4, "ぶどう酒を渡すL", 0)
		at = 24
		wait_frames(27)
		event.set_object_sequence_motion(0, "小人見会話", 6)
		event.queue_object_sequence_next_motion(0, "小人見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 25
		helper_4116e6bb(2090750)
		event.reset_mouth_texture_animations()
		at = 26
		wait_objects(0)
		at = 27
		helper_4116e6bb(2090760)
		at = 28
		helper_4116e6bb(2090765)
		event.set_character_active(1, 38)
		event.detach_character_from_frame(37)
		event.attach_character_to_frame(global0, "item", 37)
		event.set_camera_sequence_position(-665.1, 35.16, -841.27)
		event.set_camera_sequence_look_at(-637.33, 29.85, -838.63)
		event.set_object_sequence_position(6, -644.57, 33.56, -840.23)
		event.set_object_sequence_rotation(6, 0.0, -1.08, 0.0)
		event.stop_music(0)
		event.play_sound_effect(var0, 20)
		event.play_sound_effect(var1, 0)
		event.set_object_sequence_motion(6, "発動", 6)
		event.set_object_sequence_motion(0, "ぶどう酒ゲット", 4, -1.0, 1)
		at = 29
		helper_f38eabca(370, 1)
		event.set_character_active(0, 37)
		event.set_character_active(0, 38)
		event.play_music(0)
		event.set_object_sequence_motion(1, "小人見立ち", 4, -1.0, 1)
		event.set_camera_sequence_position(-609.41, 36.37, -779.33)
		event.set_camera_sequence_look_at(-630.67, 25.71, -807.05)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(0, "小人見会話", 6)
		event.queue_object_sequence_next_motion(0, "小人見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 30
		helper_4116e6bb(2090770)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "会話", 6)
		event.queue_object_sequence_next_motion(4, "立ち")
		at = 31
		helper_4116e6bb(2090780)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 32
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			helper_8cd371d7(2090620)
		end
		if at <= 3 then
			wait_frames_skipping(45)
		end
		if at <= 4 then
			var9 = 0
			var11 = 0.0
			var10 = 0.0
			pos_x = vm.f32(-694.77)
			pos_z = vm.f32(-857.66)
			var10 = vm.f32(var10 + 15.0)
			pos_x = vm.f32(pos_x + vm.f32(vm.sin(var11) * var10))
			pos_z = vm.f32(pos_z + vm.f32(vm.cos(var11) * var10))
		end
		if at <= 5 then
			local _ = var9 < 10
			var9 = var9 + 1
			helper_8cd371d7(2090630)
		end
		if at <= 6 then
			local _ = global0 ~= 0
			wait_frames_skipping(30)
		end
		if at <= 7 then
			var13 = 128.0
			var12 = 1.0
			local _ = var13 < vm.f32(2.1333334)
			var13 = 0.0
			var13 = vm.f32(var13 - vm.f32(2.1333334))
			var12 = vm.f32(var12 - vm.f32(0.01))
		end
		if at <= 8 then
			local _ = var9 < 82
			var9 = var9 + 1
			helper_238b5abc(8)
		end
		if at <= 9 then
			wait_frames_skipping(23)
		end
		if at <= 10 then
			local _ = global0 ~= 0
			wait_frames_skipping(36)
		end
		if at <= 11 then
			helper_8cd371d7(2090640)
		end
		if at <= 12 then
			helper_8cd371d7(2090650)
		end
		if at <= 13 then
			helper_8cd371d7(2090660)
		end
		if at <= 14 then
			helper_8cd371d7(2090670)
		end
		if at <= 15 then
			helper_8cd371d7(2090680)
		end
		if at <= 16 then
			helper_238b5abc(1)
		end
		if at <= 17 then
			helper_8cd371d7(2090690)
		end
		if at <= 18 then
			helper_8cd371d7(2090700)
		end
		if at <= 19 then
			helper_8cd371d7(2090710)
		end
		if at <= 20 then
			helper_8cd371d7(2090720)
		end
		if at <= 21 then
			helper_8cd371d7(2090730)
		end
		if at <= 22 then
			helper_8cd371d7(2090740)
		end
		if at <= 23 then
			wait_frames_skipping(27)
		end
		if at <= 24 then
			helper_8cd371d7(2090750)
		end
		if at <= 25 then
			helper_238b5abc(0)
		end
		if at <= 26 then
			helper_8cd371d7(2090760)
		end
		if at <= 27 then
			helper_8cd371d7(2090765)
		end
		if at <= 28 then
			helper_7d730ff7(370, 1)
		end
		if at <= 29 then
			helper_8cd371d7(2090770)
		end
		if at <= 30 then
			helper_8cd371d7(2090780)
		end
		if at <= 31 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	helper_3164c()
	event.stop_music(0)
	at = 33
	wait_frames(4)
	event.load_music(1)
	event.play_music(0)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
		helper_b76e3b36()
		helper_f72a4299()
		at = 2
		helper_28e0c()
		event.set_npc_party_status(1, 128)
		event.set_npc_party_status(2, 128)
		event.set_npc_party_status(13, 128)
		event.set_save_data_value(0, 4)
		event.set_party_member(1, 1)
		event.set_character_change_enabled(1, 1)
		event.set_character_change_unmasked(1, 1)
		event.add_inventory_item(352, 5)
		at = 3
		helper_d529ed92()
		event.fade_in_screen(30)
		event.initialize_event()
		helper_d552d8eb()
		helper_0226fccb()
		at = 4
		vm.wait(4)
		event.load_event_script("s02/s02_1.stb", -1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				helper_28e0c()
				return vm.continue_with(function()
					event.set_npc_party_status(1, 128)
					event.set_npc_party_status(2, 128)
					event.set_npc_party_status(13, 128)
					event.set_save_data_value(0, 4)
					event.set_party_member(1, 1)
					event.set_character_change_enabled(1, 1)
					event.set_character_change_unmasked(1, 1)
					event.add_inventory_item(352, 5)
					at = 3
					helper_d529ed92()
					event.fade_in_screen(30)
					event.initialize_event()
					helper_d552d8eb()
					helper_0226fccb()
					at = 4
					vm.wait(4)
					event.load_event_script("s02/s02_1.stb", -1)
					return
				end)
			end
			if at <= 2 then
				helper_e52544df()
			end
			if at <= 3 then
				helper_042a5b29()
				helper_1ef0d4b2()
			end
			return 0
		end
		return nil
	end)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_3302c()
	event.initialize_event()
	event.add_inventory_item(370, 1)
	helper_d529ed92()
	event.fade_in_screen(30)
	event.attach_object_handle_to_map_part_2(0, "p09_s0201")
	event.set_object_handle_visible(0, 0)
	helper_d4172c24()
	helper_d552d8eb()
	vm.wait(3)
	event.load_event_script("s02/s02_1.stb", -1)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
		helper_b76e3b36()
		helper_f72a4299()
		at = 2
		helper_2000ac46()
		event.initialize_event()
		helper_d552d8eb()
		helper_0226fccb()
		at = 3
		vm.wait(3)
		event.load_event_script("s02/s02_1.stb", 504)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				helper_2000ac46()
				return vm.continue_with(function()
					event.initialize_event()
					helper_d552d8eb()
					helper_0226fccb()
					at = 3
					vm.wait(3)
					event.load_event_script("s02/s02_1.stb", 504)
					return
				end)
			end
			if at <= 2 then
				helper_042a5b29()
				helper_1ef0d4b2()
			end
			return 0
		end
		return nil
	end)
end

return script
