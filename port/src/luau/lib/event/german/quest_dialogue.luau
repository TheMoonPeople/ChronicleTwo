--!strict
--- Holds the German quest dialogue events for requests, recruits and request-progress routing.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/german/npc_chatter")
local npc_dialogue = vm.module("@lib/event/german/npc_dialogue")
local npc_recruit = vm.module("@lib/event/german/npc_recruit")
local palm_brinks_quests = vm.module("@lib/event/german/palm_brinks_quests")
local palm_brinks_villagers = vm.module("@lib/event/german/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local swordsmith = vm.module("@lib/event/german/swordsmith")

local quest_dialogue = {}

--- Plays the scene where the tailor hands over her first finished garment and joins the party.
function quest_dialogue.receive_tailor_garment(npc: s32, player: s32)
	local garment_item: s32 = 0
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Ah, Max! Ich hab etwas gen[UNI00e4]ht!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ich wollte deine Materialien\nnicht verschwenden,\nund das hat mich motiviert.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ich bin nicht zufrieden damit,\naber w[UNI00fc]rdest du es trotzdem tragen?")
	message.say_bubble(0, -1, npc, player, 0)
	garment_item = 259
	item_count = event.get_item_count(258) or item_count
	if item_count <= 0 then
		garment_item = 258
	else
		item_count = event.get_item_count(260) or item_count
		if item_count <= 0 then
			garment_item = 260
		end
	end
	event.add_inventory_item(garment_item)
	inventory.announce_received(garment_item, 1)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(
		0,
		"Ach, ich bin so froh, dass\nich etwas fertig bekommen habe.<page>Jetzt bin ich viel\nzuversichtlicher.<page>Ich werde mir alle M[UNI00fc]he geben,\nalso nimm mich bitte mit."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

--- Has the servant explain his need for money to bid on a rare book, then starts that request.
function quest_dialogue.request_book_funds(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Falls du etwas brauchst,\nhelfe ich gern so gut ich kann.<page>Verlass dich auf mich.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, " ...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ich wei[UNI00df] nicht, ob du helfen\nkannst ...<page>Aber h[UNI00f6]r dir das an.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ich arbeite seit 30 Jahren\nhart in diesem Haus.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ich mache sonst nichts, aber\nmein Hobby ist Lesen.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Es gibt ein kostbares, seltenes\nBuch, das momentan versteigert wird.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Alle wollen es haben.\nIch denke, ein Gebot von etwa\n1000 Gilda m[UNI00fc]sste reichen.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Aber so viel Geld habe ich nicht,\nund wenn ich meinen Meister frage, wird\ner wom[UNI00f6]glich sauer und k[UNI00fc]ndigt mir."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Du bist meine einzige Hoffnung.<page>Aber das hei[UNI00df]t nicht, dass\nich dir nicht helfe, wenn\ndu mir nicht hilfst."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Egal was er sagt - Stewart\n   hilft dir wohl nur f[UNI00fc]r 1000 Gilda.\n   Tja, dann spar mal sch[UNI00f6]n!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

--- Has the villager set a church candle puzzle, then starts that request.
function quest_dialogue.request_candle_puzzle(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Wirklich? Ich soll dir helfen?<page>Dann l[UNI00f6]se mein R[UNI00e4]tsel.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Die Kerzen dieser Kirche werden \nvon einem Mechanismus gesteuert.<page>Sind sie an, so l[UNI00f6]scht er sie,\nwenn sie aus sind, entz[UNI00fc]ndet er sie.<page>Wenn sich eine Kerze [UNI00e4]ndert,\n[UNI00e4]ndern sich ihre Nachbarn mit."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Wenn du alle Kerzen l[UNI00f6]schst,\nbeweist das deine Weisheit.\nDann komme ich mit.<page>Wenn du es l[UNI00f6]st, prima! Wenn nicht,\nmusst du verstehen, dass ich\ndir nicht helfen kann."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Noch etwas Kniffliges. Versuch's\n   ein paar Mal, und merke dir,\n   was du dabei lernst."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Wenn du wieder in die Kirche\n   kommst, sind die Kerzen wieder normal.\n   Keine Angst vor Fehlversuchen!\n   Es k[UNI00f6]nnte ganz leicht sein."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Has the mayor ask the player to work out his forgotten safe combination, then starts that request.
function quest_dialogue.request_safe_combination(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player, npc)
	event.open_message_window_2(0, "Grummel, grummel ...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Was soll das hei[UNI00df]en, was\nmurmele ich da?<page>Ich versuche, mich an die\nSafe-Kombination zu erinnern."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Was soll das hei[UNI00df]en,\nwelcher Safe?<page>Der Safe hinter dem Bild\nin meinem B[UNI00fc]ro nat[UNI00fc]rlich ..."
	)
	message.say_bubble(0, -1, npc, player, 0)
	character.face_toward(npc, player)
	event.set_character_motion(npc, "会話")
	event.open_message_window_2(
		0,
		"Ah, du hast mich erschreckt!<page>Oh, Mist!<page>Jetzt hab ich mein gr[UNI00f6][UNI00df]tes\nGeheimnis ausgeplaudert!<page>Na ja, jetzt wei[UNI00df]t du's.<page>Vielleicht hilfst du mir\nja, ihn zu [UNI00f6]ffnen."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Ich hab ein gro[UNI00df]es Problem -\nich habe die Kombination f[UNI00fc]r\nden Safe vergessen."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Es sind vier Ziffern. Deshalb\nhabe ich Claires Geburtstag genommen -\nich dachte, den vergess ich nie."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Wie konnte ich ihn vergessen ...<page>Ich bin ein schrecklicher Vater!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Need scheint sehr besorgt.\n   H[UNI00f6]r zu, was er [UNI00fc]ber Claires Ge-\n   burtstag sagt und knack den Code!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

--- Hands Monica a Gladius and asks her to build it up two levels, then starts that request.
function quest_dialogue.request_sword_upgrade(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Du bist Monica,\nstimmt's?<page>Du sollst ganz gut mit\nSchwertern umgehen k[UNI00f6]nnen.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Aber du musst wissen, dass\nSchwerter keine Spielzeuge sind.<page>Du musst dar[UNI00fc]ber nachdenken,\nwas du vor dir hast."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Wenn du ein Schwert um etwa\nzwei Stufen hochstufen kannst, glaube\nich dir, dass du Talent hast."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Warum f[UNI00e4]ngst du nicht mit\ndiesem Sto[UNI00df]schwert an?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.add_inventory_item(44)
	inventory.announce_received(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Um Milanes Respekt zu gewinnen,\n   musst du offenbar das\n   Sto[UNI00df]schwert um 2 Stufen hochstufen"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Du kannst auch Waffen kaufen\n   oder finden. Bring ihr eine\n   starke Waffe, und Milane hilft dir."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

--- Has the would-be tailor ask the player to fetch cloth, hide and copper, then starts that request.
function quest_dialogue.request_tailor_materials(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"Ja, wenn ich's wieder versuche\nund diesmal etwas schaffe,\nk[UNI00f6]nnte ich wieder an mich glauben."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Aber ich habe keine Materialien.<page>K[UNI00f6]nntest du sie mir holen?")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ich brauche nur starken\nStoff, Tierhaut und einen\nKupferklumpen.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
	event.set_save_counter(8, 1)
end

--- Routes the angler conversation by request progress.
function quest_dialogue.talk_angler(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_chatter.talk_angler_intro(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 15) or quest_status
	if quest_status == 0 then
		palm_brinks_villagers.request_catch_big_nonky(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_nonky_catch(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_fishing_spots(npc, player)
		return
	end
end

--- Routes the baker conversation by playable character and request progress.
function quest_dialogue.talk_baker(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_baker_about_max(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_customer_trust(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 8) or quest_status
	if quest_status == 0 then
		npc_dialogue.start_baker_request(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_baker_request(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_bread_offer(npc, player)
		return
	end
end

--- Plays the bread-delivery recipient dialogue for the current delivery stage.
function quest_dialogue.talk_bread_delivery_recipient(npc: s32, player: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage == 0 then
		event.open_message_window_2(0, "Oh, du hilfst\nPolly?<page>Toll.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Was ich mit\n20 Laiben will?<page>Ich mache heute mit ein\npaar Leuten K[UNI00e4]sefondue.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			'Um mit deinen "Erfindungen" zu\nsprechen - es ist eine Kombination<page>aus K[UNI00e4]se, Brot und Wein!'
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"Es ist super. Man isst viel,\ndeshalb brauche ich das Brot.<page>Aber ich wollte es eigentlich\nnicht hierher geliefert haben."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"Sag mal, Max, k[UNI00f6]nntest du es zu mir\nnach Hause bringen?<page>Du wei[UNI00df]t doch, wo das ist?\nBeim K[UNI00fc]rbisfeld."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 1)
	end
	if delivery_stage == 1 then
		event.open_message_window_2(0, "Du wei[UNI00df]t, wo es ist, nicht?\nBeim K[UNI00fc]rbisfeld.")
		message.say_bubble(0, -1, npc, player, 0)
	end
	if delivery_stage == 2 then
		event.open_message_window_2(0, "Abgesagt?\nWie schade!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"Dann brauche ich das Brot nicht.\nKannst du es f[UNI00fc]r mich zu Polly\nzur[UNI00fc]ckbringen?"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 3)
	end
	if delivery_stage == 3 then
		event.open_message_window_2(0, "Tut mir Leid - kannst du Polly\ndas Brot f[UNI00fc]r mich zur[UNI00fc]ckbringen?")
		message.say_bubble(0, -1, npc, player, 0)
	end
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Picks the resident's conversation from the progress of the angler's Nonky fishing request, speaking an idle line before the requests open.
function quest_dialogue.talk_by_request_status(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_chatter.talk_angler_intro(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 15) or request_status
	if request_status == 0 then
		palm_brinks_quests.explain_fish_challenge(npc_character, player_character)
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

--- Routes the candy maker conversation by playable character and request progress.
function quest_dialogue.talk_candy_maker(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_aspiring_chef(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_cooking_experiments(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 3) or quest_status
	if quest_status == 0 then
		palm_brinks_villagers.request_chestnuts(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_chestnut(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_candy_maker_done(npc, player)
		return
	end
end

--- Routes the coin collector conversation by request progress.
function quest_dialogue.talk_coin_collector(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_shop_closed(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 2) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_rare_coins(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_rare_coins(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_zelmite_hunt(npc, player)
		return
	end
end

--- Routes the mayor conversation by request progress.
function quest_dialogue.talk_mayor(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_muttering_numbers(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 12) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_safe_combination(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_safe_code_request(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_garbage_sorting(npc, player)
		return
	end
end

--- Routes the swordsmith conversation by playable character and request progress.
function quest_dialogue.talk_swordsmith(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		npc_chatter.talk_swordsmith_max(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_blade_shop(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 10) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_sword_upgrade(npc, player)
		return
	end
	if quest_status == 1 then
		quest_dialogue.test_sword_for_recruit(npc, player)
		return
	end
	if quest_status == 2 then
		swordsmith.chat_about_swords(npc, player)
		return
	end
end

--- Checks that the player owns the required gun and, if so, recruits the gun fighter and completes the request.
function quest_dialogue.test_gun_for_recruit(npc: s32, player: s32)
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	item_count = event.get_item_count(25) or item_count
	if item_count <= 0 then
		event.open_message_window_2(
			0,
			"Was ist denn los?\nGibst du schon wieder auf?<page>Ich bin entt[UNI00e4]uscht.\nKommt das davon, wenn man\nimmer an Maschinen bastelt?"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Du scheinst auch mit Waffen\nnicht schlecht zu sein!<page>Ich muss dich nicht mal\nschie[UNI00df]en sehen. Ich sehe schon, wie\nprofessionell du sie h[UNI00e4]ltst."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Na gut, ich helfe dir.\nAber ich tu's nicht f[UNI00fc]r dich.<page>Wenn die Stadt in Gefahr ist,\nkann ich nicht einfach\ntatenlos zusehen."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 11, 1)
end

--- Checks that the player owns one of the required swords and, if so, recruits the swordsman and completes the request.
function quest_dialogue.test_sword_for_recruit(npc: s32, player: s32)
	local first_item_count: s32 = 0
	local second_item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	first_item_count = event.get_item_count(67) or first_item_count
	second_item_count = event.get_item_count(69) or second_item_count
	if first_item_count <= 0 and second_item_count <= 0 then
		event.open_message_window_2(
			0,
			"Was ist das f[UNI00fc]r ein Schwert?\nDu kannst also nur gro[UNI00df] t[UNI00f6]nen?<page>Verschwinde hier!\nDu bist nur im Weg."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Wow, das ist ein sehr\nbeeindruckendes Schwert.<page>Tut mir Leid, dass ich dich\nauf die Probe stellen musste."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Aber K[UNI00e4]mpfe an der Seite\nvon Anf[UNI00e4]ngern sind eben gef[UNI00e4]hrlich.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Aber davor brauche ich bei dir\nkeine Angst zu haben.<page>Dann ziehen wir\ngemeinsam in den Kampf."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

return quest_dialogue
