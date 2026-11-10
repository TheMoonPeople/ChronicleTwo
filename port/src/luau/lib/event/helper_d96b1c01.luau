--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_d96b1c01()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local operand_x: f32 = 0
	local operand_y: f32 = 0
	local operand_z: f32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	vm.section(function()
		event.set_save_flag(308, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		var0 = event.load_sound_effect_file_2(3803) or var0
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e308/")
		event.load_message_file(0, 5, "e308_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e308_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e308_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "p00_24a.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_scene_status_flags(1, 10, 8, 1)
		event.change_directory("")
		event.load_character(5, "event/d03/p00_26a.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_scene_status_flags(1, 11, 8, 1)
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e308/e308_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 13)
			event.load_equipment_model(5, 1, 4, "info", 13)
			event.load_equipment_model(5, 1, 3, "info", 13)
			event.load_equipment_model(5, 1, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e308/e308_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		end
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -230.0, 62.1, 1210.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -213.0, 65.619995, 1230.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(3, -150.0, 230.0, 1600.0)
		event.set_object_handle_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(3, "飛び", 4)
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_sound_bank(2, var0)
		event.set_object_handle_frame_draw_flag(2, "hana", 0)
		event.play_object_sequence_sound(3, var0, 1)
		event.delay_object_sequence_sound_track(3, 34)
		event.play_object_sequence_sound(3, var0, 1)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 360)
		event.add_object_sequence_path_point(2, -193.32, 507.72, 144.75)
		event.add_object_sequence_path_point(2, -159.98, 507.72, 220.59)
		event.add_object_sequence_path_point(2, -76.06, 507.72, 268.34)
		event.add_object_sequence_path_point(2, 23.46, 507.72, 253.28)
		event.add_object_sequence_path_point(2, 92.64, 507.72, 174.56)
		event.add_object_sequence_path_point(2, 93.49, 507.72, 66.28)
		event.add_object_sequence_path_point(2, 1.5, 507.72, -7.07)
		event.add_object_sequence_path_point(2, -107.74, 507.72, -27.82)
		event.add_object_sequence_path_point(2, -212.55, 507.72, 43.02)
		event.add_object_sequence_path_point(2, -280.2, 507.72, 145.95)
		event.add_object_sequence_path_point(2, -261.4, 507.72, 250.13)
		event.add_object_sequence_path_point(2, -177.44, 507.72, 302.03)
		event.add_object_sequence_path_point(2, -77.76, 507.72, 299.29)
		event.add_object_sequence_path_point(2, -8.21, 507.72, 209.44)
		event.add_object_sequence_path_point(2, 14.08, 507.72, 94.42)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(254.65, 473.72, 1588.47)
		event.set_camera_sequence_look_at(-219.14, 62.76, 1197.82)
		event.play_sound_effect(var0, 0)
		event.fade_in_screen(30)
		x = -150.0
		y = 230.0
		z = 1600.0
		x_2 = 0.0
		y_2 = -8.0
		z_2 = -10.0
		operand_x = 0.0
		operand_y = vm.f32(0.2)
		operand_z = 0.0
		var11 = 0
		while var11 < 60 do
			do
				local out1, out2, out3 = event.add_vectors(x, y, z, x_2, y_2, z_2)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = event.add_vectors(x_2, y_2, z_2, operand_x, operand_y, operand_z)
				x_2 = out1 or x_2
				y_2 = out2 or y_2
				z_2 = out3 or z_2
			end
			event.set_object_handle_position(3, x, y, z)
			var11 = var11 + 1
			vm.wait(1)
		end
		event.set_character_active(0, 11)
		event.set_camera_sequence_position(-184.07, 43.54, 1216.07)
		event.set_camera_sequence_look_at(-236.95, 39.04, 1208.54)
		if active_chr_no == 0 then
			event.set_character_active(0)
		else
			event.set_character_active(13)
			event.set_character_active(14)
		end
		event.move_object_sequence(0, -230.0, 32.1, 1200.0, 10)
		event.set_object_sequence_motion(0, "d03着地", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		wait_frames(6)
		if active_chr_no == 0 then
			event.set_character_active(13)
			event.set_character_active(14)
		else
			event.set_character_active(0)
		end
		event.move_object_sequence(1, -213.0, 35.19, 1220.0, 10)
		event.set_object_sequence_motion(1, "d03着地", 6)
		wait_frames(2)
		var12 = event.get_sound_id(1) or var12
		event.play_sound_effect(var12, 3)
		event.play_sound_effect(var12, 2)
		wait_frames(6)
		event.play_sound_effect(var12, 2)
		wait_frames(30)
		event.set_camera_sequence_position(-220.28, 65.74, 1289.9)
		event.set_camera_sequence_look_at(-220.42, 54.04, 1203.57)
		event.move_camera_sequence_eased(-220.21, 65.74, 1327.83, -182.37, 80.44, 1173.66, 60, 0, 1.0)
		event.move_object_sequence(1, -213.0, 33.37, 1200.0, 30)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "立ち")
		wait_camera()
		event.set_camera_sequence_position(-202.75, 44.94, 1163.67)
		event.set_camera_sequence_look_at(-225.81, 55.17, 1208.79)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3080010)
		wait_objects(0)
		event.set_object_sequence_texture_animation(1, 1, "通常目～こまり目とじ")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "こまり目とじ～目あけ")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0, "こまり目とじ～目あけ")
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 1)
		event.play_object_sequence_sound(1, var0, 3)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3080020)
		wait_objects(1)
		event.set_camera_sequence_position(-218.98, 55.74, 1263.48)
		event.set_camera_sequence_look_at(-222.62, 51.36, 1199.73)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3080030)
		event.move_camera_sequence_eased(-218.17, 55.74, 1293.84, -219.13, 76.78, 1199.61, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 14)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(2, "飛び", 4)
		event.start_object_sequence_path(2)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_1584c528(3080035, 180)
		wait_camera()
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.set_character_active(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
	event.finish_event()
end

return helper_d96b1c01
