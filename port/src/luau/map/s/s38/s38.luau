--!strict
--- Ixion guest room carriages with doors between carriages and passengers.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local ixion_guest_room = require("@lib/event/ixion_guest_room")
local map = require("@lib/event/map")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local npc = require("@lib/event/npc")
local party = require("@lib/event/party")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

--- Runs a conversation with a recruitable villager: frames the camera on them, shows a greeting and a menu to swap partners, hear a remark or start their own event.
local function open_companion_menu(character_slot: s32, fixed_npc_code: s32)
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
	if npc_id == 10 or npc_id == 18 then
		window_offset = 8
	end
	if npc_id == 1 or npc_id == 6 or npc_id == 17 then
		window_offset = 16
	end
	if npc_id == 2 or npc_id == 15 or npc_id == 16 or npc_id == 19 or npc_id == 20 or npc_id == 21 or npc_id == 22 then
		window_offset = 24
	end
	if npc_id == 3 or npc_id == 4 or npc_id == 5 or npc_id == 7 or npc_id == 8 or npc_id == 23 or npc_id == 24 then
		window_offset = 32
	end
	if npc_id == 9 or npc_id == 11 or npc_id == 13 then
		window_offset = 40
	end
	event.set_message_window_option(1, 4, 30, 60, 144, -1)
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
			message.show_villager_remark(3, npc_id)
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
				wait.for_frame_count(30)
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
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
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
						event.open_message_window_2(3, "よし、これで\n修理完了じゃ！")
						message.show(3, -1, 3, 256, 208)
						party.finish_recruit_talk(character_slot, fixed_npc_code)
						event.start_crossfade(10)
					end
					if not (npc_id == 4) then
						break
					end
					party.open_npc_menu_primary(character_slot, fixed_npc_code, 6)
					break
				end
				if selection == 3 then
					if npc_id == 1 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 23)
						return
					end
					if npc_id == 4 then
						if minigame.report_scoop_progress() ~= 0 then
							party.open_npc_menu_primary(character_slot, fixed_npc_code, 33)
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
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 0)
					end
					if npc_id == 12 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 1)
					end
					if npc_id == 6 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 2)
					end
					if npc_id == 7 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 3)
					end
					if npc_id == 2 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 7)
					end
					if npc_id == 3 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 8)
					end
					if npc_id == 5 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 9)
					end
					if npc_id == 8 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 10)
					end
					if npc_id == 10 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 11)
					end
					if npc_id == 11 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 12)
					end
					if npc_id == 13 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 13)
					end
					if npc_id == 16 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 14)
					end
					if npc_id == 18 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 15)
					end
					if npc_id == 19 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 16)
					end
					if npc_id == 20 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 17)
					end
					if npc_id == 21 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 18)
					end
					if npc_id == 22 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 19)
					end
					if npc_id == 23 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 20)
					end
					if npc_id == 24 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 21)
					end
					if npc_id == 25 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 22)
					end
					if npc_id == 17 then
						party.open_npc_menu_primary(character_slot, fixed_npc_code, 32)
					end
					if npc_id == 9 then
						message.show_story_hint()
						event.set_message_draw_speed(3, 0.6, 0.6)
						message.show(3, -1, 3, 256, 208)
						party.finish_recruit_talk(character_slot, fixed_npc_code)
						event.start_crossfade(10)
					end
					if npc_id == 14 then
						event.fade_out_screen(25)
						wait.for_frame_count(30)
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

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Loads the passengers and fades in.
function script.default_event()
	cutscene.noop()
	event.initialize_event()
	print("##IN_START_EVENT################################\n")
	ixion_guest_room.load_train_passengers()
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(1, 3)
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.key_open() end

--- Exits to the station through train door 1 when it is usable and otherwise shakes the head.
function script.use_door_1()
	local sound_id: s32 = 0
	local door_usable: s32 = 0
	print("--------------------------event200-------------------------\n")
	character.turn_player_to_rotation(vm.f32(-1.5707964))
	sound_id = event.get_sound_id(2) or sound_id
	door_usable = train.is_door_usable(1)
	if door_usable ~= 0 then
		event.set_character_motion(0, "立ち")
		event.play_sound_effect(sound_id, 94)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_save_counter(15, 1)
		character.delete_extra_slots()
		event.stop_music(0)
		map.jump_to_station()
	else
		ixion_guest_room.shake_head_at_camera()
	end
end
script[200] = script.use_door_1

--- Exits to the station through train door 0 when it is usable and otherwise shakes the head.
function script.use_door_0()
	local sound_id: s32 = 0
	local door_usable: s32 = 0
	print("--------------------------event201-------------------------\n")
	character.turn_player_to_rotation(vm.f32(1.5707964))
	sound_id = event.get_sound_id(2) or sound_id
	door_usable = train.is_door_usable(0)
	if door_usable ~= 0 then
		event.set_character_motion(0, "立ち")
		event.play_sound_effect(sound_id, 94)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_save_counter(15, 0)
		character.delete_extra_slots()
		event.stop_music(0)
		map.jump_to_station()
	else
		ixion_guest_room.shake_head_at_camera()
	end
end
script[201] = script.use_door_0

--- Walks to the previous carriage or the engine room.
function script.go_to_previous_carriage()
	local sound_id: s32 = 0
	local carriage_index: s32 = 0
	print("--------------------------event202-------------------------\n")
	character.turn_player_to_rotation(0.0)
	event.set_character_motion(0, "立ち")
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 94)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	character.delete_extra_slots()
	carriage_index = event.get_save_counter(0) or carriage_index
	if carriage_index == 1 then
		event.set_save_counter(0, 0)
		event.set_character_position(0, 0.0, -22.4, -207.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.jump_to_map_2(-1, "s37")
	else
		carriage_index = vm.i32(carriage_index - 1)
		event.set_save_counter(0, carriage_index)
		ixion_guest_room.load_train_passengers()
		event.set_character_position(0, 0.0, -14.0, -235.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.initialize_event()
		event.close_message_window(1)
		event.fade_in_screen(30)
		event.finish_event()
	end
end
script[202] = script.go_to_previous_carriage

--- Walks to the next carriage unless this is the last.
function script.go_to_next_carriage()
	local sound_id: s32 = 0
	local carriage_index: s32 = 0
	print("--------------------------event203-------------------------\n")
	character.turn_player_to_rotation(vm.f32(3.1415927))
	event.set_character_motion(0, "立ち")
	sound_id = event.get_sound_id(2) or sound_id
	carriage_index = event.get_save_counter(0) or carriage_index
	if carriage_index ~= 3 then
		event.set_character_motion(0, "立ち")
		event.play_sound_effect(sound_id, 94)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		character.delete_extra_slots()
		carriage_index = vm.i32(carriage_index + 1)
		event.set_save_counter(0, carriage_index)
		ixion_guest_room.load_train_passengers()
		event.set_character_position(0, 0.0, -14.0, 235.0)
		event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
		event.initialize_event()
		event.close_message_window(1)
		event.fade_in_screen(30)
		event.finish_event()
	else
		ixion_guest_room.shake_head_at_camera()
	end
end
script[203] = script.go_to_next_carriage

--- Opens the shop for the shopkeeper or the companion menu for another passenger.
function script.talk_to_passenger()
	local character_slot: s32 = 0
	local character_counter: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	character_counter = event.get_local_event_counter(character_slot) or character_counter
	if character_counter == 34 then
		npc.open_shop()
	else
		open_companion_menu(character_slot, 0)
	end
end
script[1000] = script.talk_to_passenger

return script
