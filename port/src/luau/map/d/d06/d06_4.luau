--!strict
--- Event script for the d06 dungeon floors covering floor entry, doors, random circles, the geostone, guide messages and the Sphida course.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local moon_flower_palace = require("@lib/event/moon_flower_palace")
local object = require("@lib/event/object")
local spheda = require("@lib/event/italian/spheda")
local sphida_hint = require("@lib/event/italian/sphida_hint")
local treasure_box = require("@lib/event/italian/treasure_box")
local wait = require("@lib/event/wait")

--- Plays the floor entry cutscene with the floor map or title logo, then announces any seal on the floor.
local function play_floor_intro(show_floor_map: s32)
	local sound_effect: s32 = 0
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local world_rotation_y: f32 = 0
	local floor: s32 = 0
	local previous_floor: s32 = 0
	local seal_flags: s32 = 0
	local texture_block: s32 = 0
	local map_part_group: s32 = 0
	local part_1_rotation_x: f32 = 0
	local part_1_rotation_y: f32 = 0
	local part_1_rotation_z: f32 = 0
	local part_2_rotation_x: f32 = 0
	local part_2_rotation_y: f32 = 0
	local part_2_rotation_z: f32 = 0
	local part_3_rotation_x: f32 = 0
	local part_3_rotation_y: f32 = 0
	local part_3_rotation_z: f32 = 0
	local part_4_rotation_x: f32 = 0
	local part_4_rotation_y: f32 = 0
	local part_4_rotation_z: f32 = 0
	local part_5_rotation_x: f32 = 0
	local part_5_rotation_y: f32 = 0
	local part_5_rotation_z: f32 = 0
	local seal_sound_effect: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_037.sound.json") or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			world_x = out1 or world_x
			world_y = out2 or world_y
			world_z = out3 or world_z
			world_rotation_y = out4 or world_rotation_y
		end
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation_y)
		if show_floor_map == 0 then
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d05_1.json", 0)
			event.set_event_image_texture(0, "logo_d05")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 30)
		else
			floor = event.get_dungeon_floor() or floor
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			event.load_dungeon_map_display(5, 0, 5, floor, previous_floor)
			event.fade_dungeon_map(1, 30)
		end
		seal_flags = event.get_dungeon_floor_status() or seal_flags
		if seal_flags ~= 0 then
			if bit32.band(seal_flags, 1) ~= 0 then
				event.switch_dungeon_main_character(1)
			end
			if bit32.band(seal_flags, 2) ~= 0 then
				event.switch_dungeon_main_character(0)
			end
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 80.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(0, 21)
		map_part_group = event.get_triggered_event_data_2(9) or map_part_group
		event.attach_object_handle_to_map_part_3(1, map_part_group, "d06w09_3-m")
		do
			local out1, out2, out3 = event.get_object_handle_rotation(1)
			part_1_rotation_x = out1 or part_1_rotation_x
			part_1_rotation_y = out2 or part_1_rotation_y
			part_1_rotation_z = out3 or part_1_rotation_z
		end
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, map_part_group, "d06w09_3-m1")
		do
			local out1, out2, out3 = event.get_object_handle_rotation(2)
			part_2_rotation_x = out1 or part_2_rotation_x
			part_2_rotation_y = out2 or part_2_rotation_y
			part_2_rotation_z = out3 or part_2_rotation_z
		end
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_3(3, map_part_group, "d06w09_3-m2")
		do
			local out1, out2, out3 = event.get_object_handle_rotation(3)
			part_3_rotation_x = out1 or part_3_rotation_x
			part_3_rotation_y = out2 or part_3_rotation_y
			part_3_rotation_z = out3 or part_3_rotation_z
		end
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, map_part_group, "d06w09_3-m3")
		do
			local out1, out2, out3 = event.get_object_handle_rotation(4)
			part_4_rotation_x = out1 or part_4_rotation_x
			part_4_rotation_y = out2 or part_4_rotation_y
			part_4_rotation_z = out3 or part_4_rotation_z
		end
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, map_part_group, "d06w09_3-m4")
		do
			local out1, out2, out3 = event.get_object_handle_rotation(5)
			part_5_rotation_x = out1 or part_5_rotation_x
			part_5_rotation_y = out2 or part_5_rotation_y
			part_5_rotation_z = out3 or part_5_rotation_z
		end
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.show_dungeon_status_bar(0, 1.0)
		event.play_sound_effect(sound_effect, 1)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 5.0, 200.0)
		event.set_camera_sequence_look_at(0.0, 22.0, 110.0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.rotate_object_sequence_eased(1, part_1_rotation_x - 1.0, part_1_rotation_y, part_1_rotation_z, 20, 0, 1.0)
		event.rotate_object_sequence_eased(2, part_2_rotation_x - 1.0, part_2_rotation_y, part_2_rotation_z, 20, 0, 1.0)
		event.rotate_object_sequence_eased(3, part_3_rotation_x - 1.0, part_3_rotation_y, part_3_rotation_z, 20, 0, 1.0)
		event.rotate_object_sequence_eased(4, part_4_rotation_x - 1.0, part_4_rotation_y, part_4_rotation_z, 20, 0, 1.0)
		event.rotate_object_sequence_eased(5, part_5_rotation_x - 1.0, part_5_rotation_y, part_5_rotation_z, 20, 0, 1.0)
		if show_floor_map == 1 then
			event.set_dungeon_map_piece_moving(1)
		end
		wait.frames(30)
		event.set_object_sequence_motion(0, "歩き", 0, -1.0, 1)
		event.move_object_sequence(0, 0.0, 0.0, 140.0, 60)
		wait.frames(10)
		event.show_dungeon_status_bar(1)
		wait.frames(10)
		event.rotate_object_sequence_eased(1, part_1_rotation_x, part_1_rotation_y, part_1_rotation_z, 20, 0, 1.0)
		event.rotate_object_sequence_eased(2, part_2_rotation_x, part_2_rotation_y, part_2_rotation_z, 20, 0, 1.0)
		event.rotate_object_sequence_eased(3, part_3_rotation_x, part_3_rotation_y, part_3_rotation_z, 20, 0, 1.0)
		event.rotate_object_sequence_eased(4, part_4_rotation_x, part_4_rotation_y, part_4_rotation_z, 20, 0, 1.0)
		event.rotate_object_sequence_eased(5, part_5_rotation_x, part_5_rotation_y, part_5_rotation_z, 20, 0, 1.0)
		wait.frames(20)
		if show_floor_map == 1 then
			event.fade_dungeon_map(0, 30)
		else
			event.fade_event_image(0, 0, 30)
		end
		wait.frames(20)
		event.set_object_sequence_motion(0, "立ち")
		wait.frames(12)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.fade_in_screen(0)
	event.stop_sound_effect(sound_effect, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.delete_event_image(0)
	if show_floor_map == 1 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	end
	event.set_camera_sequence_look_at(0.0, 30.0, 140.0)
	event.set_camera_sequence_position(0.0, 50.0, 80.0)
	vm.wait(9)
	event.set_object_handle_position(0, 0.0, 0.0, 140.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_object_handle_footstep_sound(0, -1)
	event.set_object_handle_rotation(1, part_1_rotation_x, part_1_rotation_y, part_1_rotation_z)
	event.set_object_handle_rotation(2, part_2_rotation_x, part_2_rotation_y, part_2_rotation_z)
	event.set_object_handle_rotation(3, part_3_rotation_x, part_3_rotation_y, part_3_rotation_z)
	event.set_object_handle_rotation(4, part_4_rotation_x, part_4_rotation_y, part_4_rotation_z)
	event.set_object_handle_rotation(5, part_5_rotation_x, part_5_rotation_y, part_5_rotation_z)
	event.reset_follow_camera(0)
	event.initialize_event()
	if seal_flags ~= 0 then
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(10)
			wait.background_load()
			texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or texture_block
			event.set_event_sprite_texture(0, "aka_fuuin", texture_block)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(12)
			wait.background_load()
			texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or texture_block
			event.set_event_sprite_texture(0, "ao_fuuin", texture_block)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(14)
			wait.background_load()
			texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/shiro_fuuin_1.json", 0) or texture_block
			event.set_event_sprite_texture(0, "shiro_fuuin", texture_block)
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
		seal_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_050.sound.json") or seal_sound_effect
		event.play_sound_effect(seal_sound_effect, 0)
		event.set_message_window_mode(0, 4)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.open_message_window_2(0, "Pare ci sia un Sigillo rosso sul piano.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Max ha l'Atlamillia rossa.\nNon puoi passare a lui!")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.open_message_window_2(0, "Pare ci sia un Sigillo blu sul piano.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Monica ha l'Atlamillia blu.\nNon puoi passare a lei!")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.open_message_window_2(0, "Pare ci sia un Sigillo bianco sul piano.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Non [UNI00e8] pi[UNI00f9] possibile ripristinare\nla salute o curare stati alterati.")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		event.set_event_sprite_draw_pass(0, 0)
		event.delete_event_image(0)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Loads the map, monsters and music for the current dungeon floor and plays its entry sequence.
local function load_dungeon_floor()
	local stage_id: s32 = 0
	local floor: s32 = 0
	local previous_floor: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(0)
		resume_point = 1
		vm.wait(1)
		event.reset_action_character_motion(0)
		event.set_local_event_flag(0, 0)
		event.set_local_event_flag(1, 0)
		event.set_local_event_flag(2, 0)
		event.set_local_event_flag(3, 0)
		event.set_local_event_flag(4, 0)
		event.set_event_projection(524.9)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		event.get_dungeon_floor_info(stage_id, floor, 7)
		dungeon.increment_floor_counter(stage_id, floor)
		event.initialize_dungeon_floor()
		if floor == 0 then
			event.go_to_georama_edit(109, 100)
			return
		end
		if floor == 11 then
			event.load_dungeon_map("s21")
			event.load_event_script("s21/s21.stb", 100)
			return
		end
		if floor == 21 then
			event.load_dungeon_map("s50")
			event.load_event_script("s50/s50.stb", 100)
			return
		end
		if floor == 27 then
			event.load_dungeon_map("s23")
			event.load_event_script("s23/s23.stb", 100)
			return
		end
		if floor == 26 then
			event.allow_next_music_load()
			event.stop_music(0)
			resume_point = 2
			wait.frames(6)
			event.load_music(37)
			event.skip_next_music_load()
		end
		if floor >= 1 and floor <= 4 or floor >= 12 and floor <= 20 then
			event.load_dungeon_map("d06f01", "d06f01")
		end
		if floor >= 5 and floor <= 10 then
			event.load_dungeon_map("d06f02", "d06f02")
		end
		if floor >= 22 and floor <= 26 then
			event.load_dungeon_map("d06f03", "d06f03")
		end
		event.load_dungeon_monster(0)
		event.place_treasure_box_at_event_point(-1)
		event.place_dungeon_monster(-1)
		event.play_music(0)
		previous_floor = event.get_dungeon_previous_floor() or previous_floor
		if floor == previous_floor then
			resume_point = 3
			play_floor_intro(0)
		else
			resume_point = 4
			play_floor_intro(1)
		end
		event.load_sound_effect_file_3(4, "snd2/event/ev_200_010.sound.json")
		dungeon.show_floor_title()
		return
	end, function(received: { any })
		if resume_point <= 1 then
			dungeon.increment_floor_counter_skipping(stage_id, floor)
			return 0
		end
		if resume_point <= 4 then
			if resume_point <= 2 then
				resume_point = 3
				play_floor_intro(0)
				return vm.continue_with(function()
					event.load_sound_effect_file_3(4, "snd2/event/ev_200_010.sound.json")
					dungeon.show_floor_title()
					return
				end)
			end
			if resume_point <= 3 then
				resume_point = 4
				play_floor_intro(1)
				return vm.continue_with(function()
					event.load_sound_effect_file_3(4, "snd2/event/ev_200_010.sound.json")
					dungeon.show_floor_title()
					return
				end)
			end
			cutscene.noop()
			return 0
		end
		return nil
	end)
end

--- Plays the floor music, opens the floor map and enters the floor chosen on it.
local function start_floor_from_map()
	local music_number: s32 = 0
	local previous_floor: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 21 then
		event.stop_music(0)
		wait.frames(6)
		event.load_music(21)
	end
	event.play_music(0)
	event.load_map_sounds(7601)
	event.open_dungeon_floor_map(5)
	vm.wait(2)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		previous_floor = out2 or previous_floor
		floor = out3 or floor
	end
	event.set_dungeon_floor(floor)
	event.set_dungeon_previous_floor(previous_floor)
	load_dungeon_floor()
end

--- Handles the player reaching a door by asking for the key item and moving on to the next floor.
local function interact_with_door(door_index: s32)
	local is_door_unlocked: s32 = 0
	local trigger_mode: s32 = 0
	local answer: s32 = 0
	local item: s32 = 0
	local playable_character: s32 = 0
	local choice: any = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	is_door_unlocked = event.get_local_event_flag(door_index) or is_door_unlocked
	event.set_dungeon_pause_flags(1, 1)
	if is_door_unlocked == 0 then
		trigger_mode = event.get_triggered_event_data_2(6) or trigger_mode
		if trigger_mode == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			answer = message.ask_confirmation(0, 5, 5, 256, 208, answer)
			event.set_message_window_mode(0, 7)
			event.set_message_draw_speed(0, 0)
			if answer == 1 then
				trigger_mode = 2
			end
			event.finish_event()
		end
		if trigger_mode == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait.frames(6)
			event.open_use_item_menu(348)
			vm.wait(3)
			item = vmhost.used_item() or item
			if item == 348 then
				event.set_local_event_flag(door_index, 1)
				moon_flower_palace.exit_through_door(door_index)
			elseif item <= 0 then
				event.finish_event()
			else
				character.shake_head()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
			wait.frames(6)
		end
	else
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 or playable_character == 3 then
			event.initialize_event()
			character.reset_action_motion()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if playable_character == 2 then
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
			moon_flower_palace.run_into_door()
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
			next_floor = event.get_dungeon_next_floor(floor, door_index) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			event.finish_dungeon_floor()
			start_floor_from_map()
		else
			event.finish_event()
		end
	end
	event.set_dungeon_pause_flags(1, 0)
end

--- Plays the victory sequence for the finished floor, announces rewards and offers the Sphida courses.
local function clear_floor()
	local playable_character: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local always_zero_flag: s32 = 0
	local sphida_save_flag: s32 = 0
	local sub_game_flags: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local clear_time_record: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local is_trial_version: s32 = 0
	local seal_flags: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		character.reset_action_motion()
		event.set_dungeon_pause_flags(512, 1)
		event.show_dungeon_status_bar(0, 0.16666667)
		resume_point = 1
		wait.frames(10)
		event.set_dungeon_pause_flags(16384, 1)
		event.clear_event_battle_monsters(-1)
		if playable_character == 0 then
			resume_point = 2
			dungeon.play_max_victory(1)
		end
		if playable_character == 1 then
			resume_point = 3
			dungeon.play_monica_victory(1)
		end
		if playable_character == 2 or playable_character == 3 then
			resume_point = 4
			dungeon.play_finish_banner(playable_character)
		end
		event.set_dungeon_pause_flags(16384, 0)
		moon_flower_palace.restore_opened_door()
		event.reset_action_character_motion(0, 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.show_dungeon_status_bar(1, 0.16666667)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		event.set_dungeon_floor_info(stage_id, floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
		sphida_save_flag = event.get_save_flag(220) or sphida_save_flag
		sphida_save_flag = event.get_save_flag(317) or sphida_save_flag
		sub_game_flags = event.get_floor_sub_games() or sub_game_flags
		if (if sphida_save_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
			event.clear_random_stones()
			minigame.set_up_sphida_course_with_draw_distance(0, -1)
		end
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		event.set_camera_position(camera_x, camera_y, camera_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		event.set_camera_look_at(camera_x, camera_y, camera_z)
		clear_time_record = event.record_floor_clear_time() or clear_time_record
		do
			local out1, out2 = event.get_floor_practice_result(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		resume_point = 5
		spheda.announce_medal_reward(clear_time_record, cleared, bonus)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		is_trial_version = event.is_trial_version() or is_trial_version
		seal_flags = event.get_dungeon_floor_status() or seal_flags
		if
			(if (if bit32.band(seal_flags, 1) ~= 0 then 1 else bit32.band(seal_flags, 2)) ~= 0 then 1 else bit32.band(seal_flags, 4))
			~= 0
		then
			event.set_dungeon_floor_status_flags(7, 0)
			if bit32.band(seal_flags, 1) ~= 0 then
				event.open_message_window_2(0, "Il Sigillo rosso [UNI00e8] stato infranto.")
			end
			if bit32.band(seal_flags, 2) ~= 0 then
				event.open_message_window_2(0, "Il Sigillo blu [UNI00e8] stato infranto.")
			end
			if bit32.band(seal_flags, 4) ~= 0 then
				event.open_message_window_2(0, "Il Sigillo bianco [UNI00e8] stato infranto.")
			end
			resume_point = 6
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		resume_point = 7
		message.show_and_wait(0, 2130, 8, 0, 0)
		if is_trial_version ~= 1 then
			if always_zero_flag == 1 and sphida_save_flag == 1 and bit32.band(sub_game_flags, 3) == 3 then
				resume_point = 8
				message.show_and_wait(0, 2120, 8, 0, 0)
				resume_point = 9
				spheda.move_character_to_ball()
			else
				if (if always_zero_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
					resume_point = 10
					message.show_and_wait(0, 2110, 8, 0, 0)
				end
				if (if sphida_save_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
					resume_point = 11
					message.show_and_wait(0, 2100, 8, 0, 0)
					resume_point = 12
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
		if resume_point <= 12 then
			if resume_point <= 1 then
				resume_point = 2
				dungeon.play_max_victory(1)
				return vm.continue_with(function()
					if playable_character == 1 then
						resume_point = 3
						dungeon.play_monica_victory(1)
					end
					if playable_character == 2 or playable_character == 3 then
						resume_point = 4
						dungeon.play_finish_banner(playable_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					moon_flower_palace.restore_opened_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					sphida_save_flag = event.get_save_flag(220) or sphida_save_flag
					sphida_save_flag = event.get_save_flag(317) or sphida_save_flag
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if sphida_save_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
						event.clear_random_stones()
						minigame.set_up_sphida_course_with_draw_distance(0, -1)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_position(camera_x, camera_y, camera_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_look_at(camera_x, camera_y, camera_z)
					clear_time_record = event.record_floor_clear_time() or clear_time_record
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					resume_point = 5
					spheda.announce_medal_reward(clear_time_record, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial_version = event.is_trial_version() or is_trial_version
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
							event.open_message_window_2(0, "Il Sigillo rosso [UNI00e8] stato infranto.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Il Sigillo blu [UNI00e8] stato infranto.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Il Sigillo bianco [UNI00e8] stato infranto.")
						end
						resume_point = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_point = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial_version ~= 1 then
						if always_zero_flag == 1 and sphida_save_flag == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_point = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_point = 9
							spheda.move_character_to_ball()
						else
							if (if always_zero_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_point = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if sphida_save_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_point = 11
								message.show_and_wait(0, 2100, 8, 0, 0)
								resume_point = 12
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
			if resume_point <= 2 then
				resume_point = 3
				dungeon.play_monica_victory(1)
				return vm.continue_with(function()
					if playable_character == 2 or playable_character == 3 then
						resume_point = 4
						dungeon.play_finish_banner(playable_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					moon_flower_palace.restore_opened_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					sphida_save_flag = event.get_save_flag(220) or sphida_save_flag
					sphida_save_flag = event.get_save_flag(317) or sphida_save_flag
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if sphida_save_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
						event.clear_random_stones()
						minigame.set_up_sphida_course_with_draw_distance(0, -1)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_position(camera_x, camera_y, camera_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_look_at(camera_x, camera_y, camera_z)
					clear_time_record = event.record_floor_clear_time() or clear_time_record
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					resume_point = 5
					spheda.announce_medal_reward(clear_time_record, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial_version = event.is_trial_version() or is_trial_version
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
							event.open_message_window_2(0, "Il Sigillo rosso [UNI00e8] stato infranto.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Il Sigillo blu [UNI00e8] stato infranto.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Il Sigillo bianco [UNI00e8] stato infranto.")
						end
						resume_point = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_point = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial_version ~= 1 then
						if always_zero_flag == 1 and sphida_save_flag == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_point = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_point = 9
							spheda.move_character_to_ball()
						else
							if (if always_zero_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_point = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if sphida_save_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_point = 11
								message.show_and_wait(0, 2100, 8, 0, 0)
								resume_point = 12
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
			if resume_point <= 3 then
				resume_point = 4
				dungeon.play_finish_banner(playable_character)
				return vm.continue_with(function()
					event.set_dungeon_pause_flags(16384, 0)
					moon_flower_palace.restore_opened_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					sphida_save_flag = event.get_save_flag(220) or sphida_save_flag
					sphida_save_flag = event.get_save_flag(317) or sphida_save_flag
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if sphida_save_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
						event.clear_random_stones()
						minigame.set_up_sphida_course_with_draw_distance(0, -1)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_position(camera_x, camera_y, camera_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_look_at(camera_x, camera_y, camera_z)
					clear_time_record = event.record_floor_clear_time() or clear_time_record
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					resume_point = 5
					spheda.announce_medal_reward(clear_time_record, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial_version = event.is_trial_version() or is_trial_version
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
							event.open_message_window_2(0, "Il Sigillo rosso [UNI00e8] stato infranto.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Il Sigillo blu [UNI00e8] stato infranto.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Il Sigillo bianco [UNI00e8] stato infranto.")
						end
						resume_point = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_point = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial_version ~= 1 then
						if always_zero_flag == 1 and sphida_save_flag == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_point = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_point = 9
							spheda.move_character_to_ball()
						else
							if (if always_zero_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_point = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if sphida_save_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_point = 11
								message.show_and_wait(0, 2100, 8, 0, 0)
								resume_point = 12
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
			if resume_point <= 4 then
				cutscene.noop_2()
				cutscene.noop_with_arguments(0, -1)
				message.resume_numbered_messages(clear_time_record, cleared, bonus)
			end
			if resume_point <= 5 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if resume_point <= 6 then
				message.show_and_wait_skipping(0, 2130, 8, 0, 0)
			end
			if resume_point <= 7 then
				message.show_and_wait_skipping(0, 2120, 8, 0, 0)
			end
			if resume_point <= 8 then
				message.open_choice_pair_skipping()
			end
			if resume_point <= 9 then
				message.show_and_wait_skipping(0, 2110, 8, 0, 0)
			end
			if resume_point <= 10 then
				message.show_and_wait_skipping(0, 2100, 8, 0, 0)
			end
			if resume_point <= 11 then
				message.open_choice_pair_skipping()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and needs no setup.
function script.setup() end

--- Waits for a button press and finishes the event.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	wait.until_button_pressed(64)
	event.finish_event()
end

--- Gives the party its starting items and sets the save flags the floor expects.
function script.give_starting_items()
	local owned_count: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	owned_count = event.get_owned_item_count(10) or owned_count
	if owned_count <= 0 then
		event.add_inventory_item(10, 1)
	end
	owned_count = event.get_owned_item_count(302) or owned_count
	if owned_count <= 0 then
		event.add_inventory_item(302, 1)
	end
	event.set_save_flag(220, 1)
	event.set_save_flag(317, 1)
	event.clear_event_battle_monsters(-1)
	event.finish_event()
end
script[200] = script.give_starting_items

--- Handles the player reaching the first door.
function script.interact_with_door_0()
	interact_with_door(0)
end
script[300] = script.interact_with_door_0

--- Handles the player reaching the second door after the edit analysis found changes.
function script.edit_analyze_changed()
	interact_with_door(1)
end

--- Handles the player reaching the third door.
function script.interact_with_door_2()
	interact_with_door(2)
end
script[320] = script.interact_with_door_2

--- Unlocks a door with the key item, asking the player to use it when the party has no helper who can.
function script.unlock_door_with_key()
	local party_npc_id: s32 = 0
	local trigger_mode: s32 = 0
	local answer: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 1)
	character.reset_action_motion()
	party_npc_id = event.get_party_npc() or party_npc_id
	if party_npc_id == 4 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Dovete passare da qui, giusto?")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.show_dungeon_status_bar(0, 0.16666667)
		moon_flower_palace.unlock_door_with_key()
		event.show_dungeon_status_bar(1, 0.16666667)
		wait.frames(6)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	trigger_mode = event.get_triggered_event_data_2(6) or trigger_mode
	if trigger_mode == 1 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_draw_speed(0, 1)
		answer = message.ask_confirmation(0, 2505, 5, 256, 208, answer)
		event.set_message_bubble_tail(0, 1)
		event.set_message_draw_speed(0, 0)
		if answer == 1 then
			trigger_mode = 2
		end
	end
	if trigger_mode == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait.frames(6)
		event.open_use_item_menu(349)
		vm.wait(6)
		item = vmhost.used_item() or item
		if item == 349 then
			moon_flower_palace.unlock_door_with_key()
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
script[348] = script.unlock_door_with_key

--- Loads the d06e01 map and runs its script event 500.
function script.load_d06e01_map()
	event.load_dungeon_map("d06e01")
	event.load_event_script("d06e01/d06e01.stb", 500)
	vm.wait(1)
end
script[500] = script.load_d06e01_map

script.start_floor_from_map = start_floor_from_map
script[1000] = script.start_floor_from_map

script.load_dungeon_floor = load_dungeon_floor
script[1010] = script.load_dungeon_floor

--- The dungeon system event run when the player opens a treasure box.
script.treasure_box = treasure_box.open_nearest

--- Plays the random circle sequence in which a spinning coin lands and applies the random effect that results.
function script.random_circle()
	local playable_character: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local robo_circle_x: f32 = 0
	local robo_circle_y: f32 = 0
	local robo_circle_z: f32 = 0
	local push_angle: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local sound_effect: s32 = 0
	local ring_motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local party_npc_id: s32 = 0
	local circle_side: s32 = 0
	local frame_count: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local facing_angle: f32 = 0
	local min_spin_frames: s32 = 0
	local target_angle: f32 = 0
	local roll: s32 = 0
	local threshold: s32 = 0
	local brightness: f32 = 0
	local effect_id: s32 = 0
	local effect_amount: f32 = 0
	local restore_x: f32 = 0
	local restore_y: f32 = 0
	local restore_z: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 or playable_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if playable_character == 2 then
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
			robo_circle_x = out1 or robo_circle_x
			robo_circle_y = out2 or robo_circle_y
			robo_circle_z = out3 or robo_circle_z
		end
		push_angle = event.get_direction_angle(robo_circle_x, robo_circle_y, robo_circle_z, character_x, character_y, character_z) or push_angle
		character_x = vm.f32(vm.f32(vm.sin(push_angle) * 25.0) + robo_circle_x)
		character_y = robo_circle_y
		character_z = vm.f32(vm.f32(vm.cos(push_angle) * 25.0) + robo_circle_z)
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
		circle_x = out1 or circle_x
		circle_y = out2 or circle_y
		circle_z = out3 or circle_z
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(circle_x, circle_y + 30.0, circle_z)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	wait.background_load()
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or sound_effect
	event.change_directory("event/dng/")
	event.start_background_file_loads_2("ring.gltf", "randomcoin.gltf")
	vm.wait(5)
	wait.background_load()
	ring_motion_frame = event.get_random_circle_motion_frame() or ring_motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, circle_x, circle_y, circle_z)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, ring_motion_frame)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, circle_x, circle_y - 30.0, circle_z)
	coin_angle = event.get_random_number(6.2831855) or coin_angle
	coin_angle = vm.f32(coin_angle - vm.f32(3.1415927))
	coin_angle = event.wrap_angle(coin_angle) or coin_angle
	event.set_character_rotation(13, 0.0, coin_angle, 0.0)
	event.change_directory("")
	party_npc_id = event.get_party_npc() or party_npc_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, circle_x, circle_y + 40.0, circle_z, 30, 2, 0.5)
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
			event.play_sound_effect(sound_effect, 0)
		end
		if frame_count == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if frame_count >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame_count > 300 then
			event.stop_sound_effect(sound_effect, 0)
			event.play_sound_effect(sound_effect, 3)
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
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or facing_angle
	min_spin_frames = 0
	min_spin_frames = event.get_random_number_int(10) or min_spin_frames
	min_spin_frames = vm.i32(min_spin_frames + 4)
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
		if frame_count >= min_spin_frames then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			target_angle = facing_angle
			target_angle = event.wrap_angle(target_angle) or target_angle
			if coin_angle < target_angle and calc.is_angle_within(coin_angle, target_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, target_angle, 0.0)
				circle_side = 0
				break
			end
			target_angle = vm.f32(facing_angle - vm.f32(3.1415927))
			target_angle = event.wrap_angle(target_angle) or target_angle
			if coin_angle < target_angle and calc.is_angle_within(coin_angle, target_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, target_angle, 0.0)
				circle_side = 1
				break
			end
		end
		frame_count = vm.i32(frame_count + 1)
	end
	facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, facing_angle, 1.0) == 0 then
		circle_side = 0
	else
		circle_side = 1
	end
	facing_angle = coin_angle
	wait.frames(20)
	roll = event.get_random_number_int(10) or roll
	if party_npc_id == 24 then
		threshold = 100
	else
		threshold = 6
	end
	if roll < threshold then
		roll = event.get_random_number_int(10) or roll
		if circle_side == 0 then
			if party_npc_id == 24 then
				threshold = 0
			else
				threshold = 2
			end
		elseif party_npc_id == 24 then
			threshold = 100
		else
			threshold = 4
		end
		if roll < threshold then
			facing_angle = vm.f32(facing_angle + vm.f32(3.14))
			facing_angle = event.wrap_angle(facing_angle) or facing_angle
			event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 8)
			if circle_side == 0 then
				circle_side = 1
			else
				circle_side = 0
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
	facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, facing_angle, 1.0) == 0 then
		circle_side = 0
	else
		circle_side = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness = 1.0
	frame_count = 0
	effect_id = event.get_random_circle_effect(circle_side) or effect_id
	if circle_side == 0 then
		event.play_sound_effect(sound_effect, 1)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness)
			brightness = vm.f32(brightness + vm.f32(0.03))
			frame_count = frame_count + 1
			vm.wait(13)
		end
		message.show_and_wait(0, 2310, 8, 0, 0)
		effect_amount = event.apply_random_circle_effect(effect_id) or effect_amount
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
			event.place_treasure_box(circle_x, circle_y, circle_z, facing_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_effect, 2)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness)
			brightness = vm.f32(brightness - vm.f32(0.03))
			frame_count = frame_count + 1
			vm.wait(19)
		end
		message.show_and_wait(0, 2320, 8, 0, 0)
		effect_amount = event.apply_random_circle_effect(effect_id) or effect_amount
		if effect_id == 5 then
			if playable_character == 0 or playable_character == 2 then
				message.show_and_wait(0, 2321, 8, 0, 0)
			end
			if playable_character == 1 or playable_character == 3 then
				message.show_and_wait(0, 2322, 8, 0, 0)
			end
		end
		if effect_id == 6 then
			if playable_character == 0 then
				message.show_and_wait(0, 2323, 8, 0, 0)
			end
			if playable_character == 1 or playable_character == 3 then
				message.show_and_wait(0, 2324, 8, 0, 0)
			end
			if playable_character == 2 then
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
		event.spawn_pull_items(circle_x, circle_y, circle_z, 1, 10, effect_amount / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
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
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the sequence in which the player uses the geostone and marks the floor as having it used.
function script.geostone()
	local playable_character: s32 = 0
	local original_x: f32 = 0
	local original_y: f32 = 0
	local original_z: f32 = 0
	local sound_effect: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local geostone_x: f32 = 0
	local geostone_y: f32 = 0
	local geostone_z: f32 = 0
	local facing_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	local system_sound: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 or playable_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if playable_character == 2 then
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
		original_x = out1 or original_x
		original_y = out2 or original_y
		original_z = out3 or original_z
	end
	if playable_character == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if playable_character == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_effect
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
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
		geostone_x = out1 or geostone_x
		geostone_y = out2 or geostone_y
		geostone_z = out3 or geostone_z
	end
	geostone_y = vm.f32(character_y + 18.0)
	event.set_object_handle_position(1, geostone_x, geostone_y, geostone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(geostone_x, geostone_y, geostone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if playable_character == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if playable_character == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	character_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + geostone_x)
	character_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + geostone_z)
	event.set_character_position(0, character_x, character_y, character_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if playable_character == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(character_x, character_y + 18.0, character_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, character_x, character_y + 36.0, character_z)
	end
	if playable_character == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(character_x, character_y + 18.0, character_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		effect_x = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + character_x)
		effect_y = vm.f32(character_y + 18.0)
		effect_z = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + character_z)
		event.set_character_position(12, effect_x, effect_y, effect_z)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait.frames(16)
	event.play_sound_effect(sound_effect, 0)
	wait.frames(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait.frames(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	facing_angle = event.get_direction_angle(character_x, character_y, character_z, camera_x, camera_y, camera_z) or facing_angle
	event.set_character_rotation(12, 0.0, facing_angle, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait.frames(20)
	event.play_sound_effect(sound_effect, 1)
	object.wait_until_done(0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	system_sound = event.get_system_sound_id() or system_sound
	event.play_sound_effect(system_sound, 18)
	message.show_and_wait(0, 2400, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor = event.get_dungeon_floor() or floor
	event.set_dungeon_floor_info(stage_id, floor, 5, 256)
	event.start_crossfade(10)
	if playable_character == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(529, 0)
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
	event.set_camera_control_enabled(1)
	event.finish_event()
end

--- The dungeon system event run for a monster that can be talked to.
script.monster_talk = dungeon.talk_to_monster

--- Runs the monster defeat sequence without a message.
function script.run_silent_defeat_sequence()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.run_silent_defeat_sequence

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = clear_floor

--- Shows the first-time guide message for random stones.
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

--- Shows a help message and waits for the player to answer it.
function script.show_help_message()
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
script[2510] = script.show_help_message

--- Shows the first-time level up guide messages.
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
	event.open_message_window_2(0, "Sei hai dubbi, vedi Guida da Menu principale.")
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Shows the first-time guide for driving the ridepod buggy.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Guida del Fuoristrada\n   Accelera con (L)↑; Rallenta con (L)↓.\n   Sterza con (L) ← oppure →.\n   Per le curve strette, [l1] + (L) ← o →."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Shows the first-time guide for the magic-absorb blade.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]Ora sai usare la Spada Assorbi-magia.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"In guardia, la Spada Assorbi-magia\nassorbe l'energia degli attacchi\nelementali, come Fuoco. In attacco,\nrilascer[UNI00e0] poi l'energia assorbita."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00c8] possibile caricare continuamente\nenergia dello stesso elemento.\nPer[UNI00f2], assorbendo un elemento\ndiverso, si perde l'intera carica."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "L'energia elementale assorbibile\ndipende dalla robustezza dell'arma.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Per usare l'energia elementale\nassorbita come magia, premi\n[l1] mentre sei in guardia con [r1]."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Plays a Sphida shot from aiming and the power gauge through the ball flight and its result.
function script.sphida_shot()
	local texture_bank: s32 = 0
	local sound_effect: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local rotation_z: f32 = 0
	local tee_x: f32 = 0
	local tee_y: f32 = 0
	local tee_z: f32 = 0
	local elevation_degrees: f32 = 0
	local power: f32 = 0
	local spin_factor: f32 = 0
	local level: s32 = 0
	local drift_x: f32 = 0
	local curve: f32 = 0
	local drift_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local hit_pin: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local miss_state: s32 = 0
	local contact_x: f32 = 0
	local contact_y: f32 = 0
	local contact_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local probe_x: f32 = 0
	local probe_y: f32 = 0
	local probe_z: f32 = 0
	local previous_speed: f32 = 0
	local length: f32 = 0
	local collision_id: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local step_count: s32 = 0
	local pin_distance: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local pin_segment_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_angle: f32 = 0
	local par_count: s32 = 0
	local answer: any = 0
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
	texture_bank = event.get_sphida_texture_bank() or texture_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	sound_effect = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_effect
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
		tee_x = out1 or tee_x
		tee_y = out2 or tee_y
		tee_z = out3 or tee_z
	end
	ball_x, ball_y, ball_z, aim_angle = minigame.set_up_sphida_shot(ball_x, ball_y, ball_z, aim_angle)
	camera.place_behind_player(aim_angle)
	event.set_sphida_status_panel_visible(1)
	elevation_degrees = 12.5
	event.set_sphida_carry_angle(vm.f32(elevation_degrees * vm.f32(3.1415927)) / 180.0)
	power, spin_factor, level = minigame.get_equipped_club_definition(power, spin_factor, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		drift_x = out1 or drift_x
		curve = out2 or curve
		drift_z = out3 or drift_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_angle, elevation_degrees = minigame.aim_sphida_shot(aim_angle, elevation_degrees, texture_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_sphida_ball_position(tee_x, tee_y, tee_z)
			event.set_character_position(8, tee_x, tee_y, tee_z)
			event.set_character_position(9, tee_x, tee_y, tee_z)
			minigame.finish_sphida_round(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, power, aim_angle, curve, drift_x, level = minigame.run_sphida_power_gauge(power, texture_bank, aim_angle, curve, drift_x, sound_effect, level)
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
	hit_pin = 0
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
	if power <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.frames(25)
		if level ~= 4 then
			event.play_sound_effect(sound_effect, 3)
		end
	elseif power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.frames(34)
		event.play_sound_effect(sound_effect, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.frames(39)
		if level == 0 then
			event.play_sound_effect(sound_effect, 12)
		else
			event.play_sound_effect(sound_effect, 1)
		end
	end
	if level == 4 then
		wait.frames(50)
		minigame.consume_sphida_shot(sound_effect)
		event.set_sphida_ball_position(tee_x, tee_y, tee_z)
		event.set_character_position(8, tee_x, tee_y, tee_z)
		event.set_character_position(9, tee_x, tee_y, tee_z)
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
	power = minigame.scale_by_club_power(power)
	elevation_degrees = vm.f32(vm.f32(elevation_degrees * vm.f32(3.1415927)) / 180.0)
	power = vm.f32(power - vm.f32(power * elevation_degrees))
	velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(power * vm.cos(elevation_degrees)))
	velocity_y = vm.f32(power * vm.sin(elevation_degrees))
	velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(power * vm.cos(elevation_degrees)))
	curve = vm.f32(vm.f32(curve * vm.f32(3.1415927)) / 2.0)
	drift_z = vm.f32(vm.f32(vm.f32(-velocity_z * spin_factor) * drift_x) * vm.f32(0.4))
	drift_x = vm.f32(vm.f32(vm.f32(-velocity_x * spin_factor) * drift_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	miss_state = 0
	level = 0
	sound_cooldown = 0
	do
		local out1, out2, out3, out4, out5 =
			event.get_segment_collision_13(0, ball_x, ball_y + 5.0, ball_z, ball_x, ball_y, ball_z, 0)
		contact_x = out1 or contact_x
		contact_y = out2 or contact_y
		contact_z = out3 or contact_z
		collision_id = out4 or collision_id
		surface_type = out5 or surface_type
	end
	if collision_id >= 0 and (surface_type == 1 or surface_type == 7) then
		print("----------------START_MIZU-------------------\n")
		power = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		power = 0.0
	end
	step_count = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (step_count + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_id = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_id
			if level == 1 and collision_id >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (step_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + drift_x)
				velocity_z = vm.f32(velocity_z + drift_z)
				drift_x = vm.f32(drift_x * vm.f32(0.8))
				drift_z = vm.f32(drift_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (step_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if curve ~= 0.0 then
			elevation_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation_degrees
			elevation_degrees = vm.f32(elevation_degrees + curve)
			elevation_degrees = event.wrap_angle(elevation_degrees) or elevation_degrees
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(elevation_degrees) / 10.0) * spin_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(elevation_degrees) / 10.0) * spin_factor))
		end
		length = event.get_vector_length(drift_x, 0.0, drift_z) or length
		if length > vm.f32(0.01) then
			speed = event.get_vector_length(drift_x, 0.0, drift_z) or speed
			elevation_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + drift_x, previous_y, previous_z + drift_z) or elevation_degrees
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, elevation_degrees, rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, elevation_degrees, rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			elevation_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation_degrees
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, elevation_degrees, rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, elevation_degrees, rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		previous_speed = speed
		elevation_degrees = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation_degrees
		probe_x = vm.f32(vm.sin(vm.f32(elevation_degrees - vm.f32(1.5707964))) * 3.0)
		probe_z = vm.f32(vm.cos(vm.f32(elevation_degrees - vm.f32(1.5707964))) * 3.0)
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
			contact_x = out1 or contact_x
			contact_y = out2 or contact_y
			contact_z = out3 or contact_z
			collision_id = out4 or collision_id
			surface_type = out5 or surface_type
		end
		if collision_id >= 0 and (surface_type == 1 or surface_type == 7) then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(contact_x, contact_y, contact_z)
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_effect, 11)
				sound_cooldown = 10
			end
			if power == 0.0 then
				power = 1.0
				velocity_x = vm.f32(velocity_x * vm.f32(0.4))
				velocity_y = vm.f32(velocity_y * vm.f32(0.4))
				velocity_z = vm.f32(velocity_z * vm.f32(0.4))
				drift_x = 0.0
				drift_z = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				power = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + probe_x, ball_y + probe_y, ball_z + probe_z, 1)
			contact_x = out1 or contact_x
			contact_y = out2 or contact_y
			contact_z = out3 or contact_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_id = out7 or collision_id
		end
		if collision_id < 0 then
			if ball_y >= 380.0 and velocity_y > 0.0 then
				do
					local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
					contact_x = out1 or contact_x
					contact_y = out2 or contact_y
					contact_z = out3 or contact_z
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
				collision_id = 1
			end
		end
		while collision_id >= 0 do
			curve = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if power ~= 1.0 and sound_cooldown <= 0 then
				event.play_sound_effect(sound_effect, 6)
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
				local out1, out2, out3 = event.add_vectors(contact_x, contact_y, contact_z, velocity_x, velocity_y, velocity_z)
				contact_x = out1 or contact_x
				contact_y = out2 or contact_y
				contact_z = out3 or contact_z
			end
			do
				local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, contact_x, contact_y, contact_z)
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
				if power == 0.0 then
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
					local out1, out2, out3 = event.copy_vector(contact_x, contact_y, contact_z)
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
					local out1, out2, out3 = event.copy_vector(contact_x, contact_y, contact_z)
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
					contact_x = out1 or contact_x
					contact_y = out2 or contact_y
					contact_z = out3 or contact_z
					normal_x = out4 or normal_x
					normal_y = out5 or normal_y
					normal_z = out6 or normal_z
					collision_id = out7 or collision_id
					surface_type = out8 or surface_type
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, ball_x, ball_y, ball_z, ball_x, ball_y - 3.0, ball_z, 1)
			contact_x = out1 or contact_x
			contact_y = out2 or contact_y
			contact_z = out3 or contact_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_id = out7 or collision_id
			surface_type = out8 or surface_type
		end
		if collision_id >= 0 then
			curve = 0.0
			ball_y = vm.f32(contact_y + 3.0)
			length = event.get_vector_length(velocity_x, 0.0, velocity_z) or length
			if length < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				level = 1
			else
				if power == 0.0 then
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
				if power ~= 1.0 and sound_cooldown <= 0 then
					event.play_sound_effect(sound_effect, 5)
					sound_cooldown = 10
				end
			end
			length = event.get_vector_length(drift_x, 0.0, drift_z) or length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and length < vm.f32(0.4) then
				if surface_type == 6 then
					miss_state = 1
					break
				end
				surface_type = event.get_automap_attribute_status(ball_x, ball_y, ball_z) or surface_type
				if not (surface_type == 1) then
					break
				end
				miss_state = 1
				break
			end
		end
		if ball_y < -500.0 then
			miss_state = 1
			break
		elseif step_count >= 480 then
			miss_state = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			x = vm.f32(pin_x - ball_x)
			y = vm.f32(pin_y - ball_y)
			z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(x, y, z) or pin_distance
			if ball_color ~= pin_color then
				pin_segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or pin_segment_distance
				if pin_segment_distance >= 0.0 and pin_segment_distance <= 30.0 then
					hit_pin = 1
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
					hit_pin = 1
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
				if miss_state >= 30 then
					if miss_state >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				miss_state = miss_state + 1
			elseif step_count >= 20 then
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
					camera_x = out1 or camera_x
					camera_y = out2 or camera_y
					camera_z = out3 or camera_z
				end
				camera_angle = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					camera_x,
					camera_y,
					camera_z
				) or camera_angle
				event.set_camera_control_rotation(camera_angle)
				event.move_camera_control_with_pad(8)
				event.step_camera_control()
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(15)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			step_count = step_count + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if miss_state == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		par_count = event.get_sphida_par() or par_count
		if hit_pin == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_effect, 17)
			step_count = 0
			while step_count < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				step_count = step_count + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			step_count = 0
			while step_count < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				step_count = step_count + 1
				vm.wait(17)
			end
			event.set_character_active(0, 11)
			pin_color = event.get_dungeon_stage_id() or pin_color
			ball_color = event.get_dungeon_floor() or ball_color
			collision_id = event.get_dungeon_floor_info(pin_color, ball_color, 4) or collision_id
			do
				local out1, out2 = event.get_sphida_prize(collision_id)
				sound_cooldown = out1 or sound_cooldown
				surface_type = out2 or surface_type
			end
			collision_id = vm.i32(collision_id + 1)
			event.set_dungeon_floor_info(pin_color, ball_color, 4, collision_id)
			event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, elevation_degrees, sound_cooldown, surface_type)
			wait.frames(54)
			wait.frames(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_effect
			event.stop_music(0)
			event.play_sound_effect(sound_effect, 0)
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
				event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
				event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			else
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
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
		elseif par_count >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			answer = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(24)
			if answer == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
					collision_id = out1 or collision_id
					tee_x = out2 or tee_x
					tee_y = out3 or tee_y
					tee_z = out4 or tee_z
				end
				if collision_id == 0 then
					do
						local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
						tee_x = out1 or tee_x
						tee_y = out2 or tee_y
						tee_z = out3 or tee_z
					end
				end
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pin_x = out1 or pin_x
					pin_y = out2 or pin_y
					pin_z = out3 or pin_z
				end
				speed = event.get_distance_between(tee_x, tee_y, tee_z, pin_x, pin_y, pin_z) or speed
				if speed < 40.0 then
					elevation_degrees = event.get_random_number(6.2831855) or elevation_degrees
					elevation_degrees = vm.f32(elevation_degrees - vm.f32(3.1415927))
					tee_x = vm.f32(tee_x + vm.f32(vm.sin(elevation_degrees) * 50.0))
					tee_z = vm.f32(tee_z + vm.f32(vm.cos(elevation_degrees) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(tee_x, tee_y, tee_z)
						contact_x = out1 or contact_x
						contact_y = out2 or contact_y
						contact_z = out3 or contact_z
						collision_id = out4 or collision_id
					end
					step_count = 0
					while collision_id >= 0 do
						do
							local out1, out2, out3 = event.copy_vector(tee_x, tee_y, tee_z)
							previous_x = out1 or previous_x
							previous_y = out2 or previous_y
							previous_z = out3 or previous_z
						end
						do
							local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, contact_x, contact_y, contact_z)
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
							local out1, out2, out3 = event.copy_vector(contact_x, contact_y, contact_z)
							tee_x = out1 or tee_x
							tee_y = out2 or tee_y
							tee_z = out3 or tee_z
						end
						do
							local out1, out2, out3 = event.add_vectors(tee_x, tee_y, tee_z, previous_x, previous_y, previous_z)
							tee_x = out1 or tee_x
							tee_y = out2 or tee_y
							tee_z = out3 or tee_z
						end
						step_count = step_count + 1
						if step_count > 6 then
							break
						end
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(tee_x, tee_y, tee_z)
							contact_x = out1 or contact_x
							contact_y = out2 or contact_y
							contact_z = out3 or contact_z
							collision_id = out4 or collision_id
						end
					end
				end
				aim_angle = event.get_direction_angle(tee_x, tee_y, tee_z, ball_x, ball_y, ball_z) or aim_angle
				event.set_character_position(0, tee_x, tee_y, tee_z)
				event.set_character_rotation(0, 0.0, aim_angle, 0.0)
				event.set_camera_look_at(tee_x, tee_y + 30.0, tee_z)
				aim_angle = vm.f32(aim_angle - vm.f32(3.1415927))
				aim_angle = event.wrap_angle(aim_angle) or aim_angle
				tee_x = vm.f32(vm.f32(vm.sin(aim_angle) * 100.0) + tee_x)
				tee_y = vm.f32(tee_y + 30.0)
				tee_z = vm.f32(vm.f32(vm.cos(aim_angle) * 100.0) + tee_z)
				event.set_camera_position(tee_x, tee_y, tee_z)
				event.reset_follow_camera(0)
			end
		end
	else
		event.play_sound_effect(sound_effect, 18)
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
		event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
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
		event.set_sphida_ball_position(tee_x, tee_y, tee_z)
		event.set_character_position(8, tee_x, tee_y, tee_z)
		event.set_character_position(9, tee_x, tee_y, tee_z)
		event.release_camera_sequence_follow_object()
	end
	if hit_pin == 1 then
		minigame.consume_sphida_shot(-1)
	else
		minigame.consume_sphida_shot(sound_effect)
	end
	minigame.finish_sphida_round(hit_pin)
end

--- Asks whether to move the Sphere to the player and moves it when accepted.
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

--- Warns that this is the last time the Sphere can be moved to the player and moves it when accepted.
function script.sphida_near_ball_last()
	local answer: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Questa [UNI00e8] l'ultima volta che potrai\navvicinare la Sphera.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Avvicinare la Sphera?")
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

--- Leaves the Sphida course and loads map d06e01 with its script event 16080.
function script.leave_sphida_for_d06e01_16080()
	minigame.leave_sphida()
	event.load_dungeon_map("d06e01")
	vm.wait(2)
	event.load_event_script("d06e01/d06e01.stb", 16080)
end
script[16080] = script.leave_sphida_for_d06e01_16080

--- Leaves the Sphida course and loads map d06e01 with its script event 16100.
function script.leave_sphida_for_d06e01_16100()
	minigame.leave_sphida()
	event.load_dungeon_map("d06e01")
	vm.wait(2)
	event.load_event_script("d06e01/d06e01.stb", 16100)
end
script[16100] = script.leave_sphida_for_d06e01_16100

--- Leaves the Sphida course and loads map d06e01 with its script event 16120.
function script.leave_sphida_for_d06e01_16120()
	minigame.leave_sphida()
	event.load_dungeon_map("d06e01")
	vm.wait(2)
	event.load_event_script("d06e01/d06e01.stb", 16120)
end
script[16120] = script.leave_sphida_for_d06e01_16120

--- Leaves the Sphida course and loads map s21 with its script event 17040.
function script.leave_sphida_for_s21_17040()
	minigame.leave_sphida()
	event.load_dungeon_map("s21")
	vm.wait(2)
	event.load_event_script("s21/s21.stb", 17040)
end
script[17040] = script.leave_sphida_for_s21_17040

--- Leaves the Sphida course and loads map s50 with its script event 17080.
function script.leave_sphida_for_s50_17080()
	minigame.leave_sphida()
	event.load_dungeon_map("s50")
	vm.wait(2)
	event.load_event_script("s50/s50.stb", 17080)
end
script[17080] = script.leave_sphida_for_s50_17080

--- Leaves the Sphida course and loads map d06b01 with its script event 17160.
function script.leave_sphida_for_d06b01_17160()
	minigame.leave_sphida()
	event.load_dungeon_map("d06b01")
	vm.wait(2)
	event.load_event_script("d06b01/d06b01.stb", 17160)
end
script[17160] = script.leave_sphida_for_d06b01_17160

--- Leaves the Sphida course, hides the party and loads map s64 with its script event 500.
function script.leave_sphida_for_s64()
	minigame.leave_sphida()
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	event.load_dungeon_map("s64")
	event.load_event_script("s64/s64.stb", 500)
end
script[17200] = script.leave_sphida_for_s64

--- Leaves the Sphida course, hides the party and loads map s31 with its script event 520.
function script.leave_sphida_for_s31()
	minigame.leave_sphida()
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	event.load_dungeon_map("s31")
	event.load_event_script("s31/s31.stb", 520)
end
script[17240] = script.leave_sphida_for_s31

--- Leaves the Sphida course and loads map d06b01 with its script event 17280.
function script.leave_sphida_for_d06b01_17280()
	minigame.leave_sphida()
	event.load_dungeon_map("d06b01")
	event.load_event_script("d06b01/d06b01.stb", 17280)
end
script[17280] = script.leave_sphida_for_d06b01_17280

--- Leaves the Sphida course, sets the party stats and equipment for the first preset and loads map d06e01 with its script event 151.
function script.equip_preset_gear_and_enter_d06e01()
	local owned_count: s32 = 0
	minigame.leave_sphida()
	event.set_character_max_hp(0, 200)
	event.set_character_max_hp(1, 200)
	event.set_character_defence(0, 70)
	event.set_character_defence(1, 70)
	owned_count = event.get_item_count(270) or owned_count
	if owned_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - owned_count))
	end
	event.add_inventory_item(19)
	event.equip_character_item(0, 19)
	event.add_inventory_item(33)
	event.equip_character_item(0, 33)
	event.add_inventory_item(55)
	event.equip_character_item(1, 55)
	event.add_inventory_item(96)
	event.equip_character_item(1, 96)
	vm.wait(2)
	event.load_dungeon_map("d06e01")
	vm.wait(3)
	event.load_event_script("d06e01/d06e01.stb", 151)
end
script[26050] = script.equip_preset_gear_and_enter_d06e01

--- Leaves the Sphida course, sets the party stats and equipment for the second preset and loads map d06b01 with its script event 151.
function script.equip_preset_gear_and_enter_d06b01()
	local owned_count: s32 = 0
	minigame.leave_sphida()
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
	event.load_dungeon_map("d06b01")
	vm.wait(2)
	event.load_event_script("d06b01/d06b01.stb", 151)
end
script[27010] = script.equip_preset_gear_and_enter_d06b01

--- Leaves the Sphida course, equips the preset loadout and loads map d06b02 with its script event 27020.
function script.enter_d06b02_27020()
	minigame.leave_sphida()
	moon_flower_palace.equip_preset_loadout()
	event.load_dungeon_map("d06b02")
	vm.wait(2)
	event.load_event_script("d06b02/d06b02.stb", 27020)
end
script[27020] = script.enter_d06b02_27020

--- Leaves the Sphida course, equips the preset loadout and loads map d06b02 with its script event 27030.
function script.enter_d06b02_27030()
	minigame.leave_sphida()
	moon_flower_palace.equip_preset_loadout()
	event.load_dungeon_map("d06b02")
	vm.wait(2)
	event.load_event_script("d06b02/d06b02.stb", 27030)
end
script[27030] = script.enter_d06b02_27030

--- Leaves the Sphida course, equips the preset loadout and loads map d06b02 with its script event 27040.
function script.enter_d06b02_27040()
	minigame.leave_sphida()
	moon_flower_palace.equip_preset_loadout()
	event.load_dungeon_map("d06b02")
	vm.wait(2)
	event.load_event_script("d06b02/d06b02.stb", 27040)
end
script[27040] = script.enter_d06b02_27040

--- Leaves the Sphida course, equips the preset loadout and loads map d06b02 with its script event 27050.
function script.enter_d06b02_27050()
	minigame.leave_sphida()
	moon_flower_palace.equip_preset_loadout()
	event.load_dungeon_map("d06b02")
	vm.wait(2)
	event.load_event_script("d06b02/d06b02.stb", 27050)
end
script[27050] = script.enter_d06b02_27050

--- Leaves the Sphida course, equips the preset loadout and loads map d06b02 with its script event 27060.
function script.enter_d06b02_27060()
	minigame.leave_sphida()
	moon_flower_palace.equip_preset_loadout()
	event.load_dungeon_map("d06b02")
	vm.wait(2)
	event.load_event_script("d06b02/d06b02.stb", 27060)
end
script[27060] = script.enter_d06b02_27060

--- Leaves the Sphida course, sets the party stats and equipment for the second preset and loads map d06b03 with its script event 27070.
function script.equip_preset_gear_and_enter_d06b03()
	local owned_count: s32 = 0
	minigame.leave_sphida()
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
	event.load_dungeon_map("d06b03")
	vm.wait(2)
	event.load_event_script("d06b03/d06b03.stb", 27070)
end
script[27070] = script.equip_preset_gear_and_enter_d06b03

return script
