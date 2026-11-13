--!strict
--- English conversation routing for the NPCs of the Palm Brinks houses.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/english/npc_chatter")
local npc_dialogue = vm.module("@lib/event/english/npc_dialogue")
local npc_recruit = vm.module("@lib/event/english/npc_recruit")
local palm_brinks_quests = vm.module("@lib/event/english/palm_brinks_quests")
local palm_brinks_villagers = vm.module("@lib/event/english/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/english/quest_dialogue")
local scoop_exchange = vm.module("@lib/event/english/scoop_exchange")
local villager_dialogue = vm.module("@lib/event/english/villager_dialogue")
local villager_recruitment = vm.module("@lib/event/english/villager_recruitment")
local wait = vm.module("@lib/event/wait")

local palm_brinks_talk = {}

--- Routes a Firbit's conversation by main quest progress, a story flag and the Fish Race request state.
function palm_brinks_talk.talk_to_firbit_npc(npc: s32, player: s32)
	local quest_status: s32 = 0
	local story_flag: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	story_flag = event.get_save_flag(424) or story_flag
	if quest_status ~= 2 or story_flag == 0 then
		npc_chatter.talk_firbit_favors(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 16) or quest_status
	if quest_status == 0 then
		villager_recruitment.give_fish_race_challenge(npc, player)
		return
	end
	if quest_status == 1 then
		npc_recruit.judge_race_result(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_podium_hopeful(npc, player)
		return
	end
end

--- Routes the fisherman's conversation by main quest progress and the Nonky-fishing request state.
function palm_brinks_talk.talk_to_fisherman(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_fishing_hobby(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 15) or quest_status
	if quest_status == 0 then
		palm_brinks_quests.explain_fish_challenge(npc, player)
		return
	end
	if quest_status == 1 then
		npc_recruit.judge_nonky_catch(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_fishing(npc, player)
		return
	end
end

--- Routes the flower expert's conversation by main quest progress and the flower-photo request state.
function palm_brinks_talk.talk_to_flower_expert(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_about_leaving_town(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 4) or quest_status
	if quest_status == 0 then
		villager_recruitment.refuse_until_flower_photo(npc, player)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.check_flower_photos(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_railroad_fan(npc, player)
		return
	end
end

--- Routes Gerald's conversation by active character, main quest progress and the Bell Trigger request state.
function palm_brinks_talk.talk_to_gerald(npc: s32, player: s32)
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
		palm_brinks_quests.offer_bell_trigger_challenge(npc, player)
		return
	end
	if quest_status == 1 then
		npc_recruit.check_owned_weapon(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_gun_fighter_done(npc, player)
		return
	end
end

--- Routes the hide-and-seek girl's conversation by main quest progress and the hide-and-seek request state.
function palm_brinks_talk.talk_to_hide_and_seek_npc(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.ask_to_join_party(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 18) or quest_status
	if quest_status == 0 then
		npc_recruit.challenge_hide_and_seek(npc, player)
		return
	end
	if quest_status == 1 then
		villager_recruitment.finish_hide_and_seek(npc, player)
		return
	end
	if quest_status == 2 then
		villager_dialogue.talk_corinne_after_quest(npc, player)
		return
	end
end

--- Routes Mena's conversation by a story flag and the time-distortion request state.
function palm_brinks_talk.talk_to_mena(npc: s32, player: s32)
	local story_flag: s32 = 0
	local quest_status: s32 = 0
	story_flag = event.get_save_flag(314) or story_flag
	if story_flag == 0 then
		npc_dialogue.chat_feeling_unwell(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 17) or quest_status
	if quest_status == 0 then
		palm_brinks_quests.explain_time_distortions(npc, player)
		return
	end
	if quest_status == 1 then
		npc_recruit.judge_recovery_progress(npc, player)
		return
	end
	if quest_status == 2 then
		villager_dialogue.talk_villager_23_after_quest(npc, player)
		return
	end
end

--- Routes the pastry chef's conversation by active character, main quest progress and the Castagnaccio request state.
function palm_brinks_talk.talk_to_pastry_chef(npc: s32, player: s32)
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
		npc_recruit.receive_chestnuts(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_aspiring_chef(npc, player)
		return
	end
end

--- Dispatches the triggered villager's conversation by NPC id, chapter and recruitment request progress.
function palm_brinks_talk.talk_to_villager(npc: s32, player: s32)
	local chapter: s32 = 0
	local npc_id: s32 = 0
	local submap: s32 = 0
	local story_flag: s32 = 0
	local shop_answer: any = 0
	local friend_answer: any = 0
	local main_status_12: s32 = 0
	local request_8_status: s32 = 0
	local answer_12: any = 0
	local main_status_15: s32 = 0
	local request_10_status: s32 = 0
	local answer_15: any = 0
	local main_status_18: s32 = 0
	local request_13_status: s32 = 0
	local answer_18: any = 0
	local request_8_status_33: s32 = 0
	local playable_character: s32 = 0
	local answer_33: any = 0
	event.apply_message_window_preset(0, 0)
	event.set_message_bubble_tail(0, 1)
	chapter = event.get_chapter() or chapter
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.get_current_map()
	submap = event.get_current_submap() or submap
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, npc)
	if npc_id == 3 then
		npc_recruit.talk_gordon(npc, player)
	end
	if npc_id == 5 then
		npc_recruit.talk_parn(npc, player)
	end
	if npc_id == 4 then
		story_flag = event.get_save_flag(104) or story_flag
		if story_flag == 0 then
			event.open_message_window_2(0, "Let me shop\nDig for a scoop")
			shop_answer = cutscene.ask_character_choice(npc, -1, 2, 0, 0, 0)
			if shop_answer < 0 then
				event.set_villager_ai_enabled(1, npc)
				return
			end
			if shop_answer == 1 then
				if scoop_exchange.report_scoops_and_answer_menu(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc)
				return
			else
				palm_brinks_villagers.open_shop_after_greeting()
			end
		else
			event.open_message_window_2(0, "Be my friend!\nDig for a scoop")
			friend_answer = cutscene.ask_character_choice(npc, -1, 2, 0, 0, 0)
			if friend_answer < 0 then
				event.set_villager_ai_enabled(1, npc)
				return
			end
			if friend_answer == 1 then
				if scoop_exchange.report_scoops_and_answer_menu(0) ~= 0 then
					event.fade_out_screen(25)
					wait.frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, npc)
				return
			else
				villager_recruitment.route_request_2_talk(npc, player)
			end
		end
	end
	if npc_id == 7 then
		palm_brinks_talk.talk_to_pastry_chef(npc, player)
	end
	if npc_id == 8 then
		palm_brinks_talk.talk_to_flower_expert(npc, player)
	end
	if npc_id == 10 then
		npc_recruit.talk_butler(npc, player)
	end
	if npc_id == 11 then
		villager_recruitment.route_request_7_talk(npc, player)
	end
	if npc_id == 12 then
		main_status_12 = event.get_quest_request_status(0, 0) or main_status_12
		request_8_status = event.get_quest_request_status(0, 8) or request_8_status
		if main_status_12 == 2 and request_8_status ~= 2 then
			event.set_character_motion(player, "立ち")
			event.open_message_window_2(0, "Hello\nBe my friend!")
			answer_12 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if answer_12 < 0 then
				event.set_villager_ai_enabled(1, npc)
				return
			end
			if answer_12 == 1 then
				villager_recruitment.route_request_8_talk(npc, player)
				event.set_villager_ai_enabled(1, npc)
				return
			end
		end
		if submap == 28 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			villager_recruitment.route_request_8_talk(npc, player)
		end
	end
	if npc_id == 14 then
		villager_recruitment.route_request_9_talk(npc, player)
	end
	if npc_id == 15 then
		main_status_15 = event.get_quest_request_status(0, 0) or main_status_15
		request_10_status = event.get_quest_request_status(0, 10) or request_10_status
		if main_status_15 == 2 and request_10_status ~= 2 then
			event.set_character_motion(player, "立ち")
			event.open_message_window_2(0, "Hello\nBe my friend!")
			answer_15 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if answer_15 < 0 then
				event.set_villager_ai_enabled(1, npc)
				return
			end
			if answer_15 == 1 then
				villager_recruitment.route_request_10_talk(npc, player)
				event.set_villager_ai_enabled(1, npc)
				return
			end
		end
		if submap == 30 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			villager_recruitment.route_request_10_talk(npc, player)
		end
	end
	if npc_id == 16 then
		palm_brinks_talk.talk_to_gerald(npc, player)
	end
	if npc_id == 17 then
		villager_recruitment.route_request_12_talk(npc, player)
	end
	if npc_id == 18 then
		main_status_18 = event.get_quest_request_status(0, 0) or main_status_18
		request_13_status = event.get_quest_request_status(0, 13) or request_13_status
		if main_status_18 == 2 and request_13_status ~= 2 then
			event.set_character_motion(player, "立ち")
			event.open_message_window_2(0, "Hello\nBe my friend!")
			answer_18 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if answer_18 < 0 then
				event.set_villager_ai_enabled(1, npc)
				return
			end
			if answer_18 == 1 then
				npc_recruit.talk_priest(npc, player)
				event.set_villager_ai_enabled(1, npc)
				return
			end
		end
		if submap == 33 then
			palm_brinks_villagers.open_shop_after_greeting()
		else
			npc_recruit.talk_priest(npc, player)
		end
	end
	if npc_id == 19 then
		quest_dialogue.talk_by_request_status(npc, player)
	end
	if npc_id == 20 then
		palm_brinks_talk.talk_to_fisherman(npc, player)
	end
	if npc_id == 21 then
		palm_brinks_talk.talk_to_firbit_npc(npc, player)
	end
	if npc_id == 23 then
		palm_brinks_talk.talk_to_mena(npc, player)
	end
	if npc_id == 24 then
		palm_brinks_talk.talk_to_hide_and_seek_npc(npc, player)
	end
	if npc_id == 25 then
		villager_recruitment.route_request_19_talk(npc, player)
	end
	if npc_id == 33 then
		request_8_status_33 = event.get_quest_request_status(0, 8) or request_8_status_33
		playable_character = event.get_playable_character() or playable_character
		if request_8_status_33 == 1 and playable_character == 0 then
			event.set_character_motion(player, "立ち")
			event.open_message_window_2(0, "Let me shop\nHello")
			answer_33 = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
			if answer_33 < 0 then
				event.set_villager_ai_enabled(1, npc)
				return
			end
			if answer_33 == 1 then
				quest_dialogue.talk_bread_delivery_recipient(npc, player)
				event.set_villager_ai_enabled(1, npc)
				return
			end
		end
		palm_brinks_villagers.open_shop_after_greeting()
	end
	if npc_id == 1 then
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
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	if npc_id == 2 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "If I don't have my hands in\nsomething at all times,\nI get real cranky.")
		else
			event.open_message_window_2(
				0,
				"If they discover Zelmite I'll\nbe real busy too. That's right.\nI'd dig, dig and dig some more!!"
			)
		end
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	if npc_id == 6 then
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
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	if npc_id == 13 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"I love the smell of gunpowder!\nThis job is really made for me.<page>Then again, my boss is awfully\nstubborn and old-fashioned.\nOh, well."
			)
		else
			event.open_message_window_2(0, "You really like all this\nadventure, don't ya.")
		end
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	if npc_id == 22 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"Apart from the fact that I started\nlife as a picture, I'm no different\nthan any other person."
			)
		else
			event.open_message_window_2(0, "I've got a bad feeling about Zelmite Mine.\nJust be careful, okay?")
		end
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, npc)
end

return palm_brinks_talk
