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
			event.open_message_window_2(0, "Choisis un aquarium d'entra[UNI00ee]nement.")
		end
		if heat_stage == 1 then
			event.open_message_window_2(0, "Tr[UNI00e8]s bien jou[UNI00e9] !\nAllez, on passe au 2e tour.")
			resume_step = 1
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(0, "Choisis maintenant l'aquarium\nd'entra[UNI00ee]nement de ton 2e tour.")
		end
		if heat_stage == 2 then
			event.open_message_window_2(
				0,
				"F[UNI00e9]licitations ! Te voil[UNI00e0] en finale.\nChoisis judicieusement ton aquarium\nd'entra[UNI00ee]nement pr[UNI00e9]liminaire !"
			)
		end
		resume_step = 2
		cutscene.talk(host_slot, -1, 0, 0)
		while true do
			event.set_message_window_mode(0, 8)
			event.set_message_window_option(0, 0, 0)
			event.open_message_window_2(
				0,
				"1er aquarium : Garde le rythme\n2e aquarium : De toutes tes forces\n3e aquarium : Viens te battre\n4e aquarium : De grands progr[UNI00e8]s\n5e aquarium : Sur le ring !\n6e aquarium : Dans la m[UNI00ea]l[UNI00e9]e"
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
						"Si tu ne choisis pas d'aquarium, tu\nseras [UNI00e9]limin[UNI00e9] de cette course.\nTu es s[UNI00fb]r ?"
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
				"On attaque le 1er tour. Tu dois\nfinir en 1[UNI00e8]re place pour passer au\n2e tour. Bonne chance !"
			)
			event.set_gyorace_value(3, 0)
			event.set_gyorace_value(4)
		end
		if heat_stage == 1 then
			event.open_message_window_2(
				0,
				"On attaque le 2e tour !\nFinis en 2e place ou mieux pour\naller en finale. Bonne chance !"
			)
		end
		if heat_stage == 2 then
			event.open_message_window_2(
				0,
				"Bien, tu es pr[UNI00ea]t. Nous voici\ndonc en finale ! Pour gagner un\nprix, il faut finir 3e ou mieux.<page>Mais bien s[UNI00fb]r, ton objectif\nest de terminer premier !"
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
			"          CLASSEMENT      Nom            Temps\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
		)
		resume_step = 5
		message.show_timed(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"          CLASSEMENT      Nom            Temps\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
		)
		resume_step = 6
		message.show_timed(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"          CLASSEMENT      Nom            Temps\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
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
		event.open_message_window_2(0, "Vous voulez aussi essayer, Melle ?")
		cutscene.talk(host_slot, -1, 0, 0)
		event.open_message_window_2(0, "[UNI00c7]a va, merci.<page>C'est plut[UNI00f4]t un truc de Max.")
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
		event.open_message_window_2(0, "Ainsi se terminent les Meilleures\nnageoires. [UNI00c0] la prochaine ?")
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
	event.open_message_window_2(0, "Le tournoi des Meilleures nageoires\nva commencer ! Tu veux participer ?")
	cutscene.talk(host_slot, -1, 0, 0)
	while true do
		event.open_message_window_2(0, "Participer\nEn quoi [UNI00e7]a consiste ?\nQuels sont les prix ?\nNon merci")
		menu_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 4, 3)
		if menu_choice == -1 or menu_choice == 3 then
			event.open_message_window_2(
				0,
				"Le spectacle est super, c'est s[UNI00fb]r !\nMais participer te donne une\nde ces pouss[UNI00e9]es d'adr[UNI00e9]naline !"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			return
		end
		if menu_choice == 1 then
			event.open_message_window_2(
				0,
				"Chaque tournoi de Meilleures\nnageoires comporte 3 courses.<page>Quand un poisson remporte un prix,\nil ne peut plus participer [UNI00e0]\nd'autres courses du m[UNI00ea]me tournoi."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				'Il suffit de venir me dire que tu\nveux participer. Choisis ensuite\nle poisson coureur de ton choix.<page>Ton poisson doit se trouver dans\nl\'"aquarium de repos" pour\npouvoir participer [UNI00e0] une course.'
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Ton poisson choisi, s[UNI00e9]lectionne la\ncat[UNI00e9]gorie dans laquelle il courra.<page>De D[UNI00e9]butant [UNI00e0] Master, choisis la\ncat[UNI00e9]gorie la mieux adapt[UNI00e9]e au\nniveau de ton poisson.<page>Quand ton poisson a gagn[UNI00e9] dans une\ncat[UNI00e9]gorie, il ne peut participer\nqu'[UNI00e0] la cat[UNI00e9]gorie sup[UNI00e9]rieure."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Quand un poisson remporte la plus\nhaute cat[UNI00e9]gorie (Master), tu peux\nl'y r[UNI00e9]inscrire quand tu veux.<page>Tu choisis ensuite son aquarium\nd'entra[UNI00ee]nement final.<page>L'eau de chaque aquarium est\nl[UNI00e9]g[UNI00e8]rement diff[UNI00e9]rente et changera\nles performances du poisson."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Si tu places ton poisson dans un\naquarium am[UNI00e9]liorant ses capacit[UNI00e9]s,\nses scores risqueront de t'[UNI00e9]tonner.<page>Quand l'entra[UNI00ee]nement pr[UNI00e9]liminaire\nest termin[UNI00e9], place [UNI00e0] la course, [UNI00e0]\nla d[UNI00e9]tente et aux encouragements !"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Les courses ont un 1er tour, un\nsecond, puis une finale.\nPour remporter un prix,<page>ton poisson doit [UNI00ea]tre 1er du 1er\ntour, 2e ou mieux du second,\npuis 3e ou mieux en finale.<page>[UNI00c9]videmment, ton objectif\nest de finir 1er [UNI00e0] chaque tour.\nBonne chance !"
			)
			cutscene.talk(host_slot, -1, 0, 0)
		end
		if menu_choice == 2 then
			event.open_message_window_2(0, "D[UNI00e9]butant\nJunior\nV[UNI00e9]t[UNI00e9]ran\nMaster")
			class_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 4, 0)
			if class_choice ~= -1 then
				event.open_message_window_2(0, "Voici les prix pour cette course...")
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
			"Ah ! On dirait que tu n'as aucun\npoisson [UNI00e0] inscrire.<page>Reviens quand tu en auras\ndress[UNI00e9] quelques-uns."
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	completed_stage_count = event.get_gyorace_value(5) or completed_stage_count
	event.set_message_number(0, 1, vm.i32(completed_stage_count + 1))
	event.open_message_window_2(0, "Passons [UNI00e0] l'[UNI00e9]tape [数値１].\nChoisis ton poisson.")
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
			event.open_message_window_2(0, "Ce poisson a d[UNI00e9]j[UNI00e0] remport[UNI00e9] un prix.\nChoisis-en un autre.")
			cutscene.talk(host_slot, -1, 0, 0)
		else
			break
		end
	end
	if heat_stage == 0 then
		event.open_message_window_2(0, "Puis choisis ta cat[UNI00e9]gorie.")
		cutscene.talk(host_slot, -1, 0, 0)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "D[UNI00e9]butant\nJunior\nV[UNI00e9]t[UNI00e9]ran\nMaster")
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
			"Ce poisson a d[UNI00e9]j[UNI00e0] gagn[UNI00e9] la\ncat[UNI00e9]gorie D[UNI00e9]butant. Pourquoi ne pas\nessayer une autre cat[UNI00e9]gorie ?"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if race_class == 1 and bit32.band(available_class_mask, 2) == 0 then
		event.open_message_window_2(
			0,
			"Ce poisson a d[UNI00e9]j[UNI00e0] gagn[UNI00e9] la\ncat[UNI00e9]gorie Junior. Pourquoi ne pas\nessayer une autre cat[UNI00e9]gorie ?"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if race_class == 2 and bit32.band(available_class_mask, 4) == 0 then
		event.open_message_window_2(
			0,
			"Ce poisson a d[UNI00e9]j[UNI00e0] gagn[UNI00e9] la\ncat[UNI00e9]gorie Senior. Pourquoi ne pas\nessayer une autre cat[UNI00e9]gorie ?"
		)
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
	event.open_message_window_2(0, "Bonjouuuur.\nBeau temps, non ?")
	playable_character = event.get_playable_character() or playable_character
	chapter = event.get_chapter() or chapter
	extra_mode = event.is_extra_mode() or extra_mode
	if spectator_id == 161 then
		if chapter < 6 then
			event.open_message_window_2(
				0,
				"Comment ma femme peut-elle ne pas \ntrouver [UNI00e7]a amusant ? Les \nMeilleures nageoires, c'est top !"
			)
		else
			event.open_message_window_2(
				0,
				"Mon poisson rafle tous les prix\nde la cat[UNI00e9]gorie Master.<page>Crois-moi, il va aussi gagner\ncette course."
			)
		end
	end
	if spectator_id == 171 then
		event.open_message_window_2(
			0,
			"Je suis venue chercher mon mari.\nIl tra[UNI00ee]ne toujours par ici.<page>Oh, mais dites-moi, tout ceci\nme para[UNI00ee]t bien excitant."
		)
	end
	if spectator_id == 169 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"Tout est une question\nd'entra[UNI00ee]nement... et de choix\nd'aquarium.<page>Mais de toute fa[UNI00e7]on, tu ne pourras\njamais vaincre mon poisson..."
			)
		else
			event.open_message_window_2(
				0,
				"Ah, encore toi ?\nTu comprends rien, hein ?<page>Si tu veux participer,\ntu peux. Mais ne te mets pas\nsur le chemin de mon poisson !"
			)
		end
	end
	if spectator_id == 167 then
		if chapter < 7 then
			if playable_character ~= 1 then
				event.open_message_window_2(
					0,
					"Max, tu ne participes pas [UNI00e0] la\ncourse ? Si oui, tiens-moi au\ncourant, je t'encouragerai !"
				)
			else
				event.open_message_window_2(
					0,
					"Monica, tu ne participes pas [UNI00e0] la\ncourse ? Si oui, tiens-moi au\ncourant, je t'encouragerai !"
				)
			end
		elseif playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"Je n'aime pas les poissons.\nJe veux rentrer [UNI00e0] la maison !<page>Pourquoi les adultes, ils aiment\ntant [UNI00e7]a ? Hein, dis Max ?"
			)
		else
			event.open_message_window_2(
				0,
				"Je n'aime pas les poissons.\nJe veux rentrer [UNI00e0] la maison !<page>Pourquoi les adultes, ils aiment\ntant [UNI00e7]a ? Hein, dis Monica ?"
			)
		end
	end
	if spectator_id == 166 then
		event.open_message_window_2(
			0,
			"En g[UNI00e9]n[UNI00e9]ral, je ne parie pas.<page>Mais ma copine a vraiment insist[UNI00e9],\nc'est pour [UNI00e7]a..."
		)
	end
	if spectator_id == 165 then
		if chapter < 7 then
			event.open_message_window_2(
				0,
				"C'est fou comme la simple vue d'un\npoisson qui nage me donne la p[UNI00ea]che.<page>C'est, comme qui dirait, ma\nfontaine de jouvence."
			)
		else
			event.open_message_window_2(
				0,
				"Ma petite-fille est avec moi\naujourd'hui. Elle est pass[UNI00e9]e o[UNI00f9] !?<page>On se retourne une seconde et..."
			)
		end
	end
	if spectator_id == 160 then
		event.open_message_window_2(0, "Mon poisson est\nchampion en ligne droite.<page>Lequel c'est ?\nHi hi\nC'est top secret.")
	end
	if spectator_id == 172 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"Regarde les [UNI00e9]cailles du Num[UNI00e9]ro 3 !\nLisses, brillantes !<page>Un vrai gagnant, tu vas voir !"
			)
		else
			event.open_message_window_2(
				0,
				"Je ne voulais faire qu'une course,\nmais je suis devenue accro. Je n'en\nmanquerais une pour rien au monde !<page>(soupir) Mon dernier entra[UNI00ee]nement\na [UNI00e9]t[UNI00e9] catastrophique..."
			)
		end
	end
	if spectator_id == 158 then
		if chapter < 7 then
			event.open_message_window_2(
				0,
				"Je p[UNI00ea]che souvent avec mon p[UNI00e8]re,\nmais il y a plein de poissons\nici que j'avais jamais vus avant !"
			)
		else
			event.open_message_window_2(
				0,
				"Ooh ! Regarde les jolis petits\npoissons ! Oh la la, celui-l[UNI00e0],\non dirait un petit cheval !<page>Hein ? Mais t'es pass[UNI00e9] o[UNI00f9]\nPapi ? Papi !"
			)
		end
	end
	if spectator_id == 159 then
		event.open_message_window_2(
			0,
			"Voici le concours des\nMeilleures nageoires.<page>Mesdames et Messieurs !\nNe vous laissez pas emporter..."
		)
	end
	if spectator_id == 162 then
		event.open_message_window_2(0, "Voici les Meilleures nageoires.<page>Allez, on se d[UNI00e9]tend et on\ns'amuse !")
	end
	if spectator_id == 168 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"Je suis incapable de diff[UNI00e9]rencier\nun poisson d'un autre. Que faire ?<page>Je vais devoir me fier [UNI00e0] mon\ninstinct, je suppose."
			)
		else
			event.open_message_window_2(
				0,
				"Le poisson de mon copain va courir\ndans la prochaine course. Je suis\n[UNI00e0] la fois excit[UNI00e9]e et stress[UNI00e9]e !"
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
		"Quel dommage. Mais quelle fiert[UNI00e9]\nd'avoir termin[UNI00e9] en finale !\nPoursuis tes efforts, je serai\ntoujours l[UNI00e0] pour t'encourager !"
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
		"          CLASSEMENT      Nom            Temps\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          CLASSEMENT      Nom            Temps\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          CLASSEMENT      Nom            Temps\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
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
			event.open_message_window_2(0, "Quitter les Meilleures nageoires ?")
		else
			event.open_message_window_2(
				0,
				"Le tournoi des Meilleures\nnageoires s'arr[UNI00ea]tera si tu pars.\nTu veux vraiment partir ?"
			)
		end
	else
		event.fade_out_screen(10)
		wait.frames(10)
		event.open_event_menu(26)
		vm.wait(3)
		event.fade_in_screen(10)
		event.open_message_window_2(0, "Retourner [UNI00e0] l'[UNI00e9]cran de titre ?")
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
			event.open_message_window_2(0, "Oh, pas de chance !\nN'abandonne pas. Essaie encore !")
		end
		if heat_stage == 1 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"La concurrence est rude dans\nce second tour ! Peu importe.\nContinue. Allez, essaie encore !"
			)
		end
		if heat_stage == 2 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"Quel dommage. Mais quelle fiert[UNI00e9]\nd'avoir termin[UNI00e9] en finale !\nPoursuis tes efforts, je serai\ntoujours l[UNI00e0] pour t'encourager !"
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
		"          CLASSEMENT      Nom            Temps\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          CLASSEMENT      Nom            Temps\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          CLASSEMENT      Nom            Temps\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
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
