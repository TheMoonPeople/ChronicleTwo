--!strict
-- map/s/s04/s04.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0c718064 = require("@lib/event/helper_0c718064")
local helper_0d0a5438 = require("@lib/event/helper_0d0a5438")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_21d8472e = require("@lib/event/helper_21d8472e")
local helper_3efe4328 = require("@lib/event/helper_3efe4328")
local helper_4071559a = require("@lib/event/helper_4071559a")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4cb9ff49 = require("@lib/event/helper_4cb9ff49")
local helper_5d2af1e9 = require("@lib/event/helper_5d2af1e9")
local helper_6cc2fba1 = require("@lib/event/helper_6cc2fba1")
local helper_71aacd6c = require("@lib/event/helper_71aacd6c")
local helper_84a2c453 = require("@lib/event/helper_84a2c453")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_b79fe662 = require("@lib/event/helper_b79fe662")
local helper_b7a01b67 = require("@lib/event/helper_b7a01b67")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_cce8673f = require("@lib/event/helper_cce8673f")
local helper_ce60ccd6 = require("@lib/event/helper_ce60ccd6")
local helper_cf15df04 = require("@lib/event/helper_cf15df04")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local helper_e2123063 = require("@lib/event/helper_e2123063")
local helper_ed56af24 = require("@lib/event/helper_ed56af24")
local helper_ef001e52 = require("@lib/event/helper_ef001e52")
local helper_f1384058 = require("@lib/event/helper_f1384058")
local helper_fab38133 = require("@lib/event/helper_fab38133")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_2ac28()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(300, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(3200)
		var0 = event.load_sound_effect_file_2(3200) or var0
		event.set_character_active(0, 25)
		event.set_character_active(0, 26)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e300/")
		event.load_message_file(0, 5, "e300.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e300_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e300_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(0, 24)
		event.attach_object_handle_to_character(2, 24)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.change_directory("event/e200/e207/")
		event.load_character(5, "e207_vorneo.gltf", "info", 35)
		event.set_character_active(0, 35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e207_tom.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e300/e300_mints.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 33)
			event.load_equipment_model(5, 1, 4, "info", 33)
			event.load_equipment_model(5, 1, 3, "info", 33)
			event.load_equipment_model(5, 1, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e300/e300_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 33)
		event.set_character_active(0, 34)
		event.attach_object_handle_to_map_part_2(5, "p01_train01")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train08-m2")
		event.set_object_sequence_object(6, 6)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "train08-m3")
		event.set_object_sequence_object(7, 7)
		event.attach_object_handle_to_map_part_3(8, "p01_train01", "train10-m14")
		event.set_object_sequence_object(8, 8)
		event.attach_object_handle_to_map_part_3(9, "p01_train01", "train10-m15")
		event.set_object_sequence_object(9, 9)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.create_effect("列車煙")
		event.set_effect_value(0, 5)
		event.set_object_handle_position(0, -51.32, 36.0, -146.5)
		event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -44.65, 36.0, -161.3)
		event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -60.0, 36.0, -154.54)
		event.set_object_handle_rotation(2, 0.0, -1.57, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_footstep_sound(2, 6)
		event.set_object_handle_position(3, -175.26, 36.0, 107.7)
		event.set_object_handle_rotation(3, 0.0, 2.8, 0.0)
		event.set_object_handle_position(4, -133.94, 36.0, 163.59)
		event.set_object_handle_rotation(4, 0.0, -3.12, 0.0)
		event.set_object_handle_position(5, 0.0, 0.0, -4200.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(8, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-305.89, 188.66, -811.58)
		event.set_camera_sequence_look_at(-260.09, 165.4, -1011.0)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 8)
		event.move_object_sequence(5, 0.0, 0.0, -1000.0, 90)
		helper_888ab2a3(90)
		event.set_camera_sequence_position(-748.03, 60.33, -205.79)
		event.set_camera_sequence_look_at(-473.11, 63.96, -161.07)
		event.set_object_sequence_position(5, 0.0, 0.0, 200.0)
		event.move_object_sequence_eased(5, 0.0, 0.0, 400.0, 40, 2, 1.0)
		helper_888ab2a3(80)
		event.play_sound_effect(var0, 9)
		event.set_character_active(0)
		event.set_character_active(33)
		event.set_character_active(34)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(7, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(8, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(9, 0.0, -1.5, 0.0, 30)
		wait_objects(6)
		helper_888ab2a3(10)
		event.set_camera_sequence_position(-256.14, 103.33, -318.65)
		event.set_camera_sequence_look_at(-109.39, 73.39, -128.41)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -104.57, 36.0, -146.0, 64)
		helper_888ab2a3(4)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -91.13, 36.0, -165.21, 60)
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-4.55, 266.85, -23.64)
		event.set_camera_sequence_look_at(-51.16, 197.71, -66.4)
		event.move_camera_sequence_eased(102.69, 266.85, -24.93, -51.16, 197.71, -66.4, 60, 0, 1.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.move_object_sequence(0, -170.81, 36.0, -146.0, 80)
		event.delay_object_sequence_motion_track(0, 80)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, -161.13, 36.0, -165.21, 90)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち")
		helper_4116e6bb(3000010)
		helper_4116e6bb(3000020)
		wait_objects(1)
		event.set_camera_sequence_position(-205.34, 64.3, -154.56)
		event.set_camera_sequence_look_at(-144.49, 53.0, -154.43)
		event.set_character_active(24)
		event.move_object_sequence(2, -114.8, 36.0, -154.66, 40)
		event.set_object_sequence_motion(2, "歩き")
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "立ち")
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		helper_888ab2a3(10)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_mouth_texture_animations(2, "口パク")
		helper_4116e6bb(3000030)
		wait_objects(2)
		event.set_camera_sequence_position(-210.94, 73.59, -232.54)
		event.set_camera_sequence_look_at(-148.67, 56.48, -130.25)
		event.move_camera_sequence_eased(-210.94, 73.59, -232.54, -180.15, 61.97, -107.65, 20, 2, 1.0)
		event.set_character_active(35)
		event.set_character_active(36)
		event.set_object_sequence_motion(0, "右向く戻り", 6, 0.6)
		event.queue_object_sequence_next_motion(0, "左向く", 6, 0.6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_object_sequence_motion(3, "会話2", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_object_sequence_motion(4, "スコップ会話2", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_rotation_track(1, 10)
		event.rotate_object_sequence(1, 0.0, 0.35, 0.0, 10)
		event.move_object_sequence(1, -193.42, 36.0, -145.41, 20)
		event.set_object_sequence_motion(2, "歩き")
		event.rotate_object_sequence(2, 0.0, -1.93, 0.0, 10)
		event.move_object_sequence(2, -183.47, 36.0, -185.25, 60)
		event.delay_object_sequence_rotation_track(2, 30)
		event.rotate_object_sequence(2, 0.0, -0.01, 0.0, 20)
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "立ち")
		helper_4116e6bb(3000040)
		helper_4116e6bb(3000045)
		wait_objects(2)
		event.set_camera_sequence_position(-181.22, 61.67, -107.35)
		event.set_camera_sequence_look_at(-185.03, 54.04, -201.62)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_rotation(0, 0.0, 0.2, 0.0)
		event.set_object_sequence_motion(0, "手を振る", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(3000050)
		wait_objects(0)
		event.set_object_sequence_motion(0, "振り返る", 6)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		helper_888ab2a3(4)
		event.set_object_sequence_motion(1, "回転左180度ＰＧ", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.rotate_object_sequence(1, 0.0, 2.87, 0.0, 40)
		helper_888ab2a3(40)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "口パク")
		helper_4116e6bb(3000060)
		wait_objects(2)
		event.set_camera_sequence_position(-180.14, 58.52, -189.12)
		event.set_camera_sequence_look_at(-181.13, 55.77, -139.14)
		event.set_character_active(0, 24)
		event.set_character_active(0, 35)
		event.set_character_active(0, 36)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_rotation(0, 0.0, -2.91, 0.0)
		event.set_object_sequence_motion(0, "うなづく", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		helper_888ab2a3(4)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(3000070)
		event.set_camera_sequence_position(-117.6, 87.58, -155.8)
		event.set_camera_sequence_look_at(-248.36, 57.62, -155.82)
		event.set_character_active(24)
		event.set_object_sequence_motion(2, "歩き")
		event.rotate_object_sequence(2, 0.0, -1.09, 0.0, 20)
		event.delay_object_sequence_motion_track(2, 20)
		event.set_object_sequence_motion(2, "立ち")
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 20)
		event.rotate_object_sequence(1, 0.0, -1.61, 0.0, 10)
		event.move_object_sequence(1, -315.35, 0.0, -143.13, 52, 1)
		helper_888ab2a3(2)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 20)
		event.rotate_object_sequence(0, 0.0, -1.71, 0.0, 10)
		event.move_object_sequence(0, -303.46, 0.0, -165.04, 50, 1)
		helper_888ab2a3(30)
		event.fade_out_screen(20)
		helper_888ab2a3(20)
	end)
	vm.entry(29)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.stop_sound_effect(var0, 8)
	event.set_object_handle_position(5, 0.0, 0.0, 400.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(8, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
	event.set_object_handle_texture_animation(2, 0)
	event.set_object_handle_texture_animation(2, 1, "通常目パチ")
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, -382.56, 0.0, -156.89)
	event.set_character_rotation(0, 0.0, -1.59, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_28938()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		flag = event.get_save_flag(372) or flag
		event.set_character_active(0, 24)
		if flag == 0 then
			event.set_character_active(0, 25)
			event.set_character_active(0, 26)
		end
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or var1
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 200.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m2")
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m3")
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m14")
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m15")
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
		event.set_object_handle_footstep_sound(0, 6)
		event.play_sound_effect(var1, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-266.11, 272.22, 848.56)
		event.set_camera_sequence_look_at(124.54, -133.73, -212.03)
		event.fade_in_screen(30)
		event.move_object_sequence_eased(1, 0.0, 0.0, 400.0, 40, 2, 1.0)
		wait_objects(1)
		helper_888ab2a3(10)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-211.1, 66.53, -316.91)
		event.set_camera_sequence_look_at(-87.12, 61.79, -127.67)
		var2 = event.get_sound_id(2) or var2
		event.play_sound_effect(var2, 66)
		event.set_character_active(0)
		event.set_object_sequence_position(0, -41.0, 36.0, -154.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.rotate_object_sequence(2, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		helper_888ab2a3(15)
		event.move_object_sequence(0, -130.0, 36.0, -154.0, 30)
		event.set_object_sequence_motion(0, "走り", 4)
		helper_888ab2a3(10)
		event.set_object_handle_footstep_sound(0, 2)
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		helper_888ab2a3(10)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	event.fade_in_screen(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_position(1, 0.0, 0.0, 400.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_character_position(0, -130.0, 36.0, -154.0)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_character_active(1, 24)
	if flag == 0 then
		event.set_character_active(1, 25)
		event.set_character_active(1, 26)
	end
	event.set_camera_position(-79.74, 70.2, -154.0)
	event.set_camera_look_at(-130.0, 66.0, -154.0)
end

--- Helper function.
local function helper_279ac()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or var0
	flag = event.get_save_flag(372) or flag
	event.set_character_active(0, 24)
	if flag == 0 then
		event.set_character_active(0, 25)
		event.set_character_active(0, 26)
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m7")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(1, 0.0, 0.0, 200.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.move_object_sequence_eased(1, 0.0, 0.0, 400.0, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-266.11, 272.22, 848.56)
	event.set_camera_sequence_look_at(124.54, -133.73, -212.03)
	event.fade_in_screen(30)
	event.play_sound_effect(var0, 0)
	wait_objects(1)
	helper_888ab2a3(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-211.1, 66.53, -316.91)
	event.set_camera_sequence_look_at(-87.12, 61.79, -127.67)
	event.set_object_handle_position(1, 0.0, 0.0, 400.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -41.0, 36.0, -154.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
	var2 = event.get_sound_id(2) or var2
	event.play_sound_effect(var2, 92)
	helper_888ab2a3(15)
	event.move_object_sequence(0, -130.0, 36.0, -154.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	wait_objects(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, 0.0, 0.0, 400.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_character_active(1, 24)
	if flag == 0 then
		event.set_character_active(1, 25)
		event.set_character_active(1, 26)
	end
	event.set_character_active(0)
	event.set_character_position(0, -130.0, 36.0, -154.0)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_camera_position(-79.74, 70.2, -154.0)
	event.set_camera_look_at(-130.0, 66.0, -154.0)
	event.fade_in_screen(15)
end

--- Helper function.
local function helper_26be8()
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
		event.open_message_window_2(0, "『てんびん谷』に移動しますか？")
		at = 1
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.set_camera_sequence_position(-1159.24, 92.09, 269.02)
			event.set_camera_sequence_look_at(-1327.31, 55.37, 161.26)
			event.set_object_sequence_position(0, -1386.18, 24.63, 115.22)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -1386.18, 29.63, 115.22)
			event.add_object_sequence_path_point(0, -1421.37, 37.04, 89.07)
			event.add_object_sequence_path_point(0, -1441.04, 44.13, 68.02)
			event.add_object_sequence_path_point(0, -1454.41, 52.15, 47.35)
			event.add_object_sequence_path_point(0, -1465.6, 61.13, 26.8)
			event.add_object_sequence_path_point(0, -1475.99, 68.270004, 2.68)
			event.add_object_sequence_path_point(0, -1483.7, 77.97, -24.81)
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
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(1.44)) * 30.0) + var1)
			var5 = 0.0
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(1.44)) * 30.0) + var3)
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
		event.set_object_handle_footstep_sound(0, 0)
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
local function helper_2f668()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 33
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e300/e372/e372_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e372/e372_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e300/e372/e372_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e372/e372_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "chara/p01_03a.gltf", "info", 35)
	event.attach_object_handle_to_character(2, 35)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 35)
	event.load_message_file(0, 5, "event/e300/e372/e372.txt")
	event.set_scene_status_flags(1, global0, 256, 1)
	event.set_scene_status_flags(1, global1, 256, 1)
end

--- Helper function.
local function helper_2f3b4()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(35)
end

--- Helper function.
local function helper_30460()
	vm.section(function()
		event.set_character_active(0, 24)
		event.set_save_flag(372, 1)
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(20, "p01_train01")
		event.set_object_handle_position(20, 0.0, 0.0, 400.0)
		helper_2f668()
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(49)
		event.play_music(0)
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 35)
		event.set_camera_sequence_position(-940.17, 88.71, -222.08)
		event.set_camera_sequence_look_at(-788.53, 51.39, -202.38)
		event.set_object_sequence_position(0, -802.48, 0.0, -185.61)
		event.set_object_sequence_rotation(0, 0.0, 1.5, 0.0)
		event.set_object_sequence_position(1, -799.79, 0.0, -228.07)
		event.set_object_sequence_rotation(1, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(2, -126.08, 36.0, -149.46)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.fade_in_screen(15)
		event.set_object_sequence_motion(0, "走り", 0)
		event.set_object_sequence_motion(1, "走り", 0)
		event.move_object_sequence(0, -647.07, 0.0, -165.42, 60)
		event.move_object_sequence(1, -636.31, 0.0, -204.74, 60)
		wait_objects(0)
		event.set_camera_sequence_position(-243.89, 55.02, -207.96)
		event.set_camera_sequence_look_at(-152.87, 61.42, -156.97)
		event.set_object_sequence_position(0, -207.98, 36.0, -142.65)
		event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
		event.set_object_sequence_position(1, -209.43, 36.0, -161.14)
		event.set_object_sequence_rotation(1, 0.0, 1.56, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.move_object_sequence(0, -155.54, 36.0, -140.71, 75)
		event.move_object_sequence(1, -153.89, 36.0, -159.09, 75)
		event.set_mouth_texture_animations(2, "口パク")
		helper_0382f327(3720500, 60)
		event.reset_mouth_texture_animations()
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_camera_sequence_position(-196.14, 62.27, -152.87)
		event.set_camera_sequence_look_at(-156.04, 61.42, -151.29)
		event.set_object_sequence_position(0, -155.54, 36.0, -140.71)
		event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
		event.set_object_sequence_position(1, -153.89, 36.0, -159.09)
		event.set_object_sequence_rotation(1, 0.0, 1.56, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "会話2", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "口パク")
		helper_4116e6bb(3720505)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	if global0 == 0 then
		event.set_character_position(0, -155.54, 36.0, -140.71)
	else
		event.set_character_position(0, -153.89, 36.0, -159.09)
	end
	helper_2f3b4()
	event.set_character_active(1, 24)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_316fc()
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(360, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.change_directory("event/e300/e360/")
		event.load_message_file(0, 5, "e360.txt")
		event.load_character(5, "e360_starbre.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.set_character_active(0, 0)
		event.set_character_active(0, 24)
		event.set_object_handle_position(2, -145.89, 36.0, -6.26)
		event.set_object_handle_rotation(2, 0.0, -1.58, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-189.99, 47.8, 29.79)
		event.set_camera_sequence_look_at(-106.32, 74.01, -26.32)
		event.set_character_active(34)
		event.fade_in_screen(30)
		event.stop_music(0)
		helper_888ab2a3(45)
		event.set_object_sequence_motion(2, "出発進行", 6)
		event.queue_object_sequence_next_motion(2, "出発進行L", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_4116e6bb(3600010)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_29de8()
	local var0: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.load_map_sounds(3223)
		var0 = event.load_sound_effect_file_2(3223) or var0
		event.set_character_active(0, 0)
		event.set_character_active(0, 24)
		event.set_character_active(0, 25)
		event.set_character_active(0, 26)
		helper_5d2af1e9()
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 400.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.attach_object_handle_to_map_part_2(1, "p01_shadow-0")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/train/steam/steam_l.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.attach_object_handle_to_character(2, 32)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/train/steam/steam_r.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_character(3, 33)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-251.99, 110.91, -251.89)
		event.set_camera_sequence_look_at(-151.44, 89.18, -3.01)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.set_character_active(1, 32)
		event.set_object_sequence_position(2, 30.0, 20.0, 380.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "ぶしゅー", 6)
		event.set_character_active(1, 33)
		event.set_object_sequence_position(3, -30.0, 20.0, 380.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "ぶしゅー", 6)
		event.move_object_sequence_eased(0, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(1, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(2, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(3, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.play_sound_effect(var0, 0)
		wait_objects(0)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.clear_effect_manager()
	event.delete_character(32)
	event.delete_character(33)
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
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		helper_fab38133()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, -357.0, 0.0, -206.0)
			event.set_character_rotation(0, 0.0, -1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 3.14, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			var2 = event.get_map_type(old_map_no) or var2
			if var2 ~= -1 then
				if old_map_no == 1 then
					at = 1
					helper_e2123063()
				elseif old_map_no ~= 18 and old_map_no ~= 23 and old_map_no ~= 120 and old_map_no ~= 108 then
					flag = event.get_save_flag(283) or flag
					flag_2 = event.get_save_flag(300) or flag_2
					if flag == 1 and flag_2 == 0 then
						event.set_villager_ai_enabled(0, 24)
						event.set_villager_ai_enabled(0, 25)
						event.set_villager_ai_enabled(0, 26)
						at = 2
						helper_2ac28()
						helper_b79fe662()
						event.set_villager_ai_enabled(1, 24)
						event.set_villager_ai_enabled(1, 25)
						event.set_villager_ai_enabled(1, 26)
					else
						event.set_character_active(0, 25)
						var5 = event.get_chapter() or var5
						if var5 ~= 6 and var5 ~= 7 then
							at = 3
							helper_28938()
						else
							at = 4
							helper_279ac()
						end
						event.set_character_active(25)
					end
				else
					var6 = event.get_save_counter(1) or var6
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and var6 == 3
					then
						helper_946c0402()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						var7 = event.get_chapter() or var7
						if var7 ~= 6 and var7 ~= 7 then
							at = 5
							helper_28938()
						else
							at = 6
							helper_279ac()
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
			end
		end
		return
	end, function(received: { any })
		if at <= 6 then
			if at <= 1 then
				at = 2
				helper_2ac28()
				return vm.continue_with(function()
					helper_b79fe662()
					event.set_villager_ai_enabled(1, 24)
					event.set_villager_ai_enabled(1, 25)
					event.set_villager_ai_enabled(1, 26)
					return
				end)
			end
			if at <= 2 then
				helper_1ef0d4b2()
				at = 3
				helper_28938()
				return vm.continue_with(function()
					event.set_character_active(25)
					return
				end)
			end
			if at <= 3 then
				helper_f1384058()
			end
			if at <= 4 then
				helper_d7295df9()
				at = 5
				helper_28938()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 5 then
				helper_f1384058()
			end
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local var0: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_2(3200) or var0
	vm.wait(1)
	helper_c956b4a2(32)
	event.play_sound_effect(var0, 8)
	vm.wait(3)
	helper_c956b4a2(32)
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
		event.set_save_counter(1, 3)
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
	if helper_26be8() ~= 0 then
		event.jump_to_map_3(-1, "g02", 100)
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_fab38133()
	helper_30460()
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_0c718064(3)
	helper_fab38133()
	event.set_villager_ai_enabled(0, 24)
	event.set_villager_ai_enabled(0, 25)
	event.set_villager_ai_enabled(0, 26)
	helper_2ac28()
	helper_b79fe662()
	event.set_villager_ai_enabled(1, 24)
	event.set_villager_ai_enabled(1, 25)
	event.set_villager_ai_enabled(1, 26)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(14) or var0
		if var0 == 1 then
			at = 1
			var1 = helper_ef001e52()
			if var1 == 1 then
				at = 2
				helper_316fc()
				at = 3
				helper_29de8()
				event.open_event_menu(13, 8)
				at = 4
				vm.wait(4)
				event.jump_to_map_2(-1, "s09")
			end
		end
		if var0 == 2 then
			at = 5
			helper_4cb9ff49()
		end
		if var0 == 13 then
			at = 6
			helper_71aacd6c()
		end
		if var0 == 301 then
			at = 7
			helper_ce60ccd6()
		end
		return
	end, function(received: { any })
		if at <= 7 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				at = 2
				helper_316fc()
				return vm.continue_with(function()
					at = 3
					helper_29de8()
					event.open_event_menu(13, 8)
					at = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s09")
					if var0 == 2 then
						at = 5
						helper_4cb9ff49()
					end
					if var0 == 13 then
						at = 6
						helper_71aacd6c()
					end
					if var0 == 301 then
						at = 7
						helper_ce60ccd6()
					end
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_29de8()
				return vm.continue_with(function()
					event.open_event_menu(13, 8)
					at = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s09")
					if var0 == 2 then
						at = 5
						helper_4cb9ff49()
					end
					if var0 == 13 then
						at = 6
						helper_71aacd6c()
					end
					if var0 == 301 then
						at = 7
						helper_ce60ccd6()
					end
					return
				end)
			end
			if at <= 4 then
				helper_ed56af24()
			end
			if at <= 5 then
				helper_4071559a()
			end
			if at <= 6 then
				helper_21d8472e()
			end
			return 0
		end
		return nil
	end)
end

--- Event 13000, which map data, a script or the engine runs by number.
function script.event_13000()
	helper_fab38133()
	event.set_villager_ai_enabled(0, 24)
	event.set_villager_ai_enabled(0, 25)
	event.set_villager_ai_enabled(0, 26)
	helper_2ac28()
	helper_b79fe662()
	event.set_villager_ai_enabled(1, 24)
	event.set_villager_ai_enabled(1, 25)
	event.set_villager_ai_enabled(1, 26)
end

--- Event 13600, which map data, a script or the engine runs by number.
function script.event_13600()
	local at: number = 0
	return vm.guard(function()
		helper_fab38133()
		at = 1
		helper_316fc()
		at = 2
		helper_29de8()
		event.open_event_menu(13, 8)
		at = 3
		vm.wait(3)
		event.jump_to_map_2(-1, "s09")
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_29de8()
				return vm.continue_with(function()
					event.open_event_menu(13, 8)
					at = 3
					vm.wait(3)
					event.jump_to_map_2(-1, "s09")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
