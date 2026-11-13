--!strict
--- Holds the German dialogue of the villager recruitment events and request conversations.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/german/npc_chatter")
local npc_dialogue = vm.module("@lib/event/german/npc_dialogue")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/german/palm_brinks_quests")
local party = vm.module("@lib/event/party")
local villager_dialogue = vm.module("@lib/event/german/villager_dialogue")
local villager_recruitment = vm.module("@lib/event/german/villager_recruitment")
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
		event.open_message_window_2(0, "Ooh, Max! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	else
		event.open_message_window_2(0, "Ooh, Monica! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Das ist toll! Warum nimmst\ndu mich nicht mit?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Du denkst bestimmt, ich bin nutzlos,\nweil ich ein M[UNI00e4]dchen bin.<page>Aber ich bringe den Leuten\nimmer viel Gl[UNI00fc]ck."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Wenn ich unterwegs bin, regnet\nes nie, und eine Los-Niete hab\nich noch nie gesehen.<page>Was meinst du?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Na gut.\nNein, tut mir Leid.")
	choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(npc_character, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if choice ~= 0 then
		event.open_message_window_2(0, "Was? Sei nicht gemein!\nDu bist so fies!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Du bist bl[UNI00f6]d!<page>Du Dummkopf!<page>Du Idiot!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Du nimmst mich mit?<page>Das h[UNI00e4]tte ich nicht gedacht!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber warum muss ich als Einzige\nfragen, wenn du all die anderen\nselbst um Hilfe bittest?<page>Wenn du einfach gefragt h[UNI00e4]ttest,\nh[UNI00e4]tte ich nat[UNI00fc]rlich geholfen."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ich wei[UNI00df] - wenn du mich findest,\nhelf ich dir. Abgemacht?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mit anderen Worten, wir\nspielen  Verstecken!<page>Gut, los geht's!")
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
		"[(!)]Na ja ... Du versuchst wohl besser,\n   Corinne zu finden. Sie hat sich\n   bestimmt in Palm Brinks versteckt."
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
			"Was ist denn los?\nGibst du schon wieder auf?<page>Ich bin entt[UNI00e4]uscht.\nKommt das davon, wenn man\nimmer an Maschinen bastelt?"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Du scheinst auch mit Waffen\nnicht schlecht zu sein!<page>Ich muss dich nicht mal\nschie[UNI00df]en sehen. Ich sehe schon, wie\nprofessionell du sie h[UNI00e4]ltst."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Na gut, ich helfe dir.\nAber ich tu's nicht f[UNI00fc]r dich.<page>Wenn die Stadt in Gefahr ist,\nkann ich nicht einfach\ntatenlos zusehen."
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
	event.open_message_window_2(0, "Grummel, grummel ...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Was soll das hei[UNI00df]en, was\nmurmele ich da?<page>Ich versuche, mich an die\nSafe-Kombination zu erinnern."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Was soll das hei[UNI00df]en,\nwelcher Safe?<page>Der Safe hinter dem Bild\nin meinem B[UNI00fc]ro nat[UNI00fc]rlich ..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	character.face_toward(npc_character, player_character)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"Ah, du hast mich erschreckt!<page>Oh, Mist!<page>Jetzt hab ich mein gr[UNI00f6][UNI00df]tes\nGeheimnis ausgeplaudert!<page>Na ja, jetzt wei[UNI00df]t du's.<page>Vielleicht hilfst du mir\nja, ihn zu [UNI00f6]ffnen."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ich hab ein gro[UNI00df]es Problem -\nich habe die Kombination f[UNI00fc]r\nden Safe vergessen."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Es sind vier Ziffern. Deshalb\nhabe ich Claires Geburtstag genommen -\nich dachte, den vergess ich nie."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Wie konnte ich ihn vergessen ...<page>Ich bin ein schrecklicher Vater!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Need scheint sehr besorgt.\n   H[UNI00f6]r zu, was er [UNI00fc]ber Claires Ge-\n   burtstag sagt und knack den Code!"
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
			"Hey, wetten, dass du noch nie\neinen Nonky gefangen hast?<page>Ha ha. Du musst ein ganz\nmieser Angler sein!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if catch_length_meters < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(catch_length_meters * 100.0))
		event.set_message_number(0, 1, length_centimeters)
		event.open_message_window_2(0, "Ha ha! Du hast nur ein\n [数値１]-cm-Baby geangelt!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Du verdienst meine Hilfe nicht!<page>Fang lieber von vorn an.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "... Oh,ich hab dich untersch[UNI00e4]tzt!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Tja, ich bin ein Mann.\nMir muss man nichts zweimal sagen.<page>Ich h[UNI00f6]re dich wie abgemacht an."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Sprich, so viel du willst!")
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
		event.open_message_window_2(0, "Man sagt, ein Fisch ist\nwie sein Besitzer.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Mit dem Besitzer eines so schwachen\nFisches spreche ich niemals.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ich hab's mir angesehen.\nEs war ein gutes Rennen.<page>So einen Fisch h[UNI00e4]tte ich\nselbst nicht z[UNI00fc]chten k[UNI00f6]nnen.<page>Bitte nimm mich mit dir.\nBitte bring mir bei, was du kannst."
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
			event.open_message_window_2(0, "Mir geht's immer noch\nschlecht.")
			resume_point = 2
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.open_message_window_2(
				0,
				"Vielleicht habe ich etwas\nganz Schlimmes?<page>Vielleicht kann selbst Dr. Dell\nmir jetzt nicht mehr helfen ..."
			)
			resume_point = 3
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.set_character_motion(npc_character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Hallo!<page>Wie es mir geht? Super!")
		resume_point = 4
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Ich kann kaum glauben, wie gut\nes mir in letzter Zeit geht.<page>Jetzt scheint die Welt\nwieder in Ordnung zu sein."
		)
		resume_point = 5
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Oh ja, du wolltest etwas von mir.<page>Wenn ich helfen kann, tu ich's gern.<page>Du hast mir geholfen,\ndann helfe ich dir auch."
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
		event.open_message_window_2(0, "Ich habe ihr mal eine Brosche\nmit ihrem Sternzeichen geschenkt.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Holly hat sie ausgesucht, deshalb\nwei[UNI00df] ich's nicht mehr genau,\naber es war ein<page>vierbeiniges Tier ..."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Was f[UNI00fc]r Geburtstagsgeschenke\nhabe ich ihr gemacht?<page>Hmm ... Viele M[UNI00e4]ntel und\nSchals, glaube ich.<page>Ich wei[UNI00df] nie, was ich nehmen\nsoll. Es ist jedes Jahr schwierig."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Oh ja! An Claires Geburtstag wird\nimmer der M[UNI00fc]ll abgeholt - sowohl\nBiom[UNI00fc]ll als auch Restm[UNI00fc]ll.<page>Und meine Aufgabe ist\nes, den M[UNI00fc]ll rauszubringen."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Restm[UNI00fc]ll wird an Tagen geholt,\ndie durch 7 teilbar sind,<page>Biom[UNI00fc]ll an Tagen, die\ndurch 3 teilbar sind."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Aber so etwas vergisst\nman doch nicht, oder?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(
			0,
			"Ich hab's! Des R[UNI00e4]tsels L[UNI00f6]sung!\nDie Kombination hei[UNI00df]t ...<page>Ich wei[UNI00df] nicht ...\n Lauschen wir noch etwas."
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
	event.set_menu_value(0, "Gib den Geheim-Code ein.", "2112", 0)
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
		event.open_message_window_2(0, "Hmm, es geht nicht auf ...<page>Au weia - da sind wirklich\nwichtige Dokumente drin ...")
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
	event.open_message_window_2(0, "[UNI00c4]h ... hmm ...\n2,<page>1,<page>1,<page>2 ...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "Juhuu!<page>Toll,\nes funktioniert!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.attach_object_handle_to_character(0, npc_character)
	event.clear_object_sequence(0, npc_character)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, saved_player_x, saved_player_y, saved_player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(0, "Super! Jetzt komme ich an meine\nwichtigen Dokumente heran!<page>Oh, vielen Dank!")
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
		"Was das f[UNI00fc]r Dokumente sind?<page>Mit ihnen soll mein Stellvertreter\nMorton arbeiten, w[UNI00e4]hrend ich weg bin.<page>Nat[UNI00fc]rlich ist es unangenehm,\naber es wird bestimmt klappen."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Gut, dann bin ich bereit\naufzubrechen.<page>Cedric hat mir alles erz[UNI00e4]hlt.<page>Na komm schon, auf geht's."
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
	event.open_message_window_2(0, "Hast du Kastanien bekommen?")
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
		event.open_message_window_2(0, "Du kannst also nicht helfen.<page>Tja, dann vergesse ich das\nCastagnaccio besser.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ja, genau die. Vielen Dank.<page>Jetzt kann ich mal Castagnaccio machen.<page>Du kannst probieren, wenn's\nfertig ist."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Kann ich mich denn revanchieren?<page>Wie? Ich soll dich begleiten?<page>Ha ha! Nat[UNI00fc]rlich mach ich das.<page>Warum hast du nicht gleich gefragt?"
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
	event.open_message_window_2(0, "Ich hab dich erwartet.<page>Schnell, gib mir die Farbe,\ndann kann ich das Bild beleben.")
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
		event.open_message_window_2(0, "Du machst Witze!<page>Ich brauche goldene Farbe.\nUnd nichts anderes!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "Das ist die goldene Farbe ...\nIch probiere sie sofort aus.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "S ... sie ... sie lebt ...<page>Unglaublich, sie ist perfekt!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Danke, Max.\nIch halte mein Versprechen. Nutze\nmeine neue Kraft, wann du willst.")
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
		"Du willst, dass ich\nmitkomme?<page>Ich bin nur eine B[UNI00e4]ckerin,\naber wenn du mich brauchst,\nhelfe ich gern."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Oh, aber zuerst habe ich eine\nLieferung f[UNI00fc]r Morton.<page>K[UNI00f6]nntest du diese 20 Brotlaibe\nf[UNI00fc]r mich zu Mortons Laden bringen?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "W[UNI00e4]hrend du das erledigst,\npacke ich f[UNI00fc]r die Reise.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.add_inventory_item(300, 20)
	inventory.show_obtained_message_for_item_id(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "Was um alles in der\nWelt will er mit 20 Laiben?")
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
		"Oh, Max! Du siehst in letzter\nZeit oft traurig aus. Ist alles\nin Ordnung bei dir?<page>Kann ich etwas f[UNI00fc]r dich tun?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Wie? Ich soll dich auf\ndeinem Abenteuer begleiten?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Hmm ... ich w[UNI00fc]rde gern mitkommen ...\nAber dieser arme Baum\nist krank.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Die Pflege der B[UNI00e4]ume und\nBlumen auf diesem Gel[UNI00e4]nde\nist mir das Wichtigste [UNI00fc]berhaupt.<page>Wenn ich einfach abhaue,\nverliere ich noch meinen Job."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Etwas von Brunos Weihwasser\nw[UNI00fc]rde diesem Baum sicher helfen!<page>Aber du wei[UNI00df]t ja, dein Vater und\nder Priester verstehen sich nicht...<page>Dein Vater w[UNI00fc]rde mir nie Geld\nf[UNI00fc]r Priester Brunos Weihwasser geben!<page>Ich sitze in der Klemme."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Um Gordon nach Sindain zu\n   bringen, musst du ihn erst\n   als Begleiter gewinnen.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Wenn du Gordon hilfst,\n   schlie[UNI00df]t er sich dir an\n   und steigt in den Zug.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Deine Auftr[UNI00e4]ge findest du\n   im Notizbuch\n   im Gegenst[UNI00e4]nde-Men[UNI00fc]."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(0, "[(!)]Oh, du hast kein Notizbuch.\n   Auf dem Tisch im\n   Ger[UNI00e4]teladen liegt eins.")
		message.show_and_wait(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]In Donnys Versteck liegt auch\n   eins. Es ist egal, welches\n   du nimmst, aber mach schnell!"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Starts Gordon's conversation matching his state flag and the status of his request.
function npc_recruit.talk_gordon(npc_character: s32, player_character: s32)
	local state_flag: s32 = 0
	local request_status: s32 = 0
	state_flag = event.get_save_flag(42) or state_flag
	if state_flag == 0 then
		npc_chatter.talk_tree_gardener(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status == 0 then
		npc_recruit.start_gordon_request(npc_character, player_character)
		return
	end
	if request_status == 1 then
		palm_brinks_quests.recruit_gordon(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_holy_water_keeper(npc_character, player_character)
		return
	end
end

--- Starts the conversation with the gun fighter matching the status of his request, with a separate talk for the second playable character and the default talk until the first request is finished.
function npc_recruit.talk_gun_fighter(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_chatter.talk_gun_fighter_monica(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_mining_advice(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 11) or request_status
	if request_status == 0 then
		palm_brinks_quests.offer_bell_trigger_challenge(npc_character, player_character)
		return
	end
	if request_status == 1 then
		npc_recruit.check_owned_weapon(npc_character, player_character)
		return
	end
	if request_status == 2 then
		villager_dialogue.talk_villager_16_as_monica(npc_character, player_character)
		return
	end
end

--- Starts the conversation with the mayor matching the status of his safe request, or the default talk until the first request is finished.
function npc_recruit.talk_mayor(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		palm_brinks_quests.mutter_safe_combination(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 12) or request_status
	if request_status == 0 then
		npc_recruit.explain_safe_problem(npc_character, player_character)
		return
	end
	if request_status == 1 then
		npc_recruit.open_mayor_safe(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_garbage_sorting(npc_character, player_character)
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
		villager_recruitment.pose_candle_puzzle(npc_character, player_character)
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

return npc_recruit
