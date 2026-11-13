--!strict
--- Dialogue and scripted conversations of the Palm Brinks townspeople in the English version of the game.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/english/npc_chatter")
local npc_dialogue = vm.module("@lib/event/english/npc_dialogue")
local party = vm.module("@lib/event/party")
local party_recruit = vm.module("@lib/event/english/party_recruit")
local quest_dialogue = vm.module("@lib/event/english/quest_dialogue")
local swordsmith = vm.module("@lib/event/english/swordsmith")
local villager_dialogue = vm.module("@lib/event/english/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local palm_brinks_villagers = {}

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
				"That kind of money won't\nget me into the auction.<page>I need 1000 Gilda.\nPlease get it right!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(0, "You won't believe this!<page>The price has gone up to\n1200 Gilda.")
			message.say_bubble(0, -1, character, player_character, 0)
			event.open_message_window_2(0, "I'm terribly sorry, but could you\npossibly get hold a of 1500 Gilda?")
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
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 1500 Gilda as quick as you can!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"This is terrible!\nThere's someone who'll pay 1800 Gilda!<page>If I don't bid about 2000 Gilda,\nthere's no way I'll win."
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
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 2000 Gilda as quick as you can!"
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Sonny, did you manage to get\nmy 2000 Gilders together?")
		message.say_bubble(0, -1, character, player_character, 0)
		event.set_character_motion(character, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "What can I do, it's yours.\nIt does seem a bit of a waste.")
		handover_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if handover_choice ~= 0 then
			event.open_message_window_2(
				0,
				"I see... well, 2000 Gilda is a lot of money.\nso it must be hard to part with.\nEven for a well-off young lad like you...<page>Okay then, never mind!\nBut the auction isn't over yet.\nI'll wait, no matter how long it takes..."
			)
			message.say_bubble(0, -1, character, player_character, 0)
			event.set_character_motion(character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Thank you so much.<page>I'll get straight down to the auction!")
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
	event.open_message_window_2(0, "Thank you very much.\nI managed to make a successful bid.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "I bid strong and everyone else dropped out really\nquickly, so I got it for 1400 Gilda!")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "So now I can give you 600 back.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(0, "And I'll work hard from now on to repay\nyou the rest of the money I borrowed.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "I know I put you to a lot of trouble.\nI'll repay the favour anytime.")
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
	event.open_message_window_2(0, "Welcome.")
	if npc_type == 18 then
		event.open_message_window_2(
			0,
			"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
		)
	end
	if npc_type == 4 then
		event.open_message_window_2(
			0,
			"Working hard, I see?\nYou need something?<page>No freebies, though.\nNot even for you, Max."
		)
	end
	if npc_type == 34 then
		event.open_message_window_2(
			0,
			"You need some more Georama\nelements?<page>If you don't have the time to\ncollect them yourself, maybe\nmoney can solve your problems."
		)
	end
	if npc_type == 1012 then
		baker_greeted = event.get_save_flag(45) or baker_greeted
		if baker_greeted == 0 then
			event.open_message_window_2(
				0,
				"Hello. I'm a baker's apprentice.\nI'm handling the bakery while\nPolly's away.<page>I'm a little nervous, but this is\nall part of my training, I guess.\nI'll do my best!"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_type == 1015 then
		weapon_shop_greeted = event.get_save_flag(46) or weapon_shop_greeted
		if weapon_shop_greeted == 0 then
			event.open_message_window_2(
				0,
				"We may not look very much alike...\nBut I'm Milane's little sister.<page>Milane made me watch the shop while she's away.\nI don't know the first thing about weapons!"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_type == 1018 then
		priest_greeted = event.get_save_flag(47) or priest_greeted
		if priest_greeted == 0 then
			event.open_message_window_2(
				0,
				"Surprise you, did I? I guess anyone\nwould be surprised to see someone\nstanding here dressed like this.<page>I'm a good friend of Priest Bruno. I'm\nfilling in for him while he's away on a trip.\nSo, is there anything I can help you with?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
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
	event.open_message_window_2(0, "You want me to do you a favour?<page>First, hear me out.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"I only listen to people that I respect.<page>And the only people I respect are people\nthat have caught a bigger fish than me."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"The biggest fish I ever caught\nwas a 60cm Nonky.<page>Are you impressed?\nIf you feel like a challenge,\nI'll take you on anytime!"
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]It seems like the only way to get\n   him on your side is to catch a Nonky\n   of more than 60cm. You can do it!"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]Anyway, try doing some fishing\n   in the Palm Brinks lake.")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Asks the player to find Chestnuts for the Castagnaccio sweet and registers the request.
function palm_brinks_villagers.request_chestnuts(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "Ah, good timing!\nThere's something I wanted to talk to you about.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"I'm sure you know that I'm making\nunusual sweets from around the\nworld as part of my research."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "I've heard that there's a sweet called Castagnaccio.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "which is made using something called Castarna.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "I've managed to find out that this Castarna grows\non the same kind of tree as Chestnuts.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"So I thought I may as well try using Chestnuts instead,\nbut it's really weird...\nChestnuts are sold out all over town."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "Apparently the Mayor's bought them all up or something.\nDon't suppose you could help me out?")
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
	event.set_quest_request(0, 3, 1)
end

--- Tells the player the Firbit will help only if the player wins the Fish Race Beginners' Class, and registers request 16.
function palm_brinks_villagers.request_win_fish_race(character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	event.open_message_window_2(0, "The Firbit people will only\ngrant favours to people who are\nmore skilled than themselves.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(0, "I'm fairly confident when it\ncomes to fish.")
	message.say_bubble(0, -1, character, player_character, 0)
	event.open_message_window_2(
		0,
		"I've heard that some humans are holding\nan event where they make their fish compete\nagainst each other.<page>If you've got a fish, why don't you\ntry to come in first place?<page>If you can do that, then \nI'll know you're worthy of my help."
	)
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]She seems to be talking about the Fish\n   Race.  Why not try to win the Beginners'\n   Class?  Then maybe she'll help."
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
			event.open_message_window_2(window, "Go get me a\nScoop Memo, will ya?")
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
			event.open_message_window_2(window, "Looks like there's\nno more scoops to be had.")
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
			event.open_message_window_2(window, "I figured out [Number1] more scoops.")
			event.set_message_draw_speed(window, 0)
			resume_step = 6
			message.show(window, -1, 8, 0, 0)
		end
		message.set_window_mode(window, 1)
		new_scoop_count = event.get_menu_value_2(4) or new_scoop_count
		if new_scoop_count <= 0 then
			event.open_message_window_2(window, "Come on, man! Quit slackin'!\nWhere's all your new inside scoops?")
		else
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Woo! You got [Number1] new scoops!\nI knew you had it in ya!")
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
	event.open_message_window_2(0, "You've been going out of town recently,\nright Max?<page>Don't deny it.\nI know you have.")
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the remark that Max is hardly ever seen since the player arrived.
function palm_brinks_villagers.talk_about_max_absence(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Since you came along, I've\nhardly seen Max at all.\nI don't know what you're up to,<page>but I hope you're not using him."
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
		event.open_message_window_2(0, "Hello. What kind of food do you\nlike, Monica?")
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(0, "Of course, I like normal food, but\nI'm also partial to unusual food.")
	else
		event.open_message_window_2(0, "I'm going to be the world's best\nchef someday, and when I do,\nyou can eat free anytime.")
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
end

--- Plays the blade shopkeeper's remark about the shop's specialty.
function palm_brinks_villagers.talk_blade_shopkeeper(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"My shop specializes\nin blades.<page>I do have some guns,\nbut firearms aren't\nreally my kind of thing."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
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
		npc_dialogue.pose_candle_puzzle(character, player_character)
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

--- Plays the shopkeeper's remark about the importance of customer trust.
function palm_brinks_villagers.talk_customer_trust(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"The most important thing in business\nis having the trust of your customers.<page>It's something you must\nnever take for granted."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the neighbour's reminder about sorting garbage, with a warning about Zelmite Mine in chapter 8.
function palm_brinks_villagers.talk_garbage_neighbor(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Make sure you separate your garbage\nand throw it out on the right days, won't you?")
	else
		event.open_message_window_2(
			0,
			"Just on a personal note here, I\nknow Zelmite Mine is a dangerous\nplace. Don't do anything foolish."
		)
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the old granny's remark, with a different line in chapter 8.
function palm_brinks_villagers.talk_old_granny(character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "What use could an old\ngranny like me be?")
	else
		event.open_message_window_2(
			0,
			'When the Blackstone Railroad is\nall done, I\'d just love to \ngo to the "Ends of the Earth".'
		)
	end
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the villager's complaint that the town is too peaceful to find work.
function palm_brinks_villagers.talk_peaceful_town(character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"This town is too peaceful, and\nthere's just no work for me.<page>Of course, I know that's a good thing,\nbut still..."
	)
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
		npc_dialogue.chat_armed_women(character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		palm_brinks_villagers.talk_peaceful_town(character, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(character)
		x = out1 or x
		z = out3 or z
	end
	if x < 1182.0 or 1183.0 < x or z < 210.0 or 211.0 < z then
		print("kokokokokokokokokoko\n")
		npc_dialogue.chat_busy_with_materials(character, player_character)
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
		"The shop's closed. You'll have to\ngo to my old man's shop instead.<page>Look for the pumpkins. I'm sure you'll see 'em.\nIt's just at the top of that ladder."
	)
	cutscene.talk_to_character(character, -1, 0, 0)
end

--- Plays the sword enthusiast's remark, with a different line in chapter 8.
function palm_brinks_villagers.talk_sword_fan(character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "A glint of a well-made\nsword is so brilliant.<page>It takes your breath away.")
		message.say_bubble(0, -1, character, player_character, 0)
		event.open_message_window_2(0, "I don't understand how anyone could\nbe happy just polishing stones.")
	else
		event.open_message_window_2(0, "So, what's the scoop? Come across\nany tough guys in that mine yet?")
	end
	message.say_bubble(0, -1, character, player_character, 0)
	event.set_character_motion(character, "立ち")
	event.finish_event()
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
		quest_dialogue.talk_painter(npc_character, player_character)
	end
	if npc_type == 4 then
		state_flag = event.get_save_flag(104) or state_flag
		if state_flag == 0 then
			event.open_message_window_2(0, "Let me shop\nDig for a scoop")
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
			event.open_message_window_2(0, "Be my friend!\nDig for a scoop")
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
				villager_dialogue.talk_quest_2_villager(npc_character, player_character)
			end
		end
	end
	if npc_type == 7 then
		quest_dialogue.talk_candy_maker(npc_character, player_character)
	end
	if npc_type == 8 then
		npc_dialogue.talk_to_flower_photographer(npc_character, player_character)
	end
	if npc_type == 10 then
		quest_dialogue.talk_book_servant(npc_character, player_character)
	end
	if npc_type == 11 then
		npc_dialogue.talk_to_adel(npc_character, player_character)
	end
	if npc_type == 12 then
		request_0_status = event.get_quest_request_status(0, 0) or request_0_status
		request_8_status = event.get_quest_request_status(0, 8) or request_8_status
		if request_0_status == 2 and request_8_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Hello\nBe my friend!")
			greeting_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice == 1 then
				villager_dialogue.talk_quest_8_villager(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 28 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			villager_dialogue.talk_quest_8_villager(npc_character, player_character)
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
			event.open_message_window_2(0, "Hello\nBe my friend!")
			greeting_choice_2 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if greeting_choice_2 < 0 then
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
			if greeting_choice_2 == 1 then
				swordsmith.start_conversation(npc_character, player_character)
				event.set_villager_ai_enabled(1, npc_character)
				return
			end
		end
		if current_submap == 30 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			swordsmith.start_conversation(npc_character, player_character)
		end
	end
	if npc_type == 16 then
		quest_dialogue.talk_gun_fighter(npc_character, player_character)
	end
	if npc_type == 17 then
		villager_dialogue.talk_quest_12_villager(npc_character, player_character)
	end
	if npc_type == 18 then
		request_0_status_3 = event.get_quest_request_status(0, 0) or request_0_status_3
		request_13_status = event.get_quest_request_status(0, 13) or request_13_status
		if request_0_status_3 == 2 and request_13_status ~= 2 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Hello\nBe my friend!")
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
		villager_dialogue.talk_quest_14_villager(npc_character, player_character)
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
		quest_dialogue.talk_hide_and_seek_hider(npc_character, player_character)
	end
	if npc_type == 25 then
		npc_dialogue.talk_to_old_woman(npc_character, player_character)
	end
	if npc_type == 33 then
		request_8_status_2 = event.get_quest_request_status(0, 8) or request_8_status_2
		playable_character = event.get_playable_character() or playable_character
		if request_8_status_2 == 1 and playable_character == 0 then
			event.set_character_motion(player_character, "立ち")
			event.open_message_window_2(0, "Let me shop\nHello")
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
				"Lately I've been having a hard time\nseeing all the tiny little parts.<page>Guess I'm gettin' a bit\nlong in the tooth..."
			)
		else
			event.open_message_window_2(
				0,
				"Seeing the Blackstone Railroad\noperate all over the continent is a\ndream both Need and I share.<page>We can count on you to help, right?"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 2 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "If I don't have my hands in\nsomething at all times,\nI get real cranky.")
		else
			event.open_message_window_2(
				0,
				"If they discover Zelmite I'll\nbe real busy too. That's right.\nI'd dig, dig and dig some more!!"
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 6 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"You know, I have a lot of bugs\nin my feathers these days,\nand they make me itch terribly."
			)
		else
			event.open_message_window_2(
				0,
				"It's fine if you spend your time\nhunting for Zelmite. Just don't\npush yourself too hard, kid."
			)
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 13 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"I love the smell of gunpowder!\nThis job is really made for me.<page>Then again, my boss is awfully\nstubborn and old-fashioned.\nOh, well."
			)
		else
			event.open_message_window_2(0, "You really like all this\nadventure, don't ya.")
		end
		cutscene.talk_to_character(npc_character, -1, 0, 0)
	end
	if npc_type == 22 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"Apart from the fact that I started\nlife as a picture, I'm no different\nthan any other person."
			)
		else
			event.open_message_window_2(0, "I've got a bad feeling about Zelmite Mine.\nJust be careful, okay?")
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
