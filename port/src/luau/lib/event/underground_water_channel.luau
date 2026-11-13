--!strict
--- Cutscenes and door mechanisms of the Underground Water Channel dungeon floors.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local underground_water_channel = {}

--- Opens the triggered key door by raising its gate part, opening its minimap door and swinging the camera around.
function underground_water_channel.open_key_door()
	local sound_effect: s32 = 0
	local map_part: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local camera_angle: f32 = 0
	local i: s32 = 0
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or sound_effect
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_map_part_2(0, map_part)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(1, map_part, "d01d01_00-m0")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.move_object_sequence(1, 0.0, 80.0, 0.0, 60)
	event.play_sound_effect(sound_effect, 0)
	camera_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or camera_angle
	camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
	camera_angle = event.wrap_angle(camera_angle) or camera_angle
	i = 0
	while i < 60 do
		event.swing_camera_control_to_angle(camera_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		i = i + 1
		vm.wait(1)
	end
	event.set_function_point_enabled(map_part, "key", 0)
	event.attach_object_handle_to_map_part_3(2, map_part, "d01da00-a")
	event.set_object_handle_position(2, 0.0, 80.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, map_part, "d01dv00-c")
	event.set_object_handle_visible(3, 0)
	event.reset_follow_camera(0)
end

--- Plays the scene in which Mints comes to, takes out a receiver and holds a voiced call with sound effect cues, then fades out.
function underground_water_channel.play_receiver_call(sound_effect: s32)
	event.set_camera_sequence_position(-151.46, 20.36, 7.26)
	event.set_camera_sequence_look_at(-125.08, 23.15, -0.98)
	event.set_object_sequence_position(0, -123.65, -0.41, -1.34)
	event.set_object_sequence_rotation(0, 0.0, -1.53, 0.0)
	event.fade_out_screen(0, 255, 255, 255)
	event.play_sound_effect(sound_effect, 0)
	wait.frames(30)
	event.fade_in_camera_sequence(30, 255.0, 255.0, 255.0)
	camera.wait_until_done()
	event.stop_sound_effect(sound_effect, 0)
	event.set_object_sequence_motion(0, "我に返る", 6)
	event.set_object_sequence_texture_animation(0, 1, "ぱちぱち")
	event.set_object_sequence_texture_animation(0, 1, "はっとする")
	message.show_voiced(1020050)
	event.open_voice_stream_wave(1, 1020055)
	sound.wait_voice_stream_ready(1)
	event.play_voice_stream(1)
	wait.frames(45)
	event.close_voice_stream(1)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "無表情")
	event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
	event.set_character_active(1, 8)
	event.set_object_sequence_motion(0, "レシーバーを取り出す", 6)
	event.queue_object_sequence_next_motion(0, "レシーバーを取り出すL")
	object.wait_until_done(0)
	message.show_voiced(1020060)
	event.set_object_sequence_motion(0, "耳に当てる", 6)
	event.queue_object_sequence_next_motion(0, "レシーバーキョロキョロ", 6)
	event.queue_object_sequence_next_motion(0, "レシーバー立ち")
	wait.until_motion_progress_counted(0, vm.f32(0.356), -1.0, 41)
	event.stop_sound_effect(sound_effect, 0)
	event.play_sound_effect(sound_effect, 2)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1020070)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
	message.show_voiced(1020080)
	event.set_object_sequence_motion(0, "うなづく(レシーバー)", 6)
	event.queue_object_sequence_next_motion(0, "レシーバー立ち")
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1020090)
	event.reset_mouth_texture_animations()
	message.show_voiced(1020100)
	message.show_voiced(1020101)
	message.show_voiced(1020110)
	message.show_voiced(1020120)
	message.show_voiced(1020130)
	event.set_object_sequence_motion(0, "うなづく(レシーバー)", 6)
	event.queue_object_sequence_next_motion(0, "レシーバー立ち")
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1020140)
	event.reset_mouth_texture_animations()
	message.show_voiced(1020150)
	event.set_object_sequence_motion(0, "レシーバーをなおす", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	wait.until_motion_progress_counted(0, 0.25, -1.0, 90)
	event.play_sound_effect(sound_effect, 3)
	wait.until_motion_progress_counted(0, vm.f32(0.637), -1.0, 90)
	event.play_sound_effect(sound_effect, 4)
	wait.until_motion_finished(0)
	event.fade_out_screen(30)
	object.wait_until_done(0)
end

--- Sets up and plays the receiver cutscene in which Mints takes out a receiver and listens to a call, then restores the dungeon view and controls.
function underground_water_channel.play_receiver_cutscene()
	local sound_effect: s32 = 0
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	vm.section(function()
		event.set_save_flag(102, 1)
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		event.set_message_window_mode(0, 7)
		sound_effect = event.load_sound_effect_file_2(1807) or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			event_x = out1 or event_x
			event_y = out2 or event_y
			event_z = out3 or event_z
			event_angle = out4 or event_angle
		end
		event_angle = vm.f32(event_angle + vm.f32(1.5707964))
		if event_angle > vm.f32(3.1415927) then
			event_angle = vm.f32(event_angle - vm.f32(6.2831855))
		end
		event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
		event.load_character_motion_pack(5, "event/e100/e102/e102_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 130.0, 100.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.load_item_model(5, 359, "info", 8)
		event.set_character_active(0, 8)
		event.attach_character_to_frame(0, "ef00", 8)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.load_message_file(0, 5, "event/e100/e102/e102_1.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		vm.wait(1)
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		underground_water_channel.play_receiver_call(sound_effect)
	end)
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	sound.load_event_sound_effects()
	event.stop_sound_effect(sound_effect, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_dungeon_pause_flags(1, 0)
	event.set_object_handle_position(0, -175.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_camera_position(-15.0, 77.61, 0.13)
	event.set_camera_look_at(-175.0, 30.0, 0.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Shows a refusal message and returns 1 unless the active character is playable character 0 with a club (item 9 to 14) equipped, otherwise passes that club to the Sphida device and returns 0.
function underground_water_channel.prepare_sphida_club()
	local playable_character: s32 = 0
	local club_item: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 then
			event.set_message_window_mode(0, 4)
			resume_point = 1
			message.show(0, 2000, 8, 0, 0)
			return 1
		end
		club_item = event.get_equipped_item(0, 0) or club_item
		if club_item ~= 9 and club_item ~= 10 and club_item ~= 11 and club_item ~= 12 and club_item ~= 13 and club_item ~= 14 then
			event.set_message_window_mode(0, 4)
			resume_point = 2
			message.show(0, 2001, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(club_item)
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

--- Raises the triggered gate map part by 80 units while the camera swings to the event angle, with the gate sound.
function underground_water_channel.raise_gate()
	local sound_effect: s32 = 0
	local map_part: s32 = 0
	local camera_angle: f32 = 0
	local i: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or sound_effect
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_map_part_3(0, map_part, "d01w10_4-m0")
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_map_part_3(1, map_part, "d01w10_5-m0")
	event.set_object_handle_visible(1, 1)
	event.play_sound_effect(sound_effect, 2)
	camera_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or camera_angle
	i = 0
	while i < 20 do
		event.swing_camera_control_to_angle(camera_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		i = i + 1
		vm.wait(1)
	end
	event.move_object_sequence(0, 0.0, 80.0, 0.0, 60)
	event.play_sound_effect(sound_effect, 0)
	i = 0
	while i < 60 do
		event.swing_camera_control_to_angle(camera_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		i = i + 1
		vm.wait(2)
	end
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Opens the minimap door of the automap door parts whose key point is visible, raises their gate parts by 80 units and disables the key point.
function underground_water_channel.restore_opened_key_door()
	local door_parts: s32 = 0
	local is_key_point_visible: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	event.initialize_event()
	door_parts = event.get_automap_door_parts() or door_parts
	event.attach_object_handle_to_function_point(0, door_parts, "key")
	is_key_point_visible = event.is_object_handle_visible(0) or is_key_point_visible
	if door_parts < 0 or is_key_point_visible == 0 then
		return
	end
	event.attach_object_handle_to_map_part_2(20, door_parts)
	do
		local out1, out2, out3 = event.get_object_handle_position(20)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(21, door_parts, "d01d01_00-m0")
	event.set_object_handle_position(21, 0.0, 80.0, 0.0)
	event.set_function_point_enabled(door_parts, "key", 0)
	event.attach_object_handle_to_map_part_3(22, door_parts, "d01da00-a")
	event.set_object_handle_position(22, 0.0, 80.0, 0.0)
	event.attach_object_handle_to_map_part_3(23, door_parts, "d01dv00-c")
	event.set_object_handle_visible(23, 0)
end

--- Walks the player forward to the triggered gate map part with a crossfaded camera and fades the camera sequence out.
function underground_water_channel.walk_to_gate()
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	local map_part: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event_x, event_y, event_z, event_angle =
		object.get_trigger_placement(event_x, event_y, event_z, event_angle)
	event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 11)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, -20.0, 100.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.move_object_sequence(0, 0.0, -20.0, 37.0, 40)
	event.move_object_sequence(0, 0.0, 0.0, 0.0, 40)
	event.move_object_sequence(0, 0.0, 0.0, -30.0, 40)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 120)
	event.set_object_sequence_motion(0, "立ち")
	event.delay_object_sequence_sound_track(0, 1)
	event.reset_object_sequence_dynamic_animation(0)
	event.start_crossfade(30)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(44.65, 9.01, 185.68)
	event.set_camera_sequence_look_at(9.77, 32.28, 31.49)
	wait.frames(60)
	event.set_object_handle_footstep_sound(0, 2)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(60)
	camera.wait_until_done()
	object.wait_until_done(0)
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_map_part_3(0, map_part, "d01w10_4-m0")
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
end

return underground_water_channel
