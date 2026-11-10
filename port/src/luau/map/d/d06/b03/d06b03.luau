--!strict
-- map/d/d06/b03/d06b03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2609f66b = require("@lib/event/helper_2609f66b")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_61e5dba6 = require("@lib/event/helper_61e5dba6")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a9eaf20e = require("@lib/event/helper_a9eaf20e")
local helper_f9968159 = require("@lib/event/helper_f9968159")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_177d8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.set_save_flag(728, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7603)
		var0 = event.load_sound_effect_file_2(7603) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e728/")
		event.load_message_file(0, 5, "e728.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e728_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e728_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e728_dark.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		block = event.load_event_image_4(5, "e728telop06.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e728telop06", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e700/e728/e728_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e700/e728/e728_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_object_handle_position(1, -1.42, 0.0, -83.64)
		event.set_object_handle_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(0, -23.19, 0.0, -81.74)
		event.set_object_handle_rotation(0, 0.0, 0.26, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, 10.04, 99.12, 177.76)
		event.set_object_handle_rotation(2, 0.0, -3.07, 0.0)
		event.set_object_handle_footstep_sound(2, 1)
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-79.96, 12.55, -243.16)
		event.set_camera_sequence_look_at(-22.0, 50.18, -66.57)
		event.fade_in_screen(30)
		helper_888ab2a3(60)
		event.fade_out_music(30)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(12.3, 90.7, -58.0)
		event.set_camera_sequence_look_at(8.16, 163.3, 185.9)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(2, "乱舞", 6)
		event.queue_object_sequence_next_motion(2, "乱舞L", 4)
		wait_objects(2)
		helper_888ab2a3(30)
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(39)
	event.play_music(0)
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
	event.delete_event_image(0)
	event.load_message_file(0, -1)
end

--- Helper function.
local function helper_1efcc()
	local time: f32 = 0
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(39)
	event.play_music(0)
	time = event.get_scene_time_of_day() or time
	event.set_save_counter(10, time)
	event.set_time_of_day(24.0)
	event.set_time_of_day_advancing(0)
	event.load_dungeon_monster(621, 1)
	event.load_dungeon_monster(622, 0)
	event.place_dungeon_monster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
	event.control_stopwatch(3, 350, 370, 1)
	event.control_stopwatch(2, 18000)
	event.control_stopwatch_1(0)
	vm.wait(3)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Helper function.
local function helper_197dc()
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
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 1, "info", global1, 17)
		event.load_equipment_model(5, 1, 0, "info", global1, 18)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", global1)
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
		event.load_equipment_model(5, 0, 1, "info", global0, 17)
		event.load_equipment_model(5, 0, 0, "info", global0, 18)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_map_part_2(6, "p06_d06b03-0")
	event.set_object_handle_visible(6, 0)
	event.set_character_active(1, 17)
	event.set_character_active(1, 18)
	event.load_message_file(0, 5, "event/e700/e732/e732.txt")
end

--- Helper function.
local function helper_22300000()
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
local function helper_19330()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.set_object_handle_visible(6, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
end

--- Helper function.
local function helper_1a7e8()
	local projection: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(732, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		helper_888ab2a3(4)
		event.load_music(53)
		event.play_music(0)
		event.load_map_sounds(7841)
		helper_197dc()
		projection = event.get_event_projection() or projection
		event.enable_drama_skip()
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(281.98, 20.1, 298.37)
		event.set_camera_sequence_look_at(1436.08, 1324.63, 1446.43)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_position(0, 457.63, 0.0, 460.14)
		event.set_object_sequence_rotation(0, 0.0, 0.72, 0.0)
		event.set_object_sequence_position(1, 443.3, 0.0, 472.44)
		event.set_object_sequence_rotation(1, 0.0, 0.72, 0.0)
		event.fade_in_screen(30)
		at = 2
		helper_888ab2a3(15)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(281.98, 20.1, 298.37, 1436.08, 1324.63, 1446.43)
		event.add_camera_sequence_path_point(281.98, 20.1, 298.37, 1436.08, 215.39, 1446.43)
		event.start_camera_sequence_path()
		at = 3
		wait_camera()
		at = 4
		helper_888ab2a3(30)
		event.set_camera_sequence_position(520.35, 27.62, 447.72)
		event.set_camera_sequence_look_at(443.3, 23.28, 472.44)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 5
		helper_0382f327(7320210, -1)
		event.reset_mouth_texture_animations()
		at = 6
		helper_888ab2a3(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 7
		helper_0382f327(7320215, -1)
		event.reset_mouth_texture_animations()
		at = 8
		helper_888ab2a3(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 9
		helper_0382f327(7320220, -1)
		event.reset_mouth_texture_animations()
		at = 10
		helper_888ab2a3(30)
		event.set_camera_sequence_position(422.7, -0.4, 438.35)
		event.set_camera_sequence_look_at(1436.08, 1232.78, 1446.43)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 11
		helper_0382f327(7320230, -1)
		event.reset_mouth_texture_animations()
		at = 12
		helper_888ab2a3(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 13
		helper_0382f327(7320240, -1)
		event.reset_mouth_texture_animations()
		at = 14
		helper_888ab2a3(30)
		event.set_object_sequence_motion(0, "上→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 15
		helper_0382f327(7320250, -1)
		event.reset_mouth_texture_animations()
		at = 16
		wait_objects(0)
		at = 17
		helper_888ab2a3(30)
		event.set_event_projection(projection)
		event.set_camera_sequence_position(520.35, 27.62, 447.72)
		event.set_camera_sequence_look_at(443.3, 23.28, 472.44)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 18
		helper_0382f327(7320255, -1)
		event.reset_mouth_texture_animations()
		at = 19
		helper_888ab2a3(15)
		event.set_object_sequence_motion(1, "上から左", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "詩人ね", 6)
		event.queue_object_sequence_next_motion(1, "詩人ねL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 20
		helper_0382f327(7320260, -1)
		event.reset_mouth_texture_animations()
		at = 21
		wait_objects(0)
		at = 22
		wait_objects(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "前向き～下向き")
		event.set_object_sequence_motion(0, "そうかな", 6)
		event.queue_object_sequence_next_motion(0, "そうかなL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 23
		helper_0382f327(7320270, -1)
		event.reset_mouth_texture_animations()
		at = 24
		wait_objects(0)
		at = 25
		helper_888ab2a3(30)
		event.set_event_projection(projection)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_camera_sequence_position(281.98, 20.1, 298.37)
		event.set_camera_sequence_look_at(1436.08, 215.39, 1446.43)
		at = 26
		helper_0382f327(7320280, -1)
		at = 27
		helper_888ab2a3(30)
		at = 28
		helper_0382f327(7320285, -1)
		at = 29
		helper_888ab2a3(30)
		at = 30
		helper_0382f327(7320290, -1)
		at = 31
		helper_888ab2a3(30)
		at = 32
		helper_0382f327(7320295, -1)
		event.move_camera_sequence_eased(281.98, 20.1, 298.37, 1436.08, 1963.82, 1446.43, 300, 0, 1.0)
		at = 33
		helper_888ab2a3(30)
		at = 34
		helper_0382f327(7320300, -1)
		at = 35
		helper_888ab2a3(30)
		at = 36
		helper_0382f327(7320310, -1)
		at = 37
		wait_camera()
		at = 38
		helper_0382f327(7320320, -1)
		at = 39
		helper_888ab2a3(30)
		at = 40
		helper_0382f327(7320330, -1)
		at = 41
		helper_888ab2a3(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_camera_sequence_position(539.13, 94.76, 524.34)
		event.set_camera_sequence_look_at(457.63, 10.5, 460.14)
		event.move_camera_sequence_eased(484.6, 41.24, 479.15, 471.35, 30.37, 469.8, 300, 2, 1.0)
		event.start_crossfade(30)
		at = 42
		helper_0382f327(7320340, -1)
		at = 43
		helper_888ab2a3(30)
		at = 44
		helper_0382f327(7320350, -1)
		at = 45
		helper_888ab2a3(30)
		at = 46
		helper_0382f327(7320360, -1)
		at = 47
		wait_camera()
		at = 48
		helper_888ab2a3(30)
		event.set_object_sequence_motion(0, "帽子取る", 6)
		event.queue_object_sequence_next_motion(0, "帽子取るL", 4)
		at = 49
		helper_0382f327(7320370, -1)
		at = 50
		wait_objects(0)
		event.set_object_sequence_motion(0, "ぶるぶる", 6)
		event.queue_object_sequence_next_motion(0, "帽子取るL", 4)
		at = 51
		helper_0382f327(7320380, -1)
		at = 52
		wait_objects(0)
		event.set_event_projection(182.9)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(240)
		event.add_camera_sequence_path_point(422.7, 30.65, 438.35, 1436.08, 349.8, 1446.43)
		event.add_camera_sequence_path_point(353.73, 30.65, 369.74, 1436.08, 349.8, 1446.43)
		event.start_camera_sequence_path()
		at = 53
		helper_888ab2a3(180)
		event.fade_out_music(60)
		event.fade_out_screen(60)
		at = 54
		helper_888ab2a3(60)
		event.stop_music(0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22300000()
			helper_038a2e4d(15)
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_038a2e4d(30)
		end
		if at <= 4 then
			helper_53ffe901(7320210, -1)
		end
		if at <= 5 then
			helper_038a2e4d(30)
		end
		if at <= 6 then
			helper_53ffe901(7320215, -1)
		end
		if at <= 7 then
			helper_038a2e4d(30)
		end
		if at <= 8 then
			helper_53ffe901(7320220, -1)
		end
		if at <= 9 then
			helper_038a2e4d(30)
		end
		if at <= 10 then
			helper_53ffe901(7320230, -1)
		end
		if at <= 11 then
			helper_038a2e4d(30)
		end
		if at <= 12 then
			helper_53ffe901(7320240, -1)
		end
		if at <= 13 then
			helper_038a2e4d(30)
		end
		if at <= 14 then
			helper_53ffe901(7320250, -1)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_038a2e4d(30)
		end
		if at <= 17 then
			helper_53ffe901(7320255, -1)
		end
		if at <= 18 then
			helper_038a2e4d(15)
		end
		if at <= 19 then
			helper_53ffe901(7320260, -1)
		end
		if at <= 20 then
			helper_238b5abc(0)
		end
		if at <= 21 then
			helper_238b5abc(1)
		end
		if at <= 22 then
			helper_53ffe901(7320270, -1)
		end
		if at <= 23 then
			helper_238b5abc(0)
		end
		if at <= 24 then
			helper_038a2e4d(30)
		end
		if at <= 25 then
			helper_53ffe901(7320280, -1)
		end
		if at <= 26 then
			helper_038a2e4d(30)
		end
		if at <= 27 then
			helper_53ffe901(7320285, -1)
		end
		if at <= 28 then
			helper_038a2e4d(30)
		end
		if at <= 29 then
			helper_53ffe901(7320290, -1)
		end
		if at <= 30 then
			helper_038a2e4d(30)
		end
		if at <= 31 then
			helper_53ffe901(7320295, -1)
		end
		if at <= 32 then
			helper_038a2e4d(30)
		end
		if at <= 33 then
			helper_53ffe901(7320300, -1)
		end
		if at <= 34 then
			helper_038a2e4d(30)
		end
		if at <= 35 then
			helper_53ffe901(7320310, -1)
		end
		if at <= 36 then
			helper_344d6cd8()
		end
		if at <= 37 then
			helper_53ffe901(7320320, -1)
		end
		if at <= 38 then
			helper_038a2e4d(30)
		end
		if at <= 39 then
			helper_53ffe901(7320330, -1)
		end
		if at <= 40 then
			helper_038a2e4d(30)
		end
		if at <= 41 then
			helper_53ffe901(7320340, -1)
		end
		if at <= 42 then
			helper_038a2e4d(30)
		end
		if at <= 43 then
			helper_53ffe901(7320350, -1)
		end
		if at <= 44 then
			helper_038a2e4d(30)
		end
		if at <= 45 then
			helper_53ffe901(7320360, -1)
		end
		if at <= 46 then
			helper_344d6cd8()
		end
		if at <= 47 then
			helper_038a2e4d(30)
		end
		if at <= 48 then
			helper_53ffe901(7320370, -1)
		end
		if at <= 49 then
			helper_238b5abc(0)
		end
		if at <= 50 then
			helper_53ffe901(7320380, -1)
		end
		if at <= 51 then
			helper_238b5abc(0)
		end
		if at <= 52 then
			helper_038a2e4d(180)
		end
		if at <= 53 then
			helper_038a2e4d(60)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(projection)
	at = 55
	helper_19330()
end

--- Helper function.
local function helper_102dc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	vm.section(function()
		event.set_save_flag(728, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7835)
		var0 = event.load_sound_effect_file_2(7835) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e728/")
		event.load_message_file(0, 5, "e728.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e728_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e728_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e728_dark.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e728_sun.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e728_magic_h.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "e728_magic_l.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "e728_DEhikari.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(7, 14)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.load_character(5, "e728_san_hit.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(8, 15)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e700/e728/e728_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e700/e728/e728_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_map_part_2(6, "p06_d06b03-0")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_scale(6, 0.7, 0.7, 0.7)
		event.set_object_handle_position(1, -1.42, 0.0, -83.64)
		event.set_object_handle_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(0, -23.19, 0.0, -81.74)
		event.set_object_handle_rotation(0, 0.0, 0.26, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, -12.34, 0.0, 42.31)
		event.set_object_handle_rotation(2, 0.0, -3.07, 0.0)
		event.set_object_handle_footstep_sound(2, 1)
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.attach_character_to_frame(10, "tama", 14)
		event.set_object_handle_position(3, 452.27, -10000, 254.12)
		event.set_object_handle_rotation(3, 0.0, -0.1, 0.0)
		event.set_object_handle_footstep_sound(3, 1)
		event.set_object_handle_position(8, 452.27, -10000, 254.12)
		event.set_object_handle_rotation(8, 0.0, -0.1, 0.0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_visible(8, 0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(3)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_active(11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_event_projection(360.9)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(6.95, 33.33, -38.64)
		event.set_camera_sequence_look_at(2.96, 21.19, 34.24)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		helper_888ab2a3(30)
		event.move_camera_sequence_eased(6.95, 33.33, -38.64, -16.79, 86.78, 30.71, 120, 2, 1.0)
		helper_0382f327(7280160, 540)
		event.set_event_projection(524.9)
		event.set_camera_sequence_position(-17.25, 2.73, -179.23)
		event.set_camera_sequence_look_at(-11.0, 60.16, -36.27)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(2, "手を上げる", 6)
		event.queue_object_sequence_next_motion(2, "手を上げるL", 4)
		wait_objects(2)
		event.delay_object_sequence_motion_track(2, 180)
		event.set_object_sequence_motion(2, "死に絶えるのだ", 6)
		event.queue_object_sequence_next_motion(2, "死に絶えるのだL", 4)
		event.delay_object_sequence_sound_track(2, 180)
		event.play_object_sequence_sound(2, var0, 1)
		event.open_voice_stream_wave(1, 7280163)
		helper_9cbdc640(1)
		event.open_message_window_2(0, 7280163)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		helper_888ab2a3(180)
		event.start_crossfade(30)
		event.set_camera_sequence_position(1.58, 101.91, -60.95)
		event.set_camera_sequence_look_at(-17.89, 92.73, 25.56)
		helper_61e5dba6(0, -1)
		close_message(0)
		event.close_voice_stream(1)
		wait_objects(2)
		event.set_camera_sequence_position(-37.44, 9.97, -30.69)
		event.set_camera_sequence_look_at(1007.77, 434.9, -2136.35)
		event.shake_camera_sequence_vertically(0.0, 3.3, 0.0, 60)
		event.play_sound_effect(var0, 2)
		event.set_object_handle_visible(6, 1)
		helper_888ab2a3(60)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		helper_888ab2a3(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		helper_0382f327(7280165, 90)
		event.set_camera_sequence_position(-5.51, 54.41, -260.22)
		event.set_camera_sequence_look_at(-13.59, 43.11, -47.5)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_scale(6, 1.0, 1.0, 1.0, 180)
		event.set_object_sequence_motion(2, "振り返る", 6)
		event.queue_object_sequence_next_motion(2, "上見立ち", 4)
		helper_888ab2a3(60)
		event.move_camera_sequence_eased(-5.51, 375.83, -260.22, -4.47, 459.86, -47.34, 120, 0, 1.0)
		wait_camera()
		event.set_camera_sequence_position(-44.01, 88.99, -11.02)
		event.set_camera_sequence_look_at(-13.6, 22.3, -75.12)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_0382f327(7280170, 150)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(7280180, 120)
		event.move_camera_sequence_eased(-88.64, 165.69, 144.36, -18.85, 102.29, 59.43, 120, 0, 0.5)
		event.stop_sound_effect(var0, 2)
		event.play_sound_effect(var0, 3)
		helper_888ab2a3(30)
		helper_0382f327(7280190, 500)
		wait_camera()
		event.set_camera_sequence_position(-14.82, 6.49, -265.28)
		event.set_camera_sequence_look_at(-12.4, 63.83, -45.92)
		event.set_object_sequence_position(2, -10.86, 37.42, 79.41)
		event.reset_object_sequence_dynamic_animation(2)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(2, "振り返る2", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_0382f327(7280200, 210)
		wait_objects(2)
		event.play_sound_effect(var0, 4)
		event.set_object_sequence_motion(2, "闇世界の王", 6)
		event.queue_object_sequence_next_motion(2, "闇世界の王L", 4)
		event.delay_object_sequence_sound_track(2, 30)
		event.play_object_sequence_sound(2, var0, 5)
		helper_0382f327(7280210, 480)
		wait_objects(2)
		event.set_camera_sequence_position(-45.16, 123.78, 11.64)
		event.set_camera_sequence_look_at(-7.21, 140.87, 80.61)
		event.stop_music(0)
		event.set_character_active(13)
		event.set_object_sequence_position(5, -9.83, 0.0, -376.53)
		event.set_object_sequence_motion(5, "魔法かまえ")
		event.set_object_sequence_motion(3, "魔法かまえ", 4)
		event.set_object_sequence_position(3, -9.83, 0.0, -376.53)
		event.reset_object_sequence_dynamic_animation(3)
		event.set_object_sequence_position(8, -9.83, 0.0, -376.53)
		event.set_object_sequence_motion(2, "フハハハハ", 4)
		helper_0382f327(7280220, 210)
		event.play_sound_effect(var0, 6)
		event.set_character_active(12)
		event.set_object_sequence_position(4, -16.64, 87.63, 60.46)
		event.set_object_sequence_rotation(4, 0.0, -3.07, 0.0)
		event.set_object_sequence_motion(4, "魔法あたる", 6)
		event.set_object_sequence_motion(2, "魔法あたる", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		wait_objects(2)
		event.stop_sound_effect(var0, 3)
		event.set_camera_sequence_position(-12.59, 20.81, -29.79)
		event.set_camera_sequence_look_at(-11.75, 19.91, -100.77)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_motion(0, "後ろ見る", 6)
		event.queue_object_sequence_next_motion(0, "後ろ見るL", 4)
		event.set_object_sequence_motion(1, "後ろ見", 6)
		event.queue_object_sequence_next_motion(1, "後ろ見L", 4)
		wait_objects(1)
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-0.53, 9.74, -325.24)
		event.set_camera_sequence_look_at(-10.06, 15.31, -377.35)
		event.set_object_sequence_texture_animation(3, 0)
		event.play_sound_effect(var0, 8)
		event.set_object_sequence_texture_animation(3, 1, "つかれ目パチ")
		helper_888ab2a3(60)
		event.stop_sound_effect(var0, 8)
		event.set_camera_sequence_position(8.44, 122.24, -79.64)
		event.set_camera_sequence_look_at(17.47, 121.82, 84.02)
		event.set_character_active(0, 13)
		event.move_camera_sequence(-31.27, 122.24, -88.16, -24.72, 121.82, 75.61, 420)
		helper_0382f327(7280230, 420)
		wait_camera()
		event.set_camera_sequence_position(-143.28, 120.11, -54.02)
		event.set_camera_sequence_look_at(-4.2, 126.33, 56.81)
		event.play_sound_effect(var0, 9)
		event.set_object_sequence_motion(2, "杖投げる", 6)
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-63.01, 36.02, -308.06)
		event.set_camera_sequence_look_at(6.33, 11.27, -369.11)
		event.set_character_model_lighting(10, 0)
		event.set_character_model_color(10, 128.0, 128.0, 128.0, 128.0)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "杖投げる", 6)
		event.set_object_sequence_scale(2, 0.5, 1.0, 1.0)
		event.set_object_sequence_position(2, 6.23, -0.75, -116.64)
		event.reset_object_sequence_dynamic_animation(2)
		event.delay_object_sequence_sound_track(3, 45)
		event.play_object_sequence_sound(3, var0, 10)
		event.delay_object_sequence_motion_track(3, 45)
		event.set_object_sequence_motion(3, "刺さる", 6)
		event.queue_object_sequence_next_motion(3, "刺さるL", 4)
		helper_888ab2a3(45)
		event.set_object_handle_visible(8, 1)
		event.set_object_sequence_motion(8, "刺さる", 6)
		helper_888ab2a3(5)
		helper_0382f327(7280235, 90)
		event.set_camera_sequence_position(-13.1, 29.49, -152.47)
		event.set_camera_sequence_look_at(-13.69, 6.9, -67.55)
		event.set_object_handle_visible(8, 0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.set_object_sequence_position(2, -10.86, 37.42, 79.41)
		event.reset_object_sequence_dynamic_animation(2)
		event.set_object_sequence_position(1, -1.96, 0.0, -78.42)
		event.set_object_sequence_rotation(1, 0.0, -0.48, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		helper_888ab2a3(90)
		event.set_camera_sequence_position(-139.53, 12.92, -295.36)
		event.set_camera_sequence_look_at(-5.92, 14.31, -385.02)
		event.set_object_sequence_scale(2, 1.0, 1.0, 1.0)
		event.set_object_sequence_position(2, 4.32, 1.63, -115.01)
		event.reset_object_sequence_dynamic_animation(2)
		event.move_object_sequence(2, 4.32, 25.63, -115.01, 120)
		event.move_object_sequence(3, -9.83, 25.0, -376.53, 120)
		wait_objects(3)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-10.74, 103.97, -46.08)
		event.set_camera_sequence_look_at(-10.95, 122.33, 62.77)
		event.set_character_model_lighting(10, 1)
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.set_object_sequence_position(2, -10.86, 37.42, 79.41)
		event.reset_object_sequence_dynamic_animation(2)
		event.play_sound_effect(var0, 11)
		event.set_object_sequence_motion(2, "カモーン", 6)
		event.queue_object_sequence_next_motion(2, "カモーンL", 4)
		helper_888ab2a3(90)
		event.set_camera_sequence_position(-139.53, 12.92, -295.36)
		event.set_camera_sequence_look_at(-5.92, 14.31, -385.02)
		event.set_character_model_lighting(10, 0)
		event.set_character_model_color(10, 128.0, 128.0, 128.0, 128.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_scale(2, 1.0, 1.0, 1.0)
		event.set_object_sequence_position(2, 4.32, 25.63, -115.01)
		event.reset_object_sequence_dynamic_animation(2)
		event.move_object_sequence(2, 13.34, 42.27, -29.33, 10)
		event.play_sound_effect(var0, 12)
		event.delay_object_sequence_motion_track(3, 10)
		event.set_object_sequence_motion(3, "落ちる", 6)
		event.queue_object_sequence_next_motion(3, "落ちるL", 4)
		event.move_object_sequence(3, -9.83, 0.0, -376.53, 30)
		helper_888ab2a3(60)
		event.set_character_model_lighting(10, 1)
		event.set_camera_sequence_position(8.05, 9.57, -432.58)
		event.set_camera_sequence_look_at(-4.2, 9.01, -384.9)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.set_object_sequence_position(2, -10.86, 37.42, 79.41)
		event.reset_object_sequence_dynamic_animation(2)
		event.set_object_sequence_position(0, -27.05, 0.0, -181.8)
		event.set_object_sequence_rotation(0, 0.0, 3.06, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 7.3, 0.0, -200.98)
		event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_object_sequence(0, -25.77, 0.0, -317.97, 120)
		event.rotate_object_sequence(0, 0.0, 2.94, 0.0, 120)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(1, 4.82, 0.0, -318.77, 120)
		event.rotate_object_sequence(1, 0.0, -3.0, 0.0, 120)
		helper_888ab2a3(100)
		event.set_camera_sequence_position(-31.52, 44.28, -338.11)
		event.set_camera_sequence_look_at(-5.77, 5.41, -388.31)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -24.38, 0.0, -382.48)
		event.set_object_sequence_rotation(0, 0.0, 2.22, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 10.7, 0.0, -369.54)
		event.set_object_sequence_rotation(1, 0.0, -2.64, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_motion(1)
		event.set_object_sequence_motion(1, "立ち", 4)
		helper_888ab2a3(30)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目とじ２～くるし目")
		event.set_object_sequence_motion(0, "しゃがむ", 6)
		event.queue_object_sequence_next_motion(0, "しゃがむL", 4)
		event.delay_object_sequence_motion_track(1, 15)
		event.set_object_sequence_motion(1, "しゃがみ", 6)
		event.queue_object_sequence_next_motion(1, "しゃがみL", 4)
		event.set_object_sequence_motion(3, "ユリス見る", 6)
		event.queue_object_sequence_next_motion(3, "ユリス見るL", 4)
		helper_888ab2a3(60)
		helper_0382f327(7280240, 90)
		helper_0382f327(7280245, 300)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "かなし目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "かなし目～おこり目")
		event.set_object_sequence_texture_animation(0, 1, "歯くいしばり")
		event.set_camera_sequence_position(-6.87, 5.41, -405.85)
		event.set_camera_sequence_look_at(-26.19, 16.97, -379.68)
		event.set_object_sequence_motion(3, "落ちるL", 6)
		event.set_object_sequence_position(1, 10.32, 0.0, -384.63)
		event.reset_object_sequence_dynamic_animation(1)
		helper_888ab2a3(90)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.load_music(37)
		event.play_music(0)
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 13)
		event.set_object_sequence_motion(0, "しゃがむ戻り", 6)
		event.rotate_object_sequence(0, 0.0, 0.18, 0.0, 20)
		event.delay_object_sequence_motion_track(0, 20)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "おきあがり", 6)
		event.rotate_object_sequence(1, 0.0, -0.24, 0.0, 20)
		event.delay_object_sequence_motion_track(1, 20)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_camera_sequence_position(-11.62, 15.51, -310.99)
		event.set_camera_sequence_look_at(-10.21, 16.97, -375.48)
		helper_888ab2a3(30)
		helper_888ab2a3(90)
		event.set_camera_sequence_position(21.35, 75.0, -74.7)
		event.set_camera_sequence_look_at(-18.07, 133.59, 68.07)
		event.set_object_sequence_position(0, -17.05, 0.0, -260.83)
		event.set_object_sequence_rotation(0, 0.0, 0.3, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 20.43, 0.0, -290.0)
		event.set_object_sequence_rotation(1, 0.0, 0.12, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_camera_sequence_eased(71.01, 5.64, -395.51, -82.14, 81.58, 45.26, 120, 2, 1.0)
		wait_camera()
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-14.25, 113.8, -124.29)
		event.set_camera_sequence_look_at(-12.74, 114.05, 57.05)
		event.set_object_sequence_motion(2, "杖構える", 6)
		event.queue_object_sequence_next_motion(2, "杖構えるL", 4)
		event.delay_object_sequence_sound_track(2, 30)
		event.play_object_sequence_sound(2, var0, 14)
		helper_888ab2a3(30)
		event.set_motion_blur(100)
		event.shake_camera_sequence_vertically(0.0, 8.5, 5.5, 150)
		helper_888ab2a3(90)
		event.fade_out_screen(20, 255, 255, 255)
		helper_888ab2a3(31)
	end)
	event.cancel_drama_scene_skip()
	event.set_motion_blur(0)
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 3)
	event.stop_sound_effect(var0, 8)
	var2 = event.get_active_music_number() or var2
	if var2 ~= 37 then
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(37)
		event.play_music(0)
	end
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
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.load_message_file(0, -1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local active_chr_no: s32 = 0
	event.initialize_event()
	flag = event.get_save_flag(728) or flag
	if flag == 1 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		event.show_dungeon_status_bar(0, 1.0)
		helper_177d8()
		event.show_dungeon_status_bar(1, 1.0)
		event.load_dungeon_monster(621, 1)
		event.load_dungeon_monster(622, 0)
		event.place_dungeon_monster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		event.place_dungeon_monster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
		event.control_stopwatch(3, 350, 370, 1)
		event.control_stopwatch(2, 18000)
		event.control_stopwatch_1(0)
	end
	event.set_character_position(0, 0.0, 0.0, -400.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -400.0)
	event.set_camera_position(0.0, 40.0, -520.0)
	event.reset_follow_camera(0)
	vm.wait(2)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_1efcc

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local active_chr_no_2: s32 = 0
	print(">>>>>>>>>>>>>>>>>RUN 500\n")
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_screen(20)
	helper_888ab2a3(20)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_status(0, 8, 1)
	end
	if active_chr_no == 1 then
		event.set_character_status(1, 8, 1)
	end
	event.clear_event_battle_monsters(-1)
	event.set_dungeon_floor_info(5, 27, 5, 2)
	active_chr_no_2 = event.get_playable_character() or active_chr_no_2
	if active_chr_no_2 == 2 then
		event.switch_dungeon_main_character(0)
	end
	if active_chr_no_2 == 3 then
		event.switch_dungeon_main_character(1)
	end
	event.go_to_georama_edit(180, 500)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_1a7e8()
	event.set_save_data_value(0, 10)
	vm.wait(2)
	event.jump_to_map_3(-1, "s66", 520)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	event.show_dungeon_status_bar(0, 1.0)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	helper_102dc()
	event.skip_next_music_load()
	vm.wait(2)
	event.load_dungeon_map("d06b02")
	event.load_event_script("d06b02/d06b02.stb", 100)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(728) or flag
		flag_2 = event.get_save_flag(732) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var2 = vm.float_bits(event.get_random_number(100)) or var2
			if var2 < 50 then
				at = 1
				helper_a9eaf20e(0, 8570060)
			else
				at = 2
				helper_a9eaf20e(0, 8570070)
			end
			return
		end
		at = 3
		helper_f9968159(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_2609f66b(0, 8570070)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 1201, which map data, a script or the engine runs by number.
function script.event_1201()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local boss_map: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(15, 1)
	var0 = 0
	event.initialize_event()
	var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_052.sound.json") or var1
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_dungeon_pause_flags(16384, 1)
	event.play_sound_effect(var1, 0)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(0, 128, 128, 128, 128, 90)
	helper_888ab2a3(90)
	event.save_music_status(-1)
	var2 = event.get_event_sound_bank(4) or var2
	argc = event.get_sound_effect_status(var2, 0) or argc
	battle_bgm_vol = event.get_battle_music_volume() or battle_bgm_vol
	event.stop_sound_effect(var2, 0)
	event.stop_music(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	event.start_background_file_loads_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_888ab2a3(30)
	helper_479dc9e9()
	event.load_music_pack(60)
	event.play_music(0)
	helper_888ab2a3(30)
	event.set_dungeon_pause_flags(1, 1)
	event.reset_dungeon_collision_primitives()
	block = event.load_event_image_4(5, "textures/dungeon/image/gameover.json", 0) or block
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "gameover1", block)
	event.set_event_sprite_color(1, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(1, 0, 0, 576, 128)
	event.set_event_sprite_size(1, 576, 128)
	event.set_event_sprite_position(1, -320, 208)
	event.set_event_sprite_draw_pass(1, 1)
	event.attach_object_handle_to_sprite(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.move_object_sequence(1, 288, 208, 0.0, 20)
	helper_888ab2a3(30)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "gameover1", block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 128, 576, 64)
	event.set_event_sprite_size(2, 576, 64)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 1)
	event.attach_object_handle_to_sprite(2, 2)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_color(2, 128, 128, 128, 128, 120)
	helper_888ab2a3(120)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(7)
		end
	end
	debug_flag = event.get_debug_flag() or debug_flag
	debug_flag = 0
	if debug_flag == 1 then
		event.run_dungeon_debug_command(0)
		event.reset_action_character_motion(0, 4)
	else
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		if active_chr_no == 2 then
			event.clear_effect_manager()
		end
		event.stop_music(0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(0)
		if var0 == 1 then
			event.add_hp_by_rate(1.0, 0)
			event.add_battle_weapon_durability(0, 999)
			event.add_battle_weapon_durability(1, 999)
			event.run_dungeon_event(-1)
			event.clear_event_battle_monsters(-1)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return 1
		else
			event.set_scene_exit_flag(1)
			event.finish_event()
			return 0
		end
	end
	event.stop_music(0)
	helper_888ab2a3(4)
	load_no = event.get_saved_music_number() or load_no
	event.load_music(load_no)
	event.restore_music_status(-1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_event_image(0)
	boss_map = event.is_dungeon_boss_floor() or boss_map
	if boss_map ~= 1 then
		if argc == 1 then
			event.play_sound_effect(var2, 0)
			event.set_sound_effect_volume(var2, 0, battle_bgm_vol)
		end
	end
	event.set_camera_control_enabled(1)
	event.show_dungeon_status_bar(1, 1.0)
	if debug_flag ~= 1 then
		event.fade_in_screen(30)
	end
	event.set_dungeon_pause_flags(16385, 0)
	event.finish_event()
	return 0
end

--- Event 27070, which map data, a script or the engine runs by number.
script.event_27070 = helper_1efcc

return script
