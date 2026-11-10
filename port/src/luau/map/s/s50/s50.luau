--!strict
-- map/s/s50/s50.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_786b79f1 = require("@lib/event/helper_786b79f1")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(7686)
	flag = event.get_save_flag(708) or flag
	if flag == 1 then
		event.set_function_point_enabled("", "e708", 0)
		event.attach_object_handle_to_map_part_2(0, "p06s50")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_2(0, "p04s50")
		event.set_object_handle_rotation(0, 0.0, -1.22, 0.0)
		event.attach_object_handle_to_map_part_2(1, "p05s50")
		event.set_object_handle_rotation(1, 0.0, 1.22, 0.0)
	end
	event.set_dungeon_pause_flags(8192, 1)
	event.set_character_change_unmasked(2, 0)
	event.set_character_change_unmasked(3, 0)
	event.set_save_control_bits(1, 1)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
end

--- Helper function.
local function helper_1067c(arg0: s32)
	local active_chr_no: s32 = 0
	local var2: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
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
			event.finish_event()
			return 0
		end
		at = 3
		var2 = helper_ed4dc120(arg0, -1)
		if var2 == 0 then
			event.fade_out_screen(30)
			at = 4
			helper_888ab2a3(30)
			event.finish_event()
			return 1
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at == 3 then
				var2 = received[1] :: number
			end
			if at <= 3 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_10af0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(708, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(113)
		event.play_music(0)
		event.load_map_sounds(7818)
		var0 = event.load_sound_effect_file_2(7818) or var0
		event.play_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e708/")
		event.load_message_file(0, 5, "e708.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e708_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e708_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e708_andrea.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e708_sun.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "kaisou_waku.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(7, 12)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e700/e708/e708_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e700/e708/e708_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_map_part_2(4, "p04s50")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_2(5, "p05s50")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_2(6, "p06s50")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_handle_position(0, 9.54, 0.8, 502.98)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -11.6, 0.8, 505.27)
		event.set_object_handle_rotation(1, 0.0, 3.02, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -17.67, -2.8, 1.78)
		event.set_object_handle_rotation(2, 0.0, 1.58, 0.0)
		event.set_object_handle_position(3, -21.32, -2.8, -26.09)
		event.set_object_handle_rotation(3, 0.0, -0.1, 0.0)
		event.set_object_handle_footstep_sound(3, 2)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(6, 0.0, -1.57, 0.0)
		event.set_object_handle_visible(6, 1)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "花いけ立ち", 4)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(3)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_active(11)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-89.69, 118.46, -108.66)
		event.set_camera_sequence_look_at(-1.67, 30.09, -7.9)
		event.set_character_active(12)
		event.set_scene_character_type(12, 4)
		event.keep_character_in_front_of_camera_sequence(12, 600.7, -1)
		event.play_sound_effect(var0, 1)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(2, "花いけから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_888ab2a3(30)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "こまり目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(29.44, 24.13, 17.48)
		event.set_camera_sequence_look_at(-22.52, 17.78, -11.7)
		helper_0382f327(7080010, -1)
		helper_888ab2a3(30)
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 60)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080020, 60)
		helper_888ab2a3(60)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目あき～目とじ")
		event.set_object_sequence_motion(3, "うつむく", 6)
		event.queue_object_sequence_next_motion(3, "うつむくＬ", 4)
		helper_0382f327(7080030, -1)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(3, "うつむき会話", 4)
		event.delay_object_sequence_motion_track(3, 120)
		event.queue_object_sequence_next_motion(3, "うつむくＬ", 4)
		helper_0382f327(7080035, -1)
		helper_888ab2a3(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(2, 20)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 60)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080040, -1)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(3, "うつむく戻り", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目とじ～目あき")
		helper_0382f327(7080050, 60)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-48.47, 12.55, -42.34)
		event.set_camera_sequence_look_at(-10.84, 19.04, -6.38)
		event.set_object_sequence_motion(2, "振り向く", 6)
		event.queue_object_sequence_next_motion(2, "振り向くＬ", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 60)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080060, -1)
		helper_888ab2a3(30)
		wait_objects(2)
		event.set_camera_sequence_position(-23.78, 29.48, -7.12)
		event.set_camera_sequence_look_at(-20.7, 6.84, -39.22)
		helper_888ab2a3(45)
		event.set_object_sequence_motion(3, "会話", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "通常目パチ")
		helper_0382f327(7080070, -1)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-48.47, 12.55, -42.34)
		event.set_camera_sequence_look_at(-10.84, 19.04, -6.38)
		event.set_object_sequence_motion(3, "正面向き立ち")
		event.play_sound_effect(var0, 2)
		event.set_object_sequence_motion(2, "立ちからしゃがむ", 6)
		event.queue_object_sequence_next_motion(2, "しゃがむ会話", 6)
		helper_888ab2a3(20)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 180)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080080, -1)
		helper_888ab2a3(30)
		wait_objects(2)
		event.set_object_sequence_motion(2, "しゃがみから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.play_sound_effect(var0, 3)
		event.set_camera_sequence_position(-20.65, 17.48, -24.48)
		event.set_camera_sequence_look_at(-16.7, 25.56, 1.9)
		event.set_object_sequence_motion(3, "立ち", 4)
		wait_objects(2)
		helper_888ab2a3(20)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 150)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080090, -1)
		event.set_object_sequence_motion(2, "ちょっと上向く", 6)
		event.queue_object_sequence_next_motion(2, "ちょっと上向くＬ", 4)
		helper_888ab2a3(20)
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 210)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080100, -1)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-23.78, 29.48, -7.12)
		event.set_camera_sequence_look_at(-20.7, 6.84, -39.22)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目とじ～目あき")
		event.set_mouth_texture_animations(2, "わらい口パク")
		helper_888ab2a3(20)
		helper_0382f327(7080110, 60)
		event.set_camera_sequence_position(-20.65, 17.48, -24.48)
		event.set_camera_sequence_look_at(-16.7, 25.56, 1.9)
		event.set_object_sequence_motion(2, "左見る", 6)
		event.queue_object_sequence_next_motion(2, "左見るＬ", 4)
		helper_888ab2a3(20)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 90)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080120, -1)
		helper_888ab2a3(30)
		helper_0382f327(7080130, 60)
		event.set_object_sequence_motion(2, "左見るから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 120)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080140, -1)
		helper_888ab2a3(20)
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 90)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080150, -1)
		wait_objects(2)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(2, "身体ごと向く", 6)
		event.queue_object_sequence_next_motion(2, "身体ごと向くＬ", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 90)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080160, -1)
		helper_888ab2a3(20)
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 120)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		helper_0382f327(7080165, -1)
		wait_objects(2)
		helper_888ab2a3(20)
		event.set_camera_sequence_position(-23.78, 29.48, -7.12)
		event.set_camera_sequence_look_at(-20.7, 6.84, -39.22)
		helper_888ab2a3(20)
		helper_0382f327(7080170, 60)
		helper_888ab2a3(30)
		event.fade_out_music(30)
		event.play_sound_effect(var0, 1)
		event.fade_out_screen(30, 255, 255, 255)
		helper_888ab2a3(15)
		event.set_character_active(0, 12)
		event.set_object_sequence_position(1, -8.49, -1.96, 108.26)
		event.set_object_sequence_position(0, 10.48, -1.96, 111.88)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		helper_888ab2a3(15)
		event.stop_sound_effect(var0, 1)
		event.load_map_sounds(7819)
		var2 = event.load_sound_effect_file_2(7819) or var2
		event.fade_in_screen(30)
		event.set_object_sequence_position(2, -8.49, -1000.0, 108.26)
		event.set_object_sequence_position(3, 10.48, -1000.0, 111.88)
		event.set_camera_sequence_position(-14.02, 13.72, 63.77)
		event.set_camera_sequence_look_at(7.42, 21.78, 134.93)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		helper_888ab2a3(60)
		event.set_camera_sequence_position(0.05, 16.14, 284.86)
		event.set_camera_sequence_look_at(1.57, 67.05, -251.65)
		event.play_sound_effect(var2, 4)
		event.rotate_object_sequence_eased(4, 0.0, -1.22, 0.0, 60, 1, 0.7)
		event.rotate_object_sequence_eased(5, 0.0, 1.22, 0.0, 60, 1, 0.7)
		helper_888ab2a3(90)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(57)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, -1.22, 0.0)
	event.set_object_handle_rotation(5, 0.0, 1.22, 0.0)
	event.set_character_active(0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.load_message_file(0, -1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 0, which map data, a script or the engine runs by number.
function script.event_0()
	local active_chr_no: s32 = 0
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.open_message_window_2(
			0,
			"―ユリスの発明ネタ調査―\nユリスは本を読んで\n　●武器\n　●月の柱\n　●鹿のツノ\nの３つによって何かが発明できると直感した！"
		)
	else
		event.open_message_window_2(
			0,
			"―モニカのモンスター調査―\nモニカはそこに記されている内容から\n『ダイヤ』は\n『ダイヤモンド』に目がないことを知った。"
		)
	end
	helper_75684dd8(0, -1, 8, 0, 0)
end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event_99()
	helper_9dafbc83(0.0, 0.0, 200.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 200.0)
	event.set_camera_position(0.0, 40.0, 320.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.initialize_event()
	event.clear_camera_sequence()
	event.shake_camera_sequence(0.0, 1.0, 0.0, 16)
	wait_camera()
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_1067c(2) ~= 0 then
		event.set_character_visible(1, 1)
		event.set_character_visible(2, 1)
		event.set_dungeon_pause_flags(8192, 0)
		event.reset_action_character_motion(0)
		event.set_character_change_unmasked(2, 1)
		event.set_character_change_unmasked(3, 1)
		event.set_save_control_bits(1, 0)
		event.load_event_script("d06/d06.stb", 1000)
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local flag: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	flag = event.get_save_flag(708) or flag
	if flag == 1 then
		if helper_1067c(1) ~= 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			var2 = event.get_dungeon_floor() or var2
			argc = event.get_dungeon_next_floor(var2, 0) or argc
			event.set_dungeon_floor(argc)
			event.set_dungeon_floor_info(stage_id, var2, 5, 2)
			event.set_dungeon_floor_info(stage_id, argc, 5, 1)
			event.set_character_visible(1, 1)
			event.set_character_visible(2, 1)
			event.set_dungeon_pause_flags(8192, 0)
			event.reset_action_character_motion(0)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(3, 1)
			event.set_save_control_bits(1, 0)
			event.load_event_script("d06/d06.stb", 1000)
		end
	else
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(
			0,
			"　　　扉はかたく閉ざされている。\nこの部屋には何か秘密が在るのだろうか？"
		)
		helper_75684dd8(0, -1, 5, 0, 0)
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local item: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 22, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 23, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		var1 = event.get_triggered_event_data_2(6) or var1
		if var1 == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "不思議な花びんがある。\n（(#)ボタンでメニューを開く）")
			at = 3
			var3 = helper_c292fa16(0, -1, 5, 256, 208, var3)
			if var3 == 1 then
				var1 = 2
			end
		end
		if var1 == 2 then
			event.open_use_item_menu(374)
			at = 4
			vm.wait(4)
			item = vmhost.used_item() or item
			if item > 0 then
				if item == 374 then
					event.show_dungeon_status_bar(0, 1.0)
					event.attach_object_handle_to_map_part_2(0, "p06s50")
					event.set_object_handle_visible(0, 1)
					event.set_function_point_enabled("", "e708", 0)
					event.set_function_point_enabled("", "next_floor", 1)
					event.fade_out_screen(3, 255, 255, 255)
					at = 5
					helper_888ab2a3(3)
					event.fade_in_screen(8)
					at = 6
					helper_888ab2a3(10)
					event.fade_out_screen(3, 255, 255, 255)
					at = 7
					helper_888ab2a3(3)
					event.fade_in_screen(8)
					at = 8
					helper_888ab2a3(20)
					event.fade_out_screen(30, 255, 255, 255)
					at = 9
					helper_888ab2a3(30)
					at = 10
					helper_10af0()
					helper_9dafbc83(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
					event.set_camera_look_at(30.0, 27.2, -80.0)
					event.set_camera_position(30.0, 37.2, 40.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				else
					at = 11
					helper_5fb66cb1()
				end
			end
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 23, 5, 256, 208)
			end
			return 0
		end
		if at <= 10 then
			if at == 3 then
				var3 = received[2] :: number
			end
			if at <= 3 then
				local _ = var1 == 1
				var1 = 2
			end
			if at <= 4 then
				helper_038a2e4d(3)
			end
			if at <= 5 then
				helper_038a2e4d(10)
			end
			if at <= 6 then
				helper_038a2e4d(3)
			end
			if at <= 7 then
				helper_038a2e4d(20)
			end
			if at <= 8 then
				helper_038a2e4d(30)
			end
			if at <= 9 then
				at = 10
				helper_10af0()
				return vm.continue_with(function()
					helper_9dafbc83(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
					event.set_camera_look_at(30.0, 27.2, -80.0)
					event.set_camera_position(30.0, 37.2, 40.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				end)
			end
			helper_43f02c95(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
			return 0
		end
		if at <= 11 then
			return 0
		end
		return nil
	end)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_786b79f1(0)
end

--- Event 17080, which map data, a script or the engine runs by number.
function script.event_17080()
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	helper_10af0()
end

return script
