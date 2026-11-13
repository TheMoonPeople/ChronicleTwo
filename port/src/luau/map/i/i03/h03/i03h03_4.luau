--!strict
--- Fishing Town fishing contest hall script that handles the weigh-in, the results ceremony and contestant dialogue.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local fishing_town_fishing_tournament = require("@lib/event/fishing_town_fishing_tournament")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local npc = require("@lib/event/npc")
local wait = require("@lib/event/wait")

local number_image: s32 = 0
local fish_name_image: s32 = 0
local contest_sound_bank: s32 = 0
local results_sound_bank: s32 = 0

--- Loads the trophy, the host and the contestant villagers and the number and fish name textures for the hall.
local function load_contest_participants()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "event/e00/e70/cup.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.load_character(4, "chara/p01_28a.gltf", "info", 8)
	npc.load_villager(8, 156, vm.f32(-54.41), vm.f32(43.91), vm.f32(29.63), vm.f32(0.36))
	number_image = event.load_event_image_4(4, "textures/event/e00/e75/suuji_1.json", 0) or number_image
	fish_name_image = event.load_event_image_4(4, "textures/event/e00/e75/gyoname_1.json", 1) or fish_name_image
	npc.load_villager(10, 163, -105.0, 0.0, -340.0, vm.f32(-2.81))
	npc.load_villager(11, 170, -432.0, 0.0, 25.0, vm.f32(-1.4))
	npc.load_villager(12, 166, vm.f32(-206.4), 0.0, vm.f32(100.9), vm.f32(1.8))
	npc.load_villager(14, 172, -199.5, 0.0, vm.f32(126.9), vm.f32(1.63))
	npc.load_villager(15, 164, vm.f32(48.9), 0.0, vm.f32(376.2), vm.f32(3.11))
	npc.load_villager(16, 157, vm.f32(214.9), 0.0, vm.f32(-103.6), vm.f32(-1.15))
end

--- Fades out and leaves the contest hall by jumping to map s45.
local function leave_contest_area()
	event.initialize_event()
	event.set_menu_value(1)
	event.fade_out_music(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.stop_music(0)
	fishing_town_fishing_tournament.clean_up_event()
	event.fade_in_screen(30)
	event.jump_to_map_2(-1, "s45")
	vm.wait(2)
end

--- Plays the results ceremony with the ranking board and podium, awards the prize and then leaves the contest hall.
local function announce_tournament_results()
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { s32 } = table.create(48, 0)
	local resume_step: number = 0
	return vm.guard(function()
		event.load_character_motion_pack(4, "event/e00/e70/e70_mints.gltf", "info", 0)
		results_sound_bank = 0
		results_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or results_sound_bank
		event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
		event.play_sound_effect(contest_sound_bank, 0)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-76.78, 102.98, 360.23, -174.91, 58.62, 77.17)
		event.add_camera_sequence_path_point(-76.78, 102.98, 360.23, 62.03, 58.62, 92.93)
		event.start_camera_sequence_path()
		resume_step = 1
		camera.wait_until_done()
		event.attach_object_handle_to_map_part_2(8, "p16_i03h03")
		event.set_object_handle_visible(8, 0)
		event.set_camera_sequence_position(-5.99, 55.55, -213.4)
		event.set_camera_sequence_look_at(0.0, 55.55, -471.19)
		resume_step = 2
		wait.frames(30)
		event.move_camera_sequence(-5.99, 181.46, -213.4, 0.0, 181.46, -471.19, 180)
		resume_step = 3
		camera.wait_until_done()
		event.stop_sound_effect(contest_sound_bank, 0)
		event.play_sound_effect(contest_sound_bank, 3)
		resume_step = 4
		wait.frames(20)
		event.get_fishing_tournament_info_2(4, frame[2]) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		frame[1] = 0
		frame[8] = 1
		event.get_fishing_tournament_info_2(3, frame[11]) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		event.set_message_window_mode(1, 0)
		event.set_message_window_option(1, 7, 20, 100, 20, 128)
		event.set_message_window_option(1, 8, 0)
		frame[12] = event.get_language() or frame[12]
		if frame[12] == 1 then
			event.set_message_window_option(1, 2, 0.5)
		end
		frame[9] = event.get_random_number_int(1000) or frame[9]
		frame[3] = vm.i32(vm.i32(15000 + vm.i32(frame[2] * 1000)) + frame[9])
		if frame[3] > frame[11] then
			frame[1] = vm.i32(frame[1] + 1)
		end
		while frame[8] < 5 do
			frame[9] = event.get_random_number_int(vm.idiv(frame[vm.index(vm.i32(frame[8] + 1), 48)], 3)) or frame[9]
			frame[vm.index(vm.i32(frame[8] + 2), 48)] =
				vm.i32(frame[vm.index(vm.i32(frame[8] + 1), 48)] - vm.i32(frame[9] + 1))
			if frame[vm.index(vm.i32(frame[8] + 2), 48)] < 0 then
				frame[vm.index(vm.i32(frame[8] + 2), 48)] = 0
			end
			if frame[vm.index(vm.i32(frame[8] + 2), 48)] > frame[11] then
				frame[1] = vm.i32(frame[1] + 1)
			end
			frame[8] = vm.i32(frame[8] + 1)
		end
		frame[8] = 0
		frame[13] = 0
		frame[14] = 0
		frame[15] = 0
		while frame[8] < 6 do
			if frame[8] == frame[1] then
				event.set_message_item_system_message(1, vm.i32(frame[1] + 1), 33110)
				event.set_message_number(1, vm.i32(frame[1] + 1), frame[11])
				frame[13] = 1
			else
				frame[9] = event.get_random_number_int(24) or frame[9]
				while true do
					frame[46] = 0
					while frame[15] > frame[46] do
						if frame[vm.index(vm.i32(frame[46] + 15), 48)] == frame[9] then
							break
						else
							frame[46] = vm.i32(frame[46] + 1)
						end
					end
					if frame[15] == frame[46] then
						break
					else
						frame[9] = event.get_random_number_int(24) or frame[9]
					end
				end
				frame[vm.index(vm.i32(frame[15] + 15), 48)] = frame[9]
				frame[15] = vm.i32(frame[15] + 1)
				frame[10] = event.get_npc_message_number_3(vm.i32(frame[9] + 1), 12) or frame[10]
				event.set_message_item_system_message(1, vm.i32(frame[8] + 1), frame[10])
				event.set_message_number(
					1,
					vm.i32(frame[8] + 1),
					frame[vm.index(vm.i32(vm.i32(frame[8] - frame[13]) + 2), 48)]
				)
				if vm.i32(frame[8] + 1) <= 3 then
					if frame[14] == 0 then
						event.load_npc_character(0, 4, vm.i32(frame[9] + 1), 17)
					end
					if frame[14] == 1 then
						event.load_npc_character(0, 4, vm.i32(frame[9] + 1), 18)
					end
					if frame[14] == 2 then
						event.load_npc_character(0, 4, vm.i32(frame[9] + 1), 19)
					end
					frame[14] = vm.i32(frame[14] + 1)
				end
			end
			frame[8] = vm.i32(frame[8] + 1)
		end
		event.play_sound_effect(contest_sound_bank, 4)
		event.open_message_window_2(
			1,
			"              CATEGORIA    Nome                Peso\n          ──────────────────────\n\n\n\n\n              3[UNI00b0]    [アイテム３]  [数値３]g\n\n              4[UNI00b0]    [アイテム４]  [数値４]g\n\n              5[UNI00b0]    [アイテム５]  [数値５]g\n\n              6[UNI00b0]    [アイテム６]  [数値６]g\n"
		)
		resume_step = 5
		message.show_timed(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(contest_sound_bank, 4)
		event.open_message_window_2(
			1,
			"              CATEGORIA    Nome                Peso\n          ──────────────────────\n\n\n              2[UNI00b0]    [アイテム２]  [数値２]g\n\n              3[UNI00b0]    [アイテム３]  [数値３]g\n\n              4[UNI00b0]    [アイテム４]  [数値４]g\n\n              5[UNI00b0]    [アイテム５]  [数値５]g\n\n              6[UNI00b0]    [アイテム６]  [数値６]g\n"
		)
		resume_step = 6
		message.show_timed(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(contest_sound_bank, 4)
		event.open_message_window_2(
			1,
			"              CATEGORIA    Nome                Peso\n          ──────────────────────\n              1[UNI00b0]    [アイテム１]  [数値１]g\n\n              2[UNI00b0]    [アイテム２]  [数値２]g\n\n              3[UNI00b0]    [アイテム３]  [数値３]g\n\n              4[UNI00b0]    [アイテム４]  [数値４]g\n\n              5[UNI00b0]    [アイテム５]  [数値５]g\n\n              6[UNI00b0]    [アイテム６]  [数値６]g\n"
		)
		resume_step = 7
		message.show_timed(1, -1, 4, 0, 0, 90)
		if frame[12] == 1 then
			event.set_message_window_option(1, 2, -1)
		end
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_rotation(17, 0.0, 0.0, 0.0)
		event.set_character_rotation(18, 0.0, 0.0, 0.0)
		if frame[1] == 0 then
			event.set_fishing_tournament_state(0, vm.i32(frame[2] + 1))
			event.set_character_active(1, 13)
			event.set_character_active(17)
			event.set_character_active(18)
			event.set_character_position(13, 0.0, 68.97, -470.0)
			event.set_character_position(17, 30.0, 20.0, -470.0)
			event.set_character_position(18, -30.0, 16.0, -470.0)
			event.set_character_position(0, 0.0, 36.0, -470.0)
			event.set_character_motion(0, "1位", 0)
			event.set_fishing_tournament_state(3)
		end
		if frame[1] == 1 then
			event.set_character_active(17)
			event.set_character_active(18)
			event.set_character_position(17, 0.0, 36.0, -470.0)
			event.set_character_position(18, -30.0, 16.0, -470.0)
			event.set_character_position(0, 30.0, 20.0, -470.0)
			event.set_character_motion(0, "2位", 0)
		end
		if frame[1] == 2 then
			event.set_character_active(17)
			event.set_character_active(18)
			event.set_character_position(17, 0.0, 36.0, -470.0)
			event.set_character_position(18, 30.0, 20.0, -470.0)
			event.set_character_position(0, -30.0, 16.0, -470.0)
			event.set_character_motion(0, "3位", 0)
		end
		if frame[1] >= 3 then
			event.set_character_active(17)
			event.set_character_active(18)
			event.set_character_active(19)
			event.set_character_position(17, 0.0, 36.0, -470.0)
			event.set_character_position(18, 30.0, 20.0, -470.0)
			event.set_character_position(19, -30.0, 16.0, -470.0)
			event.set_character_position(0, 34.24, 0.0, -432.43)
			event.set_character_rotation(0, 0.0, -2.4, 0.0)
			event.set_character_motion(0, "がっかりL", 0)
		end
		event.set_camera_sequence_position(-1.26, 25.59, -336.37)
		event.set_camera_sequence_look_at(0.0, 36.39, -471.19)
		event.start_crossfade(60)
		resume_step = 8
		wait.frames(90)
		event.set_object_handle_visible(8, 1)
		if frame[1] <= 2 then
			do
				local out1, out2 = event.get_fishing_tournament_info_4(1, vm.i32(frame[1] + 1))
				frame[47] = out1 or frame[47]
				frame[48] = out2 or frame[48]
			end
			event.play_sound_effect(results_sound_bank, 0)
			resume_step = 9
			minigame.show_tournament_prize(1, vm.i32(frame[1] + 1), frame[47], frame[48])
			event.add_inventory_item(frame[47], frame[48])
			resume_step = 10
			inventory.resolve_overflow_alt(1)
		end
		event.set_fishing_tournament_state(1)
		resume_step = 11
		wait.frames(30)
		event.fade_out_screen(30)
		resume_step = 12
		wait.frames(30)
		event.set_character_active(0, 13)
		event.delete_character(17)
		event.delete_character(18)
		event.delete_character(19)
		resume_step = 13
		leave_contest_area()
		return 0
	end, function(received: { any })
		if resume_step <= 13 then
			if resume_step <= 1 then
				wait.frames_skipping(30)
			end
			if resume_step <= 2 then
				wait.background_load_skipping()
			end
			if resume_step <= 3 then
				wait.frames_skipping(20)
			end
			if resume_step <= 4 then
				frame[1] = 0
				frame[8] = 1
				local _ = frame[12] == 1
				frame[3] = vm.i32(vm.i32(15000 + vm.i32(frame[2] * 1000)) + frame[9])
				local _ = frame[3] > frame[11]
				frame[1] = vm.i32(frame[1] + 1)
				local _ = frame[8] < 5
				frame[vm.index(vm.i32(frame[8] + 2), 48)] =
					vm.i32(frame[vm.index(vm.i32(frame[8] + 1), 48)] - vm.i32(frame[9] + 1))
				local _ = frame[vm.index(vm.i32(frame[8] + 2), 48)] < 0
				frame[vm.index(vm.i32(frame[8] + 2), 48)] = 0
				local _ = frame[vm.index(vm.i32(frame[8] + 2), 48)] > frame[11]
				frame[1] = vm.i32(frame[1] + 1)
				frame[8] = vm.i32(frame[8] + 1)
				frame[8] = 0
				frame[13] = 0
				frame[14] = 0
				frame[15] = 0
				local _ = frame[8] < 6
				local _ = frame[8] == frame[1]
				frame[13] = 1
				frame[46] = 0
				local _ = frame[15] > frame[46]
				local _ = frame[vm.index(vm.i32(frame[46] + 15), 48)] == frame[9]
				frame[46] = vm.i32(frame[46] + 1)
				local _ = frame[15] == frame[46]
				frame[vm.index(vm.i32(frame[15] + 15), 48)] = frame[9]
				frame[15] = vm.i32(frame[15] + 1)
				local _ = vm.i32(frame[8] + 1) <= 3
				local _ = frame[14] == 0
				local _ = frame[14] == 1
				local _ = frame[14] == 2
				frame[14] = vm.i32(frame[14] + 1)
				frame[8] = vm.i32(frame[8] + 1)
				message.show_timed_skipping(1, -1, 4, 0, 0, 60)
			end
			if resume_step <= 5 then
				message.show_timed_skipping(1, -1, 4, 0, 0, 60)
			end
			if resume_step <= 6 then
				message.show_timed_skipping(1, -1, 4, 0, 0, 90)
			end
			if resume_step <= 7 then
				wait.frames_skipping(90)
			end
			if resume_step <= 8 then
				minigame.show_tournament_prize_skipping(1, vm.i32(frame[1] + 1), frame[47], frame[48])
			end
			if resume_step <= 9 then
				wait.skip_ten_frames_variant(1)
			end
			if resume_step <= 10 then
				wait.frames_skipping(30)
			end
			if resume_step <= 11 then
				wait.frames_skipping(30)
			end
			if resume_step <= 12 then
				fishing_town_fishing_tournament.wait_skippable_frames()
			end
			return 0
		end
		return nil
	end)
end

--- Skips the results ceremony by running its silent equivalents of the waits and message boxes.
local function skip_tournament_results()
	local rank_index: s32 = 0
	local tournament_info: s32 = 0
	local weights: { s32 } = table.create(5, 0)
	local index: s32 = 0
	local random_value: s32 = 0
	local player_weight: s32 = 0
	local podium_index: s32 = 0
	local chosen_count: s32 = 0
	local chosen_contestants: { s32 } = table.create(30, 0)
	local scan_index: s32 = 0
	local prize_item: s32 = 0
	local prize_amount: s32 = 0
	results_sound_bank = 0
	wait.background_load_skipping()
	wait.frames_skipping(30)
	wait.background_load_skipping()
	wait.frames_skipping(20)
	rank_index = 0
	index = 1
	weights[1] = 15000 + tournament_info * 1000 + random_value
	rank_index = rank_index + 1
	local _ = weights[1] > player_weight
	weights[index + 1] = vm.i32(weights[index] - (random_value + 1))
	local _ = weights[index + 1] < 0
	weights[index + 1] = 0
	rank_index = rank_index + 1
	local _ = index < 5
	local _ = weights[index + 1] > player_weight
	index = index + 1
	index = 0
	podium_index = 0
	chosen_count = 0
	scan_index = 0
	local _ = chosen_count > scan_index
	local _ = chosen_contestants[scan_index + 1] == random_value
	scan_index = scan_index + 1
	chosen_contestants[chosen_count + 1] = random_value
	local _ = chosen_count == scan_index
	chosen_count = chosen_count + 1
	local _ = podium_index == 0
	local _ = podium_index == 1
	local _ = podium_index == 2
	podium_index = podium_index + 1
	local _ = index < 6
	local _ = index == rank_index
	local _ = index + 1 <= 3
	index = index + 1
	message.show_timed_skipping(1, -1, 4, 0, 0, 60)
	message.show_timed_skipping(1, -1, 4, 0, 0, 60)
	message.show_timed_skipping(1, -1, 4, 0, 0, 90)
	wait.frames_skipping(90)
	minigame.show_tournament_prize_skipping(1, rank_index + 1, prize_item, prize_amount)
	wait.skip_ten_frames_variant(1)
	wait.frames_skipping(30)
	wait.frames_skipping(30)
	fishing_town_fishing_tournament.wait_skippable_frames()
end

--- Runs the contest host's conversation for weighing in a fish, showing the weigh-in presentation and announcing the results when the entries are used up.
local function talk_to_contest_host()
	local host_slot: s32 = 0
	local playable_character: s32 = 0
	local menu_choice: any = 0
	local remaining_entries: s32 = 0
	local weigh_menu_choice: any = 0
	local selected_item: s32 = 0
	local can_weigh: s32 = 0
	local fish_length: s32 = 0
	local fish_weight: s32 = 0
	local species_length: s32 = 0
	local species_index: s32 = 0
	local fish_scale: f32 = 0
	local fish_length_float: f32 = 0
	local species_length_float: f32 = 0
	local first_digit: s32 = 0
	local second_digit: s32 = 0
	local third_digit: s32 = 0
	local fourth_digit: s32 = 0
	local fifth_digit: s32 = 0
	local sixth_digit: s32 = 0
	local rotation_z: f32 = 0
	local swing_amplitude: f32 = 0
	local weight_swing: f32 = 0
	local swing_count: s32 = 0
	local camera_running: s32 = 0
	local language_code: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		host_slot = event.get_triggered_event_data_2(13) or host_slot
		event.apply_message_window_preset(0, 0)
		event.set_character_motion(0, "立ち", 0)
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 then
			event.open_message_window_2(
				0,
				"Qui puoi dimostrare la tua abilit[UNI00e0]\nnella pesca. Puoi presentare solo\npesci che hai catturato tu stesso.<page>Come faccio a saperlo?\nAnni e anni di esperienza!"
			)
			resume_step = 1
			cutscene.talk(host_slot, -1, 0, 0)
			return
		end
		event.open_message_window_2(0, "Inizia il Torneo di Pesca!\nHai portato un pesce?")
		resume_step = 2
		cutscene.talk(host_slot, -1, 0, 0)
		while true do
			event.open_message_window_2(0, "Pesa il pesce\nAscolta la spiegazione\nEsci")
			resume_step = 3
			menu_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 3, 2)
			if menu_choice == -1 or menu_choice == 2 then
				event.open_message_window_2(0, "Puoi anche pescare solo per\ndivertirti. Ognuno fa come crede!")
				resume_step = 4
				cutscene.talk(host_slot, -1, 0, 0)
				return
			end
			if menu_choice == 1 then
				event.open_message_window_2(
					0,
					"In ogni torneo, puoi pesare fino\na 10 pesci e, se ne pesi 3 o pi[UNI00f9],\narriverai al Totale complessivo."
				)
				resume_step = 5
				cutscene.talk(host_slot, -1, 0, 0)
				event.open_message_window_2(
					0,
					"Se partecipi al torneo con pesci gi[UNI00e0] pesati e selezioni\nTotale complessivo, il punteggio finale\nsar[UNI00e0] il peso totale dei tuoi 3 pesci migliori."
				)
				resume_step = 6
				cutscene.talk(host_slot, -1, 0, 0)
				event.open_message_window_2(
					0,
					"Sappi che puoi far partecipare\nsolo pesci non allevati.<page>Non puoi pesare un pesce\nche hai nutrito tu stesso."
				)
				resume_step = 7
				cutscene.talk(host_slot, -1, 0, 0)
			end
			if menu_choice == 0 then
				break
			end
		end
		event.get_fishing_tournament_info_2(2, remaining_entries) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		host_slot = 8
		if remaining_entries == 10 then
			event.open_message_window_2(0, "Quale pesce vuoi pesare?")
			resume_step = 8
			cutscene.talk(host_slot, -1, 0, 0)
		else
			if remaining_entries > 7 then
				event.open_message_window_2(0, "Pesa\nGuarda l'Elenco Pesi")
				event.set_message_selection_top_line(0, 0)
				resume_step = 9
				weigh_menu_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 2, 0)
			else
				event.open_message_window_2(0, "Pesa il pesce\nVisualizza l'Elenco Pesi\nTotale complessivo")
				event.set_message_selection_top_line(0, 0)
				resume_step = 10
				weigh_menu_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 3, 0)
			end
			if weigh_menu_choice == -1 then
				return
			end
			if weigh_menu_choice == 1 then
				resume_step = 11
				fishing_town_fishing_tournament.show_tournament_info()
				resume_step = 12
				vm.wait(12)
				return
			end
			if weigh_menu_choice == 2 then
				event.pause_music()
				resume_step = 13
				announce_tournament_results()
				event.play_music(0)
				return
			end
			event.set_message_window_mode(0, 1)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 0)
			event.set_message_window_option(0, 4, -1, -1)
		end
		event.open_event_menu(22, 0)
		resume_step = 14
		vm.wait(14)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		do
			local out1, out2, out3, out4, out5 = event.get_menu_results_5()
			selected_item = out1 or selected_item
			can_weigh = out2 or can_weigh
			fish_length = out3 or fish_length
			fish_weight = out4 or fish_weight
			species_length = out5 or species_length
		end
		if selected_item == 0 then
			return
		end
		if can_weigh == 0 then
			event.open_message_window_2(0, "Non posso pesare quello!")
			resume_step = 15
			cutscene.talk(host_slot, -1, 0, 0)
			return
		end
		event.fade_out_screen(30)
		resume_step = 16
		wait.frames(35)
		event.pause_music()
		species_index = vm.i32(selected_item - 320)
		if selected_item == 310 then
			species_index = 17
		end
		if species_index == 0 then
			event.load_character(4, "menu/aqua/fish/f1a.gltf", "info", 9)
		end
		if species_index == 1 then
			event.load_character(4, "menu/aqua/fish/f2a.gltf", "info", 9)
		end
		if species_index == 2 then
			event.load_character(4, "menu/aqua/fish/f3a.gltf", "info", 9)
		end
		if species_index == 3 then
			event.load_character(4, "menu/aqua/fish/f4a.gltf", "info", 9)
		end
		if species_index == 4 then
			event.load_character(4, "menu/aqua/fish/f5a.gltf", "info", 9)
		end
		if species_index == 5 then
			event.load_character(4, "menu/aqua/fish/f6a.gltf", "info", 9)
		end
		if species_index == 6 then
			event.load_character(4, "menu/aqua/fish/f7a.gltf", "info", 9)
		end
		if species_index == 7 then
			event.load_character(4, "menu/aqua/fish/f8a.gltf", "info", 9)
		end
		if species_index == 8 then
			event.load_character(4, "menu/aqua/fish/f10a.gltf", "info", 9)
		end
		if species_index == 9 then
			event.load_character(4, "menu/aqua/fish/f11a.gltf", "info", 9)
		end
		if species_index == 10 then
			event.load_character(4, "menu/aqua/fish/f12a.gltf", "info", 9)
		end
		if species_index == 11 then
			event.load_character(4, "menu/aqua/fish/f13a.gltf", "info", 9)
		end
		if species_index == 12 then
			event.load_character(4, "menu/aqua/fish/f14a.gltf", "info", 9)
		end
		if species_index == 13 then
			event.load_character(4, "menu/aqua/fish/f15a.gltf", "info", 9)
		end
		if species_index == 14 then
			event.load_character(4, "menu/aqua/fish/f16a.gltf", "info", 9)
		end
		if species_index == 15 then
			event.load_character(4, "menu/aqua/fish/f17a.gltf", "info", 9)
		end
		if species_index == 16 then
			event.load_character(4, "menu/aqua/fish/f18a.gltf", "info", 9)
		end
		if species_index == 17 then
			event.load_character(4, "menu/aqua/fish/f19a.gltf", "info", 9)
		end
		event.reset_follow_camera(1, 3.14)
		event.set_character_active(9)
		event.set_character_position(9, 0.0, 80.0, 25.0)
		event.set_character_rotation(9, -1.57, -1.57, 0.0)
		fish_length_float = fish_length
		species_length_float = species_length
		fish_scale = vm.f32(vm.fdiv(fish_length_float, species_length_float))
		if fish_scale > 2.0 then
			fish_scale = 2.0
		end
		event.set_character_scale(9, fish_scale, fish_scale, fish_scale)
		event.set_camera_sequence_position(43.16, 49.45, 114.86)
		event.set_camera_sequence_look_at(8.48, 50.29, 19.23)
		event.fade_in_screen(30)
		resume_step = 17
		wait.frames(15)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(43.16, 49.45, 114.86, 8.48, 50.29, 19.23)
		event.add_camera_sequence_path_point(43.16, 112.26, 114.86, 8.48, 113.1, 19.23)
		event.start_camera_sequence_path()
		event.play_sound_effect(contest_sound_bank, 0)
		event.attach_object_handle_to_map_part_3(9, "p14_i03h03", "i03h03_14-m")
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.set_object_handle_rotation(9, 0.0, 0.0, -vm.f32(vm.f32(0.0031400002) * fish_weight))
		resume_step = 18
		vm.wait(18)
		weight_swing = vm.f32(fish_weight * 0.25)
		swing_amplitude = vm.f32(vm.f32(vm.f32(0.0031400002) * fish_weight) * 0.25)
		swing_count = 0
		while swing_amplitude > vm.f32(0.05) do
			if vm.imod(swing_count, 2) == 0 then
				rotation_z = vm.f32(-vm.f32(vm.f32(0.0031400002) * fish_weight) + swing_amplitude)
			else
				rotation_z = vm.f32(-vm.f32(vm.f32(0.0031400002) * fish_weight) - swing_amplitude)
			end
			swing_amplitude = vm.f32(swing_amplitude - vm.f32(swing_amplitude / 50.0))
			weight_swing = vm.f32(weight_swing - vm.f32(weight_swing / 50.0))
			event.set_object_handle_rotation(9, 0.0, 0.0, rotation_z)
			camera_running = event.is_camera_sequence_running() or camera_running
			if camera_running == 0 then
				event.stop_sound_effect(contest_sound_bank, 0)
			end
			swing_count = vm.i32(swing_count + 1)
			resume_step = 19
			vm.wait(19)
		end
		event.stop_sound_effect(contest_sound_bank, 0)
		event.play_sound_effect(contest_sound_bank, 1)
		event.set_object_handle_rotation(9, 0.0, 0.0, -vm.f32(vm.f32(0.0031400002) * fish_weight))
		language_code = event.get_language() or language_code
		first_digit = vm.idiv(fish_weight, 10000)
		second_digit = vm.idiv(vm.i32(fish_weight - vm.i32(first_digit * 10000)), 1000)
		third_digit = vm.idiv(vm.i32(fish_weight - vm.i32(vm.i32(first_digit * 10000) + vm.i32(second_digit * 1000))), 100)
		fourth_digit = vm.idiv(
			vm.i32(fish_weight - vm.i32(vm.i32(vm.i32(first_digit * 10000) + vm.i32(second_digit * 1000)) + vm.i32(third_digit * 100))),
			10
		)
		fifth_digit = vm.i32(
			fish_weight
				- vm.i32(
					vm.i32(vm.i32(vm.i32(first_digit * 10000) + vm.i32(second_digit * 1000)) + vm.i32(third_digit * 100))
						+ vm.i32(fourth_digit * 10)
				)
		)
		event.reset_event_sprite(10)
		event.set_event_sprite_type(10, 0)
		event.set_event_sprite_texture(10, "suuji", number_image)
		event.set_event_sprite_color(10, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(10, vm.i32(40 * first_digit), 0, 40, 52)
		event.set_event_sprite_size(10, 40, 52)
		event.set_event_sprite_position(10, 256, 344)
		event.set_event_sprite_draw_pass(10, 1)
		event.attach_object_handle_to_sprite(20, 10)
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "suuji", number_image)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(0, vm.i32(40 * second_digit), 0, 40, 52)
		event.set_event_sprite_size(0, 40, 52)
		event.set_event_sprite_position(0, 296, 344)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "suuji", number_image)
		event.set_event_sprite_color(1, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(1, vm.i32(40 * third_digit), 0, 40, 52)
		event.set_event_sprite_size(1, 40, 52)
		event.set_event_sprite_position(1, 336, 344)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(11, 1)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "suuji", number_image)
		event.set_event_sprite_color(2, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(2, 0 + vm.i32(40 * fourth_digit), 0, 40, 52)
		event.set_event_sprite_size(2, 40, 52)
		event.set_event_sprite_position(2, 376, 344)
		event.set_event_sprite_draw_pass(2, 1)
		event.attach_object_handle_to_sprite(12, 2)
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.reset_event_sprite(3)
		event.set_event_sprite_type(3, 0)
		event.set_event_sprite_texture(3, "suuji", number_image)
		event.set_event_sprite_color(3, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(3, 0 + vm.i32(40 * fifth_digit), 0, 40, 52)
		event.set_event_sprite_size(3, 40, 52)
		event.set_event_sprite_position(3, 416, 344)
		event.set_event_sprite_draw_pass(3, 1)
		event.attach_object_handle_to_sprite(13, 3)
		event.clear_object_sequence(13)
		event.set_object_sequence_object(13, 13)
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_texture(4, "suuji", number_image)
		event.set_event_sprite_color(4, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(4, 484, 0, 28, 42)
		event.set_event_sprite_size(4, 28, 42)
		event.set_event_sprite_position(4, 456, 349)
		if language_code == 5 then
			event.set_event_sprite_position(4, 456, 364)
		end
		event.set_event_sprite_draw_pass(4, 1)
		event.attach_object_handle_to_sprite(14, 4)
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.reset_event_sprite(5)
		event.set_event_sprite_type(5, 0)
		event.set_event_sprite_texture(5, "gyoname", fish_name_image)
		event.set_event_sprite_color(5, 128, 128, 128, 0)
		if species_index <= 8 then
			event.set_event_sprite_texture_rect(5, 0, vm.i32(species_index * 40), 182, 40)
		else
			event.set_event_sprite_texture_rect(5, 182, vm.i32((species_index - 9) * 40), 182, 40)
		end
		event.set_event_sprite_size(5, 182, 40)
		event.set_event_sprite_position(5, 182, 144)
		event.set_event_sprite_draw_pass(5, 1)
		event.attach_object_handle_to_sprite(15, 5)
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		third_digit = vm.idiv(fish_length, 1000)
		fourth_digit = vm.idiv(vm.i32(fish_length - vm.i32(third_digit * 1000)), 100)
		fifth_digit = vm.idiv(vm.i32(fish_length - vm.i32(vm.i32(third_digit * 1000) + vm.i32(fourth_digit * 100))), 10)
		sixth_digit = vm.i32(fish_length - vm.i32(vm.i32(vm.i32(third_digit * 1000) + vm.i32(fourth_digit * 100)) + vm.i32(fifth_digit * 10)))
		event.reset_event_sprite(6)
		event.set_event_sprite_type(6, 0)
		event.set_event_sprite_texture(6, "suuji", number_image)
		event.set_event_sprite_color(6, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(6, vm.i32(26 * third_digit), 52, 26, 32)
		event.set_event_sprite_size(6, 26, 32)
		event.set_event_sprite_position(6, 299, 144)
		event.set_event_sprite_draw_pass(6, 1)
		event.attach_object_handle_to_sprite(16, 6)
		event.clear_object_sequence(16)
		event.set_object_sequence_object(16, 16)
		event.reset_event_sprite(7)
		event.set_event_sprite_type(7, 0)
		event.set_event_sprite_texture(7, "suuji", number_image)
		event.set_event_sprite_color(7, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(7, 0 + vm.i32(26 * fourth_digit), 52, 26, 32)
		event.set_event_sprite_size(7, 26, 32)
		event.set_event_sprite_position(7, 325, 144)
		event.set_event_sprite_draw_pass(7, 1)
		event.attach_object_handle_to_sprite(17, 7)
		event.clear_object_sequence(17)
		event.set_object_sequence_object(17, 17)
		event.reset_event_sprite(8)
		event.set_event_sprite_type(8, 0)
		event.set_event_sprite_texture(8, "suuji", number_image)
		event.set_event_sprite_color(8, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(8, 0 + vm.i32(26 * fifth_digit), 52, 26, 32)
		event.set_event_sprite_size(8, 26, 32)
		event.set_event_sprite_position(8, 351, 144)
		event.set_event_sprite_draw_pass(8, 1)
		event.attach_object_handle_to_sprite(18, 8)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.reset_event_sprite(12)
		event.set_event_sprite_type(12, 0)
		event.set_event_sprite_texture(12, "suuji", number_image)
		event.set_event_sprite_color(12, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(12, 434, 0, 10, 22)
		if language_code == 2 then
			event.set_event_sprite_texture_rect(12, 432, 0, 12, 30)
		end
		if language_code == 4 then
			event.set_event_sprite_texture_rect(12, 434, 0, 10, 26)
		end
		if language_code == 5 then
			event.set_event_sprite_texture_rect(12, 434, 0, 10, 32)
		end
		event.set_event_sprite_size(12, 10, 22)
		event.set_event_sprite_position(12, 369, 149)
		if language_code == 5 then
			event.set_event_sprite_position(12, 369, 142)
		end
		event.set_event_sprite_draw_pass(12, 1)
		event.attach_object_handle_to_sprite(22, 12)
		event.clear_object_sequence(22)
		event.set_object_sequence_object(22, 22)
		event.reset_event_sprite(11)
		event.set_event_sprite_type(11, 0)
		event.set_event_sprite_texture(11, "suuji", number_image)
		event.set_event_sprite_color(11, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(11, 0 + vm.i32(26 * sixth_digit), 52, 26, 32)
		event.set_event_sprite_size(11, 26, 32)
		event.set_event_sprite_position(11, 387, 144)
		event.set_event_sprite_draw_pass(11, 1)
		event.attach_object_handle_to_sprite(21, 11)
		event.clear_object_sequence(21)
		event.set_object_sequence_object(21, 21)
		event.reset_event_sprite(9)
		event.set_event_sprite_type(9, 0)
		event.set_event_sprite_texture(9, "suuji", number_image)
		event.set_event_sprite_color(9, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(9, 444, 0, 40, 22)
		event.set_event_sprite_size(9, 40, 22)
		event.set_event_sprite_position(9, 423, 149)
		event.set_event_sprite_draw_pass(9, 1)
		event.attach_object_handle_to_sprite(19, 9)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		resume_step = 20
		camera.wait_until_done()
		event.move_object_sequence(20, 176, 224, 0.0, 30)
		event.move_object_sequence(10, 216, 224, 0.0, 30)
		event.move_object_sequence(11, 256, 224, 0.0, 30)
		event.move_object_sequence(12, 296, 224, 0.0, 30)
		event.move_object_sequence(13, 336, 224, 0.0, 30)
		if language_code == 5 then
			event.move_object_sequence(14, 376, 244, 0.0, 30)
		else
			event.move_object_sequence(14, 376, 229, 0.0, 30)
		end
		resume_step = 21
		wait.frames(30)
		event.play_sound_effect(contest_sound_bank, 2)
		event.set_object_sequence_color(15, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(16, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(17, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(18, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(19, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(21, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(22, 128.0, 128.0, 128.0, 128.0, 30)
		resume_step = 22
		wait.frames(60)
		event.set_character_position(0, 20.54, 20.0, 96.75)
		event.set_character_rotation(0, 0.0, -2.34, 0.0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_draw_pass(3, 0)
		event.set_event_sprite_draw_pass(4, 0)
		event.set_event_sprite_draw_pass(5, 0)
		event.set_event_sprite_draw_pass(6, 0)
		event.set_event_sprite_draw_pass(7, 0)
		event.set_event_sprite_draw_pass(8, 0)
		event.set_event_sprite_draw_pass(9, 0)
		event.set_event_sprite_draw_pass(10, 0)
		event.set_event_sprite_draw_pass(11, 0)
		event.set_event_sprite_draw_pass(12, 0)
		event.play_music(0)
		event.set_camera_sequence_position(3.01, 56.77, 312.31)
		event.set_camera_sequence_look_at(1.17, 80.71, 19.28)
		event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
		resume_step = 23
		wait.frames(5)
		if fish_length > 600 then
			event.open_message_window_2(0, "Wow! Questo s[UNI00ec] che [UNI00e8] grosso!\nNon vedo l'ora dei risultati!")
		elseif fish_length > 400 then
			event.open_message_window_2(0, "Bravo, niente male!\nMa non puoi ancora riposarti...")
		else
			event.open_message_window_2(0, "Mmh... Niente male, credo.")
		end
		host_slot = 8
		resume_step = 24
		cutscene.talk(host_slot, -1, 0, 0)
		event.set_camera_sequence_position(-34.05, 56.77, 159.14)
		event.set_camera_sequence_look_at(-54.41, 52.31, 29.63)
		resume_step = 25
		wait.frames(1)
		event.set_character_position(0, -43.47, 20.0, 56.19)
		event.set_character_rotation(0, 0.0, -2.7, 0.0)
		event.get_fishing_tournament_info_2(2, remaining_entries) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		if remaining_entries <= 0 then
			event.pause_music()
			resume_step = 26
			announce_tournament_results()
			event.play_music(0)
		end
		event.set_message_number(0, 1, remaining_entries)
		event.open_message_window_2(0, "Puoi pesare [数値１]pesce/i in pi[UNI00f9].\nBuona fortuna!")
		resume_step = 27
		cutscene.talk(host_slot, -1, 0, 0)
		resume_step = 28
		wait.frames(30)
		event.delete_character(9)
		event.reset_follow_camera(1, 3.14)
		return
	end, function(received: { any })
		if resume_step <= 1 then
			return 0
		end
		if resume_step <= 4 then
			if resume_step == 3 then
				menu_choice = received[1] :: number
			end
			if resume_step <= 2 then
				menu_choice = fishing_town_fishing_tournament.ask_choice(0, -1, 0, host_slot, 3, 2)
			end
			if resume_step <= 3 then
				cutscene.talk_skipping_variant(host_slot, -1, 0, 0)
			end
			return 0
		end
		if resume_step <= 10 then
			if resume_step == 9 then
				weigh_menu_choice = received[1] :: number
			end
			if resume_step == 10 then
				weigh_menu_choice = received[1] :: number
			end
			if resume_step <= 5 then
				cutscene.talk_skipping_variant(host_slot, -1, 0, 0)
			end
			if resume_step <= 6 then
				cutscene.talk_skipping_variant(host_slot, -1, 0, 0)
			end
			if resume_step <= 7 then
				host_slot = 8
				cutscene.talk_skipping_variant(host_slot, -1, 0, 0)
			end
			if resume_step <= 8 then
				weigh_menu_choice = fishing_town_fishing_tournament.ask_choice(0, -1, 0, host_slot, 2, 0)
			end
			if resume_step <= 9 then
				weigh_menu_choice = fishing_town_fishing_tournament.ask_choice(0, -1, 0, host_slot, 3, 0)
			end
			return 0
		end
		if resume_step <= 12 then
			return 0
		end
		if resume_step <= 13 then
			return 0
		end
		if resume_step <= 14 then
			return 0
		end
		if resume_step <= 15 then
			return 0
		end
		if resume_step <= 28 then
			if resume_step <= 16 then
				species_index = selected_item - 320
				species_index = 17
				fish_length_float = fish_length
				species_length_float = species_length
				fish_scale = vm.f32(vm.fdiv(fish_length_float, species_length_float))
				local _ = fish_scale > 2.0
				fish_scale = 2.0
				wait.frames_skipping(15)
			end
			if resume_step <= 18 then
				weight_swing = vm.f32(fish_weight * 0.25)
				swing_amplitude = vm.f32(vm.f32(vm.f32(0.0031400002) * fish_weight) * 0.25)
				swing_count = 0
				rotation_z = vm.f32(-vm.f32(vm.f32(0.0031400002) * fish_weight) + swing_amplitude)
				rotation_z = vm.f32(-vm.f32(vm.f32(0.0031400002) * fish_weight) - swing_amplitude)
				local _ = swing_amplitude > vm.f32(0.05)
				swing_amplitude = vm.f32(swing_amplitude - vm.f32(swing_amplitude / 50.0))
				weight_swing = vm.f32(weight_swing - vm.f32(weight_swing / 50.0))
				local _ = vm.imod(swing_count, 2) == 0
				swing_count = swing_count + 1
			end
			if resume_step <= 19 then
				first_digit = vm.idiv(fish_weight, 10000)
				second_digit = vm.idiv(vm.i32(fish_weight - vm.i32(first_digit * 10000)), 1000)
				third_digit = vm.idiv(vm.i32(fish_weight - vm.i32(vm.i32(first_digit * 10000) + vm.i32(second_digit * 1000))), 100)
				fourth_digit = vm.idiv(
					vm.i32(fish_weight - vm.i32(vm.i32(vm.i32(first_digit * 10000) + vm.i32(second_digit * 1000)) + vm.i32(third_digit * 100))),
					10
				)
				fifth_digit = vm.i32(
					fish_weight
						- vm.i32(
							vm.i32(vm.i32(vm.i32(first_digit * 10000) + vm.i32(second_digit * 1000)) + vm.i32(third_digit * 100))
								+ vm.i32(fourth_digit * 10)
						)
				)
				third_digit = vm.idiv(fish_length, 1000)
				fourth_digit = vm.idiv(vm.i32(fish_length - vm.i32(third_digit * 1000)), 100)
				fifth_digit = vm.idiv(vm.i32(fish_length - vm.i32(vm.i32(third_digit * 1000) + vm.i32(fourth_digit * 100))), 10)
				sixth_digit = vm.i32(fish_length - vm.i32(vm.i32(vm.i32(third_digit * 1000) + vm.i32(fourth_digit * 100)) + vm.i32(fifth_digit * 10)))
				wait.background_load_skipping()
			end
			if resume_step <= 20 then
				wait.frames_skipping(30)
			end
			if resume_step <= 21 then
				wait.frames_skipping(60)
			end
			if resume_step <= 22 then
				wait.frames_skipping(5)
			end
			if resume_step <= 23 then
				host_slot = 8
				cutscene.talk_skipping_variant(host_slot, -1, 0, 0)
			end
			if resume_step <= 24 then
				wait.frames_skipping(1)
			end
			if resume_step <= 25 then
				skip_tournament_results()
			end
			if resume_step <= 26 then
				cutscene.talk_skipping_variant(host_slot, -1, 0, 0)
			end
			if resume_step <= 27 then
				wait.frames_skipping(30)
			end
			return 0
		end
		return nil
	end)
end

--- Shows the contestant's dialogue for the character that was spoken to.
local function talk_to_contestant()
	local contestant_slot: s32 = 0
	local contestant_id: s32 = 0
	local playable_character: s32 = 0
	event.get_player_character_slot()
	contestant_slot = event.get_triggered_event_data_2(13) or contestant_slot
	contestant_id = event.get_triggered_event_data_2(14) or contestant_id
	print("talk_chara_id=", contestant_slot, "talk_chara=", contestant_id, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, contestant_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	if contestant_id == 164 then
		event.open_message_window_2(
			0,
			"Vivo per questi Tornei di Pesca.\nE questa volta ho un vero campione.\nPodio dei vincitori, eccomi: arrivo!"
		)
	end
	if contestant_id == 166 then
		event.open_message_window_2(
			0,
			"Questo mi [UNI00e8] costato tempo e fatica.\nLa mia ragazza dice che sono cocciuto.\nStavolta non posso proprio perdere!"
		)
	end
	if contestant_id == 172 then
		event.open_message_window_2(
			0,
			"Avevamo un appuntamento romantico\noggi e invece mi ha portata qui.<page>*sospiro*\nA me la pesca neanche piace..."
		)
	end
	if contestant_id == 163 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"Quando acchiappi il primo,\nnon hai pi[UNI00f9] scampo, eh?<page>Anche tu sei stato preso all’amo,\nMax, eh?"
			)
		else
			event.open_message_window_2(
				0,
				"Quando acchiappi il primo,\nnon hai pi[UNI00f9] scampo, eh?<page>Anche tu sei stata presa all’amo,\nMonica, eh?"
			)
		end
	end
	if contestant_id == 170 then
		event.open_message_window_2(
			0,
			"Non crederai mai come ho iniziato...<page>[UNI00c8] curioso, ma un giorno,\nvolevo fare del pesce per cena\ne ho deciso di pescarlo da sola.<page>Sai, non sono niente male!"
		)
	end
	if contestant_id == 157 then
		event.open_message_window_2(
			0,
			"[UNI00c8] il mio primo Torneo di Pesca!\nVedessi il Nonky che ho preso!\n[UNI00c8] veeeramente enorme!"
		)
	end
	cutscene.talk(contestant_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, contestant_slot)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Intentionally empty handler for event 99.
function script.do_nothing() end
script[99] = script.do_nothing

--- Initializes the contest state, loads the participants and places the player when the hall is entered.
function script.default_event()
	event.initialize_event()
	number_image = 0
	fish_name_image = 0
	contest_sound_bank = 0
	results_sound_bank = 0
	event.set_save_control_bits(1, 1)
	load_contest_participants()
	event.attach_object_handle_to_map_part_2(8, "p16_i03h03")
	event.set_fishing_tournament_state(2)
	event.set_object_handle_visible(8, 1)
	contest_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or contest_sound_bank
	event.set_character_position(0, 0.0, 0.0, 450.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1, 3.14)
end

--- Waits for a button press with the town walk paused.
function script.key_open()
	event.do_nothing(0)
	wait.until_button_pressed(64)
	event.do_nothing(1)
end

--- Asks whether to leave the contest area and leaves for the town map when the player agrees.
function script.ask_to_leave_contest_area()
	local choice: any = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	vm.wait(1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "Lasciare area torneo?")
	choice = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
	event.set_message_window_mode(0, 1)
	if choice == 0 then
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
		event.stop_music(0)
		fishing_town_fishing_tournament.clean_up_event()
		event.fade_in_screen(30)
		event.jump_to_map_2(-1, "s45")
		vm.wait(4)
	end
	return 1
end
script[202] = script.ask_to_leave_contest_area

--- Plays the results ceremony and removes the character extension packs.
function script.show_tournament_results()
	local _ = announce_tournament_results()
	event.delete_character_extension_packs(0)
end
script[502] = script.show_tournament_results

script.leave_contest_area = leave_contest_area
script[503] = script.leave_contest_area

--- Starts the host's conversation or a contestant's dialogue depending on who was spoken to.
function script.on_talk()
	local talk_slot: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		talk_slot = event.get_triggered_event_data_2(13) or talk_slot
		if talk_slot == 8 then
			resume_step = 1
			talk_to_contest_host()
		else
			resume_step = 2
			talk_to_contestant()
		end
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				fishing_town_fishing_tournament.talk_to_npc()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.on_talk

return script
