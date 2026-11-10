--!strict
-- map/s/s11/s11_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02a8d032 = require("@lib/event/helper_02a8d032")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_194337c1 = require("@lib/event/helper_194337c1")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_48c10ac3 = require("@lib/event/helper_48c10ac3")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_56de521d = require("@lib/event/helper_56de521d")
local helper_5d8e6e04 = require("@lib/event/helper_5d8e6e04")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_7d730ff7 = require("@lib/event/helper_7d730ff7")
local helper_8ab07f4b = require("@lib/event/helper_8ab07f4b")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_98e2328c = require("@lib/event/helper_98e2328c")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_9e146e8b = require("@lib/event/helper_9e146e8b")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_b4453d02 = require("@lib/event/helper_b4453d02")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_c4692af0 = require("@lib/event/helper_c4692af0")
local helper_c99744f1 = require("@lib/event/helper_c99744f1")
local helper_cc3637c1 = require("@lib/event/helper_cc3637c1")
local helper_ce5f1c27 = require("@lib/event/helper_ce5f1c27")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local helper_f4ec8310 = require("@lib/event/helper_f4ec8310")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_fdad3d3b = require("@lib/event/helper_fdad3d3b")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	local var1: s32 = 0
	helper_4337dd96()
	flag = event.get_save_flag(640) or flag
	helper_56de521d(flag)
	var1 = event.get_save_counter(16) or var1
	if bit32.band(var1, 1) ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_10-m0")
		event.set_object_handle_visible(0, 1)
	end
	if bit32.band(var1, 2) ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_09-m1")
		event.set_object_handle_visible(0, 1)
	end
	if bit32.band(var1, 4) ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_08-m0")
		event.set_object_handle_visible(0, 1)
	end
	if bit32.band(var1, 8) ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_07-m0")
		event.set_object_handle_visible(0, 1)
	end
end

--- Helper function.
local function helper_3a998()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: any = 0
	local language_code: s32 = 0
	local var4: f32 = 0
	local var5: any = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(13) or var0
		flag = event.get_save_flag(55) or flag
		if flag == 0 then
			event.set_save_flag(55, 1)
			event.set_message_bubble_tail(0, 1)
			event.apply_message_window_preset(0, 0)
			at = 1
			helper_31bbf01d(0, var0, 0)
			event.open_message_window_2(
				0,
				"Wow! I Raccordi Temporali sono\ndavvero possibili! Incredibile!<page>La scienza di quegli antichi\npoteva tutto, eh?"
			)
			at = 2
			helper_0ffc2526(0, -1, var0, 0, 0)
			event.open_message_window_2(
				0,
				"Ho scoperto che un oggetto in\nRaccordo Temporale pu[UNI00f2] esistere\nin due spazi e tempi diversi."
			)
			at = 3
			helper_0ffc2526(0, -1, var0, 0, 0)
			event.open_message_window_2(
				0,
				"Ci[UNI00f2] significa che Paznos\nora [UNI00e8] qui, ma che esiste\nanche nel futuro.<page>Capisco che non sia un concetto\nsemplice da afferrare!"
			)
			at = 4
			helper_0ffc2526(0, -1, var0, 0, 0)
			event.open_message_window_2(0, "Bene, credo sia meglio\navviarsi.")
			at = 5
			helper_0ffc2526(0, -1, var0, 0, 0)
			event.set_character_motion(var0, "立ち")
			set_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(0, "S[UNI00ec][UNI00ec][UNI00ec]!\nVoglio rimanere un altro po'.")
			at = 6
			var2 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
			event.set_message_window_option(0, 0, 0)
			event.set_message_bubble_tail(0, 1)
			if var2 ~= 0 then
				event.set_character_motion(var0, "会話")
				event.open_message_window_2(0, "Sbrighiamoci.")
				at = 7
				helper_0ffc2526(0, -1, var0, 0, 0)
				event.set_character_motion(var0, "立ち")
				event.finish_event()
				return 0
			end
			return 1
		else
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			language_code = event.get_language() or language_code
			if language_code == 0 then
				event.load_message_file(0, 5, "event/e600/e648/e648.txt")
			else
				event.load_message_file(0, 5, "event/e600/e648/e648_1.txt")
			end
			event.stop_music(0)
			at = 8
			var4 = helper_4e93f9fc(var0, 0, 0)
			at = 9
			helper_4116e6bb(6480010)
			event.set_character_motion(var0, "立ち")
			set_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(0, "S[UNI00ec][UNI00ec][UNI00ec]!\nVoglio rimanere un altro po'.")
			at = 10
			var5 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
			event.set_message_window_option(0, 0, 0)
			event.set_message_bubble_tail(0, 1)
			if var5 ~= 0 then
				event.set_character_motion(var0, "会話")
				event.set_message_window_mode(0, 7)
				at = 11
				helper_4116e6bb(6480020)
			end
			event.load_message_file(0, -1)
			set_window_mode(0, 1)
			at = 12
			helper_5d8e6e04(var0, var4, 0, 0)
			if var5 == 0 then
				return 1
			else
				event.play_music(0)
				return 0
			end
		end
	end, function(received: { any })
		if at <= 7 then
			if at == 6 then
				var2 = received[1] :: number
			end
			if at <= 1 then
				helper_48c10ac3(0, -1, var0, 0, 0)
			end
			if at <= 2 then
				helper_48c10ac3(0, -1, var0, 0, 0)
			end
			if at <= 3 then
				helper_48c10ac3(0, -1, var0, 0, 0)
			end
			if at <= 4 then
				helper_48c10ac3(0, -1, var0, 0, 0)
			end
			if at <= 5 then
				helper_8ab07f4b(0, 1)
				var2 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_48c10ac3(0, -1, var0, 0, 0)
			end
			return 0
		end
		if at <= 12 then
			if at == 8 then
				var4 = received[1] :: number
			end
			if at == 10 then
				var5 = received[1] :: number
			end
			if at <= 8 then
				helper_8cd371d7(6480010)
			end
			if at <= 9 then
				helper_8ab07f4b(0, 1)
				var5 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 10 then
				helper_8cd371d7(6480020)
			end
			if at <= 11 then
				helper_8ab07f4b(0, 1)
				helper_194337c1(var0, var4, 0, 0)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_2acf0()
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
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(13, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 13)
	event.load_character(5, "event/e600/e616/e616_eina_holo.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(6, 41)
	event.clear_object_sequence(6, 41)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/e600/e616/e616_touei.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e600/e616/e616_hologram.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.set_scene_character_type(40, 4)
	event.load_character(5, "event/e600/e616/e616_key_h.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 43)
	event.attach_object_handle_to_character(15, 43)
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 15)
	event.set_character_active(0, 43)
	event.attach_object_handle_to_map_part_2(16, "p10_s48")
	event.attach_object_handle_to_map_part_2(4, "p01_train01")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_12-m1")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.attach_object_handle_to_map_part_3(7, "p01_s11", "s11_06-m0")
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.attach_object_handle_to_map_part_3(8, "p01_s11", "s11_04-m0")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_3(9, "p01_s11", "s11_05-m0")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_4(10, "p01_s11", "s11_04-m0", "mi1")
	event.attach_object_handle_to_map_part_4(11, "p01_s11", "s11_05-m0", "mi2")
	event.attach_object_handle_to_map_part_4(12, "p01_s11", "s11_06-m0", "mi")
	event.attach_object_handle_to_map_part_3(14, "p01_s11", "s11_03-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 14)
	block = event.load_event_image_4(5, "textures/event/e600/e616/e616.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e61601", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e61602", block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(21, 1)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "e61603", block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 416)
	event.set_event_sprite_size(2, 512, 416)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(22, 2)
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "e61604", block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(3, 512, 416)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(23, 3)
	event.clear_object_sequence(23)
	event.set_object_sequence_object(23, 23)
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "e61605", block)
	event.set_event_sprite_color(4, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(4, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(4, 512, 416)
	event.set_event_sprite_position(4, 256, 208)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(24, 4)
	event.clear_object_sequence(24)
	event.set_object_sequence_object(24, 24)
	event.load_message_file(0, 5, "event/e600/e616/e616_1.txt")
end

--- Helper function.
local function helper_22c00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_2a63c()
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
	event.set_object_sequence_position(4, 895.0, -254.5, 3348.1)
	event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
	event.set_object_sequence_position(9, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(8, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(7, 0.0, 0.0, 0.0)
	event.set_object_handle_frame_visible(10, "", 1)
	event.set_object_handle_frame_visible(11, "", 1)
	event.delete_event_image(0)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_character(43)
	event.set_character_position(0, 1.4, -13.3, 312.5)
	event.set_character_rotation(0, 0.0, 3.12, 0.0)
	event.set_scene_status_flags(1, 0, 256, 0)
end

--- Helper function.
local function helper_2d158()
	local var6: s32 = 0
	local var7: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var27: s32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 2
		vm.wait(2)
		at = 3
		vm.wait(3)
		at = 4
		vm.wait(4)
		at = 5
		vm.wait(5)
		event.load_music(5)
		event.play_music(0)
		var6 = event.load_sound_effect_file_2(6201) or var6
		var7 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var7
		helper_4337dd96()
		helper_2acf0()
		event.set_scene_status_flags(1, 0, 256, 1)
		event.set_object_handle_frame_visible(10, "", 0)
		event.set_object_handle_frame_visible(11, "", 0)
		event.set_object_handle_visible(16, 0)
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_footstep_sound(13, 14)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "目パチ")
		event.set_object_sequence_position(9, 0.0, 45.5, 0.0)
		event.set_object_sequence_position(8, 0.0, 45.5, 0.0)
		event.set_object_sequence_position(7, 0.0, -71.0, 0.0)
		event.set_object_handle_position(4, 6000.0, 2400.0, 5548.1)
		event.set_object_handle_rotation(4, 0.2, -1.77, 0.0)
		event.set_camera_sequence_position(0.0, 95.11, 4837.34)
		event.set_camera_sequence_look_at(6000.0, 2400.0, 5548.1)
		event.play_sound_effect(var6, 0)
		event.fade_in_screen(30)
		event.rotate_object_sequence_eased(4, 0.0, -1.57, 0.0, 60, 2, 1.0)
		var11 = 0
		while var11 < 90 do
			at = 6
			vm.wait(6)
			do
				local out1, out2, out3 = event.get_object_handle_position(4)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			pos_x = vm.f32(pos_x + vm.f32(vm.f32(-790.0 - pos_x) / 24.0))
			pos_y = vm.f32(pos_y + vm.f32(vm.f32(-254.5 - pos_y) / 16.0))
			pos_z = vm.f32(pos_z + vm.f32(vm.f32(vm.f32(3348.1) - pos_z) / 16.0))
			event.set_object_handle_position(4, pos_x, pos_y, pos_z)
			event.set_camera_sequence_look_at(pos_x, pos_y, pos_z)
			var11 = var11 + 1
		end
		event.move_object_sequence_eased(4, -790.0, -254.5, 3348.1, 30, 2, 1.0)
		event.move_camera_sequence_look_at(0.0, 102.15, 3577.24, 60)
		event.rotate_object_sequence(4, 0.0, -1.57, 0.0, 30)
		var12 = 2.0
		var11 = 0
		while var11 < 30 do
			do
				local out1, out2, out3 = event.get_object_handle_position(4)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			if vm.imod(var11, 2) == 0 then
				pos_y = vm.f32(pos_y + var12)
			else
				pos_y = vm.f32(pos_y - var12)
			end
			var12 = vm.f32(var12 - vm.f32(var12 / 30.0))
			event.set_object_handle_position(4, pos_x, pos_y, pos_z)
			var11 = var11 + 1
			at = 7
			vm.wait(7)
		end
		at = 8
		wait_objects(4)
		at = 9
		wait_camera()
		at = 10
		wait_frames(60)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_camera_sequence_follow_object(0, 0.0, 25.0, 0.0, -3.12, -10.0, 70.0)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "歩き")
		event.set_object_sequence_position(1, -20.0, -268.4, 2550.0)
		event.set_object_sequence_rotation(1, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(0, 0.0, -268.4, 2550.0)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(2, 20.0, -268.4, 2550.0)
		event.set_object_sequence_rotation(2, 0.0, -3.12, 0.0)
		event.move_object_sequence(0, 0.0, -268.4, 2450.0, 60, 1)
		event.move_object_sequence(1, -20.0, -268.4, 2450.0, 60, 1)
		event.move_object_sequence(2, 20.0, -268.4, 2450.0, 60, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 11
		helper_1584c528(6160130, -1)
		event.reset_mouth_texture_animations()
		at = 12
		wait_frames(30)
		event.release_camera_sequence_follow_object()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(581.19, 1481.15, 2239.69, 100.38, -155.85, 234.68)
		event.add_camera_sequence_path_point(855.1, 1481.15, 2395.2, 100.38, -155.85, 234.68)
		event.start_camera_sequence_path()
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 240)
		event.add_object_sequence_path_point(0, 0.0, -118.38, 1388.15)
		event.add_object_sequence_path_point(0, 0.0, -79.03, 1037.78)
		event.start_object_sequence_path(0, 1)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 240)
		event.add_object_sequence_path_point(1, -20.0, -118.38, 1388.15)
		event.add_object_sequence_path_point(1, -20.0, -79.03, 1037.78)
		event.start_object_sequence_path(1, 1)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 240)
		event.add_object_sequence_path_point(2, 20.0, -118.38, 1388.15)
		event.add_object_sequence_path_point(2, 20.0, -79.03, 1037.78)
		event.start_object_sequence_path(2, 1)
		at = 13
		helper_1584c528(6160140, -1)
		at = 14
		helper_1584c528(6160150, -1)
		at = 15
		wait_frames(30)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_footstep_sound(13, 2)
		event.set_camera_sequence_position(5.17, 166.7, 673.45)
		event.set_camera_sequence_look_at(0.43, 32.65, 49.45)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 200)
		event.add_object_sequence_path_point(0, -11.19, -13.08, 430.16)
		event.add_object_sequence_path_point(0, 13.82, -7.06, 230.85)
		event.add_object_sequence_path_point(0, 57.64, -7.06, 139.2)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 220)
		event.add_object_sequence_path_point(1, -25.21, -13.07, 432.0)
		event.add_object_sequence_path_point(1, -23.57, -9.29, 250.9)
		event.add_object_sequence_path_point(1, -36.33, -7.06, 152.97)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 240)
		event.add_object_sequence_path_point(2, 39.42, -13.09, 422.23)
		event.add_object_sequence_path_point(2, 6.38, -13.28, 301.26)
		event.add_object_sequence_path_point(2, -3.42, -7.89, 248.04)
		event.add_object_sequence_path_point(2, 0.66, -7.06, 171.52)
		event.start_object_sequence_path(2)
		at = 16
		wait_objects(0)
		event.play_sound_effect(var6, 1)
		event.set_object_sequence_motion(0, "立ち")
		at = 17
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		at = 18
		wait_objects(2)
		event.set_object_sequence_motion(2, "立ち")
		at = 19
		helper_4116e6bb(6160160)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_camera_sequence_position(30.32, 33.53, 321.43)
		event.set_camera_sequence_look_at(-19.91, 9.23, 144.84)
		event.set_character_position(39, -2.0, -3.77, 210.36)
		event.set_character_rotation(39, 0.0, 3.05, 0.0)
		event.set_character_position(40, -2.0, -3.77, 210.36)
		event.set_character_rotation(40, 0.0, 3.05, 0.0)
		event.set_object_sequence_position(1, -32.3, -7.06, 187.68)
		event.set_object_sequence_rotation(1, 0.0, 0.83, 0.0)
		event.set_object_sequence_position(0, 28.47, -7.06, 175.02)
		event.set_object_sequence_rotation(0, 0.0, -0.49, 0.0)
		event.set_object_sequence_position(2, -3.65, -7.06, 218.56)
		event.set_object_sequence_rotation(2, 0.0, 3.05, 0.0)
		event.set_object_sequence_motion(0, "下見立ち")
		event.set_object_sequence_motion(1, "下見立ち")
		event.play_sound_effect(var6, 2)
		event.set_object_sequence_motion(2, "装置置く", 6)
		event.queue_object_sequence_next_motion(2, "装置置くループ", 4)
		at = 20
		wait_frames(60)
		event.set_object_sequence_motion(2, "装置置く戻り", 6)
		at = 21
		wait_objects(2)
		event.set_character_active(1, 39)
		event.set_character_active(1, 40)
		event.play_sound_effect(var6, 3)
		event.set_character_motion(40, "現れる", 6, -1, 1)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 22
		wait_frames(30)
		event.set_character_active(0, 38)
		event.set_character_active(1, 41)
		event.set_object_sequence_position(6, -2.0, 5.2, 210.36)
		event.set_object_sequence_rotation(6, 0.0, 3.12, 0.0)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_camera_sequence_position(25.82, 26.72, 190.12)
		event.set_camera_sequence_look_at(-1.98, 29.58, 205.98)
		event.set_mouth_texture_animations(6, "口パク")
		at = 23
		helper_4116e6bb(6160170)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(25.82, 26.72, 190.12, -1.98, 29.58, 205.98)
		event.add_camera_sequence_path_point(-28.98, 26.72, 187.0, -1.98, 29.58, 205.98)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(6, "口パク")
		at = 24
		helper_4116e6bb(6160180)
		event.reset_mouth_texture_animations()
		at = 25
		wait_camera()
		event.set_mouth_texture_animations(6, "口パク")
		at = 26
		helper_4116e6bb(6160190)
		event.reset_mouth_texture_animations()
		at = 27
		wait_frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_camera_sequence_position(20.07, 36.4, 255.98)
		event.set_camera_sequence_look_at(-5.23, 17.06, 110.89)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 28
		helper_4116e6bb(6160200)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "口パク")
		at = 29
		helper_4116e6bb(6160210)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(20.07, 36.4, 255.98, -5.23, 17.06, 110.89)
		event.add_camera_sequence_path_point(-24.67, 36.4, 257.05, -5.23, 17.06, 110.89)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 30
		helper_4116e6bb(6160220)
		event.reset_mouth_texture_animations()
		at = 31
		wait_camera()
		event.set_mouth_texture_animations(6, "口パク")
		at = 32
		helper_4116e6bb(6160230)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 33
		helper_4116e6bb(6160240)
		event.reset_mouth_texture_animations()
		at = 34
		wait_frames(15)
		event.set_character_active(1, 38)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(800)
		event.add_camera_sequence_path_point(-17.0, 360.21, 536.27, -2.0, 596.27, 210.36)
		event.add_camera_sequence_path_point(-17.0, 142.48, 536.27, -2.0, 17.1, 210.36)
		event.start_camera_sequence_path()
		at = 35
		helper_1584c528(6160250, -1)
		at = 36
		helper_1584c528(6160255, -1)
		at = 37
		helper_1584c528(6160260, -1)
		at = 38
		helper_1584c528(6160270, -1)
		at = 39
		helper_1584c528(6160275, -1)
		at = 40
		helper_1584c528(6160280, -1)
		at = 41
		helper_4116e6bb(6160290)
		at = 42
		wait_frames(30)
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(24, 128, 128, 128, 128, 30)
		at = 43
		helper_4116e6bb(6160300)
		at = 44
		helper_4116e6bb(6160305)
		event.clear_camera_sequence_path()
		event.clear_camera_sequence()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(20.07, 36.4, 255.98)
		event.set_camera_sequence_look_at(-5.23, 17.06, 110.89)
		at = 45
		vm.wait(45)
		event.set_object_sequence_color(24, 128, 128, 128, 0, 30)
		at = 46
		wait_frames(30)
		at = 47
		helper_4116e6bb(6160310)
		event.set_object_sequence_motion(0, "上→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		at = 48
		wait_frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(0.0, 140.0, 0.0, -229.22, 17.06, 307.42)
		event.add_camera_sequence_path_point(0.0, 140.0, 0.0, -276.98, 17.06, -272.13)
		event.start_camera_sequence_path()
		at = 49
		helper_4116e6bb(6160320)
		at = 50
		helper_4116e6bb(6160330)
		at = 51
		wait_camera()
		at = 52
		wait_frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(0.0, 140.0, 0.0, 236.12, 17.06, -313.37)
		event.add_camera_sequence_path_point(0.0, 140.0, 0.0, 282.78, 17.06, 279.16)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		at = 53
		helper_4116e6bb(6160340)
		at = 54
		helper_4116e6bb(6160350)
		at = 55
		wait_camera()
		at = 56
		wait_frames(30)
		event.set_camera_sequence_position(-1.43, 44.53, 179.99)
		event.set_camera_sequence_look_at(-2.0, 29.91, 210.36)
		event.set_mouth_texture_animations(6, "口パク")
		at = 57
		helper_4116e6bb(6160360)
		event.reset_mouth_texture_animations()
		at = 58
		wait_frames(30)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(20, 128, 128, 128, 128, 30)
		at = 59
		helper_4116e6bb(6160370)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(21, 128, 128, 128, 128, 30)
		at = 60
		helper_4116e6bb(6160373)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(22, 128, 128, 128, 128, 30)
		at = 61
		helper_4116e6bb(6160377)
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(23, 128, 128, 128, 128, 30)
		at = 62
		wait_frames(60)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_object_sequence_color(23, 128, 128, 128, 0, 30)
		event.set_camera_sequence_position(-1.02, 0.96, 158.0)
		event.set_camera_sequence_look_at(-2.0, 21.86, 210.36)
		event.set_mouth_texture_animations(6, "口パク")
		at = 63
		helper_4116e6bb(6160380)
		event.reset_mouth_texture_animations()
		at = 64
		wait_frames(30)
		event.set_character_active(1, 38)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_camera_sequence_position(625.14, 908.7, 665.85)
		event.set_camera_sequence_look_at(-3.77, 13.41, -2.77)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -32.3, -7.06, 187.68)
		event.add_object_sequence_path_point(1, -11.34, -7.06, 108.48)
		event.add_object_sequence_path_point(1, -9.03, -7.06, 99.73)
		event.start_object_sequence_path(1, 1)
		at = 65
		wait_objects(1)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(0, 25.73, -7.06, 162.26)
		event.set_object_sequence_rotation(0, 0.0, -2.65, 0.0)
		event.set_camera_sequence_position(-198.14, 96.68, 321.01)
		event.set_camera_sequence_look_at(-28.92, 35.2, 133.4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -8.28, -7.06, 120.98)
		event.add_object_sequence_path_point(1, -5.01, -7.06, 90.55)
		event.add_object_sequence_path_point(1, -2.73, 3.81, 72.64)
		event.add_object_sequence_path_point(1, -1.59, 3.81, 44.63)
		event.start_object_sequence_path(1, 1)
		at = 66
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		at = 67
		wait_frames(30)
		event.set_object_sequence_motion(1, "覗きこみ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 68
		wait_objects(1)
		event.rotate_object_sequence(1, 0.0, -1.98, 0.0, 10)
		at = 69
		wait_objects(1)
		event.set_object_sequence_motion(1, "歩き")
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -1.59, 3.81, 44.63)
		event.add_object_sequence_path_point(1, -55.75, 3.81, 20.86)
		event.start_object_sequence_path(1)
		at = 70
		wait_objects(1)
		event.rotate_object_sequence(1, 0.0, 3.12, 0.0, 10)
		at = 71
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		at = 72
		wait_frames(30)
		event.set_object_sequence_motion(1, "触れる", 2)
		event.queue_object_sequence_next_motion(1, "触れるL", 4)
		at = 73
		wait_objects(1)
		event.play_sound_effect(var6, 4)
		event.set_object_handle_frame_visible(10, "", 1)
		at = 74
		wait_frames(30)
		event.set_object_sequence_position(0, 5.82, -7.06, 132.65)
		event.set_camera_sequence_position(-74.97, 23.62, 244.3)
		event.set_camera_sequence_look_at(-15.01, 35.2, 88.03)
		event.set_object_sequence_motion(1, "ユリス見", 2)
		event.queue_object_sequence_next_motion(1, "ユリス見L", 4)
		at = 75
		wait_objects(1)
		at = 76
		wait_frames(30)
		event.set_object_sequence_motion(0, "歩き")
		event.rotate_object_sequence(0, 0.0, 2.77, 0.0, 10)
		at = 77
		wait_objects(0)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 120)
		event.add_object_sequence_path_point(0, 5.82, -7.06, 132.65)
		event.add_object_sequence_path_point(0, 22.37, -7.06, 90.22)
		event.add_object_sequence_path_point(0, 28.16, 3.81, 76.4)
		event.add_object_sequence_path_point(0, 55.75, 3.81, 20.86)
		event.start_object_sequence_path(0)
		at = 78
		wait_objects(0)
		event.rotate_object_sequence(0, 0.0, 3.12, 0.0, 10)
		at = 79
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		at = 80
		wait_frames(30)
		event.set_object_sequence_motion(0, "柱をさわる", 6)
		event.queue_object_sequence_next_motion(0, "柱をさわるL", 4)
		at = 81
		wait_objects(0)
		event.set_object_handle_frame_visible(11, "", 1)
		event.play_sound_effect(var6, 4)
		at = 82
		wait_frames(30)
		event.set_camera_sequence_position(-254.77, 157.73, -140.36)
		event.set_camera_sequence_look_at(17.9, 3.44, 114.28)
		event.set_object_sequence_motion(1, "触れるL", 4)
		event.set_object_sequence_position(2, -30.16, -7.06, 211.83)
		event.set_object_sequence_rotation(2, 0.0, 3.12, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		at = 83
		wait_frames(30)
		var27 = 0
		event.set_object_sequence_motion(0, "びっくり", 6)
		event.queue_object_sequence_next_motion(0, "びっくりL", 4)
		event.play_sound_effect(var6, 5)
		while var27 < 300 do
			do
				local out1, out2, out3 = event.get_character_position(global1)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var13 = event.get_vector_length(var21, var22, var23) or var13
			var14 = event.get_arc_tangent(var21, var23) or var14
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			event.set_character_position(global1, var18, var19, var20)
			event.offset_character_rotation(global1, 0.0, 0.020933334, 0.0)
			do
				local out1, out2, out3 = event.get_character_position(global0)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var13 = event.get_vector_length(var21, var22, var23) or var13
			var14 = event.get_arc_tangent(var21, var23) or var14
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			event.set_character_position(global0, var18, var19, var20)
			event.offset_character_rotation(global0, 0.0, 0.020933334, 0.0)
			do
				local out1, out2, out3 = event.get_object_handle_position(8)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = event.get_object_handle_rotation(8)
				rot_x = out1 or rot_x
				rot_y = out2 or rot_y
				rot_z = out3 or rot_z
			end
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var13 = event.get_vector_length(var21, var22, var23) or var13
			var14 = event.get_arc_tangent(var21, var23) or var14
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			event.set_object_handle_position(8, var18, var19 - vm.f32(0.15166667), var20)
			event.set_object_handle_rotation(8, rot_x, rot_y + vm.f32(0.020933334), rot_z)
			do
				local out1, out2, out3 = event.get_object_handle_position(9)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = event.get_object_handle_rotation(9)
				rot_x = out1 or rot_x
				rot_y = out2 or rot_y
				rot_z = out3 or rot_z
			end
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var13 = event.get_vector_length(var21, var22, var23) or var13
			var14 = event.get_arc_tangent(var21, var23) or var14
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			event.set_object_handle_position(9, var18, var19 - vm.f32(0.15166667), var20)
			event.set_object_handle_rotation(9, rot_x, rot_y + vm.f32(0.020933334), rot_z)
			do
				local out1, out2, out3 = event.get_object_handle_position(7)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = event.get_object_handle_rotation(7)
				rot_x = out1 or rot_x
				rot_y = out2 or rot_y
				rot_z = out3 or rot_z
			end
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var13 = event.get_vector_length(var21, var22, var23) or var13
			var14 = event.get_arc_tangent(var21, var23) or var14
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			event.set_object_handle_position(7, var18, var19 + vm.f32(0.23666666), var20)
			event.set_object_handle_rotation(7, rot_x, rot_y + vm.f32(0.020933334), rot_z)
			do
				local out1, out2, out3 = event.get_object_handle_position(14)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = event.get_object_handle_rotation(14)
				rot_x = out1 or rot_x
				rot_y = out2 or rot_y
				rot_z = out3 or rot_z
			end
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var13 = event.get_vector_length(var21, var22, var23) or var13
			var14 = event.get_arc_tangent(var21, var23) or var14
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			event.set_object_handle_position(14, var18, var19, var20)
			event.set_object_handle_rotation(14, rot_x, rot_y + vm.f32(0.020933334), rot_z)
			var27 = var27 + 1
			at = 84
			vm.wait(84)
		end
		at = 85
		wait_frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_rotation(1, 0.0, 1.27, 0.0)
		event.set_camera_sequence_position(0.0, 38.4, 184.95)
		event.set_camera_sequence_look_at(0.0, 47.52, 19.95)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		at = 86
		helper_4116e6bb(6160400)
		event.set_object_sequence_motion(1, "歩き")
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -55.82, 3.81, 20.68)
		event.add_object_sequence_path_point(1, -13.49, 3.81, 33.82)
		event.start_object_sequence_path(1)
		at = 87
		wait_objects(1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_position(1, 0.14, 3.81, 53.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.attach_character_to_frame(global1, "item", 42)
		event.set_character_active(1, 42)
		event.set_object_sequence_position(11, 5.51, 34.53, 53.38)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(0.8, 51.44, 69.42)
		event.set_camera_sequence_look_at(2.22, 23.76, 49.14)
		event.pause_music()
		event.set_character_active(1, 43)
		event.set_object_sequence_motion(11, "発動", 6)
		event.play_sound_effect(var6, 6)
		event.play_sound_effect(var7, 0)
		event.set_object_sequence_motion(1, "ゲット", 4)
		at = 88
		helper_f38eabca(362, 1)
		at = 89
		wait_frames(30)
		event.play_music(0)
		event.set_character_active(0, 42)
		event.set_character_active(0, 43)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_camera_sequence_position(-96.59, 8.53, 249.67)
		event.set_camera_sequence_look_at(33.2, 23.76, 157.73)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -14.5, -7.06, 117.32)
		event.add_object_sequence_path_point(1, -12.84, -7.06, 160.19)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 90)
		event.add_object_sequence_path_point(0, 14.5, -7.06, 117.32)
		event.add_object_sequence_path_point(0, 12.84, -7.06, 160.19)
		event.start_object_sequence_path(0)
		at = 90
		wait_objects(0)
		at = 91
		wait_objects(1)
		event.turn_object_sequence_toward(0, -2.0, -7.06, 210.36, 10)
		event.turn_object_sequence_toward(1, -2.0, -7.06, 210.36, 10)
		at = 92
		wait_objects(0)
		at = 93
		wait_objects(1)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		at = 94
		wait_frames(20)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 95
		helper_4116e6bb(6160410)
		at = 96
		helper_4116e6bb(6160415)
		event.set_object_sequence_motion(0, "上向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 97
		helper_4116e6bb(6160420)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-0.69, 31.06, 181.32)
		event.set_camera_sequence_look_at(-2.0, 30.17, 210.36)
		event.set_mouth_texture_animations(6, "口パク")
		at = 98
		helper_4116e6bb(6160430)
		event.set_character_motion(40, "消える", 6, -1, 1)
		event.set_character_visible(41, 0, 1, 0.05)
		event.play_sound_effect(var6, 7)
		at = 99
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 5 then
			helper_1ef0d4b2()
			helper_22c00000()
			var11 = 0
		end
		if at <= 6 then
			pos_x = vm.f32(pos_x + vm.f32(vm.f32(-790.0 - pos_x) / 24.0))
			pos_y = vm.f32(pos_y + vm.f32(vm.f32(-254.5 - pos_y) / 16.0))
			pos_z = vm.f32(pos_z + vm.f32(vm.f32(vm.f32(3348.1) - pos_z) / 16.0))
			local _ = var11 < 90
			var11 = var11 + 1
			var12 = 2.0
			var11 = 0
			pos_y = vm.f32(pos_y + var12)
			pos_y = vm.f32(pos_y - var12)
			var12 = vm.f32(var12 - vm.f32(var12 / 30.0))
			local _ = var11 < 30
			local _ = vm.imod(var11, 2) == 0
			var11 = var11 + 1
		end
		if at <= 7 then
			helper_238b5abc(4)
		end
		if at <= 8 then
			helper_344d6cd8()
		end
		if at <= 9 then
			wait_frames_skipping(60)
		end
		if at <= 10 then
			helper_52aadc70(6160130, -1)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		if at <= 12 then
			helper_52aadc70(6160140, -1)
		end
		if at <= 13 then
			helper_52aadc70(6160150, -1)
		end
		if at <= 14 then
			wait_frames_skipping(30)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_238b5abc(1)
		end
		if at <= 17 then
			helper_238b5abc(2)
		end
		if at <= 18 then
			helper_8cd371d7(6160160)
		end
		if at <= 19 then
			wait_frames_skipping(60)
		end
		if at <= 20 then
			helper_238b5abc(2)
		end
		if at <= 21 then
			wait_frames_skipping(30)
		end
		if at <= 22 then
			helper_8cd371d7(6160170)
		end
		if at <= 23 then
			helper_8cd371d7(6160180)
		end
		if at <= 24 then
			helper_344d6cd8()
		end
		if at <= 25 then
			helper_8cd371d7(6160190)
		end
		if at <= 26 then
			wait_frames_skipping(15)
		end
		if at <= 27 then
			helper_8cd371d7(6160200)
		end
		if at <= 28 then
			helper_8cd371d7(6160210)
		end
		if at <= 29 then
			helper_8cd371d7(6160220)
		end
		if at <= 30 then
			helper_344d6cd8()
		end
		if at <= 31 then
			helper_8cd371d7(6160230)
		end
		if at <= 32 then
			helper_8cd371d7(6160240)
		end
		if at <= 33 then
			wait_frames_skipping(15)
		end
		if at <= 34 then
			helper_52aadc70(6160250, -1)
		end
		if at <= 35 then
			helper_52aadc70(6160255, -1)
		end
		if at <= 36 then
			helper_52aadc70(6160260, -1)
		end
		if at <= 37 then
			helper_52aadc70(6160270, -1)
		end
		if at <= 38 then
			helper_52aadc70(6160275, -1)
		end
		if at <= 39 then
			helper_52aadc70(6160280, -1)
		end
		if at <= 40 then
			helper_8cd371d7(6160290)
		end
		if at <= 41 then
			wait_frames_skipping(30)
		end
		if at <= 42 then
			helper_8cd371d7(6160300)
		end
		if at <= 43 then
			helper_8cd371d7(6160305)
		end
		if at <= 45 then
			wait_frames_skipping(30)
		end
		if at <= 46 then
			helper_8cd371d7(6160310)
		end
		if at <= 47 then
			wait_frames_skipping(30)
		end
		if at <= 48 then
			helper_8cd371d7(6160320)
		end
		if at <= 49 then
			helper_8cd371d7(6160330)
		end
		if at <= 50 then
			helper_344d6cd8()
		end
		if at <= 51 then
			wait_frames_skipping(30)
		end
		if at <= 52 then
			helper_8cd371d7(6160340)
		end
		if at <= 53 then
			helper_8cd371d7(6160350)
		end
		if at <= 54 then
			helper_344d6cd8()
		end
		if at <= 55 then
			wait_frames_skipping(30)
		end
		if at <= 56 then
			helper_8cd371d7(6160360)
		end
		if at <= 57 then
			wait_frames_skipping(30)
		end
		if at <= 58 then
			helper_8cd371d7(6160370)
		end
		if at <= 59 then
			helper_8cd371d7(6160373)
		end
		if at <= 60 then
			helper_8cd371d7(6160377)
		end
		if at <= 61 then
			wait_frames_skipping(60)
		end
		if at <= 62 then
			helper_8cd371d7(6160380)
		end
		if at <= 63 then
			wait_frames_skipping(30)
		end
		if at <= 64 then
			helper_238b5abc(1)
		end
		if at <= 65 then
			helper_238b5abc(1)
		end
		if at <= 66 then
			wait_frames_skipping(30)
		end
		if at <= 67 then
			helper_238b5abc(1)
		end
		if at <= 68 then
			helper_238b5abc(1)
		end
		if at <= 69 then
			helper_238b5abc(1)
		end
		if at <= 70 then
			helper_238b5abc(1)
		end
		if at <= 71 then
			wait_frames_skipping(30)
		end
		if at <= 72 then
			helper_238b5abc(1)
		end
		if at <= 73 then
			wait_frames_skipping(30)
		end
		if at <= 74 then
			helper_238b5abc(1)
		end
		if at <= 75 then
			wait_frames_skipping(30)
		end
		if at <= 76 then
			helper_238b5abc(0)
		end
		if at <= 77 then
			helper_238b5abc(0)
		end
		if at <= 78 then
			helper_238b5abc(0)
		end
		if at <= 79 then
			wait_frames_skipping(30)
		end
		if at <= 80 then
			helper_238b5abc(0)
		end
		if at <= 81 then
			wait_frames_skipping(30)
		end
		if at <= 82 then
			wait_frames_skipping(30)
		end
		if at <= 83 then
			var27 = 0
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			var15 = 0.0
			var17 = 0.0
			var21 = vm.f32(var18 - var15)
			var23 = vm.f32(var20 - var17)
			var28 = vm.f32(var15 + vm.f32(var13 * vm.sin(vm.f32(var14 + vm.f32(0.020933334)))))
			var29 = vm.f32(var17 + vm.f32(var13 * vm.cos(vm.f32(var14 + vm.f32(0.020933334)))))
			var18 = var28
			var20 = var29
			local _ = var27 < 300
			var27 = var27 + 1
		end
		if at <= 84 then
			wait_frames_skipping(30)
		end
		if at <= 85 then
			helper_8cd371d7(6160400)
		end
		if at <= 86 then
			helper_238b5abc(1)
		end
		if at <= 87 then
			helper_7d730ff7(362, 1)
		end
		if at <= 88 then
			wait_frames_skipping(30)
		end
		if at <= 89 then
			helper_238b5abc(0)
		end
		if at <= 90 then
			helper_238b5abc(1)
		end
		if at <= 91 then
			helper_238b5abc(0)
		end
		if at <= 92 then
			helper_238b5abc(1)
		end
		if at <= 93 then
			wait_frames_skipping(20)
		end
		if at <= 94 then
			helper_8cd371d7(6160410)
		end
		if at <= 95 then
			helper_8cd371d7(6160415)
		end
		if at <= 96 then
			helper_8cd371d7(6160420)
		end
		if at <= 97 then
			helper_8cd371d7(6160430)
		end
		if at <= 98 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 100
	vm.entry(100)
	event.cancel_drama_scene_skip()
	event.fade_out_music(30)
	event.fade_out_screen(30)
	at = 101
	wait_frames(35)
	event.stop_music(0)
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.skip_next_music_load()
	helper_2a63c()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_397dc(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local item: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	if arg0 == 365 then
		var2 = 1
	end
	if arg0 == 367 then
		var2 = 2
	end
	if arg0 == 366 then
		var2 = 4
	end
	if arg0 == 368 then
		var2 = 8
	end
	var1 = event.get_save_counter(16) or var1
	if vm.i32(bit32.band(var1, var2)) ~= 0 then
		if arg0 == 365 then
			event.open_message_window_2(0, "La Gemma della Terra splende")
		end
		if arg0 == 367 then
			event.open_message_window_2(0, "La Gemma del Vento splende")
		end
		if arg0 == 366 then
			event.open_message_window_2(0, "La Gemma dell’Acqua splende.")
		end
		if arg0 == 368 then
			event.open_message_window_2(0, "La Gemma del Fuoco splende.")
		end
		show_message(0, -1, 8, 0, 0)
		return
	end
	var3 = event.get_triggered_event_data_2(6) or var3
	if var3 == 1 then
		if arg0 == 365 then
			event.open_message_window_2(0, "C'[UNI00e8] un Altare Gemma di Terra.\n(Premi (#) per accedere al Menu)")
		end
		if arg0 == 367 then
			event.open_message_window_2(0, "C'[UNI00e8] un Altare Gemma del Vento.\n(Premi (#) per accedere al Menu)")
		end
		if arg0 == 366 then
			event.open_message_window_2(0, "C'[UNI00e8] un Altare Gemma dell'Acqua.\n(Premi (#) per accedere al Menu)")
		end
		if arg0 == 368 then
			event.open_message_window_2(0, "C'[UNI00e8] un Altare Gemma del Fuoco.\n(Premi (#) per accedere al Menu)")
		end
		var5 = helper_c292fa16(0, -1, 5, 256, 208, var5)
		if var5 == 1 then
			var3 = 2
		end
	end
	if var3 == 2 then
		event.open_use_item_menu(arg0)
		vm.wait(3)
		item = vmhost.used_item() or item
		if item > 0 then
			if item == arg0 then
				var1 = vm.i32(bit32.bor(var1, var2))
				event.set_save_counter(16, var1)
				event.start_background_file_loads_1("snd2/sp/sp_033.sound.json")
				vm.wait(4)
				helper_479dc9e9()
				var6 = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or var6
				event.play_sound_effect(var6, 2)
				if arg0 == 365 then
					event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_10-m0")
				end
				if arg0 == 367 then
					event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_09-m1")
				end
				if arg0 == 366 then
					event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_08-m0")
				end
				if arg0 == 368 then
					event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_07-m0")
				end
				event.set_object_handle_visible(0, 1)
				var7 = 15
				if vm.i32(bit32.band(var1, var7)) == var7 then
					helper_cc3637c1()
				end
			else
				helper_5fb66cb1()
			end
		end
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	event.initialize_event()
	event_99()
	print("start_event--------------------------------------------\n")
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		helper_b4453d02()
		helper_9dafbc83(-40.0, vm.f32(-268.4), 3160.0, vm.f32(3.14))
		event.reset_follow_camera(1, 0.0, 10.0)
		event.fade_in_screen(30)
	else
		helper_9dafbc83(0.0, vm.f32(-268.4), 3000.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		old_map_no = event.get_previous_map() or old_map_no
		var2 = event.get_map_type(old_map_no) or var2
		if var2 ~= -1 then
			var3 = event.get_save_counter(1) or var3
			if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 6 then
				helper_b4453d02()
				helper_c4692af0()
			else
				helper_02a8d032()
				helper_b4453d02()
			end
		end
		event.set_character_motion(0, "立ち")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_3a998()
		at = 2
		helper_2d158()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_2d158()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_9e146e8b()
		if var0 ~= 1 then
			return
		end
		event.set_save_counter(1, 6)
		var1 = event.get_triggered_event_data_2(3) or var1
		if var1 <= 1 then
			at = 2
			helper_f4ec8310()
			event.stop_music(0)
			at = 3
			vm.wait(3)
			event.jump_to_map_2(-1, "s37")
			at = 4
			vm.wait(4)
		else
			at = 5
			helper_fdad3d3b()
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
		if at <= 5 then
			if at <= 4 then
				helper_c99744f1()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	event.add_inventory_item(362, 1)
	helper_2d158()
	event.jump_to_map_3(-1, "s37", 530)
	vm.wait(2)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	event_99()
	helper_b4453d02()
	helper_9dafbc83(170.0, vm.f32(-268.4), 3140.0, vm.f32(3.14))
	event.reset_follow_camera(1, 0.0, 0.0)
	event.fade_in_screen(30)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_ce5f1c27()
	event.jump_to_map_3(-1, "s12", 500)
	vm.wait(2)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_397dc(365)
end

--- Event 552, which map data, a script or the engine runs by number.
function script.event_552()
	helper_397dc(367)
end

--- Event 554, which map data, a script or the engine runs by number.
function script.event_554()
	helper_397dc(366)
end

--- Event 556, which map data, a script or the engine runs by number.
function script.event_556()
	helper_397dc(368)
end

--- Event 599, which map data, a script or the engine runs by number.
function script.event_599()
	event_99()
	helper_b4453d02()
	helper_9dafbc83(170.0, vm.f32(-268.4), 3140.0, vm.f32(3.14))
	event.reset_follow_camera(1, 0.0, 0.0)
	helper_a87eb945(0)
	event.fade_in_screen(30)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	if var0 == 301 then
		flag = event.get_save_flag(640) or flag
		flag_2 = event.get_save_flag(648) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			if helper_3a998() ~= 0 then
				event.fade_out_screen(30)
				wait_frames(30)
				event.jump_to_map_3(-1, "s37", 520)
				vm.wait(3)
			end
			return
		end
		helper_98e2328c()
	end
end

return script
