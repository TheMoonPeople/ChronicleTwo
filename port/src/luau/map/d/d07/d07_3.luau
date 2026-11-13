--!strict
--- Event script for the Zelmite Mine dungeon floors, covering floor entry, doors, random circles, the geostone, tutorial messages, floor clearing and the Sphida ball minigame.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local spheda = require("@lib/event/german/spheda")
local sphida_hint = require("@lib/event/german/sphida_hint")
local treasure_box = require("@lib/event/german/treasure_box")
local wait = require("@lib/event/wait")
local zelmite_mine = require("@lib/event/zelmite_mine")

--- Plays the floor intro with the title logo or map, the party walking in and any seal notices.
local function play_floor_entry_intro(intro_mode: s32)
	local intro_sound_effect: s32 = 0
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_angle: f32 = 0
	local current_floor: s32 = 0
	local previous_floor: s32 = 0
	local seal_flags: s32 = 0
	local texture_block: s32 = 0
	local wall_parts: s32 = 0
	local seal_sound_effect: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 1)
	event.show_dungeon_status_bar(0, 1.0)
	intro_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_048.sound.json") or intro_sound_effect
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
		event_point_x = out1 or event_point_x
		event_point_y = out2 or event_point_y
		event_point_z = out3 or event_point_z
		event_point_angle = out4 or event_point_angle
	end
	event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_angle)
	print(vm.float(event_point_angle), "\n")
	print(vm.float(event_point_angle), "\n")
	print(vm.float(event_point_angle), "\n")
	if intro_mode == 0 then
		event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d06_1.json", 0)
		event.set_event_image_texture(0, "logo_d06")
		event.set_event_image_source_rect(0, 0, 0, 384, 128)
		event.set_event_image_screen_rect(0, -24, 300, 384, 128)
		event.set_event_image_color(0, 128, 128, 128, 0)
		event.set_event_image_visible(1, 0)
		event.fade_event_image(0, 1, 30)
	else
		current_floor = event.get_dungeon_floor() or current_floor
		previous_floor = event.get_dungeon_previous_floor() or previous_floor
		event.load_dungeon_map_display(5, 0, 6, current_floor, previous_floor)
		event.fade_dungeon_map(1, 30)
		event.set_dungeon_map_piece_moving(1)
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
	wall_parts = event.get_triggered_event_data_2(9) or wall_parts
	event.attach_object_handle_to_map_part_3(1, wall_parts, "d07w10_2-m0")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, wall_parts, "d07w10_3-m0")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, wall_parts, "d07w10_3-m1")
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_3(4, wall_parts, "d07w10_5-m0")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(5, wall_parts, "d07w10_4-m0")
	event.set_object_handle_visible(5, 0)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_handle_position(0, 0.0, 11.0, -223.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "バトル立ち", 4)
	if calc.is_angle_within(event_point_angle, 0.0, 1.0) == 0 then
		event.set_object_handle_position(1, 0.0, 0.0, -200.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_position(2, 0.0, 6.0, -210.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_position(3, 0.0, 6.0, -180.0)
		event.set_object_handle_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_handle_position(4, 0.0, 0.0, -200.0)
		event.set_object_handle_rotation(4, 0.0, 3.14, 0.0)
	end
	if calc.is_angle_within(event_point_angle, vm.f32(1.57), 1.0) == 0 then
		event.set_object_handle_position(1, -200.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
		event.set_object_handle_position(2, -200.0, 6.0, -10.0)
		event.set_object_handle_rotation(2, 0.0, -1.57, 0.0)
		event.set_object_handle_position(3, -200.0, 6.0, 20.0)
		event.set_object_handle_rotation(3, 0.0, -1.57, 0.0)
		event.set_object_handle_position(4, -200.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, -1.57, 0.0)
	end
	if calc.is_angle_within(event_point_angle, vm.f32(3.14), 1.0) == 0 then
		event.set_object_handle_position(1, 0.0, 0.0, 200.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_position(2, 0.0, 6.0, 190.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_position(3, 0.0, 6.0, 220.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_position(4, 0.0, 0.0, 200.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	end
	if calc.is_angle_within(event_point_angle, vm.f32(-1.57), 1.0) == 0 then
		event.set_object_handle_position(1, 200.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
		event.set_object_handle_position(2, 200.0, 6.0, -10.0)
		event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
		event.set_object_handle_position(3, 200.0, 6.0, 20.0)
		event.set_object_handle_rotation(3, 0.0, 1.57, 0.0)
		event.set_object_handle_position(4, 200.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 1.57, 0.0)
	end
	event.clear_camera_sequence()
	event.set_camera_sequence_position(76.41, 73.84, 103.77)
	event.set_camera_sequence_look_at(-6.14, 23.51, -4.91)
	event.play_sound_effect(intro_sound_effect, 1)
	event.fade_in_screen(30)
	event.move_object_sequence_eased(0, 0.0, 11.0, -23.0, 40, 2, 1.0)
	event.move_object_sequence_eased(1, 0.0, 0.0, 0.0, 40, 2, 1.0)
	event.move_object_sequence_eased(2, 0.0, 6.0, -10.0, 40, 2, 1.0)
	event.move_object_sequence_eased(3, 0.0, 6.0, 20.0, 40, 2, 1.0)
	event.move_object_sequence_eased(4, 0.0, 0.0, 0.0, 40, 2, 1.0)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "立ち")
	event.set_object_sequence_motion_blend_step(0, 0.1)
	wait.frames(20)
	event.set_object_sequence_motion(0, "歩き")
	event.rotate_object_sequence(0, 0.0, 1.0, 0.0, 10)
	event.move_object_sequence(0, 14.0, 11.0, -23.0, 20)
	wait.frames(20)
	event.start_crossfade(30)
	if intro_mode == 1 then
		event.fade_dungeon_map(0, 0)
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	else
		event.fade_event_image(0, 0, 0)
	end
	event.delete_event_image(0)
	event.set_object_handle_position(0, 40.0, 0.0, 20.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(40.0, 30.0, 20.0)
	event.set_camera_position(40.0, 50.0, 130.0)
	event.reset_follow_camera(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.initialize_event()
	if seal_flags ~= 0 then
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(4)
			wait.background_load()
			texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or texture_block
			event.set_event_sprite_texture(0, "aka_fuuin", texture_block)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(6)
			wait.background_load()
			texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or texture_block
			event.set_event_sprite_texture(0, "ao_fuuin", texture_block)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(8)
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
			event.open_message_window_2(0, "Auf dieser Ebene scheint es\nein Rotes Siegel zu geben.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Max wurde vom Roten Atlamillia\nerw[UNI00e4]hlt. Du kannst ihn nicht anw[UNI00e4]hlen!")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.open_message_window_2(0, "Auf dieser Ebene scheint es\nein Blaues Siegel zu geben.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"Monica wurde vom Blauen Atlamillia\nerw[UNI00e4]hlt. Du kannst sie nicht anw[UNI00e4]hlen!"
			)
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.open_message_window_2(0, "Auf dieser Ebene scheint es\nein Wei[UNI00df]es Siegel zu geben.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"Du kannst nicht mehr heilen\noder ungew[UNI00f6]hnl. Zust[UNI00e4]nde ver[UNI00e4]ndern."
			)
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		event.set_event_sprite_draw_pass(0, 0)
		event.delete_event_image(0)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Loads the current floor's map, monsters and music, or the fixed map or Georama scene a special floor uses, and plays the entry intro.
local function load_floor()
	local stage_id: s32 = 0
	local floor: s32 = 0
	local boss_defeated_flag: s32 = 0
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
			boss_defeated_flag = event.get_save_flag(820) or boss_defeated_flag
			if boss_defeated_flag == 1 then
				event.skip_next_music_load()
				event.skip_next_map_sound_load()
				event.go_to_georama_edit(172, 500)
				resume_point = 2
				vm.wait(2)
				return
			end
			event.go_to_georama_edit(14, 100)
			resume_point = 3
			vm.wait(3)
			return
		end
		if floor == 5 then
			event.load_dungeon_map("s52")
			event.load_event_script("s52/s52.stb", 100)
			return
		end
		if floor == 27 then
			event.load_dungeon_map("s54")
			event.load_event_script("s54/s54.stb", 100)
			return
		end
		if floor == 10 then
			event.load_dungeon_map("s61")
			event.load_event_script("s61/s61.stb", 100)
			return
		end
		if floor == 16 then
			event.load_dungeon_map("s62")
			event.load_event_script("s62/s62.stb", 100)
			return
		end
		if floor == 21 then
			event.load_dungeon_map("s63")
			event.load_event_script("s63/s63.stb", 100)
			return
		end
		if floor == 26 then
			event.load_dungeon_map("s69")
			event.load_event_script("s69/s69.stb", 100)
			return
		end
		if floor == 38 then
			event.load_dungeon_map("d07b01")
			event.load_event_script("d07b01/d07b01.stb", 100)
			return
		end
		if floor == 37 then
			event.allow_next_music_load()
			event.stop_music(0)
			resume_point = 4
			wait.frames(6)
			event.load_music(37)
			event.skip_next_music_load()
		end
		event.load_dungeon_map("d07f01", "d07f01")
		event.load_dungeon_monster(0)
		event.place_treasure_box_at_event_point(-1)
		event.place_dungeon_monster(-1)
		event.play_music(0)
		previous_floor = event.get_dungeon_previous_floor() or previous_floor
		if floor == previous_floor then
			resume_point = 5
			play_floor_entry_intro(0)
		else
			resume_point = 6
			play_floor_entry_intro(1)
		end
		sound.load_event_sound_effects()
		dungeon.show_floor_title()
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				dungeon.increment_floor_counter_skipping(stage_id, floor)
			end
			return 0
		end
		if resume_point <= 3 then
			return 0
		end
		if resume_point <= 6 then
			if resume_point <= 4 then
				zelmite_mine.wait_through_door_exit(0)
			end
			if resume_point <= 5 then
				zelmite_mine.wait_through_door_exit(1)
			end
			wait.background_load_skipping()
			cutscene.noop()
			return 0
		end
		return nil
	end)
end

--- Starts the floor music, opens the floor map and loads the floor it selects.
local function select_floor_from_map()
	local music_number: s32 = 0
	local previous_floor: s32 = 0
	local selected_floor: s32 = 0
	event.initialize_event()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 22 then
		event.stop_music(0)
		wait.frames(6)
		event.load_music(22)
	end
	event.play_music(0)
	event.load_map_sounds(8601)
	event.open_dungeon_floor_map(6)
	vm.wait(2)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		previous_floor = out2 or previous_floor
		selected_floor = out3 or selected_floor
	end
	event.set_dungeon_floor(selected_floor)
	event.set_dungeon_previous_floor(previous_floor)
	load_floor()
end

--- Lets the player unlock a door with an item and, once unlocked, enter it to start the next floor.
local function interact_with_door(door_index: s32)
	local is_unlocked: s32 = 0
	local interaction_state: s32 = 0
	local confirmed: s32 = 0
	local item: s32 = 0
	local active_character: s32 = 0
	local choice: any = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		is_unlocked = event.get_local_event_flag(door_index) or is_unlocked
		event.set_dungeon_pause_flags(1, 1)
		if is_unlocked == 0 then
			interaction_state = event.get_triggered_event_data_2(6) or interaction_state
			if interaction_state == 1 then
				event.initialize_event()
				event.set_message_window_mode(0, 1)
				event.set_message_draw_speed(0, 1)
				resume_point = 1
				confirmed = message.ask_confirmation(0, 6, 5, 256, 208, confirmed)
				event.set_message_window_mode(0, 7)
				event.set_message_draw_speed(0, 0)
				if confirmed == 1 then
					interaction_state = 2
				end
				event.finish_event()
			end
			if interaction_state == 2 then
				event.show_dungeon_status_bar(0, 0.16666667)
				resume_point = 2
				wait.frames(6)
				event.open_use_item_menu(350)
				resume_point = 3
				vm.wait(3)
				item = vmhost.used_item() or item
				if item == 350 then
					event.set_local_event_flag(door_index, 1)
					resume_point = 4
					zelmite_mine.attach_wall_parts()
				elseif item <= 0 then
					event.finish_event()
				else
					resume_point = 5
					character.shake_head()
				end
				event.show_dungeon_status_bar(1, 0.16666667)
				resume_point = 6
				wait.frames(6)
			end
		else
			active_character = event.get_playable_character() or active_character
			if active_character == 2 or active_character == 3 then
				event.initialize_event()
				character.reset_action_motion()
				event.set_message_window_mode(0, 1)
				event.set_message_draw_speed(0, 1)
				if active_character == 2 then
					resume_point = 7
					message.show_and_wait(0, 20, 5, 256, 208)
				else
					resume_point = 8
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
			resume_point = 9
			choice = message.ask_choice(0, 10, 8, 256, 208, 2, 1)
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
			if choice == 0 then
				event.clear_event_battle_monsters(-1)
				minigame.delete_sphida_objects()
				resume_point = 10
				zelmite_mine.play_door_entry()
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
					resume_point = 11
					spheda.announce_medal_reward(-1, cleared, bonus)
					resume_point = 12
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
				resume_point = 13
				select_floor_from_map()
			else
				event.finish_event()
			end
		end
		event.set_dungeon_pause_flags(1, 0)
		return
	end, function(received: { any })
		if resume_point <= 8 then
			if resume_point == 1 then
				confirmed = received[2] :: number
			end
			if resume_point <= 1 then
				local _ = interaction_state == 1
				interaction_state = 2
				wait.frames_skipping(6)
			end
			if resume_point <= 3 then
				wait.background_load_skipping()
			end
			if resume_point <= 4 then
				character.resume_shake_head()
			end
			if resume_point <= 5 then
				wait.frames_skipping(6)
			end
			if resume_point <= 6 then
				cutscene.noop()
				message.show_and_wait_skipping(0, 20, 5, 256, 208)
			end
			if resume_point <= 7 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			return 0
		end
		if resume_point <= 13 then
			if resume_point == 9 then
				choice = received[1] :: number
			end
			if resume_point <= 9 then
				zelmite_mine.count_to_sixteen()
				zelmite_mine.wait_through_door_transition()
			end
			if resume_point <= 10 then
				message.resume_numbered_messages(-1, cleared, bonus)
			end
			if resume_point <= 12 then
				zelmite_mine.wait_between_empty_loops()
			end
			return 0
		end
		return nil
	end)
end

--- Plays the floor clear scene, records the clear time, opens the door and announces rewards, seal breaks and Sphida availability.
local function clear_floor()
	local active_character: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local unassigned_flag: s32 = 0
	local sphida_flag: s32 = 0
	local sub_game_flags: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local is_fastest_clear: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local is_trial_version: s32 = 0
	local seal_flags: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		active_character = event.get_playable_character() or active_character
		character.reset_action_motion()
		event.set_dungeon_pause_flags(512, 1)
		event.show_dungeon_status_bar(0, 0.16666667)
		resume_point = 1
		wait.frames(10)
		event.set_dungeon_pause_flags(16384, 1)
		event.clear_event_battle_monsters(-1)
		if active_character == 0 then
			resume_point = 2
			dungeon.play_max_victory(1)
		end
		if active_character == 1 then
			resume_point = 3
			dungeon.play_monica_victory(1)
		end
		if active_character == 2 or active_character == 3 then
			resume_point = 4
			dungeon.play_finish_banner(active_character)
		end
		event.set_dungeon_pause_flags(16384, 0)
		zelmite_mine.place_opened_door()
		event.reset_action_character_motion(0, 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.show_dungeon_status_bar(1, 0.16666667)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		event.set_dungeon_floor_info(stage_id, floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
		sphida_flag = event.get_save_flag(220) or sphida_flag
		sphida_flag = event.get_save_flag(317) or sphida_flag
		sub_game_flags = event.get_floor_sub_games() or sub_game_flags
		if (if sphida_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
		is_fastest_clear = event.record_floor_clear_time() or is_fastest_clear
		do
			local out1, out2 = event.get_floor_practice_result(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		resume_point = 5
		spheda.announce_medal_reward(is_fastest_clear, cleared, bonus)
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
				event.open_message_window_2(0, "Das Rote Siegel wurde ge[UNI00f6]ffnet.")
			end
			if bit32.band(seal_flags, 2) ~= 0 then
				event.open_message_window_2(0, "Das Blaue Siegel wurde ge[UNI00f6]ffnet.")
			end
			if bit32.band(seal_flags, 4) ~= 0 then
				event.open_message_window_2(0, "Das Wei[UNI00df]e Siegel wurde ge[UNI00f6]ffnet.")
			end
			resume_point = 6
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		resume_point = 7
		message.show_and_wait(0, 2130, 8, 0, 0)
		if is_trial_version ~= 1 then
			if unassigned_flag == 1 and sphida_flag == 1 and bit32.band(sub_game_flags, 3) == 3 then
				resume_point = 8
				message.show_and_wait(0, 2120, 8, 0, 0)
				resume_point = 9
				spheda.move_character_to_ball()
			else
				if (if unassigned_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
					resume_point = 10
					message.show_and_wait(0, 2110, 8, 0, 0)
				end
				if (if sphida_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					if active_character == 1 then
						resume_point = 3
						dungeon.play_monica_victory(1)
					end
					if active_character == 2 or active_character == 3 then
						resume_point = 4
						dungeon.play_finish_banner(active_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					zelmite_mine.place_opened_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					sphida_flag = event.get_save_flag(220) or sphida_flag
					sphida_flag = event.get_save_flag(317) or sphida_flag
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if sphida_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					is_fastest_clear = event.record_floor_clear_time() or is_fastest_clear
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					resume_point = 5
					spheda.announce_medal_reward(is_fastest_clear, cleared, bonus)
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
							event.open_message_window_2(0, "Das Rote Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Das Blaue Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Das Wei[UNI00df]e Siegel wurde ge[UNI00f6]ffnet.")
						end
						resume_point = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_point = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial_version ~= 1 then
						if unassigned_flag == 1 and sphida_flag == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_point = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_point = 9
							spheda.move_character_to_ball()
						else
							if (if unassigned_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_point = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if sphida_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					if active_character == 2 or active_character == 3 then
						resume_point = 4
						dungeon.play_finish_banner(active_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					zelmite_mine.place_opened_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					sphida_flag = event.get_save_flag(220) or sphida_flag
					sphida_flag = event.get_save_flag(317) or sphida_flag
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if sphida_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					is_fastest_clear = event.record_floor_clear_time() or is_fastest_clear
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					resume_point = 5
					spheda.announce_medal_reward(is_fastest_clear, cleared, bonus)
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
							event.open_message_window_2(0, "Das Rote Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Das Blaue Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Das Wei[UNI00df]e Siegel wurde ge[UNI00f6]ffnet.")
						end
						resume_point = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_point = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial_version ~= 1 then
						if unassigned_flag == 1 and sphida_flag == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_point = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_point = 9
							spheda.move_character_to_ball()
						else
							if (if unassigned_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_point = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if sphida_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
				dungeon.play_finish_banner(active_character)
				return vm.continue_with(function()
					event.set_dungeon_pause_flags(16384, 0)
					zelmite_mine.place_opened_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					sphida_flag = event.get_save_flag(220) or sphida_flag
					sphida_flag = event.get_save_flag(317) or sphida_flag
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if sphida_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					is_fastest_clear = event.record_floor_clear_time() or is_fastest_clear
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					resume_point = 5
					spheda.announce_medal_reward(is_fastest_clear, cleared, bonus)
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
							event.open_message_window_2(0, "Das Rote Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Das Blaue Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Das Wei[UNI00df]e Siegel wurde ge[UNI00f6]ffnet.")
						end
						resume_point = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_point = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial_version ~= 1 then
						if unassigned_flag == 1 and sphida_flag == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_point = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_point = 9
							spheda.move_character_to_ball()
						else
							if (if unassigned_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_point = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if sphida_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
				zelmite_mine.do_nothing()
				cutscene.noop_with_arguments(0, -1)
				message.resume_numbered_messages(is_fastest_clear, cleared, bonus)
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

--- Runs when the script is loaded; nothing needs preparing.
function script.setup() end

--- Does nothing beyond starting and finishing the event.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	event.finish_event()
end

--- Gives the party a fixed set of items and sets two save flags.
function script.give_starting_items()
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
script[200] = script.give_starting_items

--- Runs the door interaction for the first door.
function script.examine_door_0()
	interact_with_door(0)
end
script[300] = script.examine_door_0

--- Runs the door interaction for the second door.
function script.edit_analyze_changed()
	interact_with_door(1)
end

--- Runs the door interaction for the third door.
function script.examine_door_2()
	interact_with_door(2)
end
script[320] = script.examine_door_2

--- Opens the automap door, either on the companion's say-so or by using an item.
function script.examine_automap_door()
	local party_npc: s32 = 0
	local interaction_state: s32 = 0
	local confirmed: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 1)
	character.reset_action_motion()
	party_npc = event.get_party_npc() or party_npc
	if party_npc == 4 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Du musst einfach hier durch,\nstimmt's?")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.show_dungeon_status_bar(0, 0.16666667)
		zelmite_mine.open_automap_door()
		event.show_dungeon_status_bar(1, 0.16666667)
		wait.frames(6)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	interaction_state = event.get_triggered_event_data_2(6) or interaction_state
	if interaction_state == 1 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_draw_speed(0, 1)
		confirmed = message.ask_confirmation(0, 2500, 5, 256, 208, confirmed)
		event.set_message_bubble_tail(0, 1)
		event.set_message_draw_speed(0, 0)
		if confirmed == 1 then
			interaction_state = 2
		end
	end
	if interaction_state == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait.frames(6)
		event.open_use_item_menu(351)
		vm.wait(6)
		item = vmhost.used_item() or item
		if item == 351 then
			zelmite_mine.open_automap_door()
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
script[348] = script.examine_automap_door

script.select_floor_from_map = select_floor_from_map
script[1000] = script.select_floor_from_map

script.load_floor = load_floor
script[1010] = script.load_floor

--- The dungeon system event run when the player opens a treasure box.
script.treasure_box = treasure_box.open_nearest

--- Plays the random circle spinning coin sequence and applies its good or bad effect.
function script.random_circle()
	local active_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local direction_angle: f32 = 0
	local ring_x: f32 = 0
	local ring_y: f32 = 0
	local ring_z: f32 = 0
	local circle_sound_effect: s32 = 0
	local ring_motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local party_npc: s32 = 0
	local coin_side: s32 = 0
	local frame_count: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local coin_target_angle: f32 = 0
	local minimum_spin_steps: s32 = 0
	local stop_angle: f32 = 0
	local random_roll: s32 = 0
	local chance_threshold: s32 = 0
	local brightness: f32 = 0
	local effect_id: s32 = 0
	local effect_amount: f32 = 0
	local restored_x: f32 = 0
	local restored_y: f32 = 0
	local restored_z: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if active_character == 2 then
			message.show_and_wait(0, 22, 8, 0, 0)
		else
			message.show_and_wait(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			circle_x = out1 or circle_x
			circle_y = out2 or circle_y
			circle_z = out3 or circle_z
		end
		direction_angle = event.get_direction_angle(circle_x, circle_y, circle_z, player_x, player_y, player_z) or direction_angle
		player_x = vm.f32(vm.f32(vm.sin(direction_angle) * 25.0) + circle_x)
		player_y = circle_y
		player_z = vm.f32(vm.f32(vm.cos(direction_angle) * 25.0) + circle_z)
		event.set_character_position(0, player_x, player_y, player_z)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	character.reset_action_motion()
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		ring_x = out1 or ring_x
		ring_y = out2 or ring_y
		ring_z = out3 or ring_z
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(ring_x, ring_y + 30.0, ring_z)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	wait.background_load()
	circle_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or circle_sound_effect
	event.change_directory("event/dng/")
	event.start_background_file_loads_2("ring.gltf", "randomcoin.gltf")
	vm.wait(5)
	wait.background_load()
	ring_motion_frame = event.get_random_circle_motion_frame() or ring_motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, ring_x, ring_y, ring_z)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, ring_motion_frame)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, ring_x, ring_y - 30.0, ring_z)
	coin_angle = event.get_random_number(6.2831855) or coin_angle
	coin_angle = vm.f32(coin_angle - vm.f32(3.1415927))
	coin_angle = event.wrap_angle(coin_angle) or coin_angle
	event.set_character_rotation(13, 0.0, coin_angle, 0.0)
	event.change_directory("")
	party_npc = event.get_party_npc() or party_npc
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, ring_x, ring_y + 40.0, ring_z, 30, 2, 0.5)
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
			event.play_sound_effect(circle_sound_effect, 0)
		end
		if frame_count == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if frame_count >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame_count > 300 then
			event.stop_sound_effect(circle_sound_effect, 0)
			event.play_sound_effect(circle_sound_effect, 3)
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
	coin_target_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or coin_target_angle
	minimum_spin_steps = 0
	minimum_spin_steps = event.get_random_number_int(10) or minimum_spin_steps
	minimum_spin_steps = vm.i32(minimum_spin_steps + 4)
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
		if frame_count >= minimum_spin_steps then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			stop_angle = coin_target_angle
			stop_angle = event.wrap_angle(stop_angle) or stop_angle
			if coin_angle < stop_angle and calc.is_angle_within(coin_angle, stop_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, stop_angle, 0.0)
				coin_side = 0
				break
			end
			stop_angle = vm.f32(coin_target_angle - vm.f32(3.1415927))
			stop_angle = event.wrap_angle(stop_angle) or stop_angle
			if coin_angle < stop_angle and calc.is_angle_within(coin_angle, stop_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, stop_angle, 0.0)
				coin_side = 1
				break
			end
		end
		frame_count = vm.i32(frame_count + 1)
	end
	coin_target_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or coin_target_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, coin_target_angle, 1.0) == 0 then
		coin_side = 0
	else
		coin_side = 1
	end
	coin_target_angle = coin_angle
	wait.frames(20)
	random_roll = event.get_random_number_int(10) or random_roll
	if party_npc == 24 then
		chance_threshold = 100
	else
		chance_threshold = 6
	end
	if random_roll < chance_threshold then
		random_roll = event.get_random_number_int(10) or random_roll
		if coin_side == 0 then
			if party_npc == 24 then
				chance_threshold = 0
			else
				chance_threshold = 2
			end
		elseif party_npc == 24 then
			chance_threshold = 100
		else
			chance_threshold = 4
		end
		if random_roll < chance_threshold then
			coin_target_angle = vm.f32(coin_target_angle + vm.f32(3.14))
			coin_target_angle = event.wrap_angle(coin_target_angle) or coin_target_angle
			event.rotate_object_sequence(5, 0.0, coin_target_angle, 0.0, 8)
			if coin_side == 0 then
				coin_side = 1
			else
				coin_side = 0
			end
			wait.frames(10)
		else
			random_roll = event.get_random_number_int(10) or random_roll
			if random_roll < 1 then
				coin_target_angle = vm.f32(coin_target_angle + vm.f32(3.14))
				coin_target_angle = event.wrap_angle(coin_target_angle) or coin_target_angle
				event.rotate_object_sequence(5, 0.0, coin_target_angle, 0.0, 6)
				coin_target_angle = vm.f32(coin_target_angle + vm.f32(1.57))
				coin_target_angle = event.wrap_angle(coin_target_angle) or coin_target_angle
				event.rotate_object_sequence(5, 0.0, coin_target_angle, 0.0, 3)
				coin_target_angle = vm.f32(coin_target_angle + vm.f32(1.57))
				coin_target_angle = event.wrap_angle(coin_target_angle) or coin_target_angle
				event.rotate_object_sequence(5, 0.0, coin_target_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	coin_target_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or coin_target_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, coin_target_angle, 1.0) == 0 then
		coin_side = 0
	else
		coin_side = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness = 1.0
	frame_count = 0
	effect_id = event.get_random_circle_effect(coin_side) or effect_id
	if coin_side == 0 then
		event.play_sound_effect(circle_sound_effect, 1)
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
			event.place_treasure_box(ring_x, ring_y, ring_z, coin_target_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(circle_sound_effect, 2)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness)
			brightness = vm.f32(brightness - vm.f32(0.03))
			frame_count = frame_count + 1
			vm.wait(19)
		end
		message.show_and_wait(0, 2320, 8, 0, 0)
		effect_amount = event.apply_random_circle_effect(effect_id) or effect_amount
		if effect_id == 5 then
			if active_character == 0 or active_character == 2 then
				message.show_and_wait(0, 2321, 8, 0, 0)
			end
			if active_character == 1 or active_character == 3 then
				message.show_and_wait(0, 2322, 8, 0, 0)
			end
		end
		if effect_id == 6 then
			if active_character == 0 then
				message.show_and_wait(0, 2323, 8, 0, 0)
			end
			if active_character == 1 or active_character == 3 then
				message.show_and_wait(0, 2324, 8, 0, 0)
			end
			if active_character == 2 then
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
		event.spawn_pull_items(ring_x, ring_y, ring_z, 1, 10, effect_amount / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
	do
		local out1, out2, out3 = event.get_previous_camera_next_position()
		restored_x = out1 or restored_x
		restored_y = out2 or restored_y
		restored_z = out3 or restored_z
	end
	event.set_camera_position(restored_x, restored_y, restored_z)
	do
		local out1, out2, out3 = event.get_previous_camera_next_look_at()
		restored_x = out1 or restored_x
		restored_y = out2 or restored_y
		restored_z = out3 or restored_z
	end
	event.set_camera_look_at(restored_x, restored_y, restored_z)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the geostone use scene and records the geostone as used on the floor.
function script.geostone()
	local active_character: s32 = 0
	local original_x: f32 = 0
	local original_y: f32 = 0
	local original_z: f32 = 0
	local geostone_sound_effect: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local stand_x: f32 = 0
	local stand_y: f32 = 0
	local stand_z: f32 = 0
	local stone_x: f32 = 0
	local stone_y: f32 = 0
	local stone_z: f32 = 0
	local facing_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	local system_sound_id: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if active_character == 2 then
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
	if active_character == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_character == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	geostone_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or geostone_sound_effect
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
		stand_x = out1 or stand_x
		stand_y = out2 or stand_y
		stand_z = out3 or stand_z
	end
	event.copy_vector(stand_x, stand_y, stand_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		stone_x = out1 or stone_x
		stone_y = out2 or stone_y
		stone_z = out3 or stone_z
	end
	stone_y = vm.f32(stand_y + 18.0)
	event.set_object_handle_position(1, stone_x, stone_y, stone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(stone_x, stone_y, stone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if active_character == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if active_character == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	stand_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + stone_x)
	stand_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + stone_z)
	event.set_character_position(0, stand_x, stand_y, stand_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_character == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(stand_x, stand_y + 18.0, stand_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, stand_x, stand_y + 36.0, stand_z)
	end
	if active_character == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(stand_x, stand_y + 18.0, stand_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		effect_x = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + stand_x)
		effect_y = vm.f32(stand_y + 18.0)
		effect_z = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + stand_z)
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
	event.play_sound_effect(geostone_sound_effect, 0)
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
	facing_angle = event.get_direction_angle(stand_x, stand_y, stand_z, camera_x, camera_y, camera_z) or facing_angle
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
	event.play_sound_effect(geostone_sound_effect, 1)
	object.wait_until_done(0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	system_sound_id = event.get_system_sound_id() or system_sound_id
	event.play_sound_effect(system_sound_id, 18)
	message.show_and_wait(0, 2400, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor = event.get_dungeon_floor() or floor
	event.set_dungeon_floor_info(stage_id, floor, 5, 256)
	event.start_crossfade(10)
	if active_character == 1 then
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

--- Runs the silent defeat sequence.
function script.on_defeat_dialogue()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_defeat_dialogue

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = clear_floor

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

--- Shows a tutorial message and waits for it to be dismissed.
function script.show_tutorial_guide()
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
script[2510] = script.show_tutorial_guide

--- Shows the level up tutorial messages and a pointer to the help menu.
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
	event.open_message_window_2(0, 'Mehr erf[UNI00e4]hrst du unter\n"Hilfe" im Hauptmen[UNI00fc].')
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Shows the buggy driving instructions.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Lenken des Buggys\n   Beschleunige mit (L)↑, bremse mit (L)↓.\n   lenke mit (L) ← oder →.\n   Scharfe Kurven: [l1] + (L) ← oder →."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Shows the Magic-Absorb Blade tutorial messages.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]Du kannst die Magie-Raub-\nKlinge jetzt verwenden.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Die Fertigkeit Magie-Raub-Klinge\nerlaubt es dir, die Energie von\nElementarangriffen wie Feuer beim\nAbwehren aufzunehmen.<page>Beim Angriff verwandelt\nsie sich in Magie."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Die Energie eines Elements kannst\ndu immer weiter aufladen.\nNimmst du aber einen anderen Elementar-\nTyp auf, verlierst du die ganze Ladung."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Wie viel Elementarenergie du\nabsorbieren kannst, h[UNI00e4]ngt von der\nHaltbarkeit deiner Waffe ab."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Um absorbierte Elementarenergie als\nMagie abzugeben, dr[UNI00fc]cke [l1]\n w[UNI00e4]hrend du mit [r1] abwehrst."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Runs a full Sphida shot, from aiming and the power gauge through the ball physics to the result and prizes.
function script.sphida_shot()
	local texture_block: s32 = 0
	local shot_sound_effect: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local ball_rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local ball_rotation_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local angle: f32 = 0
	local shot_power_or_water_state: f32 = 0
	local club_curve_factor: f32 = 0
	local gauge_level: s32 = 0
	local side_velocity_x: f32 = 0
	local curve_spin: f32 = 0
	local side_velocity_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local reached_goal: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local out_of_bounds_state: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local probe_x: f32 = 0
	local probe_y: f32 = 0
	local probe_z: f32 = 0
	local remaining_distance: f32 = 0
	local length: f32 = 0
	local collision_index: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local step: s32 = 0
	local pin_distance: f32 = 0
	local to_pin_x: f32 = 0
	local to_pin_y: f32 = 0
	local to_pin_z: f32 = 0
	local segment_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_angle: f32 = 0
	local remaining_par: s32 = 0
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
	texture_block = event.get_sphida_texture_bank() or texture_block
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	shot_sound_effect = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or shot_sound_effect
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
	angle = 12.5
	event.set_sphida_carry_angle(vm.f32(angle * vm.f32(3.1415927)) / 180.0)
	shot_power_or_water_state, club_curve_factor, gauge_level = minigame.get_equipped_club_definition(shot_power_or_water_state, club_curve_factor, gauge_level)
	event.set_sphida_power_gauge_safe_level(gauge_level)
	do
		local out1, out2, out3 = event.zero_vector()
		side_velocity_x = out1 or side_velocity_x
		curve_spin = out2 or curve_spin
		side_velocity_z = out3 or side_velocity_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_angle, angle = minigame.aim_sphida_shot(aim_angle, angle, texture_block)
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
		t1, shot_power_or_water_state, aim_angle, curve_spin, side_velocity_x, gauge_level = minigame.run_sphida_power_gauge(shot_power_or_water_state, texture_block, aim_angle, curve_spin, side_velocity_x, shot_sound_effect, gauge_level)
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
	reached_goal = 0
	if gauge_level ~= 1 and gauge_level ~= -1 and gauge_level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if gauge_level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if gauge_level == 2 or gauge_level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if gauge_level == 3 or gauge_level == -3 then
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
	if shot_power_or_water_state <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.frames(25)
		if gauge_level ~= 4 then
			event.play_sound_effect(shot_sound_effect, 3)
		end
	elseif shot_power_or_water_state <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.frames(34)
		event.play_sound_effect(shot_sound_effect, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.frames(39)
		if gauge_level == 0 then
			event.play_sound_effect(shot_sound_effect, 12)
		else
			event.play_sound_effect(shot_sound_effect, 1)
		end
	end
	if gauge_level == 4 then
		wait.frames(50)
		minigame.consume_sphida_shot(shot_sound_effect)
		event.set_sphida_ball_position(start_x, start_y, start_z)
		event.set_character_position(8, start_x, start_y, start_z)
		event.set_character_position(9, start_x, start_y, start_z)
		minigame.finish_sphida_round(0)
		return
	end
	if gauge_level == 0 then
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
	shot_power_or_water_state = minigame.scale_by_club_power(shot_power_or_water_state)
	angle = vm.f32(vm.f32(angle * vm.f32(3.1415927)) / 180.0)
	shot_power_or_water_state = vm.f32(shot_power_or_water_state - vm.f32(shot_power_or_water_state * angle))
	velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(shot_power_or_water_state * vm.cos(angle)))
	velocity_y = vm.f32(shot_power_or_water_state * vm.sin(angle))
	velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(shot_power_or_water_state * vm.cos(angle)))
	curve_spin = vm.f32(vm.f32(curve_spin * vm.f32(3.1415927)) / 2.0)
	side_velocity_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_curve_factor) * side_velocity_x) * vm.f32(0.4))
	side_velocity_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_curve_factor) * side_velocity_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	out_of_bounds_state = 0
	gauge_level = 0
	sound_cooldown = 0
	do
		local out1, out2, out3, out4, out5 =
			event.get_segment_collision_13(0, ball_x, ball_y + 5.0, ball_z, ball_x, ball_y, ball_z, 0)
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
		collision_index = out4 or collision_index
		surface_type = out5 or surface_type
	end
	if collision_index >= 0 and (surface_type == 1 or surface_type == 7) then
		print("----------------START_MIZU-------------------\n")
		shot_power_or_water_state = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		shot_power_or_water_state = 0.0
	end
	step = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (step + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_index = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_index
			if gauge_level == 1 and collision_index >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (step + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + side_velocity_x)
				velocity_z = vm.f32(velocity_z + side_velocity_z)
				side_velocity_x = vm.f32(side_velocity_x * vm.f32(0.8))
				side_velocity_z = vm.f32(side_velocity_z * vm.f32(0.8))
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
		if curve_spin ~= 0.0 then
			angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or angle
			angle = vm.f32(angle + curve_spin)
			angle = event.wrap_angle(angle) or angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(angle) / 10.0) * club_curve_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(angle) / 10.0) * club_curve_factor))
		end
		length = event.get_vector_length(side_velocity_x, 0.0, side_velocity_z) or length
		if length > vm.f32(0.01) then
			speed = event.get_vector_length(side_velocity_x, 0.0, side_velocity_z) or speed
			angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + side_velocity_x, previous_y, previous_z + side_velocity_z) or angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				ball_rotation_x = out1 or ball_rotation_x
				aim_angle = out2 or aim_angle
				ball_rotation_z = out3 or ball_rotation_z
			end
			event.set_character_rotation(8, ball_rotation_x, angle, ball_rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, ball_rotation_x, angle, ball_rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				ball_rotation_x = out1 or ball_rotation_x
				aim_angle = out2 or aim_angle
				ball_rotation_z = out3 or ball_rotation_z
			end
			event.set_character_rotation(8, ball_rotation_x, angle, ball_rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, ball_rotation_x, angle, ball_rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		remaining_distance = speed
		angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or angle
		probe_x = vm.f32(vm.sin(vm.f32(angle - vm.f32(1.5707964))) * 3.0)
		probe_z = vm.f32(vm.cos(vm.f32(angle - vm.f32(1.5707964))) * 3.0)
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
			collision_index = out4 or collision_index
			surface_type = out5 or surface_type
		end
		if collision_index >= 0 and (surface_type == 1 or surface_type == 7) then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(hit_x, hit_y, hit_z)
			if sound_cooldown <= 0 then
				event.play_sound_effect(shot_sound_effect, 11)
				sound_cooldown = 10
			end
			if shot_power_or_water_state == 0.0 then
				shot_power_or_water_state = 1.0
				velocity_x = vm.f32(velocity_x * vm.f32(0.4))
				velocity_y = vm.f32(velocity_y * vm.f32(0.4))
				velocity_z = vm.f32(velocity_z * vm.f32(0.4))
				side_velocity_x = 0.0
				side_velocity_z = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				shot_power_or_water_state = 0.0
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
			collision_index = out7 or collision_index
		end
		if collision_index < 0 then
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
				collision_index = 1
			end
		end
		while collision_index >= 0 do
			curve_spin = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if shot_power_or_water_state ~= 1.0 and sound_cooldown <= 0 then
				event.play_sound_effect(shot_sound_effect, 6)
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
			length = vm.f32(remaining_distance - length)
			if length <= 0.0 then
				break
			else
				remaining_distance = length
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				if velocity_y < 0.0 and normal_y > 0.0 then
					velocity_x = vm.f32(side_velocity_x * 2.0)
					velocity_y = 0.0
					velocity_z = vm.f32(side_velocity_z * 2.0)
					side_velocity_x = vm.f32(side_velocity_x * vm.f32(0.2))
					side_velocity_z = vm.f32(side_velocity_z * vm.f32(0.2))
				else
					if
						velocity_x < 0.0 and normal_x > 0.0
						or velocity_x > 0.0 and normal_x < 0.0
						or velocity_z < 0.0 and normal_z > 0.0
						or velocity_z > 0.0 and normal_z < 0.0
					then
						side_velocity_x = 0.0
						side_velocity_z = 0.0
					end
					velocity_x = 0.0
					velocity_y = 0.0
					velocity_z = 0.0
				end
				if shot_power_or_water_state == 0.0 then
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
					collision_index = out7 or collision_index
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
			collision_index = out7 or collision_index
			surface_type = out8 or surface_type
		end
		if collision_index >= 0 then
			curve_spin = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			length = event.get_vector_length(velocity_x, 0.0, velocity_z) or length
			if length < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				gauge_level = 1
			else
				if shot_power_or_water_state == 0.0 then
					velocity_x = vm.f32(velocity_x * vm.f32(0.9))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
					velocity_z = vm.f32(velocity_z * vm.f32(0.9))
					velocity_x = vm.f32(velocity_x + vm.f32(side_velocity_x * 2.0))
					velocity_z = vm.f32(velocity_z + vm.f32(side_velocity_z * 2.0))
					side_velocity_x = vm.f32(side_velocity_x * vm.f32(0.2))
					side_velocity_z = vm.f32(side_velocity_z * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					velocity_x = vm.f32(velocity_x * vm.f32(0.8))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.4))
					velocity_z = vm.f32(velocity_z * vm.f32(0.8))
					side_velocity_x = 0.0
					side_velocity_z = 0.0
				end
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if shot_power_or_water_state ~= 1.0 and sound_cooldown <= 0 then
					event.play_sound_effect(shot_sound_effect, 5)
					sound_cooldown = 10
				end
			end
			length = event.get_vector_length(side_velocity_x, 0.0, side_velocity_z) or length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and length < vm.f32(0.4) then
				if surface_type == 6 then
					out_of_bounds_state = 1
					break
				end
				surface_type = event.get_automap_attribute_status(ball_x, ball_y, ball_z) or surface_type
				if not (surface_type == 1) then
					break
				end
				out_of_bounds_state = 1
				break
			end
		end
		if ball_y < -500.0 then
			out_of_bounds_state = 1
			break
		elseif step >= 480 then
			out_of_bounds_state = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			to_pin_x = vm.f32(pin_x - ball_x)
			to_pin_y = vm.f32(pin_y - ball_y)
			to_pin_z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(to_pin_x, to_pin_y, to_pin_z) or pin_distance
			if ball_color ~= pin_color then
				segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or segment_distance
				if segment_distance >= 0.0 and segment_distance <= 30.0 then
					reached_goal = 1
					break
				end
				if pin_distance ~= 0.0 then
					if pin_distance <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(to_pin_x, to_pin_y, to_pin_z, vm.fdiv(vm.f32(0.6), pin_distance))
							to_pin_x = out1 or to_pin_x
							to_pin_y = out2 or to_pin_y
							to_pin_z = out3 or to_pin_z
						end
						do
							local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, to_pin_x, to_pin_y, to_pin_z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, to_pin_x, to_pin_y, to_pin_z)
							velocity_x = out1 or velocity_x
							velocity_y = out2 or velocity_y
							velocity_z = out3 or velocity_z
						end
					end
				else
					reached_goal = 1
					break
				end
			elseif pin_distance ~= 0.0 then
				if pin_distance <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(to_pin_x, to_pin_y, to_pin_z, vm.fdiv(1.0, pin_distance))
						to_pin_x = out1 or to_pin_x
						to_pin_y = out2 or to_pin_y
						to_pin_z = out3 or to_pin_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, to_pin_x, to_pin_y, to_pin_z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, to_pin_x, to_pin_y, to_pin_z)
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
				if out_of_bounds_state >= 30 then
					if out_of_bounds_state >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				out_of_bounds_state = out_of_bounds_state + 1
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
			step = step + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if out_of_bounds_state == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		remaining_par = event.get_sphida_par() or remaining_par
		if reached_goal == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(shot_sound_effect, 17)
			step = 0
			while step < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
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
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			step = 0
			while step < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
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
			collision_index = event.get_dungeon_floor_info(pin_color, ball_color, 4) or collision_index
			do
				local out1, out2 = event.get_sphida_prize(collision_index)
				sound_cooldown = out1 or sound_cooldown
				surface_type = out2 or surface_type
			end
			collision_index = vm.i32(collision_index + 1)
			event.set_dungeon_floor_info(pin_color, ball_color, 4, collision_index)
			event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, angle, sound_cooldown, surface_type)
			wait.frames(54)
			wait.frames(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			shot_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or shot_sound_effect
			event.stop_music(0)
			event.play_sound_effect(shot_sound_effect, 0)
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
				event.set_event_sprite_texture(0, "sphida_bar", texture_block)
				event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			else
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", texture_block)
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
		elseif remaining_par >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			choice = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(24)
			if choice == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
					collision_index = out1 or collision_index
					start_x = out2 or start_x
					start_y = out3 or start_y
					start_z = out4 or start_z
				end
				if collision_index == 0 then
					do
						local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
						start_x = out1 or start_x
						start_y = out2 or start_y
						start_z = out3 or start_z
					end
				end
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pin_x = out1 or pin_x
					pin_y = out2 or pin_y
					pin_z = out3 or pin_z
				end
				speed = event.get_distance_between(start_x, start_y, start_z, pin_x, pin_y, pin_z) or speed
				if speed < 40.0 then
					angle = event.get_random_number(6.2831855) or angle
					angle = vm.f32(angle - vm.f32(3.1415927))
					start_x = vm.f32(start_x + vm.f32(vm.sin(angle) * 50.0))
					start_z = vm.f32(start_z + vm.f32(vm.cos(angle) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(start_x, start_y, start_z)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						collision_index = out4 or collision_index
					end
					step = 0
					while collision_index >= 0 do
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
							collision_index = out4 or collision_index
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
		event.play_sound_effect(shot_sound_effect, 18)
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
		event.set_event_sprite_texture(0, "sphida_bar", texture_block)
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
	if reached_goal == 1 then
		minigame.consume_sphida_shot(-1)
	else
		minigame.consume_sphida_shot(shot_sound_effect)
	end
	minigame.finish_sphida_round(reached_goal)
end

--- Offers to move the ball to the player and does so on a yes.
function script.sphida_near_ball()
	local choice: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	choice = message.ask_choice(0, 2004, 8, 0, 0, 2, 1)
	if choice == 0 then
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

--- Warns that this is the last ball move, offers it and does so on a yes.
function script.sphida_near_ball_last()
	local choice: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Das ist das letzte Mal, dass du\ndie Kugel zu dir holen kannst.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Die Kugel zu dir holen?")
	choice = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
	if choice == 0 then
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

--- Loads the Sphida course, places the player and opens the Sphida menu.
function script.enter_sphida_course()
	event.initialize_event()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	vm.wait(1)
	vm.wait(2)
	event.set_dungeon_floor(0)
	event.load_dungeon_map("d07f01", "mstage7", 64)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	minigame.set_up_sphida_course_with_draw_distance(2, 7)
	event.set_sphida_saved_hole(7)
	event.set_character_position(0, 1280.0, 0.0, 3200.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_look_at(1280.0, 30.0, 3200.0)
	event.set_camera_position(1280.0, 40.0, 3300.0)
	event.fade_in_screen(30)
	wait.frames(30)
	event.open_event_menu(28)
	vm.wait(4)
	event.reset_follow_camera(0)
	event.finish_event()
end
script[6000] = script.enter_sphida_course

--- Leaves the Sphida minigame and loads the s52 map.
function script.return_to_s52()
	minigame.leave_sphida()
	event.load_dungeon_map("s52")
	event.load_event_script("s52/s52.stb", 18040)
	vm.wait(2)
end
script[18040] = script.return_to_s52

--- Leaves the Sphida minigame and loads the s54 map for the first entry.
function script.return_to_s54_first()
	minigame.leave_sphida()
	event.load_dungeon_map("s54")
	event.load_event_script("s54/s54.stb", 18080)
	vm.wait(2)
end
script[18080] = script.return_to_s54_first

--- Leaves the Sphida minigame and loads the s54 map for the second entry.
function script.return_to_s54_second()
	minigame.leave_sphida()
	event.load_dungeon_map("s54")
	event.load_event_script("s54/s54.stb", 18120)
	vm.wait(2)
end
script[18120] = script.return_to_s54_second

--- Leaves the Sphida minigame and loads the boss floor for the first entry.
function script.return_to_boss_floor_first()
	minigame.leave_sphida()
	event.load_dungeon_map("d07b01")
	event.load_event_script("d07b01/d07b01.stb", 18160)
	vm.wait(2)
end
script[18160] = script.return_to_boss_floor_first

--- Leaves the Sphida minigame and loads the boss floor for the second entry.
function script.return_to_boss_floor_second()
	minigame.leave_sphida()
	event.load_dungeon_map("d07b01")
	event.load_event_script("d07b01/d07b01.stb", 18200)
	vm.wait(2)
end
script[18200] = script.return_to_boss_floor_second

--- Sets the party's stats and equipment and loads the s54 map.
function script.prepare_party_then_load_s54()
	local item_count: s32 = 0
	event.set_character_max_hp(0, 240)
	event.set_character_max_hp(1, 240)
	event.set_character_defence(0, 94)
	event.set_character_defence(1, 94)
	item_count = event.get_item_count(270) or item_count
	if item_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - item_count))
	end
	item_count = event.get_item_count(21) or item_count
	if item_count <= 0 then
		event.add_inventory_item(21)
	end
	event.equip_character_item(0, 21)
	item_count = event.get_item_count(40) or item_count
	if item_count <= 0 then
		event.add_inventory_item(40)
	end
	event.equip_character_item(0, 40)
	item_count = event.get_item_count(88) or item_count
	if item_count <= 0 then
		event.add_inventory_item(88)
	end
	event.equip_character_item(1, 109)
	if item_count <= 0 then
		event.add_inventory_item(109)
	end
	event.equip_character_item(1, 109)
	event.load_dungeon_map("s54")
	vm.wait(1)
	event.load_event_script("s54/s54.stb", 28010)
	event.finish_event()
end
script[28010] = script.prepare_party_then_load_s54

--- Sets the party's stats and equipment and loads the boss floor.
function script.prepare_party_then_load_boss_floor()
	local item_count: s32 = 0
	event.set_character_max_hp(0, 240)
	event.set_character_max_hp(1, 240)
	event.set_character_defence(0, 94)
	event.set_character_defence(1, 94)
	item_count = event.get_item_count(270) or item_count
	if item_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - item_count))
	end
	item_count = event.get_item_count(21) or item_count
	if item_count <= 0 then
		event.add_inventory_item(21)
	end
	event.equip_character_item(0, 21)
	item_count = event.get_item_count(40) or item_count
	if item_count <= 0 then
		event.add_inventory_item(40)
	end
	event.equip_character_item(0, 40)
	item_count = event.get_item_count(88) or item_count
	if item_count <= 0 then
		event.add_inventory_item(88)
	end
	event.equip_character_item(1, 109)
	if item_count <= 0 then
		event.add_inventory_item(109)
	end
	event.equip_character_item(1, 109)
	event.load_dungeon_map("d07b01")
	vm.wait(1)
	event.load_event_script("d07b01/d07b01.stb", 28020)
end
script[28020] = script.prepare_party_then_load_boss_floor

return script
