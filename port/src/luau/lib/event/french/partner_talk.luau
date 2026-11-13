--!strict
--- Holds the French companion conversations: camp menus, story hints and idle remarks.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")
local party = vm.module("@lib/event/party")
local scoop_exchange = vm.module("@lib/event/french/scoop_exchange")
local town_villagers = vm.module("@lib/event/french/town_villagers")
local wait = vm.module("@lib/event/wait")

local partner_talk = {}

--- Offers to leave the current map when its story flags allow it and returns 1 if the player agrees, otherwise speaks NPC 1's remarks as the partner or opens the companion menu for them.
function partner_talk.offer_leave_or_speak_with_npc_1()
	local character_slot: s32 = 0
	local offer_leave: s32 = 0
	local offer_map_id: s32 = 0
	local flag_280: s32 = 0
	local flag_283: s32 = 0
	local flag_372: s32 = 0
	local flag_360: s32 = 0
	local flag_448: s32 = 0
	local flag_452: s32 = 0
	local original_rotation: f32 = 0
	local player_slot: s32 = 0
	local leave_choice: any = 0
	local partner_id: s32 = 0
	local remark_map_id: s32 = 0
	local flag_300: s32 = 0
	local flag_400: s32 = 0
	local flag_500: s32 = 0
	local triggered_character_slot: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		character_slot = event.get_triggered_event_data_2(13) or character_slot
		offer_leave = 0
		offer_map_id = event.get_current_map() or offer_map_id
		if offer_map_id == 16 then
			flag_280 = event.get_save_flag(280) or flag_280
			flag_283 = event.get_save_flag(283) or flag_283
			if flag_280 ~= 0 and flag_283 == 0 then
				offer_leave = 1
			end
		end
		if offer_map_id == 54 then
			flag_372 = event.get_save_flag(372) or flag_372
			flag_360 = event.get_save_flag(360) or flag_360
			if flag_372 ~= 0 and flag_360 == 0 then
				offer_leave = 1
			end
		end
		if offer_map_id == 83 then
			flag_448 = event.get_save_flag(448) or flag_448
			flag_452 = event.get_save_flag(452) or flag_452
			if flag_448 ~= 0 and flag_452 == 0 then
				offer_leave = 1
			end
		end
		if offer_leave == 1 then
			message.set_window_mode(0, 1)
			resume_step = 1
			original_rotation = cutscene.begin_talk(character_slot, 0, 0)
			player_slot = event.get_player_character_slot() or player_slot
			event.open_message_window_2(0, "Tu veux partir ?")
			resume_step = 2
			message.say_bubble(0, -1, character_slot, player_slot, 0)
			event.set_character_motion(character_slot, "立ち")
			event.set_message_bubble_tail(0, 0)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(0, "Ouais !\nJe veux rester encore un peu.")
			resume_step = 3
			leave_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 0)
			event.set_message_window_option(0, 0, 0)
			event.set_message_bubble_tail(0, 1)
			if leave_choice ~= 0 then
				event.set_character_motion(character_slot, "会話")
				event.open_message_window_2(0, "Uumf allez, vas-y, fonce !")
				resume_step = 4
				message.say_bubble(0, -1, character_slot, player_slot, 0)
			end
			resume_step = 5
			cutscene.end_talk(character_slot, original_rotation, 0, 0)
			if leave_choice == 0 then
				return 1
			else
				return 0
			end
		end
		partner_id = event.get_party_npc() or partner_id
		if partner_id == 1 then
			message.set_window_mode(0, 1)
			event.open_message_window_2(0, "Faites attention l[UNI00e0]-bas.")
			remark_map_id = event.get_current_map() or remark_map_id
			flag_300 = event.get_save_flag(300) or flag_300
			if remark_map_id == 16 and flag_300 == 0 then
				event.open_message_window_2(0, "On n'est pas encore pr[UNI00ea]ts...\nLaisse-moi encore du temps.")
			end
			flag_400 = event.get_save_flag(400) or flag_400
			if remark_map_id == 54 and flag_400 == 0 then
				event.open_message_window_2(0, "On n'est pas encore pr[UNI00ea]ts...\nLaisse-moi encore du temps.")
			end
			flag_500 = event.get_save_flag(500) or flag_500
			if remark_map_id == 83 and flag_500 == 0 then
				event.open_message_window_2(0, "On n'est pas encore pr[UNI00ea]ts...\nLaisse-moi encore du temps.")
			end
			resume_step = 6
			cutscene.talk(character_slot, -1, 0, 0)
		else
			triggered_character_slot = event.get_triggered_event_data_2(13) or triggered_character_slot
			resume_step = 7
			partner_talk.open_companion_menu(triggered_character_slot, 1)
		end
		return 0
	end, function(received: { any })
		if resume_step <= 5 then
			if resume_step == 1 then
				original_rotation = received[1] :: number
			end
			if resume_step == 3 then
				leave_choice = received[1] :: number
			end
			if resume_step <= 1 then
				message.show_then_close(0, -1, character_slot, player_slot, 0)
			end
			if resume_step <= 2 then
				leave_choice = message.ask_choice_skipping(0, -1, 5, 256, 208, 2, 0)
			end
			if resume_step <= 3 then
				message.show_then_close(0, -1, character_slot, player_slot, 0)
			end
			if resume_step <= 4 then
				character.restore_facing_skipping(character_slot, original_rotation, 0, 0)
			end
			return 1
		end
		if resume_step <= 7 then
			if resume_step <= 6 then
				party.skip_talk_to_recruit(triggered_character_slot, 1)
			end
			return 0
		end
		return nil
	end)
end

--- Frames the camera on a recruitable villager at the camp point and runs a greeting with a menu to swap partners, hear a remark or start their own event.
function partner_talk.open_camp_companion_menu()
	local character_slot: s32 = 0
	local npc_id: s32 = 0
	local partner_id: s32 = 0
	local window_offset: s32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation_x: f32 = 0
	local npc_rotation_z: f32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_z: f32 = 0
	local player_look_angle: f32 = 0
	local npc_look_angle: f32 = 0
	local map_id: s32 = 0
	local camp_point_x: f32 = 0
	local camp_point_y: f32 = 0
	local camp_point_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local menu_choice: any = 0
	local option_text_number: s32 = 0
	local greeting_text_number: s32 = 0
	local option_count: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	partner_id = event.get_party_npc() or partner_id
	event.set_character_motion(0, "立ち")
	event.set_character_motion(character_slot, "立ち")
	event.initialize_event()
	event.apply_message_window_preset(1, 0)
	window_offset = 0
	if npc_id == 18 then
		window_offset = 20
	end
	if npc_id == 25 then
		window_offset = 24
	end
	if npc_id == 12 or npc_id == 17 then
		window_offset = 28
	end
	if npc_id == 7 then
		window_offset = 32
	end
	if npc_id == 10 or npc_id == 6 or npc_id == 24 then
		window_offset = 40
	end
	if npc_id == 8 or npc_id == 1 or npc_id == 2 or npc_id == 3 or npc_id == 15 or npc_id == 16 or npc_id == 21 then
		window_offset = 44
	end
	if npc_id == 4 or npc_id == 19 or npc_id == 20 or npc_id == 22 then
		window_offset = 48
	end
	if npc_id == 5 or npc_id == 11 or npc_id == 23 or npc_id == 13 then
		window_offset = 52
	end
	if npc_id == 9 then
		window_offset = 56
	end
	event.set_message_window_option(1, 4, 30, 60, 168, -1)
	event.set_message_window_option(1, 9, 20 + window_offset, 16)
	do
		local out1, _, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_z = out3 or player_z
	end
	do
		local out1, _, out3 = event.get_character_rotation(0)
		player_rotation_x = out1 or player_rotation_x
		player_rotation_z = out3 or player_rotation_z
	end
	do
		local out1, out2, out3 = event.get_character_position(character_slot)
		npc_x = out1 or npc_x
		npc_y = out2 or npc_y
		npc_z = out3 or npc_z
	end
	do
		local out1, _, out3 = event.get_character_rotation(character_slot)
		npc_rotation_x = out1 or npc_rotation_x
		npc_rotation_z = out3 or npc_rotation_z
	end
	player_look_angle = event.get_look_angle(npc_x - player_x, npc_z - player_z) or player_look_angle
	event.set_character_rotation(0, player_rotation_x, player_look_angle, player_rotation_z)
	npc_look_angle = event.get_look_angle(player_x - npc_x, player_z - npc_z) or npc_look_angle
	event.set_character_rotation(character_slot, npc_rotation_x, npc_look_angle, npc_rotation_z)
	map_id = event.get_current_map() or map_id
	if map_id ~= 1 then
		do
			local out1, out2, out3 = event.get_function_point_position("", "gcamp")
			camp_point_x = out1 or camp_point_x
			camp_point_y = out2 or camp_point_y
			camp_point_z = out3 or camp_point_z
		end
		event.set_camera_position(camp_point_x, camp_point_y, camp_point_z)
		event.set_camera_look_at(npc_x, npc_y + 30.0, npc_z)
		npc_look_angle = event.get_look_angle(camp_point_x - npc_x, camp_point_z - npc_z) or npc_look_angle
		event.set_character_rotation(character_slot, npc_rotation_x, npc_look_angle, npc_rotation_z)
	else
		camera_x = vm.f32(vm.sin(npc_look_angle) * 30.0)
		camera_x = vm.f32(camera_x + npc_x)
		camera_y = vm.f32(npc_y + 33.0)
		camera_z = vm.f32(vm.cos(npc_look_angle) * 30.0)
		camera_z = vm.f32(camera_z + npc_z)
		event.set_camera_position(camera_x, camera_y, camera_z)
		look_at_x = npc_x
		look_at_y = vm.f32(npc_y + 30.0)
		look_at_z = npc_z
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	end
	event.set_character_active(0, 0)
	vm.wait(1)
	event.start_crossfade(10)
	menu_choice = 0
	while true do
		message.set_window_mode(3, 1)
		town_villagers.say_villager_line(3, npc_id)
		option_text_number = -1
		event.set_message_draw_speed(3, 0, 0)
		message.set_window_mode(1, 8)
		event.set_message_draw_speed(1, 0, 0)
		greeting_text_number = event.get_npc_message_number_3(npc_id, 0) or greeting_text_number
		event.set_message_item_system_message(1, 1, greeting_text_number)
		message.open(1, 1, 1, 0, 0)
		message.set_window_mode(2, 2)
		do
			local out1, out2 = event.get_npc_message_number_4(npc_id, 4)
			option_text_number = out1 or option_text_number
			option_count = out2 or option_count
		end
		if option_count == 3 then
			option_text_number = 30
		end
		if option_count == 4 then
			event.set_message_item_system_message(2, 1, option_text_number)
			option_text_number = 31
		end
		if option_count == 5 then
			event.set_message_item_system_message(2, 1, option_text_number)
			event.set_message_item_system_message(2, 2, vm.i32(option_text_number + 1))
			option_text_number = 32
		end
		menu_choice = message.ask_choice(2, option_text_number, 7, 0, 0, option_count, vm.i32(option_count - 1))
		if menu_choice == 0 then
			if npc_id == partner_id then
				message.end_conversation_restoring_window()
				event.start_crossfade(10)
				return
			end
			if partner_id ~= 26 then
				event.fade_out_screen(25)
				wait.frames(30)
				event.set_npc_party_status(npc_id, 1)
				event.open_party_select_menu()
				vm.wait(5)
				message.end_conversation_restoring_window()
				event.fade_in_screen(30)
				return
			end
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			event.open_message_window_2(
				3,
				"[(!)]Tu ne peux pas faire [UNI00e7]a maintenant. Tu\ndois d'abord emmener Lin au phare !"
			)
			message.show(3, -1, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if menu_choice == 1 then
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			option_text_number = event.get_npc_message_number_3(npc_id, 3) or option_text_number
			message.show(3, option_text_number, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if 3 < option_count then
			if option_count == 5 then
				if menu_choice == 2 then
					if npc_id == 1 then
						event.set_save_data_value(2)
						event.open_message_window_2(3, "Tr[UNI00e8]s bien, on a termin[UNI00e9]\nles r[UNI00e9]parations !")
						message.show(3, -1, 3, 256, 208)
						message.end_conversation_restoring_window()
						event.start_crossfade(10)
					end
					if not (npc_id == 4) then
						break
					end
					menu.open_shop_waiting_frames(6)
					break
				end
				if menu_choice == 3 then
					if npc_id == 1 then
						menu.open_shop_waiting_frames(23)
						return
					end
					if npc_id == 4 then
						if scoop_exchange.report_scoops(3) ~= 0 then
							menu.open_shop_waiting_frames(33)
							return
						end
					end
				end
				if menu_choice == 4 then
					break
				end
				if menu_choice == -1 then
					break
				end
			else
				if menu_choice == 2 then
					if npc_id == 15 then
						menu.open_shop_waiting_frames(0)
					end
					if npc_id == 12 then
						menu.open_shop_waiting_frames(1)
					end
					if npc_id == 6 then
						menu.open_shop_waiting_frames(2)
					end
					if npc_id == 7 then
						menu.open_shop_waiting_frames(3)
					end
					if npc_id == 2 then
						menu.open_shop_waiting_frames(7)
					end
					if npc_id == 3 then
						menu.open_shop_waiting_frames(8)
					end
					if npc_id == 5 then
						menu.open_shop_waiting_frames(9)
					end
					if npc_id == 8 then
						menu.open_shop_waiting_frames(10)
					end
					if npc_id == 10 then
						menu.open_shop_waiting_frames(11)
					end
					if npc_id == 11 then
						menu.open_shop_waiting_frames(12)
					end
					if npc_id == 13 then
						menu.open_shop_waiting_frames(13)
					end
					if npc_id == 16 then
						menu.open_shop_waiting_frames(14)
					end
					if npc_id == 18 then
						menu.open_shop_waiting_frames(15)
					end
					if npc_id == 19 then
						menu.open_shop_waiting_frames(16)
					end
					if npc_id == 20 then
						menu.open_shop_waiting_frames(17)
					end
					if npc_id == 21 then
						menu.open_shop_waiting_frames(18)
					end
					if npc_id == 22 then
						menu.open_shop_waiting_frames(19)
					end
					if npc_id == 23 then
						menu.open_shop_waiting_frames(20)
					end
					if npc_id == 24 then
						menu.open_shop_waiting_frames(21)
					end
					if npc_id == 25 then
						menu.open_shop_waiting_frames(22)
					end
					if npc_id == 17 then
						menu.open_shop_waiting_frames(32)
					end
					if npc_id == 9 then
						partner_talk.show_story_hint()
						message.show(3, -1, 3, 256, 208)
						message.end_conversation_restoring_window()
						event.start_crossfade(10)
					end
					if npc_id == 14 then
						event.fade_out_screen(25)
						wait.frames(30)
						event.open_event_menu(25)
						vm.wait(36)
						message.end_conversation_restoring_window()
						event.fade_in_screen(30)
					end
					return
				end
				if menu_choice == 3 then
					break
				end
				if menu_choice == -1 then
					break
				end
			end
		else
			if menu_choice == 2 then
				break
			end
			if menu_choice == -1 then
				break
			end
		end
	end
	message.end_conversation_restoring_window()
	event.start_crossfade(10)
end

--- Runs a conversation with a recruitable villager: frames the camera on them, shows a greeting and a menu to swap partners, hear a remark or start their own event.
function partner_talk.open_companion_menu(character_slot: s32, fixed_npc_code: s32)
	local npc_id: s32 = 0
	local partner_id: s32 = 0
	local window_offset: s32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation_y: f32 = 0
	local seat_index: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_y: f32 = 0
	local player_rotation_z: f32 = 0
	local selection: any = 0
	local message_id: s32 = 0
	local chapter: s32 = 0
	local header_message_id: s32 = 0
	local option_count: s32 = 0
	local partner_slot: s32 = 0
	if fixed_npc_code == 1 then
		npc_id = 1
	elseif fixed_npc_code == 2 then
		npc_id = 2
	elseif fixed_npc_code == 3 then
		npc_id = 13
	else
		npc_id = event.get_local_event_counter(character_slot) or npc_id
	end
	partner_id = event.get_party_npc() or partner_id
	if npc_id == partner_id then
		return
	end
	event.set_character_motion(0, "立ち")
	event.initialize_event()
	event.apply_message_window_preset(1, 0)
	window_offset = 0
	if npc_id == 18 then
		window_offset = 20
	end
	if npc_id == 25 then
		window_offset = 24
	end
	if npc_id == 12 or npc_id == 17 then
		window_offset = 28
	end
	if npc_id == 7 then
		window_offset = 32
	end
	if npc_id == 10 or npc_id == 6 or npc_id == 24 then
		window_offset = 40
	end
	if npc_id == 8 or npc_id == 1 or npc_id == 2 or npc_id == 3 or npc_id == 15 or npc_id == 16 or npc_id == 21 then
		window_offset = 44
	end
	if npc_id == 4 or npc_id == 19 or npc_id == 20 or npc_id == 22 then
		window_offset = 48
	end
	if npc_id == 5 or npc_id == 11 or npc_id == 23 or npc_id == 13 then
		window_offset = 52
	end
	if npc_id == 9 then
		window_offset = 56
	end
	event.set_message_window_option(1, 4, 30, 60, 168, -1)
	event.set_message_window_option(1, 9, 20 + window_offset, 16)
	event.set_eye_view_map_parts(1)
	if fixed_npc_code ~= 0 then
		event.attach_object_handle_to_character(0, character_slot)
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			npc_x = out1 or npc_x
			npc_y = out2 or npc_y
			npc_z = out3 or npc_z
		end
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			npc_rotation_y = out2 or npc_rotation_y
		end
	else
		seat_index = event.get_villager_training_value(1, npc_id) or seat_index
		do
			local out1, out2, out3, out4 = event.get_train_seat_position(seat_index)
			npc_x = out1 or npc_x
			npc_y = out2 or npc_y
			npc_z = out3 or npc_z
			npc_rotation_y = out4 or npc_rotation_y
		end
		event.attach_object_handle_to_character(0, character_slot)
		event.set_object_handle_position(0, npc_x, npc_y, npc_z)
		event.set_object_handle_rotation(0, 0.0, npc_rotation_y, 0.0)
		event.set_character_motion(character_slot, "立ち", 4)
	end
	camera_x = vm.f32(vm.sin(npc_rotation_y) * 75.0)
	camera_x = vm.f32(camera_x + npc_x)
	camera_y = vm.f32(npc_y + 45.0)
	camera_z = vm.f32(vm.cos(npc_rotation_y) * 75.0)
	camera_z = vm.f32(camera_z + npc_z)
	event.set_camera_position(camera_x, camera_y, camera_z)
	look_at_x = npc_x
	look_at_y = vm.f32(npc_y + 30.0)
	look_at_z = npc_z
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	player_x = vm.f32(vm.sin(npc_rotation_y) * 30.0)
	player_x = vm.f32(player_x + npc_x)
	player_y = npc_y
	player_z = vm.f32(vm.cos(npc_rotation_y) * 30.0)
	player_z = vm.f32(player_z + npc_z)
	event.set_character_position(0, player_x, player_y, player_z)
	player_rotation_x = 0
	player_rotation_y = vm.f32(npc_rotation_y + vm.f32(3.1415927))
	if player_rotation_y > vm.f32(3.1415927) then
		player_rotation_y = vm.f32(player_rotation_y - vm.f32(6.2831855))
	end
	player_rotation_z = 0
	event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
	vm.wait(1)
	event.start_crossfade(10)
	selection = 0
	while true do
		message.set_window_mode(3, 1)
		chapter = event.get_chapter() or chapter
		if chapter ~= 8 then
			message_id = event.get_npc_message_number_3(npc_id, 2) or message_id
		else
			partner_talk.show_npc_remark(3, npc_id)
			message_id = -1
		end
		event.set_message_draw_speed(3, 0, 0)
		message.open(3, message_id, 3, 256, 208)
		message.set_window_mode(1, 8)
		event.set_message_draw_speed(1, 0, 0)
		header_message_id = event.get_npc_message_number_3(npc_id, 0) or header_message_id
		event.set_message_item_system_message(1, 1, header_message_id)
		message.open(1, 1, 1, 0, 0)
		message.set_window_mode(2, 2)
		do
			local out1, out2 = event.get_npc_message_number_4(npc_id, 4)
			message_id = out1 or message_id
			option_count = out2 or option_count
		end
		if option_count == 3 then
			message_id = 30
		end
		if option_count == 4 then
			event.set_message_item_system_message(2, 1, message_id)
			message_id = 31
		end
		if option_count == 5 then
			event.set_message_item_system_message(2, 1, message_id)
			event.set_message_item_system_message(2, 2, vm.i32(message_id + 1))
			message_id = 32
		end
		selection = message.ask_choice(2, message_id, 7, 0, 0, option_count, vm.i32(option_count - 1))
		message.close(3)
		if selection == 0 then
			if partner_id ~= 26 then
				event.fade_out_screen(25)
				wait.frames(30)
				if fixed_npc_code == 0 then
					event.set_character_active(0, character_slot)
					partner_slot = event.find_local_event_counter(partner_id) or partner_slot
					if 0 <= partner_slot then
						event.set_character_active(partner_slot)
					end
				end
				event.set_npc_party_status(npc_id, 1)
				event.open_party_select_menu()
				vm.wait(4)
				party.finish_recruit_talk(character_slot, fixed_npc_code)
				event.fade_in_screen(30)
				return
			end
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			event.open_message_window_2(
				3,
				"[(!)]Tu ne peux pas faire [UNI00e7]a maintenant. Tu\ndois d'abord emmener Lin au phare !"
			)
			message.show(3, -1, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if selection == 1 then
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			message_id = event.get_npc_message_number_3(npc_id, 3) or message_id
			message.show(3, message_id, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if 3 < option_count then
			if option_count == 5 then
				if selection == 2 then
					if npc_id == 1 then
						event.set_save_data_value(2)
						event.open_message_window_2(3, "Tr[UNI00e8]s bien, on a termin[UNI00e9]\nles r[UNI00e9]parations !")
						message.show(3, -1, 3, 256, 208)
						party.finish_recruit_talk(character_slot, fixed_npc_code)
						event.start_crossfade(10)
					end
					if not (npc_id == 4) then
						break
					end
					party.open_npc_menu(character_slot, fixed_npc_code, 6)
					break
				end
				if selection == 3 then
					if npc_id == 1 then
						party.open_npc_menu(character_slot, fixed_npc_code, 23)
						return
					end
					if npc_id == 4 then
						if scoop_exchange.report_scoops(3) ~= 0 then
							party.open_npc_menu(character_slot, fixed_npc_code, 33)
							return
						end
					end
				end
				if selection == 4 then
					break
				end
				if selection == -1 then
					break
				end
			else
				if selection == 2 then
					if npc_id == 15 then
						party.open_npc_menu(character_slot, fixed_npc_code, 0)
					end
					if npc_id == 12 then
						party.open_npc_menu(character_slot, fixed_npc_code, 1)
					end
					if npc_id == 6 then
						party.open_npc_menu(character_slot, fixed_npc_code, 2)
					end
					if npc_id == 7 then
						party.open_npc_menu(character_slot, fixed_npc_code, 3)
					end
					if npc_id == 2 then
						party.open_npc_menu(character_slot, fixed_npc_code, 7)
					end
					if npc_id == 3 then
						party.open_npc_menu(character_slot, fixed_npc_code, 8)
					end
					if npc_id == 5 then
						party.open_npc_menu(character_slot, fixed_npc_code, 9)
					end
					if npc_id == 8 then
						party.open_npc_menu(character_slot, fixed_npc_code, 10)
					end
					if npc_id == 10 then
						party.open_npc_menu(character_slot, fixed_npc_code, 11)
					end
					if npc_id == 11 then
						party.open_npc_menu(character_slot, fixed_npc_code, 12)
					end
					if npc_id == 13 then
						party.open_npc_menu(character_slot, fixed_npc_code, 13)
					end
					if npc_id == 16 then
						party.open_npc_menu(character_slot, fixed_npc_code, 14)
					end
					if npc_id == 18 then
						party.open_npc_menu(character_slot, fixed_npc_code, 15)
					end
					if npc_id == 19 then
						party.open_npc_menu(character_slot, fixed_npc_code, 16)
					end
					if npc_id == 20 then
						party.open_npc_menu(character_slot, fixed_npc_code, 17)
					end
					if npc_id == 21 then
						party.open_npc_menu(character_slot, fixed_npc_code, 18)
					end
					if npc_id == 22 then
						party.open_npc_menu(character_slot, fixed_npc_code, 19)
					end
					if npc_id == 23 then
						party.open_npc_menu(character_slot, fixed_npc_code, 20)
					end
					if npc_id == 24 then
						party.open_npc_menu(character_slot, fixed_npc_code, 21)
					end
					if npc_id == 25 then
						party.open_npc_menu(character_slot, fixed_npc_code, 22)
					end
					if npc_id == 17 then
						party.open_npc_menu(character_slot, fixed_npc_code, 32)
					end
					if npc_id == 9 then
						partner_talk.show_story_hint()
						event.set_message_draw_speed(3, 0.6, 0.6)
						message.show(3, -1, 3, 256, 208)
						party.finish_recruit_talk(character_slot, fixed_npc_code)
						event.start_crossfade(10)
					end
					if npc_id == 14 then
						event.fade_out_screen(25)
						wait.frames(30)
						event.open_event_menu(25)
						vm.wait(35)
						party.finish_recruit_talk(character_slot, fixed_npc_code)
						event.fade_in_screen(30)
					end
					return
				end
				if selection == 3 then
					break
				end
				if selection == -1 then
					break
				end
			end
		else
			if selection == 2 then
				break
			end
			if selection == -1 then
				break
			end
		end
	end
	party.finish_recruit_talk(character_slot, fixed_npc_code)
	event.start_crossfade(10)
end

--- Opens the given message window with the idle remark of the villager with the given id.
function partner_talk.show_npc_remark(window: s32, npc_id: s32)
	if npc_id == 1 then
		event.open_message_window_2(
			window,
			"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
		)
	end
	if npc_id == 2 then
		event.open_message_window_2(
			window,
			"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
		)
	end
	if npc_id == 3 then
		event.open_message_window_2(window, "Il doit y avoir tant de plantes\nqu'on ne conna[UNI00ee]t pas encore.")
	end
	if npc_id == 4 then
		event.open_message_window_2(
			window,
			"H[UNI00e9] ! Alors, cette chasse [UNI00e0] la\nzelmite ? Si je peux faire quoi\nque ce soit, appelle-moi."
		)
	end
	if npc_id == 5 then
		event.open_message_window_2(
			window,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	if npc_id == 6 then
		event.open_message_window_2(
			window,
			"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
		)
	end
	if npc_id == 7 then
		event.open_message_window_2(
			window,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	if npc_id == 8 then
		event.open_message_window_2(
			window,
			"Enfin, le chemin de fer Noirpierre\nva s'[UNI00e9]tendre au reste du monde.\nComme c'est excitant !"
		)
	end
	if npc_id == 9 then
		event.open_message_window_2(window, "H[UNI00e9], [UNI00e7]a roule ? Moi, c'est l'top !")
	end
	if npc_id == 10 then
		event.open_message_window_2(window, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	if npc_id == 11 then
		event.open_message_window_2(window, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	if npc_id == 12 then
		event.open_message_window_2(window, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	if npc_id == 13 then
		event.open_message_window_2(window, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
	end
	if npc_id == 14 then
		event.open_message_window_2(window, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	if npc_id == 15 then
		event.open_message_window_2(window, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	if npc_id == 16 then
		event.open_message_window_2(
			window,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	if npc_id == 17 then
		event.open_message_window_2(
			window,
			"Je voulais te dire... je sais que\nla Mine de zelmite est un endroit\ndangereux. Ne prends aucun risque."
		)
	end
	if npc_id == 18 then
		event.open_message_window_2(window, "Je prie pour que le monde vive\nenfin en paix.")
	end
	if npc_id == 19 then
		event.open_message_window_2(
			window,
			"Si la voie ferr[UNI00e9]e Noirpierre couvre\nle monde entier, on va d[UNI00e9]couvrir\ndes tas de super nouveaux endroits."
		)
	end
	if npc_id == 20 then
		event.open_message_window_2(
			window,
			"J'ai h[UNI00e2]te de d[UNI00e9]couvrir les nouveaux\nhauts-lieux de la p[UNI00ea]che qu'a [UNI00e0]\noffrir le monde. [UNI00c7]a sera trop top."
		)
	end
	if npc_id == 21 then
		event.open_message_window_2(
			window,
			"J'aimerais tant que Fabio\ns'int[UNI00e9]resse un peu [UNI00e0] autre chose\nque la p[UNI00ea]che."
		)
	end
	if npc_id == 22 then
		event.open_message_window_2(window, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
	end
	if npc_id == 23 then
		event.open_message_window_2(
			window,
			"Si la Voie ferr[UNI00e9]e Noirpierre\ns'[UNI00e9]tend au monde entier, j'irai\npeut-[UNI00ea]tre aussi voyager."
		)
	end
	if npc_id == 24 then
		event.open_message_window_2(
			window,
			"Ne dis pas le contraire. Je sais\nque tu as fait plein de trucs hyper\ncool. Viens m'en parler un jour !"
		)
	end
	if npc_id == 25 then
		event.open_message_window_2(
			window,
			'Quand la voie ferr[UNI00e9]e Noirpierre\nsera termin[UNI00e9]e, j\'adorerais aller \naux "Confins de la Terre".'
		)
	end
end

--- Opens message window 3 with the partner's hint for the latest story progress selected from the story flags.
function partner_talk.show_story_hint()
	local story_flag: s32 = 0
	local gem_flag_1: s32 = 0
	local gem_flag_2: s32 = 0
	local gem_flag_3: s32 = 0
	local gem_flag_4: s32 = 0
	story_flag = event.get_save_flag(732) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Bravo ! Les hommes ne sont\npas si mauvais apr[UNI00e8]s tout !<page>J'avais tort !")
		return
	end
	story_flag = event.get_save_flag(728) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"[UNI00c7]a y est. C'est presque termin[UNI00e9].\nIl ne reste plus qu'[UNI00e0] le vaincre.<page>Apr[UNI00e8]s [UNI00e7]a, le monde pourra revivre."
		)
		return
	end
	story_flag = event.get_save_flag(712) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Je crois comprendre Griffon, mais\nje ne pourrai jamais lui pardonner.")
		return
	end
	story_flag = event.get_save_flag(702) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Reconstruis le jardin, et d[UNI00e9]couvre\nle secret de Griffon, euh... Sirus.")
		return
	end
	story_flag = event.get_save_flag(700) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"Qu'est-ce que [UNI00e7]a veut dire les\n\"souvenirs de Sirus\"?\nJe suppose qu'il\nfaut entrer au palais pour comprendre."
		)
		return
	end
	story_flag = event.get_save_flag(640) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Vite, Griffon va s'[UNI00e9]chapper, allons\nau Palais de fleur-lune !")
		return
	end
	gem_flag_1 = event.get_save_flag(624) or gem_flag_1
	gem_flag_2 = event.get_save_flag(628) or gem_flag_2
	gem_flag_3 = event.get_save_flag(632) or gem_flag_3
	gem_flag_4 = event.get_save_flag(636) or gem_flag_4
	if (if (if (if gem_flag_1 ~= 0 then gem_flag_2 else 0) ~= 0 then gem_flag_3 else 0) ~= 0 then gem_flag_4 else 0) ~= 0 then
		event.open_message_window_2(3, "Les pierres semblent toutes l[UNI00e0].\nAllons vite [UNI00e0] Stonehenge Kazarov.")
		return
	end
	story_flag = event.get_save_flag(616) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Peu importe, trouvons vite les\npierres, ou il sera trop tard.")
		return
	end
	story_flag = event.get_save_flag(600) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Tout a d[UNI00e9]but[UNI00e9] dans ce palais,\nhein. Bon, allons dans le jardin.")
		return
	end
	story_flag = event.get_save_flag(540) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Rentrons au Labo psy. Peut-[UNI00ea]tre\nauront-ils fini l'Ixion ?")
		return
	end
	story_flag = event.get_save_flag(536) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Il est temps de riposter contre\nGriffon. Allons au QG de Paznos.")
		return
	end
	story_flag = event.get_save_flag(526) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Ne reste pas plant[UNI00e9] l[UNI00e0] ! Il faut\naller sauver Monica, c'est urgent !")
		return
	end
	story_flag = event.get_save_flag(524) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Galen Agaris a dit que jouer de la\nCorne de feu t'ouvrirait la route.")
		return
	end
	story_flag = event.get_save_flag(520) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Ne reste pas plant[UNI00e9] l[UNI00e0] ! Il faut\naller sauver Monica, c'est urgent !")
		return
	end
	story_flag = event.get_save_flag(508) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Il faut pulv[UNI00e9]riser ce Lance-feu.<page>Il serait au sommet du Mt Gundor.")
		return
	end
	event.open_message_window_2(
		3,
		"Attendre ici ne changera rien.<page>Il y a s[UNI00fb]rement un lieu o[UNI00f9] on\nn'est pas encore all[UNI00e9]s."
	)
end

--- Speaks NPC 13's chapter-dependent remarks when they are the current partner, otherwise opens the companion menu for them.
function partner_talk.speak_with_npc_13()
	local character_slot: s32 = 0
	local partner_id: s32 = 0
	local chapter: s32 = 0
	local flag_280: s32 = 0
	local flag_372: s32 = 0
	local flag_448: s32 = 0
	local triggered_character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	partner_id = event.get_party_npc() or partner_id
	if partner_id == 13 then
		message.set_window_mode(0, 1)
		event.open_message_window_2(
			0,
			"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
		)
		chapter = event.get_chapter() or chapter
		flag_280 = event.get_save_flag(280) or flag_280
		if chapter == 2 and flag_280 == 0 then
			event.open_message_window_2(0, "Une super bombe et ce rocher\nne sera plus qu'un souvenir.")
		end
		flag_372 = event.get_save_flag(372) or flag_372
		if chapter == 3 and flag_372 == 0 then
			event.open_message_window_2(
				0,
				"N'emp[UNI00ea]che que, faire sauter des\ntrucs, c'est pas rien non plus.\nUne erreur, et tout s'[UNI00e9]croule."
			)
		end
		flag_448 = event.get_save_flag(448) or flag_448
		if chapter == 4 and flag_448 == 0 then
			event.open_message_window_2(
				0,
				"Je suis peut-[UNI00ea]tre expert en\nd[UNI00e9]molition, mais quand il s'agit de\nr[UNI00e9]parer, j'ai deux mains gauches !"
			)
		end
		cutscene.talk(character_slot, -1, 0, 0)
	else
		triggered_character_slot = event.get_triggered_event_data_2(13) or triggered_character_slot
		partner_talk.open_companion_menu(triggered_character_slot, 3)
	end
end

--- Speaks NPC 2's chapter-dependent remarks when they are the current partner, otherwise opens the companion menu for them.
function partner_talk.speak_with_npc_2()
	local character_slot: s32 = 0
	local partner_id: s32 = 0
	local chapter: s32 = 0
	local flag_448: s32 = 0
	local triggered_character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	partner_id = event.get_party_npc() or partner_id
	if partner_id == 2 then
		message.set_window_mode(0, 1)
		event.open_message_window_2(0, "Quand je n'ai rien\n[UNI00e0] faire, je deviens de\nmauvaise humeur.")
		chapter = event.get_chapter() or chapter
		flag_448 = event.get_save_flag(448) or flag_448
		if chapter == 4 and flag_448 == 0 then
			event.open_message_window_2(
				0,
				"Les routes et les ponts sont\nvraiment mal faits ! T'as fait\nn'importe quoi ou quoi ? Pffff."
			)
		end
		if chapter == 3 then
			event.open_message_window_2(
				0,
				"Il faut faire de l'exercice souvent\npour [UNI00e9]viter les courbatures. Pour\nles machines c'est pareil..."
			)
		end
		cutscene.talk(character_slot, -1, 0, 0)
	else
		triggered_character_slot = event.get_triggered_event_data_2(13) or triggered_character_slot
		partner_talk.open_companion_menu(triggered_character_slot, 2)
	end
end

return partner_talk
