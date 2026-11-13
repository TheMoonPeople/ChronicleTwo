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
			event.open_message_window_2(0, "Elige la pecera de calentamiento.")
		end
		if heat_stage == 1 then
			event.open_message_window_2(0, "[UNI00a1]Muy bien!\nVenga, a por la segunda eliminatoria.")
			resume_step = 1
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(0, "Elige la pecera de\ncalentamiento para la 2[UNI00aa] eliminatoria.")
		end
		if heat_stage == 2 then
			event.open_message_window_2(
				0,
				"[UNI00a1]Guau! [UNI00a1]Enhorabuena! Has llegado\na la final. Elige bien la pecera\nde calentamiento."
			)
		end
		resume_step = 2
		cutscene.talk(host_slot, -1, 0, 0)
		while true do
			event.set_message_window_mode(0, 8)
			event.set_message_window_option(0, 0, 0)
			event.open_message_window_2(
				0,
				"1[UNI00aa] pecera: Ritmo constante\n2[UNI00aa] pecera: A toda pastilla\n3[UNI00aa] pecera: Sal con u[UNI00f1]as y dientes\n4[UNI00aa] pecera: los [UNI00fa]ltimos ser[UNI00e1]n los primeros\n5[UNI00aa] pecera: Pasa por el aro\n6[UNI00aa] pecera: Qu[UNI00e9]date en el medio"
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
						"Si no eliges una pecera, ser[UNI00e1]s\nexpulsado de la carrera.\n[UNI00bf]Est[UNI00e1]s decidido?"
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
				"A por la primera eliminatoria.\nTienes que quedar el primero para pasar a la segunda eliminatoria.\n [UNI00a1]Suerte!"
			)
			event.set_gyorace_value(3, 0)
			event.set_gyorace_value(4)
		end
		if heat_stage == 1 then
			event.open_message_window_2(
				0,
				"A por la 2[UNI00aa] eliminatoria.\nTienes que quedar 2[UNI00ba] o mejor para pasar\na la final. [UNI00a1]Suerte!"
			)
		end
		if heat_stage == 2 then
			event.open_message_window_2(
				0,
				"Bueno, ya est[UNI00e1]n hechos los preparativos. [UNI00a1]Es\nhora de correr la final! Llega el 3[UNI00ba] o mejor si quieres\nganar un premio.<page>[UNI00a1]Pero t[UNI00fa] apunta siempre\na lo m[UNI00e1]s alto!"
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
			"          PUESTO      Nombre            Tiempo\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
		)
		resume_step = 5
		message.show_timed(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"          Puesto      Nombre            Tiempo\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
		)
		resume_step = 6
		message.show_timed(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(race_sound_bank, 4)
		event.open_message_window_2(
			1,
			"          Puesto      Nombre            Tiempo\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
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
		event.open_message_window_2(0, "[UNI00bf]Quiere probar usted tambi[UNI00e9]n, se[UNI00f1]orita?")
		cutscene.talk(host_slot, -1, 0, 0)
		event.open_message_window_2(0, "Gracias, pero no.<page>Esto es cosa de Max.")
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
		event.open_message_window_2(0, "Y as[UNI00ed] acaba el Finny Frenzy.\n[UNI00a1]Espero veros la pr[UNI00f3]xima vez!")
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
	event.open_message_window_2(0, "Est[UNI00e1] a punto de empezar el Finny Frenzy.\n[UNI00bf]Quieres participar?")
	cutscene.talk(host_slot, -1, 0, 0)
	while true do
		event.open_message_window_2(
			0,
			"Participar\n[UNI00bf]De qu[UNI00e9] se trata?\n[UNI00bf]Qu[UNI00e9] premios dan?\nNo, gracias"
		)
		menu_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 4, 3)
		if menu_choice == -1 or menu_choice == 3 then
			event.open_message_window_2(
				0,
				"Ver las carreras es divertido.\n[UNI00a1]Pero si compites se te dispara\nel coraz[UNI00f3]n de la emoci[UNI00f3]n!"
			)
			cutscene.talk(host_slot, -1, 0, 0)
			return
		end
		if menu_choice == 1 then
			event.open_message_window_2(
				0,
				"En cada torneo de Finny Frenzy\nhay 3 carreras.<page>Cuando un pez gana un premio,\nno puede participar en ninguna otra carrera\ndel mismo torneo."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				'Habla conmigo y dime\nsi quieres participar. Luego elige\nel pez con el que quieras competir.<page>El pez debe estar en\nla "Pecera de preparaci[UNI00f3]n".'
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Cuando hayas elegido al pez, elige\nla categor[UNI00ed]a.<page>Escoge la m[UNI00e1]s apropiada,\ndesde Novato hasta Profesional, seg[UNI00fa]n el nivel\ndel pez.<page>Si un pez gana en\nuna categor[UNI00ed]a, s[UNI00f3]lo podr[UNI00e1] participar\nen la inmediatamente superior."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Pero si un pez gana en la categor[UNI00ed]a\nProfesional, podr[UNI00e1] seguir\nparticipando en ella indefinidamente.<page>Luego, elige la pecera para\nhacer los [UNI00fa]ltimos preparativos antes de la carrera.<page>El agua de las peceras es\n,diferente e influir[UNI00e1] en\nel rendimiento del pez."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Si metes un pez en una pecera\nque potencie sus habilidades, a lo mejor\nobtienes unos resultados sorprendentes.<page>Cuando hayas acabado con los preparativos,\ns[UNI00f3]lo habr[UNI00e1] que esperar al comienzo de la carrera.\nPonte c[UNI00f3]modo y anima a tu pez."
			)
			cutscene.talk(host_slot, -1, 0, 0)
			event.open_message_window_2(
				0,
				"La competici[UNI00f3]n consta\nde dos eliminatorias m[UNI00e1]s la final.\nPara ganar un premio,<page>tu pez debe quedar 1[UNI00ba] en la 1[UNI00aa] eliminatoria,\n2[UNI00ba] o mejor en la 2[UNI00aa] eliminatoria\ny 3[UNI00ba] o mejor en la final.<page>Claro que lo m[UNI00e1]s conveniente es quedar\nprimero en todas las carreras.\n[UNI00a1]Suerte!"
			)
			cutscene.talk(host_slot, -1, 0, 0)
		end
		if menu_choice == 2 then
			event.open_message_window_2(0, "Novato\nAficionado\nExperto\nProfesional")
			class_choice = message.ask_bubble_choice(0, -1, 0, host_slot, 4, 0)
			if class_choice ~= -1 then
				event.open_message_window_2(0, "Los premios de esta carrera son...")
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
			"[UNI00a1]Vaya! Parece que no tienes\nning[UNI00fa]n pez que valga.<page>Vuelve cuando hayas cogido\nalguno."
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	completed_stage_count = event.get_gyorace_value(5) or completed_stage_count
	event.set_message_number(0, 1, vm.i32(completed_stage_count + 1))
	event.open_message_window_2(0, "A por todas[数値１].\nElige un pez.")
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
			event.open_message_window_2(0, "Ese pez ya ha ganado un premio.\nElige otro.")
			cutscene.talk(host_slot, -1, 0, 0)
		else
			break
		end
	end
	if heat_stage == 0 then
		event.open_message_window_2(0, "Ahora elige una categor[UNI00ed]a.")
		cutscene.talk(host_slot, -1, 0, 0)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "Novato\nAficionado\nExperto\nProfesional")
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
			"El pez ya ha ganado en la categor[UNI00ed]a Principiante.\n[UNI00bf]Por qu[UNI00e9] no pruebas en otra?"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if race_class == 1 and bit32.band(available_class_mask, 2) == 0 then
		event.open_message_window_2(
			0,
			"El pez ya ha ganado en la categor[UNI00ed]a Aficionado.\n[UNI00bf]Por qu[UNI00e9] no pruebas en otra?"
		)
		cutscene.talk(host_slot, -1, 0, 0)
		return
	end
	if race_class == 2 and bit32.band(available_class_mask, 4) == 0 then
		event.open_message_window_2(
			0,
			"El pez ya ha ganado en la categor[UNI00ed]a Experto.\n[UNI00bf]Por qu[UNI00e9] no pruebas en otra?"
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
	event.open_message_window_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	playable_character = event.get_playable_character() or playable_character
	chapter = event.get_chapter() or chapter
	extra_mode = event.is_extra_mode() or extra_mode
	if spectator_id == 161 then
		if chapter < 6 then
			event.open_message_window_2(
				0,
				"[UNI00bf]Por qu[UNI00e9] no le ver[UNI00e1] mi mujer\nla gracia a esto? [UNI00a1]No hay nada mejor\nque el Finny Frenzy!"
			)
		else
			event.open_message_window_2(
				0,
				"Mi pez est[UNI00e1] entre los ganadores\nde la categor[UNI00ed]a profesional.<page>T[UNI00fa] f[UNI00ed]ate de m[UNI00ed], tambi[UNI00e9]n va a arrasar\nen esta carrera."
			)
		end
	end
	if spectator_id == 171 then
		event.open_message_window_2(
			0,
			"Yo he venido a buscar\na mi marido. Siempre est[UNI00e1] aqu[UNI00ed].<page>[UNI00a1]Oh! Qu[UNI00e9] emocionante parece esto..."
		)
	end
	if spectator_id == 169 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"Los resultados de la carrera dependen\nen gran medida del calentamiento.\nElige bien la pecera.<page>Aunque, de todas formas, no conseguir[UNI00e1]s\nganar a mi equipo..."
			)
		else
			event.open_message_window_2(
				0,
				"[UNI00bf]T[UNI00fa] otra vez?\n[UNI00bf]Es que nunca aprendes?<page>Si quieres participar,\npor m[UNI00ed] vale, pero ten cuidado\ncon mi pez."
			)
		end
	end
	if spectator_id == 167 then
		if chapter < 7 then
			if playable_character ~= 1 then
				event.open_message_window_2(
					0,
					"Max, [UNI00bf]t[UNI00fa] no compites?\nSi participas, av[UNI00ed]same.\nTe animar[UNI00e9]."
				)
			else
				event.open_message_window_2(
					0,
					"M[UNI00f3]nica, [UNI00bf]t[UNI00fa] no compites?\nSi participas, av[UNI00ed]same.\nTe animar[UNI00e9]."
				)
			end
		elseif playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"No me gusta el pescado.\n[UNI00a1]Vamos a casa!<page>[UNI00bf]Por qu[UNI00e9] a los mayores les\ngusta tanto esto? [UNI00bf]Max?"
			)
		else
			event.open_message_window_2(
				0,
				"No me gusta el pescado.\n[UNI00a1]Vamos a casa!<page>[UNI00bf]Por qu[UNI00e9] a los mayores les\ngusta tanto esto? [UNI00bf]M[UNI00f3]nica?"
			)
		end
	end
	if spectator_id == 166 then
		event.open_message_window_2(
			0,
			"Yo nunca apuesto, la verdad.<page>Es que mi novia insisti[UNI00f3] tanto que claro... Pero s[UNI00f3]lo por eso..."
		)
	end
	if spectator_id == 165 then
		if chapter < 7 then
			event.open_message_window_2(
				0,
				"No s[UNI00e9] por qu[UNI00e9], pero ver nadar\na los peces me pone el coraz[UNI00f3]n a cien.<page>Es como mi\nfuente de juventud particular."
			)
		else
			event.open_message_window_2(
				0,
				"Me he tra[UNI00ed]do a mi nieta conmigo.\n[UNI00bf]Pero d[UNI00f3]nde se ha metido esta criatura?<page>Es que te descuidas un momento..."
			)
		end
	end
	if spectator_id == 160 then
		event.open_message_window_2(
			0,
			"Mi pez brilla\ncon luz propia en las rectas.<page>[UNI00bf]Que cu[UNI00e1]l es?\nJi, ji...\nEs un secreto."
		)
	end
	if spectator_id == 172 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"[UNI00a1]Mira qu[UNI00e9] escamas tiene el n[UNI00fa]mero 3!\n[UNI00a1]C[UNI00f3]mo brillan! [UNI00a1]Y qu[UNI00e9] lisas!<page>Tiene madera de ganador. [UNI00a1]Ya lo ver[UNI00e1]s!"
			)
		else
			event.open_message_window_2(
				0,
				"Yo s[UNI00f3]lo quer[UNI00ed]a probar por probar,\npero luego me enganch[UNI00e9].\nAhora no me pierdo ni una carrera.<page>(suspiro) La he fastidiado\nen el [UNI00fa]ltimo calentamiento..."
			)
		end
	end
	if spectator_id == 158 then
		if chapter < 7 then
			event.open_message_window_2(
				0,
				"Yo voy mucho de pesca con mi padre,\npero aqu[UNI00ed] hay montones de peces que no hab[UNI00ed]a visto nunca."
			)
		else
			event.open_message_window_2(
				0,
				"[UNI00a1]Guau! [UNI00a1]Mira qu[UNI00e9] peces\ntan bonitos! Corcho, [UNI00a1]ese parece\nun caballo!<page>[UNI00bf]Eh? [UNI00bf]D[UNI00f3]nde est[UNI00e1]s\nabuelo? [UNI00a1]Abuelito!"
			)
		end
	end
	if spectator_id == 159 then
		event.open_message_window_2(
			0,
			"Esto es la competici[UNI00f3]n Finny\nFrenzy.<page>[UNI00a1]Es el momento!\nQue se calmen los [UNI00e1]nimos..."
		)
	end
	if spectator_id == 162 then
		event.open_message_window_2(
			0,
			"Est[UNI00e1]s en las carreras Finny Frenzy.<page>[UNI00a1]Su[UNI00e9]ltate el pelo\ny disfruta!"
		)
	end
	if spectator_id == 168 then
		if extra_mode == 0 then
			event.open_message_window_2(
				0,
				"Para m[UNI00ed] todos los peces son iguales.\n[UNI00bf]C[UNI00f3]mo los diferencio?<page>Me fiar[UNI00e9] de lo que me diga\nel instinto."
			)
		else
			event.open_message_window_2(
				0,
				"El pez de mi novio corre\nen la siguiente carrera. [UNI00a1]Qu[UNI00e9]\nemoci[UNI00f3]n! [UNI00a1]Ya no aguanto m[UNI00e1]s!"
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
		"Qu[UNI00e9] pena. Aunque tendr[UNI00ed]as que estar contento\nde haber llegado hasta la final. Te estar[UNI00e9]\nobservando la pr[UNI00f3]xima vez, [UNI00a1]sigue intent[UNI00e1]ndolo!"
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
		"          PUESTO      Nombre            Tiempo\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          Puesto      Nombre            Tiempo\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          Puesto      Nombre            Tiempo\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
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
			event.open_message_window_2(0, "[UNI00bf]Salir de Finny Frenzy?")
		else
			event.open_message_window_2(0, "Si te vas, termina el Finny Frenzy.\n[UNI00bf]Seguro que quieres irte?")
		end
	else
		event.fade_out_screen(10)
		wait.frames(10)
		event.open_event_menu(26)
		vm.wait(3)
		event.fade_in_screen(10)
		event.open_message_window_2(0, "[UNI00bf]Volver a la pantalla de T[UNI00ed]tulo?")
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
			event.open_message_window_2(0, "[UNI00a1]Qu[UNI00e9] mal!\nNo te rindas. [UNI00a1]Int[UNI00e9]ntalo otra vez!")
		end
		if heat_stage == 1 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"[UNI00a1]Ah! La competencia es muy dura\nen la 2[UNI00aa] eliminatoria. Bueno, no importa.\nNo te rindas. [UNI00a1]Sigue intent[UNI00e1]ndolo!"
			)
		end
		if heat_stage == 2 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"Qu[UNI00e9] pena. Aunque tendr[UNI00ed]as que estar contento\nde haber llegado hasta la final. Te estar[UNI00e9]\nobservando la pr[UNI00f3]xima vez, [UNI00a1]sigue intent[UNI00e1]ndolo!"
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
		"          PUESTO      Nombre            Tiempo\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          Puesto      Nombre            Tiempo\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	message.show_timed(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(race_sound_bank, 4)
	event.open_message_window_2(
		1,
		"          Puesto      Nombre            Tiempo\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
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
