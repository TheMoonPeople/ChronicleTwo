--!strict
-- map/f/f01/f01_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_342a37b0 = require("@lib/event/helper_342a37b0")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_5c12934f = require("@lib/event/helper_5c12934f")
local helper_66ac1f76 = require("@lib/event/helper_66ac1f76")
local helper_76f23193 = require("@lib/event/helper_76f23193")
local helper_7ed7ab4f = require("@lib/event/helper_7ed7ab4f")
local helper_81af0537 = require("@lib/event/helper_81af0537")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_b84429a4 = require("@lib/event/helper_b84429a4")
local helper_c1df6484 = require("@lib/event/helper_c1df6484")
local helper_c5ea1698 = require("@lib/event/helper_c5ea1698")
local helper_e538a72d = require("@lib/event/helper_e538a72d")
local helper_ee09935e = require("@lib/event/helper_ee09935e")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0
local global4: s32 = 0
local global5: s32 = 0
local global6: s32 = 0
local global7: s32 = 0
local global8: any = 0
local global9: any = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local var0: s32 = 0
	local var2: s32 = 0
	event.set_function_point_enabled("", "e277", 0)
	var0 = 0
	var2 = event.get_georama_analysis_flag(104) or var2
	if var2 ~= 0 then
		var0 = 1
	end
	var2 = event.get_georama_analysis_flag(105) or var2
	if var2 ~= 0 then
		var0 = 1
	end
	var2 = event.get_georama_analysis_flag(106) or var2
	if var0 ~= 0 then
		event.attach_object_handle_to_map_part_2(1, "p11_f0101")
		event.set_object_handle_visible(1, 0)
	end
	helper_66ac1f76()
	event.set_character_position(0, 205.1, -6.0, 894.1)
end

--- Helper function.
local function helper_1c6d8()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_message_file(0, 5, "event/e200/e270/e270_1.txt")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 33
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.load_character_motion_pack(5, "event/e200/e270/e270_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global2)
		event.load_character(5, "chara/c02_base.gltf", "info", global3)
		event.load_equipment_model(5, 1, 4, "info", global3)
		event.load_equipment_model(5, 1, 3, "info", global3)
		event.load_equipment_model(5, 1, 2, "info", global3, 37)
		event.load_character_motion_pack(5, "event/e200/e270/e270_monica.gltf", "info", global3)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global3)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global2 = 33
		global3 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global2)
		event.load_equipment_model(5, 0, 4, "info", global2)
		event.load_equipment_model(5, 0, 3, "info", global2)
		event.load_equipment_model(5, 0, 2, "info", global2, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.load_character_motion_pack(5, "event/e200/e270/e270_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global2)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e270/e270_monica.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.set_character_active(0, global3)
	end
end

--- Helper function.
local function helper_21f00000()
	global2 = 0
	global3 = 33
	global2 = 33
	global3 = 0
end

--- Helper function.
local function helper_1c400()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global2)
		event.set_character_active(0, global3)
		event.delete_character_extension_packs(global2)
		event.delete_character_extension_packs(global3)
		event.delete_character(global3)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global3)
		event.set_character_active(0, global2)
		event.delete_character_extension_packs(global2)
		event.delete_character_extension_packs(global3)
		event.delete_character(global2)
		event.delete_character(37)
	end
end

--- Helper function.
local function helper_1d334()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(270, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(45)
		event.load_map_sounds(2500)
		var4 = event.load_sound_effect_file_2(2500) or var4
		helper_1c6d8()
		event.enable_drama_skip()
		event.set_character_active(1, global2)
		event.set_character_active(1, global3)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(174.76, 389.28, 1785.94)
		event.set_camera_sequence_look_at(34.41, 90.8, 382.81)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_position(0, 68.8, 23.7, 1491.8)
		event.set_object_sequence_rotation(0, 0.0, 3.05, 0.0)
		event.set_object_sequence_position(1, 93.9, 23.7, 1438.4)
		event.set_object_sequence_rotation(1, 0.0, 3.05, 0.0)
		event.fade_in_screen(30)
		event.play_sound_effect(var4, 2)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		at = 2
		wait_frames(15)
		event.move_object_sequence(0, 37.43, 14.75, 561.52, 600, 1)
		event.move_object_sequence(1, 58.59, 15.55, 560.22, 600, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(660)
		event.add_camera_sequence_path_point(174.76, 389.28, 1785.94, 34.41, 90.8, 382.81)
		event.add_camera_sequence_path_point(171.97, 318.75, 1758.0, 34.41, 90.8, 382.81)
		event.add_camera_sequence_path_point(161.43, 215.48, 1652.69, 34.41, 90.8, 382.81)
		event.add_camera_sequence_path_point(142.06, 138.98, 1459.02, 34.41, 90.8, 382.81)
		event.add_camera_sequence_path_point(64.19, 10.12, 750.23, 30.64, 90.8, 392.13)
		event.start_camera_sequence_path()
		at = 3
		wait_objects(1)
		event.rotate_object_sequence(1, 0.0, -2.75, 0.0, 5)
		at = 4
		wait_frames(5)
		event.set_object_sequence_motion(1, "立ち", 0)
		at = 5
		wait_objects(0)
		event.rotate_object_sequence(0, 0.0, 3.05, 0.0, 5)
		at = 6
		wait_frames(5)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.stop_sound_effect(var4, 2)
		at = 7
		wait_frames(60)
		at = 8
		helper_4116e6bb(2700010)
		at = 9
		helper_4116e6bb(2700020)
		at = 10
		wait_frames(30)
		event.set_camera_sequence_position(25.23, 45.67, 520.07)
		event.set_camera_sequence_look_at(56.48, 39.42, 567.84)
		event.move_object_sequence(1, 58.3, 15.55, 557.33, 10, 1)
		event.set_object_sequence_motion(1, "歩き", 2)
		at = 11
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち", 2)
		event.queue_object_sequence_next_motion(1, "上向く", 6)
		at = 12
		wait_objects(1)
		event.queue_object_sequence_next_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 0)
		at = 13
		helper_4116e6bb(2700030)
		event.reset_mouth_texture_animations()
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 14
		wait_frames(30)
		event.set_camera_sequence_position(64.19, 10.12, 750.23)
		event.set_camera_sequence_look_at(30.64, 90.8, 392.13)
		at = 15
		wait_frames(15)
		event.set_object_sequence_motion(0, "右向く戻り")
		event.queue_object_sequence_next_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 16
		helper_4116e6bb(2700040)
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 17
		helper_4116e6bb(2700050)
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 18
		helper_4116e6bb(2700055)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 19
		wait_frames(60)
		event.set_object_sequence_motion(0, "風", 6)
		event.queue_object_sequence_next_motion(0, "風Ｌ", 4)
		event.set_object_sequence_motion(1, "風", 6)
		event.queue_object_sequence_next_motion(1, "風Ｌ", 4)
		event.play_sound_effect(var4, 3)
		event.set_wind(40.0, 34.48, 48.5, 396.61)
		at = 20
		helper_1584c528(2700060, -1)
		event.set_wind(-1)
		event.set_object_sequence_motion(0, "風戻り", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "風戻り", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 21
		wait_frames(30)
		event.set_camera_sequence_position(25.23, 45.67, 520.07)
		event.set_camera_sequence_look_at(56.48, 39.42, 567.84)
		at = 22
		wait_frames(15)
		event.set_object_sequence_motion(1, "あいつは～専用", 6)
		event.queue_object_sequence_next_motion(1, "あいつは～専用Ｌ", 4)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "時の～専用上～見立ちに", 6)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ")
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ～目あき")
		at = 23
		vm.wait(23)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 24
		helper_4116e6bb(2700070)
		at = 25
		wait_objects(1)
		event.wait_object_sequence_motion_end(1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向くL", 6)
		event.queue_object_sequence_next_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 26
		helper_4116e6bb(2700080)
		at = 27
		wait_objects(1)
		event.wait_object_sequence_motion_end(1)
		event.reset_mouth_texture_animations()
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 28
		wait_frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(930)
		event.add_camera_sequence_path_point(132.27, 70.71, 488.53, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(159.15, 70.71, 562.03, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(132.93, 70.71, 625.44, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(77.3, 70.71, 656.87, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(28.82, 70.71, 654.67, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-9.49, 70.71, 633.72, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-37.15, 70.71, 595.03, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-44.53, 70.71, 550.01, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-32.67, 70.71, 507.99, 58.05, 36.97, 556.81)
		event.add_camera_sequence_path_point(-6.04, 70.71, 475.89, 58.05, 36.97, 556.81)
		event.start_camera_sequence_path()
		at = 29
		wait_frames(15)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 30
		helper_1584c528(2700090, 120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 31
		helper_1584c528(2700095, 120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 32
		helper_1584c528(2700100, 230)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 33
		helper_1584c528(2700110, 200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 34
		helper_1584c528(2700120, -1)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(40.68, 60.8, 523.12)
		event.set_camera_sequence_look_at(50.29, 32.81, 569.09)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 110)
		event.set_object_sequence_motion(1, "上向き会話2", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 35
		helper_4116e6bb(2700130)
		at = 36
		wait_objects(1)
		event.wait_object_sequence_motion_end(1)
		event.reset_mouth_texture_animations()
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 37
		wait_frames(30)
		event.set_camera_sequence_position(64.19, 10.12, 750.23)
		event.set_camera_sequence_look_at(30.64, 90.8, 392.13)
		at = 38
		wait_frames(15)
		at = 39
		helper_4116e6bb(2700140)
		at = 40
		helper_4116e6bb(2700150)
		at = 41
		helper_4116e6bb(2700153)
		at = 42
		wait_frames(30)
		event.set_camera_sequence_position(19.5, 49.85, 518.46)
		event.set_camera_sequence_look_at(52.88, 36.97, 566.51)
		at = 43
		wait_frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～がっかり目")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "力こめ目とじ")
		event.set_object_sequence_texture_animation(1, 1, "口閉じ～口くいしばり")
		event.play_sound_effect(var4, 5)
		event.set_object_sequence_motion(1, "悔しがりラスト", 6)
		event.queue_object_sequence_next_motion(1, "悔しがりラストＬ", 4)
		event.set_object_sequence_motion(0, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.move_camera_sequence_eased(26.54, 49.85, 528.59, 52.88, 36.97, 566.51, 60, 2, 1.0)
		at = 44
		helper_1584c528(2700155, -1)
		at = 45
		wait_frames(30)
		event.fade_out_screen(30)
		at = 46
		wait_frames(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_21f00000()
			wait_frames_skipping(15)
		end
		if at <= 2 then
			helper_238b5abc(1)
		end
		if at <= 3 then
			wait_frames_skipping(5)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			wait_frames_skipping(5)
		end
		if at <= 6 then
			wait_frames_skipping(60)
		end
		if at <= 7 then
			helper_8cd371d7(2700010)
		end
		if at <= 8 then
			helper_8cd371d7(2700020)
		end
		if at <= 9 then
			wait_frames_skipping(30)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			helper_238b5abc(1)
		end
		if at <= 12 then
			helper_8cd371d7(2700030)
		end
		if at <= 13 then
			wait_frames_skipping(30)
		end
		if at <= 14 then
			wait_frames_skipping(15)
		end
		if at <= 15 then
			helper_8cd371d7(2700040)
		end
		if at <= 16 then
			helper_8cd371d7(2700050)
		end
		if at <= 17 then
			helper_8cd371d7(2700055)
		end
		if at <= 18 then
			wait_frames_skipping(60)
		end
		if at <= 19 then
			helper_52aadc70(2700060, -1)
		end
		if at <= 20 then
			wait_frames_skipping(30)
		end
		if at <= 21 then
			wait_frames_skipping(15)
		end
		if at <= 23 then
			helper_8cd371d7(2700070)
		end
		if at <= 24 then
			helper_238b5abc(1)
		end
		if at <= 25 then
			helper_8cd371d7(2700080)
		end
		if at <= 26 then
			helper_238b5abc(1)
		end
		if at <= 27 then
			wait_frames_skipping(30)
		end
		if at <= 28 then
			wait_frames_skipping(15)
		end
		if at <= 29 then
			helper_52aadc70(2700090, 120)
		end
		if at <= 30 then
			helper_52aadc70(2700095, 120)
		end
		if at <= 31 then
			helper_52aadc70(2700100, 230)
		end
		if at <= 32 then
			helper_52aadc70(2700110, 200)
		end
		if at <= 33 then
			helper_52aadc70(2700120, -1)
		end
		if at <= 34 then
			helper_8cd371d7(2700130)
		end
		if at <= 35 then
			helper_238b5abc(1)
		end
		if at <= 36 then
			wait_frames_skipping(30)
		end
		if at <= 37 then
			wait_frames_skipping(15)
		end
		if at <= 38 then
			helper_8cd371d7(2700140)
		end
		if at <= 39 then
			helper_8cd371d7(2700150)
		end
		if at <= 40 then
			helper_8cd371d7(2700153)
		end
		if at <= 41 then
			wait_frames_skipping(30)
		end
		if at <= 42 then
			wait_frames_skipping(15)
		end
		if at <= 43 then
			helper_52aadc70(2700155, -1)
		end
		if at <= 44 then
			wait_frames_skipping(30)
		end
		if at <= 45 then
			wait_frames_skipping(35)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_wind(-1)
	event.stop_sound_effect(var4, 2)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_1c400()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_20a74()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global4 = 0
		global5 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global4)
		event.load_character_motion_pack(5, "event/e200/e272/e272_mints.gltf", "info", global4)
		event.attach_object_handle_to_character(0, global4)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global4)
		event.load_character(5, "chara/c02_base.gltf", "info", global5)
		event.load_equipment_model(5, 1, 4, "info", global5)
		event.load_equipment_model(5, 1, 3, "info", global5)
		event.load_equipment_model(5, 1, 2, "info", global5, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global5)
		event.load_character_motion_pack(5, "event/e200/e272/e272_monica.gltf", "info", global5)
		event.attach_object_handle_to_character(1, global5)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global5)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global4 = 32
		global5 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global4)
		event.load_equipment_model(5, 0, 4, "info", global4)
		event.load_equipment_model(5, 0, 3, "info", global4)
		event.load_equipment_model(5, 0, 2, "info", global4, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global4)
		event.load_character_motion_pack(5, "event/e200/e272/e272_mints.gltf", "info", global4)
		event.attach_object_handle_to_character(0, global4)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global4)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global5)
		event.load_character_motion_pack(5, "event/e200/e272/e272_monica.gltf", "info", global5)
		event.attach_object_handle_to_character(1, global5)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global5)
	end
	event.load_character(5, "event/e200/e255/e255_rafu_tane.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(2, 35)
	event.clear_object_sequence(3, 35)
	event.set_object_sequence_object(3, 2)
	event.load_character(5, "event/e200/e272/e272_hanabaku.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e200/e272/e272_kirakira.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(4, 39)
	event.clear_object_sequence(5, 39)
	event.set_object_sequence_object(5, 4)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 40)
	event.attach_object_handle_to_character(5, 40)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 5)
	event.set_character_active(0, 40)
	event.load_message_file(0, 5, "event/e200/e272/e272_1.txt")
end

--- Helper function.
local function helper_22800000()
	global4 = 0
	global5 = 32
	global4 = 32
	global5 = 0
end

--- Helper function.
local function helper_20620()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global4)
		event.set_character_active(0, global5)
		event.delete_character_extension_packs(global4)
		event.delete_character_extension_packs(global5)
		event.delete_character_extension_packs(36)
		event.delete_character(global5)
		event.delete_character(36)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global5)
		event.set_character_active(0, global4)
		event.delete_character_extension_packs(global4)
		event.delete_character_extension_packs(global5)
		event.delete_character_extension_packs(36)
		event.delete_character(global4)
		event.delete_character(36)
		event.delete_character(37)
	end
	event.delete_character(35)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
end

--- Helper function.
local function helper_21af4()
	local var10: s32 = 0
	local var11: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 1
		wait_frames(45)
		event.set_save_flag(272, 1)
		event.load_map_sounds(2503)
		var10 = event.load_sound_effect_file_2(2503) or var10
		var11 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var11
		helper_20a74()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global4)
		event.set_character_active(1, global5)
		event.set_character_active(0, 35)
		event.set_camera_sequence_position(104.47, 46.8, 1479.26)
		event.set_camera_sequence_look_at(86.03, 73.72, 1247.28)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_character_position(38, -96.86, 52.75, 388.46)
		event.set_character_rotation(38, 0.0, 0.0, 0.0)
		event.set_character_position(39, 37.43, 34.75, 561.52)
		event.set_character_rotation(39, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(0, 47.14, -8.67, 849.46)
		event.set_object_sequence_rotation(0, 0.0, 3.05, 0.0)
		event.set_object_sequence_position(1, 70.25, -10.75, 900.05)
		event.set_object_sequence_rotation(1, 0.0, 3.05, 0.0)
		event.fade_in_screen(30)
		event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		at = 2
		wait_frames(15)
		event.move_object_sequence(0, 37.43, 14.75, 561.52, 240, 1)
		event.move_object_sequence(1, 58.59, 15.55, 560.22, 270, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(104.47, 46.8, 1479.26, 86.03, 73.72, 1247.28)
		event.add_camera_sequence_path_point(65.3, 46.8, 986.65, 46.86, 73.72, 754.67)
		event.start_camera_sequence_path()
		at = 3
		wait_objects(0)
		event.rotate_object_sequence(0, 0.0, -3.11, 0.0, 5)
		at = 4
		wait_frames(5)
		event.set_object_sequence_motion(0, "立ち", 0)
		at = 5
		wait_objects(1)
		event.rotate_object_sequence(1, 0.0, -2.87, 0.0, 5)
		at = 6
		wait_frames(5)
		event.set_object_sequence_motion(1, "上向くL", 0)
		at = 7
		wait_frames(60)
		event.set_object_sequence_motion(0, "上向く", 2)
		event.queue_object_sequence_next_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 8
		helper_4116e6bb(2720010)
		at = 9
		wait_objects(0)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 10
		helper_4116e6bb(2720020)
		at = 11
		helper_4116e6bb(2720030)
		at = 12
		helper_4116e6bb(2720035)
		at = 13
		wait_frames(30)
		event.set_camera_sequence_position(62.05, 41.42, 524.15)
		event.set_camera_sequence_look_at(28.43, 35.31, 613.0)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 14
		helper_4116e6bb(2720040)
		event.reset_mouth_texture_animations()
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		at = 15
		wait_frames(30)
		event.set_camera_sequence_position(65.3, 46.8, 986.65)
		event.set_camera_sequence_look_at(46.86, 73.72, 754.67)
		at = 16
		helper_4116e6bb(2720050)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 17
		helper_4116e6bb(2720060)
		at = 18
		wait_objects(0)
		at = 19
		helper_4116e6bb(2720070)
		at = 20
		wait_frames(30)
		event.set_camera_sequence_position(35.55, 36.73, 529.53)
		event.set_camera_sequence_look_at(46.86, 52.13, 754.67)
		event.set_object_sequence_motion(0, "考える", 4)
		at = 21
		wait_frames(15)
		event.move_camera_sequence_eased(35.81, 36.73, 534.67, 46.86, 52.13, 754.67, 30, 2, 1.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 22
		helper_4116e6bb(2720080)
		event.reset_mouth_texture_animations()
		at = 23
		wait_frames(30)
		event.set_camera_sequence_position(283.52, 88.96, 846.8)
		event.set_camera_sequence_look_at(90.35, 78.53, 545.4)
		at = 24
		wait_frames(15)
		at = 25
		helper_4116e6bb(2720090)
		event.set_map_piece_character_motion("jyuraku", "jyuraku", "もごもご")
		at = 26
		wait_frames(30)
		event.set_map_piece_character_motion("jyuraku", "jyuraku", "ふんっ")
		at = 27
		wait_frames(30)
		event.set_character_active(1, 38)
		event.set_character_motion(38, "鼻爆発", 2, -1, 1)
		event.play_sound_effect(var10, 4)
		event.set_wind(40.0, -96.86, 52.75, 388.46)
		at = 28
		wait_frames(15)
		event.set_wind(-1)
		event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
		event.set_object_sequence_motion(0, "驚く", 6)
		event.set_object_sequence_motion(1, "おどろき", 6)
		event.queue_object_sequence_next_motion(0, "驚くL", 4)
		event.queue_object_sequence_next_motion(1, "おどろきL", 4)
		at = 29
		wait_frames(90)
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(64.11, 33.73, 495.58)
		event.set_camera_sequence_look_at(35.93, 39.28, 614.27)
		event.set_object_sequence_rotation(1, 0.0, -2.03, 0.0)
		event.set_character_active(1, 39)
		event.set_character_motion(39, "キラキラ（ループ）", 4, -1, 1)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 120)
		event.add_object_sequence_path_point(5, 39.0, 68.91, 553.15)
		event.add_object_sequence_path_point(5, 39.0, 42.39, 553.15)
		event.start_object_sequence_path(5)
		event.play_sound_effect(var10, 5)
		event.set_object_sequence_motion(0, "キラキラ見る", 2)
		event.set_object_sequence_motion(1, "おどろきＬから上向き立ち", 2)
		event.queue_object_sequence_next_motion(0, "取る", 6)
		event.queue_object_sequence_next_motion(1, "上向く戻り", 6, 0.025)
		event.queue_object_sequence_next_motion(0, "取るL", 4)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 30
		wait_frames(120)
		event.set_character_motion(39, "消える", 2, -1, 1)
		at = 31
		wait_frames(30)
		event.set_character_active(0, 39)
		event.set_camera_sequence_position(32.21, 52.0, 529.74)
		event.set_camera_sequence_look_at(38.35, 42.39, 562.99)
		event.set_object_sequence_position(6, 44.55, 45.78, 564.88)
		event.set_object_sequence_rotation(6, 0.0, -3.11, 0.0)
		event.pause_music()
		event.set_character_active(1, 40)
		event.play_sound_effect(var10, 6)
		event.play_sound_effect(var11, 0)
		event.set_object_sequence_motion(6, "発動", 6)
		event.attach_character_to_frame(global4, "item", 35)
		event.set_character_active(1, 35)
		event.set_object_sequence_motion(0, "種ゲット", 4)
		at = 32
		helper_f38eabca(361, 1)
		event.play_music(0)
		event.detach_character_from_frame(35)
		event.set_character_active(0, 40)
		event.set_camera_sequence_position(65.3, 46.8, 986.65)
		event.set_camera_sequence_look_at(46.86, 73.72, 754.67)
		event.set_object_sequence_rotation(1, 0.0, -2.87, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 0)
		event.set_object_sequence_motion(1, "上向くL", 0)
		at = 33
		helper_4116e6bb(2720100)
		at = 34
		helper_4116e6bb(2720110)
		event.set_camera_sequence_position(40.41, 53.02, 519.29)
		event.set_camera_sequence_look_at(64.94, -1.06, 669.16)
		at = 35
		wait_frames(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 36
		helper_4116e6bb(2720120)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(65.3, 46.8, 986.65)
		event.set_camera_sequence_look_at(46.86, 73.72, 754.67)
		at = 37
		wait_frames(15)
		at = 38
		helper_4116e6bb(2720130)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 39
		helper_4116e6bb(2720140)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 40
		helper_4116e6bb(2720150)
		at = 41
		wait_frames(30)
		event.set_camera_sequence_position(40.41, 53.02, 519.29)
		event.set_camera_sequence_look_at(64.94, -1.06, 669.16)
		event.set_object_sequence_motion(0, "あせり会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 42
		helper_4116e6bb(2720160)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "大口パク")
		event.set_object_sequence_motion(0, "あせり会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 43
		helper_4116e6bb(2720165)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(65.3, 46.8, 986.65)
		event.set_camera_sequence_look_at(46.86, 73.72, 754.67)
		event.set_object_sequence_motion(0, "立ち", 4)
		at = 44
		helper_4116e6bb(2720170)
		at = 45
		helper_f38eabca(308, 1)
		event.set_camera_sequence_position(40.41, 53.02, 519.29)
		event.set_camera_sequence_look_at(64.94, -1.06, 669.16)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 6)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "だめだめ", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 6)
		at = 46
		wait_frames(120)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Per prendere una Goccia del\nSole, ti serve qualcosa che ti\npermetta di parlare all'Himarra.<page>Ottenere questo oggetto dipende anche\ndallo sviluppo del Diorama. Lavoraci\nsu e controlla il mondo futuro di Jurak."
		)
		at = 47
		show_message(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22800000()
			wait_frames_skipping(15)
		end
		if at <= 2 then
			helper_238b5abc(0)
		end
		if at <= 3 then
			wait_frames_skipping(5)
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			wait_frames_skipping(5)
		end
		if at <= 6 then
			wait_frames_skipping(60)
		end
		if at <= 7 then
			helper_8cd371d7(2720010)
		end
		if at <= 8 then
			helper_238b5abc(0)
		end
		if at <= 9 then
			helper_8cd371d7(2720020)
		end
		if at <= 10 then
			helper_8cd371d7(2720030)
		end
		if at <= 11 then
			helper_8cd371d7(2720035)
		end
		if at <= 12 then
			wait_frames_skipping(30)
		end
		if at <= 13 then
			helper_8cd371d7(2720040)
		end
		if at <= 14 then
			wait_frames_skipping(30)
		end
		if at <= 15 then
			helper_8cd371d7(2720050)
		end
		if at <= 16 then
			helper_8cd371d7(2720060)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_8cd371d7(2720070)
		end
		if at <= 19 then
			wait_frames_skipping(30)
		end
		if at <= 20 then
			wait_frames_skipping(15)
		end
		if at <= 21 then
			helper_8cd371d7(2720080)
		end
		if at <= 22 then
			wait_frames_skipping(30)
		end
		if at <= 23 then
			wait_frames_skipping(15)
		end
		if at <= 24 then
			helper_8cd371d7(2720090)
		end
		if at <= 25 then
			wait_frames_skipping(30)
		end
		if at <= 26 then
			wait_frames_skipping(30)
		end
		if at <= 27 then
			wait_frames_skipping(15)
		end
		if at <= 28 then
			wait_frames_skipping(90)
		end
		if at <= 29 then
			wait_frames_skipping(120)
		end
		if at <= 30 then
			wait_frames_skipping(30)
		end
		if at <= 31 then
			helper_5c12934f(361, 1)
		end
		if at <= 32 then
			helper_8cd371d7(2720100)
		end
		if at <= 33 then
			helper_8cd371d7(2720110)
		end
		if at <= 34 then
			wait_frames_skipping(15)
		end
		if at <= 35 then
			helper_8cd371d7(2720120)
		end
		if at <= 36 then
			wait_frames_skipping(15)
		end
		if at <= 37 then
			helper_8cd371d7(2720130)
		end
		if at <= 38 then
			helper_8cd371d7(2720140)
		end
		if at <= 39 then
			helper_8cd371d7(2720150)
		end
		if at <= 40 then
			wait_frames_skipping(30)
		end
		if at <= 41 then
			helper_8cd371d7(2720160)
		end
		if at <= 42 then
			helper_8cd371d7(2720165)
		end
		if at <= 43 then
			helper_8cd371d7(2720170)
		end
		if at <= 44 then
			helper_5c12934f(308, 1)
		end
		if at <= 45 then
			wait_frames_skipping(120)
		end
		if at <= 46 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 48
	wait_frames(30)
	event.set_wind(-1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_20620()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_24f40()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_message_file(0, 5, "event/e200/e275/e275_1.txt")
end

--- Helper function.
local function helper_22d00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_24c68()
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
end

--- Helper function.
local function helper_259cc()
	local var4: s32 = 0
	local var5: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(275, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 1
		wait_frames(45)
		helper_24f40()
		event.load_map_sounds(2506)
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(-4.27, 55.7, 754.91)
		event.set_camera_sequence_look_at(14.71, 53.79, 698.03)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		var4 = event.get_georama_analysis_flag(106) or var4
		var5 = event.get_georama_analysis_flag(105) or var5
		if var5 ~= 0 then
			event.set_camera_sequence_position(13.7, 24.83, 757.8)
			event.set_camera_sequence_look_at(14.71, 53.79, 698.03)
		end
		if var4 ~= 0 then
			event.set_camera_sequence_position(49.24, 24.83, 746.5)
			event.set_camera_sequence_look_at(14.71, 53.79, 698.03)
		end
		event.set_object_sequence_position(0, 13.4, 6.52, 613.7)
		event.set_object_sequence_rotation(0, 0.0, -2.92, 0.0)
		event.set_object_sequence_position(1, 47.24, 7.54, 600.38)
		event.set_object_sequence_rotation(1, 0.0, -2.92, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		at = 2
		wait_frames(15)
		if (if var4 ~= 0 then 1 else var5) ~= 0 then
			event.clear_camera_sequence_path()
			if (if var4 ~= 0 then var5 else 0) ~= 0 then
				event.set_camera_sequence_path_frames(480)
			end
			if (if var4 ~= 0 then 1 else var5) ~= 0 then
				event.set_camera_sequence_path_frames(240)
			end
			if var4 ~= 0 then
				event.add_camera_sequence_path_point(49.24, 24.83, 746.5, 14.71, 53.79, 698.03)
			end
			if var5 ~= 0 then
				event.add_camera_sequence_path_point(13.7, 24.83, 757.8, 14.71, 53.79, 698.03)
			end
			event.add_camera_sequence_path_point(-4.27, 55.7, 754.91, 14.71, 53.79, 698.03)
			event.start_camera_sequence_path()
		else
			at = 3
			wait_frames(60)
		end
		at = 4
		helper_4116e6bb(2750010)
		at = 5
		wait_camera()
		at = 6
		wait_frames(30)
		event.set_camera_sequence_position(17.1, 20.28, 879.05)
		event.set_camera_sequence_look_at(14.71, 53.79, 698.03)
		at = 7
		wait_frames(15)
		at = 8
		helper_4116e6bb(2750020)
		at = 9
		helper_4116e6bb(2750030)
		at = 10
		wait_frames(60)
		event.fade_out_screen(30)
		at = 11
		wait_frames(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22d00000()
			wait_frames_skipping(15)
		end
		if at <= 2 then
			wait_frames_skipping(60)
		end
		if at <= 3 then
			helper_8cd371d7(2750010)
		end
		if at <= 4 then
			helper_344d6cd8()
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			wait_frames_skipping(15)
		end
		if at <= 7 then
			helper_8cd371d7(2750020)
		end
		if at <= 8 then
			helper_8cd371d7(2750030)
		end
		if at <= 9 then
			wait_frames_skipping(60)
		end
		if at <= 10 then
			wait_frames_skipping(35)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	helper_24c68()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_2912c()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global6 = 0
		global7 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global6)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", global6)
		event.attach_object_handle_to_character(0, global6)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global6)
		event.load_character(5, "chara/c02_base.gltf", "info", global7)
		event.load_equipment_model(5, 1, 4, "info", global7)
		event.load_equipment_model(5, 1, 3, "info", global7)
		event.load_equipment_model(5, 1, 2, "info", global7, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global7)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", global7)
		event.attach_object_handle_to_character(1, global7)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global7)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global6 = 32
		global7 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global6)
		event.load_equipment_model(5, 0, 4, "info", global6)
		event.load_equipment_model(5, 0, 3, "info", global6)
		event.load_equipment_model(5, 0, 2, "info", global6, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global6)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", global6)
		event.attach_object_handle_to_character(0, global6)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global6)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global7)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", global7)
		event.attach_object_handle_to_character(1, global7)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global7)
	end
	event.load_message_file(0, 5, "event/e200/e280/e280a_1.txt")
end

--- Helper function.
local function helper_23100000()
	global6 = 0
	global7 = 32
	global6 = 32
	global7 = 0
end

--- Helper function.
local function helper_28dfc()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global6)
		event.set_character_active(0, global7)
		event.delete_character_extension_packs(global6)
		event.delete_character_extension_packs(global7)
		event.delete_character(global7)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global7)
		event.set_character_active(0, global6)
		event.delete_character_extension_packs(global6)
		event.delete_character_extension_packs(global7)
		event.delete_character(global6)
		event.delete_character(37)
	end
	event.jump_to_map_3(-1, "s26", 700)
end

--- Helper function.
local function helper_29d88()
	local var6: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(280, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		event.stop_music(0)
		at = 1
		wait_frames(45)
		event.load_music(59)
		event.load_map_sounds(2511)
		event.play_music(0, 36)
		var6 = event.load_sound_effect_file_2(2511) or var6
		helper_2912c()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global6)
		event.set_character_active(1, global7)
		event.set_camera_sequence_position(34.43, 5.8, 741.1)
		event.set_camera_sequence_look_at(26.93, 51.37, 586.27)
		event.set_object_sequence_position(1, 38.74, 7.54, 600.65)
		event.set_object_sequence_rotation(1, 0.0, -2.68, 0.0)
		event.set_object_sequence_position(0, 20.1, 6.52, 613.49)
		event.set_object_sequence_rotation(0, 0.0, 3.12, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		at = 2
		helper_4116e6bb(2800010)
		at = 3
		helper_4116e6bb(2800015)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "わらい口ひらき")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(-1.53, 38.93, 576.75)
		event.set_camera_sequence_look_at(47.63, 28.44, 622.59)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 4
		helper_4116e6bb(2800020)
		event.reset_mouth_texture_animations()
		at = 5
		wait_objects(1)
		event.set_object_sequence_motion(1, "上向くL", 4)
		at = 6
		wait_frames(30)
		event.set_camera_sequence_position(38.84, 15.89, 762.06)
		event.set_camera_sequence_look_at(30.81, 47.05, 622.71)
		at = 7
		wait_frames(15)
		at = 8
		helper_4116e6bb(2800030)
		at = 9
		helper_4116e6bb(2800040)
		at = 10
		wait_frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "不満目パチ")
		event.set_camera_sequence_position(17.72, 36.99, 568.83)
		event.set_camera_sequence_look_at(35.34, 28.44, 619.23)
		at = 11
		wait_frames(15)
		event.set_object_sequence_motion(1, "はぁ？", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "あきれ口パク")
		at = 12
		helper_4116e6bb(2800050)
		event.reset_mouth_texture_animations()
		at = 13
		wait_objects(1)
		at = 14
		wait_frames(30)
		event.set_camera_sequence_position(38.84, 15.89, 762.06)
		event.set_camera_sequence_look_at(30.81, 47.05, 622.71)
		at = 15
		wait_frames(15)
		at = 16
		helper_4116e6bb(2800060)
		event.set_camera_sequence_position(54.46, 37.12, 558.59)
		event.set_camera_sequence_look_at(20.97, 30.6, 620.45)
		at = 17
		helper_4116e6bb(2800065)
		event.set_camera_sequence_position(38.84, 15.89, 762.06)
		event.set_camera_sequence_look_at(30.81, 47.05, 622.71)
		at = 18
		helper_4116e6bb(2800070)
		at = 19
		wait_frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "不満顔")
		event.set_object_sequence_texture_animation(1, 1, "不満目パチ")
		event.set_camera_sequence_position(42.96, 39.99, 563.11)
		event.set_camera_sequence_look_at(28.37, 28.44, 607.63)
		event.set_object_sequence_rotation(0, 0.0, -2.56, 0.0)
		at = 20
		wait_frames(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 21
		helper_4116e6bb(2800080)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "上見から右見", 6)
		event.queue_object_sequence_next_motion(0, "右向く会話", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 22
		helper_4116e6bb(2800085)
		event.reset_mouth_texture_animations()
		at = 23
		wait_objects(0)
		at = 24
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_rotation(0, 0.0, 3.12, 0.0)
		event.set_camera_sequence_position(-23.31, 28.11, 596.86)
		event.set_camera_sequence_look_at(26.9, 28.44, 606.75)
		at = 25
		wait_frames(15)
		event.set_object_sequence_motion(1, "上向きから左向き", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "左向きから上向き", 6)
		event.queue_object_sequence_next_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "右見から上見", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 26
		helper_4116e6bb(2800090)
		event.reset_mouth_texture_animations()
		at = 27
		wait_objects(1)
		at = 28
		wait_frames(30)
		event.set_camera_sequence_position(60.85, 50.28, 994.5)
		event.set_camera_sequence_look_at(37.15, 90.96, 620.83)
		at = 29
		wait_frames(15)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(60.85, 50.28, 994.5, 37.15, 90.96, 620.83)
		event.add_camera_sequence_path_point(53.55, 50.28, 879.42, 29.85, 90.96, 505.75)
		event.start_camera_sequence_path()
		at = 30
		helper_1584c528(2800100, -1)
		event.play_sound_effect(var6, 8)
		at = 31
		wait_camera()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "うれし目パチ")
		event.set_camera_sequence_position(15.67, 33.06, 545.55)
		event.set_camera_sequence_look_at(37.65, 31.67, 641.15)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(15.67, 33.06, 545.55, 37.65, 31.67, 641.15)
		event.add_camera_sequence_path_point(21.77, 33.06, 572.11, 37.65, 31.67, 641.15)
		event.start_camera_sequence_path()
		at = 32
		wait_camera()
		event.set_camera_sequence_position(38.84, 15.89, 762.06)
		event.set_camera_sequence_look_at(30.81, 47.05, 622.71)
		event.stop_sound_effect(var6, 8)
		at = 33
		helper_1584c528(2800110, 120)
		event.play_sound_effect(var6, 9)
		event.set_object_sequence_motion(1, "がっかり肩落とし", 6)
		event.queue_object_sequence_next_motion(1, "がっかり肩落としＬ", 4)
		event.set_object_sequence_motion(0, "がっかり", 6)
		event.queue_object_sequence_next_motion(0, "がっかりＬ", 4)
		at = 34
		wait_frames(60)
		event.set_object_sequence_motion(1, "頭抱えるＬ", 4, -1.0, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "こまり顔")
		event.set_object_sequence_texture_animation(0, 1, "こまり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ")
		event.set_camera_sequence_position(-23.31, 28.11, 596.86)
		event.set_camera_sequence_look_at(26.9, 28.44, 606.75)
		at = 35
		wait_frames(15)
		at = 36
		helper_4116e6bb(2800120)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "こまり顔")
		event.set_object_sequence_texture_animation(0, 1, "こまり目～通常目")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ～おこり目あき")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(var6, 10)
		event.set_object_sequence_motion(0, "がっかり→上", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 37
		helper_4116e6bb(2800130)
		event.reset_mouth_texture_animations()
		at = 38
		wait_objects(0)
		event.set_object_sequence_motion(0, "上見から右見", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "手をおろす", 6)
		event.queue_object_sequence_next_motion(1, "下向き立ちＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 39
		helper_4116e6bb(2800140)
		event.reset_mouth_texture_animations()
		at = 40
		wait_objects(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 41
		helper_4116e6bb(2800145)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "右向く会話", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		at = 42
		helper_4116e6bb(2800150)
		at = 43
		wait_objects(0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "さみし顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "おこり目～さみし目")
		event.set_object_sequence_motion(1, "下向き立ちＬ", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "下向きから左向き", 6)
		event.queue_object_sequence_next_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "さみし口パク")
		at = 44
		helper_4116e6bb(2800160)
		event.reset_mouth_texture_animations()
		at = 45
		wait_objects(1)
		at = 46
		wait_frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "さみし顔")
		event.set_object_sequence_texture_animation(1, 1, "さみし目パチ")
		event.set_camera_sequence_position(42.73, 39.99, 562.51)
		event.set_camera_sequence_look_at(25.56, 28.44, 606.38)
		event.set_object_sequence_rotation(0, 0.0, -2.56, 0.0)
		at = 47
		wait_frames(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 48
		helper_4116e6bb(2800170)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向きから下向き", 6)
		event.queue_object_sequence_next_motion(1, "下向き立ちＬ", 4)
		event.set_mouth_texture_animations(1, "さみし口パク")
		at = 49
		helper_4116e6bb(2800180)
		event.reset_mouth_texture_animations()
		at = 50
		wait_frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "さみし目～通常目")
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(28.25, 31.54, 674.64)
		event.set_camera_sequence_look_at(28.22, 28.44, 600.45)
		event.set_object_sequence_motion(0, "右回転90度（ＰＧ）", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.rotate_object_sequence(0, 0.0, 2.4, 0.0, 20)
		at = 51
		wait_objects(0)
		at = 52
		wait_objects(0)
		event.play_sound_effect(var6, 11)
		event.set_object_sequence_motion(0, "がっつ", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 53
		helper_4116e6bb(2800190)
		event.reset_mouth_texture_animations()
		at = 54
		wait_objects(0)
		event.set_object_sequence_motion(0, "モニカ見立ちうなづき", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		at = 55
		helper_4116e6bb(2800195)
		at = 56
		wait_objects(0)
		event.play_sound_effect(var6, 12)
		event.rotate_object_sequence(1, 0.0, -1.0, 0.0, 30)
		event.set_object_sequence_motion(1, "左回転90度（ＰＧ）", 6)
		at = 57
		wait_objects(1)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 58
		helper_4116e6bb(2800200)
		event.reset_mouth_texture_animations()
		at = 59
		wait_objects(1)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 60
		helper_4116e6bb(2800205)
		event.reset_mouth_texture_animations()
		at = 61
		wait_objects(1)
		event.play_sound_effect(var6, 13)
		event.set_object_sequence_motion(0, "がっつ", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 62
		helper_4116e6bb(2800210)
		event.reset_mouth_texture_animations()
		at = 63
		wait_objects(0)
		event.play_sound_effect(var6, 14)
		event.play_sound_effect(var6, 15)
		event.set_object_sequence_motion(0, "モニカ見立うなづき", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 64
		wait_objects(0)
		at = 65
		wait_objects(1)
		event.set_object_sequence_motion(1, "歩き")
		event.set_object_sequence_motion(0, "歩き")
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 20)
		event.rotate_object_sequence(1, 0.0, 0.0, 0.0, 20)
		at = 66
		wait_objects(0)
		at = 67
		wait_objects(1)
		event.set_object_sequence_motion(1, "走り")
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 20.44, 6.52, 1490.12, 390, 1)
		event.move_object_sequence(1, 39.08, 7.54, 1478.94, 390, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(240)
		event.add_camera_sequence_path_point(28.25, 31.54, 674.64, 28.22, 28.44, 600.45)
		event.add_camera_sequence_path_point(28.59, 31.54, 1526.51, 28.22, 28.44, 600.45)
		event.start_camera_sequence_path()
		at = 68
		wait_frames(15)
		at = 69
		wait_frames(200)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 70
		wait_frames(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_23100000()
			helper_8cd371d7(2800010)
		end
		if at <= 2 then
			helper_8cd371d7(2800015)
		end
		if at <= 3 then
			helper_8cd371d7(2800020)
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			wait_frames_skipping(15)
		end
		if at <= 7 then
			helper_8cd371d7(2800030)
		end
		if at <= 8 then
			helper_8cd371d7(2800040)
		end
		if at <= 9 then
			wait_frames_skipping(30)
		end
		if at <= 10 then
			wait_frames_skipping(15)
		end
		if at <= 11 then
			helper_8cd371d7(2800050)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			wait_frames_skipping(30)
		end
		if at <= 14 then
			wait_frames_skipping(15)
		end
		if at <= 15 then
			helper_8cd371d7(2800060)
		end
		if at <= 16 then
			helper_8cd371d7(2800065)
		end
		if at <= 17 then
			helper_8cd371d7(2800070)
		end
		if at <= 18 then
			wait_frames_skipping(30)
		end
		if at <= 19 then
			wait_frames_skipping(15)
		end
		if at <= 20 then
			helper_8cd371d7(2800080)
		end
		if at <= 21 then
			helper_8cd371d7(2800085)
		end
		if at <= 22 then
			helper_238b5abc(0)
		end
		if at <= 23 then
			wait_frames_skipping(30)
		end
		if at <= 24 then
			wait_frames_skipping(15)
		end
		if at <= 25 then
			helper_8cd371d7(2800090)
		end
		if at <= 26 then
			helper_238b5abc(1)
		end
		if at <= 27 then
			wait_frames_skipping(30)
		end
		if at <= 28 then
			wait_frames_skipping(15)
		end
		if at <= 29 then
			helper_52aadc70(2800100, -1)
		end
		if at <= 30 then
			helper_344d6cd8()
		end
		if at <= 31 then
			helper_344d6cd8()
		end
		if at <= 32 then
			helper_52aadc70(2800110, 120)
		end
		if at <= 33 then
			wait_frames_skipping(60)
		end
		if at <= 34 then
			wait_frames_skipping(15)
		end
		if at <= 35 then
			helper_8cd371d7(2800120)
		end
		if at <= 36 then
			helper_8cd371d7(2800130)
		end
		if at <= 37 then
			helper_238b5abc(0)
		end
		if at <= 38 then
			helper_8cd371d7(2800140)
		end
		if at <= 39 then
			helper_238b5abc(1)
		end
		if at <= 40 then
			helper_8cd371d7(2800145)
		end
		if at <= 41 then
			helper_8cd371d7(2800150)
		end
		if at <= 42 then
			helper_238b5abc(0)
		end
		if at <= 43 then
			helper_8cd371d7(2800160)
		end
		if at <= 44 then
			helper_238b5abc(1)
		end
		if at <= 45 then
			wait_frames_skipping(30)
		end
		if at <= 46 then
			wait_frames_skipping(15)
		end
		if at <= 47 then
			helper_8cd371d7(2800170)
		end
		if at <= 48 then
			helper_8cd371d7(2800180)
		end
		if at <= 49 then
			wait_frames_skipping(30)
		end
		if at <= 50 then
			helper_238b5abc(0)
		end
		if at <= 51 then
			helper_238b5abc(0)
		end
		if at <= 52 then
			helper_8cd371d7(2800190)
		end
		if at <= 53 then
			helper_238b5abc(0)
		end
		if at <= 54 then
			helper_8cd371d7(2800195)
		end
		if at <= 55 then
			helper_238b5abc(0)
		end
		if at <= 56 then
			helper_238b5abc(1)
		end
		if at <= 57 then
			helper_8cd371d7(2800200)
		end
		if at <= 58 then
			helper_238b5abc(1)
		end
		if at <= 59 then
			helper_8cd371d7(2800205)
		end
		if at <= 60 then
			helper_238b5abc(1)
		end
		if at <= 61 then
			helper_8cd371d7(2800210)
		end
		if at <= 62 then
			helper_238b5abc(0)
		end
		if at <= 63 then
			helper_238b5abc(0)
		end
		if at <= 64 then
			helper_238b5abc(1)
		end
		if at <= 65 then
			helper_238b5abc(0)
		end
		if at <= 66 then
			helper_238b5abc(1)
		end
		if at <= 67 then
			wait_frames_skipping(15)
		end
		if at <= 68 then
			wait_frames_skipping(200)
		end
		if at <= 69 then
			wait_frames_skipping(35)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(var6, 8)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_28dfc()
	event.reset_follow_camera(0)
end

--- Helper function.
local function helper_2fed4()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e285/e285_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e285/e285_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e200/e285/e285_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e285/e285_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_item_model(5, 31, "info", 36)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e272/e272_hanabaku.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e200/e272/e272_kirakira.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(4, 39)
	event.clear_object_sequence(5, 39)
	event.set_object_sequence_object(5, 4)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 40)
	event.attach_object_handle_to_character(5, 40)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 5)
	event.set_character_active(0, 40)
	event.load_message_file(0, 5, "event/e200/e285/e285_1.txt")
end

--- Helper function.
local function helper_2e378()
	event.fade_in_screen(30)
	event.play_sound_effect(global8, 0)
	event.move_camera_sequence(111.21, 97.1, 1515.22, 354.23, 94.23, 1247.17, 540)
	wait_frames(50)
	helper_1584c528(2850010, -1)
	wait_camera()
	wait_frames(30)
	event.stop_sound_effect(global8, 0)
end

--- Helper function.
local function helper_2e560()
	event.set_object_sequence_motion(0, "立ち", 0)
	event.set_object_sequence_motion(1, "立ち", 0)
	wait_frames(15)
	helper_4116e6bb(2850020)
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "もごもご")
	wait_frames(30)
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "ふんっ")
	wait_frames(30)
	event.set_character_active(1, 38)
	event.set_wind(40.0, -96.86, 52.75, 388.46)
	event.set_character_motion(38, "鼻爆発", 2, -1, 1)
	event.play_sound_effect(global8, 1)
	wait_frames(15)
	event.set_wind(-1)
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
	event.set_object_sequence_motion(0, "驚く", 6)
	event.set_object_sequence_motion(1, "おどろき", 6)
	event.queue_object_sequence_next_motion(0, "驚くL", 4)
	event.queue_object_sequence_next_motion(1, "おどろきL", 4)
	wait_frames(90)
	event.set_character_active(1, 39)
	event.set_character_motion(39, "キラキラ（ループ）", 4, -1, 1)
	event.play_sound_effect(global8, 2)
	event.clear_object_sequence_path(5)
	event.set_object_sequence_path_frames(5, 150)
	event.add_object_sequence_path_point(5, 12.99, 142.28, 609.6)
	event.add_object_sequence_path_point(5, 12.99, 35.2, 609.6)
	event.start_object_sequence_path(5)
	event.set_object_sequence_motion(0, "キラキラ見る", 2)
	event.set_object_sequence_motion(1, "おどろきＬから上向き立ち", 2)
	wait_frames(150)
	event.queue_object_sequence_next_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(1, "上向く戻り", 6, 0.025)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	wait_frames(20)
	event.set_character_motion(39, "消える", 2, -1, 1)
	wait_frames(30)
	wait_objects(0)
	event.set_character_active(0, 39)
end

--- Helper function.
local function helper_2ef80()
	event.set_object_sequence_position(6, 5.99, 36.82, 613.24)
	event.set_object_sequence_rotation(6, 0.0, -2.92, 0.0)
	event.set_character_active(1, 36)
	event.set_character_active(1, 40)
	event.play_sound_effect(global8, 3)
	event.play_sound_effect(global8, 4)
	event.pause_music()
	event.play_sound_effect(global9, 0)
	event.set_object_sequence_motion(6, "発動", 6)
	event.attach_character_to_frame(global0, "gun_hand", 36)
	event.set_object_sequence_motion(0, "銃ゲット", 4)
	wait_frames(15)
	helper_f38eabca(31, 1)
	event.detach_character_from_frame(36)
	event.set_character_active(0, 40)
	event.stop_sound_effect(global9, 0)
	event.play_music(0)
end

--- Helper function.
local function helper_2fac8()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(36)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(36)
		event.delete_character(37)
	end
	event.set_map_piece_character_motion("jyuraku", "jyuraku", "瞬き")
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
end

--- Helper function.
local function helper_30ea4()
	vm.section(function()
		event.set_save_flag(285, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(2517)
		global8 = event.load_sound_effect_file_2(2517) or global8
		global9 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or global9
		helper_2fed4()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_position(38, -96.86, 52.75, 388.46)
		event.set_character_rotation(38, 0.0, 0.0, 0.0)
		event.set_character_position(39, 37.43, 34.75, 561.52)
		event.set_character_rotation(39, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(111.21, 97.1, 1515.22)
		event.set_camera_sequence_look_at(-186.27, 94.23, 1323.31)
		event.set_object_sequence_position(0, 13.4, 6.52, 613.7)
		event.set_object_sequence_rotation(0, 0.0, -2.92, 0.0)
		event.set_object_sequence_position(1, 47.24, 7.54, 600.38)
		event.set_object_sequence_rotation(1, 0.0, -2.2, 0.0)
		helper_2e378()
		event.set_camera_sequence_position(46.15, 36.68, 848.41)
		event.set_camera_sequence_look_at(38.64, 44.8, 724.85)
		helper_2e560()
		event.set_camera_sequence_position(3.9, 53.24, 586.95)
		event.set_camera_sequence_look_at(8.68, 32.62, 613.94)
		helper_2ef80()
		event.set_camera_sequence_position(46.15, 36.68, 848.41)
		event.set_camera_sequence_look_at(38.64, 44.8, 724.85)
		helper_c1df6484()
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(global8, 0)
	event.set_wind(-1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_2fac8()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_268e0()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e277/e277_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e277/e277_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e200/e277/e277_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e277/e277_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e277/e277_hima_b.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(2, 35)
	event.clear_object_sequence(2, 35)
	event.set_object_sequence_object(2, 2)
	event.load_message_file(0, 5, "event/e200/e277/e277_1.txt")
end

--- Helper function.
local function helper_22f00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_265e4()
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
	event.delete_character(35)
end

--- Helper function.
local function helper_27664()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(277, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 1
		wait_frames(45)
		event.load_map_sounds(2509)
		var4 = event.load_sound_effect_file_2(2509) or var4
		helper_268e0()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(-117.43, 40.09, 1220.9)
		event.set_camera_sequence_look_at(-24.54, 60.52, 1410.11)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(0, -130.99, 21.7, 1253.92)
		event.set_object_sequence_rotation(0, 0.0, 0.77, 0.0)
		event.set_object_sequence_position(1, -113.36, 16.04, 1218.2)
		event.set_object_sequence_rotation(1, 0.0, 0.17, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "歩き")
		event.set_object_sequence_motion(1, "歩き")
		at = 2
		wait_frames(15)
		event.move_object_sequence(0, -76.57, 22.37, 1326.65, 90, 1)
		event.move_object_sequence(1, -99.28, 16.04, 1239.49, 30, 1)
		at = 3
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		at = 4
		helper_1584c528(2770010, -1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.rotate_object_sequence(0, 0.0, -2.87, 0.0, 20)
		at = 5
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		at = 6
		helper_1584c528(2770020, 60)
		event.set_camera_sequence_position(-88.03, 39.16, 1280.67)
		event.set_camera_sequence_look_at(-98.45, 39.74, 1240.52)
		event.attach_character_to_frame(global1, "item", 35)
		event.set_character_active(1, 35)
		event.play_sound_effect(var4, 0)
		event.set_object_sequence_motion(1, "バッチ持ち立ち", 4)
		at = 7
		wait_frames(15)
		event.set_object_sequence_motion(1, "バッチ持ち会話", 2)
		event.queue_object_sequence_next_motion(1, "バッチ持ち立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 8
		helper_4116e6bb(2770030)
		event.reset_mouth_texture_animations()
		at = 9
		wait_objects(1)
		event.set_object_sequence_motion(1, "バッチ持ち会話", 2)
		event.queue_object_sequence_next_motion(1, "バッチ持ち立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 10
		helper_4116e6bb(2770040)
		event.reset_mouth_texture_animations()
		at = 11
		wait_objects(1)
		event.set_object_sequence_motion(1, "バッチ持ち会話", 2)
		event.queue_object_sequence_next_motion(1, "バッチ持ち立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 12
		helper_4116e6bb(2770050)
		event.reset_mouth_texture_animations()
		at = 13
		wait_objects(1)
		event.set_object_sequence_motion(1, "バッチ持ち立ち")
		at = 14
		wait_frames(30)
		event.set_character_active(0, 35)
		event.detach_character_from_frame(35)
		event.set_camera_sequence_position(-117.43, 40.09, 1220.9)
		event.set_camera_sequence_look_at(-24.54, 60.52, 1410.11)
		event.set_object_sequence_motion(0, "やったね", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 15
		helper_4116e6bb(2770060)
		event.reset_mouth_texture_animations()
		at = 16
		wait_objects(0)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 17
		helper_4116e6bb(2770065)
		event.reset_mouth_texture_animations()
		at = 18
		wait_objects(0)
		at = 19
		helper_1584c528(2770070, 150)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -60.53, 20.6, 1300.47, 60, 1)
		event.move_camera_sequence(-133.69, 30.07, 1231.38, -2.07, 60.52, 1392.67, 150)
		event.set_object_sequence_motion(0, "モニカ見立うなづき", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 20
		helper_1584c528(2770080, -1)
		event.set_object_sequence_motion(0, "歩き")
		event.rotate_object_sequence(0, 0.0, 0.89, 0.0, 30)
		at = 21
		wait_objects(0)
		event.move_object_sequence(0, -42.89, 22.37, 1361.14, 60, 1)
		event.move_object_sequence(1, -28.2, 20.64, 1346.17, 60, 1)
		at = 22
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22f00000()
			wait_frames_skipping(15)
		end
		if at <= 2 then
			helper_238b5abc(1)
		end
		if at <= 3 then
			helper_52aadc70(2770010, -1)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_52aadc70(2770020, 60)
		end
		if at <= 6 then
			wait_frames_skipping(15)
		end
		if at <= 7 then
			helper_8cd371d7(2770030)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			helper_8cd371d7(2770040)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			helper_8cd371d7(2770050)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			wait_frames_skipping(30)
		end
		if at <= 14 then
			helper_8cd371d7(2770060)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_8cd371d7(2770065)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_52aadc70(2770070, 150)
		end
		if at <= 19 then
			helper_52aadc70(2770080, -1)
		end
		if at <= 20 then
			helper_238b5abc(0)
		end
		if at <= 21 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 23
	wait_frames(30)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_265e4()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_10a9c()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	var3 = 0
	if var2 == 100 then
		var4 = event.get_georama_analysis_flag(103) or var4
		if var4 == 0 then
			event.open_message_window_2(
				0,
				"Ultimamente [UNI00e8] stato un po'\ntriste. Sembra che manchi\nqualcosa, sai? Comunque..."
			)
		else
			flag = event.get_save_flag(280) or flag
			if flag == 0 then
				event.open_message_window_2(
					0,
					"Jurak [UNI00e8] stato riportato in vita!\nStrano che non abbia pensato\na Jurak per tutto questo tempo."
				)
			else
				event.open_message_window_2(
					0,
					"Meraviglioso! Anche la foresta [UNI00e8]\ntornata come prima. Jurak [UNI00e8] di\nbuon umore. Niente da ridire!"
				)
			end
		end
	end
	if var2 == 101 then
		flag_2 = event.get_save_flag(280) or flag_2
		if flag_2 == 0 then
			event.open_message_window_2(
				0,
				"Ho un buon assortimento, sai?\nE ti offro un vero affare per\nfesteggiare il risveglio di Jurak."
			)
		else
			event.open_message_window_2(0, "Grazie a voi, Jurak e l'intera\nforesta ora sono come prima.\nTornate quando volete!")
		end
	end
	if var2 == 104 then
		flag_3 = event.get_save_flag(280) or flag_3
		if flag_3 == 0 then
			event.open_message_window_2(
				0,
				"Mmh... Quel Grifone l'ha proprio\nfatta grossa. Difficile credere\nche Jurak fosse scomparso davvero!"
			)
		else
			event.open_message_window_2(
				0,
				"Jurak [UNI00e8] tornato, quindi [UNI00e8] il\nmomento di contrattaccare Grifone.\nSe rimaniamo uniti, vinceremo!"
			)
		end
	end
	if var2 == 102 then
		flag_4 = event.get_save_flag(280) or flag_4
		if flag_4 == 0 then
			var9 = event.get_save_data_value(1, 52) or var9
			if var9 == 0 then
				event.open_message_window_2(
					0,
					"Abbiamo ottenuto degli Stemmi\nMutazione in Mostro! Prendetene\nsubito uno, prima che sia tardi!"
				)
			else
				event.open_message_window_2(
					0,
					"Questo era l'ultimo stemma. Meno\nmale che l'avete preso, non so\nquando riusciremo ad averne altri."
				)
			end
		else
			event.open_message_window_2(0, "Stai usando lo Stemma Mutazione in\nMostro? Ce ne sono molti altri\ntipi, sai?")
			helper_31bbf01d(player_chara, var1, 0)
			helper_0ffc2526(0, -1, var1, player_chara, 0)
			var3 = 1
			event.open_message_window_2(
				0,
				"A volte, se dai ad un mostro tre\noggetti di suo interesse, sar[UNI00e0]\ncos[UNI00ec] felice da lasciar cadere uno<page>stemma, quando lo uccidi. Certo,\nti servir[UNI00e0] uno dei miei speciali\nporta-doni. Allora, che ne dici?"
			)
		end
	end
	if var2 == 103 then
		flag_5 = event.get_save_flag(280) or flag_5
		if flag_5 == 0 then
			event.open_message_window_2(0, "Salve! Mangi abbastanza?\nNon diventerai mai grande se\nnon mangi. Mangia, d'accordo?")
		else
			event.open_message_window_2(0, "Jurak [UNI00e8] felice e gli affari\nvanno di bene in meglio.")
		end
	end
	if var2 == 105 then
		flag_6 = event.get_save_flag(640) or flag_6
		if flag_6 == 0 then
			flag_7 = event.get_save_flag(280) or flag_7
			if flag_7 == 0 then
				event.open_message_window_2(
					0,
					"Mi chiedo cos'abbia fatto tutto\nquesto tempo! Non riesco proprio\na ricordare.<page>Ehi, se posso permettermi, hai\nproprio una bella tenuta l[UNI00ec]!"
				)
			else
				event.open_message_window_2(
					0,
					"Allora stai per partire per nuove\nterre finalmente, eh? Bene, buona\nfortuna e buon viaggio!"
				)
			end
		else
			event.open_message_window_2(
				0,
				"Sconfiggete l'Imperatore Grifone\ne riportate questi tempi oscuri\nalla normalit[UNI00e0]. Ci contiamo!"
			)
		end
	end
	if var3 == 0 then
		helper_1c04a0eb(var1, -1, 0, 0)
	end
	if var3 == 1 then
		helper_0ffc2526(0, -1, var1, player_chara, 0)
		event.set_character_motion(var1, "立ち")
		event.finish_event()
	end
	if var3 == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		player_chara_2 = event.get_player_character_slot() or player_chara_2
		do
			local out1, _, out3 = event.get_character_position(player_chara_2)
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.get_character_position(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.get_look_angle(var17 - var14, var19 - var16) or var20
		helper_76f23193(player_chara_2, var20)
		event.set_character_rotation(player_chara_2, 0.0, var20, 0.0)
		event.set_character_motion(player_chara_2, "立ち")
		helper_0ffc2526(0, -1, var1, player_chara_2, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, var1)
	if var2 == 101 then
		helper_59a16271(25)
	end
	if var2 == 102 then
		helper_59a16271(24)
	end
	if var2 == 103 then
		helper_59a16271(26)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local old_map_no: s32 = 0
	local var8: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	event_99()
	old_map_no = event.get_previous_map() or old_map_no
	if old_map_no == 0 then
		event.set_camera_position(39.03, 111.84, 77.64)
		event.set_camera_look_at(36.78, 22.33, 74.62)
		event.fade_out_screen(0, 255, 255, 255)
		vm.wait(1)
		event.set_camera_position(102.4, 73.47, 1368.2)
		event.set_camera_look_at(102.4, 53.47, 1488.2)
		event.set_character_position(0, 110.0, 23.7, 1533.0)
		event.set_character_rotation(0, 0.0, -3.1415927, 0.0)
		event.reset_follow_camera(1, 3.14, 2.0)
	end
	event.fade_in_screen(30)
	event.get_save_flag(250)
	event.get_save_flag(260)
	event.get_save_flag(270)
	event.get_save_flag(272)
	event.get_save_flag(275)
	event.get_save_flag(280)
	event.get_save_flag(285)
	var8 = event.get_georama_analysis_flag(103) or var8
	event.get_georama_analysis_flag(104)
	event.get_georama_analysis_percent(0)
	if var8 == 0 then
		return
	end
	if helper_e538a72d() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(270, 1)
		helper_1d334()
		event.set_character_position(0, 169.8, 23.7, 1378.8)
		return
	end
	if helper_342a37b0() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(272, 1)
		helper_21af4()
		event.add_inventory_item(361)
		event.add_inventory_item(308)
		argc = event.get_item_limit_status() or argc
		argc_2 = event.get_overflow_item_count() or argc_2
		if argc >= 1 or argc_2 >= 1 then
			event.fade_out_screen(10)
			wait_frames(10)
			event.open_event_menu(16)
			vm.wait(5)
			event.fade_in_screen(10)
		end
		return
	end
	if helper_ee09935e() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(275, 1)
		helper_66ac1f76()
		helper_259cc()
		return
	end
	if helper_b84429a4() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(280, 1)
		helper_29d88()
		return
	end
	if helper_c5ea1698() ~= 0 then
		event.fade_out_screen(30)
		event.set_save_flag(285, 1)
		helper_30ea4()
		event.add_inventory_item(31)
		helper_a87eb945(1)
		return
	end
	event.set_character_position(0, 110.0, 23.7, 1533.0)
	event.set_character_rotation(0, 0.0, -3.1415927, 0.0)
	event.reset_follow_camera(1)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_21af4

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_7ed7ab4f(100.0, vm.f32(23.67), 1500.0, 0.0)
	event.jump_to_map_2(-1, "g01")
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	event.set_function_point_enabled("", "e277", 0)
	event.set_save_flag(277, 1)
	helper_27664()
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local player_chara: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local argc: s32 = 0
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_active_camera_next_position(-140.41, 35.58, 1026.08)
	event.set_active_camera_next_look_at(23.01, 135.7, 535.77)
	player_chara = event.get_player_character_slot() or player_chara
	helper_81af0537(player_chara, 0.0, 300.0)
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 0)
	flag = event.get_save_flag(640) or flag
	if flag == 0 then
		flag_2 = event.get_save_flag(372) or flag_2
		if flag_2 == 0 then
			flag_3 = event.get_save_flag(280) or flag_3
			if flag_3 == 0 then
				flag_4 = event.get_save_flag(275) or flag_4
				if flag_4 == 0 then
					flag_5 = event.get_save_flag(272) or flag_5
					if flag_5 == 0 then
						event.open_message_window_2(
							0,
							"Seeembra proprio che non rieeesca\na ricordare nuuulla. Immaggino\nmi seerva solo dell'altro teeempo."
						)
					else
						event.open_message_window_2(
							0,
							"Il seeeeme [UNI00e8] stato piaaaantato?\nE sta iniziando a geeeermogliare?<page>Era un reeeegalo, quindi faaatene\nbuon uso, caaaapito?"
						)
					end
				else
					argc = event.get_item_count(356) or argc
					if argc <= 0 then
						event.open_message_window_2(
							0,
							"Per avere una Goccia del Sole\nparlate con un mostro Himarra.\nPer farlo, usate lo stemma."
						)
						show_message(0, -1, 3, 0, 416)
						event.open_message_window_2(
							0,
							"Per diventare una Himarraaaa, ti\nserve uno Steeeemma di Himarra.<page>A volte li vendono\nnei neeeegozi di veeeestiti.<page>Oh, s[UNI00ec][UNI00ec][UNI00ec][UNI00ec]! C'[UNI00e8] un neeeegozio\ndi veeeestiti nel mio naaaaso."
						)
						show_message(0, -1, 3, 0, 416)
						event.open_message_window_2(0, "La narice destra [UNI00e8] ancora vuoota.\nSto cercando un inquiiilino.")
					else
						event.open_message_window_2(
							0,
							"Avete trovato la Goccia del Sole!\nOra, usate la Goccia del Sole dove\navete piantato la Lafrescia, OK?<page>Spero proprio che troviate\nla Farfalla Arcobaleno. Pregher[UNI00f2]\nper voi in battaglia, d'accordo?"
						)
					end
				end
			else
				event.open_message_window_2(
					0,
					"Chiedete maggiori dettagli a\nCrest, il Grande Saggio nel tempio\ndella Valle dell'Equilibrio, OK?<page>Vi dir[UNI00e0] tutto quello che dovete\nsapere... molto\nrassicurante!"
				)
			end
		else
			event.open_message_window_2(
				0,
				"Bene, bene, a quanto pare siete\nandati da Crest. Vero?\nBen fatto.<page>Ma avete ancora molta strada\nda fare. Non arrendetevi\nproprio ora, d'accordo?"
			)
		end
	else
		event.open_message_window_2(
			0,
			"Allora, state andando a combattere\nGrifone, vero? Ma c'[UNI00e8] qualcosa\nche ancora mi turba.<page>Percepisco anche uno spirito\ngentile racchiuso in\nGrifone. Strano, no?"
		)
	end
	show_message(0, -1, 3, 0, 416)
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.start_crossfade(10)
end

--- Event 402, which map data, a script or the engine runs by number.
function script.event_402()
	local flag: s32 = 0
	event.set_character_motion(0, "立ち")
	flag = event.get_save_flag(36) or flag
	if flag == 0 then
		event.set_save_flag(36, 1)
		event.add_inventory_item(376)
		helper_f38eabca(376, 1)
		helper_a87eb945(1)
	else
		set_window_mode(0, 1)
		event.open_message_window_2(0, "Mi chiedo cosa uscir[UNI00e0] da questo\nuovo?")
		show_message(0, -1, 5, 256, 208)
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_30ea4()
	event.fade_in_screen(30)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_10a9c

--- Event 12700, which map data, a script or the engine runs by number.
function script.event_12700()
	event.set_georama_analyze_flag(0, 4, 0)
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_save_flag(270, 0)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 1)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end

--- Event 12720, which map data, a script or the engine runs by number.
function script.event_12720()
	event.set_georama_analyze_flag(0, 4, 0)
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 0)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 1)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end

--- Event 12750, which map data, a script or the engine runs by number.
function script.event_12750()
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_georama_analyze_flag(0, 4, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 0)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 1)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end

--- Event 12770, which map data, a script or the engine runs by number.
function script.event_12770()
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_georama_analyze_flag(0, 4, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 0)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 1)
	event.set_save_data_value(1, 52, 1)
	event.jump_to_map_3(-1, 25, 400)
	vm.wait(1)
end

--- Event 12800, which map data, a script or the engine runs by number.
function script.event_12800()
	event.set_georama_analyze_flag(0, 5, 0)
	event.set_georama_analyze_flag(0, 6, 0)
	event.set_georama_analyze_flag(0, 7, 0)
	event.set_georama_analyze_flag(0, 8, 0)
	event.set_georama_analyze_flag(0, 9, 0)
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_georama_analyze_flag(0, 4, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 0)
	event.set_save_flag(285, 1)
	event.set_save_flag(260, 1)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end

--- Event 12850, which map data, a script or the engine runs by number.
function script.event_12850()
	event.set_georama_analyze_flag(0, 0, 1)
	event.set_georama_analyze_flag(0, 2, 1)
	event.set_georama_analyze_flag(0, 3, 1)
	event.set_georama_analyze_flag(0, 4, 1)
	event.set_georama_analyze_flag(0, 5, 1)
	event.set_georama_analyze_flag(0, 6, 1)
	event.set_georama_analyze_flag(0, 7, 1)
	event.set_georama_analyze_flag(0, 8, 1)
	event.set_georama_analyze_flag(0, 9, 1)
	event.set_save_flag(270, 1)
	event.set_save_flag(272, 1)
	event.set_save_flag(275, 1)
	event.set_save_flag(277, 1)
	event.set_save_flag(280, 1)
	event.set_save_flag(285, 0)
	event.jump_to_map_3(-1, 25, 100)
	vm.wait(1)
end

return script
