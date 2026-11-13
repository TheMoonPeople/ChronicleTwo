--!strict
--- Event staging for Sindain: villager and Toryon characters and question prompts.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local sindain_event = {}

--- Opens a message window, waits for the player's answer, closes the window and returns the chosen answer.
function sindain_event.ask_question(window: s32, text: s32, position: s32, x: s32, y: s32, chosen_answer: s32)
	local _ = message.open_skipping(window, text, position, x, y)
	do
		local _: any
		_, chosen_answer = message.wait_answer_skipping(window, 2, chosen_answer)
	end
	message.close_skipping(window)
	return chosen_answer
end

--- Opens a message window, waits for the player's answer, closes the window and returns the wait result.
function sindain_event.ask_question_with_wait_result(window: s32, text: s32, position: s32, x: s32, y: s32, chosen_answer: s32)
	local wait_result: s32 = 0
	local resume_step: number = 0
	local resumed_result: s32 = 0
	return vm.guard(function()
		local _ = message.open(window, text, position, x, y)
		resume_step = 1
		local first_result: s32
		first_result, chosen_answer = message.wait_answer(window, 2, chosen_answer)
		wait_result = first_result
		message.close(window)
		return chosen_answer
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				resumed_result = received[1] :: number
				chosen_answer = received[2] :: number
			end
			wait_result = resumed_result
			message.close_skipping(window)
			return wait_result, chosen_answer
		end
		return nil, chosen_answer
	end)
end

--- Deletes the Toryon, tree, leaf and speed-line characters.
function sindain_event.delete_toryon_characters()
	event.delete_character(42)
	event.delete_character(43)
	event.delete_character(44)
	event.delete_character(46)
	event.delete_character(45)
end

--- Deactivates and deletes the six villager characters.
function sindain_event.delete_villager_characters()
	event.set_character_active(0, 34)
	event.set_character_active(0, 41)
	event.set_character_active(0, 36)
	event.set_character_active(0, 35)
	event.set_character_active(0, 38)
	event.set_character_active(0, 40)
	event.delete_character(34)
	event.delete_character(41)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_character(38)
	event.delete_character(40)
end

--- Loads Toryon, its two trees, a leaf and speed lines, attaches the trees to Toryon and gives it the sound bank.
function sindain_event.load_toryon_characters(sound_bank: s32)
	event.load_character(6, "event/e200/e250/e250_toryon.gltf", "info", 42)
	event.attach_object_handle_to_character(9, 42)
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.set_character_active(0, 42)
	event.set_object_handle_sound_bank(9, sound_bank)
	event.load_character(6, "event/lm/e250r/e250_tree.gltf", "info", 43)
	event.attach_object_handle_to_character(10, 43)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_character_active(0, 43)
	event.attach_character_to_frame(42, "R_tree", 43)
	event.load_character(6, "event/lm/e250r/e250_tree.gltf", "info", 44)
	event.attach_object_handle_to_character(11, 44)
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.set_character_active(0, 44)
	event.attach_character_to_frame(42, "L_tree", 44)
	event.load_character(6, "event/e200/e250/e250_konoha.gltf", "info", 46)
	event.set_character_active(0, 46)
	event.attach_object_handle_to_character(15, 46)
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 15)
	event.load_character(6, "event/e200/e250/shuchusen.gltf", "info", 45)
	event.attach_object_handle_to_character(14, 45)
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 14)
	event.set_character_active(0, 45)
end

--- Loads the Toryon characters with the given sound bank.
function sindain_event.load_toryon_with_sound_bank(sound_bank: s32)
	sindain_event.load_toryon_characters(sound_bank)
end

--- Loads the six villager characters and binds them to object sequences.
function sindain_event.load_villager_characters()
	event.load_character(6, "event/e200/e250/e250_noam.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(6, "event/e200/e250/e250_rococo.gltf", "info", 41)
	event.attach_object_handle_to_character(8, 41)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.set_character_active(0, 41)
	event.load_character(6, "event/e200/e250/e250_zak.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(6, "event/e200/e250/e250_wicky.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(6, "event/e200/e250/e250_tobo.gltf", "info", 40)
	event.attach_object_handle_to_character(7, 40)
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.set_character_active(0, 40)
	event.load_character(6, "event/e200/e250/e250_mogri.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
end

--- Passes the sound bank to a routine that performs no work.
function sindain_event.pass_sound_bank(sound_bank: s32)
	cutscene.ignore_value(sound_bank)
end

return sindain_event
