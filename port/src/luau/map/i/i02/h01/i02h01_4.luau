--!strict
--- Train Town Cedric's train house script that handles entry, boarding the train and villager dialogue.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local shop_greeting = require("@lib/event/italian/shop_greeting")
local train = require("@lib/event/train")
local train_town_cedric_train = require("@lib/event/train_town_cedric_train")
local wait = require("@lib/event/wait")

--- Asks whether to go inside the train, returning 1 for the first option and 0 when cancelled or after the second option opens its event menu.
local function ask_to_board_train()
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.initialize_event()
		message.set_window_mode(0, 4)
		event.open_message_window_2(0, "Entra\nParti")
		resume_step = 1
		choice = message.open_and_ask_choice(0, -1, 5, 256, 208, 2, 0)
		if choice == -1 then
			message.set_window_mode(0, 1)
			return 0
		end
		if choice == 1 then
			event.fade_out_screen(15)
			resume_step = 2
			wait.frames(15)
			event.open_event_menu(19, 0)
			resume_step = 3
			vm.wait(3)
			event.fade_in_screen(15)
			resume_step = 4
			wait.frames(15)
			return 0
		end
		return 1
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			message.set_window_mode_skipping(0, 1)
			return 0
		end
		if resume_step <= 4 then
			if resume_step <= 3 then
				wait.frames_skipping(15)
			end
			return 0
		end
		return nil
	end)
end

--- Shows the villager's dialogue, choosing the lines from the chapter, story flags and the character that was spoken to.
local function talk_to_villager()
	local villager_slot: s32 = 0
	local villager_id: s32 = 0
	local message_group: s32 = 0
	local message_index: s32 = 0
	local message_variant: s32 = 0
	local playable_character: s32 = 0
	local chapter: s32 = 0
	local train_restored_flag: s32 = 0
	local monica_returned_flag: s32 = 0
	local playable_character_61: s32 = 0
	local playable_character_80: s32 = 0
	event.get_player_character_slot()
	villager_slot = event.get_triggered_event_data_2(13) or villager_slot
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	print("talk_chara_id=", villager_slot, "talk_chara=", villager_id, "\n")
	do
		local out1, out2 = event.get_message_window_option(0, 3, villager_id)
		message_group = out1 or message_group
		message_index = out2 or message_index
	end
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		message_variant = 2
	else
		message_variant = 1
	end
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	if villager_id == 1012 or villager_id == 1015 or villager_id == 1018 then
		shop_greeting.greet_and_open_shop()
		event.set_villager_ai_enabled(1, villager_slot)
		return
	end
	if villager_id == 50 then
		event.open_message_window_2(0, "Ehi! Non [UNI00e8] permesso\noltrepassare questo punto.")
		cutscene.talk(villager_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, villager_slot)
		return
	end
	chapter = event.get_chapter() or chapter
	if chapter == 1 then
		train_restored_flag = event.get_save_flag(9) or train_restored_flag
		if villager_id == 2 then
			if train_restored_flag == 0 then
				event.open_message_window_2(
					0,
					"Dai un'occhiata qui! Difficile\ncredere che un tempo filava\nche era una bellezza, vero?<page>Proprio cos[UNI00ec]... molto tempo fa.<page>Il mio sogno [UNI00e8] di rifarci un bel\nviaggetto! Ecco perch[UNI00e9] cerco\ndi tenerlo in perfetta forma.<page>Cos[UNI00ec], appena possibile,\n"
				)
			else
				event.open_message_window_2(
					0,
					"Sai che devi fare esercizio tutti\ni giorni per restare in forma, no?\nLo stesso vale con le macchine."
				)
			end
			cutscene.talk(villager_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_slot)
			return
		end
		if villager_id == 63 then
			if train_restored_flag == 0 then
				event.open_message_window_2(
					0,
					"Ehi salve, Max!\nLa ferrovia non funziona\nda parecchio tempo.<page>Ma io continuo a vigilare\nsulla stazione, tutti i giorni."
				)
			else
				event.open_message_window_2(
					0,
					"Il Sindaco si [UNI00e8] finalmente mosso:\nha fatto ripartire i treni.\nMa non sono aperti al pubblico!<page>Cavoli, non vedo l'ora di farci\nsalire gli abitanti della citt[UNI00e0]..."
				)
			end
			cutscene.talk(villager_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_slot)
			return
		end
		if villager_id == 65 then
			if train_restored_flag == 0 then
				event.open_message_window_2(
					0,
					"Ciao, Max. Sapevi che il\ncapostazione [UNI00e8] il mio pap[UNI00e0]?\nSorvegliamo la stazione insieme.<page>Aspettiamo che questa ferrovia\nriprenda a funzionare..."
				)
			else
				event.open_message_window_2(
					0,
					"Il treno funziona!\nMa ci vorr[UNI00e0] del tempo prima\nche la stazione torni com'era..."
				)
			end
			cutscene.talk(villager_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_slot)
			return
		end
	end
	if chapter == 8 then
		monica_returned_flag = event.get_save_flag(804) or monica_returned_flag
		if villager_id == 61 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"Sono un ammiratore segreto\ndi Monica da tempo, ma\nnon la vedo da un po'.<page>Per questo non riesco a\nconcentrarmi sul lavoro!"
				)
			else
				playable_character_61 = event.get_playable_character() or playable_character_61
				if playable_character_61 ~= 1 then
					event.open_message_window_2(0, "Ehi, Max!\nSembra che Monica sia tornata.\nNe saranno tutti felici!")
				else
					event.open_message_window_2(0, "Monica! Dove sei stata?\nMi sei mancata tanto!")
				end
			end
			cutscene.talk(villager_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_slot)
			return
		end
		if villager_id == 80 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"Avevo appena trovato il coraggio\ndi parlare a Monica normalmente,\nquando [UNI00e8] scomparsa.<page>Dai, Max...\ndimmi dov'[UNI00e8]... ti prego!"
				)
			else
				playable_character_80 = event.get_playable_character() or playable_character_80
				if playable_character_80 ~= 1 then
					event.open_message_window_2(0, "Monica [UNI00e8] tornata.\nCom'[UNI00e8] possibile?!?")
				else
					event.open_message_window_2(0, "Monica, sei tornata!\nCom'[UNI00e8] possibile?!?")
				end
			end
			cutscene.talk(villager_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_slot)
			return
		end
	end
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(message_group * 10000) + vm.i32(message_index * 10)) + message_variant))
	cutscene.talk(villager_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_slot)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = train_town_cedric_train.initialize_train_house

--- Places the player and starts the train arrival scene depending on where they came from and the chapter.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_number: s32 = 0
	local previous_map_type: s32 = 0
	local save_counter: s32 = 0
	local chapter: s32 = 0
	event.initialize_event()
	train_town_cedric_train.initialize_train_house()
	print("start_event--------------------------------------------\n")
	memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
	if memory_card_load_state == 1 then
		event.set_character_position(0, -240.0, 35.8, 140.0)
		event.set_character_rotation(0, 0.0, 3.14, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 3.14, 20.0)
	else
		previous_map_number = event.get_previous_map() or previous_map_number
		previous_map_type = event.get_map_type(previous_map_number) or previous_map_type
		if previous_map_type ~= -1 then
			if previous_map_number == 10 or previous_map_number == 22 or previous_map_number == 121 then
				event.set_character_position(0, 0.0, 198.8, 1450.0)
				event.set_character_rotation(0, 0.0, 3.14, 0.0)
				event.reset_follow_camera(1, 3.14)
				event.fade_in_screen(30)
			else
				save_counter = event.get_save_counter(1) or save_counter
				if (previous_map_number == 18 or previous_map_number == 23 or previous_map_number == 120 or previous_map_number == 108) and save_counter == 1 then
					train.place_player_at_saved_platform()
					event.fade_in_screen(15)
					event.reset_follow_camera(1, 0.0)
				else
					chapter = event.get_chapter() or chapter
					if chapter ~= 6 and chapter ~= 7 then
						train_town_cedric_train.play_train_arrival_scene()
					else
						train_town_cedric_train.play_late_chapter_train_arrival_scene()
					end
				end
			end
		end
		event.set_character_motion(0, "立ち")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = train_town_cedric_train.play_late_chapter_train_arrival_scene

--- Event 151, which map data, a script or the engine runs by number.
script[151] = train_town_cedric_train.play_train_departure_event

--- Shows the train from a fixed camera until a button is pressed, then moves the train away and restores the follow camera.
function script.cutscene_view_train()
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		resume_step = 1
		vm.wait(1)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			train_x = out1 or train_x
			train_y = out2 or train_y
			train_z = out3 or train_z
		end
		print("pos[0]=", vm.float(train_x), "-----------\n")
		print("pos[1]=", vm.float(train_y), "-----------\n")
		print("pos[2]=", vm.float(train_z), "-----------\n")
		event.set_object_handle_position(0, train_x, train_y, 0.0)
		event.set_character_active(0, 122)
		event.set_character_active(0, 123)
		event.set_character_active(0, 0)
		event.set_camera_position(-345.21, 89.08, 234.02)
		event.set_camera_look_at(-238.57, 83.73, 148.63)
		resume_step = 2
		vm.wait(2)
		resume_step = 3
		wait.until_button_pressed(64)
		event.set_character_active(1, 122)
		event.set_character_active(1, 123)
		event.set_character_active(1, 0)
		event.set_object_handle_position(0, train_x, train_y, -1800.0)
		event.set_object_handle_rotation(0, 0.0, 3.1415927, 0.0)
		event.reset_follow_camera(0)
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				print("pos[0]=", vm.float(train_x), "-----------\n")
				print("pos[1]=", vm.float(train_y), "-----------\n")
				print("pos[2]=", vm.float(train_z), "-----------\n")
			end
			if resume_step <= 2 then
				wait.until_button_pressed_skipping(64)
			end
			return 0
		end
		return nil
	end)
end
script[160] = script.cutscene_view_train

--- Leaves the train house by jumping to map m02.
function script.leave_train_house()
	vm.wait(1)
	event.jump_to_map_2(-1, "m02")
	vm.wait(2)
	event.call_command(103, 1645.1, -41.3, -1812.6) -- retail: the handler rejects 3 arguments
	event.call_command(104, 0, -0.09, 0) -- retail: the handler rejects 3 arguments
end
script[200] = script.leave_train_house

--- Shows Max thinking about the train until a save flag is set, then asks to board and sends the player to the destination for the chapter and trigger data.
function script.examine_train()
	local train_intro_flag: s32 = 0
	local boarding_choice: s32 = 0
	local chapter: s32 = 0
	local trigger_data: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		train_intro_flag = event.get_save_flag(202) or train_intro_flag
		if train_intro_flag == 0 then
			resume_step = 1
			character.turn_to_rotation(0, vm.f32(1.57))
			message.set_window_mode(0, 1)
			event.open_message_window_2(
				0,
				"Cedric chiama questo\nmarchingegno 'treno'...<page>Erik e Borneo lo usano\ncome casa.<page>Cedric dice che prima, molto prima\nche io nascessi, si muoveva.<page>[UNI00c8] vero?"
			)
			resume_step = 2
			message.show_and_wait(0, -1, 5, 256, 208)
			event.open_message_window_2(
				0,
				"Cos[UNI00ec] grande e pu[UNI00f2] muoversi?<page>Se si muovesse,\nmi piacerebbe proprio vederlo!"
			)
			resume_step = 3
			message.show_and_wait(0, -1, 5, 256, 208)
			return
		end
		resume_step = 4
		boarding_choice = ask_to_board_train()
		if boarding_choice ~= 1 then
			return
		end
		event.set_save_counter(1, 1)
		chapter = event.get_chapter() or chapter
		trigger_data = event.get_triggered_event_data_2(3) or trigger_data
		if trigger_data <= 1 then
			if chapter ~= 6 and chapter ~= 7 then
				resume_step = 5
				train.board_short_train()
				event.stop_music(0)
				resume_step = 6
				vm.wait(6)
				event.jump_to_map_2(-1, "s08")
			else
				resume_step = 7
				train.board_short_train()
				event.stop_music(0)
				resume_step = 8
				vm.wait(8)
				event.jump_to_map_2(-1, "s37")
			end
			resume_step = 9
			vm.wait(9)
		elseif chapter ~= 6 and chapter ~= 7 then
			resume_step = 10
			train.board_train(0)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			resume_step = 11
			train.board_train_via_gangway()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				message.set_window_mode_skipping(0, 1)
				message.show_and_wait_skipping(0, -1, 5, 256, 208)
			end
			if resume_step <= 2 then
				message.show_and_wait_skipping(0, -1, 5, 256, 208)
			end
			return 0
		end
		if resume_step <= 4 then
			if resume_step == 4 then
				boarding_choice = received[1] :: number
			end
			return 0
		end
		if resume_step <= 11 then
			if resume_step <= 6 then
				train.board_train_skipping()
			end
			if resume_step <= 9 then
				train.board_train_skipping_primary(0)
			end
			if resume_step <= 10 then
				train.board_train_via_gangway_skipping()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.examine_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Plays the train departure scene and enters the dungeon.
function script.cutscene_train_departure_then_enter_dungeon()
	local scene_character_slot: s32 = 0
	scene_character_slot = event.find_scene_character_slot(2) or scene_character_slot
	event.set_character_active(0, scene_character_slot)
	event.set_villager_ai_enabled(0, scene_character_slot)
	train_town_cedric_train.play_train_departure_event()
	event.go_to_dungeon(0, -1, 1000)
end
script[500] = script.cutscene_train_departure_then_enter_dungeon

--- Event 1000, which map data, a script or the engine runs by number.
script.talk_to_villager = talk_to_villager
script[1000] = script.talk_to_villager

return script
