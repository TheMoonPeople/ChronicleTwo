--!strict
--- Event scenes shared by the floors of Ocean's Roar Cave.

local vm = require("@lib/vm")
local calc = vm.module("@lib/event/calc")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local oceans_roar_cave = {}

--- Plays the player walking from the cave floor into the elevated staging area, or back onto the floor, with a fade and a sound bank reload.
function oceans_roar_cave.cross_staging_area(return_to_floor: s32)
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local staging_music_volume: f32 = 0
	local staging_sound_bank: s32 = 0
	local floor_music_volume: f32 = 0
	local floor_sound_bank: s32 = 0
	event.start_crossfade(10)
	vm.wait(1)
	world_x, world_y, world_z, world_rotation =
		object.get_trigger_placement(world_x, world_y, world_z, world_rotation)
	event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "走り", 4)
	if return_to_floor == 0 then
		event.set_object_handle_footstep_sound(0, 16)
		event.set_camera_sequence_position(71.85, 16.72, -238.11)
		event.set_camera_sequence_look_at(10.53, 73.66, -36.93)
		event.set_object_sequence_position(0, 0.0, 30.68, -72.59)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 82.86, -9.67, 30)
		wait.frames(15)
		event.fade_out_screen(15)
		wait.frames(15)
		object.wait_until_done(0)
		event.set_object_handle_footstep_sound(0, 14)
		event.stop_all_sound_effects()
		event.load_map_sounds(4682)
		sound.load_event_sound_effects()
		staging_music_volume = vm.bits_float(event.get_battle_music_volume()) or staging_music_volume
		staging_sound_bank = event.get_event_sound_bank(4) or staging_sound_bank
		if staging_music_volume <= 0.0 then
			event.stop_sound_effect(staging_sound_bank, 0)
		else
			event.play_sound_effect(staging_sound_bank, 0)
			event.set_sound_effect_volume(staging_sound_bank, 0, staging_music_volume)
		end
		event.fade_in_screen(15)
		event.set_camera_sequence_position(0.0, 3253.14, -28.11)
		event.set_camera_sequence_look_at(0.0, 3230.0, 130.0)
		event.set_map_lighting(0)
		event.set_object_sequence_position(0, 0.0, 3157.0, 45.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 3200.0, 95.0, 20)
		event.move_object_sequence(0, 0.0, 3200.0, 130.0, 10)
		object.wait_until_done(0)
	else
		event.set_object_handle_footstep_sound(0, 14)
		event.set_camera_sequence_position(0.0, 3239.0, 220.74)
		event.set_camera_sequence_look_at(0.0, 3234.0, 130.0)
		event.set_object_sequence_position(0, 0.0, 3200.0, 94.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 3147.0, 53.0, 30)
		wait.frames(15)
		event.fade_out_screen(15)
		wait.frames(15)
		object.wait_until_done(0)
		event.set_object_handle_footstep_sound(0, 16)
		event.stop_all_sound_effects()
		event.load_map_sounds(4600)
		sound.load_event_sound_effects()
		floor_music_volume = vm.bits_float(event.get_battle_music_volume()) or floor_music_volume
		floor_sound_bank = event.get_event_sound_bank(4) or floor_sound_bank
		if floor_music_volume <= 0.0 then
			event.stop_sound_effect(floor_sound_bank, 0)
		else
			event.play_sound_effect(floor_sound_bank, 0)
			event.set_sound_effect_volume(floor_sound_bank, 0, floor_music_volume)
		end
		event.fade_in_screen(15)
		event.set_camera_sequence_position(-56.2, 52.61, -305.55)
		event.set_camera_sequence_look_at(1.04, 57.84, -87.81)
		event.set_map_lighting(8)
		event.set_object_sequence_position(0, 0.0, 50.06, -39.81)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 20.0, -73.92, 16)
		event.move_object_sequence(0, 0.0, 5.0, -130.0, 16)
		object.wait_until_done(0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Does nothing and serves as an empty event hook.
function oceans_roar_cave.noop() end

--- Pans the camera to the key door and plays its opening animation with sound.
function oceans_roar_cave.open_key_door()
	local door_angle: f32 = 0
	local map_part: s32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local door_rotation_x: f32 = 0
	local door_rotation_y: f32 = 0
	local door_rotation_z: f32 = 0
	local target_scale_x: f32 = 0
	local target_scale_y: f32 = 0
	local target_scale_z: f32 = 0
	local frame: s32 = 0
	local sound_bank: s32 = 0
	map_part = event.get_triggered_event_data_2(9) or map_part
	door_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or door_angle
	event.attach_object_handle_to_map_part_2(0, map_part)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		door_x = out1 or door_x
		door_y = out2 or door_y
		door_z = out3 or door_z
	end
	event.open_minimap_door(door_x, door_y, door_z)
	event.attach_object_handle_to_map_part_3(0, map_part, "d04d00_101-m1")
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		door_rotation_x = out1 or door_rotation_x
		door_rotation_y = out2 or door_rotation_y
		door_rotation_z = out3 or door_rotation_z
	end
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if calc.is_angle_within(door_angle, 0.0, 1.0) == 0 or calc.is_angle_within(door_angle, vm.f32(3.14), 1.0) == 0 then
		event.attach_object_handle_to_map_part_3(1, map_part, "d04d00_11-m")
		event.attach_object_handle_to_map_part_3(2, map_part, "d04d00_12-m")
		event.attach_object_handle_to_map_part_3(3, map_part, "d04d00_13-m")
		event.attach_object_handle_to_map_part_3(4, map_part, "d04d00_14-m")
		event.attach_object_handle_to_map_part_3(5, map_part, "d04d00_15-m")
		event.attach_object_handle_to_map_part_3(6, map_part, "d04d00_16-m")
		event.attach_object_handle_to_map_part_3(7, map_part, "d04d00_17-m")
		event.attach_object_handle_to_map_part_3(8, map_part, "d04d00_18-m")
		target_scale_x = 1.0
		target_scale_y = 1.0
		target_scale_z = 0.0
	else
		event.attach_object_handle_to_map_part_3(1, map_part, "d04d00_21-m")
		event.attach_object_handle_to_map_part_3(2, map_part, "d04d00_22-m")
		event.attach_object_handle_to_map_part_3(3, map_part, "d04d00_23-m")
		event.attach_object_handle_to_map_part_3(4, map_part, "d04d00_24-m")
		event.attach_object_handle_to_map_part_3(5, map_part, "d04d00_25-m")
		event.attach_object_handle_to_map_part_3(6, map_part, "d04d00_26-m")
		event.attach_object_handle_to_map_part_3(7, map_part, "d04d00_27-m")
		event.attach_object_handle_to_map_part_3(8, map_part, "d04d00_28-m")
		target_scale_x = 0.0
		target_scale_y = 1.0
		target_scale_z = 1.0
	end
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_3(9, map_part, "d04da05_2-a")
	event.set_object_handle_visible(9, 0)
	event.attach_object_handle_to_map_part_3(10, map_part, "d04da99-a0")
	event.set_object_handle_visible(10, 1)
	event.set_function_point_enabled(map_part, "dkey", 0)
	event.start_background_file_loads_1("snd2/sp/sp_034.sound.json")
	door_angle = vm.f32(door_angle - vm.f32(3.1415927))
	door_angle = event.wrap_angle(door_angle) or door_angle
	frame = 0
	while frame < 30 do
		event.swing_camera_control_to_angle(door_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		frame = frame + 1
		vm.wait(1)
	end
	wait.background_load()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_034.sound.json") or sound_bank
	event.play_sound_effect(sound_bank, 0)
	wait.frames(10)
	event.play_sound_effect(sound_bank, 1)
	event.rotate_object_sequence(0, door_rotation_x - vm.f32(0.52), door_rotation_y, door_rotation_z, 30)
	wait.frames(30)
	event.play_sound_effect(sound_bank, 2)
	event.set_function_point_enabled(map_part, "eff_d04f01-50", 0)
	event.set_function_point_enabled(map_part, "eff_d04f01-51", 0)
	event.set_object_sequence_scale(1, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(2, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(3, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(4, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(6, 1.0, 1.0, 1.0, 60)
	event.set_object_sequence_scale(7, target_scale_x, target_scale_y, target_scale_z, 60)
	event.set_object_sequence_scale(8, target_scale_x, target_scale_y, target_scale_z, 60)
	wait.frames(60)
	event.set_object_handle_visible(7, 0)
	event.set_object_handle_visible(8, 0)
	event.set_function_point_enabled(map_part, "func", 0)
	event.reset_follow_camera(0)
end

--- Plays the player walking across the elevated staging area while the dungeon map or the area logo fades in.
function oceans_roar_cave.play_floor_entry_walk(show_map: s32)
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local floor: s32 = 0
	local previous_floor: s32 = 0
	local language_code: s32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		event.stop_environment_music()
		event.load_map_sounds(4682)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			world_x = out1 or world_x
			world_y = out2 or world_y
			world_z = out3 or world_z
			world_rotation = out4 or world_rotation
		end
		world_x = vm.f32(world_x + 80.0)
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 18)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 3200.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		if show_map ~= 0 then
			floor = event.get_dungeon_floor() or floor
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			event.load_dungeon_map_display(5, 0, 3, floor, previous_floor)
			event.fade_dungeon_map(1, 30)
			event.set_dungeon_map_piece_moving(1)
		else
			language_code = event.get_language() or language_code
			if language_code == 0 then
				event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d03.json", 0)
			else
				event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d03_1.json", 0)
			end
			event.set_event_image_texture(0, "logo_d03")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 30)
		end
		event.set_camera_sequence_look_at(0.0, 3230.0, 120.0)
		event.set_camera_sequence_position(0.0, 3250.0, 0.0)
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 0.0, 3200.0, 120.0, 90)
		event.fade_in_screen(30)
		step = 2
		wait.frames(40)
		event.show_dungeon_status_bar(1)
		step = 3
		wait.frames(30)
		if show_map ~= 0 then
			event.fade_dungeon_map(0, 20)
		else
			event.fade_event_image(0, 0, 20)
		end
		step = 4
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		step = 5
		wait.frames(4)
	end, function(received: { any }): boolean
		if step <= 1 then
			world_x = vm.f32(world_x + 80.0)
			wait.frames_skipping(40)
		end
		if step <= 2 then
			wait.frames_skipping(30)
		end
		if step <= 3 then
			cutscene.skip_command(0)
		end
		if step <= 4 then
			wait.frames_skipping(4)
		end
		return true
	end)
	step = 6
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.show_dungeon_status_bar(1, 1.0)
	if show_map ~= 0 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	else
		event.delete_event_image(0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_position(0, 0.0, 3200.0, 120.0)
	step = 7
	vm.wait(7)
	event.reset_object_handle_dynamic_animation(0)
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.fade_in_screen(0)
	event.reset_follow_camera(0)
	event.set_dungeon_pause_flags(1, 0)
end

--- Plays the scene in which a rotating gate turns half a revolution and its lift rises before the player runs through.
function oceans_roar_cave.play_rotating_gate_scene()
	local sound_bank: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	local map_part: s32 = 0
	local target_rotation_x: f32 = 0
	local target_rotation_y: f32 = 0
	local target_rotation_z: f32 = 0
	local original_rotation_x: f32 = 0
	local original_rotation_y: f32 = 0
	local original_rotation_z: f32 = 0
	local lift_x: f32 = 0
	local lift_y: f32 = 0
	local lift_z: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(406, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or sound_bank
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			world_x = out1 or world_x
			world_y = out2 or world_y
			world_z = out3 or world_z
			world_rotation = out4 or world_rotation
		end
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		event.change_directory("event/e400/e406/")
		event.load_message_file(0, 5, "e406_1.txt")
		event.change_directory("")
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		map_part = event.get_triggered_event_data_2(9) or map_part
		if calc.is_angle_within(world_rotation, 0.0, 1.0) == 0 or calc.is_angle_within(world_rotation, vm.f32(3.14), 1.0) == 0 then
			event.attach_object_handle_to_map_part_3(2, map_part, "d04w10_2-m")
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.attach_object_handle_to_map_part_3(3, map_part, "d04w10_4-m")
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
		else
			event.attach_object_handle_to_map_part_3(2, map_part, "d04w10_5-m")
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.attach_object_handle_to_map_part_3(3, map_part, "d04w10_6-m")
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
		end
		event.attach_object_handle_to_map_part_3(1, map_part, "d04w10_3-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(0, 0.0, 0.0, -145.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 18)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_sound_reverb_enabled(0)
		event.enable_drama_skip()
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(51.16, 17.85, 158.67)
		event.set_camera_sequence_look_at(-12.94, 64.29, -60.21)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_bank, 1)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(2)
			target_rotation_x = out1 or target_rotation_x
			target_rotation_y = out2 or target_rotation_y
			target_rotation_z = out3 or target_rotation_z
		end
		do
			local out1, out2, out3 = event.copy_vector(target_rotation_x, target_rotation_y, target_rotation_z)
			original_rotation_x = out1 or original_rotation_x
			original_rotation_y = out2 or original_rotation_y
			original_rotation_z = out3 or original_rotation_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(1)
			lift_x = out1 or lift_x
			lift_y = out2 or lift_y
			lift_z = out3 or lift_z
		end
		if calc.is_angle_within(world_rotation, 0.0, 0.5) == 0 then
			target_rotation_z = vm.f32(original_rotation_z + vm.f32(3.1415927))
			target_rotation_z = event.wrap_angle(target_rotation_z) or target_rotation_z
		end
		if calc.is_angle_within(world_rotation, vm.f32(3.14), 0.5) == 0 then
			target_rotation_z = vm.f32(original_rotation_z - vm.f32(3.1415927))
			target_rotation_z = event.wrap_angle(target_rotation_z) or target_rotation_z
		end
		if calc.is_angle_within(world_rotation, vm.f32(1.57), 0.5) == 0 then
			target_rotation_x = vm.f32(original_rotation_x + vm.f32(3.1415927))
			target_rotation_x = event.wrap_angle(target_rotation_x) or target_rotation_x
		end
		if calc.is_angle_within(world_rotation, vm.f32(-1.57), 0.5) == 0 then
			target_rotation_x = vm.f32(original_rotation_x - vm.f32(3.1415927))
			target_rotation_x = event.wrap_angle(target_rotation_x) or target_rotation_x
		end
		event.rotate_object_sequence_eased(2, target_rotation_x, target_rotation_y, target_rotation_z, 40, 0, 0.5)
		event.rotate_object_sequence_eased(3, target_rotation_x, target_rotation_y, target_rotation_z, 40, 0, 0.5)
		step = 2
		object.wait_until_done(2)
		event.move_object_sequence_eased(1, lift_x, lift_y + 80.0, lift_z, 32, 1, 0.5)
		step = 3
		wait.frames(20)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 0.0, 0.0, 0.0, 30)
		step = 4
		object.wait_until_done(1)
		event.move_object_sequence_eased(1, lift_x, lift_y, lift_z, 32, 0, 0.5)
		step = 5
		object.wait_until_done(0)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_position_track(0, 30)
		event.move_object_sequence(0, 0.0, 0.0, 60.0, 60)
		event.delay_camera_sequence_angle_track(30)
		event.set_camera_sequence_follow_object(0, 0.0, 22.0, 0.0, 0.37, 0.0, 33.0)
		event.move_camera_sequence_angle_height_distance_eased(3.14, 0.0, 33.0, 200, 0, 1.0)
		step = 6
		object.wait_until_done(1)
		event.rotate_object_sequence_eased(2, original_rotation_x, original_rotation_y, original_rotation_z, 40, 0, 0.5)
		event.rotate_object_sequence_eased(3, original_rotation_x, original_rotation_y, original_rotation_z, 40, 0, 0.5)
		step = 7
		message.show_voiced_for(4060010, 400)
		step = 8
		camera.wait_until_done()
		event.release_camera_sequence_follow_object()
		event.move_camera_sequence_eased(0.06, 29.36, 27.0, 0.0, 51.38, 60.0, 60, 1, 1.0)
		step = 9
		wait.frames(60)
		event.fade_out_screen(30)
		step = 10
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 1 then
			local _ = character.check_move_skipping(world_rotation, 0.0, 1.0) == 0
			local _ = character.check_move_skipping(world_rotation, vm.f32(3.14), 1.0) == 0
			local _ = character.check_move_skipping(world_rotation, 0.0, 0.5) == 0
			target_rotation_z = vm.f32(original_rotation_z + vm.f32(3.1415927))
			local _ = character.check_move_skipping(world_rotation, vm.f32(3.14), 0.5) == 0
			target_rotation_z = vm.f32(original_rotation_z - vm.f32(3.1415927))
			local _ = character.check_move_skipping(world_rotation, vm.f32(1.57), 0.5) == 0
			target_rotation_x = vm.f32(original_rotation_x + vm.f32(3.1415927))
			local _ = character.check_move_skipping(world_rotation, vm.f32(-1.57), 0.5) == 0
			target_rotation_x = vm.f32(original_rotation_x - vm.f32(3.1415927))
			cutscene.skip_command(2)
		end
		if step <= 2 then
			wait.frames_skipping(20)
		end
		if step <= 3 then
			cutscene.skip_command(1)
		end
		if step <= 4 then
			cutscene.skip_command(0)
		end
		if step <= 5 then
			cutscene.skip_command(1)
		end
		if step <= 6 then
			message.show_voiced_for_skipping(4060010, 400)
		end
		if step <= 7 then
			wait.background_load_skipping()
		end
		if step <= 8 then
			wait.frames_skipping(60)
		end
		if step <= 9 then
			wait.frames_skipping(30)
		end
		return true
	end)
	step = 11
	vm.entry(11)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 1)
	event.set_sound_reverb_enabled(1)
	event.load_message_file(0, -1)
	event.finish_event()
end

--- Runs the player forward from the event point, turned around, and fades the screen out.
function oceans_roar_cave.run_forward_and_fade_out()
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation: f32 = 0
	event.initialize_event()
	world_x, world_y, world_z, world_rotation =
		object.get_trigger_placement(world_x, world_y, world_z, world_rotation)
	world_rotation = vm.f32(world_rotation + vm.f32(3.1415927))
	world_rotation = event.wrap_angle(world_rotation) or world_rotation
	event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_handle_footstep_sound(0, 18)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(56.71, 54.78, -129.16)
	event.set_camera_sequence_look_at(-1.53, 22.52, 48.82)
	event.move_object_sequence(0, 0.0, 0.0, 155.0, 40)
	event.set_object_sequence_motion(0, "走り", 4)
	event.delay_object_sequence_motion_track(0, 40)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(10)
	event.fade_out_screen(30)
	wait.frames(30)
	wait.frames(60)
	event.finish_event()
end

--- Puts the key door of the automap door parts directly into its opened state.
function oceans_roar_cave.set_key_door_opened()
	local map_part: s32 = 0
	local is_visible: s32 = 0
	local facing_angle: f32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local door_rotation_x: f32 = 0
	local door_rotation_y: f32 = 0
	local door_rotation_z: f32 = 0
	event.initialize_event()
	map_part = event.get_automap_door_parts() or map_part
	event.attach_object_handle_to_function_point(0, map_part, "dkey")
	is_visible = event.is_object_handle_visible(0) or is_visible
	do
		local _, out2, _ = event.get_object_handle_rotation(0)
		facing_angle = out2 or facing_angle
	end
	if map_part < 0 or is_visible == 0 then
		return
	end
	event.attach_object_handle_to_map_part_2(0, map_part)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		door_x = out1 or door_x
		door_y = out2 or door_y
		door_z = out3 or door_z
	end
	event.open_minimap_door(door_x, door_y, door_z)
	event.attach_object_handle_to_map_part_3(0, map_part, "d04d00_101-m1")
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		door_rotation_x = out1 or door_rotation_x
		door_rotation_y = out2 or door_rotation_y
		door_rotation_z = out3 or door_rotation_z
	end
	if calc.is_angle_within(facing_angle, 0.0, 1.0) == 0 or calc.is_angle_within(facing_angle, vm.f32(3.14), 1.0) == 0 then
		event.attach_object_handle_to_map_part_3(1, map_part, "d04d00_11-m")
		event.attach_object_handle_to_map_part_3(2, map_part, "d04d00_12-m")
		event.attach_object_handle_to_map_part_3(3, map_part, "d04d00_13-m")
		event.attach_object_handle_to_map_part_3(4, map_part, "d04d00_14-m")
		event.attach_object_handle_to_map_part_3(5, map_part, "d04d00_15-m")
		event.attach_object_handle_to_map_part_3(6, map_part, "d04d00_16-m")
		event.attach_object_handle_to_map_part_3(7, map_part, "d04d00_17-m")
		event.attach_object_handle_to_map_part_3(8, map_part, "d04d00_18-m")
	else
		event.attach_object_handle_to_map_part_3(1, map_part, "d04d00_21-m")
		event.attach_object_handle_to_map_part_3(2, map_part, "d04d00_22-m")
		event.attach_object_handle_to_map_part_3(3, map_part, "d04d00_23-m")
		event.attach_object_handle_to_map_part_3(4, map_part, "d04d00_24-m")
		event.attach_object_handle_to_map_part_3(5, map_part, "d04d00_25-m")
		event.attach_object_handle_to_map_part_3(6, map_part, "d04d00_26-m")
		event.attach_object_handle_to_map_part_3(7, map_part, "d04d00_27-m")
		event.attach_object_handle_to_map_part_3(8, map_part, "d04d00_28-m")
	end
	event.attach_object_handle_to_map_part_3(9, map_part, "d04da05_2-a")
	event.set_object_handle_visible(9, 0)
	event.attach_object_handle_to_map_part_3(10, map_part, "d04da99-a0")
	event.set_object_handle_visible(10, 1)
	event.set_object_handle_rotation(0, door_rotation_x - vm.f32(0.52), door_rotation_y, door_rotation_z)
	event.set_function_point_enabled(map_part, "eff_d04f01-50", 0)
	event.set_function_point_enabled(map_part, "eff_d04f01-51", 0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(2, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(3, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(4, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(5, 1.0, 1.0, 1.0)
	event.set_object_handle_scale(6, 1.0, 1.0, 1.0)
	event.set_object_handle_visible(7, 0)
	event.set_object_handle_visible(8, 0)
	event.set_function_point_enabled(map_part, "func", 0)
	event.set_function_point_enabled(map_part, "dkey", 0)
end

--- Pans the camera to the rotating gate, turns it half a revolution and raises its lift.
function oceans_roar_cave.turn_rotating_gate()
	local sound_bank: s32 = 0
	local map_part: s32 = 0
	local gate_angle: f32 = 0
	local camera_angle: f32 = 0
	local frame: s32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	event.initialize_event()
	event.start_background_file_loads_1("snd2/sp/sp_033.sound.json")
	vm.wait(1)
	wait.background_load()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or sound_bank
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	map_part = event.get_triggered_event_data_2(9) or map_part
	gate_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or gate_angle
	event.attach_object_handle_to_map_part_3(0, map_part, "d04w10_3-m")
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if calc.is_angle_within(gate_angle, 0.0, 1.0) == 0 or calc.is_angle_within(gate_angle, vm.f32(3.14), 1.0) == 0 then
		event.attach_object_handle_to_map_part_3(1, map_part, "d04w10_2-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, map_part, "d04w10_4-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	else
		event.attach_object_handle_to_map_part_3(1, map_part, "d04w10_5-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, map_part, "d04w10_6-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	end
	event.play_sound_effect(sound_bank, 2)
	camera_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or camera_angle
	frame = 0
	while frame < 30 do
		event.swing_camera_control_to_angle(camera_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		frame = frame + 1
		vm.wait(3)
	end
	event.play_sound_effect(sound_bank, 0)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(1)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	if calc.is_angle_within(gate_angle, 0.0, 1.0) == 0 then
		vector_z = vm.f32(vector_z + vm.f32(3.1415927))
		vector_z = event.wrap_angle(vector_z) or vector_z
	end
	if calc.is_angle_within(gate_angle, vm.f32(3.14), 1.0) == 0 then
		vector_z = vm.f32(vector_z - vm.f32(3.1415927))
		vector_z = event.wrap_angle(vector_z) or vector_z
	end
	if calc.is_angle_within(gate_angle, vm.f32(1.57), 1.0) == 0 then
		vector_x = vm.f32(vector_x + vm.f32(3.1415927))
		vector_x = event.wrap_angle(vector_x) or vector_x
	end
	if calc.is_angle_within(gate_angle, vm.f32(-1.57), 1.0) == 0 then
		vector_x = vm.f32(vector_x - vm.f32(3.1415927))
		vector_x = event.wrap_angle(vector_x) or vector_x
	end
	event.rotate_object_sequence_eased(1, vector_x, vector_y, vector_z, 40, 0, 0.5)
	event.rotate_object_sequence_eased(2, vector_x, vector_y, vector_z, 40, 0, 0.5)
	object.wait_until_done(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	event.move_object_sequence_eased(0, vector_x, vector_y + 80.0, vector_z, 32, 1, 0.5)
	object.wait_until_done(0)
	event.finish_event()
end

--- Prompts the player to use the star key on the door's star lock and plays the unlock scene when the key is used.
function oceans_roar_cave.use_star_key_door()
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
				event.attach_object_handle_to_map_part_3(0, map_part, "d04wa10_2-a")
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
				event.set_object_handle_position(1, 0.0, 0.0, -48.0)
				event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
				event.set_object_handle_scale(1, 20.0, 20.0, 20.0)
				sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_014.sound.json") or sound_bank
				event.play_sound_effect(sound_bank, 0)
				event.set_object_sequence_scale(1, 20.0, 0.0, 20.0, 60)
				event.set_camera_sequence_position(-84.12, 64.7, 158.88)
				event.set_camera_sequence_look_at(23.95, 31.72, -13.93)
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

return oceans_roar_cave
