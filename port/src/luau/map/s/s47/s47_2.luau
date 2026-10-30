--!strict
-- map/s/s47/s47_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_1fc036d8 = require("@lib/event/helper_1fc036d8")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2396f96f = require("@lib/event/helper_2396f96f")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_5c12934f = require("@lib/event/helper_5c12934f")
local helper_61224aa3 = require("@lib/event/helper_61224aa3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_bf9e1d50 = require("@lib/event/helper_bf9e1d50")
local helper_ccbab5a2 = require("@lib/event/helper_ccbab5a2")
local helper_e6c0ae70 = require("@lib/event/helper_e6c0ae70")
local helper_ec7d9573 = require("@lib/event/helper_ec7d9573")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_1d000()
	local active_chr_no: s32 = 0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "event/e200/e254/e254_fukuro.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(5, 35)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 5)
	event.load_character(5, "event/e200/e254/e254_toryon.gltf", "info", 37)
	event.set_character_active(0, 37)
	event.attach_object_handle_to_character(6, 37)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 6)
	event.load_message_file(0, 5, "event/e200/e254/e254.txt")
end

--- Helper function.
local function helper_22b00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1cbfc()
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
	event.delete_character(36)
	event.delete_character(35)
	event.delete_character(37)
end

--- Helper function.
local function helper_1e050()
	local var5: s32 = 0
	local var6: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.apply_message_window_preset(0, 0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.load_map_sounds(2238)
		var5 = event.load_sound_effect_file_2(2238) or var5
		helper_1d000()
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-36.27, 5.25, -87.21)
		event.set_camera_sequence_look_at(0.0, 35.12, -200.0)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_character_active(1, 36)
		event.set_character_active(1, 35)
		event.set_object_sequence_position(0, 9.65, 0.0, -163.16)
		event.set_object_sequence_rotation(0, 0.0, -2.66, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, 27.55, 0.0, -175.0)
		event.set_object_sequence_rotation(1, 0.0, -2.66, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_position(3, 0.0, 0.0, -200.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_position(4, -29.84, 0.0, -214.7)
		event.set_object_sequence_rotation(4, 0.0, -0.04, 0.0)
		event.set_object_sequence_scale(4, 1.0, 1.0, 1.0)
		event.fade_in_screen(30)
		at = 2
		wait_frames(30)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(
			0,
			"Voici un petit cadeau de notre\npart, vous en aurez besoin\npour reconstruire la for[UNI00ea]t.<page>M[UNI00ea]me avec le Charpention et les\ng[UNI00e9]opierres, rien n'est possible\nsans mat[UNI00e9]riaux !"
		)
		at = 3
		show_message(0, -1, 2, 256, 416)
		event.open_message_window_2(
			0,
			"...Oh la la, votre sac me\npara[UNI00ee]t vraiment petit, il n'y\na de place pour rien l[UNI00e0]-dedans.<page>H[UNI00e9] ben tiens ! Je vais vous\nrendre un grand service.\nOn va agrandir ce sac !"
		)
		at = 4
		show_message(0, -1, 2, 256, 416)
		event.open_message_window_2(
			0,
			"Mais je vous pr[UNI00e9]viens, je ne\nsuis pas toujours aussi gentil.<page>C'est juste que je suis d'humeur\ng[UNI00e9]n[UNI00e9]reuse aujourd'hui."
		)
		at = 5
		show_message(0, -1, 2, 256, 416)
		event.set_object_sequence_motion(3, "立ち")
		event.set_object_sequence_scale(4, 0.9, 0.9, 0.9)
		at = 6
		helper_f38eabca(210, 28)
		event.set_object_sequence_scale(4, 0.8, 0.8, 0.8)
		at = 7
		helper_f38eabca(214, 1)
		event.set_object_sequence_scale(4, 0.7, 0.7, 0.7)
		at = 8
		helper_f38eabca(216, 1)
		event.set_object_sequence_scale(4, 0.6, 0.6, 0.6)
		at = 9
		helper_f38eabca(220, 1)
		event.set_object_sequence_scale(4, 0.5, 0.5, 0.5)
		at = 10
		helper_f38eabca(224, 1)
		event.set_object_sequence_scale(4, 0.4, 0.4, 0.4)
		at = 11
		helper_f38eabca(235, 1)
		event.set_object_sequence_scale(4, 0.3, 0.3, 0.3)
		at = 12
		helper_f38eabca(231, 20)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(0, "Maintenant, il faut demander au\nCharpention de vous rejoindre.")
		at = 13
		show_message(0, -1, 2, 256, 416)
		event.set_object_sequence_motion(3, "会話")
		event.open_message_window_2(0, "Pour aller sur la carte du\nG[UNI00e9]orama, appuie sur\n[select]. Allez ! Essaie !")
		at = 14
		var6 = helper_2396f96f(0, -1, 2, 256, 416, var6)
		while var6 ~= 1 do
			event.set_object_sequence_motion(3, "会話")
			event.open_message_window_2(0, "Il faut appuyer sur\n[select] !")
			at = 15
			var6 = helper_2396f96f(0, -1, 2, 256, 416, var6)
		end
		event.set_object_sequence_motion(3, "立ち")
		event.fade_out_screen(30)
		at = 16
		wait_frames(30)
		event.set_camera_sequence_position(80.99, 2.59, -80.49)
		event.set_camera_sequence_look_at(-3.12, 130.83, -201.26)
		event.set_character_active(1, 37)
		event.set_object_sequence_position(5, -236.26, 800.0, -539.2)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "浮遊", 4)
		event.move_object_sequence_eased(5, -236.26, 63.05, -539.2, 150, 2, 1.0)
		event.attach_object_handle_to_character_frame(20, 37, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.fade_in_screen(30)
		at = 17
		wait_frames(30)
		event.play_sound_effect(var5, 8)
		at = 18
		wait_frames(30)
		event.move_camera_sequence(80.99, 2.59, -80.49, -3.12, 50.81, -201.26, 150)
		at = 19
		wait_frames(90)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 20
		wait_frames(30)
	end, function(received: { any }): boolean
		if at == 14 then
			var6 = received[2] :: number
		end
		if at == 15 then
			var6 = received[2] :: number
		end
		if at <= 1 then
			helper_22b00000()
			wait_frames_skipping(30)
		end
		if at <= 2 then
			helper_ee1c51d0(0, -1, 2, 256, 416)
		end
		if at <= 3 then
			helper_ee1c51d0(0, -1, 2, 256, 416)
		end
		if at <= 4 then
			helper_ee1c51d0(0, -1, 2, 256, 416)
		end
		if at <= 5 then
			helper_5c12934f(210, 28)
		end
		if at <= 6 then
			helper_5c12934f(214, 1)
		end
		if at <= 7 then
			helper_5c12934f(216, 1)
		end
		if at <= 8 then
			helper_5c12934f(220, 1)
		end
		if at <= 9 then
			helper_5c12934f(224, 1)
		end
		if at <= 10 then
			helper_5c12934f(235, 1)
		end
		if at <= 11 then
			helper_5c12934f(231, 20)
		end
		if at <= 12 then
			helper_ee1c51d0(0, -1, 2, 256, 416)
		end
		if at <= 13 then
			var6 = helper_1fc036d8(0, -1, 2, 256, 416, var6)
		end
		if at <= 14 then
			var6 = helper_1fc036d8(0, -1, 2, 256, 416, var6)
		end
		if at <= 15 then
			local _ = var6 ~= 1
			wait_frames_skipping(30)
		end
		if at <= 16 then
			wait_frames_skipping(30)
		end
		if at <= 17 then
			wait_frames_skipping(30)
		end
		if at <= 18 then
			wait_frames_skipping(90)
		end
		if at <= 19 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var5, 8)
	helper_1cbfc()
	event.finish_event()
	event.stop_music(0)
	event.skip_next_music_load()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_e3c4()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
end

--- Helper function.
local function helper_10934()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.attach_object_handle_to_map_part_2(12, "p01_g010701")
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	helper_e3c4()
	event.load_message_file(0, 5, "event/e200/e250/e250_1.txt")
	event.assign_memory_stack(6)
	event.clear_memory_stack(6)
end

--- Helper function.
local function helper_10608()
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
	helper_61224aa3()
	helper_ccbab5a2()
	event.delete_character(39)
end

--- Helper function.
local function helper_10bd8()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(250, 1)
		event.initialize_event()
		event.load_map_sounds(2229)
		var11 = event.load_sound_effect_file_2(2229) or var11
		helper_10934()
		do
			local out1, out2, out3 = event.get_object_handle_position(12)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local _, out2, _ = event.get_object_handle_rotation(12)
			rot_y = out2 or rot_y
		end
		event.set_event_world_coordinate(pos_x, pos_y, pos_z, rot_y)
		event.set_object_handle_sound_bank(0, var11)
		helper_bf9e1d50()
		event.stop_music(1)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(193)
		event.start_background_file_loads_4(
			"event/e200/e250/e250_toryon.gltf",
			"event/lm/e250r/e250_tree.gltf",
			"event/e200/e250/e250_konoha.gltf",
			"event/e200/e250/shuchusen.gltf"
		)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.attach_object_handle_to_map_part_2(13, "p01_a1301-4")
		event.set_object_handle_visible(13, 0)
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 34)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_character_active(1, 41)
		event.set_character_active(1, 40)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(113.09, 252.02, 174.44)
		event.set_camera_sequence_look_at(-869.33, -1297.8, -411.75)
		event.fade_in_screen(30)
		event.move_camera_sequence_eased(113.09, 65.59, 174.44, -1546.66, 23.97, -658.2, 230, 2, 0.4)
		event.set_object_sequence_position(0, -14.3, 35.67, 60.81)
		event.set_object_sequence_rotation(0, 0.0, -1.47, 0.0)
		event.set_object_sequence_position(1, -14.3, 35.67, 70.35)
		event.set_object_sequence_rotation(1, 0.0, -1.68, 0.0)
		event.set_object_sequence_position(5, -14.299988, 35.67, 53.670013)
		event.set_object_sequence_rotation(5, 0.0, -1.56, 0.0)
		event.set_object_sequence_position(8, -14.299988, 35.67, 53.670013)
		event.set_object_sequence_rotation(8, 0.0, -1.44, 0.0)
		event.set_object_sequence_position(7, -14.299988, 35.67, 70.350006)
		event.set_object_sequence_rotation(7, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(2, -14.299988, 35.67, 70.350006)
		event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
		event.set_object_sequence_position(3, -14.299988, 35.67, 70.350006)
		event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
		event.set_object_sequence_position(4, -14.299988, 35.67, 53.670013)
		event.set_object_sequence_rotation(4, 0.0, -1.68, 0.0)
		event.set_object_sequence_position(6, -14.299988, 35.67, 70.350006)
		event.set_object_sequence_rotation(6, 0.0, -1.2, 0.0)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_sequence_motion(0, "立ち", -1, 4)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 75)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.rotate_object_sequence(0, 0.0, -1.49, 0.0, 165)
		event.delay_object_sequence_position_track(0, 75)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 90)
		event.add_object_sequence_path_point(0, -14.3, 35.67, 53.67)
		event.add_object_sequence_path_point(0, -26.37, 35.67, 57.03)
		event.add_object_sequence_path_point(0, -72.16, 14.0, 64.22)
		event.add_object_sequence_path_point(0, -88.64, 14.0, 64.27)
		event.start_object_sequence_path(0)
		event.set_object_sequence_motion(1, "立ち", -1, 4)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.rotate_object_sequence(1, 0.0, -1.64, 0.0, 180)
		event.delay_object_sequence_position_track(1, 90)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -14.3, 35.67, 70.35)
		event.add_object_sequence_path_point(1, -27.29, 35.67, 70.35)
		event.add_object_sequence_path_point(1, -68.45, 15.54, 70.63)
		event.add_object_sequence_path_point(1, -87.24, 14.0, 87.83)
		event.start_object_sequence_path(1)
		var10 = 0
		while var10 < 7 do
			event.set_object_sequence_motion(2 + var10, "走り", 4)
			event.set_object_handle_footstep_sound(5 + var10, 1)
			var10 = var10 + 1
		end
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 15)
		event.add_object_sequence_path_point(2, -14.31, 35.67, 70.35)
		event.add_object_sequence_path_point(2, -28.37, 35.67, 70.35)
		event.add_object_sequence_path_point(2, -70.8, 14.0, 66.4)
		event.add_object_sequence_path_point(2, -99.73, 13.49, 63.63)
		event.add_object_sequence_path_point(2, -115.19, 8.79, 62.15)
		event.add_object_sequence_path_point(2, -136.2, 0.0, 60.14)
		event.start_object_sequence_path(2)
		event.move_object_sequence(2, -1411.86, -0.0, -148.97, 195)
		event.delay_object_sequence_position_track(3, 10)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 15)
		event.add_object_sequence_path_point(3, -14.31, 35.67, 70.35)
		event.add_object_sequence_path_point(3, -28.37, 35.67, 70.35)
		event.add_object_sequence_path_point(3, -70.8, 14.0, 66.4)
		event.add_object_sequence_path_point(3, -99.73, 13.49, 63.63)
		event.add_object_sequence_path_point(3, -115.19, 8.79, 62.15)
		event.add_object_sequence_path_point(3, -136.2, 0.0, 60.14)
		event.start_object_sequence_path(3)
		event.move_object_sequence(3, -1411.86, -0.0, -148.97, 195)
		event.delay_object_sequence_position_track(4, 20)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 15)
		event.add_object_sequence_path_point(4, -16.96, 35.67, 57.27)
		event.add_object_sequence_path_point(4, -30.65, 35.67, 58.87)
		event.add_object_sequence_path_point(4, -74.26, 14.0, 63.97)
		event.add_object_sequence_path_point(4, -97.55, 14.0, 66.69)
		event.add_object_sequence_path_point(4, -113.48, 8.85, 69.63)
		event.add_object_sequence_path_point(4, -128.87, 1.8, 71.43)
		event.start_object_sequence_path(4)
		event.move_object_sequence(4, -1370.73, -0.0, -123.06, 195)
		event.delay_object_sequence_position_track(6, 30)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 15)
		event.add_object_sequence_path_point(6, -15.82, 35.67, 62.54)
		event.add_object_sequence_path_point(6, -29.9, 35.67, 63.43)
		event.add_object_sequence_path_point(6, -68.92, 15.16, 65.92)
		event.add_object_sequence_path_point(6, -95.99, 14.0, 67.64)
		event.add_object_sequence_path_point(6, -112.97, 8.96, 68.73)
		event.add_object_sequence_path_point(6, -133.66, 0.0, 70.05)
		event.start_object_sequence_path(6)
		event.move_object_sequence(6, -1317.43, -0.0, -99.53, 195)
		event.delay_object_sequence_position_track(5, 40)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 15)
		event.add_object_sequence_path_point(5, -14.3, 35.67, 53.67)
		event.add_object_sequence_path_point(5, -30.28, 35.67, 53.76)
		event.add_object_sequence_path_point(5, -61.37, 21.67, 59.67)
		event.add_object_sequence_path_point(5, -100.52, 12.96, 59.88)
		event.add_object_sequence_path_point(5, -117.29, 7.96, 59.97)
		event.add_object_sequence_path_point(5, -135.22, 0.0, 60.07)
		event.start_object_sequence_path(5)
		event.move_object_sequence(5, -1333.23, -0.0, -138.83, 195)
		event.delay_object_sequence_position_track(7, 50)
		event.clear_object_sequence_path(7)
		event.set_object_sequence_path_frames(7, 15)
		event.add_object_sequence_path_point(7, -14.3, 35.67, 65.19)
		event.add_object_sequence_path_point(7, -27.94, 35.67, 66.4)
		event.add_object_sequence_path_point(7, -68.78, 15.27, 70.03)
		event.add_object_sequence_path_point(7, -92.62, 14.0, 72.15)
		event.add_object_sequence_path_point(7, -111.92, 9.26, 73.86)
		event.add_object_sequence_path_point(7, -134.81, 0.0, 75.89)
		event.start_object_sequence_path(7)
		event.move_object_sequence(7, -1316.98, -0.0, -190.07, 195)
		event.delay_object_sequence_position_track(8, 60)
		event.clear_object_sequence_path(8)
		event.set_object_sequence_path_frames(8, 15)
		event.add_object_sequence_path_point(8, -14.3, 35.67, 66.92)
		event.add_object_sequence_path_point(8, -28.53, 35.67, 65.18)
		event.add_object_sequence_path_point(8, -75.65, 14.0, 64.98)
		event.add_object_sequence_path_point(8, -99.2, 14.0, 70.35)
		event.add_object_sequence_path_point(8, -120.92, 5.79, 62.69)
		event.add_object_sequence_path_point(8, -133.21, 0.0, 60.52)
		event.start_object_sequence_path(8)
		event.move_object_sequence(8, -1299.13, -0.0, -155.72, 195)
		event.delay_object_sequence_motion_track(3, 210)
		event.set_object_sequence_motion(3, "ふみきり", 6)
		event.queue_object_sequence_next_motion(3, "空中", 0)
		event.delay_object_sequence_motion_track(4, 220)
		event.set_object_sequence_motion(4, "ふみきり", 6)
		event.queue_object_sequence_next_motion(4, "空中", 0)
		event.delay_object_sequence_motion_track(6, 230)
		event.set_object_sequence_motion(6, "ふみきり", 6)
		event.queue_object_sequence_next_motion(6, "空中", 0)
		event.delay_object_sequence_motion_track(5, 240)
		event.set_object_sequence_motion(5, "ふみきり", 6)
		event.queue_object_sequence_next_motion(5, "空中", 0)
		event.delay_object_sequence_motion_track(8, 250)
		event.set_object_sequence_motion(8, "ふみきり", 6)
		event.queue_object_sequence_next_motion(8, "空中", 0)
		event.delay_object_sequence_motion_track(7, 260)
		event.set_object_sequence_motion(7, "ふみきり", 6)
		event.queue_object_sequence_next_motion(7, "空中", 0)
		event.delay_object_sequence_motion_track(2, 270)
		event.set_object_sequence_motion(2, "ふみきり", 6)
		event.queue_object_sequence_next_motion(2, "空中", 0)
		event.jump_object_sequence(5, -1998.62, -0.0, -102.27, -0.25, 60)
		event.delay_object_sequence_position_track(8, 0)
		event.jump_object_sequence(8, -1953.56, -0.0, -154.54, -0.25, 60)
		event.delay_object_sequence_position_track(7, 0)
		event.jump_object_sequence(7, -1920.26, -0.0, -167.95, -0.25, 60)
		event.delay_object_sequence_position_track(2, 0)
		event.jump_object_sequence(2, -1980.06, -0.86, -200.42, -0.25, 60)
		event.delay_object_sequence_position_track(3, 0)
		event.jump_object_sequence(3, -1901.42, -0.0, -212.85, -0.25, 60)
		event.delay_object_sequence_position_track(4, 0)
		event.jump_object_sequence(4, -1909.43, -0.0, -100.82, -0.25, 60)
		event.delay_object_sequence_position_track(6, 0)
		event.jump_object_sequence(6, -1963.98, -0.0, -28.93, -0.25, 60)
		at = 2
		wait_frames(75)
		event.play_sound_effect(var11, 14)
		at = 3
		wait_frames(255)
		helper_61224aa3()
		at = 4
		vm.wait(4)
		event.clear_memory_stack(6)
		at = 5
		helper_479dc9e9()
		helper_ec7d9573(var11)
		at = 6
		vm.wait(6)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(-130.74, 32.47, 120.8)
		event.set_camera_sequence_look_at(-102.69, 36.9, 82.53)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 7
		helper_4116e6bb(2500180)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "首をかしげる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 8
		wait_frames(5)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 9
		helper_4116e6bb(2500190)
		event.reset_mouth_texture_animations()
		at = 10
		wait_objects(0)
		event.play_sound_effect(var11, 15)
		at = 11
		wait_frames(3)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 12
		helper_4116e6bb(2500200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "指さす", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "指さすL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 13
		helper_4116e6bb(2500210)
		event.reset_mouth_texture_animations()
		at = 14
		wait_objects(0)
		event.play_music(1)
		event.set_character_active(1, 42)
		event.set_character_active(1, 46)
		event.set_character_position(46, pos_x - vm.f32(1780.39), pos_y + vm.f32(773.93), pos_z + vm.f32(82.37))
		event.set_character_rotation(46, 0.0, rot_y + vm.f32(0.36), 0.0)
		event.reset_object_sequence_motion(14)
		event.delay_object_sequence_motion_track(14, 30)
		event.set_object_sequence_motion(14, "木の葉散る", 6)
		event.attach_object_handle_to_character_frame(20, 42, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.set_camera_sequence_position(-1120.67, 799.61, 245.65)
		event.set_camera_sequence_look_at(-1205.48, 813.47, 219.34)
		event.set_object_sequence_position(9, -1983.37, 365.71, 26.93)
		event.set_object_sequence_rotation(9, 0.0, 1.85, 0.0)
		event.play_sound_effect(var11, 16)
		event.move_object_sequence_eased(9, -1983.37, 942.49, 26.93, 60, 0, 0.4)
		at = 15
		wait_objects(9)
		at = 16
		wait_frames(80)
		event.set_character_active(0, 46)
		event.move_camera_sequence_eased(206.33, 67.63, 392.02, 17.65, 209.62, 96.0, 120, 0, 0.4)
		event.move_object_sequence_eased(9, -203.42, 128.16, -69.67, 120, 0, 0.4)
		event.rotate_object_sequence_eased(9, 0.0, 1.13, 0.0, 120, 0, 0.4)
		at = 17
		wait_camera()
		event.set_character_active(0, 42)
		event.set_camera_sequence_position(-256.13, 70.1, 44.86)
		event.set_camera_sequence_look_at(-237.13, 29.77, 17.22)
		event.set_object_sequence_position(0, -241.0, 0.0, 2.23)
		event.set_object_sequence_rotation(0, 0.0, -0.41, 0.0)
		event.set_object_sequence_position(1, -215.63, 0.0, 10.45)
		event.set_object_sequence_rotation(1, 0.0, -0.68, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "うれし顔")
		event.set_object_sequence_texture_animation(0, 1, "目キラキラ")
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 18
		helper_1584c528(2500220, 90)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "うれし口～大口")
		at = 19
		helper_1584c528(2500230, 60)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 42)
		event.set_character_active(1, 43)
		event.set_character_active(1, 44)
		event.set_camera_sequence_position(-147.0, 30.77, -328.58)
		event.set_camera_sequence_look_at(-178.12, 65.41, -171.95)
		event.set_object_sequence_position(0, -249.75, 0.0, 7.65)
		event.set_object_sequence_rotation(0, 0.0, -0.41, 0.0)
		event.set_object_sequence_position(1, -193.44, 0.0, 6.3)
		event.set_object_sequence_rotation(1, 0.0, -0.68, 0.0)
		event.set_object_sequence_position(9, -335.13, 0.0, 295.03)
		event.set_object_sequence_rotation(9, 0.0, 2.81, 0.0)
		event.set_character_rotation(43, 0.0, 3.1415927, 0.0)
		event.set_character_rotation(44, 0.0, 3.1415927, 0.0)
		event.set_object_sequence_motion(9, "木持ち浮遊", 4)
		at = 20
		wait_frames(30)
		event.set_object_sequence_motion(9, "右の木を植える", 6)
		event.queue_object_sequence_next_motion(9, "右の木を植えるL", 4)
		at = 21
		wait_frames(8)
		event.set_object_sequence_motion(0, "右へよける", 6)
		event.set_object_sequence_motion(1, "上向きから驚き", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "上向きから驚きＬ", 0)
		at = 22
		wait_frames(10)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
		at = 23
		wait_frames(5)
		do
			local out1, _, out3 = event.get_object_handle_frame_position(9, "R_tree")
			pos_x_2 = out1 or pos_x_2
			pos_z_2 = out3 or pos_z_2
		end
		event.detach_character_from_frame(43)
		event.set_object_sequence_position(10, pos_x_2, 0.0, pos_z_2)
		event.set_object_sequence_motion(10, "ぷるん", 6)
		at = 24
		wait_objects(10)
		at = 25
		helper_1584c528(2500235, -1)
		at = 26
		wait_objects(9)
		event.set_character_active(0, 43)
		event.set_character_active(1, 45)
		event.set_object_sequence_position(13, 1200.0, -300.0, 12000.0)
		event.set_camera_sequence_position(-260.7, 41.9, 24.51)
		event.set_camera_sequence_look_at(-254.62, 30.24, 15.15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "前を見る", 6, 0.6)
		event.queue_object_sequence_next_motion(0, "前を見るL", 4)
		event.delay_object_sequence_position_track(13, 15)
		event.delay_object_sequence_motion_track(13, 15)
		event.set_object_sequence_position(13, -235.28, -5.32, -11.39)
		event.set_object_sequence_rotation(13, 0.0, 0.12, 0.0)
		event.set_object_sequence_motion(13, "回転", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 27
		helper_1584c528(2500240, 25)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 43)
		event.set_character_active(1, 44)
		event.set_character_active(0, 45)
		event.set_camera_sequence_position(-147.0, 30.77, -328.58)
		event.set_camera_sequence_look_at(-178.12, 65.41, -171.95)
		event.set_object_sequence_position(0, -310.86, 0.0, -37.43)
		event.set_object_sequence_rotation(0, 0.0, -0.41, 0.0)
		event.set_object_sequence_position(9, -407.63, 0.0, 280.62)
		event.set_object_sequence_rotation(9, 0.0, 2.81, 0.0)
		event.set_object_sequence_motion(9, "左の木を植える", 6)
		event.queue_object_sequence_next_motion(9, "左の木を植えるL", 4)
		at = 28
		wait_frames(8)
		event.set_object_sequence_motion(0, "左へよける", 6)
		at = 29
		wait_frames(10)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
		at = 30
		wait_frames(5)
		do
			local out1, _, out3 = event.get_object_handle_frame_position(9, "L_tree")
			pos_x_2 = out1 or pos_x_2
			pos_z_2 = out3 or pos_z_2
		end
		event.detach_character_from_frame(44)
		event.set_object_sequence_position(11, pos_x_2, 0.0, pos_z_2)
		event.set_object_sequence_motion(11, "ぷるん", 6)
		at = 31
		wait_objects(9)
		at = 32
		wait_frames(30)
		event.set_character_active(1, global1)
		event.set_character_active(0, 42)
		event.set_camera_sequence_position(-315.45, 23.19, 14.98)
		event.set_camera_sequence_look_at(-271.54, 21.8, 7.43)
		event.set_object_sequence_position(0, -276.1, 0.0, -7.52)
		event.set_object_sequence_rotation(0, 0.0, -0.41, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "うれし半口")
		event.set_object_sequence_motion(0, "よけたあと", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向きから驚きＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 33
		helper_4116e6bb(2500250)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(0, 1, "目キラキラ")
		event.set_object_sequence_motion(0, "すごいよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "すごいよL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 34
		helper_4116e6bb(2500260)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 42)
		event.set_character_active(0, 43)
		event.set_character_active(0, 44)
		event.set_camera_sequence_position(-366.92, 245.56, -135.81)
		event.set_camera_sequence_look_at(-333.13, 279.7, -11.5)
		event.set_object_sequence_position(0, -183.8, 0.0, 277.38)
		event.set_object_sequence_rotation(0, 0.0, -0.6, 0.0)
		event.set_object_sequence_position(1, -161.6, 0.0, 288.11)
		event.set_object_sequence_rotation(1, 0.0, -0.72, 0.0)
		event.set_object_sequence_position(9, -306.32, 272.97, 403.99)
		event.set_object_sequence_rotation(9, 0.0, 3.14, 0.0)
		event.play_sound_effect(var11, 19)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.set_object_sequence_motion(9, "浮遊", 4)
		event.move_camera_sequence_eased(-366.92, 245.56, -135.81, -333.13, 217.63, -11.5, 60, 2, 0.2)
		event.move_object_sequence_eased(9, -306.32, 83.84, 403.99, 60, 2, 0.2)
		at = 35
		wait_frames(72)
		event.set_character_active(1, 39)
		event.set_object_handle_shadow_enabled(0, 0)
		event.set_object_handle_shadow_enabled(1, 0)
		event.set_object_handle_shadow_enabled(5, 0)
		event.set_object_sequence_position(5, -314.51, 136.42, 395.63)
		event.set_object_sequence_rotation(5, 0.0, 3.04, 0.0)
		event.fade_out_music(60)
		event.set_object_sequence_motion(9, "浮遊", 2)
		event.wait_object_sequence_motion_end(9)
		at = 36
		wait_objects(9)
		event.play_sound_effect(var11, 20)
		event.set_object_sequence_motion(9, "入り口開く", 6)
		event.queue_object_sequence_next_motion(9, "入り口開くL", 4)
		event.move_object_sequence(5, -314.51, 12.03, 395.63, 66)
		at = 37
		wait_frames(67)
		event.set_camera_sequence_position(-272.42, 14.88, 304.99)
		event.set_camera_sequence_look_at(-302.58, 33.94, 399.83)
		event.set_object_sequence_position(0, -281.71, 0.0, 363.1)
		event.set_object_sequence_rotation(0, 0.0, -0.84, 0.0)
		event.set_object_sequence_position(1, -268.51, 0.0, 369.08)
		event.set_object_sequence_rotation(1, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(5, -315.44, 12.03, 391.74)
		event.set_object_sequence_rotation(5, 0.0, 2.32, 0.0)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(5, "会話", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		at = 38
		helper_4116e6bb(2500270)
		event.set_object_sequence_motion(0, "上→すごいよ", 6)
		event.queue_object_sequence_next_motion(0, "すごいよL", 0)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 39
		helper_4116e6bb(2500280)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "すごいよ戻り", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(5, "会話2", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		at = 40
		helper_4116e6bb(2500290)
		event.set_object_sequence_motion(0, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 41
		wait_objects(0)
		at = 42
		wait_frames(3)
		event.set_object_sequence_motion(0, "歩き", 0)
		event.set_object_sequence_motion(1, "歩き", 0)
		event.rotate_object_sequence(0, 0.0, 0.12, 0.0, 6)
		event.rotate_object_sequence(1, 0.0, -0.24, 0.0, 6)
		at = 43
		wait_frames(6)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_motion(1, "走り", 4)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 45)
		event.add_object_sequence_path_point(0, -285.87, 0.0, 357.41)
		event.add_object_sequence_path_point(0, -257.04, 0.0, 389.98)
		event.add_object_sequence_path_point(0, -274.42, 0.0, 429.26)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 45)
		event.add_object_sequence_path_point(1, -266.64, 0.0, 363.55)
		event.add_object_sequence_path_point(1, -264.8, 0.0, 426.42)
		event.add_object_sequence_path_point(1, -300.44, 0.0, 458.67)
		event.start_object_sequence_path(1)
		at = 44
		wait_frames(30)
		event.clear_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_camera_sequence_position(-312.83, 198.18, 285.67)
		event.set_camera_sequence_look_at(-304.45, 164.0, 318.5)
		event.set_object_sequence_position(0, -294.8, 16.560001, 393.65)
		event.set_object_sequence_rotation(0, 0.0, 2.44, 0.0)
		event.set_object_sequence_position(1, -289.64, 16.560001, 408.11)
		event.set_object_sequence_rotation(1, 0.0, 2.35, 0.0)
		event.set_object_sequence_position(5, -310.53, 16.560001, 383.79)
		event.set_object_sequence_rotation(5, 0.0, 2.68, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		at = 45
		wait_frames(30)
		event.play_sound_effect(var11, 21)
		event.set_object_sequence_motion(9, "閉まる", 6, -1.0, 1)
		event.move_object_sequence(0, -294.8, 150.42, 393.65, 68)
		event.move_object_sequence(1, -289.64, 150.42, 408.11, 68)
		event.move_object_sequence(5, -310.53, 150.42, 383.79, 68)
		at = 46
		wait_frames(38)
		event.fade_out_screen(30)
		at = 47
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			var10 = 0
			local _ = var10 < 7
			var10 = var10 + 1
			wait_frames_skipping(75)
		end
		if at <= 2 then
			wait_frames_skipping(255)
		end
		if at <= 3 then
			helper_1ef0d4b2()
		end
		if at <= 4 then
			helper_344d6cd8()
		end
		if at <= 5 then
			helper_e6c0ae70(var11)
		end
		if at <= 6 then
			helper_8cd371d7(2500180)
		end
		if at <= 7 then
			wait_frames_skipping(5)
		end
		if at <= 8 then
			helper_8cd371d7(2500190)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			wait_frames_skipping(3)
		end
		if at <= 11 then
			helper_8cd371d7(2500200)
		end
		if at <= 12 then
			helper_8cd371d7(2500210)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_238b5abc(9)
		end
		if at <= 15 then
			wait_frames_skipping(80)
		end
		if at <= 16 then
			helper_344d6cd8()
		end
		if at <= 17 then
			helper_52aadc70(2500220, 90)
		end
		if at <= 18 then
			helper_52aadc70(2500230, 60)
		end
		if at <= 19 then
			wait_frames_skipping(30)
		end
		if at <= 20 then
			wait_frames_skipping(8)
		end
		if at <= 21 then
			wait_frames_skipping(10)
		end
		if at <= 22 then
			wait_frames_skipping(5)
		end
		if at <= 23 then
			helper_238b5abc(10)
		end
		if at <= 24 then
			helper_52aadc70(2500235, -1)
		end
		if at <= 25 then
			helper_238b5abc(9)
		end
		if at <= 26 then
			helper_52aadc70(2500240, 25)
		end
		if at <= 27 then
			wait_frames_skipping(8)
		end
		if at <= 28 then
			wait_frames_skipping(10)
		end
		if at <= 29 then
			wait_frames_skipping(5)
		end
		if at <= 30 then
			helper_238b5abc(9)
		end
		if at <= 31 then
			wait_frames_skipping(30)
		end
		if at <= 32 then
			helper_8cd371d7(2500250)
		end
		if at <= 33 then
			helper_8cd371d7(2500260)
		end
		if at <= 34 then
			wait_frames_skipping(72)
		end
		if at <= 35 then
			helper_238b5abc(9)
		end
		if at <= 36 then
			wait_frames_skipping(67)
		end
		if at <= 37 then
			helper_8cd371d7(2500270)
		end
		if at <= 38 then
			helper_8cd371d7(2500280)
		end
		if at <= 39 then
			helper_8cd371d7(2500290)
		end
		if at <= 40 then
			helper_238b5abc(0)
		end
		if at <= 41 then
			wait_frames_skipping(3)
		end
		if at <= 42 then
			wait_frames_skipping(6)
		end
		if at <= 43 then
			wait_frames_skipping(30)
		end
		if at <= 44 then
			wait_frames_skipping(30)
		end
		if at <= 45 then
			wait_frames_skipping(38)
		end
		if at <= 46 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 48
	vm.entry(48)
	event.cancel_drama_scene_skip()
	event.stop_music(1)
	event.stop_music(0)
	event.stop_sound_effect(var11, 15)
	event.set_object_handle_shadow_enabled(0, 1)
	event.set_object_handle_shadow_enabled(1, 1)
	event.set_object_handle_shadow_enabled(5, 1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	var10 = 0
	while var10 < 7 do
		event.set_object_sequence_motion(2 + var10, "走り", 4)
		event.set_object_handle_footstep_sound(5 + var10, 0)
		var10 = var10 + 1
	end
	helper_10608()
	event.set_object_handle_visible(13, 1)
	event.initialize_event()
end

--- Helper function.
local function helper_1945c()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	block = event.load_event_image_4(5, "textures/event/e200/e250/e250_2d.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e250_cut25", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(2, 0)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.load_message_file(0, 5, "event/e200/e250/e250_1.txt")
end

--- Helper function.
local function helper_22900000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_19130()
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
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_1a3cc()
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local at: number = 0
	vm.section(function()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.set_save_flag(250, 1)
		event.initialize_event()
		var1 = event.load_sound_effect_file_2(2234) or var1
		helper_1945c()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.enable_drama_skip()
		event.play_sound_effect(var1, 22)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.set_character_position(global0, var2, var3, var4)
		event.set_character_position(global1, var2, var3, var4)
		event.fade_in_screen(30)
		event.set_camera_sequence_position(-772.48, 31.27, -965.22)
		event.set_camera_sequence_look_at(-701.0, 38.37, -1042.75)
		event.set_object_sequence_position(0, -647.25, -0.0, -1047.89)
		event.set_object_sequence_rotation(0, 0.0, -2.11, 0.0)
		event.set_object_sequence_position(1, -654.69, -0.0, -1072.52)
		event.set_object_sequence_rotation(1, 0.0, -1.2, 0.0)
		at = 2
		vm.wait(2)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 3
		helper_4116e6bb(2500500)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 4
		helper_4116e6bb(2500510)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, global1)
		event.set_camera_sequence_position(-701.14, 38.12, -985.84)
		event.set_camera_sequence_look_at(-699.63, 28.19, -1037.85)
		event.move_camera_sequence_eased(-701.14, 38.12, -985.84, -699.63, 51.5, -1037.85, 90, 2, 0.4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 5
		helper_4116e6bb(2500520)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 6
		helper_4116e6bb(2500525)
		event.reset_mouth_texture_animations()
		at = 7
		wait_objects(1)
		at = 8
		wait_camera()
		event.set_character_active(1, global1)
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
		event.set_camera_sequence_position(-697.66, 20.36, -1062.26)
		event.set_camera_sequence_look_at(-643.59, 17.44, -1071.09)
		event.set_object_sequence_position(0, -639.63, -0.0, -1057.59)
		event.set_object_sequence_rotation(0, 0.0, -1.75, 0.0)
		event.set_object_sequence_position(1, -646.9, -0.0, -1083.44)
		event.set_object_sequence_rotation(1, 0.0, -0.84, 0.0)
		event.set_object_sequence_motion(1, "左向くL", 4, -1.0, 1)
		event.set_character_cloth_animation_enabled(global0, 0)
		event.set_object_sequence_motion(0, "アトラを持つ", 6)
		event.queue_object_sequence_next_motion(0, "アトラを持つL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 9
		helper_4116e6bb(2500530)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 10
		helper_4116e6bb(2500540)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 11
		helper_4116e6bb(2500545)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(2, 128.0, 128.0, 128.0, 128.0, 10)
		at = 12
		helper_4116e6bb(2500550)
		at = 13
		helper_4116e6bb(2500555)
		at = 14
		helper_4116e6bb(2500560)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.set_character_cloth_animation_enabled(global0, 1)
		event.set_camera_sequence_position(-799.13, 98.14, -1023.59)
		event.set_camera_sequence_look_at(-641.21, 13.62, -1089.99)
		event.set_object_sequence_position(0, -647.09, -0.0, -1050.31)
		event.set_object_sequence_rotation(0, 0.0, -1.75, 0.0)
		event.set_object_sequence_position(1, -643.59, -0.0, -1073.29)
		event.set_object_sequence_rotation(1, 0.0, -1.56, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 15
		helper_4116e6bb(2500570)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "上→右見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 16
		helper_4116e6bb(2500580)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 17
		helper_4116e6bb(2500585)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
		event.set_character_active(0, global0)
		event.set_camera_sequence_position(-675.55, 30.55, -1072.9)
		event.set_camera_sequence_look_at(-648.05, 22.05, -1072.56)
		event.play_sound_effect(var1, 23)
		event.set_object_sequence_motion(1, "アトラ見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "アトラ見るL", 0)
		at = 18
		wait_frames(27)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 19
		helper_4116e6bb(2500590)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 20
		helper_4116e6bb(2500595)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "アトラ見から立ちに", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 21
		helper_4116e6bb(2500600)
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.set_camera_sequence_position(-675.37, 33.53, -1088.87)
		event.set_camera_sequence_look_at(-659.31, 20.57, -1054.58)
		event.set_object_sequence_position(0, -661.43, -0.0, -1055.96)
		event.set_object_sequence_rotation(0, 0.0, 3.04, 0.0)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4)
		at = 22
		helper_4116e6bb(2500610)
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(-757.19, 37.47, -1029.97)
		event.set_camera_sequence_look_at(-663.0, 20.57, -1070.18)
		event.set_object_sequence_position(0, -642.21, -0.0, -1050.46)
		event.set_object_sequence_rotation(0, 0.0, -2.04, 0.0)
		event.set_object_sequence_position(1, -653.99, -0.0, -1067.84)
		event.set_object_sequence_rotation(1, 0.0, -0.36, 0.0)
		event.set_object_sequence_motion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.rotate_object_sequence(1, 0.0, -2.28, 0.0, 30)
		at = 23
		helper_4116e6bb(2500620)
		at = 24
		helper_4116e6bb(2500630)
		event.set_character_cloth_animation_enabled(global0, 0)
		event.play_sound_effect(var1, 24)
		event.set_object_sequence_motion(0, "アトラを持つ", 6)
		event.queue_object_sequence_next_motion(0, "アトラを持つL", 0)
		at = 25
		helper_4116e6bb(2500640)
		at = 26
		wait_objects(0)
		at = 27
		wait_frames(30)
		event.set_object_sequence_motion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.rotate_object_sequence(1, 0.0, 0.24, 0.0, 30)
		at = 28
		wait_frames(30)
		at = 29
		helper_4116e6bb(2500650)
		at = 30
		helper_4116e6bb(2500655)
		event.set_object_sequence_motion(1, "アトラを持つ戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 31
		wait_frames(15)
		event.play_sound_effect(var1, 25)
		event.set_object_sequence_motion(0, "うなづく", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 32
		helper_4116e6bb(2500660)
		event.fade_out_screen(30)
		at = 33
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22900000()
		end
		if at <= 2 then
			helper_8cd371d7(2500500)
		end
		if at <= 3 then
			helper_8cd371d7(2500510)
		end
		if at <= 4 then
			helper_8cd371d7(2500520)
		end
		if at <= 5 then
			helper_8cd371d7(2500525)
		end
		if at <= 6 then
			helper_238b5abc(1)
		end
		if at <= 7 then
			helper_344d6cd8()
		end
		if at <= 8 then
			helper_8cd371d7(2500530)
		end
		if at <= 9 then
			helper_8cd371d7(2500540)
		end
		if at <= 10 then
			helper_8cd371d7(2500545)
		end
		if at <= 11 then
			helper_8cd371d7(2500550)
		end
		if at <= 12 then
			helper_8cd371d7(2500555)
		end
		if at <= 13 then
			helper_8cd371d7(2500560)
		end
		if at <= 14 then
			helper_8cd371d7(2500570)
		end
		if at <= 15 then
			helper_8cd371d7(2500580)
		end
		if at <= 16 then
			helper_8cd371d7(2500585)
		end
		if at <= 17 then
			wait_frames_skipping(27)
		end
		if at <= 18 then
			helper_8cd371d7(2500590)
		end
		if at <= 19 then
			helper_8cd371d7(2500595)
		end
		if at <= 20 then
			helper_8cd371d7(2500600)
		end
		if at <= 21 then
			helper_8cd371d7(2500610)
		end
		if at <= 22 then
			helper_8cd371d7(2500620)
		end
		if at <= 23 then
			helper_8cd371d7(2500630)
		end
		if at <= 24 then
			helper_8cd371d7(2500640)
		end
		if at <= 25 then
			helper_238b5abc(0)
		end
		if at <= 26 then
			wait_frames_skipping(30)
		end
		if at <= 27 then
			wait_frames_skipping(30)
		end
		if at <= 28 then
			helper_8cd371d7(2500650)
		end
		if at <= 29 then
			helper_8cd371d7(2500655)
		end
		if at <= 30 then
			wait_frames_skipping(15)
		end
		if at <= 31 then
			helper_8cd371d7(2500660)
		end
		if at <= 32 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var1, 22)
	helper_19130()
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1e050

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_10bd8()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s26", 501)
	vm.wait(2)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_1a3cc()
	event.jump_to_map_2(-1, "g01")
end

--- Event 505, which map data, a script or the engine runs by number.
function script.event_505()
	helper_1e050()
	event.jump_to_map_3(-1, "s26", 502)
	vm.wait(2)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_10bd8()
		print("KITA###########################\n")
		event.fade_in_screen(30)
		print("KITA2222222###########################\n")
		return
	end, function(received: { any })
		if at <= 1 then
			print("KITA###########################\n")
			print("KITA2222222###########################\n")
			return 0
		end
		return nil
	end)
end

return script
