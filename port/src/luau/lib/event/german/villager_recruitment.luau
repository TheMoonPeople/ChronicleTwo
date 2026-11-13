--!strict
--- Holds the German recruitment of the old woman villager into the party.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/german/npc_chatter")
local npc_dialogue = vm.module("@lib/event/german/npc_dialogue")
local npc_recruit = vm.module("@lib/event/german/npc_recruit")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/german/palm_brinks_quests")
local palm_brinks_talk = vm.module("@lib/event/german/palm_brinks_talk")
local palm_brinks_villagers = vm.module("@lib/event/german/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/german/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/german/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_recruitment = {}

--- Prompts the player for the invitation phrase and recruits the old woman villager when it is entered correctly.
function villager_recruitment.ask_phrase_to_join(villager: s32, player_character: s32)
	local entry_result: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Wie bitte?<page>Kannst du nicht langsamer reden?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Bitte gib ein:"Komm mit mir." ', "Komm mit mir.", 0)
	event.open_event_menu(5)
	vm.wait(3)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		entry_result = out1 or entry_result
	end
	if entry_result == -1 then
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	if entry_result == 0 then
		event.open_message_window_2(0, "Was redest du da?\nIch verstehe nichts ...")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ein Abenteuer?\nDas w[UNI00e4]re sch[UNI00f6]n.<page>Aber was n[UNI00fc]tzt dir da\neine alte Frau wie ich?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

--- Runs the butler's rising auction bids, taking 2000 Gilda once the player pays and returning 600 after the successful bid.
function villager_recruitment.collect_auction_funds(villager: s32, player_character: s32)
	local bid_stage: s32 = 0
	local money: s32 = 0
	local choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	bid_stage = event.get_save_counter(9) or bid_stage
	money = event.get_money() or money
	if bid_stage == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"Mit dem Betrag brauche ich\ngar nicht erst mitzubieten.<page>Ich brauche 1000 Gilda.\nBitte versuch es!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(0, "Du wirst es nicht glauben!<page>Der Preis ist auf\n1200 Gilda gestiegen.")
			message.say_bubble(0, -1, villager, player_character, 0)
			event.open_message_window_2(0, "Es tut mir sehr Leid, aber\nkannst du auch 1500 Gilda besorgen?")
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	if bid_stage == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"Wir d[UNI00fc]rfen keine Zeit verlieren,\nsonst kauft es jemand anderes.<page>Besorg mir so schnell wie\nm[UNI00f6]glich 1500 Gilda!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"Es ist schrecklich!\nJemand will 1800 Gilda bieten!<page>Wenn ich nicht etwa 2000 Gilda\nbiete, bekomme ich es nie."
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	if bid_stage == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"Wir d[UNI00fc]rfen keine Zeit verlieren,\nsonst kauft es jemand anderes.<page>Besorg mir so schnell wie\nm[UNI00f6]glich 2000 Gilda!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Na, Kleiner, hast du meine\n2000 Gilda zusammen?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "Es geh[UNI00f6]rt dir.\nIch halte es f[UNI00fc]r Verschwendung.")
		choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if choice ~= 0 then
			event.open_message_window_2(
				0,
				"Na klar - 2000 Gilda sind viel Geld,\ndas verschenkt man nicht leicht.\nSelbst reiche Jungs wie du nicht ...<page>Na gut, vergiss es!\nAber die Auktion l[UNI00e4]uft noch.\nIch warte, egal wie lang ..."
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Vielen, vielen Dank.<page>Ich gehe direkt zur Auktion!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, villager)
		event.set_character_active(0, villager)
		event.delete_villager(villager)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Vielen Dank.\nIch habe es ersteigert.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Ich habe hoch geboten, und\nalle sind ausgestiegen -\nich hab's f[UNI00fc]r 1400 Gilda bekommen!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Du bekommst 600 zur[UNI00fc]ck.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(0, "Und ab jetzt arbeite ich,\num dir den Rest zur[UNI00fc]ckzuzahlen.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ich wei[UNI00df], wie anstrengend das war.\nIch revanchiere mich gern,\nwann immer du willst.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

--- Plays the villager's reaction to being found hiding, sending them off to hide again on the first find and recruiting them on the second.
function villager_recruitment.finish_hide_and_seek(villager: s32, player_character: s32)
	local found_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	found_count = event.get_save_counter(11) or found_count
	if found_count < 1 then
		event.open_message_window_2(0, "Oh! Du hast mich!<page>Aber findest du mich noch mal?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		event.set_save_counter(11, found_count + 1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, villager)
		event.set_character_active(0, villager)
		event.delete_villager(villager)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Du hast mich ...<page>Ich hab keine Lust mehr.<page>Verstecken ist eigentlich\ntotal langweilig.<page>Na gut! Dann ziehen wir in\nunser Abenteuer!"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

--- Has the villager challenge the player to win the Fish Race Beginners' Class before agreeing to help.
function villager_recruitment.give_fish_race_challenge(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Das Firbit-Volk gew[UNI00e4]hrt\nnur denen Hilfe,\ndie etwas besser k[UNI00f6]nnen als sie.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Was Fische angeht, bin ich\nsehr selbstbewusst.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Ich hab geh[UNI00f6]rt, dass einige Menschen\nihre Fische in einem Wettkampf\ngegeneinander antreten lassen.<page>Wenn du einen Fisch hast,\nkannst du doch versuchen,\ndas Wettschwimmen zu gewinnen!<page>Wenn du das schaffst, wei[UNI00df]\nich, dass du meine Hilfe\nverdienst."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Sie redet wohl vom Flossen-\n   Fieber. Gewinne die Anf[UNI00e4]nger-\n   Klasse, dann hilft sie vielleicht!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

--- Has the villager hand Monica a Gladius and challenge her to build it up by two levels before Milane will join.
function villager_recruitment.give_gladius_challenge(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Du bist Monica,\nstimmt's?<page>Du sollst ganz gut mit\nSchwertern umgehen k[UNI00f6]nnen.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber du musst wissen, dass\nSchwerter keine Spielzeuge sind.<page>Du musst dar[UNI00fc]ber nachdenken,\nwas du vor dir hast."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Wenn du ein Schwert um etwa\nzwei Stufen hochstufen kannst, glaube\nich dir, dass du Talent hast."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Warum f[UNI00e4]ngst du nicht mit\ndiesem Sto[UNI00df]schwert an?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.add_inventory_item(44)
	inventory.show_obtained_message_for_item_id(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Um Milanes Respekt zu gewinnen,\n   musst du offenbar das\n   Sto[UNI00df]schwert um 2 Stufen hochstufen"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Du kannst auch Waffen kaufen\n   oder finden. Bring ihr eine\n   starke Waffe, und Milane hilft dir."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

--- Plays the villager's worry about a tree and hints that Gordon must be spoken to first.
function villager_recruitment.hint_talk_to_gordon(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_character, "立ち")
	event.open_message_window_2(0, "Hmm, dieser Baum ... sieht nicht\ngut aus. Ich muss etwas tun.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Gordon musst du offenbar\n   ansprechen, sonst merkt er nichts.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

--- Recruits the villager if the church candles are all out, otherwise turns the player away.
function villager_recruitment.join_after_candle_puzzle(villager: s32, player_character: s32)
	local visible_candle_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	visible_candle_count = object.count_visible_map_parts()
	if 0 < visible_candle_count then
		event.open_message_window_2(0, "Du scheinst noch nicht gut\ngenug zu sein.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(
			0,
			"Ich setze gro[UNI00df]e Hoffnungen in dich,\naber ich f[UNI00fc]rchte, momentan kann\nich dir nicht helfen."
		)
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Gut gemacht.\nWunderbar.<page>Du wirst meine Erwartungen\nsicher nicht entt[UNI00e4]uschen.<page>Ich hab's versprochen, nicht wahr?\nIch begleite dich."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

--- Has the villager pose the church candle puzzle as the condition for joining the party.
function villager_recruitment.pose_candle_puzzle(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Wirklich? Ich soll dir helfen?<page>Dann l[UNI00f6]se mein R[UNI00e4]tsel.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Die Kerzen dieser Kirche werden \nvon einem Mechanismus gesteuert.<page>Sind sie an, so l[UNI00f6]scht er sie,\nwenn sie aus sind, entz[UNI00fc]ndet er sie.<page>Wenn sich eine Kerze [UNI00e4]ndert,\n[UNI00e4]ndern sich ihre Nachbarn mit."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Wenn du alle Kerzen l[UNI00f6]schst,\nbeweist das deine Weisheit.\nDann komme ich mit.<page>Wenn du es l[UNI00f6]st, prima! Wenn nicht,\nmusst du verstehen, dass ich\ndir nicht helfen kann."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Noch etwas Kniffliges. Versuch's\n   ein paar Mal, und merke dir,\n   was du dabei lernst."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Wenn du wieder in die Kirche\n   kommst, sind die Kerzen wieder normal.\n   Keine Angst vor Fehlversuchen!\n   Es k[UNI00f6]nnte ganz leicht sein."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Gives the player one of three garments depending on which they already own, then recruits the tailor villager.
function villager_recruitment.receive_garment_and_join(villager: s32, player_character: s32)
	local item_id: s32 = 0
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Ah, Max! Ich hab etwas gen[UNI00e4]ht!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ich wollte deine Materialien\nnicht verschwenden,\nund das hat mich motiviert.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ich bin nicht zufrieden damit,\naber w[UNI00fc]rdest du es trotzdem tragen?")
	message.say_bubble(0, -1, villager, player_character, 0)
	item_id = 259
	item_count = event.get_item_count(258) or item_count
	if item_count <= 0 then
		item_id = 258
	else
		item_count = event.get_item_count(260) or item_count
		if item_count <= 0 then
			item_id = 260
		end
	end
	event.add_inventory_item(item_id)
	inventory.show_obtained_message_for_item_id(item_id, 1)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(
		0,
		"Ach, ich bin so froh, dass\nich etwas fertig bekommen habe.<page>Jetzt bin ich viel\nzuversichtlicher.<page>Ich werde mir alle M[UNI00fc]he geben,\nalso nimm mich bitte mit."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

--- Starts the old woman villager's recruitment conversation by asking for the invitation phrase.
function villager_recruitment.recruit_old_woman(villager_slot: s32, player_slot: s32)
	villager_recruitment.ask_phrase_to_join(villager_slot, player_slot)
end

--- Has the tailor villager decline to join because of lost confidence and hint that she should sew again.
function villager_recruitment.refuse_for_lack_of_confidence(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"Aha ... Ich w[UNI00fc]rde dir sehr\ngern helfen. Mehr\nals gern sogar.<page>Aber ich habe einfach\nkein Selbstvertrauen."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Ich gebe immer auf halbem Weg\nauf - ich hab noch nie etwas\nzu Ende gebracht.<page>Als Kind wollte ich Schneiderin\nwerden und habe viel ausprobiert,\naber ich habe nie was fertig gen[UNI00e4]ht."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Wenn ich mitk[UNI00e4]me, w[UNI00e4]re ich\nbestimmt nur im Weg.<page>Tut mir Leid, aber - nein."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh Mann, Adel hat gar kein\n   Selbstvertrauen. Das ist nicht\n   gut. Bring sie wieder zum N[UNI00e4]hen."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- Has the villager decline to join and ask Max for a flower photo, or defers to Monica's version of the talk.
function villager_recruitment.refuse_until_flower_photo(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(villager, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(
		0,
		"Ich w[UNI00fc]rde ja gern helfen, aber\nK[UNI00e4]mpfe sind gef[UNI00e4]hrlich\nund man wird schmutzig."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Und ich m[UNI00f6]chte niemand nerven.\nTut mir Leid, ich muss passen.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber es muss viel Interessantes\nau[UNI00df]erhalb der Stadt geben.<page>Ich frag mich, wie die B[UNI00e4]ume\naussehen und was f[UNI00fc]r Blumen es gibt."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Wenn du eine interessante Blume\nsiehst, machst du mir ein Foto?\nIch m[UNI00f6]chte sie so gern sehen."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Diesmal hat sie abgelehnt, aber wenn\n   du ihr ein Foto zeigst, das sie\n   interessiert, gibt sie wohl nach."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Has the distrustful villager decline to join and hint that a photo of the moon would win their trust.
function villager_recruitment.refuse_until_moon_photo(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Ja, ich komme gern mit -\naber gibt's dort auch einen Mond?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ach ja? Vielleicht sagst du das nur.\nIch wei[UNI00df], dass Menschen oft l[UNI00fc]gen.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Nein, ich hab's mir anders\n[UNI00fc]berlegt. Ich warte hier, bis der Mond kommt.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Vielleicht ist ihm fr[UNI00fc]her\n   etwas passiert - Rufio\n   vertraut Menschen offenbar nicht."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Du musst Rufios Vertrauen\n   gewinnen. Vielleicht w[UNI00fc]rde\n   ein Foto des Mondes reichen."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Plays the butler's request for money to bid on a rare book at auction.
function villager_recruitment.request_book_auction_funds(villager: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Falls du etwas brauchst,\nhelfe ich gern so gut ich kann.<page>Verlass dich auf mich.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, " ...")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ich wei[UNI00df] nicht, ob du helfen\nkannst ...<page>Aber h[UNI00f6]r dir das an.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ich arbeite seit 30 Jahren\nhart in diesem Haus.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ich mache sonst nichts, aber\nmein Hobby ist Lesen.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Es gibt ein kostbares, seltenes\nBuch, das momentan versteigert wird.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Alle wollen es haben.\nIch denke, ein Gebot von etwa\n1000 Gilda m[UNI00fc]sste reichen.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber so viel Geld habe ich nicht,\nund wenn ich meinen Meister frage, wird\ner wom[UNI00f6]glich sauer und k[UNI00fc]ndigt mir."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Du bist meine einzige Hoffnung.<page>Aber das hei[UNI00df]t nicht, dass\nich dir nicht helfe, wenn\ndu mir nicht hilfst."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Egal was er sagt - Stewart\n   hilft dir wohl nur f[UNI00fc]r 1000 Gilda.\n   Tja, dann spar mal sch[UNI00f6]n!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

--- Plays the magical artist Parn's introduction and his request for Golden Paint, with a shorter version for Monica.
function villager_recruitment.request_golden_paint(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(villager, 0, 0)
		event.open_message_window_2(0, "Hallo.\nDu bist Monica, stimmt's?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Ich bin Parn.\nIch bin Zaubermaler.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "Ich hab euch noch nicht\nvorgestellt, oder?<page>Das ist Julia, meine Zuk[UNI00fc]nftige.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.open_message_window_2(0, " ...")
		message.say_bubble(0, -1, player_character, villager, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Monica ist in solchen Situationen\n   unbeholfen. Wahrscheinlich schafft\n   sie das nicht. Versuch's als Max."
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Hallo, Max.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Ich hab euch noch nicht\nvorgestellt, oder?<page>Das ist Julia, meine Zuk[UNI00fc]nftige.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, " ...")
	message.say_bubble(0, -1, player_character, villager, 0)
	event.open_message_window_2(
		0,
		"Ja, lach du nur.\nEs klingt ja auch komisch!<page>Wer verliebt sich schon\nin eine gemalte Frau?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber ich bin Zaubermaler.\nWas ich zeichne, wird Wirklichkeit.<page>Was ich male, existiert im Bild\ntats[UNI00e4]chlich. Solange es nichts\nLebendiges ist ..."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Selbst Zaubermaler k[UNI00f6]nnen nichts\nLebendiges erschaffen.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber es gibt eine M[UNI00f6]glichkeit.\nAuf einem gro[UNI00df]en alten Baum liegt\nein Goldenes Ei."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Angeblich kann man mit seiner\ngoldenen Farbe alles Gezeichnete\nzum Leben erwecken.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Max, du verl[UNI00e4]sst die\nStadt, nicht wahr?<page>Kannst du mir wohl goldene\nFarbe mitbringen?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Du bekommst nat[UNI00fc]rlich etwas daf[UNI00fc]r.<page>Wenn du mir hilfst, helfe\nich dir mit meiner neuen Kraft."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Ein gro[UNI00df]er alter Baum ...\n   mit einem Goldenen Ei! Wo k[UNI00f6]nnte\n   so ein Baum blo[UNI00df] stehen?"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

--- Routes a triggered NPC talk to the villager conversation for NPC ids up to 34 and to the generic handler otherwise.
function villager_recruitment.route_npc_talk()
	local npc_id: s32 = 0
	local villager: s32 = 0
	local player_character: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		villager = event.get_triggered_event_data_2(13) or villager
		player_character = event.get_player_character_slot() or player_character
		if npc_id <= 34 then
			resume_point = 1
			palm_brinks_talk.talk_to_villager(villager, player_character)
		else
			resume_point = 2
			palm_brinks_villagers.talk_to_ordinary_villager()
		end
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				cutscene.go_shop_up_skippable_forwarded()
			end
			return 0
		end
		return nil
	end)
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 18.
function villager_recruitment.route_request_18_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.ask_to_join_party(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 18) or quest_status
	if quest_status == 0 then
		npc_recruit.challenge_hide_and_seek(villager, player_character)
		return
	end
	if quest_status == 1 then
		villager_recruitment.finish_hide_and_seek(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_hide_and_seek(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 1.
function villager_recruitment.route_request_1_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.talk_to_parn(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 1) or quest_status
	if quest_status == 0 then
		villager_recruitment.request_golden_paint(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_recruit.receive_golden_paint(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_painter_done(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 2.
function villager_recruitment.route_request_2_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_shop_closed(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 2) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_rare_coins(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_coin_collector(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_zelmite_hunt(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 6, with a separate talk for Monica.
function villager_recruitment.route_request_6_talk(villager: s32, player_character: s32)
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
		villager_recruitment.request_book_auction_funds(villager, player_character)
		return
	end
	if quest_status == 1 then
		villager_recruitment.collect_auction_funds(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_book(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 7 and the garment progress counter, with a separate talk for Monica.
function villager_recruitment.route_request_7_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	local garment_stage: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_tailor_monica(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_seamstress_dream(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 7) or quest_status
	if quest_status == 0 then
		villager_recruitment.refuse_for_lack_of_confidence(villager, player_character)
		return
	end
	if quest_status == 1 then
		garment_stage = event.get_save_counter(8) or garment_stage
		if garment_stage == 0 then
			quest_dialogue.request_tailor_materials(villager, player_character)
		end
		if garment_stage == 1 then
			npc_dialogue.deliver_tailoring_materials(villager, player_character)
		end
		if garment_stage == 2 then
			villager_recruitment.receive_garment_and_join(villager, player_character)
		end
		return
	end
	if quest_status == 2 then
		villager_dialogue.pray_for_safety(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 8, with a separate talk for Monica.
function villager_recruitment.route_request_8_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_baker_about_max(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_customer_trust(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 8) or quest_status
	if quest_status == 0 then
		npc_recruit.request_bread_delivery(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_polly(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_bread_offer(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 9, once the villager stands at their post, with a separate talk for Monica.
function villager_recruitment.route_request_9_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	local x: f32 = 0
	local z: f32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_agile_admirer_monica(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_about_peaceful_town(villager, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(villager)
		x = out1 or x
		z = out3 or z
	end
	if x < 1182.0 or 1183.0 < x or z < 210.0 or 211.0 < z then
		print("kokokokokokokokokoko\n")
		npc_chatter.talk_busy_with_materials(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 9) or quest_status
	if quest_status == 0 then
		npc_dialogue.explain_boat_run_test(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.check_boat_race_time(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_agile_admirer(villager, player_character)
		return
	end
end

return villager_recruitment
