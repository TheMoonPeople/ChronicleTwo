--!strict
-- map/d/d05/b01/d05b01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2609f66b = require("@lib/event/helper_2609f66b")
local helper_26c3d54b = require("@lib/event/helper_26c3d54b")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a6838a9a = require("@lib/event/helper_a6838a9a")
local helper_a9eaf20e = require("@lib/event/helper_a9eaf20e")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_f9968159 = require("@lib/event/helper_f9968159")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(5683)
	flag = event.get_save_flag(526) or flag
	if flag == 1 then
		event.set_function_point_enabled("d05", "func", 0)
		event.attach_object_handle_to_map_part_3(0, "d05", "d05ba02-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takil")
		event.set_object_handle_scale(0, 0.43, 1.0, 1.0)
		event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takir")
		event.set_object_handle_scale(0, 0.43, 1.0, 1.0)
		event.set_function_point_enabled("p01", "invent_2023-1", 1)
	end
	flag_2 = event.get_save_flag(528) or flag_2
	if flag_2 == 0 then
		event.attach_object_handle_to_map_part_3(0, "d05", "d05ba03-a")
		event.set_object_handle_visible(0, 1)
	else
		event.set_function_point_enabled("", "e528", 0)
	end
end

--- Helper function.
local function helper_263b8()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	vm.section(function()
		event.set_save_flag(536, 1)
		event.initialize_event()
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
		event.stop_music(0)
		event.load_map_sounds(5825)
		var1 = event.load_sound_effect_file_2(5825) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e536/")
		event.load_message_file(0, 5, "e536.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e536_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e536_monica.gltf", "info", 0)
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
			event.load_character_motion_pack(5, "event/e500/e536/e536_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e536/e536_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -9.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 3.02, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 9.0, 0.0, 100.0)
		event.set_object_handle_rotation(1, 0.0, -3.02, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 18.65, 43.37)
		event.set_camera_sequence_look_at(0.0, 15.13, 108.54)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(1, "許せない", 6)
		event.queue_object_sequence_next_motion(1, "許せないL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5360100)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var1, 10)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(5360110)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var1, 2)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
end

--- Helper function.
local function helper_1197c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	event.set_save_flag(526, 1)
	event.fade_out_screen(15)
	helper_888ab2a3(15)
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no ~= 0 then
		event.switch_dungeon_main_character(0)
		active_chr_no = 0
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	var1 = event.load_sound_effect_file_2(5814) or var1
	event.set_scene_status_flags(1, 0, 256, 1)
	event.change_directory("event/e500/e526/")
	event.load_message_file(0, 5, "e526.txt")
	event.load_character_motion_pack(5, "e526_mints.gltf", "info", 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.load_character(5, "phorn.gltf", "info", 8)
	event.set_character_active(8)
	event.attach_character_to_frame(0, "item", 8)
	event.change_directory("")
	event.attach_object_handle_to_character(1, 1)
	event.attach_object_handle_to_character(2, 2)
	event.set_object_handle_visible(1, 0)
	event.set_object_handle_visible(2, 0)
	event.set_object_handle_position(0, 0.0, -30.0, 1500.0)
	event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
	event.set_object_handle_motion(0, "ホーン吹く", 4)
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, 1, "ふき顔")
	event.set_object_handle_texture_animation(0, 1, "下向き目パチ")
	event.set_function_point_enabled("d05", "takil", 1)
	event.set_function_point_enabled("d05", "takir", 1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(16.1, -10.46, 1474.52)
	event.set_camera_sequence_look_at(0.26, -9.87, 1496.35)
	event.move_camera_sequence_eased(30.06, -19.27, 1455.3, 2.31, -16.91, 1493.52, 60, 0, 1.0)
	event.play_sound_effect(var1, 0)
	event.fade_in_screen(30)
	wait_camera()
	helper_888ab2a3(30)
	event.set_camera_sequence_position(0.0, 30.39, 1561.77)
	event.set_camera_sequence_look_at(0.0, -19.94, 1493.75)
	event.move_camera_sequence_eased(0.0, 30.39, 1561.77, 0.0, 11.85, 1493.75, 80, 0, 1.0)
	event.play_sound_effect(var1, 1)
	event.set_object_sequence_motion(0, "ホーン持ち立ち", 4)
	wait_camera()
	helper_888ab2a3(30)
	event.set_camera_sequence_position(14.64, -10.25, 1472.02)
	event.set_camera_sequence_look_at(0.03, -10.34, 1496.41)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, 1, "おどろき顔")
	event.set_object_handle_texture_animation(0, 1, "おどろき目パチ")
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_0382f327(5260010, 120)
	event.set_camera_sequence_position(0.0, 0.69, 877.16)
	event.set_camera_sequence_look_at(0.0, -9.03, 949.98)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
	event.set_object_handle_texture_animation(0, 1, "通常目パチ")
	helper_888ab2a3(90)
	event.stop_sound_effect(var1, 1)
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(1, 1)
	event.set_object_handle_visible(2, 1)
	helper_9dafbc83(0.0, -30.0, 1500.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 0.0, 1500.0)
	event.set_camera_position(0.0, 10.0, 1600.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Helper function.
local function helper_12c24()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(528, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 then
			event.switch_dungeon_main_character(0)
			active_chr_no = 0
		end
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(190)
		event.load_map_sounds(5817)
		var1 = event.load_sound_effect_file_2(5817) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e528/")
		event.load_message_file(0, 5, "e528.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e528_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e528_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e528_guiltoni.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		block = event.load_event_image_4(5, "e528telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e528telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 347)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(5, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 5)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e528/e528_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e528/e528_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(3, 1)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_position(0, 0.0, 0.0, 500.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -100.0, 0.0, -200.0)
		event.set_object_handle_rotation(1, 0.0, 2.54, 0.0)
		event.set_object_handle_motion(1, "倒れ", 4)
		event.step_object_handle_motion(1)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "死に")
		event.set_object_handle_position(2, -73.0, 0.0, -190.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "しゃがみ", 4)
		event.set_object_handle_sound_bank(2, var1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "左向き目パチ")
		event.enable_drama_skip()
		event.move_object_sequence(0, 0.0, 0.0, 400.0, 120)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 120)
		event.set_object_sequence_motion(0, "立ち")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(224.74, 194.1, 112.15)
		event.set_camera_sequence_look_at(119.89, 90.28, 320.08)
		event.fade_in_screen(30)
		at = 3
		helper_888ab2a3(90)
		event.set_camera_sequence_position(23.71, 15.41, 365.52)
		event.set_camera_sequence_look_at(0.81, 20.88, 397.45)
		at = 4
		wait_objects(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(0, 1, "半口")
		at = 5
		helper_888ab2a3(20)
		event.set_camera_sequence_position(0.0, 27.58, 241.33)
		event.set_camera_sequence_look_at(11.62, 31.84, 143.18)
		event.move_camera_sequence(0.0, 27.58, 241.33, -10.98, 31.84, 142.98, 60)
		at = 6
		wait_camera()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-62.71, 22.94, -127.1)
		event.set_camera_sequence_look_at(-79.95, 18.68, -193.59)
		event.queue_object_sequence_next_motion(2, "気がつき", 6)
		event.queue_object_sequence_next_motion(2, "起きあがり", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		at = 7
		helper_888ab2a3(46)
		event.play_sound_effect(var1, 2)
		at = 8
		helper_888ab2a3(30)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目左向き～前向き")
		at = 9
		wait_objects(2)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-65.53, 36.67, -170.72)
		event.set_camera_sequence_look_at(-72.23, 31.54, -186.28)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 10
		helper_4116e6bb(5280010)
		event.set_camera_sequence_position(17.17, 21.0, 369.81)
		event.set_camera_sequence_look_at(-1.57, 20.75, 398.07)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "左前見る", 6)
		event.queue_object_sequence_next_motion(0, "左前見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 11
		helper_4116e6bb(5280020)
		event.set_camera_sequence_position(-72.45, 23.3, -129.48)
		event.set_camera_sequence_look_at(-72.45, 23.3, -169.9)
		event.play_music(0)
		event.play_sound_effect(var1, 3)
		event.set_object_handle_frame_draw_flag(2, "sword--v0", 1)
		event.set_object_sequence_motion(2, "剣だし", 6)
		event.queue_object_sequence_next_motion(2, "剣だしL", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 12
		helper_4116e6bb(5280030)
		event.set_camera_sequence_position(-51.78, 20.26, -260.52)
		event.set_camera_sequence_look_at(-58.41, 20.26, -190.32)
		event.play_sound_effect(var1, 4)
		event.set_object_sequence_motion(2, "ジャンプ", 6)
		at = 13
		helper_888ab2a3(20)
		event.set_camera_sequence_position(17.17, 21.0, 369.81)
		event.set_camera_sequence_look_at(-1.57, 20.75, 398.07)
		event.set_object_sequence_motion(0, "上見る", 6)
		event.queue_object_sequence_next_motion(0, "上見るL", 4)
		at = 14
		wait_objects(0)
		event.set_camera_sequence_position(6.12, 32.14, 446.85)
		event.set_camera_sequence_look_at(-0.05, 14.21, 365.23)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_sequence_motion(0, "上見る戻り", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.play_sound_effect(var1, 5)
		event.set_object_sequence_position(2, 0.0, 0.0, 260.0)
		event.set_object_sequence_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "着地L", 4)
		at = 15
		wait_objects(2)
		event.set_camera_sequence_position(9.03, 31.27, 338.8)
		event.set_camera_sequence_look_at(5.32, 18.96, 267.84)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "キメ", 6)
		event.queue_object_sequence_next_motion(2, "キメL", 4)
		event.play_sound_effect(var1, 6)
		at = 16
		helper_888ab2a3(30)
		event.play_sound_effect(var1, 7)
		at = 17
		wait_objects(2)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 18
		helper_4116e6bb(5280040)
		event.start_crossfade(30)
		event.set_camera_sequence_position(1.63, 33.52, 291.68)
		event.set_camera_sequence_look_at(1.34, 31.08, 268.48)
		event.move_camera_sequence(5.68, 33.52, 291.63, 5.38, 31.08, 268.43, 120)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(2, 1, "わらい口とじ")
		at = 19
		helper_888ab2a3(90)
		event.fade_out_screen(30)
		at = 20
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = active_chr_no ~= 0
			active_chr_no = 0
			helper_038a2e4d(4)
		end
		if at <= 2 then
			helper_038a2e4d(90)
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			helper_038a2e4d(20)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_038a2e4d(46)
		end
		if at <= 7 then
			helper_038a2e4d(30)
		end
		if at <= 8 then
			helper_238b5abc(2)
		end
		if at <= 9 then
			helper_8cd371d7(5280010)
		end
		if at <= 10 then
			helper_8cd371d7(5280020)
		end
		if at <= 11 then
			helper_8cd371d7(5280030)
		end
		if at <= 12 then
			helper_038a2e4d(20)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_238b5abc(2)
		end
		if at <= 15 then
			helper_038a2e4d(30)
		end
		if at <= 16 then
			helper_238b5abc(2)
		end
		if at <= 17 then
			helper_8cd371d7(5280040)
		end
		if at <= 18 then
			helper_038a2e4d(90)
		end
		if at <= 19 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 21
	vm.entry(21)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(4, 1)
end

--- Helper function.
local function helper_15fb0()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(532, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 then
			event.switch_dungeon_main_character(0)
			active_chr_no = 0
		end
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(113)
		event.load_map_sounds(5820)
		var1 = event.load_sound_effect_file_2(5820) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e532/")
		event.load_message_file(0, 5, "e532.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e532_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e532_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e532_guiltoni.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "shuchusen.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.load_character(5, "e532_syougeki.gltf", "info", 14)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(11, 14)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 11)
		block = event.load_event_image_4(5, "e532.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e53201", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(5, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 5)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e53202", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(6, 1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 6)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e53203", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 1)
		event.attach_object_handle_to_sprite(7, 2)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 7)
		event.reset_event_sprite(3)
		event.set_event_sprite_type(3, 0)
		event.set_event_sprite_texture(3, "e53204", block)
		event.set_event_sprite_color(3, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(3, 0, 0, 512, 448)
		event.set_event_sprite_size(3, 512, 448)
		event.set_event_sprite_position(3, 256, 224)
		event.set_event_sprite_draw_pass(3, 1)
		event.attach_object_handle_to_sprite(8, 3)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 8)
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_texture(4, "e53205", block)
		event.set_event_sprite_color(4, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(4, 0, 0, 512, 448)
		event.set_event_sprite_size(4, 512, 448)
		event.set_event_sprite_position(4, 256, 224)
		event.set_event_sprite_draw_pass(4, 1)
		event.attach_object_handle_to_sprite(9, 4)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 9)
		event.change_directory("")
		if active_chr_no == 1 then
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_equipment_model(5, 1, 0, "info", 8, 10)
			event.load_character_motion_pack(5, "event/e500/e532/e532_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(3, 1)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_position(0, 0.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "バトル立ち2", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, -100.0, 0.0, -200.0)
		event.set_object_handle_rotation(1, 0.0, 2.54, 0.0)
		event.set_object_handle_motion(1, "起きあがり待ち", 4)
		event.step_object_handle_motion(1)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "死に")
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "はぁはぁ", 4)
		event.step_object_handle_motion(2)
		event.reset_object_handle_dynamic_animation(2)
		event.set_object_handle_sound_bank(2, var1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "苦し顔")
		event.set_object_handle_texture_animation(2, 1, "苦し目パチ")
		event.set_character_position(12, 0.0, -1000.0, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(38.02, 17.95, 16.08)
		event.set_camera_sequence_look_at(5.45, 17.89, 15.92)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(2, "苦し口パク")
		at = 3
		helper_4116e6bb(5320010)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		at = 4
		helper_888ab2a3(40)
		event.set_camera_sequence_position(-3.92, 12.48, 46.35)
		event.set_camera_sequence_look_at(0.46, 18.98, 16.47)
		event.set_object_sequence_motion(2, "顔上げ", 6)
		event.queue_object_sequence_next_motion(2, "顔上げL", 4)
		at = 5
		wait_objects(2)
		event.set_mouth_texture_animations(2, "苦し口パク")
		at = 6
		helper_4116e6bb(5320020)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 7
		helper_4116e6bb(5320030)
		event.set_camera_sequence_look_at(0.0, 20.0, 50.0)
		event.set_camera_sequence_angle_height_distance(-0.36, 0.0, 100.0)
		event.move_camera_sequence_angle_height_distance_eased(2.64, 0.0, 100.0, 280, 2, 1.0)
		event.set_mouth_texture_animations(2, "苦し口パク")
		at = 8
		helper_4116e6bb(5320040)
		event.set_mouth_texture_animations(2, "苦し口パク")
		at = 9
		helper_4116e6bb(5320045)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 10
		helper_4116e6bb(5320050)
		at = 11
		wait_camera()
		event.set_camera_sequence_position(16.36, 17.95, 32.78)
		event.set_camera_sequence_look_at(0.93, 19.2, 17.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "苦し顔")
		event.set_object_handle_texture_animation(2, 1, "苦し目あき～目とじ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 12
		helper_4116e6bb(5320060)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 13
		helper_4116e6bb(5320065)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "苦し顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～苦し目あき")
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 14
		helper_4116e6bb(5320070)
		event.set_camera_sequence_position(16.15, 37.27, 153.71)
		event.set_camera_sequence_look_at(3.58, 24.38, 96.09)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり顔")
		event.set_object_handle_texture_animation(2, 1, "苦し目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 15
		helper_4116e6bb(5320080)
		event.play_sound_effect(var1, 2)
		event.set_object_sequence_motion(2, "起きあがり", 6)
		event.queue_object_sequence_next_motion(2, "起きあがりL", 4)
		at = 16
		helper_888ab2a3(30)
		event.set_object_sequence_motion(1, "起きあがり", 6)
		event.queue_object_sequence_next_motion(1, "起きあがりL", 4)
		at = 17
		helper_888ab2a3(15)
		event.set_camera_sequence_position(-84.02, 9.18, -188.66)
		event.set_camera_sequence_look_at(-99.08, 9.86, -193.29)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "死に")
		event.set_object_handle_texture_animation(1, 1, "目とじ～目あき")
		event.play_sound_effect(var1, 3)
		at = 18
		wait_objects(1)
		at = 19
		helper_888ab2a3(20)
		event.set_camera_sequence_position(-23.98, 12.62, 43.97)
		event.set_camera_sequence_look_at(-1.29, 22.54, 7.67)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 20
		helper_4116e6bb(5320090)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "口とじ～大口")
		event.set_character_active(12)
		event.set_camera_sequence_follow_object(1, 0.0, 20.0, 7.0, -1.0, 0.0, 40.0)
		event.delay_camera_sequence_angle_track(19)
		event.release_camera_sequence_follow_object()
		event.delay_camera_sequence_position_track(20)
		event.set_camera_sequence_position(-26.37, 17.77, -50.44)
		event.set_camera_sequence_look_at(-51.96, 20.0, -102.44)
		event.delay_camera_sequence_character_track(20)
		event.keep_character_in_front_of_camera_sequence(12, 60.0, 20)
		event.set_character_active(1, 10)
		event.set_object_sequence_rotation(1, 0.0, 0.46, 0.0)
		event.set_object_sequence_motion(1, "剣走り", 4, -1.0, 1)
		event.move_object_sequence(1, -11.76, 0.0, -20.14, 60)
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "歯くいしばり")
		at = 21
		helper_0382f327(5320100, 40)
		event.set_character_active(0, 12)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_camera_sequence_position(-69.98, 14.49, -24.99)
		event.set_camera_sequence_look_at(-2.25, 17.76, -8.93)
		event.delay_camera_sequence_position_track(45)
		event.set_camera_sequence_position(-52.69, 22.4, 13.43)
		event.set_camera_sequence_look_at(-30.89, 6.61, -41.34)
		event.set_object_sequence_rotation(2, 0.0, -2.4, 0.0)
		event.delay_object_sequence_motion_track(2, 10)
		event.set_object_sequence_motion(2, "よけ", 6)
		event.queue_object_sequence_next_motion(2, "ふっとばし", 6)
		event.delay_object_sequence_texture_animation_track(2, 40)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(2, 1, "口ふっ")
		event.set_object_sequence_motion(1, "斬り", 6)
		event.queue_object_sequence_next_motion(1, "吹っ飛び", 6)
		event.delay_object_sequence_position_track(1, 20)
		event.move_object_sequence_eased(1, -34.13, 0.0, -72.15, 26, 2, 1.0)
		event.play_object_sequence_sound(1, var1, 4)
		event.delay_object_sequence_sound_track(1, 50)
		event.play_object_sequence_sound(1, var1, 6)
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_character_active(1, 14)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(9, 0.0, -2.4, 0.0)
		event.set_object_sequence_motion(9, "ふっとばし", 5)
		event.delay_object_sequence_motion_track(9, 26)
		event.set_object_sequence_motion(9, "ふっとばし", 6)
		event.delay_object_sequence_sound_track(9, 34)
		event.play_object_sequence_sound(9, var1, 5)
		at = 22
		helper_888ab2a3(5)
		at = 23
		helper_0382f327(5320110, 20)
		at = 24
		helper_888ab2a3(5)
		at = 25
		helper_0382f327(5320120, 40)
		at = 26
		wait_objects(1)
		event.set_character_active(0, 14)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		event.set_object_sequence_motion(0, "モニカ！！", 6)
		event.queue_object_sequence_next_motion(0, "モニカ！！L", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 27
		helper_4116e6bb(5320130)
		at = 28
		wait_objects(0)
		event.set_camera_sequence_position(-18.95, 19.99, -37.66)
		event.set_camera_sequence_look_at(-30.66, 14.75, -65.72)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(var1, 7)
		event.set_object_sequence_motion(1, "しゃがみにらみ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "しゃがみにらみL", 4)
		at = 29
		wait_objects(1)
		at = 30
		helper_888ab2a3(20)
		event.set_camera_sequence_position(-57.1, 14.78, -90.75)
		event.set_camera_sequence_look_at(-21.25, 17.36, -33.53)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.play_sound_effect(var1, 8)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "後ろ見", 6)
		event.queue_object_sequence_next_motion(2, "後ろ見L", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 31
		helper_4116e6bb(5320140)
		at = 32
		wait_objects(2)
		event.set_camera_sequence_position(0.0, 27.09, 35.56)
		event.set_camera_sequence_look_at(0.0, 29.67, -20.86)
		event.play_music(0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "笑う", 4)
		event.delay_object_sequence_motion_track(2, 140)
		event.set_object_sequence_motion(2, "笑う2")
		event.delay_object_sequence_texture_animation_track(2, 140)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目～大わらい目")
		event.set_object_sequence_texture_animation(2, 1, "大わらい口パク")
		at = 33
		helper_0382f327(5320150, -1)
		at = 34
		helper_888ab2a3(10)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "大わらい目～通常目")
		event.play_sound_effect(var1, 9)
		event.set_object_sequence_motion(2, "戻り", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 35
		helper_4116e6bb(5320155)
		at = 36
		wait_objects(2)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "前向き～右向き")
		event.set_object_sequence_motion(1, "立つ", 2)
		event.queue_object_sequence_next_motion(1, "立つL", 4)
		event.delay_object_sequence_sound_track(1, 4)
		event.play_object_sequence_sound(1, var1, 10)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 37
		helper_4116e6bb(5320160)
		at = 38
		wait_objects(1)
		event.set_camera_sequence_position(24.94, 8.23, 72.51)
		event.set_camera_sequence_look_at(1.57, 16.42, 98.07)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "歯くいしばり")
		event.set_object_sequence_motion(0, "バトル立ち2", 4)
		at = 39
		helper_888ab2a3(40)
		event.set_camera_sequence_position(1.0, 31.0, 29.43)
		event.set_camera_sequence_look_at(1.0, 31.0, 1.39)
		event.move_camera_sequence_eased(1.0, 31.0, 23.46, 1.0, 31.0, 1.39, 90, 2, 1.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.delay_object_sequence_texture_animation_track(2, 120)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 40
		helper_4116e6bb(5320170)
		at = 41
		wait_camera()
		event.set_environment_music_volume(0.0)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 42
		helper_4116e6bb(5320180)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 43
		helper_4116e6bb(5320190)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 44
		helper_4116e6bb(5320200)
		at = 45
		wait_objects(3)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 46
		helper_4116e6bb(5320210)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 47
		helper_4116e6bb(5320220)
		at = 48
		wait_objects(4)
		event.set_object_sequence_color(3, 128, 128, 128, 0)
		event.set_object_sequence_color(5, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 49
		helper_4116e6bb(5320225)
		at = 50
		wait_objects(5)
		event.set_object_sequence_color(4, 128, 128, 128, 0)
		event.set_object_sequence_color(6, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 51
		helper_4116e6bb(5320230)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 52
		helper_4116e6bb(5320240)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 53
		helper_4116e6bb(5320245)
		at = 54
		wait_objects(6)
		event.set_object_sequence_color(5, 128, 128, 128, 0)
		event.set_object_sequence_color(7, 128, 128, 128, 128, 10)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 55
		helper_4116e6bb(5320250)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 56
		helper_4116e6bb(5320260)
		at = 57
		wait_objects(7)
		event.set_object_sequence_color(6, 128, 128, 128, 0)
		event.set_object_sequence_color(7, 128, 128, 128, 0, 30)
		event.set_environment_music_volume(1.0)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 58
		helper_4116e6bb(5320270)
		at = 59
		wait_objects(7)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 60
		helper_4116e6bb(5320275)
		at = 61
		vm.wait(61)
		at = 62
		vm.wait(62)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = active_chr_no ~= 0
			active_chr_no = 0
			helper_038a2e4d(4)
		end
		if at <= 2 then
			helper_8cd371d7(5320010)
		end
		if at <= 3 then
			helper_038a2e4d(40)
		end
		if at <= 4 then
			helper_238b5abc(2)
		end
		if at <= 5 then
			helper_8cd371d7(5320020)
		end
		if at <= 6 then
			helper_8cd371d7(5320030)
		end
		if at <= 7 then
			helper_8cd371d7(5320040)
		end
		if at <= 8 then
			helper_8cd371d7(5320045)
		end
		if at <= 9 then
			helper_8cd371d7(5320050)
		end
		if at <= 10 then
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_8cd371d7(5320060)
		end
		if at <= 12 then
			helper_8cd371d7(5320065)
		end
		if at <= 13 then
			helper_8cd371d7(5320070)
		end
		if at <= 14 then
			helper_8cd371d7(5320080)
		end
		if at <= 15 then
			helper_038a2e4d(30)
		end
		if at <= 16 then
			helper_038a2e4d(15)
		end
		if at <= 17 then
			helper_238b5abc(1)
		end
		if at <= 18 then
			helper_038a2e4d(20)
		end
		if at <= 19 then
			helper_8cd371d7(5320090)
		end
		if at <= 20 then
			helper_53ffe901(5320100, 40)
		end
		if at <= 21 then
			helper_038a2e4d(5)
		end
		if at <= 22 then
			helper_53ffe901(5320110, 20)
		end
		if at <= 23 then
			helper_038a2e4d(5)
		end
		if at <= 24 then
			helper_53ffe901(5320120, 40)
		end
		if at <= 25 then
			helper_238b5abc(1)
		end
		if at <= 26 then
			helper_8cd371d7(5320130)
		end
		if at <= 27 then
			helper_238b5abc(0)
		end
		if at <= 28 then
			helper_238b5abc(1)
		end
		if at <= 29 then
			helper_038a2e4d(20)
		end
		if at <= 30 then
			helper_8cd371d7(5320140)
		end
		if at <= 31 then
			helper_238b5abc(2)
		end
		if at <= 32 then
			helper_53ffe901(5320150, -1)
		end
		if at <= 33 then
			helper_038a2e4d(10)
		end
		if at <= 34 then
			helper_8cd371d7(5320155)
		end
		if at <= 35 then
			helper_238b5abc(2)
		end
		if at <= 36 then
			helper_8cd371d7(5320160)
		end
		if at <= 37 then
			helper_238b5abc(1)
		end
		if at <= 38 then
			helper_038a2e4d(40)
		end
		if at <= 39 then
			helper_8cd371d7(5320170)
		end
		if at <= 40 then
			helper_344d6cd8()
		end
		if at <= 41 then
			helper_8cd371d7(5320180)
		end
		if at <= 42 then
			helper_8cd371d7(5320190)
		end
		if at <= 43 then
			helper_8cd371d7(5320200)
		end
		if at <= 44 then
			helper_238b5abc(3)
		end
		if at <= 45 then
			helper_8cd371d7(5320210)
		end
		if at <= 46 then
			helper_8cd371d7(5320220)
		end
		if at <= 47 then
			helper_238b5abc(4)
		end
		if at <= 48 then
			helper_8cd371d7(5320225)
		end
		if at <= 49 then
			helper_238b5abc(5)
		end
		if at <= 50 then
			helper_8cd371d7(5320230)
		end
		if at <= 51 then
			helper_8cd371d7(5320240)
		end
		if at <= 52 then
			helper_8cd371d7(5320245)
		end
		if at <= 53 then
			helper_238b5abc(6)
		end
		if at <= 54 then
			helper_8cd371d7(5320250)
		end
		if at <= 55 then
			helper_8cd371d7(5320260)
		end
		if at <= 56 then
			helper_238b5abc(7)
		end
		if at <= 57 then
			helper_8cd371d7(5320270)
		end
		if at <= 58 then
			helper_238b5abc(7)
		end
		if at <= 59 then
			helper_8cd371d7(5320275)
		end
		return true
	end)
	at = 63
	vm.entry(63)
	event.cancel_drama_scene_skip()
	event.start_crossfade(60)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(14)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.clear_camera_sequence()
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(4, 1)
end

--- Helper function.
local function helper_1c2b8()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	vm.section(function()
		event.set_save_flag(532, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 then
			event.switch_dungeon_main_character(0)
			active_chr_no = 0
		end
		event.load_map_sounds(5822)
		var1 = event.load_sound_effect_file_2(5822) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e532/")
		event.load_message_file(0, 5, "e532.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e532_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e532_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e532_guiltoni.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e532_m_guil.gltf", "p00_23a", 13)
		event.set_character_active(0, 13)
		event.attach_object_handle_to_character(10, 13)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 10)
		event.load_character(5, "e532_kawaru_hikari.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.load_character(5, "e532_guil_kage.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.load_character(5, "e532_tgate_f.gltf", "info", 17)
		event.set_character_active(0, 17)
		event.load_character(5, "e532_tgate_h.gltf", "info", 18)
		event.set_character_active(0, 18)
		block = event.load_event_image_4(5, "e532telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e532telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 347)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(12, 0)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 12)
		event.change_directory("")
		event.load_character(5, "event/time_gate/red/tg_maru_red.gltf", "info", 19)
		event.set_character_active(0, 19)
		if active_chr_no == 1 then
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e532/e532_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(3, 1)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_position(0, 0.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_position(1, -34.13, 0.0, -72.15)
		event.set_object_handle_rotation(1, 0.0, 0.46, 0.0)
		event.set_object_handle_motion(1, "立つL", 4)
		event.step_object_handle_motion(1)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "下向き立ち", 4)
		event.step_object_handle_motion(2)
		event.reset_object_handle_dynamic_animation(2)
		event.set_object_handle_sound_bank(2, var1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ")
		event.set_object_handle_position(10, 48.15, 0.0, -39.92)
		event.set_object_handle_rotation(10, 0.0, -0.96, 0.0)
		event.set_object_handle_motion(10, "立ち2", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1.0, 31.0, 23.46)
		event.set_camera_sequence_look_at(1.0, 31.0, 1.39)
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(5320380)
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(5320390)
		event.set_camera_sequence_position(32.47, 29.12, 7.82)
		event.set_camera_sequence_look_at(-0.08, 29.06, 7.66)
		event.move_camera_sequence_eased(32.49, 29.12, 2.2, -0.05, 29.06, 2.04, 90, 2, 1.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あけ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(5320400)
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(5320410)
		wait_camera()
		event.set_camera_sequence_position(-11.1, 23.74, 47.57)
		event.set_camera_sequence_look_at(-11.12, 23.68, 10.21)
		event.move_camera_sequence_eased(1.26, 23.74, 47.57, 1.24, 23.68, 10.2, 120, 2, 1.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ")
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320420)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(5320430)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(5320435)
		wait_camera()
		event.set_camera_sequence_position(21.93, 20.24, 29.75)
		event.set_camera_sequence_look_at(0.34, 28.43, 3.64)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あき")
		event.set_object_sequence_motion(2, "普通立ちへ", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(5320440)
		wait_objects(2)
		event.set_camera_sequence_position(21.31, 32.88, -28.93)
		event.set_camera_sequence_look_at(15.92, 30.08, 1.51)
		event.move_camera_sequence_eased(11.89, 32.88, -30.6, 6.5, 30.08, -0.16, 90, 2, 1.0)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(5320450)
		wait_camera()
		event.set_camera_sequence_position(21.93, 20.24, 29.75)
		event.set_camera_sequence_look_at(0.34, 28.43, 3.64)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(5320460)
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(5320465)
		event.play_sound_effect(var1, 13)
		event.rotate_object_sequence(2, 0.0, 2.04, 0.0, 12)
		event.move_object_sequence(2, 112.86, 0.0, -57.4, 120)
		event.set_object_sequence_motion(2, "歩き")
		event.delay_object_sequence_motion_track(2, 120)
		event.set_object_sequence_motion(2, "立ち")
		helper_888ab2a3(12)
		event.set_camera_sequence_position(12.52, 143.33, 237.6)
		event.set_camera_sequence_look_at(19.7, 10.27, 44.27)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		wait_objects(2)
		helper_888ab2a3(5)
		event.set_camera_sequence_position(193.83, 30.9, -96.26)
		event.set_camera_sequence_look_at(115.38, 26.4, -60.1)
		event.set_object_sequence_rotation(0, 0.0, 2.54, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, 1.54, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		helper_888ab2a3(5)
		event.play_sound_effect(var1, 14)
		event.set_object_sequence_motion(2, "魔法構え", 2)
		event.queue_object_sequence_next_motion(2, "魔法構えL", 4)
		wait_objects(2)
		event.play_sound_effect(var1, 15)
		event.set_character_active(1, 17)
		event.set_character_position(17, 112.86, 0.0, -57.4)
		event.set_character_rotation(17, 0.0, 2.04, 0.0)
		event.set_character_motion(17, "魔法構えL", 6)
		helper_888ab2a3(20)
		event.set_camera_sequence_position(93.61, 28.03, 33.84)
		event.set_camera_sequence_look_at(141.27, 27.9, -88.39)
		event.move_camera_sequence_eased(139.2, 30.07, -23.94, 196.24, 29.95, -119.09, 60, 2, 0.4)
		event.set_character_active(1, 18)
		event.set_character_position(18, 177.89, 30.0, -88.76)
		event.set_character_rotation(18, 0.0, 0.0, 0.0)
		event.set_character_motion(18, "発生", 6)
		helper_888ab2a3(10)
		event.set_character_active(1, 19)
		event.set_character_position(19, 177.89, 30.0, -88.76)
		event.set_character_rotation(19, 0.0, 0.0, 0.0)
		event.set_character_visible(19, 1, 1, 0.1)
		wait_camera()
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-83.46, 20.24, 40.29)
		event.set_camera_sequence_look_at(25.57, 18.02, -14.67)
		event.set_object_sequence_position(0, -34.9, 0.0, 31.89)
		event.set_object_sequence_rotation(0, 0.0, 2.18, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -54.15, 0.0, 12.15)
		event.set_object_sequence_rotation(1, 0.0, 2.02, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_object_sequence(2, 149.89, 0.0, -76.07, 40)
		event.set_object_sequence_motion(2, "歩き")
		event.delay_object_sequence_motion_track(2, 40)
		wait_objects(2)
		event.set_camera_sequence_position(195.01, 15.44, -79.93)
		event.set_camera_sequence_look_at(159.74, 21.63, -83.99)
		event.stop_music(0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目～くるし目")
		event.play_sound_effect(var1, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_character_active(0, 19)
		event.set_character_active(1, 15)
		event.set_character_visible(15, 1, 1, 0.033333335)
		event.set_character_position(15, 161.48, 0.0, -80.57)
		event.set_character_rotation(15, 0.0, 2.04, 0.0)
		event.set_object_sequence_motion(2, "うぐっ", 6)
		event.queue_object_sequence_next_motion(2, "頭抱え", 6)
		event.queue_object_sequence_next_motion(2, "頭抱えL", 4)
		event.play_object_sequence_sound(2, var1, 17)
		event.delay_object_sequence_sound_track(2, 30)
		event.play_object_sequence_sound(2, var1, 18)
		event.delay_object_sequence_texture_animation_track(2, 30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "苦し顔")
		event.set_object_sequence_texture_animation(2, 1, "苦し目パチ")
		event.set_object_sequence_texture_animation(2, 1, "口とじ～大口")
		event.delay_camera_sequence_position_track(30)
		event.set_camera_sequence_position(185.9, 26.26, -83.55)
		event.set_camera_sequence_look_at(160.82, 28.01, -82.54)
		event.move_camera_sequence_eased(225.88, 13.42, -85.2, 160.83, 18.04, -82.53, 60, 0, 1.0)
		event.set_mouth_texture_animations(2, "苦し口パク")
		helper_4116e6bb(5320480)
		wait_objects(2)
		wait_camera()
		event.set_camera_sequence_position(-153.15, 54.88, 77.9)
		event.set_camera_sequence_look_at(-32.02, 26.4, 15.61)
		event.move_camera_sequence_eased(-153.15, 54.88, 77.9, -32.02, 93.93, 15.61, 60, 0, 1.0)
		helper_4116e6bb(5320490)
		wait_camera()
		event.set_camera_sequence_position(-45.58, 18.39, -25.71)
		event.set_camera_sequence_look_at(-44.29, 20.81, 21.82)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(var1, 19)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320500)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.set_camera_sequence_position(152.29, 17.2, -116.31)
		event.set_camera_sequence_look_at(169.35, 16.15, -86.33)
		event.move_camera_sequence_look_at(163.62, 23.13, -83.64, 120)
		event.move_camera_sequence_angle_height_distance_eased(1.42, -8.07, 36.58, 90, 0, 1.0)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "苦し顔")
		event.set_object_sequence_texture_animation(2, 1, "苦し目パチ")
		event.set_object_sequence_motion(2, "苦しむ", 6)
		event.queue_object_sequence_next_motion(2, "苦しむL", 4)
		event.delay_object_sequence_sound_track(2, 30)
		event.play_object_sequence_sound(2, var1, 20)
		helper_4116e6bb(5320510)
		helper_4116e6bb(5320515)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "苦し顔")
		event.set_object_sequence_texture_animation(2, 1, "苦し目とじ")
		event.set_mouth_texture_animations(2, "苦し口パク")
		helper_4116e6bb(5320520)
		wait_camera()
		event.set_camera_sequence_position(-65.76, 1.45, 77.12)
		event.set_camera_sequence_look_at(-31.95, 23.15, 22.39)
		event.set_object_sequence_position(0, -54.15, 0.0, 12.15)
		event.set_object_sequence_rotation(0, 0.0, 2.02, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -34.9, 0.0, 31.89)
		event.set_object_sequence_rotation(1, 0.0, 2.18, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320530)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(5320540)
		event.set_camera_sequence_position(27.41, 54.66, -24.03)
		event.set_camera_sequence_look_at(-38.65, 16.14, 19.92)
		event.move_camera_sequence_eased(27.41, 88.01, -24.03, -38.65, 16.14, 19.92, 60, 2, 1.0)
		event.play_sound_effect(var1, 21)
		event.set_character_active(0, 15)
		event.set_character_active(0, 11)
		event.set_character_active(1, 16)
		event.set_character_position(16, 98.8, 0.0, -70.68)
		event.set_character_rotation(16, 0.0, 2.16, 0.0)
		event.set_character_motion(16, "伸びる", 6)
		event.set_object_sequence_motion(0, "ギル巨大化", 6)
		event.queue_object_sequence_next_motion(0, "ギル巨大化L", 4)
		event.set_object_sequence_motion(1, "ギル巨大化", 6)
		event.start_background_file_loads_1("snd2/bgm/bg_035.sound.json")
		helper_479dc9e9()
		event.load_music_pack(35)
		wait_camera()
		event.set_character_active(0, 16)
		event.play_music(0)
		event.set_camera_sequence_position(-201.41, 27.8, 185.21)
		event.set_camera_sequence_look_at(-35.48, 67.52, 28.17)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.stop_sound_effect(var1, 16)
		event.set_character_active(1, 13)
		helper_888ab2a3(10)
		event.play_sound_effect(var1, 22)
		event.set_object_sequence_motion(8, "攻撃１", 6)
		event.queue_object_sequence_next_motion(8, "攻撃１ループ", 4)
		helper_888ab2a3(4)
		event.set_object_sequence_motion(0, "よける", 6)
		event.set_object_sequence_motion(1, "後ろ飛び", 6)
		event.wait_object_sequence_motion_end(1)
		wait_objects(1)
		helper_888ab2a3(10)
		event.set_camera_sequence_position(-36.53, 21.01, 90.55)
		event.set_camera_sequence_look_at(-110.73, 24.73, 53.44)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.play_sound_effect(var1, 23)
		event.set_object_sequence_position(0, -130.27, 0.0, 15.93)
		event.set_object_sequence_motion(0, "バトル立ち2", 4, -1.0, 1)
		event.set_object_sequence_position(1, -64.55, 0.0, 84.34)
		event.set_object_sequence_motion(1, "戦うしか", 4, -1.0, 1)
		helper_888ab2a3(10)
		event.set_object_sequence_motion(1, "戦うしかユリス見", 2)
		event.queue_object_sequence_next_motion(1, "戦うしかユリス見L", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320550)
		event.set_object_sequence_motion(1, "上見へ", 2)
		event.queue_object_sequence_next_motion(1, "上見へL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320560)
		event.set_camera_sequence_position(-247.3, 94.84, 129.46)
		event.set_camera_sequence_look_at(-110.28, 94.53, 54.08)
		event.move_camera_sequence(-217.34, 94.84, 112.98, -110.28, 94.53, 54.08, 120)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128, 128, 128, 128, 30)
		event.set_object_sequence_motion(8, "立ち", 4)
		helper_888ab2a3(90)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var1, 16)
	var3 = event.get_active_music_number() or var3
	if var3 ~= 35 then
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(35)
		event.play_music(0)
	end
	event.set_event_sprite_draw_pass(0, 0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(11)
	event.delete_character(13)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.clear_camera_sequence()
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(4, 1)
end

--- Helper function.
local function helper_22124()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(536, 1)
		event.initialize_event()
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
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(52)
		event.load_map_sounds(5823)
		var1 = event.load_sound_effect_file_2(5823) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e536/")
		event.load_message_file(0, 5, "e536.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e536_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e536_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e536_guiltoni.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e536_m_guil.gltf", "p00_23a", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e536_guilbaku.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.load_character(5, "e536_guilbaku1.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.load_character(5, "e536_hikari.gltf", "info", 14)
		event.set_character_active(0, 14)
		event.load_character(5, "e536_hikari1.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.load_character(5, "e536_guil_hikari.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(6, 16)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 6)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e536/e536_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e536/e536_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -10.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 10.0, 0.0, 100.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, 0.0, 0.0, -50.0)
		event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(2, "倒れ", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "くるし目とじ")
		event.set_object_handle_position(3, 0.0, 0.0, -50.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "グォオー", 4)
		event.set_character_position(12, 0.0, 50.0, -50.0)
		event.set_character_rotation(12, 0.0, 0.0, 0.0)
		event.set_character_position(13, 0.0, 50.0, -18.0)
		event.set_character_rotation(13, 0.0, 0.0, 0.0)
		event.enable_drama_skip()
		event.set_character_active(1, 12)
		event.set_character_motion(12, "グォオー", 6)
		event.set_character_active(1, 13)
		event.set_character_motion(13, "グォオー", 6)
		event.play_sound_effect(var1, 2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 150.0, 65.9)
		event.set_camera_sequence_look_at(0.0, 150.0, -23.0)
		event.move_camera_sequence_eased(0.0, 123.2, 330.45, 0.0, 123.57, -23.0, 90, 0, 0.3)
		event.fade_in_screen(30)
		at = 3
		helper_888ab2a3(80)
		event.set_character_visible(11, 0, 1, 0.1)
		at = 4
		wait_camera()
		event.set_character_active(0, 13)
		event.set_character_active(0, 12)
		event.set_camera_sequence_position(45.36, 6.79, 49.62)
		event.set_camera_sequence_look_at(-2.61, 16.71, 101.94)
		event.set_wind(10, 0.0, 0.0, 1.0)
		event.set_character_active(1, 14)
		event.set_character_position(14, 19.99, 0.0, 122.09)
		event.set_character_rotation(14, 0.0, 1.57, 0.0)
		event.set_object_sequence_motion(0, "爆発", 6)
		event.queue_object_sequence_next_motion(0, "爆発L", 4)
		event.set_object_sequence_motion(1, "爆発", 6)
		event.queue_object_sequence_next_motion(1, "爆発L", 4)
		at = 5
		wait_objects(1)
		at = 6
		helper_888ab2a3(20)
		event.set_character_active(0, 14)
		event.set_camera_sequence_position(4.04, 16.09, 159.94)
		event.set_camera_sequence_look_at(4.04, 13.4, 71.43)
		event.set_character_active(0, 11)
		event.set_character_active(1, 10)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 15.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		at = 7
		helper_888ab2a3(20)
		event.set_character_visible(15, 0, 1, 0.033333335)
		event.set_wind(-1)
		at = 8
		helper_888ab2a3(20)
		event.set_object_sequence_motion(0, "爆発戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "もどり", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 9
		wait_objects(1)
		at = 10
		helper_888ab2a3(6)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 46)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, 10.0, 0.0, -30.0, 50)
		event.delay_object_sequence_rotation_track(1, 46)
		event.rotate_object_sequence(1, 0.0, -2.78, 0.0, 10)
		at = 11
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 46)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -10.0, 0.0, -30.0, 50)
		event.delay_object_sequence_rotation_track(0, 46)
		event.rotate_object_sequence(0, 0.0, 2.9, 0.0, 10)
		at = 12
		helper_888ab2a3(15)
		event.set_camera_sequence_position(13.0, 9.86, -79.62)
		event.set_camera_sequence_look_at(13.0, 12.67, -39.5)
		event.move_camera_sequence_eased(0.0, 9.86, -79.62, 0.0, 12.67, -39.5, 60, 2, 1.0)
		event.play_music(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_position(2, 13.0, 0.0, -50.0)
		event.reset_object_sequence_dynamic_animation(2)
		at = 13
		wait_objects(1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目～こまり目下")
		event.play_sound_effect(var1, 3)
		event.set_object_sequence_motion(1, "しゃがみ", 6)
		event.queue_object_sequence_next_motion(1, "しゃがみL", 4)
		at = 14
		wait_objects(0)
		event.set_object_sequence_motion(0, "しゃがむ", 6)
		event.queue_object_sequence_next_motion(0, "しゃがむL", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あけ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 15
		helper_4116e6bb(5360010)
		event.set_mouth_texture_animations(2, "くるし口パク")
		at = 16
		helper_4116e6bb(5360020)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "目あけ～目とじ")
		event.set_object_sequence_motion(2, "ぐふっ", 2)
		event.queue_object_sequence_next_motion(2, "倒れ", 4)
		event.set_mouth_texture_animations(2, "くるし口パク")
		at = 17
		helper_4116e6bb(5360025)
		at = 18
		helper_a6838a9a(5360030, -1)
		at = 19
		wait_camera()
		event.set_camera_sequence_position(16.76, 57.33, -49.41)
		event.set_camera_sequence_look_at(4.01, 12.67, -49.87)
		event.move_camera_sequence_eased(11.95, 41.94, -49.58, 4.01, 12.67, -49.87, 150, 2, 1.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "くるし目～くるし目２")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.set_mouth_texture_animations(2, "くるし口パク")
		at = 20
		helper_4116e6bb(5360040)
		event.set_mouth_texture_animations(2, "くるし口パク")
		at = 21
		helper_4116e6bb(5360045)
		at = 22
		wait_camera()
		event.play_sound_effect(var1, 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "くるし目２～通常目")
		event.set_object_handle_texture_animation(2, 1, "わらい口")
		event.set_object_sequence_motion(2, "モニカ見", 2)
		event.queue_object_sequence_next_motion(2, "モニカ見L", 4)
		at = 23
		wait_objects(2)
		at = 24
		helper_888ab2a3(60)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.set_object_handle_texture_animation(1, 1, "口とじ～大口")
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "ゆっくり目とじ")
		event.play_sound_effect(var1, 5)
		event.set_object_sequence_motion(2, "死に", 2)
		event.wait_object_sequence_motion_end(2)
		at = 25
		wait_objects(2)
		at = 26
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-6.98, 9.03, -75.58)
		event.set_camera_sequence_look_at(0.96, 12.16, -49.21)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "目あき～目とじ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 27
		helper_4116e6bb(5360050)
		event.set_camera_sequence_position(-0.18, 28.97, 146.9)
		event.set_camera_sequence_look_at(9.44, 29.01, 60.59)
		event.move_camera_sequence(-2.36, 28.97, 166.44, 9.44, 29.01, 60.59, 150)
		event.play_sound_effect(var1, 6)
		event.set_character_active(1, 16)
		event.set_character_position(16, 0.0, 0.0, -50.0)
		event.set_character_rotation(16, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "発動・ギル光の粒", 6)
		event.queue_object_sequence_next_motion(4, "ループ・ギル光の粒", 4)
		event.fade_out_music(150)
		at = 28
		helper_888ab2a3(30)
		event.fade_out_screen(120, 255, 255, 255)
		at = 29
		helper_888ab2a3(120)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = active_chr_no == 2
			active_chr_no = 0
			local _ = active_chr_no == 3
			active_chr_no = 1
			helper_038a2e4d(4)
		end
		if at <= 2 then
			helper_038a2e4d(80)
		end
		if at <= 3 then
			helper_344d6cd8()
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			helper_038a2e4d(20)
		end
		if at <= 6 then
			helper_038a2e4d(20)
		end
		if at <= 7 then
			helper_038a2e4d(20)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			helper_038a2e4d(6)
		end
		if at <= 10 then
			helper_038a2e4d(10)
		end
		if at <= 11 then
			helper_038a2e4d(15)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_8cd371d7(5360010)
		end
		if at <= 15 then
			helper_8cd371d7(5360020)
		end
		if at <= 16 then
			helper_8cd371d7(5360025)
		end
		if at <= 17 then
			helper_26c3d54b(5360030, -1)
		end
		if at <= 18 then
			helper_344d6cd8()
		end
		if at <= 19 then
			helper_8cd371d7(5360040)
		end
		if at <= 20 then
			helper_8cd371d7(5360045)
		end
		if at <= 21 then
			helper_344d6cd8()
		end
		if at <= 22 then
			helper_238b5abc(2)
		end
		if at <= 23 then
			helper_038a2e4d(60)
		end
		if at <= 24 then
			helper_238b5abc(2)
		end
		if at <= 25 then
			helper_038a2e4d(60)
		end
		if at <= 26 then
			helper_8cd371d7(5360050)
		end
		if at <= 27 then
			helper_038a2e4d(30)
		end
		if at <= 28 then
			helper_038a2e4d(120)
		end
		return true
	end)
	at = 30
	vm.entry(30)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
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
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	event.fade_out_screen(0)
	event_99()
	event.take_memory_card_load_state()
	vm.wait(1)
	helper_9dafbc83(0.0, -30.0, 1600.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 0.0, 1600.0)
	event.set_camera_position(0.0, 10.0, 1700.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(15)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_263b8

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local active_chr_no: s32 = 0
	local var1: any = 0
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
	event.open_message_window_2(0, "前のフロアに戻りますか？")
	var1 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	event.set_message_draw_speed(0, 0)
	if var1 == 0 then
		event.fade_out_screen(15)
		helper_888ab2a3(15)
		event.load_event_script("d05/d05.stb", 1000)
	end
	event.finish_event()
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	helper_93cb8168()
	event.finish_event()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 8, 0, 0)
		else
			helper_75684dd8(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end
	var1 = event.get_triggered_event_data_2(6) or var1
	if var1 == 1 then
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		var2 = helper_c292fa16(0, 2507, 5, 256, 208, var2)
		event.set_message_window_mode(0, 7)
		event.set_message_draw_speed(0, 0)
		if var2 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		helper_888ab2a3(6)
		event.open_use_item_menu(354)
		vm.wait(5)
		item = vmhost.used_item() or item
		if item == 354 then
			event.set_function_point_enabled("d05", "func", 0)
			event.attach_object_handle_to_map_part_3(0, "d05", "d05ba02-a")
			event.set_object_handle_visible(0, 0)
			event.set_function_point_enabled("p01", "invent_2023-1", 1)
			helper_1197c()
			return
		elseif item <= 0 then
			event.finish_event()
		else
			helper_5fb66cb1()
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		helper_888ab2a3(6)
	end
	event.finish_event()
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.set_save_control_bits(1, 1)
		event.fade_out_screen(15)
		at = 1
		helper_888ab2a3(15)
		event.set_function_point_enabled("", "e528", 0)
		at = 2
		helper_12c24()
		at = 3
		vm.wait(3)
		event.load_dungeon_monster(512, 1)
		event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		helper_9dafbc83(0.0, 0.0, 300.0, vm.f32(3.14))
		event.set_camera_look_at(0.0, 30.0, 300.0)
		event.set_camera_position(0.0, 40.0, 400.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_12c24()
				return vm.continue_with(function()
					at = 3
					vm.wait(3)
					event.load_dungeon_monster(512, 1)
					event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					helper_9dafbc83(0.0, 0.0, 300.0, vm.f32(3.14))
					event.set_camera_look_at(0.0, 30.0, 300.0)
					event.set_camera_position(0.0, 40.0, 400.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(15)
					event.finish_event()
					return
				end)
			end
			helper_43f02c95(0.0, 0.0, 300.0, vm.f32(3.14))
			return 0
		end
		return nil
	end)
end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(15)
		at = 1
		helper_888ab2a3(15)
		event.clear_event_battle_monsters(-1)
		event.set_party_member(1, 1)
		event.set_character_change_enabled(1, 1)
		event.set_character_change_unmasked(1, 1)
		event.set_party_member(3, 1)
		event.set_character_change_enabled(3, 1)
		event.set_character_change_unmasked(3, 1)
		at = 2
		helper_15fb0()
		event.skip_next_music_load()
		event.load_dungeon_map("s49")
		event.load_event_script("s49/s49.stb", 500)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_15fb0()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.load_dungeon_map("s49")
					event.load_event_script("s49/s49.stb", 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 561, which map data, a script or the engine runs by number.
function script.event_561()
	event.clear_event_running_flag()
	helper_1c2b8()
	event.set_function_point_enabled("", "e528", 0)
	event.set_function_point_enabled("d05", "func", 0)
	event.set_function_point_enabled("p01", "invent_2023-1", 1)
	event.attach_object_handle_to_map_part_3(0, "d05", "d05ba03-a")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takil")
	event.set_object_handle_translation(0, -330.0, 0.0, 200.0)
	event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takir")
	event.set_object_handle_translation(0, 330.0, 0.0, 200.0)
	event.load_dungeon_monster(511, 1)
	event.place_dungeon_monster(511, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	event.set_character_position(0, 0.0, 0.0, 300.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.set_camera_position(0.0, 40.0, 420.0)
	event.set_camera_look_at(0.0, 30.0, 300.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(15)
	event.finish_event()
end

--- Event 570, which map data, a script or the engine runs by number.
function script.event_570()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(0)
		event.fade_out_screen(15)
		at = 1
		helper_888ab2a3(15)
		event.stop_music(0)
		event.clear_event_battle_monsters(-1)
		at = 2
		helper_22124()
		event.set_dungeon_floor_info(4, 22, 5, 2)
		event.skip_next_music_load()
		event.load_dungeon_map("s49")
		event.load_event_script("s49/s49.stb", 510)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_22124()
				return vm.continue_with(function()
					event.set_dungeon_floor_info(4, 22, 5, 2)
					event.skip_next_music_load()
					event.load_dungeon_map("s49")
					event.load_event_script("s49/s49.stb", 510)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 571, which map data, a script or the engine runs by number.
function script.event_571()
	event.set_save_control_bits(1, 0)
	event.clear_event_running_flag()
	helper_263b8()
	event.go_to_georama_edit(3, 500)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(35)
	event.play_music(0)
	event.set_function_point_enabled("d05", "func", 0)
	event.set_function_point_enabled("", "e528", 0)
	event.load_dungeon_monster(511, 1)
	event.place_dungeon_monster(511, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(532) or flag
		flag_2 = event.get_save_flag(536) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var1 = 0
			var1 = vm.float_bits(event.get_random_number(100)) or var1
			if var1 < 50 then
				at = 1
				helper_a9eaf20e(0, 8540060)
			else
				at = 2
				helper_a9eaf20e(0, 8540070)
			end
			return
		end
		flag_3 = event.get_save_flag(528) or flag_3
		if flag_3 ~= 0 and flag == 0 then
			var1 = 0
			var1 = vm.float_bits(event.get_random_number(100)) or var1
			if var1 < 50 then
				at = 3
				helper_a9eaf20e(0, 8530100)
			else
				at = 4
				helper_a9eaf20e(0, 8530110)
			end
			return
		end
		at = 5
		helper_f9968159(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_2609f66b(0, 8540070)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_2609f66b(0, 8530110)
			end
			return 0
		end
		if at <= 5 then
			return 0
		end
		return nil
	end)
end

--- Event 15260, which map data, a script or the engine runs by number.
function script.event_15260()
	event.stop_music(0)
	helper_1197c()
end

--- Event 15280, which map data, a script or the engine runs by number.
script.event_15280 = helper_12c24

--- Event 15320, which map data, a script or the engine runs by number.
function script.event_15320()
	helper_15fb0()
	event.skip_next_music_load()
	event.load_dungeon_map("s49")
	event.load_event_script("s49/s49.stb", 500)
end

--- Event 15360, which map data, a script or the engine runs by number.
function script.event_15360()
	helper_22124()
	event.skip_next_music_load()
	event.load_dungeon_map("s49")
	event.load_event_script("s49/s49.stb", 510)
end

--- Event 25020, which map data, a script or the engine runs by number.
function script.event_25020()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(190)
	event.play_music(0)
	event.set_function_point_enabled("", "e528", 0)
	event.load_dungeon_monster(512, 1)
	event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end

return script
