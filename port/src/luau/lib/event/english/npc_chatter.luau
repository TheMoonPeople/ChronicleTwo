--!strict
--- Holds the English villager small talk and post-request chatter events.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/english/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/english/palm_brinks_villagers")

local npc_chatter = {}

--- Answers the photo shop menu choice with either a demand for more scoops or an explanation of how ideas and scoops set the Photography level.
function npc_chatter.explain_photography_scoops(window: s32)
	local talk_character_id: s32 = 0
	local player_slot: s32 = 0
	local map_id: s32 = 0
	local menu_status: s32 = 0
	local menu_selection: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		talk_character_id = event.get_triggered_event_data_2(13) or talk_character_id
		player_slot = event.get_player_character_slot() or player_slot
		map_id = event.get_current_map() or map_id
		do
			local out1, out2 = event.get_menu_value_3(6)
			menu_status = out1 or menu_status
			menu_selection = out2 or menu_selection
		end
		if 0 < menu_status then
			return 1
		end
		if menu_selection == 1 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "If you don't bring me more scoops,\nI can't give ya nothin'!")
			if map_id == 22 then
				resume_step = 1
				message.say_bubble(window, -1, talk_character_id, player_slot, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
		end
		if menu_selection == 2 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(
				window,
				"Your Photography level's determined\nby the number of ideas and scoops\nyou have.<page>And as your level goes up, you get\nmore cool items as rewards."
			)
			if map_id == 22 then
				resume_step = 3
				message.say_bubble(window, -1, talk_character_id, player_slot, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
		end
		return 0
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			if resume_step <= 2 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, talk_character_id, player_slot, 0)
			end
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the small talk of the villager who admires the player speed.
function npc_chatter.talk_agile_admirer(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "You're a lot faster\nthan you look.\nYou've surprised me!")
	else
		event.open_message_window_2(0, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the baker once she has joined the party.
function npc_chatter.talk_baker_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Come on Max,\nlet's get going.<page>So where are\nwe off to?")
	else
		event.open_message_window_2(0, "If you're ever in the mood for\nbread, you know where to find me.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the servant after the book request is finished.
function npc_chatter.talk_book_servant_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"The book I got?\nActually, I haven't read it yet.<page>Just getting hold of it\nwas enough to make me happy."
		)
	else
		event.open_message_window_2(0, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the Firbit villager remark that favours go only to the more skilled.
function npc_chatter.talk_firbit_favors(npc: s32, player: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "The Firbit people will only\ngrant favours to people who are\nmore skilled than themselves.")
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the gun fighter once the recruitment request is finished.
function npc_chatter.talk_gun_fighter_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Guns aren't toys.<page>Be careful what you do with\nthem or you might get hurt.")
	else
		event.open_message_window_2(
			0,
			"From now on I'm going to be helping\nNeed and Cedric rebuild the world.\nWe have to work together on this."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the villager who guards the Holy Water secret.
function npc_chatter.talk_holy_water_keeper(npc: s32, player: any)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			event.open_message_window_2(0, "Oh, hello, young lady.\nSomething I can do for you?")
		else
			event.open_message_window_2(0, "Max, don't mention that Holy Water\nto your father, you hear?")
		end
	else
		event.open_message_window_2(0, "There must be so many plants out\nthere we haven't even seen yet.")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the angler hoping to reach the winner podium.
function npc_chatter.talk_podium_hopeful(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "I hope that one day I'll be able\nto stand at the top of the winner's podium too.")
	else
		event.open_message_window_2(
			0,
			"I just wish that Fabio would have\na bit of an interest in something\noutside of fishing, too."
		)
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the small talk of the villager who is excited about the Blackstone Railroad.
function npc_chatter.talk_railroad_fan(npc: s32, player: s32)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			npc_dialogue.greet_monica_about_hair(npc, player)
			return
		end
		event.open_message_window_2(0, "Don't go anywhere too\ndangerous.")
	else
		event.open_message_window_2(0, "At long last the Blackstone\nRailroad takes on the world.\nIt's so exciting!")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the tailor asking how her clothes fit once her request is finished, differing by chapter.
function npc_chatter.talk_tailor_done(npc: s32, player: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "How does it fit?<page>Tell me the truth!")
	else
		event.open_message_window_2(0, "I pray for your safety...")
	end
	cutscene.talk_to_character(npc, -1, 0, 0)
end

--- Plays the tailor, still working as a maid, explaining her dream of becoming a tailor.
function npc_chatter.talk_tailor_dream(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"I'm working here as a maid at the moment,\nbut since I was a child I had a dream of\nbecoming a tailor."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Dreams don't come true,\nso that's why I call it a dream.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Plays the tailor's small talk to Monica, asking her not to put Max in danger, differing by chapter.
function npc_chatter.talk_tailor_monica(npc: s32, player: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Please stop getting Max into\ndangerous situations.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "If I find just one scratch on him,\nI'll never forgive you!")
	else
		event.open_message_window_2(0, "I pray for your safety...")
	end
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Plays the generic villager conversation selected by the villager, the chapter and the story flags.
function npc_chatter.talk_to_villager()
	local villager_character: s32 = 0
	local villager_id: s32 = 0
	local message_group: s32 = 0
	local message_page: s32 = 0
	local speaker_variant: s32 = 0
	local playable_character: s32 = 0
	local chapter: s32 = 0
	local railway_running_flag: s32 = 0
	local monica_returned_flag: s32 = 0
	local playable_character_61: s32 = 0
	local playable_character_80: s32 = 0
	event.get_player_character_slot()
	villager_character = event.get_triggered_event_data_2(13) or villager_character
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	print("talk_chara_id=", villager_character, "talk_chara=", villager_id, "\n")
	do
		local out1, out2 = event.get_message_window_option(0, 3, villager_id)
		message_group = out1 or message_group
		message_page = out2 or message_page
	end
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		speaker_variant = 2
	else
		speaker_variant = 1
	end
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_character)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	if villager_id == 1012 or villager_id == 1015 or villager_id == 1018 then
		palm_brinks_villagers.open_shop_after_greeting()
		event.set_villager_ai_enabled(1, villager_character)
		return
	end
	if villager_id == 50 then
		event.open_message_window_2(0, "Hey! No admittance\nbeyond this point.")
		cutscene.talk_to_character(villager_character, -1, 0, 0)
		event.set_villager_ai_enabled(1, villager_character)
		return
	end
	chapter = event.get_chapter() or chapter
	if chapter == 1 then
		railway_running_flag = event.get_save_flag(9) or railway_running_flag
		if villager_id == 2 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Take a look at that. Hard to\nbelieve this thing used to zoom\nalong, eh?<page>It really did...a long time ago.<page>It's my dream to set off on another\njourney in this thing. That's why I\nmake sure to keep 'er in top shape.<page>That way, if I ever get"
				)
			else
				event.open_message_window_2(
					0,
					"You know how you go to exercise\nevery day or you get all stiff and\nachy? Same thing goes for machines."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 63 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Hey there, Max!\nIt's been ages since the\nrailroad stopped running.<page>But I'm still here patrolling\nthe station, every day."
				)
			else
				event.open_message_window_2(
					0,
					"The Mayor finally got off his duff\nand got the trains going again. But\nthey're still not ready for the public.<page>Boy, I really want to let the\ntownspeople on board..."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 65 then
			if railway_running_flag == 0 then
				event.open_message_window_2(
					0,
					"Hi, Max. Did you know that the\nStationmaster is my dad? We watch\nover this station together.<page>Until the day the railway is back\nup and running..."
				)
			else
				event.open_message_window_2(
					0,
					"The train's running!\nBut it'll take a while before\nthe station's back to normal..."
				)
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
	end
	if chapter == 8 then
		monica_returned_flag = event.get_save_flag(804) or monica_returned_flag
		if villager_id == 61 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"I've been a secret admirer\nof Monica for ages, but I\nain't seen her around lately.<page>That's why I can't seem\nto concentrate on work."
				)
			else
				playable_character_61 = event.get_playable_character() or playable_character_61
				if playable_character_61 ~= 1 then
					event.open_message_window_2(0, "Hey, Max!\nSeems Monica's back.\nEveryone'll be really pleased!")
				else
					event.open_message_window_2(0, "Monica! How've you been?\nI really missed you.")
				end
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
		if villager_id == 80 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"I'd just got to the point where\nI could talk to Monica normally,\nand then she disappeared.<page>Come on Max,\ntell me where she is, will ya?"
				)
			else
				playable_character_80 = event.get_playable_character() or playable_character_80
				if playable_character_80 ~= 1 then
					event.open_message_window_2(0, "Monica's back.\nHow on earth??")
				else
					event.open_message_window_2(0, "Monica, you're back!\nHow on earth??")
				end
			end
			cutscene.talk_to_character(villager_character, -1, 0, 0)
			event.set_villager_ai_enabled(1, villager_character)
			return
		end
	end
	event.open_message_window_2(0, "Hello there.\nGreat weather, isn't it.")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(message_group * 10000) + vm.i32(message_page * 10)) + speaker_variant))
	cutscene.talk_to_character(villager_character, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_character)
end

--- Plays the gardener tending a sick tree, differing by playable character.
function npc_chatter.talk_tree_gardener(npc: s32, player: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.set_character_motion(player, "立ち")
		event.open_message_window_2(0, "Hmm, this tree... It doesn't look\ngood. I've got to do something.")
		message.say_bubble(0, -1, npc, player, 0)
	else
		event.open_message_window_2(
			0,
			"Oh, Max! You scared me.\nI was just taking some nasty bugs\noff this tree.<page>Not all trees grow up fine on\ntheir own, you know. Some, like\nthis one, you have to really watch."
		)
		cutscene.talk_to_character(npc, -1, 0, 0)
	end
end

return npc_chatter
