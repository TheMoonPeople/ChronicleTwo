--!strict
--- Event script for the Balance Valley map covering entries, exits and talking to villagers.

local vm = require("@lib/vm")
local balance_valley = require("@lib/event/balance_valley")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Plays the camera shot of the player character walking into the valley from the east edge and fades in.
local function play_entry_walk_east()
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
	wait.for_frame_count(60)
	event.set_object_sequence_motion(0, "立ち")
	wait.for_frame_count(2)
	event.set_object_handle_footstep_sound(0, 0)
end

--- Plays the first Balance Valley cutscene in which the two party members walk in and talk, then restores the player character after the scene.
local function play_first_intro_cutscene()
	local sound_effect: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(302, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(3203)
		sound_effect = event.load_sound_effect_file_2(3203) or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e302/")
		event.load_message_file(0, 5, "e302.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e302_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e302_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
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
		wait.for_frame_count(10)
		event.set_camera_sequence_position(-788.75, 21.72, -466.41)
		event.set_camera_sequence_look_at(-845.61, 14.05, -462.57)
		event.move_camera_sequence_angle_height_distance(1.24, 7.67, 56.93, 140)
		event.set_object_sequence_motion(0, "キョロキョロ", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(3020010, 100)
		event.play_sound_effect(sound_effect, 0)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(3020020, 40)
		camera.wait_until_done()
		event.set_camera_sequence_position(-423.31, 320.91, -1037.27)
		event.set_camera_sequence_look_at(-224.16, 315.23, -1109.17)
		event.move_camera_sequence_eased(-423.31, 320.91, -1037.27, -353.89, 315.23, -1191.88, 120, 2, 0.5)
		message.show_voiced_for_stopping(3020025, 240)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-310.58, 2305.36, 307.51)
		event.set_camera_sequence_look_at(-285.96, 2254.59, 250.8)
		wait.for_frame_count(60)
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
		wait.for_frame_count(30)
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
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
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

--- Plays the camera shot of the player character walking into the valley from the west edge and fades in.
local function play_entry_walk_west()
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
	wait.for_frame_count(30)
	event.set_object_handle_footstep_sound(0, 0)
end

--- Places the player outside the house after leaving it and fades the screen in.
local function arrive_from_house()
	local sound_id: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local rotation_y: f32 = 0
	event.initialize_event()
	balance_valley.disable_extra_characters_and_run_georama()
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 61)
	do
		local out1, out2, out3 = event.get_function_point_position("", "func3")
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	rotation_y = event.get_function_point_rotation("", "func3") or rotation_y
	rotation_y = vm.f32(rotation_y - vm.f32(3.1415927))
	rotation_y = event.wrap_angle(rotation_y) or rotation_y
	event.set_character_position(0, x, y, z)
	event.set_character_rotation(0, 0.0, rotation_y, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- Waits 30 frames while allowing the player to skip.
local function wait_exit_fade()
	wait.skip_frame_count(30)
end

--- Asks whether to leave through the west exit, then runs out of the map and returns 1, or walks the player character back and returns 0.
local function confirm_exit_west()
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
		event.open_message_window_2(0, "『てんびん谷停車場』に移動しますか？")
		resume_point = 1
		selection = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
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
			wait.for_frame_count(30)
			event.fade_out_screen(30)
			resume_point = 3
			wait.for_frame_count(30)
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
				wait.skip_frame_count(30)
			end
			if resume_point <= 2 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if resume_point <= 4 then
			return 0
		end
		return nil
	end)
end

--- Walks the player ahead and shows a hint about checking the last house.
local function walk_ahead_and_hint_at_house()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local frame: s32 = 0
	local flag: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	target_x = vm.f32(vm.f32(vm.sin(vm.f32(-2.76)) * 30.0) + x)
	target_y = y
	target_z = vm.f32(vm.f32(vm.cos(vm.f32(-2.76)) * 30.0) + z)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
	event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
	event.set_object_sequence_motion(0, "歩き")
	frame = 0
	while frame < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		y = vm.f32(y + 30.0)
		event.set_camera_look_at(x, y, z)
		frame = frame + 1
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	flag = event.get_save_flag(304) or flag
	if flag == 0 then
		event.open_message_window_2(0, "さっきの家に誰かいるかも知れない。\n行ってみよう。")
	else
		event.open_message_window_2(0, "こんなことをしている場合じゃない！\n早くリンを助けなきゃ。")
	end
	message.show(0, -1, 5, 256, 208)
end

--- Asks whether to leave through the east exit, then runs out of the map and returns 1, or walks the player character back and returns 0.
local function confirm_exit_east()
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
		event.open_message_window_2(0, "『ステラ渓谷』に移動しますか？")
		resume_point = 1
		selection = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
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
			wait.for_frame_count(30)
			event.fade_out_screen(30)
			resume_point = 3
			wait.for_frame_count(30)
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
				wait.skip_frame_count(30)
			end
			if resume_point <= 2 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if resume_point <= 4 then
			return 0
		end
		return nil
	end)
end

--- Plays the second Balance Valley cutscene in which the two party members walk across the valley and talk over three full-screen event images, then restores the player character.
local function play_second_intro_cutscene()
	local sound_effect: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.set_camera_position(-621.09, 400.73, 34.49)
		event.set_camera_look_at(-487.13, 465.9, -23.46)
		event.set_save_flag(306, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(2)
		event.play_music(0)
		sound_effect = event.load_sound_effect_file_2(3209) or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e306/")
		event.load_message_file(0, 5, "e306.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e306_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e306_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		block = event.load_event_image_4(5, "e306b.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e30604", block)
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
		event.set_event_sprite_texture(1, "e30605", block)
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
		event.set_event_sprite_texture(2, "e30606", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 0)
		event.attach_object_handle_to_sprite(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_chr_no == 1 then
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
		wait.for_frame_count(14)
		event.set_object_sequence_position(0, 2125.64, 0.0, -140.88)
		event.set_object_sequence_rotation(0, 0.0, 0.61, 0.0)
		event.move_object_sequence(0, 2164.86, 0.0, -77.4, 60)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		object.wait_until_done(0)
		wait.for_frame_count(30)
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
		wait.for_frame_count(20)
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
		wait.for_frame_count(30)
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

--- Opens the message window with the line of the given villager type, using the standard lines before chapter 8 and a different set from chapter 8.
local function say_villager_line(window: s32, villager_type: s32)
	local chapter: s32 = 0
	local intro_seen_flag: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		if villager_type == 1 then
			intro_seen_flag = event.get_save_flag(57) or intro_seen_flag
			if intro_seen_flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					window,
					"わしはここに住む事になったが\nバース壱号の事も心配じゃ。<page>今まで通り、列車は\nわしが動かすからな。<page>ボルネオはちと荒っぽいし、\nトムはまだ若造じゃからの。<page>これからは、この家と列車を\n行き来する事になるのう。<page>大変じゃ・・・"
				)
			else
				event.open_message_window_2(window, "スティーブの調子はどうじゃな？")
			end
		end
		if villager_type == 2 then
			event.open_message_window_2(window, "部屋でおとなしくしてるなんて、\nがまんできないぞ。")
		end
		if villager_type == 3 then
			event.open_message_window_2(
				window,
				"草木や花は世話した分だけ\nキッチリ育ちます。手を抜くなんて\nできませんぜ。"
			)
		end
		if villager_type == 4 then
			event.open_message_window_2(
				window,
				"秘密基地は大丈夫かな？\n誰かに確かめて来て欲しいけど、\n秘密だから頼めないよなぁ・・・"
			)
		end
		if villager_type == 5 then
			event.open_message_window_2(
				window,
				"むらさき色って素晴らしい色だよ。\n暖かいようで冷たくて、\n明るいようで暗くてさ。"
			)
		end
		if villager_type == 6 then
			event.open_message_window_2(window, "病に苦しむ人がいるなら、\nどこへでも行くつもりだよ。")
		end
		if villager_type == 7 then
			event.open_message_window_2(window, "どこに行っても美味い物を作るのが\nプロの料理人です。")
		end
		if villager_type == 8 then
			event.open_message_window_2(window, "やっぱりお家はがんじょうな方が\n良いじゃない？")
		end
		if villager_type == 9 then
			event.open_message_window_2(
				window,
				"木の実も美味いけど、やっぱ\nあの赤いのが最高だ。\nまた、持ってきてくれよな。"
			)
		end
		if villager_type == 10 then
			event.open_message_window_2(
				window,
				"書物にとって湿気は大敵です。\n水の近くに住むなんてとんでもない。"
			)
		end
		if villager_type == 11 then
			event.open_message_window_2(
				window,
				"おしゃれでも可愛くもないけど、\n私にしか作れない服を作っていきます。"
			)
		end
		if villager_type == 12 then
			event.open_message_window_2(window, "新しい場所で心機一転だ。\n初心に戻ってパンを焼くよ。")
		end
		if villager_type == 13 then
			event.open_message_window_2(window, "何でも良いから\n派手にぶっ壊したいぜ。")
		end
		if villager_type == 14 then
			event.open_message_window_2(window, "未知のモンスターを発見したら、\nただちに報告するように。")
		end
		if villager_type == 15 then
			event.open_message_window_2(
				window,
				"まだ男だ女だと区別する奴がいるけど、\n剣の道は剣の道だ。強い奴が正しいのさ。"
			)
		end
		if villager_type == 16 then
			event.open_message_window_2(window, "こんな小さな家に、家族だけで住むのも\n悪くないかもな。")
		end
		if villager_type == 17 then
			event.open_message_window_2(window, "モートンはちゃんとやっているかな。\n心配だ・・・")
		end
		if villager_type == 18 then
			event.open_message_window_2(window, "まだ教会のない町があるのなら、\n私がそこに赴きましょう。")
		end
		if villager_type == 19 then
			event.open_message_window_2(
				window,
				"最近はあまり月の事を考えなくなったよ。\nトモダチがたくさん出来たからかな？"
			)
		end
		if villager_type == 20 then
			event.open_message_window_2(window, "土地が違えば魚も変わる。\n釣りの仕方も工夫しないとな。")
		end
		if villager_type == 21 then
			event.open_message_window_2(window, "ここの水は魚が良く育ちそうだわ。")
		end
		if villager_type == 22 then
			event.open_message_window_2(
				window,
				"パトリったら、また女の人の絵を\n描き始めたの。私以上の美人に\nするんですって。"
			)
		end
		if villager_type == 23 then
			event.open_message_window_2(
				window,
				"虫ってどうしてあんな気味の悪い形を\nしているのかしら・・・"
			)
		end
		if villager_type == 24 then
			event.open_message_window_2(
				window,
				"もっとかわいいお家にしてちょうだい。\nかわいさに限界なんてないのよ！"
			)
		end
		if villager_type == 25 then
			event.open_message_window_2(window, "まさかこの歳になって引っ越すとは\n思わなかったよ。")
		end
	else
		message.show_villager_remark_variant(window, villager_type)
	end
end

--- Plays the conversation of the town villager that was talked to, choosing the line by villager type and chapter.
local function talk_to_villager()
	local villager_id: s32 = 0
	local villager_type: s32 = 0
	event.get_player_character_slot()
	villager_id = event.get_triggered_event_data_2(13) or villager_id
	villager_type = event.get_triggered_event_data_2(14) or villager_type
	print("talk_chara_id=", villager_id, "talk_chara=", villager_type, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_id)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	say_villager_line(0, villager_type)
	cutscene.talk(villager_id, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_id)
end

--- Frames the camera on a recruitable villager at the camp point and runs a greeting with a menu to swap partners, hear a remark or start their own event.
local function open_camp_companion_menu()
	local character_slot: s32 = 0
	local npc_id: s32 = 0
	local now_party_chara_id: s32 = 0
	local window_offset: s32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation_x: f32 = 0
	local npc_rotation_z: f32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_z: f32 = 0
	local player_look_angle: f32 = 0
	local npc_look_angle: f32 = 0
	local now_map_no: s32 = 0
	local camp_point_x: f32 = 0
	local camp_point_y: f32 = 0
	local camp_point_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local menu_choice: any = 0
	local option_text_number: s32 = 0
	local greeting_text_number: s32 = 0
	local option_count: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.set_character_motion(0, "立ち")
	event.set_character_motion(character_slot, "立ち")
	event.initialize_event()
	event.apply_message_window_preset(1, 0)
	window_offset = 0
	if npc_id == 10 or npc_id == 18 then
		window_offset = 8
	end
	if npc_id == 1 or npc_id == 6 or npc_id == 17 then
		window_offset = 16
	end
	if npc_id == 2 or npc_id == 15 or npc_id == 16 or npc_id == 19 or npc_id == 20 or npc_id == 21 or npc_id == 22 then
		window_offset = 24
	end
	if npc_id == 3 or npc_id == 4 or npc_id == 5 or npc_id == 7 or npc_id == 8 or npc_id == 23 or npc_id == 24 then
		window_offset = 32
	end
	if npc_id == 9 or npc_id == 11 or npc_id == 13 then
		window_offset = 40
	end
	event.set_message_window_option(1, 4, 30, 60, 144, -1)
	event.set_message_window_option(1, 9, 20 + window_offset, 16)
	do
		local out1, _, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_z = out3 or player_z
	end
	do
		local out1, _, out3 = event.get_character_rotation(0)
		player_rotation_x = out1 or player_rotation_x
		player_rotation_z = out3 or player_rotation_z
	end
	do
		local out1, out2, out3 = event.get_character_position(character_slot)
		npc_x = out1 or npc_x
		npc_y = out2 or npc_y
		npc_z = out3 or npc_z
	end
	do
		local out1, _, out3 = event.get_character_rotation(character_slot)
		npc_rotation_x = out1 or npc_rotation_x
		npc_rotation_z = out3 or npc_rotation_z
	end
	player_look_angle = event.get_look_angle(npc_x - player_x, npc_z - player_z) or player_look_angle
	event.set_character_rotation(0, player_rotation_x, player_look_angle, player_rotation_z)
	npc_look_angle = event.get_look_angle(player_x - npc_x, player_z - npc_z) or npc_look_angle
	event.set_character_rotation(character_slot, npc_rotation_x, npc_look_angle, npc_rotation_z)
	now_map_no = event.get_current_map() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.get_function_point_position("", "gcamp")
			camp_point_x = out1 or camp_point_x
			camp_point_y = out2 or camp_point_y
			camp_point_z = out3 or camp_point_z
		end
		event.set_camera_position(camp_point_x, camp_point_y, camp_point_z)
		event.set_camera_look_at(npc_x, npc_y + 30.0, npc_z)
		npc_look_angle = event.get_look_angle(camp_point_x - npc_x, camp_point_z - npc_z) or npc_look_angle
		event.set_character_rotation(character_slot, npc_rotation_x, npc_look_angle, npc_rotation_z)
	else
		pos_x = vm.f32(vm.sin(npc_look_angle) * 30.0)
		pos_x = vm.f32(pos_x + npc_x)
		pos_y = vm.f32(npc_y + 33.0)
		pos_z = vm.f32(vm.cos(npc_look_angle) * 30.0)
		pos_z = vm.f32(pos_z + npc_z)
		event.set_camera_position(pos_x, pos_y, pos_z)
		pos_x_2 = npc_x
		pos_y_2 = vm.f32(npc_y + 30.0)
		pos_z_2 = npc_z
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	end
	event.set_character_active(0, 0)
	vm.wait(1)
	event.start_crossfade(10)
	menu_choice = 0
	while true do
		message.set_window_mode(3, 1)
		say_villager_line(3, npc_id)
		option_text_number = -1
		event.set_message_draw_speed(3, 0, 0)
		message.set_window_mode(1, 8)
		event.set_message_draw_speed(1, 0, 0)
		greeting_text_number = event.get_npc_message_number_3(npc_id, 0) or greeting_text_number
		event.set_message_item_system_message(1, 1, greeting_text_number)
		message.open(1, 1, 1, 0, 0)
		message.set_window_mode(2, 2)
		do
			local out1, out2 = event.get_npc_message_number_4(npc_id, 4)
			option_text_number = out1 or option_text_number
			option_count = out2 or option_count
		end
		if option_count == 3 then
			option_text_number = 30
		end
		if option_count == 4 then
			event.set_message_item_system_message(2, 1, option_text_number)
			option_text_number = 31
		end
		if option_count == 5 then
			event.set_message_item_system_message(2, 1, option_text_number)
			event.set_message_item_system_message(2, 2, vm.i32(option_text_number + 1))
			option_text_number = 32
		end
		menu_choice = message.ask_choice(2, option_text_number, 7, 0, 0, option_count, vm.i32(option_count - 1))
		if menu_choice == 0 then
			if npc_id == now_party_chara_id then
				message.end_conversation()
				event.start_crossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.fade_out_screen(25)
				wait.for_frame_count(30)
				event.set_npc_party_status(npc_id, 1)
				event.open_party_select_menu()
				vm.wait(4)
				message.end_conversation()
				event.fade_in_screen(30)
				return
			end
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			event.open_message_window_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			message.show(3, -1, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if menu_choice == 1 then
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			option_text_number = event.get_npc_message_number_3(npc_id, 3) or option_text_number
			message.show(3, option_text_number, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if 3 < option_count then
			if option_count == 5 then
				if menu_choice == 2 then
					if npc_id == 1 then
						event.set_save_data_value(2)
						event.open_message_window_2(3, "よし、これで\n修理完了じゃ！")
						message.show(3, -1, 3, 256, 208)
						message.end_conversation()
						event.start_crossfade(10)
					end
					if not (npc_id == 4) then
						break
					end
					menu.open_shop(6)
					break
				end
				if menu_choice == 3 then
					if npc_id == 1 then
						menu.open_shop(23)
						return
					end
					if npc_id == 4 then
						if minigame.report_scoop_progress() ~= 0 then
							menu.open_shop(33)
							return
						end
					end
				end
				if menu_choice == 4 then
					break
				end
				if menu_choice == -1 then
					break
				end
			else
				if menu_choice == 2 then
					if npc_id == 15 then
						menu.open_shop(0)
					end
					if npc_id == 12 then
						menu.open_shop(1)
					end
					if npc_id == 6 then
						menu.open_shop(2)
					end
					if npc_id == 7 then
						menu.open_shop(3)
					end
					if npc_id == 2 then
						menu.open_shop(7)
					end
					if npc_id == 3 then
						menu.open_shop(8)
					end
					if npc_id == 5 then
						menu.open_shop(9)
					end
					if npc_id == 8 then
						menu.open_shop(10)
					end
					if npc_id == 10 then
						menu.open_shop(11)
					end
					if npc_id == 11 then
						menu.open_shop(12)
					end
					if npc_id == 13 then
						menu.open_shop(13)
					end
					if npc_id == 16 then
						menu.open_shop(14)
					end
					if npc_id == 18 then
						menu.open_shop(15)
					end
					if npc_id == 19 then
						menu.open_shop(16)
					end
					if npc_id == 20 then
						menu.open_shop(17)
					end
					if npc_id == 21 then
						menu.open_shop(18)
					end
					if npc_id == 22 then
						menu.open_shop(19)
					end
					if npc_id == 23 then
						menu.open_shop(20)
					end
					if npc_id == 24 then
						menu.open_shop(21)
					end
					if npc_id == 25 then
						menu.open_shop(22)
					end
					if npc_id == 17 then
						menu.open_shop(32)
					end
					if npc_id == 9 then
						message.show_story_hint()
						message.show(3, -1, 3, 256, 208)
						message.end_conversation()
						event.start_crossfade(10)
					end
					if npc_id == 14 then
						event.fade_out_screen(25)
						wait.for_frame_count(30)
						event.open_event_menu(25)
						vm.wait(35)
						message.end_conversation()
						event.fade_in_screen(30)
					end
					return
				end
				if menu_choice == 3 then
					break
				end
				if menu_choice == -1 then
					break
				end
			end
		else
			if menu_choice == 2 then
				break
			end
			if menu_choice == -1 then
				break
			end
		end
	end
	message.end_conversation()
	event.start_crossfade(10)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = balance_valley.disable_extra_characters_and_run_georama

--- Plays the entry sequence matching the map the player came from.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_number: s32 = 0
	local old_map_type: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local previous_submap_number: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		balance_valley.disable_extra_characters_and_run_georama()
		memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
		if memory_card_load_state == 1 then
			event.set_character_position(0, 1989.0, 0.0, -198.0)
			event.set_character_rotation(0, 0.0, -1.21, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 3.14, 20.0)
		else
			previous_map_number = event.get_previous_map() or previous_map_number
			old_map_type = event.get_map_type(previous_map_number) or old_map_type
			print("--- OLD MAP NO = ", previous_map_number, "\n")
			if old_map_type ~= -1 then
				if old_map_type == 7 or old_map_type == 8 then
					resume_step = 1
					play_entry_walk_east()
				elseif previous_map_number == 26 then
					event.set_camera_position(-741.9, 50.0, -592.0)
					event.set_camera_look_at(-741.9, 30.0, -712.0)
					event.set_character_position(0, -741.9, 0.0, -712.0)
					event.set_character_rotation(0, 0.0, 0.0, 0.0)
					event.fade_in_screen(30)
				else
					flag = event.get_save_flag(300) or flag
					flag_2 = event.get_save_flag(302) or flag_2
					if flag == 1 and flag_2 == 0 then
						resume_step = 2
						play_first_intro_cutscene()
					else
						resume_step = 3
						play_entry_walk_west()
					end
				end
			else
				previous_submap_number = event.get_previous_submap() or previous_submap_number
				if previous_submap_number == 100 then
					arrive_from_house()
				end
				if previous_submap_number == -1 then
					arrive_from_house()
				end
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				print("--- OLD SUBMAP NO = ", previous_submap_number, "\n")
			end
		end
		resume_step = 4
		balance_valley.show_gate_hint_if_pending(1)
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				resume_step = 2
				play_first_intro_cutscene()
				return vm.continue_with(function()
					resume_step = 4
					balance_valley.show_gate_hint_if_pending(1)
					return
				end)
			end
			if resume_step <= 2 then
				wait_exit_fade()
			end
			if resume_step <= 3 then
				balance_valley.subtract_pi_from_unused_angle()
				balance_valley.subtract_pi_from_unused_angle()
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				print("--- OLD SUBMAP NO = ", previous_submap_number, "\n")
				message.clear_window_option(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the menu button is ignored.
function script.key_open() end

--- Enters Lin's house either by map jump or by interior transition depending on story flags.
function script.enter_lins_house()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local party_npc_id: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		flag = event.get_save_flag(300) or flag
		flag_2 = event.get_save_flag(304) or flag_2
		flag_3 = event.get_save_flag(306) or flag_3
		flag_4 = event.get_save_flag(324) or flag_4
		flag_5 = event.get_save_flag(328) or flag_5
		flag_6 = event.get_save_flag(330) or flag_6
		if flag == 1 then
			party_npc_id = event.get_party_npc() or party_npc_id
			if
				flag_2 == 0
				or flag_3 == 0 and party_npc_id == 6
				or flag_4 == 1 and flag_5 == 0
				or flag_4 == 1 and flag_6 == 0
			then
				if not (flag_4 == 1 and flag_5 == 0) then
					event.skip_next_music_load()
				end
				event.jump_to_map_3(-1, "g02i02", 100)
				resume_step = 1
				vm.wait(1)
				print("--- MAP_JUMP(g02i02) ---\n")
				return
			end
		end
		event.go_to_interior_map(-1, "g02i02", 100)
		resume_step = 2
		vm.wait(2)
		print("--- GOTO_INTERIOR(g02i02) ---\n")
		return
	end, function(received: { any })
		if resume_step <= 1 then
			print("--- MAP_JUMP(g02i02) ---\n")
			return 0
		end
		if resume_step <= 2 then
			print("--- GOTO_INTERIOR(g02i02) ---\n")
			return 0
		end
		return nil
	end)
end
script[200] = script.enter_lins_house

script.arrive_from_house = arrive_from_house
script[210] = script.arrive_from_house

--- Plays the red time gate effect and jumps to the f02 map.
function script.use_time_gate()
	cutscene.play_time_gate_travel(vm.f32(-743.2), 0.0, vm.f32(-708.9), vm.f32(-0.64))
	event.jump_to_map_2(-1, "f02")
	vm.wait(2)
end
script[300] = script.use_time_gate

--- Shows the gate hint when pending after a georama change.
function script.edit_analyze_changed()
	balance_valley.show_gate_hint_if_pending(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_type_7

--- Asks to leave to the west and jumps to the next map when confirmed.
function script.exit_west()
	if confirm_exit_west() ~= 0 then
		event.jump_to_map_2(-1, "s04")
	end
end
script[500] = script.exit_west

--- Shows the blocked path hint or lets the player choose a dungeon floor and enter it.
function script.exit_east()
	local flag: s32 = 0
	local selected_floor: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	flag = event.get_save_flag(306) or flag
	if flag == 0 then
		walk_ahead_and_hint_at_house()
	elseif confirm_exit_east() ~= 0 then
		event.set_dungeon_stage_id(2)
		event.open_event_menu(3, 2)
		vm.wait(3)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			selected_floor = out3 or selected_floor
		end
		if selected_floor == 0 then
			play_entry_walk_east()
		else
			flag_2 = event.get_save_flag(307) or flag_2
			flag_3 = event.get_save_flag(344) or flag_3
			if selected_floor == 2 and flag_2 == 0 or selected_floor == 21 and flag_3 == 0 or selected_floor == 22 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(2, selected_floor, 1010)
		end
	end
end
script[501] = script.exit_east

--- Restores the valley state and the player after the house scene and shows the pending gate hint.
function script.return_from_house_scene()
	balance_valley.disable_extra_characters_and_run_georama()
	balance_valley.restore_player_and_finish_event()
	balance_valley.show_gate_hint_if_pending(1)
end
script[502] = script.return_from_house_scene

--- Plays the second introduction cutscene.
function script.play_second_intro_scene()
	balance_valley.disable_extra_characters_and_run_georama()
	play_second_intro_cutscene()
end
script[503] = script.play_second_intro_scene

--- Opens the dialogue of a villager and the companion menu.
function script.talk_to_villager()
	talk_to_villager()
	open_camp_companion_menu()
end
script[1000] = script.talk_to_villager

--- Event 13020, which map data, a script or the engine runs by number.
script.play_first_intro_cutscene = play_first_intro_cutscene
script[13020] = script.play_first_intro_cutscene

return script
