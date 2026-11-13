--!strict
--- Sphida minigame helpers for the dungeon system scripts: aiming, shot power gauge and round end.

local vm = require("@lib/vm")
local dungeon_system_scripts = vm.module("@lib/event/dungeon_system_scripts")
local dungeon_system_scripts_message = vm.module("@lib/event/dungeon_system_scripts_message")
local map = vm.module("@lib/event/map")
local visual_effect = vm.module("@lib/event/visual_effect")
local wait = vm.module("@lib/event/wait")

local dungeon_system_scripts_minigame = {}

--- Traces the predicted Sphida shot path with bouncing sprite dots and fills the minimap shot line.
function dungeon_system_scripts_minigame.draw_shot_guide(yaw: f32, pitch_degrees: f32, texture_block: s32)
	local sprite_index: s32 = 0
	local minimap_value: s32 = 0
	local ray_x: f32 = 0
	local ray_y: f32 = 0
	local ray_z: f32 = 0
	local ray_dx: f32 = 0
	local ray_dy: f32 = 0
	local ray_dz: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local remaining_length: f32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
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
	minimap_value = event.get_sphida_minimap_scale() or minimap_value
	if minimap_value == 0 then
		event.set_event_sprite_type(31, 0)
		event.set_event_sprite_texture_rect(31, 308, 146, 204, 30)
		event.set_event_sprite_draw_pass(31, 1)
		event.set_event_sprite_size(31, 204, 30)
		event.set_event_sprite_position(31, 120, 30)
	elseif minimap_value == 2 then
		sprite_index = 0
		while sprite_index < 32 do
			event.set_event_sprite_color(sprite_index, 128, 128, 128, 32)
			sprite_index = sprite_index + 1
		end
	end
	minimap_value = 0
	do
		local out1, out2, out3 = event.get_character_position(0)
		ray_x = out1 or ray_x
		ray_y = out2 or ray_y
		ray_z = out3 or ray_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		point_x = out1 or point_x
		point_y = out2 or point_y
		point_z = out3 or point_z
	end
	ray_y = vm.f32(ray_y + 3.0)
	point_y = vm.f32(point_y + 3.0)
	remaining_length = 600.0
	step_x = vm.f32(vm.sin(yaw) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(pitch_degrees * vm.f32(3.1415927)) / 180.0))))
	step_y = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(pitch_degrees * vm.f32(3.1415927)) / 180.0)))
	step_z = vm.f32(vm.cos(yaw) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(pitch_degrees * vm.f32(3.1415927)) / 180.0))))
	do
		local out1, out2, out3 = event.copy_vector(step_x, step_y, step_z)
		ray_dx = out1 or ray_dx
		ray_dy = out2 or ray_dy
		ray_dz = out3 or ray_dz
	end
	do
		local out1, out2, out3 = event.scale_vector(ray_dx, ray_dy, ray_dz, 30.0)
		ray_dx = out1 or ray_dx
		ray_dy = out2 or ray_dy
		ray_dz = out3 or ray_dz
	end
	sprite_index = 1
	while true do
		do
			local out1, out2, out3 = event.add_vectors(ray_x, ray_y, ray_z, ray_dx, ray_dy, ray_dz)
			ray_x = out1 or ray_x
			ray_y = out2 or ray_y
			ray_z = out3 or ray_z
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, point_x, point_y, point_z, ray_x, ray_y, ray_z, 1)
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
				local out1, out2, out3 = event.copy_vector(-step_x, -step_y, -step_z)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			do
				local out1, out2, out3 = event.normalize_vector(offset_x, offset_y, offset_z)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			do
				local out1, out2, out3 = event.scale_vector(offset_x, offset_y, offset_z, 3.0)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			do
				local out1, out2, out3 = event.add_vectors(hit_x, hit_y, hit_z, offset_x, offset_y, offset_z)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
			end
			distance = event.get_distance_between(point_x, point_y, point_z, hit_x, hit_y, hit_z) or distance
			remaining_length = vm.f32(remaining_length - distance)
			if remaining_length <= 0.0 then
				break
			end
			while true do
				distance = event.get_distance_between(point_x, point_y, point_z, hit_x, hit_y, hit_z) or distance
				if distance <= 20.0 then
					leftover_step = vm.f32(20.0 - distance)
					remaining_length = vm.f32(remaining_length - leftover_step)
					do
						local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
						point_x = out1 or point_x
						point_y = out2 or point_y
						point_z = out3 or point_z
					end
					break
				end
				do
					local out1, out2, out3 = event.add_vectors(point_x, point_y, point_z, step_x, step_y, step_z)
					point_x = out1 or point_x
					point_y = out2 or point_y
					point_z = out3 or point_z
				end
				event.set_event_sprite_position(sprite_index, point_x, point_y, point_z)
				event.set_event_sprite_draw_pass(sprite_index, 1)
				if vm.imod(sprite_index, 6) == 0 then
					event.set_sphida_minimap_shot_line_point(minimap_value, point_x, point_y, point_z)
					minimap_value = vm.i32(minimap_value + 1)
				end
				sprite_index = sprite_index + 1
				if sprite_index >= 31 then
					break
				end
			end
			if sprite_index >= 31 then
				break
			end
			do
				local out1, out2, out3 = event.copy_vector(normal_x, normal_y, normal_z)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			do
				local out1, out2, out3 = event.scale_vector(step_x, step_y, step_z, leftover_step)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			do
				local out1, out2, out3 = event.add_vectors(point_x, point_y, point_z, step_x, step_y, step_z)
				point_x = out1 or point_x
				point_y = out2 or point_y
				point_z = out3 or point_z
			end
			event.set_event_sprite_position(sprite_index, point_x, point_y, point_z)
			event.set_event_sprite_draw_pass(sprite_index, 1)
			if vm.imod(sprite_index, 6) == 0 then
				event.set_sphida_minimap_shot_line_point(minimap_value, point_x, point_y, point_z)
				minimap_value = vm.i32(minimap_value + 1)
			end
			sprite_index = sprite_index + 1
			if sprite_index >= 31 then
				break
			end
			do
				local out1, out2, out3 = event.copy_vector(normal_x, normal_y, normal_z)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			do
				local out1, out2, out3 = event.scale_vector(step_x, step_y, step_z, 20.0)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			do
				local out1, out2, out3 = event.copy_vector(normal_x, normal_y, normal_z)
				ray_dx = out1 or ray_dx
				ray_dy = out2 or ray_dy
				ray_dz = out3 or ray_dz
			end
			do
				local out1, out2, out3 = event.scale_vector(ray_dx, ray_dy, ray_dz, remaining_length)
				ray_dx = out1 or ray_dx
				ray_dy = out2 or ray_dy
				ray_dz = out3 or ray_dz
			end
			do
				local out1, out2, out3 = event.copy_vector(point_x, point_y, point_z)
				ray_x = out1 or ray_x
				ray_y = out2 or ray_y
				ray_z = out3 or ray_z
			end
		else
			while sprite_index < 31 do
				do
					local out1, out2, out3 = event.add_vectors(point_x, point_y, point_z, step_x, step_y, step_z)
					point_x = out1 or point_x
					point_y = out2 or point_y
					point_z = out3 or point_z
				end
				event.set_event_sprite_position(sprite_index, point_x, point_y, point_z)
				event.set_event_sprite_draw_pass(sprite_index, 1)
				if vm.imod(sprite_index, 6) == 0 then
					event.set_sphida_minimap_shot_line_point(minimap_value, point_x, point_y, point_z)
					minimap_value = vm.i32(minimap_value + 1)
				end
				sprite_index = sprite_index + 1
			end
			break
		end
	end
end

--- Restores the player and camera after a Sphida round and shows the closing message when no par is left.
function dungeon_system_scripts_minigame.end_round(exit_type: s32)
	local remaining_par: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	event.set_sphida_status_panel_visible(0)
	event.delete_character(12)
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.set_camera_control_enabled(1)
	event.delete_sword_afterimage()
	event.show_dungeon_status_bar(1.0)
	event.start_crossfade(15)
	remaining_par = event.get_sphida_par() or remaining_par
	if exit_type == 0 and remaining_par <= 0 then
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
		dungeon_system_scripts_message.show_and_wait(0, 2003, 8, 0, 0)
		event.reset_follow_camera(1)
	end
	event.finish_event()
end

--- Ends the Sphida minigame and plays a sound when no par is left.
function dungeon_system_scripts_minigame.end_when_par_exhausted(sound_effect_id: s32)
	local remaining_par: s32 = 0
	remaining_par = event.get_sphida_par() or remaining_par
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

--- Places the player at the Sphida ball facing the pin along a clear line and returns the ball position and facing angle.
function dungeon_system_scripts_minigame.place_character_at_ball(ball_x: f32, ball_y: f32, ball_z: f32, facing_angle: f32)
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local angle_offset: f32 = 0
	local previous_offset: f32 = 0
	local is_clear: s32 = 0
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		ball_x = out1 or ball_x
		ball_y = out2 or ball_y
		ball_z = out3 or ball_z
	end
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	facing_angle = event.get_direction_angle(ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or facing_angle
	angle_offset = 0.0
	previous_offset = 0.0
	while angle_offset <= vm.f32(3.1415927) do
		is_clear = map.check_arc_clearance(
			ball_x,
			ball_y,
			ball_z,
			vm.f32(vm.f32(facing_angle + previous_offset) + vm.f32(1.5707964)),
			vm.f32(vm.f32(facing_angle + angle_offset) + vm.f32(1.5707964))
		)
		if is_clear == 1 then
			facing_angle = vm.f32(facing_angle + angle_offset)
			break
		else
			is_clear = map.check_arc_clearance(
				ball_x,
				ball_y,
				ball_z,
				vm.f32(vm.f32(facing_angle - previous_offset) + vm.f32(1.5707964)),
				vm.f32(vm.f32(facing_angle - angle_offset) + vm.f32(1.5707964))
			)
			if is_clear == 1 then
				facing_angle = vm.f32(facing_angle - angle_offset)
				break
			else
				previous_offset = angle_offset
				angle_offset = vm.f32(angle_offset + vm.f32(0.3926991))
			end
		end
	end
	event.set_character_position(0, ball_x, ball_y - 3.0, ball_z)
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.set_character_motion(0, "かまえ", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	return ball_x, ball_y, ball_z, facing_angle
end

--- Lets the player aim a Sphida shot with the stick and returns zero when confirmed or one when cancelled along with the aim angle and pitch.
function dungeon_system_scripts_minigame.run_aim_phase(aim_angle: f32, pitch_degrees: f32, texture_block: s32)
	local result: s32 = 0
	local idle_timer: s32 = 0
	local ready_pose_timer: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local camera_angle: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local new_pitch: f32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		idle_timer = 60
		ready_pose_timer = 76
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			start_x = out1 or start_x
			start_y = out2 or start_y
			start_z = out3 or start_z
		end
		event.set_follow_camera_following(1)
		event.set_camera_control_enabled(1)
		event.set_camera_rotation_cancel_mask(43)
		event.set_camera_speed(6.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_target(start_x, start_y + 20.0, start_z)
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
					map.check_arc_clearance(
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
				ready_pose_timer = 76
				idle_timer = 400
			else
				if stick_x ~= 0.0 then
					event.set_character_motion(0, "かまえバタバタ")
					idle_timer = 200
					ready_pose_timer = 0
				elseif ready_pose_timer <= 0 then
					event.set_character_motion(0, "かまえ")
				else
					ready_pose_timer = ready_pose_timer - 1
				end
				idle_timer = idle_timer - 1
			end
			new_pitch = pitch_degrees
			new_pitch = vm.f32(new_pitch + stick_y)
			if new_pitch <= 5.0 then
				new_pitch = 5.0
			end
			if new_pitch >= 30.0 then
				new_pitch = 30.0
			end
			aim_angle = rotation_y
			pitch_degrees = new_pitch
			event.set_sphida_carry_angle(vm.f32(pitch_degrees * vm.f32(3.1415927)) / 180.0)
			camera_angle = vm.f32(aim_angle - vm.f32(3.1415927))
			camera_angle = event.wrap_angle(camera_angle) or camera_angle
			event.set_camera_control_rotation(camera_angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			dungeon_system_scripts_minigame.draw_shot_guide(aim_angle, pitch_degrees, texture_block)
			if dungeon_system_scripts.get_pressed_buttons(32) ~= 0 then
				event.set_character_motion(0, "かまえ")
				result = 0
				break
			elseif dungeon_system_scripts.get_pressed_buttons(64) ~= 0 then
				result = 1
				break
			else
				resume_step = 1
				vm.wait(1)
			end
		end
		visual_effect.hide_all_sprites()
		resume_step = 2
		vm.wait(2)
		return result, aim_angle, pitch_degrees
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				visual_effect.hide_all_sprites_skipping()
			end
			return result, aim_angle, pitch_degrees
		end
		return nil, aim_angle, pitch_degrees
	end)
end

--- Runs the Sphida power gauge until the shot is released or cancelled, returning 1 on cancel or 0 with the adjusted power, angle, offsets and gauge result.
function dungeon_system_scripts_minigame.run_shot_power_gauge(power: f32, unused_value: any, aim_angle: f32, shot_x_offset: f32, shot_y_offset: f32, sound_effect_id: s32, shot_result: s32)
	local camera_angle: f32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	local gauge_result: s32 = 0
	local marker_slot: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local random_offset: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		camera_angle = vm.f32(aim_angle - vm.f32(3.1415927))
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
			if (if marker_slot == 0 then dungeon_system_scripts.get_pressed_buttons(64) else 0) ~= 0 then
				event.set_sphida_spin_mark_position(0.0, 0.0)
				event.reset_sphida_power_gauge()
				return 1, power, aim_angle, shot_x_offset, shot_y_offset, shot_result
			end
			if dungeon_system_scripts.get_pressed_buttons(32) ~= 0 then
				event.advance_sphida_power_gauge()
				resume_step = 1
				vm.wait(1)
				gauge_result = event.get_sphida_power_gauge_result() or gauge_result
				if marker_slot == 0 or gauge_result ~= -10 then
					event.play_sound_effect(sound_effect_id, 0)
					do
						local out1, out2 = event.get_sphida_power_gauge_cursor_position()
						x = out1 or x
						y = out2 or y
					end
					event.set_event_sprite_type(10 + marker_slot, 0)
					event.set_event_sprite_alpha_blend(10 + marker_slot, 2)
					event.set_event_sprite_texture_rect(10 + marker_slot, 0, 224, 32, 32)
					event.set_event_sprite_draw_pass(10 + marker_slot, 1)
					event.set_event_sprite_size(10 + marker_slot, 32, 32)
					event.set_event_sprite_position(10 + marker_slot, x, y)
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
				resume_step = 2
				vm.wait(2)
			end
			gauge_result = event.get_sphida_power_gauge_result() or gauge_result
		end
		if gauge_result == 5 then
			event.set_sphida_spin_mark_position(0.0, 0.0)
			event.reset_sphida_power_gauge()
			return 1, power, aim_angle, shot_x_offset, shot_y_offset, shot_result
		end
		power = event.get_sphida_shot_power() or power
		if gauge_result == 4 then
			power = vm.f32(power * 0.0)
		end
		if gauge_result == -3 then
			power = vm.f32(power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			aim_angle = vm.f32(vm.f32(aim_angle - vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * power)
		end
		if gauge_result == 3 then
			power = vm.f32(power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			aim_angle = vm.f32(vm.f32(aim_angle + vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * power)
		end
		if gauge_result == -2 then
			power = vm.f32(power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			aim_angle = vm.f32(vm.f32(aim_angle - vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * power)
		end
		if gauge_result == 2 then
			power = vm.f32(power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			aim_angle = vm.f32(vm.f32(aim_angle + vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * power)
		end
		if gauge_result == -1 then
			power = vm.f32(power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			aim_angle = vm.f32(aim_angle - random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * power)
		end
		if gauge_result == 1 then
			power = vm.f32(power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			aim_angle = vm.f32(aim_angle + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * power)
		end
		if gauge_result == 0 then
			power = vm.f32(power * vm.f32(1.1))
			stick_x = vm.f32(stick_x * power)
			stick_y = vm.f32(stick_y * power)
		end
		shot_result = gauge_result
		aim_angle = event.wrap_angle(aim_angle) or aim_angle
		shot_x_offset = stick_x
		shot_y_offset = stick_y
		resume_step = 3
		wait.for_frame_count(10)
		return 0, power, aim_angle, shot_x_offset, shot_y_offset, shot_result
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				local _ = wait.is_button_pressed_skipping(32)
				local _ = marker_slot == 0
				marker_slot = 1
			end
			return 1, power, aim_angle, shot_x_offset, shot_y_offset, shot_result
		end
		if resume_step <= 3 then
			return 0, power, aim_angle, shot_x_offset, shot_y_offset, shot_result
		end
		return nil, power, aim_angle, shot_x_offset, shot_y_offset, shot_result
	end)
end

return dungeon_system_scripts_minigame
