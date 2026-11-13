--!strict
--- Event logic specific to the Griffon's Chamber Door.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local griffons_chamber_door = {}

--- Shows a remark when a non-main character is active or else asks whether to open the door, returning 1 when the screen fades out to enter and 0 otherwise.
function griffons_chamber_door.prompt_to_enter()
	local active_character: s32 = 0
	local choice: any = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				progress = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				progress = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.finish_event()
			return 0
		end
		progress = 3
		choice = message.ask_yes_no(5, 124)
		if choice == 0 then
			event.fade_out_screen(30)
			progress = 4
			wait.frames(30)
			event.finish_event()
			return 1
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if progress <= 2 then
			if progress <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			return 0
		end
		if progress <= 4 then
			if progress == 3 then
				choice = received[1] :: number
			end
			if progress <= 3 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Sets the door save flag and plays the door's message text.
function griffons_chamber_door.show_door_message()
	event.set_save_flag(712, 1)
	event.set_character_motion(0, "立ち")
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.change_directory("event/e700/e712/")
	event.start_background_file_loads_1("e712_1.txt")
	vm.wait(1)
	wait.background_load()
	event.load_message_file(0, 5, "e712_1.txt")
	event.change_directory("")
	message.show_voiced(7120010)
	message.show_voiced(7120015)
	event.load_message_file(0, -1)
	event.finish_event()
end

return griffons_chamber_door
