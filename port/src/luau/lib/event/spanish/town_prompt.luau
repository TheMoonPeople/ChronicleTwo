--!strict
--- Spanish text for prompts and remarks spoken by townspeople before entering buildings.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local town_prompt = {}

--- Asks whether to go inside or leave, opens the event menu when the player leaves and returns 1 when the player goes inside.
function town_prompt.ask_enter_or_leave()
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.initialize_event()
		message.set_window_mode(0, 4)
		event.open_message_window_2(0, "Entrar\nSalir")
		resume_step = 1
		choice = message.ask_choice(0, -1, 5, 256, 208, 2, 0)
		if choice == -1 then
			message.set_window_mode(0, 1)
			return 0
		end
		if choice == 1 then
			event.fade_out_screen(15)
			resume_step = 2
			wait.frames(15)
			event.open_event_menu(19, 0)
			resume_step = 3
			vm.wait(3)
			event.fade_in_screen(15)
			resume_step = 4
			wait.frames(15)
			return 0
		end
		return 1
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			message.set_window_mode_stub(0, 1)
			return 0
		end
		if resume_step <= 4 then
			if resume_step <= 3 then
				wait.frames_skipping(15)
			end
			return 0
		end
		return nil
	end)
end

--- Speaks the line of a character who waits outside for the player, then turns toward the player.
function town_prompt.say_waiting_outside()
	local character_slot: s32 = 0
	local flag_648: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	message.set_window_mode(0, 1)
	flag_648 = event.get_save_flag(648) or flag_648
	if flag_648 == 0 then
		event.open_message_window_2(0, "Te esperar[UNI00e9] aqu[UNI00ed].\nEspero que salga todo bien.")
	else
		event.open_message_window_2(0, "Esperar[UNI00e9] aqu[UNI00ed].\nEnc[UNI00e1]rgate de [UNI00e9]l.")
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

return town_prompt
