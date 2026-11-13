--!strict
--- German villager conversations triggered from the town and dungeon scripts.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/german/npc_chatter")
local npc_dialogue = vm.module("@lib/event/german/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/german/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/german/quest_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_dialogue = {}

--- Speaks a villager's prayer for the player's safety, with different lines in chapter 8.
function villager_dialogue.pray_for_safety(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Wie passt es denn?<page>Sag die Wahrheit!")
	else
		event.open_message_window_2(0, "Ich bete f[UNI00fc]r deine Sicherheit ...")
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Plays Corinne's request to join the player, her hide-and-seek challenge and her disappearance.
function villager_dialogue.start_corinne_hide_and_seek(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local answer: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "Ooh, Max! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	else
		event.open_message_window_2(0, "Ooh, Monica! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	end
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Das ist toll! Warum nimmst\ndu mich nicht mit?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Du denkst bestimmt, ich bin nutzlos,\nweil ich ein M[UNI00e4]dchen bin.<page>Aber ich bringe den Leuten\nimmer viel Gl[UNI00fc]ck."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Wenn ich unterwegs bin, regnet\nes nie, und eine Los-Niete hab\nich noch nie gesehen.<page>Was meinst du?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Na gut.\nNein, tut mir Leid.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(villager, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Was? Sei nicht gemein!\nDu bist so fies!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Du bist bl[UNI00f6]d!<page>Du Dummkopf!<page>Du Idiot!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Du nimmst mich mit?<page>Das h[UNI00e4]tte ich nicht gedacht!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber warum muss ich als Einzige\nfragen, wenn du all die anderen\nselbst um Hilfe bittest?<page>Wenn du einfach gefragt h[UNI00e4]ttest,\nh[UNI00e4]tte ich nat[UNI00fc]rlich geholfen."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ich wei[UNI00df] - wenn du mich findest,\nhelf ich dir. Abgemacht?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Mit anderen Worten, wir\nspielen  Verstecken!<page>Gut, los geht's!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	wait.frames(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, villager)
	event.set_character_active(0, villager)
	event.delete_villager(villager)
	event.fade_in_screen(30)
	wait.frames(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Na ja ... Du versuchst wohl besser,\n   Corinne zu finden. Sie hat sich\n   bestimmt in Palm Brinks versteckt."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

--- Plays Gordon's explanation of his tree problem, his quest and the notebook that tracks it.
function villager_dialogue.start_gordon_quest(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local notebook_count: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.hint_talk_to_gordon(villager, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"Oh, Max! Du siehst in letzter\nZeit oft traurig aus. Ist alles\nin Ordnung bei dir?<page>Kann ich etwas f[UNI00fc]r dich tun?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Wie? Ich soll dich auf\ndeinem Abenteuer begleiten?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Hmm ... ich w[UNI00fc]rde gern mitkommen ...\nAber dieser arme Baum\nist krank.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Die Pflege der B[UNI00e4]ume und\nBlumen auf diesem Gel[UNI00e4]nde\nist mir das Wichtigste [UNI00fc]berhaupt.<page>Wenn ich einfach abhaue,\nverliere ich noch meinen Job."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Etwas von Brunos Weihwasser\nw[UNI00fc]rde diesem Baum sicher helfen!<page>Aber du wei[UNI00df]t ja, dein Vater und\nder Priester verstehen sich nicht...<page>Dein Vater w[UNI00fc]rde mir nie Geld\nf[UNI00fc]r Priester Brunos Weihwasser geben!<page>Ich sitze in der Klemme."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Um Gordon nach Sindain zu\n   bringen, musst du ihn erst\n   als Begleiter gewinnen.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Wenn du Gordon hilfst,\n   schlie[UNI00df]t er sich dir an\n   und steigt in den Zug.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Deine Auftr[UNI00e4]ge findest du\n   im Notizbuch\n   im Gegenst[UNI00e4]nde-Men[UNI00fc]."
	)
	message.show(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(0, "[(!)]Oh, du hast kein Notizbuch.\n   Auf dem Tisch im\n   Ger[UNI00e4]teladen liegt eins.")
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]In Donnys Versteck liegt auch\n   eins. Es ist egal, welches\n   du nimmst, aber mach schnell!"
		)
		message.show(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Speaks a villager's lines about Fabio, with different lines in chapter 8.
function villager_dialogue.talk_about_fabio(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Ich hoffe, dass ich auch einmal\nauf dem Siegertreppchen stehen werde.")
	else
		event.open_message_window_2(
			0,
			"Ich w[UNI00fc]nschte nur, Fabio w[UNI00fc]rde\nsich auch f[UNI00fc]r andere Dinge\nals Angeln interessieren."
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Speaks a villager's lines about missing the moon.
function villager_dialogue.talk_about_moon(villager: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Warum fehlt mir der Mond so sehr?<page>Ich frage mich, ob ich\nwohl von dort stamme ...")
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Chooses the villager's conversation from the progress of quest request 18, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_18_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.ask_to_join_party(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 18) or quest_status
	if quest_status == 0 then
		villager_dialogue.start_corinne_hide_and_seek(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_after_hide_and_seek(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_hide_and_seek(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 19, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_19_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_hard_of_hearing(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 19) or quest_status
	if quest_status == 0 then
		npc_dialogue.recruit_hard_of_hearing_woman(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_grandmother(villager, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_old_granny(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 4, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_4_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_about_leaving_town(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 4) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_flower_photo(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_flower_photo_request(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_railroad_fan(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 6, using a default talk until quest request 0 is complete, with a separate talk while Monica is playable.
function villager_dialogue.talk_quest_6_villager(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.compare_player_to_elena(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_problem_advice(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 6) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_book_funds(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_villagers.lend_auction_money(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_book(villager, player_character)
		return
	end
end

--- Starts the conversation of the villager that triggered the event.
function villager_dialogue.talk_to_triggered_villager()
	local villager_type: s32 = 0
	local villager: s32 = 0
	local player_character: s32 = 0
	local step: number = 0
	return vm.guard(function()
		villager_type = event.get_triggered_event_data_2(14) or villager_type
		villager = event.get_triggered_event_data_2(13) or villager
		player_character = event.get_player_character_slot() or player_character
		if villager_type <= 34 then
			step = 1
			palm_brinks_villagers.talk_to_npc(villager, player_character)
		else
			step = 2
			palm_brinks_villagers.talk_to_ordinary_villager()
		end
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				cutscene.go_shop_up_skippable_forwarded()
			end
			return 0
		end
		return nil
	end)
end

--- Speaks the villager of type 16's lines when Monica is the playable character, with different lines in chapter 8.
function villager_dialogue.talk_villager_16_as_monica(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Feuerwaffen sind keine Spielzeuge.<page>Sei sehr vorsichtig mit\nihnen, sonst verletzt du dich."
		)
	else
		event.open_message_window_2(
			0,
			"Ab jetzt helfe ich Need und Cedric,\ndie Welt wieder aufzubauen.\nDabei m[UNI00fc]ssen wir zusammenarbeiten."
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

return villager_dialogue
