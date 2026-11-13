--!strict
--- English villager conversations triggered from the town and dungeon scripts.

local vm = require("@lib/vm")
local baker = vm.module("@lib/event/english/baker")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/english/npc_chatter")
local npc_dialogue = vm.module("@lib/event/english/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/english/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/english/quest_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_dialogue = {}

--- Plays Corinne's request to join the player, her hide-and-seek challenge and her disappearance.
function villager_dialogue.start_corinne_hide_and_seek(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local answer: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "Ooh, Max! I've heard that\nyou've been going out of town recently.")
	else
		event.open_message_window_2(0, "Ooh, Monica! I've heard that\nyou've been going out of town recently.")
	end
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "That's great! Why don't you\ntake me with you?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"I bet you're thinking I won't be\nany use because I'm a girl.<page>But I actually bring people\na lot of luck."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"It never rains when I go out,\nand I've never seen a losing\nlottery ticket.<page>What do you think?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "OK then.\nNo, sorry.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(villager, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Why! Don't be mean!\nYou're horrible!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "You're useless!<page>You fool!<page>You idiot!")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "You'll take me with you?<page>I didn't think you would!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"But how come I'm the only one\nthat has to ask you, when you've\nbeen asking all these other people.<page>If you'd just asked, then of\ncourse I would have helped you."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "I know, if you can find me,\nthen I'll help you. What do you think?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "In other words, let's play hide-and-seek!<page>Right, go!")
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
		"[(!)]Oh well... Looks like you'd better try\n   to find Corinne. She's probably hiding\n   somewhere in Palm Brinks."
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
		"Oh, Max! You've been moping about\na lot lately. Are you taking care\nof yourself?<page>Something I can do for you?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "What! You want me to go with you\non your adventure?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Hmm... I'd like to go with you...\nBut this poor tree isn't doing\nso well.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Taking care of the trees and the\nflowers on this property is my\nnumber one priority, you know.<page>If I go off roaming about, I could\nlose my job."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"I bet some of the Holy Water that Priest Bruno\nsells at the church would fix this tree!<page>But, as you know, your father\nand Priest Bruno are on bad terms...<page>Your father'd never give me money to buy\nHoly Water from Priest Bruno!<page>I'm in a pickle."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]To get Gordon to Sindain, first you\n   have to get him to join you on\n   your journey.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]If you fulfill Gordon's quest,\n   he'll join you on your journey and\n   get on the train."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]You can check out your quests\n   by reading your Notebook,\n   located on the Item Menu.")
	message.show(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(
			0,
			"[(!)]Oh, you don't have a Notebook.\n   There's one on the table\n   inside the Maintenance Shop."
		)
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]There's another one in\n   Donny's hideout. Either will do.\n   Just get hold of one quick!"
		)
		message.show(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Speaks Corinne's lines once the hide-and-seek quest is complete, with different lines in chapter 8.
function villager_dialogue.talk_corinne_after_quest(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Hide-and-seek is just\nfor little kids.")
	else
		event.open_message_window_2(
			0,
			"You can't fool me. I know you've\nbeen off doing all sorts of fun\nstuff. Tell me about it sometime!"
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Chooses the villager's conversation from the progress of quest request 12, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_12_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_muttering_numbers(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 12) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_safe_combination(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_safe_code_request(villager, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_garbage_neighbor(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 14, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_14_villager(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_moon_longing(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 14) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_moon_photo(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_moon_photo(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_moon_photo_thanks(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 2, using a default talk until quest request 0 is complete.
function villager_dialogue.talk_quest_2_villager(villager: s32, player_character: s32)
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
		npc_dialogue.recruit_with_rare_coins(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_zelmite_hunt(villager, player_character)
		return
	end
end

--- Chooses the villager's conversation from the progress of quest request 8, using a default talk until quest request 0 is complete, with a separate talk while Monica is playable.
function villager_dialogue.talk_quest_8_villager(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		baker.chat_about_max(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_customer_trust(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 8) or quest_status
	if quest_status == 0 then
		npc_dialogue.start_baker_request(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_baker_request(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_baker_done(villager, player_character)
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
		event.open_message_window_2(0, "Are you a friend of Max's?<page>Well, mind how you go.")
	else
		event.open_message_window_2(
			0,
			"From now on I'm going to be helping\nNeed and Cedric rebuild the world.\nWe have to work together on this."
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Speaks the villager of type 16's lines before quest request 0 is complete.
function villager_dialogue.talk_villager_16_early(villager: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"You're good with machines,\nbut don't you think it's time for\nyou to start learning about mining?"
	)
	cutscene.talk_to_character(villager, -1, 0, 0)
end

--- Speaks the lines of the villager of type 23 once their quest is complete, with different lines in chapter 8.
function villager_dialogue.talk_villager_23_after_quest(villager: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "You helped me so I'll help you, but please\ndon't take me to a place that has insects!")
	else
		event.open_message_window_2(
			0,
			"If the Blackstone Railroad spreads\nall around the world, maybe I'll\nhave to go around the world too."
		)
	end
	cutscene.talk_to_character(villager, -1, 0, 0)
end

return villager_dialogue
