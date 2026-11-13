--!strict
--- Dungeon system script for the d04 stage covering floor loading, rotating gates, star sockets, area transitions and the Sphida golf shot minigame.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local dungeon_system_scripts = require("@lib/event/dungeon_system_scripts")
local dungeon_system_scripts_camera = require("@lib/event/dungeon_system_scripts_camera")
local dungeon_system_scripts_cutscene = require("@lib/event/dungeon_system_scripts_cutscene")
local dungeon_system_scripts_item = require("@lib/event/dungeon_system_scripts_item")
local dungeon_system_scripts_message = require("@lib/event/dungeon_system_scripts_message")
local dungeon_system_scripts_minigame = require("@lib/event/dungeon_system_scripts_minigame")
local dungeon_system_scripts_object = require("@lib/event/dungeon_system_scripts_object")
local map = require("@lib/event/map")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local visual_effect = require("@lib/event/visual_effect")
local wait = require("@lib/event/wait")

--- Plays the floor entry cutscene in which the title logo fades in while the gate map parts rotate open and the player walks in.
local function play_floor_intro_cutscene()
	local intro_sound_bank: s32 = 0
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local point_rotation: f32 = 0
	local language_code: s32 = 0
	local gate_map_part: s32 = 0
	local rotation_x: f32 = 0
	local rot_y: f32 = 0
	local rotation_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_dungeon_pause_flags(32, 1)
		intro_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or intro_sound_bank
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			point_x = out1 or point_x
			point_y = out2 or point_y
			point_z = out3 or point_z
			point_rotation = out4 or point_rotation
		end
		event.set_event_world_coordinate(point_x, point_y, point_z, point_rotation)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, -145.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 18)
		language_code = event.get_language() or language_code
		if language_code == 0 then
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d01.json", 0)
		else
			event.load_event_image_3(5, "dungeon/image/s_title/usa/logo_d03.img", 0)
		end
		event.set_event_image_texture(0, "logo_d03")
		event.set_event_image_source_rect(0, 0, 0, 384, 128)
		event.set_event_image_screen_rect(0, -24, 300, 384, 128)
		event.set_event_image_color(0, 128, 128, 128, 0)
		event.set_event_image_visible(1, 0)
		event.fade_event_image(0, 1, 60)
		gate_map_part = event.get_triggered_event_data_2(9) or gate_map_part
		if calc.is_angle_within(point_rotation, 0.0, 1.0) == 0 or calc.is_angle_within(point_rotation, vm.f32(3.14), 1.0) == 0 then
			event.attach_object_handle_to_map_part_3(1, gate_map_part, "d04w10_2-m")
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.attach_object_handle_to_map_part_3(2, gate_map_part, "d04w10_4-m")
			event.set_object_handle_visible(2, 1)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
		else
			event.attach_object_handle_to_map_part_3(1, gate_map_part, "d04w10_5-m")
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.attach_object_handle_to_map_part_3(2, gate_map_part, "d04w10_6-m")
			event.set_object_handle_visible(2, 1)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
		end
		event.attach_object_handle_to_map_part_3(3, gate_map_part, "d04w10_3-m")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		at = 2
		dungeon_system_scripts.fade_status_bar(0, 1)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(51.16, 17.85, 158.67)
		event.set_camera_sequence_look_at(-12.94, 64.29, -60.21)
		event.fade_in_screen(30)
		event.play_sound_effect(intro_sound_bank, 1)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(1)
			rotation_x = out1 or rotation_x
			rot_y = out2 or rot_y
			rotation_z = out3 or rotation_z
		end
		do
			local out1, out2, out3 = event.copy_vector(rotation_x, rot_y, rotation_z)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		if calc.is_angle_within(point_rotation, 0.0, 0.5) == 0 then
			rotation_z = vm.f32(vector_z + vm.f32(3.1415927))
			rotation_z = event.wrap_angle(rotation_z) or rotation_z
		end
		if calc.is_angle_within(point_rotation, vm.f32(3.14), 0.5) == 0 then
			rotation_z = vm.f32(vector_z - vm.f32(3.1415927))
			rotation_z = event.wrap_angle(rotation_z) or rotation_z
		end
		if calc.is_angle_within(point_rotation, vm.f32(1.57), 0.5) == 0 then
			rotation_x = vm.f32(vector_x + vm.f32(3.1415927))
			rotation_x = event.wrap_angle(rotation_x) or rotation_x
		end
		if calc.is_angle_within(point_rotation, vm.f32(-1.57), 0.5) == 0 then
			rotation_x = vm.f32(vector_x - vm.f32(3.1415927))
			rotation_x = event.wrap_angle(rotation_x) or rotation_x
		end
		event.rotate_object_sequence_eased(1, rotation_x, rot_y, rotation_z, 40, 0, 0.5)
		event.rotate_object_sequence_eased(2, rotation_x, rot_y, rotation_z, 40, 0, 0.5)
		at = 3
		object.wait_until_done(1)
		event.move_object_sequence_eased(3, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		at = 4
		wait.for_frame_count(20)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 0.0, 0.0, 0.0, 30)
		at = 5
		object.wait_until_done(3)
		event.move_object_sequence_eased(3, pos_x, pos_y, pos_z, 32, 0, 0.5)
		at = 6
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 30)
		event.delay_object_sequence_position_track(0, 30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 0.0, 0.0, 40.0, 40)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.fade_event_image(0, 0, 60)
		at = 7
		object.wait_until_done(3)
		event.rotate_object_sequence_eased(1, vector_x, vector_y, vector_z, 40, 0, 0.5)
		event.rotate_object_sequence_eased(2, vector_x, vector_y, vector_z, 40, 0, 0.5)
		at = 8
		dungeon_system_scripts.fade_status_bar(1, 50)
		at = 9
		object.wait_until_done(1)
	end, function(received: { any }): boolean
		if at <= 1 then
			dungeon_system_scripts.ramp_ratio(0, 1)
		end
		if at <= 2 then
			local _ = character.check_move_skipping(point_rotation, 0.0, 1.0) == 0
			local _ = character.check_move_skipping(point_rotation, vm.f32(3.14), 1.0) == 0
			local _ = character.check_move_skipping(point_rotation, 0.0, 0.5) == 0
			rotation_z = vm.f32(vector_z + vm.f32(3.1415927))
			local _ = character.check_move_skipping(point_rotation, vm.f32(3.14), 0.5) == 0
			rotation_z = vm.f32(vector_z - vm.f32(3.1415927))
			local _ = character.check_move_skipping(point_rotation, vm.f32(1.57), 0.5) == 0
			rotation_x = vm.f32(vector_x + vm.f32(3.1415927))
			local _ = character.check_move_skipping(point_rotation, vm.f32(-1.57), 0.5) == 0
			rotation_x = vm.f32(vector_x - vm.f32(3.1415927))
			cutscene.skip_command(1)
		end
		if at <= 3 then
			wait.skip_frame_count(20)
		end
		if at <= 4 then
			cutscene.skip_command(3)
		end
		if at <= 5 then
			cutscene.skip_command(0)
		end
		if at <= 6 then
			cutscene.skip_command(3)
		end
		if at <= 7 then
			dungeon_system_scripts.ramp_ratio(1, 50)
		end
		if at <= 8 then
			cutscene.skip_command(1)
		end
		return true
	end)
	at = 10
	vm.entry(10)
	event.stop_sound_effect(intro_sound_bank, 1)
	event.fade_in_screen(0)
	at = 11
	dungeon_system_scripts.fade_status_bar(1, 1)
	event.delete_event_image(0)
	event.set_object_handle_position(0, 0.0, 0.0, 60.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_footstep_sound(0, -1)
	event.set_camera_sequence_look_at(0.0, 30.0, 60.0)
	event.set_camera_sequence_position(0.0, 35.0, -40.0)
	if calc.is_angle_within(point_rotation, 0.0, 1.0) == 0 or calc.is_angle_within(point_rotation, vm.f32(3.14), 1.0) == 0 then
		event.attach_object_handle_to_map_part_3(1, gate_map_part, "d04w10_2-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, gate_map_part, "d04w10_4-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	else
		event.attach_object_handle_to_map_part_3(1, gate_map_part, "d04w10_5-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, gate_map_part, "d04w10_6-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	end
	event.attach_object_handle_to_map_part_3(3, gate_map_part, "d04w10_3-m")
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(1, vector_x, vector_y, vector_z)
	event.set_object_sequence_rotation(2, vector_x, vector_y, vector_z)
	event.set_object_sequence_position(3, pos_x, pos_y, pos_z)
	at = 12
	vm.wait(12)
	event.reset_object_handle_dynamic_animation(0)
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.reset_follow_camera(0)
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Loads the map, treasure boxes and monsters for the selected floor of the stage (or the boss map for floor 3) and plays the floor intro.
local function load_dungeon_floor()
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_local_event_flag(0, 0)
		event.set_local_event_flag(1, 0)
		event.set_local_event_flag(2, 0)
		event.set_local_event_flag(3, 0)
		event.set_local_event_flag(4, 0)
		event.set_local_event_flag(5, 0)
		event.open_dungeon_floor_map(3)
		at = 1
		vm.wait(1)
		event.set_event_projection(524.9)
		do
			local _, out2, out3, _ = event.get_menu_results_4()
			stage_id = out2 or stage_id
			floor_number = out3 or floor_number
		end
		stage_id = 3
		event.set_dungeon_stage_id(stage_id)
		event.set_dungeon_floor(floor_number)
		dungeon.increment_floor_counter(stage_id, floor_number)
		if floor_number == 3 then
			event.load_dungeon_map("d05b01")
			event.fade_in_screen(1)
			return
		end
		if floor_number == 2 then
			event.load_dungeon_map("d04f02", "d04f02", 8)
			event.place_treasure_box_at_event_point(-1)
			event.load_dungeon_monster(0)
			event.place_dungeon_monster(-1)
			at = 2
			play_floor_intro_cutscene()
		else
			event.load_dungeon_map("d04f01", "d01f01")
			event.place_treasure_box_at_event_point(-1)
			event.load_dungeon_monster(0)
			event.place_dungeon_monster(-1)
			at = 3
			play_floor_intro_cutscene()
		end
		sound.load_event_sound_effects()
		return
	end, function(received: { any })
		if at <= 1 then
			stage_id = 3
			dungeon.increment_floor_counter_skipping(stage_id, floor_number)
			return 0
		end
		if at <= 3 then
			if at <= 2 then
				at = 3
				play_floor_intro_cutscene()
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					return
				end)
			end
			wait.background_load_skipping()
			return 0
		end
		return nil
	end)
end

--- Handles examining a rotating gate by asking to use the key item, opening the gate or offering to descend to the next floor.
local function interact_with_rotating_gate(gate_flag_index: s32)
	local gate_opened: s32 = 0
	local trigger_kind: s32 = 0
	local was_confirmed: s32 = 0
	local item: s32 = 0
	local active_chr_no: s32 = 0
	local selected_option: any = 0
	local stage_id: s32 = 0
	local current_floor: s32 = 0
	local next_floor: s32 = 0
	local is_e3_build: s32 = 0
	event.set_character_motion(0, "立ち")
	gate_opened = event.get_local_event_flag(gate_flag_index) or gate_opened
	event.set_dungeon_pause_flags(1, 1)
	if gate_opened == 0 then
		trigger_kind = event.get_triggered_event_data_2(6) or trigger_kind
		if trigger_kind == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			was_confirmed = dungeon_system_scripts_message.show_and_count_frames(0, 3, 5, 256, 208, was_confirmed)
			event.set_message_window_mode(0, 7)
			event.set_message_draw_speed(0, 0)
			if was_confirmed == 1 then
				trigger_kind = 2
			end
			event.finish_event()
		end
		if trigger_kind == 2 then
			event.open_use_item_menu(342)
			vm.wait(2)
			item = vmhost.used_item() or item
			if item == 342 then
				event.set_local_event_flag(gate_flag_index, 1)
				dungeon_system_scripts_object.open_rotating_gate()
			elseif item <= 0 then
				event.finish_event()
			else
				dungeon_system_scripts_cutscene.play_miss_gesture()
			end
		end
	else
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.initialize_event()
			character.set_idle_motion()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				dungeon_system_scripts_message.show_and_wait(0, 20, 5, 256, 208)
			else
				dungeon_system_scripts_message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		end
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		selected_option = dungeon_system_scripts_message.ask_option(0, 10, 8, 256, 208, 2, 1)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		if selected_option == 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			current_floor = event.get_dungeon_floor() or current_floor
			next_floor = event.get_dungeon_next_floor(current_floor, gate_flag_index) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, current_floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			dungeon_system_scripts_cutscene.run_away_and_fade_out()
			is_e3_build = event.is_e3_version() or is_e3_build
			if is_e3_build == 1 then
				event.set_scene_exit_flag(1)
				return
			else
				event.finish_event()
				load_dungeon_floor()
			end
		else
			event.finish_event()
		end
	end
	event.set_dungeon_pause_flags(1, 0)
end

--- Handles examining the star socket by using the star key item to unlock it and show the star appearing.
local function interact_with_star_socket()
	local socket_used: s32 = 0
	local trigger_kind: s32 = 0
	local item: s32 = 0
	local socket_map_part: s32 = 0
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_dungeon_pause_flags(1, 1)
	socket_used = event.get_local_event_flag(4) or socket_used
	if socket_used == 0 then
		trigger_kind = event.get_triggered_event_data_2(6) or trigger_kind
		if trigger_kind == 2 then
			event.open_use_item_menu(342)
			vm.wait(1)
			item = vmhost.used_item() or item
			if item == 362 then
				event.set_local_event_flag(4, 1)
				socket_map_part = event.get_triggered_event_data_2(9) or socket_map_part
				event.attach_object_handle_to_map_part_3(0, socket_map_part, "star-m0")
				event.set_object_handle_visible(0, 0)
				event.attach_object_handle_to_map_part_3(0, socket_map_part, "d02wa13-a")
				event.set_object_handle_visible(0, 0)
				event.set_function_point_enabled(socket_map_part, "star", 0)
				world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
					object.get_trigger_placement(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
				event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
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
				event.set_object_sequence_scale(1, 20.0, 0.0, 20.0, 60)
				event.set_camera_sequence_position(-31.46, 57.29, 350.67)
				event.set_camera_sequence_look_at(4.66, 31.72, 192.41)
				event.set_character_visible(12, 0, 1, 0.02)
				wait.for_frame_count(60)
				event.delete_character(12)
			elseif item <= 0 then
				event.finish_event()
			else
				dungeon_system_scripts_cutscene.play_miss_gesture()
			end
		end
		if trigger_kind == 1 then
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			dungeon_system_scripts_message.show_and_wait(0, 7, 8, 256, 208)
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
		end
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Moves the player between the two areas with a fade, then switches the environment music, battle music sound and map lighting.
local function play_area_transition(area_flag: s32)
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	local battle_bgm_vol: f32 = 0
	local battle_music_sound: s32 = 0
	local battle_bgm_vol_2: f32 = 0
	local battle_music_sound_2: s32 = 0
	event.start_crossfade(10)
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
		object.get_trigger_placement(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "走り", 4)
	if area_flag == 0 then
		event.set_camera_sequence_position(71.85, 16.72, -238.11)
		event.set_camera_sequence_look_at(10.53, 73.66, -36.93)
		event.set_object_sequence_position(0, 0.0, 30.68, -72.59)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 82.86, -9.67, 30)
		wait.for_frame_count(15)
		event.fade_out_screen(15)
		object.wait_until_done(0)
		event.stop_environment_music()
		event.load_environment_sound_bank(141)
		event.play_environment_music(0)
		sound.load_event_sound_effects()
		battle_bgm_vol = vm.bits_float(event.get_battle_music_volume()) or battle_bgm_vol
		battle_music_sound = event.get_event_sound_bank(4) or battle_music_sound
		if battle_bgm_vol <= 0.0 then
			event.stop_sound_effect(battle_music_sound, 0)
		else
			event.play_sound_effect(battle_music_sound, 0)
			event.set_sound_effect_volume(battle_music_sound, 0, battle_bgm_vol)
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
		event.set_camera_sequence_position(0.0, 3239.0, 220.74)
		event.set_camera_sequence_look_at(0.0, 3234.0, 130.0)
		event.set_object_sequence_position(0, 0.0, 3200.0, 94.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 3147.0, 53.0, 30)
		wait.for_frame_count(15)
		event.fade_out_screen(15)
		object.wait_until_done(0)
		event.stop_environment_music()
		event.load_environment_sound_bank(140)
		event.play_environment_music(0)
		sound.load_event_sound_effects()
		battle_bgm_vol_2 = vm.bits_float(event.get_battle_music_volume()) or battle_bgm_vol_2
		battle_music_sound_2 = event.get_event_sound_bank(4) or battle_music_sound_2
		if battle_bgm_vol_2 <= 0.0 then
			event.stop_sound_effect(battle_music_sound_2, 0)
		else
			event.play_sound_effect(battle_music_sound_2, 0)
			event.set_sound_effect_volume(battle_music_sound_2, 0, battle_bgm_vol_2)
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
	event.set_object_sequence_motion(0, "立ち")
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Lets the player rotate and tilt the shot aim until the shot is confirmed or cancelled, returning the cancel result and the aim.
local function aim_sphida_shot(aim_angle: f32, pitch_degrees: f32, texture_block: s32)
	local cancelled: s32 = 0
	local idle_timer: s32 = 0
	local ready_pose_timer: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local angle: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local new_pitch_degrees: f32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local at: number = 0
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
			new_pitch_degrees = pitch_degrees
			new_pitch_degrees = vm.f32(new_pitch_degrees + stick_y)
			if new_pitch_degrees <= 5.0 then
				new_pitch_degrees = 5.0
			end
			if new_pitch_degrees >= 30.0 then
				new_pitch_degrees = 30.0
			end
			aim_angle = rotation_y
			pitch_degrees = new_pitch_degrees
			event.set_sphida_carry_angle(vm.f32(pitch_degrees * vm.f32(3.1415927)) / 180.0)
			angle = vm.f32(aim_angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			event.set_camera_control_rotation(angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			dungeon_system_scripts_minigame.draw_shot_guide(aim_angle, pitch_degrees, texture_block)
			if wait.is_button_pressed(32) ~= 0 then
				event.set_character_motion(0, "かまえ")
				cancelled = 0
				break
			elseif wait.is_button_pressed(64) ~= 0 then
				cancelled = 1
				break
			else
				at = 1
				vm.wait(1)
			end
		end
		visual_effect.hide_all_sprites()
		at = 2
		vm.wait(2)
		return cancelled, aim_angle, pitch_degrees
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				visual_effect.hide_all_sprites_skipping()
			end
			return cancelled, aim_angle, pitch_degrees
		end
		return nil, aim_angle, pitch_degrees
	end)
end

--- Runs the swing power gauge, reading the stick spin and the button presses, and returns the shot power, adjusted aim angle and spin.
local function run_power_gauge(shot_power: f32, unused_value: any, aim_angle: f32, spin_x: f32, spin_y: f32, se_id: s32, shot_result: s32)
	local angle: f32 = 0
	local stick_x: f32 = 0
	local stick_y: f32 = 0
	local code: s32 = 0
	local marker_slot: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local random_offset: f32 = 0
	local at: number = 0
	return vm.guard(function()
		angle = vm.f32(aim_angle - vm.f32(3.1415927))
		angle = event.wrap_angle(angle) or angle
		marker_slot = 0
		code = -10
		event.reset_sphida_power_gauge()
		event.start_sphida_power_gauge()
		while code == -10 do
			event.set_camera_control_rotation(angle)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			do
				local out1, out2 = event.get_analog_sticks_2()
				stick_x = out1 or stick_x
				stick_y = out2 or stick_y
			end
			event.set_sphida_spin_mark_position(stick_x, stick_y)
			if (if marker_slot == 0 then wait.is_button_pressed(64) else 0) ~= 0 then
				event.set_sphida_spin_mark_position(0.0, 0.0)
				event.reset_sphida_power_gauge()
				return 1, shot_power, aim_angle, spin_x, spin_y, shot_result
			end
			if wait.is_button_pressed(32) ~= 0 then
				event.advance_sphida_power_gauge()
				at = 1
				vm.wait(1)
				code = event.get_sphida_power_gauge_result() or code
				if marker_slot == 0 or code ~= -10 then
					event.play_sound_effect(se_id, 0)
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
				at = 2
				vm.wait(2)
			end
			code = event.get_sphida_power_gauge_result() or code
		end
		if code == 5 then
			event.set_sphida_spin_mark_position(0.0, 0.0)
			event.reset_sphida_power_gauge()
			return 1, shot_power, aim_angle, spin_x, spin_y, shot_result
		end
		shot_power = event.get_sphida_shot_power() or shot_power
		if code == 4 then
			shot_power = vm.f32(shot_power * 0.0)
		end
		if code == -3 then
			shot_power = vm.f32(shot_power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			aim_angle = vm.f32(vm.f32(aim_angle - vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * shot_power)
		end
		if code == 3 then
			shot_power = vm.f32(shot_power * vm.f32(0.4))
			random_offset = event.get_random_number(0.2) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.1))
			aim_angle = vm.f32(vm.f32(aim_angle + vm.f32(0.4)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.2)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.2)) * shot_power)
		end
		if code == -2 then
			shot_power = vm.f32(shot_power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			aim_angle = vm.f32(vm.f32(aim_angle - vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * shot_power)
		end
		if code == 2 then
			shot_power = vm.f32(shot_power * vm.f32(0.8))
			random_offset = event.get_random_number(0.05) or random_offset
			random_offset = vm.f32(random_offset - vm.f32(0.025))
			aim_angle = vm.f32(vm.f32(aim_angle + vm.f32(0.1)) + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.4)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.4)) * shot_power)
		end
		if code == -1 then
			shot_power = vm.f32(shot_power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			aim_angle = vm.f32(aim_angle - random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * shot_power)
		end
		if code == 1 then
			shot_power = vm.f32(shot_power * 1.0)
			random_offset = event.get_random_number(0.01) or random_offset
			aim_angle = vm.f32(aim_angle + random_offset)
			stick_x = vm.f32(vm.f32(stick_x * vm.f32(0.6)) * shot_power)
			stick_y = vm.f32(vm.f32(stick_y * vm.f32(0.6)) * shot_power)
		end
		if code == 0 then
			shot_power = vm.f32(shot_power * vm.f32(1.1))
			stick_x = vm.f32(stick_x * shot_power)
			stick_y = vm.f32(stick_y * shot_power)
		end
		shot_result = code
		aim_angle = event.wrap_angle(aim_angle) or aim_angle
		spin_x = stick_x
		spin_y = stick_y
		at = 3
		wait.for_frame_count(10)
		return 0, shot_power, aim_angle, spin_x, spin_y, shot_result
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				local _ = wait.is_button_pressed_skipping(32)
				local _ = marker_slot == 0
				marker_slot = 1
			end
			return 1, shot_power, aim_angle, spin_x, spin_y, shot_result
		end
		if at <= 3 then
			return 0, shot_power, aim_angle, spin_x, spin_y, shot_result
		end
		return nil, shot_power, aim_angle, spin_x, spin_y, shot_result
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Waits for a button press and finishes when no other event number is given.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	wait.until_button_pressed(32)
	event.finish_event()
end

--- Examines the first rotating gate.
function script.examine_rotating_gate_0()
	interact_with_rotating_gate(0)
end
script[300] = script.examine_rotating_gate_0

--- Examines the second rotating gate when the edit analysis found changes.
function script.edit_analyze_changed()
	interact_with_rotating_gate(1)
end

--- Examines the third rotating gate.
function script.examine_rotating_gate_2()
	interact_with_rotating_gate(2)
end
script[320] = script.examine_rotating_gate_2

--- Examines the fourth rotating gate.
function script.examine_rotating_gate_3()
	interact_with_rotating_gate(3)
end
script[330] = script.examine_rotating_gate_3

--- Event 340, which map data, a script or the engine runs by number.
script.interact_with_star_socket = interact_with_star_socket
script[340] = script.interact_with_star_socket

--- Toggles the area flag and plays the transition between the two areas.
function script.toggle_area_transition()
	local flag_value: s32 = 0
	event.initialize_event()
	flag_value = event.get_local_event_flag(5) or flag_value
	if flag_value == 0 then
		event.set_local_event_flag(5, 1)
		event.set_dungeon_pause_flags(32, 0)
	else
		event.set_local_event_flag(5, 0)
		event.set_dungeon_pause_flags(32, 1)
	end
	play_area_transition(flag_value)
end
script[345] = script.toggle_area_transition

script.load_dungeon_floor = load_dungeon_floor
script[1000] = script.load_dungeon_floor

--- Plays the treasure box opening, choosing between the normal item pickup and the clown chest event.
function script.treasure_box()
	local active_chr_no: s32 = 0
	local move_type: s32 = 0
	local item_id: s32 = 0
	local clown_chest_id: s32 = 0
	event.initialize_event()
	event.start_crossfade(30)
	event.set_character_active(0, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		move_type = event.get_player_move_type() or move_type
		if move_type == 1 then
			event.set_character_motion(0, "立ち-足")
		end
		if move_type == 2 then
			event.set_character_motion(0, "立ち-キャタピラ")
		end
	end
	do
		local out1, out2 = event.get_treasure_box_item()
		item_id = out1 or item_id
		clown_chest_id = out2 or clown_chest_id
	end
	if clown_chest_id <= -1 then
		dungeon_system_scripts.play_treasure_get(item_id)
	else
		dungeon_system_scripts_item.play_clown_chest_event(item_id, clown_chest_id)
	end
end

--- Plays the random circle event in which a spinning coin lands on a good or bad side and applies the resulting effect.
function script.random_circle()
	local active_chr_no: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local sound_bank: s32 = 0
	local ring_motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local circle_id: s32 = 0
	local tick: s32 = 0
	local spin_speed: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local camera_facing_angle: f32 = 0
	local minimum_spin_ticks: s32 = 0
	local angle: f32 = 0
	local random_roll: s32 = 0
	local flip_threshold: s32 = 0
	local bright_rate: f32 = 0
	local effect_id: s32 = 0
	local result: f32 = 0
	event.initialize_event()
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.set_idle_motion()
		if active_chr_no == 2 then
			dungeon_system_scripts_message.show_and_wait(0, 22, 8, 0, 0)
		else
			dungeon_system_scripts_message.show_and_wait(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.get_direction_angle(pos_x, pos_y, pos_z, character_x, character_y, character_z) or yaw
		character_x = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		character_y = pos_y
		character_z = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.set_character_position(0, character_x, character_y, character_z)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	character.set_idle_motion()
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	wait.background_load()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or sound_bank
	event.start_background_file_loads_2("event/dng/ring.gltf", "event/dng/randomcoin.gltf")
	vm.wait(5)
	wait.background_load()
	ring_motion_frame = event.get_random_circle_motion_frame() or ring_motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "event/dng/ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, pos_x_2, pos_y_2, pos_z_2)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, ring_motion_frame)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "event/dng/randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	coin_angle = event.get_random_number(6.2831855) or coin_angle
	coin_angle = vm.f32(coin_angle - vm.f32(3.1415927))
	coin_angle = event.wrap_angle(coin_angle) or coin_angle
	event.set_character_rotation(13, 0.0, coin_angle, 0.0)
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	tick = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		if tick == 10 then
			event.play_sound_effect(sound_bank, 0)
		end
		if tick == 30 then
			dungeon_system_scripts_message.open_stop_hint()
		end
		if (if tick >= 30 then wait.get_button_state(0) else 0) ~= 0 or tick > 300 then
			event.stop_sound_effect(sound_bank, 0)
			event.play_sound_effect(sound_bank, 3)
			vm.wait(7)
			break
		else
			tick = tick + 1
			vm.wait(8)
		end
	end
	message.close_second_window()
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	camera_facing_angle = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or camera_facing_angle
	minimum_spin_ticks = 0
	minimum_spin_ticks = event.get_random_number_int(10) or minimum_spin_ticks
	minimum_spin_ticks = vm.i32(minimum_spin_ticks + 4)
	tick = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		vm.wait(9)
		if tick >= minimum_spin_ticks then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			angle = camera_facing_angle
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 0
				break
			end
			angle = vm.f32(camera_facing_angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 1
				break
			end
		end
		tick = vm.i32(tick + 1)
	end
	wait.for_frame_count(20)
	random_roll = event.get_random_number_int(10) or random_roll
	if random_roll < 6 then
		random_roll = event.get_random_number_int(10) or random_roll
		if circle_id == 0 then
			flip_threshold = 2
		else
			flip_threshold = 4
		end
		if random_roll < flip_threshold then
			camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(3.14))
			camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
			event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 8)
			if circle_id == 0 then
				circle_id = 1
			else
				circle_id = 0
			end
			wait.for_frame_count(10)
		else
			random_roll = event.get_random_number_int(10) or random_roll
			if random_roll < 1 then
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(3.14))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 6)
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(1.57))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 3)
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(1.57))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 3)
				wait.for_frame_count(20)
			end
		end
	end
	camera_facing_angle = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or camera_facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, camera_facing_angle, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	bright_rate = 1.0
	tick = 0
	effect_id = event.get_random_circle_effect(circle_id) or effect_id
	if circle_id == 0 then
		event.play_sound_effect(sound_bank, 1)
		while tick < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate + vm.f32(0.03))
			tick = tick + 1
			vm.wait(13)
		end
		dungeon_system_scripts_message.show_and_wait(0, 2310, 8, 0, 0)
		result = event.apply_random_circle_effect(effect_id) or result
		if effect_id == 1 then
			dungeon_system_scripts_message.show_and_wait(0, 2311, 8, 0, 0)
		end
		if effect_id == 2 then
			dungeon_system_scripts_message.show_and_wait(0, 2312, 8, 0, 0)
		end
		if effect_id == 3 then
			dungeon_system_scripts_message.show_and_wait(0, 2313, 8, 0, 0)
		end
		if effect_id == 4 then
			event.place_treasure_box(pos_x_2, pos_y_2, pos_z_2, camera_facing_angle, 294)
			dungeon_system_scripts_message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_bank, 2)
		while tick < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate - vm.f32(0.03))
			tick = tick + 1
			vm.wait(19)
		end
		dungeon_system_scripts_message.show_and_wait(0, 2320, 8, 0, 0)
		result = event.apply_random_circle_effect(effect_id) or result
		if effect_id == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				dungeon_system_scripts_message.show_and_wait(0, 2321, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				dungeon_system_scripts_message.show_and_wait(0, 2322, 8, 0, 0)
			end
		end
		if effect_id == 6 then
			if active_chr_no == 0 then
				dungeon_system_scripts_message.show_and_wait(0, 2323, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				dungeon_system_scripts_message.show_and_wait(0, 2324, 8, 0, 0)
			end
			if active_chr_no == 2 then
				dungeon_system_scripts_message.show_and_wait(0, 2325, 8, 0, 0)
			end
		end
		if effect_id == 8 then
			dungeon_system_scripts_message.show_and_wait(0, 2326, 8, 0, 0)
		end
		if effect_id == 9 then
			dungeon_system_scripts_message.show_and_wait(0, 2327, 8, 0, 0)
		end
		if effect_id == 10 then
			dungeon_system_scripts_message.show_and_wait(0, 2328, 8, 0, 0)
		end
		if effect_id == 11 then
			dungeon_system_scripts_message.show_and_wait(0, 2329, 8, 0, 0)
		end
		if effect_id == 12 then
			dungeon_system_scripts_message.show_and_wait(0, 2330, 8, 0, 0)
		end
	end
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if effect_id == 1 then
		event.spawn_pull_items(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the cutscene of the character using the geostone and receiving the geostone item.
function script.geostone()
	local active_chr_no: s32 = 0
	local original_x: f32 = 0
	local original_y: f32 = 0
	local original_z: f32 = 0
	local sound_bank: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local facing_angle: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	event.initialize_event()
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.set_idle_motion()
		if active_chr_no == 2 then
			dungeon_system_scripts_message.show_and_wait(0, 22, 8, 0, 0)
		else
			dungeon_system_scripts_message.show_and_wait(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		original_x = out1 or original_x
		original_y = out2 or original_y
		original_z = out3 or original_z
	end
	if active_chr_no == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_bank
	event.set_dungeon_pause_flags(17, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		character_x = out1 or character_x
		character_y = out2 or character_y
		character_z = out3 or character_z
	end
	event.copy_vector(character_x, character_y, character_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(character_y + 18.0)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if active_chr_no == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	character_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + pos_x_2)
	character_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + pos_z_2)
	event.set_character_position(0, character_x, character_y, character_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_chr_no == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(character_x, character_y + 18.0, character_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, character_x, character_y + 36.0, character_z)
	end
	if active_chr_no == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(character_x, character_y + 18.0, character_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		pos_x_3 = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + character_x)
		pos_y_3 = vm.f32(character_y + 18.0)
		pos_z_3 = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + character_z)
		event.set_character_position(12, pos_x_3, pos_y_3, pos_z_3)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait.for_frame_count(16)
	event.play_sound_effect(sound_bank, 0)
	wait.for_frame_count(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait.for_frame_count(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	facing_angle = event.get_direction_angle(character_x, character_y, character_z, pos_x, pos_y, pos_z) or facing_angle
	event.set_character_rotation(12, 0.0, facing_angle, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait.for_frame_count(20)
	event.play_sound_effect(sound_bank, 1)
	object.wait_until_done(0)
	dungeon_system_scripts_message.show_item_obtained(358, 1)
	event.start_crossfade(10)
	if active_chr_no == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, original_x, original_y, original_z)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.detach_geostone_from_character_frame()
	event.set_geostone_placed(0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_character(12)
	event.finish_event()
end

--- Shows a talk bubble for the monster that the player talks to.
function script.monster_talk()
	local monster_index: s32 = 0
	local talk_id: s32 = 0
	do
		local out1, out2 = event.get_monster_talk_data_2()
		monster_index = out1 or monster_index
		talk_id = out2 or talk_id
	end
	dungeon_system_scripts_message.show_talk_bubble(monster_index, vm.i32(talk_id + 1000))
end

--- Event 1200, which map data, a script or the engine runs by number.
script[1200] = dungeon_system_scripts_cutscene.play_robot_breakdown_event

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = dungeon_system_scripts_cutscene.play_extermination_clear_event

--- Runs one Sphida golf shot from aiming and the power gauge through the ball physics to the result.
function script.sphida_shot()
	local tex_bank: s32 = 0
	local sound_bank: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local rotation_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local launch_angle: f32 = 0
	local shot_power: f32 = 0
	local club_spin_factor: f32 = 0
	local level: s32 = 0
	local roll_drift_x: f32 = 0
	local curve_spin: f32 = 0
	local roll_drift_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local scored_goal: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local high_altitude_y: f32 = 0
	local fall_limit_y: f32 = 0
	local out_of_bounds: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local probe_x: f32 = 0
	local probe_y: f32 = 0
	local probe_z: f32 = 0
	local travel_remaining: f32 = 0
	local distance: f32 = 0
	local collision_id: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_kind: s32 = 0
	local tick: s32 = 0
	local pin_col: s32 = 0
	local ball_col: s32 = 0
	local pin_distance: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local segment_distance: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local relocate_answer: any = 0
	vm.wait(1)
	event.initialize_event()
	character.set_idle_motion()
	event.set_character_motion(0, "立ち")
	if dungeon_system_scripts.prepare_sphida_club() ~= 0 then
		event.finish_event()
		return
	end
	event.show_dungeon_status_bar(0.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_3(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf"
	)
	vm.wait(3)
	wait.background_load()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.get_sphida_texture_bank() or tex_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_bank
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_character_position(0)
		character_x = out1 or character_x
		character_y = out2 or character_y
		character_z = out3 or character_z
	end
	ball_x, ball_y, ball_z, aim_angle = dungeon_system_scripts_minigame.place_character_at_ball(ball_x, ball_y, ball_z, aim_angle)
	dungeon_system_scripts_camera.place_camera_behind_character(aim_angle)
	event.set_sphida_status_panel_visible(1)
	launch_angle = 12.5
	event.set_sphida_carry_angle(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power, club_spin_factor, level = minigame.get_equipped_club_definition(shot_power, club_spin_factor, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		roll_drift_x = out1 or roll_drift_x
		curve_spin = out2 or curve_spin
		roll_drift_z = out3 or roll_drift_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_angle, launch_angle = aim_sphida_shot(aim_angle, launch_angle, tex_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_character_position(0, character_x, character_y, character_z)
			dungeon_system_scripts_minigame.end_round(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, shot_power, aim_angle, curve_spin, roll_drift_x, level = run_power_gauge(shot_power, tex_bank, aim_angle, curve_spin, roll_drift_x, sound_bank, level)
		if t1 == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	scored_goal = 0
	if level ~= 1 and level ~= -1 and level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if level == 2 or level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if level == 3 or level == -3 then
			event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
		end
		event.attach_object_handle_to_sprite(18, 0)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
		event.delay_object_sequence_color_track(18, 20)
		event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
		wait.for_frame_count(10)
	end
	if shot_power <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.for_frame_count(25)
		if level ~= 4 then
			event.play_sound_effect(sound_bank, 3)
		end
	elseif shot_power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.for_frame_count(34)
		event.play_sound_effect(sound_bank, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.for_frame_count(39)
		if level == 0 then
			event.play_sound_effect(sound_bank, 12)
		else
			event.play_sound_effect(sound_bank, 1)
		end
	end
	if level == 4 then
		wait.for_frame_count(50)
		dungeon_system_scripts_minigame.end_when_par_exhausted(sound_bank)
		event.set_character_position(0, character_x, character_y, character_z)
		dungeon_system_scripts_minigame.end_round(0)
		return
	end
	if level == 0 then
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_event_sprite_position(1, 256, 278)
		event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
		event.set_event_sprite_size(1, 266, 42)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_scale(1, 10, 10, 10)
		event.attach_object_handle_to_sprite(19, 1)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
		event.set_object_sequence_scale(19, 1, 1, 1, 18)
		event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
		event.delay_object_sequence_color_track(19, 30)
		event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
	end
	shot_power = minigame.scale_by_club_power(shot_power)
	launch_angle = vm.f32(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power = vm.f32(shot_power - vm.f32(shot_power * launch_angle))
	velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(shot_power * vm.cos(launch_angle)))
	velocity_y = vm.f32(shot_power * vm.sin(launch_angle))
	velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(shot_power * vm.cos(launch_angle)))
	curve_spin = vm.f32(vm.f32(curve_spin * vm.f32(3.1415927)) / 2.0)
	roll_drift_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_spin_factor) * roll_drift_x) * vm.f32(0.4))
	roll_drift_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_spin_factor) * roll_drift_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	high_altitude_y = 180.0
	fall_limit_y = -50.0
	out_of_bounds = 0
	level = 0
	sound_cooldown = 0
	tick = 0
	while true do
		if ball_y >= high_altitude_y then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (tick + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_id = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_id
			if level == 1 and collision_id >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (tick + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + roll_drift_x)
				velocity_z = vm.f32(velocity_z + roll_drift_z)
				roll_drift_x = vm.f32(roll_drift_x * vm.f32(0.8))
				roll_drift_z = vm.f32(roll_drift_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (tick + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if curve_spin ~= 0.0 then
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			launch_angle = vm.f32(launch_angle + curve_spin)
			launch_angle = event.wrap_angle(launch_angle) or launch_angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(launch_angle) / 10.0) * club_spin_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(launch_angle) / 10.0) * club_spin_factor))
		end
		distance = event.get_vector_length(roll_drift_x, 0.0, roll_drift_z) or distance
		if distance > vm.f32(0.01) then
			speed = event.get_vector_length(roll_drift_x, 0.0, roll_drift_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + roll_drift_x, previous_y, previous_z + roll_drift_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, launch_angle, rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, launch_angle, rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, launch_angle, rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, launch_angle, rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		travel_remaining = speed
		launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
		probe_x = vm.f32(vm.sin(vm.f32(launch_angle - vm.f32(1.5707964))) * 3.0)
		probe_z = vm.f32(vm.cos(vm.f32(launch_angle - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			ball_x - probe_x,
			ball_y,
			ball_z - probe_z,
			vm.f32(ball_x + probe_x) + probe_x,
			ball_y,
			vm.f32(ball_z + probe_z) + probe_z
		)
		do
			local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = event.normalize_vector(probe_x, probe_y, probe_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = event.scale_vector(probe_x, probe_y, probe_z, 3.0)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2 =
				event.get_segment_collision_10(0, previous_x, previous_y, previous_z, ball_x + probe_x, ball_y + probe_y, ball_z + probe_z, 0)
			collision_id = out1 or collision_id
			surface_kind = out2 or surface_kind
		end
		if collision_id >= 0 and surface_kind == 1 then
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 11)
				sound_cooldown = 20
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + probe_x, ball_y + probe_y, ball_z + probe_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_id = out7 or collision_id
		end
		while collision_id >= 0 do
			curve_spin = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 6)
				sound_cooldown = 20
			end
			do
				local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.normalize_vector(velocity_x, velocity_y, velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.scale_vector(velocity_x, velocity_y, velocity_z, 3.0)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.add_vectors(hit_x, hit_y, hit_z, velocity_x, velocity_y, velocity_z)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
			end
			do
				local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			distance = event.get_vector_length(previous_x, previous_y, previous_z) or distance
			distance = vm.f32(travel_remaining - distance)
			if distance <= 0.0 then
				break
			else
				travel_remaining = distance
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				if velocity_y < 0.0 and normal_y > 0.0 then
					velocity_x = vm.f32(roll_drift_x * 2.0)
					velocity_y = 0.0
					velocity_z = vm.f32(roll_drift_z * 2.0)
					roll_drift_x = vm.f32(roll_drift_x * vm.f32(0.2))
					roll_drift_z = vm.f32(roll_drift_z * vm.f32(0.2))
				else
					if
						velocity_x < 0.0 and normal_x > 0.0
						or velocity_x > 0.0 and normal_x < 0.0
						or velocity_z < 0.0 and normal_z > 0.0
						or velocity_z > 0.0 and normal_z < 0.0
					then
						roll_drift_x = 0.0
						roll_drift_z = 0.0
					end
					velocity_x = 0.0
					velocity_y = 0.0
					velocity_z = 0.0
				end
				velocity_x = vm.f32(vm.f32(vm.f32(normal_x * speed) * vm.f32(0.9)) + velocity_x)
				velocity_y = vm.f32(vm.f32(vm.f32(normal_y * speed) * vm.f32(0.58)) + velocity_y)
				velocity_z = vm.f32(vm.f32(vm.f32(normal_z * speed) * vm.f32(0.9)) + velocity_z)
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				do
					local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(probe_x, probe_y, probe_z)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = event.scale_vector(probe_x, probe_y, probe_z, 3.0)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = event.scale_vector(normal_x, normal_y, normal_z, distance)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, normal_x, normal_y, normal_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
						12,
						previous_x,
						previous_y,
						previous_z,
						ball_x + probe_x,
						ball_y + probe_y,
						ball_z + probe_z,
						1
					)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
					normal_x = out4 or normal_x
					normal_y = out5 or normal_y
					normal_z = out6 or normal_z
					collision_id = out7 or collision_id
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, ball_x, ball_y, ball_z, ball_x, ball_y - 3.0, ball_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_id = out7 or collision_id
			surface_kind = out8 or surface_kind
		end
		if collision_id >= 0 then
			curve_spin = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			distance = event.get_vector_length(velocity_x, 0.0, velocity_z) or distance
			if distance < vm.f32(2.4) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				level = 1
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.9))
				velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
				velocity_z = vm.f32(velocity_z * vm.f32(0.9))
				velocity_x = vm.f32(velocity_x + vm.f32(roll_drift_x * 2.0))
				velocity_z = vm.f32(velocity_z + vm.f32(roll_drift_z * 2.0))
				roll_drift_x = vm.f32(roll_drift_x * vm.f32(0.2))
				roll_drift_z = vm.f32(roll_drift_z * vm.f32(0.2))
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if sound_cooldown <= 0 then
					event.play_sound_effect(sound_bank, 5)
					sound_cooldown = 20
				end
			end
			distance = event.get_vector_length(roll_drift_x, 0.0, roll_drift_z) or distance
			if velocity_y == 0.0 and speed < vm.f32(1.6) and distance < vm.f32(0.4) then
				if not (surface_kind == 6) then
					break
				end
				out_of_bounds = 1
				break
			end
		end
		if ball_y < -500.0 then
			out_of_bounds = 1
			break
		elseif tick >= 300 then
			out_of_bounds = 1
			break
		else
			pin_col = event.get_sphida_pin_color() or pin_col
			ball_col = event.get_sphida_ball_color() or ball_col
			x = vm.f32(pos_x - ball_x)
			y = vm.f32(pos_y - ball_y)
			z = vm.f32(pos_z - ball_z)
			pin_distance = event.get_vector_length(x, y, z) or pin_distance
			if ball_col ~= pin_col then
				segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pos_x, pos_y, pos_z) or segment_distance
				if segment_distance >= 0.0 and segment_distance <= 30.0 then
					scored_goal = 1
					break
				end
				if pin_distance ~= 0.0 then
					if pin_distance <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), pin_distance))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, x, y, z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, x, y, z)
							velocity_x = out1 or velocity_x
							velocity_y = out2 or velocity_y
							velocity_z = out3 or velocity_z
						end
					end
				else
					scored_goal = 1
					break
				end
			elseif pin_distance ~= 0.0 then
				if pin_distance <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, pin_distance))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, x, y, z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, x, y, z)
						velocity_x = out1 or velocity_x
						velocity_y = out2 or velocity_y
						velocity_z = out3 or velocity_z
					end
				end
			end
			event.set_character_position(8, ball_x, ball_y, ball_z)
			event.set_character_position(9, ball_x, ball_y, ball_z)
			do
				local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			if ball_y <= fall_limit_y then
				event.set_follow_camera_following(0)
				if out_of_bounds >= 30 then
					if out_of_bounds >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				out_of_bounds = out_of_bounds + 1
			elseif tick >= 20 then
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_camera_speed(6.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				do
					local out1, out2, out3 = event.get_camera_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				event.set_follow_camera_height(30.0)
				event.set_follow_camera_distance(200.0)
				yaw = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.set_follow_camera_angle(yaw)
				event.set_follow_camera_target_alternate(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z
				)
				event.step_follow_camera(1)
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(15)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			tick = tick + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	vm.wait(16)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if out_of_bounds == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		if scored_goal == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pos_x, pos_y, pos_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_bank, 17)
			tick = 0
			while tick < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				tick = tick + 1
				vm.wait(17)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			tick = 0
			while tick < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				tick = tick + 1
				vm.wait(18)
			end
			event.set_character_active(0, 11)
			event.place_treasure_box(pos_x, pos_y - 30.0, pos_z, launch_angle, 294)
			wait.for_frame_count(54)
			wait.for_frame_count(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_bank
			event.stop_music(0)
			event.play_sound_effect(sound_bank, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
			event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
			event.set_event_sprite_position(0, 256, 208)
			event.set_event_sprite_size(0, 254, 54)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
			object.wait_until_done(0)
			wait.for_frame_count(90)
			vm.wait(23)
			event.play_music(0)
			event.set_character_position(0, character_x, character_y, character_z)
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		else
			count = event.get_sphida_par() or count
			if count >= 2 then
				event.set_message_window_mode(0, 5)
				event.set_message_selection_top_line(0, 0)
				relocate_answer = dungeon_system_scripts_message.ask_option(0, 2002, 8, 256, 208, 2, 0)
				vm.wait(25)
				if relocate_answer == 0 then
					do
						local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
						collision_id = out1 or collision_id
						character_x = out2 or character_x
						character_y = out3 or character_y
						character_z = out4 or character_z
					end
					if collision_id == 0 then
						do
							local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
							character_x = out1 or character_x
							character_y = out2 or character_y
							character_z = out3 or character_z
						end
					end
					do
						local out1, out2, out3 = event.get_sphida_pin_position()
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					speed = event.get_distance_between(character_x, character_y, character_z, pos_x, pos_y, pos_z) or speed
					if speed < 40.0 then
						launch_angle = event.get_random_number(6.2831855) or launch_angle
						launch_angle = vm.f32(launch_angle - vm.f32(3.1415927))
						character_x = vm.f32(character_x + vm.f32(vm.sin(launch_angle) * 50.0))
						character_z = vm.f32(character_z + vm.f32(vm.cos(launch_angle) * 50.0))
					else
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(character_x, character_y, character_z)
							hit_x = out1 or hit_x
							hit_y = out2 or hit_y
							hit_z = out3 or hit_z
							collision_id = out4 or collision_id
						end
						tick = 0
						while collision_id >= 0 do
							do
								local out1, out2, out3 = event.copy_vector(character_x, character_y, character_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.normalize_vector(previous_x, previous_y, previous_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.scale_vector(previous_x, previous_y, previous_z, 32.0)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
								character_x = out1 or character_x
								character_y = out2 or character_y
								character_z = out3 or character_z
							end
							do
								local out1, out2, out3 = event.add_vectors(character_x, character_y, character_z, previous_x, previous_y, previous_z)
								character_x = out1 or character_x
								character_y = out2 or character_y
								character_z = out3 or character_z
							end
							do
								local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(character_x, character_y, character_z)
								hit_x = out1 or hit_x
								hit_y = out2 or hit_y
								hit_z = out3 or hit_z
								collision_id = out4 or collision_id
							end
							tick = tick + 1
							if tick > 6 then
								break
							end
						end
					end
					aim_angle = event.get_direction_angle(character_x, character_y, character_z, ball_x, ball_y, ball_z) or aim_angle
					event.set_character_position(0, character_x, character_y, character_z)
					event.set_character_rotation(0, 0.0, aim_angle, 0.0)
					event.set_camera_look_at(character_x, character_y + 30.0, character_z)
					aim_angle = vm.f32(aim_angle - vm.f32(3.1415927))
					aim_angle = event.wrap_angle(aim_angle) or aim_angle
					character_x = vm.f32(vm.f32(vm.sin(aim_angle) * 100.0) + character_x)
					character_y = vm.f32(character_y + 30.0)
					character_z = vm.f32(vm.f32(vm.cos(aim_angle) * 100.0) + character_z)
					event.set_camera_position(character_x, character_y, character_z)
					event.reset_follow_camera(0)
				else
					event.set_character_position(0, character_x, character_y, character_z)
				end
			else
				event.set_character_position(0, character_x, character_y, character_z)
			end
		end
	else
		event.play_sound_effect(sound_bank, 18)
		event.set_follow_camera_following(0)
		event.set_camera_control_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.set_object_sequence_motion(0, "だめだめ", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
		event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
		event.set_event_sprite_position(0, 256, -25)
		event.set_event_sprite_size(0, 160, 50)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
		object.wait_until_done(0)
		wait.for_frame_count(20)
		event.set_event_sprite_draw_pass(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		event.set_sphida_ball_position(ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(8, ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(9, ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(0, character_x, character_y, character_z)
		event.release_camera_sequence_follow_object()
	end
	if scored_goal == 1 then
		dungeon_system_scripts_minigame.end_when_par_exhausted(-1)
	else
		dungeon_system_scripts_minigame.end_when_par_exhausted(sound_bank)
	end
	dungeon_system_scripts_minigame.end_round(scored_goal)
end

--- Asks whether to move the ball to the character's position and does so after confirmation.
function script.sphida_near_ball()
	local answer: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	event.initialize_event()
	character.set_idle_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	answer = dungeon_system_scripts_message.ask_option(0, 2004, 8, 256, 208, 2, 0)
	if answer == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		event.set_sphida_ball_position(character_x, character_y + 3.0, character_z)
		event.set_character_position(8, character_x, character_y + 3.0, character_z)
		event.set_character_position(9, character_x, character_y + 3.0, character_z)
		dungeon_system_scripts_minigame.end_when_par_exhausted(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

return script
