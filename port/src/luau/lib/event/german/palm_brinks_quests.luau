--!strict
--- German recruitment and request conversations of Palm Brinks NPCs.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/german/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/german/palm_brinks_villagers")
local villager_recruitment = vm.module("@lib/event/german/villager_recruitment")

local palm_brinks_quests = {}

--- Reads the stopwatch for the boat race and has the NPC join the party if the time is fast enough.
function palm_brinks_quests.check_boat_race_time(npc: s32, player: s32)
	local minutes: s32 = 0
	local seconds: s32 = 0
	local seconds_fraction: s32 = 0
	local is_fast_enough: s32 = 0
	local race_state: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		minutes = out1 or minutes
		seconds = out2 or seconds
		seconds_fraction = out3 or seconds_fraction
		is_fast_enough = out4 or is_fast_enough
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	race_state = event.get_save_counter(7) or race_state
	if race_state == 0 then
		event.open_message_window_2(0, "Hallo, Max.\nWillst du nochmal probieren?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if race_state == 1 then
		event.open_message_window_2(0, "He! Du warst nicht beim Boot,\noder? Du wolltest mich\ndrankriegen! Mogeln gilt nicht.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Versuchst du's noch mal?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "He, nicht mogeln!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Versuchst du's noch mal?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "Oh, da bist du ja wieder!\nGut,<page>sehen wir mal\nnach der Zeit!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, seconds_fraction)
	if is_fast_enough == 0 then
		event.open_message_window_2(0, "Oh Mann!\n[数値１] Min. [数値２] Sek. [数値３] ist\nzu langsam.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Versuchst du's noch mal?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "Oh!\n[数値１] Min. [数値２] Sek. [数値３]\nist keine schlechte Zeit!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Du bist schneller als du aussiehst.\nDann verm[UNI00f6]beln wir zusammen\ndie Fieslinge!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

--- Has the flower expert check the player has photographed any unusual flower and, if so, join the party.
function palm_brinks_quests.check_flower_photos(npc: s32, player: s32)
	local playable_character: s32 = 0
	local photo_count_2009: s32 = 0
	local photo_count_52: s32 = 0
	local photo_count_53: s32 = 0
	local photo_count_54: s32 = 0
	local photo_count_55: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc, player)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
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
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Hast du eine seltene Blume\nfotografiert? Zeig her, zeig her!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Wow - wie toll! So sehen also\ndie Blumen dort drau[UNI00df]en aus.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Hmm ... Was soll ich machen?<page>Oh, na gut! Nimm mich mit!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Has the fisherman challenge the player to catch a Nonky over 60cm and starts the fishing request.
function palm_brinks_quests.explain_fish_challenge(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Ich soll dir einen Gefallen tun?<page>Warte - h[UNI00f6]r mich erst an.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Ich rede nur mit Leuten, die\nich respektiere.<page>Und ich respektiere nur Leute,\ndie gr[UNI00f6][UNI00df]ere Fische geangelt\nhaben als ich."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Mein gr[UNI00f6][UNI00df]ter Fang war\nein 60-cm-Nonky.<page>Bist du beeindruckt?\nWenn du gegen mich antreten\nm[UNI00f6]chtest, bin ich immer bereit!"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Um ihn zu [UNI00fc]berzeugen, musst\n   du wohl einen Nonky fangen, der\n   l[UNI00e4]nger ist als 60 cm. Du schaffst es!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Versuch doch mal, im\n   See von Palm Brinks zu angeln.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Has Mena describe her dizziness and, for Monica, explain time distortions, record the cleared-stage count and start the distortion request.
function palm_brinks_quests.explain_time_distortions(npc: s32, player: s32)
	local playable_character: s32 = 0
	local cleared_stage_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"Mir geht's in letzter Zeit nicht gut.<page>Eine Reise schaffe ich nicht.<page>Dr. Dell war hier und hat mich\nuntersucht, aber er findet nichts."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Aber selbst wenn ich nur stehe,\ndenke ich, ich kippe gleich um.<page>Es ist schwer zu erkl[UNI00e4]ren. Als\nob die Welt verzerrt w[UNI00e4]re."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(
			0,
			"Hmmm ...\nWenn Dr. Dell nicht wei[UNI00df], was los\nist, kann ich auch nichts weiter tun ..."
		)
		message.say_bubble(0, -1, player, npc, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ich erkenne die Symptome.")
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"In der Zeit, in der ich geboren\nwurde, ging es der Welt schlecht -\nes gab mehr Zeitverzerrungen\nals du dir vorstellen kannst."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Das wirkte sich auf schwache\nund gebrechliche Menschen aus.<page>Leichten Menschen wurde schwindlig,\nund schwere konnten\neinfach nicht mehr stehen."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Vielleicht bist du besonders\nempfindlich f[UNI00fc]r so etwas.<page>Selbst die wenigen Zeit-\nverzerrungen hier wirken auf dich."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(0, "Wenn wir einige der nahe\ngelegenen Verzerrungen beseitigen,\ngeht's dir vielleicht besser.")
	message.say_bubble(0, -1, player, npc, 0)
	event.set_character_motion(player, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Zeitverzerrungen beheben ... Spheda!\n   Wenn du etwa 10 Runden schaffst,\n   geht es Mina vielleicht besser."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	cleared_stage_count = event.get_menu_value_2(0) or cleared_stage_count
	event.set_save_counter(19, cleared_stage_count)
	event.set_quest_request(0, 17, 1)
end

--- Has a preoccupied NPC mutter guesses at a safe combination and shows a hint to come back later.
function palm_brinks_quests.mutter_safe_combination(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Grummel, grummel ...")
	message.wait_facing_character(npc)
	event.open_message_window_2(0, "... 1212,<page>Nein, nein, es war bestimmt 1122.<page>Oder vielleicht auch 1010.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Grummel, grummel ...")
	message.say_bubble(0, -1, npc, player, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		'[(!)]Wenn er nicht einmal Notiz\n  von dir nimmt, wenn du "Hallo." sagst, hat er \n   wohl ernsthafte Probleme.<page>[(!)]Versuch\'s doch sp[UNI00e4]ter nochmal.\n   Vielleicht kannst du ihm zur\n   Hand gehen oder ein Ohr leihen.'
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has Gerald hand over a Trumpet Gun and challenge the player to build it up into a Bell Trigger.
function palm_brinks_quests.offer_bell_trigger_challenge(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Cedric sagt, du w[UNI00e4]rst in\nletzter Zeit viel\nunterwegs gewesen.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Du kannst vieles gut,<page>aber andererseits bringst du\nnie etwas zu Ende.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Deshalb f[UNI00e4]llt es mir schwer,\ndich einfach ernst zu nehmen,\nwenn du mich um Hilfe bittest."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Ich hab's - stufe dieses\nTrompeten-Gewehr zu einem\nKlingel-Abzug hoch!<page>Schaffst du das?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.add_inventory_item(24)
	inventory.show_obtained_message_for_item_id(24, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Damit Gerald dich akzeptiert,\n   musst du ihm einen\n   Klingel-Abzug bringen.<page>[(!)]Du kannst seine Waffe\n   hochstufen, eine andere kaufen\n   oder eine aus dem Verlies holen."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

--- Has the coin collector take the Dark Coin and Indestructible Coin from the player and join the party.
function palm_brinks_quests.recruit_coin_collector(npc: s32, player: s32)
	local playable_character: s32 = 0
	local dark_coin_count: s32 = 0
	local indestructible_coin_count: s32 = 0
	local answer: any = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc, player)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	dark_coin_count = event.get_item_count(201) or dark_coin_count
	indestructible_coin_count = event.get_item_count(202) or indestructible_coin_count
	if dark_coin_count <= 0 or indestructible_coin_count <= 0 then
		event.open_message_window_2(
			0,
			"Wie? Ah, M[UNI00fc]nzen sammeln?<page>Ich suche die Dunkle M[UNI00fc]nze\nund die Panzer-M[UNI00fc]nze.<page>Die findest du nie. Ich hab [UNI00fc]berall\nnach ihnen gesucht - aber umsonst."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Wie? Du hast sie? Unglaublich!<page>Steh nicht rum!\nGib her, gib her, gib her!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Gut.\nWas soll ich tun?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Ahh! Wenn du mich\nver[UNI00e4]ppelst, helfe ich dir nie.")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"Wow, ich hab sie alle!\nIch dachte, das w[UNI00e4]re unm[UNI00f6]glich ...<page>Tja, dann hab ich wohl keine Wahl.\nIch muss mitkommen!"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

--- Has Gordon ask Max for Holy Water to fix the tree and, once it is handed over, join the party.
function palm_brinks_quests.recruit_gordon(npc: s32, player: s32)
	local playable_character: s32 = 0
	local used_item: s32 = 0
	local npc_id: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		villager_recruitment.hint_talk_to_gordon(npc, player)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Max, ich muss unbedingt diesem\nBaum helfen.<page>Na ja, und daf[UNI00fc]r brauche\nich ...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_use_item_menu(276)
	vm.wait(4)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 276 then
		event.open_message_window_2(0, "Max, so klappt das nicht.<page>Ich brauche Weihwasser\nvon Priester Bruno.")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ja - das ist es, Max! Jetzt\nkann ich den Baum versorgen!<page>Danke, Max.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Meine Arbeit ist vorerst\nerledigt.<page>Jetzt kann ich dich auf\ndeinem Abenteuer begleiten!<page>Oh, und sag deinem Vater\nnichts von dem Weihwasser, ja?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon reist jetzt mit.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		'[(!)]Seine Fertigkeiten verwendest\n   du [UNI00fc]ber den Statusbefehl unter\n   "Charakter" im Hauptmen[UNI00fc].<page>[(!)]Wenn du weitere Begleiter\n   gewinnst,\n   steigen diese in den Zug.'
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		'[(!)]Sprich jemand im Zug an,\n   um ihn oder sie als drittes\n   Gruppen-Mitglied zu aktivieren.<page>[(!)]Um einen deiner Begleiter in ein\n   Haus zu bewegen, w[UNI00e4]hle im T[UNI00fc]r-\n   Men[UNI00fc] des Hauses "Belegen".'
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Es gibt bestimmt noch\n   viele, die mit dir kommen wollen.\n   Halte Ausschau nach ihnen!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.set_npc_party_status(npc_id, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

--- Has Milane check that the player owns item 67 or 69 and, if so, join the party.
function palm_brinks_quests.recruit_milane(npc: s32, player: s32)
	local sword_67_count: s32 = 0
	local sword_69_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	sword_67_count = event.get_item_count(67) or sword_67_count
	sword_69_count = event.get_item_count(69) or sword_69_count
	if sword_67_count <= 0 and sword_69_count <= 0 then
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
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

--- Has Polly ask about the bread delivery to Morton, then once the order is cancelled trade the 20 delivery loaves for 20 of item 299 and join the party.
function palm_brinks_quests.recruit_polly(npc: s32, player: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage < 3 then
		event.open_message_window_2(0, "Tut mir Leid, ich bin\nnoch nicht soweit.<page>Gibst du mir noch\netwas Zeit?")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "[UNI00dc]brigens, warst du schon\nf[UNI00fc]r mich bei Morton?")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Was! Wie kann er so\nr[UNI00fc]cksichtslos sein?<page>Na ja,\nnimm du sie.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Vergessen wir's,\nbrechen wir auf.<page>Und wo soll's\nhingehen?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

--- Has Rufio check the player has photographed the moon and, if so, join the party.
function palm_brinks_quests.recruit_rufio_with_moon_photo(npc: s32, player: s32)
	local moon_photo_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	moon_photo_count = event.get_photo_count_of_subject(193) or moon_photo_count
	if moon_photo_count <= 0 then
		event.open_message_window_2(
			0,
			"Ich dachte, du w[UNI00e4]rst vielleicht\nanders, aber Menschen sind\neben Menschen.<page>Egal. Ich bin's gewohnt,\ndass ihr Menschen immer l[UNI00fc]gt."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Wow, wie toll! Auf dem Foto ist\nein Mond.<page>Jetzt kann ich ihn immer\nund [UNI00fc]berall ansehen."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Mitkommen?<page>Klar komm ich mit.\nIch hab sonst nichts\nzu tun.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

return palm_brinks_quests
