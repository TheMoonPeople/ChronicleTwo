--!strict
-- map/s/s18/s18_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_363cdfbf = require("@lib/event/helper_363cdfbf")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_4a9b8bc5 = require("@lib/event/helper_4a9b8bc5")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_7f487db5 = require("@lib/event/helper_7f487db5")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(3686)
	event.attach_object_handle_to_map_part_3(30, "p01_s18", "s18_02-a0")
	event.set_object_handle_visible(30, 0)
	flag = event.get_save_flag(330) or flag
	flag_2 = event.get_save_flag(340) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.set_function_point_enabled("", "e336", 1)
	end
end

--- Helper function.
local function helper_10d00()
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
		global2 = 0
		global3 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.load_character_motion_pack(5, "event/e300/e332/e332_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global2)
		event.load_character(5, "chara/c02_base.gltf", "info", global3)
		event.load_equipment_model(5, 1, 4, "info", global3)
		event.load_equipment_model(5, 1, 3, "info", global3)
		event.load_equipment_model(5, 1, 2, "info", global3, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.load_character_motion_pack(5, "event/e300/e332/e332_monica.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global3)
		event.set_character_active(1, 13)
	end
	if active_chr_no == 1 then
		global2 = 8
		global3 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global2)
		event.load_equipment_model(5, 0, 4, "info", global2)
		event.load_equipment_model(5, 0, 3, "info", global2)
		event.load_equipment_model(5, 0, 2, "info", global2, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.load_character_motion_pack(5, "event/e300/e332/e332_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global2)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.load_character_motion_pack(5, "event/e300/e332/e332_monica.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global3)
	end
	event.load_character(5, "event/d03/p00_26a.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(4, 11)
	event.clear_object_sequence(2, 11)
	event.set_object_sequence_object(2, 4)
	event.set_object_handle_shadow_enabled(4, 0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_message_file(0, 5, "event/e300/e332/e332_1.txt")
end

--- Helper function.
local function helper_108fc()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global2)
		event.set_character_active(0, global3)
		event.delete_character_extension_packs(global2)
		event.delete_character_extension_packs(global3)
		event.delete_character(global3)
		event.delete_character(13)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global3)
		event.set_character_active(0, global2)
		event.delete_character_extension_packs(global2)
		event.delete_character_extension_packs(global3)
		event.delete_character(global2)
		event.delete_character(13)
	end
	event.delete_character(11)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

--- Helper function.
local function helper_11cb4()
	local var4: s32 = 0
	local flag: s32 = 0
	vm.section(function()
		event.set_save_flag(332, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(3820)
		var4 = event.load_sound_effect_file_2(3820) or var4
		helper_10d00()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, 11)
		event.set_camera_sequence_position(2137.92, 789.89, -634.43)
		event.set_camera_sequence_look_at(1501.16, 847.03, -450.95)
		event.set_object_sequence_position(2, -169.01, 1296.7, 919.52)
		event.set_object_sequence_rotation(2, 0.0, 2.52, 0.0)
		event.set_object_sequence_position(0, -1308.19, 201.28, -552.77)
		event.set_object_sequence_rotation(0, 0.0, 1.8, 0.0)
		event.set_object_sequence_position(1, -1303.45, 200.12, -532.19)
		event.set_object_sequence_rotation(1, 0.0, 1.92, 0.0)
		event.fade_in_screen(30)
		event.play_sound_effect(var4, 0)
		event.play_sound_effect(var4, 1)
		event.set_object_sequence_motion(2, "肉つかみ飛び", 4)
		event.move_object_sequence(2, -127.0, 1099.81, 692.26, 140)
		wait_objects(2)
		event.set_character_active(1, global2)
		event.set_character_active(1, global3)
		event.play_sound_effect(var4, 2)
		event.play_sound_effect(var4, 3)
		event.set_object_sequence_position(2, -1272.85, 225.03, -556.23)
		event.set_object_sequence_rotation(2, 0.0, 1.92, 0.0)
		event.move_object_sequence(2, -1272.85, 267.03, -556.23, 60, 0)
		event.set_object_sequence_motion(0, "着地", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "着地", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_camera_sequence_position(-1178.39, 236.2, -586.84)
		event.set_camera_sequence_look_at(-1272.85, 237.51, -556.23)
		wait_frames(60)
		event.set_camera_sequence_position(-1191.17, 236.2, -746.66)
		event.set_camera_sequence_look_at(-1103.65, 237.51, -660.25)
		event.move_camera_sequence_angle_height_distance_eased(-1.31, -1.31, 104.9, 160, 2, 0.2)
		wait_camera()
		wait_frames(60)
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_camera_sequence_position(-90.5, 14.06, -606.53)
		event.set_camera_sequence_look_at(-64.24, 89.53, -950.56)
		event.set_object_sequence_position(1, -238.89, 0.0, -900.0)
		event.set_object_sequence_rotation(1, 0.0, 1.44, 0.0)
		event.set_object_sequence_position(0, -268.89, 0.0, -900.0)
		event.set_object_sequence_rotation(0, 0.0, 1.44, 0.0)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.fade_in_screen(30)
		event.move_object_sequence(0, -76.82, 0.0, -888.62, 190, 1)
		event.delay_object_sequence_rotation_track(0, 180)
		event.rotate_object_sequence(0, 0.0, 3.1, 0.0, 10)
		event.move_object_sequence(1, -57.31, 0.0, -886.09, 180, 1)
		event.delay_object_sequence_rotation_track(1, 170)
		event.rotate_object_sequence(1, 0.0, -3.04, 0.0, 10)
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		wait_frames(60)
		event.set_camera_sequence_position(-84.25, 9.79, -925.95)
		event.set_camera_sequence_look_at(-68.29, 20.6, -887.75)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		wait_frames(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3320010)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3320020)
		wait_objects(1)
		wait_frames(20)
		event.set_camera_sequence_position(-272.67, 64.11, 813.12)
		event.set_camera_sequence_look_at(-83.25, 1200.0, -897.58)
		event.play_sound_effect(var4, 4)
		event.move_camera_sequence_eased(-272.67, 67.63, 813.15, -83.25, 364.11, -897.58, 200, 0, 0.2)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3320025)
		event.reset_mouth_texture_animations()
		wait_camera()
		wait_frames(30)
		flag = event.get_save_flag(330) or flag
		if flag == 0 then
			event.fade_out_screen(20)
			wait_frames(20)
			event.set_camera_sequence_position(-85.63, 12.99, -898.44)
			event.set_camera_sequence_look_at(-67.07, 18.64, -859.32)
			event.set_object_handle_position(0, -76.27, 0.0, -854.62)
			event.set_object_handle_rotation(0, 0.0, 2.76, 0.0)
			event.set_object_handle_texture_animation(0, 0)
			event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
			event.set_object_handle_texture_animation(0, 1, "通常目パチ")
			event.set_object_handle_position(1, -55.61, 0.0, -856.61)
			event.set_object_handle_rotation(1, 0.0, 3.0, 0.0)
			event.set_object_handle_texture_animation(1, 0)
			event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
			event.set_object_handle_texture_animation(1, 1, "通常目パチ")
			event.fade_in_screen(20)
			wait_frames(20)
			event.delay_object_sequence_texture_animation_track(0, 12)
			event.set_object_sequence_texture_animation(0, 1, "右向き目")
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 1)
			event.set_object_sequence_motion(1, "左向く", 6)
			event.queue_object_sequence_next_motion(1, "左向くL", 4)
			event.open_message_window_2(0, "Me preocupa Lin.\nAhora tenemos que cuidar de Lin...")
			event.set_mouth_texture_animations(1, "通常口パク")
			helper_75684dd8(0, -1, 8, 64, 0)
			wait_objects(1)
			event.set_object_sequence_motion(1, "左向く会話", 6)
			event.queue_object_sequence_next_motion(1, "左向くL", 4)
			event.open_message_window_2(0, "Creo que de momento no deber[UNI00ed]amos ir m[UNI00e1]s lejos.")
			event.set_mouth_texture_animations(1, "通常口パク")
			helper_75684dd8(0, -1, 8, 64, 0)
			wait_objects(1)
			event.set_object_sequence_motion(0, "うなづく", 6)
			event.queue_object_sequence_next_motion(0, "立ち", 4)
			event.open_message_window_2(0, "S[UNI00ed], supongo que tienes raz[UNI00f3]n.")
			event.set_mouth_texture_animations(0, "通常口パク")
			helper_75684dd8(0, -1, 8, 460, 0)
			wait_objects(0)
		end
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_108fc()
end

--- Helper function.
local function helper_147b4()
	local active_chr_no: s32 = 0
	local block: s32 = 0
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
		global1 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e300/e336/e336_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 1, "info", global1, 14)
		event.load_equipment_model(5, 1, 0, "info", global1, 15)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e336/e336_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 13)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 1, "info", global0, 14)
		event.load_equipment_model(5, 0, 0, "info", global0, 15)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e300/e336/e336_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 13)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e336/e336_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e336/e336_lin.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(2, 9)
	event.set_object_sequence_object(2, 4)
	block = event.load_event_image_4(5, "textures/event/e300/e336/e336.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e33601", block)
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
	event.set_event_sprite_texture(1, "e33602", block)
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
	event.set_event_sprite_texture(2, "e33603", block)
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
	event.set_event_sprite_texture(3, "e33604", block)
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
	event.set_event_sprite_texture(4, "e33605", block)
	event.set_event_sprite_color(4, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(4, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(4, 512, 416)
	event.set_event_sprite_position(4, 256, 208)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(14, 4)
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	block = event.load_event_image_4(5, "textures/event/e300/e336/e336telop01_1.json", 1) or block
	event.reset_event_sprite(5)
	event.set_event_sprite_type(5, 0)
	event.set_event_sprite_texture(5, "e336telop01", block)
	event.set_event_sprite_texture_rect(5, 0, 0, 512, 128)
	event.set_event_sprite_size(5, 512, 128)
	event.set_event_sprite_position(5, 320, 334)
	event.set_event_sprite_color(5, 128, 128, 128, 0)
	event.set_event_sprite_scale(5, 1.0, 1.0)
	event.set_event_sprite_draw_pass(5, 0)
	event.attach_object_handle_to_sprite(15, 5)
	event.clear_object_sequence(15)
	event.set_object_sequence_object(15, 15)
	event.load_message_file(0, 5, "event/e300/e336/e336_1.txt")
end

--- Helper function.
local function helper_22500000()
	local var0: s32 = 0
	local _ = var0 == 2
	var0 = 0
	local _ = var0 == 3
	var0 = 1
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_14140()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
	end
	event.delete_character(9)
	event.delete_character(16)
	event.delete_character(10)
	event.delete_character(11)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.set_event_sprite_draw_pass(5, 0)
	event.delete_event_image(0)
	event.delete_event_image(1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	vm.wait(1)
	event.finish_event()
end

--- Helper function.
local function helper_16a8c()
	local var4: s32 = 0
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(336, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(112)
		event.load_map_sounds(3823)
		var4 = event.load_sound_effect_file_2(3823) or var4
		helper_147b4()
		time = event.get_scene_time_of_day() or time
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 1, "半口")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-303.43, 42.35, -704.35)
		event.set_camera_sequence_look_at(-137.93, 52.07, -827.54)
		event.set_object_sequence_position(2, -71.03, 0.0, -852.13)
		event.set_object_sequence_rotation(2, 0.0, -3.312, 0.0)
		event.set_object_sequence_position(0, -51.68, 0.0, -885.58)
		event.set_object_sequence_rotation(0, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(1, -92.78, 0.0, -885.46)
		event.set_object_sequence_rotation(1, 0.0, 2.96, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.fade_in_screen(30)
		at = 3
		wait_frames(120)
		event.start_crossfade(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(-102.49, 15.34, -957.31)
		event.set_camera_sequence_look_at(-71.83, 20.94, -886.5)
		at = 4
		wait_frames(120)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(240)
		event.add_camera_sequence_path_point(-157.91, 17.6, -857.92, 44.13, 27.32, -844.52)
		event.add_camera_sequence_path_point(-109.74, 17.6, -854.73, 44.13, 27.32, -844.52)
		event.start_camera_sequence_path()
		at = 5
		wait_frames(40)
		event.play_sound_effect(var4, 2)
		event.fade_out_screen(5, 255, 255, 255)
		at = 6
		wait_frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 1)
		at = 7
		wait_frames(15)
		event.play_sound_effect(var4, 2)
		event.fade_out_screen(5, 255, 255, 255)
		at = 8
		wait_frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 0)
		at = 9
		wait_frames(40)
		event.play_sound_effect(var4, 2)
		event.fade_out_screen(5, 255, 255, 255)
		at = 10
		wait_frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 1)
		at = 11
		wait_frames(15)
		event.play_sound_effect(var4, 2)
		event.fade_out_screen(5, 255, 255, 255)
		at = 12
		wait_frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 0)
		at = 13
		wait_frames(40)
		event.play_sound_effect(var4, 2)
		event.fade_out_screen(5, 255, 255, 255)
		at = 14
		wait_frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 1)
		at = 15
		wait_frames(15)
		event.play_sound_effect(var4, 2)
		event.fade_out_screen(5, 255, 255, 255)
		at = 16
		wait_frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 0)
		event.set_camera_sequence_position(-86.68, 23.43, -938.64)
		event.set_camera_sequence_look_at(-64.82, 27.32, -852.79)
		event.set_object_sequence_motion(2, "頭かかえ", 6)
		event.queue_object_sequence_next_motion(2, "頭かかえL", 4)
		event.delay_object_sequence_motion_track(0, 30)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, var4, 3)
		event.set_object_sequence_motion(0, "左・振り返り", 6)
		event.queue_object_sequence_next_motion(0, "左・振り返りL", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "振りかえり", 6)
		event.queue_object_sequence_next_motion(1, "振りかえりL", 4)
		at = 17
		helper_1584c528(3360020, -1)
		at = 18
		helper_1584c528(3360030, -1)
		event.set_motion_blur(60)
		event.set_camera_sequence_position(-76.1, 46.54, -770.39)
		event.set_camera_sequence_look_at(-70.1, 27.32, -860.66)
		event.set_object_sequence_rotation(0, 0.0, -0.48, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.44, 0.0)
		event.move_camera_sequence(-157.21, 46.54, 449.93, -70.1, 27.32, -860.66, 90)
		event.play_sound_effect(var4, 4)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(0, -54.72, 0.0, -869.17, 15, 1)
		event.move_object_sequence(1, -84.82, 0.0, -874.03, 15, 1)
		at = 19
		wait_objects(0)
		at = 20
		wait_objects(1)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(60)
		event.fade_out_camera_sequence(30, 255.0, 255.0, 255.0)
		at = 21
		wait_camera()
		event.set_motion_blur(0)
		at = 22
		wait_frames(30)
		event.delete_character(9)
		event.load_character(5, "event/e300/e336/e336_crest.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(6, 11)
		event.clear_object_sequence(4, 11)
		event.set_object_sequence_object(4, 6)
		event.load_character(5, "event/e300/e336/e336_lin2.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(4, 9)
		event.clear_object_sequence(2, 9)
		event.set_object_sequence_object(2, 4)
		event.set_time_of_day(12.0)
		event.set_time_of_day_advancing(0)
		event.play_music(0)
		event.set_camera_sequence_position(-297.31, 603.3, -529.44)
		event.set_camera_sequence_look_at(-114.1, 586.6, -822.33)
		event.move_camera_sequence_eased(-297.31, 51.86, -529.44, -114.1, 35.16, -822.33, 240, 2, 0.2)
		event.set_character_active(0, 13)
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(1, 9)
		event.set_character_active(1, 11)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(4, "立ち2", 4)
		event.set_object_sequence_position(4, -51.68, 0.0, -885.58)
		event.set_object_sequence_rotation(4, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(2, -76.82, 0.0, -887.22)
		event.set_object_sequence_rotation(2, 0.0, 1.76, 0.0)
		event.fade_in_camera_sequence(60, 255.0, 255.0, 255.0)
		at = 23
		wait_camera()
		at = 24
		wait_frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(-56.27, 12.94, -955.94)
		event.set_camera_sequence_look_at(-64.49, 18.56, -881.94)
		event.move_camera_sequence_eased(-29.91, 12.94, -940.74, -64.49, 18.56, -881.94, 600, 2, 0.1)
		event.play_sound_effect(var4, 5)
		event.set_object_sequence_motion(2, "右向く", 6)
		event.queue_object_sequence_next_motion(2, "右向くL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 25
		helper_4116e6bb(3360040)
		at = 26
		wait_objects(2)
		event.set_object_sequence_motion(4, "左を見る", 6)
		event.queue_object_sequence_next_motion(4, "左を見るL", 6)
		event.queue_object_sequence_next_motion(4, "考える", 6)
		event.queue_object_sequence_next_motion(4, "考えるL", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 27
		helper_4116e6bb(3360050)
		at = 28
		wait_objects(4)
		event.set_object_sequence_motion(4, "考える戻り", 6)
		event.queue_object_sequence_next_motion(4, "左を見るL", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 29
		helper_4116e6bb(3360055)
		at = 30
		wait_objects(4)
		at = 31
		wait_frames(30)
		event.clear_camera_sequence()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "大わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(-31.38, 30.21, -910.26)
		event.set_camera_sequence_look_at(-87.35, 19.34, -871.43)
		event.move_camera_sequence_eased(-29.12, 30.21, -907.0, -85.09, 19.34, -868.17, 600, 2, 0.1)
		event.set_object_sequence_motion(2, "腰に手", 6)
		event.queue_object_sequence_next_motion(2, "腰に手会話", 2)
		event.queue_object_sequence_next_motion(2, "腰に手L", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 32
		helper_4116e6bb(3360060)
		event.play_sound_effect(var4, 7)
		event.set_object_sequence_motion(4, "笑い", 6)
		event.queue_object_sequence_next_motion(4, "笑いL", 2)
		event.queue_object_sequence_next_motion(4, "笑い戻り", 6)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "わらい目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目～通常目")
		event.delay_object_sequence_texture_animation_track(30)
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_mouth_texture_animations(6, "わらい口パク")
		at = 33
		helper_4116e6bb(3360070)
		event.reset_mouth_texture_animations()
		at = 34
		wait_frames(30)
		event.set_object_sequence_motion(4, "会話2", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 35
		helper_4116e6bb(3360080)
		event.reset_mouth_texture_animations()
		at = 36
		wait_frames(30)
		event.clear_camera_sequence()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-80.0, 6.0, -766.5)
		event.set_camera_sequence_look_at(-80.0, 23.0, -889.39)
		event.move_camera_sequence_eased(-56.0, 6.0, -766.5, -56.0, 23.0, -889.39, 210, 2, 0.1)
		at = 37
		helper_4116e6bb(3360090)
		event.clear_camera_sequence()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-56.38, 6.57, -939.5)
		event.set_camera_sequence_look_at(-65.1, 23.91, -871.04)
		event.set_object_sequence_rotation(2, 0.0, 2.84, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(4, "会話3", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 38
		helper_4116e6bb(3360100)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 6)
		event.set_object_sequence_motion(2, "うーん", 6)
		event.queue_object_sequence_next_motion(2, "うーんL", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "無表情")
		event.set_object_sequence_texture_animation(2, 1, "前向き～左向き")
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 39
		helper_4116e6bb(3360110)
		event.reset_mouth_texture_animations()
		at = 40
		wait_frames(30)
		event.set_object_sequence_rotation(2, 0.0, 1.76, 0.0)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_camera_sequence_position(-78.92, 13.21, -914.21)
		event.set_camera_sequence_look_at(-33.74, 32.68, -868.91)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(4, "会話3", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 41
		helper_4116e6bb(3360120)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128, 128, 128, 128, 30)
		event.set_object_sequence_motion(4, "会話3", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 42
		helper_4116e6bb(3360130)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(11, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 43
		helper_4116e6bb(3360140)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 44
		helper_4116e6bb(3360145)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(12, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 45
		helper_4116e6bb(3360150)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 46
		helper_4116e6bb(3360155)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 47
		helper_4116e6bb(3360160)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 48
		helper_4116e6bb(3360165)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(13, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 49
		helper_4116e6bb(3360170)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 50
		helper_4116e6bb(3360175)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 51
		helper_4116e6bb(3360180)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 52
		helper_4116e6bb(3360185)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 53
		helper_4116e6bb(3360190)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 54
		helper_4116e6bb(3360200)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 55
		helper_4116e6bb(3360205)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_object_sequence_color(13, 128, 128, 128, 0, 30)
		at = 56
		wait_frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "わらい目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(-2.61, 26.27, -934.98)
		event.set_camera_sequence_look_at(-85.09, 13.74, -868.17)
		event.set_object_sequence_motion(2, "右向くL", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		event.set_object_sequence_motion(4, "会話3", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		at = 57
		helper_4116e6bb(3360210)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 58
		helper_4116e6bb(3360220)
		event.reset_mouth_texture_animations()
		at = 59
		wait_frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "大わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "わらい目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(-64.24, 26.65, -742.64)
		event.set_camera_sequence_look_at(-63.35, 32.68, -885.22)
		event.move_camera_sequence_eased(-64.42, 26.65, -682.97, -63.35, 32.68, -885.22, 600, 2, 0.1)
		event.set_object_sequence_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(4, "わらい口パク")
		at = 60
		helper_4116e6bb(3360230)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "会話2", 2)
		event.queue_object_sequence_next_motion(4, "左を見る", 6)
		event.queue_object_sequence_next_motion(4, "左を見るL", 4)
		event.set_mouth_texture_animations(6, "わらい口パク")
		at = 61
		helper_4116e6bb(3360240)
		event.set_object_sequence_texture_animation(4, 1, "わらい口パク")
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.play_sound_effect(var4, 7)
		event.set_object_sequence_motion(4, "笑い", 6)
		event.queue_object_sequence_next_motion(4, "笑いL", 4)
		at = 62
		helper_1584c528(3360245, -1)
		event.fade_out_camera_sequence(30, 255.0, 255.0, 255.0)
		event.fade_out_music(30)
		at = 63
		wait_frames(30)
		event.stop_music(0)
		event.clear_camera_sequence()
		event.delete_character(9)
		event.set_character_active(0, 11)
		event.load_character(5, "event/e300/e336/e336_me.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(5, 10)
		event.clear_object_sequence(3, 10)
		event.set_object_sequence_object(3, 5)
		event.load_character(5, "event/e300/e336/e336_lin.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(4, 9)
		event.clear_object_sequence(2, 9)
		event.set_object_sequence_object(2, 4)
		event.load_character(5, "event/e300/e336/e336_rin_kemuri.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(7, 16)
		event.clear_object_sequence(7, 16)
		event.set_object_sequence_object(7, 7)
		event.set_time_of_day(time)
		event.set_time_of_day_advancing(1)
		event.set_camera_sequence_position(-114.47, 17.08, -834.34)
		event.set_camera_sequence_look_at(-71.89, 20.6, -808.25)
		event.set_character_active(1, 13)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 9)
		event.set_character_active(1, 16)
		event.set_character_active(1, 10)
		event.set_object_sequence_scale(3, 0.0, 0.0, 0.0, 0)
		event.set_character_visible(16, 0)
		event.set_object_sequence_position(2, -74.74, 0.0, -806.3)
		event.set_object_sequence_rotation(2, 0.0, -3.312, 0.0)
		event.set_object_sequence_position(7, -74.74, 0.0, -806.3)
		event.set_object_sequence_rotation(7, 0.0, -3.312, 0.0)
		event.set_object_sequence_position(3, -76.09, 22.0, -809.66)
		event.set_object_sequence_rotation(3, 0.0, -3.312, 0.0)
		event.set_object_sequence_position(0, -51.68, 0.0, -885.58)
		event.set_object_sequence_rotation(0, 0.0, -0.32, 0.0)
		event.set_object_sequence_position(1, -92.78, 0.0, -885.46)
		event.set_object_sequence_rotation(1, 0.0, 0.2, 0.0)
		event.set_object_sequence_motion(2, "頭かかえL", 4)
		event.set_object_sequence_motion(7, "頭かかえL", 4)
		event.fade_in_camera_sequence(60, 255.0, 255.0, 255.0)
		event.play_sound_effect(var4, 8)
		at = 64
		wait_frames(15)
		event.set_character_visible(16, 1, 1, 0.0125)
		at = 65
		helper_4116e6bb(3360250)
		event.move_camera_sequence_eased(-102.78, 34.32, -836.68, -71.89, 27.85, -808.25, 120, 0, 0.4)
		event.play_sound_effect(var4, 9)
		event.set_object_sequence_scale(3, 0.25, 0.25, 0.25, 180)
		at = 66
		wait_frames(150)
		at = 67
		wait_frames(30)
		event.set_object_sequence_scale(3, 1.25, 1.25, 1.25, 240)
		event.set_camera_sequence_position(-64.41, 9.43, -967.48)
		event.set_camera_sequence_look_at(-76.6, 52.07, -819.83)
		event.set_object_sequence_motion(0, "上見驚き", 6)
		event.set_object_sequence_motion(1, "上驚き", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 68
		wait_frames(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 69
		helper_4116e6bb(3360260)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 70
		helper_4116e6bb(3360270)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_scale(3, 1.75, 1.75, 1.75, 240)
		at = 71
		wait_frames(30)
		event.set_camera_sequence_position(-224.41, 16.45, -978.74)
		event.set_camera_sequence_look_at(-76.09, 69.2, -809.66)
		at = 72
		wait_frames(15)
		event.move_camera_sequence_eased(-296.34, 16.45, -752.06, -76.09, 69.2, -809.66, 240, 0, 0.4)
		at = 73
		helper_4116e6bb(3360280)
		at = 74
		helper_4116e6bb(3360290)
		at = 75
		wait_camera()
		at = 76
		wait_frames(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-52.97, 41.64, -777.44)
		event.set_camera_sequence_look_at(-80.22, 14.54, -868.17)
		at = 77
		wait_frames(15)
		event.move_object_sequence(3, -76.09, 48.73, -809.66, 5, 0)
		event.play_sound_effect(var4, 10)
		event.set_object_sequence_motion(0, "上見驚き", 6)
		event.set_object_sequence_motion(1, "上驚き", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.stop_sound_effect(var4, 9)
		at = 78
		wait_frames(30)
		event.fade_out_screen(30)
		at = 79
		wait_frames(30)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.delete_character(10)
		event.set_character_active(0, 9)
		event.set_character_active(0, 16)
		event.load_character(5, "dungeon/monster/e220a.gltf", "e220a", 10)
		event.set_character_active(1, 10)
		event.attach_object_handle_to_character(5, 10)
		event.clear_object_sequence(3, 10)
		event.set_object_sequence_object(3, 5)
		event.load_music(190)
		event.set_object_sequence_position(3, -102.77, 0.0, -720.48)
		event.set_object_sequence_rotation(3, 0.0, -3.312, 0.0)
		event.set_object_sequence_motion(3, "攻撃１", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_camera_sequence_position(-164.4, 14.41, -665.54)
		event.set_camera_sequence_look_at(-24.29, 14.54, -859.25)
		at = 80
		wait_frames(15)
		event.fade_in_screen(30)
		at = 81
		wait_frames(15)
		event.play_music(0)
		event.shake_camera_sequence(0.0, 0.3, 0.0, 90)
		event.play_sound_effect(var4, 11)
		at = 82
		wait_frames(90)
		at = 83
		wait_frames(30)
		event.set_camera_sequence_position(-129.58, 12.28, -799.76)
		event.set_camera_sequence_look_at(-95.81, 20.0, -706.37)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.move_camera_sequence_eased(-129.58, 41.07, -799.76, -95.81, 48.78, -706.37, 120, 0, 0.4)
		at = 84
		wait_frames(90)
		event.set_event_sprite_draw_pass(5, 1)
		event.set_object_sequence_color(15, 128, 128, 128, 128, 30)
		event.set_object_sequence_motion(3, "遊び", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.play_sound_effect(var4, 12)
		at = 85
		wait_camera()
		event.set_object_sequence_color(15, 128, 128, 128, 0, 30)
		at = 86
		wait_frames(30)
		at = 87
		wait_frames(30)
		event.set_character_active(1, 14)
		event.set_character_active(1, 15)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 1)
		event.set_camera_sequence_position(-29.29, 6.3, -834.76)
		event.set_camera_sequence_look_at(-76.21, 19.78, -889.08)
		event.set_object_sequence_motion(0, "バトル立ち", 4)
		event.set_object_sequence_motion(1, "バトル立ち", 4)
		at = 88
		wait_frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 89
		helper_4116e6bb(3360310)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 13)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "バトル立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 90
		helper_4116e6bb(3360320)
		event.reset_mouth_texture_animations()
		at = 91
		wait_frames(60)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(4)
		end
		if at <= 2 then
			helper_22500000()
			wait_frames_skipping(120)
		end
		if at <= 3 then
			wait_frames_skipping(120)
		end
		if at <= 4 then
			wait_frames_skipping(40)
		end
		if at <= 5 then
			wait_frames_skipping(5)
		end
		if at <= 6 then
			wait_frames_skipping(15)
		end
		if at <= 7 then
			wait_frames_skipping(5)
		end
		if at <= 8 then
			wait_frames_skipping(40)
		end
		if at <= 9 then
			wait_frames_skipping(5)
		end
		if at <= 10 then
			wait_frames_skipping(15)
		end
		if at <= 11 then
			wait_frames_skipping(5)
		end
		if at <= 12 then
			wait_frames_skipping(40)
		end
		if at <= 13 then
			wait_frames_skipping(5)
		end
		if at <= 14 then
			wait_frames_skipping(15)
		end
		if at <= 15 then
			wait_frames_skipping(5)
		end
		if at <= 16 then
			helper_52aadc70(3360020, -1)
		end
		if at <= 17 then
			helper_52aadc70(3360030, -1)
		end
		if at <= 18 then
			helper_238b5abc(0)
		end
		if at <= 19 then
			helper_238b5abc(1)
		end
		if at <= 20 then
			helper_344d6cd8()
		end
		if at <= 21 then
			wait_frames_skipping(30)
		end
		if at <= 22 then
			helper_344d6cd8()
		end
		if at <= 23 then
			wait_frames_skipping(30)
		end
		if at <= 24 then
			helper_8cd371d7(3360040)
		end
		if at <= 25 then
			helper_238b5abc(2)
		end
		if at <= 26 then
			helper_8cd371d7(3360050)
		end
		if at <= 27 then
			helper_238b5abc(4)
		end
		if at <= 28 then
			helper_8cd371d7(3360055)
		end
		if at <= 29 then
			helper_238b5abc(4)
		end
		if at <= 30 then
			wait_frames_skipping(30)
		end
		if at <= 31 then
			helper_8cd371d7(3360060)
		end
		if at <= 32 then
			helper_8cd371d7(3360070)
		end
		if at <= 33 then
			wait_frames_skipping(30)
		end
		if at <= 34 then
			helper_8cd371d7(3360080)
		end
		if at <= 35 then
			wait_frames_skipping(30)
		end
		if at <= 36 then
			helper_8cd371d7(3360090)
		end
		if at <= 37 then
			helper_8cd371d7(3360100)
		end
		if at <= 38 then
			helper_8cd371d7(3360110)
		end
		if at <= 39 then
			wait_frames_skipping(30)
		end
		if at <= 40 then
			helper_8cd371d7(3360120)
		end
		if at <= 41 then
			helper_8cd371d7(3360130)
		end
		if at <= 42 then
			helper_8cd371d7(3360140)
		end
		if at <= 43 then
			helper_8cd371d7(3360145)
		end
		if at <= 44 then
			helper_8cd371d7(3360150)
		end
		if at <= 45 then
			helper_8cd371d7(3360155)
		end
		if at <= 46 then
			helper_8cd371d7(3360160)
		end
		if at <= 47 then
			helper_8cd371d7(3360165)
		end
		if at <= 48 then
			helper_8cd371d7(3360170)
		end
		if at <= 49 then
			helper_8cd371d7(3360175)
		end
		if at <= 50 then
			helper_8cd371d7(3360180)
		end
		if at <= 51 then
			helper_8cd371d7(3360185)
		end
		if at <= 52 then
			helper_8cd371d7(3360190)
		end
		if at <= 53 then
			helper_8cd371d7(3360200)
		end
		if at <= 54 then
			helper_8cd371d7(3360205)
		end
		if at <= 55 then
			wait_frames_skipping(30)
		end
		if at <= 56 then
			helper_8cd371d7(3360210)
		end
		if at <= 57 then
			helper_8cd371d7(3360220)
		end
		if at <= 58 then
			wait_frames_skipping(30)
		end
		if at <= 59 then
			helper_8cd371d7(3360230)
		end
		if at <= 60 then
			helper_8cd371d7(3360240)
		end
		if at <= 61 then
			helper_52aadc70(3360245, -1)
		end
		if at <= 62 then
			wait_frames_skipping(30)
		end
		if at <= 63 then
			wait_frames_skipping(15)
		end
		if at <= 64 then
			helper_8cd371d7(3360250)
		end
		if at <= 65 then
			wait_frames_skipping(150)
		end
		if at <= 66 then
			wait_frames_skipping(30)
		end
		if at <= 67 then
			wait_frames_skipping(30)
		end
		if at <= 68 then
			helper_8cd371d7(3360260)
		end
		if at <= 69 then
			helper_8cd371d7(3360270)
		end
		if at <= 70 then
			wait_frames_skipping(30)
		end
		if at <= 71 then
			wait_frames_skipping(15)
		end
		if at <= 72 then
			helper_8cd371d7(3360280)
		end
		if at <= 73 then
			helper_8cd371d7(3360290)
		end
		if at <= 74 then
			helper_344d6cd8()
		end
		if at <= 75 then
			wait_frames_skipping(30)
		end
		if at <= 76 then
			wait_frames_skipping(15)
		end
		if at <= 77 then
			wait_frames_skipping(30)
		end
		if at <= 78 then
			wait_frames_skipping(30)
		end
		if at <= 79 then
			wait_frames_skipping(15)
		end
		if at <= 80 then
			wait_frames_skipping(15)
		end
		if at <= 81 then
			wait_frames_skipping(90)
		end
		if at <= 82 then
			wait_frames_skipping(30)
		end
		if at <= 83 then
			wait_frames_skipping(90)
		end
		if at <= 84 then
			helper_344d6cd8()
		end
		if at <= 85 then
			wait_frames_skipping(30)
		end
		if at <= 86 then
			wait_frames_skipping(30)
		end
		if at <= 87 then
			wait_frames_skipping(15)
		end
		if at <= 88 then
			helper_8cd371d7(3360310)
		end
		if at <= 89 then
			helper_8cd371d7(3360320)
		end
		if at <= 90 then
			wait_frames_skipping(60)
		end
		return true
	end)
	at = 92
	vm.entry(92)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 93
	wait_frames(30)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.set_motion_blur(0)
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	at = 94
	vm.wait(94)
	at = 95
	helper_14140()
end

--- Helper function.
local function helper_1e96c()
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
		global1 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e300/e340/e340_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 1, "info", global1, 14)
		event.load_equipment_model(5, 1, 0, "info", global1, 15)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e340/e340_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 13)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 1, "info", global0, 14)
		event.load_equipment_model(5, 0, 0, "info", global0, 15)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e300/e340/e340_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e340/e340_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e300/e340/e340_lin.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(4, 11)
	event.clear_object_sequence(2, 11)
	event.set_object_sequence_object(2, 4)
	event.load_character(5, "dungeon/monster/e220a.gltf", "e220a", 12)
	event.set_character_active(0, 12)
	event.attach_object_handle_to_character(5, 12)
	event.clear_object_sequence(3, 12)
	event.set_object_sequence_object(3, 5)
	event.load_character(5, "event/e300/e340/e340_mem_kieru.gltf", "info", 16)
	event.set_character_active(0, 16)
	event.set_character_active(1, 14)
	event.set_character_active(1, 15)
	event.load_message_file(0, 5, "event/e300/e340/e340_1.txt")
end

--- Helper function.
local function helper_22e00000()
	local var0: s32 = 0
	local _ = var0 == 2
	var0 = 0
	local _ = var0 == 3
	var0 = 1
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_1e43c()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
	end
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(16)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
end

--- Helper function.
local function helper_1fc10()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(340, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(0)
		event.stop_music(0)
		at = 2
		vm.wait(2)
		at = 3
		vm.wait(3)
		at = 4
		vm.wait(4)
		at = 5
		vm.wait(5)
		helper_1e96c()
		event.load_map_sounds(3826)
		var4 = event.load_sound_effect_file_2(3826) or var4
		event.load_music(49)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "無表情")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 11)
		event.set_character_active(1, 12)
		event.set_camera_sequence_position(-559.26, 65.75, -328.45)
		event.set_camera_sequence_look_at(-142.53, 58.24, -796.93)
		event.set_object_sequence_position(2, -142.0, 0.0, -1031.0)
		event.set_object_sequence_rotation(2, 0.0, -0.36, 0.0)
		event.set_object_sequence_position(3, -296.82, 0.0, -544.32)
		event.set_object_sequence_rotation(3, 0.0, -1.72, 0.0)
		event.set_character_position(16, -296.82, 0.0, -544.32)
		event.set_character_rotation(16, 0.0, -1.72, 0.0)
		event.set_object_sequence_position(0, -439.61, 0.0, -561.58)
		event.set_object_sequence_rotation(0, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(1, -441.56, 0.0, -520.65)
		event.set_object_sequence_rotation(1, 0.0, 0.8, 0.0)
		event.set_object_sequence_motion(0, "バトル立ち", 4)
		event.set_object_sequence_motion(1, "バトル立ち", 4)
		event.set_object_sequence_motion(2, "座り", 4)
		event.set_object_sequence_motion(3, "死に", 2)
		event.set_character_active(1, 16)
		event.fade_in_screen(30)
		at = 6
		wait_frames(15)
		event.play_sound_effect(var4, 2)
		at = 7
		wait_frames(30)
		event.set_character_visible(12, 0, 1, 0.025)
		event.set_character_visible(16, 0, 1, 0.025)
		event.play_sound_effect(var4, 3)
		at = 8
		wait_frames(90)
		event.set_character_active(0, 12)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.set_object_sequence_motion(0, "走り")
		event.set_object_sequence_motion(1, "走り")
		event.set_object_sequence_position(0, -231.36, 0.0, -872.18)
		event.set_object_sequence_rotation(0, 0.0, 2.52, 0.0)
		event.set_object_sequence_position(1, -176.93, 0.0, -859.14)
		event.set_object_sequence_rotation(1, 0.0, 2.96, 0.0)
		event.move_object_sequence(0, -178.43, 0.0, -986.22, 90, 1)
		event.move_object_sequence(1, -152.11, 0.0, -973.42, 90, 1)
		event.set_camera_sequence_position(-198.82, 54.44, -881.4)
		event.set_camera_sequence_look_at(-144.13, 15.05, -1023.93)
		at = 9
		wait_objects(0)
		at = 10
		wait_objects(1)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.set_camera_sequence_position(-76.1, 10.61, -1046.48)
		event.set_camera_sequence_look_at(-132.11, 15.05, -1017.56)
		event.play_music(0)
		at = 11
		wait_frames(60)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 12
		helper_4116e6bb(3400010)
		event.reset_mouth_texture_animations()
		at = 13
		wait_frames(60)
		event.set_object_sequence_motion(2, "顔上げ", 6)
		event.queue_object_sequence_next_motion(2, "顔上げL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 14
		helper_4116e6bb(3400015)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 15
		helper_4116e6bb(3400020)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 16
		helper_4116e6bb(3400025)
		event.reset_mouth_texture_animations()
		at = 17
		wait_frames(30)
		event.set_camera_sequence_position(-160.43, 21.01, -1099.02)
		event.set_camera_sequence_look_at(-150.14, 15.05, -994.77)
		at = 18
		wait_frames(15)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 19
		helper_4116e6bb(3400030)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_object_sequence_motion(0, "右向く会話", 2)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 20
		helper_4116e6bb(3400040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		at = 21
		helper_4116e6bb(3400050)
		at = 22
		wait_frames(15)
		event.play_sound_effect(var4, 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "立ちあがる", 1)
		event.set_object_sequence_motion(2, "立ちあがる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_camera_sequence_position(-174.6, 3.67, -986.98)
		event.set_camera_sequence_look_at(-146.07, 14.84, -1024.36)
		at = 23
		helper_1584c528(3400060, -1)
		at = 24
		wait_frames(30)
		event.set_camera_sequence_position(-153.96, 18.46, -1073.61)
		event.set_camera_sequence_look_at(-151.84, 23.17, -999.4)
		at = 25
		wait_frames(60)
		event.set_object_sequence_motion(2, "うなづく", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.play_sound_effect(var4, 5)
		event.play_sound_effect(var4, 6)
		at = 26
		helper_4116e6bb(3400070)
		at = 27
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 5 then
			helper_22e00000()
			wait_frames_skipping(15)
		end
		if at <= 6 then
			wait_frames_skipping(30)
		end
		if at <= 7 then
			wait_frames_skipping(90)
		end
		if at <= 8 then
			helper_238b5abc(0)
		end
		if at <= 9 then
			helper_238b5abc(1)
		end
		if at <= 10 then
			wait_frames_skipping(60)
		end
		if at <= 11 then
			helper_8cd371d7(3400010)
		end
		if at <= 12 then
			wait_frames_skipping(60)
		end
		if at <= 13 then
			helper_8cd371d7(3400015)
		end
		if at <= 14 then
			helper_8cd371d7(3400020)
		end
		if at <= 15 then
			helper_8cd371d7(3400025)
		end
		if at <= 16 then
			wait_frames_skipping(30)
		end
		if at <= 17 then
			wait_frames_skipping(15)
		end
		if at <= 18 then
			helper_8cd371d7(3400030)
		end
		if at <= 19 then
			helper_8cd371d7(3400040)
		end
		if at <= 20 then
			helper_8cd371d7(3400050)
		end
		if at <= 21 then
			wait_frames_skipping(15)
		end
		if at <= 22 then
			helper_52aadc70(3400060, -1)
		end
		if at <= 23 then
			wait_frames_skipping(30)
		end
		if at <= 24 then
			wait_frames_skipping(60)
		end
		if at <= 25 then
			helper_8cd371d7(3400070)
		end
		if at <= 26 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 28
	vm.entry(28)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 29
	wait_frames(30)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_port_sound_effects(4)
	at = 30
	vm.wait(30)
	at = 31
	helper_1e43c()
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_22a84()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var2: any = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	local active_chr_no_2: s32 = 0
	local flag_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 20, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			at = 3
			wait_frames(10)
			event.set_character_position(0, 951.18, 106.54, 1509.16)
			event.set_character_rotation(0, 0.0, -3.13, 0.0)
			event.set_camera_position(951.95, 133.23, 1642.83)
			event.set_camera_look_at(951.18, 136.54, 1509.16)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		flag = event.get_save_flag(340) or flag
		if flag == 1 then
			at = 4
			var2 = helper_ed4dc120(1, -1)
			event.attach_object_handle_to_character(0, 0)
			event.set_object_handle_footstep_sound(0, 1)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			if var2 == 0 then
				event.fade_out_screen(30)
				at = 5
				wait_frames(30)
				return 1
			else
				do
					local out1, out2, out3 = event.get_character_position(0)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				var6 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var3)
				var7 = var4
				var8 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var5)
				event.move_object_sequence(0, var6, var7, var8, 30, 1)
				event.turn_object_sequence_toward(0, var6, var7, var8, 10)
				event.set_object_sequence_motion(0, "歩き")
				var9 = 0
				while var9 < 30 do
					do
						local out1, out2, out3 = event.get_character_position(0)
						var3 = out1 or var3
						var4 = out2 or var4
						var5 = out3 or var5
					end
					var4 = vm.f32(var4 + 30.0)
					event.set_camera_look_at(var3, var4, var5)
					var9 = var9 + 1
					at = 6
					vm.wait(6)
				end
				event.reset_follow_camera(0)
				event.finish_event()
			end
		else
			event.attach_object_handle_to_character(0, 0)
			event.set_object_handle_footstep_sound(0, 1)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			do
				local out1, out2, out3 = event.get_character_position(0)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			var13 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var10)
			var14 = var11
			var15 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var12)
			event.move_object_sequence(0, var13, var14, var15, 30, 1)
			event.turn_object_sequence_toward(0, var13, var14, var15, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 30)
			event.set_object_sequence_motion(0, "立ち")
			var16 = 0
			while var16 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var10 = out1 or var10
					var11 = out2 or var11
					var12 = out3 or var12
				end
				var11 = vm.f32(var11 + 30.0)
				event.set_camera_look_at(var10, var11, var12)
				var16 = var16 + 1
				at = 7
				vm.wait(7)
			end
			event.reset_follow_camera(0)
			active_chr_no_2 = event.get_playable_character() or active_chr_no_2
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
			event.set_message_bubble_tail(0, 0)
			flag_2 = event.get_save_flag(330) or flag_2
			if flag_2 == 0 then
				if active_chr_no_2 == 0 then
					event.open_message_window_2(0, "Me preocupa Lin.\nMejor no seguimos de momento.")
				else
					event.open_message_window_2(0, "Me preocupa Lin.\nMejor no seguimos de momento.")
				end
			elseif active_chr_no_2 == 0 then
				event.open_message_window_2(
					0,
					"Oye, M[UNI00f3]nica,\n[UNI00bf]por qu[UNI00e9] no descansamos junto al [UNI00c1]rbol Yorda un rato?\nSeguro que Lin tambi[UNI00e9]n est[UNI00e1] cansada."
				)
			else
				event.open_message_window_2(
					0,
					"Max, oye,\n[UNI00bf]podemos descansar junto al [UNI00c1]rbol Yorda un rato?\nSeguro que Lin tambi[UNI00e9]n est[UNI00e1] cansada."
				)
			end
			at = 8
			helper_75684dd8(0, -1, 5, 0, 0)
			event.set_message_bubble_tail(0, 1)
			event.finish_event()
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				wait_frames_skipping(10)
			end
			return 0
		end
		if at <= 5 then
			if at == 4 then
				var2 = received[1] :: number
			end
			if at <= 4 then
				wait_frames_skipping(30)
			end
			return 1
		end
		if at <= 8 then
			if at <= 6 then
				var13 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var10)
				var14 = var11
				var15 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var12)
				var16 = 0
				var11 = vm.f32(var11 + 30.0)
				local _ = var16 < 30
				var16 = var16 + 1
			end
			if at <= 7 then
				helper_ee1c51d0(0, -1, 5, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.initialize_event()
	event_99()
	event.fade_out_screen(0)
	flag = event.get_save_flag(300) or flag
	flag_2 = event.get_save_flag(332) or flag_2
	if flag == 1 then
		if flag_2 == 0 then
			helper_11cb4()
			helper_9dafbc83(0.0, 0.0, -600.0, vm.f32(3.14))
			event.set_camera_look_at(0.0, 30.0, -600.0)
			event.set_camera_position(0.0, 40.0, -480.0)
			event.reset_follow_camera(0)
			helper_7f487db5(1)
			event.fade_in_screen(20)
			event.finish_event()
			return
		else
			helper_363cdfbf()
		end
	end
	helper_9dafbc83(-1306.0, vm.f32(200.39), -546.0, vm.f32(1.88))
	event.set_camera_position(-1182.17, 240.83, -585.56)
	event.set_camera_look_at(-1306.0, 230.83, -546.0)
	event.reset_follow_camera(0)
	helper_7f487db5(1)
	event.fade_in_screen(20)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_16a8c

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.clear_event_battle_monsters(-1)
		event.set_save_control_bits(1, 0)
		event.attach_object_handle_to_map_part_3(0, "p01_s18", "s18_02-a0")
		event.set_object_handle_visible(0, 0)
		at = 2
		helper_1fc10()
		event.play_music(0)
		helper_7d7eee8f(vm.f32(-65.93), 0.0, vm.f32(-944.95), vm.f32(1.07))
		event.set_camera_position(-175.81, 28.77, -1006.32)
		event.set_camera_look_at(-65.93, 30.0, -944.95)
		event.reset_follow_camera(0)
		helper_7f487db5(1)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_1fc10()
				return vm.continue_with(function()
					event.play_music(0)
					helper_7d7eee8f(vm.f32(-65.93), 0.0, vm.f32(-944.95), vm.f32(1.07))
					event.set_camera_position(-175.81, 28.77, -1006.32)
					event.set_camera_look_at(-65.93, 30.0, -944.95)
					event.reset_follow_camera(0)
					helper_7f487db5(1)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			helper_43f02c95(vm.f32(-65.93), 0.0, vm.f32(-944.95), vm.f32(1.07))
			helper_4a9b8bc5(1)
			return 0
		end
		return nil
	end)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	if helper_22a84() ~= 0 then
		helper_7f487db5(0)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var1 = event.get_dungeon_floor() or var1
		argc = event.get_dungeon_next_floor(var1, 0) or argc
		event.set_dungeon_floor(argc)
		event.set_dungeon_floor_info(stage_id, var1, 5, 2)
		event.set_dungeon_floor_info(stage_id, argc, 5, 1)
		event.set_character_position(0, 0.0, 0.0, 0.0)
		event.load_event_script("d03/d03.stb", 1000)
		return
	end
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		helper_7f487db5(0)
		event.set_function_point_enabled("", "e336", 0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		at = 2
		helper_16a8c()
		event.set_save_control_bits(1, 1)
		event.attach_object_handle_to_map_part_3(30, "p01_s18", "s18_02-a0")
		event.set_object_handle_visible(30, 1)
		var1 = event.get_active_music_number() or var1
		if var1 ~= 190 then
			event.stop_music(0)
			at = 3
			wait_frames(4)
			event.load_music(190)
		end
		event.play_music(0)
		event.load_dungeon_monster(68, 1)
		event.place_dungeon_monster(68, 0.0, 0.0, 0.0, 0.0, 3.14, 0.0)
		helper_9dafbc83(0.0, 0.0, -100.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, -100.0)
		event.set_camera_position(0.0, 40.0, -220.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_4a9b8bc5(0)
				at = 2
				helper_16a8c()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 1)
					event.attach_object_handle_to_map_part_3(30, "p01_s18", "s18_02-a0")
					event.set_object_handle_visible(30, 1)
					var1 = event.get_active_music_number() or var1
					if var1 ~= 190 then
						event.stop_music(0)
						at = 3
						wait_frames(4)
						event.load_music(190)
					end
					event.play_music(0)
					event.load_dungeon_monster(68, 1)
					event.place_dungeon_monster(68, 0.0, 0.0, 0.0, 0.0, 3.14, 0.0)
					helper_9dafbc83(0.0, 0.0, -100.0, 0.0)
					event.set_camera_look_at(0.0, 30.0, -100.0)
					event.set_camera_position(0.0, 40.0, -220.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			if at <= 2 then
				wait_frames_skipping(4)
			end
			helper_43f02c95(0.0, 0.0, -100.0, 0.0)
			return 0
		end
		return nil
	end)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local active_chr_no: s32 = 0
	local var1: any = 0
	event.initialize_event()
	vm.wait(1)
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 5, 256, 208)
		else
			helper_75684dd8(0, 23, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	var1 = helper_ed4dc120(2, -1)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	if var1 == 0 then
		event.fade_out_screen(30)
		wait_frames(30)
		helper_7f487db5(0)
		event.load_event_script("d03/d03.stb", 1000)
		return
	end
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- Event 13320, which map data, a script or the engine runs by number.
function script.event_13320()
	event.fade_out_screen(0)
	helper_11cb4()
end

--- Event 13360, which map data, a script or the engine runs by number.
function script.event_13360()
	event.fade_out_screen(0)
	helper_16a8c()
end

--- Event 13400, which map data, a script or the engine runs by number.
function script.event_13400()
	event.fade_out_screen(0)
	helper_1fc10()
end

--- Event 23020, which map data, a script or the engine runs by number.
function script.event_23020()
	event.initialize_event()
	event.fade_out_screen(0)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(190)
	event.play_music(0)
	event.load_dungeon_monster(68, 1)
	event.place_dungeon_monster(68, 0.0, 0.0, 0.0, 0.0, 3.14, 0.0)
	helper_9dafbc83(0.0, 0.0, -100.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -100.0)
	event.set_camera_position(0.0, 40.0, -220.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

return script
