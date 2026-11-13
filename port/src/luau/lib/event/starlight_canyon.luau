--!strict
--- Event scenes shared by the floors of Starlight Canyon.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local starlight_canyon = {}

--- Plays the scene in which a creature lifts the player and a piece of meat and carries them off while the screen fades out.
function starlight_canyon.play_carried_exit_scene()
	local sound_bank: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local frame: s32 = 0
	event.initialize_event()
	event.fade_out_screen(10)
	wait.frames(10)
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_032.sound.json") or sound_bank
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	world_x, world_y, world_z, world_rotation =
		object.get_trigger_placement(world_x, world_y, world_z, world_rotation)
	event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.load_character(5, "event/d03/p00_26a.gltf", "info", 12)
	event.set_character_active(12)
	event.attach_object_handle_to_character(1, 12)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_scene_status_flags(1, 12, 8, 1)
	event.load_item_model(5, 341, "info", 13)
	event.set_character_active(13)
	event.attach_object_handle_to_character(2, 13)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_position(0, 0.0, 0.0, 90.0)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "持ち上げ停止", 4, -1.0, 1)
	event.set_object_sequence_position(1, 0.0, 172.0, -192.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "肉つかみ", 4)
	event.set_object_sequence_position(2, 0.0, 31.0, 90.0)
	event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
	event.play_sound_effect(sound_bank, 0)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-43.92, 11.08, 211.68)
	event.set_camera_sequence_look_at(-1.94, 50.04, 41.38)
	event.fade_in_screen(30)
	velocity_y = -6.0
	velocity_z = 16.0
	frame = 0
	while frame < 76 do
		event.add_object_sequence_position_offset(1, 0.0, velocity_y, 3.8157895)
		velocity_y = vm.f32(velocity_y * vm.f32(0.958))
		frame = frame + 1
		vm.wait(2)
	end
	event.set_camera_sequence_position(-45.71, 26.34, 49.83)
	event.set_camera_sequence_look_at(1.77, 54.14, 135.5)
	event.fade_out_screen(30)
	event.add_object_sequence_position_offset(1, 0.0, 0.0, -8.0)
	velocity_y = vm.f32(0.14)
	velocity_z = vm.f32(1.6)
	frame = 0
	while frame < 30 do
		event.add_object_sequence_position_offset(0, 0.0, velocity_y + vm.f32(0.6), velocity_z)
		event.add_object_sequence_position_offset(1, 0.0, velocity_y, velocity_z)
		event.add_object_sequence_position_offset(2, 0.0, velocity_y + vm.f32(0.6), velocity_z)
		velocity_y = vm.f32(velocity_y * vm.f32(1.06))
		velocity_z = vm.f32(velocity_z * vm.f32(1.06))
		frame = frame + 1
		vm.wait(3)
	end
	event.delete_character(12)
	event.delete_character(13)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.finish_event()
end

--- Plays the dungeon entry scene in which a creature drops the player, who lands and walks forward as the screen fades out.
function starlight_canyon.play_thrown_entry_scene()
	local sound_bank: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local playable_character: s32 = 0
	local creature_velocity_x: f32 = 0
	local creature_velocity_y: f32 = 0
	local creature_velocity_z: f32 = 0
	local player_velocity_x: f32 = 0
	local player_velocity_y: f32 = 0
	local player_velocity_z: f32 = 0
	local frame: s32 = 0
	local landing_state: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local ground_x: f32 = 0
	local ground_y: f32 = 0
	local ground_z: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(307, 1)
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		sound_bank = event.load_sound_effect_file_2(3800) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			world_x = out1 or world_x
			world_y = out2 or world_y
			world_z = out3 or world_z
			world_rotation = out4 or world_rotation
		end
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_message_file(0, 5, "event/e300/e307/e307_1.txt")
		playable_character = event.get_playable_character() or playable_character
		playable_character = if 0 == 0 then 1 else 0
		if playable_character ~= 0 then
			event.switch_dungeon_main_character(0)
			event.set_playable_character(0)
		end
		event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/d03/p00_26a.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_scene_status_flags(1, 9, 8, 1)
		event.load_item_model(5, 341, "info", 10)
		event.set_character_active(10)
		event.attach_character_to_frame(9, "niku", 10)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_sequence_position(0, 0.0, 140.0, -200.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "持ち上げ停止", 4, -1.0, 1)
		event.set_object_sequence_position(1, 0.0, 140.0, -200.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "肉つかみ飛び", 4)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.enable_drama_skip()
		event.play_sound_effect(sound_bank, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-53.68, 35.8, 200.46)
		event.set_camera_sequence_look_at(12.57, 57.95, 3.94)
		event.move_camera_sequence_eased(-53.68, 35.8, 200.46, 12.57, 10.0, 3.94, 30, 2, 1.0)
		event.fade_in_screen(30)
		creature_velocity_x = 0.0
		creature_velocity_y = -10.0
		creature_velocity_z = 7.0
		player_velocity_x = 0.0
		player_velocity_y = -3.0
		player_velocity_z = 8.0
		landing_state = 0
		frame = 0
		while frame < 60 do
			event.add_object_sequence_position_offset(1, creature_velocity_x, creature_velocity_y, creature_velocity_z)
			if frame < 30 then
				event.add_object_sequence_position_offset(0, creature_velocity_x, creature_velocity_y, creature_velocity_z)
			else
				if frame == 30 then
					event.set_object_sequence_motion(0, "d03着地", 2)
					event.queue_object_sequence_next_motion(0, "立ち", 4)
				end
				do
					local out1, out2, out3 = event.get_character_position(0)
					player_x = out1 or player_x
					player_y = out2 or player_y
					player_z = out3 or player_z
				end
				if landing_state == 0 then
					if vm.f32(player_y + player_velocity_y) <= 0.0 then
						event.set_character_position(0, player_x, 0.0, player_z)
						landing_state = 1
					else
						event.add_object_sequence_position_offset(0, player_velocity_x, player_velocity_y, player_velocity_z)
						player_velocity_y = vm.f32(player_velocity_y * vm.f32(1.1))
						player_velocity_z = vm.f32(player_velocity_z * vm.f32(0.8))
					end
				elseif landing_state <= 1 then
					do
						local out1, out2, out3, out4 =
							event.get_segment_collision_12(0, player_x, 8.0, player_z, player_x, -8.0, player_z, 0)
						ground_x = out1 or ground_x
						ground_y = out2 or ground_y
						ground_z = out3 or ground_z
						landing_state = out4 or landing_state
					end
					if landing_state >= 0 then
						event.set_character_position(0, ground_x, ground_y, ground_z)
					else
						event.set_character_position(0, player_x, -0.7, player_z)
					end
					landing_state = 10
				end
			end
			creature_velocity_y = vm.f32(creature_velocity_y * vm.f32(0.9))
			frame = frame + 1
			step = 2
			vm.wait(2)
		end
		step = 3
		object.wait_until_done(0)
		step = 4
		wait.frames(20)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_camera_sequence_follow_object(0, 0.0, 22.0, 0.0, 0.37, 0.0, 33.0)
		event.move_camera_sequence_angle_height_distance_eased(3.14, 0.0, 33.0, 180, 0, 1.0)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 0.0, -1.0, 100.0, 60)
		step = 5
		message.show_voiced_then_hold(3070010, -1, 10)
		step = 6
		message.show_voiced_then_hold(3070020, -1, 10)
		step = 7
		camera.wait_until_done()
		event.release_camera_sequence_follow_object()
		event.move_camera_sequence_eased(0.06, 21.0, 67.0, 0.0, 52.06, 100.0, 60, 0, 1.0)
		step = 8
		wait.frames(90)
		event.fade_out_screen(30)
		event.fade_out_music(30)
		step = 9
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 1 then
			playable_character = if 0 == 0 then 1 else 0
			creature_velocity_x = 0.0
			creature_velocity_y = -10.0
			creature_velocity_z = 7.0
			player_velocity_x = 0.0
			player_velocity_y = -3.0
			player_velocity_z = 8.0
			landing_state = 0
			frame = 0
			local _ = landing_state == 0
			landing_state = 1
			local _ = vm.f32(player_y + player_velocity_y) <= 0.0
			player_velocity_y = vm.f32(player_velocity_y * vm.f32(1.1))
			player_velocity_z = vm.f32(player_velocity_z * vm.f32(0.8))
			local _ = landing_state <= 1
			local _ = landing_state >= 0
			landing_state = 10
			creature_velocity_y = vm.f32(creature_velocity_y * vm.f32(0.9))
			local _ = frame < 60
			local _ = frame < 30
			local _ = frame == 30
			frame = frame + 1
		end
		if step <= 2 then
			cutscene.skip_command(0)
		end
		if step <= 3 then
			wait.frames_skipping(20)
		end
		if step <= 4 then
			message.show_voiced_then_hold_skipping(3070010, -1, 10)
		end
		if step <= 5 then
			message.show_voiced_then_hold_skipping(3070020, -1, 10)
		end
		if step <= 6 then
			wait.background_load_skipping()
		end
		if step <= 7 then
			wait.frames_skipping(90)
		end
		if step <= 8 then
			wait.frames_skipping(30)
		end
		return true
	end)
	step = 10
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	event.stop_music(0)
	event.stop_sound_effect(sound_bank, 0)
	event.delete_character(9)
	event.delete_character(10)
	event.set_object_handle_position(0, 0.0, -1.0, 100.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(0.0, 29.0, 100.0)
	event.set_camera_position(0.0, 41.0, -20.0)
	event.reset_follow_camera(0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Prompts the player to use the star key on the door's star lock and plays the unlock scene when the key is used.
function starlight_canyon.use_star_key_door()
	local story_flag: s32 = 0
	local is_door_opened: s32 = 0
	local trigger_state: s32 = 0
	local confirm_result: s32 = 0
	local used_item: s32 = 0
	local map_part: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local sound_bank: s32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_dungeon_pause_flags(1, 1)
	story_flag = event.get_save_flag(616) or story_flag
	if story_flag == 0 then
		event.set_message_window_mode(0, 4)
		event.set_message_bubble_tail(0, 0)
		message.show_and_wait(0, 9, 8, 0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	is_door_opened = event.get_local_event_flag(4) or is_door_opened
	if is_door_opened == 0 then
		trigger_state = event.get_triggered_event_data_2(6) or trigger_state
		if trigger_state == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			confirm_result = message.ask_confirmation(0, 8, 5, 256, 208, confirm_result)
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 1)
			if confirm_result == 1 then
				trigger_state = 2
			end
		end
		if trigger_state == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait.frames(6)
			event.open_item_select_menu(0, 362)
			vm.wait(4)
			used_item = vmhost.used_item() or used_item
			if used_item == 362 then
				event.set_local_event_flag(4, 1)
				map_part = event.get_triggered_event_data_2(9) or map_part
				event.attach_object_handle_to_map_part_3(0, map_part, "star-m0")
				event.set_object_handle_visible(0, 0)
				event.attach_object_handle_to_map_part_3(0, map_part, "d03wa13-a")
				event.set_object_handle_visible(0, 0)
				event.set_function_point_enabled(map_part, "star", 0)
				world_x, world_y, world_z, world_rotation =
					object.get_trigger_placement(world_x, world_y, world_z, world_rotation)
				event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
				event.assign_memory_stack(5)
				event.clear_memory_stack(5)
				event.attach_object_handle_to_character(0, 0)
				event.clear_object_sequence(0)
				event.set_object_sequence_object(0, 0)
				event.turn_object_sequence_toward(0, 0.0, 0.0, 0.0, 0)
				event.load_character(5, "event/dng/key_star.gltf", "star", 12)
				event.set_character_active(12)
				event.attach_object_handle_to_character(1, 12)
				event.set_object_sequence_object(1, 1)
				event.set_object_handle_position(1, 0.0, 0.0, 160.0)
				event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
				event.set_object_handle_scale(1, 20.0, 20.0, 20.0)
				sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_014.sound.json") or sound_bank
				event.play_sound_effect(sound_bank, 0)
				event.set_object_sequence_scale(1, 20.0, 0.0, 20.0, 60)
				event.set_camera_sequence_position(-31.46, 57.29, 350.67)
				event.set_camera_sequence_look_at(4.66, 31.72, 192.41)
				event.set_character_visible(12, 0, 1, 0.02)
				wait.frames(60)
				event.delete_character(12)
			elseif used_item <= 0 then
				event.finish_event()
			else
				character.shake_head()
			end
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		wait.frames(6)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

return starlight_canyon
