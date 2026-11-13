--!strict
--- Holds the English quest dialogue events for requests, recruits and request-progress routing.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/english/npc_chatter")
local npc_dialogue = vm.module("@lib/event/english/npc_dialogue")
local palm_brinks_quests = vm.module("@lib/event/english/palm_brinks_quests")
local palm_brinks_villagers = vm.module("@lib/event/english/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local villager_dialogue = vm.module("@lib/event/english/villager_dialogue")
local villager_recruitment = vm.module("@lib/event/english/villager_recruitment")

local quest_dialogue = {}

--- Plays the scene where the tailor hands over her first finished garment and joins the party.
function quest_dialogue.receive_tailor_garment(npc: s32, player: s32)
	local garment_item: s32 = 0
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Ah, Max! I've finally completed a garment!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"I didn't want to let the materials\nyou gave me go to waste,\nand that kept me going to the end."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "I'm not completely satisfied with it,\nbut would you wear it anyway?")
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
		"Ah, it's so great to have\nfinished something.<page>Now I feel much\nmore confident.<page>I'll do the very best I can,\nso please take me with you."
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
	event.open_message_window_2(0, "If there's anything you need,\nI'll do my best to help you.<page>Leave it to me.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "I don't know if you can help...<page>But just listen to this.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "I've spent some 30 years working\nhard in this house.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "That's all I do, but my one\nhobby is reading.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "There's a really valuable and rare book\nthat's up for auction at the moment.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "People are fighting over it.\nI believe a bid of about\n1000 Gilda would be enough.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"But I don't have those kind of funds, and if I were\nto ask my master, he'd be appalled and I'd probably\nhave to resign."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"So you're my only hope.<page>But that's not to say that\nif you can't help me I won't help you."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Despite what he says, Stewart probably\n   won't help unless you give him 1000 Gilda.\n   Oh well, better get some money together!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

--- Has Rufio ask for a photo of the moon before he trusts the player, then starts that request.
function quest_dialogue.request_moon_photo(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Yeah, I don't mind going with\nyou, but will there be a moon there?")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Really? Maybe you're just saying that.\nI know humans tell lies.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Actually, I've changed my mind.\nI'm going to wait for the moon to come out here.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Maybe it's because of something that\n   happened in the past, but Rufio doesn't\n   trust humans at all."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]You've got to get Rufio to\n   believe you. If you gave him a\n   photo of the moon, that might do it."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Has the mayor ask the player to work out his forgotten safe combination, then starts that request.
function quest_dialogue.request_safe_combination(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player, npc)
	event.open_message_window_2(0, "Grumble, grumble...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"What do you mean, what\nam I muttering about?<page>I'm trying to remember the\ncombination for the safe."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"What do you mean,\nwhat safe?<page>The safe hidden behind the\npicture in my office of course..."
	)
	message.say_bubble(0, -1, npc, player, 0)
	character.face_toward(npc, player)
	event.set_character_motion(npc, "会話")
	event.open_message_window_2(
		0,
		"Ah, you gave me a fright!<page>Oh, blast!<page>I've gone and let out\nmy biggest secret!<page>Oh well, you know now.<page>Maybe you can give me a\nhand trying to work it out."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "I've got a big problem\nbecause I can't remember the\ncombination for the safe.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "It's a 4-digit number so I used\nClaire's birth date thinking\nthat I'd never forget it.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "How could I possibly forget...<page>What a terrible father I am!")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]It looks like the Mayor's very troubled.\n   Listen to what he says about Claire's\n   birthday and figure out the combination."
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
	event.open_message_window_2(0, "You're Monica,\nright?<page>I've heard you're not\nbad with a sword.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "But swords aren't\nplaythings you know.<page>You have to think about\nwhat's in front of you.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "If you can build-up a sword by about 2 levels,\nthen I'll believe you've got talent.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Why don't you start\nwith this Gladius.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.add_inventory_item(44)
	inventory.announce_received(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]To get Milane to accept you, it looks\n   like you'll have to build-up Gladius by\n   2 levels."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]It's fine to buy or pick up weapons too.\n   Just get hold of a strong weapon, and\n   then Milane will help you out."
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
		"Yes, if I try again and this\ntime manage to complete something,\nmaybe I'll believe in myself again."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "But I don't have the materials I need.<page>Would you be able to get them for me?")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "All I need is Sturdy Cloth,\nThick Hide, and a Hunk of Copper.")
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
		npc_dialogue.chat_fishing_hobby(npc, player)
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
		npc_dialogue.chat_about_fishing(npc, player)
		return
	end
end

--- Routes the book servant conversation by playable character and request progress.
function quest_dialogue.talk_book_servant(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.chat_resembles_elena(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_problem_advice(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 6) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_book_funds(npc, player)
		return
	end
	if quest_status == 1 then
		palm_brinks_villagers.lend_auction_money(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_book_servant_done(npc, player)
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
		event.open_message_window_2(0, "Oh, you're\nhelping Polly?<page>Great.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "What'll I do\nwith 20 loaves?<page>Well, I'm having a cheese\nfondue party today.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			'In terms of your famous "inventions",\nit\'s a culinary combination of cheese,<page>bread and wine!'
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"It's mighty good. Everyone eats loads,\nso that's why I need so much bread.<page>But I didn't want it\ndelivered here really."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"Sorry Max, but you couldn't\ntake it to my house could you?<page>You know where it is, don't you?\nNear the pumpkin field."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 1)
	end
	if delivery_stage == 1 then
		event.open_message_window_2(0, "You know where it is, don't you?\nNear the pumpkin field.")
		message.say_bubble(0, -1, npc, player, 0)
	end
	if delivery_stage == 2 then
		event.open_message_window_2(0, "Cancelled?!\nWhat a shame!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "In that case, I don't need the bread.\nCan you take it back to Polly for me?")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 3)
	end
	if delivery_stage == 3 then
		event.open_message_window_2(0, "Sorry, but can you take the\nbread back to Polly for me?")
		message.say_bubble(0, -1, npc, player, 0)
	end
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Picks the resident's conversation from the progress of Rufio's moon photograph request, speaking an idle line before the requests open.
function quest_dialogue.talk_by_request_status(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_moon_longing(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 14) or request_status
	if request_status == 0 then
		villager_recruitment.refuse_until_moon_photo(npc_character, player_character)
		return
	end
	if request_status == 1 then
		palm_brinks_quests.recruit_rufio_with_moon_photo(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_moon_photo_thanks(npc_character, player_character)
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
		npc_dialogue.chat_about_cooking(npc, player)
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
		npc_dialogue.chat_aspiring_chef(npc, player)
		return
	end
end

--- Routes the gun fighter conversation by playable character and request progress.
function quest_dialogue.talk_gun_fighter(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		villager_dialogue.talk_villager_16_as_monica(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		villager_dialogue.talk_villager_16_early(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 11) or quest_status
	if quest_status == 0 then
		npc_dialogue.start_gerald_request(npc, player)
		return
	end
	if quest_status == 1 then
		quest_dialogue.test_gun_for_recruit(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_gun_fighter_done(npc, player)
		return
	end
end

--- Routes the hide-and-seek conversation by request progress.
function quest_dialogue.talk_hide_and_seek_hider(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.ask_to_join_party(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 18) or quest_status
	if quest_status == 0 then
		villager_dialogue.start_corinne_hide_and_seek(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_after_hide_and_seek(npc, player)
		return
	end
	if quest_status == 2 then
		villager_dialogue.talk_corinne_after_quest(npc, player)
		return
	end
end

--- Routes the painter conversation by request progress.
function quest_dialogue.talk_painter(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.talk_to_parn(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 1) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_golden_paint(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_parn_request(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_new_power(npc, player)
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
			"What's wrong?\nYou're giving up again?<page>I'm disappointed.\nIs that what comes of tinkering\nwith machines all the time?"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Looks like you've gotten\npretty good with weapons too!<page>I don't even need to see you shoot.\nI can tell by the way you hold it."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Okay, I'll help you out.\nBut I'm not doing it for you.<page>If this town's in danger,\nI can't just sit\nhere doing nothing."
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

return quest_dialogue
