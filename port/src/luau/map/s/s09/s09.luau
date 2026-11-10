--!strict
-- map/s/s09/s09.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_07039683 = require("@lib/event/helper_07039683")
local helper_0d0a5438 = require("@lib/event/helper_0d0a5438")
local helper_13965fb3 = require("@lib/event/helper_13965fb3")
local helper_21d8472e = require("@lib/event/helper_21d8472e")
local helper_3efe4328 = require("@lib/event/helper_3efe4328")
local helper_4071559a = require("@lib/event/helper_4071559a")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4cb9ff49 = require("@lib/event/helper_4cb9ff49")
local helper_5d0fc1fa = require("@lib/event/helper_5d0fc1fa")
local helper_6cc2fba1 = require("@lib/event/helper_6cc2fba1")
local helper_71aacd6c = require("@lib/event/helper_71aacd6c")
local helper_84a2c453 = require("@lib/event/helper_84a2c453")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_b7a01b67 = require("@lib/event/helper_b7a01b67")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_cce8673f = require("@lib/event/helper_cce8673f")
local helper_ce60ccd6 = require("@lib/event/helper_ce60ccd6")
local helper_cf15df04 = require("@lib/event/helper_cf15df04")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local helper_ef001e52 = require("@lib/event/helper_ef001e52")
local helper_f1384058 = require("@lib/event/helper_f1384058")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_2a10c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(400, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_2(4200) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e400/e400/")
		event.load_message_file(0, 5, "e400.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e400_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e400_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e400/e400_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e400/e400_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.set_villager_ai_enabled(0, 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(7, 8)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_villager_ai_enabled(0, 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(8, 9)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_villager_ai_enabled(0, 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(9, 10)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.attach_object_handle_to_map_part_2(2, "p01_train01")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m0")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train08-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m0")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m1")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.create_effect("列車煙")
		event.set_effect_value(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(7, 0)
		event.set_object_handle_texture_animation(7, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(7, 1, "通常目パチ")
		event.set_object_handle_position(0, -1494.0, 42.31, -35.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_position(1, -1478.0, 42.31, -35.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_position(7, -1485.0, 45.34, -9.42)
		event.set_object_handle_rotation(7, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(7, "立ち", 4)
		event.set_object_handle_position(2, -2312.1, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1481.05, 64.34, -282.56)
		event.set_camera_sequence_look_at(-1949.42, 59.22, -91.09)
		event.move_camera_sequence_eased(-1481.05, 64.34, -282.56, -1473.02, 59.22, -83.94, 80, 2, 1.0)
		event.move_object_sequence_eased(2, -912.1, 0.0, 0.0, 80, 2, 1.0)
		event.play_sound_effect(var0, 4)
		event.play_sound_effect(var0, 5)
		event.fade_in_screen(30)
		wait_objects(2)
		helper_888ab2a3(20)
		event.play_sound_effect(var0, 6)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(8)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		helper_888ab2a3(30)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -1493.51, 29.22, -100.0, 60)
		helper_888ab2a3(10)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -1478.51, 29.22, -90.0, 50)
		helper_888ab2a3(20)
		event.set_object_handle_footstep_sound(0, 3)
		helper_888ab2a3(10)
		event.set_object_handle_footstep_sound(1, 3)
		helper_888ab2a3(20)
		event.clear_effect_manager()
		event.set_camera_sequence_position(-1510.53, 52.11, -162.67)
		event.set_camera_sequence_look_at(-1480.38, 51.06, -136.4)
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.move_object_sequence(1, -1478.51, 29.22, -145.0, 50)
		event.set_object_sequence_motion(1, "潮歩き", 4)
		event.delay_object_sequence_motion_track(1, 50)
		event.set_object_sequence_motion(1, "潮立ち")
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4000010)
		wait_objects(1)
		event.move_object_sequence(0, -1493.51, 29.22, -135.0, 50)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4000020)
		wait_objects(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "潮立ちから右", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4000030)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4000040)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4000050)
		event.set_camera_sequence_position(-1482.95, 61.09, -180.61)
		event.set_camera_sequence_look_at(-1483.79, 47.79, -128.26)
		event.set_object_sequence_position(7, -1483.61, 29.22, -91.35)
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_motion(1, "ふりかえり", 6)
		event.queue_object_sequence_next_motion(1, "ふりかえりＬ", 4)
		event.set_object_sequence_motion(0, "振り返り", 6)
		event.queue_object_sequence_next_motion(0, "振り返りL", 4)
		event.set_mouth_texture_animations(7, "口パク")
		helper_4116e6bb(4000060)
		event.set_camera_sequence_position(-1563.93, 73.34, -118.52)
		event.set_camera_sequence_look_at(-1483.1, 54.11, -118.91)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_position(9, -625.34, 29.22, -99.11)
		event.set_character_position(10, -627.43, 29.22, -126.82)
		event.set_object_sequence_position(7, -1489.0, 29.22, -98.62)
		event.set_object_sequence_rotation(7, 0.0, 1.58, 0.0)
		event.set_object_sequence_position(0, -1496.36, 29.22, -129.63)
		event.set_object_sequence_rotation(0, 0.0, 1.46, 0.0)
		event.set_object_sequence_motion(0, "立ち", 6, -1.0, 1)
		event.set_object_sequence_position(1, -1478.51, 29.22, -145.0)
		event.set_object_sequence_rotation(1, 0.0, 0.98, 0.0)
		event.set_object_sequence_motion(1, "立ち", 6, -1.0, 1)
		helper_4116e6bb(4000070)
		event.set_object_sequence_motion(1, "手振り", 6)
		event.queue_object_sequence_next_motion(1, "手振りＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4000080)
		wait_objects(1)
		event.set_camera_sequence_position(-1522.27, 54.57, -147.64)
		event.set_camera_sequence_look_at(-1483.82, 49.34, -134.4)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 8)
		event.set_object_sequence_rotation(0, 0.0, 1.82, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(1, "手振りから左", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4000085)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		helper_888ab2a3(6)
		event.play_sound_effect(var0, 8)
		wait_objects(0)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(24)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.stop_sound_effect(var0, 4)
	event.stop_sound_effect(var0, 5)
	event.set_object_handle_position(2, -912.1, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	event.set_character_active(8)
	event.set_character_position(8, -2030.0, 30.0, -100.0)
	event.set_character_rotation(8, 0.0, 3.14, 0.0)
	event.set_villager_ai_enabled(1, 8)
	event.set_character_active(9)
	event.set_character_position(9, -1098.0, 29.2, -100.0)
	event.set_character_rotation(9, 0.0, -1.57, 0.0)
	event.set_villager_ai_enabled(1, 9)
	event.set_character_active(10)
	event.set_character_position(10, -707.6, -10.0, -172.5)
	event.set_character_rotation(10, 0.0, 0.0, 0.0)
	event.set_villager_ai_enabled(1, 10)
	event.set_character_active(0)
	event.set_character_position(0, -1880.1, 29.2, -299.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_27d90()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		flag = event.get_save_flag(448) or flag
		event.set_character_active(0, 8)
		if flag == 0 then
			event.set_character_active(0, 9)
			event.set_character_active(0, 10)
		end
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or var1
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, -1512.1, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 1.57, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.attach_object_handle_to_map_part_2(6, "p01_shadow")
		event.set_object_handle_visible(6, 0)
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m0")
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m1")
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m0")
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m1")
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(8, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 8)
		event.play_sound_effect(var1, 0)
		event.set_object_handle_footstep_sound(0, 6)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-363.94, 121.88, -75.09)
		event.set_camera_sequence_look_at(-643.14, 118.87, -58.01)
		event.fade_in_screen(30)
		event.move_object_sequence_eased(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
		wait_objects(1)
		helper_888ab2a3(10)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1664.28, 105.75, -222.05)
		event.set_camera_sequence_look_at(-1452.28, 75.37, -85.42)
		var2 = event.get_sound_id(2) or var2
		event.play_sound_effect(var2, 66)
		event.set_object_handle_position(1, -912.1, 0.0, 0.0)
		event.set_character_active(0)
		event.set_object_sequence_position(0, -1460.3, 33.0, -45.39)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		helper_888ab2a3(15)
		event.move_object_sequence(0, -1460.3, 29.22, -123.59, 30)
		event.set_object_sequence_motion(0, "走り", 4)
		helper_888ab2a3(10)
		event.set_object_handle_footstep_sound(0, 3)
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		helper_888ab2a3(10)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	event.fade_in_screen(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_object_handle_visible(6, 1)
	event.set_character_active(0)
	event.set_character_position(0, -1460.3, 29.22, -123.59)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_character_active(1, 8)
	if flag == 0 then
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
	end
	event.reset_follow_camera(1, 3.14, 10.0)
end

--- Helper function.
local function helper_26da0()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or var0
	flag = event.get_save_flag(448) or flag
	event.set_character_active(0, 8)
	if flag == 0 then
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
	end
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_2(4, "p01_shadow")
	event.set_object_handle_visible(4, 0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(1, -1512.1, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 1.57, 0.0)
	event.move_object_sequence_eased(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-363.94, 121.88, -75.09)
	event.set_camera_sequence_look_at(-643.14, 118.87, -58.01)
	event.fade_in_screen(30)
	event.play_sound_effect(var0, 0)
	wait_objects(1)
	helper_888ab2a3(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-1664.28, 105.75, -222.05)
	event.set_camera_sequence_look_at(-1452.28, 75.37, -85.42)
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -1460.3, 33.0, -45.39)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	var2 = event.get_sound_id(2) or var2
	event.play_sound_effect(var2, 92)
	helper_888ab2a3(15)
	event.move_object_sequence(0, -1460.3, 29.22, -123.59, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 3)
	wait_objects(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(4, 1)
	event.set_character_active(1, 8)
	if flag == 0 then
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
	end
	event.set_character_active(0)
	event.set_character_position(0, -1460.3, 29.22, -123.59)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(15)
end

--- Helper function.
local function helper_260d8()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『ベニーティオ』に移動しますか？")
		at = 1
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.set_camera_sequence_position(-1925.42, 97.53, -285.93)
			event.set_camera_sequence_look_at(-1921.75, 57.81, -472.01)
			event.set_object_sequence_position(0, -1910.95, 21.58, -466.12)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -1910.95, 21.58, -466.12)
			event.add_object_sequence_path_point(0, -1907.45, 17.42, -496.67)
			event.add_object_sequence_path_point(0, -1898.74, 13.2, -528.24)
			event.add_object_sequence_path_point(0, -1878.93, 9.61, -555.9)
			event.add_object_sequence_path_point(0, -1854.68, 5.12, -580.59)
			event.add_object_sequence_path_point(0, -1828.07, 1.46, -591.28)
			event.start_object_sequence_path(0)
			at = 2
			helper_888ab2a3(30)
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + var1)
			var5 = 0.0
			var6 = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + var3)
			event.move_object_sequence(0, var4, var5, var6, 30, 1)
			event.turn_object_sequence_toward(0, var4, var5, var6, 10)
			event.set_object_sequence_motion(0, "歩き")
			var7 = 0
			while var7 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				var2 = vm.f32(var2 + 30.0)
				event.set_camera_look_at(var1, var2, var3)
				var7 = var7 + 1
				at = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_2e3d4()
	local active_chr_no: s32 = 0
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
	event.load_character(5, "chara/p01_03a.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "chara/p01_06a.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_2(4, "p01_train01")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.load_message_file(0, 5, "event/e400/e448/e448.txt")
end

--- Helper function.
local function helper_2e00c()
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
	event.set_character_position(0, -1952.44, 29.22, -304.96)
	event.set_character_rotation(0, 0.0, 1.62, 0.0)
end

--- Helper function.
local function helper_2f304()
	local var6: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4220)
		var6 = event.load_sound_effect_file_2(4220) or var6
		helper_2e3d4()
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(-1979.65, 91.43, -121.02)
		event.set_camera_sequence_look_at(-1941.55, 74.53, -339.62)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.set_object_sequence_position(1, -1838.01, 8.0, -560.01)
		event.set_object_sequence_rotation(1, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(0, -1904.92, 17.42, -503.6)
		event.set_object_sequence_rotation(0, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(2, -2186.89, 29.22, -198.9)
		event.set_object_sequence_rotation(2, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(3, -2223.98, 29.22, -196.3)
		event.set_object_sequence_rotation(3, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(4, -912.1, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
		event.fade_in_screen(30)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 60)
		event.add_object_sequence_path_point(0, -1904.92, 17.42, -503.6)
		event.add_object_sequence_path_point(0, -1985.4, 29.22, -393.12)
		event.start_object_sequence_path(0, 1)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 60)
		event.add_object_sequence_path_point(1, -1838.01, 8.0, -560.01)
		event.add_object_sequence_path_point(1, -1922.88, 29.4, -436.71)
		event.start_object_sequence_path(1, 1)
		wait_objects(0)
		wait_objects(1)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_camera_sequence_position(-2052.02, 160.14, -365.82)
		event.set_camera_sequence_look_at(-2179.63, 74.53, -268.32)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 120)
		event.add_object_sequence_path_point(1, -2199.24, 29.22, -360.0)
		event.add_object_sequence_path_point(1, -2199.24, 29.22, -253.55)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 120)
		event.add_object_sequence_path_point(0, -2216.55, 29.22, -360.0)
		event.add_object_sequence_path_point(0, -2216.55, 29.22, -253.55)
		event.start_object_sequence_path(0)
		wait_objects(0)
		wait_objects(1)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_4116e6bb(4481130)
		event.set_object_sequence_motion(2, "立ち")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		helper_4116e6bb(4481140)
		event.set_object_sequence_motion(3, "会話", 2)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		helper_4116e6bb(4481150)
		event.set_object_sequence_motion(3, "立ち")
		helper_888ab2a3(30)
		event.set_object_sequence_position(1, -1935.53, 29.22, -301.43)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(0, -1952.44, 29.22, -304.96)
		event.set_object_sequence_rotation(0, 0.0, 1.08, 0.0)
		event.set_camera_sequence_position(-1949.04, 34.26, -256.22)
		event.set_camera_sequence_look_at(-1934.01, 87.78, -397.48)
		event.set_object_sequence_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4481160)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var6, 25)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(4481170)
		event.reset_mouth_texture_animations()
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	helper_888ab2a3(35)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_2e00c()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_33168()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(14) or var0
		if var0 == 1 then
			at = 1
			return helper_ef001e52()
		end
		if var0 == 2 then
			at = 2
			helper_4cb9ff49()
		end
		if var0 == 13 then
			at = 3
			helper_71aacd6c()
		end
		if var0 == 301 then
			at = 4
			helper_ce60ccd6()
		end
		return 0
	end, function(received: { any })
		if at <= 1 then
			return helper_5d0fc1fa()
		end
		if at <= 4 then
			if at <= 2 then
				helper_4071559a()
			end
			if at <= 3 then
				helper_21d8472e()
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_30b6c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(452, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4223)
		var0 = event.load_sound_effect_file_2(4223) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.load_message_file(0, 5, "event/e400/e452/e452.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "event/e400/e452/e452_mints.chr", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "event/e400/e452/e452_monica.chr", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "event/e200/e283/e283_starbre.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e452/e452_mints.chr", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e452/e452_monica.chr", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_object_handle_position(0, -1960.0, 29.22, -120.0)
		event.set_object_handle_rotation(0, 0.0, -0.7853982, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_position(1, -2000.0, 29.22, -120.0)
		event.set_object_handle_rotation(1, 0.0, 0.7853982, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_position(2, -1980.0, 29.22, -100.0)
		event.set_object_handle_rotation(2, 0.0, 3.1415927, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1980.0, 51.24, -291.47)
		event.set_camera_sequence_look_at(-1980.0, 91.37, -49.52)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(34)
		event.fade_in_screen(30)
		helper_888ab2a3(45)
		event.set_object_sequence_motion(2, "出発進行", 6)
		event.queue_object_sequence_next_motion(2, "出発進行L", 4)
		event.play_sound_effect(var0, 0)
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(4520010)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_2927c(arg0: s32)
	local var1: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.load_map_sounds(4223)
		var1 = event.load_sound_effect_file_2(4223) or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -912.1, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 1.5707964, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.load_character(5, "event/train/steam/steam_l.gltf", "info", 11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, -120.0, 0.0, -1690.0)
		event.load_character(5, "event/train/steam/steam_r.gltf", "info", 12)
		event.attach_object_handle_to_character(3, 12)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, -120.0, 0.0, -1690.0)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.create_effect("列車煙")
		event.set_effect_value(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p01_shadow")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-480.06, 58.66, -117.78)
		event.set_camera_sequence_look_at(-569.61, 64.12, -98.79)
		event.fade_in_screen(30)
		event.play_sound_effect(var1, 1)
		event.set_character_active(11)
		event.set_object_sequence_position(2, -874.19, 10.0, 30.0)
		event.set_object_sequence_rotation(2, 0.0, 1.5707964, 0.0)
		event.set_object_sequence_motion(2, "ぶしゅー", 6)
		event.set_character_active(12)
		event.set_object_sequence_position(3, -874.19, 10.0, 30.0)
		event.set_object_sequence_rotation(3, 0.0, 1.5707964, 0.0)
		event.set_object_sequence_motion(3, "ぶしゅー", 6)
		helper_888ab2a3(60)
		event.move_object_sequence_eased(0, 4000.0, 0.0, 0.0, 180, 1, 1.0)
		event.move_object_sequence_eased(1, 4500.0, 0.0, 0.0, 180, 1, 1.0)
		event.play_sound_effect(var1, 2)
		wait_objects(0)
		if arg0 ~= 0 then
			event.fade_out_music(30)
		end
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(6)
	event.cancel_drama_scene_skip()
	if arg0 ~= 0 then
		event.stop_music(0)
	end
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.delete_character(11)
	event.delete_character(12)
	event.clear_effect_manager()
	event.set_character_active(0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var6: s32 = 0
	local at: number = 0
	return vm.guard(function()
		print("START_EVENT----------------------------")
		helper_13965fb3()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, -1820.0, 29.2, -335.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			var2 = event.get_map_type() or var2
			if var2 ~= -1 then
				if old_map_no == 2 or old_map_no == 75 then
					at = 1
					helper_07039683()
				else
					var3 = event.get_save_counter(1) or var3
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and var3 == 4
					then
						helper_946c0402()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						flag = event.get_save_flag(360) or flag
						flag_2 = event.get_save_flag(400) or flag_2
						if flag == 1 and flag_2 == 0 then
							at = 2
							helper_2a10c()
						else
							event.set_character_active(0, 9)
							var6 = event.get_chapter() or var6
							if var6 ~= 6 and var6 ~= 7 then
								at = 3
								helper_27d90()
							else
								at = 4
								helper_26da0()
							end
							event.set_character_active(1, 9)
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
			end
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_d7295df9()
				at = 2
				helper_2a10c()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_27d90()
				return vm.continue_with(function()
					event.set_character_active(1, 9)
					return
				end)
			end
			if at <= 3 then
				helper_f1384058()
			end
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_26da0

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	if helper_260d8() ~= 0 then
		event.jump_to_map_2(-1, "g03")
	end
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_3efe4328()
		if var0 ~= 1 then
			return
		end
		event.set_save_counter(1, 4)
		var1 = event.get_chapter() or var1
		var2 = event.get_triggered_event_data_2(3) or var2
		if var2 <= 1 then
			if var1 ~= 6 and var1 ~= 7 then
				at = 2
				helper_cf15df04()
				event.stop_music(0)
				at = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				at = 4
				helper_cf15df04()
				event.stop_music(0)
				at = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			at = 6
			vm.wait(6)
		elseif var1 ~= 6 and var1 ~= 7 then
			at = 7
			helper_cce8673f(0)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			at = 8
			helper_0d0a5438()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			return 0
		end
		if at <= 8 then
			if at <= 3 then
				helper_6cc2fba1()
			end
			if at <= 6 then
				helper_84a2c453(0)
			end
			if at <= 7 then
				helper_b7a01b67()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_13965fb3()
	helper_2f304()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_33168()
		if var0 == 1 then
			at = 2
			helper_30b6c()
			at = 3
			helper_2927c(1)
			event.open_event_menu(13, 9)
			at = 4
			vm.wait(4)
			event.skip_next_music_load()
			event.jump_to_map_2(-1, "s10")
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				at = 2
				helper_30b6c()
				return vm.continue_with(function()
					at = 3
					helper_2927c(1)
					event.open_event_menu(13, 9)
					at = 4
					vm.wait(4)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_2927c(1)
				return vm.continue_with(function()
					event.open_event_menu(13, 9)
					at = 4
					vm.wait(4)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 14000, which map data, a script or the engine runs by number.
function script.event_14000()
	helper_13965fb3()
	helper_2a10c()
end

--- Event 14520, which map data, a script or the engine runs by number.
function script.event_14520()
	local at: number = 0
	return vm.guard(function()
		helper_13965fb3()
		at = 1
		helper_30b6c()
		at = 2
		helper_2927c(1)
		event.open_event_menu(13, 9)
		at = 3
		vm.wait(3)
		event.skip_next_music_load()
		event.jump_to_map_2(-1, "s10")
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_2927c(1)
				return vm.continue_with(function()
					event.open_event_menu(13, 9)
					at = 3
					vm.wait(3)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
