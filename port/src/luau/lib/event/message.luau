--!strict
--- Opens, drives and closes message windows, their voiced lines and their answer prompts.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")
local npc = vm.module("@lib/event/npc")
local paznos_bridge = vm.module("@lib/event/paznos_bridge")
local sound = vm.module("@lib/event/sound")
local veniccio_station = vm.module("@lib/event/veniccio_station")
local wait = vm.module("@lib/event/wait")

local message = {}

--- Opens a message window with a speech bubble and returns the option the player selects.
function message.ask_bubble_choice(window: s32, text: any, speaker: any, listener: s32, option_count: any, initial_selection: any)
	local progress_step: number = 0
	return vm.guard(function()
		progress_step = 1
		vm.wait(1)
		progress_step = 2
		vm.wait(2)
		event.open_message_window_2(window, text)
		event.place_message_bubble(window, speaker, listener)
		progress_step = 3
		return message.choose_option(window, option_count, initial_selection, 0)
	end, function(received: { any })
		if progress_step <= 3 then
			return message.resume_choice(window, option_count, initial_selection, 0)
		end
		return nil
	end)
end

--- Opens a message window with a list of options and returns the index the player chose.
function message.ask_choice(window: s32, text: any, position: s32, x: s32, y: s32, option_count: s32, selected: s32)
	local choice: any = 0
	local at: number = 0
	return vm.guard(function()
		local _ = message.open(window, text, position, x, y)
		at = 1
		choice = message.choose_option(window, option_count, selected, 0)
		event.set_message_bubble_screen_slot(window, 0)
		return choice
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				choice = received[1] :: number
			end
			return choice
		end
		return nil
	end)
end

--- Opens a bubble message with a choice list and returns the selected option.
function message.ask_choice_bubble(window: s32, text: s32, speaker: s32, listener: s32, option_count: s32, selection: s32)
	local resume_point: number = 0
	return vm.guard(function()
		resume_point = 1
		vm.wait(1)
		resume_point = 2
		vm.wait(2)
		event.open_message_window_2(window, text)
		event.place_message_bubble(window, speaker, listener)
		resume_point = 3
		return message.select_option(window, option_count, selection, 0)
	end, function(received: { any })
		if resume_point <= 3 then
			return message.resume_choice(window, option_count, selection, 0)
		end
		return nil
	end)
end

--- Stands in for a bubble choice prompt and always returns minus one.
function message.ask_choice_bubble_stub(window: s32, text: any, speaker: any, listener: s32, option_count: any, selection: any)
	return message.resume_choice(window, option_count, selection, 0)
end

--- Opens a message with a choice list and returns the selected option, counting the options with signed arithmetic.
function message.ask_choice_signed(window: s32, text: any, position: s32, x: s32, y: s32, option_count: s32, default_selection: s32)
	local selection: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		local _ = message.open(window, text, position, x, y)
		resume_point = 1
		selection = message.select_option(window, option_count, default_selection, 0)
		event.set_message_bubble_screen_slot(window, 0)
		return selection
	end, function(received: { any })
		if resume_point <= 1 then
			if resume_point == 1 then
				selection = received[1] :: number
			end
			return selection
		end
		return nil
	end)
end

--- Opens a message window with a choice list and returns the selected index; this stands in for message.ask_choice when events are skipped.
function message.ask_choice_skipping(window: s32, text: any, position: s32, x: s32, y: s32, option_count: s32, selected: s32)
	local choice: s32 = 0
	local _ = message.open_skipping(window, text, position, x, y)
	choice = message.resume_choice(window, option_count, selected, 0)
	return choice
end

--- Opens a message window, waits for a yes or no answer and closes it.
function message.ask_confirmation(window: s32, text: s32, position: s32, x: s32, y: s32, chosen: s32)
	local frame_count: s32 = 0
	local resume_point: number = 0
	local resumed_frames: s32 = 0
	return vm.guard(function()
		local _ = message.open(window, text, position, x, y)
		resume_point = 1
		local waited_frames: s32
		waited_frames, chosen = message.wait_answer(window, 1, chosen)
		frame_count = waited_frames
		message.close(window)
		return chosen
	end, function(received: { any })
		if resume_point <= 1 then
			if resume_point == 1 then
				resumed_frames = received[1] :: number
				chosen = received[2] :: number
			end
			frame_count = resumed_frames
			message.close_skipping(window)
			return frame_count, chosen
		end
		return nil, chosen
	end)
end

--- Shows a two-choice prompt about an item and returns the chosen option.
function message.ask_item_choice(prompt_index: s32, item_name_id: s32)
	local selected_choice: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.set_message_selection_top_line(1, 0)
		event.set_message_window_mode(1, 5)
		event.set_message_draw_speed(1, 1)
		event.set_message_item_system_message(1, 1, vm.i32(item_name_id + 20000))
		resume_point = 1
		selected_choice = message.ask_choice_signed(1, vm.i32(prompt_index + 70), 8, 256, 208, 2, 1)
		event.set_message_draw_speed(1, 0)
		return selected_choice
	end, function(received: { any })
		if resume_point <= 1 then
			if resume_point == 1 then
				selected_choice = received[1] :: number
			end
			return selected_choice
		end
		return nil
	end)
end

--- Opens message window 1 with message 1000 plus the choice set and returns the player's choice among two or three options.
function message.ask_numbered_choice(choice_set: s32)
	local resume_point: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(1, 4)
		message.set_window_mode(1, 4)
		if choice_set == 0 then
			resume_point = 1
			return message.ask_choice(1, 1000 + choice_set, 7, 0, 0, 2, 0)
		end
		if choice_set == 1 then
			resume_point = 2
			return message.ask_choice(1, 1000 + choice_set, 7, 0, 0, 3, 0)
		end
		return 0
	end, function(received: { any })
		if resume_point <= 1 then
			return message.ask_choice_skipping(1, vm.i32(1000 + choice_set), 7, 0, 0, 2, 0)
		end
		if resume_point <= 2 then
			return message.ask_choice_skipping(1, vm.i32(1000 + choice_set), 7, 0, 0, 3, 0)
		end
		return nil
	end)
end

--- Asks a choice question in window 1 whose text index is the given number plus 70, without displaying anything when events are skipped.
function message.ask_numbered_choice_skipping(message_number: s32, unused_value: any)
	local _ = message.ask_choice_skipping(1, vm.i32(message_number + 70), 8, 256, 208, 2, 1)
end

--- Asks a choice question in window 1 whose text index is the given number plus 70 wrapped to 32 bits, without displaying anything when events are skipped.
function message.ask_numbered_choice_skipping_wrapped(message_number: any, unused_value: s32)
	local _ = message.ask_choice_skipping(1, vm.wrap(message_number + 70), 8, 256, 208, 2, 1)
end

--- Shows a two-choice prompt by index and returns the chosen option.
function message.ask_prompt_choice(prompt_index: s32, unused_value: s32)
	local selected_choice: s32 = 0
	selected_choice = message.ask_choice_skipping(1, vm.i32(prompt_index + 70), 8, 256, 208, 2, 1)
	return selected_choice
end

--- Asks a two-option question, runs a skip-mode wait of 30 frames and then the skip-mode background load wait.
function message.ask_then_wait_background_load(unused_value: any)
	local _ = message.open_choice_skipping(0, -1, 8, 0, 0, 2, 0)
	wait.frames_skipping(30)
	wait.background_load_skipping()
end

--- Shows a text in window 1, asks a three-option question in window 0 and closes window 1, without displaying anything when events are skipped.
function message.ask_three_options_in_window_1()
	local choice_setting: s32 = 0
	message.open_skipping(1, -1, 5, 0, 0)
	local _ = message.open_choice_skipping(0, -1, 8, 0, 0, 3, choice_setting)
	message.close_skipping(1)
end

--- Sets window 0 to mode 4, asks a two-option question, then sets the mode to 1, without displaying anything when events are skipped.
function message.ask_two_options_skipping()
	message.set_window_mode_skipping(0, 4)
	local _ = message.ask_choice_skipping(0, -1, 5, 256, 208, 2, 0)
	message.set_window_mode_skipping(0, 1)
end

--- Sets window 0 to mode 4, asks a two-option question, then sets the mode to 1, without displaying anything when events are skipped.
function message.ask_two_options_skipping_2()
	message.set_window_mode_stub(0, 4)
	local _ = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 0)
	message.set_window_mode_stub(0, 1)
end

--- Sets window 0 to mode 4, asks a two-option question, then sets the mode to 1, without displaying anything when events are skipped.
function message.ask_two_options_skipping_3()
	message.set_window_mode_skipping(0, 4)
	local _ = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 0)
	message.set_window_mode_skipping(0, 1)
end

--- Sets window 0 to mode 4, asks a two-option question, then sets the mode to 1, without displaying anything when events are skipped.
function message.ask_two_options_skipping_4()
	message.set_window_mode_stub(0, 4)
	local _ = message.ask_choice_skipping(0, -1, 5, 256, 208, 2, 0)
	message.set_window_mode_stub(0, 1)
end

--- Prints two debug lines, asks a two-option question and runs skip-mode waits of 15 and 30 frames.
function message.ask_two_options_then_pause()
	print("00000000000000000000000000\n")
	print("11111111111111111111111111111111\n")
	local _ = message.ask_choice_skipping(0, -1, 8, 256, 208, 2, 1)
	wait.frames_skipping(15)
	wait.frames_skipping(30)
end

--- Shows a yes or no question with an item system message and returns the index of the chosen answer.
function message.ask_yes_no(question_index: s32, system_message_index: s32)
	local answer: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_message_selection_top_line(1, 0)
		event.set_message_window_mode(1, 5)
		event.set_message_draw_speed(1, 1)
		event.set_message_item_system_message(1, 1, vm.i32(system_message_index + 20000))
		resume_step = 1
		answer = message.ask_choice(1, vm.i32(question_index + 70), 8, 256, 208, 2, 1)
		event.set_message_draw_speed(1, 0)
		return answer
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			return answer
		end
		return nil
	end)
end

--- Plays the chapter-dependent small talk of the townsperson that the player talked to.
function message.chat_with_townsperson()
	local character_slot: s32 = 0
	local npc_id: s32 = 0
	local message_group: s32 = 0
	local message_index: s32 = 0
	local character_suffix: s32 = 0
	local playable_character: s32 = 0
	local chapter: s32 = 0
	local railway_flag: s32 = 0
	local monica_returned_flag: s32 = 0
	local fan_playable_character: s32 = 0
	local friend_playable_character: s32 = 0
	event.get_player_character_slot()
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	print("talk_chara_id=", character_slot, "talk_chara=", npc_id, "\n")
	do
		local out1, out2 = event.get_message_window_option(0, 3, npc_id)
		message_group = out1 or message_group
		message_index = out2 or message_index
	end
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		character_suffix = 2
	else
		character_suffix = 1
	end
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, character_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	if npc_id == 1012 or npc_id == 1015 or npc_id == 1018 then
		npc.open_shop()
		event.set_villager_ai_enabled(1, character_slot)
		return
	end
	if npc_id == 50 then
		event.open_message_window_2(0, "おい、この先は\n立ち入り禁止だ。")
		cutscene.talk(character_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, character_slot)
		return
	end
	chapter = event.get_chapter() or chapter
	if chapter == 1 then
		railway_flag = event.get_save_flag(109) or railway_flag
		if npc_id == 2 then
			if railway_flag == 0 then
				event.open_message_window_2(
					0,
					"見てみろよ、こんなでっかい物が\n動いてたなんて、信じられないだろう。\nでもな、昔は本当に動いてたんだぜ。<page>また、こいつに乗って旅するのがオレの夢だ。\nだから、今でも整備にぬかりはねぇ。\n許しが出たら、いつでも動かせるようにな。"
				)
			else
				event.open_message_window_2(
					0,
					"動かしてない間も整備してたんだけどな、\n実際に動かしてみると、あちこちガタが\n来てやがった。<page>毎日動かしてないと鈍っちまうってのは、\n機械も身体もいっしょだな。"
				)
			end
			cutscene.talk(character_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, character_slot)
			return
		end
		if npc_id == 63 then
			if railway_flag == 0 then
				event.open_message_window_2(
					0,
					"やあ、ユリス。\n鉄道が廃止されて\nどれだけの時間が流れたかのう。<page>私はたとえ、鉄道が動かずとも\nこうやって毎日駅を見回っているのだよ。"
				)
			else
				event.open_message_window_2(
					0,
					"ようやく町長が、重い腰を上げたのじゃな。\n列車は走っているとはいえ、まだまだ\n一般開放できる状態ではない。<page>早く町のみんなを乗せて\nあげたいのじゃが・・・"
				)
			end
			cutscene.talk(character_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, character_slot)
			return
		end
		if npc_id == 65 then
			if railway_flag == 0 then
				event.open_message_window_2(
					0,
					"こんにちは、ユリス。\nそこにいる駅長、うちのパパなの。\nこうやって親子で駅を守っているの。<page>いつの日か、鉄道が復活する日まで・・・"
				)
			else
				event.open_message_window_2(
					0,
					"列車が動いたわ！\nだけど、まだ駅が元通りになるのは、\n時間がかかりそうね・・・"
				)
			end
			cutscene.talk(character_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, character_slot)
			return
		end
	end
	if chapter == 8 then
		monica_returned_flag = event.get_save_flag(804) or monica_returned_flag
		if npc_id == 61 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"おっちゃん、モニカちゃんの\n隠れファンだったんだけど、\n最近モニカちゃんの姿が見えねーな。<page>おかげで、仕事のやる気が出ねーよ。"
				)
			else
				fan_playable_character = event.get_playable_character() or fan_playable_character
				if fan_playable_character ~= 1 then
					event.open_message_window_2(
						0,
						"よお、ユリス。\nモニカが帰って来たらしいな。\n町のみんなも喜ぶぞー！"
					)
				else
					event.open_message_window_2(
						0,
						"モニカー！元気だったか？\nおっちゃん、寂しかったよー。"
					)
				end
			end
			cutscene.talk(character_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, character_slot)
			return
		end
		if npc_id == 80 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"やっとモニカちゃんと普通に\nしゃべれるようになったのに\n突然いなくなるんだもんな。<page>ユリス、一体モニカちゃん、\nどこに行ったんだ？"
				)
			else
				friend_playable_character = event.get_playable_character() or friend_playable_character
				if friend_playable_character ~= 1 then
					event.open_message_window_2(0, "モニカが帰ってきたんだね。\n一体、どうやって？？")
				else
					event.open_message_window_2(0, "モニカ、帰ってきたんだね。\n一体、どうやって？？")
				end
			end
			cutscene.talk(character_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, character_slot)
			return
		end
	end
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(message_group * 10000) + vm.i32(message_index * 10)) + character_suffix))
	cutscene.talk(character_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, character_slot)
end

--- Lets the player move a selection through a window's options with stick, d-pad and buttons; returns the chosen index or -1 when canceled.
function message.choose_option(window: s32, option_count: any, selected: any, block_cancel: s32)
	local top_line: s32 = 0
	local buttons: s32 = 0
	local previous_direction: s32 = 0
	local direction: s32 = 0
	local step: s32 = 0
	local button_0_pressed: s32 = 0
	local button_1_pressed: s32 = 0
	local window_frame: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		top_line = event.get_message_selection_top_line(window) or top_line
		event.set_message_draw_speed(window, 0.0)
		step = 0
		direction = 0
		previous_direction = 0
		event.set_message_selection(window, -1)
		event.set_message_selection(window, selected)
		resume_step = 1
		message.wait_until_shown(window)
		while true do
			step = 0
			direction = message.get_stick_direction(window)
			if previous_direction == 0 and direction == -1 then
				event.play_message_sound(2)
				step = -1
			end
			if previous_direction == 0 and direction == 1 then
				event.play_message_sound(2)
				step = 1
			end
			previous_direction = direction
			button_0_pressed = event.is_event_button_pressed(0) or button_0_pressed
			button_1_pressed = event.is_event_button_pressed(1) or button_1_pressed
			buttons = event.get_buttons_pressed() or buttons
			window_frame = event.get_message_window_frame(window) or window_frame
			if window_frame == 5 then
				if bit32.band(buttons, 32768) ~= 0 then
					event.play_message_sound(2)
					step = -1
				end
				if bit32.band(buttons, 8192) ~= 0 then
					event.play_message_sound(2)
					step = 1
				end
			else
				if bit32.band(buttons, 4096) ~= 0 then
					event.play_message_sound(2)
					step = -1
				end
				if bit32.band(buttons, 16384) ~= 0 then
					event.play_message_sound(2)
					step = 1
				end
			end
			if button_1_pressed ~= 0 then
				event.play_message_sound(3)
				resume_step = 2
				vm.wait(2)
				break
			else
				if button_0_pressed ~= 0 then
					event.play_message_sound(1)
					resume_step = 3
					vm.wait(3)
					if block_cancel == 0 then
						message.close(window)
						return -1
					end
				end
				if step == 1 then
					if selected < vm.wrap(vm.wrap(option_count - 1) + top_line) then
						selected = vm.wrap(selected + 1)
					else
						selected = vm.wrap(vm.wrap(option_count - 1) + top_line)
					end
				end
				if step == -1 then
					if top_line < selected then
						selected = selected - 1
					else
						selected = top_line
					end
				end
				event.set_message_selection(window, selected)
				resume_step = 4
				vm.wait(4)
			end
		end
		message.close(window)
		return selected
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				step = 0
				direction = message.get_stick_direction_skipping(window)
				step = -1
				step = 1
				local _ = previous_direction == 0
				local _ = previous_direction == 0
				previous_direction = direction
				step = -1
				step = 1
				step = -1
				step = 1
			end
			message.close_skipping(window)
			return -1
		end
		if resume_step <= 4 then
			message.close_skipping(window)
			return selected
		end
		return nil
	end)
end

--- Calls the window option hook with option 0.
function message.clear_window_option(window: s32)
	message.set_window_option(window, 0)
end

--- Hides a message window's cursor, closes it and resets its bubble screen slot.
function message.close(window: any)
	event.set_message_selection(window, -1)
	event.close_message_window(window)
	event.set_message_bubble_screen_slot(window, 0)
end

--- Closes message window 1.
function message.close_second_window()
	message.close(1)
end

--- Accepts a message window and does nothing; this stands in for message.close when events are skipped.
function message.close_skipping(window: any) end

--- Closes message window 2, the third window.
function message.close_third_window()
	message.close(2)
end

--- Activates character 0, closes message window 1 and finishes the event.
function message.end_conversation()
	event.set_character_active(0)
	message.close(1)
	event.finish_event()
end

--- Activates character 0, resets message window 1 options, closes the window and finishes the event.
function message.end_conversation_restoring_window()
	event.set_character_active(0)
	event.set_message_window_option(1, 4, -1, -1, -1, -1)
	event.set_message_window_option(1, 9, -1, -1)
	message.close(1)
	event.finish_event()
end

--- Returns -1, 0 or 1 for the analog stick tilt along the axis a message window's choices run.
function message.get_stick_direction(window: s32)
	local window_frame: s32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	window_frame = event.get_message_window_frame(window) or window_frame
	do
		local out1, out2, _, _ = event.get_analog_sticks_4()
		stick_x = out1 or stick_x
		stick_y = out2 or stick_y
	end
	if window_frame == 5 then
		if stick_x < -0.5 then
			return -1
		end
		if 0.5 < stick_x then
			return 1
		end
	else
		if stick_y < -0.5 then
			return -1
		end
		if 0.5 < stick_y then
			return 1
		end
	end
	return 0
end

--- Returns -1 for a message window; this stands in for message.get_stick_direction when events are skipped.
function message.get_stick_direction_skipping(window: any)
	return -1
end

--- Reports a message window as always ready.
function message.is_ready(window: any)
	return 1
end

--- Opens a message window with its text and places its bubble on screen; returns the result of opening the window.
function message.open(window: any, text: any, position: any, x: any, y: any)
	local result: s32 = 0
	result = event.open_message_window_3(window, text) or result
	event.set_message_bubble_screen_slot(window, position)
	event.place_message_bubble(window, x, y, x, y)
	return result
end

--- Opens a message window at the given screen slot and position and returns the player's selection among its choices.
function message.open_and_ask_choice(window: s32, message_id: s32, screen_slot: s32, position_x: s32, position_y: s32, choice_count: s32, default_selection: s32)
	local answer: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		local _ = message.open(window, message_id, screen_slot, position_x, position_y)
		resume_point = 1
		answer = message.choose_option(window, choice_count, default_selection, 0)
		event.set_message_bubble_screen_slot(window, 0)
		return answer
	end, function(received: { any })
		if resume_point <= 1 then
			if resume_point == 1 then
				answer = received[1] :: number
			end
			return answer
		end
		return nil
	end)
end

--- Opens a message window as a speech bubble between a speaker and a listener.
function message.open_bubble(window: any, text: any, speaker_slot: any, listener_slot: any)
	vm.wait(1)
	vm.wait(2)
	event.set_message_bubble_screen_slot(window, 0)
	event.open_message_window_2(window, text)
	event.place_message_bubble(window, speaker_slot, listener_slot)
end

--- Accepts a window, text, speaker and listener and does nothing.
function message.open_bubble_stub(window: any, text: any, speaker: any, listener: any) end

--- Stands in for two consecutive choice prompts, the first showing message 2002, when events are skipped.
function message.open_choice_pair_skipping()
	local unused_counter: s32 = 0
	local unused_offset_x: f32 = 0
	local unused_offset_y: f32 = 0
	local unused_offset_z: f32 = 0
	local unused_accumulator_a: f32 = 0
	local unused_accumulator_b: f32 = 0
	local unused_angle: f32 = 0
	local _ = message.open_choice_skipping(0, 2002, 8, 256, 208, 2, 1)
	local _ = message.open_choice_skipping(0, -1, 8, 256, 208, 2, 1)
	unused_counter = 0
	unused_accumulator_a = vm.f32(unused_accumulator_a + 1.0)
	unused_accumulator_b = vm.f32(unused_accumulator_b + 1.0)
	unused_counter = unused_counter + 1
	unused_angle = vm.f32(unused_angle - vm.f32(3.1415927))
	unused_offset_x = vm.f32(vm.f32(vm.sin(unused_angle) * 100.0) + unused_offset_x)
	unused_offset_y = vm.f32(unused_offset_y + 30.0)
	unused_offset_z = vm.f32(vm.f32(vm.cos(unused_angle) * 100.0) + unused_offset_z)
end

--- Stands in for opening a message window with a choice prompt when events are skipped and returns -1.
function message.open_choice_skipping(window: s32, text: s32, position: s32, x: s32, y: s32, option_count: s32, initial_selection: s32)
	local result: s32 = 0
	local _ = message.open_skipping(window, text, position, x, y)
	result = message.resume_choice(window, option_count, initial_selection, 0)
	return result
end

--- Opens message window 2 with the message numbered 1010 plus the given index.
function message.open_indexed_message(message_index: s32)
	event.apply_message_window_preset(2, 4)
	message.set_window_mode(2, 8)
	message.open(2, vm.i32(1010 + message_index), 4, 0, 0)
end

--- Returns 0 without opening anything; this stands in for message.open when events are skipped.
function message.open_skipping(window: any, text: any, position: any, x: any, y: any)
	local result: s32 = 0
	return result
end

--- Streams a voice line into a blank message window until the voice ends or the player advances it, then closes the window and the stream.
function message.play_voiced_window(voice_id: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	event.open_voice_stream_wave(1, voice_id)
	while true do
		stream_open_state = event.get_voice_stream_open_state() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			vm.wait(2)
		end
	end
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	message.wait_voice_or_button(0)
	message.close(0)
	event.close_voice_stream(1)
end

--- Accepts a voice line and does nothing; this stands in for message.play_voiced_window when events are skipped.
function message.play_voiced_window_skipping(voice_id: s32)
	message.open_skipping(0, -1, 8, 0, 0)
	message.wait_voice_or_button_skipping(0)
	message.close_skipping(0)
end

--- Handles the confirm and cancel presses on a message window for one frame; returns 1 when the window is finished.
function message.poll_advance(window: s32, mouth_state: s32)
	local window_frame: s32 = 0
	local play_sound: s32 = 0
	local window_state: s32 = 0
	local button_0_pressed: s32 = 0
	local button_1_pressed: s32 = 0
	window_frame = event.get_message_window_frame(window) or window_frame
	play_sound = 1
	if window_frame == 7 then
		play_sound = 0
	end
	if window_frame == 0 then
		play_sound = 0
	end
	window_state = event.get_message_window_state(window) or window_state
	if window_state == 0 then
		return 0, mouth_state
	end
	if window_state == 1 then
		return 0, mouth_state
	end
	if window_state == 4 then
		return 0, mouth_state
	end
	button_0_pressed = event.is_event_button_pressed(0) or button_0_pressed
	button_1_pressed = event.is_event_button_pressed(1) or button_1_pressed
	if (if button_0_pressed ~= 0 then 1 else button_1_pressed) ~= 0 then
		if play_sound ~= 0 then
			if button_1_pressed ~= 0 then
				event.play_message_sound(0)
			end
			if button_0_pressed ~= 0 then
				event.play_message_sound(1)
			end
		end
		if window_state == 5 then
			event.advance_message_page(window)
		end
		if window_state == 3 then
			return 1, mouth_state
		end
		if window_state ~= 5 and window_state ~= 3 then
			event.set_message_draw_speed(window, 0.0)
			event.trigger_mouth_motion(2)
			mouth_state = 2
		end
	end
	return 0, mouth_state
end

--- Returns 0 and the mouth state unchanged; this stands in for message.poll_advance when events are skipped.
function message.poll_advance_skipping(window: s32, mouth_state: any)
	return 0, mouth_state
end

--- Sets window 0 back to mode 0, without displaying anything when events are skipped.
function message.reset_window_mode()
	message.set_window_mode_skipping(0, 0)
end

--- Resume-path counterpart of the choice prompt that closes the window and reports no selection.
function message.resume_choice(window: any, option_count: any, initial_selection: any, allow_cancel: s32)
	local previous_direction: s32 = 0
	local direction: s32 = 0
	direction = 0
	previous_direction = 0
	message.resume_choice_poll(window)
	direction = message.get_stick_direction_skipping(window)
	local _ = previous_direction == 0
	local _ = previous_direction == 0
	previous_direction = direction
	message.close_skipping(window)
	return -1
end

--- Resume-path counterpart of the input polling of the choice prompt that does nothing.
function message.resume_choice_poll(window: any) end

--- Finishes the dialogue of a character through the shared dialogue ending when the event resumes.
function message.resume_finish_dialogue(speaker: any, player_character: any)
	message.resume_talk_pages_seventh(speaker, player_character)
end

--- Resume-path sequence of messages ending with the message numbered from 2700 plus an index.
function message.resume_numbered_messages(unused_a: s32, unused_b: s32, message_index: s32)
	message.show_and_wait_skipping(0, 2750, 8, 0, 0)
	message.show_and_wait_skipping(0, 2760, 8, 0, 0)
	message.show_and_wait_skipping(0, vm.i32(2700 + message_index), 8, 0, 0)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	message.show_and_wait_skipping(0, 2760, 8, 0, 0)
end

--- Resumes the opening and two speech bubbles of a talk.
function message.resume_talk_pages(speaker: any, player_character: any)
	cutscene.show_two_default_messages_alt(speaker, player_character)
end

--- Resumes a conversation page by showing it for the character facing the player.
function message.resume_talk_pages_fifth(character_slot: any, player_slot: any)
	cutscene.talk_with_default_message(character_slot, player_slot)
end

--- Resumes the opening and two speech bubbles of a talk.
function message.resume_talk_pages_fourth(speaker: any, player_character: any)
	cutscene.show_two_default_messages_forwarded(speaker, player_character)
end

--- Resumes the opening and two speech bubbles of a talk.
function message.resume_talk_pages_second(speaker: any, player_character: any)
	cutscene.show_two_default_messages_alt(speaker, player_character)
end

--- Resumes a conversation page by showing it for the character facing the player.
function message.resume_talk_pages_seventh(character_slot: any, player_slot: any)
	cutscene.talk_skipping(character_slot, -1, 0, 0)
end

--- Resumes a conversation page by showing it for the character facing the player.
function message.resume_talk_pages_sixth(character_slot: any, player_slot: any)
	message.resume_talk_pages_seventh(character_slot, player_slot)
end

--- Resumes the opening and two speech bubbles of a talk.
function message.resume_talk_pages_third(speaker: any, player_character: any)
	cutscene.show_two_default_messages_alt(speaker, player_character)
end

--- Runs the event map prompt window and returns its result.
function message.run_event_map_prompt()
	return veniccio_station.run_prompt_event_map()
end

--- Steps a message window while animating the mouth until it finishes or the frame limit passes, then closes it.
function message.run_talking(window: any, max_frames: any)
	local is_finished: s32 = 0
	local frame_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_message_button_prompt(window, 0)
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		frame_count = 0
		while frame_count < max_frames do
			is_finished = message.step(window, 0)
			if is_finished ~= 0 then
				frame_count = vm.i32(frame_count + 1)
				break
			else
				resume_step = 1
				vm.wait(1)
				frame_count = vm.i32(frame_count + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		event.set_message_button_prompt(window, 1)
		message.close(window)
		return
	end, function(received: { any })
		if resume_step <= 1 then
			frame_count = frame_count + 1
			message.close_skipping(window)
			return frame_count
		end
		return nil
	end)
end

--- Steps a message window with mouth animation until it is dismissed or the frame limit passes, closes it and returns the frames used.
function message.run_talking_for_frames(window: s32, frame_limit: any)
	local step_result: s32 = 0
	local frame_count: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		event.set_message_button_prompt(window, 0)
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		frame_count = 0
		while frame_count < frame_limit do
			step_result = message.step(window, 0)
			if step_result ~= 0 then
				frame_count = vm.i32(frame_count + 1)
				break
			else
				progress_step = 1
				vm.wait(1)
				frame_count = vm.i32(frame_count + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		event.set_message_button_prompt(window, 1)
		message.close(window)
		return frame_count
	end, function(received: { any })
		if progress_step <= 1 then
			frame_count = frame_count + 1
			message.close_skipping(window)
			return frame_count
		end
		return nil
	end)
end

--- Steps a message window with mouth animation until it is dismissed or the frame limit passes, closes it and returns the frames used.
function message.run_talking_for_frames_primary(window: s32, frame_limit: any)
	local step_result: s32 = 0
	local frame_count: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		event.set_message_button_prompt(window, 0)
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		frame_count = 0
		while frame_count < frame_limit do
			step_result = message.step(window, 0)
			if step_result ~= 0 then
				frame_count = vm.i32(frame_count + 1)
				break
			else
				progress_step = 1
				vm.wait(1)
				frame_count = vm.i32(frame_count + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		event.set_message_button_prompt(window, 1)
		message.close(window)
		return frame_count
	end, function(received: { any })
		if progress_step <= 1 then
			frame_count = frame_count + 1
			message.close_skipping(window)
			return frame_count
		end
		return nil
	end)
end

--- Closes a message window and returns the frame counter; this stands in for message.run_talking when events are skipped.
function message.run_talking_skipping(window: s32, max_frames: s32)
	local frame_count: s32 = 0
	frame_count = 0
	local _ = message.step_skipping(window, 0)
	local _ = frame_count < max_frames
	frame_count = frame_count + 1
	frame_count = frame_count + 1
	message.close_skipping(window)
	return frame_count
end

--- Closes a message window and returns the frame counter; this stands in for message.run_talking_variant when events are skipped.
function message.run_talking_skipping_variant(window: s32, max_frames: any)
	local frame_count: s32 = 0
	local _ = max_frames > 0
	frame_count = 0
	local _ = message.step_skipping(window, 0)
	local _ = frame_count < max_frames
	frame_count = frame_count + 1
	frame_count = frame_count + 1
	message.close_skipping(window)
	return frame_count
end

--- Steps a message window while animating the mouth until it finishes or the frame limit passes, then closes it.
function message.run_talking_variant(window: any, max_frames: any)
	local is_finished: s32 = 0
	local frame_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_message_button_prompt(window, 0)
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		frame_count = 0
		while frame_count < max_frames do
			is_finished = message.step(window, 0)
			if is_finished ~= 0 then
				frame_count = vm.i32(frame_count + 1)
				break
			else
				resume_step = 1
				vm.wait(1)
				frame_count = vm.i32(frame_count + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		event.set_message_button_prompt(window, 1)
		message.close(window)
		return
	end, function(received: { any })
		if resume_step <= 1 then
			frame_count = frame_count + 1
			message.close_skipping(window)
			return frame_count
		end
		return nil
	end)
end

--- Shows a speech bubble between two characters, waits for it to finish and closes it.
function message.say_bubble(window: s32, text: any, speaker_slot: any, listener_slot: s32, unused: any)
	local chosen: s32 = 0
	message.open_bubble(window, text, speaker_slot, listener_slot)
	do
		local _: any
		_, chosen = message.wait_answer(window, 0, chosen)
	end
	message.close(window)
end

--- Stands in for message.say_bubble on the resumed path, running its open, answer wait and close steps without showing anything.
function message.say_bubble_skipping(window: s32, text: s32, speaker: any, listener: any, unused: any)
	local answer: s32 = 0
	message.open_bubble_stub(window, text, speaker, listener)
	do
		local _: any
		_, answer = message.wait_answer_skipping(window, 0, answer)
	end
	message.close_skipping(window)
end

--- Runs the cursor loop of a message choice list and returns the selected index, or minus one on cancel.
function message.select_option(window: s32, option_count: s32, selection: any, block_cancel: s32)
	local top_line: s32 = 0
	local buttons_pressed: s32 = 0
	local previous_direction: s32 = 0
	local stick_direction: s32 = 0
	local move_direction: s32 = 0
	local cancel_pressed: s32 = 0
	local confirm_pressed: s32 = 0
	local window_frame: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		top_line = event.get_message_selection_top_line(window) or top_line
		event.set_message_draw_speed(window, 0.0)
		move_direction = 0
		stick_direction = 0
		previous_direction = 0
		event.set_message_selection(window, -1)
		event.set_message_selection(window, selection)
		resume_point = 1
		message.wait_until_shown(window)
		while true do
			move_direction = 0
			stick_direction = message.get_stick_direction(window)
			if previous_direction == 0 and stick_direction == -1 then
				event.play_message_sound(2)
				move_direction = -1
			end
			if previous_direction == 0 and stick_direction == 1 then
				event.play_message_sound(2)
				move_direction = 1
			end
			previous_direction = stick_direction
			cancel_pressed = event.is_event_button_pressed(0) or cancel_pressed
			confirm_pressed = event.is_event_button_pressed(1) or confirm_pressed
			buttons_pressed = event.get_buttons_pressed() or buttons_pressed
			window_frame = event.get_message_window_frame(window) or window_frame
			if window_frame == 5 then
				if bit32.band(buttons_pressed, 32768) ~= 0 then
					event.play_message_sound(2)
					move_direction = -1
				end
				if bit32.band(buttons_pressed, 8192) ~= 0 then
					event.play_message_sound(2)
					move_direction = 1
				end
			else
				if bit32.band(buttons_pressed, 4096) ~= 0 then
					event.play_message_sound(2)
					move_direction = -1
				end
				if bit32.band(buttons_pressed, 16384) ~= 0 then
					event.play_message_sound(2)
					move_direction = 1
				end
			end
			if confirm_pressed ~= 0 then
				event.play_message_sound(3)
				resume_point = 2
				vm.wait(2)
				break
			else
				if cancel_pressed ~= 0 then
					event.play_message_sound(1)
					resume_point = 3
					vm.wait(3)
					if block_cancel == 0 then
						message.close(window)
						return -1
					end
				end
				if move_direction == 1 then
					if selection < vm.i32(vm.i32(option_count - 1) + top_line) then
						selection = selection + 1
					else
						selection = vm.i32(vm.i32(option_count - 1) + top_line)
					end
				end
				if move_direction == -1 then
					if top_line < selection then
						selection = selection - 1
					else
						selection = top_line
					end
				end
				event.set_message_selection(window, selection)
				resume_point = 4
				vm.wait(4)
			end
		end
		message.close(window)
		return selection
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point <= 1 then
				move_direction = 0
				stick_direction = message.get_stick_direction_skipping(window)
				move_direction = -1
				move_direction = 1
				local _ = previous_direction == 0
				local _ = previous_direction == 0
				previous_direction = stick_direction
				move_direction = -1
				move_direction = 1
				move_direction = -1
				move_direction = 1
			end
			message.close_skipping(window)
			return -1
		end
		if resume_point <= 4 then
			message.close_skipping(window)
			return selection
		end
		return nil
	end)
end

--- Sets a message window's mode.
function message.set_window_mode(window: s32, mode: s32)
	event.set_message_window_mode(window, mode)
end

--- Accepts a window and a mode and does nothing; this stands in for message.set_window_mode when events are skipped.
function message.set_window_mode_skipping(window: s32, mode: s32) end

--- Accepts a window and mode and does nothing.
function message.set_window_mode_stub(window: any, mode: s32) end

--- Does nothing; accepts a window and option that have no effect.
function message.set_window_option(window: any, option: any) end

--- Opens a message window, waits for it to be read and closes it.
function message.show(window: s32, text: any, position: s32, x: s32, y: s32)
	local answer: s32 = 0
	local _ = message.open(window, text, position, x, y)
	do
		local _: any
		_, answer = message.wait_answer(window, 0, answer)
	end
	message.close(window)
end

--- Opens a message window at the given screen slot and position, waits for the player's answer, closes the window and returns the answer.
function message.show_and_ask(window: s32, message_id: s32, screen_slot: s32, position_x: s32, position_y: s32, answer: s32)
	local _ = message.open_skipping(window, message_id, screen_slot, position_x, position_y)
	do
		local _: any
		_, answer = message.wait_answer_skipping(window, 1, answer)
	end
	message.close_skipping(window)
	return answer
end

--- Opens a message window, waits for it to be read and closes it.
function message.show_and_close(window: any, text: s32, position: s32, x: s32, y: s32)
	local answer: s32 = 0
	local _ = message.open_skipping(window, text, position, x, y)
	do
		local _: any
		_, answer = message.wait_answer_skipping(window, 0, answer)
	end
	message.close_skipping(window)
end

--- Opens a message window, waits for its answer and closes it.
function message.show_and_wait(window: s32, text: s32, position: s32, x: s32, y: s32)
	local chosen: s32 = 0
	local _ = message.open(window, text, position, x, y)
	do
		local _: any
		_, chosen = message.wait_answer(window, 0, chosen)
	end
	message.close(window)
end

--- Accepts message window arguments and does nothing; this stands in for message.show_and_wait when events are skipped.
function message.show_and_wait_skipping(window: s32, text: s32, position: s32, x: s32, y: s32)
	local chosen: s32 = 0
	local _ = message.open_skipping(window, text, position, x, y)
	do
		local _: any
		_, chosen = message.wait_answer_skipping(window, 0, chosen)
	end
	message.close_skipping(window)
end

--- Opens a bubble message for a speaker, waits for it to be read and closes it.
function message.show_bubble_and_close(window: any, text: s32, speaker: any, listener: any, unused_option: any)
	local answer: s32 = 0
	message.open_bubble_stub(window, text, speaker, listener)
	do
		local _: any
		_, answer = message.wait_answer_skipping(window, 0, answer)
	end
	message.close_skipping(window)
end

--- Starts a talk between two characters and shows the loaded bubble message twice.
function message.show_bubble_twice(speaker: s32, listener: s32)
	cutscene.begin_talk_stub_with_camera_flag(speaker, 0, 0)
	message.show_bubble_and_close(0, -1, speaker, listener, 0)
	message.show_bubble_and_close(0, -1, speaker, listener, 0)
end

--- Shows the pending text at a screen slot and waits for it to close.
function message.show_continued_at_slot()
	local screen_slot: s32 = 0
	cutscene.talk_skipping_variant(screen_slot, -1, 0, 0)
end

--- Sets window 1 to mode 4 and shows its pending text, without displaying anything when events are skipped.
function message.show_continued_in_window_1_skipping()
	message.set_window_mode_skipping(1, 4)
	message.show_and_wait_skipping(1, -1, 8, 0, 0)
end

--- Shows the pending text at a screen slot twice, waiting for each to close.
function message.show_continued_twice()
	local screen_slot: s32 = 0
	cutscene.talk_skipping_variant(screen_slot, -1, 0, 0)
	message.show_then_close_variant(0, -1, 0, screen_slot, 0)
end

--- Shows the defeat message window for a character and waits for it to be dismissed.
function message.show_defeat_message(character_id: s32)
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	message.show_and_wait(1, vm.i32(60 + character_id), 8, 0, 0)
end

--- Accepts a character and does nothing; this stands in for message.show_defeat_message when events are skipped.
function message.show_defeat_message_skipping(character_id: s32)
	message.set_window_mode_skipping(1, 4)
	message.show_and_wait_skipping(1, vm.i32(60 + character_id), 8, 0, 0)
end

--- Starts a talk and shows nine message pages at a screen slot, without displaying anything when events are skipped.
function message.show_nine_pages_skipping(screen_slot: any, bubble_x: any)
	cutscene.begin_talk_stub(screen_slot, 0, 0)
	message.say_bubble_skipping(0, -1, screen_slot, bubble_x, 0)
	message.say_bubble_skipping(0, -1, screen_slot, bubble_x, 0)
	message.say_bubble_skipping(0, -1, screen_slot, bubble_x, 0)
	message.say_bubble_skipping(0, -1, screen_slot, bubble_x, 0)
	message.say_bubble_skipping(0, -1, screen_slot, bubble_x, 0)
	message.say_bubble_skipping(0, -1, screen_slot, bubble_x, 0)
	message.say_bubble_skipping(0, -1, screen_slot, bubble_x, 0)
	message.say_bubble_skipping(0, -1, screen_slot, bubble_x, 0)
	message.say_bubble_skipping(0, -1, screen_slot, bubble_x, 0)
end

--- Shows four message pages, a two-option question and a final page at a screen slot.
function message.show_pages_then_ask()
	local screen_slot: s32 = 0
	character.interpolate_between_points(0, screen_slot, 0)
	message.show_then_close(0, -1, screen_slot, 0, 0)
	message.show_then_close(0, -1, screen_slot, 0, 0)
	message.show_then_close(0, -1, screen_slot, 0, 0)
	message.show_then_close(0, -1, screen_slot, 0, 0)
	message.set_window_mode_stub(0, 1)
	local _ = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
	message.show_then_close(0, -1, screen_slot, 0, 0)
end

--- Shows the partner's hint for the next story goal in message window 3 based on the current story save flags.
function message.show_story_hint()
	local story_flag: s32 = 0
	local lapis_flag_1: s32 = 0
	local lapis_flag_2: s32 = 0
	local lapis_flag_3: s32 = 0
	local lapis_flag_4: s32 = 0
	story_flag = event.get_save_flag(732) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "やったな！ニンゲンも\n少しはやるもんだ。<page>見直したぜ。")
		return
	end
	story_flag = event.get_save_flag(728) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"いよいよ最後だね。\n奴を倒せば全て終わる。<page>そして、新しい何かが\n始まるんだ。"
		)
		return
	end
	story_flag = event.get_save_flag(712) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"グリフォンの気持ちもわかるけど、\n彼のした事は許されないと思うんだ。"
		)
		return
	end
	story_flag = event.get_save_flag(702) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "庭園を元に戻して、グリフォン、\nいやサンの秘密をあばくんだ。")
		return
	end
	story_flag = event.get_save_flag(700) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"「サンの思い出」って何の事かな？\n宮殿に入ってみなきゃわかんないよ。"
		)
		return
	end
	story_flag = event.get_save_flag(640) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"ぼやぼやしているとグリフォンを\n逃がしてしまうよ。<page>早く月花宮殿へ行かなきゃ。"
		)
		return
	end
	lapis_flag_1 = event.get_save_flag(624) or lapis_flag_1
	lapis_flag_2 = event.get_save_flag(628) or lapis_flag_2
	lapis_flag_3 = event.get_save_flag(632) or lapis_flag_3
	lapis_flag_4 = event.get_save_flag(636) or lapis_flag_4
	if (if (if (if lapis_flag_1 ~= 0 then lapis_flag_2 else 0) ~= 0 then lapis_flag_3 else 0) ~= 0 then lapis_flag_4 else 0) ~= 0 then
		event.open_message_window_2(
			3,
			"ラピスは全て手に入れたよね。\n急いでカザロフストーンへ行こう。"
		)
		return
	end
	story_flag = event.get_save_flag(616) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"とにかく、急いでラピスを探さなきゃ、\n取り返しのつかない事になっちゃうよ。"
		)
		return
	end
	story_flag = event.get_save_flag(600) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"この宮殿から全てが始まったんだね。\nとりあえず、中に入ってみようよ。"
		)
		return
	end
	story_flag = event.get_save_flag(540) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"そろそろ、ルナ研に戻ってみない？\nイクシオンが完成してるかもしれないよ。"
		)
		return
	end
	story_flag = event.get_save_flag(536) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"いよいよグリフォンへの反撃開始だ。\nパズノス要塞へ行ってみようよ。"
		)
		return
	end
	story_flag = event.get_save_flag(526) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "なにぼやぼやしてるの！\n早くモニカを助けなきゃ！")
		return
	end
	story_flag = event.get_save_flag(524) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"ドナ・ホーンさんが\n言っていたよね。<page>ファイアーホーンを奏でれば\n道は開けるって。"
		)
		return
	end
	story_flag = event.get_save_flag(520) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(3, "なにぼやぼやしてるの！\n早くモニカを助けなきゃ！")
		return
	end
	story_flag = event.get_save_flag(508) or story_flag
	if story_flag ~= 0 then
		event.open_message_window_2(
			3,
			"ファイアースコール装置を\n壊さなきゃ。<page>ガンドール火山の頂上に\nあるって言っていたよね。"
		)
		return
	end
	event.open_message_window_2(
		3,
		"待っているだけでは\n何も起きないよ。<page>まだ行った事のない場所が\nあるんじゃないの。"
	)
end

--- Shows text 2000 without displaying anything when events are skipped, and returns 1.
function message.show_text_2000()
	message.show_and_wait_skipping(0, 2000, 8, 0, 0)
	return 1
end

--- Shows text 2000 twice in a row, without displaying anything when events are skipped.
function message.show_text_2000_twice()
	local _ = message.show_text_2000()
	local _ = message.show_text_2000()
end

--- Runs a skip-mode wait of 30 frames, shows and closes a text, and asks a two-option question, without displaying anything when events are skipped.
function message.show_text_then_ask()
	wait.frames_skipping(30)
	cutscene.skip_command(1)
	message.open_skipping(0, -1, 8, 0, 0)
	message.wait_voice_or_button_skipping(0)
	message.close_skipping(0)
	message.open_skipping(0, -1, 5, 0, 0)
	local _ = message.resume_choice(0, 2, 0, 1)
end

--- Opens a message window at the given screen slot, waits for it to finish and closes it.
function message.show_then_close(window: any, message_id: s32, screen_slot: s32, position_x: s32, unused_argument: any)
	local answer: s32 = 0
	message.open_bubble_stub(window, message_id, screen_slot, position_x)
	do
		local _: any
		_, answer = message.wait_answer_skipping(window, 0, answer)
	end
	message.close_skipping(window)
end

--- Opens a message window at the given screen slot, waits for it to finish and closes it; a duplicate of show_then_close.
function message.show_then_close_variant(window: s32, message_id: s32, screen_slot: s32, position_x: s32, unused_argument: any)
	local answer: s32 = 0
	message.open_bubble_stub(window, message_id, screen_slot, position_x)
	do
		local _: any
		_, answer = message.wait_answer_skipping(window, 0, answer)
	end
	message.close_skipping(window)
end

--- Shows three messages in sequence and then opens a question.
function message.show_three_lines_then_ask()
	local answer: s32 = 0
	message.show_and_wait_skipping(0, -1, 5, 256, 208)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	answer = message.show_and_ask(0, -1, 5, 256, 208, answer)
end

--- Opens a message window and runs it for at most the given number of frames.
function message.show_timed(window: s32, text: s32, position: s32, x: s32, y: s32, frame_limit: s32)
	local _ = message.open(window, text, position, x, y)
	local _ = message.run_talking_for_frames(window, frame_limit)
	event.set_message_bubble_screen_slot(window, 0)
end

--- Opens a message window and runs it for at most the given number of frames.
function message.show_timed_primary(window: s32, text: s32, position: s32, x: s32, y: s32, frame_limit: s32)
	local _ = message.open(window, text, position, x, y)
	local _ = message.run_talking_for_frames_primary(window, frame_limit)
	event.set_message_bubble_screen_slot(window, 0)
end

--- Opens and closes a message window without showing it; this stands in for message.show_timed when events are skipped.
function message.show_timed_skipping(window: s32, text: s32, position: s32, x: s32, y: s32, frame_limit: s32)
	local _ = message.open_skipping(window, text, position, x, y)
	local _ = message.run_talking_skipping_variant(window, frame_limit)
end

--- Opens and closes a message window without showing it; this stands in for message.show_timed_primary when events are skipped.
function message.show_timed_skipping_primary(window: s32, text: s32, position: s32, x: s32, y: s32, frame_limit: s32)
	local _ = message.open_skipping(window, text, position, x, y)
	local _ = message.run_talking_skipping(window, frame_limit)
end

--- Shows two message pages at a screen slot and then asks a two-option question, without displaying anything when events are skipped.
function message.show_two_pages_then_ask(screen_slot: s32)
	message.set_window_mode_skipping(0, 7)
	wait.frames_skipping(20)
	cutscene.skip_command(1)
	paznos_bridge.update_talk_state(0, -1, screen_slot, 0, 0)
	cutscene.skip_command(1)
	paznos_bridge.update_talk_state(0, -1, screen_slot, 0, 0)
	message.set_window_mode_skipping(0, 1)
	local _ = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 0)
end

--- Shows two texts at screen slot 24 and then asks a two-option question in window 0.
function message.show_two_texts_then_ask()
	local screen_slot: s32 = 0
	screen_slot = 24
	cutscene.talk_skipping_variant(screen_slot, -1, 0, 0)
	cutscene.talk_skipping_variant(screen_slot, -1, 0, 0)
	local _ = message.open_choice_skipping(0, -1, 8, 0, 0, 6, 0)
end

--- Shows the villager remark with the given index in a message window.
function message.show_villager_remark(window: s32, remark_index: s32)
	if remark_index == 1 then
		event.open_message_window_2(
			window,
			"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
		)
	end
	if remark_index == 2 then
		event.open_message_window_2(
			window,
			"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
		)
	end
	if remark_index == 3 then
		event.open_message_window_2(
			window,
			"世界にはアッシの知らない植物が\nまだまだたくさんあるんですかねぇ。"
		)
	end
	if remark_index == 4 then
		event.open_message_window_2(
			window,
			"おう。ゼルマイト探しは進んでるか？\nなんか手伝うことがあったら\n遠慮なく言ってくれ。"
		)
	end
	if remark_index == 5 then
		event.open_message_window_2(window, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	if remark_index == 6 then
		event.open_message_window_2(window, "ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。")
	end
	if remark_index == 7 then
		event.open_message_window_2(
			window,
			"料理の勉強をして世界一の\nコックをめざします。そしたら、\n坊ちゃんに一番にごちそうしますね。"
		)
	end
	if remark_index == 8 then
		event.open_message_window_2(window, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	if remark_index == 9 then
		event.open_message_window_2(window, "よっ！元気か。オレも元気だぜ。")
	end
	if remark_index == 10 then
		event.open_message_window_2(
			window,
			"ゼルマイト鉱山は怖いところです。\nくれぐれも気をつけてくださいませ。"
		)
	end
	if remark_index == 11 then
		event.open_message_window_2(window, "ご無事をお祈りします・・・")
	end
	if remark_index == 12 then
		event.open_message_window_2(window, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	if remark_index == 13 then
		event.open_message_window_2(window, "おまえ、ホントに冒険が好きだよなぁ。")
	end
	if remark_index == 14 then
		event.open_message_window_2(window, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	if remark_index == 15 then
		event.open_message_window_2(window, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	if remark_index == 16 then
		event.open_message_window_2(
			window,
			"これからは、ニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	if remark_index == 17 then
		event.open_message_window_2(
			window,
			"頼みごとをしていて言うのも変だが、\n鉱山は危険な場所だ。\nあまり無理をしないようにな。"
		)
	end
	if remark_index == 18 then
		event.open_message_window_2(window, "これから先も、永久に世界が\n平和でありますように。")
	end
	if remark_index == 19 then
		event.open_message_window_2(
			window,
			"バース鉄道が世界中に広がったら\nいろんなところにいけるようになるね。"
		)
	end
	if remark_index == 20 then
		event.open_message_window_2(window, "はやく、いろんなところに行って\n釣りをしてみたいよね。")
	end
	if remark_index == 21 then
		event.open_message_window_2(
			window,
			"フラビンたら、少しは釣り以外の\nことにも興味を持って欲しいわ。"
		)
	end
	if remark_index == 22 then
		event.open_message_window_2(
			window,
			"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
		)
	end
	if remark_index == 23 then
		event.open_message_window_2(
			window,
			"バース鉄道が世界中に広がったら\nいろんなところに旅行とか\n行っちゃおっかな。"
		)
	end
	if remark_index == 24 then
		event.open_message_window_2(
			window,
			"ねぇねぇ、最近なんか、こっそり\n楽しいことしてるでしょ？\nわたしにも教えてよ～。"
		)
	end
	if remark_index == 25 then
		event.open_message_window_2(
			window,
			"そうだねぇ、バース鉄道が完成したら\n”世界の果て”を見てみたいねぇ。"
		)
	end
end

--- Shows the villager remark with the given index, using the alternate line wrapping.
function message.show_villager_remark_variant(window: s32, remark_index: s32)
	if remark_index == 1 then
		event.open_message_window_2(
			window,
			"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
		)
	end
	if remark_index == 2 then
		event.open_message_window_2(
			window,
			"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
		)
	end
	if remark_index == 3 then
		event.open_message_window_2(
			window,
			"世界にはアッシの知らない\n植物が、まだまだたくさん\nあるんですかねぇ。"
		)
	end
	if remark_index == 4 then
		event.open_message_window_2(
			window,
			"おう。ゼルマイト探しは進んでるか？\nなんか手伝うことがあったら\n遠慮なく言ってくれ。"
		)
	end
	if remark_index == 5 then
		event.open_message_window_2(window, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	if remark_index == 6 then
		event.open_message_window_2(
			window,
			"ゼルマイト探しもいいが\nはりきりすぎて\n体を壊さんようにな。"
		)
	end
	if remark_index == 7 then
		event.open_message_window_2(
			window,
			"料理の勉強をして世界一のコックを\nめざします。そしたら、坊ちゃんに\n一番にごちそうしますね。"
		)
	end
	if remark_index == 8 then
		event.open_message_window_2(window, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	if remark_index == 9 then
		event.open_message_window_2(window, "よっ！元気か。オレも元気だぜ。")
	end
	if remark_index == 10 then
		event.open_message_window_2(
			window,
			"ゼルマイト鉱山は怖いところ\nです。くれぐれも気をつけて\nくださいませ。"
		)
	end
	if remark_index == 11 then
		event.open_message_window_2(window, "ご無事をお祈りします・・・")
	end
	if remark_index == 12 then
		event.open_message_window_2(window, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	if remark_index == 13 then
		event.open_message_window_2(window, "おまえ、ホントに\n冒険が好きだよなぁ。")
	end
	if remark_index == 14 then
		event.open_message_window_2(window, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	if remark_index == 15 then
		event.open_message_window_2(window, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	if remark_index == 16 then
		event.open_message_window_2(
			window,
			"これからはニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	if remark_index == 17 then
		event.open_message_window_2(
			window,
			"頼みごとをしていて言うのも変だが、\n鉱山は危険な場所だ。\nあまり無理をしないようにな。"
		)
	end
	if remark_index == 18 then
		event.open_message_window_2(window, "これから先も、永久に世界が\n平和でありますように。")
	end
	if remark_index == 19 then
		event.open_message_window_2(
			window,
			"バース鉄道が世界中に\n広がったら、いろんなところに\nいけるようになるね。"
		)
	end
	if remark_index == 20 then
		event.open_message_window_2(window, "はやく、いろんなところに行って\n釣りをしてみたいよね。")
	end
	if remark_index == 21 then
		event.open_message_window_2(
			window,
			"フラビンたら、少しは釣り以外の\nことにも興味を持って欲しいわ。"
		)
	end
	if remark_index == 22 then
		event.open_message_window_2(
			window,
			"ゼルマイト鉱山から、\n何か恐ろしい気を感じるの。\n気をつけてね。"
		)
	end
	if remark_index == 23 then
		event.open_message_window_2(
			window,
			"バース鉄道が世界中に広がったら\nいろんなところに旅行とか\n行っちゃおっかな。"
		)
	end
	if remark_index == 24 then
		event.open_message_window_2(
			window,
			"ねぇねぇ、最近なんか、こっそり\n楽しいことしてるでしょ？\nわたしにも教えてよ～。"
		)
	end
	if remark_index == 25 then
		event.open_message_window_2(
			window,
			"そうだねぇ、バース鉄道が完成したら\n”世界の果て”を見てみたいねぇ。"
		)
	end
end

--- Opens a message window with the text of a voice line and plays the voice with it.
function message.show_voiced(voice_id: s32)
	event.open_message_window_2(0, voice_id)
	message.play_voiced_window(voice_id)
end

--- Plays a voice line with its message text for a number of frames.
function message.show_voiced_for(voice_id: s32, duration: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	event.open_voice_stream_wave(1, voice_id)
	while true do
		stream_open_state = event.get_voice_stream_open_state() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, voice_id)
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	message.wait_voice_for(0, duration)
	message.close(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

--- Waits for a voice duration and a number of frames without showing anything; this stands in for showing a voiced message for a number of frames when events are skipped.
function message.show_voiced_for_frames_skipping(unused_value: s32, voice_duration: s32, frames: any)
	cutscene.skip_command(1)
	message.open_skipping(0, -1, 8, 0, 0)
	message.wait_voice_for_skipping(0, voice_duration)
	local _ = frames > 0
	wait.frames_skipping(frames)
	message.close_skipping(0)
end

--- Accepts a voice and a duration and does nothing; this stands in for message.show_voiced_for when events are skipped.
function message.show_voiced_for_skipping(voice_id: s32, duration: s32)
	message.open_skipping(0, -1, 8, 0, 0)
	message.wait_voice_for_skipping(0, duration)
	message.close_skipping(0)
end

--- Plays a voice line with its message text for a number of frames and then stops the voice.
function message.show_voiced_for_stopping(voice_id: s32, duration: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	event.open_voice_stream_wave(1, voice_id)
	while true do
		stream_open_state = event.get_voice_stream_open_state() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, voice_id)
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	message.wait_voice_stopping_for(0, duration)
	message.close(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

--- Counts a voice wait without opening a window; this stands in for message.show_voiced_for_stopping when events are skipped.
function message.show_voiced_for_stopping_skipping(voice_id: s32, duration: s32)
	message.open_skipping(0, -1, 8, 0, 0)
	message.wait_voice_stopping_for_skipping(0, duration)
	message.close_skipping(0)
end

--- Streams a voice line while showing its message window and animating the mouth until the line ends.
function message.show_voiced_line(voice_id: s32, max_frames: s32)
	local open_state: s32 = 0
	local ready_state: s32 = 0
	event.open_voice_stream_wave(1, voice_id)
	while true do
		open_state = event.get_voice_stream_open_state() or open_state
		if open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		ready_state = event.get_voice_stream_open_state() or ready_state
		if ready_state == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, voice_id)
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	message.run_talking(0, max_frames)
	message.close(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

--- Streams a voice line while showing its message window and animating the mouth until the line ends.
function message.show_voiced_line_variant(voice_id: s32, max_frames: s32)
	local open_state: s32 = 0
	local ready_state: s32 = 0
	event.open_voice_stream_wave(1, voice_id)
	while true do
		open_state = event.get_voice_stream_open_state() or open_state
		if open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		ready_state = event.get_voice_stream_open_state() or ready_state
		if ready_state == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, voice_id)
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	message.run_talking_variant(0, max_frames)
	message.close(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

--- Accepts a voice line and does nothing; this stands in for message.show_voiced when events are skipped.
function message.show_voiced_skipping(voice_id: s32)
	message.play_voiced_window_skipping(voice_id)
end

--- Plays a voice line with its message text, then keeps the window open with its button prompt for a number of frames.
function message.show_voiced_then_hold(voice: any, duration: s32, hold_frames: any)
	local button_prompt: s32 = 0
	event.call_command(231, 0, button_prompt) -- retail: the handler rejects 2 arguments
	event.open_voice_stream_wave(1, voice)
	sound.wait_voice_stream_ready(1)
	event.play_voice_stream(1)
	event.open_message_window_2(0, voice)
	message.open(0, -1, 8, 0, 0)
	message.wait_voice_for(0, duration)
	event.set_message_button_prompt(0, button_prompt)
	wait.frames(hold_frames)
	event.set_message_button_prompt(0, 0)
	event.close_voice_stream(1)
	message.close(0)
end

--- Counts a voice wait and a hold time without waiting; this stands in for message.show_voiced_then_hold when events are skipped.
function message.show_voiced_then_hold_skipping(voice: any, duration: s32, hold_frames: any)
	cutscene.skip_command(1)
	message.open_skipping(0, -1, 8, 0, 0)
	message.wait_voice_for_skipping(0, duration)
	local _ = hold_frames > 0
	wait.frames_skipping(hold_frames)
	message.close_skipping(0)
end

--- Opens a voiced message, streams its voice, shows a button prompt for a number of frames and closes it. It shows a button prompt.
function message.show_voiced_with_button_prompt(voice_id: s32, voice_option: s32, hold_frames: any)
	local button_prompt: s32 = 0
	event.call_command(231, 0, button_prompt) -- retail: the handler rejects 2 arguments
	event.open_voice_stream_wave(1, voice_id)
	sound.wait_voice_stream_ready(1)
	event.play_voice_stream(1)
	event.open_message_window_2(0, voice_id)
	message.open(0, -1, 8, 0, 0)
	message.wait_voice_for(0, voice_option)
	event.set_message_button_prompt(0, button_prompt)
	wait.frames(hold_frames)
	event.set_message_button_prompt(0, 0)
	event.close_voice_stream(1)
	message.close(0)
end

--- Runs one frame of a message window's mouth animation and answer buttons; returns 0 until the window gives a result.
function message.step(window: any, answers: s32)
	local uses_button_2: s32 = 0
	local uses_button_3: s32 = 0
	local window_frame: s32 = 0
	local play_sound: s32 = 0
	local stream_playing: s32 = 0
	local window_state: s32 = 0
	local button_0_pressed: s32 = 0
	local button_1_pressed: s32 = 0
	local button_2_pressed: s32 = 0
	local button_3_pressed: s32 = 0
	uses_button_2 = 0
	uses_button_3 = 0
	if answers == 1 then
		uses_button_2 = 1
	end
	if answers == 2 then
		uses_button_3 = 1
	end
	window_frame = event.get_message_window_frame(window) or window_frame
	play_sound = 1
	if window_frame == 7 then
		play_sound = 0
	end
	if window_frame == 0 then
		play_sound = 0
	end
	stream_playing = event.is_voice_stream_playing() or stream_playing
	window_state = event.get_message_window_state(window) or window_state
	if window_state == 0 then
		return 0
	end
	if window_state == 1 then
		return 0
	end
	if window_state == 3 then
		if stream_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	if window_state == 4 then
		return 0
	end
	if window_state == 5 then
		if stream_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	button_0_pressed = event.is_event_button_pressed(0) or button_0_pressed
	button_1_pressed = event.is_event_button_pressed(1) or button_1_pressed
	button_2_pressed = event.is_event_button_pressed(2) or button_2_pressed
	button_3_pressed = event.is_event_button_pressed(3) or button_3_pressed
	if
		(
			if (if (if button_0_pressed ~= 0 then 1 else button_1_pressed) ~= 0 then 1 else if uses_button_2 ~= 0 then button_2_pressed else 0)
					~= 0
				then 1
				else if uses_button_3 ~= 0 then button_3_pressed else 0
		) ~= 0
	then
		if play_sound ~= 0 then
			if button_1_pressed ~= 0 then
				event.play_message_sound(0)
			end
			if button_0_pressed ~= 0 then
				event.play_message_sound(1)
			end
			if (if uses_button_2 ~= 0 then button_2_pressed else 0) ~= 0 then
				event.play_message_sound(0)
			end
			if (if uses_button_3 ~= 0 then button_3_pressed else 0) ~= 0 then
				event.play_message_sound(0)
			end
		end
		if window_state == 5 then
			event.advance_message_page(window)
			if stream_playing == 0 then
				event.trigger_mouth_texture_animation(1)
				event.trigger_mouth_motion(0)
			end
		end
		if window_state == 3 then
			if stream_playing == 0 then
				event.trigger_mouth_texture_animation(0)
				event.trigger_mouth_motion(2)
			end
			if (if uses_button_2 ~= 0 then button_2_pressed else 0) ~= 0 then
				return 2
			end
			if (if uses_button_3 ~= 0 then button_3_pressed else 0) ~= 0 then
				return 3
			end
			return 1
		end
		if window_state ~= 5 and window_state ~= 3 then
			event.set_message_draw_speed(window, 0.0)
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
			if stream_playing ~= 0 then
				event.stop_voice_stream(1)
			end
		end
	end
	return 0
end

--- Returns 0 for a window and answer count; this stands in for message.step when events are skipped.
function message.step_skipping(window: any, answers: any)
	return 0
end

--- Plays the conversation with the Gundorada villager that the player talked to, then restores villager AI.
function message.talk_to_gundorada_villager()
	local player_slot: s32 = 0
	local villager_slot: s32 = 0
	local villager_id: s32 = 0
	local end_mode: s32 = 0
	local save_flag_640: s32 = 0
	local save_flag_616: s32 = 0
	local save_flag_540: s32 = 0
	local save_flag_536: s32 = 0
	local save_flag_640_b: s32 = 0
	local save_flag_616_b: s32 = 0
	local save_flag_540_b: s32 = 0
	local save_flag_536_b: s32 = 0
	local save_flag_520: s32 = 0
	local facing_player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local look_angle: f32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	villager_slot = event.get_triggered_event_data_2(13) or villager_slot
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	print("talk_chara_id=", villager_slot, "talk_chara=", villager_id, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	end_mode = 0
	if villager_id == 400 then
		save_flag_640 = event.get_save_flag(640) or save_flag_640
		if save_flag_640 == 0 then
			save_flag_616 = event.get_save_flag(616) or save_flag_616
			if save_flag_616 == 0 then
				save_flag_540 = event.get_save_flag(540) or save_flag_540
				if save_flag_540 == 0 then
					save_flag_536 = event.get_save_flag(536) or save_flag_536
					if save_flag_536 == 0 then
						event.open_message_window_2(
							0,
							"ギルトーニは手強い、決して\n油断してはならぬぞ。<page>キミならきっと勝てるはずだ。\nアトラミリアに選ばれた\nキミなら・・・"
						)
					else
						event.open_message_window_2(
							0,
							"そうか、ギルトーニも\n悲しい男だったのだな。<page>グリフォンは二つの時代の\n人々を巻き込んで、いったい\n何をするつもりなのだ・・・"
						)
					end
				else
					event.open_message_window_2(
						0,
						"君たちならきっと、\nグリフォンを倒すことが\nできるだろう。<page>期待しているぞ。"
					)
				end
			else
				event.open_message_window_2(
					0,
					"クロノユニオン・・・<page>古代人たちの英知によって\n世界が救われると\n言うのか・・・"
				)
			end
		else
			event.open_message_window_2(
				0,
				"いよいよ最後の決戦か。\nグリフォン大帝との闘いには、\n多くの仲間の血が流された・・・<page>絶対に負けるわけにはいかん！\nユリス、モニカ、頼んだぞ。\n必ず、奴を倒すのだ。"
			)
		end
	end
	if villager_id == 401 then
		save_flag_640_b = event.get_save_flag(640) or save_flag_640_b
		if save_flag_640_b == 0 then
			save_flag_616_b = event.get_save_flag(616) or save_flag_616_b
			if save_flag_616_b == 0 then
				save_flag_540_b = event.get_save_flag(540) or save_flag_540_b
				if save_flag_540_b == 0 then
					save_flag_536_b = event.get_save_flag(536) or save_flag_536_b
					if save_flag_536_b == 0 then
						save_flag_520 = event.get_save_flag(520) or save_flag_520
						if save_flag_520 == 0 then
							event.open_message_window_2(
								0,
								"よう、まずはファイアースコールを破壊して、\n火炎雨をどうにかしねぇと、ヘイム・ラダを\n元に戻すことなんてできないぜ。"
							)
						else
							event.open_message_window_2(
								0,
								"そうか、そんなことになってしまったか。\nファイアースコールを破壊しただけでも、\nまずはよかったというべきか。"
							)
							cutscene.face_each_other(player_slot, villager_slot, 0)
							message.say_bubble(0, -1, villager_slot, player_slot, 0)
							end_mode = 1
							event.open_message_window_2(
								0,
								"しかし、火口に落ちてしまった\nおまえさんの連れも心配だな。<page>こうなったら、ヘイム・ラダを復興して、\nこのガンドラダをさらにパワーアップする\nしかないな。"
							)
						end
					else
						event.open_message_window_2(
							0,
							"ギルトーニを倒しちまうとは、\nおまえたち、スゲェんだな。<page>後は親玉のグリフォン大帝だ。\n気合を入れてかかれよ。"
						)
					end
				else
					event.open_message_window_2(
						0,
						"パズノスの活躍、見せてもらった。\nうれしくてつい涙が出ちまったぜ。<page>なんてったって、移動要塞パズノスは\nオレたちの血と汗の結晶だからな。"
					)
				end
			else
				event.open_message_window_2(
					0,
					"ラピス？\nう～ん、オレにはなんのことだか\nわかんねぇなぁ。"
				)
			end
		else
			event.open_message_window_2(
				0,
				"いよいよ、グリフォンってやつと\n対決するわけだな。<page>がんばれよ、兄弟！"
			)
		end
	end
	if villager_id == 402 then
		event.open_message_window_2(0, "ヘーイ、いいのがそろってるよ！\n買ってって！！")
	end
	if villager_id == 403 then
		event.open_message_window_2(
			0,
			"パーツの品揃えならまかしときな。\nウチでさがせば、バッチリだぜ。"
		)
	end
	if villager_id == 404 then
		event.open_message_window_2(
			0,
			"バトルは奥が深い。武器だけでゴリ押し\nしているようでは、まだまだだぜ。<page>バトルってやつは、アイテムを使って、\n切り抜けるのが、かっこいいんだ。"
		)
	end
	if villager_id == 405 then
		event.open_message_window_2(
			0,
			"ガンドラダ大工房でつくれないもの\nなどない。どんな巨大なものでも\nこの工房でならつくれてしまうんだぜ。"
		)
	end
	if villager_id == 406 then
		event.open_message_window_2(
			0,
			"オイ、おまえたちどこから入ってきたんだ。\nここは、危ないから気をつけるんだぞ。"
		)
	end
	if villager_id == 407 then
		event.open_message_window_2(
			0,
			"ボクら今までどうしてたんだろう？\nなんか思い出せないんだよね。"
		)
	end
	if villager_id == 408 then
		event.open_message_window_2(
			0,
			"オレたちがグリフォンに消されていた\nなんて・・・なんて恐ろしいやつなんだ。\nグリフォン大帝ってやつは。"
		)
	end
	if villager_id == 409 then
		event.open_message_window_2(0, "今、いそがしいんです。\n邪魔しないでください。")
	end
	if villager_id == 410 then
		event.open_message_window_2(
			0,
			"私たちもカゲながら健闘を祈っています。\nがんばってください！！"
		)
	end
	if villager_id == 411 then
		event.open_message_window_2(
			0,
			"おっとー、ここの\nケースの中の武器は\n非売品らしいぜ。<page>しっかし、世の中には\nいろんな形をした武器が\nあるもんだなぁ・・・"
		)
	end
	if villager_id == 412 then
		event.open_message_window_2(
			0,
			"ファイアースコールを\n降らせるなんて、\nギルトーニって奴は・・・<page>ずるがしこいって言うか・・・\n本当にひどい奴だ。"
		)
	end
	if villager_id == 413 then
		event.open_message_window_2(0, "何だ？この看板の\nハートは・・・<page>趣味悪いぜ・・・")
	end
	if end_mode == 0 then
		cutscene.talk(villager_slot, -1, 0, 0)
	end
	if end_mode == 1 then
		message.say_bubble(0, -1, villager_slot, player_slot, 0)
		event.set_character_motion(villager_slot, "立ち")
		event.finish_event()
	end
	if end_mode == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		facing_player_slot = event.get_player_character_slot() or facing_player_slot
		do
			local out1, _, out3 = event.get_character_position(facing_player_slot)
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		do
			local out1, _, out3 = event.get_character_position(villager_slot)
			villager_x = out1 or villager_x
			villager_z = out3 or villager_z
		end
		look_angle = event.get_look_angle(villager_x - player_x, villager_z - player_z) or look_angle
		character.turn_to_angle(facing_player_slot, look_angle)
		event.set_character_rotation(facing_player_slot, 0.0, look_angle, 0.0)
		event.set_character_motion(facing_player_slot, "立ち")
		message.say_bubble(0, -1, villager_slot, facing_player_slot, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, villager_slot)
	if villager_id == 402 then
		menu.open_type_6(30)
	end
	if villager_id == 403 then
		menu.open_type_6(28)
	end
	if villager_id == 404 then
		menu.open_type_6(29)
	end
end

--- Plays the conversation with the Lunar Wisdom Laboratory staff member that the player talked to, then restores villager AI.
function message.talk_to_lunar_lab_staff()
	local player_slot: s32 = 0
	local villager_slot: s32 = 0
	local villager_id: s32 = 0
	local end_mode: s32 = 0
	local save_flag_640: s32 = 0
	local save_flag_456: s32 = 0
	local save_flag_420: s32 = 0
	local save_flag_408: s32 = 0
	local invention_created: s32 = 0
	local save_value: s32 = 0
	local save_flag_640_b: s32 = 0
	local save_flag_616: s32 = 0
	local save_flag_600: s32 = 0
	local save_flag_448: s32 = 0
	local playable_character: s32 = 0
	local facing_player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local look_angle: f32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	villager_slot = event.get_triggered_event_data_2(13) or villager_slot
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	print("talk_chara_id=", villager_slot, "talk_chara=", villager_id, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	end_mode = 0
	if villager_id == 300 then
		save_flag_640 = event.get_save_flag(640) or save_flag_640
		if save_flag_640 == 0 then
			save_flag_456 = event.get_save_flag(456) or save_flag_456
			if save_flag_456 == 0 then
				event.open_message_window_2(
					0,
					"ん？キミは・・・？ここには、世界最高の研究機関\nルナティックウィズダム研究所が、できるはず\nだったんだ。<page>今では、こんなになってしまってるけどね。"
				)
			else
				event.open_message_window_2(
					0,
					"ルナ研のすばらしさは、ひとことでは\n言い尽くせないよ。キミが自分の目で\n確かめることだね。"
				)
			end
		else
			event.open_message_window_2(
				0,
				"グリフォンを倒さないと本当の歴史を\n取り戻すことはできないんだ。<page>グリフォンの存在自体が、この歴史を\nゆがめてしまってるんだからね。"
			)
		end
	end
	if villager_id == 301 then
		save_flag_420 = event.get_save_flag(420) or save_flag_420
		if save_flag_420 == 0 then
			save_flag_408 = event.get_save_flag(408) or save_flag_408
			if save_flag_408 == 0 then
				event.open_message_window_2(0, "グガー、グガー")
				end_mode = 2
			else
				invention_created = event.is_invention_created(309) or invention_created
				if invention_created < 0 then
					event.open_message_window_2(
						0,
						"アクアリウムを発明するヒントは\n木箱、窓、噴水だ。<page>おまえの町にも\nそれくらいはあるだろ。"
					)
				else
					save_value = event.get_save_data_value(2) or save_value
					if save_value == 0 then
						event.open_message_window_2(
							0,
							"アクアリウムの中の魚に「電気ミミズ」を\n食わせて、電気を帯びた魚をつくるんだ。\nそいつを例のシーグラに食わせる。<page>忘れるなよ。"
						)
					else
						event.open_message_window_2(
							0,
							"おっ、電気を帯びた魚はできたようだな。\nじゃ、あとはそいつをシーグラに食わせて\nみるんだ。ま、せいぜい、がんばってな。"
						)
					end
				end
			end
		else
			event.open_message_window_2(
				0,
				"お！成功したみたいだな。\nやはり、私の発明品は役に立つ。\nうむうむ。"
			)
		end
	end
	if villager_id == 302 then
		event.open_message_window_2(
			0,
			"オズモンドといい、所長といい、\nこのルナ研は、変わり者が多いんだよな～。"
		)
	end
	if villager_id == 303 then
		save_flag_640_b = event.get_save_flag(640) or save_flag_640_b
		if save_flag_640_b == 0 then
			save_flag_616 = event.get_save_flag(616) or save_flag_616
			if save_flag_616 == 0 then
				save_flag_600 = event.get_save_flag(600) or save_flag_600
				if save_flag_600 == 0 then
					save_flag_448 = event.get_save_flag(448) or save_flag_448
					if save_flag_448 == 0 then
						event.open_message_window_2(
							0,
							"シェルトーキーは、大切にしてくれよ。\nあれはルナ研の大事な発明品のひとつなんだ。"
						)
					else
						event.open_message_window_2(
							0,
							"時間がない。急いでくれ、ユリス、モニカ。\nグリフォンの軍勢がエイナたちに迫っている。\n恐らく、長くは持ちこたえられない・・・"
						)
					end
				else
					event.open_message_window_2(0, "グリフォンとはいったいどんな奴\nなんだろう・・・")
				end
			else
				event.open_message_window_2(
					0,
					"ラピス探しか・・・ラピスは古代の民によって\nつくられた英知の結晶だ。ルナ研の\nコンピュータ分析によって<page>七色蝶の森、ステラ渓谷、潮騒の洞窟、\nガンドール火山の４箇所に隠されている\nことがわかった。"
				)
				cutscene.face_each_other(player_slot, villager_slot, 0)
				message.say_bubble(0, -1, villager_slot, player_slot, 0)
				end_mode = 1
				event.open_message_window_2(
					0,
					"隠された場所の入り口には必ず、\n星がかたどられた紋章がついているはずだ。\n探してみてくれ。"
				)
			end
		else
			event.open_message_window_2(
				0,
				"いよいよ、グリフォンを倒すときが来た。\n世界の運命はキミたちの双肩にかかっている。\n頼んだぞ！"
			)
		end
	end
	if villager_id == 304 then
		event.open_message_window_2(
			0,
			"この研究所では、すべてが実力主義。\n能力があれば、たとえ子供であろうと\nトップに君臨することもできるのだ。"
		)
	end
	if villager_id == 305 then
		event.open_message_window_2(
			0,
			"シーグラたちが運んでくるルナストーンは\n私たちの頭をスッキリさせて、研究に集中\nさせてくれる効果があるんだ。<page>ルナストーンの正体が何なのかは\n私たちもわからないんだけどね。"
		)
	end
	if villager_id == 306 then
		event.open_message_window_2(
			0,
			"海の上にある研究施設なんてイカすだろ？\nこの研究所に入るためにどれだけ勉強した\nことか・・・"
		)
	end
	if villager_id == 307 then
		event.open_message_window_2(
			0,
			"ところでキミ、このルナ研のデザイン、\nどう思う？<page>これじゃ、まるで遊園地じゃないかぁ？\nいったいダレの趣味なんだか・・・"
		)
	end
	if villager_id == 308 then
		event.open_message_window_2(
			0,
			"いつか、私も所長を越えて、トップに\n立って見せるぞ。なにしろ、この研究所は\n実力の世界なんだから。"
		)
	end
	if villager_id == 309 then
		event.open_message_window_2(
			0,
			"私は所長を尊敬しています。なんてったって、\nあの歳で、ベストセラー技術書「超科学者バイブル」\n全４０巻を書き上げた人だからな。"
		)
	end
	if villager_id == 310 then
		event.open_message_window_2(
			0,
			"ボクまだ新人なんです。この研究所で\nいろんなことを学んで、立派な研究員に\nなりたいと思っています。<page>どうぞ、よろしくお願いします！"
		)
	end
	if villager_id == 311 then
		event.open_message_window_2(
			0,
			"この研究所から見る海は\n最高だよ。<page>海の闇と空の闇が\n地平線のかなたで\n一体化しているんだ。"
		)
	end
	if villager_id == 312 then
		event.open_message_window_2(
			0,
			"ここは、第２ラボ。<page>ルナ研は、\n研究室によって、\n研究内容が違うんだ。"
		)
	end
	if villager_id == 313 then
		event.open_message_window_2(
			0,
			"ここルナ研は、夜の空間を\n作り出し、更にルナストーンの\n力を高めているんだ。"
		)
	end
	if villager_id == 314 then
		event.open_message_window_2(
			0,
			"研究員なりたての頃は、どこがどの研究所なのか\nよく迷ったものだ。君もそうだろ。\nでは、覚え方を教えてあげよう。<page>まず、第一ラボは赤、第二ラボは青、\n第三ラボは紫、第四ラボは緑だ。\n各々の研究所で色が違うって訳だ。"
		)
	end
	if villager_id == 315 then
		event.open_message_window_2(
			0,
			"センターラボの上に輝くエンブレムは\n月をイメージして作られたらしい。"
		)
	end
	if villager_id == 316 then
		event.open_message_window_2(
			0,
			"昔、シグーと言う海竜が、たくさん\nルナストーンを運んでくれたおかげで\nこの研究所が完成したと聞いたよ。<page>かしこい海竜がいるものだな。"
		)
	end
	if villager_id == 317 then
		event.open_message_window_2(
			0,
			"内緒だぞ。<page>オズモンドさんの\n寒いギャグには、僕らも\n飽き飽きしてるんだ。"
		)
	end
	if villager_id == 318 then
		event.open_message_window_2(
			0,
			"何を隠そう、この僕も\n電気ミミズの研究に携わったのだ。\n今は別の研究にとりかかっている。<page>何かって？秘密だよ。\n外部の者にそう簡単に\n言えるものではないのだ。"
		)
	end
	if villager_id == 319 then
		event.open_message_window_2(
			0,
			"何だ？君たちも\n研究員になりたいのか？<page>この研究所に入るのは、\n並大抵のことじゃないんだ。\nものすごく倍率が高いしね。"
		)
	end
	if villager_id == 320 then
		event.open_message_window_2(
			0,
			"このルナ研のデザインに\nケチをつける研究員もいるらしいが\n僕はイカしていると思うな・・・<page>ま、少数意見というのも\n事実だがな。"
		)
	end
	if villager_id == 321 then
		event.open_message_window_2(
			0,
			"今、極秘の研究内容について\n話しているところなんだ。<page>ちょっと\n席を外してくれないか。"
		)
	end
	if villager_id == 322 then
		event.open_message_window_2(
			0,
			"申し訳ない。今、\n極秘の研究内容について\n話し合っているんだ。<page>少しばかり厄介なことに\nなっていてね・・・"
		)
	end
	if villager_id == 323 then
		event.open_message_window_2(
			0,
			"Ｄｒ．チャップは、\nもちろん才能もあるが\n努力の人でもある。<page>僕なんて\nまだまだ・・・"
		)
	end
	if villager_id == 324 then
		event.open_message_window_2(
			0,
			"君か？オズモンドさんに\n反論したって話、聞いたけど。<page>別に非難してるわけじゃないぜ。\n感心してるんだ。疑うことから\n何かが生まれるってこともあるからね。"
		)
	end
	if villager_id == 325 then
		event.open_message_window_2(
			0,
			"この派手な照明に\n目が慣れないって？<page>君たち、過去から来た人間には\n慣れるのに\n少し時間がかかるだろうな。"
		)
	end
	if villager_id == 326 then
		event.open_message_window_2(
			0,
			"いやー、少しばかり\n頭を冷やしているところだよ。<page>あんまり根詰めてやっていると\n効率も悪くなるからね。"
		)
	end
	if villager_id == 327 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"君もなかなかの発明家と聞いたよ。\nどうだ？大きくなったら、\nルナ研の研究員にならないか。<page>そうか、君が大人になる頃は、この\nルナ研もまだできたてほやほやだから\n君程度のレベルでも入れるかもね。"
			)
		else
			event.open_message_window_2(
				0,
				"いろんな物を発明しちゃう男って、\nかっこいいと思わないかい？<page>おっと、でも僕に惚れてもムダだよ。\n僕は研究一筋なんだからね。"
			)
		end
	end
	if villager_id == 328 then
		event.open_message_window_2(
			0,
			"画期的な発明を思いついたんだ。\nモンスターと人間が\n共存するためのシステムなんだ。<page>モンスターが、人間の言葉を\n理解する機械を作るのだ。"
		)
	end
	if villager_id == 329 then
		event.open_message_window_2(
			0,
			"ルナ研の中枢は\nルナストーンによって\nできている。<page>ルナストーンが無ければ、たちまち\nこのルナ研の全てのシステムが\nストップしてしまうだろう。"
		)
	end
	if end_mode == 0 then
		cutscene.talk(villager_slot, -1, 0, 0)
	end
	if end_mode == 1 then
		message.say_bubble(0, -1, villager_slot, player_slot, 0)
		event.set_character_motion(villager_slot, "立ち")
		event.finish_event()
	end
	if end_mode == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		facing_player_slot = event.get_player_character_slot() or facing_player_slot
		do
			local out1, _, out3 = event.get_character_position(facing_player_slot)
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		do
			local out1, _, out3 = event.get_character_position(villager_slot)
			villager_x = out1 or villager_x
			villager_z = out3 or villager_z
		end
		look_angle = event.get_look_angle(villager_x - player_x, villager_z - player_z) or look_angle
		character.turn_to_angle(facing_player_slot, look_angle)
		event.set_character_rotation(facing_player_slot, 0.0, look_angle, 0.0)
		event.set_character_motion(facing_player_slot, "立ち")
		message.say_bubble(0, -1, villager_slot, facing_player_slot, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, villager_slot)
end

--- Plays the conversation with the villager of Stella Temple and the restaurant that the player talked to, then restores villager AI.
function message.talk_to_stella_villager()
	local player_slot: s32 = 0
	local villager_slot: s32 = 0
	local villager_id: s32 = 0
	local end_mode: s32 = 0
	local save_flag_324: s32 = 0
	local save_flag_330: s32 = 0
	local save_flag_372: s32 = 0
	local save_flag_400: s32 = 0
	local save_flag_640: s32 = 0
	local facing_player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local look_angle: f32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	villager_slot = event.get_triggered_event_data_2(13) or villager_slot
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	print("talk_chara_id=", villager_slot, "talk_chara=", villager_id, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	end_mode = 0
	save_flag_324 = event.get_save_flag(324) or save_flag_324
	save_flag_330 = event.get_save_flag(330) or save_flag_330
	save_flag_372 = event.get_save_flag(372) or save_flag_372
	save_flag_400 = event.get_save_flag(400) or save_flag_400
	save_flag_640 = event.get_save_flag(640) or save_flag_640
	if villager_id == 200 then
		if save_flag_640 == 0 then
			if save_flag_330 == 0 then
				if save_flag_324 == 0 then
					event.open_message_window_2(
						0,
						"奇跡の料理、つくるには「白き風の花」が\n必要アル。今は切らしていてつくれないアル。\nお役に立てなくて申し訳ないアル。"
					)
				else
					event.open_message_window_2(
						0,
						"奇跡のシューマイはもう食べたアルか？\n熱いうちに食べないと効果がうすれるアルよ。"
					)
				end
			else
				event.open_message_window_2(
					0,
					"奇跡のシューマイが役に立ったアルか！\nそれはよかったアル。ところで、\n今日は何も食べていかないアルか？"
				)
			end
		else
			event.open_message_window_2(
				0,
				"アイヤー、いよいよアルかぁ。\nよくわからないけど、がんばるアルよ。"
			)
		end
	end
	if villager_id == 201 then
		event.open_message_window_2(
			0,
			"アイテムにはいろいろな効果がある。\n使って役に立つもの。スペクトル化して\n武器に合成するもの・・・<page>アイテムを駆使すれば、手強い相手にも\n楽に勝てるんだぜ。覚えておけよ。"
		)
	end
	if villager_id == 202 then
		if save_flag_372 == 0 then
			event.open_message_window_2(
				0,
				"この寺院がグリフォンと呼ばれる\n悪の皇帝に消されていたなんて・・・\n信じられません。<page>こんなとき、大賢者クレストさまが\nいてくだされば・・・"
			)
		else
			event.open_message_window_2(
				0,
				"クレストさまが復活なされれば、もう怖いもの\nなしだ。おまえたちも安心してグリフォンと\n戦うがよいぞ。"
			)
		end
	end
	if villager_id == 203 then
		if save_flag_372 == 0 then
			event.open_message_window_2(
				0,
				"この寺院は永遠に夜のままだ。\nなぜなら、月のクリスタルは、夜にこそ、\nその力を発揮するからだ。<page>寺院の法力によって、この周りに\n夜の空間をつくり出しているのだ。"
			)
		else
			event.open_message_window_2(
				0,
				"クレストさまは月のクリスタルをお使いになり、\nこの世のすべてのことをお見通しになるのだ。\nクレストさまに隠し事などできぬぞ。"
			)
		end
	end
	if villager_id == 204 then
		event.open_message_window_2(
			0,
			"よう、いい武器がそろってるぜ。\n見てってくれよ。うちの武器は、よく\nビルドアップするって評判なんだぜ。"
		)
	end
	if villager_id == 205 then
		if save_flag_640 == 0 then
			if save_flag_400 == 0 then
				event.open_message_window_2(
					0,
					"何してるんだい！ぐずぐずしてると\nグリフォンの思うつぼだよ！\n急ぐんだよ！"
				)
			else
				event.open_message_window_2(
					0,
					"私にしてやれることはここまでだよ。\nあとはアンタたち自身の力で\nグリフォンをどうにかしておくれ。<page>私を救ってくれたアンタたちなら\nきっとやれるはずさ。"
				)
			end
		else
			event.open_message_window_2(
				0,
				"いよいよ、アンタたちの旅も終わりに\n近づいているようだね。グリフォンは、\n先生のカタキでもあるんだ。<page>必ず、倒しておくれ、頼んだよ。\nグリフォンが倒されたその時・・・\n先生も・・・私も、本当の賢者になれるんだ・・・"
			)
		end
	end
	if villager_id == 206 then
		if save_flag_372 == 0 then
			event.open_message_window_2(
				0,
				"寺院が元に戻っても、クレストさまがいなければ、\nこのステラ寺院は何の役にも立たない。<page>クレストさましか、すべてを見通す『大占星術』\nを使うことはできないのだ。。"
			)
		else
			event.open_message_window_2(
				0,
				"あのクレストさまも、昔はある賢者さまの\n弟子だったらしい。クレストさまの師匠とは\nいったい、どんなすごい賢者さまなのだろう・・・"
			)
		end
	end
	if villager_id == 207 then
		if save_flag_324 == 0 then
			event.open_message_window_2(
				0,
				"この店の料理はいつ来てもうまいよなぁ。\n舌がとろけるっていうか、ホント最高なんだよ。"
			)
		else
			event.open_message_window_2(
				0,
				"奇跡の料理、見せてもらった！\nやっぱり、ラオチャオ料理長はすごいな。"
			)
		end
	end
	if villager_id == 208 then
		if save_flag_324 == 0 then
			event.open_message_window_2(
				0,
				"この店の料理を食べたら、もう他の料理が\nみんなまずく感じちゃうの。どうしましょ。"
			)
		else
			event.open_message_window_2(0, "いいなぁ。私も奇跡のシューマイ\n食べたーい！")
		end
	end
	if villager_id == 209 then
		if save_flag_372 == 0 then
			event.open_message_window_2(
				0,
				"「星の砂時計」が\n不思議なアイテムだと？<page>そうだな、私も持っているんだが、\n特に強い思いなどないからなぁ・・・\n時間を巻き戻したことなんてないなぁ。"
			)
		else
			event.open_message_window_2(
				0,
				"なんとあなたたち、\n大賢者クレストさまの\nお知り合いだったのですね。<page>しかし、やけに\n親しげですね・・・"
			)
		end
	end
	if villager_id == 210 then
		if save_flag_372 == 0 then
			event.open_message_window_2(
				0,
				"大賢者クレストさまがいないんだ。\nどこに行かれたのだろう・・・<page>私たちは、あの方がいなければ\n不安でしかたないのだ。"
			)
		else
			event.open_message_window_2(
				0,
				"クレストさまから聞いたことがある。遠い昔、\nギルトーニと言うやつに、この月のクリスタルを\n破壊されそうになったと。<page>それを命がけでお守りしたのが、\nクレストさまの師匠であったお方らしい・・・"
			)
		end
	end
	if villager_id == 211 then
		if save_flag_372 == 0 then
			event.open_message_window_2(
				0,
				"クレストさまは、月のクリスタルを\nお守りする為に、クリスタルともども\n消えてしまったと言うのか・・・<page>何と言うことだ・・・"
			)
		else
			event.open_message_window_2(
				0,
				"見ただろ？月のクリスタルの偉大な力を。\nしかし、あの力を使えるのは\nクレストさまだけ・・・<page>私たちには、一生かかっても\nあの力を手に入れることは\nできないだろうな。"
			)
		end
	end
	if villager_id == 212 then
		if save_flag_372 == 0 then
			event.open_message_window_2(
				0,
				"ん？おまえたち、もしかして・・・\nいつか男の子と女の子が私を訪ねてくるだろう、と\nクレストさまがおっしゃっていた、あの２人・・・<page>さすがクレストさま、予言どおりだ。\nだが、残念なことに大賢者クレストさまも\n消されてしまっているんだ・・・"
			)
		else
			event.open_message_window_2(
				0,
				"一万年前だって？<page>クレストさまの力でも、どうにも\nならないことが「ルナ研」と言う所に\n行けば可能だと言うのか・・・"
			)
		end
	end
	if villager_id == 213 then
		event.open_message_window_2(
			0,
			"月と言うものは、いろんな生物に\n影響を与える不思議な力を\n持っている。<page>そして、この力の結晶が、\n月のクリスタルなのだ。"
		)
	end
	if villager_id == 214 then
		event.open_message_window_2(
			0,
			"君たちか。クレストさまから\n話を聞いたことがあるぞ。ずいぶん昔に\n命を救われたことがあると。<page>なんと、\n子供だったとは・・・"
		)
	end
	if end_mode == 0 then
		cutscene.talk(villager_slot, -1, 0, 0)
	end
	if end_mode == 1 then
		message.say_bubble(0, -1, villager_slot, player_slot, 0)
		event.set_character_motion(villager_slot, "立ち")
		event.finish_event()
	end
	if end_mode == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		facing_player_slot = event.get_player_character_slot() or facing_player_slot
		do
			local out1, _, out3 = event.get_character_position(facing_player_slot)
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		do
			local out1, _, out3 = event.get_character_position(villager_slot)
			villager_x = out1 or villager_x
			villager_z = out3 or villager_z
		end
		look_angle = event.get_look_angle(villager_x - player_x, villager_z - player_z) or look_angle
		character.turn_to_angle(facing_player_slot, look_angle)
		event.set_character_rotation(facing_player_slot, 0.0, look_angle, 0.0)
		event.set_character_motion(facing_player_slot, "立ち")
		message.say_bubble(0, -1, villager_slot, facing_player_slot, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, villager_slot)
	if villager_id == 201 then
		menu.open_type_6(5)
	end
	if villager_id == 204 then
		menu.open_type_6(27)
	end
end

--- Waits for a message window's answer; returns the frames it waited and whether the expected answer was chosen.
function message.wait_answer(window: any, answers: s32, chosen: s32)
	local result: s32 = 0
	local frames: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		frames = 0
		while true do
			result = message.step(window, answers)
			if result ~= 0 then
				chosen = 0
				if answers == 1 and result == 2 then
					chosen = 1
				end
				if answers == 2 and result == 3 then
					chosen = 1
				end
				frames = vm.i32(frames + 1)
				break
			else
				resume_step = 1
				vm.wait(1)
				frames = vm.i32(frames + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		return frames, chosen
	end, function(received: { any })
		if resume_step <= 1 then
			frames = frames + 1
			return frames, chosen
		end
		return nil, chosen
	end)
end

--- Counts an answer wait without waiting; this stands in for message.wait_answer when events are skipped.
function message.wait_answer_skipping(window: any, answers: s32, chosen: s32)
	local frames: s32 = 0
	frames = 0
	local _ = message.step_skipping(window, answers)
	chosen = 0
	chosen = 1
	chosen = 1
	frames = frames + 1
	frames = frames + 1
	return frames, chosen
end

--- Turns the player toward a character and shows the open message as that character's speech bubble until it closes.
function message.wait_facing_character(speaker: s32)
	local player_character: s32 = 0
	player_character = event.get_player_character_slot() or player_character
	character.face_toward(player_character, speaker)
	message.say_bubble(0, -1, speaker, player_character, 0)
end

--- Stands in for message.wait_facing_character on the resumed path, facing the player toward a character and running a skipped speech bubble.
function message.wait_facing_character_skipping(speaker: any)
	local player_character: s32 = 0
	character.restore_default_facing(player_character, speaker)
	message.say_bubble_skipping(0, -1, speaker, player_character, 0)
end

--- Waits while a message window opens or prints its text.
function message.wait_until_shown(window: s32)
	local window_state: s32 = 0
	window_state = event.get_message_window_state(window) or window_state
	while window_state == 0 or window_state == 1 do
		vm.wait(1)
		window_state = event.get_message_window_state(window) or window_state
	end
end

--- Waits for a window's voice line or a frame limit, animates the speaker's mouth and closes the window at a chosen frame.
function message.wait_voice(window: s32, duration: any, close_frame: any)
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local frame: s32 = 0
	local previous_audible: s32 = 0
	local audible: s32 = 0
	local running: s32 = 0
	event.set_message_button_prompt(window, 0)
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	frame = 0
	previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
	audible = 0
	running = 1
	while running ~= 0 do
		previous_voice_state = voice_state
		voice_state = event.get_voice_stream_state(1) or voice_state
		if previous_voice_state ~= 0 and voice_state == 0 then
			event.trigger_mouth_motion(2)
			if duration == -1 then
				running = 0
			end
		end
		previous_audible = audible
		audible = event.is_voice_stream_audible(1) or audible
		if previous_audible == 0 and audible == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if previous_audible == 1 and audible == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		vm.wait(1)
		frame = vm.i32(frame + 1)
		if duration ~= -1 then
			if duration <= frame then
				running = 0
			end
		end
		if close_frame == frame then
			message.close(window)
		end
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.set_message_button_prompt(window, 1)
end

--- Waits a number of frames for a window's voice line.
function message.wait_voice_for(window: s32, duration: any)
	message.wait_voice(window, vm.ftoi(duration), -1)
end

--- Accepts a window and a duration and does nothing; this stands in for message.wait_voice_for when events are skipped.
function message.wait_voice_for_skipping(window: s32, duration: s32)
	message.wait_voice_skipping(window, duration, -1)
end

--- Waits until a window's voice line ends or the player advances it, animating the speaker's mouth meanwhile.
function message.wait_voice_or_button(window: s32)
	local auto_advance: s32 = 0
	local mouth_state: s32 = 0
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local finished: s32 = 0
	local frame: s32 = 0
	local previous_audible: s32 = 0
	local audible: s32 = 0
	auto_advance = event.get_save_data_value(5) or auto_advance
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	mouth_state = 0
	frame = 0
	previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
	audible = 0
	while true do
		previous_voice_state = voice_state
		voice_state = event.get_voice_stream_state(1) or voice_state
		if previous_voice_state ~= 0 and voice_state == 0 then
			event.trigger_mouth_motion(2)
			mouth_state = 2
			if auto_advance ~= 0 then
				break
			end
		end
		previous_audible = audible
		audible = event.is_voice_stream_audible(1) or audible
		if previous_audible == 0 and audible == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if previous_audible == 1 and audible == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		local button_result: s32
		button_result, mouth_state = message.poll_advance(window, mouth_state)
		finished = button_result
		if finished ~= 0 then
			frame = vm.i32(frame + 1)
			break
		else
			vm.wait(1)
			frame = vm.i32(frame + 1)
		end
	end
	if mouth_state == 0 then
		event.trigger_mouth_motion(2)
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.stop_voice_stream(1)
end

--- Waits on a window without waiting; this stands in for message.wait_voice_or_button when events are skipped.
function message.wait_voice_or_button_skipping(window: s32)
	local mouth_state: s32 = 0
	local frame: s32 = 0
	mouth_state = 0
	frame = 0
	mouth_state = 2
	do
		local _: any
		_, mouth_state = message.poll_advance_skipping(window, mouth_state)
	end
	frame = frame + 1
	frame = frame + 1
end

--- Counts a message voice wait without waiting; this stands in for message.wait_voice when events are skipped.
function message.wait_voice_skipping(window: s32, duration: any, close_frame: s32)
	local frame: s32 = 0
	local running: s32 = 0
	local _ = duration > 0
	frame = 0
	running = 1
	local _ = running
	running = 0
	frame = frame + 1
	running = 0
	message.close_skipping(window)
end

--- Waits for a window's voice line or a frame limit, animates the speaker's mouth, closes the window at a chosen frame and stops the voice.
function message.wait_voice_stopping(window: s32, duration: any, close_frame: any)
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local frame: s32 = 0
	local previous_audible: s32 = 0
	local audible: s32 = 0
	local running: s32 = 0
	event.set_message_button_prompt(window, 0)
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	frame = 0
	previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
	audible = 0
	running = 1
	while running ~= 0 do
		previous_voice_state = voice_state
		voice_state = event.get_voice_stream_state(1) or voice_state
		if previous_voice_state ~= 0 and voice_state == 0 then
			event.trigger_mouth_motion(2)
			if duration == -1 then
				running = 0
			end
		end
		previous_audible = audible
		audible = event.is_voice_stream_audible(1) or audible
		if previous_audible == 0 and audible == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if previous_audible == 1 and audible == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		vm.wait(1)
		frame = vm.i32(frame + 1)
		if duration ~= -1 then
			if duration <= frame then
				running = 0
			end
		end
		if close_frame == frame then
			message.close(window)
		end
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.stop_voice_stream(1)
	event.set_message_button_prompt(window, 1)
end

--- Waits a number of frames for a window's voice line and then stops the voice.
function message.wait_voice_stopping_for(window: s32, duration: any)
	message.wait_voice_stopping(window, vm.ftoi(duration), -1)
end

--- Accepts a window and a duration and does nothing; this stands in for message.wait_voice_stopping_for when events are skipped.
function message.wait_voice_stopping_for_skipping(window: s32, duration: s32)
	message.wait_voice_stopping_skipping(window, duration, -1)
end

--- Counts a message voice wait without waiting; this stands in for message.wait_voice_stopping when events are skipped.
function message.wait_voice_stopping_skipping(window: s32, duration: s32, close_frame: s32)
	local frame: s32 = 0
	local running: s32 = 0
	frame = 0
	running = 1
	local _ = running
	running = 0
	frame = frame + 1
	running = 0
	message.close_skipping(window)
end

return message
