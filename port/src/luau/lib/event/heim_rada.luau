--!strict
--- Helpers specific to the Heim Rada map.

local vm = require("@lib/vm")
local georama = vm.module("@lib/event/georama")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local heim_rada = {}

--- Asks leave prompt 79 and returns 1 after running the character out along a path with a fade when confirmed, otherwise walks a few steps and returns 0.
function heim_rada.confirm_leave_area_79()
	local exit_choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		progress = 1
		exit_choice = message.ask_yes_no(5, 79)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if exit_choice == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-1344.5, 29.04, -1202.39)
			event.set_camera_sequence_look_at(-1454.01, 30.0, -1310.84)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.delay_object_sequence_motion_track(0, 60)
			event.set_object_sequence_motion(0, "立ち")
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -1491.32, 0.0, -1347.87)
			event.add_object_sequence_path_point(0, -1566.57, 0.0, -1398.85)
			event.add_object_sequence_path_point(0, -1646.11, 0.0, -1452.77)
			event.start_object_sequence_path(0)
			progress = 2
			wait.frames(40)
			event.fade_out_screen(20)
			progress = 3
			wait.frames(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(0.9)) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(0.9)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30)
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
				progress = 4
				vm.wait(4)
			end
		end
		event.set_object_handle_footstep_sound(0, 0)
		return 0
	end, function(received: { any })
		if progress <= 3 then
			if progress == 1 then
				exit_choice = received[1] :: number
			end
			if progress <= 1 then
				wait.frames_skipping(40)
			end
			if progress <= 2 then
				wait.frames_skipping(20)
			end
			return 1
		end
		if progress <= 4 then
			return 0
		end
		return nil
	end)
end

--- Asks leave prompt 87 and returns 1 after running the character out along a path with a fade when confirmed, otherwise walks a few steps and returns 0.
function heim_rada.confirm_leave_area_87()
	local exit_choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		progress = 1
		exit_choice = message.ask_yes_no(5, 87)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if exit_choice == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(1741.43, 158.18, -323.48)
			event.set_camera_sequence_look_at(1987.85, 77.48, -185.67)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 70)
			event.add_object_sequence_path_point(0, 2073.86, 0.0, -146.5)
			event.add_object_sequence_path_point(0, 2172.98, -1.14, -140.36)
			event.add_object_sequence_path_point(0, 2239.86, -9.63, -132.92)
			event.add_object_sequence_path_point(0, 2337.56, -22.03, -101.25)
			event.start_object_sequence_path(0)
			progress = 2
			wait.frames(50)
			event.fade_out_screen(20)
			progress = 3
			wait.frames(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(-1.57)) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(-1.57)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30)
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
				progress = 4
				vm.wait(4)
			end
		end
		event.set_object_handle_footstep_sound(0, 0)
		return 0
	end, function(received: { any })
		if progress <= 3 then
			if progress == 1 then
				exit_choice = received[1] :: number
			end
			if progress <= 1 then
				wait.frames_skipping(50)
			end
			if progress <= 2 then
				wait.frames_skipping(20)
			end
			return 1
		end
		if progress <= 4 then
			return 0
		end
		return nil
	end)
end

--- Returns 1 when any of the four hint events tied to save flags 548, 552, 556 and 560 is still pending.
function heim_rada.has_pending_hint()
	if georama.can_start_event_548() ~= 0 then
		return 1
	end
	if georama.can_start_event_552() ~= 0 then
		return 1
	end
	if georama.can_start_event_556() ~= 0 then
		return 1
	end
	if georama.can_start_event_560() ~= 0 then
		return 1
	end
	return 0
end

--- Fades in with the character running in along a path from the first entrance.
function heim_rada.run_in_entrance_a()
	event.initialize_event()
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-1356.86, 83.9, -1168.92)
	event.set_camera_sequence_look_at(-1484.75, 27.8, -1316.45)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -1627.77, 0.0, -1432.14)
	event.set_object_sequence_rotation(0, 0.0, 1.12, 0.0)
	event.set_object_sequence_motion(0, "走り", 4)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 60)
	event.add_object_sequence_path_point(0, -1627.77, 0.0, -1432.14)
	event.add_object_sequence_path_point(0, -1529.23, 0.0, -1370.02)
	event.add_object_sequence_path_point(0, -1477.71, 0.0, -1329.77)
	event.start_object_sequence_path(0)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait.frames(60)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

--- Fades in with the character running in from the second entrance and stopping.
function heim_rada.run_in_entrance_b()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 2123.53, 0.0, -172.9)
	event.set_object_sequence_rotation(0, 0.0, -1.54, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(2113.85, 58.0, -172.0)
	event.set_camera_sequence_look_at(1961.18, 30.0, -219.86)
	event.set_object_sequence_position(0, 2084.3, 0.0, -181.26)
	event.set_object_sequence_rotation(0, 0.0, -1.87, 0.0)
	event.move_object_sequence(0, 1961.18, 0.0, -219.86, 40)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.delay_object_sequence_motion_track(0, 40)
	event.set_object_sequence_motion(0, "立ち")
	event.fade_in_screen(15)
	wait.frames(50)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

--- Shows the chapter hint message while the chapter is below 8, using text 1051 when a hint event is pending and 1050 otherwise, adding 10 when use_alternate_text is set; skipped when require_pending is set and no hint is pending.
function heim_rada.show_hint_message(require_pending: any, use_alternate_text: s32)
	local chapter: s32 = 0
	local message_id: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter >= 8 then
		return
	end
	event.set_message_window_mode(1, 8)
	event.set_character_motion(0, "立ち")
	message_id = 1050
	if heim_rada.has_pending_hint() ~= 0 then
		message_id = 1051
	elseif require_pending ~= 0 then
		return
	end
	if use_alternate_text ~= 0 then
		message_id = message_id + 10
	end
	event.open_message_window_2(1, message_id)
	message.show(1, -1, 8, 0, 0)
end

--- Reads the georama state unless save flag 520 is set and shows the hint message with it selecting the alternate text.
function heim_rada.show_hint_with_georama_state(require_pending: s32)
	local georama_state: s32 = 0
	local georama_flag: s32 = 0
	georama_state = 0
	georama_flag = event.get_save_flag(520) or georama_flag
	if georama_flag == 0 then
		event.run_georama_command(3, georama_state) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	end
	heim_rada.show_hint_message(require_pending, georama_state)
end

return heim_rada
