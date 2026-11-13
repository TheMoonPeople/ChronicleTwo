--!strict
--- Fishing Town racing hall script that handles the Finny Frenzy race entry, tank choice, results ceremony and spectator dialogue.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local fishing_town_pinna_sprint = require("@lib/event/fishing_town_pinna_sprint")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local wait = require("@lib/event/wait")

local race_sound_bank: s32 = 0
local results_sound_bank: s32 = 0

--- Has the host announce the heat, lets the player pick the pre-race tank and starts the race, returning -1 when the player backs out.
local function choose_preparation_tank()
	local host_slot: s32 = 0
	local heat_stage: s32 = 0
	local tank_choice: any = 0
	local retire_choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		host_slot = 24
		heat_stage = event.get_gyorace_value(3) or heat_stage
		if heat_stage == 0 then
			event.open_message_window_2(0, "W[UNI00e4]hle den Vorbereitungstank.")
		end
		if heat_stage == 1 then
			event.open_message_window_2(0, "Sehr gut gemacht!\nJetzt kommt der 2. Lauf.")
			resume_step = 1
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(0, "W[UNI00e4]hle jetzt deinen Vorbereitungstank\nf[UNI00fc]r den 2. Lauf.")
		end
		if heat_stage == 2 then
			event.open_message_window_2(
				0,
				"Wow! Gl[UNI00fc]ckwunsch! Du bist im\nFinale. W[UNI00e4]hle deinen\nVorbereitungstank mit Bedacht!"
			)
		end
		resume_step = 2
		cutscene.talk(host_slot, -1, 0, 0)
		while true do
			event.set_message_window_mode(0, 8)
			event.set_message_window_option(0, 0, 0)
			event.open_message_window_2(
				0,
				"1. Tank: Sch[UNI00f6]n gleichm[UNI00e4][UNI00df]ig\n2. Tank: Mit aller Kraft\n3. Tank: Komm und k[UNI00e4]mpfe\n4. Tank: Die Letzten werden d. Ersten\n5. Tank: Kl[UNI00e4]ren wir's im Ring\n6. Tank: Goldene Mitte"
			)
			event.set_message_selection_top_line(0, 0)
			resume_step = 3
			tank_choice = message.ask_choice(0, -1, 8, 0, 0, 6, 0)
			if tank_choice == -1 then
				if heat_stage == 0 then
					event.set_message_window_mode(0, 1)
					event.set_message_selection_top_line(0, 0)
					event.set_message_window_option(0, 0, 0)
					event.set_message_window_option(0, 4, -1, -1)
					return -1
				else
					event.set_message_selection_top_line(0, 0)
					event.set_message_window_mode(0, 5)
					event.set_message_draw_speed(0, 1)
					event.open_message_window_2(
						0,
						"Wenn du keinen Tank w[UNI00e4]hlst,\nwirst du vom Rennen ausgeschlossen.\nBist du sicher?"
					)
					resume_step = 4
					retire_choice = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
					event.set_message_window_mode(0, 1)
					if retire_choice == 0 then
						event.set_gyorace_value(3, 0)
						event.set_message_window_mode(0, 1)
						event.set_message_selection_top_line(0, 0)
						event.set_message_window_option(0, 0, 0)
						event.set_message_window_option(0, 4, -1, -1)
						resume_step = 5
						vm.wait(5)
						return -1
					end
				end
			else
				break
			end
		end
		event.set_gyorace_value(0, tank_choice)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		if heat_stage == 0 then
			event.open_message_window_2(
				0,
				"Nun zum 1. Lauf.\nDu musst 1. werden, um in den\n2. Lauf zu kommen. Viel Gl[UNI00fc]ck!"
			)
			event.set_gyorace_value(3, 0)
			event.set_gyorace_value(4)
		end
		if heat_stage == 1 then
			event.open_message_window_2(
				0,
				"Jetzt zum 2. Lauf!\nDu musst 1. oder 2. werden, um das\nFinale zu erreichen. Viel Gl[UNI00fc]ck!"
			)
		end
		if heat_stage == 2 then
			event.open_message_window_2(
				0,
				"Die Vorbereitung ist abgeschlossen.\nJetzt zum Finale! Ab dem 3. Platz\ngewinnst du einen Preis.<page>Aber dein Ziel ist nat[UNI00fc]rlich\nder erste Preis!"
			)
		end
		resume_step = 6
		cutscene.talk(host_slot, -1, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		resume_step = 7
		wait.frames(30)
		event.stop_music(0)
		fishing_town_pinna_sprint.warp_to_i03h05()
		resume_step = 8
		vm.wait(8)
		return 0
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step == 3 then
				tank_choice = received[1] :: number
			end
			if resume_step <= 1 then
				cutscene.talk_skipping_variant(host_slot, -1, 0, 0)
			end
			if resume_step <= 2 then
				tank_choice = message.open_choice_skipping(0, -1, 8, 0, 0, 6, 0)
			end
			return -1
		end
		if resume_step <= 5 then
			if resume_step == 4 then
				retire_choice = received[1] :: number
			end
			return -1
		end
		if resume_step <= 8 then
			if resume_step <= 6 then
				wait.frames_skipping(30)
			end
			if resume_step <= 7 then
				cutscene.noop()
			end
			return 0
		end
		return nil
	end)
end

--- Handles the finishing rank of the heat: eliminates the fish, starts the next heat tank choice, or after the final shows the ranking board and awards the prize; returns 0 when eliminated, -1 when the player retires and 1 after the prize.
local function show_race_results()
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { s32 } = table.create(49, 0)
	local resume_step: number = 0
	return vm.guard(function()
		fishing_town_pinna_sprint.place_villagers()
		frame[8] = event.get_gyorace_value(1) or frame[8]
		event.set_character_position(0, 126.15, 0.0, -376.23)
		event.set_character_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_motion(0, "立ち", 0)
		event.set_camera_position(136.75, 46.57, -242.89)
		event.set_camera_look_at(101.62, 35.0, -367.91)
		event.fade_in_screen(30)
		frame[9] = event.get_gyorace_value(3) or frame[9]
		if frame[9] == 0 then
			if 0 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 1)
			resume_step = 1
			if choose_preparation_tank() == -1 then
				return -1
			end
		end
		if frame[9] == 1 then
			if 1 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 2)
			resume_step = 2
			if choose_preparation_tank() == -1 then
				return -1
			end
		end
		if frame[9] == 2 then
			if 2 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 0)
		end
		event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
		event.set_object_handle_visible(8, 0)
		event.play_sound_effect(race_sound_bank, 0)
		event.set_camera_sequence_position(-5.99, 55.55, -213.4)
		event.set_camera_sequence_look_at(0.0, 55.55, -471.19)
		resume_step = 3
		wait.frames(30)
		event.move_camera_sequence(-5.99, 181.46, -213.4, 0.0, 181.46, -471.19, 180)
		resume_step = 4
		camera.wait_until_done()
		event.stop_sound_effect(race_sound_bank, 0)
		event.play_sound_effect(race_sound_bank, 3)
		frame[6] = 1
		event.set_message_window_mode(1, 0)
		event.set_message_window_option(1, 7, 20, 100, 20, 128)
		event.set_message_window_option(1, 8, 0)
		frame[6] = 0
		frame[12] = 0
		frame[13] = 0
		frame[14] = 0
		frame[45] = event.get_language() or frame[45]
		if frame[45] == 1 then
			event.set_message_window_option(1, 2, 0.5)
		end
		while frame[6] < 6 do
			event.set_gyorace_value(5, 1, vm.i32(1 + frame[6]), frame[6])
			event.set_gyorace_value(6, 1, vm.i32(7 + frame[6]), frame[6])
			if frame[6] == frame[8] then
				frame[12] = 1
			else
				frame[7] = event.get_random_number_int(24) or frame[7]
				while true do
					frame[46] = 0
					while frame[14] > frame[46] do
						if frame[vm.index(vm.i32(frame[46] + 14), 49)] == frame[7] then
							break
						else
							frame[46] = vm.i32(frame[46] + 1)
						end
					end
					if frame[14] == frame[46] then
						break
					else
						frame[7] = event.get_random_number_int(24) or frame[7]
					end
				end
				frame[vm.index(vm.i32(frame[14] + 14), 49)] = frame[7]
				frame[14] = vm.i32(frame[14] + 1)
				if vm.i32(frame[6] + 1) <= 3 then
					if frame[13] == 0 then
						event.load_npc_character(0, 4, vm.i32(frame[7] + 1), 15)
					end
					if frame[13] == 1 then
						event.load_npc_character(0, 4, vm.i32(frame[7] + 1), 16)
					end
					frame[13] = vm.i32(frame[13] + 1)
				end
			end
			frame[6] = vm.i32(frame[6] + 1)
		end
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"          RANG      Name            Zeit\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
		)
		resume_step = 5
		message.show_timed(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"          RANG      Name            Zeit\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
		)
		resume_step = 6
		message.show_timed(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"          RANG      Name            Zeit\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
		)
		resume_step = 7
		message.show_timed(1, -1, 4, 0, 0, 90)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(16, 0.0, 0.0, 0.0)
		if frame[8] == 0 then
			event.set_character_active(1, 8)
			event.set_character_position(8, 0.0, 68.97, -470.0)
			event.set_save_flag(41, 1)
			event.set_character_position(15, 30.0, 20.0, -470.0)
			event.set_character_position(16, -30.0, 16.0, -470.0)
			event.set_character_position(0, 0.0, 36.0, -470.0)
			event.set_character_motion(0, "1位", 0)
		end
		if frame[8] == 1 then
			event.set_character_position(15, 0.0, 36.0, -470.0)
			event.set_character_position(16, -30.0, 16.0, -470.0)
			event.set_character_position(0, 30.0, 20.0, -470.0)
			event.set_character_motion(0, "2位", 0)
		end
		if frame[8] == 2 then
			event.set_character_position(15, 0.0, 36.0, -470.0)
			event.set_character_position(16, 30.0, 20.0, -470.0)
			event.set_character_position(0, -30.0, 16.0, -470.0)
			event.set_character_motion(0, "3位", 0)
		end
		event.set_character_active(15)
		event.set_character_active(16)
		event.set_camera_sequence_position(-1.26, 25.59, -336.37)
		event.set_camera_sequence_look_at(0.0, 36.39, -471.19)
		event.start_crossfade(60)
		resume_step = 8
		wait.frames(90)
		event.set_object_handle_visible(8, 1)
		frame[49] = event.get_gyorace_value(2) or frame[49]
		do
			local out1, out2 = event.get_gyorace_value(4, frame[49], vm.i32(frame[8] + 1))
			frame[47] = out1 or frame[47]
			frame[48] = out2 or frame[48]
		end
		event.play_sound_effect(results_sound_bank, 0)
		resume_step = 9
		minigame.show_tournament_prize(0, vm.i32(frame[8] + 1), frame[47], frame[48])
		event.add_inventory_item(frame[47], frame[48])
		resume_step = 10
		inventory.resolve_overflow_alt(1)
		if frame[8] == 0 then
			event.set_gyorace_value(7)
		end
		event.fade_out_screen(30)
		resume_step = 11
		wait.frames(30)
		if frame[45] == 1 then
			event.set_message_window_option(1, 2, -1)
		end
		event.set_character_active(0, 8)
		event.delete_character(15)
		event.delete_character(16)
		event.set_character_position(0, 126.15, 0.0, -376.23)
		event.set_character_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_motion(0, "立ち", 0)
		event.set_camera_position(136.75, 46.57, -242.89)
		event.set_camera_look_at(101.62, 35.0, -367.91)
		event.fade_in_screen(30)
		resume_step = 12
		wait.frames(30)
		return 1
	end, function(received: { any })
		if resume_step <= 1 then
			return -1
		end
		if resume_step <= 2 then
			return -1
		end
		if resume_step <= 12 then
			if resume_step <= 3 then
				wait.background_load_skipping()
			end
			if resume_step <= 4 then
				frame[6] = 1
				frame[6] = 0
				frame[12] = 0
				frame[13] = 0
				frame[14] = 0
				local _ = frame[45] == 1
				local _ = frame[6] < 6
				local _ = frame[6] == frame[8]
				frame[12] = 1
				frame[46] = 0
				local _ = frame[14] > frame[46]
				local _ = frame[vm.index(vm.i32(frame[46] + 14), 49)] == frame[7]
				frame[46] = vm.i32(frame[46] + 1)
				local _ = frame[14] == frame[46]
				frame[vm.index(vm.i32(frame[14] + 14), 49)] = frame[7]
				frame[14] = vm.i32(frame[14] + 1)
				local _ = vm.i32(frame[6] + 1) <= 3
				local _ = frame[13] == 0
				local _ = frame[13] == 1
				frame[13] = vm.i32(frame[13] + 1)
				frame[6] = vm.i32(frame[6] + 1)
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
				minigame.show_tournament_prize_skipping(0, vm.i32(frame[8] + 1), frame[47], frame[48])
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
			return 1
		end
		return nil
	end)
end

--- Runs the race host's conversation covering the rules, the prizes and entering a fish in a class.
local function talk_to_race_host()
	local host_slot: s32 = 0
	local playable_character: s32 = 0
	local extra_mode: s32 = 0
	local menu_result: s32 = 0
	local completed_stage_count: s32 = 0
	local menu_choice: any = 0
	local class_choice: any = 0
	local first_prize_item: s32 = 0
	local second_prize_item: s32 = 0
	local third_prize_item: s32 = 0
	local first_prize_amount: s32 = 0
	local second_prize_amount: s32 = 0
	local third_prize_amount: s32 = 0
	local heat_stage: s32 = 0
	local fish_count: s32 = 0
	local selected_fish: s32 = 0
	local available_class_mask: s32 = 0
	local has_won_prize: s32 = 0
	local race_class: any = 0
	host_slot = event.get_triggered_event_data_2(13) or host_slot
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(0, "立ち", 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character ~= 0 then
		event.open_message_window_2(0, "M[UNI00f6]chtest du auch mal mitmachen?")
		cutscene.talk(host_slot, -1, 0, 0)
		event.open_message_window_2(0, "Vielen Dank.<page>Das ist Max' Fachgebiet.")
		message.say_bubble(0, -1, 0, host_slot, 0)
		return
	end
	extra_mode = event.is_extra_mode() or extra_mode
	if extra_mode ~= 0 then
		event.open_event_menu(23, 0)
		vm.wait(3)
		event.fade_in_screen(15)
		do
			local out1, _, _, _ = event.get_menu_results_4()
			menu_result = out1 or menu_result
		end
		if menu_result == 1000 then
			event.fade_out_music(30)
			event.fade_out_screen(30)
			wait.frames(30)
			event.stop_music(0)
			fishing_town_pinna_sprint.warp_to_i03h05()
		end
		return
	end
	completed_stage_count = event.get_gyorace_value(5) or completed_stage_count
	if completed_stage_count >= 3 then
		event.open_message_window_2(0, "Das ist das Ende des Flossen-Fiebers.\nBis zum n[UNI00e4]chsten, hoffentlich!")
		cutscene.talk(host_slot, -1, 0, 0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
		event.stop_music(0)
		event.set_menu_value(1)
		fishing_town_pinna_sprint.clean_up_event()
		event.fade_in_screen(30)
		event.jump_to_map_2(-1, "s45")
		vm.wait(7)
	end
	event.open_message_window_2(0, "Das Flossen-Fieber beginnt!\nM[UNI00f6]chtest du mitmachen?")
	cutscene.talk(host_slot, -1, 0, 0)
	while true do
		event.open_message_window_2(0, "Mitmachen\nWorum geht's denn?\nWas gibt's zu gewinnen?\nLieber nicht.")
		menu_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 4, 3)
		if menu_choice == -1 or menu_choice == 3 then
			event.open_message_window_2(
				0,
				"Na klar, Zusehen macht Spa[UNI00df].\nAber richtig spannend ist\nes nur, wenn man mitmacht!"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			return
		end
		if menu_choice == 1 then
			event.open_message_window_2(
				0,
				"Bei jedem Flossen-Fieber-Turnier\ngibt es drei Rennen.<page>Wenn ein Fisch einen Preis gewinnt,\nkannst du ihn im selben Turnier\nnicht mehr einsetzen."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				'Sprich mich einfach an und\nsag mir, dass du mitmachen willst. W[UNI00e4]hle\ndann den Fisch, der teilnehmen soll.<page>Dein Fisch muss im "Erholungstank"\nsein, um an einem Rennen\nteilnehmen zu k[UNI00f6]nnen.'
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Wenn du einen Fisch gew[UNI00e4]hlt\nhast, bestimmst du die Klasse,\nin der er antritt.<page>W[UNI00e4]hle von Anf[UNI00e4]nger bis Meister\ndie Klasse, die der Stufe deines\nFisches am besten entspricht.<page>Hat ein Fisch in einer\nKlasse einmal gewonnen, kann er\nnur noch in der n[UNI00e4]chsth[UNI00f6]heren antreten."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Gewinnt ein Fisch aber in der\nMeister-Klasse, kann er beliebig oft\nwieder in dieser Klasse antreten.<page>Dann w[UNI00e4]hlst du den Tank, in dem sich\ndein Fisch auf das Rennen vorbereitet.<page>Das Wasser ist in jedem Tank anders\nund beeinflusst die Leistung\ndes Fischs."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Wenn du einen Tank w[UNI00e4]hlst, der die\nEigenschaften des Fischs verbessert,\nkann er viel besser abschneiden!<page>Wenn deine Vorbereitungen\nabgeschlossen sind, beginnt das Rennen.\nJetzt kannst du nur noch anfeuern!"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Die Rennen gehen vom 1. Lauf\n[UNI00fc]ber den 2. Lauf bis ins Finale.\nUm einen Preis zu holen,<page>muss dein Fisch im 1. Lauf 1. sein,\n2. oder besser im 2. Lauf und\n3. oder besser im Finale.<page>Aber dein Ziel ist nat[UNI00fc]rlich, immer\nErster zu sein.\nViel Gl[UNI00fc]ck!"
			)
			cutscene.talk(host_slot, -1, 0, 0)
		end
		if menu_choice == 2 then
			event.open_message_window_2(0, "Anf[UNI00e4]nger\nJunior\nSenior\nMeister")
			class_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 4, 0)
			if class_choice ~= -1 then
				event.open_message_window_2(0, "Die Preise sind ...")
				cutscene.talk(host_slot, -1, 0, 0)
				do
					local out1, out2 = event.get_gyorace_value(4, class_choice, 1)
					first_prize_item = out1 or first_prize_item
					first_prize_amount = out2 or first_prize_amount
				end
				do
					local out1, out2 = event.get_gyorace_value(4, class_choice, 2)
					second_prize_item = out1 or second_prize_item
					second_prize_amount = out2 or second_prize_amount
				end
				do
					local out1, out2 = event.get_gyorace_value(4, class_choice, 3)
					third_prize_item = out1 or third_prize_item
					third_prize_amount = out2 or third_prize_amount
				end
				fishing_town_pinna_sprint.show_prizes_message(first_prize_item, first_prize_amount, second_prize_item, second_prize_amount, third_prize_item, third_prize_amount)
			end
		end
		if menu_choice == 0 then
			break
		end
	end
	heat_stage = event.get_gyorace_value(3) or heat_stage
	fish_count = event.get_message_window_option(0, 2) or fish_count
	if fish_count < 1 then
		event.open_message_window_2(
			0,
			"Huch! Es scheint, als k[UNI00f6]nntest\ndu keinen Fisch eintragen.<page>Komm wieder, wenn du einen\naufgezogen hast."
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	completed_stage_count = event.get_gyorace_value(5) or completed_stage_count
	event.set_message_number(0, 1, vm.i32(completed_stage_count + 1))
	event.open_message_window_2(0, "Es ist Zeit f[UNI00fc]r Stufe [数値１].\nW[UNI00e4]hle deinen Fisch.")
	cutscene.talk(host_slot, -1, 0, 0)
	while true do
		event.open_event_menu(15, 0)
		vm.wait(22)
		do
			local out1, out2, out3 = event.get_menu_results_3()
			selected_fish = out1 or selected_fish
			available_class_mask = out2 or available_class_mask
			has_won_prize = out3 or has_won_prize
		end
		if selected_fish == -1 then
			return
		elseif has_won_prize ~= 0 then
			event.open_message_window_2(0, "Dieser Fisch hat schon gewonnen.\nW[UNI00e4]hle einen anderen Fisch.")
			cutscene.talk(host_slot, -1, 0, 0)
		else
			break
		end
	end
	if heat_stage == 0 then
		event.open_message_window_2(0, "Bestimme nun die Klasse des Fischs.")
		cutscene.talk(host_slot, -1, 0, 0)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "Anf[UNI00e4]nger\nJunior\nSenior\nMeister")
		event.set_message_selection_top_line(0, 0)
		race_class = message.ask_choice(0, -1, 8, 0, 0, 4, 0)
	else
		race_class = event.get_gyorace_value(2) or race_class
	end
	event.set_message_window_mode(0, 1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 0)
	event.set_message_window_option(0, 4, -1, -1)
	if race_class == -1 then
		return
	end
	if race_class == 0 and bit32.band(available_class_mask, 1) == 0 then
		event.open_message_window_2(
			0,
			"Dieser Fisch hat die Anf[UNI00e4]nger-\nKlasse bereits gewonnen.\nVersuch's doch in einer anderen!"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if race_class == 1 and bit32.band(available_class_mask, 2) == 0 then
		event.open_message_window_2(0, "Dieser Fisch hat die Junior-\nKlasse bereits gewonnen.\nVersuch's doch in einer anderen!")
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if race_class == 2 and bit32.band(available_class_mask, 4) == 0 then
		event.open_message_window_2(0, "Dieser Fisch hat die Senior-\nKlasse bereits gewonnen.\nVersuch's doch in einer anderen!")
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if heat_stage == 0 then
		event.set_gyorace_value(2, race_class)
	end
	choose_preparation_tank()
	vm.wait(30)
end

--- Shows the spectator's dialogue for the character that was spoken to, depending on the chapter and extra mode.
local function talk_to_spectator()
	local spectator_slot: s32 = 0
	local spectator_id: s32 = 0
	local playable_character: s32 = 0
	local chapter: s32 = 0
	local extra_mode: s32 = 0
	event.get_player_character_slot()
	spectator_slot = event.get_triggered_event_data_2(13) or spectator_slot
	spectator_id = event.get_triggered_event_data_2(14) or spectator_id
	print("talk_chara_id=", spectator_slot, "talk_chara=", spectator_id, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, spectator_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	playable_character = event.get_playable_character() or playable_character
	chapter = event.get_chapter() or chapter
	extra_mode = event.is_extra_mode() or extra_mode
	if spectator_id == 161 then
		if chapter < 6 then
			event.open_message_window_2(
				0,
				"Warum versteht meine Frau nicht,\nwie viel Spa[UNI00df] das macht? Nichts\nist besser als Flossen-Fieber!"
			)
		else
			event.open_message_window_2(
				0,
				"Mein Fisch holt in der Meister-\nKlasse immer den Sieg.<page>Vertrau mir, er r[UNI00e4]umt auch\ndiesmal ab."
			)
		end
	end
	if spectator_id == 171 then
		event.open_message_window_2(
			0,
			"Ich suche nur meinen\nMann. Er ist immer hier.<page>Liebe G[UNI00fc]te, das sieht aus,\nals k[UNI00f6]nnte es spannend werden."
		)
	end
	if spectator_id == 169 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"Die Renn-Ergebnisse h[UNI00e4]ngen\nentscheidend von der Vorbereitung ab.\nW[UNI00e4]hle deinen Tank sorgf[UNI00e4]ltig.<page>Na ja, meinen Fisch schl[UNI00e4]gst du\nnat[UNI00fc]rlich sowieso nicht ..."
			)
		else
			event.open_message_window_2(
				0,
				"Du schon wieder, ja?\nDu lernst es wohl nie.<page>Wenn du teilnehmen willst,\nkein Problem. Komm nur meinem\nFisch nicht in die Quere!"
			)
		end
	end
	if spectator_id == 167 then
		if chapter < 7 then
			if playable_character ~= 1 then
				event.open_message_window_2(
					0,
					"Machst du auch mit, Max?\nSag mir Bescheid, wenn du's tust -\ndann feure ich dich an!"
				)
			else
				event.open_message_window_2(
					0,
					"Machst du auch mit, Monica?\nSag mir Bescheid, wenn du's tust -\ndann feure ich dich an!"
				)
			end
		elseif playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"Ich mag keine Fische.\nIch will heim!<page>Was finden die Erwachsenen\nblo[UNI00df] so toll hier? Hm, Max?"
			)
		else
			event.open_message_window_2(
				0,
				"Ich mag keine Fische.\nIch will heim!<page>Was finden die Erwachsenen\nblo[UNI00df] so toll hier? Hm, Monica?"
			)
		end
	end
	if spectator_id == 166 then
		event.open_message_window_2(
			0,
			"Eigentlich wette ich nie.<page>Meine Freundin hat drauf bestanden,\ndas ist der einzige Grund ..."
		)
	end
	if spectator_id == 165 then
		if chapter < 7 then
			event.open_message_window_2(
				0,
				"Ich wei[UNI00df] nicht wieso, aber es macht\nmich ganz kribbelig, den\nFischen zuzusehen.<page>Das ist so eine Art Jungbrunnen\nf[UNI00fc]r mich."
			)
		else
			event.open_message_window_2(0, "Ich hab mein Enkelchen dabei.\nWo ist es denn jetzt?<page>Kaum dreht man sich um ...")
		end
	end
	if spectator_id == 160 then
		event.open_message_window_2(
			0,
			"Mein Fisch gl[UNI00e4]nzt auf\nden Geraden.<page>Welcher meiner ist?\n*kicher*\nStreng geheim."
		)
	end
	if spectator_id == 172 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"Sieh dir die Schuppen von 3 an!\nGl[UNI00e4]nzend und glitzernd!<page>So sieht ein Sieger aus!\nWirst schon sehen!"
			)
		else
			event.open_message_window_2(
				0,
				"Ich wollte die Rennen nur mal\nausprobieren, aber jetzt bin ich\ns[UNI00fc]chtig und verpasse nie eins!<page>(seufz) Meine letzte Renn-Vorbereitung\nhab ich wirklich verbockt ..."
			)
		end
	end
	if spectator_id == 158 then
		if chapter < 7 then
			event.open_message_window_2(
				0,
				"Ich angle oft mit meinem Vater,\naber hier gibt es alle m[UNI00f6]glichen\nFische, die ich<page>noch nie gesehen habe!"
			)
		else
			event.open_message_window_2(
				0,
				"Wow! Sieh nur, die ganzen s[UNI00fc][UNI00df]en\nFische! Liebe G[UNI00fc]te, der sieht aus\nwie ein Pferd!<page>H[UNI00e4]h? Wo bist du,\nOpa? Opa!"
			)
		end
	end
	if spectator_id == 159 then
		event.open_message_window_2(0, "Dies ist das Flossen-Fieber-\nWettrennen.<page>Also bitte!\nNicht gleich ausrasten ...")
	end
	if spectator_id == 162 then
		event.open_message_window_2(
			0,
			"Hier findet das Flossen-\nFieber-Rennen statt.<page>Entspann dich einfach\nund genie[UNI00df]e es!"
		)
	end
	if spectator_id == 168 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"Fische sehen doch alle gleich aus.\nWie unterscheidet man sie?<page>Ich muss wohl meinem\nGef[UNI00fc]hl vertrauen."
			)
		else
			event.open_message_window_2(
				0,
				"Der Fisch meines Freunds startet\nim n[UNI00e4]chsten Rennen. Ich bin so\naufgeregt - ich halt's nicht aus!"
			)
		end
	end
	cutscene.talk(spectator_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, spectator_slot)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Intentionally empty handler for event 99.
function script.do_nothing() end
script[99] = script.do_nothing

--- Initializes the race state, places the villagers and the player when the hall is entered.
function script.default_event()
	event.initialize_event()
	race_sound_bank = 0
	results_sound_bank = 0
	event.set_save_control_bits(1, 1)
	fishing_town_pinna_sprint.place_villagers()
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 1)
	event.set_gyorace_value(7)
	event.set_character_position(0, 0.0, 0.0, 450.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1, 3.14)
end

--- Plays the consolation message and the race results board after the player was eliminated.
function script.key_open()
	event.open_message_window_2(
		0,
		"Oh, wie schade. Aber du kannst\nstolz sein, dass du Finalist warst!\nIch hoffe, wir sehen uns wieder -\nversuch's weiter!"
	)
	message.say_bubble(0, -1, 24, 0, 0)
	race_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or race_sound_bank
	results_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or results_sound_bank
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(race_sound_bank, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	wait.frames(90)
	event.stop_sound_effect(race_sound_bank, 0)
	event.play_sound_effect(race_sound_bank, 3)
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	for i = 0, 5 do
		event.set_message_inserted_string(1, 1 + i, "０１２３４５６７８９ ")
		event.set_message_inserted_string(1, 7 + i, "９９：９９：９９")
	end
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          RANG      Name            Zeit\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          RANG      Name            Zeit\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          RANG      Name            Zeit\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
	)
	message.show(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	wait.frames(35)
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end

--- Asks whether to leave the race hall and leaves for the town map or ends the extra mode scene when the player agrees.
function script.ask_to_leave_race_area()
	local extra_mode: s32 = 0
	local completed_stage_count: s32 = 0
	local choice: any = 0
	extra_mode = event.is_extra_mode() or extra_mode
	completed_stage_count = event.get_gyorace_value(5) or completed_stage_count
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	vm.wait(1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	if extra_mode == 0 then
		if completed_stage_count <= 0 then
			event.open_message_window_2(0, "Flossen-Fieber verlassen?")
		else
			event.open_message_window_2(0, "Wenn du gehst, endet das Turnier.\nWillst du wirklich gehen?")
		end
	else
		event.fade_out_screen(10)
		wait.frames(10)
		event.open_event_menu(26)
		vm.wait(3)
		event.fade_in_screen(10)
		event.open_message_window_2(0, "Zur[UNI00fc]ck zum Titel-Bildschirm?")
	end
	choice = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
	event.set_message_window_mode(0, 1)
	if choice == 0 then
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
		event.stop_music(0)
		if 0 < completed_stage_count then
			event.set_menu_value(1)
		end
		fishing_town_pinna_sprint.clean_up_event()
		event.fade_in_screen(30)
		if extra_mode == 0 then
			event.jump_to_map_2(-1, "s45")
			vm.wait(6)
		else
			event.set_scene_exit_flag(1)
		end
	end
	return 1
end
script[202] = script.ask_to_leave_race_area

--- Prints a debug marker for event 401.
function script.print_event_401_marker()
	print("---401----------------------------\n")
end
script[401] = script.print_event_401_marker

--- Shows the race results and plays the consolation message when the fish was eliminated.
function script.cutscene_finish_race()
	local race_result: s32 = 0
	local heat_stage: s32 = 0
	event.initialize_event()
	event.set_save_control_bits(1, 1)
	event.load_music(193)
	race_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or race_sound_bank
	results_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or results_sound_bank
	race_result = show_race_results()
	event.play_music(0)
	if race_result == 0 then
		event.set_character_motion(0, "がっかりL", 0)
		heat_stage = event.get_gyorace_value(3) or heat_stage
		if heat_stage == 0 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(0, "Oh, schade!\nNa ja, gib nicht auf.\nVersuch's nochmal!")
		end
		if heat_stage == 1 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"Tja, im 2. Lauf weht ein rauer Wind.\nNa ja, was soll's.\nGib nicht auf. Versuch's weiter!"
			)
		end
		if heat_stage == 2 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"Oh, wie schade. Aber du kannst\nstolz sein, dass du Finalist warst!\nIch hoffe, wir sehen uns wieder -\nversuch's weiter!"
			)
		end
		message.say_bubble(0, -1, 24, 0, 0)
	end
	event.delete_character_extension_packs(0)
end
script[502] = script.cutscene_finish_race

--- Shows the ranking board for the race and fades the hall back in.
function script.cutscene_show_ranking_board()
	local i: s32 = 0
	local language_code: s32 = 0
	event.set_save_control_bits(1, 1)
	event.initialize_event()
	event.load_music(193)
	fishing_town_pinna_sprint.place_villagers()
	race_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or race_sound_bank
	results_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or results_sound_bank
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(race_sound_bank, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	wait.frames(90)
	event.stop_sound_effect(race_sound_bank, 0)
	event.play_sound_effect(race_sound_bank, 3)
	i = 1
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	i = 0
	language_code = event.get_language() or language_code
	if language_code == 1 then
		event.set_message_window_option(1, 2, 0.5)
	end
	while i < 6 do
		event.set_gyorace_value(5, 1, 1 + i, i)
		event.set_gyorace_value(6, 1, 7 + i, i)
		i = i + 1
	end
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          RANG      Name            Zeit\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          RANG      Name            Zeit\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          RANG      Name            Zeit\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
	)
	message.show(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	wait.frames(35)
	event.play_music(0)
	if language_code == 1 then
		event.set_message_window_option(1, 2, -1)
	end
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end
script[503] = script.cutscene_show_ranking_board

--- Starts the race host's conversation or a spectator's dialogue depending on who was spoken to.
function script.on_talk()
	local talk_slot: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		talk_slot = event.get_triggered_event_data_2(13) or talk_slot
		if talk_slot == 24 then
			resume_step = 1
			talk_to_race_host()
		else
			resume_step = 2
			talk_to_spectator()
		end
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				fishing_town_pinna_sprint.talk_to_npc()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.on_talk

return script
