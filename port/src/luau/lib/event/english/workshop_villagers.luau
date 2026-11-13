--!strict
--- Holds the English conversations of the villagers of Gundorada Workshop.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")

local workshop_villagers = {}

--- Plays the conversation of the Gundorada Workshop villager that was talked to, choosing the line by villager type and story flags.
function workshop_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local final_battle_flag: s32 = 0
	local gem_hint_flag: s32 = 0
	local paznos_flag: s32 = 0
	local gaspard_defeated_flag: s32 = 0
	local final_battle_recheck_flag: s32 = 0
	local gem_hint_recheck_flag: s32 = 0
	local paznos_recheck_flag: s32 = 0
	local gaspard_defeated_recheck_flag: s32 = 0
	local fire_squall_defeated_flag: s32 = 0
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
	if villager_type == 400 then
		final_battle_flag = event.get_save_flag(640) or final_battle_flag
		if final_battle_flag == 0 then
			gem_hint_flag = event.get_save_flag(616) or gem_hint_flag
			if gem_hint_flag == 0 then
				paznos_flag = event.get_save_flag(540) or paznos_flag
				if paznos_flag == 0 then
					gaspard_defeated_flag = event.get_save_flag(536) or gaspard_defeated_flag
					if gaspard_defeated_flag == 0 then
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
	if villager_type == 401 then
		final_battle_recheck_flag = event.get_save_flag(640) or final_battle_recheck_flag
		if final_battle_recheck_flag == 0 then
			gem_hint_recheck_flag = event.get_save_flag(616) or gem_hint_recheck_flag
			if gem_hint_recheck_flag == 0 then
				paznos_recheck_flag = event.get_save_flag(540) or paznos_recheck_flag
				if paznos_recheck_flag == 0 then
					gaspard_defeated_recheck_flag = event.get_save_flag(536) or gaspard_defeated_recheck_flag
					if gaspard_defeated_recheck_flag == 0 then
						fire_squall_defeated_flag = event.get_save_flag(520) or fire_squall_defeated_flag
						if fire_squall_defeated_flag == 0 then
							event.open_message_window_2(
								0,
								"Okay, first you've got to \ndestroy the Fire Squall.<page>If we don't do anything about\nthis fire raining down here, \nHeim Rada is done for."
							)
						else
							event.open_message_window_2(
								0,
								"Okay, so that's what happened. I\nguess we should be glad the\nFiresquall is out of the way."
							)
							cutscene.face_each_other(player_slot, villager_id, 0)
							message.say_bubble(0, -1, villager_id, player_slot, 0)
							closing_mode = 1
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
	if villager_type == 402 then
		event.open_message_window_2(0, "Hey there! We got lotsa good stuff\nfor you! So what can I get ya?")
	end
	if villager_type == 403 then
		event.open_message_window_2(0, "You name it, I got it. Any part\nyou need, I'm your man.")
	end
	if villager_type == 404 then
		event.open_message_window_2(
			0,
			"Combat can get pretty deep. You\ncan't just run into every \nsituation guns blazing.<page>If you wanna be cool, you gotta use\nitems too. Find your enemy's\nweakness and exploit it."
		)
	end
	if villager_type == 405 then
		event.open_message_window_2(
			0,
			"There's nothing we can't make here\nat Gundorada Workshop. No matter\nhow big or small, we can do it."
		)
	end
	if villager_type == 406 then
		event.open_message_window_2(
			0,
			"Hey, how'd you guys get in here?\nBetter watch yourself in here. It\ncan get pretty dangerous."
		)
	end
	if villager_type == 407 then
		event.open_message_window_2(0, "What's been going on this whole\ntime? I just can't seem to \nremember, you know.")
	end
	if villager_type == 408 then
		event.open_message_window_2(0, "So, we all got erased by Griffon, huh?\nWhat a terrible monster he must be.")
	end
	if villager_type == 409 then
		event.open_message_window_2(0, "I'm a little busy right now.\nPlease stay out of the way.")
	end
	if villager_type == 410 then
		event.open_message_window_2(0, "We're all rooting for you too.\nWe're behind you 100%.")
	end
	if villager_type == 411 then
		event.open_message_window_2(
			0,
			"Seems the weapons\nin this case\naren't for sale.<page>There really are some\nweird and wonderful weapons\nin the world, though..."
		)
	end
	if villager_type == 412 then
		event.open_message_window_2(
			0,
			"So that guy Gaspard can\nunleash the Fire Squall?<page>He's not just sly...\nHe's truly evil."
		)
	end
	if villager_type == 413 then
		event.open_message_window_2(0, "What's with the heart\non that sign...<page>That's pretty nasty,\nif you ask me...")
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
	if villager_type == 402 then
		menu.open_type_6_alt(30)
	end
	if villager_type == 403 then
		menu.open_type_6_alt(28)
	end
	if villager_type == 404 then
		menu.open_type_6_alt(29)
	end
end

return workshop_villagers
