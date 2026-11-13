--!strict
--- Event script for the Palm Brinks town map, covering entry placement, house doors, the dungeon gate, the fishing contest prompt and story cutscenes.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local npc = require("@lib/event/npc")
local object = require("@lib/event/object")
local palm_brinks_town = require("@lib/event/palm_brinks_town")
local party = require("@lib/event/party")
local wait = require("@lib/event/wait")

--- Plays the e800 cutscene in which Need appears on the map and fades the scene back out.
local function play_e800_cutscene()
	local sound_bank_id: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.set_save_flag(800, 1)
		event.set_camera_position(1863.34, -57.23, -1093.45)
		event.set_camera_look_at(1673.6, -34.95, -1596.24)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(193)
		event.play_music(0)
		sound_bank_id = event.load_sound_effect_file_2(1261) or sound_bank_id
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e800/e800/")
		event.load_message_file(0, 5, "e800.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e800_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.load_character(5, "e800_need.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(2, 35)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		block = event.load_event_image_4(5, "e800.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e80001", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e80002", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(4, 1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		event.set_object_handle_position(0, 1471.93, -90.0, -1214.38)
		event.set_object_handle_rotation(0, 0.0, 2.95, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, 1693.4, -48.85, -1747.04)
		event.set_object_handle_rotation(2, 0.0, -3.09, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 2)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1863.34, -57.23, -1093.45)
		event.set_camera_sequence_look_at(1673.6, -34.95, -1596.24)
		event.set_character_active(0)
		event.move_camera_sequence(1419.0, -57.23, -1121.53, 1673.6, -34.95, -1596.24, 300)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		wait.for_frame_count(180)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 1616.06, -90.0, -1552.76, 120, 1)
		camera.wait_until_done()
		event.set_camera_sequence_position(1819.9, 101.8, -1573.08)
		event.set_camera_sequence_look_at(1698.78, -1.69, -1732.94)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 1607.13, -77.8, -1633.37)
		event.set_object_sequence_rotation(0, 0.0, 2.95, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 1657.71, -48.85, -1704.67, 60, 1)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "振り向き", 6)
		event.rotate_object_sequence(2, 0.0, -0.33, 0.0, 20)
		event.delay_object_sequence_motion_track(2, 20)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		object.wait_until_done(0)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000010)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(8000020)
		event.set_camera_sequence_position(1680.47, -37.85, -1706.19)
		event.set_camera_sequence_look_at(1694.26, -26.32, -1748.64)
		event.set_object_handle_frame_visible(2, "te_l", 0)
		event.set_object_handle_frame_visible(2, "te_r", 0)
		event.set_object_handle_frame_visible(2, "te_gl--v0", 1)
		event.set_object_handle_frame_visible(2, "te_gr--v0", 1)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "しんけん顔")
		event.set_object_sequence_texture_animation(2, 1, "しんけん目パチ")
		event.set_scene_status_flags(1, 0, 256, 1)
		event.set_object_sequence_motion(2, "エキサイト", 6)
		event.queue_object_sequence_next_motion(2, "エキサイト戻り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000030)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000035)
		event.set_camera_sequence_position(1819.9, 101.8, -1573.08)
		event.set_camera_sequence_look_at(1698.78, -1.69, -1732.94)
		event.set_object_handle_frame_visible(2, "te_l", 1)
		event.set_object_handle_frame_visible(2, "te_r", 1)
		event.set_object_handle_frame_visible(2, "te_gl--v0", 0)
		event.set_object_handle_frame_visible(2, "te_gr--v0", 0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000040)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(8000050)
		event.set_scene_status_flags(1, 0, 256, 0)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000060)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000065)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(8000070)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000080)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000090)
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000100)
		event.play_sound_effect(sound_bank_id, 0)
		event.set_object_sequence_motion(0, "がっつ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(8000110)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000120)
		event.set_object_sequence_color(4, 128, 128, 128, 0, 30)
		event.set_camera_sequence_position(1704.99, -31.99, -1684.63)
		event.set_camera_sequence_look_at(1684.93, -26.32, -1741.26)
		event.set_object_sequence_position(0, 1678.13, -48.85, -1729.46)
		event.set_object_sequence_rotation(0, 0.0, 2.95, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(8000130)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(35)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, 1678.13, -48.85, -1729.46)
	event.set_character_rotation(0, 0.0, 2.95, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Pans the camera over the town at night until a button is pressed.
local function start_night_walk_scene()
	event.initialize_event()
	event.set_character_active(0, 0)
	event.set_character_active(0, 122)
	event.set_character_active(0, 123)
	event.set_event_projection(524.9)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-2805.19, 378.19, -1591.92)
	event.set_camera_sequence_look_at(-2901.57, 398.3, -1620.79)
	wait.for_frame_count(30)
	event.move_camera_sequence(-2805.19, 378.19, -1591.92, -2902.6, 398.3, -1571.73, 300)
	vm.wait(2)
	wait.until_button_pressed(32)
	event.set_character_active(1, 0)
end

--- Shows the system-style message window with the message the map already holds.
local function show_system_message()
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "You can't enter here in the demo version.")
	message.show(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 1)
end

--- Asks whether to enter the contest and either runs the player off to it or walks back, returning 1 when the player goes.
local function confirm_fishing_contest_entry()
	local contest_type: s32 = 0
	local choice: any = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local stage: number = 0
	return vm.guard(function()
		print("00000000000000000000000000\n")
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_motion(0, "立ち", 4)
		event.set_message_window_mode(0, 5)
		contest_type = event.get_menu_value_2(1) or contest_type
		if contest_type == 1 then
			event.open_message_window_2(0, "『釣り大会会場前』に移動しますか？")
		else
			event.open_message_window_2(0, "『ギョレース会場前』に移動しますか？")
		end
		print("11111111111111111111111111111111\n")
		stage = 1
		choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
		if choice == 0 then
			event.set_camera_sequence_position(1332.56, 67.86, 1494.1)
			event.set_camera_sequence_look_at(1508.0, 12.6, 1425.04)
			event.move_camera_sequence_eased(1332.56, 97.86, 1494.1, 1508.0, 42.6, 1425.04, 48, 2, 0.4)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			do
				local out1, out2, _ = event.get_character_position(0)
				start_x = out1 or start_x
				start_y = out2 or start_y
			end
			event.set_object_sequence_position(0, start_x, start_y, 1415.0)
			event.set_object_sequence_rotation(0, 0.0, 1.57, 0.0)
			event.move_object_sequence(0, 1800.0, start_y, 1415.0, 90)
			stage = 2
			wait.for_frame_count(15)
			event.fade_out_screen(30)
			stage = 3
			wait.for_frame_count(30)
			return 1
		end
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 15)
		stage = 4
		wait.for_frame_count(15)
		do
			local _, out2, out3 = event.get_character_position(0)
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		event.move_object_sequence(0, 1480.0, current_y, current_z, 45)
		stage = 5
		wait.for_frame_count(45)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if stage <= 3 then
			if stage == 1 then
				choice = received[1] :: number
			end
			if stage <= 1 then
				wait.skip_frame_count(15)
			end
			if stage <= 2 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if stage <= 5 then
			if stage <= 4 then
				wait.skip_frame_count(45)
			end
			return 0
		end
		return nil
	end)
end

--- Shows the note from Ferdinand about the cancelled party when the matching quest request is active.
local function show_party_cancelled_note()
	local request_status: s32 = 0
	local note_counter: s32 = 0
	request_status = event.get_quest_request_status(0, 8) or request_status
	if request_status == 1 then
		note_counter = event.get_save_counter(12) or note_counter
		if 0 < note_counter then
			if note_counter == 1 then
				event.set_save_counter(12, 2)
			end
			character.turn_to_rotation(0, vm.f32(-1.57))
			message.set_window_mode(0, 1)
			event.open_message_window_2(
				0,
				"ドアに手紙がはさんである。<page>「今日のパーティーは、とろりんチーズが\n　いまいちとろりんとしないので、中止に\n　します。　　　　　　　　　　　ポーク」"
			)
			message.show(0, -1, 5, 256, 208)
			event.request_town_edit_event(1)
			vm.wait(3)
		end
	end
end

--- Asks the yes or no prompt for system message 160 and, when the first choice is picked, fades out and returns 1, otherwise returns 0.
local function confirm_dungeon_entry_160()
	local choice: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		choice = message.ask_yes_no(5, 160)
		if choice == 0 then
			event.fade_out_screen(30)
			at = 2
			wait.for_frame_count(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				choice = received[1] :: number
			end
			if at <= 1 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		return nil
	end)
end

--- Asks whether to move to the sewer entrance and, when the first choice is picked, fades out and returns 1, otherwise returns 0.
local function confirm_dungeon_entry_55()
	local choice: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		vm.wait(1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『地下水道入り口』に移動しますか？")
		at = 2
		choice = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
		event.set_message_window_mode(0, 1)
		if choice == 0 then
			event.fade_out_screen(30)
			at = 3
			wait.for_frame_count(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 2 then
				choice = received[1] :: number
			end
			if at <= 1 then
				choice = message.ask_choice_skipping(0, -1, 8, 0, 0, 2, 1)
			end
			if at <= 2 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		return nil
	end)
end

--- Plays the dawn cutscene, repositions the player and enters the interior i01h01.
local function cutscene_dawn_then_enter_house()
	event.set_function_point_enabled("p01_e01g01-0", "invent_36-0", 1)
	palm_brinks_town.play_dawn_cutscene()
	event.set_camera_position(345.12, 84.74, -31.95)
	event.set_camera_look_at(351.66, 70.52, 137.18)
	event.set_character_position(0, 350.13, 52.0, 148.02)
	event.set_character_rotation(0, 0.0, -3.12, 0.0)
	event.skip_next_music_play()
	vm.wait(2)
	event.go_to_interior_map(-1, "i01h01", 500, 1)
	vm.wait(3)
end

--- Starts the conversation with a villager by dispatching on the villager's character type to that villager's own dialogue.
local function talk_to_npc(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	local npc_type: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local request_0_status: s32 = 0
	local request_8_status: s32 = 0
	local greeting_choice: any = 0
	local request_0_status_2: s32 = 0
	local request_10_status: s32 = 0
	local greeting_choice_2: any = 0
	local request_0_status_3: s32 = 0
	local request_13_status: s32 = 0
	local greeting_choice_3: any = 0
	local request_8_status_2: s32 = 0
	local active_chr_no: s32 = 0
	local greeting_choice_4: any = 0
	local at: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		event.set_message_bubble_tail(0, 1)
		chapter = event.get_chapter() or chapter
		npc_type = event.get_triggered_event_data_2(14) or npc_type
		event.get_current_map()
		now_sub_map_no = event.get_current_submap() or now_sub_map_no
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, npc_character)
		if npc_type == 3 then
			at = 1
			npc.talk_gardener(npc_character, player_character)
		end
		if npc_type == 5 then
			at = 2
			party.recruit_painter(npc_character, player_character)
		end
		if npc_type == 4 then
			flag = event.get_save_flag(104) or flag
			if flag == 0 then
				at = 3
				npc.open_shop()
			else
				at = 4
				npc.talk_shopkeeper_by_quest_2(npc_character, player_character)
			end
		end
		if npc_type == 7 then
			at = 5
			npc.talk_chef_by_quest_3(npc_character, player_character)
		end
		if npc_type == 8 then
			at = 6
			npc.talk_girl_by_quest_4(npc_character, player_character)
		end
		if npc_type == 10 then
			at = 7
			npc.talk_butler_by_quest_6(npc_character, player_character)
		end
		if npc_type == 11 then
			at = 8
			npc.talk_maid_by_quest_7(npc_character, player_character)
		end
		if npc_type == 12 then
			request_0_status = event.get_quest_request_status(0, 0) or request_0_status
			request_8_status = event.get_quest_request_status(0, 8) or request_8_status
			if request_0_status == 2 and request_8_status ~= 2 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				at = 9
				greeting_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if greeting_choice < 0 then
					event.set_villager_ai_enabled(1, npc_character)
					return
				end
				if greeting_choice == 1 then
					at = 10
					npc.talk_baker(npc_character, player_character)
					event.set_villager_ai_enabled(1, npc_character)
					return
				end
			end
			if now_sub_map_no == 28 then
				at = 11
				npc.open_shop()
			else
				at = 12
				npc.talk_baker(npc_character, player_character)
			end
		end
		if npc_type == 14 then
			at = 13
			party.recruit_busy_official(npc_character, player_character)
		end
		if npc_type == 15 then
			request_0_status_2 = event.get_quest_request_status(0, 0) or request_0_status_2
			request_10_status = event.get_quest_request_status(0, 10) or request_10_status
			if request_0_status_2 == 2 and request_10_status ~= 2 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				at = 14
				greeting_choice_2 = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if greeting_choice_2 < 0 then
					event.set_villager_ai_enabled(1, npc_character)
					return
				end
				if greeting_choice_2 == 1 then
					at = 15
					party.recruit_circus_performer(npc_character, player_character)
					event.set_villager_ai_enabled(1, npc_character)
					return
				end
			end
			if now_sub_map_no == 30 then
				at = 16
				npc.open_shop()
			else
				at = 17
				party.recruit_circus_performer(npc_character, player_character)
			end
		end
		if npc_type == 16 then
			at = 18
			npc.talk_by_quest_11(npc_character, player_character)
		end
		if npc_type == 17 then
			at = 19
			npc.talk_mayor_by_quest_12(npc_character, player_character)
		end
		if npc_type == 18 then
			request_0_status_3 = event.get_quest_request_status(0, 0) or request_0_status_3
			request_13_status = event.get_quest_request_status(0, 13) or request_13_status
			if request_0_status_3 == 2 and request_13_status ~= 2 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				at = 20
				greeting_choice_3 = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if greeting_choice_3 < 0 then
					event.set_villager_ai_enabled(1, npc_character)
					return
				end
				if greeting_choice_3 == 1 then
					at = 21
					npc.talk_priest(npc_character, player_character)
					event.set_villager_ai_enabled(1, npc_character)
					return
				end
			end
			if now_sub_map_no == 33 then
				at = 22
				npc.open_shop()
			else
				at = 23
				npc.talk_priest(npc_character, player_character)
			end
		end
		if npc_type == 19 then
			at = 24
			party.recruit_moon_photo_friend(npc_character, player_character)
		end
		if npc_type == 20 then
			at = 25
			npc.talk_fisherman(npc_character, player_character)
		end
		if npc_type == 21 then
			at = 26
			party.recruit_podium_hopeful(npc_character, player_character)
		end
		if npc_type == 23 then
			at = 27
			party.recruit_mina(npc_character, player_character)
		end
		if npc_type == 24 then
			at = 28
			npc.talk_colin(npc_character, player_character)
		end
		if npc_type == 25 then
			at = 29
			party.recruit_grandmother(npc_character, player_character)
		end
		if npc_type == 33 then
			request_8_status_2 = event.get_quest_request_status(0, 8) or request_8_status_2
			active_chr_no = event.get_playable_character() or active_chr_no
			if request_8_status_2 == 1 and active_chr_no == 0 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "買い物させて\nこんにちは")
				at = 30
				greeting_choice_4 = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if greeting_choice_4 < 0 then
					event.set_villager_ai_enabled(1, npc_character)
					return
				end
				if greeting_choice_4 == 1 then
					at = 31
					npc.talk_fondue_host(npc_character, player_character)
					event.set_villager_ai_enabled(1, npc_character)
					return
				end
			end
			at = 32
			npc.open_shop()
		end
		if npc_type == 1 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(
					0,
					"最近は細かい部品が\n見えにくくてのぅ。<page>わしも、もうろく\nしたのかのぅ・・・"
				)
			else
				event.open_message_window_2(
					0,
					"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
				)
			end
			at = 33
			cutscene.talk(npc_character, -1, 0, 0)
		end
		if npc_type == 2 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
			else
				event.open_message_window_2(
					0,
					"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
				)
			end
			at = 34
			cutscene.talk(npc_character, -1, 0, 0)
		end
		if npc_type == 6 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(0, "この時期、羽毛に虫がついてな、\nかゆくてかなわんよ。")
			else
				event.open_message_window_2(
					0,
					"ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。"
				)
			end
			at = 35
			cutscene.talk(npc_character, -1, 0, 0)
		end
		if npc_type == 13 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(
					0,
					"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
				)
			else
				event.open_message_window_2(0, "おまえ、ホントに冒険が好きだよなぁ。")
			end
			at = 36
			cutscene.talk(npc_character, -1, 0, 0)
		end
		if npc_type == 22 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(
					0,
					"絵から出て来たって言っても、\nそれ以外は普通の人と変わらないのよ。"
				)
			else
				event.open_message_window_2(
					0,
					"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
				)
			end
			at = 37
			cutscene.talk(npc_character, -1, 0, 0)
		end
		event.set_villager_ai_enabled(1, npc_character)
		return
	end, function(received: { any })
		if at <= 9 then
			if at == 9 then
				greeting_choice = received[1] :: number
			end
			if at <= 1 then
				message.resume_talk_pages(npc_character, player_character)
			end
			if at <= 2 then
				cutscene.go_shop_up()
			end
			if at <= 3 then
				message.resume_talk_pages_fifth(npc_character, player_character)
			end
			if at <= 4 then
				message.resume_talk_pages_third(npc_character, player_character)
			end
			if at <= 5 then
				message.resume_talk_pages_fourth(npc_character, player_character)
			end
			if at <= 6 then
				message.resume_talk_pages_sixth(npc_character, player_character)
			end
			if at <= 7 then
				message.resume_talk_pages_second(npc_character, player_character)
			end
			if at <= 8 then
				greeting_choice = message.ask_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 10 then
			return 0
		end
		if at <= 14 then
			if at == 14 then
				greeting_choice_2 = received[1] :: number
			end
			if at <= 11 then
				message.resume_talk_pages_third(npc_character, player_character)
			end
			if at <= 12 then
				message.resume_finish_dialogue(npc_character, player_character)
			end
			if at <= 13 then
				greeting_choice_2 = message.ask_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 15 then
			return 0
		end
		if at <= 20 then
			if at == 20 then
				greeting_choice_3 = received[1] :: number
			end
			if at <= 16 then
				message.resume_talk_pages_sixth(npc_character, player_character)
			end
			if at <= 17 then
				message.resume_talk_pages_sixth(npc_character, player_character)
			end
			if at <= 18 then
				npc.forward_talk(npc_character, player_character)
			end
			if at <= 19 then
				greeting_choice_3 = message.ask_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 21 then
			return 0
		end
		if at <= 30 then
			if at == 30 then
				greeting_choice_4 = received[1] :: number
			end
			if at <= 22 then
				cutscene.talk_with_default_message_zero_option(npc_character, player_character)
			end
			if at <= 23 then
				message.resume_talk_pages_fifth(npc_character, player_character)
			end
			if at <= 24 then
				message.resume_talk_pages_fifth(npc_character, player_character)
			end
			if at <= 25 then
				cutscene.talk_with_default_message_forwarded(npc_character, player_character)
			end
			if at <= 26 then
				cutscene.show_two_default_messages_forwarded_alt(npc_character, player_character)
			end
			if at <= 27 then
				message.resume_talk_pages(npc_character, player_character)
			end
			if at <= 28 then
				message.resume_talk_pages_fifth(npc_character, player_character)
			end
			if at <= 29 then
				greeting_choice_4 = message.ask_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 31 then
			return 0
		end
		if at <= 37 then
			if at <= 32 then
				cutscene.talk_skipping(npc_character, -1, 0, 0)
			end
			if at <= 33 then
				cutscene.talk_skipping(npc_character, -1, 0, 0)
			end
			if at <= 34 then
				cutscene.talk_skipping(npc_character, -1, 0, 0)
			end
			if at <= 35 then
				cutscene.talk_skipping(npc_character, -1, 0, 0)
			end
			if at <= 36 then
				cutscene.talk_skipping(npc_character, -1, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Starts the conversation of the villager that triggered the event.
local function talk_to_triggered_villager()
	local villager_type: s32 = 0
	local villager: s32 = 0
	local player_chara: s32 = 0
	local at: number = 0
	return vm.guard(function()
		villager_type = event.get_triggered_event_data_2(14) or villager_type
		villager = event.get_triggered_event_data_2(13) or villager
		player_chara = event.get_player_character_slot() or player_chara
		if villager_type <= 34 then
			at = 1
			talk_to_npc(villager, player_chara)
		else
			at = 2
			npc.talk_to_ordinary_villager()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				npc.resume_talk_end()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = palm_brinks_town.refresh_bridge_state

--- Places the player and restores music according to how the map was entered, and plays the chapter eight opening after a load when its flags are set.
function script.default_event()
	local memory_card_loaded: s32 = 0
	local cutscene_ready_flag: s32 = 0
	local cutscene_done_flag: s32 = 0
	local default_music_number: s32 = 0
	local exit_index: s32 = 0
	local required_flag: s32 = 0
	local blocking_flag: s32 = 0
	local music_switched_flag: s32 = 0
	local active_music_number: s32 = 0
	local old_map_no: s32 = 0
	local old_map_type: s32 = 0
	local needs_default_spawn: s32 = 0
	local spawn_override_flag: s32 = 0
	local previous_interior_map_no: s32 = 0
	palm_brinks_town.refresh_bridge_state()
	memory_card_loaded = event.take_memory_card_load_state() or memory_card_loaded
	if memory_card_loaded == 1 then
		cutscene_ready_flag = event.get_save_flag(736) or cutscene_ready_flag
		cutscene_done_flag = event.get_save_flag(800) or cutscene_done_flag
		if cutscene_ready_flag == 1 and cutscene_done_flag == 0 then
			event.fade_out_screen(0)
			play_e800_cutscene()
			event.set_save_data_value(0, 10)
			event.stop_all_sounds()
			event.set_sound_reverb_enabled(0)
			event.show_chapter_title(8)
			vm.wait(2)
			event.set_sound_reverb_enabled(1)
			event.load_map_sounds(1000)
			default_music_number = event.get_default_music_number(10) or default_music_number
			event.load_music(default_music_number)
			event.play_music(0)
			event.set_music_volume_follows_time_of_day(1)
			event.set_character_position(0, 1640.0, -48.8, -1700.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.reset_follow_camera(1, 0.0, 10.0)
			event.fade_in_screen(30)
			return
		end
		exit_index = event.get_save_counter(4) or exit_index
		if exit_index == 0 then
			event.set_character_position(0, 560.0, 4.1, 120.0)
			event.set_character_rotation(0, 0.0, 3.14, 0.0)
		end
		if exit_index == 1 then
			event.set_character_position(0, 2095.0, 0.0, 2100.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
		end
		if exit_index == 2 then
			event.set_character_position(0, -4260.0, 350.0, 2810.0)
			event.set_character_rotation(0, 0.0, 2.86, 0.0)
		end
		if exit_index == 3 then
			event.set_character_position(0, -3770.0, 359.4, -1640.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
		end
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0, 20.0)
	else
		required_flag = event.get_save_flag(105) or required_flag
		blocking_flag = event.get_save_flag(109) or blocking_flag
		music_switched_flag = event.get_save_flag(56) or music_switched_flag
		if required_flag ~= 0 and blocking_flag == 0 and music_switched_flag == 0 then
			event.get_active_music_number(active_music_number)
			event.get_music_master_volume()
			if active_music_number ~= 10 then
				event.fade_out_screen(0)
				event.load_map_sounds(1000)
				active_music_number = event.get_default_music_number(10) or active_music_number
				event.stop_music(0)
				wait.for_frame_count(4)
				event.load_music(active_music_number)
				event.play_music(0)
				event.set_save_flag(56, 1)
				event.set_music_volume_follows_time_of_day(1)
				event.fade_in_screen(30)
			end
		end
		old_map_no = event.get_previous_map() or old_map_no
		old_map_type = event.get_map_type(old_map_no) or old_map_type
		if old_map_type ~= -1 then
			if old_map_type == 7 or old_map_type == 8 then
				character.place_standing_and_reset_cloth(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
				event.reset_follow_camera(1, 0.0, 10.0)
			else
				needs_default_spawn = 1
				spawn_override_flag = event.get_save_flag(40) or spawn_override_flag
				if spawn_override_flag == 1 then
					if old_map_no == 34 then
						needs_default_spawn = 0
						event.set_character_position(0, 1645.1, -41.3, -1812.6)
						event.set_character_rotation(0, 0.0, -0.09, 0.0)
						event.reset_follow_camera(1)
					end
					if old_map_no == 22 then
						needs_default_spawn = 0
						palm_brinks_town.place_player_at_entrance_a()
					end
				end
				previous_interior_map_no = event.get_previous_interior_map() or previous_interior_map_no
				if 0 <= previous_interior_map_no then
					needs_default_spawn = 0
				elseif old_map_no == 121 then
					needs_default_spawn = 0
					event.set_character_position(0, 1450.0, 0.0, 1420.0)
					event.set_character_rotation(0, 0.0, -1.57, 0.0)
					event.reset_follow_camera(1, 3.1415927)
				end
				if needs_default_spawn ~= 0 then
					palm_brinks_town.place_player_at_entrance_b()
				end
			end
		end
	end
	event.set_save_flag(40, 0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = start_night_walk_scene

--- Enters the interior i01h01, or shows the system message while the story progress value is 100.
function script.enter_house_i01h01()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
		return
	end
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	vm.wait(3)
	event.go_to_interior_map(-1, "i01h01", 100, 1)
	vm.wait(4)
end
script[200] = script.enter_house_i01h01

--- Asks to enter the contest and jumps to map s45 when accepted.
function script.enter_fishing_contest()
	local stage: number = 0
	return vm.guard(function()
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n")
		stage = 1
		if confirm_fishing_contest_entry() ~= 0 then
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			event.fade_out_screen(0)
			stage = 2
			vm.wait(2)
			event.jump_to_map_2(-1, "s45")
			return
		end
		print("ccccccccccccccccccccccccccc\n")
		return
	end, function(received: { any })
		if stage <= 2 then
			if stage == 1 then
				local _ = received[1] :: number
			end
			if stage <= 1 then
				print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			end
			return 0
		end
		return nil
	end)
end
script[201] = script.enter_fishing_contest

--- Jumps to the interior i02h01, or shows the system message while the story progress value is 100.
function script.enter_house_i02h01()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
		return
	end
	event.jump_to_map_2(-1, "i02h01")
	vm.wait(3)
end
script[204] = script.enter_house_i02h01

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_210()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[210] = script.examine_door_210

--- Event 211, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_211() end
script[211] = script.ignore_event_211

--- Event 212, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_212() end
script[212] = script.ignore_event_212

--- Event 213, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_213() end
script[213] = script.ignore_event_213

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_214()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[214] = script.examine_door_214

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_215()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[215] = script.examine_door_215

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_216()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[216] = script.examine_door_216

--- Event 217, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_217() end
script[217] = script.ignore_event_217

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_218()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[218] = script.examine_door_218

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_219()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[219] = script.examine_door_219

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_220()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[220] = script.examine_door_220

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_221()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[221] = script.examine_door_221

--- Shows the system message while the story progress value is 100, otherwise reads the party-cancelled note.
function script.examine_party_cancelled_note()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	else
		show_party_cancelled_note()
	end
end
script[222] = script.examine_party_cancelled_note

--- Shows the system message while the story progress value is 100 and skips the next music load when the e305 flags are set.
function script.examine_door_223()
	local story_progress: s32 = 0
	local cutscene_ready_flag: s32 = 0
	local cutscene_done_flag: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
	cutscene_ready_flag = event.get_save_flag(304) or cutscene_ready_flag
	cutscene_done_flag = event.get_save_flag(305) or cutscene_done_flag
	if cutscene_ready_flag == 1 and cutscene_done_flag == 0 then
		event.skip_next_music_load()
	end
end
script[223] = script.examine_door_223

script.show_system_message = show_system_message
script[248] = script.show_system_message

--- Confirms entry, opens the dungeon floor menu and starts the chosen dungeon floor.
function script.enter_dungeon_gate()
	local unlocked_flag: s32 = 0
	local floor: s32 = 0
	unlocked_flag = event.get_save_flag(800) or unlocked_flag
	if unlocked_flag == 0 then
		return
	end
	if confirm_dungeon_entry_160() ~= 0 then
		event.set_dungeon_stage_id(6)
		event.open_event_menu(3, 6)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			floor = out3 or floor
		end
		if floor == 0 then
			event.fade_in_screen(30)
			return
		else
			if floor == 37 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(6, floor, 1010)
		end
	end
end
script[290] = script.enter_dungeon_gate

--- Stores the exit the player took and opens the event menu.
function script.open_menu_at_exit()
	local exit_index: s32 = 0
	exit_index = event.get_triggered_event_data_2(15) or exit_index
	event.set_save_counter(4, exit_index)
	menu.open_type_7()
end
script[400] = script.open_menu_at_exit

--- Shows the remark about boarding the train without permission, or the Blinkhorn reminder on the first visit.
function script.examine_train_without_permission()
	local active_character: s32 = 0
	local quest_counter: s32 = 0
	event.set_character_motion(0, "立ち")
	active_character = event.get_playable_character() or active_character
	quest_counter = event.get_save_counter(7) or quest_counter
	if active_character == 0 and quest_counter == 1 then
		event.set_save_counter(7, 2)
		event.open_message_window_2(0, "よし！急いでパッカーの所に戻らなきゃ。")
	else
		event.open_message_window_2(0, "だまって乗ったら怒られるかな？")
	end
	message.show(0, -1, 5, 256, 208)
end
script[401] = script.examine_train_without_permission

--- Confirms entry and jumps to the dungeon map d01e01.
function script.enter_dungeon_d01e01()
	if confirm_dungeon_entry_55() ~= 0 then
		event.jump_to_map_3(-1, "d01e01", 100)
	end
end
script[510] = script.enter_dungeon_d01e01

script.cutscene_dawn_then_enter_house = cutscene_dawn_then_enter_house
script[530] = script.cutscene_dawn_then_enter_house

--- Fades out, repositions the player and re-enters the interior i01h01 after losing to the elephant.
function script.on_lost_to_elephant()
	local stage: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.set_camera_position(345.12, 84.74, -31.95)
		event.set_camera_look_at(351.66, 70.52, 137.18)
		event.set_character_position(0, 350.13, 52.0, 148.02)
		event.set_character_rotation(0, 0.0, -3.12, 0.0)
		print("ぞうにまけた---------------------\n")
		stage = 1
		vm.wait(1)
		event.go_to_interior_map(-1, "i01h01", 510, 1)
		stage = 2
		vm.wait(2)
		print("じゃんぷ------------------\n")
		return
	end, function(received: { any })
		if stage <= 2 then
			print("じゃんぷ------------------\n")
			return 0
		end
		return nil
	end)
end
script[531] = script.on_lost_to_elephant

--- Plays the Starbre walk cutscene and jumps to the interior i03h01a without reloading the music.
function script.cutscene_starbre_walk_keep_music()
	palm_brinks_town.play_starbre_walk_cutscene()
	event.skip_villager_loading()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i03h01a", 500)
	vm.wait(2)
end
script[540] = script.cutscene_starbre_walk_keep_music

--- Has the two guards warn the player away from the restricted area and moves the player back unless the story progress value is 100.
function script.talk_to_gate_guards()
	local story_progress: s32 = 0
	local first_guard_slot: s32 = 0
	local second_guard_slot: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		return
	end
	event.set_camera_position(1300.0, 50.0, 763.0)
	event.set_camera_look_at(1300.0, 30.0, 968.18)
	event.set_character_motion(0, "立ち")
	first_guard_slot = event.find_scene_character_slot(50) or first_guard_slot
	second_guard_slot = vm.i32(first_guard_slot + 1)
	event.set_villager_ai_enabled(0, second_guard_slot)
	event.set_villager_ai_enabled(0, first_guard_slot)
	event.open_message_window_2(0, "おい、この先は\n立ち入り禁止だ。")
	cutscene.talk(first_guard_slot, -1, 0, 0)
	event.open_message_window_2(0, "おとなしく引き返した方が\n身のためだぜ。")
	cutscene.talk(second_guard_slot, -1, 0, 0)
	event.fade_out_screen(20)
	wait.for_frame_count(20)
	event.set_character_position(0, 1302, 0, 951)
	event.set_character_rotation(0, 0, 3.14, 0)
	event.set_villager_ai_enabled(1, second_guard_slot)
	event.set_villager_ai_enabled(1, first_guard_slot)
	event.fade_in_screen(20)
end
script[550] = script.talk_to_gate_guards

--- Event 560, which map data, a script or the engine runs by number.
script[560] = palm_brinks_town.refresh_bridge_state

--- Talks to the triggered villager unless the story progress value is 100.
function script.talk_to_villager()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		return
	end
	talk_to_triggered_villager()
end
script[1000] = script.talk_to_villager

--- Event 11051, which map data, a script or the engine runs by number.
script[11051] = script.cutscene_dawn_then_enter_house

--- Resets save flag 105 and the story progress value and re-enters the interior i01h01 to replay the Steve scene.
function script.reenter_i01h01_11052()
	event.set_save_flag(105, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11052, 1)
	vm.wait(2)
end
script[11052] = script.reenter_i01h01_11052

--- Resets save flag 105 and the story progress value and re-enters the interior i01h01 to replay the Steve scene.
function script.reenter_i01h01_11053()
	event.set_save_flag(105, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11053, 1)
	vm.wait(2)
end
script[11053] = script.reenter_i01h01_11053

--- Sets story flags and re-enters the interior i01h01 to replay the Steve scene.
function script.reenter_i01h01_11060()
	event.set_save_flag(103, 1)
	event.set_save_flag(106, 0)
	event.set_save_flag(107, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11060, 1)
	vm.wait(2)
end
script[11060] = script.reenter_i01h01_11060

--- Plays the Starbre walk cutscene and jumps to the interior i03h01a.
function script.cutscene_starbre_walk_then_enter_house()
	palm_brinks_town.play_starbre_walk_cutscene()
	event.skip_villager_loading()
	vm.wait(2)
	event.jump_to_map_3(-1, "i03h01a", 500)
	vm.wait(3)
end
script[11091] = script.cutscene_starbre_walk_then_enter_house

--- Plays the chapter eight opening and restarts the town music at the new spawn.
function script.cutscene_chapter_eight_start()
	play_e800_cutscene()
	event.set_save_data_value(0, 10)
	event.stop_all_sounds()
	event.set_sound_reverb_enabled(0)
	event.show_chapter_title(8)
	vm.wait(2)
	event.set_sound_reverb_enabled(1)
	event.load_music(0)
	event.load_map_sounds(1000)
	event.play_music(0)
	event.set_character_position(0, 1640.0, -48.8, -1700.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end
script[18000] = script.cutscene_chapter_eight_start

return script
