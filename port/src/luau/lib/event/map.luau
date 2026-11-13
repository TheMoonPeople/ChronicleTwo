--!strict
--- Tests map geometry around a position.

local vm = require("@lib/vm")
local balance_valley = vm.module("@lib/event/balance_valley")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local heim_rada_stop = vm.module("@lib/event/heim_rada_stop")
local message = vm.module("@lib/event/message")
local sindain_station = vm.module("@lib/event/sindain_station")
local train = vm.module("@lib/event/train")
local wait = vm.module("@lib/event/wait")

local map = {}

--- Calls the station logger that prints the current station, train and side identifiers.
function map.call_station_logger()
	train.skip_place_player_at_saved_platform()
end

--- Tests two points 16 units around a position against walls and ground; returns -1 when a point is walled off, 0 when the arc is blocked or lacks ground and 1 when it is clear.
function map.check_arc_clearance(center_x: f32, center_y: f32, center_z: f32, start_angle: f32, end_angle: f32)
	local first_x: f32 = 0
	local first_y: f32 = 0
	local first_z: f32 = 0
	local second_x: f32 = 0
	local second_y: f32 = 0
	local second_z: f32 = 0
	local angle_difference: f32 = 0
	local collision: s32 = 0
	start_angle = event.wrap_angle(start_angle) or start_angle
	start_angle = event.wrap_angle(start_angle) or start_angle
	end_angle = event.wrap_angle(end_angle) or end_angle
	end_angle = event.wrap_angle(end_angle) or end_angle
	first_x = vm.f32(vm.sin(start_angle) * 16.0)
	first_y = 6.0
	first_z = vm.f32(vm.cos(start_angle) * 16.0)
	if end_angle ~= start_angle then
		angle_difference = vm.f32(end_angle - start_angle)
		angle_difference = event.wrap_angle(angle_difference) or angle_difference
		if angle_difference > 0.0 then
			end_angle = vm.f32(start_angle + 0.5)
		else
			start_angle = vm.f32(start_angle + vm.f32(0.2))
			end_angle = vm.f32(start_angle - 0.5)
		end
	end
	end_angle = event.wrap_angle(end_angle) or end_angle
	second_x = vm.f32(vm.sin(end_angle) * 16.0)
	second_y = 6.0
	second_z = vm.f32(vm.cos(end_angle) * 16.0)
	do
		local out1, out2, out3 = event.add_vectors(first_x, first_y, first_z, center_x, center_y, center_z)
		first_x = out1 or first_x
		first_y = out2 or first_y
		first_z = out3 or first_z
	end
	do
		local out1, out2, out3 = event.add_vectors(second_x, second_y, second_z, center_x, center_y, center_z)
		second_x = out1 or second_x
		second_y = out2 or second_y
		second_z = out3 or second_z
	end
	collision = event.get_segment_collision_9(12, first_x, first_y, first_z, center_x, center_y + 6.0, center_z, 1) or collision
	if collision >= 0 then
		return -1
	end
	collision = event.get_segment_collision_9(12, second_x, second_y, second_z, center_x, center_y + 6.0, center_z, 1) or collision
	if collision >= 0 then
		return -1
	end
	collision = event.get_segment_collision_9(12, first_x, first_y, first_z, second_x, second_y, second_z, 1) or collision
	if collision >= 0 then
		return 0
	end
	collision = event.get_segment_collision_9(12, first_x, first_y, first_z, first_x, first_y - 12.0, first_z, 1) or collision
	if collision < 0 then
		return 0
	end
	collision = event.get_segment_collision_9(12, second_x, second_y, second_z, second_x, second_y - 12.0, second_z, 1) or collision
	if collision < 0 then
		return 0
	end
	return 1
end

--- Asks whether to leave the area, running out of the scene or walking back, and returns 1 when leaving; characters 2 and 3 only see a message and are returned to the entrance.
function map.confirm_leave_area()
	local playable_character: s32 = 0
	local answer: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
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
			event.fade_out_screen(10)
			resume_step = 3
			wait.for_frame_count(10)
			event.set_character_position(0, 1804.36, -189.51, 1279.76)
			event.set_character_rotation(0, 0.0, -2.47, 0.0)
			event.set_camera_position(1889.79, -158.65, 1386.92)
			event.set_camera_look_at(1804.36, -159.51, 1279.76)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		resume_step = 4
		answer = message.ask_yes_no(2, -1)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
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
			resume_step = 5
			wait.for_frame_count(30)
			event.fade_out_screen(30)
			resume_step = 6
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
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					character_x = out1 or character_x
					character_y = out2 or character_y
					character_z = out3 or character_z
				end
				character_y = vm.f32(character_y + 30.0)
				event.set_camera_look_at(character_x, character_y, character_z)
				i = i + 1
				resume_step = 7
				vm.wait(7)
			end
			event.set_object_handle_footstep_sound(0, -1)
			event.reset_follow_camera(0)
			event.finish_event()
		end
		return 0
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			if resume_step <= 2 then
				wait.skip_frame_count(10)
			end
			return 0
		end
		if resume_step <= 6 then
			if resume_step == 4 then
				answer = received[1] :: number
			end
			if resume_step <= 4 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 5 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if resume_step <= 7 then
			return 0
		end
		return nil
	end)
end

--- Asks whether to leave the area, running out of the scene or walking back, and returns 1 when leaving; characters 2 and 3 only see a message and are returned to the entrance, waiting with wait_frames.
function map.confirm_leave_area_variant()
	local playable_character: s32 = 0
	local answer: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
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
			event.fade_out_screen(10)
			resume_step = 3
			wait.frames(10)
			event.set_character_position(0, 1804.36, -189.51, 1279.76)
			event.set_character_rotation(0, 0.0, -2.47, 0.0)
			event.set_camera_position(1889.79, -158.65, 1386.92)
			event.set_camera_look_at(1804.36, -159.51, 1279.76)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		resume_step = 4
		answer = message.ask_yes_no(2, -1)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
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
			resume_step = 5
			wait.frames(30)
			event.fade_out_screen(30)
			resume_step = 6
			wait.frames(30)
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
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					character_x = out1 or character_x
					character_y = out2 or character_y
					character_z = out3 or character_z
				end
				character_y = vm.f32(character_y + 30.0)
				event.set_camera_look_at(character_x, character_y, character_z)
				i = i + 1
				resume_step = 7
				vm.wait(7)
			end
			event.set_object_handle_footstep_sound(0, -1)
			event.reset_follow_camera(0)
			event.finish_event()
		end
		return 0
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			if resume_step <= 2 then
				wait.frames_skipping(10)
			end
			return 0
		end
		if resume_step <= 6 then
			if resume_step == 4 then
				answer = received[1] :: number
			end
			if resume_step <= 4 then
				wait.frames_skipping(30)
			end
			if resume_step <= 5 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if resume_step <= 7 then
			return 0
		end
		return nil
	end)
end

--- Disables the function points e348 and event when save flags 348 and 352 are set.
function map.disable_completed_function_points()
	local flag_348: s32 = 0
	local flag_352: s32 = 0
	flag_348 = event.get_save_flag(348) or flag_348
	if flag_348 == 1 then
		event.set_function_point_enabled("", "e348", 0)
	end
	flag_352 = event.get_save_flag(352) or flag_352
	if flag_352 == 1 then
		event.set_function_point_enabled("", "event", 0)
	end
end

--- Enters door mode, waits one frame and 10 more frames, then jumps to the requested map.
function map.enter_door()
	event.enter_door_mode()
	vm.wait(1)
	wait.for_frame_count(10)
	event.jump_to_requested_map()
end

--- Enters door mode, waits one frame, waits 10 frames with the frame wait helper and jumps to the requested map.
function map.enter_door_waiting_frames()
	event.enter_door_mode()
	vm.wait(1)
	wait.frames(10)
	event.jump_to_requested_map()
end

--- Turns the player toward a door, plays the door sound, fades the screen out and waits 30 frames.
function map.fade_out_facing_door(door_rotation: f32, sound_variant: s32)
	local sound_id: s32 = 0
	character.turn_player_to_rotation(door_rotation)
	event.set_character_motion(0, "立ち")
	sound_id = event.get_sound_id(2) or sound_id
	if sound_variant ~= 0 then
		event.play_sound_effect(sound_id, 92)
	else
		event.play_sound_effect(sound_id, 94)
	end
	event.fade_out_screen(30)
	wait.for_frame_count(30)
end

--- Turns the player toward a door, plays the door sound, fades the screen out and waits 30 frames with the frame wait helper.
function map.fade_out_facing_door_waiting_frames(door_rotation: f32, sound_variant: s32)
	local sound_id: s32 = 0
	character.turn_player_to_rotation(door_rotation)
	event.set_character_motion(0, "立ち")
	sound_id = event.get_sound_id(2) or sound_id
	if sound_variant ~= 0 then
		event.play_sound_effect(sound_id, 92)
	else
		event.play_sound_effect(sound_id, 94)
	end
	event.fade_out_screen(30)
	wait.frames(30)
end

--- Prints the map initialization marker and runs the first empty initialization hook.
function map.init_with_log()
	print("map_init-------------------------\n")
	cutscene.noop()
end

--- Jumps to the map of the station stored in the save counter and waits a station-dependent number of frames.
function map.jump_to_station()
	local station_id: s32 = 0
	station_id = event.get_save_counter(1) or station_id
	if station_id == 2 then
		event.jump_to_map_2(-1, "s02")
		vm.wait(1)
		return
	end
	if station_id == 3 then
		event.jump_to_map_2(-1, "s04")
		vm.wait(2)
		return
	end
	if station_id == 4 then
		event.jump_to_map_2(-1, "s09")
		vm.wait(3)
		return
	end
	if station_id == 5 then
		event.jump_to_map_2(-1, "s10")
		vm.wait(4)
		return
	end
	if station_id == 6 then
		event.jump_to_map_2(-1, "s11")
		vm.wait(5)
		return
	end
	if station_id == 7 then
		event.jump_to_map_2(-1, "s12")
		vm.wait(6)
		return
	end
	if station_id == 8 then
		event.jump_to_map_2(-1, "s31")
		vm.wait(7)
		return
	end
	if station_id == 9 then
		event.jump_to_map_2(-1, "s34")
		vm.wait(8)
		return
	end
	event.jump_to_map_2(-1, "i02h01")
	vm.wait(9)
end

--- Prints the map initialization marker.
function map.log_init()
	print("map_init-------------------------\n")
end

--- Prints the train debug values and runs the fixed sequence of train interval waits twice.
function map.print_train_debug_info(unused_argument: s32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local train_id: s32 = 0
	print("train_id=", train_id, "----------------\n")
	print("fpos[0]=", vm.float(position_x), "---------------\n")
	print("fpos[1]=", vm.float(position_y), "---------------\n")
	print("fpos[2]=", vm.float(position_z), "---------------\n")
	print("train_id=", train_id, "---------------\n")
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(18)
	wait.skip_frame_count(12)
	wait.skip_frame_count(30)
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(18)
	wait.skip_frame_count(12)
	wait.skip_frame_count(30)
end

--- Runs three empty map initialization hooks in order.
function map.run_init_sequence_a()
	cutscene.noop()
	sindain_station.skip_crossfade_step()
	heim_rada_stop.noop()
end

--- Runs three empty map initialization hooks in order.
function map.run_init_sequence_b()
	wait.background_load_skipping()
	cutscene.noop()
	balance_valley.do_nothing()
end

--- Runs six empty map initialization hooks in order.
function map.run_init_sequence_c()
	cutscene.noop()
	cutscene.noop()
	cutscene.noop()
	wait.background_load_skipping()
	balance_valley.do_nothing()
	cutscene.noop()
end

--- Runs two empty map initialization hooks in order.
function map.run_init_sequence_d()
	cutscene.noop()
	wait.background_load_skipping()
end

--- Runs the fixed sequence of train interval waits twice (10, 20, 18, 12 and 30), which have no effect.
function map.run_train_interval_waits()
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(18)
	wait.skip_frame_count(12)
	wait.skip_frame_count(30)
	wait.skip_frame_count(10)
	wait.skip_frame_count(20)
	wait.skip_frame_count(18)
	wait.skip_frame_count(12)
	wait.skip_frame_count(30)
end

return map
