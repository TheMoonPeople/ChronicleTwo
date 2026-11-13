--!strict
--- Train stop with arrival, departure and boarding handling.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local menu = require("@lib/event/menu")
local party = require("@lib/event/party")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

--- Logs the start of the map.
local function log_map_init()
	print("map_init-------------------------\n")
end

--- Plays the cutscene of the player running along the opened gangway into the train, then fades out, and finishes the sequence on skip.
local function board_train_via_gangway()
	local map_number: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local event_rotation: f32 = 0
	local train_id: s32 = 0
	local world_rotation: f32 = 0
	local part_variant: s32 = 0
	local sound_id: s32 = 0
	local gangway_x: f32 = 0
	local gangway_y: f32 = 0
	local gangway_z: f32 = 0
	local player_y: f32 = 0
	local player_x: f32 = 0
	local footstep_sound: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		map_number = event.get_current_map() or map_number
		event.initialize_event()
		event.get_sound_id(1)
		train_id = event.get_triggered_event_data_2(3) or train_id
		event.get_triggered_event_data_2(4)
		event.call_command(1035, 8, world_x, world_y, world_z, event_rotation) -- retail: the handler rejects 5 arguments
		print("train_id=", train_id, "----------------\n")
		print("fpos[0]=", vm.float(world_x), "---------------\n")
		print("fpos[1]=", vm.float(world_y), "---------------\n")
		print("fpos[2]=", vm.float(world_z), "---------------\n")
		if world_z < 4500.0 then
			world_rotation = vm.f32(1.5707964)
		else
			world_rotation = vm.f32(-1.5707964)
		end
		if map_number == 76 then
			if world_z < 3600.0 then
				world_rotation = vm.f32(1.5707964)
			else
				world_rotation = vm.f32(-1.5707964)
			end
		end
		if map_number == 72 then
			if world_z < 4500.0 then
				world_rotation = vm.f32(1.5707964)
			else
				world_rotation = vm.f32(-1.5707964)
			end
		end
		if map_number == 34 or map_number == 16 or map_number == 54 then
			world_rotation = vm.f32(3.1415927)
		end
		if map_number == 87 then
			world_rotation = vm.f32(2.3561945)
		end
		if map_number == 83 or map_number == 103 then
			world_rotation = vm.f32(1.5707964)
		end
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		part_variant = 0
		if map_number == 34 or map_number == 54 or map_number == 87 or map_number == 103 or map_number == 76 then
			part_variant = 1
		end
		if train_id == 4 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m6")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m1")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m")
			event.set_save_counter(0, 1)
		end
		if train_id == 5 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m7")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m1")
			event.set_save_counter(0, 1)
		end
		if train_id == 2 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m3")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
			event.set_save_counter(0, 2)
		end
		if train_id == 3 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m11")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
			event.set_save_counter(0, 2)
		end
		if train_id == 6 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m3")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m5")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m8")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m5")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m4")
			event.set_save_counter(0, 3)
		end
		if train_id == 7 then
			event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m2")
			if part_variant == 0 then
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m4")
			else
				event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m9")
			end
			event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m3")
			event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m5")
			event.set_save_counter(0, 3)
		end
		sound_id = event.get_sound_id(2) or sound_id
		event.play_sound_effect(sound_id, 92)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(5)
			gangway_x = out1 or gangway_x
			gangway_y = out2 or gangway_y
			gangway_z = out3 or gangway_z
		end
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.clear_camera_sequence()
		player_y = 0.0
		player_x = 46.0
		if map_number == 34 then
			player_y = vm.f32(35.8)
		end
		if map_number == 16 then
			player_y = vm.f32(-7.86)
		end
		if map_number == 54 then
			player_y = 36.0
		end
		if map_number == 83 then
			player_y = vm.f32(29.22)
		end
		if map_number == 87 then
			player_y = -6.0
		end
		if map_number == 103 then
			player_y = vm.f32(-13.87)
		end
		if map_number == 72 then
			player_x = 30.0
			player_y = vm.f32(0.09)
		end
		if map_number == 155 then
			player_x = 30.0
			player_y = vm.f32(0.09)
		end
		event.set_object_sequence_position(0, player_x, player_y, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.5707964, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_camera_sequence_position(148.0, 23.45, -118.4)
		event.set_camera_sequence_look_at(5.11, 26.65, 8.6)
		if map_number == 34 or map_number == 54 then
			event.set_camera_sequence_position(106.46, 47.9, -133.32)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		if map_number == 83 then
			event.set_camera_sequence_position(148.0, 35.52, -118.4)
			event.set_camera_sequence_look_at(5.11, 77.95, 8.6)
		end
		progress_step = 1
		wait.for_frame_count(10)
		if vm.imod(train_id, 2) ~= 1 then
			event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
			if map_number == 83 or map_number == 54 or map_number == 34 then
				progress_step = 2
				wait.for_frame_count(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
				progress_step = 3
				wait.for_frame_count(30)
				if map_number == 103 then
					event.move_object_sequence(5, gangway_x + 45.0, gangway_y - 19.0, gangway_z, 30)
					progress_step = 4
					wait.for_frame_count(20)
				else
					event.move_object_sequence(5, gangway_x + 20.0, gangway_y - 8.0, gangway_z, 20)
					progress_step = 5
					wait.for_frame_count(10)
				end
			end
		else
			event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
			event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
			if map_number == 83 or map_number == 54 or map_number == 34 then
				progress_step = 6
				wait.for_frame_count(20)
			else
				event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
				event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
				progress_step = 7
				wait.for_frame_count(30)
				if map_number == 103 then
					event.move_object_sequence(5, gangway_x - 45.0, gangway_y - 19.0, gangway_z, 30)
					progress_step = 8
					wait.for_frame_count(20)
				else
					event.move_object_sequence(5, gangway_x - 20.0, gangway_y - 8.0, gangway_z, 20)
					progress_step = 9
					wait.for_frame_count(10)
				end
			end
		end
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -50.0, 30.0, 0.0, 45)
		footstep_sound = 0
		if
			map_number == 16
			or map_number == 83
			or map_number == 87
			or map_number == 103
			or map_number == 72
			or map_number == 76
			or map_number == 155
		then
			print("てつのあしおと\n")
			footstep_sound = 6
		end
		if map_number == 34 or map_number == 54 then
			print("いしのあしおと\n")
			footstep_sound = 2
		end
		event.set_object_handle_footstep_sound(0, footstep_sound)
		progress_step = 10
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		progress_step = 11
		wait.for_frame_count(30)
		event.set_object_handle_footstep_sound(0, 0)
		event.set_object_handle_motion(0, "立ち", 4)
		if vm.imod(train_id, 2) ~= 1 then
			event.set_character_position(0, 50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, -1.57, 0.0)
		else
			event.set_character_position(0, -50.0, -14.0, 0.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
		end
		return
	end, function(received: { any })
		if progress_step <= 11 then
			if progress_step <= 1 then
				wait.skip_frame_count(20)
			end
			if progress_step <= 2 then
				wait.skip_frame_count(30)
			end
			if progress_step <= 3 then
				wait.skip_frame_count(20)
			end
			if progress_step <= 4 then
				wait.skip_frame_count(10)
			end
			if progress_step <= 5 then
				wait.skip_frame_count(20)
			end
			if progress_step <= 6 then
				wait.skip_frame_count(30)
			end
			if progress_step <= 7 then
				wait.skip_frame_count(20)
			end
			if progress_step <= 8 then
				wait.skip_frame_count(10)
			end
			if progress_step <= 9 then
				footstep_sound = 0
				print("てつのあしおと\n")
				footstep_sound = 6
				print("いしのあしおと\n")
				footstep_sound = 2
				wait.skip_frame_count(30)
			end
			if progress_step <= 10 then
				wait.skip_frame_count(30)
			end
			return 0
		end
		return nil
	end)
end

--- Waits through the frame counts of the gangway boarding cutscene without delaying; this stands in for train.board_train_via_gangway when events are skipped.
local function board_train_via_gangway_skipping()
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local train_id: s32 = 0
	print("train_id=", train_id, "----------------\n")
	print("fpos[0]=", vm.float(world_x), "---------------\n")
	print("fpos[1]=", vm.float(world_y), "---------------\n")
	print("fpos[2]=", vm.float(world_z), "---------------\n")
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(30)
	wait.skip_frame_count(20)
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(30)
	wait.skip_frame_count(20)
	wait.skip_frame_count(10)
	print("てつのあしおと\n")
	print("いしのあしおと\n")
	wait.skip_frame_count(30)
	wait.skip_frame_count(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.log_map_init = log_map_init
script[99] = script.log_map_init

--- Places the player by how the map was entered.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_number: s32 = 0
	local previous_map_type: s32 = 0
	local boarding_stop: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		log_map_init()
		print("start_event--------------------------------------------\n")
		memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
		if memory_card_load_state == 1 then
			character.load_station_npc()
			character.place_standing_and_reset_cloth(vm.f32(94.2), vm.f32(140.4), vm.f32(2842.4), 0.0)
			event.reset_follow_camera(1, 0.0, 20.0)
			event.fade_in_screen(30)
		else
			previous_map_number = event.get_previous_map() or previous_map_number
			previous_map_type = event.get_map_type(previous_map_number) or previous_map_type
			if previous_map_type ~= -1 then
				if previous_map_number == 4 or previous_map_number == 109 then
					character.load_station_npc()
					character.place_standing_and_reset_cloth(0.0, vm.f32(189.2), 2630.0, 0.0)
					event.reset_follow_camera(1, 3.14, 20.0)
					event.fade_in_screen(30)
				else
					boarding_stop = event.get_save_counter(1) or boarding_stop
					if
						(previous_map_number == 18 or previous_map_number == 23 or previous_map_number == 120 or previous_map_number == 108)
						and boarding_stop == 9
					then
						character.load_station_npc()
						resume_step = 1
						train.alight_primary()
						train.place_player_at_saved_platform()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						resume_step = 2
						train.arrive_at_station_primary()
						character.load_station_npc()
					end
				end
			end
			event.set_character_motion(0, "立ち")
		end
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				train.skip_place_player_at_saved_platform()
				wait.skip_long_pause_primary()
			end
			cutscene.noop()
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = train.arrive_at_station_primary

--- Confirms and jumps to g05.
function script.leave_for_g05()
	if menu.confirm_leave_primary() ~= 0 then
		event.jump_to_map_2(-1, "g05")
	end
end
script[200] = script.leave_for_g05

--- Asks whether to board and enters the train.
function script.board_train()
	local choice: s32 = 0
	local route_index: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		choice = menu.ask_enter_or_depart()
		if choice ~= 1 then
			return
		end
		event.set_save_counter(1, 9)
		route_index = event.get_triggered_event_data_2(3) or route_index
		if route_index <= 1 then
			resume_step = 2
			train.board_short_train_primary()
			event.stop_music(0)
			resume_step = 3
			vm.wait(3)
			event.jump_to_map_2(-1, "s37")
			resume_step = 4
			vm.wait(4)
		else
			resume_step = 5
			board_train_via_gangway()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step <= 4 then
				board_train_via_gangway_skipping()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.board_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_type_7

--- Says the waiting-outside line when the triggering character is the one waiting.
function script.talk_to_waiting_character()
	local character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	if character_slot == 8 then
		party.talk_to_waiting_npc()
	end
end
script[1000] = script.talk_to_waiting_character

return script
