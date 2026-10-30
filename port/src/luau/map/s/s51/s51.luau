--!strict
-- map/s/s51/s51.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_523109b8 = require("@lib/event/helper_523109b8")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_786b79f1 = require("@lib/event/helper_786b79f1")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f616ba9e = require("@lib/event/helper_f616ba9e")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_ff10()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_event_projection(524.9)
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		at = 1
		helper_888ab2a3(4)
		event.load_music(194)
		event.load_map_sounds(800)
		var1 = event.load_sound_effect_file_2(800) or var1
		event.show_atlamillia_frames(1, 0, 0)
		event.set_character_active(0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e00/e50/")
		event.load_message_file(0, 5, "e50.txt")
		event.load_character_motion_pack(5, "e50_monica.gltf", "info", 0)
		event.set_character_active(0, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.load_character(5, "e50_soldier.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(1, 11)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.copy_character(5, 11, 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.copy_character(5, 11, 13)
		event.set_character_active(0, 13)
		event.attach_object_handle_to_character(3, 13)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.copy_character(5, 11, 14)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(4, 14)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "e50_soldier_s.gltf", "info", 16)
		event.set_character_active(16)
		event.attach_object_handle_to_character(15, 16)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 15)
		event.set_scene_status_flags(1, 16, 512, 1)
		event.copy_character(5, 16, 17)
		event.set_character_active(17)
		event.attach_object_handle_to_character(16, 17)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 16)
		event.set_scene_status_flags(1, 17, 512, 1)
		event.load_character(5, "e50_glassware.gltf", "info", 15)
		event.set_scene_status_flags(1, 15, 64, 1)
		event.set_character_active(0, 15)
		event.change_directory("")
		event.load_character(5, "event/e00/e50/c02_base_e50.gltf", "info", 8)
		event.load_equipment_model(5, 1, 4, "info", 8)
		event.load_equipment_model(5, 1, 3, "info", 8)
		event.load_character_motion_pack(5, "event/e00/e50/e50_monica.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(14, 8)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 14)
		event.set_scene_status_flags(1, 8, 256, 1)
		event.set_scene_status_flags(1, 8, 512, 1)
		event.load_equipment_model(5, 1, 0, "info", 0, 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_map_part_3(5, "p01_s5102-0", "s510206-m0")
		event.attach_object_handle_to_map_part_2(7, "p11_s5102-0")
		event.attach_object_handle_to_map_part_2(6, "p07_s5102-0")
		event.attach_object_handle_to_map_part_3(8, "p08_s5102-0", "s510208-m0")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 8)
		event.attach_object_handle_to_character(9, 1)
		event.attach_object_handle_to_character(10, 2)
		event.attach_object_handle_to_map_part_2(11, "p10_s5102-0")
		event.attach_object_handle_to_map_part_2(12, "p10_s5102-1")
		event.attach_object_handle_to_map_part_2(13, "p12_s5102-0")
		event.attach_object_handle_to_map_part_2(18, "p14_s5102-0")
		event.attach_object_handle_to_map_part_3(17, "p01_s5102-0", "s510213-m0")
		event.set_object_handle_visible(9, 0)
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(8, 1)
		event.set_object_handle_rotation(8, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(5, 1)
		event.set_object_handle_visible(7, 1)
		event.set_object_handle_position(7, 0.0, 0.0, 826.974)
		event.set_object_handle_visible(6, 1)
		event.set_object_handle_visible(13, 1)
		event.set_object_handle_visible(18, 1)
		event.set_object_handle_rotation(11, 0.0, -0.2, 0.0)
		event.set_object_handle_rotation(12, 0.0, 0.2, 0.0)
		event.set_object_handle_visible(17, 0)
		event.set_object_handle_motion(0, "走りノーマル", 4)
		event.set_object_handle_footstep_sound(0, -1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_position(14, -1200.0, -300.0, 260.0)
		event.set_object_handle_rotation(14, 0.0, 1.93, 0.0)
		event.set_object_handle_scale(14, 1.2, 1.2, 1.2)
		event.set_object_handle_motion(14, "走り", 4)
		event.set_object_handle_footstep_sound(14, 21)
		event.set_object_handle_position(15, -1280.0, -300.0, 310.0)
		event.set_object_handle_rotation(15, 0.0, 1.93, 0.0)
		event.set_object_handle_scale(15, 1.2, 1.2, 1.2)
		event.set_object_handle_motion(15, "走り", 4)
		event.set_object_handle_position(16, -1290.0, -300.0, 300.0)
		event.set_object_handle_rotation(16, 0.0, 1.93, 0.0)
		event.set_object_handle_scale(16, 1.2, 1.2, 1.2)
		event.set_object_handle_motion(16, "走り", 4)
		event.set_object_handle_sound_bank(1, var1)
		event.set_object_handle_sound_bank(2, -1)
		event.set_object_handle_sound_bank(3, -1)
		event.set_object_handle_sound_bank(4, -1)
		event.set_object_handle_sound_bank(15, var1)
		event.set_object_handle_sound_bank(16, -1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(15.3, -241.0, 171.19)
		event.set_camera_sequence_look_at(0.41, -250.55, 204.26)
		event.move_camera_sequence_eased(15.53, -241.0, 153.53, 0.63, -250.55, 186.6, 100, 0, 1.0)
		event.move_object_sequence(6, 100.0, -300.0, 210.0, 240)
		event.move_object_sequence(7, 100.0, -300.0, 210.0, 260)
		event.move_object_sequence(8, 100.0, -300.0, 200.0, 270)
		event.fade_in_screen(30)
		at = 2
		wait_camera()
		at = 3
		helper_888ab2a3(4)
		at = 4
		wait_objects(6)
		at = 5
		wait_objects(7)
		at = 6
		wait_objects(8)
		event.set_character_active(1, 0)
		event.set_character_active(0, 8)
		event.set_object_handle_scale(15, 1.0, 1.0, 1.0)
		event.set_scene_status_flags(1, 16, 512, 0)
		event.set_object_handle_scale(16, 1.0, 1.0, 1.0)
		event.set_scene_status_flags(1, 17, 512, 0)
		event.set_object_handle_visible(13, 0)
		event.set_object_handle_visible(18, 0)
		event.set_camera_sequence_position(-575.02, 45.19, 363.88)
		event.set_camera_sequence_look_at(-599.81, 35.7, 424.09)
		event.set_object_handle_motion(14, "立ち", 4)
		event.set_object_handle_footstep_sound(14, -1)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(1, 11)
		event.set_character_active(1, 12)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 70)
		event.add_object_sequence_path_point(0, -692.07, -0.36, 990.78)
		event.add_object_sequence_path_point(0, -689.4, -0.36, 780.32)
		event.add_object_sequence_path_point(0, -662.72, -0.36, 615.33)
		event.add_object_sequence_path_point(0, -627.87, -0.36, 503.76)
		event.start_object_sequence_path(0)
		event.set_object_sequence_motion(1, "走り", 4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 70)
		event.add_object_sequence_path_point(1, -633.39, -0.17, 1210.41)
		event.add_object_sequence_path_point(1, -698.31, -0.17, 1037.39)
		event.add_object_sequence_path_point(1, -732.28, -0.17, 924.78)
		event.add_object_sequence_path_point(1, -729.93, -0.17, 758.07)
		event.start_object_sequence_path(1)
		event.set_object_sequence_motion(2, "走り", 4)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 70)
		event.add_object_sequence_path_point(2, -618.92, -0.17, 1090.21)
		event.add_object_sequence_path_point(2, -655.87, -0.17, 965.4)
		event.add_object_sequence_path_point(2, -667.3, -0.17, 891.14)
		event.add_object_sequence_path_point(2, -667.67, -0.17, 710.72)
		event.add_object_sequence_path_point(2, -666.43, -1.11, 671.43)
		event.start_object_sequence_path(2)
		at = 7
		helper_888ab2a3(15)
		event.play_music(0)
		event.open_voice_stream_wave(1, 500003)
		at = 8
		helper_9cbdc640(1)
		at = 9
		wait_objects(0)
		event.set_camera_sequence_follow_object(0, 0.0, 23.0, -4.0, -0.6, -3.0, 36.0, "", 1)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.play_voice_stream(1)
		event.set_object_sequence_motion(0, "振り返り走り", 6)
		event.queue_object_sequence_next_motion(0, "走りノーマル", 4)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 50)
		event.add_object_sequence_path_point(0, -692.07, -0.17, 990.78)
		event.add_object_sequence_path_point(0, -683.94, -0.17, 726.33)
		event.start_object_sequence_path(0)
		at = 10
		wait_objects(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(-666.42, 40.0, 654.32)
		event.set_camera_sequence_look_at(-678.61, 23.25, 716.14)
		event.set_character_active(1, 11)
		event.set_character_active(1, 12)
		event.set_object_sequence_motion(0, "走りノーマル", 4)
		event.clear_object_sequence_path(0)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 50)
		event.add_object_sequence_path_point(0, -689.4, -0.36, 780.32)
		event.add_object_sequence_path_point(0, -662.72, -0.36, 615.33)
		event.add_object_sequence_path_point(0, -627.87, -0.36, 503.76)
		event.start_object_sequence_path(0)
		event.set_object_sequence_motion(1, "走り", 4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 50)
		event.add_object_sequence_path_point(1, -698.31, -0.17, 1037.39)
		event.add_object_sequence_path_point(1, -732.28, -0.17, 924.78)
		event.add_object_sequence_path_point(1, -729.93, -0.17, 758.07)
		event.start_object_sequence_path(1)
		event.set_object_sequence_motion(2, "走り", 4)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 50)
		event.add_object_sequence_path_point(2, -655.87, -0.17, 965.4)
		event.add_object_sequence_path_point(2, -667.3, -0.17, 891.14)
		event.add_object_sequence_path_point(2, -667.67, -0.17, 710.72)
		event.add_object_sequence_path_point(2, -666.43, -1.11, 671.43)
		event.start_object_sequence_path(2)
		at = 11
		wait_objects(0)
		event.set_camera_sequence_follow_object(0, 3.0, 6.0, -3.0, 3.14, 0.0, 0.1, "kao", 1)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 100)
		event.add_object_sequence_path_point(0, -710.53, -0.17, 707.3)
		event.add_object_sequence_path_point(0, -659.55, -0.17, 588.15)
		event.add_object_sequence_path_point(0, -599.01, -0.17, 474.25)
		event.add_object_sequence_path_point(0, -544.19, -0.17, 394.69)
		event.add_object_sequence_path_point(0, -487.18, -0.17, 335.72)
		event.start_object_sequence_path(0)
		at = 12
		helper_888ab2a3(90)
		event.close_voice_stream(1)
		event.open_voice_stream_wave(1, 500010)
		at = 13
		helper_9cbdc640(1)
		at = 14
		wait_objects(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_follow_object(0, 0.0, 23.0, -4.0, -0.6, -3.0, 36.0, "", 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 140)
		event.add_object_sequence_path_point(0, -710.53, -0.17, 707.3)
		event.add_object_sequence_path_point(0, -659.55, -0.17, 588.15)
		event.add_object_sequence_path_point(0, -599.01, -0.17, 474.25)
		event.add_object_sequence_path_point(0, -544.19, -0.17, 394.69)
		event.add_object_sequence_path_point(0, -493.18, -0.17, 329.72)
		event.start_object_sequence_path(0)
		event.set_object_sequence_texture_animation(0, 1, "通常口パク")
		event.set_message_button_prompt(0, 0)
		event.open_message_window_2(0, 500010)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 15
		helper_888ab2a3(130)
		close_message(0)
		event.close_voice_stream(1)
		event.set_object_sequence_texture_animation(0, 0, "通常口パク")
		at = 16
		wait_objects(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(-555.36, 48.77, 420.75)
		event.set_camera_sequence_look_at(-439.22, 30.11, 269.93)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 40)
		event.add_object_sequence_path_point(0, -504.43, -0.17, 353.14)
		event.add_object_sequence_path_point(0, -456.02, -0.17, 290.98)
		event.add_object_sequence_path_point(0, -432.13, -0.17, 263.55)
		event.add_object_sequence_path_point(0, -394.89, -0.17, 226.72)
		event.start_object_sequence_path(0)
		at = 17
		wait_objects(0)
		event.set_camera_sequence_position(-258.12, 43.64, 195.63)
		event.set_camera_sequence_look_at(-309.59, 52.1, 75.71)
		event.set_object_handle_position(7, 0.0, -1000.0, 826.974)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_character_active(1, 11)
		event.set_object_sequence_position(1, -399.79, 36.97, -132.89)
		event.set_object_sequence_rotation(1, 0.0, 0.42, 0.0)
		event.jump_object_sequence(1, -282.94, -0.17, 139.36, -0.3, 30)
		event.set_object_sequence_motion(1, "飛び", 4)
		at = 18
		helper_888ab2a3(3)
		event.play_sound_effect(var1, 4)
		at = 19
		helper_888ab2a3(18)
		event.set_character_active(1, 15)
		event.set_character_position(15, -313.12, 60.82, 67.65)
		event.set_character_rotation(15, 0.0, 0.39, 0.0)
		event.set_character_motion(15, "割れ", 6)
		event.set_object_handle_visible(5, 0)
		at = 20
		wait_objects(1)
		event.set_camera_sequence_position(-410.63, 15.99, 277.48)
		event.set_camera_sequence_look_at(-459.98, 22.57, 269.05)
		event.set_object_handle_visible(17, 1)
		event.delay_object_sequence_texture_animation_track(0, 20)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_position(0, -478.12, -0.17, 293.36)
		event.set_object_sequence_rotation(0, 0.0, 2.09, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence_eased(0, -438.61, -0.17, 269.74, 20, 2, 1.0)
		event.set_object_sequence_motion(0, "止まる", 6)
		event.queue_object_sequence_next_motion(0, "止まるL", 4)
		event.open_voice_stream_wave(1, 500020)
		at = 21
		var0 = helper_f616ba9e(1)
		at = 22
		helper_888ab2a3(vm.i32(20 - var0))
		at = 23
		helper_888ab2a3(10)
		event.play_sound_effect(var1, 5)
		event.play_voice_stream(1)
		at = 24
		helper_888ab2a3(10)
		at = 25
		wait_objects(0)
		at = 26
		helper_888ab2a3(20)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(-505.04, 34.04, 374.96)
		event.set_camera_sequence_look_at(-456.55, 22.99, 297.9)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_character_active(1, 11)
		event.set_character_active(1, 12)
		event.set_character_active(1, 13)
		event.set_character_active(1, 14)
		event.play_sound_effect(var1, 6)
		event.set_object_sequence_position(1, -310.02, 28.2, 76.61)
		event.set_object_sequence_rotation(1, 0.0, 0.25, 0.0)
		event.jump_object_sequence(1, -287.81, -0.17, 136.28, -0.1, 10)
		event.rotate_object_sequence(1, 0.0, -0.83, 0.0, 10)
		event.set_object_sequence_motion(1, "着地", 6)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.set_object_sequence_position(2, -320.56, -0.17, 224.94)
		event.set_object_sequence_rotation(2, 0.0, -1.19, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_position(3, -590.45, -0.17, 410.34)
		event.set_object_sequence_rotation(3, 0.0, 2.28, 0.0)
		event.set_object_sequence_position(4, -534.81, -0.17, 411.26)
		event.set_object_sequence_rotation(4, 0.0, 2.53, 0.0)
		at = 27
		helper_888ab2a3(30)
		event.move_camera_sequence_angle_height_distance_eased(2.84, -5.37, 71.78, 40, 0, 1.0)
		at = 28
		helper_888ab2a3(20)
		event.set_object_sequence_motion(0, "振り返り1", 2)
		event.queue_object_sequence_next_motion(0, "振り返り1L", 4)
		at = 29
		helper_888ab2a3(4)
		event.play_sound_effect(var1, 7)
		event.open_voice_stream_wave(1, 500021)
		at = 30
		var0 = helper_f616ba9e(1)
		at = 31
		helper_888ab2a3(vm.i32(30 - var0))
		event.play_voice_stream(1)
		at = 32
		wait_objects(0)
		at = 33
		wait_camera()
		at = 34
		helper_888ab2a3(20)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(-440.29, 24.47, 235.66)
		event.set_camera_sequence_look_at(-439.17, 22.16, 264.83)
		event.set_object_sequence_rotation(0, 0.0, -1.15, 0.0)
		event.set_object_sequence_motion(0, "振り返り2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "2から身構え", 6)
		event.wait_object_sequence_motion_end(0)
		at = 35
		helper_888ab2a3(4)
		event.play_sound_effect(var1, 8)
		event.open_voice_stream_wave(1, 500032)
		at = 36
		helper_9cbdc640(1)
		at = 37
		wait_objects(0)
		event.set_camera_sequence_position(-481.43, 27.13, 301.91)
		event.set_camera_sequence_look_at(-425.22, 21.28, 264.03)
		event.play_voice_stream(1)
		event.play_sound_effect(var1, 10)
		event.set_object_sequence_rotation(0, 0.0, 2.37, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "構えL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "攻撃２", 6)
		event.delay_object_sequence_position_track(2, 6)
		event.move_object_sequence(2, -436.52, -0.17, 280.2, 20)
		at = 38
		helper_888ab2a3(4)
		event.set_object_sequence_motion(1, "攻撃２", 6)
		event.delay_object_sequence_position_track(1, 6)
		event.move_object_sequence(1, -423.21, -0.17, 254.95, 20)
		event.set_object_sequence_motion(0, "横飛び", 2)
		at = 39
		helper_888ab2a3(4)
		event.play_sound_effect(var1, 9)
		at = 40
		helper_888ab2a3(36)
		event.set_camera_sequence_position(-455.8, 119.67, 409.21)
		event.set_camera_sequence_look_at(-473.73, 21.28, 211.42)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_sequence_position(0, -500.6, 0.0, 175.97)
		event.set_object_sequence_rotation(0, 0.0, 1.0, 0.0)
		event.set_object_sequence_motion(0, "壁立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_position(1, -385.55, -0.17, 226.77)
		event.set_object_sequence_rotation(1, 0.0, -1.67, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_position(2, -408.67, -0.17, 288.74)
		event.set_object_sequence_rotation(2, 0.0, -2.39, 0.0)
		event.set_object_sequence_position(3, -470.36, -0.17, 321.58)
		event.set_object_sequence_rotation(3, 0.0, -3.04, 0.0)
		event.set_object_sequence_position(4, -531.85, -0.17, 295.06)
		event.set_object_sequence_rotation(4, 0.0, 2.77, 0.0)
		at = 41
		helper_888ab2a3(20)
		event.move_object_sequence(0, -486.59, 0.0, 162.88, 80)
		event.set_object_sequence_motion(0, "壁歩き", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.queue_object_sequence_next_motion(0, "像見る", 6)
		event.queue_object_sequence_next_motion(0, "像見るL", 4)
		at = 42
		helper_888ab2a3(30)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(-497.34, 28.69, 213.66)
		event.set_camera_sequence_look_at(-477.84, 8.8, 140.63)
		at = 43
		wait_objects(0)
		at = 44
		helper_888ab2a3(20)
		event.move_camera_sequence_eased(-497.34, 28.69, 213.66, -477.84, 34.1, 140.63, 20, 0, 0.4)
		event.set_object_sequence_motion(0, "像上見る", 6)
		event.queue_object_sequence_next_motion(0, "像上見るL", 4)
		at = 45
		wait_camera()
		at = 46
		helper_888ab2a3(20)
		event.set_camera_sequence_position(-418.89, 26.37, 155.17)
		event.set_camera_sequence_look_at(-478.71, 27.36, 152.48)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "左向き目パチ")
		event.set_object_sequence_motion(0, "像見戻り", 6)
		event.queue_object_sequence_next_motion(0, "像見るL", 4)
		at = 47
		helper_888ab2a3(20)
		event.set_camera_sequence_position(-468.82, 19.71, 169.71)
		event.set_camera_sequence_look_at(-415.85, 25.05, 200.94)
		event.play_sound_effect(var1, 11)
		event.set_object_sequence_motion(1, "攻撃２", 6)
		event.set_object_sequence_position(1, -389.81, -0.17, 218.14)
		event.set_object_sequence_rotation(1, 0.0, -2.15, 0.0)
		event.delay_object_sequence_position_track(1, 6)
		event.move_object_sequence(1, -423.64, -0.17, 198.07, 8)
		event.open_voice_stream_wave(1, 500034)
		at = 48
		var0 = helper_f616ba9e(1)
		at = 49
		helper_888ab2a3(vm.i32(14 - var0))
		event.set_camera_sequence_position(-418.89, 26.37, 155.17)
		event.set_camera_sequence_look_at(-478.71, 27.36, 152.48)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "左向き～前向き")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.delay_object_sequence_texture_animation_track(0, 10)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "前向き～右向き")
		event.delay_object_sequence_texture_animation_track(0, 10)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "右向き～左向き")
		event.set_object_sequence_position(0, -486.59, 0.0, 162.88)
		event.set_object_sequence_rotation(0, 0.0, 1.0, 0.0)
		event.set_object_sequence_motion(0, "剣飛び", 6)
		event.wait_object_sequence_motion_end(0)
		at = 50
		helper_888ab2a3(6)
		event.reset_object_sequence_motion(1)
		event.set_object_sequence_motion(1, "攻撃２", 6)
		event.set_object_sequence_position(1, -389.81, -0.17, 218.14)
		event.set_object_sequence_rotation(1, 0.0, -2.15, 0.0)
		event.delay_object_sequence_position_track(1, 6)
		event.move_object_sequence(1, -462.48, -0.17, 175.0, 20)
		at = 51
		helper_888ab2a3(2)
		event.play_sound_effect(var1, 12)
		at = 52
		helper_888ab2a3(4)
		event.play_voice_stream(1)
		at = 53
		helper_888ab2a3(12)
		event.rotate_object_sequence(5, 0.0, 0.0, -1.57, 10)
		at = 54
		wait_objects(0)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(-393.47, 16.73, 206.96)
		event.set_camera_sequence_look_at(-383.04, 20.81, 172.7)
		event.move_camera_sequence_eased(-397.16, 14.0, 219.08, -383.04, 20.81, 172.7, 60, 2, 1.0)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_character_active(10)
		event.set_object_sequence_position(0, -369.4, 0.0, 171.56)
		event.set_object_sequence_rotation(0, 0.0, -1.04, 0.0)
		event.set_object_sequence_motion(0, "起きあがり", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "起きあがりL", 4)
		at = 55
		helper_888ab2a3(6)
		event.play_sound_effect(var1, 13)
		at = 56
		wait_objects(0)
		at = 57
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		at = 58
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at == 21 then
			var0 = received[1] :: number
		end
		if at == 30 then
			var0 = received[1] :: number
		end
		if at == 48 then
			var0 = received[1] :: number
		end
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			helper_038a2e4d(4)
		end
		if at <= 3 then
			helper_238b5abc(6)
		end
		if at <= 4 then
			helper_238b5abc(7)
		end
		if at <= 5 then
			helper_238b5abc(8)
		end
		if at <= 6 then
			helper_038a2e4d(15)
		end
		if at <= 7 then
			helper_238b5abc(1)
		end
		if at <= 8 then
			helper_238b5abc(0)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_038a2e4d(90)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_038a2e4d(130)
		end
		if at <= 15 then
			helper_d16eef1e(0)
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_238b5abc(0)
		end
		if at <= 17 then
			helper_038a2e4d(3)
		end
		if at <= 18 then
			helper_038a2e4d(18)
		end
		if at <= 19 then
			helper_238b5abc(1)
		end
		if at <= 20 then
			var0 = helper_523109b8(1)
		end
		if at <= 21 then
			helper_038a2e4d(vm.i32(20 - var0))
		end
		if at <= 22 then
			helper_038a2e4d(10)
		end
		if at <= 23 then
			helper_038a2e4d(10)
		end
		if at <= 24 then
			helper_238b5abc(0)
		end
		if at <= 25 then
			helper_038a2e4d(20)
		end
		if at <= 26 then
			helper_038a2e4d(30)
		end
		if at <= 27 then
			helper_038a2e4d(20)
		end
		if at <= 28 then
			helper_038a2e4d(4)
		end
		if at <= 29 then
			var0 = helper_523109b8(1)
		end
		if at <= 30 then
			helper_038a2e4d(vm.i32(30 - var0))
		end
		if at <= 31 then
			helper_238b5abc(0)
		end
		if at <= 32 then
			helper_344d6cd8()
		end
		if at <= 33 then
			helper_038a2e4d(20)
		end
		if at <= 34 then
			helper_038a2e4d(4)
		end
		if at <= 35 then
			helper_238b5abc(1)
		end
		if at <= 36 then
			helper_238b5abc(0)
		end
		if at <= 37 then
			helper_038a2e4d(4)
		end
		if at <= 38 then
			helper_038a2e4d(4)
		end
		if at <= 39 then
			helper_038a2e4d(36)
		end
		if at <= 40 then
			helper_038a2e4d(20)
		end
		if at <= 41 then
			helper_038a2e4d(30)
		end
		if at <= 42 then
			helper_238b5abc(0)
		end
		if at <= 43 then
			helper_038a2e4d(20)
		end
		if at <= 44 then
			helper_344d6cd8()
		end
		if at <= 45 then
			helper_038a2e4d(20)
		end
		if at <= 46 then
			helper_038a2e4d(20)
		end
		if at <= 47 then
			var0 = helper_523109b8(1)
		end
		if at <= 48 then
			helper_038a2e4d(vm.i32(14 - var0))
		end
		if at <= 49 then
			helper_038a2e4d(6)
		end
		if at <= 50 then
			helper_038a2e4d(2)
		end
		if at <= 51 then
			helper_038a2e4d(4)
		end
		if at <= 52 then
			helper_038a2e4d(12)
		end
		if at <= 53 then
			helper_238b5abc(0)
		end
		if at <= 54 then
			helper_038a2e4d(6)
		end
		if at <= 55 then
			helper_238b5abc(0)
		end
		if at <= 56 then
			helper_038a2e4d(30)
		end
		if at <= 57 then
			helper_038a2e4d(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.play_music(0)
	event.set_object_handle_scale(0, 1.0, 1.0, 1.0)
	event.set_object_handle_visible(13, 0)
	event.set_object_handle_visible(18, 0)
	event.set_object_handle_visible(8, 0)
	event.set_object_handle_position(7, 0.0, -1000.0, 826.974)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_scene_status_flags(1, 8, 256, 0)
	event.set_scene_status_flags(1, 8, 512, 0)
	event.set_object_handle_visible(5, 0)
	event.set_object_handle_visible(17, 1)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, 1, "通常目パチ")
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_visible(9, 1)
	event.set_object_handle_visible(10, 1)
	event.set_character_active(1, 0)
	event.stop_sound_effect(var1, 4)
	event.stop_sound_effect(var1, 5)
	event.stop_sound_effect(var1, 6)
	event.stop_sound_effect(var1, 7)
	event.stop_sound_effect(var1, 8)
	event.stop_sound_effect(var1, 9)
	event.stop_sound_effect(var1, 10)
	event.stop_sound_effect(var1, 11)
	event.stop_sound_effect(var1, 12)
	event.stop_sound_effect(var1, 13)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	helper_9dafbc83(vm.f32(-255.23), vm.f32(-0.17), vm.f32(130.23), vm.f32(-1.01))
	event.set_camera_position(-136.84, 51.17, 55.65)
	event.set_camera_look_at(-255.23, 29.83, 130.23)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Helper function.
local function helper_18074()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		var0 = event.load_sound_effect_file_2(802) or var0
		event.set_scene_status_flags(1, 0, 256, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e00/e50/")
		event.load_message_file(0, 5, "e50.txt")
		event.load_character_motion_pack(5, "e50_monica.gltf", "info", 0)
		event.load_character_motion_pack(5, "e50_monica2.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e50_guiltoni.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_object_handle_to_character(2, 18)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e50_timegate_f.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.load_character(5, "e50_ou.gltf", "info", 13)
		event.set_character_active(1, 13)
		event.change_directory("")
		event.load_character(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(7, 9)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 7)
		event.load_equipment_model(5, 1, 0, "info", 0, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(1, 12)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_character(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.attach_object_handle_to_map_part_2(3, "p10_s5102-0")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_2(4, "p10_s5102-1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_position(0, -494.38, -0.17, 247.95)
		event.set_object_handle_rotation(0, 0.0, 2.01, 0.0)
		event.set_object_handle_motion(0, "走り", 4)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(2, 0.0, 0.0, -250.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_sound_bank(2, var0)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_rotation(3, 0.0, -0.2, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.2, 0.0)
		event.set_object_handle_position(7, 0.0, 30.0, -300.0)
		event.set_character_position(11, 0.0, 30.0, -300.0)
		event.set_character_position(13, 18.0, 0.0, -220.0)
		event.set_character_rotation(13, 0.0, -1.57, 0.0)
		event.set_character_motion(13, "倒れ", 4)
		event.enable_drama_skip()
		event.move_object_sequence(0, -368.53, -0.17, 185.7, 50)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-467.79, 15.29, 271.35)
		event.set_camera_sequence_look_at(-445.52, 25.45, 209.11)
		event.fade_in_screen(30)
		at = 2
		wait_objects(0)
		event.set_camera_sequence_position(-134.51, 100.78, 136.35)
		event.set_camera_sequence_look_at(-54.64, 52.81, 37.61)
		event.set_object_sequence_position(0, -117.35, -0.17, 66.54)
		event.move_object_sequence(0, -9.29, -0.17, 0.77, 30)
		event.delay_object_sequence_rotation_track(0, 22)
		event.rotate_object_sequence(0, 0.0, 0.12, 0.0, 8)
		event.delay_object_sequence_motion_track(0, 28)
		event.set_object_sequence_motion(0, "壁立ち")
		at = 3
		helper_888ab2a3(10)
		event.set_object_handle_footstep_sound(0, 2)
		at = 4
		helper_888ab2a3(12)
		event.play_sound_effect(var0, 14)
		at = 5
		wait_objects(0)
		at = 6
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "像見る", 2)
		event.queue_object_sequence_next_motion(0, "像見るL", 4)
		at = 7
		helper_888ab2a3(40)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_camera_sequence_position(-95.58, 18.43, -157.01)
		event.set_camera_sequence_look_at(0.23, 35.57, -22.29)
		event.play_sound_effect(var0, 15)
		event.rotate_object_sequence(3, 0.0, -1.8, 0.0, 16)
		event.rotate_object_sequence_eased(3, 0.0, -1.7, 0.0, 20, 2, 1.0)
		event.rotate_object_sequence(4, 0.0, 1.8, 0.0, 16)
		event.rotate_object_sequence_eased(4, 0.0, 1.7, 0.0, 20, 2, 1.0)
		event.set_object_sequence_position(0, 0.0, -0.17, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "あたりドア開け", 6)
		event.queue_object_sequence_next_motion(0, "構え", 4)
		at = 8
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-12.11, 17.82, -20.43)
		event.set_camera_sequence_look_at(1.71, 21.68, 0.96)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_motion(0, "ショック", 6)
		event.queue_object_sequence_next_motion(0, "ショックL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 9
		helper_0382f327(500045, 100)
		event.set_camera_sequence_position(0.0, 20.0, -80.0)
		event.set_camera_sequence_look_at(0.0, 20.0, -160.0)
		event.move_camera_sequence(0.0, 20.0, -120.0, 0.0, 20.0, -200.0, 120.0)
		at = 10
		wait_camera()
		event.start_crossfade(40)
		event.set_camera_sequence_position(0.0, 30.0, -210.0)
		event.set_camera_sequence_look_at(0.0, 30.0, -245.0)
		event.move_camera_sequence_angle_height_distance_eased(-1.2, 0.0, 35.0, 90, 0, 1.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ショック顔")
		event.set_object_sequence_texture_animation(0, 1, "ショック目パチ")
		event.set_object_sequence_motion(0, "立ちN", 4, -1.0, 1)
		event.play_sound_effect(var0, 17)
		event.set_object_sequence_motion(2, "振り返り", 6)
		event.queue_object_sequence_next_motion(2, "振り返りL", 4)
		at = 11
		wait_objects(2)
		event.open_voice_stream_wave(1, 500050)
		at = 12
		helper_888ab2a3(40)
		at = 13
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		at = 14
		wait_camera()
		event.set_camera_sequence_position(0.0, 30.0, -210.0)
		event.set_camera_sequence_look_at(0.0, 30.0, -290.0)
		event.move_camera_sequence_eased(0.0, 20.0, -160.0, 0.0, 20.0, -280.0, 120, 0, 0.4)
		event.play_sound_effect(var0, 18)
		event.set_object_sequence_motion(2, "振り返り戻り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		at = 15
		wait_objects(2)
		event.play_sound_effect(var0, 19)
		event.set_character_active(1, 11)
		event.set_character_motion(11, "発生", 6)
		at = 16
		helper_888ab2a3(10)
		event.set_character_active(1, 9)
		event.set_character_visible(9, 1, 1, 0.1)
		at = 17
		helper_888ab2a3(30)
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, 0.0, 0.0, -300.0, 60)
		at = 18
		helper_888ab2a3(30)
		event.set_character_visible(18, 0, 1, 0.033333335)
		at = 19
		helper_888ab2a3(30)
		event.set_character_visible(9, 0, 1, 0.05)
		var1 = 1.0
		var2 = vm.f32(0.01)
		var3 = vm.f32(-0.002)
		var4 = 0
		while var4 < 20 do
			var1 = vm.f32(var1 + var2)
			var2 = vm.f32(var2 + var3)
			event.set_character_scale(9, var1, var1, var1)
			var4 = var4 + 1
			at = 20
			vm.wait(20)
		end
		at = 21
		helper_888ab2a3(30)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(0.0, 23.0, -34.0)
		event.set_camera_sequence_look_at(0.0, 23.0, 0.0)
		event.move_camera_sequence_eased(0.0, 23.0, -24.0, 0.0, 23.0, 0.0, 60, 2, 1.0)
		at = 22
		wait_camera()
		at = 23
		helper_888ab2a3(20)
		event.set_camera_sequence_position(0.0, 23.0, -297.58)
		event.set_camera_sequence_look_at(0.0, 23.0, -273.58)
		event.play_sound_effect(var0, 20)
		event.detach_character_from_frame(12)
		event.set_object_sequence_position(1, 10.0, 8.0, 0.0)
		event.set_object_sequence_rotation(1, 0.4, 2.88, 0.0)
		event.move_object_sequence(1, 10.0, 1.0, 0.0, 10)
		event.rotate_object_sequence(1, 0.0, 2.88, 0.0, 8)
		event.rotate_object_sequence(1, 0.0, 2.88, 0.3, 6)
		event.rotate_object_sequence(1, 0.0, 2.88, -0.2, 4)
		event.rotate_object_sequence(1, 0.0, 2.88, 0.1, 3)
		event.rotate_object_sequence(1, 0.0, 2.88, -0.05, 2)
		event.rotate_object_sequence(1, 0.0, 2.88, 0.0, 2)
		at = 24
		wait_objects(1)
		at = 25
		helper_888ab2a3(40)
		event.set_object_sequence_motion(0, "ヨロあるき")
		event.set_object_sequence_motion_blend_step(0, 0.05)
		event.move_object_sequence(0, 0.0, -0.17, -80.0, 120)
		at = 26
		helper_888ab2a3(90)
		event.fade_out_screen(30)
		at = 27
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_238b5abc(0)
		end
		if at <= 2 then
			helper_038a2e4d(10)
		end
		if at <= 3 then
			helper_038a2e4d(12)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_038a2e4d(10)
		end
		if at <= 6 then
			helper_038a2e4d(40)
		end
		if at <= 7 then
			helper_038a2e4d(30)
		end
		if at <= 8 then
			helper_53ffe901(500045, 100)
		end
		if at <= 9 then
			helper_344d6cd8()
		end
		if at <= 10 then
			helper_238b5abc(2)
		end
		if at <= 11 then
			helper_038a2e4d(40)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_344d6cd8()
		end
		if at <= 14 then
			helper_238b5abc(2)
		end
		if at <= 15 then
			helper_038a2e4d(10)
		end
		if at <= 16 then
			helper_038a2e4d(30)
		end
		if at <= 17 then
			helper_038a2e4d(30)
		end
		if at <= 18 then
			helper_038a2e4d(30)
		end
		if at <= 19 then
			var1 = 1.0
			var2 = vm.f32(0.01)
			var3 = vm.f32(-0.002)
			var4 = 0
			var1 = vm.f32(var1 + var2)
			var2 = vm.f32(var2 + var3)
			local _ = var4 < 20
			var4 = var4 + 1
		end
		if at <= 20 then
			helper_038a2e4d(30)
		end
		if at <= 21 then
			helper_344d6cd8()
		end
		if at <= 22 then
			helper_038a2e4d(20)
		end
		if at <= 23 then
			helper_238b5abc(1)
		end
		if at <= 24 then
			helper_038a2e4d(40)
		end
		if at <= 25 then
			helper_038a2e4d(90)
		end
		if at <= 26 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 28
	vm.entry(28)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, 1, "通常目パチ")
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_visible(5, 1)
	event.set_object_handle_visible(6, 1)
	event.stop_sound_effect(var0, 14)
	event.stop_sound_effect(var0, 15)
	event.stop_sound_effect(var0, 16)
	event.stop_sound_effect(var0, 17)
	event.stop_sound_effect(var0, 18)
	event.stop_sound_effect(var0, 19)
	event.stop_sound_effect(var0, 20)
	event.delete_character_extension_packs(0)
	event.delete_character(18)
	event.delete_character(9)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_ff10()
	event.load_dungeon_monster(523, 1)
	event.place_dungeon_monster(523, -382.5, -0.2, 120.2, 0.0, 1.61, 0.0)
	event.place_dungeon_monster(523, -428.0, -0.2, 202.7, 0.0, 1.71, 0.0)
	event.place_dungeon_monster(523, -452.5, -0.2, 287.0, 0.0, 1.98, 0.0)
	event.place_dungeon_monster(523, -324.2, -0.2, 260.5, 0.0, 2.34, 0.0)
	vm.wait(2)
	event.set_dungeon_pause_flags(16385, 1)
	event.fade_in_screen(20)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"(O)ボタン・・・攻撃\n[r1]ボタン・・・ガード\n(X)ボタン・・・ロックオン\n[l1]＋(O)ボタン・・・魔法"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		event.clear_event_battle_monsters(-1)
		at = 2
		helper_18074()
		event.give_monica_starting_equipment(1)
		event.set_playable_character(0)
		event.set_party_member(0, 1)
		event.set_party_member(1, 0)
		event.add_inventory_item(353)
		event.add_inventory_item(311)
		event.add_inventory_item(268, 5)
		event.add_inventory_item(294, 3)
		event.add_inventory_item(298, 3)
		event.add_inventory_item(425, 3)
		event.add_inventory_item(275, 2)
		event.set_save_flag(54, 1)
		event.skip_next_music_load()
		event.go_to_georama_edit(19, 151)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_18074()
				return vm.continue_with(function()
					event.give_monica_starting_equipment(1)
					event.set_playable_character(0)
					event.set_party_member(0, 1)
					event.set_party_member(1, 0)
					event.add_inventory_item(353)
					event.add_inventory_item(311)
					event.add_inventory_item(268, 5)
					event.add_inventory_item(294, 3)
					event.add_inventory_item(298, 3)
					event.add_inventory_item(425, 3)
					event.add_inventory_item(275, 2)
					event.set_save_flag(54, 1)
					event.skip_next_music_load()
					event.go_to_georama_edit(19, 151)
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

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_786b79f1(0)
end

--- Event 10500, which map data, a script or the engine runs by number.
function script.event_10500()
	event.add_inventory_item(110)
	event.add_inventory_item(127)
	event.add_inventory_item(133)
	event.add_inventory_item(266)
	event.equip_character_item(1, 110)
	event.equip_character_item(1, 127)
	event.equip_character_item(1, 133)
	event.equip_character_item(1, 266)
	event.switch_dungeon_main_character(1)
	helper_ff10()
	event.set_dungeon_pause_flags(16384, 1)
	event.load_dungeon_monster(523, 1)
	event.place_dungeon_monster(523, -382.5, -0.2, 120.2, 0.0, 1.61, 0.0)
	event.place_dungeon_monster(523, -428.0, -0.2, 202.7, 0.0, 1.71, 0.0)
	event.place_dungeon_monster(523, -452.5, -0.2, 287.0, 0.0, 1.98, 0.0)
	event.place_dungeon_monster(523, -324.2, -0.2, 260.5, 0.0, 2.34, 0.0)
	vm.wait(2)
	event.fade_in_screen(20)
	event.finish_event()
end

return script
