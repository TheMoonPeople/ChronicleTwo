--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_fd6dee54 = require("@lib/event/helper_fd6dee54")

--- Helper function.
local function helper_88bef1b9(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.get_save_flag(57) or flag
			if flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					arg0,
					"I'm livin' here now,\nbut I'm more worried\nabout Blackstone One.<page>I'm the one who'll be\nkeepin' the train runnin',\njust like old times."
				)
				var4 = event.get_triggered_event_data_2(13) or var4
				helper_1c04a0eb(var4, -1, 0, 0)
				event.open_message_window_2(
					arg0,
					"Borneo's a bit heavy-handed,\nand Erik's just a kid.<page>Nothing but home, work,\nhome and work again every\nday for the likes of me.<page>But that's life, eh..."
				)
			else
				event.open_message_window_2(arg0, "How's Steve doin'?")
			end
		end
		if arg1 == 2 then
			event.open_message_window_2(arg0, "I can't handle just sitting in my\nroom, twiddlin' my thumbs.")
		end
		if arg1 == 3 then
			event.open_message_window_2(
				arg0,
				"Plants and flowers only grow as\nwell as you look after them. I\ncould never neglect my babies."
			)
		end
		if arg1 == 4 then
			event.open_message_window_2(
				arg0,
				"Wonder if the secret base is okay.\nI wish I could ask someone to check\nit out, but it's a secret, you know?"
			)
		end
		if arg1 == 5 then
			event.open_message_window_2(
				arg0,
				"Purple's a great colour.\nIt's got a warm kinda coolness,\nand a bright kinda darkness."
			)
		end
		if arg1 == 6 then
			event.open_message_window_2(arg0, "If someone's sick\nI'll go anywhere to help.")
		end
		if arg1 == 7 then
			event.open_message_window_2(arg0, "Only a top chef can \nmake delicious food \neverywhere he goes.")
		end
		if arg1 == 8 then
			event.open_message_window_2(arg0, "When it comes to houses, the\nsturdier the better, right?")
		end
		if arg1 == 9 then
			event.open_message_window_2(
				arg0,
				"Nuts are pretty good, but those red\nthings were simply scrumptious.\nThink you could bring me some more?"
			)
		end
		if arg1 == 10 then
			event.open_message_window_2(
				arg0,
				"Damp air is a book's worst enemy.\nI don't think I could ever tolerate\nliving near water."
			)
		end
		if arg1 == 11 then
			event.open_message_window_2(arg0, "They're not cute or trendy, but I\nmake clothes that no one else in\nthe world can.")
		end
		if arg1 == 12 then
			event.open_message_window_2(arg0, "A new place, a new me.\nI feel like a young baker again.")
		end
		if arg1 == 13 then
			event.open_message_window_2(arg0, "I don't care what,\nI just wanna smash something\ninto millions of tiny pieces!")
		end
		if arg1 == 14 then
			event.open_message_window_2(arg0, "If you discover a new monster,\nbe sure to report it right away.")
		end
		if arg1 == 15 then
			event.open_message_window_2(
				arg0,
				"Some say it's not for women,\nbut the sword does not care who\nholds it. May the best fighter win."
			)
		end
		if arg1 == 16 then
			event.open_message_window_2(arg0, "This little house might not be a\nbad place to raise a family.")
		end
		if arg1 == 17 then
			event.open_message_window_2(arg0, "I wonder if Morton's staying on the\nball. He has me a bit worried...")
		end
		if arg1 == 18 then
			event.open_message_window_2(arg0, "If you know of a town in need of a\nchurch, I'm your priest. Just let\nme know.")
		end
		if arg1 == 19 then
			event.open_message_window_2(
				arg0,
				"I haven't been thinking about the\nmoon much lately anymore. It must\nbe because of all my new friends."
			)
		end
		if arg1 == 20 then
			event.open_message_window_2(
				arg0,
				"Different place, different fish.\nYou have to change your thinking\nto match the territory."
			)
		end
		if arg1 == 21 then
			event.open_message_window_2(arg0, "This water looks perfect for fish.")
		end
		if arg1 == 22 then
			event.open_message_window_2(
				arg0,
				"Parn's started on another picture\nof a woman. Says this time she'll\nbe prettier than even me."
			)
		end
		if arg1 == 23 then
			event.open_message_window_2(arg0, "I wonder why insects look\nso revolting...")
		end
		if arg1 == 24 then
			event.open_message_window_2(arg0, "Can you make my house any cuter?\nA house can never be too cute,\nyou know!")
		end
		if arg1 == 25 then
			event.open_message_window_2(arg0, "I never imagined I'd be\nmoving at this age.")
		end
	else
		helper_fd6dee54(arg0, arg1)
	end
end

return helper_88bef1b9
