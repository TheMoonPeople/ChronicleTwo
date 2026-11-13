--!strict
--- English recruitment and request conversations of Palm Brinks NPCs.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/english/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/english/palm_brinks_villagers")
local villager_recruitment = vm.module("@lib/event/english/villager_recruitment")

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
		event.open_message_window_2(0, "Hey there, Max.\nYou come to try again?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if race_state == 1 then
		event.open_message_window_2(0, "Oy! You didn't get to the boat,\ndid you? You tried to trick me.\nDon't cheat!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Giving it another try?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "Hey, no cheating!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Giving it another try?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "Oh, you're back!\nRight,<page>Let's check\nyour time!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, seconds_fraction)
	if is_fast_enough == 0 then
		event.open_message_window_2(0, "Oh Dear!\n[数値１] minutes [数値２].[数値３] seconds is\ntoo slow.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Giving it another try?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "Oh!\n[数値１] minutes [数値２] seconds [数値３]\nisn't a bad time!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "You're a lot faster than you look. Okay,\nlet's go and fight the bad guys together!")
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
			"Did you get a picture of an unusual flower?<page>I know a lot about flowers, so if it's\nnothing special it won't interest me."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Did you get a picture of an unusual flower?\nLet's see, let's see!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Wow! This is amazing!\nSo these are the kind of flowers on the outside.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Hmm... what should I do?<page>Oh, okay! Take me with you!")
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
	event.open_message_window_2(0, "You want me to do you a favour?<page>First, hear me out.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"I only listen to people that I respect.<page>And the only people I respect are people\nthat have caught a bigger fish than me."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"The biggest fish I ever caught\nwas a 60cm Nonky.<page>Are you impressed?\nIf you feel like a challenge,\nI'll take you on anytime!"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]It seems like the only way to get\n   him on your side is to catch a Nonky\n   of more than 60cm. You can do it!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Anyway, try doing some fishing\n   in the Palm Brinks lake.")
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
		"I've not been feeling too good lately.<page>I'm just not up to going on a trip.<page>I got Dr. Dell to come and have a look at me,\nbut he said there's nothing wrong."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"But even standing normally I feel\nlike I'm going to fall down.<page>It's hard to explain. It's almost\nas if the world has been distorted."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(
			0,
			"Hmmm...\nif Dr. Dell doesn't know what the problem is,\nthen there's not much I can do to help..."
		)
		message.say_bubble(0, -1, player, npc, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "I remember those symptoms.")
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"In the time I was born,\nthe world was in a very bad state,\nwith more time distortions than\nyou can possibly imagine."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"This had an effect on physically\nweak and fragile people.<page>Light people would get dizzy or faint,\nand heavier people couldn't stand at all."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Maybe you're particularly susceptible\nto this kind of thing.<page>Even the few time distortions we have\nhere are enough to affect you."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(0, "If we can just get rid of some of the closest\ndistortions, maybe you'll start to feel better.")
	message.say_bubble(0, -1, player, npc, 0)
	event.set_character_motion(player, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]How to fix a time distortion... Spheda!\n   If you can complete about 10 stages,\n   maybe Mena will start to feel better."
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
	event.open_message_window_2(0, "Grumble, grumble...")
	message.wait_facing_character(npc)
	event.open_message_window_2(0, "...1212,<page>No, no, I'm sure it was 1122.<page>Or maybe it was 1010.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Grumble, grumble...")
	message.say_bubble(0, -1, npc, player, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]If he doesn't even notice you \n   trying to say, \"Hello.\" He must \n   have some pretty serious problems.<page>[(!)]Why don't you try back later?\n   Maybe you could lend him a hand or\n   an ear or something."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has Gerald hand over a Trumpet Gun and challenge the player to build it up into a Bell Trigger.
function palm_brinks_quests.offer_bell_trigger_challenge(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "According to Cedric,\nyou've been off up to\nsomething recently.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "You're good at a lot of things,<page>but on the other hand you\nnever see anything through.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "So when you ask for help,\nit's hard for me to take you\nseriously just like that.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"I know, why don't you try to build-up\nthis Trumpet Gun to a Bell Trigger?<page>Think you can do it?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.add_inventory_item(24)
	inventory.show_obtained_message_for_item_id(24, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]To get Gerald to accept you,\n   you'll have to bring\n   him a Bell Trigger.<page>[(!)]You can build-up the weapon you've\n   been given, or you can buy a weapon,\n   or bring one you find in the dungeons."
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
			"What? Aah, coin collecting?<page>I'm looking for the Dark Coin\nand the Indestructible Coin.<page>You'll never get hold of those. I've looked all\nover for them, but they're impossible to find."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Eh? You've got them? Unbelievable!<page>Don't just stand there! Gimme, gimme, gimme!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "OK.\nWhat shall I do?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Argh! If you're going to mess me\naround I definitely won't help you.")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"Wow, I've got them all!\nAnd I thought it was impossible...<page>Well, I guess I've got no choice now.\nI'd better go with you!"
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
	event.open_message_window_2(0, "Max, fixing this tree is my number\none priority.<page>Now, what I need to fix this\ntree...")
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
		event.open_message_window_2(0, "Max, this just won't work.<page>What I need is Holy Water from\nPriest Bruno.")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Yes! Max, you've done it! Now\nI can take care of this tree!<page>Thank you, Max.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"My work is all taken care of\nfor now.<page>Now I can go with you on your\nadventure!<page>Oh, and don't mention that Holy\nWater to you father, you hear?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon joined your party.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]You can use his abilities\n   from the Status command under\n   Characters on the Main Menu.<page>[(!)]If you recruit someone else\n   to join your adventure, that\n   person will get on the train."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Talk to that person inside\n   the train to switch him or her\n   in as your third party member.<page>[(!)]To move one of your train friends\n   into a house, choose Move Person\n   from the door menu of that house."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]There may be many others\n   willing to join your party.\n   Be sure to look for them!")
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
			"What sort of a sword is that?\nSo it was all just talk?<page>Get out of here!\nYou're just getting in the way."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Wow, that's a pretty\nimpressive sword.<page>Sorry I had\nto test you.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "It's just that if I fight with an\namateur it's dangerous for me too.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "But I guess I needn't worry\nabout that with you.<page>Right, let's go\nfight together.")
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
		event.open_message_window_2(0, "Sorry, I'm still\nnot ready.<page>Can you give me\na little longer?")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "By the way, have you been\nto Morton's for me yet?")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "What! How can he be\nso inconsiderate?<page>Oh well,\nyou have them.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Never mind that,\nlet's get going.<page>So where are\nwe off to?")
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
			"I thought you might be different,\nbut no, humans are humans.<page>No matter. I've got used to you\nhumans telling lies all the time."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Wow, amazing! There's a moon in this photo.<page>Now I can see the moon any time, any place.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Come with you?<page>Of course I will.\nI've nowhere else to go.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

return palm_brinks_quests
