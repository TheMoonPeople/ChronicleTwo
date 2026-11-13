--!strict
--- Dialogue and scripted conversations of the Palm Brinks townspeople in the German version of the game.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local firearms_partner = vm.module("@lib/event/german/firearms_partner")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/german/npc_chatter")
local npc_dialogue = vm.module("@lib/event/german/npc_dialogue")
local party = vm.module("@lib/event/party")
local party_recruit = vm.module("@lib/event/german/party_recruit")
local quest_dialogue = vm.module("@lib/event/german/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/german/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local palm_brinks_villagers = {}

--- Remarks that the player resembles Elena and warns about Zelmite Mine.
function palm_brinks_villagers.compare_player_to_elena(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Vielleicht liegt's an mir, aber\ndu erinnerst mich sehr an Elena.<page>Ich wei[UNI00df] nicht, woran es liegt,\naber du bist anders als die\nanderen Leute in der Stadt."
		)
	else
		event.open_message_window_2(0, "Die Zelmit-Mine ist unheimlich.\nDort musst du immer\nwachsam bleiben.")
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Explains that the Firbit people only grant favours to those who are better than themselves.
function palm_brinks_villagers.explain_firbit_favours(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Das Firbit-Volk gew[UNI00e4]hrt\nnur denen Hilfe,\ndie etwas besser k[UNI00f6]nnen als sie.")
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Runs the request in which a villager asks for escalating sums of Gilda for an auction bid and returns 600 Gilda after winning it.
function palm_brinks_villagers.lend_auction_money(character: s32, player_character: s32)
	local auction_stage: s32 = 0
	local money: s32 = 0
	local handover_choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	auction_stage = event.get_save_counter(9) or auction_stage
	money = event.get_money() or money
	if auction_stage == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"Mit dem Betrag brauche ich\ngar nicht erst mitzubieten.<page>Ich brauche 1000 Gilda.\nBitte versuch es!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(0, "Du wirst es nicht glauben!<page>Der Preis ist auf\n1200 Gilda gestiegen.")
			message.say_bubble(0, -1, character, player_character, 0)
			event.open_message_window_2(0, "Es tut mir sehr Leid, aber\nkannst du auch 1500 Gilda besorgen?")
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"Wir d[UNI00fc]rfen keine Zeit verlieren,\nsonst kauft es jemand anderes.<page>Besorg mir so schnell wie\nm[UNI00f6]glich 1500 Gilda!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"Es ist schrecklich!\nJemand will 1800 Gilda bieten!<page>Wenn ich nicht etwa 2000 Gilda\nbiete, bekomme ich es nie."
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"Wir d[UNI00fc]rfen keine Zeit verlieren,\nsonst kauft es jemand anderes.<page>Besorg mir so schnell wie\nm[UNI00f6]glich 2000 Gilda!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Na, Kleiner, hast du meine\n2000 Gilda zusammen?")
		message.say_bubble(0, -1, character, player_character, 0)
		event.set_character_motion(character, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "Es geh[UNI00f6]rt dir.\nIch halte es f[UNI00fc]r Verschwendung.")
		handover_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if handover_choice ~= 0 then
			event.open_message_window_2(
				0,
				"Na klar - 2000 Gilda sind viel Geld,\ndas verschenkt man nicht leicht.\nSelbst reiche Jungs wie du nicht ...<page>Na gut, vergiss es!\nAber die Auktion l[UNI00e4]uft noch.\nIch warte, egal wie lang ..."
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Vielen, vielen Dank.<page>Ich gehe direkt zur Auktion!")
		message.say_bubble(0, -1, character, player_character, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, character)
		event.set_character_active(0, character)
		event.delete_villager(character)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Vielen Dank.\nIch habe es ersteigert.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ich habe hoch geboten, und\nalle sind ausgestiegen -\nich hab's f[UNI00fc]r 1400 Gilda bekommen!"
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Du bekommst 600 zur[UNI00fc]ck.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(0, "Und ab jetzt arbeite ich,\num dir den Rest zur[UNI00fc]ckzuzahlen.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Ich wei[UNI00df], wie anstrengend das war.\nIch revanchiere mich gern,\nwann immer du willst.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

--- Greets the shopkeeper that was talked to, then opens that shop's menu once the conversation ends.
function palm_brinks_villagers.open_shop_after_greeting()
	local npc_type: s32 = 0
	local npc_character: s32 = 0
	local baker_greeted: s32 = 0
	local weapon_shop_greeted: s32 = 0
	local priest_greeted: s32 = 0
	print("IN go_shop_up()\n")
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	npc_character = event.get_triggered_event_data_2(13) or npc_character
	print("talk_chara=", npc_type, "talk_chara_id=", npc_character, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Willkommen.")
	if npc_type == 18 then
		event.open_message_window_2(
			0,
			"M[UNI00f6]chtest du die Macht der\nG[UNI00f6]tter zeitweise verliehen bekommen?<page>Dann bitte ich um eine\nSpende f[UNI00fc]r die Kirche."
		)
	end
	if npc_type == 4 then
		event.open_message_window_2(
			0,
			"Schwer besch[UNI00e4]ftigt, was?\nBrauchst du was?<page>Aber gratis gibt's nichts.\nNicht mal f[UNI00fc]r dich, Max."
		)
	end
	if npc_type == 34 then
		event.open_message_window_2(
			0,
			"Du brauchst noch mehr Georama-\nTeile?<page>Falls du keine Zeit hast, sie\nselbst zu sammeln, kannst du vielleicht\nmit etwas Geld nachhelfen."
		)
	end
	if npc_type == 1012 then
		baker_greeted = event.get_save_flag(45) or baker_greeted
		if baker_greeted == 0 then
			event.open_message_window_2(
				0,
				"Hallo, ich bin B[UNI00e4]cker-Lehrling.\nIch k[UNI00fc]mmere mich um die B[UNI00e4]ckerei,\nsolange Polly fort ist.<page>Ich bin etwas nerv[UNI00f6]s, aber es\ngeh[UNI00f6]rt wohl auch zur Ausbildung.\nIch tue mein Bestes!"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_type == 1015 then
		weapon_shop_greeted = event.get_save_flag(46) or weapon_shop_greeted
		if weapon_shop_greeted == 0 then
			event.open_message_window_2(
				0,
				"Wir sehen uns kaum [UNI00e4]hnlich ...\naber ich bin Milanes kleine\nSchwester.<page>Sie hat gesagt, ich soll auf den\nLaden aufpassen, w[UNI00e4]hrend sie\nweg ist.<page>Dabei hab ich gar\nkeine Ahnung von Waffen!"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_type == 1018 then
		priest_greeted = event.get_save_flag(47) or priest_greeted
		if priest_greeted == 0 then
			event.open_message_window_2(
				0,
				"Hab ich dich [UNI00fc]berrascht, ja?\nEs ist ja auch [UNI00fc]berraschend, wenn hier\njemand in diesen Klamotten steht.<page>Ich bin mit Priester Bruno befreundet\nund vertrete ihn, solange er weg ist.\nKann ich dir denn helfen?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"M[UNI00f6]chtest du die Macht der\nG[UNI00f6]tter zeitweise verliehen bekommen?<page>Dann bitte ich um eine\nSpende f[UNI00fc]r die Kirche."
			)
		end
	end
	if npc_character ~= -1 then
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 18 then
		menu.open_type_6_alt(15)
	end
	if npc_type == 12 then
		menu.open_type_6_alt(1)
	end
	if npc_type == 4 then
		menu.open_type_6_alt(6)
	end
	if npc_type == 15 then
		menu.open_type_6_alt(0)
	end
	if npc_type == 33 then
		menu.open_type_6_alt(4)
	end
	if npc_type == 34 then
		menu.open_type_6_alt(31)
	end
	if npc_type == 1012 then
		menu.open_type_6_alt(35)
	end
	if npc_type == 1015 then
		menu.open_type_6_alt(36)
	end
	if npc_type == 1018 then
		menu.open_type_6_alt(37)
	end
end

--- Challenges the player to catch a Nonky over 60cm and registers request 15.
function palm_brinks_villagers.request_catch_big_nonky(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "Ich soll dir einen Gefallen tun?<page>Warte - h[UNI00f6]r mich erst an.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ich rede nur mit Leuten, die\nich respektiere.<page>Und ich respektiere nur Leute,\ndie gr[UNI00f6][UNI00df]ere Fische geangelt\nhaben als ich."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Mein gr[UNI00f6][UNI00df]ter Fang war\nein 60-cm-Nonky.<page>Bist du beeindruckt?\nWenn du gegen mich antreten\nm[UNI00f6]chtest, bin ich immer bereit!"
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Um ihn zu [UNI00fc]berzeugen, musst\n   du wohl einen Nonky fangen, der\n   l[UNI00e4]nger ist als 60 cm. Du schaffst es!"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Versuch doch mal, im\n   See von Palm Brinks zu angeln.")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Asks the player to find Chestnuts for the Castagnaccio sweet and registers the request.
function palm_brinks_villagers.request_chestnuts(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "Ah, das passt ja bestens!\nIch wollte mit dir reden.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Du wei[UNI00df]t ja sicher, dass\nich f[UNI00fc]r meine Forschungen auch\nS[UNI00fc][UNI00df]igkeiten aus aller Welt mache."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Es gibt ein Gericht\nnamens Castagnaccio,")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "f[UNI00fc]r das man Castarna braucht.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Diese Castarna wachsen\nauf den gleichen\nB[UNI00e4]umen wie Kastanien.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Da dachte ich, ich nehme einfach\nKastanien, aber es ist\nmerkw[UNI00fc]rdig - die sind [UNI00fc]berall ausverkauft."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Der B[UNI00fc]rgermeister soll alle\ngekauft haben. Kannst du mir helfen?")
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
	event.set_quest_request(0, 3, 1)
end

--- Tells the player the Firbit will help only if the player wins the Fish Race Beginners' Class, and registers request 16.
function palm_brinks_villagers.request_win_fish_race(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "Das Firbit-Volk gew[UNI00e4]hrt\nnur denen Hilfe,\ndie etwas besser k[UNI00f6]nnen als sie.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Was Fische angeht, bin ich\nsehr selbstbewusst.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ich hab geh[UNI00f6]rt, dass einige Menschen\nihre Fische in einem Wettkampf\ngegeneinander antreten lassen.<page>Wenn du einen Fisch hast,\nkannst du doch versuchen,\ndas Wettschwimmen zu gewinnen!<page>Wenn du das schaffst, wei[UNI00df]\nich, dass du meine Hilfe\nverdienst."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Sie redet wohl vom Flossen-\n   Fieber. Gewinne die Anf[UNI00e4]nger-\n   Klasse, dann hilft sie vielleicht!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

--- Has the Scoop Memo villager review the player's Scoop Memos, announcing new scoops, and returns nonzero when a reward can be claimed.
function palm_brinks_villagers.review_scoop_memos(window: s32)
	local npc_character: s32 = 0
	local player_character: s32 = 0
	local current_map: s32 = 0
	local memo_count: s32 = 0
	local collected_scoops: s32 = 0
	local total_scoops: s32 = 0
	local new_scoop_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		npc_character = event.get_triggered_event_data_2(13) or npc_character
		player_character = event.get_player_character_slot() or player_character
		current_map = event.get_current_map() or current_map
		memo_count = event.get_owned_item_count(355) or memo_count
		if memo_count <= 0 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Bring mir mal ein paar\nKn[UNI00fc]ller-Notizen, ja?")
			if current_map == 22 then
				resume_step = 1
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
			return 0
		end
		do
			local out1, out2 = event.get_menu_value_3(5)
			collected_scoops = out1 or collected_scoops
			total_scoops = out2 or total_scoops
		end
		if collected_scoops == total_scoops then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Sieht aus, als g[UNI00e4]be es\nkeine weiteren Kn[UNI00fc]ller mehr.")
			if current_map == 22 then
				resume_step = 3
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
			resume_step = 5
			return npc_chatter.explain_photography_scoops(window)
		end
		new_scoop_count = event.get_menu_value_2(3) or new_scoop_count
		if 0 < new_scoop_count then
			message.set_window_mode(window, 8)
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Ich hab noch [Number1] Kn[UNI00fc]ller\nherausgefunden.")
			event.set_message_draw_speed(window, 0)
			resume_step = 6
			message.show(window, -1, 8, 0, 0)
		end
		message.set_window_mode(window, 1)
		new_scoop_count = event.get_menu_value_2(4) or new_scoop_count
		if new_scoop_count <= 0 then
			event.open_message_window_2(
				window,
				"Komm schon, Mann! H[UNI00e4]ng nicht nur rum!\nWo bleiben deine neuen\nInsider-Kn[UNI00fc]ller?"
			)
		else
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Juhu! Du hast [Number1] neue(n) Kn[UNI00fc]ller!\nIch wusste, dass du's schaffst!")
		end
		if current_map == 22 then
			resume_step = 7
			message.say_bubble(window, -1, npc_character, player_character, 0)
		else
			resume_step = 8
			message.show(window, -1, 3, 256, 208)
		end
		resume_step = 9
		return npc_chatter.explain_photography_scoops(window)
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		if resume_step <= 9 then
			if resume_step <= 6 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, npc_character, player_character, 0)
			end
			if resume_step <= 7 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		return nil
	end)
end

--- Remarks on the player's trips out of town, or hands over to the girl's greeting when the playable character is the girl.
function palm_brinks_villagers.talk_about_leaving_town(character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Du warst au[UNI00df]erhalb der Stadt,\nstimmt's, Max?<page>Streite es nicht ab.\nIch wei[UNI00df], dass es stimmt."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the remark that Max is hardly ever seen since the player arrived.
function palm_brinks_villagers.talk_about_max_absence(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Seit du da bist, hab ich\nMax kaum gesehen.\nIch wei[UNI00df] nicht, was du vor hast -<page>ich hoffe, du benutzt\nihn nicht."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the aspiring chef's remark, with a different line in chapter 8.
function palm_brinks_villagers.talk_aspiring_chef(character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Hallo. Was f[UNI00fc]r Essen\nmagst du, Monica?")
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(0, "Ich mag nat[UNI00fc]rlich normales\nEssen, aber auch ungew[UNI00f6]hnliches.")
	else
		event.open_message_window_2(0, "Ich werde der beste Koch\nder Welt, und wenn's soweit ist,\nisst du immer gratis bei mir.")
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
end

--- Plays the baker's remark about the girl travelling with Max, with a different line in chapter 8.
function palm_brinks_villagers.talk_baker_about_max(character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Du bist das M[UNI00e4]dchen, das in\nletzter Zeit bei Max ist.<page>Ich erkenne einen guten\nMann, wenn ich ihn sehe."
		)
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(0, "Wenn ich etwas j[UNI00fc]nger w[UNI00e4]re,\nw[UNI00fc]rde ich ihn mir schnappen.")
	else
		event.open_message_window_2(0, "Wenn du Lust auf Brot hast,\nwei[UNI00df]t du ja, wo ich bin.")
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
end

--- Chooses the dialogue of the church candle puzzle giver from the progress of the main request chain and of request 13.
function palm_brinks_villagers.talk_candle_puzzle_giver(character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_prayer_for_peace(character, player_character, 0)
		return
	end
	request_status = event.get_quest_request_status(0, 13) or request_status
	if request_status == 0 then
		quest_dialogue.request_candle_puzzle(character, player_character)
		return
	end
	if request_status == 1 then
		party_recruit.recruit_partner(character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_world_peace(character, player_character)
		return
	end
end

--- Asks about discoveries and describes the villager's cooking experiments.
function palm_brinks_villagers.talk_cooking_experiments(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Na, was Gutes entdeckt?<page>W[UNI00e4]hrend du Maschinen und Ger[UNI00e4]te\nerfindest, erfinde ich\nneue Kochrezepte.<page>Ich versuche st[UNI00e4]ndig, Delikatessen\nzu schaffen, die noch\nnie jemand gegessen hat."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the shopkeeper's remark about the importance of customer trust.
function palm_brinks_villagers.talk_customer_trust(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Das Wichtigste in diesem Gesch[UNI00e4]ft\nist das Vertrauen der Kunden.<page>Das darf man nie\neinfach voraussetzen."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the old granny's remark, with a different line in chapter 8.
function palm_brinks_villagers.talk_old_granny(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Was n[UNI00fc]tzt dir eine\nalte Oma wie ich?")
	else
		event.open_message_window_2(
			0,
			'Wenn die Blackstone-Bahn fertig\nist, w[UNI00fc]rde ich gern mal\nzu den "Enden der Erde" fahren.'
		)
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Chooses the dialogue of the request 9 giver from the playable character, the character's position and the progress of request 9.
function palm_brinks_villagers.talk_request_9_giver(character: s32, player_character: s32)
	local playable_character: s32 = 0
	local request_status: s32 = 0
	local x: f32 = 0
	local z: f32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_agile_admirer_monica(character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_about_peaceful_town(character, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(character)
		x = out1 or x
		z = out3 or z
	end
	if x < 1182.0 or 1183.0 < x or z < 210.0 or 211.0 < z then
		print("kokokokokokokokokoko\n")
		npc_chatter.talk_busy_with_materials(character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 9) or request_status
	if request_status == 0 then
		npc_dialogue.explain_boat_run_test(character, player_character)
		return
	end
	if request_status == 1 then
		npc_dialogue.check_boat_run_time(character, player_character)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_agile_admirer(character, player_character)
		return
	end
end

--- Tells the player the shop is closed and points to the owner's father's shop.
function palm_brinks_villagers.talk_shop_closed(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Hier ist zu. Geh doch stattdessen\nzum Laden meines alten Herrn.<page>Achte auf die K[UNI00fc]rbisse. Du siehst\nsie bestimmt. Einfach die Leiter rauf."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Starts the conversation with a villager by dispatching on the villager's character type to that villager's own dialogue.
function palm_brinks_villagers.talk_to_npc(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	local npc_type: s32 = 0
	local current_submap: s32 = 0
	local state_flag: s32 = 0
	local shop_or_scoop_choice: any = 0
	local friend_or_scoop_choice: any = 0
	local request_0_status: s32 = 0
	local request_8_status: s32 = 0
	local greeting_choice: any = 0
	local request_0_status_2: s32 = 0
	local request_10_status: s32 = 0
	local greeting_choice_2: any = 0
	local request_0_status_3: s32 = 0
	local request_13_status: s32 = 0
	local greeting_choice_3: any = 0
	local request_8_status_2: s32 = 0
	local playable_character: s32 = 0
	local greeting_choice_4: any = 0
	event.apply_message_window_preset(0, 0)
	event.set_message_bubble_tail(0, 1)
	chapter = event.get_chapter() or chapter
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	event.get_current_map()
	current_submap = event.get_current_submap() or current_submap
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, npc_character)
	if npc_type == 3 then
		npc_dialogue.talk_to_gardener(npc_character, player_character)
	end
	if npc_type == 5 then
		npc_dialogue.talk_to_magical_artist(npc_character, player_character)
	end
	if npc_type == 4 then
		state_flag = event.get_save_flag(104) or state_flag
		if state_flag == 0 then
			event.open_message_window_2(0, "Lass mich einkaufen.\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			shop_or_scoop_choice = cutscene.ask_character_choice(npc_character, -1, 2, 0, 0, 0)
			if shop_or_scoop_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if shop_or_scoop_choice == 1 then
				if palm_brinks_villagers.review_scoop_memos(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc_character)
				return
			else
				palm_brinks_villagers.open_shop_after_greeting()
			end
		else
			event.open_message_window_2(0, "Sei mein Freund!\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			friend_or_scoop_choice = cutscene.ask_character_choice(npc_character, -1, 2, 0, 0, 0)
			if friend_or_scoop_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if friend_or_scoop_choice == 1 then
				if palm_brinks_villagers.review_scoop_memos(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc_character)
				return
			else
				quest_dialogue.talk_coin_collector(npc_character, player_character)
			end
		end
	end
	if npc_type == 7 then
		quest_dialogue.talk_candy_maker(npc_character, player_character)
	end
	if npc_type == 8 then
		villager_dialogue.talk_quest_4_villager(npc_character, player_character)
	end
	if npc_type == 10 then
		villager_dialogue.talk_quest_6_villager(npc_character, player_character)
	end
	if npc_type == 11 then
		npc_dialogue.talk_to_adel(npc_character, player_character)
	end
	if npc_type == 12 then
		request_0_status = event.get_quest_request_status(0, 0) or request_0_status
		request_8_status = event.get_quest_request_status(0, 8) or request_8_status
		if request_0_status == 2 and request_8_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Hallo.\nSei mein Freund!")
			greeting_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice == 1 then
				quest_dialogue.talk_baker(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 28 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			quest_dialogue.talk_baker(npc_character, player_character)
		end
	end
	if npc_type == 14 then
		palm_brinks_villagers.talk_request_9_giver(npc_character, player_character)
	end
	if npc_type == 15 then
		request_0_status_2 = event.get_quest_request_status(0, 0) or request_0_status_2
		request_10_status = event.get_quest_request_status(0, 10) or request_10_status
		if request_0_status_2 == 2 and request_10_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Hallo.\nSei mein Freund!")
			greeting_choice_2 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_2 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_2 == 1 then
				quest_dialogue.talk_swordsmith(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 30 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			quest_dialogue.talk_swordsmith(npc_character, player_character)
		end
	end
	if npc_type == 16 then
		firearms_partner.start_conversation(npc_character, player_character)
	end
	if npc_type == 17 then
		quest_dialogue.talk_mayor(npc_character, player_character)
	end
	if npc_type == 18 then
		request_0_status_3 = event.get_quest_request_status(0, 0) or request_0_status_3
		request_13_status = event.get_quest_request_status(0, 13) or request_13_status
		if request_0_status_3 == 2 and request_13_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Hallo.\nSei mein Freund!")
			greeting_choice_3 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_3 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_3 == 1 then
				palm_brinks_villagers.talk_candle_puzzle_giver(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 33 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			palm_brinks_villagers.talk_candle_puzzle_giver(npc_character, player_character)
		end
	end
	if npc_type == 19 then
		npc_dialogue.talk_to_moon_fan(npc_character, player_character)
	end
	if npc_type == 20 then
		quest_dialogue.talk_angler(npc_character, player_character)
	end
	if npc_type == 21 then
		npc_dialogue.talk_to_fisherman(npc_character, player_character)
	end
	if npc_type == 23 then
		npc_dialogue.talk_to_mena(npc_character, player_character)
	end
	if npc_type == 24 then
		villager_dialogue.talk_quest_18_villager(npc_character, player_character)
	end
	if npc_type == 25 then
		villager_dialogue.talk_quest_19_villager(npc_character, player_character)
	end
	if npc_type == 33 then
		request_8_status_2 = event.get_quest_request_status(0, 8) or request_8_status_2
		playable_character = event.get_playable_character() or playable_character
		if request_8_status_2 == 1 and playable_character == 0 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Lass mich einkaufen.\nHallo.")
			greeting_choice_4 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_4 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_4 == 1 then
				quest_dialogue.talk_bread_delivery_recipient(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		palm_brinks_villagers.open_shop_after_greeting()
	end
	if npc_type == 1 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"Ich hab in letzter Zeit Probleme,\ndie kleinen Teile zu sehen.<page>Ich werde wohl auch\nnicht j[UNI00fc]nger ..."
			)
		else
			event.open_message_window_2(
				0,
				"Need und ich tr[UNI00e4]umen davon, dass\ndie Blackstone-Bahn den ganzen\nKontinent bef[UNI00e4]hrt.<page>Du hilft uns doch, oder?"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 2 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "Wenn ich nicht immer\nwas zu tun habe,\nwerde ich unausstehlich.")
		else
			event.open_message_window_2(
				0,
				"Wenn sie Zelmit finden, bin ich\nauch besch[UNI00e4]ftigt. Dann w[UNI00fc]rde\nich buddeln, buddeln, buddeln!"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 6 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "Ich habe in letzter Zeit viel\nUngeziefer im Gefieder,\ndas juckt schrecklich.")
		else
			event.open_message_window_2(
				0,
				"Wenn du Zelmit suchen willst,\nmach das ruhig. Aber\n[UNI00fc]beranstrenge dich nicht, Kleiner."
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 13 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"Ich liebe Schwarzpulver-Duft!\nDas ist echt mein Traumjob.<page>Aber mein Boss ist ziemlich\nstur und altmodisch.\nAch, na ja."
			)
		else
			event.open_message_window_2(0, "Diese Abenteuer machen dir\neinen Riesenspa[UNI00df], was?")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 22 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"Abgesehen davon, dass ich als\nGem[UNI00e4]lde zur Welt kam, bin\nich genau wie alle anderen."
			)
		else
			event.open_message_window_2(0, "Ich hab ein dummes Gef[UNI00fc]hl bei der\nZelmit-Mine. Sei vorsichtig, ja?")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, npc_character)
end

--- Starts the ordinary villager conversation when the talked-to character type is outside the special 100 to 1000 range.
function palm_brinks_villagers.talk_to_ordinary_villager()
	local npc_type: s32 = 0
	npc_type = event.get_triggered_event_data_2(14) or npc_type
	if npc_type < 100 or 1000 < npc_type then
		npc_chatter.talk_to_villager()
	end
end

return palm_brinks_villagers
