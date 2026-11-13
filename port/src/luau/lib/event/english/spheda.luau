--!strict
--- Holds the English spheda event helpers.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")

local spheda = {}

--- Announces the floor practice result messages and the medals awarded for it.
function spheda.announce_medal_reward(is_new_record: s32, practice_result: s32, bonus_index: s32)
	local record_sound_id: s32 = 0
	local medal_sound_id: s32 = 0
	local reward_sound_id: s32 = 0
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	if is_new_record == 1 or is_new_record == 2 then
		message.show_and_wait(0, 2750, 8, 0, 0)
	end
	if is_new_record == 1 and practice_result ~= 2 then
		record_sound_id = event.get_system_sound_id() or record_sound_id
		event.play_sound_effect(record_sound_id, 18)
		message.show_and_wait(0, 2760, 8, 0, 0)
	end
	if practice_result == 2 or practice_result == 3 then
		message.show_and_wait(0, vm.i32(2700 + bonus_index), 8, 0, 0)
	end
	if is_new_record == 1 and practice_result == 2 then
		medal_sound_id = event.get_system_sound_id() or medal_sound_id
		event.play_sound_effect(medal_sound_id, 18)
		event.open_message_window_2(0, "You got 2 Medals!")
		message.show_and_wait(0, -1, 8, 0, 0)
	elseif practice_result == 2 then
		reward_sound_id = event.get_system_sound_id() or reward_sound_id
		event.play_sound_effect(reward_sound_id, 18)
		message.show_and_wait(0, 2760, 8, 0, 0)
	end
end

--- Asks whether to move the character to the Spheda ball and places the character and camera beside it, clear of nearby treasure boxes.
function spheda.move_character_to_ball()
	local answer: any = 0
	local playable_character: s32 = 0
	local search_result: s32 = 0
	local attempt: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local box_pos_x: f32 = 0
	local box_pos_y: f32 = 0
	local box_pos_z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local facing_angle: f32 = 0
	event.set_message_window_mode(0, 5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_message_selection_top_line(0, 0)
		answer = message.ask_choice(0, 2002, 8, 256, 208, 2, 1)
	else
		event.set_message_selection_top_line(0, 0)
		event.open_message_window_2(0, "Move Monica to the Sphere?")
		answer = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
	end
	vm.wait(3)
	if answer == 0 then
		do
			local out1, out2, out3 = event.get_sphida_ball_position()
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		event.get_sphida_pin_position()
		do
			local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
			search_result = out1 or search_result
			target_x = out2 or target_x
			target_y = out3 or target_y
			target_z = out4 or target_z
		end
		if search_result == 0 then
			do
				local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
		end
		attempt = 0
		do
			local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(target_x, target_y, target_z)
			box_pos_x = out1 or box_pos_x
			box_pos_y = out2 or box_pos_y
			box_pos_z = out3 or box_pos_z
			search_result = out4 or search_result
		end
		while search_result >= 0 do
			do
				local out1, out2, out3 = event.copy_vector(target_x, target_y, target_z)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			do
				local out1, out2, out3 = event.subtract_vectors(offset_x, offset_y, offset_z, box_pos_x, box_pos_y, box_pos_z)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			offset_x = vm.f32(offset_x + 1.0)
			offset_z = vm.f32(offset_z + 1.0)
			do
				local out1, out2, out3 = event.normalize_vector(offset_x, offset_y, offset_z)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			do
				local out1, out2, out3 = event.scale_vector(offset_x, offset_y, offset_z, 30.1)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			do
				local out1, out2, out3 = event.copy_vector(box_pos_x, box_pos_y, box_pos_z)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			do
				local out1, out2, out3 = event.add_vectors(target_x, target_y, target_z, offset_x, offset_y, offset_z)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			attempt = attempt + 1
			if attempt > 6 then
				break
			else
				do
					local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(target_x, target_y, target_z)
					box_pos_x = out1 or box_pos_x
					box_pos_y = out2 or box_pos_y
					box_pos_z = out3 or box_pos_z
					search_result = out4 or search_result
				end
			end
		end
		facing_angle = event.get_direction_angle(target_x, target_y, target_z, ball_x, ball_y, ball_z) or facing_angle
		event.set_character_position(0, target_x, target_y, target_z)
		event.set_character_rotation(0, 0.0, facing_angle, 0.0)
		event.set_camera_look_at(target_x, target_y + 30.0, target_z)
		facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
		facing_angle = event.wrap_angle(facing_angle) or facing_angle
		target_x = vm.f32(vm.f32(vm.sin(facing_angle) * 100.0) + target_x)
		target_y = vm.f32(target_y + 30.0)
		target_z = vm.f32(vm.f32(vm.cos(facing_angle) * 100.0) + target_z)
		event.set_camera_position(target_x, target_y, target_z)
		event.set_follow_camera_offset(0.0, 30.0, 0.0)
		event.set_follow_camera_height(5.0)
		event.set_follow_camera_distance(160.0)
		event.set_camera_speed(6.0)
		event.set_camera_rotation_cancel_mask(1)
		event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
		event.reset_follow_camera(0)
	end
end

return spheda
