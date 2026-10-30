--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_523109b8 = require("@lib/event/helper_523109b8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_705b02bc = require("@lib/event/helper_705b02bc")
local helper_917013c0 = require("@lib/event/helper_917013c0")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f616ba9e = require("@lib/event/helper_f616ba9e")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_1b215860()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.delete_character(9)
		event.delete_character(10)
		event.delete_character(11)
		event.delete_character(12)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
		event.delete_character(16)
		event.delete_character(17)
		event.delete_character(18)
		event.delete_character(19)
		event.delete_character(20)
		event.delete_character(8)
		event.set_message_window_mode(0, 7)
		event.load_music(106)
		event.play_music(0)
		event.load_map_sounds(1216)
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p4/op4ch1_1.txt")
		var1 = event.load_sound_effect_file_2(1216) or var1
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 548.18, 133.45, -204.55)
		event.set_object_sequence_rotation(0, 0.0, -2.64, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 0)
		event.attach_object_handle_to_character(21, 2)
		event.set_object_handle_visible(21, 0)
		event.load_character(5, "event/opening/p4/buranko.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "待機", 4)
		event.load_character(5, "event/opening/p4/light.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_frame_visible(2, "kusari", 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "待機", 4)
		event.load_character(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, var1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 728.98, 133.45, 91.56)
		event.set_object_sequence_rotation(3, 0.0, -2.52, 0.0)
		event.copy_character(5, 11, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.set_object_handle_sound_bank(4, var1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 772.23, 133.45, 85.26)
		event.set_object_sequence_rotation(4, 0.0, -2.52, 0.0)
		event.copy_character(5, 11, 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_sound_bank(5, var1)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 737.7, 133.45, 178.69)
		event.set_object_sequence_rotation(5, 0.0, -2.52, 0.0)
		event.copy_character(5, 11, 14)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character_frame(7, 10, "light_rot")
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.rotate_object_sequence(7, 0.01, 0.0, 0.0, -1)
		event.load_character(5, "event/opening/p4/p4_people.gltf", "info", 15)
		event.set_character_active(15)
		event.set_character_position(15, 0.0, 0.0, -405.0)
		event.set_scene_status_flags(1, 15, 8, 1)
		event.load_character(5, "event/opening/p4/up_kusari.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_character_to_frame(10, "up_kusari", 18)
		event.load_character(5, "event/opening/p4/shuchusen.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(6, 8)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.attach_object_handle_to_map_part_2(30, "p21_i03h02")
		event.set_object_handle_visible(30, 0)
		event.assign_memory_stack(6)
		event.clear_memory_stack(6)
		event.load_character_motion_pack(6, "event/opening/p4/p4_mints1.gltf", "info", 0)
		event.start_background_file_loads_1("event/opening/p4/p4_pierrot1.gltf")
		at = 2
		vm.wait(2)
		at = 3
		helper_479dc9e9()
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot1.gltf", "info", 11)
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot1.gltf", "info", 12)
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot1.gltf", "info", 13)
		event.open_voice_stream_wave(1, 40010)
		at = 4
		helper_9cbdc640(1)
		event.set_object_sequence_motion(0, "走り", 6)
		event.wait_object_sequence_motion_end(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "走り", 6)
		event.queue_object_sequence_next_motion(0, "おっとっと", 6)
		event.wait_object_sequence_motion_end(0)
		event.move_object_sequence(0, 452.01, 133.45, -365.64, 50)
		event.set_object_sequence_motion(3, "走り", 4)
		event.move_object_sequence(3, 464.87, 133.45, -344.58, 125)
		event.set_object_sequence_motion(4, "走り", 4)
		event.set_object_sequence_motion_time(4, 6.0)
		event.move_object_sequence(4, 486.28, 133.45, -397.17, 160)
		event.set_object_sequence_motion(5, "走り", 4)
		event.set_object_sequence_motion_time(5, 12.0)
		event.move_object_sequence(5, 428.16, 133.45, -335.04, 180)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(547.06, 213.33, -103.4)
		event.set_camera_sequence_look_at(534.68, 170.7, -203.08)
		event.move_camera_sequence(537.57, 209.13, -119.23, 500.76, 170.7, -269.77, 45)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		at = 5
		wait_frames(50)
		event.set_camera_sequence_position(426.81, 155.31, -411.47)
		event.set_camera_sequence_look_at(456.18, 150.65, -363.99)
		event.set_object_sequence_texture_animation(0, 1, "驚き（１）")
		event.set_object_sequence_texture_animation(0, 1, "大きな口（１）")
		event.play_voice_stream(1)
		event.open_message_window_2(0, 40010)
		open_message(0, -1, 8, 0, 0)
		at = 6
		helper_917013c0(0, 30)
		close_message(0)
		at = 7
		wait_objects(0)
		event.close_voice_stream(1)
		event.set_object_sequence_motion(0, "振り返る", 6)
		event.wait_object_sequence_motion_end(0)
		event.delay_object_sequence_texture_animation_track(0, 20)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "だっしゅ！！（１）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口（１）")
		at = 8
		wait_objects(0)
		event.set_camera_sequence_position(283.78, 126.6, -281.55)
		event.set_camera_sequence_look_at(445.98, 163.55, -447.12)
		event.set_object_sequence_position(0, 34.0, 0.0, -42.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "飛ぶ", 6)
		event.queue_object_sequence_next_motion(0, "ぶらさがりL", 4)
		event.play_object_sequence_sound(0, var1, 8)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, var1, 9)
		at = 9
		wait_objects(3)
		event.set_object_sequence_motion(3, "落ちる", 6)
		event.delay_object_sequence_sound_track(3, 10)
		event.play_object_sequence_sound(3, var1, 10)
		at = 10
		wait_objects(4)
		event.set_object_sequence_motion(4, "立ち")
		at = 11
		wait_objects(5)
		event.set_object_sequence_motion(5, "立ち")
		at = 12
		wait_frames(10)
		event.set_camera_sequence_position(312.69, 142.84, -492.3)
		event.set_camera_sequence_look_at(387.96, 148.13, -434.53)
		event.set_object_sequence_position(0, 373.67, 133.45, -445.03)
		event.set_object_sequence_rotation(0, 0.0, -2.28, 0.0)
		event.set_object_sequence_motion(0, "よじのぼり", 6)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		event.play_object_sequence_sound(0, var1, 11)
		at = 13
		wait_objects(0)
		at = 14
		wait_frames(4)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 342.75, 133.45, -468.75, 15)
		at = 15
		wait_objects(0)
		event.set_camera_sequence_position(0.0, 164.0, -140.0)
		event.set_camera_sequence_look_at(10.0, 164.0, -352.47)
		event.move_camera_sequence(0.0, 164.0, -140.0, -10.0, 164.0, -352.47, 155)
		event.set_object_sequence_motion(0, "走り", 4)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 110)
		event.add_object_sequence_path_point(0, 216.54, 133.45, -548.56)
		event.add_object_sequence_path_point(0, 182.72, 133.45, -564.69)
		event.add_object_sequence_path_point(0, -0.73, 133.45, -590.33)
		event.add_object_sequence_path_point(0, -190.24, 133.45, -560.44)
		event.add_object_sequence_path_point(0, -232.51, 133.45, -532.93)
		event.start_object_sequence_path(0)
		at = 16
		wait_frames(30)
		event.set_object_sequence_motion(3, "走り", 4)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 110)
		event.add_object_sequence_path_point(3, 235.84, 133.45, -501.84)
		event.add_object_sequence_path_point(3, 174.96, 133.45, -531.08)
		event.add_object_sequence_path_point(3, 10.05, 133.45, -560.78)
		event.add_object_sequence_path_point(3, -179.09, 133.45, -536.68)
		event.add_object_sequence_path_point(3, -227.25, 133.45, -513.05)
		event.start_object_sequence_path(3)
		at = 17
		wait_frames(15)
		event.set_object_sequence_motion(4, "走り", 4)
		event.set_object_sequence_motion_time(4, 12.0)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 110)
		event.add_object_sequence_path_point(4, 248.7, 135.36, -572.26)
		event.add_object_sequence_path_point(4, 200.97, 135.36, -594.75)
		event.add_object_sequence_path_point(4, 19.57, 135.36, -627.45)
		event.add_object_sequence_path_point(4, -183.63, 135.36, -599.12)
		event.add_object_sequence_path_point(4, -243.31, 135.36, -569.25)
		event.start_object_sequence_path(4)
		at = 18
		wait_objects(0)
		at = 19
		wait_objects(3)
		at = 20
		wait_objects(4)
		event.set_camera_sequence_position(-76.14, 200.79, -552.98)
		event.set_camera_sequence_look_at(-244.03, 164.0, -536.48)
		event.move_camera_sequence(-86.73, 200.79, -548.01, -281.45, 164.0, -521.18, 43)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, -77.37, 133.45, -569.47)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, -108.56, 133.45, -613.85)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 80)
		event.add_object_sequence_path_point(0, -207.41, 133.45, -545.84)
		event.add_object_sequence_path_point(0, -362.81, 133.45, -457.15)
		event.add_object_sequence_path_point(0, -455.6, 133.45, -366.11)
		event.add_object_sequence_path_point(0, -496.87, 133.45, -294.54)
		event.start_object_sequence_path(0)
		event.set_object_sequence_motion(0, "走り", 6)
		event.wait_object_sequence_motion_end(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "飛ぶ2", 6)
		event.queue_object_sequence_next_motion(0, "走り", 4)
		event.delay_object_sequence_sound_track(0, 40)
		event.play_object_sequence_sound(0, var1, 12)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 120)
		event.add_object_sequence_path_point(3, -77.37, 133.45, -569.47)
		event.add_object_sequence_path_point(3, -204.83, 133.45, -519.56)
		event.add_object_sequence_path_point(3, -351.11, 133.45, -436.61)
		event.add_object_sequence_path_point(3, -436.92, 133.45, -351.79)
		event.add_object_sequence_path_point(3, -474.71, 133.45, -285.13)
		event.start_object_sequence_path(3)
		event.set_object_sequence_motion(3, "走り", 6)
		event.wait_object_sequence_motion_end(3)
		event.reset_object_sequence_motion(3)
		event.set_object_sequence_motion(3, "走り", 6)
		event.wait_object_sequence_motion_end(3)
		event.reset_object_sequence_motion(3)
		event.set_object_sequence_motion(3, "走り", 6)
		event.queue_object_sequence_next_motion(3, "飛ぶ", 6)
		event.queue_object_sequence_next_motion(3, "走り", 4)
		event.delay_object_sequence_sound_track(3, 72)
		event.play_object_sequence_sound(3, var1, 12)
		at = 21
		wait_frames(8)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 120)
		event.add_object_sequence_path_point(4, -108.56, 133.45, -613.85)
		event.add_object_sequence_path_point(4, -245.28, 133.45, -564.91)
		event.add_object_sequence_path_point(4, -378.72, 133.45, -485.4)
		event.add_object_sequence_path_point(4, -481.13, 133.45, -385.99)
		event.add_object_sequence_path_point(4, -521.02, 133.45, -316.93)
		event.start_object_sequence_path(4)
		event.set_object_sequence_motion(4, "走り", 6)
		event.wait_object_sequence_motion_end(4)
		event.reset_object_sequence_motion(4)
		event.set_object_sequence_motion(4, "走り", 6)
		event.wait_object_sequence_motion_end(4)
		event.reset_object_sequence_motion(4)
		event.set_object_sequence_motion(4, "走り", 6)
		event.queue_object_sequence_next_motion(4, "飛ぶ", 6)
		event.queue_object_sequence_next_motion(4, "走り", 4)
		event.delay_object_sequence_sound_track(4, 72)
		event.play_object_sequence_sound(4, var1, 12)
		at = 22
		wait_frames(20)
		var0 = 0
		at = 23
		wait_frames(15 - var0)
		event.set_camera_sequence_position(-253.07, 137.49, -256.64)
		event.set_camera_sequence_look_at(-383.77, 149.38, -384.26)
		at = 24
		wait_objects(0)
		at = 25
		wait_objects(3)
		at = 26
		wait_objects(4)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_camera_sequence_position(-624.63, 203.17, -154.88)
		event.set_camera_sequence_look_at(-576.54, 149.38, 113.64)
		event.set_object_sequence_position(0, -583.25, 133.45, -101.95)
		event.set_object_sequence_rotation(0, 0.0, 0.07, 0.0)
		event.move_object_sequence(0, -577.83, 133.45, 14.04, 30)
		event.set_object_sequence_motion(0, "走り", 6)
		event.set_object_sequence_motion_time(0, 10.0)
		event.wait_object_sequence_motion_end(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "走り", 6)
		event.queue_object_sequence_next_motion(0, "ストップ", 6)
		event.queue_object_sequence_next_motion(0, "ストップL", 6)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "出現", 6)
		event.queue_object_sequence_next_motion(5, "出現L", 4)
		event.play_object_sequence_sound(5, var1, 13)
		event.delay_object_sequence_sound_track(5, 50)
		event.play_object_sequence_sound(5, var1, 14)
		at = 27
		wait_frames(20)
		at = 28
		wait_objects(0)
		event.set_camera_sequence_position(-564.24, 148.01, 41.12)
		event.set_camera_sequence_look_at(-579.7, 154.29, 16.45)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目")
		event.set_object_sequence_texture_animation(0, 1, "口パク小")
		at = 29
		wait_frames(30)
		event.set_camera_sequence_position(-567.19, 160.39, 76.35)
		event.set_camera_sequence_look_at(-562.84, 160.91, 93.75)
		event.move_camera_sequence(-570.96, 160.39, 77.29, -566.61, 160.91, 94.69, 45)
		event.set_object_sequence_motion(5, "かまえ立ち", 4, 0.05)
		event.set_object_sequence_position(5, -570.67, 133.45, 93.71)
		event.set_object_sequence_rotation(5, 0.0, -2.88, 0.0)
		at = 30
		wait_camera()
		at = 31
		wait_frames(15)
		event.set_camera_sequence_position(-476.38, 153.26, 55.85)
		event.set_camera_sequence_look_at(-580.21, 159.97, 82.18)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "vsピエロ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "vsピエロ（１）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口（１）")
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, var1, 15)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, var1, 16)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "vsピエロ", 6)
		at = 32
		wait_frames(45)
		event.set_camera_sequence_position(-552.26, 154.78, 179.33)
		event.set_camera_sequence_look_at(-572.64, 133.7, 67.83)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "あ！！（１）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口（１）")
		event.set_object_sequence_motion(3, "走り", 4)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 130)
		event.add_object_sequence_path_point(3, -505.19, 133.45, -266.75)
		event.add_object_sequence_path_point(3, -525.23, 133.45, -172.98)
		event.add_object_sequence_path_point(3, -544.18, 133.45, -7.69)
		event.add_object_sequence_path_point(3, -510.83, 133.45, 98.05)
		event.start_object_sequence_path(3)
		event.set_object_sequence_motion(4, "走り", 4)
		event.set_object_sequence_motion_time(4, 12.0)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 150)
		event.add_object_sequence_path_point(4, -521.02, 133.45, -316.93)
		event.add_object_sequence_path_point(4, -550.86, 133.45, -178.43)
		event.add_object_sequence_path_point(4, -548.36, 133.45, -1.85)
		event.add_object_sequence_path_point(4, -527.93, 133.45, 69.26)
		event.start_object_sequence_path(4)
		at = 33
		wait_frames(30)
		event.move_camera_sequence(-574.0, 156.97, 179.02, -487.34, 166.42, 108.67, 60)
		at = 34
		wait_frames(20)
		at = 35
		wait_camera()
		at = 36
		wait_frames(30)
		event.set_object_sequence_motion(3, "立ち")
		event.set_object_sequence_motion(4, "立ち")
		event.set_camera_sequence_position(-524.03, 172.04, -43.4)
		event.set_camera_sequence_look_at(-445.68, 174.18, 59.09)
		event.move_camera_sequence(-524.03, 172.04, -43.4, -415.83, 184.9, 28.66, 60)
		at = 37
		wait_objects(0)
		at = 38
		wait_camera()
		event.set_camera_sequence_position(-403.56, 235.67, 109.42)
		event.set_camera_sequence_look_at(-352.18, 211.03, 18.75)
		event.start_background_file_loads_2("event/opening/p4/p4_mints2.gltf", "event/opening/p4/p4_pierrot2.gltf")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ブランコ前（１）")
		event.set_object_sequence_texture_animation(0, 1, "口パク横大（１）")
		event.set_object_sequence_position(0, -374.25, 184.32, 26.34)
		event.set_object_sequence_rotation(0, 0.0, 2.0, 0.0)
		event.move_object_sequence(0, -328.72, 184.32, 6.44, 18)
		event.set_object_sequence_motion(0, "走り2", 6)
		event.queue_object_sequence_next_motion(0, "後ろを見る", 2)
		event.queue_object_sequence_next_motion(0, "後ろを見るL", 4)
		at = 39
		wait_objects(0)
		at = 40
		helper_479dc9e9()
		event.delete_character_extension_packs(0)
		event.clear_memory_stack(6)
		event.load_character_motion_pack(6, "event/opening/p4/p4_mints2.gltf", "info", 0)
		event.delete_character_extension_packs(11)
		event.delete_character_extension_packs(12)
		event.delete_character_extension_packs(13)
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot2.gltf", "info", 11)
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot2.gltf", "info", 12)
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot2.gltf", "info", 13)
		event.set_camera_sequence_position(-341.49, 223.49, -20.69)
		event.set_camera_sequence_look_at(-385.73, 190.51, 33.94)
		event.set_object_sequence_position(3, -402.0, 159.7, 49.66)
		event.set_object_sequence_rotation(3, 0.0, 2.14, 0.0)
		event.set_object_sequence_motion(3, "立ち上がり", 6)
		event.set_object_sequence_position(4, -482.22, 134.65, 113.65)
		event.set_object_sequence_rotation(4, 0.0, 2.14, 0.0)
		event.move_object_sequence(4, -445.32, 147.11, 83.57, 30)
		event.set_object_sequence_motion(4, "綱渡り", 4)
		at = 41
		wait_frames(30)
		event.set_camera_sequence_position(-403.56, 235.67, 109.42)
		event.set_camera_sequence_look_at(-352.18, 211.03, 18.75)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "ブランコを取る", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_motion(1, "ブランコを取る", 6)
		at = 42
		wait_frames(20)
		at = 43
		wait_objects(0)
		event.set_camera_sequence_position(-267.74, 231.08, 97.99)
		event.set_camera_sequence_look_at(-305.0, 211.03, 3.73)
		event.play_object_sequence_sound(0, var1, 17)
		event.set_object_sequence_motion(0, "空中ブランコ", 6)
		event.set_object_sequence_motion(1, "空中ブランコ", 6)
		event.move_camera_sequence(-86.05, 232.08, 330.06, -180.81, 158.06, -26.95, 60)
		at = 44
		wait_frames(24)
		event.open_voice_stream_wave(1, 40030)
		at = 45
		helper_9cbdc640(1)
		at = 46
		wait_camera()
		event.play_object_sequence_sound(0, var1, 28)
		event.set_object_sequence_position(3, 0.0, -1000.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "かまえ立ち", 4)
		event.set_object_sequence_position(4, 0.0, -1000.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "かまえ立ち", 4)
		event.set_object_sequence_motion_time(0, 16.0)
		event.set_object_sequence_motion_time(1, 16.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "空中（２）")
		event.set_object_sequence_texture_animation(0, 1, "大口（２）")
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 0.0, 0.0, 0.0, 40.0, "bcol00", 2)
		event.delay_camera_sequence_angle_track(40)
		event.release_camera_sequence_follow_object()
		event.play_voice_stream(1)
		event.open_message_window_2(0, 40030)
		open_message(0, -1, 8, 0, 0)
		at = 47
		wait_frames(40)
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		at = 48
		wait_camera()
		event.set_camera_sequence_position(-105.65, 209.67, 213.11)
		event.set_camera_sequence_look_at(-5.77, 249.52, 4.26)
		at = 49
		wait_frames(30)
		event.set_object_sequence_position(3, -309.76, 184.62, 0.22)
		event.set_object_sequence_rotation(3, 0.0, 0.96, 0.0)
		event.set_object_sequence_position(4, -321.11, 184.32, -16.48)
		event.set_object_sequence_rotation(4, 0.0, 0.54, 0.0)
		event.set_object_sequence_motion_time(0, 68.0)
		event.set_object_sequence_motion_time(1, 68.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "空中２（２）")
		event.set_object_sequence_texture_animation(0, 1, "大口（２）")
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 0.0, 0.0, 0.0, 40.0, "bcol00", 2)
		at = 50
		wait_frames(30)
		event.release_camera_sequence_follow_object()
		event.set_object_sequence_motion_time(0, 64.0)
		event.set_object_sequence_motion_time(1, 64.0)
		event.set_camera_sequence_position(-105.65, 209.67, 213.11)
		event.set_camera_sequence_look_at(-5.77, 249.52, 4.26)
		at = 51
		wait_frames(30)
		event.close_voice_stream(1)
		event.set_object_sequence_motion_time(0, 78.4)
		event.set_object_sequence_motion_time(1, 78.4)
		event.set_camera_sequence_position(-341.79, 268.45, 142.52)
		event.set_camera_sequence_look_at(-275.52, 194.52, 6.09)
		at = 52
		wait_frames(30)
		event.set_object_sequence_motion_time(0, 80.0)
		event.set_object_sequence_motion_time(1, 80.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "戻るー！！（２）")
		event.set_object_sequence_texture_animation(0, 1, "大口（２）")
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 5.0, 1.5, 0.0, 30.0, "bcol00", 1)
		at = 53
		wait_frames(30)
		event.release_camera_sequence_follow_object()
		event.set_object_sequence_motion_time(0, 102.4)
		event.set_object_sequence_motion_time(1, 102.4)
		event.set_camera_sequence_position(-220.35, 212.87, 157.52)
		event.set_camera_sequence_look_at(-306.54, 193.56, -8.65)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "蹴飛ばされる", 6)
		event.delay_object_sequence_sound_track(3, 10)
		event.play_object_sequence_sound(3, var1, 18)
		at = 54
		wait_frames(26)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "捕まえ失敗", 6)
		at = 55
		wait_frames(70)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_camera_sequence_position(-105.65, 209.67, 213.11)
		event.set_camera_sequence_look_at(-5.77, 249.52, 4.26)
		event.delay_object_sequence_sound_track(0, 4)
		event.play_object_sequence_sound(0, var1, 19)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, var1, 20)
		event.play_object_sequence_sound(0, var1, 28)
		at = 56
		wait_frames(42)
		event.set_object_sequence_motion_time(0, 208.0)
		event.set_object_sequence_motion_time(1, 208.0)
		event.wait_object_sequence_motion_end(1)
		event.set_object_sequence_motion(1, "たれさがり")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "空中（２）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口（２）")
		event.delay_object_sequence_texture_animation_track(0, 20)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "よし！！次（２）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口（２）")
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 0.0, 0.0, 0.0, 40.0, "bcol00", 2)
		at = 57
		wait_frames(40)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(163.49, 140.77, 131.57)
		event.set_camera_sequence_look_at(270.66, 194.2, -19.59)
		event.set_character_cloth_animation_enabled(0, 0)
		event.wait_object_sequence_motion_end(0)
		event.delay_object_sequence_sound_track(0, 4)
		event.play_object_sequence_sound(0, var1, 21)
		at = 58
		wait_objects(0)
		event.set_character_cloth_animation_enabled(0, 1)
		event.set_camera_sequence_position(447.58, 266.17, -85.27)
		event.set_camera_sequence_look_at(357.43, 185.48, 3.08)
		event.set_object_sequence_position(0, 349.03, 184.32, 4.08)
		event.set_object_sequence_rotation(0, 0.0, 1.57, 0.0)
		event.set_object_sequence_motion(0, "立ち上がる", 6)
		event.queue_object_sequence_next_motion(0, "キョロキョロ立ち", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "よし！！次（２）")
		event.set_object_sequence_texture_animation(0, 1, "口パク小")
		at = 59
		wait_objects(0)
		event.set_camera_sequence_position(452.54, 255.33, -129.4)
		event.set_camera_sequence_look_at(388.48, 192.54, 28.93)
		event.start_background_file_loads_2("event/opening/p4/p4_mints3.gltf", "event/opening/p4/p4_pierrot3.gltf")
		event.rotate_object_sequence(0, 0.0, 0.85, 0.0, 6)
		event.set_object_sequence_motion(0, "かまえ立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "気づく（２）")
		event.set_object_sequence_texture_animation(0, 1, "大口（２）")
		event.set_character_active(11)
		event.set_character_active(12)
		event.set_object_sequence_position(3, 442.04, 148.45, 80.27)
		event.set_object_sequence_rotation(3, 0.0, -2.28, 0.0)
		event.move_object_sequence(3, 422.02, 155.31, 63.91, 40)
		event.set_object_sequence_motion(3, "綱渡り", 4)
		event.set_object_sequence_motion_time(3, 3.5)
		event.set_object_sequence_position(4, 472.84, 137.68, 106.72)
		event.set_object_sequence_rotation(4, 0.0, -2.28, 0.0)
		event.move_object_sequence(4, 454.19, 144.23, 90.87, 40)
		event.set_object_sequence_motion(4, "綱渡り", 4)
		at = 60
		wait_frames(40)
		at = 61
		helper_479dc9e9()
		event.delete_character_extension_packs(0)
		event.clear_memory_stack(6)
		event.load_character_motion_pack(6, "event/opening/p4/p4_mints3.gltf", "info", 0)
		event.set_object_sequence_motion(0, "キョロキョロ立ち", 5)
		event.set_camera_sequence_position(373.64, 213.67, 15.39)
		event.set_camera_sequence_look_at(347.99, 207.28, 2.45)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "よし！！次（２）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口（３）")
		event.delay_object_sequence_texture_animation_track(0, 57)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "見上げる（２）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口（３）")
		at = 62
		wait_frames(10)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "キョロキョロ立ち", 6)
		event.queue_object_sequence_next_motion(0, "上を見る", 6)
		event.queue_object_sequence_next_motion(0, "上を見るL", 4)
		event.delete_character_extension_packs(11)
		event.delete_character_extension_packs(12)
		event.delete_character_extension_packs(13)
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot3.gltf", "info", 12)
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot3.gltf", "info", 13)
		event.load_character_motion_pack(6, "event/opening/p4/p4_pierrot3.gltf", "info", 14)
		at = 63
		wait_objects(0)
		at = 64
		wait_frames(10)
		event.set_camera_sequence_position(452.33, 233.67, -60.78)
		event.set_camera_sequence_look_at(343.67, 205.51, -9.42)
		event.set_object_handle_shadow_enabled(0, 0)
		event.set_object_sequence_position(0, 358.46, 184.32, -6.15)
		event.set_object_sequence_rotation(0, 0.0, -2.87, 0.0)
		event.set_object_sequence_motion(0, "柱･しがみつき", 6)
		event.wait_object_sequence_motion_end(0)
		event.play_object_sequence_sound(0, var1, 22)
		at = 65
		wait_objects(0)
		event.set_object_sequence_position(3, 397.41, 184.32, 30.99)
		event.set_object_sequence_rotation(3, 0.0, -2.52, 0.0)
		event.move_object_sequence(3, 370.41, 184.32, -8.43, 35)
		event.set_object_sequence_motion(3, "歩き", 6)
		event.queue_object_sequence_next_motion(3, "上を見る", 6)
		event.queue_object_sequence_next_motion(3, "上を見るL", 4)
		at = 66
		wait_frames(10)
		event.move_object_sequence(0, 358.46, 380.32, -6.15, 200)
		event.set_object_sequence_motion(0, "柱･登り", 4)
		event.move_camera_sequence(452.33, 233.67, -60.78, 343.67, 351.26, -9.42, 160)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var1, 23)
		at = 67
		wait_camera()
		event.set_camera_sequence_position(436.58, 475.72, -3.59)
		event.set_camera_sequence_look_at(343.67, 410.45, -9.42)
		at = 68
		wait_objects(0)
		event.set_object_sequence_position(0, 358.46, 370.64, -6.15)
		event.set_object_sequence_motion(0, "柱･棒に立つ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		at = 69
		wait_frames(40)
		event.set_camera_sequence_position(367.47, 421.1, 17.39)
		event.set_camera_sequence_look_at(340.3, 420.48, -31.37)
		event.start_background_file_loads_2("event/opening/p4/p4_kusari.gltf", "event/opening/p4/p4_kemuri.gltf")
		at = 70
		wait_objects(0)
		event.set_object_sequence_motion(0, "下見立ち", 6)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣下見")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		at = 71
		wait_frames(20)
		at = 72
		helper_479dc9e9()
		event.assign_memory_stack(7)
		event.clear_memory_stack(7)
		event.load_character(7, "event/opening/p4/p4_kusari.gltf", "info", 19)
		event.set_character_active(0, 19)
		event.attach_object_handle_to_character(10, 19)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_position(10, 0.0, 448.0, 105.0)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.load_character(7, "event/opening/p4/p4_kemuri.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.set_character_position(20, 0.0, 10.0, 0.0)
		event.set_camera_sequence_position(439.18, 421.1, 162.79)
		event.set_camera_sequence_look_at(340.3, 366.23, -31.37)
		event.set_object_sequence_position(3, 354.39, 291.6, -24.56)
		event.set_object_sequence_rotation(3, 0.0, -2.76, 0.0)
		event.set_object_sequence_motion(3, "柱･登り", 4)
		event.move_object_sequence(3, 354.39, 321.6, -24.56, 60)
		event.set_object_sequence_position(4, 360.04, 254.11, -32.06)
		event.set_object_sequence_rotation(4, 0.0, -1.49, 0.0)
		event.set_object_sequence_motion(4, "柱･登り", 4)
		event.move_object_sequence(4, 360.04, 284.11, -32.06, 60)
		at = 73
		wait_frames(60)
		event.set_camera_sequence_position(367.47, 421.1, 17.39)
		event.set_camera_sequence_look_at(340.3, 420.48, -31.37)
		event.set_object_sequence_motion(0, "棒の先を見る", 6)
		event.queue_object_sequence_next_motion(0, "踏み出す", 6, 0.1)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "○７（３）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口（３）")
		at = 74
		wait_objects(0)
		event.set_camera_sequence_position(132.73, 389.48, 276.32)
		event.set_camera_sequence_look_at(306.5, 389.69, -17.39)
		event.move_camera_sequence(132.73, 389.48, 276.32, -0.73, 353.3, -17.15, 210)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "拍手喝采（３）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		event.set_object_sequence_position(0, 309.1, 392.52, -23.46)
		event.set_object_sequence_rotation(0, 0.0, -1.43, 0.0)
		event.set_object_sequence_motion(0, "綱渡り", 6)
		event.wait_object_sequence_motion_end(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "綱渡り", 6)
		event.queue_object_sequence_next_motion(0, "綱走り")
		event.move_object_sequence(0, 274.31, 373.41, -16.87, 80)
		event.move_object_sequence(0, 183.47, 333.23, 0.0, 50)
		event.move_object_sequence(0, 9.21, 327.28, 0.0, 80)
		event.delay_object_sequence_rotation_track(0, 140)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 6)
		event.set_object_sequence_position(3, 354.39, 373.19, -24.56)
		event.set_object_sequence_rotation(3, 0.0, -2.52, 0.0)
		event.set_object_sequence_motion(3, "柱･登り", 4)
		event.move_object_sequence(3, 354.39, 403.19, -24.56, 60)
		event.set_object_sequence_position(4, 360.04, 327.61, -32.06)
		event.set_object_sequence_rotation(4, 0.0, -1.49, 0.0)
		event.set_object_sequence_motion(4, "柱･登り", 4)
		event.move_object_sequence(4, 360.04, 387.61, -32.06, 90)
		event.set_character_active(13)
		event.set_object_sequence_position(5, 347.62, 292.91, -38.69)
		event.set_object_sequence_rotation(5, 0.0, 0.65, 0.0)
		event.set_object_sequence_motion(5, "柱･登り", 4)
		event.move_object_sequence(5, 347.62, 352.91, -38.69, 90)
		at = 75
		wait_objects(3)
		event.set_object_sequence_motion(3, "柱･棒に立つ", 6)
		at = 76
		wait_objects(0)
		event.set_camera_sequence_position(-215.21, 383.68, 0.36)
		event.set_camera_sequence_look_at(4.09, 338.95, -1.2)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "ぐらぐら", 6)
		event.queue_object_sequence_next_motion(0, "ぐらぐらL", 6)
		event.wait_object_sequence_motion_end(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "ぐらぐらL", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_position(3, 142.97, 331.31, 0.0)
		event.set_object_sequence_rotation(3, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(3, "綱渡り", 4, 0.35)
		event.set_object_sequence_motion_time(5, 3.5)
		event.move_object_sequence(3, 60.0, 328.26, 0.0, 80)
		event.move_object_sequence(3, 40.0, 328.26, 0.0, 20)
		event.set_object_sequence_position(4, 212.27, 343.23, -5.15)
		event.set_object_sequence_rotation(4, 0.0, -1.45, 0.0)
		event.set_object_sequence_motion(4, "綱渡り", 6, 0.35)
		event.set_object_sequence_motion_time(4, 7.0)
		event.wait_object_sequence_motion_end(4)
		event.reset_object_sequence_motion(4)
		event.set_object_sequence_motion(4, "綱渡り", 6)
		event.wait_object_sequence_motion_end(4)
		event.reset_object_sequence_motion(4)
		event.set_object_sequence_motion(4, "綱渡り", 6)
		event.wait_object_sequence_motion_end(4)
		event.reset_object_sequence_motion(4)
		event.set_object_sequence_motion(4, "綱渡り", 6)
		event.queue_object_sequence_next_motion(4, "棒の上立ち", 6)
		event.queue_object_sequence_next_motion(4, "棒の上立ちL", 4)
		event.move_object_sequence(4, 183.0, 332.22, 0.0, 30)
		event.move_object_sequence(4, -23.0, 328.47, 0.0, 134)
		event.delay_object_sequence_rotation_track(4, 30)
		event.rotate_object_sequence(4, 0.0, -1.57, 0.0, 6)
		event.set_object_sequence_position(5, 260.46, 368.14, -15.47)
		event.set_object_sequence_rotation(5, 0.0, -1.45, 0.0)
		event.set_object_sequence_motion(5, "綱渡り", 6)
		event.wait_object_sequence_motion_end(5)
		event.reset_object_sequence_motion(5)
		event.set_object_sequence_motion(5, "綱渡り", 6)
		event.wait_object_sequence_motion_end(5)
		event.reset_object_sequence_motion(5)
		event.set_object_sequence_motion(5, "綱渡り", 6)
		event.wait_object_sequence_motion_end(5)
		event.reset_object_sequence_motion(5)
		event.set_object_sequence_motion(5, "綱渡り", 6)
		event.queue_object_sequence_next_motion(5, "棒の上立ち", 6)
		event.queue_object_sequence_next_motion(5, "棒の上立ちL", 4)
		event.move_object_sequence(5, 183.0, 332.22, 0.0, 84)
		event.move_object_sequence(5, 0.0, 328.22, 0.0, 100)
		at = 77
		wait_objects(3)
		event.set_object_sequence_motion(3, "飛びつき", 6)
		at = 78
		wait_objects(0)
		event.set_object_sequence_motion(0, "ライトに飛ぶ", 6)
		event.play_object_sequence_sound(0, var1, 24)
		event.set_object_sequence_motion(2, "ライトに飛ぶ", 6)
		event.queue_object_sequence_next_motion(2, "まわる", 4)
		at = 79
		wait_frames(22)
		event.set_object_handle_motion(0, "ライトに飛ぶL", 4)
		event.attach_character_to_frame(10, "mints", 0)
		event.play_object_sequence_sound(2, var1, 25)
		event.delay_object_sequence_sound_track(2, 134)
		event.play_object_sequence_sound(2, var1, 25)
		event.close_voice_stream(1)
		event.open_voice_stream_wave(1, 40040)
		at = 80
		var0 = helper_f616ba9e(1)
		at = 81
		wait_frames(vm.i32(80 - var0))
		event.set_camera_sequence_position(-189.64, 319.88, 278.88)
		event.set_camera_sequence_look_at(23.52, 338.95, 28.18)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, -23.05, 328.26, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "棒の上立ち(正面）L", 4, 0.02)
		event.set_object_sequence_motion_time(3, 1.4)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 7.4, 327.14, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "棒の上立ち(正面）L", 4, 0.02)
		event.set_object_sequence_motion_time(4, 2.6000001)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 38.44, 327.39, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "棒の上立ち(正面）L", 4)
		event.delay_object_sequence_position_track(4, 100)
		event.delay_object_sequence_motion_track(4, 100)
		event.set_object_sequence_motion(4, "ライトに飛ぶ", 6)
		event.delay_object_sequence_position_track(4, 10)
		event.jump_object_sequence(4, 13.2, 315.39, 40.3, -0.4, 14)
		event.delay_object_sequence_position_track(5, 105)
		event.delay_object_sequence_motion_track(5, 105)
		event.delay_object_sequence_rotation_track(5, 105)
		event.set_object_sequence_motion(5, "ライトに飛ぶ", 6)
		event.delay_object_sequence_position_track(5, 10)
		event.delay_object_sequence_rotation_track(5, 10)
		event.jump_object_sequence(5, 28.98, 312.19, 49.95, -0.4, 14)
		event.rotate_object_sequence(5, 0.0, -0.84, 0.0, 14)
		event.delay_object_sequence_position_track(3, 109)
		event.delay_object_sequence_motion_track(3, 109)
		event.delay_object_sequence_rotation_track(3, 109)
		event.set_object_sequence_motion(3, "ライトに飛ぶ", 6)
		event.delay_object_sequence_position_track(3, 10)
		event.delay_object_sequence_rotation_track(3, 10)
		event.jump_object_sequence(3, -25.86, 311.84, 49.12, -0.4, 14)
		event.rotate_object_sequence(3, 0.0, 0.84, 0.0, 14)
		event.play_voice_stream(1)
		event.open_message_window_2(0, 40040)
		open_message(0, -1, 8, 0, 0)
		at = 82
		helper_917013c0(0, 60)
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		event.close_voice_stream(1)
		event.delay_camera_sequence_position_track(30)
		event.set_camera_sequence_position(-208.72, 388.6, 84.96)
		event.set_camera_sequence_look_at(2.62, 320.22, 24.49)
		event.delay_camera_sequence_position_track(30)
		event.set_camera_sequence_position(1.55, 445.57, 288.5)
		event.set_camera_sequence_look_at(-0.46, 280.6, 24.97)
		at = 83
		wait_objects(4)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot2", 12)
		at = 84
		wait_objects(5)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot3", 13)
		at = 85
		wait_objects(3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot1", 11)
		at = 86
		wait_frames(30)
		event.set_camera_sequence_position(16.78, 341.72, 53.54)
		event.set_camera_sequence_look_at(0.31, 383.37, 104.98)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(19)
		event.set_character_active(0, 18)
		event.set_object_sequence_position(2, 0.0, -1000.0, 0.0)
		event.set_object_sequence_motion(10, "ちぎれそう", 6)
		event.set_object_sequence_motion_time(10, 3.0)
		event.play_sound_effect(var1, 32)
		at = 87
		wait_frames(60)
		event.set_character_active(18)
		event.set_character_active(0, 19)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 0.0, -0.4, 20.0, 20.0, "bcol00", 2)
		event.set_object_sequence_motion(0, "見上げる", 2)
		event.queue_object_sequence_next_motion(0, "見上げるL", 4)
		event.delay_object_sequence_texture_animation_track(0, 15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "落ちるー（３）")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.open_voice_stream_wave(1, 40050)
		at = 88
		var0 = helper_f616ba9e(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, 40050)
		open_message(0, -1, 8, 0, 0)
		at = 89
		helper_917013c0(0, vm.i32(60 - var0))
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		at = 90
		wait_objects(0)
		event.close_voice_stream(1)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(16.78, 341.72, 53.54)
		event.set_camera_sequence_look_at(0.31, 383.37, 104.98)
		event.set_object_sequence_position(2, 0.0, -1000.0, 0.0)
		event.set_character_active(0, 18)
		event.set_character_active(19)
		event.set_object_sequence_motion(10, "ちぎれそう待機", 6)
		event.open_voice_stream_wave(1, 40060)
		at = 91
		wait_frames(10)
		event.set_object_sequence_motion(10, "ちぎれる", 6)
		event.delay_object_sequence_sound_track(10, 4)
		event.play_object_sequence_sound(10, var1, 26)
		at = 92
		wait_frames(58)
		at = 93
		helper_9cbdc640(1)
		event.set_character_active(0, 19)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 8.0, -0.16, 15.0, 20.0, "bcol00", 2)
		event.delay_object_sequence_motion_track(6, 30)
		event.play_sound_effect(var1, 33)
		event.keep_character_in_front_of_camera_sequence(8, 60.0, 30)
		event.set_character_active(8)
		event.set_character_active(18)
		event.set_character_motion(10, "落下", 6, 0.3)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "落ちるー（３）")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.play_voice_stream(1)
		event.open_message_window_2(0, 40060)
		open_message(0, -1, 8, 0, 0)
		at = 94
		helper_917013c0(0, 30)
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		at = 95
		wait_objects(6)
		event.close_voice_stream(1)
		event.release_camera_sequence_follow_object()
		event.set_character_active(0, 8)
		event.set_character_active(11)
		event.set_character_active(12)
		event.set_character_active(13)
		event.set_camera_sequence_position(0.0, 18.46, -95.54)
		event.set_camera_sequence_look_at(0.0, 194.33, 107.78)
		event.move_camera_sequence(0.0, 18.46, -95.54, 0.0, 66.62, 107.78, 30)
		event.set_character_active(0, 18)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "落下", 6, 0.3)
		event.queue_object_sequence_next_motion(2, "停止", 4)
		event.play_object_sequence_sound(2, var1, 27)
		event.set_object_handle_shadow_enabled(0, 1)
		at = 96
		wait_frames(14)
		event.set_object_sequence_motion(0, "飛び降りる", 2)
		event.queue_object_sequence_next_motion(0, "飛び降りるL", 6, 0.2)
		event.queue_object_sequence_next_motion(0, "ライトから着地", 6)
		event.wait_object_sequence_motion_end(0)
		event.delay_object_sequence_motion_track(0, 10)
		at = 97
		wait_frames(10)
		event.detach_character_from_frame(0)
		event.set_object_sequence_position(0, 0.0, 65.81, 94.16)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.jump_object_sequence(0, 0.0, 10.6, 6.0, -0.2, 30)
		at = 98
		wait_frames(5)
		event.set_character_active(20)
		event.set_character_motion(20, "けむり", 6)
		at = 99
		wait_objects(2)
		event.stop_music(0)
		event.clear_object_sequence(7)
		event.detach_character_from_frame(11)
		event.set_object_sequence_position(3, -46.01, 150.0, 50.48)
		event.set_object_sequence_rotation(3, 0.0, 2.42, 0.0)
		event.detach_character_from_frame(12)
		event.set_object_sequence_position(4, -48.62, 150.0, 60.52)
		event.set_object_sequence_rotation(4, 0.0, -2.42, 0.0)
		event.detach_character_from_frame(13)
		event.set_object_sequence_position(5, -35.87, 150.0, -54.34)
		event.set_object_sequence_rotation(5, 0.0, 0.38, 0.0)
		event.set_character_active(14)
		event.attach_object_handle_to_character(20, 14)
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.set_object_sequence_position(20, 30.12, 150.0, -61.93)
		event.set_object_sequence_rotation(20, 0.0, -0.6, 0.0)
		at = 100
		wait_objects(0)
		event.set_camera_sequence_position(1.17, 26.95, -26.03)
		event.set_camera_sequence_look_at(1.17, 33.68, 4.49)
		event.set_object_sequence_position(0, 0.0, 10.0, 6.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "舞台上キョロキョロ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "拍手喝采（３）")
		event.set_object_sequence_texture_animation(0, 1, "開きからにこり")
		event.play_object_sequence_sound(0, var1, 28)
		at = 101
		wait_objects(0)
		event.set_camera_sequence_look_at(0.0, 33.68, 4.49)
		event.set_camera_sequence_angle_height_distance(0.9, 9.0, 50.0)
		event.move_camera_sequence_angle_height_distance(-0.9, 9.0, 50.0, 180)
		event.set_object_sequence_motion(0, "手を振る", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "感動（３）")
		event.set_object_sequence_texture_animation(0, 1, "うれし口（３）")
		at = 102
		wait_camera()
		event.set_camera_sequence_position(0.61, 45.86, -150.28)
		event.set_camera_sequence_look_at(0.57, 21.14, 5.95)
		event.set_character_active(0, 10)
		event.set_object_sequence_motion(20, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(20, "着地", 6)
		event.queue_object_sequence_next_motion(20, "立ち", 4)
		event.jump_object_sequence(20, 30.12, 8.8, -61.93, -0.2, 30)
		event.delay_object_sequence_sound_track(20, 30)
		event.play_object_sequence_sound(20, var1, 34)
		at = 103
		wait_frames(6)
		event.set_object_sequence_motion(3, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.jump_object_sequence(3, -46.01, 8.8, 50.48, -0.2, 30)
		event.delay_object_sequence_sound_track(3, 30)
		event.play_object_sequence_sound(3, var1, 34)
		at = 104
		wait_frames(4)
		event.set_object_sequence_motion(5, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(5, "着地", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.jump_object_sequence(5, -35.87, 8.8, -54.34, -0.2, 30)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, var1, 34)
		at = 105
		wait_frames(3)
		event.set_object_sequence_motion(4, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.jump_object_sequence(4, 48.62, 8.8, 60.52, -0.2, 30)
		event.delay_object_sequence_sound_track(4, 30)
		event.play_object_sequence_sound(4, var1, 34)
		at = 106
		wait_frames(20)
		event.set_object_sequence_motion(0, "キョロキョロ立ち")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		at = 107
		helper_1584c528(40080, 30)
		at = 108
		wait_frames(10)
		event.set_camera_sequence_position(-20.61, 33.01, -18.61)
		event.set_camera_sequence_look_at(1.45, 30.1, 6.28)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_object_sequence_motion(0, "レンチを取り出す", 6)
		event.queue_object_sequence_next_motion(0, "レンチを取り出すL", 4)
		event.close_voice_stream(1)
		var0 = 0
		at = 109
		wait_frames(40 - var0)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 1)
		at = 110
		wait_frames(46)
		event.play_object_sequence_sound(0, var1, 35)
		at = 111
		wait_objects(0)
		at = 112
		wait_frames(30)
		event.set_camera_sequence_position(-4.51, 25.29, -32.6)
		event.set_camera_sequence_look_at(1.45, 30.1, 6.28)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.delay_object_sequence_sound_track(0, 4)
		event.play_object_sequence_sound(0, var1, 36)
		at = 113
		wait_objects(0)
		at = 114
		wait_frames(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		at = 115
		wait_camera()
	end, function(received: { any }): boolean
		if at == 80 then
			var0 = received[1] :: number
		end
		if at == 88 then
			var0 = received[1] :: number
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_238b5abc(1)
		end
		if at <= 4 then
			wait_frames_skipping(50)
		end
		if at <= 5 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_705b02bc(0, 30)
		end
		if at <= 6 then
			helper_d16eef1e(0)
			helper_238b5abc(0)
		end
		if at <= 7 then
			helper_238b5abc(0)
		end
		if at <= 8 then
			helper_238b5abc(3)
		end
		if at <= 9 then
			helper_238b5abc(4)
		end
		if at <= 10 then
			helper_238b5abc(5)
		end
		if at <= 11 then
			wait_frames_skipping(10)
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			wait_frames_skipping(4)
		end
		if at <= 14 then
			helper_238b5abc(0)
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			wait_frames_skipping(15)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_238b5abc(3)
		end
		if at <= 19 then
			helper_238b5abc(4)
		end
		if at <= 20 then
			wait_frames_skipping(8)
		end
		if at <= 21 then
			wait_frames_skipping(20)
		end
		if at <= 22 then
			var0 = 0
			wait_frames_skipping(15 - var0)
		end
		if at <= 23 then
			helper_238b5abc(0)
		end
		if at <= 24 then
			helper_238b5abc(3)
		end
		if at <= 25 then
			helper_238b5abc(4)
		end
		if at <= 26 then
			wait_frames_skipping(20)
		end
		if at <= 27 then
			helper_238b5abc(0)
		end
		if at <= 28 then
			wait_frames_skipping(30)
		end
		if at <= 29 then
			helper_344d6cd8()
		end
		if at <= 30 then
			wait_frames_skipping(15)
		end
		if at <= 31 then
			wait_frames_skipping(45)
		end
		if at <= 32 then
			wait_frames_skipping(30)
		end
		if at <= 33 then
			wait_frames_skipping(20)
		end
		if at <= 34 then
			helper_344d6cd8()
		end
		if at <= 35 then
			wait_frames_skipping(30)
		end
		if at <= 36 then
			helper_238b5abc(0)
		end
		if at <= 37 then
			helper_344d6cd8()
		end
		if at <= 38 then
			helper_238b5abc(0)
		end
		if at <= 39 then
			helper_344d6cd8()
		end
		if at <= 40 then
			wait_frames_skipping(30)
		end
		if at <= 41 then
			wait_frames_skipping(20)
		end
		if at <= 42 then
			helper_238b5abc(0)
		end
		if at <= 43 then
			wait_frames_skipping(24)
		end
		if at <= 44 then
			helper_238b5abc(1)
		end
		if at <= 45 then
			helper_344d6cd8()
		end
		if at <= 46 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			wait_frames_skipping(40)
		end
		if at <= 47 then
			helper_d16eef1e(0)
			helper_344d6cd8()
		end
		if at <= 48 then
			wait_frames_skipping(30)
		end
		if at <= 49 then
			wait_frames_skipping(30)
		end
		if at <= 50 then
			wait_frames_skipping(30)
		end
		if at <= 51 then
			wait_frames_skipping(30)
		end
		if at <= 52 then
			wait_frames_skipping(30)
		end
		if at <= 53 then
			wait_frames_skipping(26)
		end
		if at <= 54 then
			wait_frames_skipping(70)
		end
		if at <= 55 then
			wait_frames_skipping(42)
		end
		if at <= 56 then
			wait_frames_skipping(40)
		end
		if at <= 57 then
			helper_238b5abc(0)
		end
		if at <= 58 then
			helper_238b5abc(0)
		end
		if at <= 59 then
			wait_frames_skipping(40)
		end
		if at <= 60 then
			helper_344d6cd8()
		end
		if at <= 61 then
			wait_frames_skipping(10)
		end
		if at <= 62 then
			helper_238b5abc(0)
		end
		if at <= 63 then
			wait_frames_skipping(10)
		end
		if at <= 64 then
			helper_238b5abc(0)
		end
		if at <= 65 then
			wait_frames_skipping(10)
		end
		if at <= 66 then
			helper_344d6cd8()
		end
		if at <= 67 then
			helper_238b5abc(0)
		end
		if at <= 68 then
			wait_frames_skipping(40)
		end
		if at <= 69 then
			helper_238b5abc(0)
		end
		if at <= 70 then
			wait_frames_skipping(20)
		end
		if at <= 71 then
			helper_344d6cd8()
		end
		if at <= 72 then
			wait_frames_skipping(60)
		end
		if at <= 73 then
			helper_238b5abc(0)
		end
		if at <= 74 then
			helper_238b5abc(3)
		end
		if at <= 75 then
			helper_238b5abc(0)
		end
		if at <= 76 then
			helper_238b5abc(3)
		end
		if at <= 77 then
			helper_238b5abc(0)
		end
		if at <= 78 then
			wait_frames_skipping(22)
		end
		if at <= 79 then
			var0 = helper_523109b8(1)
		end
		if at <= 80 then
			wait_frames_skipping(vm.i32(80 - var0))
		end
		if at <= 81 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_705b02bc(0, 60)
		end
		if at <= 82 then
			helper_d16eef1e(0)
			helper_238b5abc(4)
		end
		if at <= 83 then
			helper_238b5abc(5)
		end
		if at <= 84 then
			helper_238b5abc(3)
		end
		if at <= 85 then
			wait_frames_skipping(30)
		end
		if at <= 86 then
			wait_frames_skipping(60)
		end
		if at <= 87 then
			var0 = helper_523109b8(1)
		end
		if at <= 88 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_705b02bc(0, vm.i32(60 - var0))
		end
		if at <= 89 then
			helper_d16eef1e(0)
			helper_238b5abc(0)
		end
		if at <= 90 then
			wait_frames_skipping(10)
		end
		if at <= 91 then
			wait_frames_skipping(58)
		end
		if at <= 92 then
			helper_238b5abc(1)
		end
		if at <= 93 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_705b02bc(0, 30)
		end
		if at <= 94 then
			helper_d16eef1e(0)
			helper_238b5abc(6)
		end
		if at <= 95 then
			wait_frames_skipping(14)
		end
		if at <= 96 then
			wait_frames_skipping(10)
		end
		if at <= 97 then
			wait_frames_skipping(5)
		end
		if at <= 98 then
			helper_238b5abc(2)
		end
		if at <= 99 then
			helper_238b5abc(0)
		end
		if at <= 100 then
			helper_238b5abc(0)
		end
		if at <= 101 then
			helper_344d6cd8()
		end
		if at <= 102 then
			wait_frames_skipping(6)
		end
		if at <= 103 then
			wait_frames_skipping(4)
		end
		if at <= 104 then
			wait_frames_skipping(3)
		end
		if at <= 105 then
			wait_frames_skipping(20)
		end
		if at <= 106 then
			helper_52aadc70(40080, 30)
		end
		if at <= 107 then
			wait_frames_skipping(10)
		end
		if at <= 108 then
			var0 = 0
			wait_frames_skipping(40 - var0)
		end
		if at <= 109 then
			wait_frames_skipping(46)
		end
		if at <= 110 then
			helper_238b5abc(0)
		end
		if at <= 111 then
			wait_frames_skipping(30)
		end
		if at <= 112 then
			helper_238b5abc(0)
		end
		if at <= 113 then
			wait_frames_skipping(30)
		end
		if at <= 114 then
			helper_344d6cd8()
		end
		return true
	end)
	at = 116
	vm.entry(116)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(var1, 33)
	event.stop_sound_effect(var1, 27)
	event.stop_sound_effect(var1, 28)
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_shadow_enabled(0, 1)
	event.set_character_position(0, 0.0, 8.8, 6.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "バトル立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(21, 1)
	event.set_object_handle_visible(21, 1)
	event.set_camera_look_at(0.0, 33.8, 6.0)
	event.set_camera_position(0.0, 38.8, 86.0)
	event.reset_follow_camera(0)
	event.detach_character_from_frame(0)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(8)
	event.set_character_active(1, 0)
	event.load_map_sounds(1217)
	var2 = event.get_sound_id(4) or var2
	event.set_action_character_second_sound_bank(0, var2)
	event.copy_action_character_sound_to_parts(0)
	event.load_event_script("s43/s43.stb", 152)
end

return helper_1b215860
