--!strict
--- Veniccio station script covering the arrival cutscenes, boarding trains and the departure to the next town.

local vm = require("@lib/vm")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local partner_talk = require("@lib/event/english/partner_talk")
local party = require("@lib/event/party")
local town_prompt = require("@lib/event/english/town_prompt")
local train = require("@lib/event/train")
local veniccio_station = require("@lib/event/veniccio_station")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads Max, Monica and the station cutscene models in the slots for the active character.
local function load_station_cutscene_party()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e400/e448/e448_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e400/e448/e448_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e400/e448/e448_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e400/e448/e448_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "chara/p01_03a.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "chara/p01_06a.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_2(4, "p01_train01")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.load_message_file(0, 5, "event/e400/e448/e448_1.txt")
end

--- Unloads the cutscene models and places the player at the station.
local function unload_station_cutscene_party()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(37)
	end
	event.delete_character(38)
	event.delete_character(39)
	event.set_character_position(0, -1952.44, 29.22, -304.96)
	event.set_character_rotation(0, 0.0, 1.62, 0.0)
end

--- Plays the cutscene where Max and Monica meet the station staff.
local function play_station_meeting_cutscene()
	local sound_bank: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4220)
		sound_bank = event.load_sound_effect_file_2(4220) or sound_bank
		load_station_cutscene_party()
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(-1979.65, 91.43, -121.02)
		event.set_camera_sequence_look_at(-1941.55, 74.53, -339.62)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.set_object_sequence_position(1, -1838.01, 8.0, -560.01)
		event.set_object_sequence_rotation(1, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(0, -1904.92, 17.42, -503.6)
		event.set_object_sequence_rotation(0, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(2, -2186.89, 29.22, -198.9)
		event.set_object_sequence_rotation(2, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(3, -2223.98, 29.22, -196.3)
		event.set_object_sequence_rotation(3, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(4, -912.1, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
		event.fade_in_screen(30)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 60)
		event.add_object_sequence_path_point(0, -1904.92, 17.42, -503.6)
		event.add_object_sequence_path_point(0, -1985.4, 29.22, -393.12)
		event.start_object_sequence_path(0, 1)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 60)
		event.add_object_sequence_path_point(1, -1838.01, 8.0, -560.01)
		event.add_object_sequence_path_point(1, -1922.88, 29.4, -436.71)
		event.start_object_sequence_path(1, 1)
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_camera_sequence_position(-2052.02, 160.14, -365.82)
		event.set_camera_sequence_look_at(-2179.63, 74.53, -268.32)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 120)
		event.add_object_sequence_path_point(1, -2199.24, 29.22, -360.0)
		event.add_object_sequence_path_point(1, -2199.24, 29.22, -253.55)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 120)
		event.add_object_sequence_path_point(0, -2216.55, 29.22, -360.0)
		event.add_object_sequence_path_point(0, -2216.55, 29.22, -253.55)
		event.start_object_sequence_path(0)
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced(4481130)
		event.set_object_sequence_motion(2, "立ち")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		message.show_voiced(4481140)
		event.set_object_sequence_motion(3, "会話", 2)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		message.show_voiced(4481150)
		event.set_object_sequence_motion(3, "立ち")
		wait.frames(30)
		event.set_object_sequence_position(1, -1935.53, 29.22, -301.43)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(0, -1952.44, 29.22, -304.96)
		event.set_object_sequence_rotation(0, 0.0, 1.08, 0.0)
		event.set_camera_sequence_position(-1949.04, 34.26, -256.22)
		event.set_camera_sequence_look_at(-1934.01, 87.78, -397.48)
		event.set_object_sequence_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4481160)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 25)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4481170)
		event.reset_mouth_texture_animations()
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait.frames(35)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	unload_station_cutscene_party()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Handles talking to a station character and tells whether the party leaves.
local function talk_to_station_npc()
	local npc_id: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		if npc_id == 1 then
			resume_step = 1
			return partner_talk.offer_leave_or_speak_with_npc_1()
		end
		if npc_id == 2 then
			resume_step = 2
			partner_talk.speak_with_npc_2()
		end
		if npc_id == 13 then
			resume_step = 3
			partner_talk.speak_with_npc_13()
		end
		if npc_id == 301 then
			resume_step = 4
			town_prompt.say_waiting_outside()
		end
		return 0
	end, function(received: { any })
		if resume_step <= 1 then
			return veniccio_station.run_prompt_event_map()
		end
		if resume_step <= 4 then
			if resume_step <= 2 then
				party.skip_talk_to_blaster()
			end
			if resume_step <= 3 then
				party.skip_talk_to_waiting_npc()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing for this map.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default map setup.
function script.skip_default_setup() end
script[99] = script.skip_default_setup

--- Plays the arrival matching how the player came to the station.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local map_type: s32 = 0
	local train_station_counter: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local chapter: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		print("START_EVENT----------------------------")
		veniccio_station.initialize_station()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, -1820.0, 29.2, -335.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			map_type = event.get_map_type() or map_type
			if map_type ~= -1 then
				if old_map_no == 2 or old_map_no == 75 then
					resume_step = 1
					veniccio_station.run_into_station()
				else
					train_station_counter = event.get_save_counter(1) or train_station_counter
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and train_station_counter == 4
					then
						train.place_player_at_saved_platform()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						flag = event.get_save_flag(360) or flag
						flag_2 = event.get_save_flag(400) or flag_2
						if flag == 1 and flag_2 == 0 then
							resume_step = 2
							veniccio_station.play_first_arrival()
						else
							event.set_character_active(0, 9)
							chapter = event.get_chapter() or chapter
							if chapter ~= 6 and chapter ~= 7 then
								resume_step = 3
								veniccio_station.play_steam_train_arrival()
							else
								resume_step = 4
								veniccio_station.play_train_arrival()
							end
							event.set_character_active(1, 9)
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
			end
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				train.skip_place_player_at_saved_platform()
				resume_step = 2
				veniccio_station.play_first_arrival()
				return vm.continue_with(function()
					return
				end)
			end
			if resume_step <= 2 then
				resume_step = 3
				veniccio_station.play_steam_train_arrival()
				return vm.continue_with(function()
					event.set_character_active(1, 9)
					return
				end)
			end
			if resume_step <= 3 then
				wait.skip_short_pause()
			end
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = veniccio_station.play_train_arrival

--- Leaves the station for the town exit after confirmation.
function script.leave_station()
	if veniccio_station.confirm_leave_station() ~= 0 then
		event.jump_to_map_2(-1, "g03")
	end
end
script[201] = script.leave_station

--- Asks to board a train and starts the matching departure.
function script.board_train()
	local answer: s32 = 0
	local chapter: s32 = 0
	local train_route: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		answer = town_prompt.ask_enter_or_leave()
		if answer ~= 1 then
			return
		end
		event.set_save_counter(1, 4)
		chapter = event.get_chapter() or chapter
		train_route = event.get_triggered_event_data_2(3) or train_route
		if train_route <= 1 then
			if chapter ~= 6 and chapter ~= 7 then
				resume_step = 2
				train.board_short_train()
				event.stop_music(0)
				resume_step = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				resume_step = 4
				train.board_short_train()
				event.stop_music(0)
				resume_step = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			resume_step = 6
			vm.wait(6)
		elseif chapter ~= 6 and chapter ~= 7 then
			resume_step = 7
			train.board_train(0)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			resume_step = 8
			train.board_train_via_gangway()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			return 0
		end
		if resume_step <= 8 then
			if resume_step <= 3 then
				train.board_train_skipping()
			end
			if resume_step <= 6 then
				train.board_train_skipping_primary(0)
			end
			if resume_step <= 7 then
				train.board_train_via_gangway_skipping()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.board_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Sets up the station and plays the station meeting cutscene.
function script.cutscene_station_meeting()
	veniccio_station.initialize_station()
	play_station_meeting_cutscene()
end
script[500] = script.cutscene_station_meeting

--- Talks to the station character and sends the party off on the steam train when ready.
function script.talk_to_station_npc_and_depart()
	local departure_requested: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		departure_requested = talk_to_station_npc()
		if departure_requested == 1 then
			resume_step = 2
			veniccio_station.play_starbre_send_off()
			resume_step = 3
			veniccio_station.play_steam_train_departure(1)
			event.open_event_menu(13, 9)
			resume_step = 4
			vm.wait(4)
			event.skip_next_music_load()
			event.jump_to_map_2(-1, "s10")
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 1 then
				departure_requested = received[1] :: number
			end
			if resume_step <= 1 then
				resume_step = 2
				veniccio_station.play_starbre_send_off()
				return vm.continue_with(function()
					resume_step = 3
					veniccio_station.play_steam_train_departure(1)
					event.open_event_menu(13, 9)
					resume_step = 4
					vm.wait(4)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			if resume_step <= 2 then
				resume_step = 3
				veniccio_station.play_steam_train_departure(1)
				return vm.continue_with(function()
					event.open_event_menu(13, 9)
					resume_step = 4
					vm.wait(4)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_station_npc_and_depart

--- Sets up the station and replays the first arrival.
function script.replay_first_arrival()
	veniccio_station.initialize_station()
	veniccio_station.play_first_arrival()
end
script[14000] = script.replay_first_arrival

--- Replays the send-off and steam train departure.
function script.replay_departure()
	local resume_step: number = 0
	return vm.guard(function()
		veniccio_station.initialize_station()
		resume_step = 1
		veniccio_station.play_starbre_send_off()
		resume_step = 2
		veniccio_station.play_steam_train_departure(1)
		event.open_event_menu(13, 9)
		resume_step = 3
		vm.wait(3)
		event.skip_next_music_load()
		event.jump_to_map_2(-1, "s10")
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				resume_step = 2
				veniccio_station.play_steam_train_departure(1)
				return vm.continue_with(function()
					event.open_event_menu(13, 9)
					resume_step = 3
					vm.wait(3)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[14520] = script.replay_departure

return script
