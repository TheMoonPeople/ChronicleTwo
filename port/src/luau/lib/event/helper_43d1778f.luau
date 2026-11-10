--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_43d1778f()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local result: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(520, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(35)
		event.load_map_sounds(5806)
		var0 = event.load_sound_effect_file_2(5806) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		print("1--------------------------------\n")
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
			active_chr_no = 0
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
			active_chr_no = 1
		end
		event.change_directory("event/e500/e520/")
		event.load_message_file(0, 5, "e520_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e520_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e520_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 9)
			event.load_equipment_model(5, 0, 4, "info", 9)
			event.load_equipment_model(5, 0, 3, "info", 9)
			event.load_equipment_model(5, 0, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e500/e520/e520_mints.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 9)
			event.attach_object_handle_to_character(0, 9)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 9)
			event.load_equipment_model(5, 1, 4, "info", 9)
			event.load_equipment_model(5, 1, 3, "info", 9)
			event.load_equipment_model(5, 1, 2, "info", 9, 10)
			event.load_equipment_model(5, 1, 0, "info", 9, 14)
			event.load_character_motion_pack(5, "event/e500/e520/e520_monica.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.attach_object_handle_to_character(5, 14)
			event.clear_object_sequence(5)
			event.set_object_sequence_object(5, 5)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(9)
		event.set_character_active(10)
		event.load_character(5, "event/e500/e520/e520_guiltoni.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2, 11)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e500/e520/e520_dsmoke.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(3, 12)
		event.clear_object_sequence(3, 12)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e500/e520/e520_mahou_h.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(4, 13)
		event.clear_object_sequence(4, 13)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_2(16, "p01_battleship")
		event.clear_object_sequence(16)
		event.set_object_sequence_object(16, 16)
		event.attach_object_handle_to_map_part_2(17, "p03_s2001")
		event.clear_object_sequence(17)
		event.set_object_sequence_object(17, 17)
		event.attach_object_handle_to_map_part_2(18, "p04_s2001")
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.attach_object_handle_to_map_part_2(19, "firesquall")
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.attach_object_handle_to_map_part_2(20, "p01_s2001")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.set_object_handle_visible(20, 1)
		event.create_character_sword_effect(14, 0, 5, 16, 8)
		event.set_character_sword_effect_texture(14, 0, 74, "sweff", 0, 0, 64, 32)
		event.create_character_sword_effect(14, 1, 5, 16, 8)
		event.set_character_sword_effect_texture(14, 1, 74, "sweff", 0, 0, 64, 32)
		event.initialize_effect_manager(5)
		event.load_effect_base("EVモニカ魔法－火")
		event.load_effect_base("EVモニカ魔法－火ヒット")
		event.load_effect_base("モニカ魔法－溜め")
		event.create_effect_work_buffer(5)
		event.set_character_active(0, 14)
		event.set_object_handle_position(0, -3391.16, 181.07, 100.69)
		event.set_object_handle_rotation(0, 0.0, -1.89, 0.0)
		event.set_object_handle_motion(0, "爆弾セット", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -792.45, 0.0, 2890.7)
		event.set_object_handle_rotation(1, 0.0, -2.13, 0.0)
		event.set_object_handle_motion(1, "走り", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -1961.74, 308.38, 537.92)
		event.set_object_handle_rotation(2, 0.0, 0.51, 0.0)
		event.set_object_handle_motion(2, "ガキどもめ", 4)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_handle_position(16, 1209.2, 1334.3, 0.0)
		event.set_object_handle_rotation(16, 0.0, -1.5707964, 0.0)
		event.set_object_handle_position(3, 1209.2, 1334.3, 0.0)
		event.set_object_handle_rotation(3, 0.0, -2.65, 0.0)
		event.set_object_handle_visible(2, 1)
		event.set_object_handle_visible(3, 1)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(16, 1)
		event.set_object_handle_visible(17, 0)
		event.set_object_handle_visible(18, 1)
		event.set_object_handle_visible(19, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1069.43, 18.8, 3159.35)
		event.set_camera_sequence_look_at(-1009.32, 43.21, 3030.33)
		event.set_event_projection(524.9)
		event.set_character_active(0)
		event.set_character_active(9)
		event.set_character_active(10)
		event.move_object_sequence(16, -389.1, 820, 0.0, 120)
		event.move_object_sequence(3, -389.1, 820, 0.0, 120)
		event.set_object_sequence_motion(1, "右向き走り")
		event.move_object_sequence(1, -985.05, 0.0, 2803.03, 120, 1)
		event.set_object_handle_frame_visible(2, "obj89", 0)
		event.set_scene_status_flags(1, 0, 8, 1)
		event.set_scene_status_flags(1, 9, 8, 1)
		event.set_scene_status_flags(1, 11, 8, 1)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		print("2--------------------------------\n")
		event.play_sound_effect(var0, 2)
		at = 3
		wait_frames(120)
		print("3--------------------------------\n")
		event.set_camera_sequence_position(-1986.48, 333.67, 558.59)
		event.set_camera_sequence_look_at(-1965.0, 337.43, 540.26)
		event.stop_sound_effect(var0, 2)
		event.play_sound_effect(var0, 3)
		print("4--------------------------------\n")
		event.set_object_sequence_position(16, -1947.7, 307.5, 101.3)
		event.set_object_sequence_rotation(16, 0.0, -2.1031218, 0.0)
		event.set_object_sequence_position(3, 1209.2, 1334.3, 0.0)
		event.set_object_sequence_rotation(3, 0.0, -2.1031218, 0.0)
		event.set_object_sequence_position(1, -2813.58, 84.71, 768.64)
		event.set_object_sequence_rotation(1, 0.0, 2.47, 0.0)
		x = vm.f32(-2438.17)
		y = vm.f32(332.67)
		z = 341.25
		do
			local out1, out2, out3 = event.subtract_vectors(x, y, z, -2380.18, 330.38, 324.27)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		event.set_wind(10, x, y, z)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "下目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 4
		helper_1584c528(5200010, -1)
		event.stop_sound_effect(var0, 3)
		event.play_sound_effect(var0, 4)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		event.set_object_sequence_motion(2, "落ちる", 6)
		event.queue_object_sequence_next_motion(2, "落ちるL", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "下向き～上向き")
		at = 5
		wait_frames(10)
		at = 6
		wait_camera()
		event.stop_sound_effect(var0, 4)
		event.play_music(0)
		event.set_camera_sequence_position(-2696.98, 45.16, 871.07)
		event.set_camera_sequence_look_at(-2807.7, 201.06, 594.2)
		event.play_sound_effect(var0, 5)
		event.play_sound_effect(var0, 6)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		event.set_object_handle_footstep_sound(1, 6)
		event.move_object_sequence(1, -2763.63, 157.55, 674.32, 60)
		at = 7
		wait_frames(60)
		event.stop_sound_effect(var0, 6)
		event.move_object_sequence(1, -2672.25, 236.43, 545.71, 60)
		at = 8
		wait_frames(60)
		event.stop_sound_effect(var0, 5)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		event.set_object_sequence_position(2, -1997.03, 308.38, 480.43)
		event.set_object_sequence_rotation(2, 0.0, -2.61, 0.0)
		event.set_object_sequence_motion(2, "なに？")
		event.set_object_sequence_position(1, -2470.35, 281.36, 358.2)
		event.set_object_sequence_rotation(1, 0.0, 1.99, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_event_projection(350.9)
		event.set_camera_sequence_position(-2437.16, 269.25, 417.91)
		event.set_camera_sequence_look_at(-2453.36, 309.91, 353.75)
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_motion(1, "飛び", 6)
		event.queue_object_sequence_next_motion(1, "飛びL", 4)
		event.move_object_sequence(1, -2414.26, 303.6, 328.1, 60)
		event.move_camera_sequence(-2415.91, 282.04, 390.68, -2416.07, 304.55, 359.36, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "大口パク")
		at = 9
		helper_1584c528(5200020, 50)
		at = 10
		wait_frames(5)
		event.set_object_sequence_position(1, -2282.71, 308.37, 346.12)
		event.set_camera_sequence_position(-2025.37, 340.27, 478.9)
		event.set_camera_sequence_look_at(-1996.22, 338.59, 478.94)
		event.set_event_projection(524.9)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "下目～おどろき目")
		event.set_mouth_texture_animations(2, "大口パク")
		at = 11
		helper_1584c528(5200030, -1)
		event.set_camera_sequence_position(-1937.42, 385.84, 606.52)
		event.set_camera_sequence_look_at(-2052.1, 341.76, 476.36)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_footstep_sound(1, 2)
		event.delay_object_sequence_sound_track(1, 30)
		event.play_object_sequence_sound(1, var0, 9)
		event.set_object_sequence_motion(1, "着地2", 4)
		event.set_object_sequence_motion_step(1, 0.25)
		event.queue_object_sequence_next_motion(1, "着地立ち", 6)
		event.set_object_sequence_rotation(1, 0.0, 1.99, 0.0)
		at = 12
		wait_frames(30)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-2045.44, 316.91, 227.14)
		event.set_camera_sequence_look_at(-2093.8, 322.86, 203.57)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_character_active(14)
		event.set_object_sequence_position(1, -2098.82, 307.87, 203.15)
		event.set_object_sequence_rotation(1, 0.0, 3.07, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		at = 13
		wait_frames(90)
		event.set_object_sequence_motion(2, "ガード連スタート", 4)
		event.set_object_sequence_motion(1, "魔法構え", 6)
		event.queue_object_sequence_next_motion(1, "魔法構えL", 4)
		event.set_object_sequence_position(2, -2098.82, 307.87, 203.15)
		event.set_object_sequence_rotation(2, 0.0, 1.27, 0.0)
		at = 14
		wait_objects(1)
		event.play_sound_effect(var0, 10)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(1, "item")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		result = event.create_effect_3("モニカ魔法－溜め", 9) or result
		event.set_effect_first_vector(pos_x, pos_y, pos_z)
		event.set_effect_second_vector(128, 64, 64)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 15
		helper_1584c528(5200040, -1)
		at = 16
		wait_frames(30)
		event.set_object_sequence_motion(1, "魔法撃つ", 4)
		event.stop_sound_effect(var0, 10)
		event.play_sound_effect(var0, 11)
		event.create_effect_2("EVモニカ魔法－火", 9)
		event.set_effect_first_vector(pos_x, pos_y, pos_z)
		event.set_effect_target(-1)
		event.finish_effect(9, result)
		at = 17
		wait_frames(20)
		event.set_object_sequence_motion(1, "魔法撃つ", 4)
		event.play_sound_effect(var0, 11)
		event.create_effect_2("EVモニカ魔法－火", 9)
		event.set_effect_first_vector(pos_x, pos_y, pos_z)
		event.set_effect_target(-1)
		event.finish_effect(9, result)
		at = 18
		wait_frames(10)
		event.set_object_sequence_motion(1, "魔法撃つ", 4)
		event.play_sound_effect(var0, 11)
		event.create_effect_2("EVモニカ魔法－火", 9)
		event.set_effect_first_vector(pos_x, pos_y, pos_z)
		event.set_effect_target(-1)
		event.finish_effect(9, result)
		at = 19
		wait_frames(10)
		event.set_object_handle_visible(20, 0)
		event.set_camera_sequence_position(-1961.75, 323.59, 207.69)
		event.set_camera_sequence_look_at(-2049.52, 323.57, 217.76)
		event.set_object_sequence_rotation(1, 0.0, 1.27, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.play_sound_effect(var0, 12)
		event.set_scene_character_type(13, 4)
		event.set_object_handle_visible(4, 1)
		event.set_object_sequence_position(4, -2039.14, 327.12, 209.19)
		event.set_object_sequence_motion(4, "魔法ヒット", 6)
		at = 20
		wait_objects(4)
		at = 21
		wait_frames(30)
		event.play_sound_effect(var0, 13)
		event.set_object_sequence_motion(1, "よけ2つ")
		event.wait_object_sequence_motion_end(1)
		event.set_object_sequence_motion(2, "よけ2つ")
		event.wait_object_sequence_motion_end(2)
		at = 22
		wait_frames(15)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		at = 23
		wait_frames(15)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		at = 24
		wait_frames(10)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		at = 25
		wait_frames(20)
		event.set_object_handle_frame_visible(2, "obj88", 0)
		event.set_object_handle_frame_visible(2, "obj89", 1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		event.set_camera_sequence_position(-2063.52, 323.93, 286.2)
		event.set_camera_sequence_look_at(-2027.6, 321.15, 217.1)
		event.set_object_sequence_position(2, -2027.94, 307.87, 217.37)
		event.set_object_sequence_rotation(2, 0.0, -0.41, 0.0)
		event.reset_object_sequence_dynamic_animation(2)
		event.set_object_sequence_position(1, -2027.94, 307.87, 217.37)
		event.set_object_sequence_rotation(1, 0.0, -0.41, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.play_sound_effect(var0, 14)
		event.set_object_sequence_motion(1, "ムーンサルト", 6)
		event.wait_object_sequence_motion_end(1)
		event.set_object_sequence_motion(2, "ムーンサルト", 6)
		event.wait_object_sequence_motion_end(2)
		at = 26
		wait_frames(10)
		event.start_character_sword_effect(14, 0, "dcol00", "dcol01", 94, 6, 6)
		at = 27
		wait_objects(1)
		event.set_camera_sequence_position(-2082.67, 325.7, 160.89)
		event.set_camera_sequence_look_at(-2021.3, 327.3, 209.89)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(var0, 15)
		event.set_object_sequence_motion(1, "ぐらっ", 6)
		event.set_object_sequence_motion_step(1, 0.7)
		event.queue_object_sequence_next_motion(1, "ぐらっL", 4)
		event.set_object_sequence_motion(2, "ぐらっ", 6)
		event.set_object_sequence_motion_step(1, 0.7)
		event.queue_object_sequence_next_motion(2, "ぐらっL", 4)
		event.play_sound_effect(var0, 16)
		event.delay_camera_sequence_shake_track(15)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		at = 28
		wait_frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 29
		helper_1584c528(5200050, -1)
		event.set_camera_sequence_position(-2043.31, 334.08, 203.6)
		event.set_camera_sequence_look_at(-2013.93, 336.49, 194.04)
		event.delay_object_sequence_sound_track(2, 8)
		event.play_object_sequence_sound(2, var0, 20)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "わらい口パク")
		at = 30
		helper_1584c528(5200060, -1)
		event.set_camera_sequence_position(-2058.89, 312.45, 158.48)
		event.set_camera_sequence_look_at(-2022.95, 325.53, 214.99)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～かはっ目")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "下目パチ")
		event.set_object_sequence_motion(1, "殴り", 6)
		event.queue_object_sequence_next_motion(1, "殴りL", 4)
		event.set_object_sequence_motion(2, "殴り", 6)
		event.queue_object_sequence_next_motion(2, "殴りL", 4)
		at = 31
		wait_frames(10)
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		at = 32
		helper_1584c528(5200070, -1)
		event.wait_object_sequence_motion_end(2)
		at = 33
		wait_objects(1)
		event.set_camera_sequence_position(-2025.6, 317.11, 283.22)
		event.set_camera_sequence_look_at(-2022.52, 324.9, 217.92)
		at = 34
		wait_frames(20)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "くるし顔")
		event.detach_character_from_frame(14)
		event.set_object_sequence_position(5, -2016.36, 313.05, 230.26)
		event.set_object_sequence_rotation(5, 0.5, 1.67, 0.8)
		event.set_camera_sequence_position(-2038.22, 330.43, 198.53)
		event.set_camera_sequence_look_at(-2027.97, 333.86, 219.66)
		event.set_object_sequence_motion(1, "殴られ顔", 4)
		event.reset_object_sequence_dynamic_animation(1)
		at = 35
		wait_frames(30)
		event.set_camera_sequence_position(-2063.52, 323.93, 286.2)
		event.set_camera_sequence_look_at(-2027.6, 321.15, 217.1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "くるし顔")
		event.set_object_sequence_texture_animation(1, 1, "かはっ目～目とじ")
		event.set_object_sequence_texture_animation(1, 1, "口あけ～口とじ")
		event.play_sound_effect(var0, 21)
		event.play_sound_effect(var0, 22)
		event.move_object_sequence(5, -2016.36, 308.85, 230.26, 6)
		event.rotate_object_sequence(5, 0.0, 1.67, 0.0, 6)
		event.move_object_sequence(5, -2016.36, 310.0, 230.26, 6)
		event.rotate_object_sequence(5, 0.4, 1.67, 0.5, 6)
		event.move_object_sequence(5, -2016.36, 308.85, 230.26, 5)
		event.rotate_object_sequence(5, 0.0, 1.67, 0.0, 5)
		event.set_object_sequence_motion(1, "かかえ", 6)
		event.queue_object_sequence_next_motion(1, "かかえL", 4)
		event.set_object_sequence_motion(2, "かかえ", 6)
		event.queue_object_sequence_next_motion(2, "かかえL", 4)
		event.wait_object_sequence_motion_end(2)
		at = 36
		wait_frames(60)
		event.set_object_sequence_position(0, -2213.52, 0.0, 1691.84)
		event.set_object_sequence_rotation(0, 0.0, 2.83, 0.0)
		event.set_camera_sequence_position(-2040.48, 335.59, 231.83)
		event.set_camera_sequence_look_at(-2021.29, 337.31, 214.72)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "死に")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "下目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 37
		helper_1584c528(5200080, -1)
		event.delay_camera_sequence_shake_track(30)
		event.shake_camera_sequence(0.0, 0.2, 0.0, -1)
		event.play_sound_effect(var0, 23)
		at = 38
		wait_frames(60)
		event.set_object_sequence_motion(2, "上見", 6)
		event.queue_object_sequence_next_motion(2, "上見L", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_mouth_texture_animations(2, "おこり口パク")
		at = 39
		helper_1584c528(5200090, -1)
		event.stop_sound_effect(var0, 8)
		event.stop_sound_effect(var0, 23)
		event.set_wind(-1)
		event.clear_camera_sequence()
		event.set_object_handle_visible(20, 1)
		event.set_camera_sequence_position(-2307.42, 27.19, 1937.3)
		event.set_camera_sequence_look_at(-2258.86, 36.53, 1808.93)
		at = 40
		wait_frames(10)
		event.play_sound_effect(var0, 24)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_visible(1, 0)
		event.set_object_handle_visible(5, 0)
		event.move_object_sequence_eased(16, -604.5, -2501, 66.7, 360, 1, 0.7)
		event.rotate_object_sequence_eased(16, 0.0, -1.9024088, -0.6894051, 210, 1, 0.7)
		event.move_object_sequence_eased(3, -604.5, -2501, 66.7, 360, 1, 0.7)
		event.rotate_object_sequence_eased(3, 0.0, -1.6057029, -0.6894051, 210, 1, 0.7)
		at = 41
		wait_frames(90)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "大口パク")
		at = 42
		helper_1584c528(5200100, 60)
		event.move_camera_sequence_eased(-2198.1, 30.55, 1580.48, -2105.26, 29.78, 1380.32, 120, 1, 0.5)
		event.move_camera_sequence_eased(-2085.28, 88.8, 1337.19, -1972.16, 302.92, 1093.31, 90, 2, 1.0)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -2112.56, 0.0, 1396.51, 160)
		event.delay_object_sequence_motion_track(0, 160)
		event.set_object_sequence_motion(0, "立ち")
		at = 43
		wait_frames(90)
		event.fade_out_music(90)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 44
		helper_1584c528(5200110, 90)
		event.fade_out_screen(30)
		at = 45
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(4)
		end
		if at <= 2 then
			print("1--------------------------------\n")
			local _ = active_chr_no == 2
			active_chr_no = 0
			local _ = active_chr_no == 3
			active_chr_no = 1
			print("2--------------------------------\n")
			wait_frames_skipping(120)
		end
		if at <= 3 then
			print("3--------------------------------\n")
			print("4--------------------------------\n")
			x = vm.f32(-2438.17)
			y = vm.f32(332.67)
			z = 341.25
			helper_52aadc70(5200010, -1)
		end
		if at <= 4 then
			wait_frames_skipping(10)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			wait_frames_skipping(60)
		end
		if at <= 7 then
			wait_frames_skipping(60)
		end
		if at <= 8 then
			helper_52aadc70(5200020, 50)
		end
		if at <= 9 then
			wait_frames_skipping(5)
		end
		if at <= 10 then
			helper_52aadc70(5200030, -1)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		if at <= 12 then
			wait_frames_skipping(90)
		end
		if at <= 13 then
			helper_238b5abc(1)
		end
		if at <= 14 then
			helper_52aadc70(5200040, -1)
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			wait_frames_skipping(20)
		end
		if at <= 17 then
			wait_frames_skipping(10)
		end
		if at <= 18 then
			wait_frames_skipping(10)
		end
		if at <= 19 then
			helper_238b5abc(4)
		end
		if at <= 20 then
			wait_frames_skipping(30)
		end
		if at <= 21 then
			wait_frames_skipping(15)
		end
		if at <= 22 then
			wait_frames_skipping(15)
		end
		if at <= 23 then
			wait_frames_skipping(10)
		end
		if at <= 24 then
			wait_frames_skipping(20)
		end
		if at <= 25 then
			wait_frames_skipping(10)
		end
		if at <= 26 then
			helper_238b5abc(1)
		end
		if at <= 27 then
			wait_frames_skipping(15)
		end
		if at <= 28 then
			helper_52aadc70(5200050, -1)
		end
		if at <= 29 then
			helper_52aadc70(5200060, -1)
		end
		if at <= 30 then
			wait_frames_skipping(10)
		end
		if at <= 31 then
			helper_52aadc70(5200070, -1)
		end
		if at <= 32 then
			helper_238b5abc(1)
		end
		if at <= 33 then
			wait_frames_skipping(20)
		end
		if at <= 34 then
			wait_frames_skipping(30)
		end
		if at <= 35 then
			wait_frames_skipping(60)
		end
		if at <= 36 then
			helper_52aadc70(5200080, -1)
		end
		if at <= 37 then
			wait_frames_skipping(60)
		end
		if at <= 38 then
			helper_52aadc70(5200090, -1)
		end
		if at <= 39 then
			wait_frames_skipping(10)
		end
		if at <= 40 then
			wait_frames_skipping(90)
		end
		if at <= 41 then
			helper_52aadc70(5200100, 60)
		end
		if at <= 42 then
			wait_frames_skipping(90)
		end
		if at <= 43 then
			helper_52aadc70(5200110, 90)
		end
		if at <= 44 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 46
	vm.entry(46)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 8, 0)
	event.set_scene_status_flags(1, 9, 8, 0)
	event.set_scene_status_flags(1, 11, 8, 0)
	event.set_wind(-1)
	event.set_object_handle_visible(3, 0)
	event.set_object_handle_visible(16, 0)
	event.stop_music(0)
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 3)
	event.stop_sound_effect(var0, 4)
	event.stop_sound_effect(var0, 5)
	event.stop_sound_effect(var0, 6)
	event.stop_sound_effect(var0, 8)
	event.stop_sound_effect(var0, 9)
	event.stop_sound_effect(var0, 10)
	event.stop_sound_effect(var0, 16)
	event.stop_sound_effect(var0, 23)
	event.stop_sound_effect(var0, 24)
	event.set_object_handle_visible(16, 0)
	event.set_object_handle_visible(20, 1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_position(16, 3139.7, 9.0, 918.2)
	event.call_command(703, 16, 2.4260077, 0.0) -- retail: the handler rejects 3 arguments
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.load_message_file(0, -1)
	event.delete_event_image(0)
	event.delete_event_image(1)
	event.clear_effect_manager()
	event.set_character_active(0)
	event.set_character_position(0, -2213.52, 0.0, 1691.84)
	event.set_character_rotation(0, 0.0, 2.59, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.show_dungeon_status_bar(1, 1.0)
	event.fade_in_screen(30)
end

return helper_43d1778f
