--!strict
-- map/s/s70/s70_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4e15b328 = require("@lib/event/helper_4e15b328")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

--- Helper function.
local function helper_11480()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global2)
		event.load_character(5, "chara/c02_base.gltf", "info", global3)
		event.load_equipment_model(5, 1, 4, "info", global3)
		event.load_equipment_model(5, 1, 3, "info", global3)
		event.load_equipment_model(5, 1, 2, "info", global3, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global3)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global2 = 32
		global3 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global2)
		event.load_equipment_model(5, 0, 4, "info", global2)
		event.load_equipment_model(5, 0, 3, "info", global2)
		event.load_equipment_model(5, 0, 2, "info", global2, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global2)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global3)
	end
	event.load_character(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.load_character(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(4, 40)
	event.clear_object_sequence(4, 40)
	event.set_object_sequence_object(4, 4)
	event.load_character(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(5, 41)
	event.clear_object_sequence(5, 41)
	event.set_object_sequence_object(5, 5)
	event.load_character(5, "event/e600/e616/e616_tama1.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.attach_object_handle_to_character(6, 42)
	event.clear_object_sequence(6, 42)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/e600/e616/e616_ozu_moe.gltf", "info", 43)
	event.set_character_active(0, 43)
	event.load_character(5, "event/e600/e616/e616_ozu_kemuri.gltf", "info", 44)
	event.set_character_active(0, 44)
	event.initialize_effect_manager(5)
	event.load_effect_base("Ｅ６１６月花ビームＢ")
	event.create_effect_work_buffer(5)
	event.load_message_file(0, 5, "event/e600/e616/e616_1.txt")
end

--- Helper function.
local function helper_110ac()
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
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_character(43)
	event.delete_character(44)
end

--- Helper function.
local function helper_12890()
	local var6: s32 = 0
	local projection: f32 = 0
	local var8: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7200)
		var6 = event.load_sound_effect_file_2(7200) or var6
		helper_11480()
		projection = event.get_event_projection() or projection
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_character_active(0, global2)
		event.set_character_active(1, global3)
		event.set_character_active(1, 38)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "何てこと", 6, -1.0, 1)
		event.call_command(466, 1, "何てことL", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_sequence_motion(2, "立ち（上見）", 4)
		event.set_object_sequence_position(1, 32.0, 0.0, 1400.0)
		event.set_object_sequence_rotation(1, 0.0, -0.59, 0.0)
		event.set_object_sequence_position(0, -32.0, 0.0, 1400.0)
		event.set_object_sequence_rotation(0, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(2, 17.0, 0.0, 1400.0)
		event.set_object_sequence_rotation(2, 0.0, 0.01, 0.0)
		event.set_object_sequence_position(3, 418.95, 294.2, 1072.8)
		event.set_object_sequence_rotation(3, 0.0, -2.72, 0.0)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(5, 17.0, 0.0, 1380.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(-9.53, 17.78, 1399.96)
		event.set_camera_sequence_look_at(36.07, 23.27, 1405.88)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 1
		helper_4116e6bb(6160060)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var6, 6)
		event.set_mouth_texture_animations(2, "通常口パク")
		at = 2
		helper_4116e6bb(6160070)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var6, 7)
		at = 3
		wait_frames(30)
		event.play_sound_effect(var6, 8)
		event.set_wind(80.0, 17.0, 0.0, 1380.0)
		event.set_character_motion(41, "ヒット", 6, -1, 1)
		event.set_character_active(1, 41)
		at = 4
		wait_frames(10)
		event.play_sound_effect(var6, 9)
		event.set_wind(-1)
		event.set_object_sequence_motion(1, "後ろ爆発", 6)
		event.queue_object_sequence_next_motion(1, "後ろ爆発L", 4)
		event.set_object_sequence_motion(2, "とびあがる", 2)
		event.queue_object_sequence_next_motion(2, "とびあがるループ", 4)
		at = 5
		wait_frames(60)
		event.attach_character_to_frame(38, "hi", 43)
		event.set_character_active(1, 43)
		event.set_character_active(0, 41)
		event.set_character_motion(43, "走り（燃える）", 4, -1, 1)
		event.set_object_sequence_position(4, 913.78, 1615.71, -1455.71)
		event.set_object_sequence_position(6, 913.78, 1615.71, -1455.71)
		event.set_object_sequence_rotation(6, 0.0, -0.16, 0.0)
		event.set_object_sequence_position(5, 0.0, 0.0, 1380.0)
		event.set_character_active(1, global2)
		event.set_object_sequence_rotation(1, 0.0, 3.13, 0.0)
		event.set_object_sequence_motion(2, "走り（燃える）", 4)
		event.set_event_projection(400.0)
		event.set_camera_sequence_position(0.0, 38.21, 1638.99)
		event.set_camera_sequence_look_at(0.0, 194.92, 737.84)
		var8 = 2
		event.clear_object_sequence_path(var8)
		event.set_object_sequence_path_frames(var8, 180)
		event.add_object_sequence_path_point(var8, 0.0, 0.0, 1350.0)
		event.add_object_sequence_path_point(var8, 100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(var8, 0.0, 0.0, 1150.0)
		event.add_object_sequence_path_point(var8, -100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(var8, 0.0, 0.0, 1350.0)
		event.add_object_sequence_path_point(var8, 100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(var8, 0.0, 0.0, 1150.0)
		event.add_object_sequence_path_point(var8, -100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(var8, 0.0, 0.0, 1350.0)
		event.start_object_sequence_path(var8)
		event.set_character_active(1, 40)
		event.set_object_sequence_motion(4, "入り", 6)
		event.queue_object_sequence_next_motion(4, "溜めループ", 4)
		event.play_sound_effect(var6, 3)
		at = 6
		helper_1584c528(6160080, -1)
		at = 7
		helper_1584c528(6160090, -1)
		at = 8
		wait_objects(2)
		event.set_object_sequence_motion(0, "走り")
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(2, 0.0, 0.01, 0.0, 20)
		event.rotate_object_sequence(1, 0.0, 0.01, 0.0, 20)
		event.rotate_object_sequence(0, 0.0, -0.01, 0.0, 20)
		at = 9
		wait_objects(2)
		event.set_character_active(1, 42)
		event.play_sound_effect(var6, 4)
		event.create_effect("Ｅ６１６月花ビームＢ")
		event.set_effect_first_vector(913.78, 1615.71, -1455.71)
		event.set_effect_second_vector(0.0, -0.16, 0.0)
		event.set_object_sequence_motion(4, "発射", 6)
		event.set_object_sequence_motion(6, "弾道", 6)
		event.move_object_sequence(0, -32.0, 0.0, 1818.0, 60)
		event.move_object_sequence(1, 32.0, 0.0, 1818.0, 60)
		event.move_object_sequence(2, 0.0, 0.0, 1818.0, 60)
		at = 10
		wait_frames(30)
		event.set_character_active(1, 41)
		event.set_character_motion(41, "ヒット", 6, -1, 1)
		event.play_sound_effect(var6, 5)
		at = 11
		wait_frames(90)
		event.set_character_active(0, 40)
		event.set_event_projection(projection)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_position(0, -32.0, 0.0, 2418.0)
		event.play_sound_effect(var6, 10)
		event.set_camera_sequence_position(-4.22, 16.51, 2448.91)
		event.set_camera_sequence_look_at(-30.91, 22.39, 2407.0)
		event.set_object_sequence_motion(0, "左後ろ見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "左後ろ見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 12
		helper_4116e6bb(6160100)
		event.reset_mouth_texture_animations()
		event.stop_music(0)
		at = 13
		vm.wait(13)
		at = 14
		vm.wait(14)
		at = 15
		vm.wait(15)
		at = 16
		vm.wait(16)
		event.load_music(190)
		event.attach_object_handle_to_character_frame(20, 39, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.play_music(0)
		event.set_character_active(1, 39)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.set_camera_sequence_position(329.6, 416.23, 860.98)
		event.set_camera_sequence_look_at(418.95, 436.16, 1072.8)
		at = 17
		wait_frames(60)
		event.move_camera_sequence_eased(117.44, 416.23, 937.94, 373.95, 436.16, 1038.44, 90, 0, 0.4)
		at = 18
		wait_camera()
		event.move_camera_sequence_eased(-325.06, 685.54, 1733.22, 87.51, 627.46, 1290.16, 150, 0, 0.4)
		at = 19
		wait_camera()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_character_active(0, 43)
		event.detach_character_from_frame(43)
		event.attach_character_to_frame(38, "hi", 44)
		event.set_character_active(1, 44)
		event.set_character_motion(44, "立ち（煙）", 4, -1, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "立ち（煙）", 4)
		event.set_object_sequence_motion(1, "走り", 4)
		event.set_camera_sequence_position(-154.51, 10.06, 1495.9)
		event.set_camera_sequence_look_at(1.55, 150.34, 2062.42)
		event.set_object_sequence_position(1, -81.32, 0.0, 1615.39)
		event.set_object_sequence_rotation(1, 0.0, -0.59, 0.0)
		event.set_object_sequence_position(0, -148.27, 0.0, 1617.78)
		event.set_object_sequence_rotation(0, 0.0, 0.13, 0.0)
		event.set_object_sequence_position(2, -101.78, 0.0, 1761.73)
		event.set_object_sequence_rotation(2, 0.0, 0.01, 0.0)
		event.move_object_sequence(1, -98.54, 0.0, 1658.48, 20)
		event.delay_object_sequence_rotation_track(1, 20)
		event.rotate_object_sequence(1, 0.0, -2.63, 0.0, 10)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.queue_object_sequence_next_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		at = 20
		helper_4116e6bb(6160110)
		event.set_object_sequence_motion(0, "左後ろ見る戻り", 6, -1.0, 1)
		event.fade_out_screen(30)
		at = 21
		wait_frames(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_8cd371d7(6160070)
		end
		if at <= 2 then
			wait_frames_skipping(30)
		end
		if at <= 3 then
			wait_frames_skipping(10)
		end
		if at <= 4 then
			wait_frames_skipping(60)
		end
		if at <= 5 then
			var8 = 2
			helper_52aadc70(6160080, -1)
		end
		if at <= 6 then
			helper_52aadc70(6160090, -1)
		end
		if at <= 7 then
			helper_238b5abc(2)
		end
		if at <= 8 then
			helper_238b5abc(2)
		end
		if at <= 9 then
			wait_frames_skipping(30)
		end
		if at <= 10 then
			wait_frames_skipping(90)
		end
		if at <= 11 then
			helper_8cd371d7(6160100)
		end
		if at <= 16 then
			wait_frames_skipping(60)
		end
		if at <= 17 then
			helper_344d6cd8()
		end
		if at <= 18 then
			helper_344d6cd8()
		end
		if at <= 19 then
			helper_8cd371d7(6160110)
		end
		if at <= 20 then
			wait_frames_skipping(35)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.set_wind(-1)
	event.stop_sound_effect(var6, 10)
	event.stop_port_sound_effects(4)
	event.stop_all_sound_effects()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.clear_effect_manager()
	at = 22
	vm.wait(22)
	helper_110ac()
	event.set_event_projection(projection)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_e8a8()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_message_file(0, 5, "event/e600/e616/e616_1.txt")
end

--- Helper function.
local function helper_21700000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_e540()
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
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_character(38)
	event.finish_event()
	vm.wait(1)
end

--- Helper function.
local function helper_f62c()
	local var6: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(616, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7200)
		var6 = event.load_sound_effect_file_2(7200) or var6
		helper_e8a8()
		event.enable_drama_skip()
		event.set_scene_status_flags(1, 0, 256, 1)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_camera_sequence_position(0.0, 20.12, 505.57)
		event.set_camera_sequence_look_at(0.0, 30.0, 1531.66)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 180)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 180)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 200)
		event.set_object_sequence_motion(2, "とまる", 4)
		event.set_object_sequence_position(1, 16.0, 0.0, 621.38)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(0, -16.0, 0.0, 621.38)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(2, 0.0, 0.0, 2232.39)
		event.set_object_sequence_rotation(2, 0.0, 3.13, 0.0)
		event.fade_in_screen(30)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 200)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 2232.39)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 527.58)
		event.start_object_sequence_path(2)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 180)
		event.add_object_sequence_path_point(0, -16.0, 0.0, 621.38)
		event.add_object_sequence_path_point(0, -16.0, 0.0, 730.69)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 180)
		event.add_object_sequence_path_point(1, 16.0, 0.0, 621.38)
		event.add_object_sequence_path_point(1, 16.0, 0.0, 730.69)
		event.start_object_sequence_path(1)
		at = 2
		helper_4116e6bb(6160010)
		at = 3
		wait_objects(2)
		event.set_object_sequence_rotation(1, 0.0, 3.13, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.13, 0.0)
		at = 4
		wait_frames(15)
		event.play_sound_effect(var6, 1)
		event.rotate_object_sequence(2, 0.0, 0.01, 0.0, 30)
		at = 5
		wait_objects(2)
		at = 6
		wait_frames(30)
		event.set_object_sequence_motion(2, "走り")
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 60)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 527.58)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 700.0)
		event.start_object_sequence_path(2)
		at = 7
		wait_objects(2)
		event.set_object_sequence_motion(0, "下見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "下見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "ぜいぜい", 4)
		event.set_object_sequence_rotation(1, 0.0, -2.55, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 2.89, 0.0)
		event.set_camera_sequence_position(-38.64, 38.38, 652.69)
		event.set_camera_sequence_look_at(-1.85, 14.77, 711.67)
		at = 8
		wait_frames(30)
		event.set_object_sequence_motion(0, "下見会話", 2)
		event.queue_object_sequence_next_motion(0, "下見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 9
		helper_4116e6bb(6160020)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "ぜいぜい（見上げ）in", 2)
		event.queue_object_sequence_next_motion(2, "ぜいぜい（見上げ）", 4)
		at = 10
		helper_4116e6bb(6160030)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目～おこり目")
		event.set_object_sequence_motion(1, "キョロキョロ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 11
		helper_4116e6bb(6160040)
		event.reset_mouth_texture_animations()
		at = 12
		wait_frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_camera_sequence_position(-28.76, 13.15, 706.38)
		event.set_camera_sequence_look_at(-17.78, 21.48, 726.14)
		event.set_object_sequence_motion(0, "上見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "上見るL")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 13
		helper_4116e6bb(6160050)
		event.reset_mouth_texture_animations()
		at = 14
		wait_frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(616.77, 208.31, 1155.4, 646.89, 231.29, 968.2)
		event.add_camera_sequence_path_point(-272.08, 208.31, 1012.37, -241.96, 231.29, 825.17)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		at = 15
		wait_frames(200)
		event.fade_out_screen(30)
		at = 16
		wait_frames(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_21700000()
			helper_8cd371d7(6160010)
		end
		if at <= 2 then
			helper_238b5abc(2)
		end
		if at <= 3 then
			wait_frames_skipping(15)
		end
		if at <= 4 then
			helper_238b5abc(2)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			helper_238b5abc(2)
		end
		if at <= 7 then
			wait_frames_skipping(30)
		end
		if at <= 8 then
			helper_8cd371d7(6160020)
		end
		if at <= 9 then
			helper_8cd371d7(6160030)
		end
		if at <= 10 then
			helper_8cd371d7(6160040)
		end
		if at <= 11 then
			wait_frames_skipping(15)
		end
		if at <= 12 then
			helper_8cd371d7(6160050)
		end
		if at <= 13 then
			wait_frames_skipping(30)
		end
		if at <= 14 then
			wait_frames_skipping(200)
		end
		if at <= 15 then
			wait_frames_skipping(35)
		end
		return true
	end)
	at = 17
	vm.entry(17)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.skip_next_music_load()
	event.stop_port_sound_effects(4)
	at = 18
	vm.wait(18)
	at = 19
	helper_e540()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	event_99()
	event.set_save_control_bits(1, 1)
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		event.stop_music(0)
		wait_frames(4)
		event.load_music(166)
		event.play_music(0)
		helper_9dafbc83(50.0, vm.f32(140.7), -800.0, 0.0)
	else
		helper_9dafbc83(0.0, vm.f32(140.7), -900.0, 0.0)
	end
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_12890

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	event.set_save_data_value(3, 1)
	helper_f57795f8()
	event.set_save_data_value(3, 0)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.set_save_control_bits(1, 0)
		event.set_save_flag(616, 1)
		at = 2
		helper_f62c()
		event.jump_to_map_3(-1, "s32", 500)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_f62c()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s32", 500)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 530, which map data, a script or the engine runs by number.
function script.event_530()
	helper_12890()
	event.jump_to_map_3(-1, "s26", 550)
	vm.wait(2)
end

--- Event 532, which map data, a script or the engine runs by number.
function script.event_532()
	helper_4e15b328()
	event.jump_to_map_3(-1, "s71", 590)
	vm.wait(2)
end

--- Event 16160, which map data, a script or the engine runs by number.
function script.event_16160()
	helper_f62c()
	event.jump_to_map_3(-1, "s32", 500)
	vm.wait(2)
end

return script
