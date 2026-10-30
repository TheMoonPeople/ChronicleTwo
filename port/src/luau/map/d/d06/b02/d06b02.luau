--!strict
-- map/d/d06/b02/d06b02.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_786b79f1 = require("@lib/event/helper_786b79f1")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

--- Helper function.
local function helper_10324()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.set_save_flag(728, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7836)
		var0 = event.load_sound_effect_file_2(7836) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e214e.gltf", "e214e", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
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
		block = event.load_event_image_4(5, "e728telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e728telop01", block)
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
		event.set_object_handle_position(1, 4028.5, 1622.31, -1892.41)
		event.set_object_handle_rotation(1, 0.0, -1.54, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(0, 4034.32, 1622.31, -1873.58)
		event.set_object_handle_rotation(0, 0.0, -1.69, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, 4329.53, 1541.01, -1873.11)
		event.set_object_handle_rotation(2, 0.0, 2.9, 0.0)
		event.set_object_handle_footstep_sound(2, 2)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(3987.77, 1635.56, -1881.54)
		event.set_camera_sequence_look_at(4044.8, 1645.92, -1884.2)
		event.set_event_projection(524.9)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		helper_888ab2a3(60)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "上→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "上から左", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		helper_888ab2a3(60)
		event.set_camera_sequence_position(4119.77, 1673.4, -1851.32)
		event.set_camera_sequence_look_at(3992.15, 1648.49, -1851.49)
		event.set_event_projection(300.9)
		event.play_sound_effect(var0, 0)
		event.move_camera_sequence(9389.19, 2315.05, -1704.48, 8139.49, 2508.8, -1483.43, 300)
		wait_camera()
		helper_888ab2a3(20)
		helper_888ab2a3(10)
		event.set_camera_sequence_position(3887.54, 1636.19, -1974.75)
		event.set_camera_sequence_look_at(4005.51, 1653.83, -1855.26)
		event.set_event_projection(524.9)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(0, 4036.58, 1622.31, -1856.87)
		event.set_object_sequence_rotation(0, 0.0, -2.05, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 4032.15, 1622.31, -1892.75)
		event.set_object_sequence_rotation(1, 0.0, -1.54, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(2, 3919.19, 1729.55, -1864.92)
		event.set_object_sequence_rotation(2, 0.0, 1.5, 0.0)
		event.reset_object_sequence_dynamic_animation(2)
		event.move_object_sequence(2, 3919.19, 1622.31, -1864.92, 20)
		event.set_object_sequence_motion(2, "落下", 6)
		event.delay_object_sequence_motion_track(2, 20)
		event.queue_object_sequence_next_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.play_sound_effect(var0, 1)
		event.delay_camera_sequence_shake_track(20)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		helper_888ab2a3(90)
		wait_objects(2)
		event.set_camera_sequence_position(4061.29, 1628.51, -1771.93)
		event.set_camera_sequence_look_at(3940.77, 1672.13, -1868.07)
		event.set_object_sequence_position(0, 4036.58, 1222.31, -1856.87)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 4032.15, 1222.31, -1892.75)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_camera_sequence(4052.6, 1698.8, -1956.36, 3928.33, 1648.67, -1867.69, 150)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.play_sound_effect(var0, 2)
		event.delay_object_sequence_sound_track(2, 90)
		event.play_object_sequence_sound(2, var0, 3)
		event.set_object_sequence_motion(2, "攻撃１", 6)
		event.queue_object_sequence_next_motion(2, "攻撃２", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		wait_camera()
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.stop_sound_effect(var0, 0)
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
	event.set_character_active(0)
	event.set_character_position(0, 4036.58, 1622.31, -1856.87)
	event.set_character_rotation(0, 0.0, -2.05, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	vm.wait(11)
end

--- Helper function.
local function helper_1a6d4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	event.reset_action_character_motion(0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_2("event/e700/e728/rasen_iwa.gltf", "snd2/sp/sp_049.sound.json")
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	var9 = event.get_direction_angle(var0, var1, var2, pos_x, pos_y, pos_z) or var9
	var9 = vm.f32(var9 - vm.f32(3.1415927))
	var9 = event.wrap_angle(var9) or var9
	var10 = 0
	while var10 < 20 do
		event.swing_camera_control_to_angle(var9)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var10 = var10 + 1
		vm.wait(1)
	end
	helper_479dc9e9()
	var11 = event.load_sound_effect_file_3(8, "snd2/sp/sp_049.sound.json") or var11
	event.load_character(5, "event/e700/e728/rasen_iwa.gltf", "info", 8)
	event.set_character_active(1, 8)
	event.set_character_position(8, pos_x, pos_y + 20.0, pos_z)
	event.set_character_rotation(8, rot_x, rot_y, rot_z)
	event.set_character_motion(8, "岩消える", 6, 0.6)
	event.play_sound_effect(var11, 0)
	event.move_object_sequence_eased(0, pos_x, pos_y - 260.0, pos_z, 60, 1, 1.0)
	event.reset_follow_camera(0)
	wait_objects(0)
	helper_888ab2a3(30)
	event.delete_character(8)
	event.finish_event()
end

--- Helper function.
local function helper_12f34()
	local var0: s32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_287.sound.json") or var0
		event.play_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e220e.gltf", "e220e", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.change_directory("event/e700/e728/")
		block = event.load_event_image_4(5, "e728telop02.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e728telop02", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		event.load_character(5, "chara/c01_base.gltf", "info", 8)
		event.load_equipment_model(5, 0, 4, "info", 8)
		event.load_equipment_model(5, 0, 3, "info", 8)
		event.load_equipment_model(5, 0, 2, "info", 8, 9)
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "chara/c02_base.gltf", "info", 10)
		event.load_equipment_model(5, 1, 4, "info", 10)
		event.load_equipment_model(5, 1, 3, "info", 10)
		event.load_equipment_model(5, 1, 2, "info", 10, 11)
		event.set_character_active(10)
		event.set_character_active(11)
		event.attach_object_handle_to_character(1, 10)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(1, 3308.05, 2411.42, 3265.06)
		event.set_object_handle_rotation(1, 0.0, -1.54, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(0, 3309.86, 2411.42, 3306.96)
		event.set_object_handle_rotation(0, 0.0, -1.69, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, 3226.64, 2528.88, 3294.36)
		event.set_object_handle_rotation(2, 0.0, 1.5, 0.0)
		event.set_object_handle_footstep_sound(2, 2)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(0, 0)
		event.set_character_active(12)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(3170.59, 2432.59, 3163.04)
		event.set_camera_sequence_look_at(3269.4, 2439.28, 3302.02)
		event.set_event_projection(524.9)
		event.fade_in_screen(30)
		event.move_object_sequence(2, 3226.64, 2411.42, 3294.36, 20)
		event.set_object_sequence_motion(2, "落下", 6)
		event.delay_object_sequence_motion_track(2, 20)
		event.queue_object_sequence_next_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.play_object_sequence_sound(2, var0, 21)
		event.delay_camera_sequence_shake_track(20)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		helper_888ab2a3(90)
		wait_objects(2)
		event.set_camera_sequence_position(3330.27, 2500.07, 3406.83)
		event.set_camera_sequence_look_at(3233.27, 2448.19, 3292.97)
		event.set_object_sequence_position(0, 3309.86, 2911.42, 3306.96)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 3308.05, 2911.42, 3265.06)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_camera_sequence_eased(3371.95, 2435.67, 3236.53, 3241.2, 2447.69, 3291.49, 150, 2, 1.0)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.play_sound_effect(var0, 4)
		event.delay_object_sequence_sound_track(2, 45)
		event.play_object_sequence_sound(2, var0, 22)
		event.set_object_sequence_motion(2, "攻撃１", 6)
		event.queue_object_sequence_next_motion(2, "遊び", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		wait_camera()
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.stop_sound_effect(var0, 4)
	event.stop_sound_effect(var0, 20)
	event.stop_sound_effect(var0, 21)
	event.stop_sound_effect(var0, 22)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.set_character_position(0, 3308.05, 2411.42, 3265.06)
	event.set_character_rotation(0, 0.0, -2.05, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

--- Helper function.
local function helper_14a14()
	local var0: s32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_288.sound.json") or var0
		event.play_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e219e.gltf", "e219e", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.change_directory("event/e700/e728/")
		block = event.load_event_image_4(5, "e728telop03.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e728telop03", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		event.load_character(5, "chara/c01_base.gltf", "info", 8)
		event.load_equipment_model(5, 0, 4, "info", 8)
		event.load_equipment_model(5, 0, 3, "info", 8)
		event.load_equipment_model(5, 0, 2, "info", 8, 9)
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "chara/c02_base.gltf", "info", 10)
		event.load_equipment_model(5, 1, 4, "info", 10)
		event.load_equipment_model(5, 1, 3, "info", 10)
		event.load_equipment_model(5, 1, 2, "info", 10, 11)
		event.set_character_active(10)
		event.set_character_active(11)
		event.attach_object_handle_to_character(1, 10)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(1, -4971.6, 3914.32, 1534.68)
		event.set_object_handle_rotation(1, 0.0, -2.86, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(0, -4993.85, 3914.32, 1543.9)
		event.set_object_handle_rotation(0, 0.0, -2.89, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, -4997.27, 4004.45, 1452.4)
		event.set_object_handle_rotation(2, 0.0, 0.18, 0.0)
		event.set_object_handle_footstep_sound(2, 2)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(0, 0)
		event.set_character_active(12)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-5096.33, 3921.02, 1427.65)
		event.set_camera_sequence_look_at(-4993.89, 3946.99, 1494.91)
		event.set_event_projection(524.9)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.move_object_sequence(2, -4997.27, 3914.32, 1452.4, 20)
		event.set_object_sequence_motion(2, "落下", 6)
		event.delay_object_sequence_motion_track(2, 20)
		event.queue_object_sequence_next_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.play_object_sequence_sound(2, var0, 21)
		event.delay_camera_sequence_shake_track(20)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 30)
		helper_888ab2a3(90)
		wait_objects(2)
		event.set_camera_sequence_position(-4904.1, 3921.19, 1638.17)
		event.set_camera_sequence_look_at(-4997.01, 3947.63, 1461.27)
		event.set_object_sequence_position(0, -4993.85, 4514.32, 1543.9)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -4971.6, 4514.32, 1534.68)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_camera_sequence_eased(-4999.07, 3918.97, 1568.34, -4997.01, 3947.63, 1461.27, 150, 2, 1.0)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.play_sound_effect(var0, 4)
		event.delay_object_sequence_sound_track(2, 45)
		event.play_object_sequence_sound(2, var0, 22)
		event.set_object_sequence_motion(2, "攻撃１", 6)
		event.queue_object_sequence_next_motion(2, "遊び", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		wait_camera()
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(7)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.set_character_position(0, -4971.6, 3914.32, 1534.68)
	event.set_character_rotation(0, 0.0, -2.05, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

--- Helper function.
local function helper_164f4()
	local var0: s32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_289.sound.json") or var0
		event.play_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e40e.gltf", "e40e", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.change_directory("event/e700/e728/")
		block = event.load_event_image_4(5, "e728telop04.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e728telop04", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		event.load_character(5, "chara/c01_base.gltf", "info", 8)
		event.load_equipment_model(5, 0, 4, "info", 8)
		event.load_equipment_model(5, 0, 3, "info", 8)
		event.load_equipment_model(5, 0, 2, "info", 8, 9)
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "chara/c02_base.gltf", "info", 10)
		event.load_equipment_model(5, 1, 4, "info", 10)
		event.load_equipment_model(5, 1, 3, "info", 10)
		event.load_equipment_model(5, 1, 2, "info", 10, 11)
		event.set_character_active(10)
		event.set_character_active(11)
		event.attach_object_handle_to_character(1, 10)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(1, -1266.18, 5303.14, -3048.94)
		event.set_object_handle_rotation(1, 0.0, 1.5, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(0, -1257.27, 5303.14, -3079.18)
		event.set_object_handle_rotation(0, 0.0, 1.23, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, -1167.01, 5396.94, -3048.4)
		event.set_object_handle_rotation(2, 0.0, -1.86, 0.0)
		event.set_object_handle_footstep_sound(2, 2)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(0, 0)
		event.set_character_active(12)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1093.42, 5387.63, -3123.8)
		event.set_camera_sequence_look_at(-1245.42, 5310.96, -3033.33)
		event.set_event_projection(524.9)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.move_object_sequence(2, -1167.01, 5303.14, -3048.4, 20)
		event.set_object_sequence_motion(2, "落下", 6)
		event.delay_object_sequence_motion_track(2, 20)
		event.queue_object_sequence_next_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.play_object_sequence_sound(2, var0, 21)
		helper_888ab2a3(90)
		wait_objects(2)
		event.set_camera_sequence_position(-1299.13, 5331.11, -2982.55)
		event.set_camera_sequence_look_at(-1192.6, 5340.86, -3056.04)
		event.set_object_sequence_position(0, -1257.27, 5603.14, -3079.18)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -1266.18, 5603.14, -3048.94)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_camera_sequence_eased(-1253.37, 5318.24, -3148.07, -1182.09, 5340.92, -3048.93, 150, 2, 1.0)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.play_sound_effect(var0, 4)
		event.delay_object_sequence_sound_track(2, 45)
		event.play_object_sequence_sound(2, var0, 5)
		event.delay_object_sequence_sound_track(2, 45)
		event.play_object_sequence_sound(2, var0, 22)
		event.set_object_sequence_motion(2, "攻撃１", 6)
		event.queue_object_sequence_next_motion(2, "攻撃２", 6)
		event.queue_object_sequence_next_motion(2, "遊び", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		wait_camera()
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(7)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.set_character_active(0)
	event.set_character_position(0, -1257.27, 5303.14, -3079.18)
	event.set_character_rotation(0, 0.0, -2.05, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

--- Helper function.
local function helper_180dc()
	local var0: s32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_290.sound.json") or var0
		event.play_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e117g.gltf", "e117g", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e117f.gltf", "e117f", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(3, 13)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		event.change_directory("event/e700/e728/")
		block = event.load_event_image_4(5, "e728telop05.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e728telop05", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(4, 0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		event.load_character(5, "chara/c01_base.gltf", "info", 8)
		event.load_equipment_model(5, 0, 4, "info", 8)
		event.load_equipment_model(5, 0, 3, "info", 8)
		event.load_equipment_model(5, 0, 2, "info", 8, 9)
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "chara/c02_base.gltf", "info", 10)
		event.load_equipment_model(5, 1, 4, "info", 10)
		event.load_equipment_model(5, 1, 3, "info", 10)
		event.load_equipment_model(5, 1, 2, "info", 10, 11)
		event.set_character_active(10)
		event.set_character_active(11)
		event.attach_object_handle_to_character(1, 10)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(1, -3865.73, 7277.16, 3359.29)
		event.set_object_handle_rotation(1, 0.0, -1.42, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(0, -3866.22, 7277.16, 3386.78)
		event.set_object_handle_rotation(0, 0.0, -1.33, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, -4001.48, 7352.3, 3374.42)
		event.set_object_handle_rotation(2, 0.0, 1.74, 0.0)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_handle_position(3, -3985.26, 7352.3, 3434.83)
		event.set_object_handle_rotation(3, 0.0, 1.98, 0.0)
		event.set_object_handle_footstep_sound(3, 2)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(0, 0)
		event.set_character_active(12)
		event.set_character_active(13)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-4096.39, 7346.63, 3435.97)
		event.set_camera_sequence_look_at(-3944.67, 7285.9, 3390.81)
		event.set_event_projection(524.9)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.move_object_sequence(2, -4001.48, 7277.16, 3374.42, 20)
		event.set_object_sequence_motion(2, "落下", 6)
		event.delay_object_sequence_motion_track(2, 20)
		event.queue_object_sequence_next_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_290.sound.json") or var0
		event.play_object_sequence_sound(2, var0, 21)
		helper_888ab2a3(10)
		event.move_object_sequence(3, -3985.26, 7277.16, 3434.83, 20)
		event.set_object_sequence_motion(3, "落下", 6)
		event.delay_object_sequence_motion_track(3, 20)
		event.queue_object_sequence_next_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_291.sound.json") or var0
		event.play_object_sequence_sound(3, var0, 21)
		event.delay_camera_sequence_shake_track(15)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 40)
		helper_888ab2a3(90)
		wait_objects(2)
		wait_objects(3)
		event.set_camera_sequence_position(-3852.79, 7355.36, 3367.81)
		event.set_camera_sequence_look_at(-4014.32, 7278.63, 3412.93)
		event.set_object_sequence_position(0, -3866.22, 7677.16, 3386.78)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -3865.73, 7677.16, 3359.29)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_camera_sequence_eased(-3871.31, 7288.29, 3372.98, -4018.09, 7304.56, 3413.99, 150, 2, 1.0)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_290.sound.json") or var0
		event.play_sound_effect(var0, 5)
		event.delay_object_sequence_sound_track(2, 60)
		event.play_object_sequence_sound(2, var0, 22)
		event.set_object_sequence_motion(2, "攻撃２", 6)
		event.queue_object_sequence_next_motion(2, "遊び", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		event.set_object_sequence_motion(3, "攻撃２", 6)
		event.queue_object_sequence_next_motion(3, "遊び", 6)
		event.queue_object_sequence_next_motion(3, "立ち")
		wait_camera()
		event.set_object_sequence_color(4, 128, 128, 128, 0, 30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.set_character_position(0, -3866.22, 7277.16, 3386.78)
	event.set_character_rotation(0, 0.0, -2.05, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event_99()
		flag = event.get_save_flag(728) or flag
		if flag == 1 then
			at = 1
			helper_10324()
			event.load_map_sounds(7691)
			event.set_character_visible(1, 1)
			event.set_character_visible(2, 1)
			event.show_dungeon_status_bar(1, 1.0)
			var1 = event.get_sound_id(4) or var1
			print("btl_snd_id = ", var1, "\n")
			event.set_action_character_second_sound_bank(0, var1)
			event.copy_action_character_sound_to_parts(0)
			helper_9dafbc83(vm.f32(3846.1), vm.f32(1622.3), vm.f32(-2002.6), vm.f32(0.69))
			event.set_camera_position(3744.75, 1652.31, -2126.35)
			event.set_camera_look_at(3846.14, 1652.31, -2002.58)
			event.reset_follow_camera(0)
			event.load_dungeon_monster(603, 1)
			event.place_dungeon_monster(603, 4034.9, 1622.3, -1778.2, 0.0, -2.46, 0.0)
		end
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 1 then
			print("btl_snd_id = ", var1, "\n")
			helper_43f02c95(vm.f32(3846.1), vm.f32(1622.3), vm.f32(-2002.6), vm.f32(0.69))
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-1")
	helper_1a6d4()
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-3")
	helper_1a6d4()
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-5")
	helper_1a6d4()
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-7")
	helper_1a6d4()
end

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-9")
	helper_1a6d4()
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		helper_888ab2a3(20)
		at = 2
		helper_12f34()
		event.set_function_point_enabled("", "2f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-2")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-3")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.load_dungeon_monster(604, 1)
		event.place_dungeon_monster(604, 3220.8, 2411.4, 3458.1, 0.0, 1.91, 0.0)
		event.set_character_position(0, 3482.7, 2411.4, 3361.8)
		event.set_character_rotation(0, 0.0, -1.21, 0.0)
		event.set_camera_position(3776.37, 2452.2, 3256.29)
		event.set_camera_look_at(3625.59, 2441.42, 3309.81)
		event.reset_follow_camera(0)
		event.fade_in_screen(20)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_12f34()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "2f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-2")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-3")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.load_dungeon_monster(604, 1)
					event.place_dungeon_monster(604, 3220.8, 2411.4, 3458.1, 0.0, 1.91, 0.0)
					event.set_character_position(0, 3482.7, 2411.4, 3361.8)
					event.set_character_rotation(0, 0.0, -1.21, 0.0)
					event.set_camera_position(3776.37, 2452.2, 3256.29)
					event.set_camera_look_at(3625.59, 2441.42, 3309.81)
					event.reset_follow_camera(0)
					event.fade_in_screen(20)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 551, which map data, a script or the engine runs by number.
function script.event_551()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		helper_888ab2a3(20)
		at = 2
		helper_14a14()
		event.set_function_point_enabled("", "3f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-4")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-5")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.load_dungeon_monster(605, 1)
		event.place_dungeon_monster(605, -5000.8, 3914.3, 1335.4, 0.0, 0.5, 0.0)
		event.set_character_position(0, -4878.4, 3914.3, 1557.6)
		event.set_character_rotation(0, 0.0, -2.64, 0.0)
		event.set_camera_position(-4801.28, 3960.04, 1697.72)
		event.set_camera_look_at(-4878.44, 3944.32, 1557.56)
		event.reset_follow_camera(0)
		event.fade_in_screen(20)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_14a14()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "3f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-4")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-5")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.load_dungeon_monster(605, 1)
					event.place_dungeon_monster(605, -5000.8, 3914.3, 1335.4, 0.0, 0.5, 0.0)
					event.set_character_position(0, -4878.4, 3914.3, 1557.6)
					event.set_character_rotation(0, 0.0, -2.64, 0.0)
					event.set_camera_position(-4801.28, 3960.04, 1697.72)
					event.set_camera_look_at(-4878.44, 3944.32, 1557.56)
					event.reset_follow_camera(0)
					event.fade_in_screen(20)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 552, which map data, a script or the engine runs by number.
function script.event_552()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		helper_888ab2a3(20)
		at = 2
		helper_164f4()
		event.set_function_point_enabled("", "4f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-6")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-7")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.load_dungeon_monster(606, 1)
		event.place_dungeon_monster(606, -1126.9, 5303.1, -3005.0, 0.0, -1.78, 0.0)
		event.set_character_position(0, -1380.3, 5303.1, -3061.2)
		event.set_character_rotation(0, 0.0, 1.37, 0.0)
		event.set_camera_position(-1537.07, 5363.09, -3093.39)
		event.set_camera_look_at(-1380.34, 5333.14, -3061.24)
		event.reset_follow_camera(0)
		event.fade_in_screen(20)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_164f4()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "4f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-6")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-7")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.load_dungeon_monster(606, 1)
					event.place_dungeon_monster(606, -1126.9, 5303.1, -3005.0, 0.0, -1.78, 0.0)
					event.set_character_position(0, -1380.3, 5303.1, -3061.2)
					event.set_character_rotation(0, 0.0, 1.37, 0.0)
					event.set_camera_position(-1537.07, 5363.09, -3093.39)
					event.set_camera_look_at(-1380.34, 5333.14, -3061.24)
					event.reset_follow_camera(0)
					event.fade_in_screen(20)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 553, which map data, a script or the engine runs by number.
function script.event_553()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		helper_888ab2a3(20)
		at = 2
		helper_180dc()
		event.set_function_point_enabled("", "5f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-8")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-9")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.load_dungeon_monster(607, 1)
		event.load_dungeon_monster(608, 0)
		event.place_dungeon_monster(607, -3980.8, 7277.16, 3321.3, 0.0, 1.46, 0.0)
		event.place_dungeon_monster(608, -3947.0, 7277.16, 3460.7, 0.0, 2.07, 0.0)
		event.set_character_position(0, -3745.89, 7277.16, 3354.1)
		event.set_character_rotation(0, 0.0, -1.38, 0.0)
		event.set_camera_position(-3588.72, 7334.8, 3324.13)
		event.set_camera_look_at(-3745.89, 7307.16, 3354.1)
		event.reset_follow_camera(0)
		event.fade_in_screen(20)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_180dc()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "5f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-8")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-9")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.load_dungeon_monster(607, 1)
					event.load_dungeon_monster(608, 0)
					event.place_dungeon_monster(607, -3980.8, 7277.16, 3321.3, 0.0, 1.46, 0.0)
					event.place_dungeon_monster(608, -3947.0, 7277.16, 3460.7, 0.0, 2.07, 0.0)
					event.set_character_position(0, -3745.89, 7277.16, 3354.1)
					event.set_character_rotation(0, 0.0, -1.38, 0.0)
					event.set_camera_position(-3588.72, 7334.8, 3324.13)
					event.set_camera_look_at(-3745.89, 7307.16, 3354.1)
					event.reset_follow_camera(0)
					event.fade_in_screen(20)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 554, which map data, a script or the engine runs by number.
function script.event_554()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_screen(20)
	helper_888ab2a3(20)
	event.load_dungeon_map("d06b03")
	event.load_event_script("d06b03/d06b03.stb", 100)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_786b79f1(0)
end

--- Event 27020, which map data, a script or the engine runs by number.
function script.event_27020()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(603, 1)
	event.place_dungeon_monster(603, 4034.9, 1622.3, -1778.2, 0.0, -2.46, 0.0)
	helper_9dafbc83(3760.0, vm.f32(1622.3), -2117.0, vm.f32(0.68))
	event.set_camera_position(3660.11, 1666.73, -2241.34)
	event.set_camera_look_at(3760.76, 1652.31, -2116.96)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 27030, which map data, a script or the engine runs by number.
function script.event_27030()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(604, 1)
	event.place_dungeon_monster(604, 3220.8, 2411.4, 3458.1, 0.0, 1.91, 0.0)
	event.set_character_position(0, 3482.7, 2411.4, 3361.8)
	event.set_character_rotation(0, 0.0, -1.21, 0.0)
	event.set_camera_position(3776.37, 2452.2, 3256.29)
	event.set_camera_look_at(3625.59, 2441.42, 3309.81)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 27040, which map data, a script or the engine runs by number.
function script.event_27040()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(605, 1)
	event.place_dungeon_monster(605, -5000.8, 3914.3, 1335.4, 0.0, 0.5, 0.0)
	event.set_character_position(0, -4878.4, 3914.3, 1557.6)
	event.set_character_rotation(0, 0.0, -2.64, 0.0)
	event.set_camera_position(-4801.28, 3960.04, 1697.72)
	event.set_camera_look_at(-4878.44, 3944.32, 1557.56)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 27050, which map data, a script or the engine runs by number.
function script.event_27050()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(606, 1)
	event.place_dungeon_monster(606, -1126.9, 5303.1, -3005.0, 0.0, -1.78, 0.0)
	event.set_character_position(0, -1380.3, 5303.1, -3061.2)
	event.set_character_rotation(0, 0.0, 1.37, 0.0)
	event.set_camera_position(-1537.07, 5363.09, -3093.39)
	event.set_camera_look_at(-1380.34, 5333.14, -3061.24)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 27060, which map data, a script or the engine runs by number.
function script.event_27060()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(607, 1)
	event.load_dungeon_monster(608, 0)
	event.place_dungeon_monster(607, -3980.8, 7277.16, 3321.3, 0.0, 1.46, 0.0)
	event.place_dungeon_monster(608, -3947.0, 7277.16, 3460.7, 0.0, 2.07, 0.0)
	event.set_character_position(0, -3745.89, 7277.16, 3354.1)
	event.set_character_rotation(0, 0.0, -1.38, 0.0)
	event.set_camera_position(-3588.72, 7334.8, 3324.13)
	event.set_camera_look_at(-3745.89, 7307.16, 3354.1)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

return script
