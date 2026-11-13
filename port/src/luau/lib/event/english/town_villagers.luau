--!strict
--- Holds the English conversations of the villagers living in the player's town.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local partner_talk = vm.module("@lib/event/english/partner_talk")

local town_villagers = {}

--- Opens the message window with the line of the given villager type, using the standard lines before chapter 8 and a different set from chapter 8.
function town_villagers.say_villager_line(window: s32, villager_type: s32)
	local chapter: s32 = 0
	local intro_seen_flag: s32 = 0
	local villager_id: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		if villager_type == 1 then
			intro_seen_flag = event.get_save_flag(57) or intro_seen_flag
			if intro_seen_flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					window,
					"I'm livin' here now,\nbut I'm more worried\nabout Blackstone One.<page>I'm the one who'll be\nkeepin' the train runnin',\njust like old times."
				)
				villager_id = event.get_triggered_event_data_2(13) or villager_id
				cutscene.talk(villager_id, -1, 0, 0)
				event.open_message_window_2(
					window,
					"Borneo's a bit heavy-handed,\nand Erik's just a kid.<page>Nothing but home, work,\nhome and work again every\nday for the likes of me.<page>But that's life, eh..."
				)
			else
				event.open_message_window_2(window, "How's Steve doin'?")
			end
		end
		if villager_type == 2 then
			event.open_message_window_2(window, "I can't handle just sitting in my\nroom, twiddlin' my thumbs.")
		end
		if villager_type == 3 then
			event.open_message_window_2(
				window,
				"Plants and flowers only grow as\nwell as you look after them. I\ncould never neglect my babies."
			)
		end
		if villager_type == 4 then
			event.open_message_window_2(
				window,
				"Wonder if the secret base is okay.\nI wish I could ask someone to check\nit out, but it's a secret, you know?"
			)
		end
		if villager_type == 5 then
			event.open_message_window_2(
				window,
				"Purple's a great colour.\nIt's got a warm kinda coolness,\nand a bright kinda darkness."
			)
		end
		if villager_type == 6 then
			event.open_message_window_2(window, "If someone's sick\nI'll go anywhere to help.")
		end
		if villager_type == 7 then
			event.open_message_window_2(window, "Only a top chef can \nmake delicious food \neverywhere he goes.")
		end
		if villager_type == 8 then
			event.open_message_window_2(window, "When it comes to houses, the\nsturdier the better, right?")
		end
		if villager_type == 9 then
			event.open_message_window_2(
				window,
				"Nuts are pretty good, but those red\nthings were simply scrumptious.\nThink you could bring me some more?"
			)
		end
		if villager_type == 10 then
			event.open_message_window_2(
				window,
				"Damp air is a book's worst enemy.\nI don't think I could ever tolerate\nliving near water."
			)
		end
		if villager_type == 11 then
			event.open_message_window_2(window, "They're not cute or trendy, but I\nmake clothes that no one else in\nthe world can.")
		end
		if villager_type == 12 then
			event.open_message_window_2(window, "A new place, a new me.\nI feel like a young baker again.")
		end
		if villager_type == 13 then
			event.open_message_window_2(window, "I don't care what,\nI just wanna smash something\ninto millions of tiny pieces!")
		end
		if villager_type == 14 then
			event.open_message_window_2(window, "If you discover a new monster,\nbe sure to report it right away.")
		end
		if villager_type == 15 then
			event.open_message_window_2(
				window,
				"Some say it's not for women,\nbut the sword does not care who\nholds it. May the best fighter win."
			)
		end
		if villager_type == 16 then
			event.open_message_window_2(window, "This little house might not be a\nbad place to raise a family.")
		end
		if villager_type == 17 then
			event.open_message_window_2(window, "I wonder if Morton's staying on the\nball. He has me a bit worried...")
		end
		if villager_type == 18 then
			event.open_message_window_2(window, "If you know of a town in need of a\nchurch, I'm your priest. Just let\nme know.")
		end
		if villager_type == 19 then
			event.open_message_window_2(
				window,
				"I haven't been thinking about the\nmoon much lately anymore. It must\nbe because of all my new friends."
			)
		end
		if villager_type == 20 then
			event.open_message_window_2(
				window,
				"Different place, different fish.\nYou have to change your thinking\nto match the territory."
			)
		end
		if villager_type == 21 then
			event.open_message_window_2(window, "This water looks perfect for fish.")
		end
		if villager_type == 22 then
			event.open_message_window_2(
				window,
				"Parn's started on another picture\nof a woman. Says this time she'll\nbe prettier than even me."
			)
		end
		if villager_type == 23 then
			event.open_message_window_2(window, "I wonder why insects look\nso revolting...")
		end
		if villager_type == 24 then
			event.open_message_window_2(window, "Can you make my house any cuter?\nA house can never be too cute,\nyou know!")
		end
		if villager_type == 25 then
			event.open_message_window_2(window, "I never imagined I'd be\nmoving at this age.")
		end
	else
		partner_talk.show_npc_remark(window, villager_type)
	end
end

--- Plays the conversation of the town villager that was talked to, choosing the line by villager type and chapter.
function town_villagers.talk_to_villager()
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	event.get_player_character_slot()
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hello there.\nGreat weather, isn't it.")
	town_villagers.say_villager_line(0, villager_type)
	cutscene.talk(villager_id, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_id)
end

return town_villagers
