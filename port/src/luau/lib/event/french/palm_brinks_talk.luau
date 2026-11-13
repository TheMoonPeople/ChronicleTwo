--!strict
--- French conversation routing for the NPCs of the Palm Brinks houses.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/french/npc_chatter")
local npc_dialogue = vm.module("@lib/event/french/npc_dialogue")
local npc_recruit = vm.module("@lib/event/french/npc_recruit")
local palm_brinks_quests = vm.module("@lib/event/french/palm_brinks_quests")
local palm_brinks_villagers = vm.module("@lib/event/french/palm_brinks_villagers")
local quest_dialogue = vm.module("@lib/event/french/quest_dialogue")
local scoop_exchange = vm.module("@lib/event/french/scoop_exchange")
local villager_dialogue = vm.module("@lib/event/french/villager_dialogue")
local villager_recruitment = vm.module("@lib/event/french/villager_recruitment")
local wait = vm.module("@lib/event/wait")

local palm_brinks_talk = {}

--- Routes the coin collector's conversation by main quest progress and the coin request state.
function palm_brinks_talk.talk_to_coin_collector(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_about_closed_shop(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 2) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_rare_coins(npc, player)
		return
	end
	if quest_status == 1 then
		palm_brinks_quests.recruit_coin_collector(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_zelmite_hunt(npc, player)
		return
	end
end

--- Routes a Firbit's conversation by main quest progress, a story flag and the Fish Race request state.
function palm_brinks_talk.talk_to_firbit_npc(npc: s32, player: s32)
	local quest_status: s32 = 0
	local story_flag: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	story_flag = event.get_save_flag(424) or story_flag
	if quest_status ~= 2 or story_flag == 0 then
		palm_brinks_villagers.explain_firbit_favours(npc, player)
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
		npc_dialogue.chat_podium_dream(npc, player)
		return
	end
end

--- Routes the old woman's conversation by main quest progress and the request state of her phrase-entry recruitment.
function palm_brinks_talk.talk_to_granny(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_hard_of_hearing(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 19) or quest_status
	if quest_status == 0 then
		villager_recruitment.ask_phrase_to_join(npc, player)
		return
	end
	if quest_status == 1 then
		villager_recruitment.recruit_old_woman(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_old_woman_ends_of_earth(npc, player)
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
		npc_chatter.talk_hide_and_seek_hider_done(npc, player)
		return
	end
end

--- Routes Mena's conversation by a story flag and the time-distortion request state.
function palm_brinks_talk.talk_to_mena(npc: s32, player: s32)
	local story_flag: s32 = 0
	local quest_status: s32 = 0
	story_flag = event.get_save_flag(314) or story_flag
	if story_flag == 0 then
		npc_chatter.talk_sick_villager(npc, player)
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
		palm_brinks_villagers.talk_bug_averse_villager(npc, player)
		return
	end
end

--- Routes the pastry chef's conversation by active character, main quest progress and the Castagnaccio request state.
function palm_brinks_talk.talk_to_pastry_chef(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_candy_maker_monica(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		villager_dialogue.talk_about_cooking(npc, player)
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
		npc_chatter.talk_candy_maker_done(npc, player)
		return
	end
end

--- Routes Stewart's conversation by active character, main quest progress and the book-auction money request state.
function palm_brinks_talk.talk_to_stewart(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_chatter.talk_book_servant_monica(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.offer_help_with_problems(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 6) or quest_status
	if quest_status == 0 then
		villager_recruitment.request_book_auction_funds(npc, player)
		return
	end
	if quest_status == 1 then
		villager_recruitment.collect_auction_funds(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_unread_book(npc, player)
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
		villager_recruitment.route_request_1_talk(npc, player)
	end
	if npc_id == 4 then
		story_flag = event.get_save_flag(104) or story_flag
		if story_flag == 0 then
			event.open_message_window_2(0, "Je veux faire des achats\nC'est parti pour un scoop")
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
			event.open_message_window_2(0, "En route pour l'aventure ?\nC'est parti pour un scoop")
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
				palm_brinks_talk.talk_to_coin_collector(npc, player)
			end
		end
	end
	if npc_id == 7 then
		palm_brinks_talk.talk_to_pastry_chef(npc, player)
	end
	if npc_id == 8 then
		villager_recruitment.route_request_4_talk(npc, player)
	end
	if npc_id == 10 then
		palm_brinks_talk.talk_to_stewart(npc, player)
	end
	if npc_id == 11 then
		villager_recruitment.route_request_7_talk(npc, player)
	end
	if npc_id == 12 then
		main_status_12 = event.get_quest_request_status(0, 0) or main_status_12
		request_8_status = event.get_quest_request_status(0, 8) or request_8_status
		if main_status_12 == 2 and request_8_status ~= 2 then
			event.set_character_motion(player, "立ち")
			event.open_message_window_2(0, "Bonjour\nEn route pour l'aventure ?")
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
			event.open_message_window_2(0, "Bonjour\nEn route pour l'aventure ?")
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
		npc_recruit.talk_gun_fighter(npc, player)
	end
	if npc_id == 17 then
		quest_dialogue.talk_by_request_status(npc, player)
	end
	if npc_id == 18 then
		main_status_18 = event.get_quest_request_status(0, 0) or main_status_18
		request_13_status = event.get_quest_request_status(0, 13) or request_13_status
		if main_status_18 == 2 and request_13_status ~= 2 then
			event.set_character_motion(player, "立ち")
			event.open_message_window_2(0, "Bonjour\nEn route pour l'aventure ?")
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
		villager_recruitment.route_request_14_talk(npc, player)
	end
	if npc_id == 20 then
		npc_recruit.talk_fisherman(npc, player)
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
		palm_brinks_talk.talk_to_granny(npc, player)
	end
	if npc_id == 33 then
		request_8_status_33 = event.get_quest_request_status(0, 8) or request_8_status_33
		playable_character = event.get_playable_character() or playable_character
		if request_8_status_33 == 1 and playable_character == 0 then
			event.set_character_motion(player, "立ち")
			event.open_message_window_2(0, "Je veux faire des achats\nBonjour")
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
				"J'ai du mal depuis quelque temps [UNI00e0]\nvoir les toutes petites pi[UNI00e8]ces.<page>Je dois commencer [UNI00e0] me\nfaire un peu vieux..."
			)
		else
			event.open_message_window_2(
				0,
				"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
			)
		end
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	if npc_id == 2 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(0, "Quand je n'ai rien\n[UNI00e0] faire, je deviens de\nmauvaise humeur.")
		else
			event.open_message_window_2(
				0,
				"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
			)
		end
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	if npc_id == 6 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"Tu sais, j'ai plein de bestioles\ndans les plumes en ce moment,\net [UNI00e7]a me gratte terriblement."
			)
		else
			event.open_message_window_2(
				0,
				"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
			)
		end
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	if npc_id == 13 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
			)
		else
			event.open_message_window_2(0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
		end
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	if npc_id == 22 then
		event.apply_message_window_preset(0, 0)
		if chapter ~= 8 then
			event.open_message_window_2(
				0,
				"[UNI00c0] part le fait que j'ai d[UNI00e9]but[UNI00e9]\nma vie sur une toile, je ne\nsuis pas diff[UNI00e9]rente des autres."
			)
		else
			event.open_message_window_2(0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
		end
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, npc)
end

return palm_brinks_talk
