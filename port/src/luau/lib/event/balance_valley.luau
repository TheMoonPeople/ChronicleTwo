--!strict
--- Event helpers for the Balance Valley map: intro cutscenes, area exits and entry setup.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local georama = vm.module("@lib/event/georama")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local balance_valley = {}

--- Asks whether to leave through the east exit, then runs out of the map and returns 1, or walks the player character back and returns 0.
function balance_valley.confirm_exit_east()
	local selection: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		resume_point = 1
		selection = message.ask_yes_no(5, 58)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if selection == 0 then
			event.set_camera_sequence_position(2745.73, 115.67, 336.92)
			event.set_camera_sequence_look_at(2562.52, 160.38, 739.42)
			event.set_object_sequence_position(0, 2625.24, 0.0, 792.83)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, 2625.24, 0.0, 792.83)
			event.add_object_sequence_path_point(0, 2608.8, 0.0, 896.1)
			event.add_object_sequence_path_point(0, 2558.92, 0.0, 1062.37)
			event.add_object_sequence_path_point(0, 2516.28, 0.0, 1156.04)
			event.start_object_sequence_path(0, 1)
			resume_point = 2
			wait.frames(30)
			event.fade_out_screen(30)
			resume_point = 3
			wait.frames(30)
			event.set_character_motion(0, "立ち", 4)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(-2.76)) * 30.0) + x)
			target_y = y
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(-2.76)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				y = vm.f32(y + 30.0)
				event.set_camera_look_at(x, y, z)
				i = i + 1
				resume_point = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point == 1 then
				selection = received[1] :: number
			end
			if resume_point <= 1 then
				wait.frames_skipping(30)
			end
			if resume_point <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if resume_point <= 4 then
			return 0
		end
		return nil
	end)
end

--- Asks whether to leave through the west exit, then runs out of the map and returns 1, or walks the player character back and returns 0.
function balance_valley.confirm_exit_west()
	local selection: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		resume_point = 1
		selection = message.ask_yes_no(5, 54)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if selection == 0 then
			event.set_camera_sequence_position(-839.6, 49.25, -439.32)
			event.set_camera_sequence_look_at(-953.56, 30.0, -547.13)
			event.set_object_handle_footstep_sound(0, 2)
			event.set_object_sequence_position(0, -1064.31, 0.0, -610.92)
			event.set_object_sequence_rotation(0, 0.0, -2.14, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.move_object_sequence(0, -1180.4, -72.61, -684.29, 50)
			resume_point = 2
			wait.frames(30)
			event.fade_out_screen(30)
			resume_point = 3
			wait.frames(30)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(0.92)) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(0.92)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				y = vm.f32(y + 30.0)
				event.set_camera_look_at(x, y, z)
				i = i + 1
				resume_point = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point == 1 then
				selection = received[1] :: number
			end
			if resume_point <= 1 then
				wait.frames_skipping(30)
			end
			if resume_point <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if resume_point <= 4 then
			return 0
		end
		return nil
	end)
end

--- Disables characters 120 and 121 outside debug mode while story flag 306 is not 1, then runs georama command 2.
function balance_valley.disable_extra_characters_and_run_georama()
	local story_flag: s32 = 0
	local debug_enabled: s32 = 0
	story_flag = event.get_save_flag(306) or story_flag
	if story_flag ~= 1 then
		debug_enabled = event.get_debug_flag() or debug_enabled
		if debug_enabled == 0 then
			event.set_character_active(0, 120)
			event.set_character_active(0, 121)
		end
	end
	event.run_georama_command(2)
end

--- Does nothing; an empty placeholder.
function balance_valley.do_nothing() end

--- Returns 1 when any of four georama-analysis gate conditions is met and its save flag is still unset, otherwise 0.
function balance_valley.has_pending_gate_condition()
	if georama.can_start_event_364() ~= 0 then
		return 1
	end
	if georama.can_start_event_368() ~= 0 then
		return 1
	end
	if georama.can_start_event_372() ~= 0 then
		return 1
	end
	if georama.can_start_event_376() ~= 0 then
		return 1
	end
	return 0
end

--- Plays the camera shot of the player character walking into the valley from the east edge and fades in.
function balance_valley.play_entry_walk_east()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 2492.28, 5.66, 457.27)
	event.set_object_sequence_rotation(0, 0.0, -2.76, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.move_object_sequence(0, 2466.56, 6.63, 395.9, 60)
	event.set_camera_sequence_look_at(2466.56, 36.63, 395.98)
	event.set_camera_sequence_position(2513.1, 56.63, 506.94)
	event.fade_in_screen(30)
	wait.frames(60)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(2)
	event.set_object_handle_footstep_sound(0, 0)
end

--- Plays the camera shot of the player character walking into the valley from the west edge and fades in.
function balance_valley.play_entry_walk_west()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_camera_sequence_position(-1091.22, 50.0, -610.47)
	event.set_camera_sequence_look_at(-951.89, 30.0, -531.81)
	event.set_object_sequence_position(0, -996.5, 0.0, -556.99)
	event.set_object_sequence_rotation(0, 0.0, 1.06, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.move_object_sequence(0, -951.89, 0.0, -531.81, 45)
	event.fade_in_screen(30)
	wait.frames(30)
	event.set_object_handle_footstep_sound(0, 0)
end

--- Plays the first Balance Valley cutscene in which the two party members walk in and talk, then restores the player character after the scene.
function balance_valley.play_first_intro_cutscene()
	local sound_effect: s32 = 0
	local playable_character_id: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(302, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(3203)
		sound_effect = event.load_sound_effect_file_2(3203) or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character_id = event.get_playable_character() or playable_character_id
		event.change_directory("event/e300/e302/")
		event.load_message_file(0, 5, "e302_1.txt")
		if playable_character_id == 0 then
			event.load_character_motion_pack(5, "e302_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character_id == 1 then
			event.load_character_motion_pack(5, "e302_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character_id == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e302/e302_mints.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 33)
			event.load_equipment_model(5, 1, 4, "info", 33)
			event.load_equipment_model(5, 1, 3, "info", 33)
			event.load_equipment_model(5, 1, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e302/e302_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(0, -896.43, 0.0, -466.97)
		event.set_object_handle_rotation(0, 0.0, 1.46, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 90)
		event.add_object_sequence_path_point(0, -942.31, 0.0, -490.69)
		event.add_object_sequence_path_point(0, -900.66, 0.0, -465.41)
		event.add_object_sequence_path_point(0, -864.88, 0.0, -454.67)
		event.add_object_sequence_path_point(0, -842.75, 0.0, -451.14)
		event.start_object_sequence_path(0)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(1, -906.51, 0.0, -493.26)
		event.set_object_handle_rotation(1, 0.0, 1.46, 0.0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 94)
		event.add_object_sequence_path_point(1, -936.77, 0.0, -513.55)
		event.add_object_sequence_path_point(1, -908.26, 0.0, -495.93)
		event.add_object_sequence_path_point(1, -873.95, 0.0, -481.67)
		event.add_object_sequence_path_point(1, -846.98, 0.0, -473.74)
		event.start_object_sequence_path(1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 94)
		event.set_object_sequence_motion(1, "立ち")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-628.61, 133.43, -295.88)
		event.set_camera_sequence_look_at(-904.95, 45.82, -445.11)
		event.fade_in_screen(30)
		object.wait_until_done(1)
		wait.frames(10)
		event.set_camera_sequence_position(-788.75, 21.72, -466.41)
		event.set_camera_sequence_look_at(-845.61, 14.05, -462.57)
		event.move_camera_sequence_angle_height_distance(1.24, 7.67, 56.93, 140)
		event.set_object_sequence_motion(0, "キョロキョロ", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for(3020010, 100)
		event.play_sound_effect(sound_effect, 0)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for(3020020, 40)
		camera.wait_until_done()
		event.set_camera_sequence_position(-423.31, 320.91, -1037.27)
		event.set_camera_sequence_look_at(-224.16, 315.23, -1109.17)
		event.move_camera_sequence_eased(-423.31, 320.91, -1037.27, -353.89, 315.23, -1191.88, 120, 2, 0.5)
		message.show_voiced_for(3020025, 240)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-310.58, 2305.36, 307.51)
		event.set_camera_sequence_look_at(-285.96, 2254.59, 250.8)
		wait.frames(60)
		event.set_camera_sequence_position(-788.75, 21.72, -466.41)
		event.set_camera_sequence_look_at(-845.61, 14.05, -462.57)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "手当てきょろきょろ", 6)
		event.queue_object_sequence_next_motion(1, "戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(0, 1, "口とじ～半口")
		message.show_voiced(3020030)
		event.set_object_handle_texture_animation(0, 0, "口とじ～半口")
		object.wait_until_done(1)
		event.set_camera_sequence_position(-866.53, 35.13, -489.41)
		event.set_camera_sequence_look_at(-761.07, 14.23, -373.8)
		event.set_object_sequence_rotation(0, 0.0, 2.43, 0.0)
		event.set_object_sequence_motion(0, "指さす", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3020033)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-798.38, 18.7, -471.33)
		event.set_camera_sequence_look_at(-843.17, 20.06, -461.7)
		event.set_object_sequence_rotation(0, 0.0, 2.91, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "右向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(3020036)
		event.set_object_sequence_motion(1, "右向くうなづき", 6)
		wait.frames(30)
		event.set_camera_sequence_position(-890.1, 44.29, -500.83)
		event.set_camera_sequence_look_at(-840.33, 36.43, -459.09)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(0, "歩き")
		event.rotate_object_sequence(0, 0.0, 0.87, 0.0, 10)
		event.move_object_sequence(0, -801.56, 0.0, -408.6, 60)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き")
		event.rotate_object_sequence(1, 0.0, 0.87, 0.0, 20)
		event.move_object_sequence(1, -798.52, 0.0, -429.51, 60)
		wait.frames(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(18)
	event.cancel_drama_scene_skip()
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, -484.3, 0.0, -241.8)
	event.set_character_rotation(0, 0.0, 0.63, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 20.0)
	event.fade_in_screen(30)
end

--- Plays the second Balance Valley cutscene in which the two party members walk across the valley and talk over three full-screen event images, then restores the player character.
function balance_valley.play_second_intro_cutscene()
	local sound_effect: s32 = 0
	local playable_character_id: s32 = 0
	local image_block: s32 = 0
	vm.section(function()
		event.set_camera_position(-621.09, 400.73, 34.49)
		event.set_camera_look_at(-487.13, 465.9, -23.46)
		event.set_save_flag(306, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(2)
		event.play_music(0)
		sound_effect = event.load_sound_effect_file_2(3209) or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character_id = event.get_playable_character() or playable_character_id
		event.change_directory("event/e300/e306/")
		event.load_message_file(0, 5, "e306_1.txt")
		if playable_character_id == 0 then
			event.load_character_motion_pack(5, "e306_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character_id == 1 then
			event.load_character_motion_pack(5, "e306_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		image_block = event.load_event_image_4(5, "e306b.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e30604", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e30605", image_block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 0)
		event.attach_object_handle_to_sprite(3, 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e30606", image_block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 0)
		event.attach_object_handle_to_sprite(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if playable_character_id == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e306/e306_mints.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 33)
			event.load_equipment_model(5, 1, 4, "info", 33)
			event.load_equipment_model(5, 1, 3, "info", 33)
			event.load_equipment_model(5, 1, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e306/e306_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_position(0, 265.0, 0.0, -73.0)
		event.set_object_handle_rotation(0, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(0, "歩き", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, 270.0, 0.0, -35.0)
		event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		event.move_object_sequence(0, 536.0, 0.0, -76.0, 240)
		event.move_object_sequence(1, 507.0, 0.0, -48.0, 240)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-621.09, 400.73, 34.49)
		event.set_camera_sequence_look_at(-487.13, 465.9, -23.46)
		event.move_camera_sequence_eased(-621.09, 166.82, 34.49, -487.13, 143.67, -23.46, 120, 2, 1.0)
		event.fade_in_screen(30)
		camera.wait_until_done()
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.set_camera_sequence_position(2117.25, 46.58, -164.96)
		event.set_camera_sequence_look_at(2180.0, 22.74, -75.0)
		event.set_object_sequence_position(1, 2136.0, 0.0, -151.18)
		event.set_object_sequence_rotation(1, 0.0, 0.61, 0.0)
		event.move_object_sequence(1, 2180.57, 0.0, -93.18, 60)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		wait.frames(14)
		event.set_object_sequence_position(0, 2125.64, 0.0, -140.88)
		event.set_object_sequence_rotation(0, 0.0, 0.61, 0.0)
		event.move_object_sequence(0, 2164.86, 0.0, -77.4, 60)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		object.wait_until_done(0)
		wait.frames(30)
		event.set_camera_sequence_position(2176.34, 42.48, -21.97)
		event.set_camera_sequence_look_at(2165.23, -0.03, -107.71)
		event.set_object_sequence_position(0, 2161.96, 0.0, -70.15)
		event.set_object_sequence_rotation(0, 0.0, 2.65, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, -0.95, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3060270)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.delay_object_sequence_sound_track(0, 14)
		event.play_object_sequence_sound(0, sound_effect, 13)
		object.wait_until_done(0)
		wait.frames(20)
		event.set_camera_sequence_position(2244.92, 62.5, -22.07)
		event.set_camera_sequence_look_at(2112.09, 19.05, -129.53)
		event.set_object_sequence_rotation(0, 0.0, -2.19, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, -2.27, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(1, "指差し", 6)
		event.queue_object_sequence_next_motion(1, "指差しL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3060280)
		event.set_camera_sequence_position(2121.12, 117.35, -94.66)
		event.set_camera_sequence_look_at(2199.27, 126.12, -73.41)
		event.set_event_sprite_draw_pass(0, 2)
		event.set_event_sprite_draw_pass(1, 2)
		event.set_event_sprite_draw_pass(2, 2)
		event.set_object_sequence_color(2, 128, 128, 128, 128)
		event.set_object_sequence_position(0, 2161.96, 100.0, -70.15)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3060285)
		event.set_object_sequence_motion(0, "だめだ", 6)
		event.queue_object_sequence_next_motion(0, "だめだL", 4)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3060290)
		object.wait_until_done(3)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3060300)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "やった", 6)
		event.queue_object_sequence_next_motion(0, "やったL", 4)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3060305)
		object.wait_until_done(4)
		object.wait_until_done(0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_camera_sequence_position(2211.31, 15.69, -35.88)
		event.set_camera_sequence_look_at(2160.03, 14.35, -94.15)
		event.set_object_sequence_position(0, 2161.96, 0.0, -70.15)
		event.set_object_sequence_rotation(0, 0.0, 0.97, 0.0)
		event.set_object_sequence_motion(0, "うーん", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "うーんL", 4)
		event.set_object_sequence_rotation(1, 0.0, 0.89, 0.0)
		event.set_object_sequence_motion(1, "右向くL", 4, -1.0, 1)
		event.delay_object_sequence_sound_track(1, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3060310)
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "右向く会話", 2)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "うーん戻り", 2)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3060320)
		object.wait_until_done(1)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "左向くうなづき", 2)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_sound_track(0, 14)
		event.play_object_sequence_sound(0, sound_effect, 13)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3060330)
		object.wait_until_done(0)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, 1994.4, 0.0, -247.1)
	event.set_character_rotation(0, 0.0, 0.65, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Places the player character at the valley start position, resets the follow camera and message window, fades in, clears NPC party status 26 and finishes the event.
function balance_valley.restore_player_and_finish_event()
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.set_character_position(0, -600.0, 0.0, -600.0)
	event.set_character_rotation(0, 0.0, -2.23, 0.0)
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
	event.set_npc_party_status(26, 0)
	event.finish_event()
end

--- Shows the gate hint message only when a gate condition is pending.
function balance_valley.show_gate_hint_if_pending(only_when_pending: s32)
	balance_valley.show_gate_hint_message(only_when_pending, 0)
end

--- Shows the gate hint message (a different one when a gate condition is pending), unless the chapter is 8 or later.
function balance_valley.show_gate_hint_message(only_when_pending: s32, use_alternate_text: s32)
	local chapter: s32 = 0
	local message_id: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter >= 8 then
		return
	end
	event.set_message_window_mode(1, 8)
	event.set_character_motion(0, "立ち")
	message_id = 1050
	if balance_valley.has_pending_gate_condition() ~= 0 then
		message_id = 1051
	elseif only_when_pending ~= 0 then
		return
	end
	if use_alternate_text ~= 0 then
		message_id = message_id + 10
	end
	event.open_message_window_2(1, message_id)
	message.show(1, -1, 8, 0, 0)
end

--- Calls the empty placeholder and subtracts pi from a local angle that is never used.
function balance_valley.subtract_pi_from_unused_angle()
	local unused_angle: f32 = 0
	balance_valley.do_nothing()
	unused_angle = vm.f32(unused_angle - vm.f32(3.1415927))
end

--- Waits 30 frames while allowing the player to skip.
function balance_valley.wait_exit_fade()
	wait.frames_skipping(30)
end

return balance_valley
