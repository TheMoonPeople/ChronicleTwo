--!strict
--- Sindain map event helpers.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local georama = vm.module("@lib/event/georama")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local sindain = {}

--- Asks a selection prompt and returns 1 after running forward with a fade-out, or turns and walks back and returns 0.
function sindain.ask_and_leave_or_walk_back()
	local answer: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local walk_frame: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		resume_point = 1
		answer = sindain.ask_selection(5, 16)
		if answer == 0 then
			event.set_object_sequence_position(0, 435.65, 0.09, 1239.32)
			event.set_object_sequence_rotation(0, 0.0, 0.15, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_camera_sequence()
			event.set_camera_sequence_position(509.64, 85.52, 1104.08)
			event.set_camera_sequence_look_at(467.67, 42.86, 1293.7)
			event.move_object_sequence(0, 493.92, 0.01, 1423.13, 60, 1)
			event.move_camera_sequence(509.64, 85.52, 1104.08, 485.07, 46.59, 1340.58, 60)
			print("2")
			resume_point = 2
			wait.frames(30)
			print("3")
			event.fade_out_screen(30)
			resume_point = 3
			wait.frames(30)
			return 1
		end
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		x = vm.f32(x + vm.f32(45.0 * vm.sin(vm.f32(-3.01))))
		z = vm.f32(z + vm.f32(45.0 * vm.cos(vm.f32(-3.01))))
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, -3.01, 0.0, 15)
		event.move_object_sequence(0, x, y, z, 45)
		for i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			event.set_camera_sequence_look_at(x, y + 30.0, z)
			resume_point = 4
			vm.wait(4)
		end
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point == 1 then
				answer = received[1] :: number
			end
			if resume_point <= 1 then
				print("2")
				wait.frames_skipping(30)
			end
			if resume_point <= 2 then
				print("3")
				wait.frames_skipping(30)
			end
			return 1
		end
		if resume_point <= 4 then
			local _ = walk_frame < 45
			walk_frame = walk_frame + 1
			return 0
		end
		return nil
	end)
end

--- Opens a selection message window and returns the chosen option.
function sindain.ask_selection(message_index: s32, system_message_index: s32)
	local selection: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.set_message_selection_top_line(1, 0)
		event.set_message_window_mode(1, 5)
		event.set_message_draw_speed(1, 1)
		event.set_message_item_system_message(1, 1, vm.i32(system_message_index + 20000))
		resume_point = 1
		selection = message.open_and_ask_choice(1, vm.i32(message_index + 70), 8, 256, 208, 2, 1)
		event.set_message_draw_speed(1, 0)
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

--- Returns 1 when any of five georama analysis and save flag checks is satisfied.
function sindain.has_any_analysis_condition_met()
	if georama.can_start_event_270() ~= 0 then
		return 1
	end
	if georama.can_start_event_272() ~= 0 then
		return 1
	end
	if georama.can_start_event_275() ~= 0 then
		return 1
	end
	if georama.can_start_event_280() ~= 0 then
		return 1
	end
	if georama.can_trigger_full_analysis_event() ~= 0 then
		return 1
	end
	return 0
end

--- Plays the get-up motion on sequence 2 and waits 45 frames.
function sindain.play_get_up_motion()
	event.set_object_sequence_motion(2, "起きる", 6)
	event.queue_object_sequence_next_motion(2, "起きるL", 0)
	wait.for_frame_count(13)
	wait.for_frame_count(30)
end

--- Plays the look-down motion on sequences 0 and 1 and the jump-down motion on sequence 2.
function sindain.play_look_down_and_jump_motion()
	wait.for_frame_count(10)
	event.delay_object_sequence_motion_track(0, 10)
	event.delay_object_sequence_motion_track(1, 20)
	event.set_object_sequence_motion(0, "下を見る", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(0, "下を見るL", 0)
	event.set_object_sequence_motion(1, "下を見る", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "下を見るL", 0)
	event.set_object_sequence_motion(2, "飛び降り", 6)
	wait.for_frame_count(81)
end

--- Plays the peek-in and run-away motions on sequences 1 and 2 and waits for them.
function sindain.play_peek_and_run_away_motion()
	event.set_object_sequence_motion(1, "のぞきこむ", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "のぞきこむL", 0)
	event.set_object_sequence_motion(2, "ぷるぷる", 4)
	wait.for_frame_count(16)
	wait.for_frame_count(30)
	event.set_object_sequence_motion(2, "知るかー！", 6)
	wait.for_frame_count(30)
	event.set_object_sequence_motion(2, "歩き", 4)
	event.delay_object_sequence_motion_track(2, 5)
	event.set_object_sequence_motion(2, "走り", 4)
	event.rotate_object_sequence(2, 0.0, -1.68, 0.0, 5)
	event.delay_object_sequence_position_track(2, 10)
	event.move_object_sequence(2, -34.77, 0.0, 141.26, 10)
	wait.for_frame_count(20)
end

--- Plays the hand-release motion on sequences 1 and 2 and waits 31 frames.
function sindain.play_release_hands_motion()
	event.set_object_sequence_motion(1, "手をはなす", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
	event.set_object_sequence_motion(2, "手をはなす", 6)
	wait.for_frame_count(30)
end

--- Sets sequence 2 to the standing motion and waits 47 frames.
function sindain.play_stand_motion_and_wait()
	event.set_object_sequence_motion(2, "立ち", 4)
	wait.for_frame_count(15)
	wait.for_frame_count(30)
end

--- Plays the stand-up and trembling motion on sequence 2 and waits 72 frames.
function sindain.play_stand_up_and_tremble_motion()
	event.set_object_sequence_motion(2, "立ちあがる", 6)
	event.queue_object_sequence_next_motion(2, "ぷるぷる", 0)
	wait.for_frame_count(40)
	wait.for_frame_count(30)
end

--- Plays the cutscene in which Toryon plants two trees beside Mints and Monica and spins.
function sindain.play_toryon_tree_planting_scene()
	local tree_x: f32 = 0
	local tree_z: f32 = 0
	local spin_frame: s32 = 0
	local spin_angle: f32 = 0
	local angle_delta: f32 = 0
	local phase: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character_motion_pack(5, "event/lm/e250r/e250_mints.gltf", "info", 0)
	event.set_character_position(0, -211.18, 0.0, 11.07)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "上見立ち", 4)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_sequence_object(0, 0)
	event.load_character(5, "chara/c02_base.gltf", "info", 8)
	event.set_character_active(8)
	event.attach_object_handle_to_character(1, 8)
	event.load_equipment_model(5, 1, 4, "info", 8)
	event.load_equipment_model(5, 1, 3, "info", 8)
	event.load_equipment_model(5, 1, 2, "info", 8, 13)
	event.set_character_active(13)
	event.set_character_position(8, -173.24, 0.0, 0.0)
	event.set_character_rotation(8, 0.0, 0.0, 0.0)
	event.load_character_motion_pack(5, "event/lm/e250r/e250_monica.gltf", "info", 8)
	event.set_character_motion(8, "上見立ち", 4)
	event.attach_object_handle_to_character(1, 8)
	event.set_object_sequence_object(1, 1)
	event.load_character(5, "event/lm/e250r/e250_toryon.gltf", "info", 9)
	event.set_character_active(9)
	event.set_character_position(9, -1121.01, 394.47, -2048.83)
	event.set_character_rotation(9, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(2, 9)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/lm/e250r/e250_tree.gltf", "info", 10)
	event.set_character_rotation(10, 0.0, 3.14, 0.0)
	event.set_character_active(0, 10)
	event.attach_character_to_frame(9, "R_tree", 10)
	event.load_character(5, "event/lm/e250r/e250_tree.gltf", "info", 11)
	event.set_character_rotation(11, 0.0, 3.14, 0.0)
	event.set_character_active(0, 11)
	event.attach_character_to_frame(9, "L_tree", 11)
	event.attach_object_handle_to_character_frame(6, 9, "puropera")
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.rotate_object_sequence(6, 0.0, -0.2, 0.0, -1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-601.29, 522.11, 100.72)
	event.set_camera_sequence_look_at(-689.32, 571.24, -105.58)
	wait.frames(30)
	event.move_object_sequence_eased(2, -1121.01, 995.31, -2048.83, 60, 2, 0.5)
	event.rotate_object_sequence(2, 0.0, -3.14, 0.0, 40)
	event.rotate_object_sequence(2, 0.0, 1.57, 0.0, 20)
	event.rotate_object_sequence_eased(2, 0.0, 0.16, 0.0, 20, 2, 0.5)
	object.wait_until_done(2)
	event.move_object_sequence_eased(2, -671.63, 447.09, -193.49, 80, 1, 0.4)
	event.move_camera_sequence_eased(-601.29, 522.11, 100.72, -654.5, 581.35, -117.24, 60, 0, 0.4)
	object.wait_until_done(2)
	camera.wait_until_done()
	event.set_camera_sequence_position(-298.8, 199.33, -185.86)
	event.set_camera_sequence_look_at(-194.57, 243.43, 136.45)
	event.set_character_active(1, 10)
	event.set_character_active(1, 11)
	event.set_character_position(9, -221.16, 0.0, 293.2)
	event.set_character_rotation(9, 0.0, 3.14, 0.0)
	event.set_character_motion(9, "木持ち浮遊", 4)
	event.move_camera_sequence_eased(-299.31, 60.07, -348.88, -167.05, 136.09, 169.13, 60, 0, 0.5)
	camera.wait_until_done()
	event.set_object_sequence_motion(2, "右の木を植える", 2)
	event.queue_object_sequence_next_motion(2, "右の木を植えるL", 4)
	wait.frames(18)
	event.set_character_motion(0, "右へよける", 6)
	event.set_character_motion(8, "左へよける", 6)
	wait.frames(5)
	do
		local out1, _, out3 = event.get_object_handle_frame_position(2, "R_tree")
		tree_x = out1 or tree_x
		tree_z = out3 or tree_z
	end
	event.detach_character_from_frame(10)
	event.set_character_position(10, tree_x, 0.0, tree_z)
	event.set_character_motion(10, "ぷるん", 6)
	event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
	object.wait_until_done(2)
	event.set_camera_sequence_position(-280.52, 44.63, 49.11)
	event.set_camera_sequence_look_at(-280.82, 14.35, 12.64)
	event.set_character_position(0, -281.18, 0.0, 11.07)
	event.set_character_position(9, -291.16, 0.0, 293.2)
	event.set_object_sequence_motion(0, "前を見る", 6)
	event.queue_object_sequence_next_motion(0, "前を見るL", 4)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "目・おどろき")
	event.set_object_sequence_texture_animation(0, 1, "口・はっ")
	object.wait_until_done(0)
	event.set_camera_sequence_position(-299.31, 60.07, -348.88)
	event.set_camera_sequence_look_at(-167.05, 136.09, 169.13)
	event.set_object_sequence_motion(2, "左の木を植える", 2)
	event.queue_object_sequence_next_motion(2, "左の木を植えるL", 4)
	wait.frames(18)
	event.set_object_sequence_motion(0, "左へよける", 6)
	wait.frames(5)
	do
		local out1, _, out3 = event.get_object_handle_frame_position(2, "L_tree")
		tree_x = out1 or tree_x
		tree_z = out3 or tree_z
	end
	event.detach_character_from_frame(11)
	event.set_character_position(11, tree_x, 0.0, tree_z)
	event.set_character_motion(11, "ぷるん", 6)
	event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
	object.wait_until_done(2)
	wait.frames(30)
	event.set_camera_sequence_position(-814.87, 217.76, -136.29)
	event.set_camera_sequence_look_at(-388.48, 229.58, 435.09)
	event.move_camera_sequence_eased(-647.69, 217.76, 87.74, -388.48, 229.58, 435.09, 64, 2, 0.5)
	event.set_character_position(9, -360.96, 101.44, 464.93)
	event.set_character_rotation(9, 0.0, -2.9, 0.0)
	event.set_object_sequence_motion(2, "まわる", 6)
	event.queue_object_sequence_next_motion(2, "まわるL", 6)
	event.delay_object_sequence_motion_track(2, 1)
	event.set_object_sequence_motion_step(2, 1.0)
	event.queue_object_sequence_next_motion(2, "ピース", 6)
	event.queue_object_sequence_next_motion(2, "ピースL", 4)
	spin_frame = 0
	spin_angle = vm.f32(-2.9)
	phase = 0
	while spin_frame < 68 do
		phase = vm.f32(phase + vm.f32(0.04619989))
		angle_delta = vm.f32(vm.sin(phase) * vm.f32(0.3))
		spin_angle = vm.f32(spin_angle + angle_delta)
		spin_angle = event.wrap_angle(spin_angle) or spin_angle
		event.set_character_rotation(9, 0.0, spin_angle, 0.0)
		spin_frame = spin_frame + 1
		vm.wait(14)
	end
	vm.wait(15)
	wait.until_button_pressed(64)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(13)
end

--- Places the camera and player at fixed positions and fades in from white.
function sindain.restore_player_view_with_white_fade()
	event.set_camera_position(-738.31, 36.31, -959.51)
	event.set_camera_look_at(-716.6, 22.73, -1033.69)
	event.set_character_position(0, -700.0, 0.0, -1090.0)
	event.set_character_rotation(0, 0.0, -0.26, 0.0)
	event.reset_follow_camera(1, 3.14, 2.0)
	event.fade_in_screen(30, 255.0, 255.0, 255.0)
end

--- Runs the player into view with a camera move and fade-in unless save flag 207 is set while flag 208 is clear.
function sindain.run_player_in_with_camera()
	local flag_208: s32 = 0
	local flag_207: s32 = 0
	event.initialize_event()
	flag_208 = event.get_save_flag(208) or flag_208
	flag_207 = event.get_save_flag(207) or flag_207
	if not (flag_208 == 0 and flag_207 == 1) then
		event.clear_camera_sequence()
		event.set_camera_sequence_position(324.12, 34.59, 830.75)
		event.set_camera_sequence_look_at(362.46, 42.77, 960.05)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 404.68, 0.0, 1124.89)
		event.set_object_sequence_rotation(0, 0.0, -2.84, 0.0)
		event.move_camera_sequence_eased(324.12, 34.59, 830.75, 377.85, 23.14, 1003.73, 48, 2, 0.25)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_object_sequence(0, 361.74, 0.0, 957.26, 60)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
		wait.frames(60)
		event.reset_follow_camera(0)
	end
end

--- Shows the gate message window before chapter 8, with text chosen by the condition checks.
function sindain.show_gate_message(only_when_condition_met: s32, use_alternate_text: s32)
	local chapter: s32 = 0
	local message_id: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter >= 8 then
		return
	end
	event.set_message_window_mode(1, 8)
	event.set_character_motion(0, "立ち")
	message_id = 1050
	if sindain.has_any_analysis_condition_met() ~= 0 then
		message_id = 1051
	elseif only_when_condition_met ~= 0 then
		return
	end
	if use_alternate_text ~= 0 then
		message_id = message_id + 10
	end
	event.open_message_window_2(1, message_id)
	message.show(1, -1, 8, 0, 0)
end

--- Shows the gate message with the default text, and only when a gate condition is met if the argument is set.
function sindain.show_gate_message_with_default_text(only_when_condition_met: s32)
	sindain.show_gate_message(only_when_condition_met, 0)
end

--- Shows an option prompt for message 1000 plus the prompt index, returning the chosen option, or 0 for indexes above 1.
function sindain.show_option_prompt(prompt_index: s32)
	local resume_point: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(1, 4)
		message.set_window_mode(1, 4)
		if prompt_index == 0 then
			resume_point = 1
			return message.open_and_ask_choice(1, 1000 + prompt_index, 7, 0, 0, 2, 0)
		end
		if prompt_index == 1 then
			resume_point = 2
			return message.open_and_ask_choice(1, 1000 + prompt_index, 7, 0, 0, 3, 0)
		end
		return 0
	end, function(received: { any })
		if resume_point <= 1 then
			return message.ask_choice_skipping(1, vm.i32(1000 + prompt_index), 7, 0, 0, 2, 0)
		end
		if resume_point <= 2 then
			return message.ask_choice_skipping(1, vm.i32(1000 + prompt_index), 7, 0, 0, 3, 0)
		end
		return nil
	end)
end

--- Runs the skip-mode pass of a 60-frame wait without waiting.
function sindain.skip_60_frame_wait()
	wait.frames_skipping(60)
end

--- Loads the g01b_1 event script when save flag 207 is set and flag 208 is clear.
function sindain.start_g01b_event_if_pending()
	local story_flag: s32 = 0
	story_flag = event.get_save_flag(207) or story_flag
	if story_flag == 1 then
		story_flag = event.get_save_flag(208) or story_flag
		if story_flag == 0 then
			event.fade_out_screen(0)
			vm.wait(1)
			event.load_event_script("g01/g01b_1.stb", 501)
		end
	end
end

--- Enables the door function point when save flag 209 is set and shows characters 120 and 121 when save flag 250 is set.
function sindain.update_door_and_character_visibility()
	local story_flag: s32 = 0
	story_flag = event.get_save_flag(209) or story_flag
	if story_flag == 0 then
		event.set_function_point_enabled("p01_g010701", "door", 0)
	else
		event.set_function_point_enabled("p01_g010701", "door", 1)
	end
	story_flag = event.get_save_flag(250) or story_flag
	if story_flag == 1 then
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
	else
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
	end
end

--- Waits 31 frames.
function sindain.wait_31_frames()
	wait.for_frame_count(30)
end

--- Waits 16 frames then 31 frames, 47 in total.
function sindain.wait_47_frames()
	wait.for_frame_count(15)
	wait.for_frame_count(30)
end

--- Fades in while sequences 0 and 1 walk to their end positions.
function sindain.walk_characters_in_with_fade()
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
	event.fade_in_screen(15)
	event.move_object_sequence(0, 418.52, 0.01, 950.16, 75, 1)
	event.move_object_sequence(1, 399.78, 0.0, 963.89, 75, 1)
	wait.frames(75)
end

return sindain
