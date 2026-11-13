--!strict
--- Holds the French dialogue of the villager recruitment events and request conversations.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/french/npc_chatter")
local npc_dialogue = vm.module("@lib/event/french/npc_dialogue")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/french/palm_brinks_quests")
local party = vm.module("@lib/event/party")
local villager_dialogue = vm.module("@lib/event/french/villager_dialogue")
local villager_recruitment = vm.module("@lib/event/french/villager_recruitment")
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
		event.open_message_window_2(0, "Ooh, Max ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	else
		event.open_message_window_2(0, "Ooh, Monica ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "C'est g[UNI00e9]nial ! Pourquoi ne\nm'emm[UNI00e8]nerais-tu pas avec toi ?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Je parie que tu crois que je serai\ninutile parce que je suis une fille<page>alors qu'en fait, je porte chance\naux gens que je c[UNI00f4]toie."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Il ne pleut jamais quand je sors,\net je n'ai jamais vu un billet de\nloterie perdant.<page>Qu'est-ce que tu en penses ?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "D'accord.\nNon merci.")
	choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(npc_character, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if choice ~= 0 then
		event.open_message_window_2(0, "Pourquoi ? C'est injuste !\nT'es horrible !")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "T'es naze !<page>Imb[UNI00e9]cile !<page>Stupide !")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Tu m'emm[UNI00e8]neras avec toi ?<page>Je croyais pas que tu le ferais !")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Mais pourquoi je suis la seule qui\ndoive te le demander, alors que tu\nl'as demand[UNI00e9] [UNI00e0] tous les autres ?<page>Il suffisait de le demander pour\nque je vienne."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Je sais, si tu arrives [UNI00e0] me\ntrouver, je t'aiderai. D'accord ?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Bref, on va jouer [UNI00e0] cache-cache !<page>Allez, on y va !")
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
		"[(!)]Bien... on dirait qu'il va falloir\n   retrouver Corinne. Elle se cache\n   s[UNI00fb]rement quelque part [UNI00e0] Palm Brinks."
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
			"Qu'est-ce qui se passe ?\nTu baisses encore les bras ?<page>Tu me d[UNI00e9][UNI00e7]ois.\nC'est [UNI00e0] [UNI00e7]a que [UNI00e7]a m[UNI00e8]ne de bricoler\ndes machines [UNI00e0] longueur de journ[UNI00e9]e ?"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oh ! On dirait que tu commences\n[UNI00e0] t'y conna[UNI00ee]tre en armes aussi !<page>Il suffit de voir comment tu les\ntiens pour s'en rendre compte..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"OK, je vais t'aider.\nMais je ne le fais pas pour toi.<page>Si cette ville est en danger,\nje ne peux pas rester assis\nici [UNI00e0] me tourner les pouces."
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
	event.open_message_window_2(0, "Ronchonnements...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Comment [UNI00e7]a, qu'est-ce que\nj'ai [UNI00e0] marmonner ?<page>J'essaie de me souvenir de la\ncombinaison du coffre."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Comment [UNI00e7]a,\nquel coffre ? Celui<page>qui est cach[UNI00e9] derri[UNI00e8]re le tableau\ndans mon bureau, bien s[UNI00fb]r..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	character.face_toward(npc_character, player_character)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"Ah, tu m'as fait peur !<page>Oh, fl[UNI00fb]te !<page>Je viens de l[UNI00e2]cher\nmon plus gros secret !<page>Bon, tant pis !<page>Tu peux peut-[UNI00ea]tre m'aider\n[UNI00e0] l'ouvrir maintenant."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"J'ai un gros probl[UNI00e8]me, je\nn'arrive plus [UNI00e0] me souvenir\nde la combinaison du coffre."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Il y a 4 chiffres alors j'ai choisi\nla date de naissance de Claire\npour [UNI00ea]tre s[UNI00fb]r de pas l'oublier."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Comment ai-je pu oublier [UNI00e7]a...<page>Quel mauvais p[UNI00e8]re je fais !")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Le Maire para[UNI00ee]t tr[UNI00e8]s ennuy[UNI00e9].\n   [UNI00c9]coute ses propos sur l'anniversaire\n   de Claire pour trouver la combinaison."
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
			"H[UNI00e9], je parie que tu n'as jamais\nattrap[UNI00e9] un Nonky ?<page>Ah ah. Tu dois [UNI00ea]tre vraiment\nnul en p[UNI00ea]che !"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if catch_length_meters < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(catch_length_meters * 100.0))
		event.set_message_number(0, 1, length_centimeters)
		event.open_message_window_2(0, "Ah ah ! Tu n'as attrap[UNI00e9] qu'un tout\npetit poisson de [数値１] cm !")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Tu ne m[UNI00e9]rites pas mon aide !<page>Tu ferais mieux de recommencer.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "...Oh, je t'avais sous-estim[UNI00e9].")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Un homme, [UNI00e7]a n'a qu'une parole.<page>Je vais [UNI00e9]couter ce que t'as [UNI00e0] dire."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Parle autant que tu veux !")
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
		event.open_message_window_2(0, "Tel poisson, tel ma[UNI00ee]tre, para[UNI00ee]t-il.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Pas question que je parle au \npropri[UNI00e9]taire d'un poisson si nul.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"J'ai bien regard[UNI00e9], tu sais.\nC'[UNI00e9]tait une course superbe.<page>Je ne pense pas que j'aurais pu\ndresser un aussi bon poisson.<page>Tu peux m'emmener avec toi et\nm'apprendre tout ce que tu sais ?"
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
			event.open_message_window_2(0, "Je me sens toujours aussi mal.")
			resume_point = 2
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.open_message_window_2(
				0,
				"J'ai peut-[UNI00ea]tre quelque\nchose de tr[UNI00e8]s grave ?<page>Peut-[UNI00ea]tre que m[UNI00ea]me le Dr Dell ne\npeut plus rien faire pour moi..."
			)
			resume_point = 3
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.set_character_motion(npc_character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Bonjour !<page>Comment je vais ? Super bien !")
		resume_point = 4
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Je me sens tellement mieux !<page>Le monde semble [UNI00e0] nouveau normal.")
		resume_point = 5
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Ah oui. Tu voulais un service.<page>Je ferai tout pour t'aider.<page>Tu l'as fait pour moi, alors je\ndois aussi te venir en aide."
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
		event.open_message_window_2(0, "Une fois, je lui ai offert une\nbroche avec son signe astrologique.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"C'est Holly qui l'avait achet[UNI00e9]e\npour moi, mais je crois me souvenir\nque c'[UNI00e9]tait un animal [UNI00e0] 4 pattes..."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Quel genre de cadeaux\nd'anniversaire je lui offre ?<page>Humm... beaucoup de manteaux et\nd'[UNI00e9]charpes il me semble.<page>Je ne sais jamais quoi lui offrir.\nEt tous les ans, c'est pire."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Ah [UNI00e7]a ! Son anniversaire, c'est\ntoujours p[UNI00e9]nible. C'est un jour de\nramassage des d[UNI00e9]chets combustibles<page>et non-combustibles. C'est moi qui\nsort les poubelles chez nous."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Les d[UNI00e9]chets non-combustibles sont\nramass[UNI00e9]s les jours divisibles par 7<page>et les d[UNI00e9]chets combustibles, les\njours divisibles par 3."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Tu n'oublierais quand m[UNI00ea]me pas [UNI00e7]a,\nhein ?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(
			0,
			"J'ai compris ! Myst[UNI00e8]re r[UNI00e9]solu !\nLa combinaison est...<page>Je ne sais pas... Attends un peu."
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
	event.set_menu_value(0, "Saisis le num[UNI00e9]ro du code secret.", "2112", 0)
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
		event.open_message_window_2(
			0,
			"Humm, [UNI00e7]a s'ouvre pas. Oh la la...<page>Il y a des documents vraiment\nimportants l[UNI00e0]-dedans..."
		)
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
	event.open_message_window_2(0, "Euh... Mmm...\n2,<page>1,<page>1,<page>2...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "Ouaaaaouh !<page>Formidable,\n[UNI00e7]a a march[UNI00e9] !")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.attach_object_handle_to_character(0, npc_character)
	event.clear_object_sequence(0, npc_character)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, saved_player_x, saved_player_y, saved_player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(0, "Formidable ! Je peux enfin\nsortir mes documents importants !<page>Oh, merci !")
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
		"Quels documents ? Des dossiers<page>qui aideront Morton, mon adjoint,\n[UNI00e0] me remplacer en mon absence.<page>[UNI00c7]a m'inqui[UNI00e8]te un peu,\nmais je suis s[UNI00fb]r que [UNI00e7]a ira."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Je suis pr[UNI00ea]t [UNI00e0] quitter la ville.<page>C[UNI00e9]dric m'a tout expliqu[UNI00e9].<page>Allez, on y va."
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
	event.open_message_window_2(0, "Tu as trouv[UNI00e9] des marrons ?")
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
		event.open_message_window_2(
			0,
			"Alors, tu ne peux pas m'aider...<page>Tant pis, je ne ferai pas\nde castagnaccio, voil[UNI00e0] tout."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oui, c'est [UNI00e7]a ! Merci beaucoup ! Je<page>vais pouvoir faire un castagnaccio.<page>Je te ferai go[UNI00fb]ter si tu veux."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Comment te remercier... ?<page>Quoi, te suivre dans une aventure ?<page>Ha ha ! Mais bien s[UNI00fb]r...<page>Il fallait le dire tout de suite."
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
	event.open_message_window_2(
		0,
		"Je t'attendais. Vite, donne-moi<page>la peinture, que je puisse enfin\ndonner vie [UNI00e0] mon portrait."
	)
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
		event.open_message_window_2(
			0,
			"C'est une blague !?<page>Ce qu'il me faut, c'est de la\npeinture dor[UNI00e9]e. Et rien d'autre !"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "Ah, la fameuse peinture dor[UNI00e9]e...\nJe vais l'essayer imm[UNI00e9]diatement.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "E-elle... Elle est r[UNI00e9]elle...<page>[UNI00c9]tonnant, elle est parfaite !")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Merci, Max. Je n'ai pas oubli[UNI00e9] ma\npromesse. Tu pourras utiliser mes\nnouveaux pouvoirs quand tu veux."
	)
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
		"Tu veux que je\nvienne avec toi ?<page>Je ne suis qu'une femme qui fait\ndu pain, mais si je peux t'aider,\nje le ferai avec plaisir."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Oh, mais d'abord, j'ai quelque chose\n[UNI00e0] faire livrer [UNI00e0] Morton.<page>[UNI00c7]a t'emb[UNI00ea]terait d'emporter pour moi\n20 pains [UNI00e0] son magasin ?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Pendant ce temps-l[UNI00e0], je vais\nfaire mes bagages pour le voyage.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.add_inventory_item(300, 20)
	inventory.show_obtained_message_for_item_id(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "Je me demande ce qu'il peut bien\nvouloir faire avec 20 pains ?")
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
		"Oh, Max ! Tu as l'air de tra[UNI00ee]ner\npas mal en ce moment. Tu te\nportes bien ?<page>Je peux faire quelque chose ?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ah bon ! Tu veux que je\nt'accompagne dans tes aventures ?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mmm... J'aimerais bien venir avec\ntoi... Mais ce pauvre arbre ne va\npas tr[UNI00e8]s bien.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Soigner les arbres et les fleurs\nde cette propri[UNI00e9]t[UNI00e9] est ma grande\npriorit[UNI00e9], tu sais.<page>Si je pars me balader maintenant,\nje pourrais perdre mon travail."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Je parie que l'eau sacr[UNI00e9]e vendue [UNI00e0]\nl'[UNI00e9]glise soignerait cet arbre !<page>Mais, comme tu le sais, ton p[UNI00e8]re et\nP[UNI00e8]re Bruno ne s'entendent pas...<page>Ton p[UNI00e8]re ne me donnera jamais de\nsous pour acheter de l'eau sacr[UNI00e9]e !<page>J'ai un vrai probl[UNI00e8]me l[UNI00e0]."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Pour que Gordon aille [UNI00e0] Sindain,\n   tu dois le convaincre de venir\n   avec toi.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]R[UNI00e9]alise la mission de Gordon\n   et il montera dans le train pour\n   t'accompagner."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tu peux consulter tes missions\n   en lisant ton carnet de notes,\n   situ[UNI00e9] dans le menu Objets."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(
			0,
			"[(!)]Oh, tu n'as pas de carnet.\n   Il y en a un sur la table\n   chez C[UNI00e9]dric, le r[UNI00e9]parateur."
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]Il y en a un autre dans la\n   base secr[UNI00e8]te de Donny. Ils se valent.\n   R[UNI00e9]cup[UNI00e8]re l'un d'eux !"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Starts the conversation with the fisherman matching the status of his Nonky request, or the default talk until the first request is finished.
function npc_recruit.talk_fisherman(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_fishing_hobby(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 15) or request_status
	if request_status == 0 then
		villager_recruitment.give_nonky_challenge(npc_character, player_character)
		return
	end
	if request_status == 1 then
		npc_recruit.judge_nonky_catch(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_fishing_spots(npc_character, player_character)
		return
	end
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
