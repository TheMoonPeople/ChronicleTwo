--!strict
--- Moon Flower Palace field with the dungeon entrance and the exit to the train stop.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Plays the scene of event 604.
local function play_event_604_scene()
	local sound_bank: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(604, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(51)
		event.play_music(0)
		event.load_map_sounds(7803)
		sound_bank = event.load_sound_effect_file_2(7803) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e600/e604/")
		event.load_message_file(0, 5, "e604.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e604_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e604_monica.gltf", "info", 0)
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
			event.load_character_motion_pack(5, "event/e600/e604/e604_mints.gltf", "info", 33)
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
			event.load_character_motion_pack(5, "event/e600/e604/e604_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.attach_object_handle_to_map_part_3(2, "p01_s3302-0", "s330208-m0")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_3(3, "p01_s3302-0", "s330208-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_handle_position(0, 14.06, 0.0, -283.76)
		event.set_object_handle_rotation(0, 0.0, -3.09, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -22.57, 0.0, -283.73)
		event.set_object_handle_rotation(1, 0.0, -3.09, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1409.3, 33.17, 699.45)
		event.set_camera_sequence_look_at(-1317.3, 207.26, 35.03)
		event.set_character_active(0)
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 14.06, 0.0, -588.5, 540, 1)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -22.57, 0.0, -588.26, 540, 1)
		event.fade_in_screen(30)
		event.move_camera_sequence(1340.45, 33.17, 781.09, 1266.94, 207.26, 116.17, 450)
		wait.for_frame_count(60)
		message.show_voiced_for_stopping(6040010, 150)
		message.show_voiced_for_stopping(6040020, 240)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(1, -13.05, 82.65, -581.69)
		event.set_object_sequence_rotation(1, 0.0, -3.09, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 10.82, 82.79, -581.79)
		event.set_object_sequence_rotation(0, 0.0, -3.09, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.05, 107.16, -512.55)
		event.set_camera_sequence_look_at(-0.34, 115.06, -632.94)
		event.move_object_sequence(1, -11.66, 140.66, -709.98, 260, 1)
		event.move_object_sequence(0, 11.57, 140.66, -707.0, 260, 1)
		message.show_voiced_for_stopping(6040030, 240)
		wait.for_frame_count(20)
		object.wait_until_done(1)
		event.set_camera_sequence_position(1.24, 142.22, -872.19)
		event.set_camera_sequence_look_at(1.67, 177.22, -765.97)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(1, -8.87, 140.66, -739.81)
		event.set_object_sequence_rotation(1, 0.0, 3.07, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 12.17, 140.66, -739.07)
		event.set_object_sequence_rotation(0, 0.0, -3.09, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(1, -9.09, 140.66, -794.9, 120, 1)
		event.move_object_sequence(0, 11.95, 140.66, -793.78, 120, 1)
		event.delay_object_sequence_motion_track(0, 120)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(1, 120)
		event.set_object_sequence_motion(1, "立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(6040040, -1)
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(6040050)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-0.36, 446.02, 122.03)
		event.set_camera_sequence_look_at(3.18, 151.42, -826.58)
		event.set_object_sequence_position(1, -22.1, 140.66, -908.82)
		event.set_object_sequence_rotation(1, 0.0, 2.95, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 13.59, 140.66, -906.11)
		event.set_object_sequence_rotation(0, 0.0, -2.97, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 0)
		event.rotate_object_sequence(2, 0.0, 0.61, 0.0, 60)
		event.rotate_object_sequence(3, 0.0, -0.61, 0.0, 60)
		wait.for_frame_count(120)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向く会話", 4)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(6040060)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(6040070)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_rotation(2, 0.0, 0.61, 0.0)
	event.set_object_handle_rotation(3, 0.0, -0.61, 0.0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(0.0, vm.f32(140.7), -770.0, vm.f32(3.14))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Asks whether to enter the dungeon, walks the player forward if so and returns whether the player agreed.
local function confirm_dungeon_entry()
	local choice: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local frame: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		choice = message.ask_yes_no(7, 97)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if choice == 0 then
			event.fade_out_screen(30)
			at = 2
			wait.for_frame_count(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				player_x = out1 or player_x
				player_y = out2 or player_y
				player_z = out3 or player_z
			end
			target_x = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + player_x)
			target_y = player_y
			target_z = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + player_z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			frame = 0
			while frame < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					player_x = out1 or player_x
					player_y = out2 or player_y
					player_z = out3 or player_z
				end
				player_y = vm.f32(player_y + 30.0)
				event.set_camera_look_at(player_x, player_y, player_z)
				frame = frame + 1
				at = 3
				vm.wait(3)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				choice = received[1] :: number
			end
			if at <= 1 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Plays the scene of event 372.
local function play_event_372_scene()
	local flag: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/e300/e372/e372_waku2.gltf", "info", 32)
		event.attach_object_handle_to_character(0, 32)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_message_file(0, 5, "event/e300/e372/e372.txt")
		flag = event.get_save_flag(43) or flag
		if flag ~= 0 then
			event.stop_music(0)
			wait.for_frame_count(4)
			event.load_music(59)
			event.play_music(0)
			event.set_save_flag(43, 0)
		end
		event.enable_drama_skip()
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.start_crossfade(0, 0, 90)
		event.set_camera_sequence_position(-178.53, 128.12, 2185.49)
		event.set_camera_sequence_look_at(-546.76, 268.24, 1697.27)
		event.set_object_sequence_position(0, -546.76, 268.24, 1697.27)
		event.keep_character_in_front_of_camera_sequence(32, 608.78, 99999999)
		event.move_camera_sequence_eased(1177.44, 128.12, 1162.78, 809.21, 268.24, 674.57, 600, 2, 0.4)
		message.show_voiced(3720190)
		message.show_voiced(3720200)
		message.show_voiced(3720210)
		message.show_voiced(3720220)
		event.clear_camera_sequence()
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.delete_character(32)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Plays the cutscene or places the player depending on saved flags.
function script.default_event()
	local flag_600: s32 = 0
	local flag_604: s32 = 0
	flag_600 = event.get_save_flag(600) or flag_600
	flag_604 = event.get_save_flag(604) or flag_604
	if flag_600 == 1 and flag_604 == 0 then
		play_event_604_scene()
	else
		if flag_604 == 1 then
			event.attach_object_handle_to_map_part_3(0, "p01_s3302-0", "s330208-m0")
			event.attach_object_handle_to_map_part_3(1, "p01_s3302-0", "s330208-m1")
			event.set_object_handle_rotation(0, 0.0, 0.61, 0.0)
			event.set_object_handle_rotation(1, 0.0, -0.61, 0.0)
		end
		character.place_standing_and_reset_cloth(0.0, 0.0, 2300.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Confirms and enters the dungeon.
function script.enter_dungeon()
	if confirm_dungeon_entry() ~= 0 then
		event.skip_next_music_load()
		event.go_to_dungeon(5, -1, 500)
	end
end
script[200] = script.enter_dungeon

--- Confirms and returns to s31.
function script.leave_for_s31()
	if dungeon.confirm_exit() ~= 0 then
		event.jump_to_map_2(-1, "s31")
	end
end
script[210] = script.leave_for_s31

--- Plays the e372 cutscene and jumps to f02.
function script.cutscene_e372()
	play_event_372_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f02", 510)
	vm.wait(2)
end
script[510] = script.cutscene_e372

--- Event 16040, which map data, a script or the engine runs by number.
script.play_event_604_scene = play_event_604_scene
script[16040] = script.play_event_604_scene

return script
