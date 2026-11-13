--!strict
--- Holds the Italian dialogue of the villager recruitment events and request conversations.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cook = vm.module("@lib/event/italian/cook")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/italian/npc_chatter")
local npc_dialogue = vm.module("@lib/event/italian/npc_dialogue")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/italian/palm_brinks_quests")
local palm_brinks_villagers = vm.module("@lib/event/italian/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local villager_dialogue = vm.module("@lib/event/italian/villager_dialogue")
local villager_recruitment = vm.module("@lib/event/italian/villager_recruitment")
local wait = vm.module("@lib/event/wait")

local npc_recruit = {}

--- Has the girl ask to join the party and, when the player agrees, starts a hide-and-seek by removing her from town.
function npc_recruit.challenge_hide_and_seek(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(0, "Oh, Max! Ho sentito dire che\nsei stato fuori citt[UNI00e0] ultimamente.")
	else
		event.open_message_window_2(0, "Ooh, Monica! Ho sentito dire che\nsei stata fuori citt[UNI00e0] ultimamente.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Grandioso! Perch[UNI00e9] non\nmi porti con te?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Scommetto che mi reputi inutile\nsolo perch[UNI00e9] sono una ragazza.<page>Ma in realt[UNI00e0], porto alla gente\nun sacco di fortuna!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Quando esco non piove mai\ne non ho mai perso\nalla lotteria!<page>Che ne pensi?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "OK allora.\nNo, mi spiace.")
	choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(npc_character, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if choice ~= 0 then
		event.open_message_window_2(0, "Perch[UNI00e9]? Non essere crudele!\nSei orribile!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Incapace!<page>Demente!<page>Idiota!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Mi porterai con te?<page>Non credevo lo avresti fatto!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Come mai devo chiedertelo io,\nmentre tu non fai che chiederlo\na tutti gli altri? <page>Se solo me l’avessi chiesto,\nti avrei aiutato subito."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Allora, se riesci a trovarmi,\nti aiuter[UNI00f2]. Che ne pensi?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Cio[UNI00e8]... giochiamo a nascondino!<page>Pronti, via!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	wait.frames(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, npc_character)
	event.set_character_active(0, npc_character)
	event.delete_villager(npc_character)
	event.fade_in_screen(30)
	wait.frames(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh bene... Forse faresti meglio a\n   trovare Corinne. Si sar[UNI00e0] nascosta\n   da qualche parte a Vallecatini."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

--- Recruits the character when the player holds the required weapon item, otherwise scolds the player for giving up.
function npc_recruit.check_owned_weapon(npc_character: s32, player_character: s32)
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	item_count = event.get_item_count(25) or item_count
	if item_count <= 0 then
		event.open_message_window_2(
			0,
			"Che c'[UNI00e8] che non va?\nTi arrendi di nuovo?<page>Mi deludi!\n[UNI00c8] questo che succede ad armeggiare\ntroppo con le macchine?"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Sembra che tu sia diventato\nbravo anche con le armi!<page>Non serve guardarti sparare:\nsi vede gi[UNI00e0] da come la tieni."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"OK, ti aiuter[UNI00f2].\nMa non lo faccio per te.<page>Se questa citt[UNI00e0] [UNI00e8] in pericolo,\nnon posso stare con\nle mani in mano."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 11, 1)
end

--- Plays the mayor muttering about the forgotten safe combination, admitting the problem and starting the safe request.
function npc_recruit.explain_safe_problem(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player_character, npc_character)
	event.open_message_window_2(0, "Mpfffff...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Che vuoi dire con\n'cosa sto blaterando'?<page>Sto tentando di ricordare\nla combinazione della cassaforte."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Come sarebbe\n'quale cassaforte'?<page>La cassaforte nascosta dietro\nil quadro nel mio ufficio, no?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	character.face_toward(npc_character, player_character)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"Ah, mi hai messo una paura!<page>Oh, maledizione!<page>Mi son lasciato scappare il\nmio segreto pi[UNI00f9] grande!<page>Oh bene, ora lo sai.<page>Forse puoi darmi una mano\na risolvere il problema."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ho un grosso problema:\nnon riesco a ricordare\nla combinazione della cassaforte.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"[UNI00c8] un numero a 4 cifre. Ho usato\nla data di nascita di Claire,\nconvinto di ricordarmela sempre."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Come posso essermela dimenticata?<page>Che padre snaturato sono!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Pare che il Sindaco sia nei guai.\n   Ascolta cosa dice del compleanno\n   di Claire e scopri la combinazione."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

--- Judges the length of the player's recorded Nonky catch and recruits the character once it reaches 60 centimeters.
function npc_recruit.judge_nonky_catch(npc_character: s32, player_character: s32)
	local catch_length_meters: f32 = 0
	local length_centimeters: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	catch_length_meters = vm.bits_float(event.get_menu_value(2, 322)) or catch_length_meters
	if catch_length_meters <= 0 then
		event.open_message_window_2(
			0,
			"Ehi, scommetto che non hai\nmai preso un Nonky per davvero!<page>Ah ah ah! Fai pena\ncome pescatore!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if catch_length_meters < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(catch_length_meters * 100.0))
		event.set_message_number(0, 1, length_centimeters)
		event.open_message_window_2(0, "Ah ah ah! Hai preso\nun pescetto di [数値１] cm!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Non sei degno del mio aiuto!<page>Ricomincia pure da capo!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "...Oh, ti avevo sottovalutato.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Non mi rimanger[UNI00f2] la parola data:<page>ti ascolter[UNI00f2], come avevo promesso.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Parla quanto vuoi!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

--- Judges whether the player's fish race was won and recruits the character when it was.
function npc_recruit.judge_race_result(npc_character: s32, player_character: s32)
	local race_won: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	race_won = event.get_save_flag(41) or race_won
	if race_won == 0 then
		event.open_message_window_2(0, "Un pesce rispecchia il padrone.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Non parler[UNI00f2] mai col padrone \ndi un pesce tanto imbranato!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Stavo guardando, sai.\n[UNI00c8] stata una bella corsa.<page>Non avrei mai potuto allevare\nun pesce simile!<page>Ti prego, portami con te.\nTi prego, insegnami quel che sai!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

--- Recruits the character once the current counter has grown by 10 since the request started, otherwise has him complain of feeling unwell.
function npc_recruit.judge_recovery_progress(npc_character: s32, player_character: s32)
	local current_counter: s32 = 0
	local start_counter: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		resume_point = 1
		cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
		current_counter = event.get_menu_value_2(0) or current_counter
		start_counter = event.get_save_counter(19) or start_counter
		print("start=", start_counter, ",now=", current_counter, ",clear=", vm.i32(current_counter - start_counter), "\n")
		if vm.i32(current_counter - start_counter) < 10 then
			event.open_message_window_2(0, "Ancora non mi sento bene.")
			resume_point = 2
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.open_message_window_2(
				0,
				"Sar[UNI00e0] qualcosa\ndi grave?<page>Forse neppure il Dottor Dell\npu[UNI00f2] aiutarmi ormai..."
			)
			resume_point = 3
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.set_character_motion(npc_character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Salve!<page>Come mi sento? Benissimo!")
		resume_point = 4
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "[UNI00c8] incredibile, sto molto meglio.<page>Il mondo [UNI00e8] tornato a posto.")
		resume_point = 5
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Oh s[UNI00ec], volevate un favore...<page>Far[UNI00f2] il possibile per aiutarvi.<page>Voi mi avete aiutato,\nquindi io aiuter[UNI00f2] voi."
		)
		resume_point = 6
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		resume_point = 7
		i04_girard_house.recruit_triggered_villager()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point <= 1 then
				print("start=", start_counter, ",now=", current_counter, ",clear=", current_counter - start_counter, "\n")
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			if resume_point <= 2 then
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			return 0
		end
		if resume_point <= 7 then
			if resume_point <= 4 then
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			if resume_point <= 5 then
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			if resume_point <= 6 then
				party.announce_new_member_alt_default()
			end
			return 0
		end
		return nil
	end)
end

--- Replays the mayor's birthday hints until the player enters the safe combination, then stages the safe opening or failing and recruits the mayor on success.
function npc_recruit.open_mayor_safe(npc_character: s32, player_character: s32)
	local listen_choice: any = 0
	local entry_result: s32 = 0
	local unlock_sound_id: s32 = 0
	local saved_npc_x: f32 = 0
	local saved_npc_y: f32 = 0
	local saved_npc_z: f32 = 0
	local saved_npc_rotation_x: f32 = 0
	local saved_npc_rotation_y: f32 = 0
	local saved_npc_rotation_z: f32 = 0
	local saved_player_x: f32 = 0
	local saved_player_y: f32 = 0
	local saved_player_z: f32 = 0
	local saved_player_rotation_x: f32 = 0
	local saved_player_rotation_y: f32 = 0
	local saved_player_rotation_z: f32 = 0
	local angle_to_npc: f32 = 0
	local saved_camera_x: f32 = 0
	local saved_camera_y: f32 = 0
	local saved_camera_z: f32 = 0
	local saved_look_at_x: f32 = 0
	local saved_look_at_y: f32 = 0
	local saved_look_at_z: f32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	while true do
		event.open_message_window_2(0, "Tempo fa, le regalai una spilla\ncon il suo segno zodiacale.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Holly se ne era occupata per me.\nNon ricordo bene, ma son certo\nche fosse un animale a 4 zampe..."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Che regali le ho fatto?<page>Mmh... molte giacche\ne sciarpe, credo.<page>Non so mai cosa prenderle.\nOgni anno [UNI00e8] una tragedia!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Il compleanno di Claire [UNI00e8] sempre un\ndramma! [UNI00c8] il giorno in cui c’[UNI00e8] la\nraccolta dei rifiuti combustibili e non.<page>A casa nostra [UNI00e8] compito mio\nportar fuori la spazzatura."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"I rifiuti non combustibili vengono\nraccolti i giorni divisibili per 7<page>e quelli combustibili\nnei giorni divisibili per 3."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Ma tu non lo scorderesti,\nvero?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(
			0,
			"Trovato! Mistero svelato!\nLa combinazione [UNI00e8]...<page>Non so... Stiamo ad ascoltare..."
		)
		listen_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		if listen_choice == 0 then
			break
		else
			if listen_choice == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(npc_character, "会話")
		end
	end
	event.set_menu_value(0, "Inserisci il codice segreto.", "2112", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		entry_result = out1 or entry_result
	end
	if entry_result == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait.frames(15)
	unlock_sound_id = event.get_sound_id(2) or unlock_sound_id
	do
		local out1, out2, out3 = event.get_character_position(npc_character)
		saved_npc_x = out1 or saved_npc_x
		saved_npc_y = out2 or saved_npc_y
		saved_npc_z = out3 or saved_npc_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(npc_character)
		saved_npc_rotation_x = out1 or saved_npc_rotation_x
		saved_npc_rotation_y = out2 or saved_npc_rotation_y
		saved_npc_rotation_z = out3 or saved_npc_rotation_z
	end
	event.set_character_position(npc_character, -100.0, 0.0, -110.0)
	event.set_character_rotation(npc_character, 0.0, 3.1415927, 0.0)
	event.set_character_motion(npc_character, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		saved_player_x = out1 or saved_player_x
		saved_player_y = out2 or saved_player_y
		saved_player_z = out3 or saved_player_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		saved_player_rotation_x = out1 or saved_player_rotation_x
		saved_player_rotation_y = out2 or saved_player_rotation_y
		saved_player_rotation_z = out3 or saved_player_rotation_z
	end
	angle_to_npc = event.get_arc_tangent(-100.0 - saved_player_x, -110.0 - saved_player_z) or angle_to_npc
	event.set_character_rotation(0, 0.0, angle_to_npc, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		saved_camera_x = out1 or saved_camera_x
		saved_camera_y = out2 or saved_camera_y
		saved_camera_z = out3 or saved_camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		saved_look_at_x = out1 or saved_look_at_x
		saved_look_at_y = out2 or saved_look_at_y
		saved_look_at_z = out3 or saved_look_at_z
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait.frames(30)
	if entry_result == 0 then
		event.set_character_motion(npc_character, "会話")
		event.open_message_window_2(0, "Mmh, non si apre. Oh cielo...<page>Ci sono documenti\nimportanti l[UNI00ec] dentro...")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.fade_out_screen(15)
		wait.frames(15)
		event.set_character_rotation(0, saved_player_rotation_x, saved_player_rotation_y, saved_player_rotation_z)
		event.set_character_position(npc_character, saved_npc_x, saved_npc_y, saved_npc_z)
		event.set_character_rotation(npc_character, saved_npc_rotation_x, saved_npc_rotation_y, saved_npc_rotation_z)
		event.set_camera_position(saved_camera_x, saved_camera_y, saved_camera_z)
		event.set_camera_look_at(saved_look_at_x, saved_look_at_y, saved_look_at_z)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(0, "Er...Mmh...\n2,<page>1,<page>1,<page>2...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "Evviva!<page>Grandioso,\nfunziona!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.attach_object_handle_to_character(0, npc_character)
	event.clear_object_sequence(0, npc_character)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, saved_player_x, saved_player_y, saved_player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(0, "Bene! Ora posso prendere\ni miei documenti importanti!<page>Oh, grazie!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.fade_out_screen(15)
	wait.frames(15)
	event.set_character_rotation(0, saved_player_rotation_x, saved_player_rotation_y, saved_player_rotation_z)
	event.set_character_position(npc_character, saved_npc_x, saved_npc_y, saved_npc_z)
	event.set_character_rotation(npc_character, saved_npc_rotation_x, saved_npc_rotation_y, saved_npc_rotation_z)
	event.set_camera_position(saved_camera_x, saved_camera_y, saved_camera_z)
	event.set_camera_look_at(saved_look_at_x, saved_look_at_y, saved_look_at_z)
	event.fade_in_screen(15)
	wait.frames(15)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"Quali documenti importanti?<page>Serviranno al Vicesindaco Morton\nper sostituirmi quando sar[UNI00f2] via.<page>Sono un po’ in pensiero,\nma sento che andr[UNI00e0] tutto bene."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Sono pronto anch’io a lasciare la<page>citt[UNI00e0]. Cedric mi ha detto tutto.<page>Forza, andiamo."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

--- Asks the player to hand over Chestnuts and recruits the cook.
function npc_recruit.receive_chestnuts(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Avete trovato delle Castagne?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(301)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 301 then
		event.open_message_window_2(0, "Allora non potete aiutarmi...<page>Oh beh, meglio lasciar\nperdere il Castagnaccio.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ah, eccole! Grazie tante.<page>Prover[UNI00f2] a fare il Castagnaccio.<page>Ve lo far[UNI00f2] assaggiare appena pronto!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Posso fare qualcosa in cambio?<page>Cosa? Un'avventura al vostro fianco?<page>Ah ah! Certo che verr[UNI00f2].<page>Ma potevate dirlo subito!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

--- Asks the player to hand over the Golden Paint, brings the painting to life and recruits the magical artist.
function npc_recruit.receive_golden_paint(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Ti stavo aspettando.<page>Forza, dammi la Vernice, cos[UNI00ec]\nposso dar vita al mio quadro!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 376 then
		event.open_message_window_2(0, "Starai scherzando!<page>Mi serve la Vernice oro.\nNon sbagliare!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "Cos[UNI00ec] [UNI00e8] questa la Vernice oro...\nLa provo subito.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Lei, lei... [UNI00e8] vera...<page>Incredibile, [UNI00e8] perfetta!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Grazie, Max. Non ho dimenticato\nla mia promessa. Usa pure il\nmio nuovo potere quando vuoi!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.set_npc_party_status(22, 130)
	i04_girard_house.show_join_announcement(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

--- Has the baker ask the player to deliver 20 loaves of bread to the shop and hands the player the loaves.
function npc_recruit.request_bread_delivery(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Vuoi che venga\ncon voi?<page>Sono solo una fornaia,\nma se posso essere utile,\nvengo volentieri."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Oh, ma prima c'[UNI00e8] una cosa che\ndev'essere consegnata a Morton.<page>Ti spiacerebbe portare 20 pagnotte\nal negozio di Morton per me?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mentre vai,\npreparo i bagagli.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.add_inventory_item(300, 20)
	inventory.show_obtained_message_for_item_id(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "Mi chiedo perch[UNI00e9] diavolo\nvoglia 20 pagnotte!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- Has Gordon explain his sick tree and how to recruit him and starts his request, deferring to a hint talk for the second playable character.
function npc_recruit.start_gordon_request(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local notebook_count: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		villager_recruitment.hint_talk_to_gordon(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Oh, Max! Hai avuto parecchi\npensieri ultimamente.\nTi stai riguardando?<page>Posso fare qualcosa per te?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Cosa! Vuoi che ti segua\nnella tua avventura?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mmh... Vorrei venire con te...\nMa questo povero albero non\nsta mica tanto bene.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Prendermi cura degli alberi e dei\nfiori di questa tenuta [UNI00e8] ci[UNI00f2] che\nmi preme di pi[UNI00f9], lo sai.<page>Se me ne andassi a zonzo,\nperderei il mio lavoro!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"L'Acqua sacra che Don Bruno vende\nin chiesa sanerebbe quest'albero!<page>Ma, come sai, tuo padre e Don\nBruno non vanno molto d'accordo...<page>Tuo padre non mi darebbe mai soldi\nper comprare la sua Acqua Sacra!<page>Sono in un bel pasticcio!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Per portare Gordon a Sindain,\n   devi fare in modo che ti\n   segua in viaggio.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Se soddisfi la richiesta di Gordon,\n   ti seguir[UNI00e0] in viaggio\n   e salir[UNI00e0] sul treno."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Puoi controllare le richieste\n   leggendo il Taccuino,\n   nel Menu Oggetti.")
	message.show_and_wait(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(0, "[(!)]Oh, non hai un Taccuino?\n   Ce n'[UNI00e8] uno sul tavolo\n   nel Negozio di Cedric.")
		message.show_and_wait(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]Ce ne [UNI00e8] un altro nella tana\n   di Donny. Vanno bene entrambi.\n   Prendine uno, sbrigati!"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Starts the conversation with the cook matching the status of his chestnut request, with a separate talk for the second playable character and the default talk until the first request is finished.
function npc_recruit.talk_cook(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		cook.chat_about_food(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		palm_brinks_villagers.talk_cooking_experiments(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 3) or request_status
	if request_status == 0 then
		palm_brinks_villagers.request_chestnuts(npc_character, player_character)
		return
	end
	if request_status == 1 then
		npc_recruit.receive_chestnuts(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_aspiring_chef(npc_character, player_character)
		return
	end
end

--- Starts the conversation with the flower photo villager matching the status of his request, or the default talk until the first request is finished.
function npc_recruit.talk_flower_photo_villager(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		palm_brinks_villagers.talk_about_leaving_town(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 4) or request_status
	if request_status == 0 then
		villager_recruitment.refuse_until_flower_photo(npc_character, player_character)
		return
	end
	if request_status == 1 then
		palm_brinks_quests.check_flower_photos(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_railroad_fan(npc_character, player_character)
		return
	end
end

--- Starts the conversation with the priest matching the status of his candle puzzle request, or the default talk until the first request is finished.
function npc_recruit.talk_priest(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_prayer_for_peace(npc_character, player_character, 0)
		return
	end
	request_status = event.get_quest_request_status(0, 13) or request_status
	if request_status == 0 then
		palm_brinks_quests.explain_candle_puzzle(npc_character, player_character)
		return
	end
	if request_status == 1 then
		villager_recruitment.join_after_candle_puzzle(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_world_peace(npc_character, player_character)
		return
	end
end

--- Starts the conversation with the villager feeling unwell matching the status of his request, or the default talk until his state flag is set.
function npc_recruit.talk_sick_villager(npc_character: s32, player_character: s32)
	local state_flag: s32 = 0
	local request_status: s32 = 0
	state_flag = event.get_save_flag(314) or state_flag
	if state_flag == 0 then
		npc_dialogue.chat_feeling_unwell(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 17) or request_status
	if request_status == 0 then
		palm_brinks_quests.explain_time_distortions(npc_character, player_character)
		return
	end
	if request_status == 1 then
		npc_recruit.judge_recovery_progress(npc_character, player_character)
		return
	end
	if request_status == 2 then
		villager_dialogue.talk_villager_23_after_quest(npc_character, player_character)
		return
	end
end

return npc_recruit
