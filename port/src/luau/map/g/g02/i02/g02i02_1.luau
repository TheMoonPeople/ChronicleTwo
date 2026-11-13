--!strict
--- Event script for Lin's house in Balance Valley covering the sick Lin scenes and resident dialogue.

local vm = require("@lib/vm")
local balance_valley_lins_house = require("@lib/event/balance_valley_lins_house")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Lets the player use a medicine item on Lin and starts the recovery scene.
local function give_medicine_to_lin()
	local interaction_stage: s32 = 0
	local confirmed: s32 = 0
	local item: s32 = 0
	local party_npc_id: s32 = 0
	local party_status: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		interaction_stage = event.get_triggered_event_data_2(6) or interaction_stage
		if interaction_stage == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "It looks like Lin is in pain.\n(Press (#) to open Menu)")
			resume_step = 1
			confirmed = message.ask_confirmation(0, -1, 5, 0, 0, confirmed)
			if confirmed == 1 then
				interaction_stage = 2
			end
		end
		if interaction_stage == 2 then
			event.open_use_item_menu(364)
			resume_step = 2
			vm.wait(2)
			item = vmhost.used_item() or item
			if item == 364 then
				event.set_function_point_enabled("", "syumai", 0)
				event.set_function_point_enabled("", "event_550", 0)
				resume_step = 3
				balance_valley_lins_house.play_event_330()
				resume_step = 4
				balance_valley_lins_house.show_party_npc_message()
				resume_step = 5
				vm.wait(5)
				party_npc_id = event.get_party_npc() or party_npc_id
				party_status = event.get_npc_party_status(party_npc_id) or party_status
				if bit32.band(party_status, 4) ~= 0 then
					event.set_npc_party_status(party_npc_id, 4)
				else
					event.set_npc_party_status(party_npc_id, 2)
				end
				event.set_npc_party_status(26, 128)
				event.set_npc_party_status(26, 1)
			elseif item > 0 then
				resume_step = 6
				character.shake_head_at_camera()
			end
		end
		return
	end, function(received: { any })
		if resume_step <= 6 then
			if resume_step == 1 then
				confirmed = received[2] :: number
			end
			if resume_step <= 1 then
				local _ = interaction_stage == 1
				interaction_stage = 2
			end
			if resume_step <= 2 then
				resume_step = 3
				balance_valley_lins_house.play_event_330()
				return vm.continue_with(function()
					resume_step = 4
					balance_valley_lins_house.show_party_npc_message()
					resume_step = 5
					vm.wait(5)
					party_npc_id = event.get_party_npc() or party_npc_id
					party_status = event.get_npc_party_status(party_npc_id) or party_status
					if bit32.band(party_status, 4) ~= 0 then
						event.set_npc_party_status(party_npc_id, 4)
					else
						event.set_npc_party_status(party_npc_id, 2)
					end
					event.set_npc_party_status(26, 128)
					event.set_npc_party_status(26, 1)
					return
				end)
			end
			if resume_step <= 3 then
				balance_valley_lins_house.show_default_message()
			end
			if resume_step <= 5 then
				cutscene.do_nothing()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = balance_valley_lins_house.place_residents

--- Places the residents and plays the scene matching the story flags on entering the house.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local party_npc_id: s32 = 0
	local sound_id: s32 = 0
	balance_valley_lins_house.place_residents()
	flag = event.get_save_flag(300) or flag
	flag_2 = event.get_save_flag(304) or flag_2
	flag_3 = event.get_save_flag(306) or flag_3
	flag_4 = event.get_save_flag(324) or flag_4
	flag_5 = event.get_save_flag(328) or flag_5
	event.get_save_flag(330)
	if flag == 1 then
		if flag_2 == 0 then
			balance_valley_lins_house.play_event_304()
			return
		else
			party_npc_id = event.get_party_npc() or party_npc_id
			if flag_3 == 0 and party_npc_id == 6 then
				balance_valley_lins_house.play_event_306()
				event.set_npc_party_status(6, 2)
				event.skip_next_music_load()
				event.jump_to_map_3(-1, "g02", 503)
				vm.wait(3)
				return
			end
			if flag_4 == 1 and flag_5 == 0 then
				balance_valley_lins_house.play_event_328()
				return
			end
		end
	end
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 61)
	event.set_character_position(0, 8.0, 0.0, 120.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- Shows the party NPC message and restores the party NPC status.
function script.key_open()
	local party_npc_id: s32 = 0
	balance_valley_lins_house.show_party_npc_message()
	vm.wait(2)
	party_npc_id = event.get_party_npc() or party_npc_id
	event.set_npc_party_status(party_npc_id, 2)
	event.set_npc_party_status(26, 128)
	event.set_npc_party_status(26, 1)
end

--- Leaves the house by outside transition or map jump depending on the current map.
function script.exit_house()
	local current_map_number: s32 = 0
	current_map_number = event.get_current_map() or current_map_number
	if current_map_number == 1 then
		event.go_to_outside_map(-1, "g02", 100)
	else
		event.jump_to_map_3(-1, "g02", 100)
	end
	vm.wait(1)
end
script[200] = script.exit_house

--- Event 500, which map data, a script or the engine runs by number.
script.give_medicine_to_lin = give_medicine_to_lin
script[500] = script.give_medicine_to_lin

--- Turns the player toward Lin and shows her moaning.
function script.listen_to_lin_moaning()
	local player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local npc_x: f32 = 0
	local npc_z: f32 = 0
	local target_angle: f32 = 0
	local flag: s32 = 0
	print("550-------------------------------------------------")
	event.fade_out_screen(1)
	vm.wait(1)
	event.initialize_event()
	event.set_camera_position(9.08, 28.93, -152.07)
	event.set_camera_look_at(11.2, 18.91, -112.52)
	event.fade_in_screen(15)
	player_slot = event.get_player_character_slot() or player_slot
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	do
		local out1, _, out3 = event.get_character_position(player_slot)
		player_x = out1 or player_x
		player_z = out3 or player_z
	end
	npc_x = vm.f32(9.52)
	npc_z = vm.f32(-125.12)
	target_angle = event.get_look_angle(npc_x - player_x, npc_z - player_z) or target_angle
	character.turn_to_angle(player_slot, target_angle)
	event.set_character_rotation(player_slot, 0.0, target_angle, 0.0)
	event.set_character_motion(player_slot, "立ち")
	flag = event.get_save_flag(306) or flag
	if flag == 0 then
		event.open_message_window_2(0, "Ooooh...\nNnnnn... ahhhh...")
	else
		event.open_message_window_2(0, "Ohhh, ohhh...")
	end
	message.show(0, -1, 4, 256, 312)
	event.fade_out_screen(15)
	wait.frames(15)
	event.reset_follow_camera(1, 3.1415927)
	event.finish_event()
	event.fade_in_screen(15)
end
script[550] = script.listen_to_lin_moaning

--- Turns the player toward Shirooza and shows dialogue matching the story flags.
function script.talk_to_shirooza()
	local player_slot: s32 = 0
	local shirooza_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local npc_x: f32 = 0
	local npc_z: f32 = 0
	local target_angle: f32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	print("551-------------------------------------------------")
	player_slot = event.get_player_character_slot() or player_slot
	shirooza_slot = 24
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	do
		local out1, _, out3 = event.get_character_position(player_slot)
		player_x = out1 or player_x
		player_z = out3 or player_z
	end
	do
		local out1, _, out3 = event.get_character_position(shirooza_slot)
		npc_x = out1 or npc_x
		npc_z = out3 or npc_z
	end
	target_angle = event.get_look_angle(npc_x - player_x, npc_z - player_z) or target_angle
	character.turn_to_angle(player_slot, target_angle)
	event.set_character_rotation(player_slot, 0.0, target_angle, 0.0)
	event.set_character_motion(player_slot, "立ち")
	flag = event.get_save_flag(356) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			0,
			"Lin's gone off to study, hoo. Said\nshe won't be back till she becomes\na real sage.<page>But who decides when you get to\nbecome a sage anyway?<page>I don't care if she becomes a sage\nor not. I just want her to hurry\nand come back home. Hoo."
		)
	else
		flag_2 = event.get_save_flag(330) or flag_2
		if flag_2 ~= 0 then
			event.open_message_window_2(0, "You look after Lin, okay?\nAnd be careful, hoo.")
		else
			flag_3 = event.get_save_flag(324) or flag_3
			if flag_3 ~= 0 then
				event.open_message_window_2(0, "Hurry it up!<page>Give me a dumpling,\nquick, hoo!")
			else
				flag_4 = event.get_save_flag(317) or flag_4
				if flag_4 ~= 0 then
					event.open_message_window_2(0, "Haven't you got hold of the\nMiracle Dish yet?")
					message.say_bubble(0, -1, shirooza_slot, player_slot, 0)
					event.open_message_window_2(0, "Slowpoke, hoo, nincompoop!\nYou're good for nothing, hoooo!")
				else
					flag_5 = event.get_save_flag(320) or flag_5
					if flag_5 ~= 0 then
						event.open_message_window_2(0, 'You still don\'t have the, hoo,\n "White Windflower"?')
						message.say_bubble(0, -1, shirooza_slot, player_slot, 0)
						event.open_message_window_2(0, "Slowpoke, hoo, nincompoop!\nYou're good for nothing, hoooo!")
					else
						flag_6 = event.get_save_flag(306) or flag_6
						if flag_6 ~= 0 then
							event.open_message_window_2(0, "Hoo, Lao Chao Restaurant\nisn't restored hoo yet?")
							message.say_bubble(0, -1, shirooza_slot, player_slot, 0)
							event.open_message_window_2(0, "Slowpoke, hoo, nincompoop!\nYou're good for nothing, hoooo!")
						else
							event.open_message_window_2(0, "Bring a doctor quick, hoo.\nYou must bring one right away, hoo.")
						end
					end
				end
			end
		end
	end
	message.say_bubble(0, -1, shirooza_slot, player_slot, 0)
end
script[551] = script.talk_to_shirooza

--- Turns the player toward a villager and shows a greeting.
function script.talk_to_villager()
	local villager_slot: s32 = 0
	local player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local npc_x: f32 = 0
	local npc_z: f32 = 0
	local target_angle: f32 = 0
	print("KITA-------------------------------\n")
	villager_slot = event.get_triggered_event_data_2(13) or villager_slot
	player_slot = event.get_player_character_slot() or player_slot
	do
		local out1, _, out3 = event.get_character_position(player_slot)
		player_x = out1 or player_x
		player_z = out3 or player_z
	end
	do
		local out1, _, out3 = event.get_character_position(villager_slot)
		npc_x = out1 or npc_x
		npc_z = out3 or npc_z
	end
	target_angle = event.get_look_angle(npc_x - player_x, npc_z - player_z) or target_angle
	character.turn_to_angle(player_slot, target_angle)
	event.set_character_rotation(player_slot, 0.0, target_angle, 0.0)
	event.set_character_motion(player_slot, "立ち")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hello there.\nGreat weather, isn't it.")
	message.say_bubble(0, -1, villager_slot, player_slot, 0)
end
script[1000] = script.talk_to_villager

--- Resets the story flags and replays the scene where Lin falls ill.
function script.replay_first_meeting_scene()
	event.set_save_flag(304, 0)
	event.set_save_flag(306, 0)
	event.set_save_flag(324, 0)
	event.set_save_flag(330, 0)
	balance_valley_lins_house.place_residents()
	balance_valley_lins_house.play_event_304()
end
script[13040] = script.replay_first_meeting_scene

--- Sets the story flags and replays the scene that recruits the party NPC.
function script.replay_party_npc_scene()
	event.set_save_flag(304, 1)
	event.set_save_flag(306, 0)
	event.set_save_flag(324, 0)
	event.set_save_flag(330, 0)
	event.set_npc_party_status(6, 128)
	event.set_npc_party_status(6, 1)
	balance_valley_lins_house.place_residents()
	balance_valley_lins_house.play_event_306()
	event.jump_to_map_3(-1, "g02", 503)
	vm.wait(2)
end
script[13060] = script.replay_party_npc_scene

--- Sets the story flags and replays the scene where the party visits Shirooza.
function script.replay_shirooza_visit_scene()
	event.set_save_flag(304, 1)
	event.set_save_flag(306, 1)
	event.set_save_flag(324, 1)
	event.set_save_flag(330, 0)
	balance_valley_lins_house.place_residents()
	balance_valley_lins_house.play_event_328()
end
script[13280] = script.replay_shirooza_visit_scene

--- Sets the story flags and replays the recovery scene.
function script.replay_medicine_scene()
	event.set_save_flag(324, 1)
	event.set_save_flag(330, 0)
	balance_valley_lins_house.place_residents()
	balance_valley_lins_house.play_event_330()
end
script[13300] = script.replay_medicine_scene

return script
