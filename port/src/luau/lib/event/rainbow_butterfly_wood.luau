--!strict
--- Cutscenes, door mechanisms and voice bubbles of the Rainbow Butterfly Wood dungeon floors.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local rainbow_butterfly_wood = {}

--- Makes a spider web vanish without a swing animation, then opens the minimap door of the key door behind it and disables its key point.
function rainbow_butterfly_wood.clear_spider_web()
	local map_part: s32 = 0
	local web_x: f32 = 0
	local web_y: f32 = 0
	local web_z: f32 = 0
	local facing_angle: f32 = 0
	local i: s32 = 0
	local sound_effect: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.call_command(1035, 8, web_x, web_y, web_z, facing_angle) -- retail: the handler rejects 5 arguments
	facing_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or facing_angle
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.start_background_file_loads_2("event/dng_inout/kumonosu.gltf", "snd2/sp/sp_028.sound.json")
	facing_angle = vm.f32(facing_angle + vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	i = 0
	while i < 30 do
		event.set_follow_camera_target(web_x, web_y + 40.0, web_z)
		event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
		event.swing_camera_control_to_angle(facing_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		i = i + 1
		vm.wait(1)
	end
	wait.background_load()
	event.load_character(5, "event/dng_inout/kumonosu.gltf", "info", 12)
	event.set_character_position(12, web_x, web_y + 20.0, web_z)
	event.set_character_rotation(12, 0.0, facing_angle, 0.0)
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_028.sound.json") or sound_effect
	wait.frames(10)
	event.play_sound_effect(sound_effect, 0)
	event.set_character_active(1, 12)
	event.set_character_motion(12, "巣消える", 6)
	wait.frames(75)
	event.delete_character(12)
	event.reset_follow_camera(0)
	event.attach_object_handle_to_map_part_2(2, map_part)
	do
		local out1, out2, out3 = event.get_object_handle_position(2)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(3, map_part, "d02d05_1-m0")
	event.set_object_handle_visible(3, 0)
	event.attach_object_handle_to_map_part_3(4, map_part, "d02da05-a")
	event.set_object_handle_visible(4, 0)
	event.attach_object_handle_to_map_part_3(5, map_part, "d02dv05-c")
	event.set_object_handle_visible(5, 0)
	event.set_function_point_enabled(map_part, "key", 0)
	event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
	event.start_crossfade(30)
	wait.frames(30)
end

--- Swings a key at a spider web with the player, makes the web vanish, then opens the minimap door of the key door behind it and disables its key point.
function rainbow_butterfly_wood.cut_spider_web_with_key()
	local map_part: s32 = 0
	local web_x: f32 = 0
	local web_y: f32 = 0
	local web_z: f32 = 0
	local facing_angle: f32 = 0
	local rotation_y: f32 = 0
	local needs_turn: s32 = 0
	local playable_character: s32 = 0
	local i: s32 = 0
	local sound_effect: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.call_command(1035, 8, web_x, web_y, web_z, facing_angle) -- retail: the handler rejects 5 arguments
	facing_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or facing_angle
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_character(0, 0)
	do
		local _, out2, _ = event.get_object_handle_rotation(0)
		rotation_y = out2 or rotation_y
	end
	event.set_object_sequence_object(0, 0)
	needs_turn = event.compare_angles(rotation_y, facing_angle, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(0, 0.0, facing_angle, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.start_background_file_loads_4(
			"event/dng_inout/c01d02gkey.gltf",
			"event/dng_inout/d02nkey_h.gltf",
			"event/dng_inout/kumonosu.gltf",
			"snd2/sp/sp_028.sound.json"
		)
	else
		event.start_background_file_loads_4(
			"event/dng_inout/c02d02gkey.gltf",
			"event/dng_inout/d02nkey_h.gltf",
			"event/dng_inout/kumonosu.gltf",
			"snd2/sp/sp_028.sound.json"
		)
	end
	facing_angle = vm.f32(facing_angle + vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	i = 0
	while i < 30 do
		event.set_follow_camera_target(web_x, web_y + 40.0, web_z)
		event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
		event.swing_camera_control_to_angle(facing_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		i = i + 1
		vm.wait(1)
	end
	wait.background_load()
	event.load_character(5, "event/dng_inout/d02nkey_h.gltf", "info", 12)
	if playable_character == 0 then
		event.load_character_motion_pack(5, "event/dng_inout/c01d02gkey.gltf", "info", 0)
		event.attach_character_to_frame(0, "ef00", 12)
	else
		event.load_character_motion_pack(5, "event/dng_inout/c02d02gkey.gltf", "info", 0)
		event.attach_character_to_frame(0, "sword_hand", 12)
	end
	event.set_character_active(12)
	event.load_character(5, "event/dng_inout/kumonosu.gltf", "info", 13)
	event.set_character_position(13, web_x, web_y + 20.0, web_z)
	event.set_character_rotation(13, 0.0, facing_angle, 0.0)
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_028.sound.json") or sound_effect
	event.attach_object_handle_to_character(1, 1)
	event.set_object_handle_visible(1, 0)
	event.set_object_sequence_motion(0, "d02くもの巣取り", 2)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	wait.frames(20)
	event.play_sound_effect(sound_effect, 0)
	event.set_character_active(1, 13)
	event.set_character_motion(13, "巣消える", 6)
	object.wait_until_done(0)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.reset_follow_camera(0)
	event.attach_object_handle_to_character(1, 1)
	event.set_object_handle_visible(1, 1)
	event.attach_object_handle_to_map_part_2(2, map_part)
	do
		local out1, out2, out3 = event.get_object_handle_position(2)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(3, map_part, "d02d05_1-m0")
	event.set_object_handle_visible(3, 0)
	event.attach_object_handle_to_map_part_3(4, map_part, "d02da05-a")
	event.set_object_handle_visible(4, 0)
	event.attach_object_handle_to_map_part_3(5, map_part, "d02dv05-c")
	event.set_object_handle_visible(5, 0)
	event.set_function_point_enabled(map_part, "key", 0)
	event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
	event.start_crossfade(30)
	wait.frames(30)
end

--- Makes the player jump into the dungeon floor and fades the camera sequence out.
function rainbow_butterfly_wood.jump_into_room()
	local playable_character: s32 = 0
	local sound_effect: s32 = 0
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.start_background_file_loads_2("dungeon/chara/mints_01in.gltf", "snd2/sp/sp_031.sound.json")
	end
	if playable_character == 1 then
		event.start_background_file_loads_2("dungeon/chara/monica_01in.gltf", "snd2/sp/sp_031.sound.json")
	end
	vm.wait(1)
	wait.background_load()
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_031.sound.json") or sound_effect
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event_x, event_y, event_z, event_angle =
		object.get_trigger_placement(event_x, event_y, event_z, event_angle)
	event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 183.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_handle_footstep_sound(0, 3)
	if playable_character == 0 then
		event.load_character_motion_pack(5, "dungeon/chara/mints_01in.gltf", "info", 0)
	end
	if playable_character == 1 then
		event.load_character_motion_pack(5, "dungeon/chara/monica_01in.gltf", "info", 0)
	end
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-32.1, 44.57, 270.0)
	event.set_camera_sequence_look_at(7.73, 34.2, 52.8)
	event.move_camera_sequence_eased(-23.76, 44.57, 224.57, 7.73, 34.2, 52.8, 90, 1, 1.0)
	event.set_object_sequence_motion(0, "ジャンプ", 6)
	event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.3)
	event.queue_object_sequence_next_motion(0, "d01着地", 6)
	if playable_character == 0 then
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
	else
		event.queue_object_sequence_next_motion(0, "立ち", 4)
	end
	wait.frames(8)
	event.play_sound_effect(sound_effect, 2)
	event.jump_object_sequence(0, 0.0, 29.88, 127.4, -0.2, 26)
	wait.frames(26)
	event.play_sound_effect(sound_effect, 3)
	object.wait_until_done(0)
	wait.frames(5)
	event.move_object_sequence(0, 0.0, 27.83, 35.0, 90)
	event.set_object_sequence_motion(0, "歩き")
	wait.frames(60)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(30)
	event.set_object_handle_footstep_sound(0, -1)
	camera.wait_until_done()
end

--- Opens the minimap door of the automap door parts whose key point is visible, hides their gate parts and disables the key point.
function rainbow_butterfly_wood.restore_opened_key_door()
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
	event.attach_object_handle_to_map_part_2(22, door_parts)
	do
		local out1, out2, out3 = event.get_object_handle_position(22)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(23, door_parts, "d02d05_1-m0")
	event.set_object_handle_visible(23, 0)
	event.attach_object_handle_to_map_part_3(24, door_parts, "d02da05-a")
	event.set_object_handle_visible(24, 0)
	event.attach_object_handle_to_map_part_3(25, door_parts, "d02dv05-c")
	event.set_object_handle_visible(25, 0)
	event.set_function_point_enabled(door_parts, "key", 0)
end

--- Plays a voice stream line in a message bubble between the given speaker and listener and closes it when the voice ends.
function rainbow_butterfly_wood.speak_voice_bubble(voice_id: s32, speaker: s32, listener: s32)
	local voice_open_state: s32 = 0
	local voice_ready_state: s32 = 0
	event.open_voice_stream_wave(1, voice_id)
	while true do
		voice_open_state = event.get_voice_stream_open_state() or voice_open_state
		if voice_open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		voice_ready_state = event.get_voice_stream_open_state() or voice_ready_state
		if voice_ready_state == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.set_message_bubble_screen_slot(0, 0)
	event.open_message_window_2(0, -1)
	event.place_message_bubble(0, speaker, listener)
	event.play_voice_stream(1)
	message.wait_voice_or_button(0)
	message.close(0)
	event.close_voice_stream(1)
end

--- Plays the key activation motion, then tips the gate map part over by a quarter turn and lets it bounce into place.
function rainbow_butterfly_wood.topple_gate_with_key()
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	local sound_effect: s32 = 0
	local map_part: s32 = 0
	local camera_angle: f32 = 0
	local i: s32 = 0
	local gate_rotation_x: f32 = 0
	local angular_velocity: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_1("snd2/sp/sp_031.sound.json")
	vm.wait(1)
	wait.background_load()
	event_x, event_y, event_z, event_angle =
		object.get_trigger_placement(event_x, event_y, event_z, event_angle)
	event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_031.sound.json") or sound_effect
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_map_part_3(0, map_part, "d02w10_4-m0")
	event.attach_object_handle_to_map_part_3(1, map_part, "d02w10_3-m0")
	event.set_object_handle_visible(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.load_character(5, "event/dng/g01_gkey.gltf", "info", 12)
	event.set_character_active(12)
	event.attach_object_handle_to_character(2, 12)
	event.set_object_handle_position(2, 0.0, 0.0, 145.0)
	event.set_object_handle_motion(2, "発動", 5)
	event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
	camera_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or camera_angle
	i = 0
	while i < 10 do
		event.swing_camera_control_to_angle(camera_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		i = i + 1
		vm.wait(3)
	end
	event.play_sound_effect(sound_effect, 0)
	event.set_object_handle_motion(2, "発動", 6)
	i = 0
	while i < 20 do
		event.swing_camera_control_to_angle(camera_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		i = i + 1
		vm.wait(4)
	end
	wait.frames(20)
	event.set_object_handle_visible(0, 0)
	wait.frames(37)
	event.play_sound_effect(sound_effect, 1)
	angular_velocity = vm.f32(-0.001)
	gate_rotation_x = 0.0
	while gate_rotation_x > vm.f32(-1.57) do
		event.set_object_sequence_rotation(1, gate_rotation_x, event_angle, 0.0)
		angular_velocity = vm.f32(angular_velocity * vm.f32(1.06))
		gate_rotation_x = vm.f32(gate_rotation_x + angular_velocity)
		vm.wait(7)
	end
	event.play_sound_effect(sound_effect, 5)
	i = 0
	while i < 3 do
		while true do
			angular_velocity = vm.f32(angular_velocity * vm.f32(0.6))
			gate_rotation_x = vm.f32(gate_rotation_x - angular_velocity)
			event.set_object_sequence_rotation(1, gate_rotation_x, event_angle, 0.0)
			if angular_velocity > vm.f32(-0.001) then
				break
			else
				vm.wait(8)
			end
		end
		angular_velocity = vm.f32(angular_velocity + vm.f32(-0.001))
		while true do
			angular_velocity = vm.f32(angular_velocity * vm.f32(1.2))
			gate_rotation_x = vm.f32(gate_rotation_x + angular_velocity)
			event.set_object_sequence_rotation(1, gate_rotation_x, event_angle, 0.0)
			if gate_rotation_x < vm.f32(-1.57) then
				break
			else
				vm.wait(9)
			end
		end
		i = i + 1
	end
	wait.frames(10)
	event.delete_character(12)
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Shows a message when save flag 616 is unset, otherwise asks whether to use the star key and, when it is chosen from the item menu, plays the star gate unlock scene.
function rainbow_butterfly_wood.unlock_star_gate()
	local save_flag: s32 = 0
	local unlocked_flag: s32 = 0
	local trigger_state: s32 = 0
	local answer: s32 = 0
	local item: s32 = 0
	local map_part: s32 = 0
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	local sound_effect: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 1)
	character.reset_action_motion()
	save_flag = event.get_save_flag(616) or save_flag
	if save_flag == 0 then
		event.set_message_window_mode(0, 4)
		event.set_message_bubble_tail(0, 0)
		message.show_and_wait(0, 9, 8, 0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	unlocked_flag = event.get_local_event_flag(4) or unlocked_flag
	if unlocked_flag == 0 then
		trigger_state = event.get_triggered_event_data_2(6) or trigger_state
		if trigger_state == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			answer = message.ask_confirmation(0, 8, 5, 256, 208, answer)
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 1)
			if answer == 1 then
				trigger_state = 2
			end
		end
		if trigger_state == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait.frames(6)
			event.open_item_select_menu(0, 362)
			vm.wait(4)
			item = vmhost.used_item() or item
			if item == 362 then
				event.set_local_event_flag(4, 1)
				map_part = event.get_triggered_event_data_2(9) or map_part
				event.attach_object_handle_to_map_part_3(0, map_part, "star-m0")
				event.set_object_handle_visible(0, 0)
				event.attach_object_handle_to_map_part_3(0, map_part, "d02wa13-a")
				event.set_object_handle_visible(0, 0)
				event.set_function_point_enabled(map_part, "star", 0)
				event_x, event_y, event_z, event_angle =
					object.get_trigger_placement(event_x, event_y, event_z, event_angle)
				event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
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
				sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_014.sound.json") or sound_effect
				event.play_sound_effect(sound_effect, 0)
				event.set_object_sequence_scale(1, 20.0, 0.0, 20.0, 60)
				event.set_camera_sequence_position(-31.46, 57.29, 350.67)
				event.set_camera_sequence_look_at(4.66, 31.72, 192.41)
				event.set_character_visible(12, 0, 1, 0.02)
				wait.frames(60)
				event.delete_character(12)
			elseif item <= 0 then
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

return rainbow_butterfly_wood
