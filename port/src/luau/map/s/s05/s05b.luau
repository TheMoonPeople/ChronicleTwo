--!strict
-- map/s/s05/s05b.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_04c5554b = require("@lib/event/helper_04c5554b")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_7babd1cd = require("@lib/event/helper_7babd1cd")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_bb23ef44 = require("@lib/event/helper_bb23ef44")
local helper_da5ae2ed = require("@lib/event/helper_da5ae2ed")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_fc5948a6 = require("@lib/event/helper_fc5948a6")
local show_message = require("@lib/event/show_message")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_12f74()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e230/e230_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e230/e230_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e230/e230_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e230/e230_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e230/e230_utan.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e200/e230/e230_dokuring.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(3, 38)
	event.load_character(5, "event/e200/e230/e230_dokuring.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(4, 39)
	event.load_character(5, "event/e200/e230/e230_dokuring.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(5, 40)
	event.load_character(5, "event/e200/e230/e230_dokuring.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(6, 41)
	event.load_message_file(0, 5, "event/e200/e230/e230.txt")
end

--- Helper function.
local function helper_21700000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_12be8()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
end

--- Helper function.
local function helper_1403c()
	local var1: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(230, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 0)
		event.load_map_sounds(2806)
		var1 = event.load_sound_effect_file_2(2806) or var1
		helper_12f74()
		event.set_character_active(0, 8)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(108)
		event.play_music(0)
		event.enable_drama_skip()
		event.set_character_active(1, 34)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_character_active(1, 40)
		event.set_character_active(1, 41)
		event.set_object_sequence_position(2, -1968.66, 0.4, 1106.69)
		event.set_object_sequence_rotation(2, 0.0, 2.32, 0.0)
		event.set_character_position(38, -1923.31, 1.37, 1057.48)
		event.set_character_rotation(38, 3.1415927, 0.0, 0.0)
		event.set_character_position(39, -1919.91, 1.37, 1053.89)
		event.set_character_position(40, -1919.01, 1.37, 1057.56)
		event.set_character_position(41, -1925.65, 1.37, 1055.86)
		event.set_character_rotation(39, 3.1415927, 0.0, 0.0)
		event.set_character_rotation(40, 3.1415927, 0.0, 0.0)
		event.set_character_rotation(41, 3.1415927, 0.0, 0.0)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.fade_in_screen(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(180)
		event.add_camera_sequence_path_point(-1867.73, 11.94, 1125.15, -1943.18, 24.02, 1082.8)
		event.add_camera_sequence_path_point(-1857.2, 11.94, 1093.33, -1943.18, 24.02, 1082.8)
		event.add_camera_sequence_path_point(-1857.15, 11.94, 1072.13, -1943.18, 24.02, 1082.8)
		event.add_camera_sequence_path_point(-1864.74, 11.94, 1045.69, -1943.18, 24.02, 1082.8)
		event.add_camera_sequence_path_point(-1881.33, 11.94, 1021.81, -1943.18, 24.02, 1082.8)
		event.add_camera_sequence_path_point(-1901.11, 11.94, 1006.72, -1943.18, 24.02, 1082.8)
		event.add_camera_sequence_path_point(-1932.2, 11.94, 996.46, -1943.18, 24.02, 1082.8)
		event.add_camera_sequence_path_point(-1940.25, 11.94, 995.79, -1943.18, 24.02, 1082.8)
		event.start_camera_sequence_path()
		at = 3
		helper_888ab2a3(150)
		event.start_crossfade(0, 0, 30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1733.89, 14.82, 832.21)
		event.set_camera_sequence_look_at(-1680.25, 22.42, 836.47)
		event.set_object_sequence_position(0, -1681.29, 0.4, 845.23)
		event.set_object_sequence_rotation(0, 0.0, -1.04, 0.0)
		event.set_object_sequence_position(1, -1693.53, 0.4, 827.18)
		event.set_object_sequence_rotation(1, 0.0, -0.84, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 4
		helper_4116e6bb(2300010)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "右向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右向くL", 0)
		at = 5
		helper_888ab2a3(17)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 6
		helper_4116e6bb(2300020)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		at = 7
		helper_888ab2a3(17)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 8
		helper_4116e6bb(2300030)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 9
		helper_4116e6bb(2300035)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く戻り", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 10
		helper_888ab2a3(9)
		event.set_object_sequence_motion(0, "右向く戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 11
		helper_4116e6bb(2300040)
		event.reset_mouth_texture_animations()
		at = 12
		wait_objects(0)
		event.set_object_sequence_motion(0, "走り", 0)
		event.set_object_sequence_motion(1, "走り", 0)
		event.move_object_sequence(0, -1707.23, 0.4, 923.25, 45)
		event.move_object_sequence(1, -1730.82, 0.4, 869.79, 20)
		at = 13
		helper_888ab2a3(20)
		event.start_crossfade(30)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_camera_sequence_position(-1942.18, 117.19, 1202.58)
		event.set_camera_sequence_look_at(-1947.7, 30.54, 1110.87)
		event.set_object_sequence_position(0, -1786.46, 0.4, 1010.21)
		event.set_object_sequence_rotation(0, 0.0, -1.04, 0.0)
		event.set_object_sequence_position(1, -1833.95, 0.4, 966.71)
		event.set_object_sequence_rotation(1, 0.0, -0.84, 0.0)
		event.move_object_sequence(0, -1898.83, 0.4, 1075.37, 45)
		event.move_object_sequence(1, -1912.91, 0.4, 1046.41, 30)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.delay_object_sequence_motion_track(1, 6)
		event.set_object_sequence_motion(1, "上向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "上向くL", 0)
		at = 14
		helper_888ab2a3(45)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.delay_object_sequence_motion_track(0, 6)
		event.set_object_sequence_motion(0, "上向く", 6, -1.0, 1)
		event.set_object_sequence_motion(0, "上向くL", 0)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 15
		helper_4116e6bb(2300050)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "座り会話", 2)
		event.queue_object_sequence_next_motion(2, "E230座り", 0)
		event.set_mouth_motions(2, "会話２", 0, "E230座り", 0)
		at = 16
		helper_4116e6bb(2300060)
		event.reset_mouth_motions()
		event.set_mouth_motions(2, "会話２", 0, "E230座り", 0)
		at = 17
		helper_4116e6bb(2300070)
		event.reset_mouth_motions()
		event.set_mouth_motions(2, "会話２", 0, "E230座り", 0)
		at = 18
		helper_4116e6bb(2300075)
		event.set_object_sequence_motion(2, "E230座り", 0)
		event.set_camera_sequence_position(-1884.57, 13.71, 1027.61)
		event.set_camera_sequence_look_at(-1927.88, 26.89, 1070.06)
		event.set_object_sequence_position(0, -1903.73, 0.4, 1060.72)
		event.set_object_sequence_rotation(0, 0.0, -0.8, 0.0)
		event.set_object_sequence_position(1, -1920.27, 0.4, 1046.47)
		event.set_object_sequence_rotation(1, 0.0, -0.72, 0.0)
		event.set_object_sequence_position(2, -1968.66, 0.4, 1106.69)
		event.set_object_sequence_rotation(2, 0.0, 2.32, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 19
		helper_4116e6bb(2300080)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "会話２", 4)
		event.set_mouth_motions(2, "会話２", 0, "会話２", 0)
		at = 20
		helper_0382f327(2300090, 360)
		event.reset_mouth_motions()
		event.set_mouth_motions(2, "会話２", 0, "E230座り", 0)
		at = 21
		helper_4116e6bb(2300100)
		event.reset_mouth_motions()
		event.set_object_sequence_motion(2, "しょぼくれ入り", 6)
		event.queue_object_sequence_next_motion(2, "しょぼくれ", 4)
		at = 22
		wait_objects(2)
		event.set_mouth_motions(2, "しょぼくれ会話２", 0, "しょぼくれ", 0)
		at = 23
		helper_4116e6bb(2300110)
		event.reset_mouth_motions()
		event.set_mouth_motions(2, "しょぼくれ会話２", 0, "しょぼくれ", 0)
		at = 24
		helper_4116e6bb(2300120)
		event.reset_mouth_motions()
		event.set_camera_sequence_position(-1923.34, 17.33, 1025.86)
		event.set_camera_sequence_look_at(-1883.4, 21.14, 1020.69)
		event.set_object_sequence_position(0, -1868.48, 0.4, 1031.7)
		event.set_object_sequence_rotation(0, 0.0, -0.68, 0.0)
		event.set_object_sequence_position(1, -1885.77, 0.4, 1014.51)
		event.set_object_sequence_rotation(1, 0.0, -0.84, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.play_sound_effect(var1, 4)
		event.set_object_sequence_motion(1, "りんご取り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "りんご取りＬ", 0)
		at = 25
		helper_888ab2a3(27)
		event.set_character_position(38, 0.0, 0.0, 0.0)
		event.set_character_rotation(38, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(global1, "item", 38)
		at = 26
		helper_888ab2a3(31)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "上見から右見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 27
		helper_4116e6bb(2300130)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 28
		helper_4116e6bb(2300135)
		event.reset_mouth_texture_animations()
		event.delay_object_sequence_motion_track(0, 15)
		event.set_object_sequence_motion(0, "右見から上見", 6)
		event.queue_object_sequence_next_motion(0, "上見L", 4)
		event.set_object_sequence_motion(1, "りんご持ち上見", 6)
		at = 29
		helper_888ab2a3(10)
		event.set_object_sequence_motion(1, "りんご持ち上見会話", 2)
		event.queue_object_sequence_next_motion(1, "りんご持ち上見Ｌ", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 30
		helper_4116e6bb(2300140)
		event.reset_mouth_texture_animations()
		at = 31
		wait_objects(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 32
		helper_4116e6bb(2300150)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, global0)
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(-1942.18, 117.19, 1202.58)
		event.set_camera_sequence_look_at(-1947.7, 30.54, 1110.87)
		event.set_object_sequence_position(0, -1892.68, 0.4, 1074.49)
		event.set_object_sequence_rotation(0, 0.0, -0.92, 0.0)
		event.set_object_sequence_position(1, -1906.2, 0.4, 1049.58)
		event.set_object_sequence_rotation(1, 0.0, -0.84, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "しょぼくれ戻り", 6)
		event.queue_object_sequence_next_motion(2, "会話２", 0)
		at = 33
		helper_888ab2a3(24)
		at = 34
		helper_4116e6bb(2300160)
		event.set_object_sequence_motion(2, "E230座り", 0)
		event.set_object_sequence_motion(1, "上向く会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "上向くL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 35
		helper_4116e6bb(2300170)
		event.reset_mouth_texture_animations()
		at = 36
		wait_objects(1)
		at = 37
		helper_888ab2a3(15)
		event.set_object_sequence_motion(0, "上見から右見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "上見から左見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 38
		helper_4116e6bb(2300180)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 39
		helper_4116e6bb(2300190)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 40
		helper_4116e6bb(2300200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "右見から上見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "左見から上見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 41
		helper_888ab2a3(17)
		event.set_object_sequence_motion(0, "上向く会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "上向くL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 42
		helper_4116e6bb(2300210)
		event.reset_mouth_texture_animations()
		at = 43
		wait_objects(0)
		event.reset_object_sequence_motion(2)
		event.set_camera_sequence_position(-1885.94, 10.87, 1032.57)
		event.set_camera_sequence_look_at(-1896.84, 16.33, 1042.04)
		event.set_object_sequence_position(0, -1903.73, 0.4, 1060.72)
		event.set_object_sequence_rotation(0, 0.0, -1.04, 0.0)
		event.set_object_sequence_position(1, -1920.27, 0.4, 1046.47)
		event.set_object_sequence_rotation(1, 0.0, -0.6, 0.0)
		event.set_object_sequence_position(2, -1949.25, 0.4, 1088.25)
		event.set_object_sequence_rotation(2, 0.0, 2.32, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_object_sequence_dynamic_animation(1)
		event.queue_object_sequence_next_motion(2, "E230座り", 4)
		event.set_mouth_motions(2, "会話２", 0, "E230座り", 0)
		at = 44
		helper_4116e6bb(2300220)
		event.reset_mouth_motions()
		event.set_mouth_motions(2, "会話２", 0, "E230座り", 0)
		at = 45
		helper_4116e6bb(2300225)
		event.reset_mouth_motions()
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "上見から右見", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "上見から左見", 6)
		event.queue_object_sequence_next_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 46
		helper_4116e6bb(2300230)
		event.reset_mouth_texture_animations()
		at = 47
		wait_objects(1)
		event.set_object_sequence_motion(0, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 48
		helper_4116e6bb(2300240)
		event.reset_mouth_texture_animations()
		at = 49
		wait_objects(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 50
		helper_4116e6bb(2300250)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 51
		helper_4116e6bb(2300255)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "右向く会話", 2)
		event.queue_object_sequence_next_motion(0, "右向くL", 0)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 52
		helper_4116e6bb(2300260)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "右見から上見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "左見から上見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 53
		helper_888ab2a3(17)
		event.delay_object_sequence_motion_track(1, 15)
		event.set_object_sequence_motion(1, "上見から手振り", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 54
		helper_4116e6bb(2300270)
		event.reset_mouth_texture_animations()
		at = 55
		wait_objects(1)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, 1.72, 0.0, 10)
		event.delay_object_sequence_position_track(0, 10)
		event.move_object_sequence(0, -1836.7, 0.4, 1123.98, 45)
		event.rotate_object_sequence(1, 0.0, 1.32, 0.0, 10)
		event.delay_object_sequence_position_track(1, 10)
		event.move_object_sequence(1, -1795.02, 0.4, 1063.66, 45)
		at = 56
		helper_888ab2a3(30)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.start_crossfade(0, 0, 30)
		event.set_camera_sequence_position(-2077.67, 91.91, 1212.19)
		event.set_camera_sequence_look_at(-1941.66, 59.01, 1088.55)
		event.set_object_sequence_position(0, -1492.98, 0.4, 782.07)
		event.set_object_sequence_rotation(0, 0.0, 2.2, 0.0)
		event.set_object_sequence_position(1, -1531.9, 0.4, 770.09)
		event.set_object_sequence_rotation(1, 0.0, 2.28, 0.0)
		event.set_object_sequence_position(2, -1968.66, 0.4, 1106.69)
		event.set_object_sequence_rotation(2, 0.0, 2.32, 0.0)
		event.move_object_sequence(0, -418.74, 0.01, -210.33, 400, 1)
		event.move_object_sequence(1, -432.44, 0.01, -245.86, 400, 1)
		event.play_sound_effect(var1, 5)
		event.set_object_sequence_motion(2, "手をふる入り", 6)
		event.queue_object_sequence_next_motion(2, "手をふるL", 0)
		at = 57
		helper_0382f327(2300280, 270)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 58
		helper_888ab2a3(45)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_21700000()
			helper_038a2e4d(4)
		end
		if at <= 2 then
			helper_038a2e4d(150)
		end
		if at <= 3 then
			helper_8cd371d7(2300010)
		end
		if at <= 4 then
			helper_038a2e4d(17)
		end
		if at <= 5 then
			helper_8cd371d7(2300020)
		end
		if at <= 6 then
			helper_038a2e4d(17)
		end
		if at <= 7 then
			helper_8cd371d7(2300030)
		end
		if at <= 8 then
			helper_8cd371d7(2300035)
		end
		if at <= 9 then
			helper_038a2e4d(9)
		end
		if at <= 10 then
			helper_8cd371d7(2300040)
		end
		if at <= 11 then
			helper_238b5abc(0)
		end
		if at <= 12 then
			helper_038a2e4d(20)
		end
		if at <= 13 then
			helper_038a2e4d(45)
		end
		if at <= 14 then
			helper_8cd371d7(2300050)
		end
		if at <= 15 then
			helper_8cd371d7(2300060)
		end
		if at <= 16 then
			helper_8cd371d7(2300070)
		end
		if at <= 17 then
			helper_8cd371d7(2300075)
		end
		if at <= 18 then
			helper_8cd371d7(2300080)
		end
		if at <= 19 then
			helper_53ffe901(2300090, 360)
		end
		if at <= 20 then
			helper_8cd371d7(2300100)
		end
		if at <= 21 then
			helper_238b5abc(2)
		end
		if at <= 22 then
			helper_8cd371d7(2300110)
		end
		if at <= 23 then
			helper_8cd371d7(2300120)
		end
		if at <= 24 then
			helper_038a2e4d(27)
		end
		if at <= 25 then
			helper_038a2e4d(31)
		end
		if at <= 26 then
			helper_8cd371d7(2300130)
		end
		if at <= 27 then
			helper_8cd371d7(2300135)
		end
		if at <= 28 then
			helper_038a2e4d(10)
		end
		if at <= 29 then
			helper_8cd371d7(2300140)
		end
		if at <= 30 then
			helper_238b5abc(1)
		end
		if at <= 31 then
			helper_8cd371d7(2300150)
		end
		if at <= 32 then
			helper_038a2e4d(24)
		end
		if at <= 33 then
			helper_8cd371d7(2300160)
		end
		if at <= 34 then
			helper_8cd371d7(2300170)
		end
		if at <= 35 then
			helper_238b5abc(1)
		end
		if at <= 36 then
			helper_038a2e4d(15)
		end
		if at <= 37 then
			helper_8cd371d7(2300180)
		end
		if at <= 38 then
			helper_8cd371d7(2300190)
		end
		if at <= 39 then
			helper_8cd371d7(2300200)
		end
		if at <= 40 then
			helper_038a2e4d(17)
		end
		if at <= 41 then
			helper_8cd371d7(2300210)
		end
		if at <= 42 then
			helper_238b5abc(0)
		end
		if at <= 43 then
			helper_8cd371d7(2300220)
		end
		if at <= 44 then
			helper_8cd371d7(2300225)
		end
		if at <= 45 then
			helper_8cd371d7(2300230)
		end
		if at <= 46 then
			helper_238b5abc(1)
		end
		if at <= 47 then
			helper_8cd371d7(2300240)
		end
		if at <= 48 then
			helper_238b5abc(0)
		end
		if at <= 49 then
			helper_8cd371d7(2300250)
		end
		if at <= 50 then
			helper_8cd371d7(2300255)
		end
		if at <= 51 then
			helper_8cd371d7(2300260)
		end
		if at <= 52 then
			helper_038a2e4d(17)
		end
		if at <= 53 then
			helper_8cd371d7(2300270)
		end
		if at <= 54 then
			helper_238b5abc(1)
		end
		if at <= 55 then
			helper_038a2e4d(30)
		end
		if at <= 56 then
			helper_53ffe901(2300280, 270)
		end
		if at <= 57 then
			helper_038a2e4d(45)
		end
		return true
	end)
	at = 59
	vm.entry(59)
	event.cancel_drama_scene_skip()
	helper_12be8()
	event.set_character_active(1, 8)
	event.set_character_motion(0, "立ち")
	event.set_character_position(0, -1312.2, -15.78, 671.41)
	event.set_character_rotation(0, 0.0, 2.28, 0.0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_music(0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1, 0.0, 20.0)
end

--- Helper function.
local function helper_19a0c()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e235/e235_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e235/e235_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e235/e235_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e235/e235_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_message_file(0, 5, "event/e200/e235/e235.txt")
end

--- Helper function.
local function helper_22200000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_19734()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
end

--- Helper function.
local function helper_1a658()
	local var1: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(235, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var1 = event.load_sound_effect_file_2(2809) or var1
		helper_19a0c()
		event.stop_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(-157.76, 19.55, -353.69)
		event.set_camera_sequence_look_at(-44.18, 22.24, -324.2)
		event.set_object_sequence_position(0, -57.08, 0.0, -322.16)
		event.set_object_sequence_rotation(0, 0.0, -3.02, 0.0)
		event.set_object_sequence_position(1, -23.8, 0.0, -319.29)
		event.set_object_sequence_rotation(1, 0.0, 2.92, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.fade_in_screen(30)
		event.move_camera_sequence_angle_height_distance_eased(1.79, -2.69, 122.7, 555, 2, 0.4)
		event.set_object_sequence_motion(1, "左向く", 6, -1.0, 1)
		at = 2
		helper_888ab2a3(17)
		event.set_object_sequence_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 3
		helper_0382f327(2350010, 120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "半口顔")
		event.set_object_sequence_texture_animation(0, 1, "通常～おどろき目")
		event.play_sound_effect(var1, 4)
		event.set_object_sequence_motion(0, "驚く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "驚くL", 0)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 4
		helper_0382f327(2350020, 75)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く会話", 2)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 5
		helper_0382f327(2350030, 165)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 6
		helper_0382f327(2350035, 135)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "ユリス見会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 7
		helper_0382f327(2350040, 150)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "驚くL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 8
		helper_4116e6bb(2350050)
		event.reset_mouth_texture_animations()
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(
			0,
			"[(!)]釣り竿を装備して(O)ボタンで竿を振ります。詳しくは\n   メインメニューのヘルプの「釣り」を見てください。"
		)
		at = 9
		show_message(0, -1, 5, 0, 0)
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 10
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22200000()
			helper_038a2e4d(17)
		end
		if at <= 2 then
			helper_53ffe901(2350010, 120)
		end
		if at <= 3 then
			helper_53ffe901(2350020, 75)
		end
		if at <= 4 then
			helper_53ffe901(2350030, 165)
		end
		if at <= 5 then
			helper_53ffe901(2350035, 135)
		end
		if at <= 6 then
			helper_53ffe901(2350040, 150)
		end
		if at <= 7 then
			helper_8cd371d7(2350050)
		end
		if at <= 8 then
			helper_ee1c51d0(0, -1, 5, 0, 0)
		end
		if at <= 9 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 11
	vm.entry(11)
	event.cancel_drama_scene_skip()
	helper_19734()
	event.clear_camera_sequence()
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1bb74(arg0: s32)
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e247/e247_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e247/e247_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e247/e247_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e247/e247_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e247/e247_noam.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.set_object_handle_sound_bank(2, arg0)
	event.load_character(5, "event/e200/e247/e247_zak.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.set_object_handle_sound_bank(3, arg0)
	event.load_character(5, "event/e200/e247/e247_wicky.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.set_object_handle_sound_bank(4, arg0)
	event.load_character(5, "event/e200/e247/e247_mogri.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
	event.set_object_handle_sound_bank(6, arg0)
	event.load_message_file(0, 5, "event/e200/e247/e247.txt")
end

--- Helper function.
local function helper_22500000(arg0: s32)
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1b80c()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
end

--- Helper function.
local function helper_1cd10()
	local var1: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(247, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(2818)
		var1 = event.load_sound_effect_file_2(2818) or var1
		helper_1bb74(var1)
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(57)
		event.play_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_character_active(1, 38)
		event.fade_in_screen(30)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(1719.11, 34.0, 714.02)
		event.set_camera_sequence_look_at(1739.12, 27.98, 727.37)
		event.set_object_sequence_position(0, 1738.32, 0.01, 741.82)
		event.set_object_sequence_rotation(0, 0.0, 1.25, 0.0)
		event.set_object_sequence_position(1, 1748.79, 0.01, 715.17)
		event.set_object_sequence_rotation(1, 0.0, 0.6, 0.0)
		event.set_object_sequence_position(2, 1967.41, 0.01, 873.54)
		event.set_object_sequence_rotation(2, 0.0, -2.16, 0.0)
		event.set_object_sequence_position(3, 2381.04, 0.0, 1078.89)
		event.set_object_sequence_rotation(3, 0.0, -2.04, 0.0)
		event.set_object_sequence_position(4, 2381.04, 0.0, 1078.89)
		event.set_object_sequence_rotation(4, 0.0, -2.04, 0.0)
		event.set_object_sequence_position(6, 2381.04, 0.0, 1078.89)
		event.set_object_sequence_rotation(6, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.set_object_sequence_motion(2, "走り", 4)
		event.delay_object_sequence_motion_track(2, 45)
		event.set_object_sequence_motion(2, "立ち", 0)
		event.move_object_sequence(0, 1773.43, 0.01, 763.65, 30)
		event.move_object_sequence(1, 1786.54, 0.01, 743.76, 30)
		event.move_object_sequence(2, 1831.97, 0.01, 787.95, 45)
		at = 3
		helper_4116e6bb(2470010)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 4
		helper_4116e6bb(2470020)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		event.set_object_sequence_motion(3, "走り", 4)
		event.set_object_sequence_motion(4, "走り", 4)
		event.set_object_sequence_motion(6, "走り", 4)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 150)
		event.add_object_sequence_path_point(3, 2381.04, 0.0, 1078.89)
		event.add_object_sequence_path_point(3, 2331.11, 0.0, 1116.22)
		event.add_object_sequence_path_point(3, 2116.36, 0.0, 997.42)
		event.add_object_sequence_path_point(3, 1848.69, 0.0, 775.64)
		event.start_object_sequence_path(3)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 150)
		event.add_object_sequence_path_point(4, 2381.04, 0.0, 1078.89)
		event.add_object_sequence_path_point(4, 2276.7, 0.0, 1082.34)
		event.add_object_sequence_path_point(4, 2018.28, 0.0, 933.17)
		event.add_object_sequence_path_point(4, 1844.97, 0.01, 795.34)
		event.start_object_sequence_path(4)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 150)
		event.add_object_sequence_path_point(6, 2381.04, 0.0, 1078.89)
		event.add_object_sequence_path_point(6, 2201.8, 0.0, 1064.29)
		event.add_object_sequence_path_point(6, 1826.14, 0.01, 815.65)
		event.start_object_sequence_path(6)
		at = 5
		helper_0382f327(2470030, 150)
		event.set_character_active(0, 34)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(3, 1848.69, 0.0, 775.64)
		event.set_object_sequence_position(4, 1844.97, 0.01, 795.34)
		event.set_object_sequence_position(6, 1826.14, 0.01, 815.65)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(525)
		event.add_camera_sequence_path_point(1821.21, 20.38, 744.56, 1849.75, 16.15, 775.36)
		event.add_camera_sequence_path_point(1809.08, 20.38, 774.26, 1843.57, 16.15, 793.85)
		event.add_camera_sequence_path_point(1787.87, 20.38, 816.77, 1829.31, 16.15, 811.65)
		event.start_camera_sequence_path()
		event.set_object_sequence_motion(3, "会話", 2)
		event.queue_object_sequence_next_motion(3, "立ち", 0)
		event.open_message_window_2(0, 2470040)
		event.set_mouth_texture_animations(3, "口パク")
		at = 6
		helper_0382f327(2470040, 210)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "会話", 2)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		event.open_message_window_2(0, 2470050)
		event.set_mouth_texture_animations(4, "口パク")
		at = 7
		helper_0382f327(2470050, 165)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(6, "会話", 2)
		event.queue_object_sequence_next_motion(6, "立ち", 0)
		event.open_message_window_2(0, 2470060)
		event.set_mouth_texture_animations(6, "口パク")
		at = 8
		helper_0382f327(2470060, 150)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence()
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(1872.03, 33.39, 840.77)
		event.set_camera_sequence_look_at(1841.2, 22.59, 805.7)
		event.set_object_sequence_rotation(0, 0.0, 0.89, 0.0)
		event.set_object_sequence_position(2, 1830.92, 0.01, 806.7)
		event.set_object_sequence_rotation(2, 0.0, -2.4, 0.0)
		event.set_object_sequence_rotation(3, 0.0, -2.05, 0.0)
		event.set_object_sequence_rotation(4, 0.0, -2.27, 0.0)
		event.set_object_sequence_position(6, 1814.28, 0.01, 811.77)
		event.set_object_sequence_rotation(6, 0.0, -2.72, 0.0)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 9
		helper_4116e6bb(2470070)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(3, "会話", 2)
		event.queue_object_sequence_next_motion(3, "立ち", 0)
		event.set_mouth_texture_animations(3, "口パク")
		at = 10
		helper_4116e6bb(2470080)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "ゆびさし", 6)
		event.queue_object_sequence_next_motion(1, "ゆびさしＬ", 0)
		event.delay_object_sequence_motion_track(1, 45)
		event.set_object_sequence_motion(1, "ゆびさしＬから立ち", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 11
		helper_4116e6bb(2470090)
		event.reset_mouth_texture_animations()
		at = 12
		wait_objects(1)
		at = 13
		wait_objects(1)
		event.set_camera_sequence_position(1733.66, 30.77, 725.75)
		event.set_camera_sequence_look_at(1802.53, 17.99, 768.87)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(6, "会話", 2)
		event.queue_object_sequence_next_motion(6, "立ち", 0)
		event.set_mouth_texture_animations(6, "口パク")
		at = 14
		helper_4116e6bb(2470100)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "会話", 2)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		event.set_mouth_texture_animations(4, "口パク")
		at = 15
		helper_4116e6bb(2470110)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		at = 16
		helper_4116e6bb(2470120)
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 17
		helper_4116e6bb(2470130)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 18
		helper_4116e6bb(2470135)
		event.reset_mouth_texture_animations()
		var2 = event.get_message_window_frame(0) or var2
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(
			0,
			"[(!)]一時、シャーロットに戻りましょう。\n   このエリアに入って来た出口から出るか、\n   メインメニューの「いどう」から、\n   「いったん外に出る」を選んでください。"
		)
		at = 19
		show_message(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]「いどう」の「いったん外に出る」を選んで、\n   ダンジョンを出た場合でも、魔物がいないエリアからで\n   あればお金を失うことはありません。"
		)
		at = 20
		show_message(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, var2)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 21
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22500000(var1)
			helper_038a2e4d(4)
		end
		if at <= 2 then
			helper_8cd371d7(2470010)
		end
		if at <= 3 then
			helper_8cd371d7(2470020)
		end
		if at <= 4 then
			helper_53ffe901(2470030, 150)
		end
		if at <= 5 then
			helper_53ffe901(2470040, 210)
		end
		if at <= 6 then
			helper_53ffe901(2470050, 165)
		end
		if at <= 7 then
			helper_53ffe901(2470060, 150)
		end
		if at <= 8 then
			helper_8cd371d7(2470070)
		end
		if at <= 9 then
			helper_8cd371d7(2470080)
		end
		if at <= 10 then
			helper_8cd371d7(2470090)
		end
		if at <= 11 then
			helper_238b5abc(1)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_8cd371d7(2470100)
		end
		if at <= 14 then
			helper_8cd371d7(2470110)
		end
		if at <= 15 then
			helper_8cd371d7(2470120)
		end
		if at <= 16 then
			helper_8cd371d7(2470130)
		end
		if at <= 17 then
			helper_8cd371d7(2470135)
		end
		if at <= 18 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		if at <= 19 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		if at <= 20 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 22
	vm.entry(22)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	helper_1b80c()
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1fd7c()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e253/e253_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e253/e253_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e253/e253_utan.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(1, 34)
	event.load_character(5, "event/e200/e253/e253_rock.gltf", "info", 35)
	event.attach_object_handle_to_character(6, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 6)
	event.set_character_active(1, 35)
	event.set_character_position(35, -2303.34, 38.0002, 629.104)
	event.set_character_rotation(35, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p05_s0501", "s050111-m0")
	event.set_object_handle_position(3, -2303.34, 38.0002, 629.104)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(4, "p05_s0501", "s050102-a")
	event.set_object_handle_position(4, -2303.34, 38.0002, 629.104)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(5, "p05_s0501", "s050102-c")
	event.set_object_handle_position(5, -2303.34, 38.0002, 629.104)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(3, 0)
	event.load_message_file(0, 5, "event/e200/e253/e253.txt")
end

--- Helper function.
local function helper_22700000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1fa5c()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(35)
end

--- Helper function.
local function helper_20ec4()
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(253, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var1 = event.load_sound_effect_file_2(2821) or var1
		helper_1fd7c()
		event.set_object_handle_sound_bank(2, var1)
		event.stop_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(-1983.77, 35.19, 702.93)
		event.set_camera_sequence_look_at(-2025.3, 34.91, 704.63)
		event.set_object_sequence_position(0, -2102.17, 0.4, 705.62)
		event.set_object_sequence_rotation(0, 0.0, -0.86, 0.0)
		event.set_object_sequence_position(1, -2119.98, 0.4, 680.76)
		event.set_object_sequence_rotation(1, 0.0, -0.6, 0.0)
		event.set_object_sequence_position(2, -2202.71, 0.4, 759.61)
		event.set_object_sequence_rotation(2, 0.0, 2.16, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		at = 2
		helper_4116e6bb(2530010)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 3
		helper_4116e6bb(2530020)
		event.reset_mouth_texture_animations()
		event.set_mouth_motions(2, "立ち会話２", 0, "立ち", 0)
		at = 4
		helper_4116e6bb(2530030)
		event.reset_mouth_motions()
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		at = 5
		helper_4116e6bb(2530035)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 6
		helper_4116e6bb(2530040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 7
		helper_4116e6bb(2530050)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		at = 8
		helper_4116e6bb(2530060)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 0)
		at = 9
		helper_888ab2a3(34)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 10
		helper_4116e6bb(2530070)
		event.reset_mouth_texture_animations()
		at = 11
		wait_objects(1)
		event.play_sound_effect(var1, 6)
		event.set_object_sequence_motion(2, "左見る入り", 6)
		event.queue_object_sequence_next_motion(2, "左見るＬ", 0)
		at = 12
		helper_4116e6bb(2530080)
		at = 13
		wait_objects(2)
		event.set_object_sequence_motion(2, "左見る戻り", 6)
		event.queue_object_sequence_next_motion(2, "歩き", 0)
		at = 14
		helper_888ab2a3(48)
		event.rotate_object_sequence(2, 0.0, -2.55, 0.0, 25)
		event.move_object_sequence(2, -2250.46, 0.4, 692.44, 75)
		at = 15
		helper_888ab2a3(75)
		event.set_object_sequence_motion(2, "立ち", 0)
		at = 16
		helper_888ab2a3(10)
		event.play_sound_effect(var1, 8)
		event.set_object_sequence_motion(2, "岩触れる入り", 6)
		event.queue_object_sequence_next_motion(2, "岩触れる入りL", 0)
		at = 17
		helper_888ab2a3(27)
		do
			local out1, out2, out3 = event.get_character_position(34)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		at = 18
		helper_888ab2a3(30)
		event.set_character_active(1, 35)
		event.set_character_position(35, 0.0, 0.0, 0.0)
		event.set_character_rotation(35, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(34, "rock_null", 35)
		event.play_sound_effect(var1, 9)
		event.set_object_sequence_motion(2, "岩持ち上げ", 6)
		event.queue_object_sequence_next_motion(2, "岩持ち上げL", 0)
		at = 19
		helper_4116e6bb(2530090)
		event.set_camera_sequence_position(-2034.58, 17.54, 697.44)
		event.set_camera_sequence_look_at(-2146.5, 38.21, 676.58)
		event.set_object_sequence_position(0, -2114.19, 0.4, 672.39)
		event.set_object_sequence_rotation(0, 0.0, -1.34, 0.0)
		event.set_object_sequence_position(1, -2118.22, 0.4, 650.68)
		event.set_object_sequence_rotation(1, 0.0, -1.44, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "岩持ち歩き", 4)
		event.rotate_object_sequence(2, 0.0, 1.81, 0.0, 45)
		at = 20
		helper_888ab2a3(45)
		event.set_object_sequence_motion(2, "岩持ち上げL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 21
		helper_4116e6bb(2530100)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "岩持ち会話", 0)
		at = 22
		helper_0382f327(2530110, 135)
		at = 23
		wait_objects(2)
		event.play_sound_effect(var1, 10)
		event.delay_object_sequence_sound_track(3, 15)
		event.play_object_sequence_sound(3, var1, 11)
		event.set_object_sequence_motion(2, "腰痛める", 6)
		event.queue_object_sequence_next_motion(2, "腰痛めるL", 0)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(2, "rock_null")
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.detach_character_from_frame(35)
		event.set_object_sequence_position(3, var2, var3, var4)
		event.jump_object_sequence(3, -2343.99, 35.68, 691.66, -1.0, 15)
		event.jump_object_sequence(3, -2343.99, 35.68, 691.66, -0.05, 25)
		event.delay_camera_sequence_shake_track(15)
		event.shake_camera_sequence(0.0, 0.3, 0.0, 15)
		at = 24
		helper_4116e6bb(2530115)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 25
		helper_4116e6bb(2530120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "腰痛め会話", 0)
		at = 26
		helper_0382f327(2530130, 180)
		at = 27
		helper_0382f327(2530135, 240)
		event.play_sound_effect(var1, 13)
		event.set_object_sequence_motion(2, "座り入り", 6)
		event.queue_object_sequence_next_motion(2, "座り", 0)
		at = 28
		helper_888ab2a3(6)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "上向く戻り", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "上向く戻り", 2)
		event.queue_object_sequence_next_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		at = 29
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 30
		helper_4116e6bb(2530140)
		event.reset_mouth_texture_animations()
		at = 31
		wait_objects(1)
		event.set_object_sequence_motion(0, "手を振る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 32
		helper_4116e6bb(2530150)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		at = 33
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22700000()
			helper_8cd371d7(2530010)
		end
		if at <= 2 then
			helper_8cd371d7(2530020)
		end
		if at <= 3 then
			helper_8cd371d7(2530030)
		end
		if at <= 4 then
			helper_8cd371d7(2530035)
		end
		if at <= 5 then
			helper_8cd371d7(2530040)
		end
		if at <= 6 then
			helper_8cd371d7(2530050)
		end
		if at <= 7 then
			helper_8cd371d7(2530060)
		end
		if at <= 8 then
			helper_038a2e4d(34)
		end
		if at <= 9 then
			helper_8cd371d7(2530070)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			helper_8cd371d7(2530080)
		end
		if at <= 12 then
			helper_238b5abc(2)
		end
		if at <= 13 then
			helper_038a2e4d(48)
		end
		if at <= 14 then
			helper_038a2e4d(75)
		end
		if at <= 15 then
			helper_038a2e4d(10)
		end
		if at <= 16 then
			helper_038a2e4d(27)
		end
		if at <= 17 then
			helper_038a2e4d(30)
		end
		if at <= 18 then
			helper_8cd371d7(2530090)
		end
		if at <= 19 then
			helper_038a2e4d(45)
		end
		if at <= 20 then
			helper_8cd371d7(2530100)
		end
		if at <= 21 then
			helper_53ffe901(2530110, 135)
		end
		if at <= 22 then
			helper_238b5abc(2)
		end
		if at <= 23 then
			helper_8cd371d7(2530115)
		end
		if at <= 24 then
			helper_8cd371d7(2530120)
		end
		if at <= 25 then
			helper_53ffe901(2530130, 180)
		end
		if at <= 26 then
			helper_53ffe901(2530135, 240)
		end
		if at <= 27 then
			helper_038a2e4d(6)
		end
		if at <= 28 then
			helper_038a2e4d(15)
		end
		if at <= 29 then
			helper_8cd371d7(2530140)
		end
		if at <= 30 then
			helper_238b5abc(1)
		end
		if at <= 31 then
			helper_8cd371d7(2530150)
		end
		if at <= 32 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 34
	vm.entry(34)
	event.cancel_drama_scene_skip()
	helper_1fa5c()
	event.set_character_position(0, -2114.19, 0.4, 672.39)
	event.set_character_rotation(0, 0.0, -1.34, 0.0)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		print("kits--------------------\n")
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_1403c()
		argc = event.get_item_count(302) or argc
		if argc ~= 0 then
			event.set_save_counter(3, 3)
		end
		helper_bb23ef44()
		at = 3
		vm.wait(3)
		event.load_event_script("s05/s05.stb", -1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_1403c()
				return vm.continue_with(function()
					argc = event.get_item_count(302) or argc
					if argc ~= 0 then
						event.set_save_counter(3, 3)
					end
					helper_bb23ef44()
					at = 3
					vm.wait(3)
					event.load_event_script("s05/s05.stb", -1)
					return
				end)
			end
			if at <= 2 then
				helper_fc5948a6()
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
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_1a658()
		event.set_save_counter(3, 4)
		helper_bb23ef44()
		at = 3
		vm.wait(3)
		event.load_event_script("s05/s05.stb", -1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_1a658()
				return vm.continue_with(function()
					event.set_save_counter(3, 4)
					helper_bb23ef44()
					at = 3
					vm.wait(3)
					event.load_event_script("s05/s05.stb", -1)
					return
				end)
			end
			if at <= 2 then
				helper_fc5948a6()
			end
			return 0
		end
		return nil
	end)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	local at: number = 0
	return vm.guard(function()
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_save_counter(3, 7)
		helper_bb23ef44()
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_1cd10()
		at = 3
		vm.wait(3)
		event.load_event_script("s05/s05.stb", -1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_1cd10()
				return vm.continue_with(function()
					at = 3
					vm.wait(3)
					event.load_event_script("s05/s05.stb", -1)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	local at: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		helper_7babd1cd()
		at = 2
		helper_20ec4()
		event.set_save_counter(3, 8)
		helper_bb23ef44()
		helper_04c5554b(0)
		at = 3
		vm.wait(3)
		event.load_event_script("s05/s05.stb", -1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				helper_20ec4()
				return vm.continue_with(function()
					event.set_save_counter(3, 8)
					helper_bb23ef44()
					helper_04c5554b(0)
					at = 3
					vm.wait(3)
					event.load_event_script("s05/s05.stb", -1)
					return
				end)
			end
			if at <= 2 then
				helper_fc5948a6()
				helper_da5ae2ed(0)
			end
			return 0
		end
		return nil
	end)
end

return script
