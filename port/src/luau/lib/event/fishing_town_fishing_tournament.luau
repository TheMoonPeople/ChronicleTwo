--!strict
--- Holds the talk, choice, information and cleanup helpers for the Fishing Tournament Hall.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local fishing_town_fishing_tournament = {}

--- Shows a choice menu with the given option count and default choice in the given window and returns the chosen index.
function fishing_town_fishing_tournament.ask_choice(window: s32, unused_1: s32, unused_2: s32, talk_character: s32, choice_count: s32, default_choice: s32)
	return message.resume_choice(window, choice_count, default_choice, 0)
end

--- Resets the sound ports, deletes the event characters and images and clears the save control bits before leaving the hall.
function fishing_town_fishing_tournament.clean_up_event()
	event.initialize_sound_port(5)
	event.initialize_sound_port(8)
	event.initialize_sound_port(1)
	event.delete_character_extension_packs(0)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(8)
	event.delete_character(13)
	event.delete_event_image(0)
	event.delete_event_image(1)
	event.set_save_control_bits(1, 0)
end

--- Shows the fishing tournament information message.
function fishing_town_fishing_tournament.show_tournament_info()
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	event.get_fishing_tournament_info_2(0, 1)
	message.show(1, -1, 8, 0, 0)
end

--- Prints the talking character and starts the NPC conversation.
function fishing_town_fishing_tournament.talk_to_npc()
	local talk_character_id: s32 = 0
	local talk_character: s32 = 0
	print("talk_chara_id=", talk_character_id, "talk_chara=", talk_character, "\n")
	cutscene.talk_skipping_variant(talk_character_id, -1, 0, 0)
end

--- Waits 30 frames with skipping allowed and then runs an empty finish handler.
function fishing_town_fishing_tournament.wait_skippable_frames()
	wait.frames_skipping(30)
	cutscene.noop()
end

return fishing_town_fishing_tournament
