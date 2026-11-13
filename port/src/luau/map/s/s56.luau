--!strict
--- Runs the lighthouse cape map: the star hourglass use, the Lin scene and the exit prompt.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local map = require("@lib/event/map")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Asks whether to go back to the past and returns 1 on a yes.
local function confirm_travel_to_past()
	local answer: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(
			0,
			"ここから過去に戻れば、クレストを助けられるはず！\n（(#)ボタンでメニューを開く）"
		)
		checkpoint = 1
		answer = message.ask_confirmation(0, -1, 5, 256, 208, answer)
		if answer == 1 then
			return 1
		else
			return 0
		end
	end, function(received: { any })
		if checkpoint <= 1 then
			if checkpoint == 1 then
				answer = received[2] :: number
			end
			return 1
		end
		return nil
	end)
end

--- Sets the hourglass flag, shows the hourglass message and fades out.
local function use_star_hourglass()
	event.initialize_event()
	event.set_save_flag(352, 1)
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.open_message_window_2(0, "Ｅ３５２　～星の砂時計を使う～")
	message.show(0, -1, 5, 0, 0)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.finish_event()
end

--- Animates the speaker's mouth from the voice stream until it ends or the frame limit passes.
local function animate_mouth_during_voice(window: s32, frame_limit: any)
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local frame_count: s32 = 0
	local was_audible: s32 = 0
	local is_audible: s32 = 0
	local is_running: s32 = 0
	event.set_message_button_prompt(window, 0)
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	frame_count = 0
	previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
	is_audible = 0
	is_running = 1
	while is_running ~= 0 do
		previous_voice_state = voice_state
		voice_state = event.get_voice_stream_state(1) or voice_state
		if previous_voice_state ~= 0 and voice_state == 0 then
			event.trigger_mouth_motion(2)
			if frame_limit == -1 then
				is_running = 0
			end
		end
		was_audible = is_audible
		is_audible = event.is_voice_stream_audible(1) or is_audible
		if was_audible == 0 and is_audible == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if was_audible == 1 and is_audible == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		vm.wait(1)
		frame_count = vm.i32(frame_count + 1)
		if frame_limit ~= -1 then
			if frame_limit <= frame_count then
				is_running = 0
			end
		end
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.stop_voice_stream(1)
	event.set_message_button_prompt(window, 1)
end

--- Streams a voiced message, shows its window and animates the mouth for up to a frame limit.
local function show_voiced_message_for(message_id: s32, frame_limit: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	event.open_voice_stream_wave(1, message_id)
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
	event.open_message_window_2(0, message_id)
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	animate_mouth_during_voice(0, frame_limit)
	message.close(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

--- Animates the speaker's mouth from the voice stream until the player advances the message.
local function animate_mouth_until_advance(window: s32)
	local advance_state: s32 = 0
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local has_advanced: s32 = 0
	local frame_count: s32 = 0
	local was_audible: s32 = 0
	local is_audible: s32 = 0
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	advance_state = 0
	frame_count = 0
	previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
	is_audible = 0
	while true do
		previous_voice_state = voice_state
		voice_state = event.get_voice_stream_state(1) or voice_state
		if previous_voice_state ~= 0 and voice_state == 0 then
			event.trigger_mouth_motion(2)
			advance_state = 2
		end
		was_audible = is_audible
		is_audible = event.is_voice_stream_audible(1) or is_audible
		if was_audible == 0 and is_audible == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if was_audible == 1 and is_audible == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		local t0: s32
		t0, advance_state = message.poll_advance(window, advance_state)
		has_advanced = t0
		if has_advanced ~= 0 then
			frame_count = vm.i32(frame_count + 1)
			break
		else
			vm.wait(1)
			frame_count = vm.i32(frame_count + 1)
		end
	end
	if advance_state == 0 then
		event.trigger_mouth_motion(2)
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.stop_voice_stream(1)
end

--- Streams a voiced message, shows its window and animates the mouth until the player advances.
local function show_voiced_message(message_id: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	event.open_voice_stream_wave(1, message_id)
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
	event.open_message_window_2(0, message_id)
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	animate_mouth_until_advance(0)
	message.close(0)
	event.close_voice_stream(1)
end

--- Mirrors the mouth animation wait for a skipped scene.
local function skip_animate_mouth_during_voice(window: s32, frame_limit: s32)
	local frame_count: s32 = 0
	local is_running: s32 = 0
	frame_count = 0
	is_running = 1
	local _ = is_running
	is_running = 0
	frame_count = frame_count + 1
	is_running = 0
end

--- Mirrors the timed voiced message for a skipped scene.
local function skip_show_voiced_message_for(message_id: s32, frame_limit: s32)
	message.open_skipping(0, -1, 8, 0, 0)
	skip_animate_mouth_during_voice(0, frame_limit)
	message.close_skipping(0)
end

--- Mirrors the advance-driven mouth animation wait for a skipped scene.
local function skip_animate_mouth_until_advance(window: s32)
	local advance_state: s32 = 0
	local frame_count: s32 = 0
	advance_state = 0
	frame_count = 0
	advance_state = 2
	do
		local _: any
		_, advance_state = message.poll_advance_skipping(window, advance_state)
	end
	frame_count = frame_count + 1
	frame_count = frame_count + 1
end

--- Mirrors the voiced message for a skipped scene.
local function skip_show_voiced_message(message_id: s32)
	message.open_skipping(0, -1, 8, 0, 0)
	skip_animate_mouth_until_advance(0)
	message.close_skipping(0)
end

--- Plays the scene in which the party walks up to Lin at the lighthouse and then places the player at the lighthouse.
local function play_lin_scene()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local checkpoint: number = 0
	vm.section(function()
		checkpoint = 1
		vm.entry(1)
		event.set_save_flag(348, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		sound_bank = event.load_sound_effect_file_2(3829) or sound_bank
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 or playable_character ~= 1 then
			event.switch_dungeon_main_character(0)
			event.set_playable_character(0)
			playable_character = 0
		end
		event.change_directory("event/e300/e348/")
		event.load_message_file(0, 5, "e348.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e348_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e348_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e348_lin.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 9)
			event.load_equipment_model(5, 0, 4, "info", 9)
			event.load_equipment_model(5, 0, 3, "info", 9)
			event.load_equipment_model(5, 0, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e300/e348/e348_mints.gltf", "info", 10)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 9)
			event.attach_object_handle_to_character(0, 9)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 9)
			event.load_equipment_model(5, 1, 4, "info", 9)
			event.load_equipment_model(5, 1, 3, "info", 9)
			event.load_equipment_model(5, 1, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e300/e348/e348_monica.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(9)
		event.set_character_active(10)
		event.attach_object_handle_to_character(3, 1)
		event.set_object_handle_visible(3, 0)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_position(0, 1521.47, -107.28, 771.74)
		event.set_object_handle_rotation(0, 0.0, -2.88, 0.0)
		event.set_object_handle_motion(0, "歩き", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 1505.66, -106.53, 783.49)
		event.set_object_handle_rotation(1, 0.0, 3.04, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, 1506.3, -108.37, 803.96)
		event.set_object_handle_rotation(2, 0.0, -3.12, 0.0)
		event.set_object_handle_motion(2, "歩き", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "無表情")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_texture_animation(2, 1, "半口")
		event.move_object_sequence(0, 1521.47, -107.28, 731.74, 80)
		event.move_object_sequence(1, 1505.66, -106.53, 743.49, 80)
		event.move_object_sequence(2, 1506.3, -108.37, 763.96, 80)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1478.0, -94.44, 748.45)
		event.set_camera_sequence_look_at(1526.09, -83.38, 795.48)
		event.move_camera_sequence(1478.0, -94.44, 708.45, 1526.09, -83.38, 755.48, 80)
		event.fade_in_screen(30)
		checkpoint = 2
		wait.for_frame_count(80)
		event.set_camera_sequence_position(1635.22, -45.35, 898.95)
		event.set_camera_sequence_look_at(1509.85, -91.47, 744.47)
		event.move_camera_sequence_eased(1635.22, -45.35, 898.95, 1509.85, 36.75, 744.47, 60, 0, 1.0)
		event.set_object_sequence_position(0, 1522.58, -104.86, 733.22)
		event.set_object_sequence_rotation(0, 0.0, -2.52, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 1508.09, -104.9, 755.07)
		event.set_object_sequence_rotation(1, 0.0, -2.76, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(2, 1536.72, -109.15, 777.79)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.move_object_sequence(0, 1491.96, -99.81, 672.57, 90)
		event.move_object_sequence(1, 1473.85, -100.1, 691.32, 90)
		event.move_object_sequence(2, 1493.11, -100.84, 700.12, 90)
		checkpoint = 3
		show_voiced_message_for(3480010, 120)
		checkpoint = 4
		camera.wait_until_done()
		checkpoint = 5
		wait.for_frame_count(10)
		event.set_camera_sequence_position(1459.8, -32.33, 632.79)
		event.set_camera_sequence_look_at(1494.99, -96.61, 704.05)
		event.move_camera_sequence_eased(1475.8, -54.94, 665.2, 1494.99, -84.52, 704.05, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "上見立ち", 4)
		checkpoint = 6
		camera.wait_until_done()
		checkpoint = 7
		wait.for_frame_count(10)
		event.set_camera_sequence_position(1518.17, -76.49, 671.12)
		event.set_camera_sequence_look_at(1493.05, -78.0, 693.7)
		event.set_object_sequence_position(2, 1501.04, -100.84, 688.87)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.play_sound_effect(sound_bank, 6)
		event.set_object_sequence_motion(1, "右向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		checkpoint = 8
		show_voiced_message(3480020)
		event.fade_out_screen(30)
		checkpoint = 9
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			local _ = playable_character ~= 0
			local _ = playable_character ~= 1
			playable_character = 0
			wait.skip_frame_count(80)
		end
		if checkpoint <= 2 then
			skip_show_voiced_message_for(3480010, 120)
		end
		if checkpoint <= 3 then
			wait.background_load_skipping()
		end
		if checkpoint <= 4 then
			wait.skip_frame_count(10)
		end
		if checkpoint <= 5 then
			wait.background_load_skipping()
		end
		if checkpoint <= 6 then
			wait.skip_frame_count(10)
		end
		if checkpoint <= 7 then
			skip_show_voiced_message(3480020)
		end
		if checkpoint <= 8 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	checkpoint = 10
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.attach_object_handle_to_character(0, 1)
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_position(0, 1390.73, -76.07, 523.09)
	event.set_character_rotation(0, 0.0, -2.28, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Runs a message choice menu driven by the stick, d-pad and buttons and returns the selected index or -1.
local function run_choice_menu(window: s32, choice_count: any, selection: any, block_cancel: s32)
	local top_line: s32 = 0
	local pad_down: s32 = 0
	local previous_stick_direction: s32 = 0
	local stick_direction: s32 = 0
	local selection_step: s32 = 0
	local cancel_pressed: s32 = 0
	local confirm_pressed: s32 = 0
	local window_frame: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		top_line = event.get_message_selection_top_line(window) or top_line
		event.set_message_draw_speed(window, 0.0)
		selection_step = 0
		stick_direction = 0
		previous_stick_direction = 0
		event.set_message_selection(window, -1)
		event.set_message_selection(window, selection)
		checkpoint = 1
		message.wait_until_shown(window)
		while true do
			selection_step = 0
			stick_direction = message.get_stick_direction(window)
			if previous_stick_direction == 0 and stick_direction == -1 then
				event.play_message_sound(2)
				selection_step = -1
			end
			if previous_stick_direction == 0 and stick_direction == 1 then
				event.play_message_sound(2)
				selection_step = 1
			end
			previous_stick_direction = stick_direction
			cancel_pressed = event.is_event_button_pressed(0) or cancel_pressed
			confirm_pressed = event.is_event_button_pressed(1) or confirm_pressed
			pad_down = event.get_buttons_pressed() or pad_down
			window_frame = event.get_message_window_frame(window) or window_frame
			if window_frame == 5 then
				if bit32.band(pad_down, 32768) ~= 0 then
					event.play_message_sound(2)
					selection_step = -1
				end
				if bit32.band(pad_down, 8192) ~= 0 then
					event.play_message_sound(2)
					selection_step = 1
				end
			else
				if bit32.band(pad_down, 4096) ~= 0 then
					event.play_message_sound(2)
					selection_step = -1
				end
				if bit32.band(pad_down, 16384) ~= 0 then
					event.play_message_sound(2)
					selection_step = 1
				end
			end
			if confirm_pressed ~= 0 then
				event.play_message_sound(0)
				checkpoint = 2
				vm.wait(2)
				break
			else
				if cancel_pressed ~= 0 then
					event.play_message_sound(1)
					checkpoint = 3
					vm.wait(3)
					if block_cancel == 0 then
						message.close(window)
						return -1
					end
				end
				if selection_step == 1 then
					if selection < vm.wrap(vm.wrap(choice_count - 1) + top_line) then
						selection = vm.wrap(selection + 1)
					else
						selection = vm.wrap(vm.wrap(choice_count - 1) + top_line)
					end
				end
				if selection_step == -1 then
					if top_line < selection then
						selection = selection - 1
					else
						selection = top_line
					end
				end
				event.set_message_selection(window, selection)
				checkpoint = 4
				vm.wait(4)
			end
		end
		message.close(window)
		return selection
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				selection_step = 0
				stick_direction = message.get_stick_direction_skipping(window)
				selection_step = -1
				selection_step = 1
				local _ = previous_stick_direction == 0
				local _ = previous_stick_direction == 0
				previous_stick_direction = stick_direction
				selection_step = -1
				selection_step = 1
				selection_step = -1
				selection_step = 1
			end
			message.close_skipping(window)
			return -1
		end
		if checkpoint <= 4 then
			message.close_skipping(window)
			return selection
		end
		return nil
	end)
end

--- Opens a message window and returns the selection from its choice menu.
local function ask_choice(window: s32, message_id: any, window_style: s32, x: s32, y: s32, choice_count: s32, default_selection: any)
	local selection: any = 0
	local checkpoint: number = 0
	return vm.guard(function()
		local _ = message.open(window, message_id, window_style, x, y)
		checkpoint = 1
		selection = run_choice_menu(window, choice_count, default_selection, 0)
		event.set_message_bubble_screen_slot(window, 0)
		return selection
	end, function(received: { any })
		if checkpoint <= 1 then
			if checkpoint == 1 then
				selection = received[1] :: number
			end
			return selection
		end
		return nil
	end)
end

--- Asks whether to leave the lighthouse and either walks off and fades out or steps the player back.
local function ask_to_leave_lighthouse()
	local selection: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local index: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "「岬の灯台」を出ますか？")
		checkpoint = 1
		selection = ask_choice(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if selection == 0 then
			event.set_camera_sequence_position(1776.49, -106.69, 1400.79)
			event.set_camera_sequence_look_at(1951.33, -163.61, 1351.42)
			event.set_object_sequence_position(0, 1943.88, -189.72, 1357.17)
			event.set_object_sequence_rotation(0, 0.0, 1.21, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, 1943.88, -189.72, 1357.17)
			event.add_object_sequence_path_point(0, 2022.78, -189.88, 1386.95)
			event.add_object_sequence_path_point(0, 2104.45, -195.47, 1399.2)
			event.add_object_sequence_path_point(0, 2155.72, -202.4, 1401.26)
			event.start_object_sequence_path(0)
			checkpoint = 2
			wait.for_frame_count(30)
			event.fade_out_screen(30)
			checkpoint = 3
			wait.for_frame_count(30)
			event.set_character_motion(0, "立ち", 4)
			event.set_object_handle_footstep_sound(0, -1)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				character_x = out1 or character_x
				character_y = out2 or character_y
				character_z = out3 or character_z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(-2.14)) * 30.0) + character_x)
			target_y = character_y
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(-2.14)) * 30.0) + character_z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			index = 0
			while index < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					character_x = out1 or character_x
					character_y = out2 or character_y
					character_z = out3 or character_z
				end
				character_y = vm.f32(character_y + 30.0)
				event.set_camera_look_at(character_x, character_y, character_z)
				index = index + 1
				checkpoint = 4
				vm.wait(4)
			end
			event.set_object_handle_footstep_sound(0, -1)
			event.reset_follow_camera(0)
			event.finish_event()
		end
		return 0
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint == 1 then
				selection = received[1] :: number
			end
			if checkpoint <= 1 then
				wait.skip_frame_count(30)
			end
			if checkpoint <= 2 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if checkpoint <= 4 then
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = map.disable_completed_function_points

--- Disables the function points of completed scenes and walks the party in at the entrance.
function script.default_event()
	map.disable_completed_function_points()
	cutscene.walk_in_at_entrance()
end

--- Waits a frame and then ends the event.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	event.finish_event()
end

--- Handles the spot where the star hourglass is used to travel to the past.
function script.examine_past_travel_spot()
	local interaction_stage: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	interaction_stage = event.get_triggered_event_data_2(6) or interaction_stage
	if interaction_stage == 1 then
		if confirm_travel_to_past() ~= 0 then
			interaction_stage = 2
		end
	end
	if interaction_stage == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait.for_frame_count(6)
		event.open_use_item_menu(371)
		vm.wait(3)
		item = vmhost.used_item() or item
		if item == 371 then
			event.set_function_point_enabled("", "event", 0)
			use_star_hourglass()
			event.load_dungeon_map("d03b02")
			event.load_event_script("d03b02/d03b02.stb", 500)
			return
		elseif item > 0 then
			character.shake_head_at_camera()
		end
	end
	event.show_dungeon_status_bar(1, 0.16666667)
	wait.for_frame_count(6)
	event.finish_event()
end
script[500] = script.examine_past_travel_spot

--- Fades out and plays the Lin scene.
function script.cutscene_lin()
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_function_point_enabled("", "e348", 0)
		character.set_idle_motion()
		event.fade_out_screen(30)
		checkpoint = 1
		wait.for_frame_count(30)
		checkpoint = 2
		play_lin_scene()
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				checkpoint = 2
				play_lin_scene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[502] = script.cutscene_lin

--- Asks to leave the lighthouse and loads dungeon d03 on a yes.
function script.leave_lighthouse()
	if ask_to_leave_lighthouse() ~= 0 then
		event.load_event_script("d03/d03.stb", 1000)
	end
end
script[510] = script.leave_lighthouse

return script
