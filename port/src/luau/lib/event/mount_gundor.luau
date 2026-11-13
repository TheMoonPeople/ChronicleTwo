--!strict
--- Event scenes shared by the floors of Mount Gundor.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local mount_gundor = {}

--- Does nothing and serves as an empty event hook.
function mount_gundor.noop() end

--- Plays a door opening either by launching the door away with a shaking camera and sound or by a white wind effect.
function mount_gundor.play_door_opening(use_wind: s32)
	local map_part: s32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local camera_angle: f32 = 0
	local frame: s32 = 0
	local door_sound_bank: s32 = 0
	local wind_sound_bank: s32 = 0
	local name_comparison: s32 = 0
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_map_part_2(0, map_part)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		door_x = out1 or door_x
		door_y = out2 or door_y
		door_z = out3 or door_z
	end
	event.open_minimap_door(door_x, door_y, door_z)
	event.call_command(1035, 8, target_x, target_y, target_z, camera_angle) -- retail: the handler rejects 5 arguments
	camera_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or camera_angle
	camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
	camera_angle = event.wrap_angle(camera_angle) or camera_angle
	frame = 0
	if use_wind == 0 then
		event.start_background_file_loads_1("snd2/sp/sp_026.sound.json")
		while frame < 30 do
			event.set_follow_camera_target(target_x, target_y + 40.0, target_z)
			event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
			event.swing_camera_control_to_angle(camera_angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			frame = frame + 1
			vm.wait(1)
		end
		wait.background_load()
		door_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_026.sound.json") or door_sound_bank
		event.play_sound_effect(door_sound_bank, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d05_3-m0")
		event.set_object_handle_visible(0, 1)
		event.set_function_point_enabled(map_part, "eff_d05ef-0", 0)
		wait.frames(10)
		event.clear_camera_sequence()
		event.set_map_piece_character_motion(map_part, "d05d05_2-m0", "飛ぶ")
		event.shake_camera_sequence(0.0, 0.2, 0.0, 80)
		wait.frames(20)
		event.play_sound_effect(door_sound_bank, 1)
		wait.frames(60)
		event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
		event.set_function_point_enabled(map_part, "door01", 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d05_2-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da05b-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv05-c")
		event.set_object_handle_visible(0, 0)
	else
		event.start_background_file_loads_2("event/dng_inout/whitewind.gltf", "snd2/sp/sp_027.sound.json")
		while frame < 30 do
			event.set_follow_camera_target(target_x, target_y + 40.0, target_z)
			event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
			event.swing_camera_control_to_angle(camera_angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			frame = frame + 1
			vm.wait(6)
		end
		wind_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_027.sound.json") or wind_sound_bank
		event.play_sound_effect(wind_sound_bank, 0)
		event.load_character(5, "event/dng_inout/whitewind.gltf", "info", 12)
		event.set_character_active(1, 12)
		event.set_character_position(12, target_x, target_y + 10.0, target_z)
		event.set_character_rotation(12, 0.0, camera_angle, 0.0)
		event.set_character_scale(12, 2.4, 2.4, 2.4)
		event.set_character_motion(12, "ホワイトウィンド", 6)
		event.set_function_point_enabled(map_part, "door01", 0)
		wait.frames(60)
		name_comparison = event.compare_map_parts_part_name(map_part, "door04") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 0)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door05") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 0)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door06") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 0)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door07") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 0)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door12") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 1)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door13") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 1)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door14") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 1)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door15") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 1)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door20") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 2)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door21") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 2)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door22") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 2)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door23") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 2)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door32") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 3)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door33") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 3)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door34") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 3)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door35") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 3)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door40") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 4)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door41") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 4)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door42") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 4)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door43") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 4)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door48") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 5)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door49") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 5)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door50") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 5)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door51") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 5)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door68") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 6)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door69") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 6)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door70") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 6)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door71") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 6)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door76") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 7)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door77") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 7)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door78") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 7)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door79") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 7)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door84") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 8)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door85") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 8)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door86") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 8)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door87") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 8)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door96") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 9)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door97") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 9)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door98") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 9)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door99") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 9)
		end
		event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
		event.delete_character(12)
		event.start_crossfade(30)
	end
	event.reset_follow_camera(0)
end

--- Plays either the jump over the lava with a thrown rock or the descent on a rope between floors.
function mount_gundor.play_floor_link_scene(scene_kind: s32)
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local map_part: s32 = 0
	local frame: s32 = 0
	local carry_frame_count: s32 = 0
	local rock_x: f32 = 0
	local rock_y: f32 = 0
	local rock_z: f32 = 0
	local item_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	local land_sound_bank: s32 = 0
	local rope_sound_bank: s32 = 0
	local world_x_2: f32 = 0
	local world_y_2: f32 = 0
	local world_z_2: f32 = 0
	local world_rotation_2: f32 = 0
	local playable_character_2: s32 = 0
	event.initialize_event()
	if scene_kind == 0 then
		world_x, world_y, world_z, world_rotation =
			object.get_trigger_placement(world_x, world_y, world_z, world_rotation)
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		sound_bank = event.get_sound_id(2) or sound_bank
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-74.77, 120.66, 51.54)
		event.set_camera_sequence_look_at(7.05, 109.71, -89.51)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.initialize_effect_manager(5, 1)
		event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
		event.create_effect_work_buffer(5, 2000)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 then
			event.load_character_motion_pack(5, "event/dng_inout/c01d04gkey.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/dng_inout/c02d04gkey.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_motion(0, "持ち上げ停止", 4)
		event.step_object_handle_motion(0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 80.0, -33.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "持ち上げ停止", 4, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "投げ", 2)
		event.queue_object_sequence_next_motion(0, "立ち")
		map_part = event.get_triggered_event_data_2(9) or map_part
		event.attach_object_handle_to_map_part_3(1, map_part, "d05w10_1-m0")
		event.set_object_handle_position(1, 0.0, 70.0, 0.0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "event/dng_inout/magumarock.gltf", "info", 12)
		event.set_character_active(1, 12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		frame = 0
		if playable_character == 0 then
			carry_frame_count = 47
		else
			carry_frame_count = 44
		end
		while frame < carry_frame_count do
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(0, "item")
				rock_x = out1 or rock_x
				rock_y = out2 or rock_y
				rock_z = out3 or rock_z
			end
			do
				local _, out2, _ = event.get_object_handle_rotation(0)
				item_angle = out2 or item_angle
			end
			if playable_character == 0 then
				item_angle = vm.f32(item_angle + vm.f32(1.57))
			else
				item_angle = vm.f32(item_angle - vm.f32(1.57))
			end
			item_angle = event.wrap_angle(item_angle) or item_angle
			rock_x = vm.f32(vm.f32(vm.sin(item_angle) * 6.0) + rock_x)
			rock_z = vm.f32(vm.f32(vm.cos(item_angle) * 6.0) + rock_z)
			event.set_object_handle_position(2, rock_x, rock_y, rock_z)
			frame = frame + 1
			vm.wait(1)
		end
		event.jump_object_sequence(2, 0.0, 94.0, -80.0, -0.3, 16)
		wait.frames(12)
		effect_x = vm.f32(vm.f32(vm.sin(world_rotation) * -70.0) + world_x)
		effect_y = vm.f32(world_y + 94.0)
		effect_z = vm.f32(vm.f32(vm.cos(world_rotation) * -70.0) + world_z)
		event.create_effect("足水パシャ")
		event.set_effect_first_vector(effect_x, effect_y, effect_z)
		wait.frames(2)
		event.play_sound_effect(sound_bank, 58)
		wait.frames(2)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "04ジャンプ", 6)
		event.queue_object_sequence_next_motion(0, "04着地", 6)
		event.queue_object_sequence_next_motion(0, "04着地L", 4)
		if playable_character == 0 then
			event.delay_object_sequence_position_track(0, 12)
			event.delay_object_sequence_sound_track(0, 26)
			event.play_object_sequence_sound(0, sound_bank, 4)
			event.delay_object_sequence_sound_track(0, 2)
			event.play_object_sequence_sound(0, sound_bank, 5)
		else
			event.delay_object_sequence_position_track(0, 6)
			event.delay_object_sequence_sound_track(0, 20)
			event.play_object_sequence_sound(0, sound_bank, 4)
			event.delay_object_sequence_sound_track(0, 2)
			event.play_object_sequence_sound(0, sound_bank, 5)
		end
		event.jump_object_sequence(0, 0.0, 101.0, -78.0, -0.3, 16)
		object.wait_until_done(0)
		event.start_background_file_loads_1("snd2/sp/sp_035.sound.json")
		vm.wait(7)
		wait.background_load()
		land_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_035.sound.json") or land_sound_bank
		event.play_sound_effect(land_sound_bank, 2)
		wait.frames(30)
		event.jump_object_sequence(0, 0.0, 201.0, -78.0, -0.4, 30)
		event.jump_object_sequence(1, 0.0, 160.0, 0.0, -0.4, 30)
		event.jump_object_sequence(2, 0.0, 194.0, -80.0, -0.4, 30)
		event.fade_out_screen(30)
		wait.frames(30)
		event.delete_character(12)
		event.delete_character_extension_packs(0)
		event.clear_effect_manager()
		event.set_character_visible(1, 1)
		event.set_character_visible(2, 1)
	else
		event.fade_out_screen(10)
		wait.frames(10)
		rope_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_036.sound.json") or rope_sound_bank
		world_x_2, world_y_2, world_z_2, world_rotation_2 =
			object.get_trigger_placement(world_x_2, world_y_2, world_z_2, world_rotation_2)
		event.set_event_world_coordinate(world_x_2, world_y_2, world_z_2, world_rotation_2)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character_2 = event.get_playable_character() or playable_character_2
		if playable_character_2 == 0 then
			event.load_character_motion_pack(5, "event/dng_inout/c01d05gkey.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/dng_inout/c02d05gkey.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 20.0, -40.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "ロープぶら下がり", 4, -1.0, 1)
		event.set_camera_sequence_position(-121.5, 37.81, 67.72)
		event.set_camera_sequence_look_at(-4.03, 39.46, -45.06)
		event.play_sound_effect(rope_sound_bank, 1)
		event.fade_in_screen(20)
		event.move_object_sequence_eased(0, 0.0, -80.0, -40.0, 40, 1, 1.0)
		wait.frames(40)
		event.fade_out_screen(30)
		wait.frames(30)
		event.delete_character_extension_packs(0)
	end
	event.finish_event()
end

--- Raises the platform map part with sound, or makes it appear with a crossfade.
function mount_gundor.raise_platform(use_crossfade: s32)
	local map_part: s32 = 0
	local camera_angle: f32 = 0
	local frame: s32 = 0
	local rise_sound_bank: s32 = 0
	local appear_sound_bank: s32 = 0
	event.initialize_event()
	map_part = event.get_triggered_event_data_2(9) or map_part
	if use_crossfade == 0 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05w10_1-m0")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.start_background_file_loads_1("snd2/sp/sp_035.sound.json")
		camera_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or camera_angle
		frame = 0
		while frame < 20 do
			event.swing_camera_control_to_angle(camera_angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			frame = frame + 1
			vm.wait(1)
		end
		vm.wait(2)
		wait.background_load()
		rise_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_035.sound.json") or rise_sound_bank
		event.play_sound_effect(rise_sound_bank, 1)
		event.move_object_sequence_eased(0, 0.0, 70.0, 0.0, 30, 2, 0.4)
		event.reset_follow_camera(0)
		object.wait_until_done(0)
		event.stop_sound_effect(rise_sound_bank, 1)
	else
		event.start_background_file_loads_1("snd2/sp/sp_036.sound.json")
		vm.wait(5)
		wait.background_load()
		appear_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_036.sound.json") or appear_sound_bank
		event.play_sound_effect(appear_sound_bank, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05w10_1-m0")
		event.set_object_handle_visible(0, 1)
		event.start_crossfade(10)
	end
	vm.wait(7)
	event.finish_event()
end

--- Puts the door of the automap door parts directly into its opened state for the current floor.
function mount_gundor.set_door_opened()
	local map_part: s32 = 0
	local is_visible: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local floor: s32 = 0
	local name_comparison: s32 = 0
	event.initialize_event()
	map_part = event.get_automap_door_parts() or map_part
	event.attach_object_handle_to_function_point(0, map_part, "door01")
	is_visible = event.is_object_handle_visible(0) or is_visible
	if map_part < 0 or is_visible == 0 then
		return
	end
	event.attach_object_handle_to_map_part_2(0, map_part)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	floor = event.get_dungeon_floor() or floor
	if floor >= 1 and floor < 16 and floor ~= 8 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d05_3-m0")
		event.set_object_handle_visible(0, 1)
		event.set_function_point_enabled(map_part, "eff_d05ef-0", 0)
		event.set_function_point_enabled(map_part, "door01", 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d05_2-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da05b-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv05-c")
		event.set_object_handle_visible(0, 0)
	else
		event.set_function_point_enabled(map_part, "door01", 0)
		name_comparison = event.compare_map_parts_part_name(map_part, "door04") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 0)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door05") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 0)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door06") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 0)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door07") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 0)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door12") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 1)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door13") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 1)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door14") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 1)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door15") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 1)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door20") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 2)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door21") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 2)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door22") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 2)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door23") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 2)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door32") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 3)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door33") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 3)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door34") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 3)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door35") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 3)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door40") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 4)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door41") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 4)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door42") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 4)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door43") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 4)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door48") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 5)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door49") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 5)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door50") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 5)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door51") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 5)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door68") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 6)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door69") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 6)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door70") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 6)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door71") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 6)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door76") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 7)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door77") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 7)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door78") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 7)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door79") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 7)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door84") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 8)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door85") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 8)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door86") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 8)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door87") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 8)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door96") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 9)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door97") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 9)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door98") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 9)
		end
		name_comparison = event.compare_map_parts_part_name(map_part, "door99") or name_comparison
		if name_comparison == 0 then
			mount_gundor.show_door_opened_parts(map_part, 9)
		end
	end
end

--- Shows the opened parts of the numbered door variant and hides its closed parts.
function mount_gundor.show_door_opened_parts(map_part: s32, door_variant: s32)
	if door_variant == 0 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d01_4-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d01_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da02-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv02-c")
		event.set_object_handle_visible(0, 0)
	end
	if door_variant == 1 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d09_4-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d09_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da02-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv02-c")
		event.set_object_handle_visible(0, 0)
	end
	if door_variant == 2 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d17_4-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d17_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da02-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv02-c")
		event.set_object_handle_visible(0, 0)
	end
	if door_variant == 3 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d33_1-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d29_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da33-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv33-c")
		event.set_object_handle_visible(0, 0)
	end
	if door_variant == 4 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d41_1-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d37_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da33-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv33-c")
		event.set_object_handle_visible(0, 0)
	end
	if door_variant == 5 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d49_1-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d45_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da33-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv33-c")
		event.set_object_handle_visible(0, 0)
	end
	if door_variant == 6 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d69_1-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d65_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da69-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv69-c")
		event.set_object_handle_visible(0, 0)
	end
	if door_variant == 7 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d77_1-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d73_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da69-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv69-c")
		event.set_object_handle_visible(0, 0)
	end
	if door_variant == 8 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d85_1-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d81_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da69-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv69-c")
		event.set_object_handle_visible(0, 0)
	end
	if door_variant == 9 then
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d97_1-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05d93_3-m0")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05da97-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, map_part, "d05dv97-c")
		event.set_object_handle_visible(0, 0)
	end
end

--- Prompts the player to use the star key on the door's star lock and plays the unlock scene when the key is used.
function mount_gundor.use_star_key_door()
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
				event.attach_object_handle_to_map_part_3(0, map_part, "d05wa13-a")
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

return mount_gundor
