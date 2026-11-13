--!strict
--- Holds the English dialogue and events of the town residents who can join the party.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/english/npc_chatter")
local object = vm.module("@lib/event/object")
local palm_brinks_villagers = vm.module("@lib/event/english/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local quest_dialogue = vm.module("@lib/event/english/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/english/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local npc_dialogue = {}

--- Has the villager greet Max or Monica by name and ask to be taken along on trips outside town.
function npc_dialogue.ask_to_join_party(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "Ooh, Max! I've heard that\nyou've been going out of town recently.")
	else
		event.open_message_window_2(0, "Ooh, Monica! I've heard that\nyou've been going out of town recently.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "That's great! Why don't you\ntake me with you?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Plays chatter about the circus performance and the mine, depending on the chapter.
function npc_dialogue.chat_about_circus(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"So you saw me at the circus?\nPretty cool, right?<page>It's not so much a job\nas a hobby of mine."
		)
	else
		event.open_message_window_2(0, "So, what's the scoop? Come across\nany tough guys in that mine yet?")
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays chatter about discoveries and cooking research.
function npc_dialogue.chat_about_cooking(npc_slot: s32, player_slot: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Made any good discoveries?<page>You know, while you're making discoveries\nabout machines and devices,\nI'm making discoveries about cooking.<page>Every day, I'm researching how to make\ndelicious foods that no one's ever\ntasted before."
	)
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays chatter about fishing tricks and new fishing spots, depending on the chapter.
function npc_dialogue.chat_about_fishing(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Um, I don't need to know right this instant,\nbut maybe one day you could let me\nin on your fishing tricks."
		)
	else
		event.open_message_window_2(
			0,
			"I can't wait to check out all the\nnew fishing spots all over the\nworld. It's gonna be so fun."
		)
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays the prayer for world peace in chapter 8 and otherwise the remark that a good cause needs wisdom.
function npc_dialogue.chat_about_world_peace(npc_slot: s32, player_slot: s32)
	npc_dialogue.chat_prayer_for_peace(npc_slot, player_slot, 1)
end

--- Plays amazed praise for Max outside chapter 8 (deferring to a separate remark when Monica leads) and asks how the Zelmite hunt is going in chapter 8.
function npc_dialogue.chat_about_zelmite_hunt(npc_slot: s32, player_slot: s32)
	local chapter: s32 = 0
	local active_character: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		active_character = event.get_playable_character() or active_character
		if active_character == 1 then
			palm_brinks_villagers.talk_about_max_absence(npc_slot, player_slot)
			return
		end
		event.apply_message_window_preset(0, 0)
		event.open_message_window_2(
			0,
			"I can't believe it. I never\nreally imagined you could get them.<page>That's really something, Max!"
		)
	else
		event.open_message_window_2(0, "Hey! How goes the Zelmite hunt?\nIf there's anything I can do,\njust gimme a holler.")
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Has the villager dislike women wielding swords and praise ladylike women, with an offer of help in the final chapter.
function npc_dialogue.chat_armed_women(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"I don't really like to see a\nwoman waving a sword around.<page>The best women are the ladylike\nones. Take Adel, for example."
		)
	else
		event.open_message_window_2(0, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager talk about becoming the world's best chef, with a different line once the story reaches the final chapter.
function npc_dialogue.chat_aspiring_chef(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Of course I'd never refuse\nyou anything.")
	else
		event.open_message_window_2(0, "I'm going to be the world's best\nchef someday, and when I do,\nyou can eat free anytime.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager say they are busy gathering materials for the town's safety and ask the player to wait until tomorrow.
function npc_dialogue.chat_busy_with_materials(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Hey, Max.\nSorry, but I'm a bit\ntied up right now.<page>I'm in the middle of\ngetting important materials\nto keep this town safe."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "If it's not urgent,\ncan it wait until tomorrow?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Has the villager complain of feeling unwell although the doctor finds nothing wrong.
function npc_dialogue.chat_feeling_unwell(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "I've not been feeling too good lately.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"I got Dr. Dell to come and have a look at me,\nbut he said there's nothing wrong.<page>I wonder why?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Has the villager talk about fishing as a hobby and the dream of catching a giant fish.
function npc_dialogue.chat_fishing_hobby(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"My hobby is fishing.<page>It's my dream to catch a Mardan Karayan.<page>I only respect people who catch big fish."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager say they are hard of hearing and can only follow slow speech.
function npc_dialogue.chat_hard_of_hearing(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"...<page>Ah! Hello!\nI've been a bit deaf lately.<page>I can't make out what you're\nsaying unless you speak slowly."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager wonder why the moon is so missed and if the villager came from there.
function npc_dialogue.chat_moon_longing(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Why do I miss the moon so much?<page>I wonder if that's where I\ncame from...")
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager thank the player for the moon photo and look forward to the railroad in the final chapter.
function npc_dialogue.chat_moon_photo_thanks(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "You gave me this photo of the moon.\nYou're a good human.")
	else
		event.open_message_window_2(
			0,
			"If the Blackstone Railroad goes all\nover the world, we'll be able to\nvisit lots of cool new places."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager mutter number sequences while ignoring the player, then shows a hint to come back later.
function npc_dialogue.chat_muttering_numbers(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Grumble, grumble...")
	message.wait_facing_character(npc_character)
	event.open_message_window_2(0, "...1212,<page>No, no, I'm sure it was 1122.<page>Or maybe it was 1010.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Grumble, grumble...")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]If he doesn't even notice you \n   trying to say, \"Hello.\" He must \n   have some pretty serious problems.<page>[(!)]Why don't you try back later?\n   Maybe you could lend him a hand or\n   an ear or something."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has the magical artist offer the use of his new power, with a remark about the world of pictures in the final chapter.
function npc_dialogue.chat_new_power(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Please use my new power\nwhenever you want.")
	else
		event.open_message_window_2(
			0,
			"The world of pictures is very deep.\nIt may take me a lifetime to master\nbut the journey is well worth it."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager pray for world peace or speak of wisdom, depending on the chapter and whether the villager's own request is completed.
function npc_dialogue.chat_prayer_for_peace(npc_character: s32, player_character: any, request_completed: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if request_completed ~= 0 and chapter == 8 then
		event.open_message_window_2(0, "I pray that the world will\nfrom today forever be at peace.")
	else
		event.open_message_window_2(0, "When you're striving for a good cause,\nyou must have wisdom.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager invite the player to bring any problem to them first.
function npc_dialogue.chat_problem_advice(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "If you have any kind of problem,\nmake sure you come to me first.")
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager say the player resembles Elena, with a warning about Zelmite Mine in the final chapter.
function npc_dialogue.chat_resembles_elena(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Maybe I'm the only one to think this, but something\nabout you really reminds me of Elena.<page>I don't know what it is, but you have a certain quality\nthat seems different to other people in this town."
		)
	else
		event.open_message_window_2(0, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Checks the stopwatch time of the player's run to the boat and recruits the villager when it beats the record.
function npc_dialogue.check_boat_run_time(npc_character: s32, player_character: s32)
	local minutes: s32 = 0
	local seconds: s32 = 0
	local hundredths: s32 = 0
	local beat_record: s32 = 0
	local run_state: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		minutes = out1 or minutes
		seconds = out2 or seconds
		hundredths = out3 or hundredths
		beat_record = out4 or beat_record
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	run_state = event.get_save_counter(7) or run_state
	if run_state == 0 then
		event.open_message_window_2(0, "Hey there, Max.\nYou come to try again?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if run_state == 1 then
		event.open_message_window_2(0, "Oy! You didn't get to the boat,\ndid you? You tried to trick me.\nDon't cheat!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Giving it another try?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "Hey, no cheating!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Giving it another try?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "Oh, you're back!\nRight,<page>Let's check\nyour time!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, hundredths)
	if beat_record == 0 then
		event.open_message_window_2(0, "Oh Dear!\n[数値１] minutes [数値２].[数値３] seconds is\ntoo slow.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Giving it another try?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "Oh!\n[数値１] minutes [数値２] seconds [数値３]\nisn't a bad time!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "You're a lot faster than you look. Okay,\nlet's go and fight the bad guys together!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

--- The baker checks whether the bread delivery to Morton is done, trades the 20 loaves for 20 of another item and joins the party.
function npc_dialogue.complete_baker_request(npc_slot: s32, player_slot: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage < 3 then
		event.open_message_window_2(0, "Sorry, I'm still\nnot ready.<page>Can you give me\na little longer?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "By the way, have you been\nto Morton's for me yet?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "What! How can he be\nso inconsiderate?<page>Oh well,\nyou have them.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Never mind that,\nlet's get going.<page>So where are\nwe off to?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

--- Greets Monica with the hair greeting when she leads, otherwise checks Max's flower photos, then praises them and joins the party or asks to see an unusual flower.
function npc_dialogue.complete_flower_photo_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local photo_count_2009: s32 = 0
	local photo_count_52: s32 = 0
	local photo_count_53: s32 = 0
	local photo_count_54: s32 = 0
	local photo_count_55: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	photo_count_2009 = event.get_photo_count_of_subject(2009) or photo_count_2009
	photo_count_52 = event.get_photo_count_of_subject(52, 3) or photo_count_52
	photo_count_53 = event.get_photo_count_of_subject(53, 3) or photo_count_53
	photo_count_54 = event.get_photo_count_of_subject(54, 3) or photo_count_54
	photo_count_55 = event.get_photo_count_of_subject(55, 3) or photo_count_55
	if vm.i32(vm.i32(vm.i32(vm.i32(photo_count_2009 + photo_count_52) + photo_count_53) + photo_count_54) + photo_count_55) <= 0 then
		event.open_message_window_2(
			0,
			"Did you get a picture of an unusual flower?<page>I know a lot about flowers, so if it's\nnothing special it won't interest me."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Did you get a picture of an unusual flower?\nLet's see, let's see!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Wow! This is amazing!\nSo these are the kind of flowers on the outside.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Hmm... what should I do?<page>Oh, okay! Take me with you!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Gordon asks Max for Holy Water to fix the tree, joins the party, explains party and train management and completes request 0.
function npc_dialogue.complete_gordon_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local used_item: s32 = 0
	local npc_id: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_dialogue.hint_talk_to_gordon(npc_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Max, fixing this tree is my number\none priority.<page>Now, what I need to fix this\ntree...")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_use_item_menu(276)
	vm.wait(4)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 276 then
		event.open_message_window_2(0, "Max, this just won't work.<page>What I need is Holy Water from\nPriest Bruno.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Yes! Max, you've done it! Now\nI can take care of this tree!<page>Thank you, Max.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"My work is all taken care of\nfor now.<page>Now I can go with you on your\nadventure!<page>Oh, and don't mention that Holy\nWater to you father, you hear?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon joined your party.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]You can use his abilities\n   from the Status command under\n   Characters on the Main Menu.<page>[(!)]If you recruit someone else\n   to join your adventure, that\n   person will get on the train."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Talk to that person inside\n   the train to switch him or her\n   in as your third party member.<page>[(!)]To move one of your train friends\n   into a house, choose Move Person\n   from the door menu of that house."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]There may be many others\n   willing to join your party.\n   Be sure to look for them!")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.set_npc_party_status(npc_id, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

--- Mena reports whether enough stages were cleared since request 17 began and joins the party once ten were cleared.
function npc_dialogue.complete_mena_request(npc_slot: s32, player_slot: s32)
	local current_clear_count: s32 = 0
	local start_clear_count: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		checkpoint = 1
		cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
		current_clear_count = event.get_menu_value_2(0) or current_clear_count
		start_clear_count = event.get_save_counter(19) or start_clear_count
		print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", vm.i32(current_clear_count - start_clear_count), "\n")
		if vm.i32(current_clear_count - start_clear_count) < 10 then
			event.open_message_window_2(0, "I'm still not feeling great.")
			checkpoint = 2
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.open_message_window_2(
				0,
				"Maybe there's something\nreally wrong with me?<page>Maybe even Dr. Dell\ncan't help me now..."
			)
			checkpoint = 3
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.set_character_motion(npc_slot, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "Hello!<page>How am I feeling? Great!")
		checkpoint = 4
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "I can't believe how much better I am recently.<page>Now the world feels right again.")
		checkpoint = 5
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Oh yeah, you wanted me to do you a favour.<page>I'll do whatever I can to help.<page>You helped me,\nso I must help you."
		)
		checkpoint = 6
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		checkpoint = 7
		party.add_talked_npc()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", current_clear_count - start_clear_count, "\n")
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 2 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			return 0
		end
		if checkpoint <= 7 then
			if checkpoint <= 4 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 5 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 6 then
				party.announce_new_member_alt_default()
			end
			return 0
		end
		return nil
	end)
end

--- Parn takes the Golden Paint from Max, joins the party and completes request 1.
function npc_dialogue.complete_parn_request(npc_slot: s32, player_slot: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"I've been waiting for you.<page>Quick, give me the Paint so that\nI can give life to my picture."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 376 then
		event.open_message_window_2(0, "You must be joking!<page>What I need is Golden Paint.\nGet it right!")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "So this is Golden Paint...\nI'll try it straight away.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Sh-she... She's real...<page>Amazing, she's perfect!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Thanks, Max.\nI haven't forgotten my promise. Please use\nmy new power whenever you want.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.set_npc_party_status(22, 130)
	party.announce_member_joined(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

--- Walks through the safe's secret code puzzle, tests the code Max enters and joins the party once the safe opens.
function npc_dialogue.complete_safe_code_request(npc_slot: s32, player_slot: s32)
	local selection: any = 0
	local code_result: s32 = 0
	local unlock_sound_id: s32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation_x: f32 = 0
	local npc_rotation_y: f32 = 0
	local npc_rotation_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_y: f32 = 0
	local player_rotation_z: f32 = 0
	local angle_toward_safe: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	while true do
		event.open_message_window_2(0, "A long time ago I gave her a brooch\nwith her star sign on it.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Holly sorted it out for me so I don't\nreally remember,\nbut I'm sure it was a 4-legged animal..."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"What kind of birthday\npresents have I given her?<page>Hmm...lots of coats\nand scarves I suppose.<page>I never know what to get her.\nIt's a real struggle every year."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Oh yes! Claire's birthday is always a right pain!\nIt's on a day when both burnable and non-burnable\ngarbage get collected.<page>It's my job to put the\ngarbage out in our house."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Non-burnable garbage gets collected\non days divisible by 7,<page>and burnable garbage gets collected\non days divisible by 3."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "You wouldn't forget that though,\nwould you?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.open_message_window_2(
			0,
			"I get it! Mystery solved!\nThe combination is...<page>I don't know...Let's listen some more."
		)
		selection = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		if selection == 0 then
			break
		else
			if selection == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(npc_slot, "会話")
		end
	end
	event.set_menu_value(0, "Enter the secret code number.", "1221", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		code_result = out1 or code_result
	end
	if code_result == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait.frames(15)
	unlock_sound_id = event.get_sound_id(2) or unlock_sound_id
	do
		local out1, out2, out3 = event.get_character_position(npc_slot)
		npc_x = out1 or npc_x
		npc_y = out2 or npc_y
		npc_z = out3 or npc_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(npc_slot)
		npc_rotation_x = out1 or npc_rotation_x
		npc_rotation_y = out2 or npc_rotation_y
		npc_rotation_z = out3 or npc_rotation_z
	end
	event.set_character_position(npc_slot, -100.0, 0.0, -110.0)
	event.set_character_rotation(npc_slot, 0.0, 3.1415927, 0.0)
	event.set_character_motion(npc_slot, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		player_rotation_x = out1 or player_rotation_x
		player_rotation_y = out2 or player_rotation_y
		player_rotation_z = out3 or player_rotation_z
	end
	angle_toward_safe = event.get_arc_tangent(-100.0 - player_x, -110.0 - player_z) or angle_toward_safe
	event.set_character_rotation(0, 0.0, angle_toward_safe, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait.frames(30)
	if code_result == 0 then
		event.set_character_motion(npc_slot, "会話")
		event.open_message_window_2(0, "Hmm, it won't open. Oh dear...<page>There are some really important\ndocuments in there...")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.fade_out_screen(15)
		wait.frames(15)
		event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
		event.set_character_position(npc_slot, npc_x, npc_y, npc_z)
		event.set_character_rotation(npc_slot, npc_rotation_x, npc_rotation_y, npc_rotation_z)
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(0, "Er...Hmm...\n1,<page>2,<page>2,<page>1...")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "Wa-hoo!<page>Great,\nit worked!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.attach_object_handle_to_character(0, npc_slot)
	event.clear_object_sequence(0, npc_slot)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, player_x, player_y, player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(0, "Great! Now I can get my\nimportant documents out!<page>Oh, thank you!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.fade_out_screen(15)
	wait.frames(15)
	event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
	event.set_character_position(npc_slot, npc_x, npc_y, npc_z)
	event.set_character_rotation(npc_slot, npc_rotation_x, npc_rotation_y, npc_rotation_z)
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.fade_in_screen(15)
	wait.frames(15)
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(
		0,
		"What important documents?<page>Documents that will help Vice Mayor Morton\ndo my job while I'm away.<page>It's a bit of a worry,\nbut I'm sure it'll be okay."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Right, now I'm all set to leave town too.<page>Cedric told me everything.<page>Come on, let's go."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

--- Takes sturdy cloth, thick hide and a copper lump from the player so the seamstress can start making clothes, then removes her from the scene.
function npc_dialogue.deliver_tailoring_materials(npc_character: s32, player_character: s32)
	local sturdy_cloth_count: s32 = 0
	local thick_hide_count: s32 = 0
	local copper_lump_count: s32 = 0
	local answer: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	sturdy_cloth_count = event.get_item_count(214) or sturdy_cloth_count
	thick_hide_count = event.get_item_count(245) or thick_hide_count
	copper_lump_count = event.get_item_count(227) or copper_lump_count
	if sturdy_cloth_count <= 0 or thick_hide_count <= 0 or copper_lump_count <= 0 then
		event.open_message_window_2(
			0,
			"Without the materials,\nI can't make anything.<page>I need Sturdy Cloth,\nThick Hide and a Copper Lump.<page>Sorry to be\nsuch a bother."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Here, have these!\nIt seems a bit of a waste.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Without the materials,\nI can't make anything.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(214)
	event.remove_item(245)
	event.remove_item(227)
	event.set_save_counter(8, 2)
	event.open_message_window_2(0, "Thanks very much!\nNow I'll try making some clothes!<page>I won't let these go to waste.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, npc_character)
	event.set_character_active(0, npc_character)
	event.delete_villager(npc_character)
	event.finish_event()
	event.fade_in_screen(30)
end

--- Has the villager explain the speed test of running to the boat and back, then offers an attempt.
function npc_dialogue.explain_boat_run_test(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Hey Max, have you come looking for me?<page>I've been waiting.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Thanks to the castle walls,\nthis town is pretty safe.<page>It's time for us to go outside.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "It's good that you're always\ntinkering about with machines,\nbut I wonder how strong you are?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Fighting's all about\nspeed and footwork.<page>If you're any slower than me,\nit's no good.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Why don't we give you a test.\nRun to the boat at the lake and back.<page>My record is 2 minutes 1 second.\nIf you're any slower than that,\nit's no good."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 9, 1)
	event.open_message_window_2(0, "How about it, you want to try?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	npc_dialogue.offer_boat_run(npc_character, player_character)
end

--- Greets Monica as Max's girlfriend and compliments her hair.
function npc_dialogue.greet_monica_about_hair(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Hi! Are you Max's\ngirlfriend?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Your hair's a really unusual colour.\nLike Erik's, but different...<page>Yours is really pretty,\nlike a jewel."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.finish_event()
end

--- Plays the remark about the ailing tree and the hint that Monica must talk to Gordon to get his attention.
function npc_dialogue.hint_talk_to_gordon(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_slot, "立ち")
	event.open_message_window_2(0, "Hmm, this tree... It doesn't look\ngood. I've got to do something.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Looks like you have to talk to\n   Gordon to get his attention.")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

--- Asks whether the player wants to try the boat run and starts the stopwatch when accepted.
function npc_dialogue.offer_boat_run(npc_character: s32, player_character: s32)
	local answer: any = 0
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Sure, I'll give it a try.\nI'm not up to it.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Okay...<page>Okay, if you wanna try again later,\njust let me know. I'll be waiting.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(7, 0)
		return
	end
	event.open_message_window_2(0, "Ready, steady,\ngo!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.control_stopwatch(3, 32, 364, 0)
	event.control_stopwatch_1(0)
	event.set_save_counter(7, 1)
end

--- Has the villager pose the church candle puzzle as a test of wisdom and starts the quest request.
function npc_dialogue.pose_candle_puzzle(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Really? You need my help?<page>Then let me pose you a problem.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"The candles in this church are\ncontrolled by a small mechanism.<page>When they're lit it puts them out,\nand when they're out it lights them.<page>If one of them changes,\nthe adjacent candles change too."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"If you can put all the candles out successfully,\nit'll prove your wisdom, and I'll go with you.<page>If you solve it, great! If not,\nplease understand that I cannot help you."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]This is another puzzler. Give\n   it a few attempts, and make use\n   of what you learn each time."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]If you re-enter the church,\n   the candles will be reset.\n   So don't worry about going wrong.\n   The answer could be simple."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Checks whether the player has won the fish race and recruits the fish keeper if so.
function npc_dialogue.recruit_after_fish_race(npc_character: s32, player_character: s32)
	local story_flag: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	story_flag = event.get_save_flag(41) or story_flag
	if story_flag == 0 then
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

--- Counts how often the hiding villager is found and recruits the villager once the game of hide-and-seek is over.
function npc_dialogue.recruit_after_hide_and_seek(npc_character: s32, player_character: s32)
	local times_found: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	times_found = event.get_save_counter(11) or times_found
	if times_found < 1 then
		event.open_message_window_2(0, "Oh! You found me!<page>But can you find me again?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(11, times_found + 1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, npc_character)
		event.set_character_active(0, npc_character)
		event.delete_villager(npc_character)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"Oh! You found me...<page>I'm getting a bit fed up with this now.<page>Hiding is actually\nreally boring.<page>Oh well! Let's go off on\nour adventure then!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

--- The hard-of-hearing grandmother starts request 19, asks Max to enter "Let's go together." and joins the party when he does.
function npc_dialogue.recruit_grandmother(npc_slot: s32, player_slot: s32)
	npc_dialogue.recruit_hard_of_hearing_woman(npc_slot, player_slot)
end

--- Asks the hard-of-hearing old woman to join through a "go together" menu choice and recruits her on the right answer.
function npc_dialogue.recruit_hard_of_hearing_woman(npc_character: s32, player_character: s32)
	local menu_selection: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "What was that?<page>Can't you talk a bit more slowly?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Please enter, "Let\'s go together."', "Let's go together.", 0)
	event.open_event_menu(5)
	vm.wait(3)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		menu_selection = out1 or menu_selection
	end
	if menu_selection == -1 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if menu_selection == 0 then
		event.open_message_window_2(0, "What are you going on about?\nI've no idea...")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "An adventure?\nThat would be nice.<page>What use could an old\nwoman like me be?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

--- Asks the player to hand over a chestnut and recruits the villager when the right item is used.
function npc_dialogue.recruit_with_chestnut(npc_character: s32, player_character: s32)
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

--- Checks whether the player has photographed the moon and, if so, recruits the moon-loving villager into the party.
function npc_dialogue.recruit_with_moon_photo(npc_character: s32, player_character: s32)
	local moon_photo_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	moon_photo_count = event.get_photo_count_of_subject(193) or moon_photo_count
	if moon_photo_count <= 0 then
		event.open_message_window_2(
			0,
			"I thought you might be different,\nbut no, humans are humans.<page>No matter. I've got used to you\nhumans telling lies all the time."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Wow, amazing! There's a moon in this photo.<page>Now I can see the moon any time, any place.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Come with you?<page>Of course I will.\nI've nowhere else to go.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

--- Checks the length of the player's caught Nonky and recruits the fisherman if it is long enough.
function npc_dialogue.recruit_with_nonky_catch(npc_character: s32, player_character: s32)
	local fish_length: f32 = 0
	local length_centimeters: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	fish_length = vm.bits_float(event.get_menu_value(2, 322)) or fish_length
	if fish_length <= 0 then
		event.open_message_window_2(
			0,
			"Hey, I'll bet you've never\nactually caught a Nonky?<page>Ha-ha. You must really stink\nat fishing!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if fish_length < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(fish_length * 100.0))
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

--- Asks for the Dark Coin and the Indestructible Coin, takes them after confirmation and recruits the coin collector.
function npc_dialogue.recruit_with_rare_coins(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local dark_coin_count: s32 = 0
	local indestructible_coin_count: s32 = 0
	local answer: any = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	dark_coin_count = event.get_item_count(201) or dark_coin_count
	indestructible_coin_count = event.get_item_count(202) or indestructible_coin_count
	if dark_coin_count <= 0 or indestructible_coin_count <= 0 then
		event.open_message_window_2(
			0,
			"What? Aah, coin collecting?<page>I'm looking for the Dark Coin\nand the Indestructible Coin.<page>You'll never get hold of those. I've looked all\nover for them, but they're impossible to find."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Eh? You've got them? Unbelievable!<page>Don't just stand there! Gimme, gimme, gimme!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "OK.\nWhat shall I do?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Argh! If you're going to mess me\naround I definitely won't help you.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"Wow, I've got them all!\nAnd I thought it was impossible...<page>Well, I guess I've got no choice now.\nI'd better go with you!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

--- Has a fearful villager refuse to fight, ask Max for a flower photo and start the photo request, while Monica takes the alternate dialogue.
function npc_dialogue.request_flower_photo(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "I wish I could help you out, but fighting's\nscary and I might get dirty.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "And I'd hate to be a nuisance to everyone.\nSorry, but I'll have to say no.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"But there must be lots of\nunusual things outside town.<page>I wonder what the trees are like,\nand what kind of flowers there are."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"If you see an interesting flower, could\nyou take a picture of it for me, Max?\nI'd so love to see it."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]She said no this time, but if you show\n   her a picture of something she's\n   interested in she'll probably give in."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Has the magical artist introduce his painted fiancee and ask the player to bring Golden Paint, or says the player should try as Max when Monica talks.
function npc_dialogue.request_golden_paint(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
		event.open_message_window_2(0, "Hi there.\nIt's Monica, right?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "I'm Parn.\nI'm a magical artist.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(0, "...")
		message.say_bubble(0, -1, player_character, npc_character, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Monica's not very good in this kind of \n   situation. She might get somewhere, but\n   probably not. Better try again as Max."
		)
		message.show(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Hey Max.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(0, "Yeah, you can laugh.\nI know it's strange!<page>Who'd fall in love with\na girl in a picture?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"But I'm a magical artist.\nI have the power to make the things I draw real.<page>Whatever I draw really does exist in the picture.\nAs long as it's not a living thing..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Even a magical artist can't draw life.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "But, I've heard of a way.\nThere's a Golden Egg in a big, old tree.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "It's said that with its golden colour,\nyou can give life to anything you draw.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Max, you're going out of\ntown, right?<page>I wonder if you could get hold of some Golden Paint?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Of course I don't expect you to do it for nothing.<page>If you can help me, I'll use\nmy new power to help you in return."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]A big, old tree...\n   With  a Golden Egg! Where on earth\n   would you find a tree like that?!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

--- Has the coin collector refuse to help without payment and ask for the Dark Coin and the Indestructible Coin, or says the player should try as Max when Monica talks.
function npc_dialogue.request_rare_coins(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"You should know the answer to that:\nN-O W-A-Y!<page>Why should I have to work for the\nsake of other people?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "There's not much in it for me, and\nit's just too scary.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "As it's you, I suppose I could\nthink about it, though.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "But then, I am the son of a salesman\nand we don't do things for free.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"You probably know that I collect coins.<page>They're the symbol of business. I really\nwant to complete my collection."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"But I just can't seem to get\nmy hands on the Dark Coin\nand the Indestructible Coin.<page>If you can help me,\nmaybe I can help you."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 2, 1)
end

--- Adel explains she has lost her confidence, a hint says to get her sewing again, and request 7 starts.
function npc_dialogue.start_adel_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"I see...I really wish\nthat I could help you.\nMore than anything.<page>But I don't have any\nconfidence in myself."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"I always seem to give up halfway,\nand I've never seen anything through.<page>When I was little, I dreamt of becoming a tailor,\nand I tried many times to make something,\nbut I never completed a single garment."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "If I went with you, I'm sure\nI'd just get in the way.<page>So, sorry, but no.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Oh dear, Adel has lost all her\n   confidence. This is no good. Let's\n   get her to try making clothes again."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- The baker agrees to join once Max delivers 20 loaves of bread to Morton, hands over the bread and starts request 8.
function npc_dialogue.start_baker_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"You want me to\ngo with you?<page>I'm just a woman who bakes bread,\nbut if I can be of any use to you,\nI will gladly."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Oh, but first I've got something\nthat needs delivering to Morton.<page>Would you mind delivering 20 loaves\nof bread to Morton's shop for me?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "While you're doing that,\nI'll pack for the trip.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.add_inventory_item(300, 20)
	inventory.announce_received(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "I wonder what on earth he\ncould want with 20 loaves?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- Gerald hands Max a Trumpet Gun, asks him to build it up into a Bell Trigger and starts request 11.
function npc_dialogue.start_gerald_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "According to Cedric,\nyou've been off up to\nsomething recently.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "You're good at a lot of things,<page>but on the other hand you\nnever see anything through.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "So when you ask for help,\nit's hard for me to take you\nseriously just like that.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"I know, why don't you try to build-up\nthis Trumpet Gun to a Bell Trigger?<page>Think you can do it?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.add_inventory_item(24)
	inventory.announce_received(24, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]To get Gerald to accept you,\n   you'll have to bring\n   him a Bell Trigger.<page>[(!)]You can build-up the weapon you've\n   been given, or you can buy a weapon,\n   or bring one you find in the dungeons."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

--- Mena describes her dizziness; when Monica leads she recognises it as an effect of time distortions, a hint explains how to fix them, and request 17 starts with the current clear count saved.
function npc_dialogue.start_mena_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local clear_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"I've not been feeling too good lately.<page>I'm just not up to going on a trip.<page>I got Dr. Dell to come and have a look at me,\nbut he said there's nothing wrong."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"But even standing normally I feel\nlike I'm going to fall down.<page>It's hard to explain. It's almost\nas if the world has been distorted."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(
			0,
			"Hmmm...\nif Dr. Dell doesn't know what the problem is,\nthen there's not much I can do to help..."
		)
		message.say_bubble(0, -1, player_slot, npc_slot, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "I remember those symptoms.")
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"In the time I was born,\nthe world was in a very bad state,\nwith more time distortions than\nyou can possibly imagine."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"This had an effect on physically\nweak and fragile people.<page>Light people would get dizzy or faint,\nand heavier people couldn't stand at all."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Maybe you're particularly susceptible\nto this kind of thing.<page>Even the few time distortions we have\nhere are enough to affect you."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(0, "If we can just get rid of some of the closest\ndistortions, maybe you'll start to feel better.")
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.set_character_motion(player_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]How to fix a time distortion... Spheda!\n   If you can complete about 10 stages,\n   maybe Mena will start to feel better."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	clear_count = event.get_menu_value_2(0) or clear_count
	event.set_save_counter(19, clear_count)
	event.set_quest_request(0, 17, 1)
end

--- Routes Adel's conversation by whether Monica leads, the status of requests 0 and 7 and the tailoring progress.
function npc_dialogue.talk_to_adel(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	local tailoring_progress: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_chatter.talk_tailor_monica(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_chatter.talk_tailor_dream(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 7) or request_status
	if request_status == 0 then
		npc_dialogue.start_adel_request(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		tailoring_progress = event.get_save_counter(8) or tailoring_progress
		if tailoring_progress == 0 then
			quest_dialogue.request_tailor_materials(npc_slot, player_slot)
		end
		if tailoring_progress == 1 then
			npc_dialogue.deliver_tailoring_materials(npc_slot, player_slot)
		end
		if tailoring_progress == 2 then
			quest_dialogue.receive_tailor_garment(npc_slot, player_slot)
		end
		return
	end
	if request_status == 2 then
		npc_chatter.talk_tailor_done(npc_slot, player_slot)
		return
	end
end

--- Routes the fisherman's conversation by request 0 and 16 status and a story flag.
function npc_dialogue.talk_to_fisherman(npc_slot: s32, player_slot: s32)
	local request_status: s32 = 0
	local story_flag: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	story_flag = event.get_save_flag(424) or story_flag
	if request_status ~= 2 or story_flag == 0 then
		npc_chatter.talk_firbit_favors(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 16) or request_status
	if request_status == 0 then
		palm_brinks_villagers.request_win_fish_race(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.recruit_after_fish_race(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_podium_hopeful(npc_slot, player_slot)
		return
	end
end

--- Routes the flower photographer's conversation by request 0 and 4 status.
function npc_dialogue.talk_to_flower_photographer(npc_slot: s32, player_slot: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		palm_brinks_villagers.talk_about_leaving_town(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 4) or request_status
	if request_status == 0 then
		npc_dialogue.request_flower_photo(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.complete_flower_photo_request(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		npc_chatter.talk_railroad_fan(npc_slot, player_slot)
		return
	end
end

--- Chooses the gardener's dialogue from the story flag and the state of his quest request.
function npc_dialogue.talk_to_gardener(npc_character: s32, player_character: s32)
	local story_flag: s32 = 0
	local quest_status: s32 = 0
	story_flag = event.get_save_flag(42) or story_flag
	if story_flag == 0 then
		npc_chatter.talk_tree_gardener(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status == 0 then
		villager_dialogue.start_gordon_quest(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_gordon_request(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_holy_water_keeper(npc_character, player_character)
		return
	end
end

--- Routes Mena's conversation by story flag and the status of request 17.
function npc_dialogue.talk_to_mena(npc_slot: s32, player_slot: s32)
	local story_flag: s32 = 0
	local request_status: s32 = 0
	story_flag = event.get_save_flag(314) or story_flag
	if story_flag == 0 then
		npc_dialogue.chat_feeling_unwell(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 17) or request_status
	if request_status == 0 then
		npc_dialogue.start_mena_request(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.complete_mena_request(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		villager_dialogue.talk_villager_23_after_quest(npc_slot, player_slot)
		return
	end
end

--- Chooses the old woman's dialogue from the state of the main request and her own quest request.
function npc_dialogue.talk_to_old_woman(npc_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_hard_of_hearing(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 19) or quest_status
	if quest_status == 0 then
		npc_dialogue.recruit_hard_of_hearing_woman(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_grandmother(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		palm_brinks_villagers.talk_old_granny(npc_character, player_character)
		return
	end
end

--- Parn introduces himself to Monica or greets Max.
function npc_dialogue.talk_to_parn(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
		event.open_message_window_2(0, "Hi there.\nIt's Monica, right?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "I'm Parn.\nI'm a magical artist.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hey Max.<page>How come you always\nlook so well?!")
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

return npc_dialogue
