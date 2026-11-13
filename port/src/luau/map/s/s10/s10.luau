--!strict
--- Heim Rada stop script covering the chapter five arrival cutscene, train boarding and the departure talk.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local heim_rada_stop = require("@lib/event/heim_rada_stop")
local map = require("@lib/event/map")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local party = require("@lib/event/party")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

--- Resets the train cars and spawns the villager at the stop.
local function reset_stop_scene()
	object.reset_train_car_parts()
	train.tilt_cars()
	heim_rada_stop.spawn_villager()
end

--- Runs the player along a path into the stop with a fade out and in, then repositions them and restores the follow camera.
local function run_into_stop()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 70)
	event.add_object_sequence_path_point(0, 2730.28, 163.23, 630.94)
	event.add_object_sequence_path_point(0, 2674.4, 138.96, 765.84)
	event.add_object_sequence_path_point(0, 2616.58, 125.16, 846.91)
	event.start_object_sequence_path(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(2590.33, 108.76, 1218.81)
	event.set_camera_sequence_look_at(2591.54, 130.16, 1030.59)
	event.fade_in_screen(15)
	wait.for_frame_count(40)
	event.fade_out_screen(15)
	wait.for_frame_count(15)
	event.set_object_handle_footstep_sound(0, 0)
	character.place_standing_and_reset_cloth(vm.f32(2358.3), 0.0, vm.f32(1357.7), vm.f32(0.06))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the cutscene where the steam train arrives and the party meets the villagers, ending with the chapter title.
local function play_train_arrival_cutscene()
	local sound_bank: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(500, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(5200)
		sound_bank = event.load_sound_effect_file_2(5200) or sound_bank
		event.play_sound_effect(sound_bank, 0)
		event.stop_sound_effect(sound_bank, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e500/e500/")
		event.load_message_file(0, 5, "e500.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e500_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e500_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "steam_slow_l.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.attach_object_handle_to_character(17, 34)
		event.clear_object_sequence(17)
		event.set_object_sequence_object(17, 17)
		event.set_object_sequence_position(17, -120.0, 0.0, -1690.0)
		event.load_character(5, "steam_slow_r.gltf", "info", 35)
		event.set_character_active(0, 35)
		event.attach_object_handle_to_character(18, 35)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_position(18, -120.0, 0.0, -1690.0)
		event.load_character(5, "train_hibana.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_object_handle_to_character(19, 36)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.copy_character(5, 36, 37)
		event.set_character_active(0, 37)
		event.attach_object_handle_to_character(20, 37)
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e500/e500/e500_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e500/e500/e500_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.load_character(5, "chara/p01_03a.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(10, 8)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.load_character(5, "event/e500/e500/e207_vorneo.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(11, 9)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.load_character(5, "event/e500/e500/e207_tom.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(12, 10)
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.attach_object_handle_to_map_part_2(2, "p01_train01")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m0")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train08-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m0")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m1")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "train07-m3")
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.attach_object_handle_to_map_part_3(8, "p01_train01", "train07-m4")
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.attach_object_handle_to_map_part_3(9, "p01_train01", "train07-m5")
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.attach_object_handle_to_map_part_3(13, "p01_train01", "train05-m17")
		event.clear_object_sequence(13)
		event.set_object_sequence_object(13, 13)
		event.attach_object_handle_to_map_part_3(14, "p01_train01", "train05-m16")
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.attach_object_handle_to_map_part_3(15, "p01_train01", "train06-m1")
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		event.attach_object_handle_to_map_part_3(16, "p01_train01", "train06-m0")
		event.clear_object_sequence(16)
		event.set_object_sequence_object(16, 16)
		event.attach_object_handle_to_map_part_2(21, "p01_shadow-0")
		event.clear_object_sequence(21)
		event.set_object_sequence_object(21, 21)
		event.set_character_active(0, 122)
		event.set_character_active(0, 123)
		event.set_object_handle_position(0, 2382.27, 41.01, 1705.74)
		event.set_object_handle_rotation(0, 0.0, -2.3, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_position(1, 2384.06, 42.55, 1716.02)
		event.set_object_handle_rotation(1, 0.0, -2.3, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_position(10, 2397.6, 43.23, 1711.52)
		event.set_object_handle_rotation(10, 0.0, -2.3, 0.0)
		event.set_object_handle_motion(10, "立ち", 4)
		event.set_object_handle_footstep_sound(10, 6)
		event.set_object_handle_position(2, 2128.3, 9.0, 2080.6)
		event.set_object_handle_rotation(2, 0.0, 2.495821, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(13, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(14, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(15, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(16, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(7, 0)
		event.set_object_handle_visible(8, 0)
		event.set_object_handle_visible(9, 0)
		event.set_object_handle_visible(21, 0)
		event.set_object_handle_position(17, 2128.3, 9.0, 2080.6)
		event.set_object_handle_position(18, 2128.3, 9.0, 2080.6)
		event.set_scene_status_flags(1, 0, 8, 1)
		event.set_scene_status_flags(1, 32, 8, 1)
		event.set_scene_status_flags(1, 8, 8, 1)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(3045.82, 154.0, 603.5)
		event.set_camera_sequence_look_at(2536.0, 67.0, 2000.0)
		event.set_object_sequence_position(17, 2105.42, 31.57, 2072.94)
		event.set_object_sequence_rotation(17, 0.0, 2.44, 0.0)
		event.set_object_sequence_position(18, 2136.76, 22.97, 2082.99)
		event.set_object_sequence_rotation(18, 0.0, 2.44, 0.0)
		event.set_object_sequence_rotation(19, 0.0, 2.44, 0.0)
		event.set_object_sequence_position(19, 2136.76, 22.97, 2082.99)
		event.set_object_sequence_rotation(19, 0.0, 2.44, 0.0)
		event.set_object_sequence_position(20, 2136.76, 22.97, 2082.99)
		event.set_object_sequence_rotation(20, 0.0, 2.2, 0.0)
		event.move_camera_sequence_eased(2704.05, 126.34, 969.56, 3385.02, 64.22, 713.94, 110, 2, 1.0)
		event.move_object_sequence_eased(2, 3139.7, 6.0, 918.2, 90, 2, 1.0)
		event.move_object_sequence_eased(17, 3031.0, 44.52, 961.3, 90, 2, 1.0)
		event.move_object_sequence_eased(18, 3155.72, 91.2, 940.8, 90, 2, 1.0)
		event.move_object_sequence_eased(19, 3113.06, 16.05, 850.16, 90, 2, 1.0)
		event.move_object_sequence_eased(20, 3066.8, 16.05, 937.56, 90, 2, 1.0)
		event.delay_object_sequence_rotation_track(13, 70)
		event.rotate_object_sequence_eased(13, 6.108652, 0.0, 0.0, 40, 2, 1.0)
		event.delay_object_sequence_rotation_track(14, 70)
		event.rotate_object_sequence_eased(14, 6.108652, 0.0, 0.0, 40, 2, 1.0)
		event.delay_object_sequence_rotation_track(15, 70)
		event.rotate_object_sequence_eased(15, 6.108652, 0.0, 0.0, 40, 2, 1.0)
		event.delay_object_sequence_rotation_track(16, 70)
		event.rotate_object_sequence_eased(16, 6.108652, 0.0, 0.0, 40, 2, 1.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(10, 0)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(2, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 2)
		event.fade_in_screen(30)
		event.delay_object_sequence_sound_track(2, 30)
		event.play_object_sequence_sound(2, sound_bank, 6)
		wait.for_frame_count(90)
		event.set_object_handle_visible(19, 1)
		event.set_object_handle_visible(20, 1)
		event.set_character_active(36)
		event.set_character_active(37)
		event.set_object_sequence_motion(19, "ｴﾌｪｸﾄ_火花", 4)
		event.set_object_sequence_motion(20, "ｴﾌｪｸﾄ_火花", 4)
		wait.for_frame_count(30)
		event.set_character_visible(36, 0, 1, 0.1)
		event.set_character_visible(37, 0, 1, 0.1)
		event.set_character_active(34)
		event.set_character_active(35)
		event.set_object_handle_visible(17, 1)
		event.set_object_handle_visible(18, 1)
		event.set_object_sequence_motion(17, "ぶしゅー", 6)
		event.set_object_sequence_motion(18, "ぶしゅー", 6)
		event.wait_object_sequence_motion_end(17)
		object.wait_until_done(2)
		wait.for_frame_count(75)
		event.set_character_active(0, 34)
		event.set_character_active(0, 35)
		event.fade_out_screen(20)
		wait.for_frame_count(20)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.stop_all_sounds()
		event.set_sound_reverb_enabled(0)
		event.show_chapter_title(5)
		vm.wait(7)
		event.set_sound_reverb_enabled(1)
		wait.for_frame_count(30)
		event.enable_drama_skip()
		event.fade_in_screen(20)
		event.set_object_handle_visible(7, 1)
		event.set_object_handle_visible(8, 1)
		event.set_object_handle_visible(9, 1)
		event.set_object_handle_visible(21, 1)
		event.set_object_sequence_position(2, 2786.4, 6.0, 1333.3)
		event.set_object_handle_rotation(2, 0.0, 2.422517, 0.0)
		event.stop_music(0)
		event.load_music(4)
		event.play_music(0)
		event.set_camera_sequence_position(2066.31, 175.05, 1569.8)
		event.set_camera_sequence_look_at(2394.41, 50.17, 1680.51)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(8)
		wait.for_frame_count(5)
		event.play_sound_effect(sound_bank, 7)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		wait.for_frame_count(25)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 2374.17, 41.99, 1697.89, 30)
		event.delay_object_sequence_position_track(1, 30)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, 2362.0, 42.55, 1698.53, 45)
		event.delay_object_sequence_position_track(10, 90)
		event.delay_object_sequence_motion_track(10, 90)
		event.set_object_sequence_motion(10, "歩き")
		event.move_object_sequence(10, 2370.1, 42.05, 1695.1, 50)
		wait.for_frame_count(30)
		event.set_camera_sequence_position(2287.78, 88.48, 1626.22)
		event.set_camera_sequence_look_at(2356.53, 39.11, 1685.03)
		event.move_camera_sequence_eased(2290.62, 70.54, 1629.19, 2345.8, 32.47, 1678.44, 90, 2, 1.0)
		event.set_object_sequence_motion(0, "上見歩き", 4)
		event.move_object_sequence(0, 2315.09, 0.0, 1657.75, 180)
		event.move_object_sequence(0, 2279.82, 0.0, 1641.44, 60)
		event.set_object_sequence_motion(1, "上見歩き", 4)
		event.delay_object_sequence_position_track(1, 15)
		event.delay_object_sequence_motion_track(1, 15)
		event.move_object_sequence(1, 2327.23, 0.0, 1646.23, 175)
		event.move_object_sequence(1, 2299.73, 0.0, 1624.52, 90)
		event.delay_object_sequence_position_track(10, 50)
		event.delay_object_sequence_motion_track(10, 50)
		event.move_object_sequence(10, 2317.79, 0.0, 1657.54, 160)
		event.delay_object_sequence_motion_track(10, 160)
		event.queue_object_sequence_next_motion(10, "立ち")
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(5000020, 60)
		event.reset_mouth_texture_animations()
		wait.for_frame_count(30)
		event.set_camera_sequence_position(2276.95, 8.29, 1699.56)
		event.set_camera_sequence_look_at(2299.83, 22.14, 1634.76)
		event.move_camera_sequence_eased(2284.38, 11.92, 1696.16, 2289.11, 21.16, 1630.83, 90, 2, 1.0)
		event.set_object_handle_footstep_sound(0, 16)
		event.queue_object_sequence_next_motion(0, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.queue_object_sequence_next_motion(0, "立ち")
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 135)
		event.queue_object_sequence_next_motion(1, "立ち")
		wait.for_frame_count(30)
		event.set_scene_status_flags(1, 0, 8, 0)
		event.set_scene_status_flags(1, 32, 8, 0)
		event.set_scene_status_flags(1, 8, 8, 0)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(5000030, 180)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(5000040, 150)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		message.show_voiced(5000045)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		message.show_voiced(5000050)
		object.wait_until_done(0)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_position(9, 2428.11, 1.16, 1553.04)
		event.set_character_rotation(9, 0.0, -1.07, 0.0)
		event.set_character_position(10, 2407.91, 0.0, 1529.52)
		event.set_character_rotation(10, 0.0, -1.08, 0.0)
		event.set_object_sequence_position(0, 2290.27, 0.0, 1646.13)
		event.set_object_sequence_rotation(0, 0.0, -2.3, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 2307.29, 0.0, 1634.49)
		event.set_object_sequence_rotation(1, 0.0, -2.42, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_rotation(10, 0.0, -2.78, 0.0)
		event.set_camera_sequence_position(2182.37, 51.29, 1680.81)
		event.set_camera_sequence_look_at(2393.77, -7.42, 1580.11)
		event.set_object_sequence_motion(10, "会話", 6)
		event.queue_object_sequence_next_motion(10, "立ち", 4)
		event.set_object_sequence_texture_animation(10, 0)
		event.set_object_sequence_texture_animation(10, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(10, 1, "通常目パチ")
		event.set_mouth_texture_animations(10, "通常口パク")
		message.show_voiced(5000060)
		event.set_object_sequence_motion(11, "会話")
		event.delay_object_sequence_motion_track(11, 30)
		event.queue_object_sequence_next_motion(11, "立ち", 4)
		event.delay_object_sequence_motion_track(1, 15)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_texture_animation(11, 0)
		event.set_object_sequence_texture_animation(11, 1, "目パチ")
		event.set_mouth_texture_animations(11, "口パク")
		message.show_voiced_for_stopping(5000070, 200)
		event.set_object_sequence_motion(12, "会話", 6)
		event.queue_object_sequence_next_motion(12, "立ち", 4)
		event.set_object_sequence_texture_animation(12, 0)
		event.set_object_sequence_texture_animation(12, 1, "目パチ")
		event.set_mouth_texture_animations(12, "口パク")
		message.show_voiced(5000080)
		event.reset_mouth_texture_animations()
		event.apply_message_window_preset(1, 4)
		message.set_window_mode(1, 4)
		event.open_message_window_2(1, "ボルネオとトムは、ジオラマに\n配置できるようになった。")
		message.show(1, -1, 8, 0, 0)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(27)
	event.cancel_drama_scene_skip()
	event.set_object_handle_position(2, 2837.4, 6.0, 1289.1)
	event.set_object_handle_rotation(2, 0.0, 2.4260077, 0.0)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.set_object_handle_visible(21, 1)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_scene_status_flags(1, 0, 8, 0)
	event.set_scene_status_flags(1, 32, 8, 0)
	event.set_scene_status_flags(1, 8, 8, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_character_active(1, 122)
	event.set_character_active(1, 123)
	event.stop_sound_effect(sound_bank, 6)
	event.stop_sound_effect(sound_bank, 7)
	event.clear_effect_manager()
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(8)
	event.load_message_file(0, -1)
	event.set_save_data_value(0, 7)
	character.place_standing_and_reset_cloth(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the cutscene of the steam train sliding in and the player stepping off.
local function play_steam_train_arrival()
	local sound_bank: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local train_rotation_y: f32 = 0
	local approach_angle: f32 = 0
	local common_sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or sound_bank
	train.level_cars()
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m4")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m5")
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m4")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m5")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_handle_position(0, 2101.51, 40.82, 2060.52)
	event.set_object_handle_rotation(0, 0.0, -2.26, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_footstep_sound(0, 6)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		train_x = out1 or train_x
		train_y = out2 or train_y
		train_z = out3 or train_z
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(1)
		train_rotation_y = out2 or train_rotation_y
	end
	approach_angle = vm.f32(train_rotation_y - vm.f32(3.1415927))
	approach_angle = event.wrap_angle(approach_angle) or approach_angle
	start_x = vm.f32(vm.f32(vm.sin(approach_angle) * 200.0) + train_x)
	start_y = train_y
	start_z = vm.f32(vm.f32(vm.cos(approach_angle) * 200.0) + train_z)
	event.set_object_handle_position(1, start_x, start_y, start_z)
	event.move_object_sequence_eased(1, train_x, train_y, train_z, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1514.63, 208.98, 2402.32)
	event.set_camera_sequence_look_at(1792.39, 155.32, 2165.78)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("列車煙")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 1)
	event.play_sound_effect(sound_bank, 0)
	event.fade_in_screen(30)
	object.wait_until_done(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	train.tilt_cars()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_camera_sequence_position(1899.12, 13.68, 1889.27)
	event.set_camera_sequence_look_at(1958.62, 31.92, 1939.67)
	common_sound_bank = event.get_sound_id(2) or common_sound_bank
	event.play_sound_effect(common_sound_bank, 106)
	event.set_character_active(0)
	event.set_object_handle_position(1, train_x, train_y, train_z)
	event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
	event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
	wait.for_frame_count(30)
	event.set_object_sequence_motion(0, "走り")
	event.delay_object_sequence_motion_track(0, 56)
	event.set_object_sequence_motion(0, "立ち")
	event.move_object_sequence(0, 2087.08, 40.82, 2048.3, 14)
	event.move_object_sequence(0, 2037.85, 0.0, 2005.99, 32)
	event.move_object_sequence(0, 2017.4, 0.0, 1988.67, 10)
	wait.for_frame_count(46)
	event.set_object_handle_footstep_sound(0, 16)
	event.fade_out_screen(15)
	wait.for_frame_count(15)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_character_active(0)
	character.place_standing_and_reset_cloth(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.clear_effect_manager()
	event.fade_in_screen(15)
end

--- Plays the cutscene of the train sliding in and the player stepping off.
local function play_train_arrival()
	local sound_bank: s32 = 0
	local carriage_part_x: f32 = 0
	local carriage_part_y: f32 = 0
	local carriage_part_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local train_rotation_y: f32 = 0
	local approach_angle: f32 = 0
	local common_sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or sound_bank
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
	do
		local out1, out2, out3 = event.get_object_handle_position(5)
		carriage_part_x = out1 or carriage_part_x
		carriage_part_y = out2 or carriage_part_y
		carriage_part_z = out3 or carriage_part_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		train_x = out1 or train_x
		train_y = out2 or train_y
		train_z = out3 or train_z
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(1)
		train_rotation_y = out2 or train_rotation_y
	end
	approach_angle = vm.f32(train_rotation_y - vm.f32(3.1415927))
	approach_angle = event.wrap_angle(approach_angle) or approach_angle
	start_x = vm.f32(vm.f32(vm.sin(approach_angle) * 200.0) + train_x)
	start_y = train_y
	start_z = vm.f32(vm.f32(vm.cos(approach_angle) * 200.0) + train_z)
	event.set_object_handle_position(1, start_x, start_y, start_z)
	event.move_object_sequence_eased(1, train_x, train_y, train_z, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1514.63, 208.98, 2402.32)
	event.set_camera_sequence_look_at(1792.39, 155.32, 2165.78)
	event.fade_in_screen(30)
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(1)
	event.set_camera_sequence_position(1890.88, 13.68, 2033.57)
	event.set_camera_sequence_look_at(1970.25, 31.92, 2037.52)
	event.set_character_active(0)
	event.set_object_handle_position(1, train_x, train_y, train_z)
	event.set_object_sequence_position(0, 2125.0, 40.0, 2080.0)
	event.set_object_sequence_rotation(0, 0.0, -2.26, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
	common_sound_bank = event.get_sound_id(2) or common_sound_bank
	event.play_sound_effect(common_sound_bank, 92)
	wait.for_frame_count(30)
	event.move_object_sequence(5, carriage_part_x + 11.25, carriage_part_y - 4.75, carriage_part_z, 30)
	wait.for_frame_count(20)
	event.move_object_sequence(0, 2050.0, 0.0, 2015.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.for_frame_count(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, train_x, train_y, train_z)
	event.set_object_handle_rotation(1, 0.0, train_rotation_y, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, carriage_part_x, carriage_part_y, carriage_part_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_character_active(0)
	character.place_standing_and_reset_cloth(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(15)
end

--- Waits out the transition frames that follow the run into the stop and repositions the player.
local function finish_run_into_stop()
	cutscene.skip_command(1)
	wait.skip_frame_count(30)
	wait.skip_frame_count(20)
	cutscene.skip_command(0)
	wait.skip_frame_count(10)
	cutscene.ignore_coordinates(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
end

--- Asks whether to leave the stop and either runs the player out or steps them back into it.
local function confirm_leave_stop()
	local answer: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		resume_step = 1
		answer = message.ask_yes_no(5, 3)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
			event.set_camera_sequence_position(2590.33, 108.76, 1218.81)
			event.set_camera_sequence_look_at(2591.54, 130.16, 1030.59)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 70)
			event.add_object_sequence_path_point(0, 2616.58, 125.16, 846.91)
			event.add_object_sequence_path_point(0, 2674.4, 138.96, 765.84)
			event.add_object_sequence_path_point(0, 2730.28, 163.23, 630.94)
			event.start_object_sequence_path(0)
			resume_step = 2
			wait.for_frame_count(50)
			event.fade_out_screen(20)
			resume_step = 3
			wait.for_frame_count(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(-0.42)) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(-0.42)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				y = vm.f32(y + 30.0)
				event.set_camera_look_at(x, y, z)
				i = i + 1
				resume_step = 4
				vm.wait(4)
			end
		end
		event.set_object_handle_footstep_sound(0, 0)
		return 0
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				wait.skip_frame_count(50)
			end
			if resume_step <= 2 then
				wait.skip_frame_count(20)
			end
			return 1
		end
		if resume_step <= 4 then
			return 0
		end
		return nil
	end)
end

--- Asks whether to leave when the stop is ready and otherwise lets the partner talk.
local function talk_to_partner_about_leaving()
	local character_slot: s32 = 0
	local is_ready_to_leave: s32 = 0
	local now_map_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local original_rotation: f32 = 0
	local player_chara: s32 = 0
	local choice: any = 0
	local now_party_chara_id: s32 = 0
	local now_map_no_2: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local triggered_character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	is_ready_to_leave = 0
	now_map_no = event.get_current_map() or now_map_no
	if now_map_no == 16 then
		flag = event.get_save_flag(280) or flag
		flag_2 = event.get_save_flag(283) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			is_ready_to_leave = 1
		end
	end
	if now_map_no == 54 then
		flag_3 = event.get_save_flag(372) or flag_3
		flag_4 = event.get_save_flag(360) or flag_4
		if flag_3 ~= 0 and flag_4 == 0 then
			is_ready_to_leave = 1
		end
	end
	if now_map_no == 83 then
		flag_5 = event.get_save_flag(448) or flag_5
		flag_6 = event.get_save_flag(452) or flag_6
		if flag_5 ~= 0 and flag_6 == 0 then
			is_ready_to_leave = 1
		end
	end
	if is_ready_to_leave == 1 then
		message.set_window_mode(0, 1)
		original_rotation = cutscene.begin_talk(character_slot, 0, 0)
		player_chara = event.get_player_character_slot() or player_chara
		event.open_message_window_2(0, "出発するか？")
		message.say_bubble(0, -1, character_slot, player_chara, 0)
		event.set_character_motion(character_slot, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "うん！\nもう少しここにいるよ。")
		choice = message.ask_choice(0, -1, 5, 256, 208, 2, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_bubble_tail(0, 1)
		if choice ~= 0 then
			event.set_character_motion(character_slot, "会話")
			event.open_message_window_2(0, "うむ、しっかりがんばるんじゃぞ。")
			message.say_bubble(0, -1, character_slot, player_chara, 0)
		end
		cutscene.end_talk(character_slot, original_rotation, 0, 0)
		if choice == 0 then
			return
		else
			return
		end
	end
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if now_party_chara_id == 1 then
		message.set_window_mode(0, 1)
		event.open_message_window_2(0, "二人とも気をつけてな。")
		now_map_no_2 = event.get_current_map() or now_map_no_2
		flag_7 = event.get_save_flag(300) or flag_7
		if now_map_no_2 == 16 and flag_7 == 0 then
			event.open_message_window_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
		end
		flag_8 = event.get_save_flag(400) or flag_8
		if now_map_no_2 == 54 and flag_8 == 0 then
			event.open_message_window_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
		end
		flag_9 = event.get_save_flag(500) or flag_9
		if now_map_no_2 == 83 and flag_9 == 0 then
			event.open_message_window_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
		end
		cutscene.talk(character_slot, -1, 0, 0)
	else
		triggered_character_slot = event.get_triggered_event_data_2(13) or triggered_character_slot
		party.talk_to_recruit(triggered_character_slot, 1)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing for this map.
function script.setup() end

script.reset_stop_scene = reset_stop_scene
script[99] = script.reset_stop_scene

--- Plays the arrival matching how the player came to the stop.
function script.default_event()
	local old_map_no: s32 = 0
	local map_type: s32 = 0
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local train_station_counter: s32 = 0
	local chapter: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		reset_stop_scene()
		old_map_no = event.get_previous_map() or old_map_no
		map_type = event.get_map_type() or map_type
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			character.place_standing_and_reset_cloth(vm.f32(2373.8), 0.0, vm.f32(1497.9), vm.f32(-2.17))
			event.reset_follow_camera(1, 0.0, 20.0)
		elseif map_type ~= -1 then
			if old_map_no == 3 then
				resume_step = 1
				run_into_stop()
			else
				flag = event.get_save_flag(452) or flag
				flag_2 = event.get_save_flag(500) or flag_2
				if flag == 1 and flag_2 == 0 then
					resume_step = 2
					play_train_arrival_cutscene()
					heim_rada_stop.spawn_villager()
					event.set_npc_party_status(2, 130)
					event.set_npc_party_status(13, 130)
					return
				end
				train_station_counter = event.get_save_counter(1) or train_station_counter
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and train_station_counter == 5 then
					train.place_player_at_saved_platform()
					event.fade_in_screen(15)
					event.reset_follow_camera(1, 0.0)
				else
					chapter = event.get_chapter() or chapter
					if chapter ~= 6 and chapter ~= 7 then
						resume_step = 3
						play_steam_train_arrival()
					else
						resume_step = 4
						play_train_arrival()
					end
				end
			end
		end
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_train_arrival_cutscene()
				return vm.continue_with(function()
					heim_rada_stop.spawn_villager()
					event.set_npc_party_status(2, 130)
					event.set_npc_party_status(13, 130)
					return
				end)
			end
			heim_rada_stop.noop()
			return 0
		end
		if resume_step <= 4 then
			if resume_step <= 3 then
				finish_run_into_stop()
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_train_arrival

--- Asks to board a train and starts the matching departure.
function script.board_train()
	local answer: s32 = 0
	local chapter: s32 = 0
	local train_route: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		answer = menu.ask_enter_or_depart()
		if answer ~= 1 then
			return
		end
		event.set_save_counter(1, 5)
		chapter = event.get_chapter() or chapter
		train_route = event.get_triggered_event_data_2(3) or train_route
		if train_route <= 1 then
			if chapter ~= 6 and chapter ~= 7 then
				resume_step = 2
				train.board_short_train_primary()
				event.stop_music(0)
				resume_step = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				resume_step = 4
				train.board_short_train_primary()
				event.stop_music(0)
				resume_step = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			resume_step = 6
			vm.wait(6)
		elseif chapter ~= 6 and chapter ~= 7 then
			resume_step = 7
			train.board_train_primary(1)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			resume_step = 8
			train.board_via_gangway_main()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			return 0
		end
		if resume_step <= 8 then
			if resume_step <= 3 then
				map.run_train_interval_waits()
			end
			if resume_step <= 6 then
				map.print_train_debug_info(1)
			end
			if resume_step <= 7 then
				train.skip_board_via_gangway_main()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.board_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_type_7

--- Places the player at the stop after a cutscene and fades in.
function script.enter_stop_after_cutscene()
	reset_stop_scene()
	character.place_standing_and_reset_cloth(2288.0, 0.0, 1488.0, vm.f32(0.87))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end
script[510] = script.enter_stop_after_cutscene

--- Leaves the stop for the next area after confirmation.
function script.leave_stop()
	local flag: s32 = 0
	if confirm_leave_stop() ~= 0 then
		flag = event.get_save_flag(504) or flag
		if flag == 0 then
			event.jump_to_map_3(-1, "s41", 501)
			vm.wait(2)
		else
			event.jump_to_map_2(-1, "g04")
			vm.wait(3)
		end
	end
end
script[550] = script.leave_stop

--- Talks to the partner or announces that the other party is waiting outside.
function script.talk_to_npc()
	local npc_id: s32 = 0
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	if npc_id == 1 then
		talk_to_partner_about_leaving()
	end
	if npc_id == 301 then
		party.talk_to_waiting_npc()
	end
end
script[1000] = script.talk_to_npc

--- Replays the train arrival cutscene.
function script.replay_train_arrival_cutscene()
	event.set_save_flag(500, 0)
	reset_stop_scene()
	play_train_arrival_cutscene()
	heim_rada_stop.spawn_villager()
end
script[15000] = script.replay_train_arrival_cutscene

return script
