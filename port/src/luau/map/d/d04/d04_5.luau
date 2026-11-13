--!strict
--- Event script for the Ocean's Roar Cave dungeon floors, covering floor setup, gates, guides and the Sphida mini-game.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local oceans_roar_cave = require("@lib/event/oceans_roar_cave")
local sound = require("@lib/event/sound")
local spheda = require("@lib/event/spanish/spheda")
local sphida_hint = require("@lib/event/spanish/sphida_hint")
local treasure_box = require("@lib/event/spanish/treasure_box")
local wait = require("@lib/event/wait")

--- Plays the arrival cutscene on a dungeon floor, with the map display or the floor logo, and explains any seal on the floor.
local function play_floor_arrival_scene(show_map: s32)
	local seal_flags: s32 = 0
	local block: s32 = 0
	local sound_id: s32 = 0
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	local floor: s32 = 0
	local previous_floor: s32 = 0
	local map_part_id: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local seal_sound_id: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		seal_flags = event.get_dungeon_floor_status() or seal_flags
		if seal_flags ~= 0 then
			if bit32.band(seal_flags, 1) ~= 0 then
				event.switch_dungeon_main_character(1)
			end
			if bit32.band(seal_flags, 2) ~= 0 then
				event.switch_dungeon_main_character(0)
			end
		end
		sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or sound_id
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			event_x = out1 or event_x
			event_y = out2 or event_y
			event_z = out3 or event_z
			event_angle = out4 or event_angle
		end
		event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, -145.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 18)
		if show_map ~= 0 then
			floor = event.get_dungeon_floor() or floor
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			event.load_dungeon_map_display(5, 0, 3, floor, previous_floor)
			event.fade_dungeon_map(1, 30)
		else
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d03_1.json", 0)
			event.set_event_image_texture(0, "logo_d03")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 30)
		end
		map_part_id = event.get_triggered_event_data_2(9) or map_part_id
		if calc.is_angle_within(event_angle, 0.0, 1.0) == 0 or calc.is_angle_within(event_angle, vm.f32(3.14), 1.0) == 0 then
			event.attach_object_handle_to_map_part_3(1, map_part_id, "d04w10_2-m")
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.attach_object_handle_to_map_part_3(2, map_part_id, "d04w10_4-m")
			event.set_object_handle_visible(2, 1)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
		else
			event.attach_object_handle_to_map_part_3(1, map_part_id, "d04w10_5-m")
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.attach_object_handle_to_map_part_3(2, map_part_id, "d04w10_6-m")
			event.set_object_handle_visible(2, 1)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
		end
		event.attach_object_handle_to_map_part_3(3, map_part_id, "d04w10_3-m")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(51.16, 17.85, 158.67)
		event.set_camera_sequence_look_at(-12.94, 64.29, -60.21)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_id, 1)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(1)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			rot_z = out3 or rot_z
		end
		do
			local out1, out2, out3 = event.copy_vector(rot_x, rot_y, rot_z)
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
		if calc.is_angle_within(event_angle, 0.0, 0.5) == 0 then
			rot_z = vm.f32(vector_z + vm.f32(3.1415927))
			rot_z = event.wrap_angle(rot_z) or rot_z
		end
		if calc.is_angle_within(event_angle, vm.f32(3.14), 0.5) == 0 then
			rot_z = vm.f32(vector_z - vm.f32(3.1415927))
			rot_z = event.wrap_angle(rot_z) or rot_z
		end
		if calc.is_angle_within(event_angle, vm.f32(1.57), 0.5) == 0 then
			rot_x = vm.f32(vector_x + vm.f32(3.1415927))
			rot_x = event.wrap_angle(rot_x) or rot_x
		end
		if calc.is_angle_within(event_angle, vm.f32(-1.57), 0.5) == 0 then
			rot_x = vm.f32(vector_x - vm.f32(3.1415927))
			rot_x = event.wrap_angle(rot_x) or rot_x
		end
		event.rotate_object_sequence_eased(1, rot_x, rot_y, rot_z, 40, 0, 0.5)
		event.rotate_object_sequence_eased(2, rot_x, rot_y, rot_z, 40, 0, 0.5)
		at = 2
		object.wait_until_done(1)
		event.move_object_sequence_eased(3, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		if show_map ~= 0 then
			event.set_dungeon_map_piece_moving(1)
		end
		at = 3
		wait.frames(20)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 0.0, 0.0, 0.0, 30)
		at = 4
		object.wait_until_done(3)
		event.move_object_sequence_eased(3, pos_x, pos_y, pos_z, 32, 0, 0.5)
		at = 5
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 30)
		event.delay_object_sequence_position_track(0, 30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 0.0, 0.0, 60.0, 40)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		at = 6
		object.wait_until_done(3)
		event.rotate_object_sequence_eased(1, vector_x, vector_y, vector_z, 40, 0, 0.5)
		event.rotate_object_sequence_eased(2, vector_x, vector_y, vector_z, 40, 0, 0.5)
		if show_map ~= 0 then
			event.fade_dungeon_map(0, 60)
		else
			event.fade_event_image(0, 0, 60)
		end
		event.show_dungeon_status_bar(1)
		at = 7
		object.wait_until_done(1)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = character.check_move_skipping(event_angle, 0.0, 1.0) == 0
			local _ = character.check_move_skipping(event_angle, vm.f32(3.14), 1.0) == 0
			local _ = character.check_move_skipping(event_angle, 0.0, 0.5) == 0
			rot_z = vm.f32(vector_z + vm.f32(3.1415927))
			local _ = character.check_move_skipping(event_angle, vm.f32(3.14), 0.5) == 0
			rot_z = vm.f32(vector_z - vm.f32(3.1415927))
			local _ = character.check_move_skipping(event_angle, vm.f32(1.57), 0.5) == 0
			rot_x = vm.f32(vector_x + vm.f32(3.1415927))
			local _ = character.check_move_skipping(event_angle, vm.f32(-1.57), 0.5) == 0
			rot_x = vm.f32(vector_x - vm.f32(3.1415927))
			cutscene.skip_command(1)
		end
		if at <= 2 then
			wait.frames_skipping(20)
		end
		if at <= 3 then
			cutscene.skip_command(3)
		end
		if at <= 4 then
			cutscene.skip_command(0)
		end
		if at <= 5 then
			cutscene.skip_command(3)
		end
		if at <= 6 then
			cutscene.skip_command(1)
		end
		return true
	end)
	at = 8
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_id, 1)
	event.show_dungeon_status_bar(1, 1.0)
	if show_map ~= 0 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	else
		event.delete_event_image(0)
	end
	event.set_camera_sequence_look_at(0.0, 30.0, 60.0)
	event.set_camera_sequence_position(0.0, 35.0, -40.0)
	if calc.is_angle_within(event_angle, 0.0, 1.0) == 0 or calc.is_angle_within(event_angle, vm.f32(3.14), 1.0) == 0 then
		event.attach_object_handle_to_map_part_3(1, map_part_id, "d04w10_2-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, map_part_id, "d04w10_4-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	else
		event.attach_object_handle_to_map_part_3(1, map_part_id, "d04w10_5-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, map_part_id, "d04w10_6-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	end
	event.attach_object_handle_to_map_part_3(3, map_part_id, "d04w10_3-m")
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(1, vector_x, vector_y, vector_z)
	event.set_object_sequence_rotation(2, vector_x, vector_y, vector_z)
	event.set_object_sequence_position(3, pos_x, pos_y, pos_z)
	at = 9
	vm.wait(9)
	event.set_object_handle_position(0, 0.0, 0.0, 60.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.reset_follow_camera(0)
	event.fade_in_screen(0)
	event.initialize_event()
	if seal_flags ~= 0 then
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 10
			vm.wait(10)
			at = 11
			wait.background_load()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "aka_fuuin", block)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 12
			vm.wait(12)
			at = 13
			wait.background_load()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "ao_fuuin", block)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 14
			vm.wait(14)
			at = 15
			wait.background_load()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/shiro_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "shiro_fuuin", block)
		end
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 156)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_color(0, 128, 128, 128, 128, 30)
		seal_sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_050.sound.json") or seal_sound_id
		event.play_sound_effect(seal_sound_id, 0)
		event.set_message_window_mode(0, 4)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello rojo.")
			at = 16
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "La Atlamillia roja ha elegido a Max.\n[UNI00a1]No puedes cambiarlo!")
			at = 17
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello azul.")
			at = 18
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "La Atlamillia azul ha elegido a M[UNI00f3]nica.\n[UNI00a1]No puedes cambiarla!")
			at = 19
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello blanco.")
			at = 20
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Ya ni podr[UNI00e1]s restablecer la salud ni curar\nestados an[UNI00f3]malos.")
			at = 21
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		event.set_event_sprite_draw_pass(0, 0)
		event.delete_event_image(0)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Sets up a floor of the Ocean's Roar Cave by number, loading the matching map and scene or branching to a special area.
local function enter_floor()
	local stage_id: s32 = 0
	local floor: s32 = 0
	local floor_info: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local previous_floor: s32 = 0
	local random_roll: s32 = 0
	local flag_4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		at = 2
		vm.wait(2)
		event.reset_action_character_motion(0)
		event.set_local_event_flag(0, 0)
		event.set_local_event_flag(1, 0)
		event.set_local_event_flag(2, 0)
		event.set_local_event_flag(3, 0)
		event.set_local_event_flag(4, 0)
		event.set_event_projection(524.9)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		floor_info = event.get_dungeon_floor_info(stage_id, floor, 7) or floor_info
		dungeon.increment_floor_counter(stage_id, floor)
		event.initialize_dungeon_floor()
		if floor == 0 then
			event.go_to_georama_edit(2, 100)
			return
		end
		if floor == 9 then
			event.skip_next_music_load()
			event.load_dungeon_map("s19")
			event.load_event_script("s19/s19.stb", 100)
			return
		end
		if floor == 14 then
			event.skip_next_music_load()
			event.load_dungeon_map("s15")
			event.load_event_script("s15/s15.stb", 100)
			return
		end
		if floor == 20 then
			flag = event.get_save_flag(438) or flag
			flag_2 = event.get_save_flag(444) or flag_2
			if flag == 1 and flag_2 == 0 then
				event.skip_next_music_load()
				event.load_dungeon_map("d04b01")
				event.load_event_script("d04b01/d04b01.stb", 100)
			else
				event.skip_next_music_load()
				event.go_to_georama_edit(90, 100)
			end
			return
		end
		flag_3 = event.get_save_flag(424) or flag_3
		if floor == 17 and flag_3 == 0 then
			event.set_dungeon_pause_flags(2048, 1)
			event.skip_next_music_load()
			event.load_dungeon_map("s45")
			event.load_event_script("s45/s45.stb", 520)
			return
		end
		previous_floor = event.get_dungeon_previous_floor() or previous_floor
		if floor == 1 then
			event.load_dungeon_map("d04f00", "d04f00", 56)
			event.load_dungeon_monster(0)
			event.place_treasure_box_at_event_point(-1)
			event.place_dungeon_monster(-1)
			event.set_local_event_flag(5, 1)
			event.set_dungeon_pause_flags(32, 0)
			event.set_map_lighting(0)
			if floor_info <= 0 then
				at = 3
				oceans_roar_cave.play_floor_entry_walk(0)
			elseif floor == previous_floor then
				at = 4
				oceans_roar_cave.play_floor_entry_walk(0)
			else
				at = 5
				oceans_roar_cave.play_floor_entry_walk(1)
			end
		elseif floor <= 5 or floor >= 17 then
			random_roll = event.get_random_number_int(100) or random_roll
			flag_4 = event.get_save_flag(406) or flag_4
			if floor == 2 and flag_4 == 0 then
				event.skip_next_music_load()
				event.load_dungeon_map("d04f02", "d04f02", 40)
				event.set_local_event_flag(5, 0)
				event.set_dungeon_pause_flags(32, 1)
				at = 6
				oceans_roar_cave.play_rotating_gate_scene()
				event.set_dungeon_pause_flags(2048, 1)
				event.skip_next_music_load()
				event.load_dungeon_map("s46")
				event.load_event_script("s46/s46.stb", 520)
			else
				if floor == 19 then
					event.allow_next_music_load()
					event.stop_music(0)
					at = 7
					wait.frames(6)
					event.load_music(37)
					event.skip_next_music_load()
				end
				if vm.imod(random_roll, 8) == 0 then
					event.load_dungeon_map("d04f02r", "d04f02", 40)
					event.set_dungeon_weather(1)
				else
					event.load_dungeon_map("d04f02", "d04f02", 40)
				end
				event.play_music(0)
				event.set_local_event_flag(5, 0)
				event.set_dungeon_pause_flags(32, 1)
				event.load_dungeon_monster(0)
				event.place_treasure_box_at_event_point(-1)
				event.place_dungeon_monster(-1)
				if floor == previous_floor then
					at = 8
					play_floor_arrival_scene(0)
				else
					at = 9
					play_floor_arrival_scene(1)
				end
			end
		else
			if floor >= 11 and floor <= 13 then
				event.load_dungeon_map("d04f01s", "d01f01")
			else
				event.load_dungeon_map("d04f01", "d01f01")
			end
			event.load_dungeon_monster(0)
			event.place_treasure_box_at_event_point(-1)
			event.place_dungeon_monster(-1)
			event.set_local_event_flag(5, 0)
			event.set_dungeon_pause_flags(32, 1)
			if floor == previous_floor then
				at = 10
				play_floor_arrival_scene(0)
			else
				at = 11
				play_floor_arrival_scene(1)
			end
		end
		sound.load_event_sound_effects()
		dungeon.show_floor_title()
		return
	end, function(received: { any })
		if at <= 2 then
			dungeon.increment_floor_counter_skipping(stage_id, floor)
			return 0
		end
		if at <= 11 then
			if at <= 3 then
				at = 4
				oceans_roar_cave.play_floor_entry_walk(0)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if at <= 4 then
				at = 5
				oceans_roar_cave.play_floor_entry_walk(1)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if at <= 5 then
				at = 6
				oceans_roar_cave.play_rotating_gate_scene()
				return vm.continue_with(function()
					event.set_dungeon_pause_flags(2048, 1)
					event.skip_next_music_load()
					event.load_dungeon_map("s46")
					event.load_event_script("s46/s46.stb", 520)
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if at <= 6 then
				wait.frames_skipping(6)
			end
			if at <= 7 then
				at = 8
				play_floor_arrival_scene(0)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if at <= 8 then
				at = 9
				play_floor_arrival_scene(1)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if at <= 9 then
				at = 10
				play_floor_arrival_scene(0)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if at <= 10 then
				at = 11
				play_floor_arrival_scene(1)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			wait.background_load_skipping()
			cutscene.noop()
			return 0
		end
		return nil
	end)
end

--- Opens the floor map, stores the chosen floors and starts the floor setup.
local function select_floor_from_map()
	local current_music_number: s32 = 0
	local previous_floor: s32 = 0
	local next_floor: s32 = 0
	event.initialize_event()
	event.initialize_sphida()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	current_music_number = event.get_active_music_number() or current_music_number
	if current_music_number ~= 18 then
		event.stop_music(0)
		wait.frames(6)
		event.load_music(18)
	end
	event.play_music(0)
	event.load_map_sounds(4601)
	event.open_dungeon_floor_map(3)
	vm.wait(2)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		previous_floor = out2 or previous_floor
		next_floor = out3 or next_floor
	end
	event.set_dungeon_floor(next_floor)
	event.set_dungeon_previous_floor(previous_floor)
	enter_floor()
end

--- Handles interaction with a rotating gate depression: placing the key item or, once opened, offering to move on to the next floor.
local function interact_with_gate_slot(slot_index: s32)
	local is_slot_filled: s32 = 0
	local prompt_state: s32 = 0
	local answer: s32 = 0
	local item: s32 = 0
	local active_chr_no: s32 = 0
	local choice: any = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	local is_e3_version: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	is_slot_filled = event.get_local_event_flag(slot_index) or is_slot_filled
	event.set_dungeon_pause_flags(1, 1)
	if is_slot_filled == 0 then
		prompt_state = event.get_triggered_event_data_2(6) or prompt_state
		if prompt_state == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			event.open_message_window_2(0, "Aqu[UNI00ed] hay un hueco. Se puede poner algo.\n(Usa (#) para abrir el men[UNI00fa].)")
			answer = message.ask_confirmation(0, -1, 5, 256, 208, answer)
			event.set_message_window_mode(0, 7)
			event.set_message_draw_speed(0, 0)
			if answer == 1 then
				prompt_state = 2
			end
			event.finish_event()
		end
		if prompt_state == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait.frames(6)
			event.open_use_item_menu(342)
			vm.wait(3)
			item = vmhost.used_item() or item
			if item == 342 then
				event.set_local_event_flag(slot_index, 1)
				oceans_roar_cave.turn_rotating_gate()
			elseif item <= 0 then
				event.finish_event()
			else
				character.shake_head()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
			wait.frames(6)
		end
	else
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.initialize_event()
			character.reset_action_motion()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				message.show_and_wait(0, 21, 5, 256, 208)
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
		choice = message.ask_choice(0, 10, 8, 256, 208, 2, 1)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		if choice == 0 then
			event.clear_event_battle_monsters(-1)
			minigame.delete_sphida_objects()
			oceans_roar_cave.run_forward_and_fade_out()
			do
				local out1, out2 = event.get_floor_practice_result(1)
				cleared = out1 or cleared
				bonus = out2 or bonus
			end
			if cleared == 2 or cleared == 3 then
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 512, 416)
				event.set_event_sprite_color(0, 0, 0, 0, 128)
				event.set_event_sprite_draw_pass(0, 1)
				event.fade_in_screen(0)
				spheda.announce_medal_reward(-1, cleared, bonus)
				vm.wait(12)
				event.fade_out_screen(0)
				event.set_event_sprite_draw_pass(0, 0)
			end
			stage_id = event.get_dungeon_stage_id() or stage_id
			floor = event.get_dungeon_floor() or floor
			next_floor = event.get_dungeon_next_floor(floor, slot_index) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			event.finish_dungeon_floor()
			is_e3_version = event.is_e3_version() or is_e3_version
			if is_e3_version == 1 then
				event.set_scene_exit_flag(1)
				return
			else
				event.finish_event()
				select_floor_from_map()
			end
		else
			event.finish_event()
		end
	end
	event.set_dungeon_pause_flags(1, 0)
end

--- Runs the floor clear sequence: victory scene, practice results, seal messages and Sphida course setup.
local function finish_floor()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local flag_220: s32 = 0
	local flag: s32 = 0
	local is_play_sub_game: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local is_clear_most_fast_destroy: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local is_trial: s32 = 0
	local seal_flags: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		character.reset_action_motion()
		event.set_dungeon_pause_flags(512, 1)
		event.show_dungeon_status_bar(0, 0.16666667)
		at = 1
		wait.frames(10)
		event.set_dungeon_pause_flags(16384, 1)
		event.clear_event_battle_monsters(-1)
		if active_chr_no == 0 then
			at = 2
			dungeon.play_max_victory(1)
		end
		if active_chr_no == 1 then
			at = 3
			dungeon.play_monica_victory(1)
		end
		if active_chr_no == 2 or active_chr_no == 3 then
			at = 4
			dungeon.play_finish_banner(active_chr_no)
		end
		event.set_dungeon_pause_flags(16384, 0)
		oceans_roar_cave.set_key_door_opened()
		event.reset_action_character_motion(0, 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.show_dungeon_status_bar(1, 0.16666667)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		event.set_dungeon_floor_info(stage_id, floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
		flag = event.get_save_flag(220) or flag
		flag = event.get_save_flag(317) or flag
		is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
		if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
			event.clear_random_stones()
			minigame.set_up_sphida_course_with_draw_distance(0, -1)
		end
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
		is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
		do
			local out1, out2 = event.get_floor_practice_result(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		at = 5
		spheda.announce_medal_reward(is_clear_most_fast_destroy, cleared, bonus)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		is_trial = event.is_trial_version() or is_trial
		seal_flags = event.get_dungeon_floor_status() or seal_flags
		if
			(if (if bit32.band(seal_flags, 1) ~= 0 then 1 else bit32.band(seal_flags, 2)) ~= 0 then 1 else bit32.band(seal_flags, 4))
			~= 0
		then
			event.set_dungeon_floor_status_flags(7, 0)
			if bit32.band(seal_flags, 1) ~= 0 then
				event.open_message_window_2(0, "Se ha roto el Sello rojo.")
			end
			if bit32.band(seal_flags, 2) ~= 0 then
				event.open_message_window_2(0, "Se ha roto el Sello azul.")
			end
			if bit32.band(seal_flags, 4) ~= 0 then
				event.open_message_window_2(0, "Se ha roto el Sello blanco.")
			end
			at = 6
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		at = 7
		message.show_and_wait(0, 2130, 8, 0, 0)
		if is_trial ~= 1 then
			if flag_220 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
				at = 8
				message.show_and_wait(0, 2120, 8, 0, 0)
				at = 9
				spheda.move_character_to_ball()
			else
				if (if flag_220 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					at = 10
					message.show_and_wait(0, 2110, 8, 0, 0)
				end
				if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					at = 11
					message.show_and_wait(0, 2100, 8, 0, 0)
					at = 12
					spheda.move_character_to_ball()
				end
			end
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(512, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 12 then
			if at <= 1 then
				at = 2
				dungeon.play_max_victory(1)
				return vm.continue_with(function()
					if active_chr_no == 1 then
						at = 3
						dungeon.play_monica_victory(1)
					end
					if active_chr_no == 2 or active_chr_no == 3 then
						at = 4
						dungeon.play_finish_banner(active_chr_no)
					end
					event.set_dungeon_pause_flags(16384, 0)
					oceans_roar_cave.set_key_door_opened()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					flag = event.get_save_flag(220) or flag
					flag = event.get_save_flag(317) or flag
					is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
					if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
						event.clear_random_stones()
						minigame.set_up_sphida_course_with_draw_distance(0, -1)
					end
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
					is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					spheda.announce_medal_reward(is_clear_most_fast_destroy, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial = event.is_trial_version() or is_trial
					seal_flags = event.get_dungeon_floor_status() or seal_flags
					if
						(
							if (if bit32.band(seal_flags, 1) ~= 0 then 1 else bit32.band(seal_flags, 2)) ~= 0
								then 1
								else bit32.band(seal_flags, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(seal_flags, 1) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello rojo.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello azul.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello blanco.")
						end
						at = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					at = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial ~= 1 then
						if flag_220 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
							at = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							at = 9
							spheda.move_character_to_ball()
						else
							if (if flag_220 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 11
								message.show_and_wait(0, 2100, 8, 0, 0)
								at = 12
								spheda.move_character_to_ball()
							end
						end
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 2 then
				at = 3
				dungeon.play_monica_victory(1)
				return vm.continue_with(function()
					if active_chr_no == 2 or active_chr_no == 3 then
						at = 4
						dungeon.play_finish_banner(active_chr_no)
					end
					event.set_dungeon_pause_flags(16384, 0)
					oceans_roar_cave.set_key_door_opened()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					flag = event.get_save_flag(220) or flag
					flag = event.get_save_flag(317) or flag
					is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
					if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
						event.clear_random_stones()
						minigame.set_up_sphida_course_with_draw_distance(0, -1)
					end
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
					is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					spheda.announce_medal_reward(is_clear_most_fast_destroy, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial = event.is_trial_version() or is_trial
					seal_flags = event.get_dungeon_floor_status() or seal_flags
					if
						(
							if (if bit32.band(seal_flags, 1) ~= 0 then 1 else bit32.band(seal_flags, 2)) ~= 0
								then 1
								else bit32.band(seal_flags, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(seal_flags, 1) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello rojo.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello azul.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello blanco.")
						end
						at = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					at = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial ~= 1 then
						if flag_220 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
							at = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							at = 9
							spheda.move_character_to_ball()
						else
							if (if flag_220 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 11
								message.show_and_wait(0, 2100, 8, 0, 0)
								at = 12
								spheda.move_character_to_ball()
							end
						end
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 3 then
				at = 4
				dungeon.play_finish_banner(active_chr_no)
				return vm.continue_with(function()
					event.set_dungeon_pause_flags(16384, 0)
					oceans_roar_cave.set_key_door_opened()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					flag = event.get_save_flag(220) or flag
					flag = event.get_save_flag(317) or flag
					is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
					if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
						event.clear_random_stones()
						minigame.set_up_sphida_course_with_draw_distance(0, -1)
					end
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
					is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					spheda.announce_medal_reward(is_clear_most_fast_destroy, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial = event.is_trial_version() or is_trial
					seal_flags = event.get_dungeon_floor_status() or seal_flags
					if
						(
							if (if bit32.band(seal_flags, 1) ~= 0 then 1 else bit32.band(seal_flags, 2)) ~= 0
								then 1
								else bit32.band(seal_flags, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(seal_flags, 1) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello rojo.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello azul.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello blanco.")
						end
						at = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					at = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial ~= 1 then
						if flag_220 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
							at = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							at = 9
							spheda.move_character_to_ball()
						else
							if (if flag_220 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 11
								message.show_and_wait(0, 2100, 8, 0, 0)
								at = 12
								spheda.move_character_to_ball()
							end
						end
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 4 then
				oceans_roar_cave.noop()
				cutscene.noop_with_arguments(0, -1)
				message.resume_numbered_messages(is_clear_most_fast_destroy, cleared, bonus)
			end
			if at <= 5 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if at <= 6 then
				message.show_and_wait_skipping(0, 2130, 8, 0, 0)
			end
			if at <= 7 then
				message.show_and_wait_skipping(0, 2120, 8, 0, 0)
			end
			if at <= 8 then
				message.open_choice_pair_skipping()
			end
			if at <= 9 then
				message.show_and_wait_skipping(0, 2110, 8, 0, 0)
			end
			if at <= 10 then
				message.show_and_wait_skipping(0, 2100, 8, 0, 0)
			end
			if at <= 11 then
				message.open_choice_pair_skipping()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script is loaded and does nothing.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Runs for the default event and is empty.
function script.default_event() end

--- Gives the starting items and sets the two save flags that enable the Sphida courses.
function script.grant_starting_items()
	local item_count: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	item_count = event.get_owned_item_count(10) or item_count
	if item_count <= 0 then
		event.add_inventory_item(10, 1)
	end
	item_count = event.get_owned_item_count(302) or item_count
	if item_count <= 0 then
		event.add_inventory_item(302, 1)
	end
	event.set_save_flag(220, 1)
	event.set_save_flag(317, 1)
	event.clear_event_battle_monsters(-1)
	event.finish_event()
end
script[200] = script.grant_starting_items

--- Interacts with the first gate depression.
function script.examine_gate_slot_0()
	interact_with_gate_slot(0)
end
script[300] = script.examine_gate_slot_0

--- Interacts with the second gate depression when the edit analysis found changes.
function script.edit_analyze_changed()
	interact_with_gate_slot(1)
end

--- Interacts with the third gate depression.
function script.examine_gate_slot_2()
	interact_with_gate_slot(2)
end
script[320] = script.examine_gate_slot_2

--- Interacts with the fourth gate depression.
function script.examine_gate_slot_3()
	interact_with_gate_slot(3)
end
script[330] = script.examine_gate_slot_3

--- Event 340, which map data, a script or the engine runs by number.
script[340] = oceans_roar_cave.use_star_key_door

--- Toggles whether the staging area is crossable and plays the crossing between it and the cave floor.
function script.cross_staging_area()
	local previous_flag: s32 = 0
	event.initialize_event()
	previous_flag = event.get_local_event_flag(5) or previous_flag
	if previous_flag == 0 then
		event.set_local_event_flag(5, 1)
		event.set_dungeon_pause_flags(32, 0)
	else
		event.set_local_event_flag(5, 0)
		event.set_dungeon_pause_flags(32, 1)
	end
	oceans_roar_cave.cross_staging_area(previous_flag)
end
script[345] = script.cross_staging_area

--- Opens the key door, either automatically for the party companion or after the player uses the key item.
function script.examine_key_door()
	local now_party_chara_id: s32 = 0
	local prompt_state: s32 = 0
	local answer: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 1)
	character.reset_action_motion()
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if now_party_chara_id == 4 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "S[UNI00f3]lo tienes que pasar por aqu[UNI00ed], [UNI00bf]entendido?")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.show_dungeon_status_bar(0, 0.16666667)
		oceans_roar_cave.open_key_door()
		event.show_dungeon_status_bar(1, 0.16666667)
		wait.frames(6)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	prompt_state = event.get_triggered_event_data_2(6) or prompt_state
	if prompt_state == 1 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_draw_speed(0, 1)
		answer = message.ask_confirmation(0, 2503, 5, 256, 208, answer)
		event.set_message_bubble_tail(0, 1)
		event.set_message_draw_speed(0, 0)
		if answer == 1 then
			prompt_state = 2
		end
	end
	if prompt_state == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait.frames(6)
		event.open_use_item_menu(343)
		vm.wait(6)
		item = vmhost.used_item() or item
		if item == 343 then
			oceans_roar_cave.open_key_door()
		elseif item <= 0 then
		else
			character.shake_head()
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		wait.frames(6)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end
script[348] = script.examine_key_door

--- Places the player at the floor start point and starts a floor without a cutscene.
function script.start_floor_at_event_point()
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	event.initialize_event()
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
		event_x = out1 or event_x
		event_y = out2 or event_y
		event_z = out3 or event_z
		event_angle = out4 or event_angle
	end
	event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_position(0, 0.0, -1.0, 100.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(0.0, 29.0, 100.0)
	event.set_camera_position(0.0, 41.0, -20.0)
	event.reset_follow_camera(0)
	event.set_dungeon_pause_flags(1, 0)
	event.load_dungeon_monster(0)
	event.place_treasure_box_at_event_point(-1)
	event.place_dungeon_monster(-1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_local_event_flag(5, 0)
	event.set_dungeon_pause_flags(32, 1)
	sound.load_event_sound_effects()
	event.fade_in_screen(30)
	vm.wait(1)
	dungeon.show_floor_title()
	event.finish_event()
end
script[500] = script.start_floor_at_event_point

script.select_floor_from_map = select_floor_from_map
script[1000] = script.select_floor_from_map

script.enter_floor = enter_floor
script[1010] = script.enter_floor

--- The dungeon system event run when the player opens a treasure box.
script.treasure_box = treasure_box.open_nearest

--- Plays the spinning random circle ring and coin, then applies the good or bad effect it stops on.
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
	local sound_id: s32 = 0
	local weight: f32 = 0
	local coin_angle: f32 = 0
	local now_party_chara_id: s32 = 0
	local circle_id: s32 = 0
	local frame_count: s32 = 0
	local spin_speed: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local facing_angle: f32 = 0
	local minimum_spin_frames: s32 = 0
	local angle: f32 = 0
	local roll: s32 = 0
	local threshold: s32 = 0
	local bright_rate: f32 = 0
	local effect_id: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if active_chr_no == 2 then
			message.show_and_wait(0, 22, 8, 0, 0)
		else
			message.show_and_wait(0, 23, 8, 0, 0)
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
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	character.reset_action_motion()
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
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	wait.background_load()
	sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or sound_id
	event.change_directory("event/dng/")
	event.start_background_file_loads_2("ring.gltf", "randomcoin.gltf")
	vm.wait(5)
	wait.background_load()
	weight = event.get_random_circle_motion_frame() or weight
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, pos_x_2, pos_y_2, pos_z_2)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, weight)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	coin_angle = event.get_random_number(6.2831855) or coin_angle
	coin_angle = vm.f32(coin_angle - vm.f32(3.1415927))
	coin_angle = event.wrap_angle(coin_angle) or coin_angle
	event.set_character_rotation(13, 0.0, coin_angle, 0.0)
	event.change_directory("")
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	frame_count = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		if frame_count == 10 then
			event.play_sound_effect(sound_id, 0)
		end
		if frame_count == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if frame_count >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame_count > 300 then
			event.stop_sound_effect(sound_id, 0)
			event.play_sound_effect(sound_id, 3)
			vm.wait(7)
			break
		else
			frame_count = frame_count + 1
			vm.wait(8)
		end
	end
	message.close_second_window()
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
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
	facing_angle = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or facing_angle
	minimum_spin_frames = 0
	minimum_spin_frames = event.get_random_number_int(10) or minimum_spin_frames
	minimum_spin_frames = vm.i32(minimum_spin_frames + 4)
	frame_count = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		vm.wait(9)
		if frame_count >= minimum_spin_frames then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			angle = facing_angle
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 0
				break
			end
			angle = vm.f32(facing_angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 1
				break
			end
		end
		frame_count = vm.i32(frame_count + 1)
	end
	facing_angle = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, facing_angle, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	facing_angle = coin_angle
	wait.frames(20)
	roll = event.get_random_number_int(10) or roll
	if now_party_chara_id == 24 then
		threshold = 100
	else
		threshold = 6
	end
	if roll < threshold then
		roll = event.get_random_number_int(10) or roll
		if circle_id == 0 then
			if now_party_chara_id == 24 then
				threshold = 0
			else
				threshold = 2
			end
		elseif now_party_chara_id == 24 then
			threshold = 100
		else
			threshold = 4
		end
		if roll < threshold then
			facing_angle = vm.f32(facing_angle + vm.f32(3.14))
			facing_angle = event.wrap_angle(facing_angle) or facing_angle
			event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 8)
			if circle_id == 0 then
				circle_id = 1
			else
				circle_id = 0
			end
			wait.frames(10)
		else
			roll = event.get_random_number_int(10) or roll
			if roll < 1 then
				facing_angle = vm.f32(facing_angle + vm.f32(3.14))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 6)
				facing_angle = vm.f32(facing_angle + vm.f32(1.57))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 3)
				facing_angle = vm.f32(facing_angle + vm.f32(1.57))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	facing_angle = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, facing_angle, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	bright_rate = 1.0
	frame_count = 0
	effect_id = event.get_random_circle_effect(circle_id) or effect_id
	if circle_id == 0 then
		event.play_sound_effect(sound_id, 1)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate + vm.f32(0.03))
			frame_count = frame_count + 1
			vm.wait(13)
		end
		message.show_and_wait(0, 2310, 8, 0, 0)
		result = event.apply_random_circle_effect(effect_id) or result
		if effect_id == 1 then
			message.show_and_wait(0, 2311, 8, 0, 0)
		end
		if effect_id == 2 then
			message.show_and_wait(0, 2312, 8, 0, 0)
		end
		if effect_id == 3 then
			message.show_and_wait(0, 2313, 8, 0, 0)
		end
		if effect_id == 4 then
			event.place_treasure_box(pos_x_2, pos_y_2, pos_z_2, facing_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_id, 2)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate - vm.f32(0.03))
			frame_count = frame_count + 1
			vm.wait(19)
		end
		message.show_and_wait(0, 2320, 8, 0, 0)
		result = event.apply_random_circle_effect(effect_id) or result
		if effect_id == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				message.show_and_wait(0, 2321, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				message.show_and_wait(0, 2322, 8, 0, 0)
			end
		end
		if effect_id == 6 then
			if active_chr_no == 0 then
				message.show_and_wait(0, 2323, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				message.show_and_wait(0, 2324, 8, 0, 0)
			end
			if active_chr_no == 2 then
				message.show_and_wait(0, 2325, 8, 0, 0)
			end
		end
		if effect_id == 8 then
			message.show_and_wait(0, 2328, 8, 0, 0)
		end
		if effect_id == 9 then
			message.show_and_wait(0, 2326, 8, 0, 0)
		end
		if effect_id == 10 then
			message.show_and_wait(0, 2329, 8, 0, 0)
		end
		if effect_id == 11 then
			message.show_and_wait(0, 2327, 8, 0, 0)
		end
		if effect_id == 12 then
			message.show_and_wait(0, 2330, 8, 0, 0)
		end
	end
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if effect_id == 1 then
		event.spawn_pull_items(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
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
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the geostone use scene and records that the geostone has been used on the floor.
function script.geostone()
	local active_chr_no: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local sound_id: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local argc: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if active_chr_no == 2 then
			message.show_and_wait(0, 22, 8, 0, 0)
		else
			message.show_and_wait(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.set_dungeon_pause_flags(16, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_save_flag(31, 1)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
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
	sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_id
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
	yaw = event.get_direction_angle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or yaw
	yaw = event.wrap_angle(yaw) or yaw
	if active_chr_no == 0 then
		yaw = vm.f32(yaw + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		yaw = vm.f32(yaw + vm.f32(2.4))
	end
	yaw = event.wrap_angle(yaw) or yaw
	character_x = vm.f32(vm.f32(vm.sin(yaw) * 14.0) + pos_x_2)
	character_z = vm.f32(vm.f32(vm.cos(yaw) * 14.0) + pos_z_2)
	event.set_character_position(0, character_x, character_y, character_z)
	yaw = vm.f32(yaw - vm.f32(3.1415927))
	yaw = event.wrap_angle(yaw) or yaw
	event.set_character_rotation(0, 0.0, yaw, 0.0)
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
		pos_x_3 = vm.f32(vm.f32(vm.sin(yaw) * 8.0) + character_x)
		pos_y_3 = vm.f32(character_y + 18.0)
		pos_z_3 = vm.f32(vm.f32(vm.cos(yaw) * 8.0) + character_z)
		event.set_character_position(12, pos_x_3, pos_y_3, pos_z_3)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait.frames(16)
	event.play_sound_effect(sound_id, 0)
	wait.frames(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait.frames(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	yaw = event.get_direction_angle(character_x, character_y, character_z, pos_x, pos_y, pos_z) or yaw
	event.set_character_rotation(12, 0.0, yaw, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait.frames(20)
	event.play_sound_effect(sound_id, 1)
	object.wait_until_done(0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	argc = event.get_system_sound_id() or argc
	event.play_sound_effect(argc, 18)
	message.show_and_wait(0, 2400, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor = event.get_dungeon_floor() or floor
	event.set_dungeon_floor_info(stage_id, floor, 5, 256)
	event.start_crossfade(10)
	if active_chr_no == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(529, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, start_x, start_y, start_z)
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
	event.set_camera_control_enabled(1)
	event.finish_event()
end

--- The dungeon system event run for a monster that can be talked to.
script.monster_talk = dungeon.talk_to_monster

--- Runs the defeat sequence without showing its message.
function script.run_silent_defeat_sequence()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.run_silent_defeat_sequence

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = finish_floor

--- Shows the guide message the first time a random stone is examined.
function script.random_stone_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.set_save_flag(50, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.show_and_wait(0, 2600, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Shows a guide message and waits for it to be dismissed.
function script.show_guide_message()
	local answer: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.open(0, 2610, 8, 0, 0)
	wait.frames(30)
	do
		local _: any
		_, answer = message.wait_answer(0, 0, answer)
	end
	message.close(0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end
script[2510] = script.show_guide_message

--- Shows the level up guide messages and points to the help menu.
function script.level_up_guide()
	local answer: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.open(0, 2620, 8, 0, 0)
	wait.frames(30)
	do
		local _: any
		_, answer = message.wait_answer(0, 0, answer)
	end
	message.close(0)
	message.show_and_wait(0, 2621, 8, 0, 0)
	message.show_and_wait(0, 2622, 8, 0, 0)
	message.show_and_wait(0, 2623, 8, 0, 0)
	event.open_message_window_2(0, "Consulta Ayuda en el men[UNI00fa] Principal para obtener m[UNI00e1]s informaci[UNI00f3]n.")
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Shows the controls of the ridepod's wheels.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Conducci[UNI00f3]n del Buggy\n   Acelerar (L)↑/ Frenar (L)↓\n   Girar (L) ← o →\n   Curvas cerradas [l1] + (L) ← o →"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Explains how to use the Magic-Absorb Blade.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]Has aprendido a usar la Hoja de absorci[UNI00f3]n m[UNI00e1]gica.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La Hoja de absorci[UNI00f3]n m[UNI00e1]gica es una habilidad que\nte permite absorber la energ[UNI00ed]a de ataques elementales,\ncomo el Fuego, mientras te defiendes. Al blandir la\nespada, se dispara en forma de magia."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Puedes recargar continuamente\nenerg[UNI00ed]a de un elemental.\nSin embargo, si absorbes\nenerg[UNI00ed]a elemental de otro tipo, pierdes toda la carga."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La cantidad de energ[UNI00ed]a elemental que puedes absorber\ndepende de la resistencia del arma que est[UNI00e9]s usando."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Para liberar energ[UNI00ed]a elemental absorbida\nen forma de magia, pulsa el bot[UNI00f3]n [l1]\nmientras te defiendes con el bot[UNI00f3]n [r1]."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Runs a full Sphida shot: aiming, power gauge, ball flight physics with collisions, and the result.
function script.sphida_shot()
	local tex_bank: s32 = 0
	local sound_id: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rot_x: f32 = 0
	local aim_angle: f32 = 0
	local rot_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local launch_angle: f32 = 0
	local shot_power: f32 = 0
	local curve_factor: f32 = 0
	local level: s32 = 0
	local drift_x: f32 = 0
	local curve_angle: f32 = 0
	local drift_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local is_cup_in: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
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
	local previous_speed: f32 = 0
	local length: f32 = 0
	local collision_result: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local step: s32 = 0
	local pin_distance: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local pin_path_distance: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local choice: any = 0
	vm.wait(1)
	event.initialize_event()
	character.reset_action_motion()
	event.set_character_motion(0, "立ち")
	if minigame.check_sphida_club() ~= 0 then
		event.finish_event()
		return
	end
	event.show_dungeon_status_bar(0, 0.1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_4(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf",
		"dungeon/sphida/mizu_eff.gltf"
	)
	vm.wait(3)
	wait.background_load()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.get_sphida_texture_bank() or tex_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	sound_id = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_id
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.initialize_effect_manager(5, 1)
	event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	ball_x, ball_y, ball_z, aim_angle = minigame.set_up_sphida_shot(ball_x, ball_y, ball_z, aim_angle)
	camera.place_behind_player(aim_angle)
	event.set_sphida_status_panel_visible(1)
	launch_angle = 12.5
	event.set_sphida_carry_angle(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power, curve_factor, level = minigame.get_equipped_club_definition(shot_power, curve_factor, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		drift_x = out1 or drift_x
		curve_angle = out2 or curve_angle
		drift_z = out3 or drift_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_angle, launch_angle = minigame.aim_sphida_shot(aim_angle, launch_angle, tex_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_sphida_ball_position(start_x, start_y, start_z)
			event.set_character_position(8, start_x, start_y, start_z)
			event.set_character_position(9, start_x, start_y, start_z)
			minigame.finish_sphida_round(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, shot_power, aim_angle, curve_angle, drift_x, level = minigame.run_sphida_power_gauge(shot_power, tex_bank, aim_angle, curve_angle, drift_x, sound_id, level)
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
	is_cup_in = 0
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
		wait.frames(10)
	end
	if shot_power <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.frames(25)
		if level ~= 4 then
			event.play_sound_effect(sound_id, 3)
		end
	elseif shot_power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.frames(34)
		event.play_sound_effect(sound_id, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.frames(39)
		if level == 0 then
			event.play_sound_effect(sound_id, 12)
		else
			event.play_sound_effect(sound_id, 1)
		end
	end
	if level == 4 then
		wait.frames(50)
		minigame.consume_sphida_shot(sound_id)
		event.set_sphida_ball_position(start_x, start_y, start_z)
		event.set_character_position(8, start_x, start_y, start_z)
		event.set_character_position(9, start_x, start_y, start_z)
		minigame.finish_sphida_round(0)
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
	curve_angle = vm.f32(vm.f32(curve_angle * vm.f32(3.1415927)) / 2.0)
	drift_z = vm.f32(vm.f32(vm.f32(-velocity_z * curve_factor) * drift_x) * vm.f32(0.4))
	drift_x = vm.f32(vm.f32(vm.f32(-velocity_x * curve_factor) * drift_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	out_of_bounds = 0
	level = 0
	sound_cooldown = 0
	do
		local out1, out2, out3, out4, out5 =
			event.get_segment_collision_13(0, ball_x, ball_y + 5.0, ball_z, ball_x, ball_y, ball_z, 0)
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
		collision_result = out4 or collision_result
		surface_type = out5 or surface_type
	end
	if collision_result >= 0 and (surface_type == 1 or surface_type == 7) then
		print("----------------START_MIZU-------------------\n")
		shot_power = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		shot_power = 0.0
	end
	step = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (step + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_result = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_result
			if level == 1 and collision_result >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (step + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + drift_x)
				velocity_z = vm.f32(velocity_z + drift_z)
				drift_x = vm.f32(drift_x * vm.f32(0.8))
				drift_z = vm.f32(drift_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (step + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if curve_angle ~= 0.0 then
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			launch_angle = vm.f32(launch_angle + curve_angle)
			launch_angle = event.wrap_angle(launch_angle) or launch_angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(launch_angle) / 10.0) * curve_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(launch_angle) / 10.0) * curve_factor))
		end
		length = event.get_vector_length(drift_x, 0.0, drift_z) or length
		if length > vm.f32(0.01) then
			speed = event.get_vector_length(drift_x, 0.0, drift_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + drift_x, previous_y, previous_z + drift_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rot_x = out1 or rot_x
				aim_angle = out2 or aim_angle
				rot_z = out3 or rot_z
			end
			event.set_character_rotation(8, rot_x, launch_angle, rot_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, rot_x, launch_angle, rot_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rot_x = out1 or rot_x
				aim_angle = out2 or aim_angle
				rot_z = out3 or rot_z
			end
			event.set_character_rotation(8, rot_x, launch_angle, rot_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, rot_x, launch_angle, rot_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		previous_speed = speed
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
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, previous_x, previous_y, previous_z, ball_x + probe_x, ball_y + probe_y, ball_z + probe_z, 0)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			collision_result = out4 or collision_result
			surface_type = out5 or surface_type
		end
		if collision_result >= 0 and (surface_type == 1 or surface_type == 7) then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(hit_x, hit_y, hit_z)
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_id, 11)
				sound_cooldown = 10
			end
			if shot_power == 0.0 then
				shot_power = 1.0
				velocity_x = vm.f32(velocity_x * vm.f32(0.4))
				velocity_y = vm.f32(velocity_y * vm.f32(0.4))
				velocity_z = vm.f32(velocity_z * vm.f32(0.4))
				drift_x = 0.0
				drift_z = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				shot_power = 0.0
				print("----------------SE ON-------------------\n")
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
			collision_result = out7 or collision_result
		end
		if collision_result < 0 then
			if ball_y >= 380.0 and velocity_y > 0.0 then
				do
					local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
				end
				do
					local out1, out2, out3 = event.copy_vector(velocity_x, -velocity_y, velocity_z)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(normal_x, normal_y, normal_z)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				collision_result = 1
			end
		end
		while collision_result >= 0 do
			curve_angle = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if shot_power ~= 1.0 and sound_cooldown <= 0 then
				event.play_sound_effect(sound_id, 6)
				sound_cooldown = 10
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
			length = event.get_vector_length(previous_x, previous_y, previous_z) or length
			length = vm.f32(previous_speed - length)
			if length <= 0.0 then
				break
			else
				previous_speed = length
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				if velocity_y < 0.0 and normal_y > 0.0 then
					velocity_x = vm.f32(drift_x * 2.0)
					velocity_y = 0.0
					velocity_z = vm.f32(drift_z * 2.0)
					drift_x = vm.f32(drift_x * vm.f32(0.2))
					drift_z = vm.f32(drift_z * vm.f32(0.2))
				else
					if
						velocity_x < 0.0 and normal_x > 0.0
						or velocity_x > 0.0 and normal_x < 0.0
						or velocity_z < 0.0 and normal_z > 0.0
						or velocity_z > 0.0 and normal_z < 0.0
					then
						drift_x = 0.0
						drift_z = 0.0
					end
					velocity_x = 0.0
					velocity_y = 0.0
					velocity_z = 0.0
				end
				if shot_power == 0.0 then
					velocity_x = vm.f32(vm.f32(vm.f32(normal_x * speed) * vm.f32(0.9)) + velocity_x)
					velocity_y = vm.f32(vm.f32(vm.f32(normal_y * speed) * vm.f32(0.58)) + velocity_y)
					velocity_z = vm.f32(vm.f32(vm.f32(normal_z * speed) * vm.f32(0.9)) + velocity_z)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					velocity_x = vm.f32(vm.f32(vm.f32(normal_x * speed) * vm.f32(0.8)) + velocity_x)
					velocity_y = vm.f32(vm.f32(vm.f32(normal_y * speed) * vm.f32(0.4)) + velocity_y)
					velocity_z = vm.f32(vm.f32(vm.f32(normal_z * speed) * vm.f32(0.8)) + velocity_z)
				end
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
					local out1, out2, out3 = event.scale_vector(normal_x, normal_y, normal_z, length)
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
					local out1, out2, out3, out4, out5, out6, out7, out8 = event.get_segment_collision_16(
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
					collision_result = out7 or collision_result
					surface_type = out8 or surface_type
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
			collision_result = out7 or collision_result
			surface_type = out8 or surface_type
		end
		if collision_result >= 0 then
			curve_angle = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			length = event.get_vector_length(velocity_x, 0.0, velocity_z) or length
			if length < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				level = 1
			else
				if shot_power == 0.0 then
					velocity_x = vm.f32(velocity_x * vm.f32(0.9))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
					velocity_z = vm.f32(velocity_z * vm.f32(0.9))
					velocity_x = vm.f32(velocity_x + vm.f32(drift_x * 2.0))
					velocity_z = vm.f32(velocity_z + vm.f32(drift_z * 2.0))
					drift_x = vm.f32(drift_x * vm.f32(0.2))
					drift_z = vm.f32(drift_z * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					velocity_x = vm.f32(velocity_x * vm.f32(0.8))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.4))
					velocity_z = vm.f32(velocity_z * vm.f32(0.8))
					drift_x = 0.0
					drift_z = 0.0
				end
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if shot_power ~= 1.0 and sound_cooldown <= 0 then
					event.play_sound_effect(sound_id, 5)
					sound_cooldown = 10
				end
			end
			length = event.get_vector_length(drift_x, 0.0, drift_z) or length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and length < vm.f32(0.4) then
				if surface_type == 6 then
					out_of_bounds = 1
					break
				end
				surface_type = event.get_automap_attribute_status(ball_x, ball_y, ball_z) or surface_type
				if not (surface_type == 1) then
					break
				end
				out_of_bounds = 1
				break
			end
		end
		if ball_y < -500.0 then
			out_of_bounds = 1
			break
		elseif step >= 480 then
			out_of_bounds = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			x = vm.f32(pos_x - ball_x)
			y = vm.f32(pos_y - ball_y)
			z = vm.f32(pos_z - ball_z)
			pin_distance = event.get_vector_length(x, y, z) or pin_distance
			if ball_color ~= pin_color then
				pin_path_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pos_x, pos_y, pos_z) or pin_path_distance
				if pin_path_distance >= 0.0 and pin_path_distance <= 30.0 then
					is_cup_in = 1
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
					is_cup_in = 1
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
			if ball_y <= -50.0 then
				event.set_follow_camera_following(0)
				if out_of_bounds >= 30 then
					if out_of_bounds >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				out_of_bounds = out_of_bounds + 1
			elseif step >= 20 then
				event.set_camera_control_range(20.0, 30.0, 60.0, 200.0)
				event.set_camera_speed(8.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_target(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z
				)
				do
					local out1, out2, out3 = event.get_camera_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				yaw = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.set_camera_control_rotation(yaw)
				event.move_camera_control_with_pad(8)
				event.step_camera_control()
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(15)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			step = step + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if out_of_bounds == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		count = event.get_sphida_par() or count
		if is_cup_in == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pos_x, pos_y, pos_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_id, 17)
			step = 0
			while step < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				step = step + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			step = 0
			while step < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				step = step + 1
				vm.wait(17)
			end
			event.set_character_active(0, 11)
			pin_color = event.get_dungeon_stage_id() or pin_color
			ball_color = event.get_dungeon_floor() or ball_color
			collision_result = event.get_dungeon_floor_info(pin_color, ball_color, 4) or collision_result
			do
				local out1, out2 = event.get_sphida_prize(collision_result)
				sound_cooldown = out1 or sound_cooldown
				surface_type = out2 or surface_type
			end
			collision_result = vm.i32(collision_result + 1)
			event.set_dungeon_floor_info(pin_color, ball_color, 4, collision_result)
			event.place_treasure_box(pos_x, pos_y - 30.0, pos_z, launch_angle, sound_cooldown, surface_type)
			wait.frames(54)
			wait.frames(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_id
			event.stop_music(0)
			event.play_sound_effect(sound_id, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			sound_cooldown = event.get_language() or sound_cooldown
			if sound_cooldown == 0 then
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
				event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			else
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
				event.set_event_sprite_texture_rect(0, 206, 0, 306, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			end
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
			object.wait_until_done(0)
			wait.frames(90)
			vm.wait(22)
			event.play_music(0)
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		elseif count >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			choice = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(24)
			if choice == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
					collision_result = out1 or collision_result
					start_x = out2 or start_x
					start_y = out3 or start_y
					start_z = out4 or start_z
				end
				if collision_result == 0 then
					do
						local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
						start_x = out1 or start_x
						start_y = out2 or start_y
						start_z = out3 or start_z
					end
				end
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				speed = event.get_distance_between(start_x, start_y, start_z, pos_x, pos_y, pos_z) or speed
				if speed < 40.0 then
					launch_angle = event.get_random_number(6.2831855) or launch_angle
					launch_angle = vm.f32(launch_angle - vm.f32(3.1415927))
					start_x = vm.f32(start_x + vm.f32(vm.sin(launch_angle) * 50.0))
					start_z = vm.f32(start_z + vm.f32(vm.cos(launch_angle) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(start_x, start_y, start_z)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						collision_result = out4 or collision_result
					end
					step = 0
					while collision_result >= 0 do
						do
							local out1, out2, out3 = event.copy_vector(start_x, start_y, start_z)
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
						previous_x = vm.f32(previous_x + 1.0)
						previous_z = vm.f32(previous_z + 1.0)
						do
							local out1, out2, out3 = event.normalize_vector(previous_x, previous_y, previous_z)
							previous_x = out1 or previous_x
							previous_y = out2 or previous_y
							previous_z = out3 or previous_z
						end
						do
							local out1, out2, out3 = event.scale_vector(previous_x, previous_y, previous_z, 30.1)
							previous_x = out1 or previous_x
							previous_y = out2 or previous_y
							previous_z = out3 or previous_z
						end
						do
							local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
							start_x = out1 or start_x
							start_y = out2 or start_y
							start_z = out3 or start_z
						end
						do
							local out1, out2, out3 = event.add_vectors(start_x, start_y, start_z, previous_x, previous_y, previous_z)
							start_x = out1 or start_x
							start_y = out2 or start_y
							start_z = out3 or start_z
						end
						step = step + 1
						if step > 6 then
							break
						end
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(start_x, start_y, start_z)
							hit_x = out1 or hit_x
							hit_y = out2 or hit_y
							hit_z = out3 or hit_z
							collision_result = out4 or collision_result
						end
					end
				end
				aim_angle = event.get_direction_angle(start_x, start_y, start_z, ball_x, ball_y, ball_z) or aim_angle
				event.set_character_position(0, start_x, start_y, start_z)
				event.set_character_rotation(0, 0.0, aim_angle, 0.0)
				event.set_camera_look_at(start_x, start_y + 30.0, start_z)
				aim_angle = vm.f32(aim_angle - vm.f32(3.1415927))
				aim_angle = event.wrap_angle(aim_angle) or aim_angle
				start_x = vm.f32(vm.f32(vm.sin(aim_angle) * 100.0) + start_x)
				start_y = vm.f32(start_y + 30.0)
				start_z = vm.f32(vm.f32(vm.cos(aim_angle) * 100.0) + start_z)
				event.set_camera_position(start_x, start_y, start_z)
				event.reset_follow_camera(0)
			end
		end
	else
		event.play_sound_effect(sound_id, 18)
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
		wait.frames(20)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_sphida_ball_position(start_x, start_y, start_z)
		event.set_character_position(8, start_x, start_y, start_z)
		event.set_character_position(9, start_x, start_y, start_z)
		event.release_camera_sequence_follow_object()
	end
	if is_cup_in == 1 then
		minigame.consume_sphida_shot(-1)
	else
		minigame.consume_sphida_shot(sound_id)
	end
	minigame.finish_sphida_round(is_cup_in)
end

--- Offers to move the Sphida ball to the player.
function script.sphida_near_ball()
	local answer: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	answer = message.ask_choice(0, 2004, 8, 0, 0, 2, 1)
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
		minigame.consume_sphida_shot(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- Warns this is the last move of the Sphida ball and offers to move it to the player.
function script.sphida_near_ball_last()
	local answer: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Esta es la [UNI00fa]ltima vez que\npodr[UNI00e1]s mover la Esfera hacia ti.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "[UNI00bf]Acercar la Esfera?")
	answer = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
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
		event.set_sphida_last_challenge(1)
		event.start_crossfade(15)
	end
	vm.wait(3)
	event.finish_event()
end

--- Starts the Sphida course on the practice floor.
function script.start_sphida_course()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.load_dungeon_map("d04f02", "d04f02", 8)
		at = 2
		play_floor_arrival_scene(0)
		minigame.set_up_sphida_course_with_draw_distance(0, -1)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				play_floor_arrival_scene(0)
				return vm.continue_with(function()
					minigame.set_up_sphida_course_with_draw_distance(0, -1)
					return
				end)
			end
			cutscene.noop_with_arguments(0, -1)
			return 0
		end
		return nil
	end)
end
script[4000] = script.start_sphida_course

--- Leaves Sphida and plays the rotating gate scene before the next map.
function script.leave_sphida_to_rotating_gate()
	local at: number = 0
	return vm.guard(function()
		at = 1
		minigame.leave_sphida()
		event.load_dungeon_map("d04f02", "d04f02", 40)
		at = 2
		oceans_roar_cave.play_rotating_gate_scene()
		event.skip_next_music_load()
		event.load_dungeon_map("s46")
		event.load_event_script("s46/s46.stb", 520)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				oceans_roar_cave.play_rotating_gate_scene()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.load_dungeon_map("s46")
					event.load_event_script("s46/s46.stb", 520)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[14060] = script.leave_sphida_to_rotating_gate

--- Leaves Sphida and returns to the floor 9 side area.
function script.leave_sphida_to_floor_9_area_14080()
	minigame.leave_sphida()
	event.load_dungeon_map("s19")
	event.load_event_script("s19/s19.stb", 14080)
end
script[14080] = script.leave_sphida_to_floor_9_area_14080

--- Leaves Sphida and returns to the floor 9 side area.
function script.leave_sphida_to_floor_9_area_14100()
	minigame.leave_sphida()
	event.load_dungeon_map("s19")
	event.load_event_script("s19/s19.stb", 14100)
end
script[14100] = script.leave_sphida_to_floor_9_area_14100

--- Leaves Sphida and returns to the floor 9 side area.
function script.leave_sphida_to_floor_9_area_14160()
	minigame.leave_sphida()
	event.load_dungeon_map("s19")
	event.load_event_script("s19/s19.stb", 14160)
end
script[14160] = script.leave_sphida_to_floor_9_area_14160

--- Leaves Sphida and returns to the floor 9 side area.
function script.leave_sphida_to_floor_9_area_14200()
	minigame.leave_sphida()
	event.load_dungeon_map("s19")
	event.load_event_script("s19/s19.stb", 14200)
end
script[14200] = script.leave_sphida_to_floor_9_area_14200

--- Leaves Sphida, resets the story flags, gives the reward item and goes to the Georama.
function script.leave_sphida_to_georama_with_item()
	minigame.leave_sphida()
	event.set_save_flag(400, 1)
	event.set_save_flag(432, 0)
	event.set_save_flag(434, 0)
	event.set_save_flag(436, 0)
	event.set_save_flag(438, 0)
	event.add_inventory_item(373)
	event.go_to_georama_edit(90, 100)
end
script[14320] = script.leave_sphida_to_georama_with_item

--- Leaves Sphida, resets the story flags, takes the reward item back and goes to the Georama.
function script.leave_sphida_to_georama_without_item()
	minigame.leave_sphida()
	event.set_save_flag(400, 1)
	event.set_save_flag(432, 0)
	event.set_save_flag(436, 0)
	event.set_save_flag(438, 0)
	event.remove_item(373, 900)
	event.go_to_georama_edit(90, 100)
end
script[14360] = script.leave_sphida_to_georama_without_item

--- Leaves Sphida and returns to the boss floor map.
function script.return_to_boss_floor_14400()
	minigame.leave_sphida()
	event.load_dungeon_map("d04b01")
	event.load_event_script("d04b01/d04b01.stb", 14400)
end
script[14400] = script.return_to_boss_floor_14400

--- Leaves Sphida and returns to the boss floor map.
function script.return_to_boss_floor_14440()
	minigame.leave_sphida()
	event.load_dungeon_map("d04b01")
	event.load_event_script("d04b01/d04b01.stb", 14440)
end
script[14440] = script.return_to_boss_floor_14440

--- Sets the party's stats and equipment and starts the floor 9 side area.
function script.start_floor_9_area_with_loadout()
	local item_count: s32 = 0
	event.set_character_max_hp(0, 80)
	event.set_character_max_hp(1, 80)
	event.set_character_defence(0, 22)
	event.set_character_defence(1, 22)
	item_count = event.get_item_count(270) or item_count
	if item_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - item_count))
	end
	event.add_inventory_item(17)
	event.equip_character_item(0, 17)
	event.add_inventory_item(26)
	event.equip_character_item(0, 26)
	event.add_inventory_item(54)
	event.equip_character_item(1, 54)
	event.add_inventory_item(94)
	event.equip_character_item(1, 94)
	event.load_dungeon_map("s19")
	vm.wait(1)
	event.load_event_script("s19/s19.stb", 151)
end
script[24010] = script.start_floor_9_area_with_loadout

--- Sets the party's stats and equipment and starts the boss floor map.
function script.start_boss_floor_with_loadout()
	local item_count: s32 = 0
	event.set_character_max_hp(0, 80)
	event.set_character_max_hp(1, 80)
	event.set_character_defence(0, 22)
	event.set_character_defence(1, 22)
	item_count = event.get_item_count(270) or item_count
	if item_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - item_count))
	end
	event.add_inventory_item(17)
	event.equip_character_item(0, 17)
	event.add_inventory_item(26)
	event.equip_character_item(0, 26)
	event.add_inventory_item(54)
	event.equip_character_item(1, 54)
	event.add_inventory_item(94)
	event.equip_character_item(1, 94)
	event.load_dungeon_map("d04b01")
	vm.wait(1)
	event.load_event_script("d04b01/d04b01.stb", 24020)
end
script[24020] = script.start_boss_floor_with_loadout

--- Sets the stronger party stats and equipment and starts the later map.
function script.start_later_map_with_loadout()
	local item_count: s32 = 0
	event.set_character_max_hp(0, 160)
	event.set_character_max_hp(1, 160)
	event.set_character_defence(0, 50)
	event.set_character_defence(1, 50)
	item_count = event.get_item_count(270) or item_count
	if item_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - item_count))
	end
	event.add_inventory_item(16)
	event.equip_character_item(0, 16)
	event.add_inventory_item(27)
	event.equip_character_item(0, 27)
	event.add_inventory_item(71)
	event.equip_character_item(1, 71)
	event.add_inventory_item(100)
	event.equip_character_item(1, 100)
	event.load_dungeon_map("s15")
	vm.wait(1)
	event.load_event_script("s15/s15.stb", 26030)
end
script[26030] = script.start_later_map_with_loadout

return script
