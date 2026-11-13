--!strict
--- Holds the English companion conversations: camp menus, story hints and idle remarks.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")
local party = vm.module("@lib/event/party")
local scoop_exchange = vm.module("@lib/event/english/scoop_exchange")
local town_villagers = vm.module("@lib/event/english/town_villagers")
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
			event.open_message_window_2(0, "You want to leave?")
			resume_step = 2
			message.say_bubble(0, -1, character_slot, player_slot, 0)
			event.set_character_motion(character_slot, "立ち")
			event.set_message_bubble_tail(0, 0)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(0, "Yeah!\nI want to stay a little longer.")
			resume_step = 3
			leave_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 0)
			event.set_message_window_option(0, 0, 0)
			event.set_message_bubble_tail(0, 1)
			if leave_choice ~= 0 then
				event.set_character_motion(character_slot, "会話")
				event.open_message_window_2(0, "Umph, you go get 'em, ya hear!")
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
			event.open_message_window_2(0, "Be careful out there, you two.")
			remark_map_id = event.get_current_map() or remark_map_id
			flag_300 = event.get_save_flag(300) or flag_300
			if remark_map_id == 16 and flag_300 == 0 then
				event.open_message_window_2(0, "We're not ready to leave just yet...\nGive me a little more time.")
			end
			flag_400 = event.get_save_flag(400) or flag_400
			if remark_map_id == 54 and flag_400 == 0 then
				event.open_message_window_2(0, "We're not ready to leave just yet...\nGive me a little more time.")
			end
			flag_500 = event.get_save_flag(500) or flag_500
			if remark_map_id == 83 and flag_500 == 0 then
				event.open_message_window_2(0, "We're not ready to leave just yet...\nGive me a little more time.")
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
			event.open_message_window_2(3, "[(!)]You can't do that right now. You have\nto bring Lin to the lighthouse first!")
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
						event.open_message_window_2(3, "Alright, we're finished\nwith repairs!")
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
			event.open_message_window_2(3, "[(!)]You can't do that right now. You have\nto bring Lin to the lighthouse first!")
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
						event.open_message_window_2(3, "Alright, we're finished\nwith repairs!")
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
			"Seeing the Blackstone Railroad\noperate all over the continent is a\ndream both Need and I share.<page>We can count on you to help, right?"
		)
	end
	if npc_id == 2 then
		event.open_message_window_2(
			window,
			"If they discover Zelmite I'll\nbe real busy too. That's right.\nI'd dig, dig and dig some more!!"
		)
	end
	if npc_id == 3 then
		event.open_message_window_2(window, "There must be so many plants out\nthere we haven't even seen yet.")
	end
	if npc_id == 4 then
		event.open_message_window_2(window, "Hey! How goes the Zelmite hunt?\nIf there's anything I can do,\njust gimme a holler.")
	end
	if npc_id == 5 then
		event.open_message_window_2(
			window,
			"The world of pictures is very deep.\nIt may take me a lifetime to master\nbut the journey is well worth it."
		)
	end
	if npc_id == 6 then
		event.open_message_window_2(
			window,
			"It's fine if you spend your time\nhunting for Zelmite. Just don't\npush yourself too hard, kid."
		)
	end
	if npc_id == 7 then
		event.open_message_window_2(
			window,
			"I'm going to be the world's best\nchef someday, and when I do,\nyou can eat free anytime."
		)
	end
	if npc_id == 8 then
		event.open_message_window_2(window, "At long last the Blackstone\nRailroad takes on the world.\nIt's so exciting!")
	end
	if npc_id == 9 then
		event.open_message_window_2(window, "Hey, how ya doin'? I'm doin' great!")
	end
	if npc_id == 10 then
		event.open_message_window_2(window, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	if npc_id == 11 then
		event.open_message_window_2(window, "I pray for your safety...")
	end
	if npc_id == 12 then
		event.open_message_window_2(window, "If you're ever in the mood for\nbread, you know where to find me.")
	end
	if npc_id == 13 then
		event.open_message_window_2(window, "You really like all this\nadventure, don't ya.")
	end
	if npc_id == 14 then
		event.open_message_window_2(window, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	if npc_id == 15 then
		event.open_message_window_2(window, "So, what's the scoop? Come across\nany tough guys in that mine yet?")
	end
	if npc_id == 16 then
		event.open_message_window_2(
			window,
			"From now on I'm going to be helping\nNeed and Cedric rebuild the world.\nWe have to work together on this."
		)
	end
	if npc_id == 17 then
		event.open_message_window_2(
			window,
			"Just on a personal note here, I\nknow Zelmite Mine is a dangerous\nplace. Don't do anything foolish."
		)
	end
	if npc_id == 18 then
		event.open_message_window_2(window, "I pray that the world will\nfrom today forever be at peace.")
	end
	if npc_id == 19 then
		event.open_message_window_2(
			window,
			"If the Blackstone Railroad goes all\nover the world, we'll be able to\nvisit lots of cool new places."
		)
	end
	if npc_id == 20 then
		event.open_message_window_2(
			window,
			"I can't wait to check out all the\nnew fishing spots all over the\nworld. It's gonna be so fun."
		)
	end
	if npc_id == 21 then
		event.open_message_window_2(
			window,
			"I just wish that Fabio would have\na bit of an interest in something\noutside of fishing, too."
		)
	end
	if npc_id == 22 then
		event.open_message_window_2(window, "I've got a bad feeling about Zelmite Mine.\nJust be careful, okay?")
	end
	if npc_id == 23 then
		event.open_message_window_2(
			window,
			"If the Blackstone Railroad spreads\nall around the world, maybe I'll\nhave to go around the world too."
		)
	end
	if npc_id == 24 then
		event.open_message_window_2(
			window,
			"You can't fool me. I know you've\nbeen off doing all sorts of fun\nstuff. Tell me about it sometime!"
		)
	end
	if npc_id == 25 then
		event.open_message_window_2(
			window,
			'When the Blackstone Railroad is\nall done, I\'d just love to \ngo to the "Ends of the Earth".'
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
		event.open_message_window_2(3, "Great job! Humans\naren't so bad after all!<page>I was wrong!")
		return
	end
	story_flag = event.get_save_flag(728) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"This is it. It's almost over.\nAll we have to do is defeat him.<page>And after that, the world can live again."
		)
		return
	end
	story_flag = event.get_save_flag(712) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"I guess I know how Griffon feels, but I don't\nthink I could ever forgive him for what he did."
		)
		return
	end
	story_flag = event.get_save_flag(702) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Return the garden to its former state, and\nexpose the secret of Griffon, I mean, Sirus.")
		return
	end
	story_flag = event.get_save_flag(700) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"I wonder what she means, \"Sirus' memories.\"\nI guess we'll have to enter the palace to find out."
		)
		return
	end
	story_flag = event.get_save_flag(640) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"Griffon'll get away if we just stand around like\nthis. Let's get to the Moon Flower Palace, quick."
		)
		return
	end
	gem_flag_1 = event.get_save_flag(624) or gem_flag_1
	gem_flag_2 = event.get_save_flag(628) or gem_flag_2
	gem_flag_3 = event.get_save_flag(632) or gem_flag_3
	gem_flag_4 = event.get_save_flag(636) or gem_flag_4
	if (if (if (if gem_flag_1 ~= 0 then gem_flag_2 else 0) ~= 0 then gem_flag_3 else 0) ~= 0 then gem_flag_4 else 0) ~= 0 then
		event.open_message_window_2(3, "Looks like we got all the gems. Now we\njust have to hurry to Kazarov Stonehenge.")
		return
	end
	story_flag = event.get_save_flag(616) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Whatever it is, we better find the gems\nquick, before it's too late.")
		return
	end
	story_flag = event.get_save_flag(600) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Everything started at this palace, huh.\nAnyway, let's head into the garden.")
		return
	end
	story_flag = event.get_save_flag(540) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "We better head back to Luna Lab soon.\nThey may be finished with Ixion already.")
		return
	end
	story_flag = event.get_save_flag(536) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "It's about time to strike back against\nGriffon. Let's head over to the Paznos base.")
		return
	end
	story_flag = event.get_save_flag(526) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Don't just stand there!\nWe got to rescue Monica, fast!")
		return
	end
	story_flag = event.get_save_flag(524) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Remember? Galen Agaris said that if you\nplay the Fire Horn the road will open up.")
		return
	end
	story_flag = event.get_save_flag(520) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Don't just stand there!\nWe got to rescue Monica, fast!")
		return
	end
	story_flag = event.get_save_flag(508) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "Gotta blow that Firesquall to bits.<page>So it's up there on top of Mt. Gundor, huh?")
		return
	end
	event.open_message_window_2(
		3,
		"Just waiting here won't change anything.<page>There's got to be some places we haven't been to yet."
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
			"I love the smell of gunpowder!\nThis job is really made for me.<page>Then again, my boss is awfully\nstubborn and old-fashioned.\nOh, well."
		)
		chapter = event.get_chapter() or chapter
		flag_280 = event.get_save_flag(280) or flag_280
		if chapter == 2 and flag_280 == 0 then
			event.open_message_window_2(0, "One Final Bomb and a boulder\nlike this would be history.")
		end
		flag_372 = event.get_save_flag(372) or flag_372
		if chapter == 3 and flag_372 == 0 then
			event.open_message_window_2(
				0,
				"Mind you, blastin' is no cakewalk\neither. One tiny slip-up and you\nbring the whole house down."
			)
		end
		flag_448 = event.get_save_flag(448) or flag_448
		if chapter == 4 and flag_448 == 0 then
			event.open_message_window_2(0, "I may be a demolitions expert,\nbut when it comes to repairs,\nI'm all thumbs!")
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
		event.open_message_window_2(0, "If I don't have my hands in\nsomething at all times,\nI get real cranky.")
		chapter = event.get_chapter() or chapter
		flag_448 = event.get_save_flag(448) or flag_448
		if chapter == 4 and flag_448 == 0 then
			event.open_message_window_2(0, "The roads and the bridges are\nall out of whack! What were\nyou thinking? Geez...")
		end
		if chapter == 3 then
			event.open_message_window_2(
				0,
				"You know how you go to exercise\nevery day or you get all stiff and\nachy? Same thing goes for machines."
			)
		end
		cutscene.talk(character_slot, -1, 0, 0)
	else
		triggered_character_slot = event.get_triggered_event_data_2(13) or triggered_character_slot
		partner_talk.open_companion_menu(triggered_character_slot, 2)
	end
end

return partner_talk
