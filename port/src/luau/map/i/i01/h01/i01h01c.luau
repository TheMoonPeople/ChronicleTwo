--!strict
--- Palm Brinks workshop script that runs the Steve and Flotsam rematch scenes and the workshop owner's conversation.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local palm_brinks_shop_house = require("@lib/event/palm_brinks_shop_house")
local wait = require("@lib/event/wait")

--- Plays the Mints and Starbre exchange and asks whether to continue, returning 1 when the player agrees.
local function ask_to_begin_introduction(se_id: s32)
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
		resume_step = 1
		camera.wait_until_done()
		event.set_camera_sequence_position(-26.93, 26.72, -145.82)
		event.set_camera_sequence_look_at(27.6, 22.54, -159.02)
		event.set_object_sequence_position(0, 16.25, -0.02, -166.37)
		event.set_object_sequence_rotation(0, 0.0, 1.16, 0.0)
		event.set_object_sequence_motion(0, "上見立ち", 4)
		event.set_object_sequence_position(2, 38.77, -0.02, -147.68)
		event.set_object_sequence_rotation(2, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		resume_step = 2
		wait.for_frame_count(30)
		event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
		resume_step = 3
		camera.wait_until_done()
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		resume_step = 4
		wait.for_frame_count(10)
		event.set_mouth_texture_animations(2, "大口パク")
		resume_step = 5
		message.show_voiced(1060010)
		event.reset_mouth_texture_animations()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "ＯＫ！！\nもう少し待って。")
		resume_step = 6
		choice = message.open_and_ask_choice(0, -1, 8, 0, 0, 2, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if choice == 0 then
			resume_step = 7
			message.show_voiced(1060040)
			event.play_sound_effect(se_id, 2)
			event.set_object_sequence_motion(0, "ガッツポーズ", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "上見立ち", 4)
			event.set_object_sequence_motion(2, "ガッツポーズ", 6)
			event.queue_object_sequence_next_motion(2, "立ち", 0)
			event.set_mouth_texture_animations(2, "大口パク")
			resume_step = 8
			message.show_voiced(1060050)
			event.reset_mouth_texture_animations()
			event.fade_out_music(30)
			event.fade_out_screen(30)
			resume_step = 9
			wait.for_frame_count(30)
			return 1
		else
			event.set_object_sequence_motion(0, "上見会話", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "上見立ち", 4)
			resume_step = 10
			wait.for_frame_count(9)
			resume_step = 11
			message.show_voiced(1060020)
			event.set_object_sequence_motion(2, "会話2", 6)
			resume_step = 12
			wait.for_frame_count(9)
			event.set_mouth_texture_animations(2, "大口パク")
			resume_step = 13
			message.show_voiced(1060030)
			event.reset_mouth_texture_animations()
			return 0
		end
	end, function(received: { any })
		if resume_step <= 9 then
			if resume_step == 6 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 2 then
				wait.background_load_skipping()
			end
			if resume_step <= 3 then
				wait.skip_frame_count(10)
			end
			if resume_step <= 4 then
				message.show_voiced_skipping(1060010)
			end
			if resume_step <= 5 then
				choice = message.open_choice_skipping(0, -1, 8, 0, 0, 2, 0)
			end
			if resume_step <= 6 then
				message.show_voiced_skipping(1060040)
			end
			if resume_step <= 7 then
				message.show_voiced_skipping(1060050)
			end
			if resume_step <= 8 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if resume_step <= 13 then
			if resume_step <= 10 then
				message.show_voiced_skipping(1060020)
			end
			if resume_step <= 11 then
				wait.skip_frame_count(9)
			end
			if resume_step <= 12 then
				message.show_voiced_skipping(1060030)
			end
			return 0
		end
		return nil
	end)
end

--- Shows Steve standing in the corridor light and switches the light frame on.
local function show_steve_in_light(light_visible: s32, se_id: s32)
	event.set_camera_sequence_position(-98.46, 29.02, -221.77)
	event.set_camera_sequence_look_at(-133.84, 25.44, -219.86)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -143.53, -12.49, -220.28)
	event.set_object_sequence_rotation(0, 0.0, 1.61, 0.0)
	event.set_object_sequence_position(2, -79.25, -13.53, -223.34)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_position(3, -143.53, -12.49, -220.28)
	event.set_object_sequence_rotation(3, 0.0, 1.61, 0.0)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(3)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(3, "立ち（スティーブ）", 4)
	event.fade_in_screen(30)
	wait.for_frame_count(30)
	wait.for_frame_count(45)
	event.play_sound_effect(se_id, 6)
	event.play_sound_effect(se_id, 8)
	event.set_object_handle_frame_draw_flag(3, "light", light_visible)
	wait.for_frame_count(45)
end

--- Plays the first lines of the exchange between Starbre and the party in the corridor.
local function play_starbre_greeting_exchange(sound_bank: any)
	local projection: f32 = 0
	event.set_camera_sequence_position(-51.29, 55.13, -119.05)
	event.set_camera_sequence_look_at(-104.92, 14.85, -202.28)
	projection = event.get_event_projection() or projection
	event.set_event_projection(524.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -85.21, -13.05, -197.85)
	event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.set_object_handle_visible(11, 1)
	event.set_object_sequence_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(3, "下見立ち", 4)
	event.set_object_sequence_motion(2, "上見立ち", 4)
	wait.for_frame_count(15)
	event.set_object_sequence_motion(2, "上見会話", 6)
	event.queue_object_sequence_next_motion(2, "上見立ち", 0)
	event.set_mouth_texture_animations(2, "大口パク")
	message.show_voiced(1060060)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(2, "大口パク")
	message.show_voiced(1060061)
	event.reset_mouth_texture_animations()
	event.set_event_projection(projection)
end

--- Plays the lines in which the party promises to take care of the task.
local function play_starbre_assurance_exchange(sound_bank: any)
	event.set_camera_sequence_position(-93.2, 20.09, -139.75)
	event.set_camera_sequence_look_at(-109.87, 17.08, -226.98)
	event.reset_object_sequence_motion(1)
	event.reset_object_sequence_motion(3)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.reset_object_sequence_motion(0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -85.21, -13.05, -197.85)
	event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.reset_object_sequence_motion(3)
	event.set_object_handle_visible(11, 0)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.queue_object_sequence_next_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(2, "上見立ち", 4)
	event.set_object_sequence_motion(3, "うなづく", 6)
	event.queue_object_sequence_next_motion(3, "下見立ち", 4)
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(1060070)
	event.reset_mouth_texture_animations()
	wait.for_frame_count(15)
	event.set_object_sequence_motion(2, "上見会話2", 6)
	event.queue_object_sequence_next_motion(2, "上見立ち", 0)
	event.set_mouth_texture_animations(2, "わらい口パク")
	message.show_voiced(1060080)
	event.reset_mouth_texture_animations()
	wait.for_frame_count(15)
	event.set_object_sequence_motion(0, "まかせて", 6)
	event.queue_object_sequence_next_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(3, "まかせて", 6)
	event.queue_object_sequence_next_motion(3, "下見立ち", 4)
	wait.for_frame_count(10)
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(1060090)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
	object.wait_until_done(3)
end

--- Walks Steve and Starbre away down the corridor while the projection widens and the screen fades out.
local function walk_party_down_corridor(se_id: s32)
	local projection: f32 = 0
	local projection_range: f32 = 0
	local step_count: f32 = 0
	local projection_step: f32 = 0
	local step_index: f32 = 0
	local projection_2: f32 = 0
	event.set_camera_sequence_position(-120.59, 12.3, -121.56)
	event.set_camera_sequence_look_at(-121.3, 14.64, -178.67)
	event.get_event_projection(projection)
	event.set_event_projection(478.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -128.93, -12.49, -206.0)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -92.88, -13.05, -212.34)
	event.set_object_sequence_rotation(2, 0.0, -1.44, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -128.93, -12.49, -206.0)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.set_object_handle_visible(11, 0)
	vm.wait(1)
	event.set_object_sequence_motion(2, "歩き", 4)
	event.rotate_object_sequence(2, 0.0, -2.88, 0.0, 15)
	event.delay_object_sequence_motion_track(2, 15)
	event.set_object_sequence_motion(2, "上見立ち", 0)
	event.play_sound_effect(se_id, 4)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(3)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(3, "歩き（スティーブ）", 4)
	event.rotate_object_sequence(0, 0.0, -3.11, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -3.11, 0.0, 30)
	wait.for_frame_count(30)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 0)
	event.set_object_sequence_motion(3, "立ち（スティーブ）", 0)
	event.play_sound_effect(se_id, 5)
	event.rotate_object_sequence(12, 0.0, -1.57, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 1.57, 0.0, 50)
	wait.for_frame_count(50)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(3, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -125.29, -12.78, -310.13, 120)
	event.move_object_sequence(3, -125.29, -12.78, -310.13, 120)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(70)
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	step_index = 1.0
	projection_range = vm.f32(132.00003)
	step_count = 120.0
	projection_step = vm.f32(vm.fdiv(projection_range, step_count))
	while true do
		projection_2 = vm.f32(vm.f32(478.9) + vm.f32(projection_step * step_index))
		event.set_event_projection(projection_2)
		vm.wait(4)
		step_index = vm.f32(step_index + 1.0)
		if step_index > step_count then
			break
		end
	end
	event.set_event_projection(projection)
end

--- Fast-forwards the introduction question and returns 1.
local function skip_ask_to_begin_introduction(sound_bank: s32)
	wait.background_load_skipping()
	wait.skip_frame_count(30)
	wait.background_load_skipping()
	wait.skip_frame_count(10)
	message.show_voiced_skipping(1060010)
	local _ = message.open_choice_skipping(0, -1, 8, 0, 0, 2, 0)
	message.show_voiced_skipping(1060040)
	message.show_voiced_skipping(1060050)
	wait.skip_frame_count(30)
	return 1
end

--- Fast-forwards the shot of Steve standing in the corridor light.
local function skip_show_steve_in_light(light_visible: s32, sound_bank: s32)
	wait.skip_frame_count(30)
	wait.skip_frame_count(45)
	wait.skip_frame_count(45)
end

--- Fast-forwards the first lines of the corridor exchange.
local function skip_starbre_greeting_exchange(sound_bank: any)
	wait.skip_frame_count(15)
	message.show_voiced_skipping(1060060)
	message.show_voiced_skipping(1060061)
end

--- Fast-forwards the promise lines of the corridor exchange.
local function skip_starbre_assurance_exchange(sound_bank: any)
	message.show_voiced_skipping(1060070)
	wait.skip_frame_count(15)
	message.show_voiced_skipping(1060080)
	wait.skip_frame_count(15)
	wait.skip_frame_count(10)
	message.show_voiced_skipping(1060090)
	cutscene.skip_command(0)
	cutscene.skip_command(3)
end

--- Fast-forwards the walk of the party down the corridor.
local function skip_walk_party_down_corridor(sound_bank: s32)
	local step_index: f32 = 0
	wait.skip_frame_count(30)
	wait.skip_frame_count(50)
	step_index = 1.0
	step_index = vm.f32(step_index + 1.0)
end

--- Plays the Steve introduction scene in the workshop and returns 1 when the player went through it.
local function play_steve_introduction_scene()
	local accepted: s32 = 0
	local light_visible: s32 = 0
	local sound_bank: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local projection: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		vm.section(function()
			resume_step = 1
			vm.entry(1)
			event.set_save_flag(106, 1)
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			sound_bank = event.load_sound_effect_file_2(1231) or sound_bank
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
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
			event.load_character_motion_pack(5, "event/e100/e106/e106_mints.gltf", "info", 0)
			event.set_character_active(1, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character(5, "event/e100/e106/e106_starbre.gltf", "info", 34)
			event.attach_object_handle_to_character(2, 34)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_character_active(1, 34)
			event.load_character(5, "event/e100/e106/e106_steve.gltf", "info", 35)
			event.set_character_active(1, 35)
			event.attach_object_handle_to_character(3, 35)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_handle_sound_bank(3, sound_bank)
			event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
			event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
			event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
			event.clear_object_sequence(12)
			event.set_object_sequence_object(12, 12)
			event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
			event.clear_object_sequence(13)
			event.set_object_sequence_object(13, 13)
			event.load_message_file(0, 5, "event/e100/e106/e106.txt")
			event.stop_music(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
			event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
			event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
			resume_step = 2
			accepted = ask_to_begin_introduction(sound_bank)
			if accepted == 1 then
				event.delete_character_extension_packs(0)
				event.load_character_motion_pack(5, "event/e100/e106/e106_mints2.gltf", "info", 0)
				light_visible = event.is_object_handle_frame_visible(3, "light") or light_visible
				event.set_object_handle_frame_visible(3, "light", 0)
				projection = event.get_event_projection() or projection
				event.enable_drama_skip()
				resume_step = 3
				show_steve_in_light(light_visible, sound_bank)
				resume_step = 4
				play_starbre_greeting_exchange(sound_bank)
				resume_step = 5
				play_starbre_assurance_exchange(sound_bank)
				event.set_object_handle_sound_bank(3, sound_bank)
				resume_step = 6
				walk_party_down_corridor(sound_bank)
			end
			event.fade_out_screen(30)
			resume_step = 7
			wait.for_frame_count(30)
		end, function(received: { any }): boolean
			if resume_step == 2 then
				accepted = received[1] :: number
			end
			if resume_step <= 1 then
				accepted = skip_ask_to_begin_introduction(sound_bank)
			end
			if resume_step <= 2 then
				skip_show_steve_in_light(light_visible, sound_bank)
			end
			if resume_step <= 3 then
				skip_starbre_greeting_exchange(sound_bank)
			end
			if resume_step <= 4 then
				skip_starbre_assurance_exchange(sound_bank)
			end
			if resume_step <= 5 then
				skip_walk_party_down_corridor(sound_bank)
			end
			if resume_step <= 6 then
				wait.skip_frame_count(30)
			end
			return true
		end)
		resume_step = 8
		vm.entry(8)
		event.cancel_drama_scene_skip()
		event.stop_sound_effect(sound_bank, 6)
		event.set_event_projection(projection)
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.set_character_motion(0, "立ち", 4)
		event.set_character_active(1, 0)
		event.delete_character_extension_packs(0)
		event.delete_character(34)
		event.delete_character(35)
		if accepted ~= 1 then
			event.play_music(0)
		end
		event.fade_in_screen(30)
		return accepted
	end, function(received: { any })
		if resume_step <= 8 then
			return accepted
		end
		return nil
	end)
end

--- Fades in on the corridor and walks Steve toward the player while the doors swing.
local function walk_steve_into_corridor(se_id: s32)
	local projection: f32 = 0
	event.set_camera_sequence_position(-84.68, 6.96, -155.87)
	event.set_camera_sequence_look_at(-202.81, 27.8, -509.36)
	event.get_event_projection(projection)
	event.set_event_projection(468.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -121.68, -12.53, -351.93)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, -121.68, -12.53, -351.93)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(10, 0)
	event.set_object_handle_visible(11, 0)
	event.set_object_sequence_rotation(12, 0.0, -1.57, 0.0)
	event.set_object_sequence_rotation(13, 0.0, 1.57, 0.0)
	event.set_object_handle_visible(14, 0)
	event.set_object_handle_visible(15, 0)
	event.fade_out_screen(0)
	object.wait_until_done(12)
	object.wait_until_done(13)
	event.play_sound_effect(se_id, 0)
	event.fade_in_screen(30)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -119.53, -12.53, -218.69, 100)
	event.move_object_sequence(1, -119.53, -12.53, -218.69, 100)
	wait.for_frame_count(80)
	event.play_sound_effect(se_id, 4)
	event.rotate_object_sequence(12, 0.0, 0.0, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 0.0, 0.0, 50)
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	event.set_event_projection(projection)
end

--- Plays the corridor shots that end with the hint that Steve starts the Flotsam rematch.
local function show_steve_rematch_hint(se_id: s32)
	event.set_camera_sequence_position(-119.36, 26.55, -129.41)
	event.set_camera_sequence_look_at(-121.06, 12.13, -226.83)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	wait.for_frame_count(50)
	event.stop_sound_effect(se_id, 0)
	event.play_sound_effect(se_id, 5)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	wait.for_frame_count(30)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.set_camera_sequence_position(-107.26, 10.75, -131.0)
	event.set_camera_sequence_look_at(-110.45, 11.92, -193.48)
	event.set_character_position(0, -91.97, -12.53, -211.57)
	event.set_character_rotation(0, 0.0, -2.4, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.set_character_position(33, -119.53, -12.53, -229.18)
	event.set_character_rotation(33, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(1)
	event.set_object_handle_frame_visible(1, "light--c0appz0n1", 0)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(100, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]ポルカスに再挑戦するなら\n   スティーブに(O)ボタンで\n   アクセスしてください。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
end

--- Sets up the corridor scene with Steve, plays it through the rematch hint and restores the camera, characters and map parts.
local function play_steve_corridor_scene()
	local sound_bank: s32 = 0
	local steve_sound_bank: s32 = 0
	local projection: f32 = 0
	vm.section(function()
		event.set_save_flag(108, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(1822) or sound_bank
		steve_sound_bank = event.load_sound_effect_file_3(7, "snd2/chara/ch_040.sound.json") or steve_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		projection = event.get_event_projection() or projection
		event.get_camera_position()
		event.get_camera_look_at()
		event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 0.0, 50.0, 0.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 33)
		event.set_character_active(1, 33)
		event.attach_object_handle_to_character(1, 33)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_position(33, 0.0, 50.0, 0.0)
		event.set_character_rotation(33, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(1, steve_sound_bank)
		event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
		event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
		event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
		event.clear_object_sequence(13)
		event.set_object_sequence_object(13, 13)
		event.attach_object_handle_to_map_part_3(14, "p07_i01h01", "i01h01_08-m0")
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.attach_object_handle_to_map_part_3(15, "p07_i01h01", "i01h01_08-m1")
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		walk_steve_into_corridor(sound_bank)
		show_steve_rematch_hint(sound_bank)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.clear_object_sequence(0)
	event.clear_object_sequence(12)
	event.clear_object_sequence(13)
	event.set_save_flag(56, 0)
	event.set_event_projection(projection)
	event.set_camera_position(-119.36, 26.55, -129.41)
	event.set_camera_look_at(-121.06, 12.13, -226.83)
	event.set_character_position(0, -98.38, -12.53, -200.14)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_object_handle_rotation(12, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(13, 0.0, 0.0, 0.0)
	vm.wait(4)
	event.set_object_handle_visible(10, 1)
	event.set_object_handle_visible(11, 1)
	event.set_object_handle_visible(14, 1)
	event.set_object_handle_visible(15, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Asks whether Mints is ready to face Flotsam again and returns 1 when the player confirms.
local function ask_ready_for_rematch(sound_bank: any)
	local choice: any = 0
	local previous_window_mode: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_camera_sequence_position(-138.16, 13.17, -131.29)
		event.set_camera_sequence_look_at(-115.98, 11.22, -208.05)
		event.set_character_active(1, 0)
		event.set_object_sequence_position(0, -98.38, -12.53, -200.14)
		event.set_object_sequence_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_active(1, 33)
		event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.reset_object_sequence_motion(1)
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		previous_window_mode = event.get_message_window_frame(0) or previous_window_mode
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "よし！ポルカスに再挑戦だ。\nもう少し準備がたりない。")
		resume_step = 1
		choice = message.open_and_ask_choice(0, -1, 8, 0, 0, 2, 0)
		event.set_message_window_mode(0, previous_window_mode)
		if choice == 0 then
			event.mark_camera_sequence_fade_track()
			event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
			resume_step = 2
			wait.for_frame_count(30)
			resume_step = 3
			camera.wait_until_done()
			resume_step = 4
			vm.wait(4)
			return 1
		end
		return 0
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 2 then
				wait.background_load_skipping()
			end
			return 1
		end
		return nil
	end)
end

--- Fades the camera sequence in on Steve waiting in the corridor.
local function show_steve_waiting_in_corridor(se_id: s32)
	event.set_camera_sequence_position(-120.34, 23.49, -175.84)
	event.set_camera_sequence_look_at(-120.44, 21.93, -203.94)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.play_sound_effect(se_id, 1)
	wait.for_frame_count(50)
end

--- Fast-forwards the shot of Steve waiting in the corridor.
local function skip_show_steve_waiting(sound_bank: s32)
	wait.background_load_skipping()
	cutscene.skip_command(0)
	cutscene.skip_command(1)
	wait.skip_frame_count(50)
end

--- Asks for confirmation and plays the Flotsam rematch scene, returning 1 when it was played.
local function play_rematch_scene()
	local sound_bank: s32 = 0
	local projection: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local confirmed: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		vm.section(function()
			event.set_character_active(0, 24)
			event.set_save_flag(108, 1)
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			event.load_map_sounds(1237)
			sound_bank = event.load_sound_effect_file_2(1237) or sound_bank
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			projection = event.get_event_projection() or projection
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
			event.clear_camera_sequence()
			event.set_camera_position(6.02, 94.24, 399.23)
			event.set_camera_look_at(-4.96, 118.28, 117.71)
			event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
			event.set_character_active(1, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_character_position(0, 0.0, 50.0, 0.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 33)
			event.set_character_active(1, 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_character_position(33, 0.0, 50.0, 0.0)
			event.set_character_rotation(33, 0.0, 0.0, 0.0)
			event.set_object_handle_sound_bank(1, sound_bank)
			event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
			event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
			event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
			event.clear_object_sequence(12)
			event.set_object_sequence_object(12, 12)
			event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
			event.clear_object_sequence(13)
			event.set_object_sequence_object(13, 13)
			event.set_object_sequence_rotation(13, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_map_part_3(14, "p07_i01h01", "i01h01_08-m0")
			event.clear_object_sequence(14)
			event.set_object_sequence_object(14, 14)
			event.attach_object_handle_to_map_part_3(15, "p07_i01h01", "i01h01_08-m1")
			event.clear_object_sequence(15)
			event.set_object_sequence_object(15, 15)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "おこり顔")
			event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
			resume_step = 1
			confirmed = ask_ready_for_rematch(sound_bank)
			if confirmed == 1 then
				event.enable_drama_skip()
				resume_step = 2
				show_steve_waiting_in_corridor(sound_bank)
				resume_step = 3
				palm_brinks_shop_house.play_corridor_exit_scene(sound_bank)
				event.set_save_flag(56, 1)
			else
				event.set_save_flag(56, 0)
			end
			event.fade_out_screen(30)
			resume_step = 4
			wait.for_frame_count(30)
		end, function(received: { any }): boolean
			if resume_step == 1 then
				confirmed = received[1] :: number
			end
			if resume_step <= 1 then
				skip_show_steve_waiting(sound_bank)
			end
			if resume_step <= 2 then
				palm_brinks_shop_house.skip_corridor_exit_scene(sound_bank)
			end
			if resume_step <= 3 then
				wait.skip_frame_count(30)
			end
			return true
		end)
		resume_step = 5
		vm.entry(5)
		event.cancel_drama_scene_skip()
		event.stop_sound_effect(sound_bank, 1)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.get_event_projection(projection)
		event.get_camera_position(camera_x, camera_y, camera_z)
		event.get_camera_look_at(look_at_x, look_at_y, look_at_z)
		resume_step = 6
		vm.wait(6)
		event.delete_character_extension_packs(0)
		event.delete_character(33)
		event.fade_in_screen(30)
		return confirmed
	end, function(received: { any })
		if resume_step <= 6 then
			return confirmed
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Plays the Steve introduction scene and grants the starting inventions and party member when it completes.
function script.cutscene_steve_introduction()
	local accepted: s32 = 0
	local item_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.fade_out_screen(10)
		resume_step = 1
		wait.for_frame_count(10)
		palm_brinks_shop_house.hide_house_owner()
		resume_step = 2
		accepted = play_steve_introduction_scene()
		if accepted == 1 then
			event.add_inventory_item(135, 1)
			event.add_inventory_item(145, 1)
			event.add_inventory_item(155, 1)
			event.add_inventory_item(165, 1)
			resume_step = 3
			vm.wait(3)
			item_count = event.get_item_count(246) or item_count
			if item_count == 0 then
				event.add_inventory_item(246, 1)
			end
			event.set_party_member(2, 1)
			event.set_character_change_enabled(2, 1)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(0, 1)
			event.set_save_flag(25, 1)
			event.fade_out_screen(30)
			resume_step = 4
			wait.for_frame_count(30)
			event.fade_in_screen(30)
		else
			palm_brinks_shop_house.resume_exploration()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			resume_step = 5
			vm.wait(5)
			event.load_event_script("i01h01/i01h01.stb", -1)
		end
		return
	end, function(received: { any })
		if resume_step <= 5 then
			if resume_step == 2 then
				accepted = received[1] :: number
			end
			if resume_step <= 1 then
				cutscene.noop()
				resume_step = 2
				accepted = play_steve_introduction_scene()
				return vm.continue_with(function()
					if accepted == 1 then
						event.add_inventory_item(135, 1)
						event.add_inventory_item(145, 1)
						event.add_inventory_item(155, 1)
						event.add_inventory_item(165, 1)
						resume_step = 3
						vm.wait(3)
						item_count = event.get_item_count(246) or item_count
						if item_count == 0 then
							event.add_inventory_item(246, 1)
						end
						event.set_party_member(2, 1)
						event.set_character_change_enabled(2, 1)
						event.set_character_change_unmasked(2, 1)
						event.set_character_change_unmasked(0, 1)
						event.set_save_flag(25, 1)
						event.fade_out_screen(30)
						resume_step = 4
						wait.for_frame_count(30)
						event.fade_in_screen(30)
					else
						palm_brinks_shop_house.resume_exploration()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						resume_step = 5
						vm.wait(5)
						event.load_event_script("i01h01/i01h01.stb", -1)
					end
					return
				end)
			end
			if resume_step <= 3 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 4 then
				cutscene.noop()
			end
			return 0
		end
		return nil
	end)
end
script[151] = script.cutscene_steve_introduction

--- Event 200, which map data, a script or the engine runs by number.
script[200] = palm_brinks_shop_house.exit_to_town

--- Plays the Steve introduction scene, grants the starting items and party member and enters the dungeon.
function script.cutscene_steve_introduction_then_enter_dungeon()
	local accepted: s32 = 0
	local item_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.fade_out_screen(10)
		resume_step = 1
		wait.for_frame_count(10)
		palm_brinks_shop_house.hide_house_owner()
		resume_step = 2
		accepted = play_steve_introduction_scene()
		if accepted == 1 then
			item_count = event.get_item_count(246) or item_count
			if item_count <= 0 then
				event.add_inventory_item(135, 1)
				event.add_inventory_item(145, 1)
				event.add_inventory_item(155, 1)
				event.add_inventory_item(165, 1)
				resume_step = 3
				vm.wait(3)
				event.add_inventory_item(246, 1)
			end
			event.set_party_member(2, 1)
			event.set_character_change_enabled(2, 1)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(0, 1)
			event.set_save_flag(25, 1)
			event.fade_out_screen(30)
			resume_step = 4
			wait.for_frame_count(30)
			resume_step = 5
			inventory.open_overflow_menu()
			event.skip_next_music_load()
			event.go_to_dungeon(0, 4, 520)
			resume_step = 6
			vm.wait(6)
			return
		else
			palm_brinks_shop_house.resume_exploration()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			resume_step = 7
			vm.wait(7)
			event.load_event_script("i01h01/i01h01.stb", -1)
		end
		return
	end, function(received: { any })
		if resume_step <= 6 then
			if resume_step == 2 then
				accepted = received[1] :: number
			end
			if resume_step <= 1 then
				cutscene.noop()
				resume_step = 2
				accepted = play_steve_introduction_scene()
				return vm.continue_with(function()
					if accepted == 1 then
						item_count = event.get_item_count(246) or item_count
						if item_count <= 0 then
							event.add_inventory_item(135, 1)
							event.add_inventory_item(145, 1)
							event.add_inventory_item(155, 1)
							event.add_inventory_item(165, 1)
							resume_step = 3
							vm.wait(3)
							event.add_inventory_item(246, 1)
						end
						event.set_party_member(2, 1)
						event.set_character_change_enabled(2, 1)
						event.set_character_change_unmasked(2, 1)
						event.set_character_change_unmasked(0, 1)
						event.set_save_flag(25, 1)
						event.fade_out_screen(30)
						resume_step = 4
						wait.for_frame_count(30)
						resume_step = 5
						inventory.open_overflow_menu()
						event.skip_next_music_load()
						event.go_to_dungeon(0, 4, 520)
						resume_step = 6
						vm.wait(6)
						return
					else
						palm_brinks_shop_house.resume_exploration()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						resume_step = 7
						vm.wait(7)
						event.load_event_script("i01h01/i01h01.stb", -1)
					end
					return
				end)
			end
			if resume_step <= 3 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 4 then
				cutscene.skip_step()
			end
			return 0
		end
		if resume_step <= 7 then
			return 0
		end
		return nil
	end)
end
script[500] = script.cutscene_steve_introduction_then_enter_dungeon

--- Plays the corridor scene with Steve and returns the player to the workshop with Steve out of the party.
function script.cutscene_steve_corridor()
	palm_brinks_shop_house.hide_house_owner()
	event.set_character_active(0, 26)
	event.set_character_active(0, 25)
	play_steve_corridor_scene()
	event.set_character_active(1, 25)
	event.initialize_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.set_character_active(1, 25)
	event.set_character_active(1, 26)
	event.attach_character_to_frame(25, "back", 26)
	event.set_party_member(2, 0)
	event.set_function_point_enabled("", "fc_event_e108c", 1)
	wait.for_frame_count(30)
	vm.wait(3)
	event.load_event_script("i01h01/i01h01.stb", -1)
end
script[510] = script.cutscene_steve_corridor

--- Plays the Flotsam rematch scene and enters the dungeon or returns to the workshop depending on the player's choice.
function script.cutscene_flotsam_rematch()
	local confirmed: s32 = 0
	palm_brinks_shop_house.hide_house_owner()
	event.set_character_active(0, 25)
	event.set_character_active(0, 26)
	confirmed = play_rematch_scene()
	if confirmed == 1 then
		event.set_save_flag(25, 1)
		event.set_party_member(2, 1)
		event.skip_next_music_load()
		event.go_to_dungeon(0, 4, 520)
	else
		event.set_save_flag(29, 1)
		event.set_character_active(1, 25)
		event.set_character_active(1, 26)
		event.set_function_point_enabled("", "fc_event_e108c", 1)
		vm.wait(2)
		event.load_event_script("i01h01/i01h01.stb", -1)
		return
	end
end
script[520] = script.cutscene_flotsam_rematch

--- Handles the player talking to a character in the workshop.
function script.on_talk()
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		resume_step = 1
		vm.wait(1)
		resume_step = 2
		palm_brinks_shop_house.dispatch_talk_event()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				palm_brinks_shop_house.handle_talk_event()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.on_talk

return script
