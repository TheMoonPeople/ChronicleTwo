--!strict
--- Holds the English recruitment of the old woman villager into the party.

local vm = require("@lib/vm")
local baker = vm.module("@lib/event/english/baker")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/english/npc_chatter")
local npc_dialogue = vm.module("@lib/event/english/npc_dialogue")
local npc_recruit = vm.module("@lib/event/english/npc_recruit")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/english/palm_brinks_quests")
local palm_brinks_talk = vm.module("@lib/event/english/palm_brinks_talk")
local palm_brinks_villagers = vm.module("@lib/event/english/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/english/quest_dialogue")
local wait = vm.module("@lib/event/wait")

local villager_recruitment = {}

--- Prompts the player for the invitation phrase and recruits the old woman villager when it is entered correctly.
function villager_recruitment.ask_phrase_to_join(villager: s32, player_character: s32)
	local entry_result: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "What was that?<page>Can't you talk a bit more slowly?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Please enter, "Let\'s go together."', "Let's go together.", 0)
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
		event.open_message_window_2(0, "What are you going on about?\nI've no idea...")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "An adventure?\nThat would be nice.<page>What use could an old\nwoman like me be?")
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
				"That kind of money won't\nget me into the auction.<page>I need 1000 Gilda.\nPlease get it right!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(0, "You won't believe this!<page>The price has gone up to\n1200 Gilda.")
			message.say_bubble(0, -1, villager, player_character, 0)
			event.open_message_window_2(0, "I'm terribly sorry, but could you\npossibly get hold a of 1500 Gilda?")
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
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 1500 Gilda as quick as you can!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"This is terrible!\nThere's someone who'll pay 1800 Gilda!<page>If I don't bid about 2000 Gilda,\nthere's no way I'll win."
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
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 2000 Gilda as quick as you can!"
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Sonny, did you manage to get\nmy 2000 Gilders together?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "What can I do, it's yours.\nIt does seem a bit of a waste.")
		choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if choice ~= 0 then
			event.open_message_window_2(
				0,
				"I see... well, 2000 Gilda is a lot of money.\nso it must be hard to part with.\nEven for a well-off young lad like you...<page>Okay then, never mind!\nBut the auction isn't over yet.\nI'll wait, no matter how long it takes..."
			)
			message.say_bubble(0, -1, villager, player_character, 0)
			event.set_character_motion(villager, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Thank you so much.<page>I'll get straight down to the auction!")
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
	event.open_message_window_2(0, "Thank you very much.\nI managed to make a successful bid.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "I bid strong and everyone else dropped out really\nquickly, so I got it for 1400 Gilda!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "So now I can give you 600 back.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(0, "And I'll work hard from now on to repay\nyou the rest of the money I borrowed.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "I know I put you to a lot of trouble.\nI'll repay the favour anytime.")
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
		event.open_message_window_2(0, "Oh! You found me!<page>But can you find me again?")
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
		"Oh! You found me...<page>I'm getting a bit fed up with this now.<page>Hiding is actually\nreally boring.<page>Oh well! Let's go off on\nour adventure then!"
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
	event.open_message_window_2(0, "The Firbit people will only\ngrant favours to people who are\nmore skilled than themselves.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "I'm fairly confident when it\ncomes to fish.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"I've heard that some humans are holding\nan event where they make their fish compete\nagainst each other.<page>If you've got a fish, why don't you\ntry to come in first place?<page>If you can do that, then \nI'll know you're worthy of my help."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]She seems to be talking about the Fish\n   Race.  Why not try to win the Beginners'\n   Class?  Then maybe she'll help."
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
	event.open_message_window_2(0, "You're Monica,\nright?<page>I've heard you're not\nbad with a sword.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "But swords aren't\nplaythings you know.<page>You have to think about\nwhat's in front of you.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "If you can build-up a sword by about 2 levels,\nthen I'll believe you've got talent.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Why don't you start\nwith this Gladius.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.add_inventory_item(44)
	inventory.show_obtained_message_for_item_id(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]To get Milane to accept you, it looks\n   like you'll have to build-up Gladius by\n   2 levels."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]It's fine to buy or pick up weapons too.\n   Just get hold of a strong weapon, and\n   then Milane will help you out."
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
	event.open_message_window_2(0, "Hmm, this tree... It doesn't look\ngood. I've got to do something.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Looks like you have to talk to\n   Gordon to get his attention.")
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
		event.open_message_window_2(0, "It seems like you're not\nquite good enough yet.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(
			0,
			"I have high hopes for you in the future,\nbut I'm afraid I can't cooperate\nwith you at the moment."
		)
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"You've done well.\nWonderful.<page>I'm sure you'll live\nup to my expectations.<page>I promised, didn't I?\nI'll go with you."
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
	event.open_message_window_2(0, "Really? You need my help?<page>Then let me pose you a problem.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"The candles in this church are\ncontrolled by a small mechanism.<page>When they're lit it puts them out,\nand when they're out it lights them.<page>If one of them changes,\nthe adjacent candles change too."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"If you can put all the candles out successfully,\nit'll prove your wisdom, and I'll go with you.<page>If you solve it, great! If not,\nplease understand that I cannot help you."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]This is another puzzler. Give\n   it a few attempts, and make use\n   of what you learn each time."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]If you re-enter the church,\n   the candles will be reset.\n   So don't worry about going wrong.\n   The answer could be simple."
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
	event.open_message_window_2(0, "Ah, Max! I've finally completed a garment!")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"I didn't want to let the materials\nyou gave me go to waste,\nand that kept me going to the end."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "I'm not completely satisfied with it,\nbut would you wear it anyway?")
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
		"Ah, it's so great to have\nfinished something.<page>Now I feel much\nmore confident.<page>I'll do the very best I can,\nso please take me with you."
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
		"I see...I really wish\nthat I could help you.\nMore than anything.<page>But I don't have any\nconfidence in myself."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"I always seem to give up halfway,\nand I've never seen anything through.<page>When I was little, I dreamt of becoming a tailor,\nand I tried many times to make something,\nbut I never completed a single garment."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "If I went with you, I'm sure\nI'd just get in the way.<page>So, sorry, but no.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh dear, Adel has lost all her\n   confidence. This is no good. Let's\n   get her to try making clothes again."
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
	event.open_message_window_2(0, "I wish I could help you out, but fighting's\nscary and I might get dirty.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "And I'd hate to be a nuisance to everyone.\nSorry, but I'll have to say no.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"But there must be lots of\nunusual things outside town.<page>I wonder what the trees are like,\nand what kind of flowers there are."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"If you see an interesting flower, could\nyou take a picture of it for me, Max?\nI'd so love to see it."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]She said no this time, but if you show\n   her a picture of something she's\n   interested in she'll probably give in."
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
	event.open_message_window_2(0, "Yeah, I don't mind going with\nyou, but will there be a moon there?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Really? Maybe you're just saying that.\nI know humans tell lies.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Actually, I've changed my mind.\nI'm going to wait for the moon to come out here.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Maybe it's because of something that\n   happened in the past, but Rufio doesn't\n   trust humans at all."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]You've got to get Rufio to\n   believe you. If you gave him a\n   photo of the moon, that might do it."
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
	event.open_message_window_2(0, "If there's anything you need,\nI'll do my best to help you.<page>Leave it to me.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "I don't know if you can help...<page>But just listen to this.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "I've spent some 30 years working\nhard in this house.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "That's all I do, but my one\nhobby is reading.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "There's a really valuable and rare book\nthat's up for auction at the moment.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "People are fighting over it.\nI believe a bid of about\n1000 Gilda would be enough.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"But I don't have those kind of funds, and if I were\nto ask my master, he'd be appalled and I'd probably\nhave to resign."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"So you're my only hope.<page>But that's not to say that\nif you can't help me I won't help you."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Despite what he says, Stewart probably\n   won't help unless you give him 1000 Gilda.\n   Oh well, better get some money together!"
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
		event.open_message_window_2(0, "Hi there.\nIt's Monica, right?")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "I'm Parn.\nI'm a magical artist.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.open_message_window_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
		message.say_bubble(0, -1, villager, player_character, 0)
		event.set_character_motion(villager, "立ち")
		event.open_message_window_2(0, "...")
		message.say_bubble(0, -1, player_character, villager, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Monica's not very good in this kind of \n   situation. She might get somewhere, but\n   probably not. Better try again as Max."
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(villager, 0, 0)
	event.open_message_window_2(0, "Hey Max.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, player_character, villager, 0)
	event.open_message_window_2(0, "Yeah, you can laugh.\nI know it's strange!<page>Who'd fall in love with\na girl in a picture?")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"But I'm a magical artist.\nI have the power to make the things I draw real.<page>Whatever I draw really does exist in the picture.\nAs long as it's not a living thing..."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "Even a magical artist can't draw life.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "But, I've heard of a way.\nThere's a Golden Egg in a big, old tree.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(0, "It's said that with its golden colour,\nyou can give life to anything you draw.")
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Max, you're going out of\ntown, right?<page>I wonder if you could get hold of some Golden Paint?"
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.open_message_window_2(
		0,
		"Of course I don't expect you to do it for nothing.<page>If you can help me, I'll use\nmy new power to help you in return."
	)
	message.say_bubble(0, -1, villager, player_character, 0)
	event.set_character_motion(villager, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]A big, old tree...\n   With  a Golden Egg! Where on earth\n   would you find a tree like that?!"
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

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 10, with a separate talk for Max.
function villager_recruitment.route_request_10_talk(villager: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		npc_dialogue.chat_about_circus(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_blade_shopkeeper(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 10) or quest_status
	if quest_status == 0 then
		villager_recruitment.give_gladius_challenge(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_milane(villager, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_sword_fan(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 12.
function villager_recruitment.route_request_12_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_quests.mutter_safe_combination(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 12) or quest_status
	if quest_status == 0 then
		npc_recruit.explain_safe_problem(villager, player_character)
		return
	end
	if quest_status == 1 then
		npc_recruit.open_mayor_safe(villager, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_garbage_neighbor(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 19.
function villager_recruitment.route_request_19_talk(villager: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_hard_of_hearing(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 19) or quest_status
	if quest_status == 0 then
		villager_recruitment.ask_phrase_to_join(villager, player_character)
		return
	end
	if quest_status == 1 then
		villager_recruitment.recruit_old_woman(villager, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_old_granny(villager, player_character)
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
		npc_chatter.talk_tailor_dream(villager, player_character)
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
		npc_chatter.talk_tailor_done(villager, player_character)
		return
	end
end

--- Routes a talk with the villager to the default conversation until quest request 0 reaches status 2, then to the conversation matching the status of quest request 8, with a separate talk for Monica.
function villager_recruitment.route_request_8_talk(villager: s32, player_character: s32)
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
		npc_recruit.request_bread_delivery(villager, player_character)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_polly(villager, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_baker_done(villager, player_character)
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
		npc_dialogue.chat_armed_women(villager, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_peaceful_town(villager, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(villager)
		x = out1 or x
		z = out3 or z
	end
	if x < 1182.0 or 1183.0 < x or z < 210.0 or 211.0 < z then
		print("kokokokokokokokokoko\n")
		npc_dialogue.chat_busy_with_materials(villager, player_character)
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
