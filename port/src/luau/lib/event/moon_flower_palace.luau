--!strict
--- Door and loadout helpers for the Moon Flower Palace.

local vm = require("@lib/vm")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local moon_flower_palace = {}

--- Sets both characters' max HP and defence, tops up item 270 to 20 and equips preset items.
function moon_flower_palace.equip_preset_loadout()
	local owned_count: s32 = 0
	event.set_character_max_hp(0, 240)
	event.set_character_max_hp(1, 240)
	event.set_character_defence(0, 94)
	event.set_character_defence(1, 94)
	owned_count = event.get_item_count(270) or owned_count
	if owned_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - owned_count))
	end
	event.add_inventory_item(20)
	event.equip_character_item(0, 20)
	event.add_inventory_item(33)
	event.equip_character_item(0, 33)
	event.add_inventory_item(60)
	event.equip_character_item(1, 60)
	event.add_inventory_item(96)
	event.equip_character_item(1, 96)
end

--- Walks the player out of the room through the triggered door while its panels swing open and the exit effect plays.
function moon_flower_palace.exit_through_door(door_variant: s32)
	local door_parts: s32 = 0
	local panel_0_rotation_x: f32 = 0
	local panel_0_rotation_y: f32 = 0
	local panel_0_rotation_z: f32 = 0
	local panel_1_rotation_x: f32 = 0
	local panel_1_rotation_y: f32 = 0
	local panel_1_rotation_z: f32 = 0
	local panel_2_rotation_x: f32 = 0
	local panel_2_rotation_y: f32 = 0
	local panel_2_rotation_z: f32 = 0
	local panel_3_rotation_x: f32 = 0
	local panel_3_rotation_y: f32 = 0
	local panel_3_rotation_z: f32 = 0
	local panel_4_rotation_x: f32 = 0
	local panel_4_rotation_y: f32 = 0
	local panel_4_rotation_z: f32 = 0
	local exit_x: f32 = 0
	local exit_y: f32 = 0
	local exit_z: f32 = 0
	local facing_angle: f32 = 0
	local door_angle: f32 = 0
	local frame: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local sound_bank: s32 = 0
	event.initialize_event()
	event.start_background_file_loads_2("event/dng_inout/gekka_out.gltf", "snd2/sp/sp_037.sound.json")
	door_parts = event.get_triggered_event_data_2(9) or door_parts
	if door_variant == 0 then
		event.attach_object_handle_to_map_part_3(0, door_parts, "d06w09_3-m")
		event.attach_object_handle_to_map_part_3(1, door_parts, "d06w09_3-m1")
		event.attach_object_handle_to_map_part_3(2, door_parts, "d06w09_3-m2")
		event.attach_object_handle_to_map_part_3(3, door_parts, "d06w09_3-m3")
		event.attach_object_handle_to_map_part_3(4, door_parts, "d06w09_3-m4")
	elseif door_variant == 1 then
		event.attach_object_handle_to_map_part_3(0, door_parts, "d06w09_4-m")
		event.attach_object_handle_to_map_part_3(1, door_parts, "d06w09_4-m1")
		event.attach_object_handle_to_map_part_3(2, door_parts, "d06w09_4-m2")
		event.attach_object_handle_to_map_part_3(3, door_parts, "d06w09_4-m3")
		event.attach_object_handle_to_map_part_3(4, door_parts, "d06w09_4-m4")
	else
		event.attach_object_handle_to_map_part_3(0, door_parts, "d06w09_5-m")
		event.attach_object_handle_to_map_part_3(1, door_parts, "d06w09_5-m1")
		event.attach_object_handle_to_map_part_3(2, door_parts, "d06w09_5-m2")
		event.attach_object_handle_to_map_part_3(3, door_parts, "d06w09_5-m3")
		event.attach_object_handle_to_map_part_3(4, door_parts, "d06w09_5-m4")
	end
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		panel_0_rotation_x = out1 or panel_0_rotation_x
		panel_0_rotation_y = out2 or panel_0_rotation_y
		panel_0_rotation_z = out3 or panel_0_rotation_z
	end
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(1)
		panel_1_rotation_x = out1 or panel_1_rotation_x
		panel_1_rotation_y = out2 or panel_1_rotation_y
		panel_1_rotation_z = out3 or panel_1_rotation_z
	end
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(2)
		panel_2_rotation_x = out1 or panel_2_rotation_x
		panel_2_rotation_y = out2 or panel_2_rotation_y
		panel_2_rotation_z = out3 or panel_2_rotation_z
	end
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(3)
		panel_3_rotation_x = out1 or panel_3_rotation_x
		panel_3_rotation_y = out2 or panel_3_rotation_y
		panel_3_rotation_z = out3 or panel_3_rotation_z
	end
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(4)
		panel_4_rotation_x = out1 or panel_4_rotation_x
		panel_4_rotation_y = out2 or panel_4_rotation_y
		panel_4_rotation_z = out3 or panel_4_rotation_z
	end
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_character(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	door_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or door_angle
	event.call_command(1035, 8, exit_x, exit_y, exit_z, door_angle) -- retail: the handler rejects 5 arguments
	exit_x = vm.f32(vm.f32(vm.sin(door_angle) * 30.0) + exit_x)
	exit_z = vm.f32(vm.f32(vm.cos(door_angle) * 30.0) + exit_z)
	facing_angle = vm.f32(door_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.move_object_sequence(10, exit_x, exit_y, exit_z, 30)
	event.rotate_object_sequence(10, 0.0, facing_angle, 0.0, 30)
	event.set_object_sequence_motion(10, "歩き")
	event.delay_object_sequence_motion_track(10, 30)
	event.set_object_sequence_motion(10, "立ち")
	frame = 0
	while frame < 40 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		event.set_follow_camera_target(character_x, character_y, character_z)
		event.swing_camera_control_to_angle(door_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		frame = frame + 1
		vm.wait(1)
	end
	wait.background_load()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	exit_x = vm.f32(vm.f32(vm.sin(facing_angle) * 20.0) + exit_x)
	exit_z = vm.f32(vm.f32(vm.cos(facing_angle) * 20.0) + exit_z)
	event.load_character(5, "event/dng_inout/gekka_out.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, exit_x, exit_y, exit_z)
	event.set_character_rotation(12, 0.0, door_angle, 0.0)
	event.set_character_motion(12, "アウト", 6)
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_037.sound.json") or sound_bank
	event.play_sound_effect(sound_bank, 0)
	event.play_sound_effect(sound_bank, 2)
	event.rotate_object_sequence_eased(0, panel_0_rotation_x - 1.0, panel_0_rotation_y, panel_0_rotation_z, 20, 0, 1.0)
	event.rotate_object_sequence_eased(1, panel_1_rotation_x - 1.0, panel_1_rotation_y, panel_1_rotation_z, 20, 0, 1.0)
	event.rotate_object_sequence_eased(2, panel_2_rotation_x - 1.0, panel_2_rotation_y, panel_2_rotation_z, 20, 0, 1.0)
	event.rotate_object_sequence_eased(3, panel_3_rotation_x - 1.0, panel_3_rotation_y, panel_3_rotation_z, 20, 0, 1.0)
	event.rotate_object_sequence_eased(4, panel_4_rotation_x - 1.0, panel_4_rotation_y, panel_4_rotation_z, 20, 0, 1.0)
	object.wait_until_done(0)
	event.attach_object_handle_to_map_part_2(0, door_parts)
	event.get_object_handle_position(0)
	event.set_function_point_position(door_parts, "key1", 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06wa09_2-a")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06wv09_2-c")
	event.set_object_handle_visible(0, 0)
	event.delete_character(12)
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Restores the opened appearance of the automap door if its key function point is still active, and disables that point.
function moon_flower_palace.restore_opened_door()
	local door_parts: s32 = 0
	local key_point_visible: s32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	event.initialize_event()
	door_parts = event.get_automap_door_parts() or door_parts
	event.attach_object_handle_to_function_point(0, door_parts, "key1")
	key_point_visible = event.is_object_handle_visible(0) or key_point_visible
	if door_parts < 0 or key_point_visible == 0 then
		return
	end
	event.attach_object_handle_to_map_part_2(0, door_parts)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		door_x = out1 or door_x
		door_y = out2 or door_y
		door_z = out3 or door_z
	end
	event.open_minimap_door(door_x, door_y, door_z)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06d00_4-m")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06d00_3-m")
	event.set_object_handle_visible(0, 0)
	event.set_map_piece_character_motion(door_parts, "d06d00_2-m", "全停止", 4)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06da00_2-a")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06dv00_1-c")
	event.set_object_handle_visible(0, 0)
	event.set_function_point_enabled(door_parts, "key1", 0)
end

--- Plays the cutscene of the player running into the triggered door and fading out.
function moon_flower_palace.run_into_door()
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local door_angle: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	door_x, door_y, door_z, door_angle =
		object.get_trigger_placement(door_x, door_y, door_z, door_angle)
	event.set_event_world_coordinate(door_x, door_y, door_z, door_angle)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_footstep_sound(0, 21)
	event.set_object_sequence_motion(0, "走り")
	event.set_object_sequence_position(0, 0.0, 0.0, 40.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-96.52, 68.45, 152.82)
	event.set_camera_sequence_look_at(-32.44, 32.28, 0.35)
	event.move_object_sequence(0, 0.0, 0.0, -140.0, 60)
	wait.frames(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_character_motion(0, "立ち")
	wait.frames(60)
	event.finish_event()
end

--- Plays the key-turning unlock sequence on the triggered door while the follow camera swings to face it.
function moon_flower_palace.unlock_door_with_key()
	local door_parts: s32 = 0
	local sound_bank: s32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local camera_target_x: f32 = 0
	local camera_target_y: f32 = 0
	local camera_target_z: f32 = 0
	local camera_angle: f32 = 0
	local frame: s32 = 0
	door_parts = event.get_triggered_event_data_2(9) or door_parts
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_038.sound.json") or sound_bank
	event.attach_object_handle_to_map_part_2(0, door_parts)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		door_x = out1 or door_x
		door_y = out2 or door_y
		door_z = out3 or door_z
	end
	event.open_minimap_door(door_x, door_y, door_z)
	event.call_command(1035, 8, camera_target_x, camera_target_y, camera_target_z, camera_angle) -- retail: the handler rejects 5 arguments
	camera_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or camera_angle
	camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
	camera_angle = event.wrap_angle(camera_angle) or camera_angle
	event.play_sound_effect(sound_bank, 0)
	event.set_map_piece_character_motion(door_parts, "d06d00_2-m", "キー付く")
	frame = 0
	while frame < 30 do
		event.set_follow_camera_target(camera_target_x, camera_target_y + 40.0, camera_target_z)
		event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
		event.swing_camera_control_to_angle(camera_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		frame = frame + 1
		vm.wait(1)
	end
	event.play_sound_effect(sound_bank, 1)
	event.set_map_piece_character_motion(door_parts, "d06d00_2-m", "キー回転")
	wait.frames(44)
	event.set_map_piece_character_motion(door_parts, "d06d00_2-m", "キー止まる")
	wait.frames(10)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06d00_4-m")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06d00_3-m")
	event.set_object_handle_visible(0, 0)
	wait.frames(10)
	event.set_map_piece_character_motion(door_parts, "d06d00_2-m", "全回転")
	wait.frames(60)
	event.set_map_piece_character_motion(door_parts, "d06d00_2-m", "全停止")
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06da00_2-a")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d06dv00_1-c")
	event.set_object_handle_visible(0, 0)
	event.set_function_point_enabled(door_parts, "key1", 0)
	event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
	event.reset_follow_camera(0)
end

return moon_flower_palace
