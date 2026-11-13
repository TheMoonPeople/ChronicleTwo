--!strict
--- Holds the English conversations of the villagers of Starlight Temple.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")

local starlight_temple_villagers = {}

--- Plays the conversation of the Starlight Temple villager that was talked to, choosing the line by villager type and story flags.
function starlight_temple_villagers.talk_to_villager()
	local player_slot: s32 = 0
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	local closing_mode: s32 = 0
	local miracle_dish_flag: s32 = 0
	local dumpling_helped_flag: s32 = 0
	local crest_returned_flag: s32 = 0
	local rescued_flag: s32 = 0
	local final_battle_flag: s32 = 0
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
	miracle_dish_flag = event.get_save_flag(324) or miracle_dish_flag
	dumpling_helped_flag = event.get_save_flag(330) or dumpling_helped_flag
	crest_returned_flag = event.get_save_flag(372) or crest_returned_flag
	rescued_flag = event.get_save_flag(400) or rescued_flag
	final_battle_flag = event.get_save_flag(640) or final_battle_flag
	if villager_type == 200 then
		if final_battle_flag == 0 then
			if dumpling_helped_flag == 0 then
				if miracle_dish_flag == 0 then
					event.open_message_window_2(
						0,
						"To make the miracle dish、I need\na White Windflower.　But I'm all\nout. Sorry I can't help you now."
					)
				else
					event.open_message_window_2(
						0,
						"Have you already tried the\nMiracle Dumpling? They lose effect\nas they cool, so eat 'em quick."
					)
				end
			else
				event.open_message_window_2(
					0,
					"The Miracle Dumpling helped, eh?\nGlad to hear it. Hey, do you want\nsomething to eat before you go?"
				)
			end
		else
			event.open_message_window_2(0, "Oh my, it's just about time, eh?\nWell, here goes nothing, eh?")
		end
	end
	if villager_type == 201 then
		event.open_message_window_2(
			0,
			"Different items have different\neffects. Some can help you. Others\nchange to form weapons...<page>If you try experimenting, you'll\nbe able to beat even the toughest\nof enemies. Try everything you can."
		)
	end
	if villager_type == 202 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"I just can't believe this temple\ngot wiped out by that diabolical \nEmperor Griffon...<page>If only the Great Sage Crest\nwere here..."
			)
		else
			event.open_message_window_2(
				0,
				"With the Great Crest with us once\nagain, there will be nothing to\nfear. Now go, and face Griffon."
			)
		end
	end
	if villager_type == 203 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"This Temple exists in an endless\nnight because the Moon Crystal's\npower is strongest at night.<page>It's utilizing the force of the\ntemple to create an area of night."
			)
		else
			event.open_message_window_2(
				0,
				"May Crest the Great use the power\nof the Moon Crystal to see all\nthat is of this world. <page>There is no escaping the all-\nseeing eyes of Crest."
			)
		end
	end
	if villager_type == 204 then
		event.open_message_window_2(
			0,
			"Howdy. We got a great selection for\nyou. Our weapons are known for\nbeing strong and sturdy."
		)
	end
	if villager_type == 205 then
		if final_battle_flag == 0 then
			if rescued_flag == 0 then
				event.open_message_window_2(0, "Hey! Quit dilly-dallying and show\nthat Griffon who's boss!\nHurry!")
			else
				event.open_message_window_2(
					0,
					"Well, this is the end of the line\nfor me. The rest is up to you. Go\ntake care of that Griffon, ya hear.<page>You saved my life. I know if anyone\ncan do the job, it's you guys."
				)
			end
		else
			event.open_message_window_2(
				0,
				"Looks like your journey has almost\nreached its end. Get that Griffon,\nfor Master, and for us all.<page>You must defeat him no matter what.\nWhen Griffon falls... Crest and\nI... can truly become Great Sages."
			)
		end
	end
	if villager_type == 206 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Even with the temple back to\nnormal, without Crest, Starlight\nTemple is useless. <page>No one but Crest has the immense\nastrological power to survey\nthe whole world."
			)
		else
			event.open_message_window_2(
				0,
				"Even the Great Crest was once the\napprentice of a sage. He must have\nbeen an amazing teacher..."
			)
		end
	end
	if villager_type == 207 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(0, "The food here is first class.\nMakes my mouth water just\nthinking about it.")
		else
			event.open_message_window_2(0, "He made his miracle dish!\nLao Chao really is a great chef!")
		end
	end
	if villager_type == 208 then
		if miracle_dish_flag == 0 then
			event.open_message_window_2(0, "Once you've dined here,\nnothing else will ever taste\nas good. This is so good.")
		else
			event.open_message_window_2(0, "Wow! I'd sure like to\ntry some of those\nMiracle Dumplings too!")
		end
	end
	if villager_type == 209 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"You think the Starglass\nis pretty weird?<page>You're telling me! I've got one as\nwell, but I don't think much of it...\nCertainly never turned back time."
			)
		else
			event.open_message_window_2(
				0,
				"That's great that you guys were\nfriends with Crest the Great Sage.<page>But I didn't realize\nyou were so incredibly close..."
			)
		end
	end
	if villager_type == 210 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"The Great Sage Crest isn't here.\nI wonder where he's gone...<page>We can't help but feel uneasy\nwith him not around."
			)
		else
			event.open_message_window_2(
				0,
				"The Great Crest once told me... \nIn ages past, a man called Gaspard\ntried to destroy this Moon Crystal.<page>And it was the Great Crest's master\nthat risked his life to protect it..."
			)
		end
	end
	if villager_type == 211 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"The Great Crest has disappeared\nwith the Moon Crystal,\nin order to protect it...?<page>I don't understand..."
			)
		else
			event.open_message_window_2(
				0,
				"You've witnessed the massive power\nof the Moon Crystal, right? But\n there is only one who can use it...<page>Crest the Great Sage...<page>There's no way normal people like\nus could ever do anything like\nthat."
			)
		end
	end
	if villager_type == 212 then
		if crest_returned_flag == 0 then
			event.open_message_window_2(
				0,
				"Could you be the ones...? The Great\nCrest told me that one day\na boy and girl would come to me...<page>I just knew this prophecy would\ncome to pass!<page>But unfortunately the Great Sage\nhas disappeared as well."
			)
		else
			event.open_message_window_2(
				0,
				"10,000 years ago?<page>You're telling me the Luna Lab can\naccomplish such a feat that even\nthe Great Crest was incapable of?"
			)
		end
	end
	if villager_type == 213 then
		event.open_message_window_2(
			0,
			"The moon has a strange power\nthat affects all sorts of\nliving things.<page> And it is the Moon Crystal\nthat embodies that power."
		)
	end
	if villager_type == 214 then
		if dumpling_helped_flag == 0 then
			event.open_message_window_2(
				0,
				"If you are looking for the\nworld's best food, you should\nvisit Lao Chao's Bistro!<page>You have heard of it, right?"
			)
		else
			event.open_message_window_2(
				0,
				"So you're the ones. The Great Crest\ntold me about you, and about how a\nlong time ago you saved her life.<page>But, I never would've imagined\nyou were just kids..."
			)
		end
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
	if villager_type == 201 then
		menu.open_type_6_alt(5)
	end
	if villager_type == 204 then
		menu.open_type_6_alt(27)
	end
end

return starlight_temple_villagers
