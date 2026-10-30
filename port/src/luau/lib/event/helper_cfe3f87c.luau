--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_76f23193 = require("@lib/event/helper_76f23193")

--- Helper function.
local function helper_cfe3f87c()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hello there.\nGreat weather, isn't it.")
	var3 = 0
	if var2 == 400 then
		flag = event.get_save_flag(640) or flag
		if flag == 0 then
			flag_2 = event.get_save_flag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.get_save_flag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.get_save_flag(536) or flag_4
					if flag_4 == 0 then
						event.open_message_window_2(
							0,
							"Gaspard's a formidable adversary. \nDon't let your guard down, even \nan instant.<page>I know you can defeat him.\nThe Atlamillia chose you for\na reason..."
						)
					else
						event.open_message_window_2(
							0,
							"Right, Gaspard was unhappy too.<page>What on earth is Griffon up to,\nmessing with people from two eras..."
						)
					end
				else
					event.open_message_window_2(
						0,
						"I'm sure that if anyone can \ndefeat Griffon, you guys can.<page>We're counting on you."
					)
				end
			else
				event.open_message_window_2(
					0,
					"The Chrono Union...  So, the world\nis going to be saved by the wisdom\nof the ancients..."
				)
			end
		else
			event.open_message_window_2(
				0,
				"So, this is it, eh. The blood of\nmany friends has been spilled in\nthe fight against Griffon...<page>You're our last hope! Max, Monica,\nI'm counting on you. You must \ndefeat Griffon!"
			)
		end
	end
	if var2 == 401 then
		flag_5 = event.get_save_flag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.get_save_flag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.get_save_flag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.get_save_flag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.get_save_flag(520) or flag_9
						if flag_9 == 0 then
							event.open_message_window_2(
								0,
								"Okay, first you've got to \ndestroy the Fire Squall.<page>If we don't do anything about\nthis fire raining down here, \nHeim Rada is done for."
							)
						else
							event.open_message_window_2(
								0,
								"Okay, so that's what happened. I\nguess we should be glad the\nFiresquall is out of the way."
							)
							helper_31bbf01d(player_chara, var1, 0)
							helper_0ffc2526(0, -1, var1, player_chara, 0)
							var3 = 1
							event.open_message_window_2(
								0,
								"But I'm worried about your friend\nthat fell into the crater.<page>I guess all we can do now is\nrestore Heim Rada and make the\nWorkshop even better than before."
							)
						end
					else
						event.open_message_window_2(
							0,
							"You defeated Gaspard!\nYou guys are simply amazing!<page>Now for his boss, Emperor Griffon.\nSettle this once and for all!"
						)
					end
				else
					event.open_message_window_2(
						0,
						"I was so happy to see Paznos in action,\ntears ran down my cheeks.<page>Everything we worked so hard\nfor has finally paid off."
					)
				end
			else
				event.open_message_window_2(0, "Gem? Hmm, sorry but, I really\nhave no idea about that stuff.")
			end
		else
			event.open_message_window_2(0, "Time to finally face Griffon, eh?\nGood luck. Go get him!")
		end
	end
	if var2 == 402 then
		event.open_message_window_2(0, "Hey there! We got lotsa good stuff\nfor you! So what can I get ya?")
	end
	if var2 == 403 then
		event.open_message_window_2(0, "You name it, I got it. Any part\nyou need, I'm your man.")
	end
	if var2 == 404 then
		event.open_message_window_2(
			0,
			"Combat can get pretty deep. You\ncan't just run into every \nsituation guns blazing.<page>If you wanna be cool, you gotta use\nitems too. Find your enemy's\nweakness and exploit it."
		)
	end
	if var2 == 405 then
		event.open_message_window_2(
			0,
			"There's nothing we can't make here\nat Gundorada Workshop. No matter\nhow big or small, we can do it."
		)
	end
	if var2 == 406 then
		event.open_message_window_2(
			0,
			"Hey, how'd you guys get in here?\nBetter watch yourself in here. It\ncan get pretty dangerous."
		)
	end
	if var2 == 407 then
		event.open_message_window_2(0, "What's been going on this whole\ntime? I just can't seem to \nremember, you know.")
	end
	if var2 == 408 then
		event.open_message_window_2(0, "So, we all got erased by Griffon, huh?\nWhat a terrible monster he must be.")
	end
	if var2 == 409 then
		event.open_message_window_2(0, "I'm a little busy right now.\nPlease stay out of the way.")
	end
	if var2 == 410 then
		event.open_message_window_2(0, "We're all rooting for you too.\nWe're behind you 100%.")
	end
	if var2 == 411 then
		event.open_message_window_2(
			0,
			"Seems the weapons\nin this case\naren't for sale.<page>There really are some\nweird and wonderful weapons\nin the world, though..."
		)
	end
	if var2 == 412 then
		event.open_message_window_2(
			0,
			"So that guy Gaspard can\nunleash the Fire Squall?<page>He's not just sly...\nHe's truly evil."
		)
	end
	if var2 == 413 then
		event.open_message_window_2(0, "What's with the heart\non that sign...<page>That's pretty nasty,\nif you ask me...")
	end
	if var3 == 0 then
		helper_1c04a0eb(var1, -1, 0, 0)
	end
	if var3 == 1 then
		helper_0ffc2526(0, -1, var1, player_chara, 0)
		event.set_character_motion(var1, "立ち")
		event.finish_event()
	end
	if var3 == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		player_chara_2 = event.get_player_character_slot() or player_chara_2
		do
			local out1, _, out3 = event.get_character_position(player_chara_2)
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.get_character_position(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.get_look_angle(var17 - var14, var19 - var16) or var20
		helper_76f23193(player_chara_2, var20)
		event.set_character_rotation(player_chara_2, 0.0, var20, 0.0)
		event.set_character_motion(player_chara_2, "立ち")
		helper_0ffc2526(0, -1, var1, player_chara_2, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, var1)
	if var2 == 402 then
		helper_59a16271(30)
	end
	if var2 == 403 then
		helper_59a16271(28)
	end
	if var2 == 404 then
		helper_59a16271(29)
	end
end

return helper_cfe3f87c
