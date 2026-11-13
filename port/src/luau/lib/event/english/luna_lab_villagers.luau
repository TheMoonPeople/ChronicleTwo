--!strict
--- Holds the English conversations of the villagers of Luna Lab.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local luna_lab_villagers = {}

--- Plays the conversation of the Luna Lab villager that was talked to, choosing the line by villager type and story flags.
function luna_lab_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local final_battle_flag: s32 = 0
	local lab_visit_flag: s32 = 0
	local aquarium_done_flag: s32 = 0
	local aquarium_quest_flag: s32 = 0
	local aquarium_invention_status: s32 = 0
	local electric_fish_state: s32 = 0
	local final_battle_recheck_flag: s32 = 0
	local gem_hint_flag: s32 = 0
	local griffon_hint_flag: s32 = 0
	local elena_attack_flag: s32 = 0
	local playable_character: s32 = 0
	local current_player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local look_angle_degrees: f32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hello there.\nGreat weather, isn't it.")
	closing_mode = 0
	if villager_type == 300 then
		final_battle_flag = event.get_save_flag(640) or final_battle_flag
		if final_battle_flag == 0 then
			lab_visit_flag = event.get_save_flag(456) or lab_visit_flag
			if lab_visit_flag == 0 then
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
	if villager_type == 301 then
		aquarium_done_flag = event.get_save_flag(420) or aquarium_done_flag
		if aquarium_done_flag == 0 then
			aquarium_quest_flag = event.get_save_flag(408) or aquarium_quest_flag
			if aquarium_quest_flag == 0 then
				event.open_message_window_2(0, "Haahn, shooo, haahn, shooo.")
				closing_mode = 2
			else
				aquarium_invention_status = event.is_invention_created(309) or aquarium_invention_status
				if aquarium_invention_status < 0 then
					event.open_message_window_2(
						0,
						"Here are a few hints to help you\ninvent an aquarium. A Wooden Box,\na Window, and a Fountain. You\nhave those in your town, right?"
					)
				else
					electric_fish_state = event.get_save_data_value(2) or electric_fish_state
					if electric_fish_state == 0 then
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
	if villager_type == 302 then
		event.open_message_window_2(0, "Whether it's Osmond or the head of the lab,\nthere are just way too many weirdos here.")
	end
	if villager_type == 303 then
		final_battle_recheck_flag = event.get_save_flag(640) or final_battle_recheck_flag
		if final_battle_recheck_flag == 0 then
			gem_hint_flag = event.get_save_flag(616) or gem_hint_flag
			if gem_hint_flag == 0 then
				griffon_hint_flag = event.get_save_flag(600) or griffon_hint_flag
				if griffon_hint_flag == 0 then
					elena_attack_flag = event.get_save_flag(448) or elena_attack_flag
					if elena_attack_flag == 0 then
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
				cutscene.face_each_other(player_slot, villager_id, 0)
				message.say_bubble(0, -1, villager_id, player_slot, 0)
				closing_mode = 1
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
	if villager_type == 304 then
		event.open_message_window_2(
			0,
			"It's all about ability here at this\nlab. With the right ability, even a\nlittle kid could be top dog here."
		)
	end
	if villager_type == 305 then
		event.open_message_window_2(
			0,
			"The Luna Stones the Shigura bring\nus help us clear our heads and\nconcentrate on our research.<page>I don't know what the Luna Stones\nare exactly, though..."
		)
	end
	if villager_type == 306 then
		event.open_message_window_2(0, "A lab on the ocean is pretty keen,\neh? Do you know how hard I worked\nto get a job here?")
	end
	if villager_type == 307 then
		event.open_message_window_2(
			0,
			"What do you think of the design\nof Luna Lab? I wonder who came up\nwith this amusement park concept..."
		)
	end
	if villager_type == 308 then
		event.open_message_window_2(
			0,
			"Someday I'm gonna outdo everyone\nand show 'em how smart I am. We're\nall about ability here, you know."
		)
	end
	if villager_type == 309 then
		event.open_message_window_2(
			0,
			'I respect the boss a lot, you know.\nYou gotta hand it to a guy who can\nwrite a best-seller 40 volume<page>manual, "The Super Scientist\'s\nBible," at his age.'
		)
	end
	if villager_type == 310 then
		event.open_message_window_2(
			0,
			"I'm still kind of a newbie here.\nI'm learning a lot and I want to\nbe a top-notch researcher someday."
		)
	end
	if villager_type == 311 then
		event.open_message_window_2(
			0,
			"The view of the sea from this lab\nis amazing.<page>Far off on the horizon,\nthe darkness of the sea and the\ndarkness of the sky exist as one."
		)
	end
	if villager_type == 312 then
		event.open_message_window_2(0, "This is Lab Number 2.<page>At Luna Lab,\neach laboratory has its\nown area of research.")
	end
	if villager_type == 313 then
		event.open_message_window_2(
			0,
			"Here at Luna Lab, we simulate\na nighttime environment to boost\nthe power of the Luna Stones."
		)
	end
	if villager_type == 314 then
		event.open_message_window_2(
			0,
			"When I first started here, I\ncouldn't remember which lab was\nwhich, either. Maybe this'll help.<page>Lab 1 is red, Lab 2 is blue, Lab 3\nis purple, and Lab 4 is green.\nSo every lab has its own color."
		)
	end
	if villager_type == 315 then
		event.open_message_window_2(0, "The emblem above the Central Lab\nwas designed after the moon.")
	end
	if villager_type == 316 then
		event.open_message_window_2(
			0,
			"I heard that this Lab was completed\nthanks to the Luna Stones a sea\ndragon named Shingala brought here. <page>I guess some of those sea dragons\ncan be pretty smart, eh! "
		)
	end
	if villager_type == 317 then
		event.open_message_window_2(
			0,
			"Now you can't tell him I said this,<page> but we've had it up to here with\nOsmond's so-called jokes.\n They make us want to hurl chunks."
		)
	end
	if villager_type == 318 then
		event.open_message_window_2(
			0,
			"I can't lie. Yes, I too had a hand\nin the Electric Worm research.\nNow I'm working on a new project.<page> Hey, I can't tell you what it is!\nIt's top secret! I can't just go\nblabbing it to the whole world."
		)
	end
	if villager_type == 319 then
		event.open_message_window_2(
			0,
			"What's that? You guys\nwant to be researchers too?<page>It's no piece of cake\ngetting in here, you know.\nThe competition's fierce."
		)
	end
	if villager_type == 320 then
		event.open_message_window_2(
			0,
			"Some researchers criticize our\ndesigns here at the Luna Lab. I\nthink they're pretty nifty, myself...<page> At any rate, I seem to be\nin the minority on this matter."
		)
	end
	if villager_type == 321 then
		event.open_message_window_2(
			0,
			"We're in the middle of discussing\nsome highly confidential research.<page>Would you mind leaving\n us alone for a while?"
		)
	end
	if villager_type == 322 then
		event.open_message_window_2(
			0,
			"I'm terribly sorry, but\nwe're in the middle of discussing\nsome highly confidential research.<page>We can't really talk with\nyou standing there, so..."
		)
	end
	if villager_type == 323 then
		event.open_message_window_2(
			0,
			"Dr. Nobb is talented\nof course, but\nhard-working too.<page>I just pale in comparison...\nI'm like an albino..."
		)
	end
	if villager_type == 324 then
		event.open_message_window_2(
			0,
			"It's you? I heard you'd had a\ndispute with Dr. Osmond.<page>I'm not criticizing. In fact I\nthink it's great. New discoveries\nare made when we question things."
		)
	end
	if villager_type == 325 then
		event.open_message_window_2(
			0,
			"You can't get used to\nthe bright lights, you say?<page>I reckon it'll take you\nvisitors from the past\na little while to adjust."
		)
	end
	if villager_type == 326 then
		event.open_message_window_2(
			0,
			"Well, I'm just taking\na bit of a breather.<page> You need to give your brain a rest\nnow and then, or else you start\nlosing your edge."
		)
	end
	if villager_type == 327 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 1 then
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
	if villager_type == 328 then
		event.open_message_window_2(
			0,
			"I've got a revolutionary new idea.\nIt's a system that would enable\nmonsters to live alongside humans.<page>I shall create a machine that\nunderstands human language."
		)
	end
	if villager_type == 329 then
		event.open_message_window_2(
			0,
			"The Luna Stones are the backbone\nof the Luna Lab.<page>Without them, all of our systems\nwould grind to an instant halt."
		)
	end
	if closing_mode == 0 then
		cutscene.talk(villager_id, -1, 0, 0)
	end
	if closing_mode == 1 then
		message.say_bubble(0, -1, villager_id, player_slot, 0)
		event.set_character_motion(villager_id, "立ち")
		event.finish_event()
	end
	if closing_mode == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		current_player_slot = event.get_player_character_slot() or current_player_slot
		do
			local out1, _, out3 = event.get_character_position(current_player_slot)
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		do
			local out1, _, out3 = event.get_character_position(villager_id)
			villager_x = out1 or villager_x
			villager_z = out3 or villager_z
		end
		look_angle_degrees = event.get_look_angle(villager_x - player_x, villager_z - player_z) or look_angle_degrees
		character.turn_to_angle(current_player_slot, look_angle_degrees)
		event.set_character_rotation(current_player_slot, 0.0, look_angle_degrees, 0.0)
		event.set_character_motion(current_player_slot, "立ち")
		message.say_bubble(0, -1, villager_id, current_player_slot, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, villager_id)
end

return luna_lab_villagers
