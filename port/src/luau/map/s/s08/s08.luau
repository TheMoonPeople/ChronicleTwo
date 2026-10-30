--!strict
-- map/s/s08/s08.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19b130fb = require("@lib/event/helper_19b130fb")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_38bce8cf = require("@lib/event/helper_38bce8cf")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_5be5f988 = require("@lib/event/helper_5be5f988")
local helper_669c752b = require("@lib/event/helper_669c752b")
local helper_66d374a5 = require("@lib/event/helper_66d374a5")
local helper_7f754b8f = require("@lib/event/helper_7f754b8f")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8b00b423 = require("@lib/event/helper_8b00b423")
local helper_8e5b8087 = require("@lib/event/helper_8e5b8087")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_df4094fb = require("@lib/event/helper_df4094fb")
local helper_ee4287cb = require("@lib/event/helper_ee4287cb")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")

local global0: s32 = 0

--- Helper function.
local function helper_2349c()
	event.play_sound_effect(global0, 2)
	event.play_sound_effect(global0, 8)
end

--- Helper function.
local function helper_23558()
	event.initialize_event()
	global0 = 0
	event.load_map_sounds(2200)
	global0 = event.load_sound_effect_file_2(2200) or global0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "event/e200/e203/e203_starbre.gltf", "info", 9)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(1, 9)
	event.set_character_position(9, 5.62, 36.1, 39.9)
	event.set_character_rotation(9, 0.0, 3.04, 0.0)
	event.set_character_motion(9, "立ち", 4)
	event.load_character(4, "event/e200/e203/e203_vorneo.gltf", "info", 10)
	event.attach_object_handle_to_character(2, 10)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(1, 10)
	event.set_character_position(10, -38.37, 36.08, 32.88)
	event.set_character_rotation(10, 0.0, 1.48, 0.0)
	event.set_character_motion(10, "立ち", 4)
	event.load_character(4, "event/e200/e203/e203_tom.gltf", "info", 11)
	event.attach_object_handle_to_character(3, 11)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(1, 11)
	event.set_character_position(11, -1.81, 36.1, 72.51)
	event.set_character_rotation(11, 0.0, -0.48, 0.0)
	event.set_character_motion(11, "立ち", 4)
	event.set_object_handle_sound_bank(3, global0)
	event.register_villager(9, 1)
	event.register_villager(10, 2)
	event.register_villager(11, 13, 65)
	event.set_scene_character_number(9, 1)
	event.set_scene_character_number(10, 2)
	event.set_scene_character_number(11, 13)
	helper_2349c()
end

--- Helper function.
local function helper_1fed8()
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.clear_camera_sequence()
	event.load_character_motion_pack(5, "event/e200/e203/e203_mints.gltf", "info", 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.load_character(5, "event/e200/e203/e203_starbre.gltf", "info", 33)
	event.attach_object_handle_to_character(1, 33)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 33)
	event.load_character(5, "event/e200/e203/e203_vorneo.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e203/e203_tom.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e200/e203/e203_sekitan.gltf", "info", 37)
	event.attach_object_handle_to_character(5, 37)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 37)
	event.attach_object_handle_to_map_part_3(4, "p06_kikan", "kikan_06-m")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 3.1415927, 0.0)
	block = event.load_event_image_4(5, "textures/event/e200/e203/e203.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e20301", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 51.2, 41.6)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e20302", block)
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
	event.set_event_sprite_texture(2, "e20303", block)
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
	event.set_event_sprite_texture(3, "e20304", block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(3, 51.2, 41.6)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(13, 3)
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.load_message_file(0, 5, "event/e200/e203/e203.txt")
	event.set_scene_status_flags(1, 0, 256, 1)
end

--- Helper function.
local function helper_1da38(arg0: any)
	event.fade_in_screen(30)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_motion(1, "腰に手", 4)
	event.set_object_sequence_motion(2, "斜め向き立ち", 4)
	event.set_object_sequence_motion(3, "石炭", 4)
	event.move_camera_sequence_eased(41.03, 65.52, -72.49, 1.22, 60.93, 25.12, 60, 0, 1.0)
	wait_camera()
	helper_888ab2a3(20)
end

--- Helper function.
local function helper_1dcec(arg0: any)
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_motion(2, "スコップ立ち", 4)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(2030010)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(2030020)
	event.reset_mouth_texture_animations()
end

--- Helper function.
local function helper_1e36c(arg0: any)
	event.set_character_active(0, 11)
	event.set_character_active(1, 33)
	event.set_event_sprite_size(1, 512.0, 416.0)
	event.set_event_sprite_draw_pass(1, 1)
	event.set_object_sequence_position(11, 256.0, 208.0, 10.0)
	event.set_object_sequence_color(11, 128.0, 128.0, 128.0, 128.0, 15)
	helper_888ab2a3(15)
	event.set_event_sprite_draw_pass(0, 0)
	helper_4116e6bb(2030060)
end

--- Helper function.
local function helper_1e5e4(arg0: any)
	event.set_event_sprite_size(2, 512.0, 416.0)
	event.set_event_sprite_draw_pass(2, 1)
	event.set_object_sequence_position(12, 256.0, 208.0, 10.0)
	event.set_object_sequence_color(12, 128.0, 128.0, 128.0, 128.0, 15)
	helper_888ab2a3(15)
	event.set_event_sprite_draw_pass(1, 0)
	helper_4116e6bb(2030070)
	helper_4116e6bb(2030073)
end

--- Helper function.
local function helper_1e820(arg0: any)
	event.set_event_sprite_size(3, 512.0, 416.0)
	event.set_event_sprite_draw_pass(3, 1)
	event.set_object_sequence_position(13, 256.0, 208.0, 0.0)
	event.set_object_sequence_color(13, 128.0, 128.0, 128.0, 128.0, 15)
	helper_888ab2a3(15)
	event.set_event_sprite_draw_pass(2, 0)
	helper_4116e6bb(2030080)
	helper_4116e6bb(2030083)
end

--- Helper function.
local function helper_1ec34(se_id: s32)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "無表情")
	event.set_object_sequence_texture_animation(0, 1, "目パチ")
	event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
	event.set_object_sequence_color(13, 0.0, 0.0, 0.0, 15)
	helper_888ab2a3(15)
	event.set_event_sprite_draw_pass(3, 0)
	event.move_camera_sequence_eased(10.91, 58.61, 33.87, 1.64, 58.99, 18.19, 300, 2, 0.4)
	helper_4116e6bb(2030090)
	event.set_object_sequence_texture_animation(0, 1, "眉真剣")
	helper_4116e6bb(2030100)
	event.stop_music(0)
	event.play_sound_effect(se_id, 5)
	event.shake_camera_sequence(0.0, 0.8, 0.0, 45)
	helper_888ab2a3(45)
end

--- Helper function.
local function helper_1f028(se_id: s32)
	event.set_character_active(0, 11)
	event.set_character_active(1, 35)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
	event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
	event.play_sound_effect(se_id, 6)
	event.set_object_sequence_motion(0, "振り返る", 6)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "振り返るL", 0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_motion(3, "立ち", 4)
	helper_888ab2a3(23)
end

--- Helper function.
local function helper_1f34c(se_id: s32)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "おこり顔")
	event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.play_sound_effect(se_id, 7)
	event.set_object_sequence_motion(1, "驚く", 6)
	event.queue_object_sequence_next_motion(1, "驚くL", 0)
	event.set_object_sequence_motion(2, "驚く", 6)
	event.queue_object_sequence_next_motion(2, "驚くL", 0)
	event.set_object_sequence_motion(3, "驚く", 6)
	event.queue_object_sequence_next_motion(3, "驚くL", 0)
	helper_888ab2a3(20)
	event.play_sound_effect(se_id, 8)
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(2030110)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(2, "口パク")
	helper_4116e6bb(2030120)
	event.reset_mouth_texture_animations()
	event.set_camera_sequence_position(23.44, 65.11, 70.77)
	event.set_camera_sequence_look_at(-17.65, 56.75, -37.19)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.set_object_sequence_motion(1, "会話2", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(2030130)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "大口パク")
	helper_4116e6bb(2030135)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "うなづく", 2)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	helper_8e5b8087(0, vm.f32(0.267), -1.0, 30)
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(2030140)
	event.reset_mouth_texture_animations()
end

--- Helper function.
local function helper_211d4()
	local var0: s32 = 0
	vm.section(function()
		event.set_save_flag(203, 1)
		event.initialize_event()
		var0 = event.load_sound_effect_file_2(2200) or var0
		helper_1fed8()
		event.set_object_handle_sound_bank(3, var0)
		event.stop_music(0)
		helper_888ab2a3(6)
		event.load_music(105)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目パチ")
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.enable_drama_skip()
		event.set_character_active(1, 0)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(41.03, 65.52, -72.49)
		event.set_camera_sequence_look_at(1.22, 121.98, 25.12)
		event.set_object_sequence_position(0, 2.3, 36.08, 14.12)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 5.62, 36.1, 39.9)
		event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(2, -38.37, 36.08, 32.88)
		event.set_object_sequence_rotation(2, 0.0, 1.48, 0.0)
		event.set_object_sequence_position(3, -1.81, 36.1, 72.51)
		event.set_object_sequence_rotation(3, 0.0, -0.48, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.play_sound_effect(var0, 2)
		helper_1da38(var0)
		event.set_camera_sequence_position(54.99, 53.17, 1.95)
		event.set_camera_sequence_look_at(-1.12, 50.66, 35.36)
		event.move_camera_sequence_angle_height_distance_eased(2.64, 2.9, 55.5, 140, 0, 1.0)
		event.set_object_sequence_position(0, 2.3, 36.08, 14.12)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		helper_1dcec(var0)
		wait_camera()
		event.set_camera_sequence_position(11.36, 60.35, 36.83)
		event.set_camera_sequence_look_at(-1.48, 59.0, 7.39)
		helper_66d374a5(var0)
		helper_38bce8cf(var0)
		helper_1e36c(var0)
		helper_1e5e4(var0)
		helper_1e820(var0)
		event.set_character_active(1, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(12.55, 58.61, 36.64)
		event.set_camera_sequence_look_at(3.28, 58.99, 20.96)
		helper_1ec34(var0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(3.0, 69.45, -14.12)
		event.set_camera_sequence_look_at(-5.47, 39.58, 58.5)
		helper_1f028(var0)
		event.set_camera_sequence_position(29.29, 88.68, -13.52)
		event.set_camera_sequence_look_at(-6.48, 65.74, 32.61)
		event.set_object_sequence_position(0, 6.15, 36.08, -1.68)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(2, -18.35, 36.08, 35.6)
		event.set_object_sequence_rotation(2, 0.0, 1.48, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		helper_1f34c(var0)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	helper_ee4287cb()
	event.set_character_active(1, 9)
	event.set_character_active(1, 10)
	event.set_character_active(1, 11)
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 8)
	event.set_camera_sequence_position(29.29, 88.68, -13.52)
	event.set_camera_sequence_look_at(-6.48, 65.74, 32.61)
	event.reset_follow_camera(0)
end

--- Helper function.
local function helper_224a8()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e200/e205/e205_starbre.gltf", "info", 32)
	event.attach_object_handle_to_character(0, 32)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 32)
	event.load_character(5, "event/e200/e205/e205_vorneo.gltf", "info", 33)
	event.attach_object_handle_to_character(1, 33)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 33)
	event.load_character(5, "event/e200/e205/e205_tom.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_message_file(0, 5, "event/e200/e205/e205.txt")
	event.set_character_active(0, 0)
end

--- Helper function.
local function helper_2297c()
	local var0: s32 = 0
	vm.section(function()
		event.set_save_flag(205, 1)
		event.initialize_event()
		event.load_map_sounds(2206)
		var0 = event.load_sound_effect_file_2(2206) or var0
		helper_224a8()
		event.stop_music(0)
		event.fade_in_screen(30)
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(26.2, 66.14, -50.83)
		event.set_camera_sequence_look_at(13.28, 59.7, -9.45)
		event.set_object_sequence_position(0, 24.27, 36.08, -15.66)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(1, -25.76, 36.08, 14.84)
		event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(2, -5.4, 36.08, 70.48)
		event.set_object_sequence_rotation(2, 0.0, -2.64, 0.0)
		event.set_object_sequence_motion(0, "だめじゃ", 4)
		event.set_object_sequence_motion(1, "気絶", 4)
		event.set_object_sequence_motion(2, "錯乱", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.play_sound_effect(var0, 0)
		event.shake_camera_sequence(0.0, 0.5, 0.1, -1)
		event.set_mouth_texture_animations(0, "大口パク")
		helper_4116e6bb(2050010)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "口パク")
		helper_4116e6bb(2050020)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.clear_camera_sequence()
	helper_669c752b()
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local mc_load: s32 = 0
	helper_19b130fb()
	helper_8b00b423()
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_7f754b8f(1)
		event.set_save_control_bits(1, 1)
	else
		helper_7f754b8f(0)
	end
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		event.set_character_position(0, 38.0, 36.1, -100.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
	end
	if flag == 1 and flag_2 == 0 then
		helper_23558()
	end
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(32)
	show_message(0, 1002, 8, 450, 100)
	event.do_nothing(0)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	print("-------event_200----------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.set_save_control_bits(1, 0)
		event.set_save_counter(15, 1)
		event.fade_out_screen(0)
		event.stop_music(0)
		helper_5be5f988()
	end
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local var0: s32 = 0
	print("-------event_201----------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.set_save_control_bits(1, 0)
		event.set_save_counter(15, 0)
		event.fade_out_screen(0)
		event.stop_music(0)
		helper_5be5f988()
	end
end

--- Event 203, which map data, a script or the engine runs by number.
function script.event_203()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.set_save_control_bits(1, 0)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_save_counter(0, 1)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_character_position(0, 0.0, 36.0, 235.0)
		event.set_character_rotation(0, 0.0, 3.14, 0.0)
		event.jump_to_map_2(-1, "s07")
	end
end

--- Event 204, which map data, a script or the engine runs by number.
function script.event_204()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.set_save_control_bits(1, 0)
		event.fade_in_screen(30)
		event.stop_sound_effect(global0, 2)
		event.stop_sound_effect(global0, 8)
		event.jump_to_map_3(-1, "s03", 501)
		vm.wait(1)
	end
end

--- Event 205, which map data, a script or the engine runs by number.
function script.event_205()
	local var0: s32 = 0
	print("--------------------------event205-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 206, which map data, a script or the engine runs by number.
function script.event_206()
	local var0: s32 = 0
	print("--------------------------event206-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 208, which map data, a script or the engine runs by number.
function script.event_208()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event208-------------------------\n")
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 209, which map data, a script or the engine runs by number.
function script.event_209()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event209-------------------------\n")
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	event.set_save_data_value(3, 1)
	helper_93cb8168()
	event.set_save_data_value(3, 0)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_8b00b423()
	helper_7f754b8f(1)
	helper_23558()
	helper_211d4()
	event.set_save_control_bits(1, 1)
	helper_2349c()
	event.fade_in_screen(30)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_2297c()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s03", 512)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	set_window_mode(0, 1)
	if var0 == 9 then
		event.open_message_window_2(0, "なにをもたもたしとる！\nはやくはしごをのぼるんじゃ。")
	end
	if var0 == 10 then
		event.open_message_window_2(
			0,
			"今は世界がどうしたとか言ってる場合じゃないな。\nユリス、急いで外の様子を見てきてくれ。"
		)
	end
	if var0 == 11 then
		event.open_message_window_2(
			0,
			"さっきのゆれ方からすると、\nわりと小さい爆弾と思うっす。<page>でも、当たり所が悪いとヤバいっすよ。"
		)
	end
	helper_1c04a0eb(var0, -1, 0, 0)
end

--- Event 12030, which map data, a script or the engine runs by number.
function script.event_12030()
	helper_23558()
	helper_211d4()
	helper_2349c()
	event.fade_in_screen(30)
end

--- Event 12050, which map data, a script or the engine runs by number.
function script.event_12050()
	helper_2297c()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s03", 512)
	vm.wait(2)
end

return script
