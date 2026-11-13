--!strict
--- Holds the English dialogue of the villager recruitment events and request conversations.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/english/npc_chatter")
local npc_dialogue = vm.module("@lib/event/english/npc_dialogue")
local object = vm.module("@lib/event/object")
local palm_brinks_quests = vm.module("@lib/event/english/palm_brinks_quests")
local party = vm.module("@lib/event/party")
local villager_recruitment = vm.module("@lib/event/english/villager_recruitment")
local wait = vm.module("@lib/event/wait")

local npc_recruit = {}

--- Has the girl ask to join the party and, when the player agrees, starts a hide-and-seek by removing her from town.
function npc_recruit.challenge_hide_and_seek(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(0, "Ooh, Max! I've heard that\nyou've been going out of town recently.")
	else
		event.open_message_window_2(0, "Ooh, Monica! I've heard that\nyou've been going out of town recently.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "That's great! Why don't you\ntake me with you?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"I bet you're thinking I won't be\nany use because I'm a girl.<page>But I actually bring people\na lot of luck."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"It never rains when I go out,\nand I've never seen a losing\nlottery ticket.<page>What do you think?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "OK then.\nNo, sorry.")
	choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(npc_character, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if choice ~= 0 then
		event.open_message_window_2(0, "Why! Don't be mean!\nYou're horrible!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "You're useless!<page>You fool!<page>You idiot!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "You'll take me with you?<page>I didn't think you would!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"But how come I'm the only one\nthat has to ask you, when you've\nbeen asking all these other people.<page>If you'd just asked, then of\ncourse I would have helped you."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "I know, if you can find me,\nthen I'll help you. What do you think?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "In other words, let's play hide-and-seek!<page>Right, go!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	wait.frames(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, npc_character)
	event.set_character_active(0, npc_character)
	event.delete_villager(npc_character)
	event.fade_in_screen(30)
	wait.frames(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh well... Looks like you'd better try\n   to find Corinne. She's probably hiding\n   somewhere in Palm Brinks."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

--- Recruits the character when the player holds the required weapon item, otherwise scolds the player for giving up.
function npc_recruit.check_owned_weapon(npc_character: s32, player_character: s32)
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	item_count = event.get_item_count(25) or item_count
	if item_count <= 0 then
		event.open_message_window_2(
			0,
			"What's wrong?\nYou're giving up again?<page>I'm disappointed.\nIs that what comes of tinkering\nwith machines all the time?"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Oh! Looks like you've gotten\npretty good with weapons too!<page>I don't even need to see you shoot.\nI can tell by the way you hold it."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Okay, I'll help you out.\nBut I'm not doing it for you.<page>If this town's in danger,\nI can't just sit\nhere doing nothing."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 11, 1)
end

--- Plays the mayor muttering about the forgotten safe combination, admitting the problem and starting the safe request.
function npc_recruit.explain_safe_problem(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player_character, npc_character)
	event.open_message_window_2(0, "Grumble, grumble...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"What do you mean, what\nam I muttering about?<page>I'm trying to remember the\ncombination for the safe."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"What do you mean,\nwhat safe?<page>The safe hidden behind the\npicture in my office of course..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	character.face_toward(npc_character, player_character)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"Ah, you gave me a fright!<page>Oh, blast!<page>I've gone and let out\nmy biggest secret!<page>Oh well, you know now.<page>Maybe you can give me a\nhand trying to work it out."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "I've got a big problem\nbecause I can't remember the\ncombination for the safe.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "It's a 4-digit number so I used\nClaire's birth date thinking\nthat I'd never forget it.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "How could I possibly forget...<page>What a terrible father I am!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]It looks like the Mayor's very troubled.\n   Listen to what he says about Claire's\n   birthday and figure out the combination."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

--- Judges the length of the player's recorded Nonky catch and recruits the character once it reaches 60 centimeters.
function npc_recruit.judge_nonky_catch(npc_character: s32, player_character: s32)
	local catch_length_meters: f32 = 0
	local length_centimeters: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	catch_length_meters = vm.bits_float(event.get_menu_value(2, 322)) or catch_length_meters
	if catch_length_meters <= 0 then
		event.open_message_window_2(
			0,
			"Hey, I'll bet you've never\nactually caught a Nonky?<page>Ha-ha. You must really stink\nat fishing!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if catch_length_meters < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(catch_length_meters * 100.0))
		event.set_message_number(0, 1, length_centimeters)
		event.open_message_window_2(0, "Ha-ha! You only caught\na [数値１] cm baby!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "You're nowhere near worthy of my help!<page>You'd better start fresh.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "...Oh, I underestimated you.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Well, I'm a man. Men don't need to be told twice.<page>I'll listen to what you say as I promised."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Talk as much as you like!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

--- Judges whether the player's fish race was won and recruits the character when it was.
function npc_recruit.judge_race_result(npc_character: s32, player_character: s32)
	local race_won: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	race_won = event.get_save_flag(41) or race_won
	if race_won == 0 then
		event.open_message_window_2(0, "They say that a fish mirrors its owner.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "There's no way I'll talk to such a \nweak fish's owner.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"I was watching, you know.\nIt was a great race.<page>I doubt that I could've raised\nsuch a good fish.<page>Please take me with you.\nPlease teach me what you know."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

--- Recruits the character once the current counter has grown by 10 since the request started, otherwise has him complain of feeling unwell.
function npc_recruit.judge_recovery_progress(npc_character: s32, player_character: s32)
	local current_counter: s32 = 0
	local start_counter: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		resume_point = 1
		cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
		current_counter = event.get_menu_value_2(0) or current_counter
		start_counter = event.get_save_counter(19) or start_counter
		print("start=", start_counter, ",now=", current_counter, ",clear=", vm.i32(current_counter - start_counter), "\n")
		if vm.i32(current_counter - start_counter) < 10 then
			event.open_message_window_2(0, "I'm still not feeling great.")
			resume_point = 2
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.open_message_window_2(
				0,
				"Maybe there's something\nreally wrong with me?<page>Maybe even Dr. Dell\ncan't help me now..."
			)
			resume_point = 3
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.set_character_motion(npc_character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Hello!<page>How am I feeling? Great!")
		resume_point = 4
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "I can't believe how much better I am recently.<page>Now the world feels right again.")
		resume_point = 5
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Oh yeah, you wanted me to do you a favour.<page>I'll do whatever I can to help.<page>You helped me,\nso I must help you."
		)
		resume_point = 6
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		resume_point = 7
		i04_girard_house.recruit_triggered_villager()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point <= 1 then
				print("start=", start_counter, ",now=", current_counter, ",clear=", current_counter - start_counter, "\n")
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			if resume_point <= 2 then
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			return 0
		end
		if resume_point <= 7 then
			if resume_point <= 4 then
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			if resume_point <= 5 then
				message.show_bubble_and_close(0, -1, npc_character, player_character, 0)
			end
			if resume_point <= 6 then
				party.announce_new_member_alt_default()
			end
			return 0
		end
		return nil
	end)
end

--- Replays the mayor's birthday hints until the player enters the safe combination, then stages the safe opening or failing and recruits the mayor on success.
function npc_recruit.open_mayor_safe(npc_character: s32, player_character: s32)
	local listen_choice: any = 0
	local entry_result: s32 = 0
	local unlock_sound_id: s32 = 0
	local saved_npc_x: f32 = 0
	local saved_npc_y: f32 = 0
	local saved_npc_z: f32 = 0
	local saved_npc_rotation_x: f32 = 0
	local saved_npc_rotation_y: f32 = 0
	local saved_npc_rotation_z: f32 = 0
	local saved_player_x: f32 = 0
	local saved_player_y: f32 = 0
	local saved_player_z: f32 = 0
	local saved_player_rotation_x: f32 = 0
	local saved_player_rotation_y: f32 = 0
	local saved_player_rotation_z: f32 = 0
	local angle_to_npc: f32 = 0
	local saved_camera_x: f32 = 0
	local saved_camera_y: f32 = 0
	local saved_camera_z: f32 = 0
	local saved_look_at_x: f32 = 0
	local saved_look_at_y: f32 = 0
	local saved_look_at_z: f32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	while true do
		event.open_message_window_2(0, "A long time ago I gave her a brooch\nwith her star sign on it.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Holly sorted it out for me so I don't\nreally remember,\nbut I'm sure it was a 4-legged animal..."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"What kind of birthday\npresents have I given her?<page>Hmm...lots of coats\nand scarves I suppose.<page>I never know what to get her.\nIt's a real struggle every year."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Oh yes! Claire's birthday is always a right pain!\nIt's on a day when both burnable and non-burnable\ngarbage get collected.<page>It's my job to put the\ngarbage out in our house."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"Non-burnable garbage gets collected\non days divisible by 7,<page>and burnable garbage gets collected\non days divisible by 3."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "You wouldn't forget that though,\nwould you?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(
			0,
			"I get it! Mystery solved!\nThe combination is...<page>I don't know...Let's listen some more."
		)
		listen_choice = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		if listen_choice == 0 then
			break
		else
			if listen_choice == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(npc_character, "会話")
		end
	end
	event.set_menu_value(0, "Enter the secret code number.", "1221", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		entry_result = out1 or entry_result
	end
	if entry_result == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait.frames(15)
	unlock_sound_id = event.get_sound_id(2) or unlock_sound_id
	do
		local out1, out2, out3 = event.get_character_position(npc_character)
		saved_npc_x = out1 or saved_npc_x
		saved_npc_y = out2 or saved_npc_y
		saved_npc_z = out3 or saved_npc_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(npc_character)
		saved_npc_rotation_x = out1 or saved_npc_rotation_x
		saved_npc_rotation_y = out2 or saved_npc_rotation_y
		saved_npc_rotation_z = out3 or saved_npc_rotation_z
	end
	event.set_character_position(npc_character, -100.0, 0.0, -110.0)
	event.set_character_rotation(npc_character, 0.0, 3.1415927, 0.0)
	event.set_character_motion(npc_character, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		saved_player_x = out1 or saved_player_x
		saved_player_y = out2 or saved_player_y
		saved_player_z = out3 or saved_player_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		saved_player_rotation_x = out1 or saved_player_rotation_x
		saved_player_rotation_y = out2 or saved_player_rotation_y
		saved_player_rotation_z = out3 or saved_player_rotation_z
	end
	angle_to_npc = event.get_arc_tangent(-100.0 - saved_player_x, -110.0 - saved_player_z) or angle_to_npc
	event.set_character_rotation(0, 0.0, angle_to_npc, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		saved_camera_x = out1 or saved_camera_x
		saved_camera_y = out2 or saved_camera_y
		saved_camera_z = out3 or saved_camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		saved_look_at_x = out1 or saved_look_at_x
		saved_look_at_y = out2 or saved_look_at_y
		saved_look_at_z = out3 or saved_look_at_z
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait.frames(30)
	if entry_result == 0 then
		event.set_character_motion(npc_character, "会話")
		event.open_message_window_2(0, "Hmm, it won't open. Oh dear...<page>There are some really important\ndocuments in there...")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.fade_out_screen(15)
		wait.frames(15)
		event.set_character_rotation(0, saved_player_rotation_x, saved_player_rotation_y, saved_player_rotation_z)
		event.set_character_position(npc_character, saved_npc_x, saved_npc_y, saved_npc_z)
		event.set_character_rotation(npc_character, saved_npc_rotation_x, saved_npc_rotation_y, saved_npc_rotation_z)
		event.set_camera_position(saved_camera_x, saved_camera_y, saved_camera_z)
		event.set_camera_look_at(saved_look_at_x, saved_look_at_y, saved_look_at_z)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(0, "Er...Hmm...\n1,<page>2,<page>2,<page>1...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "Wa-hoo!<page>Great,\nit worked!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.attach_object_handle_to_character(0, npc_character)
	event.clear_object_sequence(0, npc_character)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, saved_player_x, saved_player_y, saved_player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(0, "Great! Now I can get my\nimportant documents out!<page>Oh, thank you!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.fade_out_screen(15)
	wait.frames(15)
	event.set_character_rotation(0, saved_player_rotation_x, saved_player_rotation_y, saved_player_rotation_z)
	event.set_character_position(npc_character, saved_npc_x, saved_npc_y, saved_npc_z)
	event.set_character_rotation(npc_character, saved_npc_rotation_x, saved_npc_rotation_y, saved_npc_rotation_z)
	event.set_camera_position(saved_camera_x, saved_camera_y, saved_camera_z)
	event.set_camera_look_at(saved_look_at_x, saved_look_at_y, saved_look_at_z)
	event.fade_in_screen(15)
	wait.frames(15)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"What important documents?<page>Documents that will help Vice Mayor Morton\ndo my job while I'm away.<page>It's a bit of a worry,\nbut I'm sure it'll be okay."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Right, now I'm all set to leave town too.<page>Cedric told me everything.<page>Come on, let's go."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

--- Asks the player to hand over Chestnuts and recruits the cook.
function npc_recruit.receive_chestnuts(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Did you get hold of any Chestnuts?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(301)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 301 then
		event.open_message_window_2(0, "So you can't help...<page>Oh well, better give up on making\nCastagnaccio.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Yes, that's it. Thanks very much.<page>Now I can try to make some Castagnaccio.<page>I'll let you try some as soon as it's ready."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Actually, is there anything I can do in return?<page>What? You want me to go with you on an adventure?<page>Ha-ha! Of course I will.<page>Why didn't you just ask in the first place?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

--- Asks the player to hand over the Golden Paint, brings the painting to life and recruits the magical artist.
function npc_recruit.receive_golden_paint(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"I've been waiting for you.<page>Quick, give me the Paint so that\nI can give life to my picture."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 376 then
		event.open_message_window_2(0, "You must be joking!<page>What I need is Golden Paint.\nGet it right!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "So this is Golden Paint...\nI'll try it straight away.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Sh-she... She's real...<page>Amazing, she's perfect!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Thanks, Max.\nI haven't forgotten my promise. Please use\nmy new power whenever you want.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.set_npc_party_status(22, 130)
	i04_girard_house.show_join_announcement(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

--- Has the baker ask the player to deliver 20 loaves of bread to the shop and hands the player the loaves.
function npc_recruit.request_bread_delivery(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"You want me to\ngo with you?<page>I'm just a woman who bakes bread,\nbut if I can be of any use to you,\nI will gladly."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Oh, but first I've got something\nthat needs delivering to Morton.<page>Would you mind delivering 20 loaves\nof bread to Morton's shop for me?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "While you're doing that,\nI'll pack for the trip.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.add_inventory_item(300, 20)
	inventory.show_obtained_message_for_item_id(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "I wonder what on earth he\ncould want with 20 loaves?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- Has Gordon explain his sick tree and how to recruit him and starts his request, deferring to a hint talk for the second playable character.
function npc_recruit.start_gordon_request(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local notebook_count: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		villager_recruitment.hint_talk_to_gordon(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Oh, Max! You've been moping about\na lot lately. Are you taking care\nof yourself?<page>Something I can do for you?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "What! You want me to go with you\non your adventure?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Hmm... I'd like to go with you...\nBut this poor tree isn't doing\nso well.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Taking care of the trees and the\nflowers on this property is my\nnumber one priority, you know.<page>If I go off roaming about, I could\nlose my job."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"I bet some of the Holy Water that Priest Bruno\nsells at the church would fix this tree!<page>But, as you know, your father\nand Priest Bruno are on bad terms...<page>Your father'd never give me money to buy\nHoly Water from Priest Bruno!<page>I'm in a pickle."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]To get Gordon to Sindain, first you\n   have to get him to join you on\n   your journey.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]If you fulfill Gordon's quest,\n   he'll join you on your journey and\n   get on the train."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]You can check out your quests\n   by reading your Notebook,\n   located on the Item Menu.")
	message.show_and_wait(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(
			0,
			"[(!)]Oh, you don't have a Notebook.\n   There's one on the table\n   inside the Maintenance Shop."
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]There's another one in\n   Donny's hideout. Either will do.\n   Just get hold of one quick!"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Starts the conversation with the butler matching the status of his auction request, with a separate talk for the second playable character and the default talk until the first request is finished.
function npc_recruit.talk_butler(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_dialogue.chat_resembles_elena(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_problem_advice(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 6) or request_status
	if request_status == 0 then
		villager_recruitment.request_book_auction_funds(npc_character, player_character)
		return
	end
	if request_status == 1 then
		villager_recruitment.collect_auction_funds(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_book_servant_done(npc_character, player_character)
		return
	end
end

--- Starts Gordon's conversation matching his state flag and the status of his request.
function npc_recruit.talk_gordon(npc_character: s32, player_character: s32)
	local state_flag: s32 = 0
	local request_status: s32 = 0
	state_flag = event.get_save_flag(42) or state_flag
	if state_flag == 0 then
		npc_chatter.talk_tree_gardener(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status == 0 then
		npc_recruit.start_gordon_request(npc_character, player_character)
		return
	end
	if request_status == 1 then
		palm_brinks_quests.recruit_gordon(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_holy_water_keeper(npc_character, player_character)
		return
	end
end

--- Starts the conversation with the magical artist matching the status of his Golden Paint request, or the default talk until the first request is finished.
function npc_recruit.talk_parn(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.talk_to_parn(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 1) or request_status
	if request_status == 0 then
		villager_recruitment.request_golden_paint(npc_character, player_character)
		return
	end
	if request_status == 1 then
		npc_recruit.receive_golden_paint(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_new_power(npc_character, player_character)
		return
	end
end

--- Starts the conversation with the priest matching the status of his candle puzzle request, or the default talk until the first request is finished.
function npc_recruit.talk_priest(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_prayer_for_peace(npc_character, player_character, 0)
		return
	end
	request_status = event.get_quest_request_status(0, 13) or request_status
	if request_status == 0 then
		villager_recruitment.pose_candle_puzzle(npc_character, player_character)
		return
	end
	if request_status == 1 then
		villager_recruitment.join_after_candle_puzzle(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_world_peace(npc_character, player_character)
		return
	end
end

return npc_recruit
