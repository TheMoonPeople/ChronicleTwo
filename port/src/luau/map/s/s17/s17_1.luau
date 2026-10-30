--!strict
-- map/s/s17/s17_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1a7fd8eb = require("@lib/event/helper_1a7fd8eb")
local helper_1e55e9a8 = require("@lib/event/helper_1e55e9a8")
local helper_22d6eddc = require("@lib/event/helper_22d6eddc")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_250612f7 = require("@lib/event/helper_250612f7")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_39ab7f1f = require("@lib/event/helper_39ab7f1f")
local helper_39af59c5 = require("@lib/event/helper_39af59c5")
local helper_3a9fbd88 = require("@lib/event/helper_3a9fbd88")
local helper_3d6e13c5 = require("@lib/event/helper_3d6e13c5")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_42079db3 = require("@lib/event/helper_42079db3")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_47b9f5b8 = require("@lib/event/helper_47b9f5b8")
local helper_4b10efff = require("@lib/event/helper_4b10efff")
local helper_4e5d2821 = require("@lib/event/helper_4e5d2821")
local helper_5ac4b36d = require("@lib/event/helper_5ac4b36d")
local helper_6673bb50 = require("@lib/event/helper_6673bb50")
local helper_6813499c = require("@lib/event/helper_6813499c")
local helper_69d65e1a = require("@lib/event/helper_69d65e1a")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_779b62a3 = require("@lib/event/helper_779b62a3")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_ad04d185 = require("@lib/event/helper_ad04d185")
local helper_adcd807d = require("@lib/event/helper_adcd807d")
local helper_b1b0c1a6 = require("@lib/event/helper_b1b0c1a6")
local helper_b55f37c0 = require("@lib/event/helper_b55f37c0")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_bd088cc0 = require("@lib/event/helper_bd088cc0")
local helper_c2ca38b7 = require("@lib/event/helper_c2ca38b7")
local helper_cc4413ca = require("@lib/event/helper_cc4413ca")
local helper_cd17820b = require("@lib/event/helper_cd17820b")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_d8e14c06 = require("@lib/event/helper_d8e14c06")
local helper_d96b1c01 = require("@lib/event/helper_d96b1c01")
local helper_dbb2323a = require("@lib/event/helper_dbb2323a")
local helper_dcf91359 = require("@lib/event/helper_dcf91359")
local helper_dfa8c909 = require("@lib/event/helper_dfa8c909")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e787350a = require("@lib/event/helper_e787350a")
local helper_e7afa9ca = require("@lib/event/helper_e7afa9ca")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f29372c9 = require("@lib/event/helper_f29372c9")
local open_message = require("@lib/event/open_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
local function default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(300) or flag
		flag_2 = event.get_save_flag(320) or flag_2
		flag_3 = event.get_save_flag(317) or flag_3
		if flag == 1 then
			if flag_2 == 1 then
				if flag_3 == 0 then
					at = 1
					helper_adcd807d()
					event.clear_local_event_counters()
					event.set_dungeon_pause_flags(8192, 1)
					event.set_character_change_unmasked(0, 1)
					event.set_character_change_unmasked(2, 0)
					event.set_character_change_unmasked(1, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_save_control_bits(1, 1)
				else
					at = 2
					helper_6673bb50()
					event.set_function_point_enabled("", "exit", 1)
					event.set_function_point_enabled("", "talk", 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-a0_1")
					event.set_object_handle_visible(0, 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-c0_1")
					event.set_object_handle_visible(0, 0)
					event.set_function_point_enabled("p01_s17", "invent_30001-0", 0)
					event.set_function_point_enabled("", "branch", 0)
					return
				end
			else
				helper_d96b1c01()
				at = 4
				helper_69d65e1a()
				return
			end
		else
			event.initialize_event()
			event.set_character_position(0, 0.0, 62.57, 1305.0)
			event.set_character_rotation(0, 0.0, 3.14, 0.0)
			event.set_camera_position(-0.16, 110.89, 1405.0)
			event.set_camera_look_at(0.0, 92.57, 1305.0)
			event.reset_follow_camera(0)
			event.fade_in_screen(30)
			event.finish_event()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_6673bb50()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "exit", 1)
					event.set_function_point_enabled("", "talk", 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-a0_1")
					event.set_object_handle_visible(0, 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-c0_1")
					event.set_object_handle_visible(0, 0)
					event.set_function_point_enabled("p01_s17", "invent_30001-0", 0)
					event.set_function_point_enabled("", "branch", 0)
					return
				end)
			end
			return 0
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_2f708()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local var6: any = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(314, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		var0 = event.load_sound_effect_file_2(3809) or var0
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		if active_chr_no == 0 then
		else
		end
		event.change_directory("event/e300/e314/")
		event.unlock_memory_stack(4)
		event.load_message_file(0, 4, "e314_1.txt")
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e314_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		block = event.load_event_image_4(5, "e314_1.json", 1) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e31401", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e31402", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(3, 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e31403", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 1)
		event.attach_object_handle_to_sprite(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e314/e314_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/e300/e314/e314_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(13)
		event.set_character_active(14)
		event.set_object_handle_position(0, 10.0, 40.79, 1150.0)
		event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -10.0, 40.79, 1150.0)
		event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag ~= 0 then
			event.enable_drama_skip()
		end
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 62.86, 1089.96)
		event.set_camera_sequence_look_at(0.0, 52.74, 1185.03)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 2
		helper_4116e6bb(3140010)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -10.0, 40.79, 1200.0, 40, 1)
		event.rotate_object_sequence(1, 0.0, 0.0, 0.0, 10)
		at = 3
		wait_frames(10)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 10.0, 40.79, 1180.0, 30, 1)
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 10)
		event.fade_out_screen(30)
		at = 4
		wait_frames(30)
		at = 5
		wait_objects(0)
		while true do
			event.fade_in_screen(30)
			event.set_message_window_mode(0, 7)
			event.set_object_sequence_motion(1, "歩き")
			event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
			event.reset_object_sequence_dynamic_animation(1)
			event.set_object_sequence_motion(0, "立ち", 4)
			event.set_character_active(0, 0)
			at = 6
			helper_b55f37c0(var0)
			at = 7
			vm.wait(7)
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "Yes\nNo")
			open_message(0, -1, 5, 0, 0)
			at = 8
			var6 = helper_39af59c5(0, 2, 0, 1)
			event.set_message_bubble_screen_slot(0, 0)
			if var6 == 1 then
				at = 9
				vm.wait(9)
				break
			else
				event.fade_out_screen(30)
				at = 10
				wait_frames(30)
			end
		end
		event.set_message_window_mode(0, 7)
		event.set_object_sequence_motion(1, "がっつ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, var0, 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 11
		helper_4116e6bb(3140160)
		event.fade_out_screen(30)
		at = 12
		wait_frames(30)
	end, function(received: { any }): boolean
		if at == 8 then
			var6 = received[1] :: number
		end
		if at <= 1 then
			helper_8cd371d7(3140010)
		end
		if at <= 2 then
			wait_frames_skipping(10)
		end
		if at <= 3 then
			wait_frames_skipping(30)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_4b10efff(var0)
		end
		if at <= 7 then
			helper_f018b3c0(0, -1, 5, 0, 0)
			var6 = helper_d793ae41(0, 2, 0, 1)
		end
		if at <= 9 then
			wait_frames_skipping(30)
		end
		if at <= 10 then
			helper_8cd371d7(3140160)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 13
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.delete_event_image(1)
	event.load_message_file(0, -1)
	event.set_sphida_playing(1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_character_active(0)
	event.set_character_position(0, -25.0, 62.7, 1285.3)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_character_active(13)
	event.set_character_position(13, 68.04, 41.85, 1180.61)
	event.set_character_rotation(13, 0.0, 3.14, 0.0)
	event.set_character_motion(13, "立ち", 4)
	event.update_character_motion(13)
	event.reset_character_cloth_and_hair(13)
	event.set_camera_look_at(-25.0, 92.7, 1285.3)
	event.set_camera_position(-25.0, 102.7, 1385.3)
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Helper function.
local function helper_44068()
	event.initialize_event()
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		'"Taking a Shot"\n1) Aim with the left analog stick\n2) Press (O) to begin swing\n3) Press (O) again to set power level\n4) Press (O) again to hit the Sphere'
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		'"The Impact Zone"\nShown as a red bar under power gauge.\nStrike sphere when in middle of\nImpact Zone for a strong hit.'
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "Hitting while outside Impact Zone\nwill cause the sphere to go flying\nin the wrong direction.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		'"Changing Point of Impact"\nBy holding the left analog stick in a\ncertain direction at the time of impact,\nyou can change where you hit the Sphere.<page>Doing this changes the following:'
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Top - Topspins so spins easier.\nBtm - Backspins so stops easier.\nLft - Slices and curves to right.\nRt - Hooks and curves to left."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"If the Sphere ends up landing in\na place you can't get to,\npress (#) to move the Sphere to you."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Spheda has been added to the Help\n   section of the Main Menu.")
	helper_75684dd8(0, -1, 8, 0, 0)
end

--- Helper function.
local function helper_2da78()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "See if there's some kind of stick\nhandy. Then I'll show you how to hit\nthe Sphere.")
	helper_bd088cc0(13, -1)
	event.finish_event()
end

--- Helper function.
local function helper_31c78()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var11: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var15: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		var0 = 13
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_footstep_sound(0, 1)
		event.attach_object_handle_to_character(1, var0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_footstep_sound(1, 1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			var8 = out2 or var8
		end
		do
			local out1, out2, out3 = event.get_character_position(var0)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local _, out2, _ = event.get_character_rotation(var0)
			var11 = out2 or var11
		end
		yaw = event.get_direction_angle(var1, var2, var3, var4, var5, var6) or yaw
		yaw_2 = event.get_direction_angle(var4, var5, var6, var1, var2, var3) or yaw_2
		var15 = event.compare_angles(var8, yaw, 0.1) or var15
		if var15 ~= 0 then
			event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
		end
		event.set_object_sequence_motion(0, "立ち")
		var15 = event.compare_angles(var11, yaw_2, 0.1) or var15
		if var15 ~= 0 then
			event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		at = 1
		wait_frames(20)
		event.set_mouth_motions(1, "会話", 0, "立ち", 0)
		event.open_message_window_2(0, "What?\nYou're quitting?")
		at = 2
		helper_0ffc2526(0, -1, var0, 0, 0)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Yes\nNo")
		open_message(0, -1, 5, 0, 0)
		at = 3
		var15 = helper_39af59c5(0, 2, 1, 0)
		event.set_message_bubble_screen_slot(0, 0)
		event.set_message_bubble_tail(0, 1)
		if var15 == 0 then
			event.fade_out_screen(30)
			at = 4
			wait_frames(30)
			return 1
		else
			event.open_message_window_2(0, "Yeah.\nGood luck, Max!")
			at = 5
			helper_0ffc2526(0, -1, var0, 0, 0)
		end
		var15 = event.compare_angles(var11, yaw_2, 0.1) or var15
		if var15 ~= 0 then
			event.rotate_object_sequence(1, 0.0, var11, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		at = 6
		wait_objects(1)
		return 0
	end, function(received: { any })
		if at <= 4 then
			if at == 3 then
				var15 = received[1] :: number
			end
			if at <= 1 then
				helper_249b75d1(0, -1, var0, 0, 0)
			end
			if at <= 2 then
				helper_f018b3c0(0, -1, 5, 0, 0)
				var15 = helper_d793ae41(0, 2, 1, 0)
			end
			if at <= 3 then
				local _ = var15 ~= 0
				local _ = var15 ~= 0
				wait_frames_skipping(30)
			end
			return 1
		end
		if at <= 6 then
			if at <= 5 then
				helper_238b5abc(1)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_186f0()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 then
			event.set_message_window_mode(0, 4)
			at = 1
			helper_75684dd8(0, 2000, 8, 0, 0)
			return 1
		end
		var1 = event.get_equipped_item(0, 0) or var1
		if var1 ~= 9 and var1 ~= 10 and var1 ~= 11 and var1 ~= 12 and var1 ~= 13 and var1 ~= 14 then
			event.set_message_window_mode(0, 4)
			event.open_message_window_2(0, "Equip the Handy Stick.")
			at = 2
			helper_75684dd8(0, -1, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(var1)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_1af2c()
	local tex_bank: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local level: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var29: s32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: s32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var51: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local yaw: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		if helper_186f0() ~= 0 then
			event.finish_event()
			return 0
		end
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.start_background_file_loads_4(
			"dungeon/sphida/c01_golf.gltf",
			"dungeon/chara/c01b_miss.gltf",
			"dungeon/sphida/gool_end.gltf",
			"dungeon/sphida/mizu_eff.gltf"
		)
		at = 2
		vm.wait(2)
		at = 3
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
		event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
		tex_bank = event.get_sphida_texture_bank() or tex_bank
		event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
		event.set_character_active(0, 12)
		var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or var1
		event.create_sword_afterimage(5, 64, 16)
		event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
		event.initialize_effect_manager(5, 1)
		event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_character(0, 1)
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_character(0, 2)
		event.set_object_handle_visible(0, 0)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.start_crossfade(15)
		event.reset_sphida_power_gauge()
		do
			local out1, out2, out3 = event.get_sphida_ball_position()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var2, var3, var4, var6 = helper_cc4413ca(var2, var3, var4, var6)
		helper_1a7fd8eb(var6)
		event.set_sphida_status_panel_visible(1)
		var11 = 12.5
		event.set_sphida_carry_angle(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
		var12, var13, level = helper_39ab7f1f(var12, var13, level)
		event.set_sphida_power_gauge_safe_level(level)
		do
			local out1, out2, out3 = event.zero_vector()
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		while true do
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			at = 4
			local t0: s32
			t0, var6, var11 = helper_47b9f5b8(var6, var11, tex_bank)
			if t0 ~= 0 then
				event.set_sphida_minimap_scroll_enabled(0)
				event.set_sphida_minimap_shot_line_visible(0)
				event.set_sphida_ball_position(pos_x, pos_y, pos_z)
				event.set_character_position(8, pos_x, pos_y, pos_z)
				event.set_character_position(9, pos_x, pos_y, pos_z)
				at = 5
				return helper_dbb2323a(0)
			end
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			at = 6
			local t1: s32
			t1, var12, var6, var16, var15, level = helper_b1b0c1a6(var12, tex_bank, var6, var16, var15, var1, level)
			if t1 == 0 then
				break
			else
				at = 7
				vm.wait(7)
			end
		end
		do
			local out1, out2, out3 = event.copy_vector(var2, var3, var4)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		var21 = 0
		if level ~= 1 and level ~= -1 and level ~= 4 then
			event.set_event_sprite_type(0, 1)
			event.set_event_sprite_draw_pass(0, 1)
			event.set_event_sprite_size(0, 10.8, 11.6)
			event.set_event_sprite_position(0, var2, var3 + 30.0, var4)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			if level == 0 then
				event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
			end
			if level == 2 or level == -2 then
				event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
			end
			if level == 3 or level == -3 then
				event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
			end
			event.attach_object_handle_to_sprite(18, 0)
			event.clear_object_sequence(18)
			event.set_object_sequence_object(18, 18)
			event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
			event.delay_object_sequence_color_track(18, 20)
			event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
			at = 8
			wait_frames(10)
		end
		if var12 <= vm.f32(0.3) then
			event.set_character_motion(0, "小ショット", 2)
			at = 9
			wait_frames(25)
			if level ~= 4 then
				event.play_sound_effect(var1, 3)
			end
		elseif var12 <= vm.f32(0.6) then
			event.set_character_motion(0, "中ショット", 2)
			at = 10
			wait_frames(34)
			event.play_sound_effect(var1, 2)
		else
			event.set_character_motion(0, "大ショット", 2)
			at = 11
			wait_frames(39)
			if level == 0 then
				event.play_sound_effect(var1, 12)
			else
				event.play_sound_effect(var1, 1)
			end
		end
		if level == 4 then
			at = 12
			wait_frames(50)
			helper_c2ca38b7(var1)
			event.set_sphida_ball_position(pos_x, pos_y, pos_z)
			event.set_character_position(8, pos_x, pos_y, pos_z)
			event.set_character_position(9, pos_x, pos_y, pos_z)
			at = 13
			return helper_dbb2323a(0)
		end
		if level == 0 then
			event.set_event_sprite_type(1, 0)
			event.set_event_sprite_draw_pass(1, 1)
			event.set_event_sprite_position(1, 256, 278)
			event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
			event.set_event_sprite_size(1, 266, 42)
			event.set_event_sprite_color(1, 128, 128, 128, 0)
			event.set_event_sprite_scale(1, 10, 10, 10)
			event.attach_object_handle_to_sprite(19, 1)
			event.clear_object_sequence(19)
			event.set_object_sequence_object(19, 19)
			event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
			event.set_object_sequence_scale(19, 1, 1, 1, 18)
			event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
			event.delay_object_sequence_color_track(19, 30)
			event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
		end
		var12 = helper_dff48a5c(var12)
		var11 = vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
		var12 = vm.f32(var12 - vm.f32(var12 * var11))
		var22 = vm.f32(vm.sin(var6) * vm.f32(var12 * vm.cos(var11)))
		var23 = vm.f32(var12 * vm.sin(var11))
		var24 = vm.f32(vm.cos(var6) * vm.f32(var12 * vm.cos(var11)))
		var16 = vm.f32(vm.f32(var16 * vm.f32(3.1415927)) / 2.0)
		var17 = vm.f32(vm.f32(vm.f32(-var24 * var13) * var15) * vm.f32(0.4))
		var15 = vm.f32(vm.f32(vm.f32(-var22 * var13) * var15) * vm.f32(0.4))
		do
			local out1, out2, out3 = event.get_sphida_pin_position()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		var29 = 0
		level = 0
		var42 = 0
		var46 = 0
		while true do
			if var3 >= 180.0 then
				var22 = vm.f32(var22 * vm.f32(0.999))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0098) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.999))
			else
				var41 = event.get_segment_collision_9(
					12,
					var2,
					var3,
					var4,
					var2,
					vm.f32(var3 - 3.0) - vm.f32(0.01),
					var4,
					0
				) or var41
				if level == 1 and var41 >= 0 then
					var22 = vm.f32(var22 * vm.f32(0.94))
					var23 = vm.f32(var23 + vm.f32(vm.f32(-0.00045) * (var46 + 1)))
					var24 = vm.f32(var24 * vm.f32(0.94))
					var22 = vm.f32(var22 + var15)
					var24 = vm.f32(var24 + var17)
					var15 = vm.f32(var15 * vm.f32(0.8))
					var17 = vm.f32(var17 * vm.f32(0.8))
				else
					var22 = vm.f32(var22 * vm.f32(0.999))
					var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0045) * (var46 + 1)))
					var24 = vm.f32(var24 * vm.f32(0.999))
				end
			end
			do
				local out1, out2, out3 = event.add_vectors(var2, var3, var4, var22, var23, var24)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			if var16 ~= 0.0 then
				var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
				var11 = vm.f32(var11 + var16)
				var11 = event.wrap_angle(var11) or var11
				var22 = vm.f32(var22 + vm.f32(vm.f32(vm.sin(var11) / 10.0) * var13))
				var24 = vm.f32(var24 + vm.f32(vm.f32(vm.cos(var11) / 10.0) * var13))
			end
			var40 = event.get_vector_length(var15, 0.0, var17) or var40
			if var40 > vm.f32(0.01) then
				var25 = event.get_vector_length(var15, 0.0, var17) or var25
				var11 = event.get_direction_angle(var18, var19, var20, var18 + var15, var19, var20 + var17) or var11
				do
					local out1, out2, out3 = event.get_character_rotation(8)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				event.set_character_rotation(8, var5, var11, var7)
				event.offset_character_rotation(8, var25 * 12.0, 0.0, 0.0)
				event.set_character_rotation(9, var5, var11, var7)
				event.offset_character_rotation(9, var25 * 12.0, 0.0, 0.0)
			else
				var25 = event.get_vector_length(var22, 0.0, var24) or var25
				var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
				do
					local out1, out2, out3 = event.get_character_rotation(8)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				event.set_character_rotation(8, var5, var11, var7)
				event.offset_character_rotation(8, var25 / 10.0, 0.0, 0.0)
				event.set_character_rotation(9, var5, var11, var7)
				event.offset_character_rotation(9, var25 / 10.0, 0.0, 0.0)
			end
			var25 = event.get_vector_length(var22, var23, var24) or var25
			var39 = var25
			var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
			var36 = vm.f32(vm.sin(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
			var38 = vm.f32(vm.cos(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
			event.add_sword_afterimage_point(
				var2 - var36,
				var3,
				var4 - var38,
				vm.f32(var2 + var36) + var36,
				var3,
				vm.f32(var4 + var38) + var38
			)
			do
				local out1, out2, out3 = event.copy_vector(var22, var23, var24)
				var36 = out1 or var36
				var37 = out2 or var37
				var38 = out3 or var38
			end
			do
				local out1, out2, out3 = event.normalize_vector(var36, var37, var38)
				var36 = out1 or var36
				var37 = out2 or var37
				var38 = out3 or var38
			end
			do
				local out1, out2, out3 = event.scale_vector(var36, var37, var38, 3.0)
				var36 = out1 or var36
				var37 = out2 or var37
				var38 = out3 or var38
			end
			do
				local out1, out2, out3, out4, out5 =
					event.get_segment_collision_13(0, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 0)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
				var41 = out4 or var41
				var43 = out5 or var43
			end
			if var41 >= 0 and (var43 == 1 or var43 == 7) then
				event.create_effect("足水パシャ")
				event.set_effect_first_vector(var30, var31, var32)
				if var42 <= 0 then
					event.play_sound_effect(var1, 11)
					var42 = 20
				end
			end
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					event.get_segment_collision_15(12, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 1)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
				var33 = out4 or var33
				var34 = out5 or var34
				var35 = out6 or var35
				var41 = out7 or var41
			end
			if var41 < 0 then
				if var3 >= 400.0 and var23 > 0.0 then
					do
						local out1, out2, out3 = event.copy_vector(var2, var3, var4)
						var30 = out1 or var30
						var31 = out2 or var31
						var32 = out3 or var32
					end
					do
						local out1, out2, out3 = event.copy_vector(var22, -var23, var24)
						var33 = out1 or var33
						var34 = out2 or var34
						var35 = out3 or var35
					end
					do
						local out1, out2, out3 = event.normalize_vector(var33, var34, var35)
						var33 = out1 or var33
						var34 = out2 or var34
						var35 = out3 or var35
					end
					var41 = 1
				end
			end
			while var41 >= 0 do
				var16 = 0.0
				if var25 > 8.0 then
					helper_79d90c82()
				end
				if var42 <= 0 then
					event.play_sound_effect(var1, 6)
					var42 = 10
				end
				do
					local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				do
					local out1, out2, out3 = event.normalize_vector(var22, var23, var24)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				do
					local out1, out2, out3 = event.scale_vector(var22, var23, var24, 3.0)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				do
					local out1, out2, out3 = event.add_vectors(var30, var31, var32, var22, var23, var24)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
				end
				do
					local out1, out2, out3 = event.subtract_vectors(var18, var19, var20, var30, var31, var32)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				var40 = event.get_vector_length(var18, var19, var20) or var40
				var40 = vm.f32(var39 - var40)
				if var40 <= 0.0 then
					break
				else
					var39 = var40
					do
						local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
						var22 = out1 or var22
						var23 = out2 or var23
						var24 = out3 or var24
					end
					if var23 < 0.0 and var34 > 0.0 then
						var22 = vm.f32(var15 * 2.0)
						var23 = 0.0
						var24 = vm.f32(var17 * 2.0)
						var15 = vm.f32(var15 * vm.f32(0.2))
						var17 = vm.f32(var17 * vm.f32(0.2))
					else
						if
							var22 < 0.0 and var33 > 0.0
							or var22 > 0.0 and var33 < 0.0
							or var24 < 0.0 and var35 > 0.0
							or var24 > 0.0 and var35 < 0.0
						then
							var15 = 0.0
							var17 = 0.0
						end
						var22 = 0.0
						var23 = 0.0
						var24 = 0.0
					end
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.9)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.58)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.9)) + var24)
					do
						local out1, out2, out3 = event.copy_vector(var30, var31, var32)
						var18 = out1 or var18
						var19 = out2 or var19
						var20 = out3 or var20
					end
					do
						local out1, out2, out3 = event.copy_vector(var22, var23, var24)
						var36 = out1 or var36
						var37 = out2 or var37
						var38 = out3 or var38
					end
					do
						local out1, out2, out3 = event.normalize_vector(var36, var37, var38)
						var36 = out1 or var36
						var37 = out2 or var37
						var38 = out3 or var38
					end
					do
						local out1, out2, out3 = event.scale_vector(var36, var37, var38, 3.0)
						var36 = out1 or var36
						var37 = out2 or var37
						var38 = out3 or var38
					end
					do
						local out1, out2, out3 = event.scale_vector(var33, var34, var35, var40)
						var33 = out1 or var33
						var34 = out2 or var34
						var35 = out3 or var35
					end
					do
						local out1, out2, out3 = event.copy_vector(var30, var31, var32)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3 = event.add_vectors(var2, var3, var4, var33, var34, var35)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
							12,
							var18,
							var19,
							var20,
							var2 + var36,
							var3 + var37,
							var4 + var38,
							1
						)
						var30 = out1 or var30
						var31 = out2 or var31
						var32 = out3 or var32
						var33 = out4 or var33
						var34 = out5 or var34
						var35 = out6 or var35
						var41 = out7 or var41
					end
				end
			end
			do
				local out1, out2, out3, out4, out5, out6, out7, out8 =
					event.get_segment_collision_16(12, var2, var3, var4, var2, var3 - 3.0, var4, 1)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
				var33 = out4 or var33
				var34 = out5 or var34
				var35 = out6 or var35
				var41 = out7 or var41
				var43 = out8 or var43
			end
			if var41 >= 0 then
				var16 = 0.0
				var3 = vm.f32(var31 + 3.0)
				var40 = event.get_vector_length(var22, 0.0, var24) or var40
				if var40 < vm.f32(2.4) or var23 >= -1.0 and var23 <= 0.0 then
					var23 = 0.0
					level = 1
				else
					var22 = vm.f32(var22 * vm.f32(0.9))
					var23 = -vm.f32(var23 * vm.f32(0.58))
					var24 = vm.f32(var24 * vm.f32(0.9))
					var22 = vm.f32(var22 + vm.f32(var15 * 2.0))
					var24 = vm.f32(var24 + vm.f32(var17 * 2.0))
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
					if var25 > 8.0 then
						helper_79d90c82()
					end
					if var42 <= 0 then
						event.play_sound_effect(var1, 5)
						var42 = 10
					end
				end
				var40 = event.get_vector_length(var15, 0.0, var17) or var40
				if var23 == 0.0 and var25 < vm.f32(1.6) and var40 < vm.f32(0.4) then
					if not (var43 == 6) then
						break
					end
					var29 = 1
					break
				end
			end
			if var3 < -500.0 then
				var29 = 1
				break
			elseif var46 >= 300 then
				var29 = 1
				break
			else
				var44 = event.get_sphida_pin_color() or var44
				var45 = event.get_sphida_ball_color() or var45
				x = vm.f32(pos_x_2 - var2)
				y = vm.f32(pos_y_2 - var3)
				z = vm.f32(pos_z_2 - var4)
				var47 = event.get_vector_length(x, y, z) or var47
				if var45 ~= var44 then
					var51 = event.get_point_to_segment_distance(var18, var19, var20, var2, var3, var4, pos_x_2, pos_y_2, pos_z_2)
						or var51
					if var51 >= 0.0 and var51 <= 30.0 then
						var21 = 1
						break
					end
					if var47 ~= 0.0 then
						if var47 <= 120.0 then
							do
								local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), var47))
								x = out1 or x
								y = out2 or y
								z = out3 or z
							end
							do
								local out1, out2, out3 = event.add_vectors(var2, var3, var4, x, y, z)
								var2 = out1 or var2
								var3 = out2 or var3
								var4 = out3 or var4
							end
							do
								local out1, out2, out3 = event.add_vectors(var22, var23, var24, x, y, z)
								var22 = out1 or var22
								var23 = out2 or var23
								var24 = out3 or var24
							end
						end
					else
						var21 = 1
						break
					end
				elseif var47 ~= 0.0 then
					if var47 <= 60.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, var47))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.subtract_vectors(var2, var3, var4, x, y, z)
							var2 = out1 or var2
							var3 = out2 or var3
							var4 = out3 or var4
						end
						do
							local out1, out2, out3 = event.subtract_vectors(var22, var23, var24, x, y, z)
							var22 = out1 or var22
							var23 = out2 or var23
							var24 = out3 or var24
						end
					end
				end
				event.set_character_position(8, var2, var3, var4)
				event.set_character_position(9, var2, var3, var4)
				do
					local out1, out2, out3 = event.copy_vector(var2, var3, var4)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				if var3 <= -70.0 then
					event.set_follow_camera_following(0)
					if var29 >= 30 then
						if var29 >= 50 then
							break
						end
					else
						event.set_camera_look_at(var2, var3, var4)
					end
					var29 = var29 + 1
				elseif var46 >= 20 then
					event.set_camera_control_range(20.0, 30.0, 60.0, 200.0)
					event.set_camera_speed(8.0)
					event.set_follow_camera_offset(0.0, 0.0, 0.0)
					event.set_follow_camera_target(
						vm.f32(var2 + var22) + var22,
						vm.f32(var3 + var23) + var23,
						vm.f32(var4 + var24) + var24
					)
					do
						local out1, out2, out3 = event.get_camera_position()
						pos_x_3 = out1 or pos_x_3
						pos_y_3 = out2 or pos_y_3
						pos_z_3 = out3 or pos_z_3
					end
					yaw = event.get_direction_angle(
						vm.f32(var2 + var22) + var22,
						vm.f32(var3 + var23) + var23,
						vm.f32(var4 + var24) + var24,
						pos_x_3,
						pos_y_3,
						pos_z_3
					) or yaw
					event.set_camera_control_rotation(yaw)
					event.move_camera_control_with_pad(8)
					event.step_camera_control()
				end
				event.set_sphida_ball_position(var2, var3, var4)
				at = 14
				vm.wait(14)
				if var42 > 0 then
					var42 = var42 - 1
				end
				if var12 > 0.0 then
					var12 = vm.f32(var12 - 1.0)
				end
				var46 = var46 + 1
			end
		end
		event.set_character_position(8, var2, var3, var4)
		event.set_character_position(9, var2, var3, var4)
		at = 15
		vm.wait(15)
		event.set_sphida_status_panel_visible(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var29 == 0 then
			event.set_sphida_ball_position(var2, var3, var4)
			if var21 == 1 then
				event.set_character_active(0, 0)
				event.set_character_active(0, 8)
				event.set_character_active(0, 9)
				event.set_character_active(1, 12)
				event.set_character_position(12, pos_x_2, pos_y_2, pos_z_2)
				event.set_character_motion(12, "発動", 6)
				event.play_sound_effect(var1, 17)
				var46 = 0
				while var46 < 2 do
					event.set_camera_control_enabled(0)
					event.set_follow_camera_following(1)
					event.set_follow_camera_target_alternate(pos_x_2, pos_y_2, pos_z_2)
					event.set_camera_speed(12.0)
					event.set_follow_camera_offset(0.0, 0.0, 0.0)
					event.set_follow_camera_height(0.0)
					event.set_follow_camera_distance(100.0)
					event.step_follow_camera(1)
					var46 = var46 + 1
					at = 16
					vm.wait(16)
				end
				event.set_character_active(0, 10)
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				var46 = 0
				while var46 < 100 do
					event.set_camera_control_enabled(0)
					event.set_follow_camera_following(1)
					event.set_follow_camera_target_alternate(pos_x_2, pos_y_2, pos_z_2)
					event.set_camera_speed(12.0)
					event.set_follow_camera_offset(0.0, 0.0, 0.0)
					event.set_follow_camera_height(0.0)
					event.set_follow_camera_distance(100.0)
					event.step_follow_camera(1)
					var46 = var46 + 1
					at = 17
					vm.wait(17)
				end
				event.set_character_active(0, 11)
				var44 = event.get_dungeon_stage_id() or var44
				var45 = event.get_dungeon_floor() or var45
				var41 = event.get_dungeon_floor_info(var44, var45, 4) or var41
				do
					local out1, out2 = event.get_sphida_prize(var41)
					var42 = out1 or var42
					var43 = out2 or var43
				end
				var41 = vm.i32(var41 + 1)
				event.set_dungeon_floor_info(var44, var45, 4, var41)
				at = 18
				wait_frames(54)
				at = 19
				wait_frames(30)
				event.delete_character(8)
				event.delete_character(9)
				event.delete_character(10)
				event.delete_character(11)
				event.set_sphida_playing(0)
				event.fade_out_screen(30)
				at = 20
				wait_frames(30)
				event.play_music(0)
				event.release_camera_sequence_follow_object()
				event.set_event_sprite_draw_pass(0, 0)
			end
		else
			event.play_sound_effect(var1, 18)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "だめだめ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "立ち", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
			event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
			event.set_event_sprite_position(0, 256, -25)
			event.set_event_sprite_size(0, 160, 50)
			event.set_event_sprite_color(0, 128, 128, 128, 128)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
			event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
			event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
			at = 21
			wait_objects(0)
			at = 22
			wait_frames(20)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_sphida_ball_position(pos_x, pos_y, pos_z)
			event.set_character_position(8, pos_x, pos_y, pos_z)
			event.set_character_position(9, pos_x, pos_y, pos_z)
			event.release_camera_sequence_follow_object()
		end
		if var21 == 1 then
			helper_c2ca38b7(-1)
		else
			helper_c2ca38b7(var1)
		end
		at = 23
		return helper_dbb2323a(var21)
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				local _ = received[1] :: number
				local _ = received[1] :: number
			end
			return 0
		end
		if at <= 5 then
			if at == 4 then
				local _ = received[1] :: number
				var6 = received[2] :: number
				var11 = received[3] :: number
			end
			if at <= 2 then
				helper_344d6cd8()
			end
			if at <= 3 then
				var2, var3, var4, var6 = helper_250612f7(var2, var3, var4, var6)
				helper_6813499c(var6)
				var11 = 12.5
				var12, var13, level = helper_22d6eddc(var12, var13, level)
				do
					local _: any
					_, var6, var11 = helper_f29372c9(var6, var11, tex_bank)
				end
			end
			return helper_dfa8c909(0)
		end
		if at <= 13 then
			if at == 6 then
				local _ = received[1] :: number
				var12 = received[2] :: number
				var6 = received[3] :: number
				var16 = received[4] :: number
				var15 = received[5] :: number
				level = received[6] :: number
			end
			if at <= 7 then
				var21 = 0
				wait_frames_skipping(10)
			end
			if at <= 8 then
				wait_frames_skipping(25)
			end
			if at <= 9 then
				wait_frames_skipping(34)
			end
			if at <= 10 then
				wait_frames_skipping(39)
			end
			if at <= 11 then
				wait_frames_skipping(50)
			end
			if at <= 12 then
				helper_1e55e9a8(var1)
			end
			return helper_dfa8c909(0)
		end
		if at <= 23 then
			if at <= 14 then
				local _ = var42 > 0
				var42 = var42 - 1
				local _ = var12 > 0.0
				var12 = vm.f32(var12 - 1.0)
				local _ = var46 >= 300
				local _ = var46 >= 20
				var46 = var46 + 1
			end
			if at <= 15 then
				var46 = 0
				local _ = var46 < 2
				var46 = var46 + 1
			end
			if at <= 16 then
				var46 = 0
				local _ = var46 < 100
				var46 = var46 + 1
			end
			if at <= 17 then
				local _ = var41 >= 0
				local _ = var41 >= 0
				var41 = var41 + 1
				wait_frames_skipping(54)
			end
			if at <= 18 then
				wait_frames_skipping(30)
			end
			if at <= 19 then
				wait_frames_skipping(30)
			end
			if at <= 20 then
				helper_238b5abc(0)
			end
			if at <= 21 then
				wait_frames_skipping(20)
			end
			if at <= 22 then
				helper_1e55e9a8(-1)
				helper_1e55e9a8(var1)
			end
			return helper_dfa8c909(var21)
		end
		return nil
	end)
end

--- Helper function.
local function helper_32acc()
	local var0: s32 = 0
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		var0 = event.load_sound_effect_file_2(3809) or var0
		event.set_character_active(0, 0)
		event.load_character_motion_pack(5, "dungeon/chara/c02a_miss.gltf", "info", 13)
		event.load_character_motion_pack(5, "event/e300/e315/e315_monica.gltf", "info", 13)
		event.attach_object_handle_to_character(1, 13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(67.57, 63.38, 1149.74)
		event.set_camera_sequence_look_at(67.85, 63.66, 1179.99)
		event.fade_in_screen(30)
		at = 1
		wait_frames(30)
		event.play_sound_effect(var0, 5)
		event.set_object_sequence_motion(1, "だめだめ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_voice_stream_wave(1, 3140170)
		at = 2
		helper_9cbdc640(1)
		event.open_message_window_2(0, "Aw, that's too bad.\nWanna try again?")
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 3
		helper_5ac4b36d(0)
		close_message(0)
		event.close_voice_stream(1)
		event.set_message_bubble_screen_slot(0, 0)
		event.reset_mouth_texture_animations()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Yes\nNo")
		open_message(0, -1, 5, 0, 0)
		at = 4
		var1 = helper_39af59c5(0, 2, 0, 1)
		event.set_message_bubble_screen_slot(0, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if var1 == 0 then
			event.delete_character_extension_packs(13)
			event.set_character_active(1, 0)
			return 1
		else
			event.set_object_sequence_motion(1, "貸しなさい", 2)
			event.queue_object_sequence_next_motion(1, "貸しなさいＬ", 4)
			event.set_mouth_texture_animations(1, "通常口パク")
			event.open_voice_stream_wave(1, 3150010)
			at = 5
			helper_9cbdc640(1)
			event.open_message_window_2(0, "You stink, Max.\nLet me do it.")
			open_message(0, -1, 8, 0, 0)
			event.play_voice_stream(1)
			at = 6
			helper_5ac4b36d(0)
			close_message(0)
			event.close_voice_stream(1)
			event.set_message_bubble_screen_slot(0, 0)
			event.reset_mouth_texture_animations()
			at = 7
			wait_objects(1)
			event.fade_out_screen(30)
			at = 8
			wait_frames(30)
			event.set_character_active(1, 0)
			event.delete_character_extension_packs(13)
			return 0
		end
	end, function(received: { any })
		if at <= 4 then
			if at == 4 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_238b5abc(1)
			end
			if at <= 2 then
				helper_f018b3c0(0, -1, 8, 0, 0)
				helper_42079db3(0)
			end
			if at <= 3 then
				helper_d16eef1e(0)
				helper_f018b3c0(0, -1, 5, 0, 0)
				var1 = helper_d793ae41(0, 2, 0, 1)
			end
			return 1
		end
		if at <= 8 then
			if at <= 5 then
				helper_f018b3c0(0, -1, 8, 0, 0)
				helper_42079db3(0)
			end
			if at <= 6 then
				helper_d16eef1e(0)
				helper_238b5abc(1)
			end
			if at <= 7 then
				wait_frames_skipping(30)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

script.default_event = default_event

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_2f708

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local flag: s32 = 0
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(314) or flag
		if flag == 0 then
			argc = event.get_owned_item_count(9) or argc
			if argc >= 1 then
				event.set_character_motion(0, "立ち")
				event.fade_out_screen(30)
				at = 1
				wait_frames(30)
				at = 2
				helper_2f708()
				event.fade_in_screen(30)
				at = 3
				wait_frames(30)
				at = 4
				helper_44068()
			else
				at = 5
				helper_2da78()
			end
		elseif (function()
			at = 6
			return helper_31c78()
		end)() ~= 0 then
			at = 7
			helper_779b62a3()
			event.add_inventory_item(10)
			event.add_inventory_item(363)
			at = 8
			helper_dcf91359(10)
			at = 9
			helper_69d65e1a()
			return
		end
		at = 10
		vm.wait(10)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 9 then
			if at == 6 then
				local _ = received[1] :: number
			end
			if at <= 1 then
				at = 2
				helper_2f708()
				return vm.continue_with(function()
					event.fade_in_screen(30)
					at = 3
					wait_frames(30)
					at = 4
					helper_44068()
					at = 10
					vm.wait(10)
					event.finish_event()
					return
				end)
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			if at <= 3 then
				helper_d8e14c06()
			end
			if at <= 4 then
				helper_ad04d185()
			end
			if at <= 5 then
				local _ = helper_3d6e13c5()
			end
			if at <= 6 then
				at = 7
				helper_779b62a3()
				return vm.continue_with(function()
					event.add_inventory_item(10)
					event.add_inventory_item(363)
					at = 8
					helper_dcf91359(10)
					at = 9
					helper_69d65e1a()
					return
				end)
			end
			if at <= 7 then
				at = 8
				helper_dcf91359(10)
				return vm.continue_with(function()
					at = 9
					helper_69d65e1a()
					return
				end)
			end
			if at <= 8 then
				helper_cd17820b()
			end
			return 0
		end
		if at <= 10 then
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	event.initialize_event()
	vm.wait(1)
	event.set_character_motion(0, "立ち")
	event.set_function_point_enabled("", "branch", 0)
	event.add_inventory_item(9)
	helper_e787350a(9, 1)
	event.set_character_active(0, 15)
	helper_a87eb945(1)
	event.finish_event()
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local active_chr_no: s32 = 0
	local var1: any = 0
	event.initialize_event()
	vm.wait(1)
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 20, 5, 256, 208)
		else
			helper_75684dd8(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	var1 = helper_bac0e30d(0, 10, 8, 256, 208, 2, 1)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	if var1 == 0 then
		event.fade_out_screen(30)
		wait_frames(30)
		helper_69d65e1a()
		return
	end
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- The Sphida event run when the player stands at the ball and presses the action button.
function script.sphida_shot()
	local var0: s32 = 0
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_1af2c()
		if var0 == 1 then
			at = 2
			helper_4e5d2821()
			event.add_inventory_item(11)
			event.add_inventory_item(363)
			at = 3
			helper_dcf91359(11)
			at = 4
			helper_69d65e1a()
			return
		end
		if var0 == 2 then
			argc = event.get_local_event_counter(0) or argc
			argc = vm.i32(argc + 1)
			event.set_local_event_counter(0, argc)
			if argc >= 10 then
				at = 5
				helper_3a9fbd88()
				event.add_inventory_item(10)
				event.add_inventory_item(363)
				at = 6
				helper_dcf91359(10)
				at = 7
				helper_69d65e1a()
				return
			elseif (function()
				at = 8
				return helper_32acc()
			end)() == 0 then
				at = 9
				helper_e7afa9ca()
				event.add_inventory_item(10)
				event.add_inventory_item(363)
				at = 10
				helper_dcf91359(10)
				at = 11
				helper_69d65e1a()
				return
			else
				event.set_character_active(0)
				event.set_character_position(0, -25.0, 62.7, 1285.3)
				event.set_character_rotation(0, 0.0, 3.14, 0.0)
				event.set_character_motion(0, "立ち", 4)
				event.update_character_motion(0)
				event.reset_character_cloth_and_hair(0)
				event.set_sphida_playing(1)
				event.set_sphida_par(3)
				event.set_sphida_ball_position(0.0, 65.57, 1305.04)
				event.set_sphida_ball_color(0)
				event.set_sphida_last_challenge(0)
				event.set_character_position(8, 0.0, 65.57, 1305.04)
				event.set_character_active(0, 8)
				event.set_character_position(9, 0.0, 65.57, 1305.04)
				event.set_character_active(1, 9)
				event.set_camera_look_at(-25.0, 92.7, 1285.3)
				event.set_camera_position(-25.0, 102.7, 1385.3)
				event.reset_follow_camera(0)
				event.finish_event()
			end
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				at = 2
				helper_4e5d2821()
				return vm.continue_with(function()
					event.add_inventory_item(11)
					event.add_inventory_item(363)
					at = 3
					helper_dcf91359(11)
					at = 4
					helper_69d65e1a()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_dcf91359(11)
				return vm.continue_with(function()
					at = 4
					helper_69d65e1a()
					return
				end)
			end
			if at <= 3 then
				helper_cd17820b()
			end
			return 0
		end
		if at <= 7 then
			if at <= 5 then
				at = 6
				helper_dcf91359(10)
				return vm.continue_with(function()
					at = 7
					helper_69d65e1a()
					return
				end)
			end
			if at <= 6 then
				helper_cd17820b()
			end
			return 0
		end
		if at <= 11 then
			if at <= 8 then
				at = 9
				helper_e7afa9ca()
				return vm.continue_with(function()
					event.add_inventory_item(10)
					event.add_inventory_item(363)
					at = 10
					helper_dcf91359(10)
					at = 11
					helper_69d65e1a()
					return
				end)
			end
			if at <= 9 then
				at = 10
				helper_dcf91359(10)
				return vm.continue_with(function()
					at = 11
					helper_69d65e1a()
					return
				end)
			end
			if at <= 10 then
				helper_cd17820b()
			end
			return 0
		end
		return nil
	end)
end

--- The Sphida event run when the menu button is pressed near the ball.
function script.sphida_near_ball()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local debug_flag: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	var0 = helper_bac0e30d(0, 2004, 8, 256, 208, 2, 0)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 0 then
			helper_c2ca38b7(-1)
		end
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- The Sphida event run when the menu button is pressed near the ball with fewer than two shots of par left.
function script.sphida_near_ball_last()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "This is the last time you'll be\nable to move the Sphere to you.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Move the Sphere to you?")
	var0 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		event.set_sphida_last_challenge(1)
		event.start_crossfade(15)
	end
	vm.wait(3)
	event.finish_event()
end

--- Event 13080, which map data, a script or the engine runs by number.
function script.event_13080()
	event_99()
	event.set_save_flag(300, 1)
	event.set_save_flag(320, 0)
	default_event()
end

--- Event 13120, which map data, a script or the engine runs by number.
function script.event_13120()
	event_99()
	event.set_save_flag(300, 1)
	event.set_save_flag(320, 1)
	event.set_save_flag(312, 0)
	event.set_save_flag(314, 0)
	event.set_save_flag(315, 0)
	event.set_save_flag(316, 0)
	event.set_save_flag(317, 0)
	default_event()
end

--- Event 13170, which map data, a script or the engine runs by number.
function script.event_13170()
	event_99()
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "chara/c02_base.gltf", "info", 13)
	event.load_equipment_model(4, 1, 4, "info", 13)
	event.load_equipment_model(4, 1, 3, "info", 13)
	event.load_equipment_model(4, 1, 2, "info", 13, 14)
	helper_dcf91359(10)
end

return script
