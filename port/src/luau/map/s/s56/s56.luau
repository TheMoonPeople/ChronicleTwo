--!strict
-- map/s/s56/s56.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_35a95052 = require("@lib/event/helper_35a95052")
local helper_38df53e4 = require("@lib/event/helper_38df53e4")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_786b79f1 = require("@lib/event/helper_786b79f1")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_df618068 = require("@lib/event/helper_df618068")
local helper_e4e2e66b = require("@lib/event/helper_e4e2e66b")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	var0 = event.get_active_music_number() or var0
	if var0 ~= 17 then
		event.stop_music(0)
		helper_888ab2a3(6)
		event.load_music(17)
	end
	event.play_music(0)
	event.load_map_sounds(3682)
	flag = event.get_save_flag(348) or flag
	if flag == 1 then
		event.set_function_point_enabled("", "e348", 0)
		event.attach_object_handle_to_map_part_2(0, "p07_d03b01")
		event.set_object_handle_visible(0, 0)
	end
	flag_2 = event.get_save_flag(352) or flag_2
	if flag_2 == 1 then
		event.set_function_point_enabled("", "event", 0)
	end
end

--- Helper function.
local function helper_160d0()
	local argc: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.apply_message_window_preset(0, 0)
		event.set_message_bubble_tail(0, 0)
		argc = event.get_item_count(371) or argc
		if argc <= 0 then
			event.open_message_window_2(
				0,
				"ここから過去に戻れば、クレストを助けられるはず！\nでも、過去に戻るにはどうしたら良いんだろう・・・"
			)
			at = 1
			helper_75684dd8(0, -1, 5, 256, 208)
			event.apply_message_window_preset(0, 4)
			event.set_message_window_mode(0, 4)
			event.open_message_window_2(
				0,
				"[(!)]過去に戻る方法なんてあるんでしょうか？\n   何か特別な道具でもあれば別ですけど・・・"
			)
			at = 2
			helper_75684dd8(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"[(!)]そう言えば、ステラ寺院には世にも珍しい品物を扱う\n   道具屋があるそうです。そこでなら、もしかしたら、\n   何か手に入るかも知れませんね。"
			)
			at = 3
			helper_75684dd8(0, -1, 8, 0, 0)
		else
			event.open_message_window_2(
				0,
				"ここから過去に戻れば、クレストを助けられるはず！\n（(#)ボタンでメニューを開く）"
			)
			at = 4
			var1 = helper_c292fa16(0, -1, 5, 256, 208, var1)
			if var1 == 1 then
				event.set_message_bubble_tail(0, 1)
				return 1
			end
		end
		event.apply_message_window_preset(0, 0)
		event.set_message_bubble_tail(0, 1)
		return 0
	end, function(received: { any })
		if at <= 4 then
			if at == 4 then
				var1 = received[2] :: number
			end
			if at <= 1 then
				helper_ee1c51d0(0, -1, 8, 0, 0)
			end
			if at <= 2 then
				helper_ee1c51d0(0, -1, 8, 0, 0)
			end
			if at <= 3 then
				var1 = helper_35a95052(0, -1, 5, 256, 208, var1)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_12f20()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	print("GET_ACTIVE_CHR_NO-------", active_chr_no, "\n")
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 1, "info", global1, 17)
		event.load_equipment_model(5, 1, 0, "info", global1, 18)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 1, "info", global0, 17)
		event.load_equipment_model(5, 0, 0, "info", global0, 18)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e352/e352_lin.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(2, 9)
	event.set_object_sequence_object(2, 4)
	event.load_character(5, "event/e300/e352/e352_tokei_h.gltf", "info", 19)
	event.set_character_active(0, 19)
	event.load_character(5, "event/e300/e352/e352_monica_tokei.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.load_character(5, "event/e300/e352/e352_sdokei.gltf", "info", 20)
	event.set_character_active(0, 20)
	event.load_character(5, "event/e300/e352/e352_mabu.gltf", "info", 21)
	event.set_character_active(0, 21)
	event.load_character(5, "event/e300/e352/e352_hikari.gltf", "info", 22)
	event.set_character_active(0, 22)
	event.set_scene_character_type(22, 4)
	event.load_message_file(0, 5, "event/e300/e352/e352.txt")
end

--- Helper function.
local function helper_22c00000()
	local var0: s32 = 0
	print("GET_ACTIVE_CHR_NO-------", var0, "\n")
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_129cc()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(9)
	event.delete_character(19)
	event.delete_character(13)
	event.delete_character(20)
	event.delete_character(21)
	event.delete_character(22)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
end

--- Helper function.
local function helper_1439c()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(352, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		at = 2
		vm.wait(2)
		at = 3
		vm.wait(3)
		at = 4
		vm.wait(4)
		at = 5
		vm.wait(5)
		event.load_map_sounds(3831)
		var4 = event.load_sound_effect_file_2(3831) or var4
		helper_12f20()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "無表情")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 1, "半口")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "上見立ち", 4)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(496.47, 169.37, -809.35)
		event.set_camera_sequence_look_at(508.77, 169.14, -850.82)
		event.set_object_sequence_position(2, 543.2, 144.04, -840.61)
		event.set_object_sequence_rotation(2, 0.0, -1.99, 0.0)
		event.set_object_sequence_position(0, 538.49, 145.86, -872.44)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 567.83, 142.65, -858.12)
		event.set_object_sequence_rotation(1, 0.0, -0.92, 0.0)
		event.move_camera_sequence_eased(530.44, 169.37, -799.27, 542.75, 169.14, -840.74, 120, 2, 1.0)
		event.fade_in_screen(30)
		at = 6
		wait_camera()
		at = 7
		helper_888ab2a3(30)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 8
		helper_4116e6bb(3520010)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "うなづく", 6)
		event.queue_object_sequence_next_motion(2, "上見立ち", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 9
		helper_4116e6bb(3520020)
		event.reset_mouth_texture_animations()
		at = 10
		wait_objects(2)
		event.attach_character_to_frame(global1, "sword_hand", 13)
		event.set_character_active(1, 13)
		event.set_object_sequence_position(1, 519.39, 147.4, -861.34)
		event.set_object_sequence_rotation(1, 0.0, -0.2, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -0.6, 0.0)
		event.set_object_sequence_motion(2, "下見立ち", 4)
		event.play_sound_effect(var4, 0)
		event.set_object_sequence_motion(1, "置く～下見", 6)
		event.queue_object_sequence_next_motion(1, "下見", 4)
		event.set_camera_sequence_position(485.69, 161.28, -803.81)
		event.set_camera_sequence_look_at(535.39, 163.79, -859.0)
		at = 11
		helper_888ab2a3(27)
		event.play_sound_effect(var4, 1)
		event.detach_character_from_frame(13)
		event.set_character_active(0, 13)
		event.set_character_active(1, 19)
		event.set_character_position(19, 516.77, 149.74, -850.63)
		at = 12
		helper_888ab2a3(60)
		event.set_camera_sequence_position(499.2, 155.53, -839.73)
		event.set_camera_sequence_look_at(516.77, 149.74, -850.63)
		at = 13
		helper_888ab2a3(60)
		event.set_character_active(1, 20)
		event.set_character_position(20, 516.77, 149.74, -850.63)
		event.set_character_motion(20, "砂時計光る", 2, -1, 1)
		event.play_sound_effect(var4, 2)
		at = 14
		helper_888ab2a3(60)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "目とじ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "目とじ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "無表情")
		event.set_object_sequence_texture_animation(2, 1, "目とじ")
		event.set_object_sequence_texture_animation(2, 1, "半口")
		event.set_object_sequence_motion(2, "まぶしい", 6)
		event.set_object_sequence_motion(0, "まぶしい", 6)
		event.set_object_sequence_motion(1, "まぶしい", 6)
		event.queue_object_sequence_next_motion(2, "まぶしいＬ", 4)
		event.queue_object_sequence_next_motion(0, "まぶしいＬ", 4)
		event.queue_object_sequence_next_motion(1, "まぶしいＬ", 4)
		event.set_object_sequence_position(0, 539.17, 145.1, -856.52)
		event.set_object_sequence_rotation(0, 0.0, -1.99, 0.0)
		event.set_object_sequence_position(1, 538.92, 143.03, -823.0)
		event.set_object_sequence_rotation(1, 0.0, -2.24, 0.0)
		event.set_camera_sequence_position(494.78, 152.75, -815.47)
		event.set_camera_sequence_look_at(543.94, 165.9, -843.48)
		at = 15
		helper_888ab2a3(30)
		event.set_character_active(1, 21)
		event.set_character_position(21, 547.24, 149.74, -859.21)
		event.set_character_motion(21, "まぶしい", 2, -1, 1)
		at = 16
		helper_888ab2a3(60)
		event.set_character_active(0, 21)
		event.set_camera_sequence_position(1717.19, 225.79, 121.59)
		event.set_camera_sequence_look_at(543.94, 165.9, -843.48)
		event.play_sound_effect(var4, 3)
		event.set_character_active(1, 22)
		event.set_character_position(22, 516.77, 149.74, -850.63)
		event.set_character_motion(22, "光る光る", 2, -1, 1)
		at = 17
		helper_888ab2a3(75)
		event.init_screen_raster_effect(0.0, 0.0, 0.15707964)
		event.start_screen_raster_effect(60.0, 0.3926991, -1.0, 60)
		at = 18
		helper_888ab2a3(75)
	end, function(received: { any }): boolean
		if at <= 5 then
			helper_22c00000()
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_038a2e4d(30)
		end
		if at <= 7 then
			helper_8cd371d7(3520010)
		end
		if at <= 8 then
			helper_8cd371d7(3520020)
		end
		if at <= 9 then
			helper_238b5abc(2)
		end
		if at <= 10 then
			helper_038a2e4d(27)
		end
		if at <= 11 then
			helper_038a2e4d(60)
		end
		if at <= 12 then
			helper_038a2e4d(60)
		end
		if at <= 13 then
			helper_038a2e4d(60)
		end
		if at <= 14 then
			helper_038a2e4d(30)
		end
		if at <= 15 then
			helper_038a2e4d(60)
		end
		if at <= 16 then
			helper_038a2e4d(75)
		end
		if at <= 17 then
			helper_038a2e4d(75)
		end
		return true
	end)
	at = 19
	vm.entry(19)
	event.cancel_drama_scene_skip()
	event.fade_out_camera_sequence(30, 255.0, 255.0, 255.0)
	at = 20
	helper_888ab2a3(30)
	event.stop_screen_raster_effect(0.0, 0.0, 0.0, 0)
	event.stop_port_sound_effects(4)
	event.skip_next_music_load()
	at = 21
	vm.wait(21)
	at = 22
	helper_129cc()
end

--- Helper function.
local function helper_102d4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(348, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		event.stop_music(0)
		var0 = event.load_sound_effect_file_2(3829) or var0
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 or active_chr_no ~= 1 then
			event.switch_dungeon_main_character(0)
			event.set_playable_character(0)
			active_chr_no = 0
		end
		event.change_directory("event/e300/e348/")
		event.load_message_file(0, 5, "e348.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e348_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e348_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e348_lin.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 9)
			event.load_equipment_model(5, 0, 4, "info", 9)
			event.load_equipment_model(5, 0, 3, "info", 9)
			event.load_equipment_model(5, 0, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e300/e348/e348_mints.gltf", "info", 10)
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
			event.load_character_motion_pack(5, "event/e300/e348/e348_monica.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(9)
		event.set_character_active(10)
		event.attach_object_handle_to_character(3, 1)
		event.set_object_handle_visible(3, 0)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_position(0, 1521.47, -107.28, 771.74)
		event.set_object_handle_rotation(0, 0.0, -2.88, 0.0)
		event.set_object_handle_motion(0, "歩き", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_footstep_sound(0, 2)
		event.step_object_handle_motion(0)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_position(1, 1505.66, -106.53, 783.49)
		event.set_object_handle_rotation(1, 0.0, 3.04, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_handle_footstep_sound(1, 2)
		event.step_object_handle_motion(1)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_position(2, 1506.3, -108.37, 803.96)
		event.set_object_handle_rotation(2, 0.0, -3.12, 0.0)
		event.set_object_handle_motion(2, "歩き", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "無表情")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_texture_animation(2, 1, "半口")
		event.move_object_sequence(0, 1521.47, -107.28, 731.74, 80)
		event.move_object_sequence(1, 1505.66, -106.53, 743.49, 80)
		event.move_object_sequence(2, 1506.3, -108.37, 763.96, 80)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1478.0, -94.44, 748.45)
		event.set_camera_sequence_look_at(1526.09, -83.38, 795.48)
		event.move_camera_sequence(1478.0, -94.44, 708.45, 1526.09, -83.38, 755.48, 80)
		event.fade_in_screen(30)
		at = 2
		helper_888ab2a3(80)
		event.set_camera_sequence_position(1635.22, -45.35, 898.95)
		event.set_camera_sequence_look_at(1509.85, -91.47, 744.47)
		event.move_camera_sequence_eased(1635.22, -45.35, 898.95, 1509.85, 36.75, 744.47, 60, 0, 1.0)
		event.set_object_sequence_position(0, 1522.58, -104.86, 733.22)
		event.set_object_sequence_rotation(0, 0.0, -2.52, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 1508.09, -104.9, 755.07)
		event.set_object_sequence_rotation(1, 0.0, -2.76, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(2, 1536.72, -109.15, 777.79)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.move_object_sequence(0, 1491.96, -99.81, 672.57, 90)
		event.move_object_sequence(1, 1473.85, -100.1, 691.32, 90)
		event.move_object_sequence(2, 1493.11, -100.84, 700.12, 90)
		at = 3
		helper_0382f327(3480010, 120)
		at = 4
		wait_camera()
		at = 5
		helper_888ab2a3(10)
		event.set_camera_sequence_position(1459.8, -32.33, 632.79)
		event.set_camera_sequence_look_at(1494.99, -96.61, 704.05)
		event.move_camera_sequence_eased(1475.8, -54.94, 665.2, 1494.99, -84.52, 704.05, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "上見立ち", 4)
		at = 6
		wait_camera()
		at = 7
		helper_888ab2a3(10)
		event.set_camera_sequence_position(1518.17, -76.49, 671.12)
		event.set_camera_sequence_look_at(1493.05, -78.0, 693.7)
		event.set_object_sequence_position(2, 1501.04, -100.84, 688.87)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.play_sound_effect(var0, 6)
		event.set_object_sequence_motion(1, "右向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		at = 8
		helper_4116e6bb(3480020)
		event.fade_out_screen(30)
		at = 9
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = active_chr_no ~= 0
			local _ = active_chr_no ~= 1
			active_chr_no = 0
			helper_038a2e4d(80)
		end
		if at <= 2 then
			helper_53ffe901(3480010, 120)
		end
		if at <= 3 then
			helper_344d6cd8()
		end
		if at <= 4 then
			helper_038a2e4d(10)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_038a2e4d(10)
		end
		if at <= 7 then
			helper_8cd371d7(3480020)
		end
		if at <= 8 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 10
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.attach_object_handle_to_character(0, 1)
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.play_music(0)
	event.set_character_position(0, 1390.73, -76.07, 523.09)
	event.set_character_rotation(0, 0.0, -2.28, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event_99()
	helper_e4e2e66b()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	helper_c956b4a2(32)
	event.finish_event()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: s32 = 0
	local item: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		var0 = event.get_triggered_event_data_2(6) or var0
		if var0 == 1 then
			at = 1
			if helper_160d0() ~= 0 then
				var0 = 2
			end
		end
		if var0 == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			at = 2
			helper_888ab2a3(6)
			event.open_use_item_menu(371)
			at = 3
			vm.wait(3)
			item = vmhost.used_item() or item
			if item == 371 then
				event.set_function_point_enabled("", "event", 0)
				event.fade_out_screen(20)
				at = 4
				helper_888ab2a3(20)
				event.switch_dungeon_main_character(0)
				at = 5
				helper_1439c()
				event.load_dungeon_map("d03b02")
				event.load_event_script("d03b02/d03b02.stb", 502)
				return
			elseif item > 0 then
				at = 6
				helper_df618068()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
		end
		at = 7
		helper_888ab2a3(6)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 5 then
			if at == 1 then
				local _ = received[1] :: number
			end
			if at <= 1 then
				local _ = var0 == 1
				var0 = 2
				helper_038a2e4d(6)
			end
			if at <= 3 then
				helper_038a2e4d(20)
			end
			if at <= 4 then
				at = 5
				helper_1439c()
				return vm.continue_with(function()
					event.load_dungeon_map("d03b02")
					event.load_event_script("d03b02/d03b02.stb", 502)
					return
				end)
			end
			return 0
		end
		if at <= 7 then
			if at <= 6 then
				helper_038a2e4d(6)
			end
			return 0
		end
		return nil
	end)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_function_point_enabled("", "e348", 0)
		event.attach_object_handle_to_map_part_2(0, "p07_d03b01")
		event.set_object_handle_visible(0, 0)
		helper_52115bbf()
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_102d4()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_102d4()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	if helper_38df53e4() ~= 0 then
		event.load_event_script("d03/d03.stb", 1000)
	end
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_786b79f1(0)
end

--- Event 13480, which map data, a script or the engine runs by number.
script.event_13480 = helper_102d4

--- Event 13520, which map data, a script or the engine runs by number.
function script.event_13520()
	event.switch_dungeon_main_character(0)
	helper_1439c()
	event.load_dungeon_map("d03b02")
	event.load_event_script("d03b02/d03b02.stb", 502)
end

return script
