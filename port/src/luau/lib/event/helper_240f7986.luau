--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0e75aa9e = require("@lib/event/helper_0e75aa9e")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2c01310e = require("@lib/event/helper_2c01310e")
local helper_2f8c501c = require("@lib/event/helper_2f8c501c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_87747ba2 = require("@lib/event/helper_87747ba2")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_240f7986()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(444, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(53)
		event.load_map_sounds(4829)
		var0 = event.load_sound_effect_file_2(4829) or var0
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
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e444/")
		event.load_message_file(0, 5, "e444_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e444_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e444_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e444_shigura.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.copy_character(5, 10, 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.copy_character(5, 10, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e444/e444_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e400/e444/e444_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.assign_memory_stack(6)
		event.clear_memory_stack(6)
		event.change_directory("event/e400/e444/")
		event.load_character(6, "e444_jamming.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.load_character(6, "e440_sourcer.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(6, 14)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(6, "e444_break.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_character_to_frame(14, "null6", 15)
		event.load_character(6, "e444_guiltoni.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(7, 16)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.load_character(6, "e444_soldier.gltf", "info", 17)
		event.set_character_active(0, 17)
		event.copy_character(6, 17, 18)
		event.set_character_active(0, 18)
		event.change_directory("")
		event.attach_object_handle_to_map_part_2(11, "p01_battleship")
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.attach_object_handle_to_character(12, 1)
		event.attach_object_handle_to_character(13, 2)
		event.set_object_handle_visible(12, 0)
		event.set_object_handle_visible(13, 0)
		event.set_object_handle_position(0, 252.3, 0.0, 357.5)
		event.set_object_handle_rotation(0, 0.0, 1.2, 0.0)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_position(1, 258.89, 0.0, 341.43)
		event.set_object_handle_rotation(1, 0.0, 1.2, 0.0)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_position(2, 545.17, 0.0, -7.91)
		event.set_object_handle_rotation(2, 0.0, -0.72, 0.0)
		event.set_object_handle_sound_bank(2, var0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目赤")
		event.set_object_handle_position(3, 129.15, 0.0, -26.35)
		event.set_object_handle_rotation(3, 0.0, 0.6, 0.0)
		event.set_object_handle_sound_bank(3, var0)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目赤")
		event.set_object_handle_position(4, 570.53, 0.0, 382.62)
		event.set_object_handle_rotation(4, 0.0, -1.96, 0.0)
		event.set_object_handle_sound_bank(4, var0)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "目赤")
		event.set_object_handle_position(5, 300.33, 240.0, 240.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(5, "落ち前（会話）", 4)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "目パチ")
		event.set_object_handle_position(6, 300.33, 240.0, 240.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_handle_position(7, 2290.9, 1276.37, 2358.88)
		event.set_object_handle_rotation(7, 0.0, -1.92, 0.0)
		event.set_object_handle_motion(7, "下向き立ち", 4)
		event.set_object_handle_texture_animation(7, 0)
		event.set_object_handle_texture_animation(7, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(7, 1, "下目パチ")
		event.set_character_position(17, 2312.3, 1275.66, 2387.69)
		event.set_character_rotation(17, 0.0, -2.16, 0.0)
		event.set_character_position(18, 2327.72, 1275.66, 2348.04)
		event.set_character_rotation(18, 0.0, -1.68, 0.0)
		event.set_object_handle_position(11, 2627.4, 1276.4, 2639.6)
		event.set_object_handle_rotation(11, 0.0, -0.767, 0.0)
		event.enable_drama_skip()
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day_advancing(0)
		event.play_sound_effect(var0, 7)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(300.17, 240.56, 319.36)
		event.set_camera_sequence_look_at(300.43, 248.47, 241.14)
		event.fade_in_screen(30)
		at = 3
		helper_4116e6bb(4440010)
		event.play_sound_effect(var0, 8)
		event.move_object_sequence(6, 300.33, 230.0, 240.0, 4)
		event.rotate_object_sequence(6, 0.2, 0.0, -0.4, 4)
		event.jump_object_sequence(5, 320.44, 0.0, 291.73, -0.14, 60)
		event.rotate_object_sequence(5, 0.0, 0.36, 0.0, 4)
		event.set_object_sequence_motion(5, "落ちるin", 6)
		event.queue_object_sequence_next_motion(5, "落ちる", 4)
		at = 4
		wait_frames(20)
		event.set_camera_sequence_position(318.44, 131.15, 661.43)
		event.set_camera_sequence_look_at(322.58, 144.45, 500.53)
		event.stop_sound_effect(var0, 7)
		event.move_object_sequence(6, 290.33, 180.0, 220.0, 30)
		event.rotate_object_sequence(6, -0.2, -3.14, 0.0, 30)
		at = 5
		wait_frames(30)
		event.set_camera_sequence_position(318.05, 24.6, 353.37)
		event.set_camera_sequence_look_at(322.78, 4.36, 298.93)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "目あき～目とじ")
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.set_object_sequence_motion(5, "落ちた", 2)
		event.wait_object_sequence_motion_end(5)
		at = 6
		helper_4116e6bb(4440020)
		at = 7
		wait_objects(5)
		event.set_camera_sequence_position(295.12, 92.37, 617.16)
		event.set_camera_sequence_look_at(303.66, 107.91, 513.32)
		event.set_object_sequence_motion(4, "パウォーンin", 6)
		event.queue_object_sequence_next_motion(4, "パウォーンループ", 4)
		event.delay_object_sequence_sound_track(4, 10)
		event.play_object_sequence_sound(4, var0, 9)
		event.delay_object_sequence_motion_track(3, 8)
		event.set_object_sequence_motion(3, "パウォーンin", 6)
		event.queue_object_sequence_next_motion(3, "パウォーンループ", 4)
		event.delay_object_sequence_motion_track(2, 20)
		event.set_object_sequence_motion(2, "パウォーンin", 6)
		event.queue_object_sequence_next_motion(2, "パウォーンループ", 4)
		at = 8
		helper_4116e6bb(4440030)
		at = 9
		helper_4116e6bb(4440040)
		at = 10
		wait_objects(2)
		event.set_camera_sequence_position(422.0, 274.04, 460.88)
		event.set_camera_sequence_look_at(457.86, 277.56, 400.77)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "まばたき目パチ")
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "まばたき目パチ")
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "まばたき目パチ")
		event.play_music(0)
		at = 11
		wait_frames(40)
		event.set_camera_sequence_position(218.94, 252.83, 424.76)
		event.set_camera_sequence_look_at(320.08, 29.2, 293.98)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目パチ")
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "目パチ")
		event.play_sound_effect(var0, 10)
		event.set_object_sequence_position(2, 614.03, 0.0, 217.01)
		event.set_object_sequence_rotation(2, 0.0, -1.32, 0.0)
		event.set_object_sequence_motion(2, "くわえるin", 4)
		event.queue_object_sequence_next_motion(2, "くわえるout", 6)
		event.wait_object_sequence_motion_end(2)
		event.set_object_sequence_position(3, 20.52, 0.0, 157.49)
		event.set_object_sequence_rotation(3, 0.0, 1.08, 0.0)
		event.set_object_sequence_motion(3, "見下ろす", 6)
		event.queue_object_sequence_next_motion(3, "見下ろすループ", 4)
		event.set_object_sequence_position(4, 181.65, 0.0, 660.37)
		event.set_object_sequence_rotation(4, 0.0, 2.64, 0.0)
		at = 12
		wait_frames(17)
		event.queue_object_sequence_next_motion(5, "くわえるout", 6)
		at = 13
		wait_objects(2)
		at = 14
		wait_frames(10)
		event.set_camera_sequence_position(229.1, 159.91, 213.0)
		event.set_camera_sequence_look_at(331.44, 4.22, 299.73)
		event.move_camera_sequence_eased(320.69, 24.73, 290.62, 331.44, 4.22, 299.73, 60, 0, 0.8)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "目とじ")
		event.set_object_sequence_motion(2, "なめるin", 6)
		event.queue_object_sequence_next_motion(2, "なめるループ", 4)
		at = 15
		wait_frames(50)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "しか目とじ")
		event.set_object_sequence_motion(5, "なめるループ", 4)
		at = 16
		wait_camera()
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "しか目とじ～目あき")
		event.set_object_sequence_motion(5, "目を覚ます", 2)
		event.queue_object_sequence_next_motion(5, "目を覚ます（会話）", 4)
		at = 17
		wait_frames(30)
		at = 18
		helper_4116e6bb(4440050)
		event.set_camera_sequence_position(394.66, 61.86, 362.9)
		event.set_camera_sequence_look_at(331.44, 4.22, 299.73)
		event.move_camera_sequence_eased(2396.78, 1356.17, 2363.54, 331.44, 4.22, 299.73, 120, 0, 0.2)
		event.play_sound_effect(var0, 12)
		at = 19
		wait_camera()
		at = 20
		wait_frames(30)
		event.set_camera_sequence_position(2123.1, 1250.04, 2302.95)
		event.set_camera_sequence_look_at(2287.46, 1298.13, 2360.01)
		event.move_camera_sequence_eased(2196.82, 1272.46, 2328.55, 2287.46, 1298.13, 2360.01, 30, 0, 1.0)
		event.play_sound_effect(var0, 13)
		event.set_character_active(16)
		event.set_character_active(17)
		event.set_character_active(18)
		event.set_object_sequence_motion(7, "下向き会話", 2)
		event.queue_object_sequence_next_motion(7, "下向き立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		at = 21
		helper_4116e6bb(4440060)
		at = 22
		wait_camera()
		event.set_mouth_texture_animations(7, "通常口パク")
		at = 23
		helper_4116e6bb(4440065)
		event.play_sound_effect(var0, 14)
		event.set_object_sequence_motion(7, "振り返り", 2)
		event.rotate_object_sequence_eased(7, 0.0, 1.2, 0.0, 20, 0, 1.0)
		event.queue_object_sequence_next_motion(7, "歩き", 4)
		event.delay_object_sequence_position_track(7, 45)
		event.move_object_sequence(7, 2312.24, 1276.37, 2366.29, 30)
		at = 24
		wait_frames(30)
		at = 25
		helper_1584c528(4440070, 30)
		at = 26
		wait_objects(7)
		event.stop_sound_effect(var0, 12)
		event.stop_sound_effect(var0, 13)
		event.set_camera_sequence_position(307.51, 36.12, 379.62)
		event.set_camera_sequence_look_at(354.57, 49.17, 421.92)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
		event.delete_character(16)
		event.delete_character(17)
		event.delete_character(18)
		event.change_directory("event/e400/e444/")
		event.start_background_file_loads_3("e444_baru.gltf", "e444_paw.gltf", "e444_shigu.gltf")
		event.play_sound_effect(var0, 15)
		do
			local out1, out2, out3 = event.get_object_handle_position(11)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(vm.f32(vm.sin(vm.f32(-0.767)) * 600.0) + pos_x)
		pos_y = vm.f32(pos_y + 1900.0)
		pos_z = vm.f32(vm.f32(vm.cos(vm.f32(-0.767)) * 600.0) + pos_z)
		event.rotate_object_sequence_eased(11, 0.12, -0.767, 0.0, 60, 0, 1.0)
		event.rotate_object_sequence_eased(11, 0.0, 1.0, 0.0, 60, 1, 1.0)
		event.delay_object_sequence_position_track(11, 10)
		event.move_object_sequence_eased(11, pos_x, pos_y, pos_z, 120, 1, 1.0)
		at = 27
		wait_objects(11)
		pos_x = vm.f32(vm.f32(vm.sin(1.0) * 16000.0) + pos_x)
		pos_y = vm.f32(pos_y - 2000.0)
		pos_z = vm.f32(vm.f32(vm.cos(1.0) * 16000.0) + pos_z)
		event.move_object_sequence(11, pos_x, pos_y, pos_z, 240)
		at = 28
		wait_objects(11)
		at = 29
		helper_479dc9e9()
		event.clear_memory_stack(6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.load_character(6, "e444_baru.gltf", "info", 21)
		event.set_character_active(21)
		event.attach_object_handle_to_character(10, 21)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_handle_position(10, -49.41, 0.0, 184.42)
		event.set_object_handle_rotation(10, 0.0, 1.06, 0.0)
		event.set_object_handle_motion(10, "立ち（下見）", 4)
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "目パチ")
		event.set_object_handle_sound_bank(10, var0)
		event.load_character(6, "e444_paw.gltf", "info", 19)
		event.set_character_active(0, 19)
		event.attach_object_handle_to_character(8, 19)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_object_handle_position(8, 743.96, 0.0, 405.8)
		event.set_object_handle_rotation(8, 0.0, -1.68, 0.0)
		event.set_object_handle_motion(8, "立ち", 4)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "目パチ")
		event.set_object_handle_footstep_sound(8, 14)
		event.load_character(6, "e444_shigu.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.attach_object_handle_to_character(9, 20)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "目パチ")
		event.set_object_handle_position(9, 820.94, 0.0, 396.57)
		event.set_object_handle_rotation(9, 0.0, -1.68, 0.0)
		event.set_object_handle_motion(9, "立ち", 4)
		event.set_object_handle_sound_bank(9, var0)
		event.change_directory("")
		event.move_camera_sequence_eased(199.68, 6.1, 282.7, 354.57, 49.17, 421.92, 60, 0, 1.0)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		at = 30
		wait_camera()
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "左・振り返る", 6)
		event.queue_object_sequence_next_motion(0, "左・振り返るL", 4)
		event.delay_object_sequence_sound_track(0, 26)
		event.play_object_sequence_sound(0, var0, 16)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "バル見右振り返る", 6)
		event.queue_object_sequence_next_motion(1, "バル見右振り返るL", 4)
		at = 31
		helper_4116e6bb(4440080)
		at = 32
		wait_objects(1)
		event.set_camera_sequence_position(231.08, 133.37, 346.07)
		event.set_camera_sequence_look_at(117.53, 106.94, 279.75)
		event.move_camera_sequence_eased(231.08, 133.37, 346.07, 117.53, 192.74, 279.75, 40, 2, 1.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(0, 0.0, -2.08, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, -2.08, 0.0)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		at = 33
		helper_4116e6bb(4440085)
		at = 34
		wait_camera()
		event.set_camera_sequence_position(238.96, 20.42, 316.49)
		event.set_camera_sequence_look_at(263.11, 21.75, 361.47)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "あきれ顔")
		event.set_object_handle_texture_animation(1, 1, "あきれ目パチ")
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 35
		helper_4116e6bb(4440090)
		at = 36
		wait_objects(1)
		event.set_camera_sequence_position(222.1, 248.84, 164.7)
		event.set_camera_sequence_look_at(72.33, 243.65, 235.39)
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "通常目～おどろき目")
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		at = 37
		helper_4116e6bb(4440100)
		event.set_camera_sequence_position(377.63, 113.56, -196.18)
		event.set_camera_sequence_look_at(139.89, 126.6, 285.69)
		event.move_camera_sequence_angle_height_distance_eased(1.08, -13.04, 537.3, 350, 0, 0.2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 38
		helper_4116e6bb(4440110)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 39
		helper_4116e6bb(4440120)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 40
		helper_4116e6bb(4440125)
		at = 41
		wait_camera()
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "半目")
		event.set_object_sequence_motion(10, "頭下げin", 2)
		event.wait_object_sequence_motion_end(10)
		at = 42
		wait_objects(10)
		event.set_mouth_motions(10, "頭下げ（会話）", 0, "頭下げループ", 0)
		at = 43
		helper_4116e6bb(4440130)
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "目とじ")
		event.move_camera_sequence_angle_height_distance_eased(-0.59, -13.04, 537.3, 350, 0, 0.2)
		event.set_mouth_motions(10, "頭下げ（会話）", 0, "頭下げループ", 0)
		at = 44
		helper_4116e6bb(4440140)
		event.set_object_sequence_motion(10, "うなだれるin", 2)
		event.wait_object_sequence_motion_end(10)
		at = 45
		wait_objects(10)
		event.set_mouth_motions(10, "うなだれる（会話）", 0, "うなだれるループ", 0)
		at = 46
		helper_4116e6bb(4440145)
		at = 47
		wait_camera()
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "右・振り向く", 6)
		event.queue_object_sequence_next_motion(0, "右・振り向くL", 4)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "上見から振り返り", 6)
		event.queue_object_sequence_next_motion(1, "上見から振り返りL", 4)
		at = 48
		helper_4116e6bb(4440150)
		event.set_camera_sequence_position(495.19, 17.84, 361.84)
		event.set_camera_sequence_look_at(690.07, 37.26, 383.0)
		event.set_character_active(19)
		event.set_character_active(20)
		event.move_object_sequence(8, 560.22, 0.0, 376.68, 60)
		event.set_object_sequence_motion(8, "走り", 4)
		event.move_object_sequence(9, 730.38, 0.0, 386.74, 60)
		event.set_object_sequence_motion(9, "歩き", 4)
		at = 49
		helper_1584c528(4440160, 50)
		at = 50
		wait_objects(8)
		at = 51
		wait_objects(9)
		event.set_camera_sequence_position(268.74, 17.84, 243.45)
		event.set_camera_sequence_look_at(253.91, 23.46, 365.24)
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "目パチ")
		event.set_object_sequence_rotation(1, 0.0, 2.76, 0.0)
		event.set_object_sequence_motion(1, "右向くL", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "右向く戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 6)
		event.delay_object_sequence_texture_animation_track(1, 16)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "前向き～左向き")
		event.set_object_sequence_rotation(0, 0.0, 3.0, 0.0)
		event.set_object_sequence_motion(0, "右向くL", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 16)
		event.set_object_sequence_motion(0, "右向く戻り", 4, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 6)
		event.delay_object_sequence_texture_animation_track(0, 16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "前向き～左向き")
		event.set_object_sequence_position(8, 320.83, 0.0, 352.35)
		event.set_object_sequence_rotation(8, 0.0, -2.04, 0.0)
		event.move_object_sequence(8, 266.83, 0.0, 323.49, 40)
		event.delay_object_sequence_motion_track(8, 40)
		event.set_object_sequence_motion(8, "息切れ")
		event.set_object_sequence_position(9, 452.72, 0.0, 425.6)
		event.set_object_sequence_rotation(9, 0.0, -2.04, 0.0)
		event.move_object_sequence(9, 389.06, 0.0, 393.13, 60)
		event.delay_object_sequence_motion_track(9, 60)
		event.set_object_sequence_motion(9, "立ち")
		at = 52
		wait_objects(8)
		event.set_camera_sequence_position(248.36, 14.52, 315.22)
		event.set_camera_sequence_look_at(272.47, 6.08, 326.81)
		event.move_camera_sequence_eased(248.36, 14.52, 315.22, 272.47, 17.46, 326.81, 30, 0, 1.0)
		at = 53
		wait_camera()
		at = 54
		wait_frames(20)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(0, 0.0, -2.08, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, -2.08, 0.0)
		event.set_object_sequence_motion(8, "上見立ち", 4)
		event.set_camera_sequence_position(709.01, 282.92, 118.6)
		event.set_camera_sequence_look_at(526.53, 220.56, 171.63)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.play_sound_effect(var0, 17)
		event.set_object_sequence_motion(10, "顔よせin", 6)
		event.wait_object_sequence_motion_end(10)
		at = 55
		wait_objects(10)
		event.set_mouth_motions(10, "顔よせ（会話）", 0, "顔よせループ", 0)
		at = 56
		helper_4116e6bb(4440170)
		event.set_camera_sequence_position(241.68, 16.71, 309.43)
		event.set_camera_sequence_look_at(266.8, 16.62, 323.29)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "てれ目パチ")
		event.set_object_sequence_motion(8, "てれる", 6)
		event.queue_object_sequence_next_motion(8, "てれるL", 4)
		at = 57
		helper_4116e6bb(4440180)
		at = 58
		wait_objects(8)
		event.set_camera_sequence_position(582.83, 16.71, 236.56)
		event.set_camera_sequence_look_at(218.16, 115.67, 270.9)
		event.set_object_sequence_motion(8, "上見立ち", 4)
		event.set_object_sequence_motion(10, "顔よせout", 6)
		event.wait_object_sequence_motion_end(10)
		at = 59
		wait_objects(10)
		at = 60
		wait_frames(30)
		event.set_mouth_motions(10, "シグー見（会話）", 0, "立ち", 0)
		at = 61
		helper_4116e6bb(4440190)
		event.set_camera_sequence_position(223.01, 93.87, 310.22)
		event.set_camera_sequence_look_at(354.09, 88.95, 375.33)
		event.move_camera_sequence_angle_height_distance_eased(2.61, 4.92, 146.36, 120, 0, 0.6)
		at = 62
		helper_4116e6bb(4440195)
		at = 63
		wait_camera()
		event.set_camera_sequence_position(592.78, 70.05, 215.14)
		event.set_camera_sequence_look_at(193.64, 115.67, 314.46)
		event.move_camera_sequence_angle_height_distance_eased(1.09, 289.34, 602.63, 360, 0, 1.0)
		event.set_mouth_motions(10, "シグー見（会話）", 0, "立ち", 0)
		at = 64
		helper_4116e6bb(4440200)
		event.set_mouth_motions(10, "シグー見（会話）", 0, "立ち", 0)
		at = 65
		helper_4116e6bb(4440210)
		event.set_mouth_motions(10, "シグー見（会話）", 0, "立ち", 0)
		at = 66
		helper_4116e6bb(4440220)
		at = 67
		wait_camera()
		event.set_camera_sequence_position(270.35, 12.55, 273.69)
		event.set_camera_sequence_look_at(266.43, 13.93, 321.78)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "さみし目パチ")
		event.set_object_sequence_motion(8, "うなだれ", 4)
		at = 68
		helper_0e75aa9e(4440230, -1, 10)
		event.set_message_button_prompt(0, 1)
		event.delay_object_sequence_motion_track(8, 20)
		event.set_object_sequence_motion(8, "上見る", 2)
		event.queue_object_sequence_next_motion(8, "上見立ち", 4)
		at = 69
		helper_4116e6bb(4440240)
		at = 70
		wait_objects(8)
		at = 71
		helper_4116e6bb(4440245)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "笑い目とじ")
		event.set_object_sequence_motion(8, "じゃれる", 6)
		event.queue_object_sequence_next_motion(8, "じゃれるL", 4)
		event.set_object_sequence_position(9, 378.05, 0.0, 378.96)
		event.set_object_sequence_motion(9, "じゃれる", 6)
		event.queue_object_sequence_next_motion(9, "じゃれるL", 4)
		at = 72
		wait_objects(9)
		at = 73
		helper_4116e6bb(4440250)
		event.set_camera_sequence_position(224.1, 15.74, 287.53)
		event.set_camera_sequence_look_at(268.95, 17.12, 321.25)
		event.move_camera_sequence_eased(248.67, 15.74, 306.0, 268.95, 17.12, 321.25, 60, 0, 1.0)
		event.set_object_sequence_motion(1, "右向くL", 4, -1.0, 1)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "さみし目～片目とじ")
		at = 74
		helper_4116e6bb(4440260)
		at = 75
		wait_camera()
		event.fade_out_music(60)
		event.fade_out_screen(60)
		at = 76
		wait_frames(60)
		at = 77
		wait_frames(30)
		event.set_camera_sequence_position(923.53, 319.36, 605.97)
		event.set_camera_sequence_look_at(937.39, 309.52, 676.43)
		event.stop_music(0)
		at = 78
		wait_frames(4)
		event.load_music(112)
		event.set_time_of_day(17.5)
		event.set_object_sequence_position(0, 324.85, 0.0, 743.21)
		event.set_object_sequence_rotation(0, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 339.43, 0.0, 730.36)
		event.set_object_sequence_rotation(1, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(8, 358.56, 0.0, 715.56)
		event.set_object_sequence_rotation(8, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(8, "上見立ち", 4)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "目パチ")
		event.set_object_sequence_position(9, 354.38, 0.0, 381.34)
		event.set_object_sequence_rotation(9, 0.0, 0.36, 0.0)
		event.set_object_sequence_motion(9, "立ち", 4)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "目パチ")
		event.set_object_sequence_position(10, 84.12, 0.0, 476.19)
		event.set_object_sequence_rotation(10, 0.0, 0.7, 0.0)
		event.set_object_sequence_motion(10, "立ち（下見）", 4)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(260)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 937.39, 309.52, 676.43)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 902.6, 309.52, 674.74)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 882.59, 309.48, 665.11)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 865.02, 306.16, 647.98)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 852.74, 302.36, 620.25)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 851.29, 295.52, 603.41)
		event.start_camera_sequence_path()
		event.fade_in_screen(60)
		at = 79
		wait_camera()
		event.start_crossfade(60)
		event.set_camera_sequence_position(223.45, 515.0, 150.38)
		event.set_camera_sequence_look_at(212.66, 211.08, 449.02)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "さみし顔")
		event.set_object_handle_texture_animation(0, 1, "さみし目パチ")
		at = 80
		wait_frames(30)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		at = 81
		helper_4116e6bb(4440270)
		at = 82
		wait_objects(10)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 83
		helper_4116e6bb(4440280)
		at = 84
		wait_objects(0)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "うなだれる", 6)
		event.queue_object_sequence_next_motion(0, "うなだれるL", 4)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		at = 85
		helper_4116e6bb(4440290)
		at = 86
		wait_objects(0)
		event.set_object_sequence_motion(0, "うなだれる戻り", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		at = 87
		helper_4116e6bb(4440300)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		at = 88
		helper_4116e6bb(4440305)
		event.play_sound_effect(var0, 18)
		event.set_object_sequence_motion(10, "歩き")
		event.set_object_sequence_motion_blend_step(10, 0.02)
		event.rotate_object_sequence_eased(10, 0.0, -0.74, 0.0, 60, 0, 1.0)
		event.move_object_sequence_eased(10, -91.56, 0.0, 632.05, 160, 1, 1.0)
		at = 89
		wait_objects(10)
		event.set_camera_sequence_position(4.01, 520.98, 81.91)
		event.set_camera_sequence_look_at(-200.88, 47.61, 516.52)
		event.set_object_sequence_position(10, -330.83, 0.0, 588.98)
		event.set_object_sequence_rotation(10, 0.0, -1.1, 0.0)
		event.move_object_sequence(10, -606.74, -12.0, 763.16, 220)
		event.set_object_sequence_motion(10, "水歩き", 4)
		event.set_character_active(10)
		event.set_object_sequence_position(2, 45.1, 0.0, 642.1)
		event.set_object_sequence_rotation(2, 0.0, -1.1, 0.0)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.set_object_sequence_motion_time(2, 12.0)
		event.move_object_sequence(2, -182.51, 0.0, 778.98, 220)
		event.set_character_active(11)
		event.set_object_sequence_position(3, 13.41, 0.0, 156.64)
		event.set_object_sequence_rotation(3, 0.0, -1.1, 0.0)
		event.set_object_sequence_motion(3, "歩き", 4)
		event.set_object_sequence_motion_time(3, 20.0)
		event.move_object_sequence(3, -190.65, 0.0, 240.14, 220)
		at = 90
		wait_objects(10)
		event.set_camera_sequence_position(163.44, 190.58, 781.74)
		event.set_camera_sequence_look_at(-41.96, 53.55, 668.25)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "さみし目パチ")
		event.play_music(0)
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.set_character_active(0, 8)
		event.set_character_active(0, 21)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_object_sequence_position(8, -50.0, 0.0, 725.0)
		event.set_object_sequence_rotation(8, 0.0, -3.14, 0.0)
		event.set_object_sequence_motion(8, "上見立ち", 4)
		event.set_object_sequence_position(9, -50.0, 0.0, 530.0)
		event.set_object_sequence_rotation(9, 0.0, 0.0, 0.0)
		event.move_object_sequence(9, -50.0, 0.0, 590.0, 60)
		event.set_object_sequence_motion(9, "歩き", 4)
		event.delay_object_sequence_motion_track(9, 60)
		event.set_object_sequence_motion(9, "立ち")
		at = 91
		wait_frames(80)
		event.play_sound_effect(var0, 19)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "目あき～目とじ")
		event.set_object_sequence_motion(8, "なでる", 6)
		event.queue_object_sequence_next_motion(8, "なでるL", 4)
		event.set_object_sequence_motion(9, "なでる", 6)
		event.queue_object_sequence_next_motion(9, "なでるL", 4)
		at = 92
		helper_4116e6bb(4440310)
		at = 93
		wait_objects(8)
		at = 94
		helper_4116e6bb(4440320)
		event.play_sound_effect(var0, 20)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "目とじ～目あき")
		event.set_object_sequence_motion(9, "なでる戻り", 6)
		event.queue_object_sequence_next_motion(9, "立ち", 4)
		event.set_object_sequence_motion(8, "なでる戻り", 6)
		event.queue_object_sequence_next_motion(8, "うなだれ", 4)
		at = 95
		helper_4116e6bb(4440330)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "通常目～さみし目")
		event.set_object_sequence_motion(8, "左指す", 6)
		event.queue_object_sequence_next_motion(8, "左指すL", 4)
		at = 96
		helper_4116e6bb(4440335)
		at = 97
		wait_objects(8)
		event.delay_object_sequence_motion_track(9, 24)
		event.set_object_sequence_motion(9, "左見る", 6)
		event.queue_object_sequence_next_motion(9, "左見るL", 4)
		event.set_object_sequence_motion(8, "左指す戻り", 6)
		event.queue_object_sequence_next_motion(8, "うつむき走り")
		at = 98
		wait_objects(8)
		event.rotate_object_sequence(8, 0.0, 1.57, 0.0, 8)
		event.move_object_sequence(8, 35.37, 0.0, 725.0, 30)
		at = 99
		wait_objects(8)
		event.set_camera_sequence_position(242.62, 3.04, 743.15)
		event.set_camera_sequence_look_at(144.17, 27.78, 743.82)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "さみし目パチ")
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "泣き目とじ")
		event.set_character_active(21)
		event.set_object_sequence_position(10, -6173.0, -82.0, 401.0)
		event.set_object_sequence_rotation(10, 0.0, -1.58, 0.0)
		event.set_character_active(10)
		event.set_object_sequence_position(2, -4863.0, -82.0, -403.0)
		event.set_object_sequence_rotation(2, 0.0, -1.58, 0.0)
		event.set_character_active(11)
		event.set_object_sequence_position(3, -3769.0, -82.0, 836.0)
		event.set_object_sequence_rotation(3, 0.0, -1.46, 0.0)
		event.set_object_sequence_position(8, 190.82, 0.0, 753.88)
		event.set_object_sequence_motion(8, "泣く", 4)
		event.set_object_sequence_position(9, -49.43, 0.0, 673.38)
		at = 100
		helper_4116e6bb(4440340)
		event.set_object_sequence_motion(9, "左見る戻り", 2)
		event.queue_object_sequence_next_motion(9, "歩き")
		event.set_object_sequence_motion_blend_step(9, 0.02)
		event.delay_object_sequence_motion_track(9, 140)
		event.queue_object_sequence_next_motion(9, "水歩き", 4)
		event.rotate_object_sequence_eased(9, 0.0, -1.57, 0.0, 60, 0, 1.0)
		event.move_object_sequence_eased(9, -838.9, -25.0, 648.72, 300, 1, 1.0)
		at = 101
		helper_87747ba2(4440350, 300)
		at = 102
		wait_objects(9)
		event.set_object_sequence_motion(9, "立ち")
		event.set_object_sequence_motion_blend_step(9, 0.02)
		at = 103
		wait_frames(20)
		event.set_object_sequence_motion(9, "左見る", 6)
		event.queue_object_sequence_next_motion(9, "左見るL", 4)
		at = 104
		wait_objects(9)
		at = 105
		wait_frames(30)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "なみだ目")
		event.delay_object_sequence_motion_track(8, 10)
		event.wait_object_sequence_motion_end(8)
		event.set_object_sequence_motion(8, "顔上げる", 6)
		event.queue_object_sequence_next_motion(8, "立ち", 4)
		event.delay_object_sequence_texture_animation_track(8, 10)
		event.set_object_sequence_texture_animation(8, 1, "泣き目とじ～目あけ")
		at = 106
		helper_4116e6bb(4440360)
		at = 107
		wait_objects(8)
		at = 108
		wait_frames(10)
		event.set_object_sequence_motion(9, "左見る戻り", 6)
		event.queue_object_sequence_next_motion(9, "歩き")
		event.play_sound_effect(var0, 21)
		event.rotate_object_sequence(8, 0.0, -1.57, 0.0, 10)
		event.move_object_sequence(8, -125.45, 0.0, 754.45, 60)
		event.set_object_sequence_motion(8, "走り")
		event.delay_object_sequence_motion_track(8, 60)
		event.set_object_sequence_motion(8, "叫ぶ")
		at = 109
		wait_frames(40)
		event.set_camera_sequence_position(-997.46, 75.59, 665.14)
		event.set_camera_sequence_look_at(-897.68, 82.51, 666.04)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "泣き目パチ")
		event.set_object_sequence_motion(9, "立ち")
		event.set_object_sequence_motion_blend_step(9, 0.02)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "なみだ目～うれし目")
		at = 110
		helper_4116e6bb(4440370)
		event.set_camera_sequence_position(-772.6, 67.51, 676.22)
		event.set_camera_sequence_look_at(-873.85, 79.6, 666.69)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "キラ目")
		event.set_object_sequence_motion(9, "左見る", 6)
		event.queue_object_sequence_next_motion(9, "左見るL", 4)
		at = 111
		wait_objects(9)
		at = 112
		helper_4116e6bb(4440380)
		event.move_camera_sequence_eased(-48.23, 14.46, 744.38, -873.85, 79.6, 666.69, 60.0, 0, 1.0)
		event.set_object_sequence_motion(8, "手を振る", 4)
		event.set_object_sequence_motion(9, "左見る戻り", 2)
		event.queue_object_sequence_next_motion(9, "立ち", 4)
		event.set_object_sequence_motion_blend_step(9, 0.02)
		at = 113
		wait_camera()
		at = 114
		helper_4116e6bb(4440390)
		at = 115
		helper_4116e6bb(4440400)
		event.set_character_visible(20, 0, 1, 0.01)
		event.set_character_visible(11, 0, 1, 0.01)
		event.set_character_visible(10, 0, 1, 0.01)
		event.set_character_visible(21, 0, 1, 0.01)
		at = 116
		helper_4116e6bb(4440410)
		at = 117
		helper_4116e6bb(4440420)
		event.set_scene_character_type(19, 4)
		event.set_character_visible(19, 0, 1, 0.01)
		at = 118
		helper_4116e6bb(4440430)
		at = 119
		wait_frames(4)
		event.start_crossfade(60)
		event.set_character_active(0, 19)
		event.set_time_of_day(24.0)
		at = 120
		helper_4116e6bb(4440435)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 121
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(4)
		end
		if at <= 2 then
			local _ = active_chr_no == 2
			active_chr_no = 0
			local _ = active_chr_no == 3
			active_chr_no = 1
			helper_8cd371d7(4440010)
		end
		if at <= 3 then
			wait_frames_skipping(20)
		end
		if at <= 4 then
			wait_frames_skipping(30)
		end
		if at <= 5 then
			helper_8cd371d7(4440020)
		end
		if at <= 6 then
			helper_238b5abc(5)
		end
		if at <= 7 then
			helper_8cd371d7(4440030)
		end
		if at <= 8 then
			helper_8cd371d7(4440040)
		end
		if at <= 9 then
			helper_238b5abc(2)
		end
		if at <= 10 then
			wait_frames_skipping(40)
		end
		if at <= 11 then
			wait_frames_skipping(17)
		end
		if at <= 12 then
			helper_238b5abc(2)
		end
		if at <= 13 then
			wait_frames_skipping(10)
		end
		if at <= 14 then
			wait_frames_skipping(50)
		end
		if at <= 15 then
			helper_344d6cd8()
		end
		if at <= 16 then
			wait_frames_skipping(30)
		end
		if at <= 17 then
			helper_8cd371d7(4440050)
		end
		if at <= 18 then
			helper_344d6cd8()
		end
		if at <= 19 then
			wait_frames_skipping(30)
		end
		if at <= 20 then
			helper_8cd371d7(4440060)
		end
		if at <= 21 then
			helper_344d6cd8()
		end
		if at <= 22 then
			helper_8cd371d7(4440065)
		end
		if at <= 23 then
			wait_frames_skipping(30)
		end
		if at <= 24 then
			helper_52aadc70(4440070, 30)
		end
		if at <= 25 then
			helper_238b5abc(7)
		end
		if at <= 26 then
			pos_x = vm.f32(vm.f32(vm.sin(vm.f32(-0.767)) * 600.0) + pos_x)
			pos_y = vm.f32(pos_y + 1900.0)
			pos_z = vm.f32(vm.f32(vm.cos(vm.f32(-0.767)) * 600.0) + pos_z)
			helper_238b5abc(11)
		end
		if at <= 27 then
			pos_x = vm.f32(vm.f32(vm.sin(1.0) * 16000.0) + pos_x)
			pos_y = vm.f32(pos_y - 2000.0)
			pos_z = vm.f32(vm.f32(vm.cos(1.0) * 16000.0) + pos_z)
			helper_238b5abc(11)
		end
		if at <= 28 then
			helper_344d6cd8()
		end
		if at <= 29 then
			helper_344d6cd8()
		end
		if at <= 30 then
			helper_8cd371d7(4440080)
		end
		if at <= 31 then
			helper_238b5abc(1)
		end
		if at <= 32 then
			helper_8cd371d7(4440085)
		end
		if at <= 33 then
			helper_344d6cd8()
		end
		if at <= 34 then
			helper_8cd371d7(4440090)
		end
		if at <= 35 then
			helper_238b5abc(1)
		end
		if at <= 36 then
			helper_8cd371d7(4440100)
		end
		if at <= 37 then
			helper_8cd371d7(4440110)
		end
		if at <= 38 then
			helper_8cd371d7(4440120)
		end
		if at <= 39 then
			helper_8cd371d7(4440125)
		end
		if at <= 40 then
			helper_344d6cd8()
		end
		if at <= 41 then
			helper_238b5abc(10)
		end
		if at <= 42 then
			helper_8cd371d7(4440130)
		end
		if at <= 43 then
			helper_8cd371d7(4440140)
		end
		if at <= 44 then
			helper_238b5abc(10)
		end
		if at <= 45 then
			helper_8cd371d7(4440145)
		end
		if at <= 46 then
			helper_344d6cd8()
		end
		if at <= 47 then
			helper_8cd371d7(4440150)
		end
		if at <= 48 then
			helper_52aadc70(4440160, 50)
		end
		if at <= 49 then
			helper_238b5abc(8)
		end
		if at <= 50 then
			helper_238b5abc(9)
		end
		if at <= 51 then
			helper_238b5abc(8)
		end
		if at <= 52 then
			helper_344d6cd8()
		end
		if at <= 53 then
			wait_frames_skipping(20)
		end
		if at <= 54 then
			helper_238b5abc(10)
		end
		if at <= 55 then
			helper_8cd371d7(4440170)
		end
		if at <= 56 then
			helper_8cd371d7(4440180)
		end
		if at <= 57 then
			helper_238b5abc(8)
		end
		if at <= 58 then
			helper_238b5abc(10)
		end
		if at <= 59 then
			wait_frames_skipping(30)
		end
		if at <= 60 then
			helper_8cd371d7(4440190)
		end
		if at <= 61 then
			helper_8cd371d7(4440195)
		end
		if at <= 62 then
			helper_344d6cd8()
		end
		if at <= 63 then
			helper_8cd371d7(4440200)
		end
		if at <= 64 then
			helper_8cd371d7(4440210)
		end
		if at <= 65 then
			helper_8cd371d7(4440220)
		end
		if at <= 66 then
			helper_344d6cd8()
		end
		if at <= 67 then
			helper_2f8c501c(4440230, -1, 10)
		end
		if at <= 68 then
			helper_8cd371d7(4440240)
		end
		if at <= 69 then
			helper_238b5abc(8)
		end
		if at <= 70 then
			helper_8cd371d7(4440245)
		end
		if at <= 71 then
			helper_238b5abc(9)
		end
		if at <= 72 then
			helper_8cd371d7(4440250)
		end
		if at <= 73 then
			helper_8cd371d7(4440260)
		end
		if at <= 74 then
			helper_344d6cd8()
		end
		if at <= 75 then
			wait_frames_skipping(60)
		end
		if at <= 76 then
			wait_frames_skipping(30)
		end
		if at <= 77 then
			wait_frames_skipping(4)
		end
		if at <= 78 then
			helper_344d6cd8()
		end
		if at <= 79 then
			wait_frames_skipping(30)
		end
		if at <= 80 then
			helper_8cd371d7(4440270)
		end
		if at <= 81 then
			helper_238b5abc(10)
		end
		if at <= 82 then
			helper_8cd371d7(4440280)
		end
		if at <= 83 then
			helper_238b5abc(0)
		end
		if at <= 84 then
			helper_8cd371d7(4440290)
		end
		if at <= 85 then
			helper_238b5abc(0)
		end
		if at <= 86 then
			helper_8cd371d7(4440300)
		end
		if at <= 87 then
			helper_8cd371d7(4440305)
		end
		if at <= 88 then
			helper_238b5abc(10)
		end
		if at <= 89 then
			helper_238b5abc(10)
		end
		if at <= 90 then
			wait_frames_skipping(80)
		end
		if at <= 91 then
			helper_8cd371d7(4440310)
		end
		if at <= 92 then
			helper_238b5abc(8)
		end
		if at <= 93 then
			helper_8cd371d7(4440320)
		end
		if at <= 94 then
			helper_8cd371d7(4440330)
		end
		if at <= 95 then
			helper_8cd371d7(4440335)
		end
		if at <= 96 then
			helper_238b5abc(8)
		end
		if at <= 97 then
			helper_238b5abc(8)
		end
		if at <= 98 then
			helper_238b5abc(8)
		end
		if at <= 99 then
			helper_8cd371d7(4440340)
		end
		if at <= 100 then
			helper_2c01310e(4440350, 300)
		end
		if at <= 101 then
			helper_238b5abc(9)
		end
		if at <= 102 then
			wait_frames_skipping(20)
		end
		if at <= 103 then
			helper_238b5abc(9)
		end
		if at <= 104 then
			wait_frames_skipping(30)
		end
		if at <= 105 then
			helper_8cd371d7(4440360)
		end
		if at <= 106 then
			helper_238b5abc(8)
		end
		if at <= 107 then
			wait_frames_skipping(10)
		end
		if at <= 108 then
			wait_frames_skipping(40)
		end
		if at <= 109 then
			helper_8cd371d7(4440370)
		end
		if at <= 110 then
			helper_238b5abc(9)
		end
		if at <= 111 then
			helper_8cd371d7(4440380)
		end
		if at <= 112 then
			helper_344d6cd8()
		end
		if at <= 113 then
			helper_8cd371d7(4440390)
		end
		if at <= 114 then
			helper_8cd371d7(4440400)
		end
		if at <= 115 then
			helper_8cd371d7(4440410)
		end
		if at <= 116 then
			helper_8cd371d7(4440420)
		end
		if at <= 117 then
			helper_8cd371d7(4440430)
		end
		if at <= 118 then
			wait_frames_skipping(4)
		end
		if at <= 119 then
			helper_8cd371d7(4440435)
		end
		if at <= 120 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 122
	vm.entry(122)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(var0, 7)
	event.stop_sound_effect(var0, 12)
	event.stop_sound_effect(var0, 13)
	event.stop_sound_effect(var0, 15)
	event.change_directory("")
	event.set_character_active(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
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
	event.delete_character(20)
	event.delete_character(21)
	event.load_message_file(0, -1)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(12, 1)
	event.set_object_handle_visible(13, 1)
	event.finish_event()
end

return helper_240f7986
