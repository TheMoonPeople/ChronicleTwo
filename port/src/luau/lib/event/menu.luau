--!strict
--- Event menus such as shops.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local flag = vm.module("@lib/event/flag")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local menu = {}

--- Asks whether to go inside or depart, opening the departure event menu between fades when the player departs, and returns 1 only when the player chooses to go inside.
function menu.ask_enter_or_depart()
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.initialize_event()
		message.set_window_mode(0, 4)
		event.open_message_window_2(0, "中に入る\n出発する")
		resume_step = 1
		choice = message.ask_choice(0, -1, 5, 256, 208, 2, 0)
		if choice == -1 then
			message.set_window_mode(0, 1)
			return 0
		end
		if choice == 1 then
			event.fade_out_screen(15)
			resume_step = 2
			wait.for_frame_count(15)
			event.open_event_menu(19, 0)
			resume_step = 3
			vm.wait(3)
			event.fade_in_screen(15)
			resume_step = 4
			wait.for_frame_count(15)
			return 0
		end
		return 1
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			message.set_window_mode_skipping(0, 1)
			return 0
		end
		if resume_step <= 4 then
			if resume_step <= 3 then
				wait.skip_frame_count(15)
			end
			return 0
		end
		return nil
	end)
end

--- Asks whether to leave and returns 1 after fading out when the player agrees.
function menu.confirm_leave()
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		resume_step = 1
		choice = message.ask_yes_no(5, 4)
		if choice == 0 then
			event.fade_out_screen(20)
			resume_step = 2
			wait.frames(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				wait.frames_skipping(20)
			end
			return 1
		end
		return nil
	end)
end

--- Asks whether to leave and returns 1 after fading out when the player agrees, waiting with the main-script frame wait.
function menu.confirm_leave_primary()
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		resume_step = 1
		choice = message.ask_yes_no(5, 4)
		if choice == 0 then
			event.fade_out_screen(20)
			resume_step = 2
			wait.for_frame_count(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				wait.skip_frame_count(20)
			end
			return 1
		end
		return nil
	end)
end

--- Refuses to leave with an explanatory message when the playable character is 2 or 3, otherwise asks to leave and returns 1 after fading out when the player agrees.
function menu.confirm_leave_unless_blocked()
	local playable_character: s32 = 0
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 or playable_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if playable_character == 2 then
				resume_step = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				resume_step = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.finish_event()
			return 0
		end
		resume_step = 3
		choice = message.ask_yes_no(2, -1)
		if choice == 0 then
			event.fade_out_screen(30)
			resume_step = 4
			wait.frames(30)
			event.finish_event()
			return 1
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			return 0
		end
		if resume_step <= 4 then
			if resume_step == 3 then
				choice = received[1] :: number
			end
			if resume_step <= 3 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Refuses to leave with an explanatory message when the playable character is 2 or 3, otherwise asks to leave and returns 1 after fading out when the player agrees, waiting with the main-script frame wait.
function menu.confirm_leave_unless_blocked_primary()
	local playable_character: s32 = 0
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 or playable_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if playable_character == 2 then
				resume_step = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				resume_step = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.finish_event()
			return 0
		end
		resume_step = 3
		choice = message.ask_yes_no(2, -1)
		if choice == 0 then
			event.fade_out_screen(30)
			resume_step = 4
			wait.for_frame_count(30)
			event.finish_event()
			return 1
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			return 0
		end
		if resume_step <= 4 then
			if resume_step == 3 then
				choice = received[1] :: number
			end
			if resume_step <= 3 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		return nil
	end)
end

--- Fades out, opens the shop menu for a shop, ends the conversation and fades back in.
function menu.open_shop(shop_id: s32)
	event.fade_out_screen(25)
	wait.for_frame_count(30)
	event.open_event_menu(6, shop_id)
	vm.wait(2)
	message.end_conversation()
	event.fade_in_screen(30)
end

--- Fades out, opens the shop menu for a shop, restores the message window and fades back in.
function menu.open_shop_waiting_frames(shop_id: s32)
	event.fade_out_screen(25)
	wait.frames(30)
	event.open_event_menu(6, shop_id)
	vm.wait(2)
	message.end_conversation_restoring_window()
	event.fade_in_screen(30)
end

--- Fades out, opens event menu 6 with a parameter, then fades back in.
function menu.open_type_6(menu_parameter: s32)
	event.fade_out_screen(15)
	wait.for_frame_count(15)
	event.open_event_menu(6, menu_parameter)
	vm.wait(2)
	event.fade_in_screen(15)
end

--- Fades out for fifteen frames using the standard frame wait, opens event menu 6 with a parameter, then fades back in.
function menu.open_type_6_alt(menu_parameter: s32)
	event.fade_out_screen(15)
	wait.frames(15)
	event.open_event_menu(6, menu_parameter)
	vm.wait(2)
	event.fade_in_screen(15)
end

--- Initializes the event, makes the player stand, fades out, opens event menu 7, then fades back in.
function menu.open_type_7()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.fade_out_screen(10)
	wait.for_frame_count(10)
	event.open_event_menu(7)
	vm.wait(2)
	event.fade_in_screen(10)
	wait.for_frame_count(10)
end

--- Resets the event, fades the screen out, opens event menu 7 and fades the screen back in.
function menu.open_with_fade()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.fade_out_screen(10)
	wait.frames(10)
	event.open_event_menu(7)
	vm.wait(2)
	event.fade_in_screen(10)
	wait.frames(10)
end

--- Skips the fixed-length wait that follows opening a shop menu when the event resumes.
function menu.resume_shop_menu(shop_id: s32)
	wait.skip_frame_count(15)
end

--- Shows the four-option topic menu on the resume path and returns the updated topic flags.
function menu.resume_show_topic_menu(topic_flags: s32)
	message.open_skipping(0, -1, 5, 0, 0)
	message.open_skipping(0, 2220, 5, 0, 0)
	local _ = message.resume_choice(0, 3, 3, 0)
	message.show_and_wait_skipping(0, -1, 5, 0, 0)
	topic_flags = flag.resume_clear_bits(topic_flags, 2)
	wait.skip_frame_count(6)
	topic_flags = flag.resume_clear_bits(topic_flags, 2)
	character.resume_shake_head()
	message.show_and_wait_skipping(0, 2215, 5, 0, 0)
	message.show_and_wait_skipping(0, 2216, 5, 0, 0)
	message.show_and_wait_skipping(0, 2211, 5, 0, 0)
	message.show_and_wait_skipping(0, 2212, 5, 0, 0)
	local _ = bit32.band(topic_flags, 8)
	local _ = bit32.band(topic_flags, 16)
	local _ = bit32.band(topic_flags, 32)
	topic_flags = flag.resume_clear_bits(topic_flags, 2)
	return topic_flags
end

--- Shows the four-option topic index with its sub-topic texts, without displaying anything when events are skipped, and returns the given topic flags.
function menu.show_topic_index_skipping(topic_flags: s32)
	local selected_topic: s32 = 0
	local done_flag: s32 = 0
	local bit_mask: s32 = 0
	local index: s32 = 0
	local sub_choice: s32 = 0
	message.open_skipping(0, 2200, 5, 0, 0)
	selected_topic = message.resume_choice(0, 4, 4, 0)
	done_flag = 0
	done_flag = 0
	done_flag = 0
	done_flag = 1
	bit_mask = 8
	index = 1
	bit_mask = bit_mask * 2
	local _ = index < selected_topic
	index = index + 1
	message.show_and_wait_skipping(0, 2213, 5, 0, 0)
	local _ = done_flag ~= 1
	done_flag = 0
	message.show_and_wait_skipping(0, 2215, 5, 0, 0)
	message.show_and_wait_skipping(0, 2216, 5, 0, 0)
	done_flag = 1
	message.show_and_wait_skipping(0, 2211, 5, 0, 0)
	done_flag = 1
	local _ = sub_choice == 3
	sub_choice = 1
	message.show_and_wait_skipping(0, 2212, 5, 0, 0)
	done_flag = 1
	return topic_flags
end

--- Shows the four-option topic menu with skip-mode waits and returns the updated topic flags.
function menu.show_topic_menu_skipping(topic_flags: s32)
	message.open_skipping(0, -1, 5, 0, 0)
	message.open_skipping(0, 2220, 5, 0, 0)
	local _ = message.resume_choice(0, 3, 3, 0)
	message.show_and_wait_skipping(0, -1, 5, 0, 0)
	topic_flags = flag.resume_clear_bits(topic_flags, 2)
	wait.frames_skipping(6)
	topic_flags = flag.resume_clear_bits(topic_flags, 2)
	character.resume_shake_head()
	message.show_and_wait_skipping(0, 2215, 5, 0, 0)
	message.show_and_wait_skipping(0, 2216, 5, 0, 0)
	message.show_and_wait_skipping(0, 2211, 5, 0, 0)
	message.show_and_wait_skipping(0, 2212, 5, 0, 0)
	local _ = bit32.band(topic_flags, 8)
	local _ = bit32.band(topic_flags, 16)
	local _ = bit32.band(topic_flags, 32)
	topic_flags = flag.resume_clear_bits(topic_flags, 2)
	return topic_flags
end

return menu
