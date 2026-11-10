--!strict
-- map/g/g01/g01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_26374f46 = require("@lib/event/helper_26374f46")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_59d97f4a = require("@lib/event/helper_59d97f4a")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8c87ba09 = require("@lib/event/helper_8c87ba09")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a15114f7 = require("@lib/event/helper_a15114f7")
local helper_afbdd04b = require("@lib/event/helper_afbdd04b")
local helper_b84429a4 = require("@lib/event/helper_b84429a4")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_e538a72d = require("@lib/event/helper_e538a72d")
local helper_ebc222ab = require("@lib/event/helper_ebc222ab")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f2e47558 = require("@lib/event/helper_f2e47558")
local helper_f4d83329 = require("@lib/event/helper_f4d83329")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	flag = event.get_save_flag(250) or flag
	if flag ~= 0 then
		event.set_save_control_bits(2, 0)
	else
		event.set_save_control_bits(2, 1)
	end
end

--- Helper function.
local function helper_224d4()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.initialize_event()
	flag = event.get_save_flag(208) or flag
	flag_2 = event.get_save_flag(207) or flag_2
	if not (flag == 0 and flag_2 == 1) then
		event.clear_camera_sequence()
		event.set_camera_sequence_position(324.12, 34.59, 830.75)
		event.set_camera_sequence_look_at(362.46, 42.77, 960.05)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 404.68, 0.0, 1124.89)
		event.set_object_sequence_rotation(0, 0.0, -2.84, 0.0)
		event.move_camera_sequence_eased(324.12, 34.59, 830.75, 377.85, 23.14, 1003.73, 48, 2, 0.25)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_object_sequence(0, 361.74, 0.0, 957.26, 60)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
		helper_888ab2a3(60)
		event.reset_follow_camera(0)
	end
end

--- Helper function.
local function helper_22ee0()
	local flag: s32 = 0
	flag = event.get_save_flag(207) or flag
	if flag == 1 then
		flag = event.get_save_flag(208) or flag
		if flag == 0 then
			event.fade_out_screen(0)
			vm.wait(1)
			event.load_event_script("g01/g01b.stb", 501)
		end
	end
end

--- Helper function.
local function helper_22b00000()
	helper_038a2e4d(60)
end

--- Helper function.
local function helper_1dd14()
	local active_chr_no: s32 = 0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e254/e254b_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e254/e254b_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 38)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e254/e254b_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e254/e254b_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
end

--- Helper function.
local function helper_22300000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1d97c()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(38)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(38)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
end

--- Helper function.
local function helper_1e9a4()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(34, 1)
		event.initialize_event()
		event.apply_message_window_preset(0, 0)
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(45)
		helper_1dd14()
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(770.06, 6.44, -898.09)
		event.set_camera_sequence_look_at(616.07, 68.13, -1043.77)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_object_sequence_position(0, 714.22, 0.0, -963.1)
		event.set_object_sequence_rotation(0, 0.0, -1.34, 0.0)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(1, 695.34, 0.0, -949.18)
		event.set_object_sequence_rotation(1, 0.0, 1.58, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.fade_in_screen(30)
		at = 2
		helper_888ab2a3(30)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(
			0,
			"今回持ち帰ったジオストーンによると、\nジュラクさまを復活させるためには、<page>このシャーロットに「木にくわしい人」を\n移住させないといけないみたいね。"
		)
		at = 3
		show_message(0, -1, 3, 0, 416)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(680.02, 12.41, -968.76)
		event.set_camera_sequence_look_at(647.47, 24.66, -996.48)
		event.set_object_sequence_position(0, 656.27, 0.0, -1003.39)
		event.set_object_sequence_rotation(0, 0.0, -0.7853982, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(1, 641.27, 0.0, -988.39)
		event.set_object_sequence_rotation(1, 0.0, 2.3561945, 0.0)
		at = 4
		vm.wait(4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "移住させる・・・？")
		at = 5
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(
			0,
			"そうよ。パームブリンクスには\n人がたくさん住んでるでしょ。<page>そういう人たちを連れて来て\n大陸中に移住させていくの。<page>そうすることで未来が\n発展していくわけね。"
		)
		at = 6
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		event.open_message_window_2(0, "ふ～ん。")
		at = 7
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.set_object_sequence_motion(1, "向き直り", 2)
		event.queue_object_sequence_next_motion(1, "向き直りL", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目～上向き目")
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "で、今回必要なのは、\n「木にくわしい人」・・・か。")
		at = 8
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		at = 9
		wait_objects(1)
		event.set_object_sequence_motion(1, "顔向け", 2)
		event.queue_object_sequence_next_motion(1, "顔向けＬ", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "上向き目～通常目")
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "ユリス、誰か知らない？")
		at = 10
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		at = 11
		wait_objects(1)
		event.set_object_sequence_motion(0, "考える", 6)
		event.queue_object_sequence_next_motion(0, "考えるL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "目あき～目とじ")
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "「木にくわしい人」・・・\nう～ん。")
		at = 12
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.reset_mouth_texture_animations()
		at = 13
		wait_objects(0)
		event.set_object_sequence_motion(0, "そうだ！！", 2)
		event.queue_object_sequence_next_motion(0, "そうだ！！L", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき")
		event.set_mouth_texture_animations(0, "わらい口パク")
		event.open_message_window_2(0, "そうだ！！\nグリンがいる。")
		at = 14
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.reset_mouth_texture_animations()
		at = 15
		wait_objects(0)
		event.set_object_sequence_motion(0, "そうだ！！戻り", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_motion(1, "もどり", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "グリン？")
		at = 16
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		at = 17
		wait_objects(0)
		at = 18
		wait_objects(1)
		event.set_object_sequence_motion(0, "モニカ見うなづき", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(
			0,
			"うん。うちの庭師なんだ。\nグリンなら木の専門家だし、\nぴったりだよ。<page>今ごろ、うちの屋敷の前で\n花の手入れをしているはずだよ。"
		)
		at = 19
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.reset_mouth_texture_animations()
		at = 20
		wait_objects(0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "ホント！？\n行ってみましょう！")
		at = 21
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "モニカ見うなづき", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.open_message_window_2(0, "うん！")
		at = 22
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]パームブリンクスに戻って、\n   庭師グリンを探してみましょう。\n   今はユリスの家の前にいるはずです。"
		)
		at = 23
		show_message(0, -1, 8, 0, 0)
		event.fade_out_screen(30)
		at = 24
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22300000()
			helper_038a2e4d(30)
		end
		if at <= 2 then
			helper_ee1c51d0(0, -1, 3, 0, 416)
		end
		if at <= 4 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 5 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 6 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 7 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 14 then
			helper_238b5abc(0)
		end
		if at <= 15 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 16 then
			helper_238b5abc(0)
		end
		if at <= 17 then
			helper_238b5abc(1)
		end
		if at <= 18 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 19 then
			helper_238b5abc(0)
		end
		if at <= 20 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 21 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 22 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		if at <= 23 then
			helper_038a2e4d(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	helper_1d97c()
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1a890()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_event.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e209/e209_rococo.gltf", "info", 33)
	event.attach_object_handle_to_character(2, 33)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 33)
	event.attach_object_handle_to_edit_map_part(6, "p01_g010701", "g010707-m")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 6)
	event.set_object_sequence_position(10, 1.0461, 59.1891, 78.8974)
	event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_edit_map_part(7, "p01_g010701", "g010708-m")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 7)
	event.set_object_sequence_position(11, 1.0461, 59.1891, 78.8974)
	event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
	event.load_message_file(0, 5, "event/e200/e209/e209.txt")
end

--- Helper function.
local function helper_1a594()
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
	event.delete_character(33)
end

--- Helper function.
local function helper_1b6a8()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	vm.section(function()
		event.set_save_flag(209, 1)
		event.initialize_event()
		var0 = event.load_sound_effect_file_2(2217) or var0
		helper_1a890()
		event.set_object_handle_sound_bank(0, var0)
		do
			local out1, out2, out3, out4 = event.get_georama_part_position("p01_g010701")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
			rot_y = out4 or rot_y
		end
		event.set_event_world_coordinate(pos_x, pos_y, pos_z, rot_y)
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
		event.set_camera_sequence_position(-152.18, 97.87, 182.55)
		event.set_camera_sequence_look_at(-14.08, 63.23, 79.66)
		event.set_object_sequence_position(0, -21.47, 35.67, 73.06)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(1, -23.66, 35.67, 53.67)
		event.set_object_sequence_rotation(1, 0.0, 1.48, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "ノック", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		helper_888ab2a3(63)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "左・モニカ見", 6)
		event.queue_object_sequence_next_motion(0, "左・モニカ見L", 0)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "右を見る", 6)
		event.queue_object_sequence_next_motion(1, "右を見るL", 0)
		helper_4116e6bb(2090010)
		wait_objects(0)
		wait_objects(1)
		event.set_camera_sequence_position(2.14, 52.68, 63.32)
		event.set_camera_sequence_look_at(-43.71, 54.31, 61.35)
		event.set_object_sequence_position(0, -44.21, 30.26, 69.36)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(1, -40.8, 31.97, 53.53)
		event.set_object_sequence_rotation(1, 0.0, 1.24, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(1, "ひそひそ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "ひそひそL", 0)
		helper_888ab2a3(14)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(2090020)
		event.reset_mouth_texture_animations()
		helper_888ab2a3(15)
		event.set_object_sequence_motion(1, "どうするのー！", 6)
		event.queue_object_sequence_next_motion(1, "どうするのー！L", 4)
		event.delay_object_sequence_motion_track(0, 15)
		event.set_object_sequence_motion(0, "左・モニカ見戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		helper_888ab2a3(14)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_0382f327(2090030, 130)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_0382f327(2090040, 120)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(-101.88, 58.31, 65.69)
		event.set_camera_sequence_look_at(-24.94, 60.87, 62.04)
		event.set_object_sequence_position(0, -38.21, 35.37, 69.15)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(1, -40.8, 36.06, 53.53)
		event.set_object_sequence_rotation(1, 0.0, 1.48, 0.0)
		event.set_object_sequence_position(2, 6.91, 35.67, 60.19)
		event.set_object_sequence_rotation(2, 0.0, -2.24, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.open_voice_stream_wave(1, 2090045)
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		helper_888ab2a3(75)
		event.play_sound_effect(var0, 5)
		helper_888ab2a3(30)
		helper_888ab2a3(60)
		event.play_sound_effect(var0, 6)
		event.rotate_object_sequence(10, 0.0, 0.78, 0.0, 30)
		event.rotate_object_sequence(11, 0.0, 0.78, 0.0, 30)
		helper_888ab2a3(30)
		event.set_character_active(0, global0)
		event.set_character_active(0, global1)
		event.set_character_active(0, 37)
		event.set_camera_sequence_position(-78.2, 56.82, 61.3)
		event.set_camera_sequence_look_at(-24.35, 59.62, 61.68)
		event.set_object_sequence_position(2, 2.98, 37.07, 62.41)
		event.set_object_sequence_rotation(2, 0.0, -2.6, 0.0)
		event.set_object_sequence_motion(2, "手招き", 4)
		helper_4116e6bb(2090050)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 37)
		event.set_character_active(0, 33)
		event.set_camera_sequence_position(1.94, 52.68, 65.96)
		event.set_camera_sequence_look_at(-43.71, 52.77, 61.35)
		event.set_object_sequence_position(0, -44.21, 30.26, 69.36)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(1, -40.8, 31.97, 53.53)
		event.set_object_sequence_rotation(1, 0.0, 1.24, 0.0)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(1, "右を見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右を見るL", 0)
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(2090060)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-98.54, 68.99, 103.67)
		event.set_camera_sequence_look_at(-31.83, 65.79, 66.42)
		event.set_object_sequence_position(0, -36.84, 35.67, 44.26)
		event.set_object_sequence_rotation(0, 0.0, 1.48, 0.0)
		event.set_object_sequence_position(1, -15.62, 35.67, 55.4)
		event.set_object_sequence_rotation(1, 0.0, 1.36, 0.0)
		event.set_object_sequence_rotation(10, 0.0, 1.2, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 1.2, 0.0)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.move_object_sequence(1, 29.37, 35.67, 54.62, 60)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, 20.32, 35.67, 64.47, 75)
		helper_888ab2a3(45)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.play_sound_effect(var0, 7)
		event.rotate_object_sequence(10, 0.0, 0.0, 0.0, 30)
		event.rotate_object_sequence(11, 0.0, 0.0, 0.0, 30)
		helper_888ab2a3(15)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
	helper_1a594()
	event.fade_in_screen(30)
end

--- Event 502, which map data, a script or the engine runs by number.
local function event_502()
	helper_1b6a8()
	event.fade_out_screen(15)
	helper_888ab2a3(15)
	vm.wait(3)
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g01i07", 501)
	vm.wait(4)
end

--- Helper function.
local function helper_218d4()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.open_message_window_2(0, "『シャーロット停車場』に移動しますか？")
		at = 1
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		if var0 == 0 then
			event.set_object_sequence_position(0, 435.65, 0.09, 1239.32)
			event.set_object_sequence_rotation(0, 0.0, 0.15, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_camera_sequence()
			event.set_camera_sequence_position(509.64, 85.52, 1104.08)
			event.set_camera_sequence_look_at(467.67, 42.86, 1293.7)
			event.move_object_sequence(0, 493.92, 0.01, 1423.13, 60, 1)
			event.move_camera_sequence(509.64, 85.52, 1104.08, 485.07, 46.59, 1340.58, 60)
			print("2")
			at = 2
			helper_888ab2a3(30)
			print("3")
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		end
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var1 = vm.f32(var1 + vm.f32(45.0 * vm.sin(vm.f32(-3.01))))
		var3 = vm.f32(var3 + vm.f32(45.0 * vm.cos(vm.f32(-3.01))))
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, -3.01, 0.0, 15)
		event.move_object_sequence(0, var1, var2, var3, 45)
		for var4_i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			event.set_camera_sequence_look_at(var1, var2 + 30.0, var3)
			at = 4
			vm.wait(4)
		end
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_message_window_mode(0, 7)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				print("2")
				helper_038a2e4d(30)
			end
			if at <= 2 then
				print("3")
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 4 then
			local _ = var4 < 45
			var4 = var4 + 1
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_df3c()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: s32 = 0
	local angle: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character_motion_pack(5, "event/lm/e250r/e250_mints.gltf", "info", 0)
	event.set_character_position(0, -211.18, 0.0, 11.07)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "上見立ち", 4)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_sequence_object(0, 0)
	event.load_character(5, "chara/c02_base.gltf", "info", 8)
	event.set_character_active(8)
	event.attach_object_handle_to_character(1, 8)
	event.load_equipment_model(5, 1, 4, "info", 8)
	event.load_equipment_model(5, 1, 3, "info", 8)
	event.load_equipment_model(5, 1, 2, "info", 8, 13)
	event.set_character_active(13)
	event.set_character_position(8, -173.24, 0.0, 0.0)
	event.set_character_rotation(8, 0.0, 0.0, 0.0)
	event.load_character_motion_pack(5, "event/lm/e250r/e250_monica.gltf", "info", 8)
	event.set_character_motion(8, "上見立ち", 4)
	event.attach_object_handle_to_character(1, 8)
	event.set_object_sequence_object(1, 1)
	event.load_character(5, "event/lm/e250r/e250_toryon.gltf", "info", 9)
	event.set_character_active(9)
	event.set_character_position(9, -1121.01, 394.47, -2048.83)
	event.set_character_rotation(9, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(2, 9)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/lm/e250r/e250_tree.gltf", "info", 10)
	event.set_character_rotation(10, 0.0, 3.14, 0.0)
	event.set_character_active(0, 10)
	event.attach_character_to_frame(9, "R_tree", 10)
	event.load_character(5, "event/lm/e250r/e250_tree.gltf", "info", 11)
	event.set_character_rotation(11, 0.0, 3.14, 0.0)
	event.set_character_active(0, 11)
	event.attach_character_to_frame(9, "L_tree", 11)
	event.attach_object_handle_to_character_frame(6, 9, "puropera")
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.rotate_object_sequence(6, 0.0, -0.2, 0.0, -1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-601.29, 522.11, 100.72)
	event.set_camera_sequence_look_at(-689.32, 571.24, -105.58)
	helper_888ab2a3(30)
	event.move_object_sequence_eased(2, -1121.01, 995.31, -2048.83, 60, 2, 0.5)
	event.rotate_object_sequence(2, 0.0, -3.14, 0.0, 40)
	event.rotate_object_sequence(2, 0.0, 1.57, 0.0, 20)
	event.rotate_object_sequence_eased(2, 0.0, 0.16, 0.0, 20, 2, 0.5)
	wait_objects(2)
	event.move_object_sequence_eased(2, -671.63, 447.09, -193.49, 80, 1, 0.4)
	event.move_camera_sequence_eased(-601.29, 522.11, 100.72, -654.5, 581.35, -117.24, 60, 0, 0.4)
	wait_objects(2)
	wait_camera()
	event.set_camera_sequence_position(-298.8, 199.33, -185.86)
	event.set_camera_sequence_look_at(-194.57, 243.43, 136.45)
	event.set_character_active(1, 10)
	event.set_character_active(1, 11)
	event.set_character_position(9, -221.16, 0.0, 293.2)
	event.set_character_rotation(9, 0.0, 3.14, 0.0)
	event.set_character_motion(9, "木持ち浮遊", 4)
	event.move_camera_sequence_eased(-299.31, 60.07, -348.88, -167.05, 136.09, 169.13, 60, 0, 0.5)
	wait_camera()
	event.set_object_sequence_motion(2, "右の木を植える", 2)
	event.queue_object_sequence_next_motion(2, "右の木を植えるL", 4)
	helper_888ab2a3(18)
	event.set_character_motion(0, "右へよける", 6)
	event.set_character_motion(8, "左へよける", 6)
	helper_888ab2a3(5)
	do
		local out1, _, out3 = event.get_object_handle_frame_position(2, "R_tree")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	event.detach_character_from_frame(10)
	event.set_character_position(10, pos_x, 0.0, pos_z)
	event.set_character_motion(10, "ぷるん", 6)
	event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
	wait_objects(2)
	event.set_camera_sequence_position(-280.52, 44.63, 49.11)
	event.set_camera_sequence_look_at(-280.82, 14.35, 12.64)
	event.set_character_position(0, -281.18, 0.0, 11.07)
	event.set_character_position(9, -291.16, 0.0, 293.2)
	event.set_object_sequence_motion(0, "前を見る", 6)
	event.queue_object_sequence_next_motion(0, "前を見るL", 4)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "目・おどろき")
	event.set_object_sequence_texture_animation(0, 1, "口・はっ")
	wait_objects(0)
	event.set_camera_sequence_position(-299.31, 60.07, -348.88)
	event.set_camera_sequence_look_at(-167.05, 136.09, 169.13)
	event.set_object_sequence_motion(2, "左の木を植える", 2)
	event.queue_object_sequence_next_motion(2, "左の木を植えるL", 4)
	helper_888ab2a3(18)
	event.set_object_sequence_motion(0, "左へよける", 6)
	helper_888ab2a3(5)
	do
		local out1, _, out3 = event.get_object_handle_frame_position(2, "L_tree")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	event.detach_character_from_frame(11)
	event.set_character_position(11, pos_x, 0.0, pos_z)
	event.set_character_motion(11, "ぷるん", 6)
	event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
	wait_objects(2)
	helper_888ab2a3(30)
	event.set_camera_sequence_position(-814.87, 217.76, -136.29)
	event.set_camera_sequence_look_at(-388.48, 229.58, 435.09)
	event.move_camera_sequence_eased(-647.69, 217.76, 87.74, -388.48, 229.58, 435.09, 64, 2, 0.5)
	event.set_character_position(9, -360.96, 101.44, 464.93)
	event.set_character_rotation(9, 0.0, -2.9, 0.0)
	event.set_object_sequence_motion(2, "まわる", 6)
	event.queue_object_sequence_next_motion(2, "まわるL", 6)
	event.delay_object_sequence_motion_track(2, 1)
	event.set_object_sequence_motion_step(2, 1.0)
	event.queue_object_sequence_next_motion(2, "ピース", 6)
	event.queue_object_sequence_next_motion(2, "ピースL", 4)
	var3 = 0
	angle = vm.f32(-2.9)
	var6 = 0
	while var3 < 68 do
		var6 = vm.f32(var6 + vm.f32(0.04619989))
		var5 = vm.f32(vm.sin(var6) * vm.f32(0.3))
		angle = vm.f32(angle + var5)
		angle = event.wrap_angle(angle) or angle
		event.set_character_rotation(9, 0.0, angle, 0.0)
		var3 = var3 + 1
		vm.wait(14)
	end
	vm.wait(15)
	helper_c956b4a2(32)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(13)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local old_map_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event_99()
		old_map_no = event.get_previous_map() or old_map_no
		var1 = event.get_map_type(old_map_no) or var1
		if var1 ~= -1 then
			if var1 ~= 2 then
				if old_map_no == 25 then
					helper_59d97f4a()
				elseif old_map_no == 16 then
					at = 1
					helper_224d4()
				elseif old_map_no == 71 then
					event.fade_in_screen(30)
					event.set_character_position(0, 275.0, 35.7, 465.0)
					event.set_character_rotation(0, 0.0, -1.57, 0.0)
					event.reset_follow_camera(1, 0.0, 20.0)
				else
					at = 2
					helper_224d4()
				end
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			event.get_previous_interior_map()
			event.fade_in_screen(30)
		end
		at = 3
		helper_22ee0()
		helper_a15114f7()
		at = 4
		helper_26374f46(1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_22b00000()
			end
			if at <= 2 then
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				helper_344d6cd8()
			end
			if at <= 3 then
				helper_344d6cd8()
				helper_ebc222ab(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1e9a4

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	flag = event.get_save_flag(209) or flag
	if flag == 0 then
		event_502()
		return
	end
	flag = event.get_save_flag(247) or flag
	if flag == 1 then
		flag = event.get_save_flag(250) or flag
		if flag == 0 then
			event.set_save_control_bits(2, 0)
			event.skip_next_music_load()
			event.jump_to_map_3(-1, "g01i07", 100)
			vm.wait(2)
			return
		end
	end
	flag = event.get_save_flag(250) or flag
	if flag == 0 then
		event.jump_to_map_3(-1, "g01i07", 100)
		vm.wait(3)
		return
	end
	vm.wait(4)
	event.go_to_interior_map(-1, "g01i07", 100)
	vm.wait(5)
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	if helper_218d4() == 1 then
		event.jump_to_map_2(-1, "s02")
		vm.wait(2)
	end
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	helper_8c87ba09(-700.0, 0.0, -1000.0, 1.0)
	var0 = event.get_georama_analysis_flag(103) or var0
	flag = event.get_save_flag(270) or flag
	if (if var0 ~= 0 then helper_e538a72d() else 0) ~= 0 and flag == 0 then
		event.skip_next_music_load()
	end
	flag_2 = event.get_save_flag(280) or flag_2
	if (if var0 ~= 0 then helper_b84429a4() else 0) ~= 0 and flag_2 == 0 then
		event.skip_next_music_load()
	end
	event.jump_to_map_2(-1, "f01")
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_26374f46(0)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: any = 0
	helper_afbdd04b(0)
	var0 = helper_f4d83329(0)
	helper_f2e47558()
	if var0 == 0 then
		event.go_to_interior_map(-1, "i01h01")
		vm.wait(2)
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	vm.wait(1)
	event.load_event_script("g01/g01b.stb", 501)
end

script.event_502 = event_502

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	event.set_camera_position(-715.15, 30.36, -736.79)
	event.set_camera_look_at(-715.13, 14.54, -733.45)
	event.fade_out_screen(0)
	vm.wait(1)
	event.load_event_script("g01/g01c.stb", 501)
	event.fade_out_screen(0)
end

--- Event 506, which map data, a script or the engine runs by number.
function script.event_506()
	local argc: s32 = 0
	local argc_2: s32 = 0
	event.add_inventory_item(210, 28)
	event.add_inventory_item(214)
	event.add_inventory_item(216)
	event.add_inventory_item(220)
	event.add_inventory_item(224)
	event.add_inventory_item(235)
	event.add_inventory_item(231, 20)
	argc = event.get_item_limit_status() or argc
	argc_2 = event.get_overflow_item_count() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		event.fade_out_screen(10)
		helper_888ab2a3(10)
		event.open_event_menu(16)
		vm.wait(2)
		event.fade_in_screen(10)
	end
	event.set_save_control_bits(2, 0)
	event.enter_edit_mode(0)
	vm.wait(3)
end

--- Event 507, which map data, a script or the engine runs by number.
function script.event_507()
	event.set_save_flag(42, 1)
	helper_1e9a4()
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	vm.wait(1)
	event.load_event_script("g01/g01b.stb", 150)
end

--- Event 650, which map data, a script or the engine runs by number.
function script.event_650()
	vm.wait(1)
	event.load_event_script("g01/rush_g01.stb", 500)
end

--- Event 651, which map data, a script or the engine runs by number.
script.event_651 = helper_1b6a8

--- Event 690, which map data, a script or the engine runs by number.
script.event_690 = helper_df3c

--- Event 12080, which map data, a script or the engine runs by number.
function script.event_12080()
	vm.wait(1)
	event.load_event_script("g01/g01b.stb", 501)
end

--- Event 12090, which map data, a script or the engine runs by number.
function script.event_12090()
	helper_1b6a8()
	event.fade_out_screen(15)
	helper_888ab2a3(15)
	vm.wait(3)
	event.jump_to_map_3(-1, "g01i07", 501)
	vm.wait(4)
end

--- Event 12542, which map data, a script or the engine runs by number.
script.event_12542 = helper_1e9a4

return script
