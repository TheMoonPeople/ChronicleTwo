--!strict
--- Holds the German dialogue and events of the town residents who can join the party.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/german/npc_chatter")
local object = vm.module("@lib/event/object")
local palm_brinks_villagers = vm.module("@lib/event/german/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local quest_dialogue = vm.module("@lib/event/german/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/german/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local npc_dialogue = {}

--- Has the villager greet Max or Monica by name and ask to be taken along on trips outside town.
function npc_dialogue.ask_to_join_party(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "Ooh, Max! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	else
		event.open_message_window_2(0, "Ooh, Monica! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Das ist toll! Warum nimmst\ndu mich nicht mit?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Plays chatter about a new book and the Zelmite mine, depending on the chapter.
function npc_dialogue.chat_about_book(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Mein neues Buch?\nIch hab's noch nicht gelesen.<page>Es einfach nur zu haben\nmacht mich schon gl[UNI00fc]cklich."
		)
	else
		event.open_message_window_2(0, "Die Zelmit-Mine ist unheimlich.\nDort musst du immer\nwachsam bleiben.")
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays the moon photo fan's thanks and chatter about the Blackstone railroad, depending on the chapter.
function npc_dialogue.chat_about_moon_picture(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Du hast mir dieses Bild\ndes Mondes gegeben.\nDu bist ein guter Mensch.")
	else
		event.open_message_window_2(
			0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, k[UNI00f6]nnen wir\nlauter coole neue Orte besuchen."
		)
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays chatter complaining that the town is too peaceful.
function npc_dialogue.chat_about_peaceful_town(npc_slot: s32, player_slot: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Diese Stadt ist zu friedlich -\nich hab nichts zu tun.<page>Ich wei[UNI00df] nat[UNI00fc]rlich, dass das gut\nist, aber trotzdem ..."
	)
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays the prayer for world peace in chapter 8 and otherwise the remark that a good cause needs wisdom.
function npc_dialogue.chat_about_world_peace(npc_slot: s32, player_slot: s32)
	npc_dialogue.chat_prayer_for_peace(npc_slot, player_slot, 1)
end

--- Plays amazed praise for Max outside chapter 8 (deferring to a separate remark when Monica leads) and asks how the Zelmite hunt is going in chapter 8.
function npc_dialogue.chat_about_zelmite_hunt(npc_slot: s32, player_slot: s32)
	local chapter: s32 = 0
	local active_character: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		active_character = event.get_playable_character() or active_character
		if active_character == 1 then
			palm_brinks_villagers.talk_about_max_absence(npc_slot, player_slot)
			return
		end
		event.apply_message_window_preset(0, 0)
		event.open_message_window_2(
			0,
			"Ich fass es nicht. Ich habe nicht\ngedacht, dass du sie findest.<page>Das war echt gut, Max!"
		)
	else
		event.open_message_window_2(0, "He! Wie l[UNI00e4]uft die Zelmit-Suche?\nWenn ich helfen kann,\nsag einfach Bescheid.")
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Has the shopkeeper describe a shop that specialises in blades and carries few guns.
function npc_dialogue.chat_blade_shop(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Mein Laden ist spezialisiert\nauf Klingen.<page>Ich habe auch Schusswaffen,\naber eigentlich mag\nich sie nicht besonders."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager offer to go along or point to the bakery, depending on the chapter.
function npc_dialogue.chat_bread_offer(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Na komm, Max,\nbrechen wir auf.<page>Wo gehen wir\ndenn hin?")
	else
		event.open_message_window_2(0, "Wenn du Lust auf Brot hast,\nwei[UNI00df]t du ja, wo ich bin.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager promise help in return while asking not to be taken to places with insects, with a railroad remark in the final chapter.
function npc_dialogue.chat_bug_averse(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Du hast mir geholfen, dann\nhelfe ich dir auch - aber bitte\nschlepp mich nicht zu Insekten!"
		)
	else
		event.open_message_window_2(
			0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, muss\nich vielleicht auch mal hier raus."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager complain of feeling unwell although the doctor finds nothing wrong.
function npc_dialogue.chat_feeling_unwell(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Mir geht's nicht gut in\nletzter Zeit.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Dr. Dell war hier und hat mich\nuntersucht, aber er findet nichts.<page>Warum blo[UNI00df]?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Has the villager ask for the player's fishing tricks and look forward to new fishing spots, with a different line in the final chapter.
function npc_dialogue.chat_fishing_spots(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"[UNI00c4]hm, es muss ja nicht jetzt sein,\naber vielleicht verr[UNI00e4]tst du mir\neines Tages deine Angel-Tricks."
		)
	else
		event.open_message_window_2(
			0,
			"Ich bin schon ganz gespannt auf\ndie neuen Angelpl[UNI00e4]tze in der\nganzen Welt. Das wird so toll!"
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager remind the player to sort garbage, with a warning about Zelmite Mine in the final chapter.
function npc_dialogue.chat_garbage_sorting(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Und trenne immer sch[UNI00f6]n den\nM[UNI00fc]ll und denk an die M[UNI00fc]llabfuhr, ja?")
	else
		event.open_message_window_2(
			0,
			"Nur so zwischen dir und mir - die\nZelmit-Mine ist nicht ungef[UNI00e4]hrlich.\nMach keine Dummheiten."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager say they are hard of hearing and can only follow slow speech.
function npc_dialogue.chat_hard_of_hearing(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"...<page>Ah! Hallo!\nIch h[UNI00f6]re seit Kurzem schwer.<page>Ich verstehe dich nur, wenn\ndu ganz langsam sprichst."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager say hide-and-seek is for children and ask to hear about the player's adventures.
function npc_dialogue.chat_hide_and_seek(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Verstecken ist nur\nf[UNI00fc]r kleine Kinder.")
	else
		event.open_message_window_2(
			0,
			"Mir machst du nichts vor. Ich\nwei[UNI00df], dass du alle m[UNI00f6]glichen tollen\nSachen gemacht hast. Erz[UNI00e4]hl mal!"
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager advise the player to learn the basics of mining.
function npc_dialogue.chat_mining_advice(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Mit Maschinen kennst du dich\naus, aber willst du nicht langsam\nmal etwas [UNI00fc]ber Bergbau lernen?"
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager mutter number sequences while ignoring the player, then shows a hint to come back later.
function npc_dialogue.chat_muttering_numbers(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Grummel, grummel ...")
	message.wait_facing_character(npc_character)
	event.open_message_window_2(0, "... 1212,<page>Nein, nein, es war bestimmt 1122.<page>Oder vielleicht auch 1010.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Grummel, grummel ...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		'[(!)]Wenn er nicht einmal Notiz\n  von dir nimmt, wenn du "Hallo." sagst, hat er \n   wohl ernsthafte Probleme.<page>[(!)]Versuch\'s doch sp[UNI00e4]ter nochmal.\n   Vielleicht kannst du ihm zur\n   Hand gehen oder ein Ohr leihen.'
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has the villager pray for world peace or speak of wisdom, depending on the chapter and whether the villager's own request is completed.
function npc_dialogue.chat_prayer_for_peace(npc_character: s32, player_character: any, request_completed: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if request_completed ~= 0 and chapter == 8 then
		event.open_message_window_2(0, "Ich bete, dass die Welt ab\nheute ewigen Frieden genie[UNI00df]t.")
	else
		event.open_message_window_2(0, "Wer f[UNI00fc]r eine gute Sache k[UNI00e4]mpft,\nbraucht Weisheit.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager invite the player to bring any problem to them first.
function npc_dialogue.chat_problem_advice(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Wenn du Probleme hast,\nfrag ruhig immer mich.")
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the maid say she dreams of becoming a seamstress although dreams rarely come true.
function npc_dialogue.chat_seamstress_dream(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Zurzeit bin ich hier Magd,\naber seit meiner Kindheit tr[UNI00e4]ume\nich davon, Schneiderin zu werden."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Tr[UNI00e4]ume werden nie wahr,\ndeshalb nenne ich es einen Traum.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Checks the stopwatch time of the player's run to the boat and recruits the villager when it beats the record.
function npc_dialogue.check_boat_run_time(npc_character: s32, player_character: s32)
	local minutes: s32 = 0
	local seconds: s32 = 0
	local hundredths: s32 = 0
	local beat_record: s32 = 0
	local run_state: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		minutes = out1 or minutes
		seconds = out2 or seconds
		hundredths = out3 or hundredths
		beat_record = out4 or beat_record
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	run_state = event.get_save_counter(7) or run_state
	if run_state == 0 then
		event.open_message_window_2(0, "Hallo, Max.\nWillst du nochmal probieren?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if run_state == 1 then
		event.open_message_window_2(0, "He! Du warst nicht beim Boot,\noder? Du wolltest mich\ndrankriegen! Mogeln gilt nicht.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Versuchst du's noch mal?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "He, nicht mogeln!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Versuchst du's noch mal?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "Oh, da bist du ja wieder!\nGut,<page>sehen wir mal\nnach der Zeit!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, hundredths)
	if beat_record == 0 then
		event.open_message_window_2(0, "Oh Mann!\n[数値１] Min. [数値２] Sek. [数値３] ist\nzu langsam.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Versuchst du's noch mal?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "Oh!\n[数値１] Min. [数値２] Sek. [数値３]\nist keine schlechte Zeit!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Du bist schneller als du aussiehst.\nDann verm[UNI00f6]beln wir zusammen\ndie Fieslinge!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

--- The baker checks whether the bread delivery to Morton is done, trades the 20 loaves for 20 of another item and joins the party.
function npc_dialogue.complete_baker_request(npc_slot: s32, player_slot: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage < 3 then
		event.open_message_window_2(0, "Tut mir Leid, ich bin\nnoch nicht soweit.<page>Gibst du mir noch\netwas Zeit?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "[UNI00dc]brigens, warst du schon\nf[UNI00fc]r mich bei Morton?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Was! Wie kann er so\nr[UNI00fc]cksichtslos sein?<page>Na ja,\nnimm du sie.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Vergessen wir's,\nbrechen wir auf.<page>Und wo soll's\nhingehen?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

--- Greets Monica with the hair greeting when she leads, otherwise checks Max's flower photos, then praises them and joins the party or asks to see an unusual flower.
function npc_dialogue.complete_flower_photo_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local photo_count_2009: s32 = 0
	local photo_count_52: s32 = 0
	local photo_count_53: s32 = 0
	local photo_count_54: s32 = 0
	local photo_count_55: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	photo_count_2009 = event.get_photo_count_of_subject(2009) or photo_count_2009
	photo_count_52 = event.get_photo_count_of_subject(52, 3) or photo_count_52
	photo_count_53 = event.get_photo_count_of_subject(53, 3) or photo_count_53
	photo_count_54 = event.get_photo_count_of_subject(54, 3) or photo_count_54
	photo_count_55 = event.get_photo_count_of_subject(55, 3) or photo_count_55
	if vm.i32(vm.i32(vm.i32(vm.i32(photo_count_2009 + photo_count_52) + photo_count_53) + photo_count_54) + photo_count_55) <= 0 then
		event.open_message_window_2(
			0,
			"Hast du eine ungew[UNI00f6]hnliche\nBlume fotografiert?<page>Ich kenne viele Blumen - wenn's\nnichts Besonderes ist,\ninteressiert es mich nicht."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Hast du eine seltene Blume\nfotografiert? Zeig her, zeig her!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Wow - wie toll! So sehen also\ndie Blumen dort drau[UNI00df]en aus.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Hmm ... Was soll ich machen?<page>Oh, na gut! Nimm mich mit!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Gordon asks Max for Holy Water to fix the tree, joins the party, explains party and train management and completes request 0.
function npc_dialogue.complete_gordon_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local used_item: s32 = 0
	local npc_id: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_dialogue.hint_talk_to_gordon(npc_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Max, ich muss unbedingt diesem\nBaum helfen.<page>Na ja, und daf[UNI00fc]r brauche\nich ...")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_use_item_menu(276)
	vm.wait(4)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 276 then
		event.open_message_window_2(0, "Max, so klappt das nicht.<page>Ich brauche Weihwasser\nvon Priester Bruno.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ja - das ist es, Max! Jetzt\nkann ich den Baum versorgen!<page>Danke, Max.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Meine Arbeit ist vorerst\nerledigt.<page>Jetzt kann ich dich auf\ndeinem Abenteuer begleiten!<page>Oh, und sag deinem Vater\nnichts von dem Weihwasser, ja?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon reist jetzt mit.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		'[(!)]Seine Fertigkeiten verwendest\n   du [UNI00fc]ber den Statusbefehl unter\n   "Charakter" im Hauptmen[UNI00fc].<page>[(!)]Wenn du weitere Begleiter\n   gewinnst,\n   steigen diese in den Zug.'
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		'[(!)]Sprich jemand im Zug an,\n   um ihn oder sie als drittes\n   Gruppen-Mitglied zu aktivieren.<page>[(!)]Um einen deiner Begleiter in ein\n   Haus zu bewegen, w[UNI00e4]hle im T[UNI00fc]r-\n   Men[UNI00fc] des Hauses "Belegen".'
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Es gibt bestimmt noch\n   viele, die mit dir kommen wollen.\n   Halte Ausschau nach ihnen!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.set_npc_party_status(npc_id, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

--- Mena reports whether enough stages were cleared since request 17 began and joins the party once ten were cleared.
function npc_dialogue.complete_mena_request(npc_slot: s32, player_slot: s32)
	local current_clear_count: s32 = 0
	local start_clear_count: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		checkpoint = 1
		cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
		current_clear_count = event.get_menu_value_2(0) or current_clear_count
		start_clear_count = event.get_save_counter(19) or start_clear_count
		print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", vm.i32(current_clear_count - start_clear_count), "\n")
		if vm.i32(current_clear_count - start_clear_count) < 10 then
			event.open_message_window_2(0, "Mir geht's immer noch\nschlecht.")
			checkpoint = 2
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.open_message_window_2(
				0,
				"Vielleicht habe ich etwas\nganz Schlimmes?<page>Vielleicht kann selbst Dr. Dell\nmir jetzt nicht mehr helfen ..."
			)
			checkpoint = 3
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.set_character_motion(npc_slot, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Hallo!<page>Wie es mir geht? Super!")
		checkpoint = 4
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Ich kann kaum glauben, wie gut\nes mir in letzter Zeit geht.<page>Jetzt scheint die Welt\nwieder in Ordnung zu sein."
		)
		checkpoint = 5
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Oh ja, du wolltest etwas von mir.<page>Wenn ich helfen kann, tu ich's gern.<page>Du hast mir geholfen,\ndann helfe ich dir auch."
		)
		checkpoint = 6
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		checkpoint = 7
		party.add_talked_npc()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", current_clear_count - start_clear_count, "\n")
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 2 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			return 0
		end
		if checkpoint <= 7 then
			if checkpoint <= 4 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 5 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 6 then
				party.announce_new_member_alt_default()
			end
			return 0
		end
		return nil
	end)
end

--- Parn takes the Golden Paint from Max, joins the party and completes request 1.
function npc_dialogue.complete_parn_request(npc_slot: s32, player_slot: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Ich hab dich erwartet.<page>Schnell, gib mir die Farbe,\ndann kann ich das Bild beleben.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 376 then
		event.open_message_window_2(0, "Du machst Witze!<page>Ich brauche goldene Farbe.\nUnd nichts anderes!")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "Das ist die goldene Farbe ...\nIch probiere sie sofort aus.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "S ... sie ... sie lebt ...<page>Unglaublich, sie ist perfekt!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Danke, Max.\nIch halte mein Versprechen. Nutze\nmeine neue Kraft, wann du willst.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.set_npc_party_status(22, 130)
	party.announce_member_joined(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

--- Walks through the safe's secret code puzzle, tests the code Max enters and joins the party once the safe opens.
function npc_dialogue.complete_safe_code_request(npc_slot: s32, player_slot: s32)
	local selection: any = 0
	local code_result: s32 = 0
	local unlock_sound_id: s32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation_x: f32 = 0
	local npc_rotation_y: f32 = 0
	local npc_rotation_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_y: f32 = 0
	local player_rotation_z: f32 = 0
	local angle_toward_safe: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	while true do
		event.open_message_window_2(0, "Ich habe ihr mal eine Brosche\nmit ihrem Sternzeichen geschenkt.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Holly hat sie ausgesucht, deshalb\nwei[UNI00df] ich's nicht mehr genau,\naber es war ein<page>vierbeiniges Tier ..."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Was f[UNI00fc]r Geburtstagsgeschenke\nhabe ich ihr gemacht?<page>Hmm ... Viele M[UNI00e4]ntel und\nSchals, glaube ich.<page>Ich wei[UNI00df] nie, was ich nehmen\nsoll. Es ist jedes Jahr schwierig."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Oh ja! An Claires Geburtstag wird\nimmer der M[UNI00fc]ll abgeholt - sowohl\nBiom[UNI00fc]ll als auch Restm[UNI00fc]ll.<page>Und meine Aufgabe ist\nes, den M[UNI00fc]ll rauszubringen."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Restm[UNI00fc]ll wird an Tagen geholt,\ndie durch 7 teilbar sind,<page>Biom[UNI00fc]ll an Tagen, die\ndurch 3 teilbar sind."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Aber so etwas vergisst\nman doch nicht, oder?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.open_message_window_2(
			0,
			"Ich hab's! Des R[UNI00e4]tsels L[UNI00f6]sung!\nDie Kombination hei[UNI00df]t ...<page>Ich wei[UNI00df] nicht ...\n Lauschen wir noch etwas."
		)
		selection = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		if selection == 0 then
			break
		else
			if selection == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(npc_slot, "会話")
		end
	end
	event.set_menu_value(0, "Gib den Geheim-Code ein.", "2112", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		code_result = out1 or code_result
	end
	if code_result == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait.frames(15)
	unlock_sound_id = event.get_sound_id(2) or unlock_sound_id
	do
		local out1, out2, out3 = event.get_character_position(npc_slot)
		npc_x = out1 or npc_x
		npc_y = out2 or npc_y
		npc_z = out3 or npc_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(npc_slot)
		npc_rotation_x = out1 or npc_rotation_x
		npc_rotation_y = out2 or npc_rotation_y
		npc_rotation_z = out3 or npc_rotation_z
	end
	event.set_character_position(npc_slot, -100.0, 0.0, -110.0)
	event.set_character_rotation(npc_slot, 0.0, 3.1415927, 0.0)
	event.set_character_motion(npc_slot, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		player_rotation_x = out1 or player_rotation_x
		player_rotation_y = out2 or player_rotation_y
		player_rotation_z = out3 or player_rotation_z
	end
	angle_toward_safe = event.get_arc_tangent(-100.0 - player_x, -110.0 - player_z) or angle_toward_safe
	event.set_character_rotation(0, 0.0, angle_toward_safe, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait.frames(30)
	if code_result == 0 then
		event.set_character_motion(npc_slot, "会話")
		event.open_message_window_2(0, "Hmm, es geht nicht auf ...<page>Au weia - da sind wirklich\nwichtige Dokumente drin ...")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.fade_out_screen(15)
		wait.frames(15)
		event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
		event.set_character_position(npc_slot, npc_x, npc_y, npc_z)
		event.set_character_rotation(npc_slot, npc_rotation_x, npc_rotation_y, npc_rotation_z)
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(0, "[UNI00c4]h ... hmm ...\n2,<page>1,<page>1,<page>2 ...")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "Juhuu!<page>Toll,\nes funktioniert!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.attach_object_handle_to_character(0, npc_slot)
	event.clear_object_sequence(0, npc_slot)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, player_x, player_y, player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(0, "Super! Jetzt komme ich an meine\nwichtigen Dokumente heran!<page>Oh, vielen Dank!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.fade_out_screen(15)
	wait.frames(15)
	event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
	event.set_character_position(npc_slot, npc_x, npc_y, npc_z)
	event.set_character_rotation(npc_slot, npc_rotation_x, npc_rotation_y, npc_rotation_z)
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.fade_in_screen(15)
	wait.frames(15)
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(
		0,
		"Was das f[UNI00fc]r Dokumente sind?<page>Mit ihnen soll mein Stellvertreter\nMorton arbeiten, w[UNI00e4]hrend ich weg bin.<page>Nat[UNI00fc]rlich ist es unangenehm,\naber es wird bestimmt klappen."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Gut, dann bin ich bereit\naufzubrechen.<page>Cedric hat mir alles erz[UNI00e4]hlt.<page>Na komm schon, auf geht's."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

--- Takes sturdy cloth, thick hide and a copper lump from the player so the seamstress can start making clothes, then removes her from the scene.
function npc_dialogue.deliver_tailoring_materials(npc_character: s32, player_character: s32)
	local sturdy_cloth_count: s32 = 0
	local thick_hide_count: s32 = 0
	local copper_lump_count: s32 = 0
	local answer: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	sturdy_cloth_count = event.get_item_count(214) or sturdy_cloth_count
	thick_hide_count = event.get_item_count(245) or thick_hide_count
	copper_lump_count = event.get_item_count(227) or copper_lump_count
	if sturdy_cloth_count <= 0 or thick_hide_count <= 0 or copper_lump_count <= 0 then
		event.open_message_window_2(
			0,
			"Ohne Materialien\nkann ich nichts n[UNI00e4]hen.<page>Ich brauche starken Stoff,\nTierhaut und einen Kupferklumpen.<page>Tut mir Leid, dass\nich so anstrengend bin."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Hier, nimm die!\nIch halt's trotzdem f[UNI00fc]r\nVerschwendung.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Ohne Materialien\nkann ich nichts n[UNI00e4]hen.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(214)
	event.remove_item(245)
	event.remove_item(227)
	event.set_save_counter(8, 2)
	event.open_message_window_2(0, "Vielen Dank! Jetzt\nversuche ich etwas zu n[UNI00e4]hen!<page>Das lasse ich nicht verkommen.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, npc_character)
	event.set_character_active(0, npc_character)
	event.delete_villager(npc_character)
	event.finish_event()
	event.fade_in_screen(30)
end

--- Has the villager explain the speed test of running to the boat and back, then offers an attempt.
function npc_dialogue.explain_boat_run_test(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "He, Max, suchst du mich?<page>Ich hab auf dich gewartet.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Die Burgmauer sch[UNI00fc]tzt diese\nStadt recht gut.<page>Wir m[UNI00fc]ssen jetzt rausgehen.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Es ist gut, dass du immer\nan Maschinen bastelst,\naber wie stark bist du wohl?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Beim K[UNI00e4]mpfen geht's um\nSchnelligkeit und Beinarbeit.<page>Wenn du langsamer bist als\nich, bringt es nichts."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Machen wir einen kleinen Test.\nLauf zum Boot am See und zur[UNI00fc]ck.<page>Mein Rekord ist 2 Min., 1 Sek.\nWenn du langsamer bist,\nbringt es nichts."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 9, 1)
	event.open_message_window_2(0, "Wie w[UNI00e4]r's, probierst du's mal?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	npc_dialogue.offer_boat_run(npc_character, player_character)
end

--- Has the moon-loving villager say a moon must exist where the player goes and explain that a photo of the moon would convince him.
function npc_dialogue.explain_moon_photo_condition(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Ja, ich komme gern mit -\naber gibt's dort auch einen Mond?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ach ja? Vielleicht sagst du das nur.\nIch wei[UNI00df], dass Menschen oft l[UNI00fc]gen.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Nein, ich hab's mir anders\n[UNI00fc]berlegt. Ich warte hier, bis der Mond kommt.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Vielleicht ist ihm fr[UNI00fc]her\n   etwas passiert - Rufio\n   vertraut Menschen offenbar nicht."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Du musst Rufios Vertrauen\n   gewinnen. Vielleicht w[UNI00fc]rde\n   ein Foto des Mondes reichen."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Greets Monica as Max's girlfriend and compliments her hair.
function npc_dialogue.greet_monica_about_hair(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Hi! Bist du Max'\nFreundin?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Deine Haarfarbe ist ungew[UNI00f6]hnlich.\nWie Eriks, nur anders ...<page>Deine Haare sind sch[UNI00f6]n,\nso wie Juwelen."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.finish_event()
end

--- Plays the remark about the ailing tree and the hint that Monica must talk to Gordon to get his attention.
function npc_dialogue.hint_talk_to_gordon(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_slot, "立ち")
	event.open_message_window_2(0, "Hmm, dieser Baum ... sieht nicht\ngut aus. Ich muss etwas tun.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Gordon musst du offenbar\n   ansprechen, sonst merkt er nichts.")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

--- Asks whether the player wants to try the boat run and starts the stopwatch when accepted.
function npc_dialogue.offer_boat_run(npc_character: s32, player_character: s32)
	local answer: any = 0
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Klar, ich versuch's.\nIch pack's nicht.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Na gut ...<page>Gut, wenn du's wieder probieren\nwillst, sag Bescheid. Ich warte.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(7, 0)
		return
	end
	event.open_message_window_2(0, "Auf die Pl[UNI00e4]tze, fertig,\nlos!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.control_stopwatch(3, 32, 364, 0)
	event.control_stopwatch_1(0)
	event.set_save_counter(7, 1)
end

--- Checks whether the player has won the fish race and recruits the fish keeper if so.
function npc_dialogue.recruit_after_fish_race(npc_character: s32, player_character: s32)
	local story_flag: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	story_flag = event.get_save_flag(41) or story_flag
	if story_flag == 0 then
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

--- Counts how often the hiding villager is found and recruits the villager once the game of hide-and-seek is over.
function npc_dialogue.recruit_after_hide_and_seek(npc_character: s32, player_character: s32)
	local times_found: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	times_found = event.get_save_counter(11) or times_found
	if times_found < 1 then
		event.open_message_window_2(0, "Oh! Du hast mich!<page>Aber findest du mich noch mal?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(11, times_found + 1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, npc_character)
		event.set_character_active(0, npc_character)
		event.delete_villager(npc_character)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Du hast mich ...<page>Ich hab keine Lust mehr.<page>Verstecken ist eigentlich\ntotal langweilig.<page>Na gut! Dann ziehen wir in\nunser Abenteuer!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

--- The hard-of-hearing grandmother starts request 19, asks Max to enter "Let's go together." and joins the party when he does.
function npc_dialogue.recruit_grandmother(npc_slot: s32, player_slot: s32)
	npc_dialogue.recruit_hard_of_hearing_woman(npc_slot, player_slot)
end

--- Asks the hard-of-hearing old woman to join through a "go together" menu choice and recruits her on the right answer.
function npc_dialogue.recruit_hard_of_hearing_woman(npc_character: s32, player_character: s32)
	local menu_selection: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Wie bitte?<page>Kannst du nicht langsamer reden?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Bitte gib ein:"Komm mit mir." ', "Komm mit mir.", 0)
	event.open_event_menu(5)
	vm.wait(3)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		menu_selection = out1 or menu_selection
	end
	if menu_selection == -1 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if menu_selection == 0 then
		event.open_message_window_2(0, "Was redest du da?\nIch verstehe nichts ...")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ein Abenteuer?\nDas w[UNI00e4]re sch[UNI00f6]n.<page>Aber was n[UNI00fc]tzt dir da\neine alte Frau wie ich?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

--- Asks the player to hand over a chestnut and recruits the villager when the right item is used.
function npc_dialogue.recruit_with_chestnut(npc_character: s32, player_character: s32)
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

--- Checks whether the player has photographed the moon and, if so, recruits the moon-loving villager into the party.
function npc_dialogue.recruit_with_moon_photo(npc_character: s32, player_character: s32)
	local moon_photo_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	moon_photo_count = event.get_photo_count_of_subject(193) or moon_photo_count
	if moon_photo_count <= 0 then
		event.open_message_window_2(
			0,
			"Ich dachte, du w[UNI00e4]rst vielleicht\nanders, aber Menschen sind\neben Menschen.<page>Egal. Ich bin's gewohnt,\ndass ihr Menschen immer l[UNI00fc]gt."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Wow, wie toll! Auf dem Foto ist\nein Mond.<page>Jetzt kann ich ihn immer\nund [UNI00fc]berall ansehen."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Mitkommen?<page>Klar komm ich mit.\nIch hab sonst nichts\nzu tun.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

--- Checks the length of the player's caught Nonky and recruits the fisherman if it is long enough.
function npc_dialogue.recruit_with_nonky_catch(npc_character: s32, player_character: s32)
	local fish_length: f32 = 0
	local length_centimeters: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	fish_length = vm.bits_float(event.get_menu_value(2, 322)) or fish_length
	if fish_length <= 0 then
		event.open_message_window_2(
			0,
			"Hey, wetten, dass du noch nie\neinen Nonky gefangen hast?<page>Ha ha. Du musst ein ganz\nmieser Angler sein!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if fish_length < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(fish_length * 100.0))
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

--- Asks for the Dark Coin and the Indestructible Coin, takes them after confirmation and recruits the coin collector.
function npc_dialogue.recruit_with_rare_coins(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local dark_coin_count: s32 = 0
	local indestructible_coin_count: s32 = 0
	local answer: any = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	dark_coin_count = event.get_item_count(201) or dark_coin_count
	indestructible_coin_count = event.get_item_count(202) or indestructible_coin_count
	if dark_coin_count <= 0 or indestructible_coin_count <= 0 then
		event.open_message_window_2(
			0,
			"Wie? Ah, M[UNI00fc]nzen sammeln?<page>Ich suche die Dunkle M[UNI00fc]nze\nund die Panzer-M[UNI00fc]nze.<page>Die findest du nie. Ich hab [UNI00fc]berall\nnach ihnen gesucht - aber umsonst."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Wie? Du hast sie? Unglaublich!<page>Steh nicht rum!\nGib her, gib her, gib her!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Gut.\nWas soll ich tun?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Ahh! Wenn du mich\nver[UNI00e4]ppelst, helfe ich dir nie.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"Wow, ich hab sie alle!\nIch dachte, das w[UNI00e4]re unm[UNI00f6]glich ...<page>Tja, dann hab ich wohl keine Wahl.\nIch muss mitkommen!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

--- Has a fearful villager refuse to fight, ask Max for a flower photo and start the photo request, while Monica takes the alternate dialogue.
function npc_dialogue.request_flower_photo(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Ich w[UNI00fc]rde ja gern helfen, aber\nK[UNI00e4]mpfe sind gef[UNI00e4]hrlich\nund man wird schmutzig."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Und ich m[UNI00f6]chte niemand nerven.\nTut mir Leid, ich muss passen.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber es muss viel Interessantes\nau[UNI00df]erhalb der Stadt geben.<page>Ich frag mich, wie die B[UNI00e4]ume\naussehen und was f[UNI00fc]r Blumen es gibt."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Wenn du eine interessante Blume\nsiehst, machst du mir ein Foto?\nIch m[UNI00f6]chte sie so gern sehen."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Diesmal hat sie abgelehnt, aber wenn\n   du ihr ein Foto zeigst, das sie\n   interessiert, gibt sie wohl nach."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Has the magical artist introduce his painted fiancee and ask the player to bring Golden Paint, or says the player should try as Max when Monica talks.
function npc_dialogue.request_golden_paint(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
		event.open_message_window_2(0, "Hallo.\nDu bist Monica, stimmt's?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Ich bin Parn.\nIch bin Zaubermaler.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Ich hab euch noch nicht\nvorgestellt, oder?<page>Das ist Julia, meine Zuk[UNI00fc]nftige.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(0, " ...")
		message.say_bubble(0, -1, player_character, npc_character, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Monica ist in solchen Situationen\n   unbeholfen. Wahrscheinlich schafft\n   sie das nicht. Versuch's als Max."
		)
		message.show(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Hallo, Max.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ich hab euch noch nicht\nvorgestellt, oder?<page>Das ist Julia, meine Zuk[UNI00fc]nftige.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, " ...")
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(
		0,
		"Ja, lach du nur.\nEs klingt ja auch komisch!<page>Wer verliebt sich schon\nin eine gemalte Frau?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber ich bin Zaubermaler.\nWas ich zeichne, wird Wirklichkeit.<page>Was ich male, existiert im Bild\ntats[UNI00e4]chlich. Solange es nichts\nLebendiges ist ..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Selbst Zaubermaler k[UNI00f6]nnen nichts\nLebendiges erschaffen.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber es gibt eine M[UNI00f6]glichkeit.\nAuf einem gro[UNI00df]en alten Baum liegt\nein Goldenes Ei."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Angeblich kann man mit seiner\ngoldenen Farbe alles Gezeichnete\nzum Leben erwecken.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Max, du verl[UNI00e4]sst die\nStadt, nicht wahr?<page>Kannst du mir wohl goldene\nFarbe mitbringen?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Du bekommst nat[UNI00fc]rlich etwas daf[UNI00fc]r.<page>Wenn du mir hilfst, helfe\nich dir mit meiner neuen Kraft."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Ein gro[UNI00df]er alter Baum ...\n   mit einem Goldenen Ei! Wo k[UNI00f6]nnte\n   so ein Baum blo[UNI00df] stehen?"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

--- Has the coin collector refuse to help without payment and ask for the Dark Coin and the Indestructible Coin, or says the player should try as Max when Monica talks.
function npc_dialogue.request_rare_coins(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Du kennst die Antwort doch:\nN-I-E-M-A-L-S!<page>Warum sollte ich f[UNI00fc]r andere\nLeute arbeiten?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Es springt nichts f[UNI00fc]r mich\nheraus und es ist gef[UNI00e4]hrlich.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Aber weil du's bist, denk ich\nmal dr[UNI00fc]ber nach.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Andererseits bin ich ein H[UNI00e4]ndler-\nsohn - wir verschenken nichts.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Du wei[UNI00df]t ja, dass ich\nM[UNI00fc]nzen sammle.<page>Sie sind Symbole des Handels.\nIch h[UNI00e4]tte so gern alle."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Aber ich komme einfach nicht\nan die Dunkle M[UNI00fc]nze\nund die Panzer-M[UNI00fc]nze ran.<page>Wenn du mir hilfst, helfe\nich dir vielleicht auch."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 2, 1)
end

--- Adel explains she has lost her confidence, a hint says to get her sewing again, and request 7 starts.
function npc_dialogue.start_adel_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"Aha ... Ich w[UNI00fc]rde dir sehr\ngern helfen. Mehr\nals gern sogar.<page>Aber ich habe einfach\nkein Selbstvertrauen."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Ich gebe immer auf halbem Weg\nauf - ich hab noch nie etwas\nzu Ende gebracht.<page>Als Kind wollte ich Schneiderin\nwerden und habe viel ausprobiert,\naber ich habe nie was fertig gen[UNI00e4]ht."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Wenn ich mitk[UNI00e4]me, w[UNI00e4]re ich\nbestimmt nur im Weg.<page>Tut mir Leid, aber - nein."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh Mann, Adel hat gar kein\n   Selbstvertrauen. Das ist nicht\n   gut. Bring sie wieder zum N[UNI00e4]hen."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- The baker agrees to join once Max delivers 20 loaves of bread to Morton, hands over the bread and starts request 8.
function npc_dialogue.start_baker_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"Du willst, dass ich\nmitkomme?<page>Ich bin nur eine B[UNI00e4]ckerin,\naber wenn du mich brauchst,\nhelfe ich gern."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Oh, aber zuerst habe ich eine\nLieferung f[UNI00fc]r Morton.<page>K[UNI00f6]nntest du diese 20 Brotlaibe\nf[UNI00fc]r mich zu Mortons Laden bringen?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "W[UNI00e4]hrend du das erledigst,\npacke ich f[UNI00fc]r die Reise.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.add_inventory_item(300, 20)
	inventory.announce_received(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "Was um alles in der\nWelt will er mit 20 Laiben?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- Gerald hands Max a Trumpet Gun, asks him to build it up into a Bell Trigger and starts request 11.
function npc_dialogue.start_gerald_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Cedric sagt, du w[UNI00e4]rst in\nletzter Zeit viel\nunterwegs gewesen.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Du kannst vieles gut,<page>aber andererseits bringst du\nnie etwas zu Ende.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Deshalb f[UNI00e4]llt es mir schwer,\ndich einfach ernst zu nehmen,\nwenn du mich um Hilfe bittest."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Ich hab's - stufe dieses\nTrompeten-Gewehr zu einem\nKlingel-Abzug hoch!<page>Schaffst du das?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.add_inventory_item(24)
	inventory.announce_received(24, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Damit Gerald dich akzeptiert,\n   musst du ihm einen\n   Klingel-Abzug bringen.<page>[(!)]Du kannst seine Waffe\n   hochstufen, eine andere kaufen\n   oder eine aus dem Verlies holen."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

--- Mena describes her dizziness; when Monica leads she recognises it as an effect of time distortions, a hint explains how to fix them, and request 17 starts with the current clear count saved.
function npc_dialogue.start_mena_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local clear_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"Mir geht's in letzter Zeit nicht gut.<page>Eine Reise schaffe ich nicht.<page>Dr. Dell war hier und hat mich\nuntersucht, aber er findet nichts."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Aber selbst wenn ich nur stehe,\ndenke ich, ich kippe gleich um.<page>Es ist schwer zu erkl[UNI00e4]ren. Als\nob die Welt verzerrt w[UNI00e4]re."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(
			0,
			"Hmmm ...\nWenn Dr. Dell nicht wei[UNI00df], was los\nist, kann ich auch nichts weiter tun ..."
		)
		message.say_bubble(0, -1, player_slot, npc_slot, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ich erkenne die Symptome.")
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"In der Zeit, in der ich geboren\nwurde, ging es der Welt schlecht -\nes gab mehr Zeitverzerrungen\nals du dir vorstellen kannst."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Das wirkte sich auf schwache\nund gebrechliche Menschen aus.<page>Leichten Menschen wurde schwindlig,\nund schwere konnten\neinfach nicht mehr stehen."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Vielleicht bist du besonders\nempfindlich f[UNI00fc]r so etwas.<page>Selbst die wenigen Zeit-\nverzerrungen hier wirken auf dich."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(0, "Wenn wir einige der nahe\ngelegenen Verzerrungen beseitigen,\ngeht's dir vielleicht besser.")
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.set_character_motion(player_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Zeitverzerrungen beheben ... Spheda!\n   Wenn du etwa 10 Runden schaffst,\n   geht es Mina vielleicht besser."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	clear_count = event.get_menu_value_2(0) or clear_count
	event.set_save_counter(19, clear_count)
	event.set_quest_request(0, 17, 1)
end

--- Routes Adel's conversation by whether Monica leads, the status of requests 0 and 7 and the tailoring progress.
function npc_dialogue.talk_to_adel(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	local tailoring_progress: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_chatter.talk_tailor_monica(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_seamstress_dream(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 7) or request_status
	if request_status == 0 then
		npc_dialogue.start_adel_request(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		tailoring_progress = event.get_save_counter(8) or tailoring_progress
		if tailoring_progress == 0 then
			quest_dialogue.request_tailor_materials(npc_slot, player_slot)
		end
		if tailoring_progress == 1 then
			npc_dialogue.deliver_tailoring_materials(npc_slot, player_slot)
		end
		if tailoring_progress == 2 then
			quest_dialogue.receive_tailor_garment(npc_slot, player_slot)
		end
		return
	end
	if request_status == 2 then
		villager_dialogue.pray_for_safety(npc_slot, player_slot)
		return
	end
end

--- Routes the fisherman's conversation by request 0 and 16 status and a story flag.
function npc_dialogue.talk_to_fisherman(npc_slot: s32, player_slot: s32)
	local request_status: s32 = 0
	local story_flag: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	story_flag = event.get_save_flag(424) or story_flag
	if request_status ~= 2 or story_flag == 0 then
		palm_brinks_villagers.explain_firbit_favours(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 16) or request_status
	if request_status == 0 then
		palm_brinks_villagers.request_win_fish_race(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.recruit_after_fish_race(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		villager_dialogue.talk_about_fabio(npc_slot, player_slot)
		return
	end
end

--- Chooses the gardener's dialogue from the story flag and the state of his quest request.
function npc_dialogue.talk_to_gardener(npc_character: s32, player_character: s32)
	local story_flag: s32 = 0
	local quest_status: s32 = 0
	story_flag = event.get_save_flag(42) or story_flag
	if story_flag == 0 then
		npc_chatter.talk_tree_gardener(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status == 0 then
		villager_dialogue.start_gordon_quest(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_gordon_request(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_holy_water_keeper(npc_character, player_character)
		return
	end
end

--- Chooses the magical artist's dialogue from the state of the main request and his own quest request.
function npc_dialogue.talk_to_magical_artist(npc_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.talk_to_parn(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 1) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_golden_paint(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_parn_request(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_painter_done(npc_character, player_character)
		return
	end
end

--- Routes Mena's conversation by story flag and the status of request 17.
function npc_dialogue.talk_to_mena(npc_slot: s32, player_slot: s32)
	local story_flag: s32 = 0
	local request_status: s32 = 0
	story_flag = event.get_save_flag(314) or story_flag
	if story_flag == 0 then
		npc_dialogue.chat_feeling_unwell(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 17) or request_status
	if request_status == 0 then
		npc_dialogue.start_mena_request(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.complete_mena_request(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_bug_averse(npc_slot, player_slot)
		return
	end
end

--- Routes the moon photo fan's conversation by request 0 and 14 status.
function npc_dialogue.talk_to_moon_fan(npc_slot: s32, player_slot: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		villager_dialogue.talk_about_moon(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 14) or request_status
	if request_status == 0 then
		npc_dialogue.explain_moon_photo_condition(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.recruit_with_moon_photo(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_moon_picture(npc_slot, player_slot)
		return
	end
end

--- Parn introduces himself to Monica or greets Max.
function npc_dialogue.talk_to_parn(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
		event.open_message_window_2(0, "Hallo.\nDu bist Monica, stimmt's?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Ich bin Parn.\nIch bin Zaubermaler.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hey, Max.<page>Warum siehst du immer\nso gesund aus?")
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

return npc_dialogue
