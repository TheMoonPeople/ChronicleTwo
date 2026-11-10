--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_76f23193 = require("@lib/event/helper_76f23193")

--- Helper function.
local function helper_00c33055()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local argc: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local active_chr_no: s32 = 0
	local player_chara_2: s32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
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
	if var2 == 300 then
		flag = event.get_save_flag(640) or flag
		if flag == 0 then
			flag_2 = event.get_save_flag(456) or flag_2
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"Huh? Who are you...?\nThis is the world's top research facility,\nLunatic Wisdom Laboratory.<page>Although this place may not\nlook like much now,\nwe should be able to finish our research."
				)
			else
				event.open_message_window_2(
					0,
					"Mere words cannot describe the\ngreatness of Luna Lab. You must\nwitness it with your own eyes."
				)
			end
		else
			event.open_message_window_2(
				0,
				"If Griffon isn't dealt with, history\nwill never go back to the way it\nused to be.<page>Griffon's existence itself is\ndistorting the flow of history."
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.get_save_flag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.get_save_flag(408) or flag_4
			if flag_4 == 0 then
				event.open_message_window_2(0, "Haahn, shooo, haahn, shooo.")
				var3 = 2
			else
				argc = event.is_invention_created(309) or argc
				if argc < 0 then
					event.open_message_window_2(
						0,
						"Here are a few hints to help you\ninvent an aquarium. A Wooden Box,\na Window, and a Fountain. You\nhave those in your town, right?"
					)
				else
					var9 = event.get_save_data_value(2) or var9
					if var9 == 0 then
						event.open_message_window_2(
							0,
							'First, feed an "Electric Worm" to a\nfish in an aquarium to electrify\nit. Then, you feed that<page>to the Shigura. You got\nall that, now?'
						)
					else
						event.open_message_window_2(
							0,
							"Ooh, have the fish, do you?\nNow just feed it to the Shigura.\nShouldn't be too hard for you, eh?"
						)
					end
				end
			end
		else
			event.open_message_window_2(
				0,
				"Well! Looks like you did it!\nGuess my invention came through\nfor you, eh. Yes, indeed."
			)
		end
	end
	if var2 == 302 then
		event.open_message_window_2(0, "Whether it's Osmond or the head of the lab,\nthere are just way too many weirdos here.")
	end
	if var2 == 303 then
		flag_5 = event.get_save_flag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.get_save_flag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.get_save_flag(600) or flag_7
				if flag_7 == 0 then
					flag_8 = event.get_save_flag(448) or flag_8
					if flag_8 == 0 then
						event.open_message_window_2(
							0,
							"Take good care of the Shell Talkie,\nnow. That's one of Luna Labs'\nmost important inventions."
						)
					else
						event.open_message_window_2(
							0,
							"There's no time. You have to hurry,\nGriffon's forces are closing in on\nElena, and they won't last long..."
						)
					end
				else
					event.open_message_window_2(0, "I wonder what kind of man this\nGriffon is...")
				end
			else
				event.open_message_window_2(
					0,
					"Looking for gems, eh... Gems are crystals\nof wisdom, forged by the ancients.<page>According to Luna Lab computer\nanalysis, they are hidden in four\nplaces:"
				)
				helper_31bbf01d(player_chara, var1, 0)
				helper_0ffc2526(0, -1, var1, player_chara, 0)
				var3 = 1
				event.open_message_window_2(
					0,
					"Rainbow Butterfly Wood, Starlight\nCanyon, Ocean's Roar Cave, and \nMt. Gundor.<page>There should be a star symbol at\nthe entrance to each location, so\nkeep your eyes peeled."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Alrighty, it's time to put Griffon\nto rest. The fate of the world is\nin your hands. Good luck!"
			)
		end
	end
	if var2 == 304 then
		event.open_message_window_2(
			0,
			"It's all about ability here at this\nlab. With the right ability, even a\nlittle kid could be top dog here."
		)
	end
	if var2 == 305 then
		event.open_message_window_2(
			0,
			"The Luna Stones the Shigura bring\nus help us clear our heads and\nconcentrate on our research.<page>I don't know what the Luna Stones\nare exactly, though..."
		)
	end
	if var2 == 306 then
		event.open_message_window_2(0, "A lab on the ocean is pretty keen,\neh? Do you know how hard I worked\nto get a job here?")
	end
	if var2 == 307 then
		event.open_message_window_2(
			0,
			"What do you think of the design\nof Luna Lab? I wonder who came up\nwith this amusement park concept..."
		)
	end
	if var2 == 308 then
		event.open_message_window_2(
			0,
			"Someday I'm gonna outdo everyone\nand show 'em how smart I am. We're\nall about ability here, you know."
		)
	end
	if var2 == 309 then
		event.open_message_window_2(
			0,
			'I respect the boss a lot, you know.\nYou gotta hand it to a guy who can\nwrite a best-seller 40 volume<page>manual, "The Super Scientist\'s\nBible," at his age.'
		)
	end
	if var2 == 310 then
		event.open_message_window_2(
			0,
			"I'm still kind of a newbie here.\nI'm learning a lot and I want to\nbe a top-notch researcher someday."
		)
	end
	if var2 == 311 then
		event.open_message_window_2(
			0,
			"The view of the sea from this lab\nis amazing.<page>Far off on the horizon,\nthe darkness of the sea and the\ndarkness of the sky exist as one."
		)
	end
	if var2 == 312 then
		event.open_message_window_2(0, "This is Lab Number 2.<page>At Luna Lab,\neach laboratory has its\nown area of research.")
	end
	if var2 == 313 then
		event.open_message_window_2(
			0,
			"Here at Luna Lab, we simulate\na nighttime environment to boost\nthe power of the Luna Stones."
		)
	end
	if var2 == 314 then
		event.open_message_window_2(
			0,
			"When I first started here, I\ncouldn't remember which lab was\nwhich, either. Maybe this'll help.<page>Lab 1 is red, Lab 2 is blue, Lab 3\nis purple, and Lab 4 is green.\nSo every lab has its own color."
		)
	end
	if var2 == 315 then
		event.open_message_window_2(0, "The emblem above the Central Lab\nwas designed after the moon.")
	end
	if var2 == 316 then
		event.open_message_window_2(
			0,
			"I heard that this Lab was completed\nthanks to the Luna Stones a sea\ndragon named Shingala brought here. <page>I guess some of those sea dragons\ncan be pretty smart, eh! "
		)
	end
	if var2 == 317 then
		event.open_message_window_2(
			0,
			"Now you can't tell him I said this,<page> but we've had it up to here with\nOsmond's so-called jokes.\n They make us want to hurl chunks."
		)
	end
	if var2 == 318 then
		event.open_message_window_2(
			0,
			"I can't lie. Yes, I too had a hand\nin the Electric Worm research.\nNow I'm working on a new project.<page> Hey, I can't tell you what it is!\nIt's top secret! I can't just go\nblabbing it to the whole world."
		)
	end
	if var2 == 319 then
		event.open_message_window_2(
			0,
			"What's that? You guys\nwant to be researchers too?<page>It's no piece of cake\ngetting in here, you know.\nThe competition's fierce."
		)
	end
	if var2 == 320 then
		event.open_message_window_2(
			0,
			"Some researchers criticize our\ndesigns here at the Luna Lab. I\nthink they're pretty nifty, myself...<page> At any rate, I seem to be\nin the minority on this matter."
		)
	end
	if var2 == 321 then
		event.open_message_window_2(
			0,
			"We're in the middle of discussing\nsome highly confidential research.<page>Would you mind leaving\n us alone for a while?"
		)
	end
	if var2 == 322 then
		event.open_message_window_2(
			0,
			"I'm terribly sorry, but\nwe're in the middle of discussing\nsome highly confidential research.<page>We can't really talk with\nyou standing there, so..."
		)
	end
	if var2 == 323 then
		event.open_message_window_2(
			0,
			"Dr. Nobb is talented\nof course, but\nhard-working too.<page>I just pale in comparison...\nI'm like an albino..."
		)
	end
	if var2 == 324 then
		event.open_message_window_2(
			0,
			"It's you? I heard you'd had a\ndispute with Dr. Osmond.<page>I'm not criticizing. In fact I\nthink it's great. New discoveries\nare made when we question things."
		)
	end
	if var2 == 325 then
		event.open_message_window_2(
			0,
			"You can't get used to\nthe bright lights, you say?<page>I reckon it'll take you\nvisitors from the past\na little while to adjust."
		)
	end
	if var2 == 326 then
		event.open_message_window_2(
			0,
			"Well, I'm just taking\na bit of a breather.<page> You need to give your brain a rest\nnow and then, or else you start\nlosing your edge."
		)
	end
	if var2 == 327 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 1 then
			event.open_message_window_2(
				0,
				"I heard you're not a bad inventor.\n How about it? When you grow up you\nwant to come and work here with us?<page>Hey, when you become an adult, this\nLuna Lab will have just been built.\n I bet they'd love to have you here."
			)
		else
			event.open_message_window_2(
				0,
				"Don't you think guys who invent\nstuff are just the studliest?<page>But don't go falling in love with\nme, alright? My research is my\nlife. It would never work."
			)
		end
	end
	if var2 == 328 then
		event.open_message_window_2(
			0,
			"I've got a revolutionary new idea.\nIt's a system that would enable\nmonsters to live alongside humans.<page>I shall create a machine that\nunderstands human language."
		)
	end
	if var2 == 329 then
		event.open_message_window_2(
			0,
			"The Luna Stones are the backbone\nof the Luna Lab.<page>Without them, all of our systems\nwould grind to an instant halt."
		)
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
			var16 = out1 or var16
			var18 = out3 or var18
		end
		do
			local out1, _, out3 = event.get_character_position(var1)
			var19 = out1 or var19
			var21 = out3 or var21
		end
		var22 = event.get_look_angle(var19 - var16, var21 - var18) or var22
		helper_76f23193(player_chara_2, var22)
		event.set_character_rotation(player_chara_2, 0.0, var22, 0.0)
		event.set_character_motion(player_chara_2, "立ち")
		helper_0ffc2526(0, -1, var1, player_chara_2, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, var1)
end

return helper_00c33055
