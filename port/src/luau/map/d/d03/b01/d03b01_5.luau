--!strict
-- map/d/d03/b01/d03b01_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06dca721 = require("@lib/event/helper_06dca721")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_161be1ae = require("@lib/event/helper_161be1ae")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4c87af69 = require("@lib/event/helper_4c87af69")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_6b4ee5b8 = require("@lib/event/helper_6b4ee5b8")
local helper_81a3d35c = require("@lib/event/helper_81a3d35c")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Helper function.
local function helper_1662c()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global2)
		event.load_character(5, "chara/c02_base.gltf", "info", global3)
		event.load_equipment_model(5, 1, 1, "info", global3, 17)
		event.load_equipment_model(5, 1, 0, "info", global3, 18)
		event.load_equipment_model(5, 1, 4, "info", global3)
		event.load_equipment_model(5, 1, 3, "info", global3)
		event.load_equipment_model(5, 1, 2, "info", global3, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global3)
		event.set_character_active(1, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if active_chr_no == 1 then
		global2 = 8
		global3 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global2)
		event.load_equipment_model(5, 0, 1, "info", global2, 17)
		event.load_equipment_model(5, 0, 0, "info", global2, 18)
		event.load_equipment_model(5, 0, 4, "info", global2)
		event.load_equipment_model(5, 0, 3, "info", global2)
		event.load_equipment_model(5, 0, 2, "info", global2, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global2)
		event.set_character_active(1, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global3)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e356/e356_lin.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(2, 9)
	event.set_object_sequence_object(2, 4)
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.set_object_handle_visible(9, 0)
	event.load_message_file(0, 5, "event/e300/e356/e356_1.txt")
end

--- Helper function.
local function helper_16120()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global2)
		event.set_character_active(0, global3)
		event.delete_character_extension_packs(global2)
		event.delete_character_extension_packs(global3)
		event.delete_character(global3)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global3)
		event.set_character_active(0, global2)
		event.delete_character_extension_packs(global2)
		event.delete_character_extension_packs(global3)
		event.delete_character(global2)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(9)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(9, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

--- Helper function.
local function helper_177c4()
	local var4: s32 = 0
	local time: f32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		event.load_map_sounds(3847)
		var4 = event.load_sound_effect_file_2(3847) or var4
		helper_1662c()
		event.set_scene_status_flags(1, 0, 256, 1)
		time = event.get_scene_time_of_day() or time
		event.enable_drama_skip()
		event.set_time_of_day(21.0)
		event.set_time_of_day_advancing(0)
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
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(1, global2)
		event.set_character_active(1, global3)
		event.set_character_active(1, 9)
		event.set_object_sequence_position(2, 543.2, 144.04, -840.61)
		event.set_object_sequence_rotation(2, 0.0, 1.17, 0.0)
		event.set_object_sequence_position(1, 569.2, 139.28, -817.83)
		event.set_object_sequence_rotation(1, 0.0, -2.4, 0.0)
		event.set_object_sequence_position(0, 574.57, 140.74, -836.69)
		event.set_object_sequence_rotation(0, 0.0, -1.64, 0.0)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(698.5, 198.36, -687.33, 415.41, 488.3, -904.7)
		event.add_camera_sequence_path_point(698.5, 198.36, -687.33, 415.41, 183.45, -904.7)
		event.start_camera_sequence_path()
		event.fade_in_screen(30)
		wait_frames(230)
		event.set_camera_sequence_position(515.1, 182.78, -800.37)
		event.set_camera_sequence_look_at(557.38, 155.79, -834.03)
		event.set_object_sequence_motion(0, "下向く", 6)
		event.queue_object_sequence_next_motion(0, "下向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3560340)
		event.reset_mouth_texture_animations()
		wait_frames(60)
		event.set_object_sequence_motion(1, "顔そむけ", 6)
		event.queue_object_sequence_next_motion(1, "顔そむけＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3560350)
		event.reset_mouth_texture_animations()
		event.load_music(59)
		event.play_music(0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(580.92, 168.28, -803.2, 557.45, 170.23, -863.66)
		event.add_camera_sequence_path_point(561.82, 168.28, -795.79, 538.36, 170.23, -856.24)
		event.start_camera_sequence_path()
		event.set_object_sequence_motion(2, "ううん", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		helper_4116e6bb(3560360)
		event.reset_mouth_texture_animations()
		wait_objects(2)
		wait_camera()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(531.29, 159.38, -832.46, 583.97, 163.32, -843.63)
		event.add_camera_sequence_path_point(535.18, 159.38, -814.11, 587.86, 163.32, -825.29)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3560370)
		event.reset_mouth_texture_animations()
		wait_camera()
		event.set_camera_sequence_position(501.31, 169.51, -797.49)
		event.set_camera_sequence_look_at(551.47, 171.45, -833.25)
		event.play_sound_effect(var4, 34)
		event.set_object_sequence_motion(2, "振り向く", 6)
		event.queue_object_sequence_next_motion(2, "振り向くL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		helper_4116e6bb(3560380)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "上向く", 6)
		event.queue_object_sequence_next_motion(2, "上向くL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		helper_4116e6bb(3560385)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(521.48, 197.33, -852.11, 539.71, 166.13, -844.52)
		event.add_camera_sequence_path_point(511.07, 215.78, -856.44, 539.71, 166.13, -844.52)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(4, "通常口パク")
		helper_4116e6bb(3560390)
		event.reset_mouth_texture_animations()
		wait_camera()
		event.set_camera_sequence_position(501.31, 169.51, -797.49)
		event.set_camera_sequence_look_at(551.47, 171.45, -833.25)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_1584c528(3560400, -1)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 35)
		event.set_object_sequence_motion(2, "向きかえる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		wait_frames(30)
		event.set_mouth_texture_animations(4, "通常口パク")
		helper_4116e6bb(3560410)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		helper_4116e6bb(3560420)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 36)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3560430)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3560440)
		event.reset_mouth_texture_animations()
		wait_frames(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(698.5, 198.36, -687.33, 415.41, 183.45, -904.7)
		event.add_camera_sequence_path_point(698.5, 198.36, -687.33, 415.41, 488.3, -904.7)
		event.start_camera_sequence_path()
		wait_frames(170)
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait_frames(30)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	event.skip_next_music_load()
	vm.wait(23)
	helper_16120()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1390c()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
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
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.set_object_handle_visible(9, 1)
	event.load_message_file(0, 5, "event/e300/e352/e352_1.txt")
end

--- Helper function.
local function helper_22c00000()
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_133c8()
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
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(9, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
	event.load_dungeon_map("d03b02")
	event.load_event_script("d03b02/d03b02.stb", 503)
end

--- Helper function.
local function helper_14aa4()
	local var4: s32 = 0
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(352, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		at = 1
		vm.wait(1)
		at = 2
		vm.wait(2)
		at = 3
		vm.wait(3)
		at = 4
		vm.wait(4)
		event.load_map_sounds(3836)
		var4 = event.load_sound_effect_file_2(3836) or var4
		helper_1390c()
		time = event.get_scene_time_of_day() or time
		event.enable_drama_skip()
		event.set_time_of_day(18.0)
		event.set_time_of_day_advancing(0)
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
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(752.46, 293.85, -635.82)
		event.set_camera_sequence_look_at(463.46, 169.14, -865.91)
		event.set_object_sequence_position(2, 543.2, 144.04, -840.61)
		event.set_object_sequence_rotation(2, 0.0, -1.99, 0.0)
		event.set_object_sequence_position(0, 553.04, 141.0, -816.53)
		event.set_object_sequence_rotation(0, 0.0, -2.4, 0.0)
		event.set_object_sequence_position(1, 564.98, 142.65, -851.46)
		event.set_object_sequence_rotation(1, 0.0, -1.64, 0.0)
		event.play_sound_effect(var4, 0)
		event.fade_in_screen(30)
		at = 5
		wait_frames(230)
		event.set_camera_sequence_position(485.46, 185.48, -900.58)
		event.set_camera_sequence_look_at(556.75, 169.14, -889.42)
		event.move_camera_sequence_eased(477.74, 185.48, -851.26, 549.03, 169.14, -840.1, 120, 2, 1.0)
		at = 6
		wait_camera()
		event.delay_object_sequence_sound_track(1, 60)
		event.play_object_sequence_sound(1, var4, 1)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くＬ", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 7
		helper_4116e6bb(3520170)
		event.reset_mouth_texture_animations()
		at = 8
		wait_objects(1)
		at = 9
		wait_objects(0)
		event.set_object_sequence_motion(0, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 10
		helper_4116e6bb(3520180)
		event.reset_mouth_texture_animations()
		at = 11
		wait_objects(0)
		event.set_object_sequence_motion(0, "右向く戻り", 6)
		event.set_object_sequence_motion(1, "左向く戻り", 6)
		event.rotate_object_sequence(0, 0.0, -2.04, 0.0, 10)
		event.rotate_object_sequence(1, 0.0, -2.0, 0.0, 10)
		event.set_object_sequence_motion(0, "走り")
		event.set_object_sequence_motion(1, "走り", 0, -1.0, 1)
		event.move_object_sequence(0, 492.39, 147.92, -843.54, 40, 1)
		event.move_object_sequence(1, 498.64, 148.11, -878.52, 40, 1)
		at = 12
		wait_objects(0)
		at = 13
		wait_objects(1)
		event.move_camera_sequence(516.37, 181.42, -848.28, 565.24, 159.44, -832.68, 120)
		at = 14
		wait_camera()
		event.set_camera_sequence_position(802.37, 193.9, -653.74)
		event.set_camera_sequence_look_at(562.44, 177.39, -814.42)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(802.37, 193.9, -653.74, 562.44, 177.39, -814.42)
		event.add_camera_sequence_path_point(802.37, 323.65, -653.74, 562.44, 307.14, -814.42)
		event.start_camera_sequence_path()
		event.move_object_sequence(0, 315.33, 250.34, -928.08, 150, 1)
		event.move_object_sequence(1, 324.09, 250.34, -964.29, 150, 1)
		at = 15
		wait_camera()
	end, function(received: { any }): boolean
		if at <= 4 then
			helper_22c00000()
			wait_frames_skipping(230)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_8cd371d7(3520170)
		end
		if at <= 7 then
			helper_238b5abc(1)
		end
		if at <= 8 then
			helper_238b5abc(0)
		end
		if at <= 9 then
			helper_8cd371d7(3520180)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_344d6cd8()
		end
		if at <= 14 then
			helper_344d6cd8()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 16
	wait_frames(30)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	at = 17
	vm.wait(17)
	event.skip_next_map_sound_load()
	event.skip_next_music_load()
	at = 18
	helper_133c8()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_161be1ae

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_161be1ae()
	helper_06dca721()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 500, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_500() end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_6b4ee5b8()
	event.go_to_georama_edit(1, 502)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_function_point_enabled("", "e348", 0)
		helper_52115bbf()
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		at = 2
		helper_81a3d35c()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_81a3d35c()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	helper_177c4()
	event.jump_to_map_3(-1, "g02", 502)
end

--- Event 504, which map data, a script or the engine runs by number.
script.event_504 = helper_14aa4

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	if helper_4c87af69() ~= 0 then
		event.load_event_script("d03/d03.stb", 1000)
	end
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- Event 13480, which map data, a script or the engine runs by number.
script.event_13480 = helper_81a3d35c

return script
