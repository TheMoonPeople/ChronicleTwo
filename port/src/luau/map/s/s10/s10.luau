--!strict
-- map/s/s10/s10.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_01a87d28 = require("@lib/event/helper_01a87d28")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0d0a5438 = require("@lib/event/helper_0d0a5438")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_3efe4328 = require("@lib/event/helper_3efe4328")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_5d8e6e04 = require("@lib/event/helper_5d8e6e04")
local helper_6cc2fba1 = require("@lib/event/helper_6cc2fba1")
local helper_82f69831 = require("@lib/event/helper_82f69831")
local helper_84a2c453 = require("@lib/event/helper_84a2c453")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_b76e3b36 = require("@lib/event/helper_b76e3b36")
local helper_b7a01b67 = require("@lib/event/helper_b7a01b67")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_cce8673f = require("@lib/event/helper_cce8673f")
local helper_ce60ccd6 = require("@lib/event/helper_ce60ccd6")
local helper_cf15df04 = require("@lib/event/helper_cf15df04")
local helper_d552d8eb = require("@lib/event/helper_d552d8eb")
local helper_dae6aadb = require("@lib/event/helper_dae6aadb")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	helper_4337dd96()
	helper_d552d8eb()
	helper_82f69831()
end

--- Helper function.
local function helper_26034()
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
	helper_888ab2a3(40)
	event.fade_out_screen(15)
	helper_888ab2a3(15)
	event.set_object_handle_footstep_sound(0, 0)
	helper_9dafbc83(vm.f32(2358.3), 0.0, vm.f32(1357.7), vm.f32(0.06))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_28f5c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(500, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(5200)
		var0 = event.load_sound_effect_file_2(5200) or var0
		event.play_sound_effect(var0, 0)
		event.stop_sound_effect(var0, 0)
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
		event.play_object_sequence_sound(2, var0, 6)
		helper_888ab2a3(90)
		event.set_object_handle_visible(19, 1)
		event.set_object_handle_visible(20, 1)
		event.set_character_active(36)
		event.set_character_active(37)
		event.set_object_sequence_motion(19, "ｴﾌｪｸﾄ_火花", 4)
		event.set_object_sequence_motion(20, "ｴﾌｪｸﾄ_火花", 4)
		helper_888ab2a3(30)
		event.set_character_visible(36, 0, 1, 0.1)
		event.set_character_visible(37, 0, 1, 0.1)
		event.set_character_active(34)
		event.set_character_active(35)
		event.set_object_handle_visible(17, 1)
		event.set_object_handle_visible(18, 1)
		event.set_object_sequence_motion(17, "ぶしゅー", 6)
		event.set_object_sequence_motion(18, "ぶしゅー", 6)
		event.wait_object_sequence_motion_end(17)
		wait_objects(2)
		helper_888ab2a3(75)
		event.set_character_active(0, 34)
		event.set_character_active(0, 35)
		event.fade_out_screen(20)
		helper_888ab2a3(20)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.stop_all_sounds()
		event.set_sound_reverb_enabled(0)
		event.show_chapter_title(5)
		vm.wait(7)
		event.set_sound_reverb_enabled(1)
		helper_888ab2a3(30)
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
		helper_888ab2a3(5)
		event.play_sound_effect(var0, 7)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		helper_888ab2a3(25)
		helper_888ab2a3(30)
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
		helper_888ab2a3(30)
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
		helper_888ab2a3(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(5000020, 60)
		event.reset_mouth_texture_animations()
		helper_888ab2a3(30)
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
		helper_888ab2a3(30)
		event.set_scene_status_flags(1, 0, 8, 0)
		event.set_scene_status_flags(1, 32, 8, 0)
		event.set_scene_status_flags(1, 8, 8, 0)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_0382f327(5000030, 180)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_0382f327(5000040, 150)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		helper_4116e6bb(5000045)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		helper_4116e6bb(5000050)
		wait_objects(0)
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
		helper_4116e6bb(5000060)
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
		helper_0382f327(5000070, 200)
		event.set_object_sequence_motion(12, "会話", 6)
		event.queue_object_sequence_next_motion(12, "立ち", 4)
		event.set_object_sequence_texture_animation(12, 0)
		event.set_object_sequence_texture_animation(12, 1, "目パチ")
		event.set_mouth_texture_animations(12, "口パク")
		helper_4116e6bb(5000080)
		event.reset_mouth_texture_animations()
		event.apply_message_window_preset(1, 4)
		set_window_mode(1, 4)
		event.open_message_window_2(1, "ボルネオとトムは、ジオラマに\n配置できるようになった。")
		show_message(1, -1, 8, 0, 0)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
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
	event.stop_sound_effect(var0, 6)
	event.stop_sound_effect(var0, 7)
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
	helper_9dafbc83(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_2798c()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local rot_y: f32 = 0
	local angle: f32 = 0
	local var11: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or var0
	helper_b76e3b36()
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
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(1)
		rot_y = out2 or rot_y
	end
	angle = vm.f32(rot_y - vm.f32(3.1415927))
	angle = event.wrap_angle(angle) or angle
	pos_x = vm.f32(vm.f32(vm.sin(angle) * 200.0) + pos_x_2)
	pos_y = pos_y_2
	pos_z = vm.f32(vm.f32(vm.cos(angle) * 200.0) + pos_z_2)
	event.set_object_handle_position(1, pos_x, pos_y, pos_z)
	event.move_object_sequence_eased(1, pos_x_2, pos_y_2, pos_z_2, 40, 2, 1.0)
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
	event.play_sound_effect(var0, 0)
	event.fade_in_screen(30)
	wait_objects(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	helper_d552d8eb()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_camera_sequence_position(1899.12, 13.68, 1889.27)
	event.set_camera_sequence_look_at(1958.62, 31.92, 1939.67)
	var11 = event.get_sound_id(2) or var11
	event.play_sound_effect(var11, 106)
	event.set_character_active(0)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
	event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(0, "走り")
	event.delay_object_sequence_motion_track(0, 56)
	event.set_object_sequence_motion(0, "立ち")
	event.move_object_sequence(0, 2087.08, 40.82, 2048.3, 14)
	event.move_object_sequence(0, 2037.85, 0.0, 2005.99, 32)
	event.move_object_sequence(0, 2017.4, 0.0, 1988.67, 10)
	helper_888ab2a3(46)
	event.set_object_handle_footstep_sound(0, 16)
	event.fade_out_screen(15)
	helper_888ab2a3(15)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_character_active(0)
	helper_9dafbc83(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.clear_effect_manager()
	event.fade_in_screen(15)
end

--- Helper function.
local function helper_26514()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local rot_y: f32 = 0
	local angle: f32 = 0
	local var14: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or var0
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
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(1)
		rot_y = out2 or rot_y
	end
	angle = vm.f32(rot_y - vm.f32(3.1415927))
	angle = event.wrap_angle(angle) or angle
	pos_x_2 = vm.f32(vm.f32(vm.sin(angle) * 200.0) + pos_x_3)
	pos_y_2 = pos_y_3
	pos_z_2 = vm.f32(vm.f32(vm.cos(angle) * 200.0) + pos_z_3)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.move_object_sequence_eased(1, pos_x_3, pos_y_3, pos_z_3, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1514.63, 208.98, 2402.32)
	event.set_camera_sequence_look_at(1792.39, 155.32, 2165.78)
	event.fade_in_screen(30)
	event.play_sound_effect(var0, 0)
	wait_objects(1)
	event.set_camera_sequence_position(1890.88, 13.68, 2033.57)
	event.set_camera_sequence_look_at(1970.25, 31.92, 2037.52)
	event.set_character_active(0)
	event.set_object_handle_position(1, pos_x_3, pos_y_3, pos_z_3)
	event.set_object_sequence_position(0, 2125.0, 40.0, 2080.0)
	event.set_object_sequence_rotation(0, 0.0, -2.26, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
	var14 = event.get_sound_id(2) or var14
	event.play_sound_effect(var14, 92)
	helper_888ab2a3(30)
	event.move_object_sequence(5, pos_x + 11.25, pos_y - 4.75, pos_z, 30)
	helper_888ab2a3(20)
	event.move_object_sequence(0, 2050.0, 0.0, 2015.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	wait_objects(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, pos_x_3, pos_y_3, pos_z_3)
	event.set_object_handle_rotation(1, 0.0, rot_y, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, pos_x, pos_y, pos_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_character_active(0)
	helper_9dafbc83(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(15)
end

--- Helper function.
local function helper_23400000()
	helper_238b5abc(1)
	helper_038a2e4d(30)
	helper_038a2e4d(20)
	helper_238b5abc(0)
	helper_038a2e4d(10)
	helper_43f02c95(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
end

--- Helper function.
local function helper_25644()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		var0 = helper_ed4dc120(5, 3)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.set_camera_sequence_position(2590.33, 108.76, 1218.81)
			event.set_camera_sequence_look_at(2591.54, 130.16, 1030.59)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 70)
			event.add_object_sequence_path_point(0, 2616.58, 125.16, 846.91)
			event.add_object_sequence_path_point(0, 2674.4, 138.96, 765.84)
			event.add_object_sequence_path_point(0, 2730.28, 163.23, 630.94)
			event.start_object_sequence_path(0)
			at = 2
			helper_888ab2a3(50)
			event.fade_out_screen(20)
			at = 3
			helper_888ab2a3(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(-0.42)) * 30.0) + var1)
			var5 = 0.0
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(-0.42)) * 30.0) + var3)
			event.move_object_sequence(0, var4, var5, var6, 30, 1)
			event.turn_object_sequence_toward(0, var4, var5, var6, 10)
			event.set_object_sequence_motion(0, "歩き")
			var7 = 0
			while var7 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				var2 = vm.f32(var2 + 30.0)
				event.set_camera_look_at(var1, var2, var3)
				var7 = var7 + 1
				at = 4
				vm.wait(4)
			end
		end
		event.set_object_handle_footstep_sound(0, 0)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(50)
			end
			if at <= 2 then
				helper_038a2e4d(20)
			end
			return 1
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_24064()
	local var0: s32 = 0
	local var1: s32 = 0
	local now_map_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local var9: f32 = 0
	local player_chara: s32 = 0
	local var11: any = 0
	local now_party_chara_id: s32 = 0
	local now_map_no_2: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local var17: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	var1 = 0
	now_map_no = event.get_current_map() or now_map_no
	if now_map_no == 16 then
		flag = event.get_save_flag(280) or flag
		flag_2 = event.get_save_flag(283) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var1 = 1
		end
	end
	if now_map_no == 54 then
		flag_3 = event.get_save_flag(372) or flag_3
		flag_4 = event.get_save_flag(360) or flag_4
		if flag_3 ~= 0 and flag_4 == 0 then
			var1 = 1
		end
	end
	if now_map_no == 83 then
		flag_5 = event.get_save_flag(448) or flag_5
		flag_6 = event.get_save_flag(452) or flag_6
		if flag_5 ~= 0 and flag_6 == 0 then
			var1 = 1
		end
	end
	if var1 == 1 then
		set_window_mode(0, 1)
		var9 = helper_4e93f9fc(var0, 0, 0)
		player_chara = event.get_player_character_slot() or player_chara
		event.open_message_window_2(0, "出発するか？")
		helper_0ffc2526(0, -1, var0, player_chara, 0)
		event.set_character_motion(var0, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "うん！\nもう少しここにいるよ。")
		var11 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_bubble_tail(0, 1)
		if var11 ~= 0 then
			event.set_character_motion(var0, "会話")
			event.open_message_window_2(0, "うむ、しっかりがんばるんじゃぞ。")
			helper_0ffc2526(0, -1, var0, player_chara, 0)
		end
		helper_5d8e6e04(var0, var9, 0, 0)
		if var11 == 0 then
			return
		else
			return
		end
	end
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if now_party_chara_id == 1 then
		set_window_mode(0, 1)
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
		helper_1c04a0eb(var0, -1, 0, 0)
	else
		var17 = event.get_triggered_event_data_2(13) or var17
		helper_dae6aadb(var17, 1)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local old_map_no: s32 = 0
	local var1: s32 = 0
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event_99()
		old_map_no = event.get_previous_map() or old_map_no
		var1 = event.get_map_type() or var1
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			helper_9dafbc83(vm.f32(2373.8), 0.0, vm.f32(1497.9), vm.f32(-2.17))
			event.reset_follow_camera(1, 0.0, 20.0)
		elseif var1 ~= -1 then
			if old_map_no == 3 then
				at = 1
				helper_26034()
			else
				flag = event.get_save_flag(452) or flag
				flag_2 = event.get_save_flag(500) or flag_2
				if flag == 1 and flag_2 == 0 then
					at = 2
					helper_28f5c()
					helper_82f69831()
					event.set_npc_party_status(2, 130)
					event.set_npc_party_status(13, 130)
					return
				end
				var5 = event.get_save_counter(1) or var5
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var5 == 5 then
					helper_946c0402()
					event.fade_in_screen(15)
					event.reset_follow_camera(1, 0.0)
				else
					var6 = event.get_chapter() or var6
					if var6 ~= 6 and var6 ~= 7 then
						at = 3
						helper_2798c()
					else
						at = 4
						helper_26514()
					end
				end
			end
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_28f5c()
				return vm.continue_with(function()
					helper_82f69831()
					event.set_npc_party_status(2, 130)
					event.set_npc_party_status(13, 130)
					return
				end)
			end
			helper_01a87d28()
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_23400000()
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_26514

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_3efe4328()
		if var0 ~= 1 then
			return
		end
		event.set_save_counter(1, 5)
		var1 = event.get_chapter() or var1
		var2 = event.get_triggered_event_data_2(3) or var2
		if var2 <= 1 then
			if var1 ~= 6 and var1 ~= 7 then
				at = 2
				helper_cf15df04()
				event.stop_music(0)
				at = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				at = 4
				helper_cf15df04()
				event.stop_music(0)
				at = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			at = 6
			vm.wait(6)
		elseif var1 ~= 6 and var1 ~= 7 then
			at = 7
			helper_cce8673f(1)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			at = 8
			helper_0d0a5438()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			return 0
		end
		if at <= 8 then
			if at <= 3 then
				helper_6cc2fba1()
			end
			if at <= 6 then
				helper_84a2c453(1)
			end
			if at <= 7 then
				helper_b7a01b67()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	event_99()
	helper_9dafbc83(2288.0, 0.0, 1488.0, vm.f32(0.87))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local flag: s32 = 0
	if helper_25644() ~= 0 then
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

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	if var0 == 1 then
		helper_24064()
	end
	if var0 == 301 then
		helper_ce60ccd6()
	end
end

--- Event 15000, which map data, a script or the engine runs by number.
function script.event_15000()
	event.set_save_flag(500, 0)
	event_99()
	helper_28f5c()
	helper_82f69831()
end

return script
