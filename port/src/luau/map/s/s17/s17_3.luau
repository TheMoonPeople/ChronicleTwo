--!strict
--- Event script for Barga's Valley, covering the Sphida minigame, its lesson and retry dialogue, and the prize cutscenes.

local vm = require("@lib/vm")
local bargas_valley = require("@lib/event/bargas_valley")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

--- Does nothing when the map is initialised.
local function init_map() end

--- Plays the Sphida introduction or a landing cutscene on entry depending on the story flags, or places the player at the start when the story has not reached the valley.
local function default_event()
	local flag_300: s32 = 0
	local flag_320: s32 = 0
	local flag_317: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		flag_300 = event.get_save_flag(300) or flag_300
		flag_320 = event.get_save_flag(320) or flag_320
		flag_317 = event.get_save_flag(317) or flag_317
		if flag_300 == 1 then
			if flag_320 == 1 then
				if flag_317 == 0 then
					resume_step = 1
					bargas_valley.play_sphida_intro_cutscene()
					event.clear_local_event_counters()
					event.set_dungeon_pause_flags(8192, 1)
					event.set_character_change_unmasked(0, 1)
					event.set_character_change_unmasked(2, 0)
					event.set_character_change_unmasked(1, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_save_control_bits(1, 1)
				else
					resume_step = 2
					bargas_valley.play_dungeon_landing_cutscene()
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
				bargas_valley.play_landing_cutscene()
				resume_step = 4
				bargas_valley.enter_next_floor_in_d03()
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
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				bargas_valley.play_dungeon_landing_cutscene()
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
		if resume_step <= 4 then
			return 0
		end
		return nil
	end)
end

--- Plays the e314 cutscene in which the partner offers a Sphida lesson until the player accepts, then places both characters for practice.
local function play_sphida_lesson_offer()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local answer: any = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.set_save_flag(314, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		sound_bank = event.load_sound_effect_file_2(3809) or sound_bank
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		if active_character == 0 then
		else
		end
		event.change_directory("event/e300/e314/")
		event.unlock_memory_stack(4)
		event.load_message_file(0, 4, "e314_1.txt")
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if active_character == 0 then
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
		if active_character == 1 then
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
		resume_step = 2
		message.show_voiced(3140010)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -10.0, 40.79, 1200.0, 40, 1)
		event.rotate_object_sequence(1, 0.0, 0.0, 0.0, 10)
		resume_step = 3
		wait.frames(10)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 10.0, 40.79, 1180.0, 30, 1)
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 10)
		event.fade_out_screen(30)
		resume_step = 4
		wait.frames(30)
		resume_step = 5
		object.wait_until_done(0)
		while true do
			event.fade_in_screen(30)
			event.set_message_window_mode(0, 7)
			event.set_object_sequence_motion(1, "歩き")
			event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
			event.reset_object_sequence_dynamic_animation(1)
			event.set_object_sequence_motion(0, "立ち", 4)
			event.set_character_active(0, 0)
			resume_step = 6
			bargas_valley.play_sphida_dialogue(sound_bank)
			resume_step = 7
			vm.wait(7)
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "Ja\nNein")
			message.open(0, -1, 5, 0, 0)
			resume_step = 8
			answer = message.choose_option(0, 2, 0, 1)
			event.set_message_bubble_screen_slot(0, 0)
			if answer == 1 then
				resume_step = 9
				vm.wait(9)
				break
			else
				event.fade_out_screen(30)
				resume_step = 10
				wait.frames(30)
			end
		end
		event.set_message_window_mode(0, 7)
		event.set_object_sequence_motion(1, "がっつ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, sound_bank, 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 11
		message.show_voiced(3140160)
		event.fade_out_screen(30)
		resume_step = 12
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_step == 8 then
			answer = received[1] :: number
		end
		if resume_step <= 1 then
			message.show_voiced_skipping(3140010)
		end
		if resume_step <= 2 then
			wait.frames_skipping(10)
		end
		if resume_step <= 3 then
			wait.frames_skipping(30)
		end
		if resume_step <= 4 then
			cutscene.skip_command(0)
		end
		if resume_step <= 5 then
			bargas_valley.play_e314_dialogue(sound_bank)
		end
		if resume_step <= 7 then
			message.open_skipping(0, -1, 5, 0, 0)
			answer = message.resume_choice(0, 2, 0, 1)
		end
		if resume_step <= 9 then
			wait.frames_skipping(30)
		end
		if resume_step <= 10 then
			message.show_voiced_skipping(3140160)
		end
		if resume_step <= 11 then
			wait.frames_skipping(30)
		end
		return true
	end)
	resume_step = 13
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

--- Shows the Sphida shot, impact zone and point of impact instructions.
local function show_sphida_tutorial()
	event.initialize_event()
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		'"Der Schlag"\n1) Ziele mit dem linken Analog-Stick\n2) Hole aus mit (O)\n3) Bestimme die Schlagkraft\n    mit (O)\n4) Spiele die Kugel mit (O)'
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		'"Die Aufprallzone"\nAls roter Balken unter der\nSchlagkraft-Anzeige dargestellt.\nSpiele die Kugel in der Mitte der<page>Aufprallzone f[UNI00fc]r weite Schl[UNI00e4]ge.'
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Ein Treffer au[UNI00df]erhalb der\nAufprallzone f[UNI00fc]hrt dazu, dass die\nKugel in die falsche Richtung fliegt."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		'"Aufprallpunkt [UNI00e4]ndern"\nIndem du den linken Analog-Stick beim\nAufprall in eine Richtung dr[UNI00fc]ckst,\nbestimmst du, wo du die Kugel<page>triffst.\nDadurch [UNI00e4]nderst du Folgendes:'
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Oben - Topspin, der beschleunigt.\nUnten - Backspin, der verlangsamt.\nLinks - Slice nach rechts.\nRechts - Hook nach links."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Falls die Kugel an einem Ort\nlandet, der unzug[UNI00e4]nglich ist, holst\ndu sie mit (#) zu dir."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, '[(!)]Spheda ist jetzt unter "Hilfe"\n   im Hauptmen[UNI00fc] aufgef[UNI00fc]hrt.')
	message.show_and_wait(0, -1, 8, 0, 0)
end

--- Has the partner tell the player to find a stick before learning to hit the Sphere.
local function say_find_a_stick()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Sieh nach, ob du einen Stock\nhast. Dann zeige ich dir, wie man\ndie Kugel schl[UNI00e4]gt.")
	character.face_each_other_and_talk(13, -1)
	event.finish_event()
end

--- Turns the characters toward each other, asks whether to quit the practice and returns 1 when the player quits.
local function confirm_quit_practice()
	local partner_slot: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local partner_x: f32 = 0
	local partner_y: f32 = 0
	local partner_z: f32 = 0
	local player_yaw: f32 = 0
	local partner_yaw: f32 = 0
	local angle_to_partner: f32 = 0
	local angle_to_player: f32 = 0
	local answer: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		partner_slot = 13
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_footstep_sound(0, 1)
		event.attach_object_handle_to_character(1, partner_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_footstep_sound(1, 1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			player_yaw = out2 or player_yaw
		end
		do
			local out1, out2, out3 = event.get_character_position(partner_slot)
			partner_x = out1 or partner_x
			partner_y = out2 or partner_y
			partner_z = out3 or partner_z
		end
		do
			local _, out2, _ = event.get_character_rotation(partner_slot)
			partner_yaw = out2 or partner_yaw
		end
		angle_to_partner = event.get_direction_angle(player_x, player_y, player_z, partner_x, partner_y, partner_z) or angle_to_partner
		angle_to_player = event.get_direction_angle(partner_x, partner_y, partner_z, player_x, player_y, player_z) or angle_to_player
		answer = event.compare_angles(player_yaw, angle_to_partner, 0.1) or answer
		if answer ~= 0 then
			event.rotate_object_sequence(0, 0.0, angle_to_partner, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
		end
		event.set_object_sequence_motion(0, "立ち")
		answer = event.compare_angles(partner_yaw, angle_to_player, 0.1) or answer
		if answer ~= 0 then
			event.rotate_object_sequence(1, 0.0, angle_to_player, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 1
		wait.frames(20)
		event.set_mouth_motions(1, "会話", 0, "立ち", 0)
		event.open_message_window_2(0, "Wie?\nDu h[UNI00f6]rst auf?")
		resume_step = 2
		message.say_bubble(0, -1, partner_slot, 0, 0)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Ja\nNein")
		message.open(0, -1, 5, 0, 0)
		resume_step = 3
		answer = message.choose_option(0, 2, 1, 0)
		event.set_message_bubble_screen_slot(0, 0)
		event.set_message_bubble_tail(0, 1)
		if answer == 0 then
			event.fade_out_screen(30)
			resume_step = 4
			wait.frames(30)
			return 1
		else
			event.open_message_window_2(0, "Ja.\nViel Gl[UNI00fc]ck, Max!")
			resume_step = 5
			message.say_bubble(0, -1, partner_slot, 0, 0)
		end
		answer = event.compare_angles(partner_yaw, angle_to_player, 0.1) or answer
		if answer ~= 0 then
			event.rotate_object_sequence(1, 0.0, partner_yaw, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 6
		object.wait_until_done(1)
		return 0
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 3 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				message.show_then_close_variant(0, -1, partner_slot, 0, 0)
			end
			if resume_step <= 2 then
				message.open_skipping(0, -1, 5, 0, 0)
				answer = message.resume_choice(0, 2, 1, 0)
			end
			if resume_step <= 3 then
				local _ = answer ~= 0
				local _ = answer ~= 0
				wait.frames_skipping(30)
			end
			return 1
		end
		if resume_step <= 6 then
			if resume_step <= 5 then
				cutscene.skip_command(1)
			end
			return 0
		end
		return nil
	end)
end

--- Returns 1 when the player cannot take a shot because of the wrong character or no handy stick equipped, and otherwise sets the club.
local function is_shot_blocked()
	local active_character: s32 = 0
	local equipped_item: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		active_character = event.get_playable_character() or active_character
		if active_character ~= 0 then
			event.set_message_window_mode(0, 4)
			resume_step = 1
			message.show_and_wait(0, 2000, 8, 0, 0)
			return 1
		end
		equipped_item = event.get_equipped_item(0, 0) or equipped_item
		if equipped_item ~= 9 and equipped_item ~= 10 and equipped_item ~= 11 and equipped_item ~= 12 and equipped_item ~= 13 and equipped_item ~= 14 then
			event.set_message_window_mode(0, 4)
			event.open_message_window_2(0, "Nimm den Schl[UNI00e4]ger.")
			resume_step = 2
			message.show_and_wait(0, -1, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(equipped_item)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if resume_step <= 1 then
			return 1
		end
		if resume_step <= 2 then
			return 1
		end
		return nil
	end)
end

--- Runs one Sphida shot from aiming and the power gauge through the ball flight and its outcome and returns the round result.
local function play_sphida_shot()
	local tex_bank: s32 = 0
	local sound_bank: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local rotation_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local elevation_angle: f32 = 0
	local shot_power: f32 = 0
	local club_spin_factor: f32 = 0
	local level: s32 = 0
	local drift_x: f32 = 0
	local curve_strength: f32 = 0
	local drift_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local hit_pin: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local out_of_play_timer: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local hit_normal_x: f32 = 0
	local hit_normal_y: f32 = 0
	local hit_normal_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local remaining_distance: f32 = 0
	local temp_length: f32 = 0
	local collision_result: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_kind: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local frame_count: s32 = 0
	local pin_distance: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local pin_segment_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_angle: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		resume_step = 1
		if is_shot_blocked() ~= 0 then
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
		resume_step = 2
		vm.wait(2)
		resume_step = 3
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
		event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
		tex_bank = event.get_sphida_texture_bank() or tex_bank
		event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
		event.set_character_active(0, 12)
		sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_bank
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
			start_x = out1 or start_x
			start_y = out2 or start_y
			start_z = out3 or start_z
		end
		ball_x, ball_y, ball_z, aim_angle = bargas_valley.place_ball_and_aim(ball_x, ball_y, ball_z, aim_angle)
		camera.place_behind_player(aim_angle)
		event.set_sphida_status_panel_visible(1)
		elevation_angle = 12.5
		event.set_sphida_carry_angle(vm.f32(elevation_angle * vm.f32(3.1415927)) / 180.0)
		shot_power, club_spin_factor, level = minigame.get_equipped_club_definition(shot_power, club_spin_factor, level)
		event.set_sphida_power_gauge_safe_level(level)
		do
			local out1, out2, out3 = event.zero_vector()
			drift_x = out1 or drift_x
			curve_strength = out2 or curve_strength
			drift_z = out3 or drift_z
		end
		while true do
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			resume_step = 4
			local t0: s32
			t0, aim_angle, elevation_angle = bargas_valley.aim_sphida_shot(aim_angle, elevation_angle, tex_bank)
			if t0 ~= 0 then
				event.set_sphida_minimap_scroll_enabled(0)
				event.set_sphida_minimap_shot_line_visible(0)
				event.set_sphida_ball_position(start_x, start_y, start_z)
				event.set_character_position(8, start_x, start_y, start_z)
				event.set_character_position(9, start_x, start_y, start_z)
				resume_step = 5
				return bargas_valley.finish_round(0)
			end
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			resume_step = 6
			local t1: s32
			t1, shot_power, aim_angle, curve_strength, drift_x, level = minigame.run_sphida_power_gauge(shot_power, tex_bank, aim_angle, curve_strength, drift_x, sound_bank, level)
			if t1 == 0 then
				break
			else
				resume_step = 7
				vm.wait(7)
			end
		end
		do
			local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		hit_pin = 0
		if level ~= 1 and level ~= -1 and level ~= 4 then
			event.set_event_sprite_type(0, 1)
			event.set_event_sprite_draw_pass(0, 1)
			event.set_event_sprite_size(0, 10.8, 11.6)
			event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
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
			resume_step = 8
			wait.frames(10)
		end
		if shot_power <= vm.f32(0.3) then
			event.set_character_motion(0, "小ショット", 2)
			resume_step = 9
			wait.frames(25)
			if level ~= 4 then
				event.play_sound_effect(sound_bank, 3)
			end
		elseif shot_power <= vm.f32(0.6) then
			event.set_character_motion(0, "中ショット", 2)
			resume_step = 10
			wait.frames(34)
			event.play_sound_effect(sound_bank, 2)
		else
			event.set_character_motion(0, "大ショット", 2)
			resume_step = 11
			wait.frames(39)
			if level == 0 then
				event.play_sound_effect(sound_bank, 12)
			else
				event.play_sound_effect(sound_bank, 1)
			end
		end
		if level == 4 then
			resume_step = 12
			wait.frames(50)
			bargas_valley.consume_par_stroke(sound_bank)
			event.set_sphida_ball_position(start_x, start_y, start_z)
			event.set_character_position(8, start_x, start_y, start_z)
			event.set_character_position(9, start_x, start_y, start_z)
			resume_step = 13
			return bargas_valley.finish_round(0)
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
		shot_power = minigame.scale_by_club_power(shot_power)
		elevation_angle = vm.f32(vm.f32(elevation_angle * vm.f32(3.1415927)) / 180.0)
		shot_power = vm.f32(shot_power - vm.f32(shot_power * elevation_angle))
		velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(shot_power * vm.cos(elevation_angle)))
		velocity_y = vm.f32(shot_power * vm.sin(elevation_angle))
		velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(shot_power * vm.cos(elevation_angle)))
		curve_strength = vm.f32(vm.f32(curve_strength * vm.f32(3.1415927)) / 2.0)
		drift_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_spin_factor) * drift_x) * vm.f32(0.4))
		drift_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_spin_factor) * drift_x) * vm.f32(0.4))
		do
			local out1, out2, out3 = event.get_sphida_pin_position()
			pin_x = out1 or pin_x
			pin_y = out2 or pin_y
			pin_z = out3 or pin_z
		end
		out_of_play_timer = 0
		level = 0
		sound_cooldown = 0
		frame_count = 0
		while true do
			if ball_y >= 180.0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (frame_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			else
				collision_result = event.get_segment_collision_9(
					12,
					ball_x,
					ball_y,
					ball_z,
					ball_x,
					vm.f32(ball_y - 3.0) - vm.f32(0.01),
					ball_z,
					0
				) or collision_result
				if level == 1 and collision_result >= 0 then
					velocity_x = vm.f32(velocity_x * vm.f32(0.94))
					velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (frame_count + 1)))
					velocity_z = vm.f32(velocity_z * vm.f32(0.94))
					velocity_x = vm.f32(velocity_x + drift_x)
					velocity_z = vm.f32(velocity_z + drift_z)
					drift_x = vm.f32(drift_x * vm.f32(0.8))
					drift_z = vm.f32(drift_z * vm.f32(0.8))
				else
					velocity_x = vm.f32(velocity_x * vm.f32(0.999))
					velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (frame_count + 1)))
					velocity_z = vm.f32(velocity_z * vm.f32(0.999))
				end
			end
			do
				local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
				ball_x = out1 or ball_x
				ball_y = out2 or ball_y
				ball_z = out3 or ball_z
			end
			if curve_strength ~= 0.0 then
				elevation_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation_angle
				elevation_angle = vm.f32(elevation_angle + curve_strength)
				elevation_angle = event.wrap_angle(elevation_angle) or elevation_angle
				velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(elevation_angle) / 10.0) * club_spin_factor))
				velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(elevation_angle) / 10.0) * club_spin_factor))
			end
			temp_length = event.get_vector_length(drift_x, 0.0, drift_z) or temp_length
			if temp_length > vm.f32(0.01) then
				speed = event.get_vector_length(drift_x, 0.0, drift_z) or speed
				elevation_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + drift_x, previous_y, previous_z + drift_z) or elevation_angle
				do
					local out1, out2, out3 = event.get_character_rotation(8)
					rotation_x = out1 or rotation_x
					aim_angle = out2 or aim_angle
					rotation_z = out3 or rotation_z
				end
				event.set_character_rotation(8, rotation_x, elevation_angle, rotation_z)
				event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
				event.set_character_rotation(9, rotation_x, elevation_angle, rotation_z)
				event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
			else
				speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
				elevation_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation_angle
				do
					local out1, out2, out3 = event.get_character_rotation(8)
					rotation_x = out1 or rotation_x
					aim_angle = out2 or aim_angle
					rotation_z = out3 or rotation_z
				end
				event.set_character_rotation(8, rotation_x, elevation_angle, rotation_z)
				event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
				event.set_character_rotation(9, rotation_x, elevation_angle, rotation_z)
				event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
			end
			speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
			remaining_distance = speed
			elevation_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation_angle
			direction_x = vm.f32(vm.sin(vm.f32(elevation_angle - vm.f32(1.5707964))) * 3.0)
			direction_z = vm.f32(vm.cos(vm.f32(elevation_angle - vm.f32(1.5707964))) * 3.0)
			event.add_sword_afterimage_point(
				ball_x - direction_x,
				ball_y,
				ball_z - direction_z,
				vm.f32(ball_x + direction_x) + direction_x,
				ball_y,
				vm.f32(ball_z + direction_z) + direction_z
			)
			do
				local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			do
				local out1, out2, out3 = event.normalize_vector(direction_x, direction_y, direction_z)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			do
				local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, 3.0)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			do
				local out1, out2, out3, out4, out5 =
					event.get_segment_collision_13(0, previous_x, previous_y, previous_z, ball_x + direction_x, ball_y + direction_y, ball_z + direction_z, 0)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
				collision_result = out4 or collision_result
				surface_kind = out5 or surface_kind
			end
			if collision_result >= 0 and (surface_kind == 1 or surface_kind == 7) then
				event.create_effect("足水パシャ")
				event.set_effect_first_vector(hit_x, hit_y, hit_z)
				if sound_cooldown <= 0 then
					event.play_sound_effect(sound_bank, 11)
					sound_cooldown = 20
				end
			end
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + direction_x, ball_y + direction_y, ball_z + direction_z, 1)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
				hit_normal_x = out4 or hit_normal_x
				hit_normal_y = out5 or hit_normal_y
				hit_normal_z = out6 or hit_normal_z
				collision_result = out7 or collision_result
			end
			if collision_result < 0 then
				if ball_y >= 400.0 and velocity_y > 0.0 then
					do
						local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
					end
					do
						local out1, out2, out3 = event.copy_vector(velocity_x, -velocity_y, velocity_z)
						hit_normal_x = out1 or hit_normal_x
						hit_normal_y = out2 or hit_normal_y
						hit_normal_z = out3 or hit_normal_z
					end
					do
						local out1, out2, out3 = event.normalize_vector(hit_normal_x, hit_normal_y, hit_normal_z)
						hit_normal_x = out1 or hit_normal_x
						hit_normal_y = out2 or hit_normal_y
						hit_normal_z = out3 or hit_normal_z
					end
					collision_result = 1
				end
			end
			while collision_result >= 0 do
				curve_strength = 0.0
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if sound_cooldown <= 0 then
					event.play_sound_effect(sound_bank, 6)
					sound_cooldown = 10
				end
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(velocity_x, velocity_y, velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				do
					local out1, out2, out3 = event.scale_vector(velocity_x, velocity_y, velocity_z, 3.0)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				do
					local out1, out2, out3 = event.add_vectors(hit_x, hit_y, hit_z, velocity_x, velocity_y, velocity_z)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
				end
				do
					local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				temp_length = event.get_vector_length(previous_x, previous_y, previous_z) or temp_length
				temp_length = vm.f32(remaining_distance - temp_length)
				if temp_length <= 0.0 then
					break
				else
					remaining_distance = temp_length
					do
						local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
						velocity_x = out1 or velocity_x
						velocity_y = out2 or velocity_y
						velocity_z = out3 or velocity_z
					end
					if velocity_y < 0.0 and hit_normal_y > 0.0 then
						velocity_x = vm.f32(drift_x * 2.0)
						velocity_y = 0.0
						velocity_z = vm.f32(drift_z * 2.0)
						drift_x = vm.f32(drift_x * vm.f32(0.2))
						drift_z = vm.f32(drift_z * vm.f32(0.2))
					else
						if
							velocity_x < 0.0 and hit_normal_x > 0.0
							or velocity_x > 0.0 and hit_normal_x < 0.0
							or velocity_z < 0.0 and hit_normal_z > 0.0
							or velocity_z > 0.0 and hit_normal_z < 0.0
						then
							drift_x = 0.0
							drift_z = 0.0
						end
						velocity_x = 0.0
						velocity_y = 0.0
						velocity_z = 0.0
					end
					velocity_x = vm.f32(vm.f32(vm.f32(hit_normal_x * speed) * vm.f32(0.9)) + velocity_x)
					velocity_y = vm.f32(vm.f32(vm.f32(hit_normal_y * speed) * vm.f32(0.58)) + velocity_y)
					velocity_z = vm.f32(vm.f32(vm.f32(hit_normal_z * speed) * vm.f32(0.9)) + velocity_z)
					do
						local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
						previous_x = out1 or previous_x
						previous_y = out2 or previous_y
						previous_z = out3 or previous_z
					end
					do
						local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
						direction_x = out1 or direction_x
						direction_y = out2 or direction_y
						direction_z = out3 or direction_z
					end
					do
						local out1, out2, out3 = event.normalize_vector(direction_x, direction_y, direction_z)
						direction_x = out1 or direction_x
						direction_y = out2 or direction_y
						direction_z = out3 or direction_z
					end
					do
						local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, 3.0)
						direction_x = out1 or direction_x
						direction_y = out2 or direction_y
						direction_z = out3 or direction_z
					end
					do
						local out1, out2, out3 = event.scale_vector(hit_normal_x, hit_normal_y, hit_normal_z, temp_length)
						hit_normal_x = out1 or hit_normal_x
						hit_normal_y = out2 or hit_normal_y
						hit_normal_z = out3 or hit_normal_z
					end
					do
						local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, hit_normal_x, hit_normal_y, hit_normal_z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
							12,
							previous_x,
							previous_y,
							previous_z,
							ball_x + direction_x,
							ball_y + direction_y,
							ball_z + direction_z,
							1
						)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						hit_normal_x = out4 or hit_normal_x
						hit_normal_y = out5 or hit_normal_y
						hit_normal_z = out6 or hit_normal_z
						collision_result = out7 or collision_result
					end
				end
			end
			do
				local out1, out2, out3, out4, out5, out6, out7, out8 =
					event.get_segment_collision_16(12, ball_x, ball_y, ball_z, ball_x, ball_y - 3.0, ball_z, 1)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
				hit_normal_x = out4 or hit_normal_x
				hit_normal_y = out5 or hit_normal_y
				hit_normal_z = out6 or hit_normal_z
				collision_result = out7 or collision_result
				surface_kind = out8 or surface_kind
			end
			if collision_result >= 0 then
				curve_strength = 0.0
				ball_y = vm.f32(hit_y + 3.0)
				temp_length = event.get_vector_length(velocity_x, 0.0, velocity_z) or temp_length
				if temp_length < vm.f32(2.4) or velocity_y >= -1.0 and velocity_y <= 0.0 then
					velocity_y = 0.0
					level = 1
				else
					velocity_x = vm.f32(velocity_x * vm.f32(0.9))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
					velocity_z = vm.f32(velocity_z * vm.f32(0.9))
					velocity_x = vm.f32(velocity_x + vm.f32(drift_x * 2.0))
					velocity_z = vm.f32(velocity_z + vm.f32(drift_z * 2.0))
					drift_x = vm.f32(drift_x * vm.f32(0.2))
					drift_z = vm.f32(drift_z * vm.f32(0.2))
					if speed > 8.0 then
						minigame.toggle_sphida_ball_color()
					end
					if sound_cooldown <= 0 then
						event.play_sound_effect(sound_bank, 5)
						sound_cooldown = 10
					end
				end
				temp_length = event.get_vector_length(drift_x, 0.0, drift_z) or temp_length
				if velocity_y == 0.0 and speed < vm.f32(1.6) and temp_length < vm.f32(0.4) then
					if not (surface_kind == 6) then
						break
					end
					out_of_play_timer = 1
					break
				end
			end
			if ball_y < -500.0 then
				out_of_play_timer = 1
				break
			elseif frame_count >= 300 then
				out_of_play_timer = 1
				break
			else
				pin_color = event.get_sphida_pin_color() or pin_color
				ball_color = event.get_sphida_ball_color() or ball_color
				x = vm.f32(pin_x - ball_x)
				y = vm.f32(pin_y - ball_y)
				z = vm.f32(pin_z - ball_z)
				pin_distance = event.get_vector_length(x, y, z) or pin_distance
				if ball_color ~= pin_color then
					pin_segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z)
						or pin_segment_distance
					if pin_segment_distance >= 0.0 and pin_segment_distance <= 30.0 then
						hit_pin = 1
						break
					end
					if pin_distance ~= 0.0 then
						if pin_distance <= 120.0 then
							do
								local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), pin_distance))
								x = out1 or x
								y = out2 or y
								z = out3 or z
							end
							do
								local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, x, y, z)
								ball_x = out1 or ball_x
								ball_y = out2 or ball_y
								ball_z = out3 or ball_z
							end
							do
								local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, x, y, z)
								velocity_x = out1 or velocity_x
								velocity_y = out2 or velocity_y
								velocity_z = out3 or velocity_z
							end
						end
					else
						hit_pin = 1
						break
					end
				elseif pin_distance ~= 0.0 then
					if pin_distance <= 60.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, pin_distance))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, x, y, z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, x, y, z)
							velocity_x = out1 or velocity_x
							velocity_y = out2 or velocity_y
							velocity_z = out3 or velocity_z
						end
					end
				end
				event.set_character_position(8, ball_x, ball_y, ball_z)
				event.set_character_position(9, ball_x, ball_y, ball_z)
				do
					local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				if ball_y <= -70.0 then
					event.set_follow_camera_following(0)
					if out_of_play_timer >= 30 then
						if out_of_play_timer >= 50 then
							break
						end
					else
						event.set_camera_look_at(ball_x, ball_y, ball_z)
					end
					out_of_play_timer = out_of_play_timer + 1
				elseif frame_count >= 20 then
					event.set_camera_control_range(20.0, 30.0, 60.0, 200.0)
					event.set_camera_speed(8.0)
					event.set_follow_camera_offset(0.0, 0.0, 0.0)
					event.set_follow_camera_target(
						vm.f32(ball_x + velocity_x) + velocity_x,
						vm.f32(ball_y + velocity_y) + velocity_y,
						vm.f32(ball_z + velocity_z) + velocity_z
					)
					do
						local out1, out2, out3 = event.get_camera_position()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					camera_angle = event.get_direction_angle(
						vm.f32(ball_x + velocity_x) + velocity_x,
						vm.f32(ball_y + velocity_y) + velocity_y,
						vm.f32(ball_z + velocity_z) + velocity_z,
						camera_x,
						camera_y,
						camera_z
					) or camera_angle
					event.set_camera_control_rotation(camera_angle)
					event.move_camera_control_with_pad(8)
					event.step_camera_control()
				end
				event.set_sphida_ball_position(ball_x, ball_y, ball_z)
				resume_step = 14
				vm.wait(14)
				if sound_cooldown > 0 then
					sound_cooldown = sound_cooldown - 1
				end
				if shot_power > 0.0 then
					shot_power = vm.f32(shot_power - 1.0)
				end
				frame_count = frame_count + 1
			end
		end
		event.set_character_position(8, ball_x, ball_y, ball_z)
		event.set_character_position(9, ball_x, ball_y, ball_z)
		resume_step = 15
		vm.wait(15)
		event.set_sphida_status_panel_visible(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if out_of_play_timer == 0 then
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			if hit_pin == 1 then
				event.set_character_active(0, 0)
				event.set_character_active(0, 8)
				event.set_character_active(0, 9)
				event.set_character_active(1, 12)
				event.set_character_position(12, pin_x, pin_y, pin_z)
				event.set_character_motion(12, "発動", 6)
				event.play_sound_effect(sound_bank, 17)
				frame_count = 0
				while frame_count < 2 do
					event.set_camera_control_enabled(0)
					event.set_follow_camera_following(1)
					event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
					event.set_camera_speed(12.0)
					event.set_follow_camera_offset(0.0, 0.0, 0.0)
					event.set_follow_camera_height(0.0)
					event.set_follow_camera_distance(100.0)
					event.step_follow_camera(1)
					frame_count = frame_count + 1
					resume_step = 16
					vm.wait(16)
				end
				event.set_character_active(0, 10)
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pin_x = out1 or pin_x
					pin_y = out2 or pin_y
					pin_z = out3 or pin_z
				end
				frame_count = 0
				while frame_count < 100 do
					event.set_camera_control_enabled(0)
					event.set_follow_camera_following(1)
					event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
					event.set_camera_speed(12.0)
					event.set_follow_camera_offset(0.0, 0.0, 0.0)
					event.set_follow_camera_height(0.0)
					event.set_follow_camera_distance(100.0)
					event.step_follow_camera(1)
					frame_count = frame_count + 1
					resume_step = 17
					vm.wait(17)
				end
				event.set_character_active(0, 11)
				pin_color = event.get_dungeon_stage_id() or pin_color
				ball_color = event.get_dungeon_floor() or ball_color
				collision_result = event.get_dungeon_floor_info(pin_color, ball_color, 4) or collision_result
				do
					local out1, out2 = event.get_sphida_prize(collision_result)
					sound_cooldown = out1 or sound_cooldown
					surface_kind = out2 or surface_kind
				end
				collision_result = vm.i32(collision_result + 1)
				event.set_dungeon_floor_info(pin_color, ball_color, 4, collision_result)
				resume_step = 18
				wait.frames(54)
				resume_step = 19
				wait.frames(30)
				event.delete_character(8)
				event.delete_character(9)
				event.delete_character(10)
				event.delete_character(11)
				event.set_sphida_playing(0)
				event.fade_out_screen(30)
				resume_step = 20
				wait.frames(30)
				event.play_music(0)
				event.release_camera_sequence_follow_object()
				event.set_event_sprite_draw_pass(0, 0)
			end
		else
			event.play_sound_effect(sound_bank, 18)
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
			resume_step = 21
			object.wait_until_done(0)
			resume_step = 22
			wait.frames(20)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_sphida_ball_position(start_x, start_y, start_z)
			event.set_character_position(8, start_x, start_y, start_z)
			event.set_character_position(9, start_x, start_y, start_z)
			event.release_camera_sequence_follow_object()
		end
		if hit_pin == 1 then
			bargas_valley.consume_par_stroke(-1)
		else
			bargas_valley.consume_par_stroke(sound_bank)
		end
		resume_step = 23
		return bargas_valley.finish_round(hit_pin)
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				local _ = received[1] :: number
				local _ = received[1] :: number
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step == 4 then
				local _ = received[1] :: number
				aim_angle = received[2] :: number
				elevation_angle = received[3] :: number
			end
			if resume_step <= 2 then
				wait.background_load_skipping()
			end
			if resume_step <= 3 then
				ball_x, ball_y, ball_z, aim_angle = bargas_valley.probe_clearance_arc(ball_x, ball_y, ball_z, aim_angle)
				bargas_valley.compute_offset_behind_angle(aim_angle)
				elevation_angle = 12.5
				shot_power, club_spin_factor, level = bargas_valley.return_arguments(shot_power, club_spin_factor, level)
				do
					local _: any
					_, aim_angle, elevation_angle = bargas_valley.update_aim_controls(aim_angle, elevation_angle, tex_bank)
				end
			end
			return bargas_valley.show_round_over_message(0)
		end
		if resume_step <= 13 then
			if resume_step == 6 then
				local _ = received[1] :: number
				shot_power = received[2] :: number
				aim_angle = received[3] :: number
				curve_strength = received[4] :: number
				drift_x = received[5] :: number
				level = received[6] :: number
			end
			if resume_step <= 7 then
				hit_pin = 0
				wait.frames_skipping(10)
			end
			if resume_step <= 8 then
				wait.frames_skipping(25)
			end
			if resume_step <= 9 then
				wait.frames_skipping(34)
			end
			if resume_step <= 10 then
				wait.frames_skipping(39)
			end
			if resume_step <= 11 then
				wait.frames_skipping(50)
			end
			if resume_step <= 12 then
				bargas_valley.decrement_counter(sound_bank)
			end
			return bargas_valley.show_round_over_message(0)
		end
		if resume_step <= 23 then
			if resume_step <= 14 then
				local _ = sound_cooldown > 0
				sound_cooldown = sound_cooldown - 1
				local _ = shot_power > 0.0
				shot_power = vm.f32(shot_power - 1.0)
				local _ = frame_count >= 300
				local _ = frame_count >= 20
				frame_count = frame_count + 1
			end
			if resume_step <= 15 then
				frame_count = 0
				local _ = frame_count < 2
				frame_count = frame_count + 1
			end
			if resume_step <= 16 then
				frame_count = 0
				local _ = frame_count < 100
				frame_count = frame_count + 1
			end
			if resume_step <= 17 then
				local _ = collision_result >= 0
				local _ = collision_result >= 0
				collision_result = collision_result + 1
				wait.frames_skipping(54)
			end
			if resume_step <= 18 then
				wait.frames_skipping(30)
			end
			if resume_step <= 19 then
				wait.frames_skipping(30)
			end
			if resume_step <= 20 then
				cutscene.skip_command(0)
			end
			if resume_step <= 21 then
				wait.frames_skipping(20)
			end
			if resume_step <= 22 then
				bargas_valley.decrement_counter(-1)
				bargas_valley.decrement_counter(sound_bank)
			end
			return bargas_valley.show_round_over_message(hit_pin)
		end
		return nil
	end)
end

--- Has the partner ask whether to try again after a miss and returns 1 when the player retries.
local function ask_retry_after_miss()
	local sound_bank: s32 = 0
	local answer: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		sound_bank = event.load_sound_effect_file_2(3809) or sound_bank
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
		resume_step = 1
		wait.frames(30)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_motion(1, "だめだめ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_voice_stream_wave(1, 3140170)
		resume_step = 2
		sound.wait_voice_stream_ready(1)
		event.open_message_window_2(0, "Oh, schade.\nM[UNI00f6]chtest du es noch mal versuchen?")
		message.open(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		resume_step = 3
		message.wait_voice_or_button(0)
		message.close(0)
		event.close_voice_stream(1)
		event.set_message_bubble_screen_slot(0, 0)
		event.reset_mouth_texture_animations()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Ja\nNein")
		message.open(0, -1, 5, 0, 0)
		resume_step = 4
		answer = message.choose_option(0, 2, 0, 1)
		event.set_message_bubble_screen_slot(0, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if answer == 0 then
			event.delete_character_extension_packs(13)
			event.set_character_active(1, 0)
			return 1
		else
			event.set_object_sequence_motion(1, "貸しなさい", 2)
			event.queue_object_sequence_next_motion(1, "貸しなさいＬ", 4)
			event.set_mouth_texture_animations(1, "通常口パク")
			event.open_voice_stream_wave(1, 3150010)
			resume_step = 5
			sound.wait_voice_stream_ready(1)
			event.open_message_window_2(0, "Du bist nutzlos, Max.\nLass mich mal.")
			message.open(0, -1, 8, 0, 0)
			event.play_voice_stream(1)
			resume_step = 6
			message.wait_voice_or_button(0)
			message.close(0)
			event.close_voice_stream(1)
			event.set_message_bubble_screen_slot(0, 0)
			event.reset_mouth_texture_animations()
			resume_step = 7
			object.wait_until_done(1)
			event.fade_out_screen(30)
			resume_step = 8
			wait.frames(30)
			event.set_character_active(1, 0)
			event.delete_character_extension_packs(13)
			return 0
		end
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 4 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				cutscene.skip_command(1)
			end
			if resume_step <= 2 then
				message.open_skipping(0, -1, 8, 0, 0)
				message.wait_voice_or_button_skipping(0)
			end
			if resume_step <= 3 then
				message.close_skipping(0)
				message.open_skipping(0, -1, 5, 0, 0)
				answer = message.resume_choice(0, 2, 0, 1)
			end
			return 1
		end
		if resume_step <= 8 then
			if resume_step <= 5 then
				message.open_skipping(0, -1, 8, 0, 0)
				message.wait_voice_or_button_skipping(0)
			end
			if resume_step <= 6 then
				message.close_skipping(0)
				cutscene.skip_command(1)
			end
			if resume_step <= 7 then
				wait.frames_skipping(30)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

script.init_map = init_map
script[99] = script.init_map

script.default_event = default_event

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_sphida_lesson_offer

--- Starts the Sphida lesson on the first talk, and afterwards offers to quit the practice and awards the prize when the player quits.
function script.talk_to_monica()
	local flag: s32 = 0
	local stick_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(314) or flag
		if flag == 0 then
			stick_count = event.get_owned_item_count(9) or stick_count
			if stick_count >= 1 then
				event.set_character_motion(0, "立ち")
				event.fade_out_screen(30)
				resume_step = 1
				wait.frames(30)
				resume_step = 2
				play_sphida_lesson_offer()
				event.fade_in_screen(30)
				resume_step = 3
				wait.frames(30)
				resume_step = 4
				show_sphida_tutorial()
			else
				resume_step = 5
				say_find_a_stick()
			end
		elseif (function()
			resume_step = 6
			return confirm_quit_practice()
		end)() ~= 0 then
			resume_step = 7
			bargas_valley.play_monica_shot_cutscene_with_sounds()
			event.add_inventory_item(10)
			event.add_inventory_item(363)
			resume_step = 8
			bargas_valley.play_item_reward_cutscene(10)
			resume_step = 9
			bargas_valley.enter_next_floor_in_d03()
			return
		end
		resume_step = 10
		vm.wait(10)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_step <= 9 then
			if resume_step == 6 then
				local _ = received[1] :: number
			end
			if resume_step <= 1 then
				resume_step = 2
				play_sphida_lesson_offer()
				return vm.continue_with(function()
					event.fade_in_screen(30)
					resume_step = 3
					wait.frames(30)
					resume_step = 4
					show_sphida_tutorial()
					resume_step = 10
					vm.wait(10)
					event.finish_event()
					return
				end)
			end
			if resume_step <= 2 then
				wait.frames_skipping(30)
			end
			if resume_step <= 3 then
				bargas_valley.show_blank_messages()
			end
			if resume_step <= 4 then
				bargas_valley.play_timed_effect()
			end
			if resume_step <= 5 then
				local _ = bargas_valley.play_timed_effect_sequence()
			end
			if resume_step <= 6 then
				resume_step = 7
				bargas_valley.play_monica_shot_cutscene_with_sounds()
				return vm.continue_with(function()
					event.add_inventory_item(10)
					event.add_inventory_item(363)
					resume_step = 8
					bargas_valley.play_item_reward_cutscene(10)
					resume_step = 9
					bargas_valley.enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 7 then
				resume_step = 8
				bargas_valley.play_item_reward_cutscene(10)
				return vm.continue_with(function()
					resume_step = 9
					bargas_valley.enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 8 then
				bargas_valley.wait_short_delay()
			end
			return 0
		end
		if resume_step <= 10 then
			return 0
		end
		return nil
	end)
end
script[500] = script.talk_to_monica

--- Gives the player the handy stick, disables the branch and shows the obtained message.
function script.pick_up_handy_stick()
	event.initialize_event()
	vm.wait(1)
	event.set_character_motion(0, "立ち")
	event.set_function_point_enabled("", "branch", 0)
	event.add_inventory_item(9)
	inventory.show_obtained_message_for_item_id(9, 1)
	event.set_character_active(0, 15)
	inventory.resolve_overflow_alt(1)
	event.finish_event()
end
script[510] = script.pick_up_handy_stick

--- Asks whether to go on to the next floor and descends when the player agrees.
function script.examine_exit()
	local active_character: s32 = 0
	local answer: any = 0
	event.initialize_event()
	vm.wait(1)
	event.reset_action_character_motion(0)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	answer = message.ask_choice(0, 10, 8, 256, 208, 2, 1)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	if answer == 0 then
		event.fade_out_screen(30)
		wait.frames(30)
		bargas_valley.enter_next_floor_in_d03()
		return
	end
	event.finish_event()
end
script[520] = script.examine_exit

--- Runs the defeat sequence when the party is defeated.
function script.on_party_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_party_defeated

--- Takes a Sphida shot, then plays the matching prize cutscene, or lets the player retry after a miss.
function script.sphida_shot()
	local shot_result: s32 = 0
	local round_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		shot_result = play_sphida_shot()
		if shot_result == 1 then
			resume_step = 2
			bargas_valley.play_hole_in_cup_cutscene()
			event.add_inventory_item(11)
			event.add_inventory_item(363)
			resume_step = 3
			bargas_valley.play_item_reward_cutscene(11)
			resume_step = 4
			bargas_valley.enter_next_floor_in_d03()
			return
		end
		if shot_result == 2 then
			round_count = event.get_local_event_counter(0) or round_count
			round_count = vm.i32(round_count + 1)
			event.set_local_event_counter(0, round_count)
			if round_count >= 10 then
				resume_step = 5
				bargas_valley.play_monica_shot_cutscene()
				event.add_inventory_item(10)
				event.add_inventory_item(363)
				resume_step = 6
				bargas_valley.play_item_reward_cutscene(10)
				resume_step = 7
				bargas_valley.enter_next_floor_in_d03()
				return
			elseif (function()
				resume_step = 8
				return ask_retry_after_miss()
			end)() == 0 then
				resume_step = 9
				bargas_valley.play_round_clear_cutscene()
				event.add_inventory_item(10)
				event.add_inventory_item(363)
				resume_step = 10
				bargas_valley.play_item_reward_cutscene(10)
				resume_step = 11
				bargas_valley.enter_next_floor_in_d03()
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
		if resume_step <= 4 then
			if resume_step == 1 then
				shot_result = received[1] :: number
			end
			if resume_step <= 1 then
				resume_step = 2
				bargas_valley.play_hole_in_cup_cutscene()
				return vm.continue_with(function()
					event.add_inventory_item(11)
					event.add_inventory_item(363)
					resume_step = 3
					bargas_valley.play_item_reward_cutscene(11)
					resume_step = 4
					bargas_valley.enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 2 then
				resume_step = 3
				bargas_valley.play_item_reward_cutscene(11)
				return vm.continue_with(function()
					resume_step = 4
					bargas_valley.enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 3 then
				bargas_valley.wait_short_delay()
			end
			return 0
		end
		if resume_step <= 7 then
			if resume_step <= 5 then
				resume_step = 6
				bargas_valley.play_item_reward_cutscene(10)
				return vm.continue_with(function()
					resume_step = 7
					bargas_valley.enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 6 then
				bargas_valley.wait_short_delay()
			end
			return 0
		end
		if resume_step <= 11 then
			if resume_step <= 8 then
				resume_step = 9
				bargas_valley.play_round_clear_cutscene()
				return vm.continue_with(function()
					event.add_inventory_item(10)
					event.add_inventory_item(363)
					resume_step = 10
					bargas_valley.play_item_reward_cutscene(10)
					resume_step = 11
					bargas_valley.enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 9 then
				resume_step = 10
				bargas_valley.play_item_reward_cutscene(10)
				return vm.continue_with(function()
					resume_step = 11
					bargas_valley.enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 10 then
				bargas_valley.wait_short_delay()
			end
			return 0
		end
		return nil
	end)
end

--- Offers to move the Sphere to the player and charges a stroke for it.
function script.sphida_near_ball()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local debug_flag: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	answer = message.ask_choice(0, 2004, 8, 256, 208, 2, 0)
	if answer == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.set_sphida_ball_position(player_x, player_y + 3.0, player_z)
		event.set_character_position(8, player_x, player_y + 3.0, player_z)
		event.set_character_position(9, player_x, player_y + 3.0, player_z)
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 0 then
			bargas_valley.consume_par_stroke(-1)
		end
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- Offers the last chance to move the Sphere to the player and marks the final challenge when accepted.
function script.sphida_near_ball_last()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Das ist das letzte Mal, dass du\ndie Kugel zu dir holen kannst.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Die Kugel zu dir holen?")
	answer = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
	if answer == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.set_sphida_ball_position(player_x, player_y + 3.0, player_z)
		event.set_character_position(8, player_x, player_y + 3.0, player_z)
		event.set_character_position(9, player_x, player_y + 3.0, player_z)
		event.set_sphida_last_challenge(1)
		event.start_crossfade(15)
	end
	vm.wait(3)
	event.finish_event()
end

--- Sets the valley story flags for the first visit and runs the default entry.
function script.enter_valley_first_visit()
	init_map()
	event.set_save_flag(300, 1)
	event.set_save_flag(320, 0)
	default_event()
end
script[13080] = script.enter_valley_first_visit

--- Resets the Sphida progress flags and runs the default entry.
function script.reset_sphida_progress()
	init_map()
	event.set_save_flag(300, 1)
	event.set_save_flag(320, 1)
	event.set_save_flag(312, 0)
	event.set_save_flag(314, 0)
	event.set_save_flag(315, 0)
	event.set_save_flag(316, 0)
	event.set_save_flag(317, 0)
	default_event()
end
script[13120] = script.reset_sphida_progress

--- Loads Monica's model and plays the item reward cutscene.
function script.cutscene_item_reward()
	init_map()
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "chara/c02_base.gltf", "info", 13)
	event.load_equipment_model(4, 1, 4, "info", 13)
	event.load_equipment_model(4, 1, 3, "info", 13)
	event.load_equipment_model(4, 1, 2, "info", 13, 14)
	bargas_valley.play_item_reward_cutscene(10)
end
script[13170] = script.cutscene_item_reward

return script
