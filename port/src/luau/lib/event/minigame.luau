--!strict
--- Sets up and runs the Sphida minigame.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")
local party = vm.module("@lib/event/party")
local visual_effect = vm.module("@lib/event/visual_effect")
local wait = vm.module("@lib/event/wait")

local minigame = {}

--- Lets the player turn and tilt the Sphida shot until confirming or cancelling, returning the result with the chosen angle and elevation.
function minigame.aim_sphida_shot(aim_angle: f32, elevation_degrees: f32, texture_block: s32)
	local result: s32 = 0
	local idle_timer: s32 = 0
	local pose_timer: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local camera_angle: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local new_elevation_degrees: f32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		idle_timer = 60
		pose_timer = 76
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.set_follow_camera_following(1)
		event.set_camera_control_enabled(1)
		event.set_camera_rotation_cancel_mask(43)
		event.set_camera_speed(6.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_target(player_x, player_y + 20.0, player_z)
		event.set_follow_camera_height(0.0)
		event.set_follow_camera_distance(100.0)
		event.set_camera_control_range(10.0, 30.0, 80.0, 120.0)
		while true do
			do
				local out1, out2 = event.get_analog_sticks_2()
				stick_x = out1 or stick_x
				stick_y = out2 or stick_y
			end
			do
				local out1, out2, out3 = event.get_character_position(0)
				current_x = out1 or current_x
				current_y = out2 or current_y
				current_z = out3 or current_z
			end
			do
				local out1, out2, out3 = event.get_character_rotation(0)
				rotation_x = out1 or rotation_x
				rotation_y = out2 or rotation_y
				rotation_z = out3 or rotation_z
			end
			if stick_x ~= 0.0 then
				if
					minigame.check_swing_space(
						current_x,
						current_y,
						current_z,
						vm.f32(rotation_y + vm.f32(1.5707964)),
						vm.f32(vm.f32(rotation_y - vm.f32(stick_x / 32.0)) + vm.f32(1.5707964))
					) == 1
				then
					rotation_y = vm.f32(rotation_y - vm.f32(stick_x / 32.0))
				else
					stick_x = 0.0
				end
			end
			event.set_character_rotation(0, rotation_x, rotation_y, rotation_z)
			if idle_timer <= 0 then
				event.set_character_motion(0, "待機")
				pose_timer = 76
				idle_timer = 400
			else
				if stick_x ~= 0.0 then
					event.set_character_motion(0, "かまえバタバタ")
					idle_timer = 200
					pose_timer = 0
				elseif pose_timer <= 0 then
					event.set_character_motion(0, "かまえ")
				else
					pose_timer = pose_timer - 1
				end
				idle_timer = idle_timer - 1
			end
			new_elevation_degrees = elevation_degrees
			new_elevation_degrees = vm.f32(new_elevation_degrees + stick_y)
			if new_elevation_degrees <= 5.0 then
				new_elevation_degrees = 5.0
			end
			if new_elevation_degrees >= 30.0 then
				new_elevation_degrees = 30.0
			end
			aim_angle = rotation_y
			elevation_degrees = new_elevation_degrees
			event.set_sphida_carry_angle(vm.f32(elevation_degrees * vm.f32(3.1415927)) / 180.0)
			camera_angle = vm.f32(aim_angle - vm.f32(3.1415927))
			camera_angle = event.wrap_angle(camera_angle) or camera_angle
			event.set_camera_control_rotation(camera_angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			minigame.draw_sphida_shot_preview(aim_angle, elevation_degrees, texture_block)
			if wait.get_button_state(0) ~= 0 then
				event.set_character_motion(0, "かまえ")
				result = 0
				break
			elseif wait.get_button_state(1) ~= 0 then
				result = 1
				break
			else
				resume_point = 1
				vm.wait(1)
			end
		end
		visual_effect.hide_all_sprites()
		resume_point = 2
		vm.wait(2)
		return result, aim_angle, elevation_degrees
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				visual_effect.hide_all_sprites_skipping()
			end
			return result, aim_angle, elevation_degrees
		end
		return nil, aim_angle, elevation_degrees
	end)
end

--- Returns 1 so the calling scoop shop script continues.
function minigame.can_continue()
	return 1
end

--- Selects the equipped club for Sphida and returns 0, or explains why the player cannot play and returns 1.
function minigame.check_sphida_club()
	local playable_character: s32 = 0
	local equipped_item_id: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 then
			event.set_message_window_mode(0, 4)
			resume_point = 1
			message.show_and_wait(0, 2000, 8, 0, 0)
			return 1
		end
		equipped_item_id = event.get_equipped_item(0, 0) or equipped_item_id
		if equipped_item_id ~= 9 and equipped_item_id ~= 10 and equipped_item_id ~= 11 and equipped_item_id ~= 12 and equipped_item_id ~= 13 and equipped_item_id ~= 14 then
			event.set_message_window_mode(0, 4)
			resume_point = 2
			message.show_and_wait(0, 2001, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(equipped_item_id)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if resume_point <= 1 then
			return 1
		end
		if resume_point <= 2 then
			return 1
		end
		return nil
	end)
end

--- Checks whether the player has room to swing between two angles, returning 1 when clear, 0 when blocked and -1 when blocked at the player.
function minigame.check_swing_space(x: f32, y: f32, z: f32, start_angle: f32, end_angle: f32)
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local end_x: f32 = 0
	local end_y: f32 = 0
	local end_z: f32 = 0
	local sweep_angle: f32 = 0
	local hit: s32 = 0
	start_angle = event.wrap_angle(start_angle) or start_angle
	start_angle = event.wrap_angle(start_angle) or start_angle
	end_angle = event.wrap_angle(end_angle) or end_angle
	end_angle = event.wrap_angle(end_angle) or end_angle
	start_x = vm.f32(vm.sin(start_angle) * 16.0)
	start_y = 8.0
	start_z = vm.f32(vm.cos(start_angle) * 16.0)
	if end_angle ~= start_angle then
		sweep_angle = vm.f32(end_angle - start_angle)
		sweep_angle = event.wrap_angle(sweep_angle) or sweep_angle
		if sweep_angle > 0.0 then
			end_angle = vm.f32(start_angle + 0.5)
		else
			start_angle = vm.f32(start_angle + vm.f32(0.2))
			end_angle = vm.f32(start_angle - 0.5)
		end
	end
	end_angle = event.wrap_angle(end_angle) or end_angle
	end_x = vm.f32(vm.sin(end_angle) * 16.0)
	end_y = 8.0
	end_z = vm.f32(vm.cos(end_angle) * 16.0)
	do
		local out1, out2, out3 = event.add_vectors(start_x, start_y, start_z, x, y, z)
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	do
		local out1, out2, out3 = event.add_vectors(end_x, end_y, end_z, x, y, z)
		end_x = out1 or end_x
		end_y = out2 or end_y
		end_z = out3 or end_z
	end
	hit = event.get_segment_collision_9(12, start_x, start_y, start_z, x, y + 8.0, z, 1) or hit
	if hit >= 0 then
		return -1
	end
	hit = event.get_segment_collision_9(12, end_x, end_y, end_z, x, y + 8.0, z, 1) or hit
	if hit >= 0 then
		return -1
	end
	hit = event.get_segment_collision_9(12, start_x, start_y, start_z, end_x, end_y, end_z, 1) or hit
	if hit >= 0 then
		return 0
	end
	hit = event.get_segment_collision_9(12, start_x, start_y, start_z, start_x, start_y - 16.0, start_z, 1) or hit
	if hit < 0 then
		return 0
	end
	hit = event.get_segment_collision_9(12, end_x, end_y, end_z, end_x, end_y - 16.0, end_z, 1) or hit
	if hit < 0 then
		return 0
	end
	return 1
end

--- Deletes the Sphida objects.
function minigame.clear_sphida_state()
	minigame.delete_sphida_objects()
end

--- Uses up one stroke of par and ends the Sphida round with a sound when none remain.
function minigame.consume_sphida_shot(sound_effect_id: s32)
	local remaining_par: s32 = 0
	remaining_par = event.get_sphida_par() or remaining_par
	remaining_par = vm.i32(remaining_par - 1)
	event.set_sphida_par(remaining_par)
	if remaining_par <= 0 then
		event.delete_character(8)
		event.delete_character(9)
		event.delete_character(10)
		event.delete_character(11)
		event.set_sphida_playing(0)
		if sound_effect_id ~= -1 then
			event.play_sound_effect(sound_effect_id, 19)
		end
	end
end

--- Deletes the Sphida characters and event image and reinitializes the minigame.
function minigame.delete_sphida_objects()
	for i = 0, 15 do
		event.delete_character(8 + i)
	end
	event.delete_event_image(0)
	event.initialize_sphida()
end

--- Draws the dotted preview path of a Sphida shot, bouncing it off walls, and fills the minimap shot line.
function minigame.draw_sphida_shot_preview(aim_angle: f32, elevation_degrees: f32, texture_block: s32)
	local sprite_index: s32 = 0
	local minimap_index: s32 = 0
	local trace_x: f32 = 0
	local trace_y: f32 = 0
	local trace_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local dot_x: f32 = 0
	local dot_y: f32 = 0
	local dot_z: f32 = 0
	local remaining_length: f32 = 0
	local segment_index: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local back_x: f32 = 0
	local back_y: f32 = 0
	local back_z: f32 = 0
	local distance: f32 = 0
	local hit_result: s32 = 0
	local leftover_step: f32 = 0
	sprite_index = 0
	while sprite_index < 48 do
		event.reset_event_sprite(sprite_index)
		event.set_event_sprite_type(sprite_index, 1)
		event.set_event_sprite_texture(sprite_index, "sphida_bar", texture_block)
		event.set_event_sprite_texture_rect(sprite_index, 64, 0, 32, 32)
		event.set_event_sprite_size(sprite_index, 2, 2)
		event.set_event_sprite_color(sprite_index, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(sprite_index, 0)
		sprite_index = sprite_index + 1
	end
	minimap_index = event.get_sphida_minimap_scale() or minimap_index
	if minimap_index == 0 then
		sprite_index = event.get_language() or sprite_index
		event.set_event_sprite_type(31, 0)
		event.set_event_sprite_draw_pass(31, 1)
		if sprite_index == 0 then
			event.set_event_sprite_texture_rect(31, 308, 146, 204, 30)
			event.set_event_sprite_size(31, 204, 30)
			event.set_event_sprite_position(31, 120, 30)
		else
			event.set_event_sprite_texture_rect(31, 286, 146, 226, 30)
			event.set_event_sprite_size(31, 226, 30)
			event.set_event_sprite_position(31, 140, 30)
		end
	end
	minimap_index = 0
	do
		local out1, out2, out3 = event.get_character_position(0)
		trace_x = out1 or trace_x
		trace_y = out2 or trace_y
		trace_z = out3 or trace_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		dot_x = out1 or dot_x
		dot_y = out2 or dot_y
		dot_z = out3 or dot_z
	end
	trace_y = vm.f32(trace_y + 3.0)
	dot_y = vm.f32(dot_y + 3.0)
	remaining_length = 100.0
	direction_x = vm.f32(vm.sin(aim_angle) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(elevation_degrees * vm.f32(3.1415927)) / 180.0))))
	direction_y = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(elevation_degrees * vm.f32(3.1415927)) / 180.0)))
	direction_z = vm.f32(vm.cos(aim_angle) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(elevation_degrees * vm.f32(3.1415927)) / 180.0))))
	do
		local out1, out2, out3 = event.copy_vector(direction_x, direction_y, direction_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = event.scale_vector(step_x, step_y, step_z, 5.0)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	segment_index = 0
	sprite_index = 0
	while segment_index < 6 do
		remaining_length = 100.0
		do
			local out1, out2, out3 = event.copy_vector(direction_x, direction_y, direction_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = event.scale_vector(step_x, step_y, step_z, 5.0)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		while true do
			do
				local out1, out2, out3 = event.add_vectors(trace_x, trace_y, trace_z, step_x, step_y, step_z)
				trace_x = out1 or trace_x
				trace_y = out2 or trace_y
				trace_z = out3 or trace_z
			end
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					event.get_segment_collision_15(12, dot_x, dot_y, dot_z, trace_x, trace_y, trace_z, 1)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
				normal_x = out4 or normal_x
				normal_y = out5 or normal_y
				normal_z = out6 or normal_z
				hit_result = out7 or hit_result
			end
			if hit_result >= 0 then
				do
					local out1, out2, out3 = event.copy_vector(-direction_x, -direction_y, -direction_z)
					back_x = out1 or back_x
					back_y = out2 or back_y
					back_z = out3 or back_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(back_x, back_y, back_z)
					back_x = out1 or back_x
					back_y = out2 or back_y
					back_z = out3 or back_z
				end
				do
					local out1, out2, out3 = event.scale_vector(back_x, back_y, back_z, 3.0)
					back_x = out1 or back_x
					back_y = out2 or back_y
					back_z = out3 or back_z
				end
				do
					local out1, out2, out3 = event.add_vectors(hit_x, hit_y, hit_z, back_x, back_y, back_z)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
				end
				distance = event.get_distance_between(dot_x, dot_y, dot_z, hit_x, hit_y, hit_z) or distance
				remaining_length = vm.f32(remaining_length - distance)
				if remaining_length <= 0.0 then
					break
				end
				while true do
					distance = event.get_distance_between(dot_x, dot_y, dot_z, hit_x, hit_y, hit_z) or distance
					if distance <= 20.0 then
						leftover_step = vm.f32(20.0 - distance)
						remaining_length = vm.f32(remaining_length - leftover_step)
						do
							local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
							dot_x = out1 or dot_x
							dot_y = out2 or dot_y
							dot_z = out3 or dot_z
						end
						break
					end
					do
						local out1, out2, out3 = event.add_vectors(dot_x, dot_y, dot_z, direction_x, direction_y, direction_z)
						dot_x = out1 or dot_x
						dot_y = out2 or dot_y
						dot_z = out3 or dot_z
					end
					event.set_event_sprite_position(sprite_index, dot_x, dot_y, dot_z)
					event.set_event_sprite_draw_pass(sprite_index, 1)
					sprite_index = vm.i32(sprite_index + 1)
					if vm.imod(sprite_index, 6) == 0 then
						event.set_sphida_minimap_shot_line_point(minimap_index, dot_x, dot_y, dot_z)
						minimap_index = vm.i32(minimap_index + 1)
					end
					if vm.imod(sprite_index, 5) == 0 then
						break
					end
					if sprite_index >= 31 then
						break
					end
				end
				if sprite_index >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.copy_vector(normal_x, normal_y, normal_z)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, leftover_step)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.add_vectors(dot_x, dot_y, dot_z, direction_x, direction_y, direction_z)
					dot_x = out1 or dot_x
					dot_y = out2 or dot_y
					dot_z = out3 or dot_z
				end
				event.set_event_sprite_position(sprite_index, dot_x, dot_y, dot_z)
				event.set_event_sprite_draw_pass(sprite_index, 1)
				sprite_index = sprite_index + 1
				if vm.imod(sprite_index, 6) == 0 then
					event.set_sphida_minimap_shot_line_point(minimap_index, dot_x, dot_y, dot_z)
					minimap_index = vm.i32(minimap_index + 1)
				end
				if sprite_index >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.copy_vector(normal_x, normal_y, normal_z)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, 20.0)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.copy_vector(normal_x, normal_y, normal_z)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
				do
					local out1, out2, out3 = event.scale_vector(step_x, step_y, step_z, remaining_length)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
				do
					local out1, out2, out3 = event.copy_vector(dot_x, dot_y, dot_z)
					trace_x = out1 or trace_x
					trace_y = out2 or trace_y
					trace_z = out3 or trace_z
				end
				if vm.imod(sprite_index, 5) == 0 then
					break
				end
			else
				while sprite_index < 31 do
					do
						local out1, out2, out3 = event.add_vectors(dot_x, dot_y, dot_z, direction_x, direction_y, direction_z)
						dot_x = out1 or dot_x
						dot_y = out2 or dot_y
						dot_z = out3 or dot_z
					end
					event.set_event_sprite_position(sprite_index, dot_x, dot_y, dot_z)
					event.set_event_sprite_draw_pass(sprite_index, 1)
					sprite_index = sprite_index + 1
					if vm.imod(sprite_index, 6) == 0 then
						event.set_sphida_minimap_shot_line_point(minimap_index, dot_x, dot_y, dot_z)
						minimap_index = vm.i32(minimap_index + 1)
					end
					if vm.imod(sprite_index, 5) == 0 then
						break
					end
				end
				do
					local out1, out2, out3 = event.copy_vector(dot_x, dot_y, dot_z)
					trace_x = out1 or trace_x
					trace_y = out2 or trace_y
					trace_z = out3 or trace_z
				end
				break
			end
		end
		segment_index = segment_index + 1
	end
end

--- Returns 1 when a scoop prize is available; otherwise tells the player to take more scoops or explains how scoops set the photographer level and prizes, and returns 0.
function minigame.explain_scoop_prize_requirement()
	local reward_stock: s32 = 0
	local reward_state: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		do
			local out1, out2 = event.get_menu_value_3(6)
			reward_stock = out1 or reward_stock
			reward_state = out2 or reward_state
		end
		if 0 < reward_stock then
			return 1
		end
		if reward_state == 1 then
			message.set_window_mode(3, 1)
			event.open_message_window_2(3, "もっとスクープを撮って来ないと\n賞品はやれないぜ。")
			resume_point = 1
			message.show(3, -1, 3, 256, 208)
		end
		if reward_state == 2 then
			message.set_window_mode(3, 1)
			event.open_message_window_2(
				3,
				"ネタかスクープの数によって、\nオマエの写真家レベルが決まる。<page>レベルが上がれば、ごほうびの\nアイテムも増えるぞ。"
			)
			resume_point = 2
			message.show(3, -1, 3, 256, 208)
		end
		return 0
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				message.set_window_mode_skipping(3, 1)
				message.show_and_wait_skipping(3, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Ends a Sphida shot by restoring the dungeon view, awarding a medal when the goal was reached and reporting when no par remains.
function minigame.finish_sphida_round(reached_goal: s32)
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	local floor_info_value: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local remaining_par: s32 = 0
	local restore_x: f32 = 0
	local restore_y: f32 = 0
	local restore_z: f32 = 0
	event.set_sphida_status_panel_visible(0)
	event.delete_character(12)
	event.clear_effect_manager()
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.set_camera_control_enabled(1)
	event.delete_sword_afterimage()
	event.show_dungeon_status_bar(1, 0.1)
	event.start_crossfade(15)
	if reached_goal == 1 then
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor_number = event.get_dungeon_floor() or floor_number
		floor_info_value = event.get_dungeon_floor_info(stage_id, floor_number, 4) or floor_info_value
		if floor_info_value == 1 then
			floor_info_value = event.get_system_sound_id() or floor_info_value
			event.play_sound_effect(floor_info_value, 18)
			event.set_dungeon_floor_info(stage_id, floor_number, 5, 128)
			event.add_yarikomi_medals(1)
			do
				local out1, out2, out3 = event.get_previous_camera_next_position()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.set_camera_position(position_x, position_y, position_z)
			do
				local out1, out2, out3 = event.get_previous_camera_next_look_at()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.set_camera_look_at(position_x, position_y, position_z)
			event.set_message_window_mode(0, 4)
			message.show_and_wait(0, 2010, 8, 0, 0)
			event.set_active_camera_slot(1)
			event.set_previous_camera_slot(0)
			event.set_follow_camera_offset(0.0, 30.0, 0.0)
			event.set_follow_camera_height(5.0)
			event.set_follow_camera_distance(160.0)
			event.set_camera_speed(6.0)
			event.set_camera_rotation_cancel_mask(1)
			event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
			event.reset_follow_camera(0)
		end
	end
	remaining_par = event.get_sphida_par() or remaining_par
	if reached_goal == 0 and remaining_par <= 0 then
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			restore_x = out1 or restore_x
			restore_y = out2 or restore_y
			restore_z = out3 or restore_z
		end
		event.set_camera_position(restore_x, restore_y, restore_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			restore_x = out1 or restore_x
			restore_y = out2 or restore_y
			restore_z = out3 or restore_z
		end
		event.set_camera_look_at(restore_x, restore_y, restore_z)
		event.set_message_window_mode(0, 4)
		message.show_and_wait(0, 2003, 8, 0, 0)
		event.reset_follow_camera(0)
	end
	event.finish_event()
end

--- Returns the power and two further fields of the Sphida club definition for the equipped weapon.
function minigame.get_equipped_club_definition(power: f32, second_value: f32, third_value: s32)
	local club: s32 = 0
	club = event.get_equipped_item(0, 0) or club
	do
		local out1, out2, out3 = event.get_sphida_club_definition(club)
		power = out1 or power
		second_value = out2 or second_value
		third_value = out3 or third_value
	end
	return power, second_value, third_value
end

--- Initializes the event, clears the Sphida state and fades the screen out.
function minigame.leave_sphida()
	event.initialize_event()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	vm.wait(1)
end

--- Resets the follow camera and loads the Sphida event script of the saved hole.
function minigame.load_saved_sphida_hole_script()
	local saved_hole: s32 = 0
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.set_follow_camera_offset(0.0, 30.0, 0.0)
	event.set_follow_camera_height(5.0)
	event.set_follow_camera_distance(160.0)
	event.set_camera_speed(6.0)
	event.set_camera_rotation_cancel_mask(1)
	event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
	event.reset_follow_camera(0)
	saved_hole = event.get_sphida_saved_hole() or saved_hole
	if saved_hole == 0 then
		event.load_event_script("d02/d02_sfida.stb", 6000)
		return
	end
	if saved_hole == 1 then
		event.load_event_script("d03/d03_sfida.stb", 6000)
		return
	end
	if saved_hole == 2 then
		event.load_event_script("d04/d04_sfida.stb", 6000)
		return
	end
	if saved_hole == 3 then
		event.load_event_script("d05/d05_sfida.stb", 6000)
		return
	end
	if saved_hole == 4 then
		event.load_event_script("d05/d05_sfida.stb", 6001)
		return
	end
	if saved_hole == 5 then
		event.load_event_script("d06/d06_sfida.stb", 6000)
		return
	end
	if saved_hole == 6 then
		event.load_event_script("d07/d07_sfida.stb", 6000)
		return
	end
	if saved_hole == 7 then
		event.load_event_script("d01/d01_sfida.stb", 6001)
		return
	end
end

--- Asks whether to take the boat race challenge and starts the stopwatch on acceptance.
function minigame.offer_boat_race(villager_character: s32, player_character: s32)
	local choice: any = 0
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "やってみるよ。\nボクにはムリだ。")
	choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if choice ~= 0 then
		event.open_message_window_2(
			0,
			"そうか・・・<page>じゃ、挑戦する気になったら\n来なさい。待っているよ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		event.set_save_counter(7, 0)
		return
	end
	event.open_message_window_2(0, "じゃ、用意ドン！")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.finish_event()
	event.control_stopwatch(3, 32, 364, 0)
	event.control_stopwatch_1(0)
	event.set_save_counter(7, 1)
end

--- Opens the Sphida event menu and loads the first Sphida course script.
function minigame.open_sphida_menu()
	event.open_event_menu(26)
	vm.wait(1)
	event.load_event_script("d01/d01_sfida.stb", 6000)
end

--- Reports the scoop memo requirement, the revealed scoop conditions and the photo count in the scoop shop, then explains the prize requirement.
function minigame.report_scoop_progress()
	local memo_count: s32 = 0
	local scoops_taken: s32 = 0
	local scoops_total: s32 = 0
	local reported_count: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		memo_count = event.get_owned_item_count(355) or memo_count
		if memo_count <= 0 then
			message.set_window_mode(3, 1)
			event.open_message_window_2(3, "スクープメモを\n買ってくれ。")
			resume_point = 1
			message.show(3, -1, 3, 256, 208)
			return 0
		end
		do
			local out1, out2 = event.get_menu_value_3(5)
			scoops_taken = out1 or scoops_taken
			scoops_total = out2 or scoops_total
		end
		if scoops_taken == scoops_total then
			message.set_window_mode(3, 1)
			event.open_message_window_2(3, "もう、スクープは\nなさそうだな。")
			resume_point = 2
			message.show(3, -1, 3, 256, 208)
			resume_point = 3
			return minigame.explain_scoop_prize_requirement()
		end
		reported_count = event.get_menu_value_2(3) or reported_count
		if 0 < reported_count then
			message.set_window_mode(3, 8)
			event.set_message_number(3, 1, reported_count)
			event.open_message_window_2(3, "スクープ条件が、[数値１]個\n明らかになった。")
			event.set_message_draw_speed(3, 0)
			resume_point = 4
			message.show(3, -1, 8, 0, 0)
		end
		message.set_window_mode(3, 1)
		reported_count = event.get_menu_value_2(4) or reported_count
		if reported_count <= 0 then
			event.open_message_window_2(3, "なんだよ、スクープなんて\n撮れてないじゃないか。")
		else
			event.set_message_number(3, 1, reported_count)
			event.open_message_window_2(3, "お、[数値１]枚もスクープが\n撮れてるじゃん。さすがだな。")
		end
		resume_point = 5
		message.show(3, -1, 3, 256, 208)
		resume_point = 6
		return minigame.explain_scoop_prize_requirement()
	end, function(received: { any })
		if resume_point <= 1 then
			return 0
		end
		if resume_point <= 3 then
			return minigame.can_continue()
		end
		if resume_point <= 6 then
			if resume_point <= 4 then
				message.set_window_mode_skipping(3, 1)
				message.show_and_wait_skipping(3, -1, 3, 256, 208)
			end
			return minigame.can_continue()
		end
		return nil
	end)
end

--- Runs the Sphida power gauge until the shot is decided and returns a cancel flag with the adjusted power, angle, spin and result code.
function minigame.run_sphida_power_gauge(power: f32, unused: any, shot_angle: f32, spin_x: f32, spin_y: f32, sound_effect_id: s32, result_code: s32)
	local camera_angle: f32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	local gauge_result: s32 = 0
	local marker_slot: s32 = 0
	local cursor_x: f32 = 0
	local cursor_y: f32 = 0
	local debug_input: s32 = 0
	local random_offset: f32 = 0
	local progress: number = 0
	return vm.guard(function()
		camera_angle = vm.f32(shot_angle - vm.f32(3.1415927))
		camera_angle = event.wrap_angle(camera_angle) or camera_angle
		marker_slot = 0
		gauge_result = -10
		event.reset_sphida_power_gauge()
		event.start_sphida_power_gauge()
		while gauge_result == -10 do
			event.set_camera_control_rotation(camera_angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			do
				local out1, out2 = event.get_analog_sticks_2()
				stick_x = out1 or stick_x
				stick_y = out2 or stick_y
			end
			event.set_sphida_spin_mark_position(stick_x, stick_y)
			if (if marker_slot == 0 then wait.get_button_state(1) else 0) ~= 0 then
				event.set_sphida_spin_mark_position(0.0, 0.0)
				event.reset_sphida_power_gauge()
				return 1, power, shot_angle, spin_x, spin_y, result_code
			end
			if wait.get_button_state(0) ~= 0 then
				event.advance_sphida_power_gauge()
				progress = 1
				vm.wait(1)
				gauge_result = event.get_sphida_power_gauge_result() or gauge_result
				if marker_slot == 0 or gauge_result ~= -10 then
					event.play_sound_effect(sound_effect_id, 0)
					do
						local out1, out2 = event.get_sphida_power_gauge_cursor_position()
						cursor_x = out1 or cursor_x
						cursor_y = out2 or cursor_y
					end
					event.set_event_sprite_type(10 + marker_slot, 0)
					event.set_event_sprite_alpha_blend(10 + marker_slot, 2)
					event.set_event_sprite_texture_rect(10 + marker_slot, 0, 224, 32, 32)
					event.set_event_sprite_draw_pass(10 + marker_slot, 1)
					event.set_event_sprite_size(10 + marker_slot, 32, 32)
					event.set_event_sprite_position(10 + marker_slot, cursor_x, cursor_y)
					event.set_event_sprite_scale(10 + marker_slot, 0.2, 0.2, 0.2)
					event.attach_object_handle_to_sprite(20 + marker_slot, 10 + marker_slot)
					event.clear_object_sequence(20 + marker_slot)
					event.set_object_sequence_object(20 + marker_slot, 20 + marker_slot)
					event.set_object_sequence_scale(20 + marker_slot, 2, 2, 2, 10)
					event.set_object_sequence_color(20 + marker_slot, 128, 128, 128, 128, 2)
					event.set_object_sequence_color(20 + marker_slot, 128, 128, 128, 0, 8)
					marker_slot = 1
				end
			else
				progress = 2
				vm.wait(2)
			end
			gauge_result = event.get_sphida_power_gauge_result() or gauge_result
		end
		if gauge_result == 5 then
			event.set_sphida_spin_mark_position(0.0, 0.0)
			event.reset_sphida_power_gauge()
			return 1, power, shot_angle, spin_x, spin_y, result_code
		end
		power = event.get_sphida_shot_power() or power
		debug_input = event.get_debug_flag() or debug_input
		if debug_input == 1 then
			debug_input = event.get_buttons_held() or debug_input
			if bit32.band(debug_input, 16) ~= 0 then
				power = 1.0
				gauge_result = 0
			end
		end
		if gauge_result == 4 then
			power = vm.f32(power * 0.0)
		end
		if gauge_result == -3 then
			power = vm.f32(power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			shot_angle = vm.f32(vm.f32(shot_angle - vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * power)
		end
		if gauge_result == 3 then
			power = vm.f32(power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			shot_angle = vm.f32(vm.f32(shot_angle + vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * power)
		end
		if gauge_result == -2 then
			power = vm.f32(power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			shot_angle = vm.f32(vm.f32(shot_angle - vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * power)
		end
		if gauge_result == 2 then
			power = vm.f32(power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			shot_angle = vm.f32(vm.f32(shot_angle + vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * power)
		end
		if gauge_result == -1 then
			power = vm.f32(power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			shot_angle = vm.f32(shot_angle - random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * power)
		end
		if gauge_result == 1 then
			power = vm.f32(power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			shot_angle = vm.f32(shot_angle + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * power)
		end
		if gauge_result == 0 then
			power = vm.f32(power * vm.f32(1.1))
			stick_x = vm.f32(stick_x * power)
			stick_y = vm.f32(stick_y * power)
		end
		result_code = gauge_result
		shot_angle = event.wrap_angle(shot_angle) or shot_angle
		spin_x = stick_x
		spin_y = stick_y
		progress = 3
		wait.frames(10)
		return 0, power, shot_angle, spin_x, spin_y, result_code
	end, function(received: { any })
		if progress <= 2 then
			if progress <= 1 then
				local _ = party.get_change_state_skipping(0)
				local _ = marker_slot == 0
				marker_slot = 1
			end
			return 1, power, shot_angle, spin_x, spin_y, result_code
		end
		if progress <= 3 then
			return 0, power, shot_angle, spin_x, spin_y, result_code
		end
		return nil, power, shot_angle, spin_x, spin_y, result_code
	end)
end

--- Runs the Sphida power gauge until the shot is released or cancelled and derives the shot power, direction and spin from the result. It then waits one frame more than ten.
function minigame.run_sphida_power_gauge_with_extra_frame(shot_power: f32, unused_value: any, shot_angle: f32, spin_x: f32, spin_y: f32, sound_effect_id: s32, gauge_result: s32)
	local camera_angle: f32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	local result_code: s32 = 0
	local marker_index: s32 = 0
	local cursor_x: f32 = 0
	local cursor_y: f32 = 0
	local debug_input: s32 = 0
	local random_offset: f32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		camera_angle = vm.f32(shot_angle - vm.f32(3.1415927))
		camera_angle = event.wrap_angle(camera_angle) or camera_angle
		marker_index = 0
		result_code = -10
		event.reset_sphida_power_gauge()
		event.start_sphida_power_gauge()
		while result_code == -10 do
			event.set_camera_control_rotation(camera_angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			do
				local out1, out2 = event.get_analog_sticks_2()
				stick_x = out1 or stick_x
				stick_y = out2 or stick_y
			end
			event.set_sphida_spin_mark_position(stick_x, stick_y)
			if (if marker_index == 0 then wait.get_button_state(1) else 0) ~= 0 then
				event.set_sphida_spin_mark_position(0.0, 0.0)
				event.reset_sphida_power_gauge()
				return 1, shot_power, shot_angle, spin_x, spin_y, gauge_result
			end
			if wait.get_button_state(0) ~= 0 then
				event.advance_sphida_power_gauge()
				resume_point = 1
				vm.wait(1)
				result_code = event.get_sphida_power_gauge_result() or result_code
				if marker_index == 0 or result_code ~= -10 then
					event.play_sound_effect(sound_effect_id, 0)
					do
						local out1, out2 = event.get_sphida_power_gauge_cursor_position()
						cursor_x = out1 or cursor_x
						cursor_y = out2 or cursor_y
					end
					event.set_event_sprite_type(10 + marker_index, 0)
					event.set_event_sprite_alpha_blend(10 + marker_index, 2)
					event.set_event_sprite_texture_rect(10 + marker_index, 0, 224, 32, 32)
					event.set_event_sprite_draw_pass(10 + marker_index, 1)
					event.set_event_sprite_size(10 + marker_index, 32, 32)
					event.set_event_sprite_position(10 + marker_index, cursor_x, cursor_y)
					event.set_event_sprite_scale(10 + marker_index, 0.2, 0.2, 0.2)
					event.attach_object_handle_to_sprite(20 + marker_index, 10 + marker_index)
					event.clear_object_sequence(20 + marker_index)
					event.set_object_sequence_object(20 + marker_index, 20 + marker_index)
					event.set_object_sequence_scale(20 + marker_index, 2, 2, 2, 10)
					event.set_object_sequence_color(20 + marker_index, 128, 128, 128, 128, 2)
					event.set_object_sequence_color(20 + marker_index, 128, 128, 128, 0, 8)
					marker_index = 1
				end
			else
				resume_point = 2
				vm.wait(2)
			end
			result_code = event.get_sphida_power_gauge_result() or result_code
		end
		if result_code == 5 then
			event.set_sphida_spin_mark_position(0.0, 0.0)
			event.reset_sphida_power_gauge()
			return 1, shot_power, shot_angle, spin_x, spin_y, gauge_result
		end
		shot_power = event.get_sphida_shot_power() or shot_power
		debug_input = event.get_debug_flag() or debug_input
		if debug_input == 1 then
			debug_input = event.get_buttons_held() or debug_input
			if bit32.band(debug_input, 16) ~= 0 then
				shot_power = 1.0
				result_code = 0
			end
		end
		if result_code == 4 then
			shot_power = vm.f32(shot_power * 0.0)
		end
		if result_code == -3 then
			shot_power = vm.f32(shot_power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			shot_angle = vm.f32(vm.f32(shot_angle - vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * shot_power)
		end
		if result_code == 3 then
			shot_power = vm.f32(shot_power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			shot_angle = vm.f32(vm.f32(shot_angle + vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * shot_power)
		end
		if result_code == -2 then
			shot_power = vm.f32(shot_power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			shot_angle = vm.f32(vm.f32(shot_angle - vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * shot_power)
		end
		if result_code == 2 then
			shot_power = vm.f32(shot_power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			shot_angle = vm.f32(vm.f32(shot_angle + vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * shot_power)
		end
		if result_code == -1 then
			shot_power = vm.f32(shot_power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			shot_angle = vm.f32(shot_angle - random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * shot_power)
		end
		if result_code == 1 then
			shot_power = vm.f32(shot_power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			shot_angle = vm.f32(shot_angle + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * shot_power)
		end
		if result_code == 0 then
			shot_power = vm.f32(shot_power * vm.f32(1.1))
			stick_x = vm.f32(stick_x * shot_power)
			stick_y = vm.f32(stick_y * shot_power)
		end
		gauge_result = result_code
		shot_angle = event.wrap_angle(shot_angle) or shot_angle
		spin_x = stick_x
		spin_y = stick_y
		resume_point = 3
		wait.for_frame_count(10)
		return 0, shot_power, shot_angle, spin_x, spin_y, gauge_result
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				local _ = party.get_change_state_skipping(0)
				local _ = marker_index == 0
				marker_index = 1
			end
			return 1, shot_power, shot_angle, spin_x, spin_y, gauge_result
		end
		if resume_point <= 3 then
			return 0, shot_power, shot_angle, spin_x, spin_y, gauge_result
		end
		return nil, shot_power, shot_angle, spin_x, spin_y, gauge_result
	end)
end

--- Multiplies a value by the power of the equipped Sphida club.
function minigame.scale_by_club_power(value: f32)
	local club: s32 = 0
	local power: f32 = 0
	club = event.get_equipped_item(0, 0) or club
	do
		local out1, _, _ = event.get_sphida_club_definition(club)
		power = out1 or power
	end
	value = vm.f32(value * power)
	return value
end

--- Loads the Sphida course images and ball and pin models and places them at the course's ball and pin positions.
function minigame.set_up_sphida_course(setup_kind: s32)
	local texture_block: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	texture_block = event.load_event_image_4(4, "textures/dungeon/sphida/sphida_bar.json", 0) or texture_block
	event.set_up_sphida(4, texture_block, setup_kind)
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		ball_x = out1 or ball_x
		ball_y = out2 or ball_y
		ball_z = out3 or ball_z
	end
	pin_color = event.get_sphida_pin_color() or pin_color
	ball_color = event.get_sphida_ball_color() or ball_color
	event.load_character(4, "dungeon/sphida/bball.gltf", "info", 8)
	event.load_character(4, "dungeon/sphida/rball.gltf", "info", 9)
	if ball_color == 0 then
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
	else
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
	end
	if pin_color == 0 then
		event.load_character(4, "dungeon/sphida/rgool.gltf", "info", 10)
		event.load_character(4, "dungeon/sphida/rgool2.gltf", "info", 11)
	else
		event.load_character(4, "dungeon/sphida/bgool.gltf", "info", 10)
		event.load_character(4, "dungeon/sphida/bgool2.gltf", "info", 11)
	end
	event.load_sphida_collision_model(4, "dungeon/sphida/gool_a.gltf")
	event.set_character_active(10)
	event.set_character_active(11)
	event.set_scene_character_type(8, 4)
	event.set_scene_character_type(9, 4)
	event.set_scene_character_type(10, 4)
	event.set_scene_character_type(11, 4)
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_character_position(10, pin_x, pin_y, pin_z)
	event.set_character_position(11, pin_x, pin_y, pin_z)
end

--- Loads the Sphida bar graphics (language-specific), ball, pin and collision model, places them for a course and sets their draw distance from the dungeon stage.
function minigame.set_up_sphida_course_with_draw_distance(setup_kind: s32, course: s32)
	local texture_bank: s32 = 0
	local language_code: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local stage_id: s32 = 0
	local draw_distance: f32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.change_directory("dungeon/sphida/")
	language_code = event.get_language() or language_code
	if language_code == 0 then
		texture_bank = event.load_event_image_4(4, "sphida_bar.json", 0) or texture_bank
	else
		texture_bank = event.load_event_image_4(4, "sphida_bar_1.json", 0) or texture_bank
	end
	event.set_up_sphida(4, texture_bank, setup_kind, course)
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		ball_x = out1 or ball_x
		ball_y = out2 or ball_y
		ball_z = out3 or ball_z
	end
	pin_color = event.get_sphida_pin_color() or pin_color
	ball_color = event.get_sphida_ball_color() or ball_color
	event.load_character(4, "bball.gltf", "info", 8)
	event.load_character(4, "rball.gltf", "info", 9)
	if ball_color == 0 then
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
	else
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
	end
	if pin_color == 0 then
		event.load_character(4, "rgool.gltf", "info", 10)
		event.load_character(4, "rgool2.gltf", "info", 11)
	else
		event.load_character(4, "bgool.gltf", "info", 10)
		event.load_character(4, "bgool2.gltf", "info", 11)
	end
	event.load_sphida_collision_model(4, "gool_a.gltf")
	event.change_directory("")
	event.set_character_active(10)
	event.set_character_active(11)
	event.set_scene_character_type(10, 4)
	event.set_scene_character_type(11, 4)
	stage_id = event.get_dungeon_stage_id() or stage_id
	if stage_id == 0 then
		draw_distance = 1300.0
	end
	if stage_id == 1 then
		draw_distance = 2000.0
	end
	if stage_id == 2 then
		draw_distance = 16000.0
	end
	if stage_id == 3 then
		draw_distance = 1500.0
	end
	if stage_id == 4 then
		draw_distance = 1800.0
	end
	if stage_id == 5 then
		draw_distance = 2100.0
	end
	if stage_id == 6 then
		draw_distance = 2000.0
	end
	event.set_character_draw_distance(8, draw_distance)
	event.set_character_visible(8, 1, 1, 1.0)
	event.set_character_draw_distance(9, draw_distance)
	event.set_character_visible(9, 1, 1, 1.0)
	event.set_character_draw_distance(10, draw_distance)
	event.set_character_visible(10, 1, 1, 1.0)
	event.set_character_draw_distance(11, draw_distance)
	event.set_character_visible(11, 1, 1, 1.0)
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_character_position(10, pin_x, pin_y, pin_z)
	event.set_character_position(11, pin_x, pin_y, pin_z)
end

--- Places the Sphida ball at the player and turns the player toward the pin along the first angle with room to swing.
function minigame.set_up_sphida_shot(x: f32, y: f32, z: f32, angle: f32)
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local offset: f32 = 0
	local previous_offset: f32 = 0
	local swing_clearance: s32 = 0
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	event.set_sphida_ball_position(x, y + 3.0, z)
	event.set_character_position(8, x, y + 3.0, z)
	event.set_character_position(9, x, y + 3.0, z)
	y = vm.f32(y + 3.0)
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	angle = event.get_direction_angle(x, y, z, pin_x, pin_y, pin_z) or angle
	offset = 0.0
	previous_offset = 0.0
	while offset <= vm.f32(3.1415927) do
		swing_clearance = minigame.check_swing_space(
			x,
			y,
			z,
			vm.f32(vm.f32(angle + previous_offset) + vm.f32(1.5707964)),
			vm.f32(vm.f32(angle + offset) + vm.f32(1.5707964))
		)
		if swing_clearance == 1 then
			angle = vm.f32(angle + offset)
			break
		else
			swing_clearance = minigame.check_swing_space(
				x,
				y,
				z,
				vm.f32(vm.f32(angle - previous_offset) + vm.f32(1.5707964)),
				vm.f32(vm.f32(angle - offset) + vm.f32(1.5707964))
			)
			if swing_clearance == 1 then
				angle = vm.f32(angle - offset)
				break
			else
				previous_offset = offset
				offset = vm.f32(offset + vm.f32(0.3926991))
			end
		end
	end
	event.set_character_rotation(0, 0.0, angle, 0.0)
	event.set_character_motion(0, "かまえ", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	return x, y, z, angle
end

--- Shows the score of the last Sphida hole as sprites and waits for a button press.
function minigame.show_sphida_hole_score()
	local language_code: s32 = 0
	local texture_bank: s32 = 0
	local score: s32 = 0
	vm.wait(1)
	language_code = event.get_language() or language_code
	score = event.get_sphida_hole_score(-1) or score
	texture_bank = event.get_sphida_texture_bank() or texture_bank
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "omake_sfida", texture_bank)
	event.set_event_sprite_position(0, 256, 192)
	if language_code == 3 then
		event.set_event_sprite_texture_rect(0, 0, 38, 162, 34)
		event.set_event_sprite_size(0, 162, 34)
	else
		event.set_event_sprite_texture_rect(0, 0, 38, 182, 34)
		event.set_event_sprite_size(0, 182, 34)
	end
	event.set_event_sprite_color(0, 128, 128, 128, 128)
	event.set_event_sprite_draw_pass(0, 1)
	event.reset_event_sprite(1)
	event.set_event_sprite_draw_pass(1, 0)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "omake_sfida", texture_bank)
	event.set_event_sprite_texture_rect(2, 136, 0, 104, 38)
	event.set_event_sprite_position(2, 278, 224)
	event.set_event_sprite_size(2, 104, 38)
	event.set_event_sprite_color(2, 128, 128, 128, 128)
	event.set_event_sprite_draw_pass(2, 1)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "omake_sfida", texture_bank)
	event.set_event_sprite_texture_rect(3, vm.i32(vm.imod(score, 10) * 28), 96, 28, 32)
	event.set_event_sprite_position(3, 208, 224)
	event.set_event_sprite_size(3, 28, 32)
	event.set_event_sprite_color(3, 128, 128, 128, 128)
	event.set_event_sprite_draw_pass(3, 1)
	if vm.idiv(score, 10) > 0 then
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_texture(4, "omake_sfida", texture_bank)
		event.set_event_sprite_texture_rect(4, vm.i32(vm.idiv(score, 10) * 28), 96, 28, 32)
		event.set_event_sprite_position(4, 184, 224)
		event.set_event_sprite_size(4, 28, 32)
		event.set_event_sprite_color(4, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(4, 1)
	end
	while true do
		if wait.get_button_state(0) ~= 0 then
			break
		else
			vm.wait(2)
		end
	end
end

--- Shows the hint that the circle button stops the Sphida gauge.
function minigame.show_stop_hint()
	local language: s32 = 0
	message.set_window_mode(1, 7)
	event.apply_message_window_preset(1, 2)
	language = event.get_language() or language
	if language == 0 then
		event.open_message_window_2(1, "(O)でストップ")
	else
		event.open_message_window_2(1, "It stops with (O) button.")
	end
	message.open(1, -1, 15, 0, 0)
end

--- Shows the message announcing the item and amount won for a fishing tournament rank, choosing the text by rank and whether the amount is one.
function minigame.show_tournament_prize(unused_value: any, rank: s32, item_id: s32, amount: s32)
	local message_id: s32 = 0
	if amount <= 0 then
		return
	end
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	message_id = -1
	if rank == 1 then
		if amount == 1 then
			message_id = 14
		else
			message_id = 21
		end
	end
	if rank == 2 then
		if amount == 1 then
			message_id = 26
		else
			message_id = 24
		end
	end
	if rank == 3 then
		if amount == 1 then
			message_id = 27
		else
			message_id = 25
		end
	end
	if message_id == -1 then
		return
	end
	event.set_message_number(1, 1, rank)
	event.set_message_item_name(1, 1, item_id)
	event.set_message_number(1, 2, amount)
	message.show(1, message_id, 8, 0, 0)
end

--- Accepts a variant, rank, item and amount and does nothing; this stands in for minigame.show_tournament_prize when events are skipped.
function minigame.show_tournament_prize_skipping(variant: any, rank: any, item_id: any, amount: s32) end

--- Shows the message announcing the item and amount won for a fishing tournament rank, choosing the text by variant, rank and whether the amount is one.
function minigame.show_tournament_prize_with_variant(variant: s32, rank: s32, item_id: s32, amount: s32)
	local message_id: s32 = 0
	if amount <= 0 then
		return
	end
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	message_id = -1
	if variant == 0 then
		if rank == 1 then
			if amount == 1 then
				message_id = 14
			else
				message_id = 21
			end
		elseif amount == 1 then
			message_id = 15
		else
			message_id = 22
		end
	end
	if variant == 1 then
		if amount == 1 then
			message_id = 18
		else
			message_id = 23
		end
	end
	if message_id == -1 then
		return
	end
	event.set_message_number(1, 1, rank)
	event.set_message_item_name(1, 1, item_id)
	event.set_message_number(1, 2, amount)
	message.show(1, message_id, 8, 0, 0)
end

--- Switches the Sphida ball between its two colors and swaps which ball character is active.
function minigame.toggle_sphida_ball_color()
	local ball_color: s32 = 0
	ball_color = event.get_sphida_ball_color() or ball_color
	if ball_color == 0 then
		ball_color = 1
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
	else
		ball_color = 0
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
	end
	event.set_sphida_ball_color(ball_color)
end

return minigame
