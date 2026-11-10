--!strict
-- map/g/g01/g01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_2295c00d = require("@lib/event/helper_2295c00d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_26374f46 = require("@lib/event/helper_26374f46")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_59d97f4a = require("@lib/event/helper_59d97f4a")
local helper_60979549 = require("@lib/event/helper_60979549")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a15114f7 = require("@lib/event/helper_a15114f7")
local helper_ab767c4a = require("@lib/event/helper_ab767c4a")
local helper_afbdd04b = require("@lib/event/helper_afbdd04b")
local helper_b11a919c = require("@lib/event/helper_b11a919c")
local helper_b84429a4 = require("@lib/event/helper_b84429a4")
local helper_d025a590 = require("@lib/event/helper_d025a590")
local helper_e538a72d = require("@lib/event/helper_e538a72d")
local helper_ebad0649 = require("@lib/event/helper_ebad0649")
local helper_ebc222ab = require("@lib/event/helper_ebc222ab")
local helper_ed77c16a = require("@lib/event/helper_ed77c16a")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_ef5935f5 = require("@lib/event/helper_ef5935f5")
local helper_f2e47558 = require("@lib/event/helper_f2e47558")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
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
local function helper_1e2f8()
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
local function helper_22400000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1df60()
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
local function helper_1ef88()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(34, 1)
		event.initialize_event()
		event.apply_message_window_preset(0, 0)
		event.fade_out_screen(30)
		at = 2
		wait_frames(45)
		helper_1e2f8()
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
		at = 3
		wait_frames(30)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(
			0,
			"Der Geostein, den du diesmal mit-\ngebracht hast, sagt, um Juraku\nwieder zu beleben ...<page>... m[UNI00fc]ssen wir 'jemand, der sich\nmit B[UNI00e4]umen auskennt' dazu bewegen, nach\nSindain zu ziehen."
		)
		at = 4
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
		at = 5
		vm.wait(5)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "Jemand zum Umzug bewegen?")
		at = 6
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(
			0,
			"Genau. In Palm Brinks wohnen\ndoch sehr viele Leute,\nnicht wahr?<page>Wir m[UNI00fc]ssen sie dazu bewegen,\nhinaus in die Welt zu ziehen.\nSo kann sich die Zukunft entwickeln."
		)
		at = 7
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		event.open_message_window_2(0, "Hmm. Verstehe.")
		at = 8
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.set_object_sequence_motion(1, "向き直り", 2)
		event.queue_object_sequence_next_motion(1, "向き直りL", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目～上向き目")
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "Und jetzt brauchen wir\n'jemand, der sich mit B[UNI00e4]umen auskennt',\nja?")
		at = 9
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		at = 10
		wait_objects(1)
		event.set_object_sequence_motion(1, "顔向け", 2)
		event.queue_object_sequence_next_motion(1, "顔向けＬ", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "上向き目～通常目")
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "Kennst du so jemanden, Max?")
		at = 11
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		at = 12
		wait_objects(1)
		event.set_object_sequence_motion(0, "考える", 6)
		event.queue_object_sequence_next_motion(0, "考えるL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "目あき～目とじ")
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "Hmm. 'Jemand, der sich mit B[UNI00e4]umen\nauskennt ...'")
		at = 13
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.reset_mouth_texture_animations()
		at = 14
		wait_objects(0)
		event.set_object_sequence_motion(0, "そうだ！！", 2)
		event.queue_object_sequence_next_motion(0, "そうだ！！L", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき")
		event.set_mouth_texture_animations(0, "わらい口パク")
		event.open_message_window_2(0, "Oh, ich hab's! Gordon!")
		at = 15
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.reset_mouth_texture_animations()
		at = 16
		wait_objects(0)
		event.set_object_sequence_motion(0, "そうだ！！戻り", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_motion(1, "もどり", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "Gordon?")
		at = 17
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		at = 18
		wait_objects(0)
		at = 19
		wait_objects(1)
		event.set_object_sequence_motion(0, "モニカ見うなづき", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(
			0,
			"Ja. Er ist unser G[UNI00e4]rtner. Und\nein echter Baum-Experte!<page>Er ist bestimmt gerade im Hof\nund gie[UNI00df]t Blumen\noder so."
		)
		at = 20
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.reset_mouth_texture_animations()
		at = 21
		wait_objects(0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Wirklich? Super! Gehen wir!")
		at = 22
		helper_0ffc2526(0, -1, global1, global0, var4)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "モニカ見うなづき", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.open_message_window_2(0, "Gut!")
		at = 23
		helper_0ffc2526(0, -1, global0, global1, var4)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]Gehe nach Palm Brinks\n   und finde Gordon, den G[UNI00e4]rtner.\n   Er sollte in Max' Hof sein."
		)
		at = 24
		show_message(0, -1, 8, 0, 0)
		event.fade_out_screen(30)
		at = 25
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(45)
		end
		if at <= 2 then
			helper_22400000()
			wait_frames_skipping(30)
		end
		if at <= 3 then
			helper_ee1c51d0(0, -1, 3, 0, 416)
		end
		if at <= 5 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 6 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 7 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 8 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 9 then
			helper_238b5abc(1)
		end
		if at <= 10 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 11 then
			helper_238b5abc(1)
		end
		if at <= 12 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_238b5abc(1)
		end
		if at <= 19 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 20 then
			helper_238b5abc(0)
		end
		if at <= 21 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 22 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 23 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		if at <= 24 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 26
	vm.entry(26)
	event.cancel_drama_scene_skip()
	helper_1df60()
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1ae64()
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
	event.load_message_file(0, 5, "event/e200/e209/e209_1.txt")
end

--- Helper function.
local function helper_1ab68()
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
local function helper_1bc8c()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	vm.section(function()
		event.set_save_flag(209, 1)
		event.initialize_event()
		var0 = event.load_sound_effect_file_2(2217) or var0
		helper_1ae64()
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
		wait_frames(63)
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
		wait_frames(14)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(2090020)
		event.reset_mouth_texture_animations()
		wait_frames(15)
		event.set_object_sequence_motion(1, "どうするのー！", 6)
		event.queue_object_sequence_next_motion(1, "どうするのー！L", 4)
		event.delay_object_sequence_motion_track(0, 15)
		event.set_object_sequence_motion(0, "左・モニカ見戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		wait_frames(14)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_1584c528(2090030, 150)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_1584c528(2090040, 120)
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
		wait_frames(75)
		event.play_sound_effect(var0, 5)
		wait_frames(30)
		wait_frames(60)
		event.play_sound_effect(var0, 6)
		event.rotate_object_sequence(10, 0.0, 0.78, 0.0, 30)
		event.rotate_object_sequence(11, 0.0, 0.78, 0.0, 30)
		wait_frames(30)
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
		wait_frames(45)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.play_sound_effect(var0, 7)
		event.rotate_object_sequence(10, 0.0, 0.0, 0.0, 30)
		event.rotate_object_sequence(11, 0.0, 0.0, 0.0, 30)
		wait_frames(15)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
	helper_1ab68()
	event.fade_in_screen(30)
end

--- Event 502, which map data, a script or the engine runs by number.
local function event_502()
	helper_1bc8c()
	event.fade_out_screen(15)
	wait_frames(15)
	vm.wait(3)
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g01i07", 501)
	vm.wait(4)
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
					helper_ab767c4a()
				elseif old_map_no == 71 then
					event.fade_in_screen(30)
					event.set_character_position(0, 275.0, 35.7, 465.0)
					event.set_character_rotation(0, 0.0, -1.57, 0.0)
					event.reset_follow_camera(1, 0.0, 20.0)
				else
					at = 2
					helper_ab767c4a()
				end
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			event.get_previous_interior_map()
			event.fade_in_screen(30)
		end
		at = 3
		helper_60979549()
		helper_a15114f7()
		at = 4
		helper_26374f46(1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_ed77c16a()
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
function script.key_open()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_b11a919c(1)
		at = 2
		helper_1ef88()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_1ef88()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

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
	if helper_2295c00d() == 1 then
		event.jump_to_map_2(-1, "s02")
		vm.wait(2)
	end
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	helper_ebad0649(-700.0, 0.0, -1000.0, 1.0)
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
	var0 = helper_d025a590(0)
	helper_f2e47558()
	if var0 == 0 then
		event.go_to_interior_map(-1, "i01h01")
		vm.wait(2)
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	vm.wait(1)
	event.load_event_script("g01/g01b_1.stb", 501)
end

script.event_502 = event_502

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	event.set_camera_position(-715.15, 30.36, -736.79)
	event.set_camera_look_at(-715.13, 14.54, -733.45)
	event.fade_out_screen(0)
	vm.wait(1)
	event.load_event_script("g01/g01c_1.stb", 501)
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
		wait_frames(10)
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
	helper_1ef88()
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	vm.wait(1)
	event.load_event_script("g01/g01b_1.stb", 150)
end

--- Event 650, which map data, a script or the engine runs by number.
function script.event_650()
	vm.wait(1)
	event.load_event_script("g01/rush_g01_1.stb", 500)
end

--- Event 651, which map data, a script or the engine runs by number.
script.event_651 = helper_1bc8c

--- Event 690, which map data, a script or the engine runs by number.
script.event_690 = helper_ef5935f5

--- Event 12080, which map data, a script or the engine runs by number.
function script.event_12080()
	vm.wait(1)
	event.load_event_script("g01/g01b_1.stb", 501)
end

--- Event 12090, which map data, a script or the engine runs by number.
function script.event_12090()
	helper_1bc8c()
	event.fade_out_screen(15)
	wait_frames(15)
	vm.wait(3)
	event.jump_to_map_3(-1, "g01i07", 501)
	vm.wait(4)
end

--- Event 12542, which map data, a script or the engine runs by number.
script.event_12542 = helper_1ef88

return script
