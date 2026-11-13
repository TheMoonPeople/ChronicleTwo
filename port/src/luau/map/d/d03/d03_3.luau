--!strict
--- Floor entry, condor perches, random circles, the geostone and the Sphida golf minigame for Starlight Canyon.

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
local starlight_canyon = require("@lib/event/starlight_canyon")
local treasure_box = require("@lib/event/german/treasure_box")
local wait = require("@lib/event/wait")

--- Plays the cutscene in which a condor drops the player onto the floor, then shows the floor title and any seal warnings.
local function play_floor_entry_scene(show_floor_map: s32)
	local drop_sound_id: s32 = 0
	local origin_x: f32 = 0
	local origin_y: f32 = 0
	local origin_z: f32 = 0
	local origin_angle: f32 = 0
	local current_floor: s32 = 0
	local previous_floor: s32 = 0
	local seal_flags: s32 = 0
	local texture_block: s32 = 0
	local active_character: s32 = 0
	local carry_velocity_x: f32 = 0
	local carry_velocity_y: f32 = 0
	local carry_velocity_z: f32 = 0
	local fall_velocity_x: f32 = 0
	local fall_velocity_y: f32 = 0
	local fall_velocity_z: f32 = 0
	local frame: s32 = 0
	local landing_state: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local ground_x: f32 = 0
	local ground_y: f32 = 0
	local ground_z: f32 = 0
	local seal_sound_id: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		drop_sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_032.sound.json") or drop_sound_id
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			origin_x = out1 or origin_x
			origin_y = out2 or origin_y
			origin_z = out3 or origin_z
			origin_angle = out4 or origin_angle
		end
		event.set_event_world_coordinate(origin_x, origin_y, origin_z, origin_angle)
		event.show_dungeon_status_bar(0, 1.0)
		if show_floor_map ~= 0 then
			current_floor = event.get_dungeon_floor() or current_floor
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			event.load_dungeon_map_display(5, 0, 2, current_floor, previous_floor)
			event.fade_dungeon_map(1, 30)
		else
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d02_1.json", 0)
			event.set_event_image_texture(0, "logo_d02")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 30)
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
		active_character = event.get_playable_character() or active_character
		if active_character == 0 then
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/d03/p00_26a.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_scene_status_flags(1, 9, 8, 1)
		event.load_item_model(5, 341, "info", 10)
		event.set_character_active(10)
		event.attach_character_to_frame(9, "niku", 10)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_sequence_position(0, 0.0, 140.0, -200.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "持ち上げ停止", 4, -1.0, 1)
		event.set_object_sequence_position(1, 0.0, 140.0, -200.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "肉つかみ飛び", 4)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.enable_drama_skip()
		event.play_sound_effect(drop_sound_id, 1)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-53.68, 35.8, 200.46)
		event.set_camera_sequence_look_at(12.57, 57.95, 3.94)
		event.move_camera_sequence_eased(-53.68, 35.8, 200.46, 12.57, 10.0, 3.94, 30, 2, 1.0)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		carry_velocity_x = 0.0
		carry_velocity_y = -10.0
		carry_velocity_z = 7.0
		fall_velocity_x = 0.0
		fall_velocity_y = -3.0
		fall_velocity_z = 8.0
		landing_state = 0
		frame = 0
		while frame < 60 do
			event.add_object_sequence_position_offset(1, carry_velocity_x, carry_velocity_y, carry_velocity_z)
			if frame < 30 then
				event.add_object_sequence_position_offset(0, carry_velocity_x, carry_velocity_y, carry_velocity_z)
			else
				if frame == 30 then
					event.set_object_sequence_motion(0, "d03着地", 2)
					event.queue_object_sequence_next_motion(0, "立ち", 4)
				end
				do
					local out1, out2, out3 = event.get_character_position(0)
					player_x = out1 or player_x
					player_y = out2 or player_y
					player_z = out3 or player_z
				end
				if landing_state == 0 then
					if vm.f32(player_y + fall_velocity_y) <= 0.0 then
						event.set_character_position(0, player_x, 0.0, player_z)
						landing_state = 1
					else
						event.add_object_sequence_position_offset(0, fall_velocity_x, fall_velocity_y, fall_velocity_z)
						fall_velocity_y = vm.f32(fall_velocity_y * vm.f32(1.1))
						fall_velocity_z = vm.f32(fall_velocity_z * vm.f32(0.8))
					end
				elseif landing_state <= 1 then
					do
						local out1, out2, out3, out4 =
							event.get_segment_collision_12(0, player_x, 8.0, player_z, player_x, -8.0, player_z, 0)
						ground_x = out1 or ground_x
						ground_y = out2 or ground_y
						ground_z = out3 or ground_z
						landing_state = out4 or landing_state
					end
					if landing_state >= 0 then
						event.set_character_position(0, ground_x, ground_y, ground_z)
					else
						event.set_character_position(0, player_x, -0.7, player_z)
					end
					landing_state = 10
				end
			end
			carry_velocity_y = vm.f32(carry_velocity_y * vm.f32(0.9))
			if show_floor_map == 1 and frame == 20 then
				event.set_dungeon_map_piece_moving(1)
			end
			frame = frame + 1
			at = 2
			vm.wait(2)
		end
		at = 3
		object.wait_until_done(0)
		at = 4
		wait.frames(20)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_camera_sequence_look_at(0.0, 29.0, 100.0)
		event.set_camera_sequence_position(0.0, 41.0, -20.0)
		event.show_dungeon_status_bar(1)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 0.0, -1.0, 100.0, 40)
		at = 5
		wait.frames(10)
		if show_floor_map ~= 0 then
			event.fade_dungeon_map(0, 30)
		else
			event.fade_event_image(0, 0, 30)
		end
		at = 6
		wait.frames(30)
		event.set_object_sequence_motion(0, "立ち")
		at = 7
		wait.frames(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			carry_velocity_x = 0.0
			carry_velocity_y = -10.0
			carry_velocity_z = 7.0
			fall_velocity_x = 0.0
			fall_velocity_y = -3.0
			fall_velocity_z = 8.0
			landing_state = 0
			frame = 0
			local _ = landing_state == 0
			landing_state = 1
			local _ = vm.f32(player_y + fall_velocity_y) <= 0.0
			fall_velocity_y = vm.f32(fall_velocity_y * vm.f32(1.1))
			fall_velocity_z = vm.f32(fall_velocity_z * vm.f32(0.8))
			local _ = landing_state <= 1
			local _ = landing_state >= 0
			landing_state = 10
			carry_velocity_y = vm.f32(carry_velocity_y * vm.f32(0.9))
			local _ = frame < 60
			local _ = frame < 30
			local _ = frame == 30
			local _ = frame == 20
			frame = frame + 1
		end
		if at <= 2 then
			cutscene.skip_command(0)
		end
		if at <= 3 then
			wait.frames_skipping(20)
		end
		if at <= 4 then
			wait.frames_skipping(10)
		end
		if at <= 5 then
			wait.frames_skipping(30)
		end
		if at <= 6 then
			wait.frames_skipping(10)
		end
		return true
	end)
	at = 8
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.stop_sound_effect(drop_sound_id, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_event_image(0)
	if show_floor_map ~= 0 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	end
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_position(0, 0.0, -1.0, 100.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(0.0, 29.0, 100.0)
	event.set_camera_position(0.0, 41.0, -20.0)
	event.reset_follow_camera(0)
	event.initialize_event()
	event.fade_in_screen(0)
	if seal_flags ~= 0 then
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 9
			vm.wait(9)
			at = 10
			wait.background_load()
			texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or texture_block
			event.set_event_sprite_texture(0, "aka_fuuin", texture_block)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 11
			vm.wait(11)
			at = 12
			wait.background_load()
			texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or texture_block
			event.set_event_sprite_texture(0, "ao_fuuin", texture_block)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 13
			vm.wait(13)
			at = 14
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
		seal_sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_050.sound.json") or seal_sound_id
		event.play_sound_effect(seal_sound_id, 0)
		event.set_message_window_mode(0, 4)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.open_message_window_2(0, "Auf dieser Ebene scheint es\nein Rotes Siegel zu geben.")
			at = 15
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Max wurde vom Roten Atlamillia\nerw[UNI00e4]hlt. Du kannst ihn nicht anw[UNI00e4]hlen!")
			at = 16
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.open_message_window_2(0, "Auf dieser Ebene scheint es\nein Blaues Siegel zu geben.")
			at = 17
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"Monica wurde vom Blauen Atlamillia\nerw[UNI00e4]hlt. Du kannst sie nicht anw[UNI00e4]hlen!"
			)
			at = 18
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.open_message_window_2(0, "Auf dieser Ebene scheint es\nein Wei[UNI00df]es Siegel zu geben.")
			at = 19
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"Du kannst nicht mehr heilen\noder ungew[UNI00f6]hnl. Zust[UNI00e4]nde ver[UNI00e4]ndern."
			)
			at = 20
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		event.set_event_sprite_draw_pass(0, 0)
		event.delete_event_image(0)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Loads the map for the current floor, routes special floors to their story scenes and plays the floor entry.
local function enter_floor()
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	local visit_count: s32 = 0
	local boss_scene_flag: s32 = 0
	local fishing_tournament_flag: s32 = 0
	local thrown_entry_flag: s32 = 0
	local weather_roll: s32 = 0
	local previous_floor: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.reset_action_character_motion(0)
		event.set_local_event_flag(0, 0)
		event.set_local_event_flag(1, 0)
		event.set_local_event_flag(2, 0)
		event.set_local_event_flag(3, 0)
		event.set_local_event_flag(4, 0)
		event.set_event_projection(524.9)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor_number = event.get_dungeon_floor() or floor_number
		visit_count = event.get_dungeon_floor_info(stage_id, floor_number, 7) or visit_count
		dungeon.increment_floor_counter(stage_id, floor_number)
		event.initialize_dungeon_floor()
		if floor_number == 0 then
			event.go_to_georama_edit(1)
			at = 2
			vm.wait(2)
			return
		end
		if floor_number == 8 then
			event.allow_next_music_load()
			event.load_dungeon_map("s17")
			event.load_event_script("s17/s17.stb", 100)
			return
		end
		if floor_number == 15 then
			event.skip_next_music_load()
			event.load_dungeon_map("s14")
			event.load_event_script("s14/s14.stb", 100)
			return
		end
		if floor_number == 18 then
			event.skip_next_music_load()
			event.load_dungeon_map("s18")
			event.load_event_script("s18/s18.stb", 100)
			return
		end
		if floor_number == 23 then
			boss_scene_flag = event.get_save_flag(356) or boss_scene_flag
			if boss_scene_flag == 0 then
				event.load_dungeon_map("s56")
				event.load_event_script("s56/s56.stb", 100)
			else
				event.load_dungeon_map("d03b01")
				event.load_event_script("d03b01/d03b01.stb", 100)
			end
			return
		end
		fishing_tournament_flag = event.get_save_flag(344) or fishing_tournament_flag
		if floor_number == 21 and fishing_tournament_flag == 0 then
			event.force_start_fishing_tournament()
			event.set_dungeon_pause_flags(2048, 1)
			event.skip_next_music_load()
			event.load_dungeon_map("s45")
			event.load_event_script("s45/s45.stb", 510)
			return
		end
		thrown_entry_flag = event.get_save_flag(307) or thrown_entry_flag
		if floor_number == 2 and thrown_entry_flag == 0 then
			event.skip_next_music_load()
			event.load_dungeon_map("d03f01", "d03f01", 6)
			at = 3
			starlight_canyon.play_thrown_entry_scene()
			event.set_dungeon_pause_flags(2048, 1)
			event.skip_next_music_load()
			event.load_dungeon_map("s46")
			event.load_event_script("s46/s46.stb", 510)
			return
		end
		if floor_number == 22 then
			event.allow_next_music_load()
			event.stop_music(0)
			at = 4
			wait.frames(6)
			event.load_music(37)
			event.skip_next_music_load()
		end
		if floor_number >= 12 and floor_number <= 14 then
			event.load_dungeon_map("d03f02s", "d03f02", 6)
		end
		weather_roll = event.get_random_number_int(100) or weather_roll
		if floor_number >= 1 and floor_number <= 7 then
			if vm.imod(weather_roll, 8) == 0 then
				event.load_dungeon_map("d03f01r", "d03f01", 6)
				event.set_dungeon_weather(2)
			else
				event.load_dungeon_map("d03f01", "d03f01", 6)
			end
		end
		if floor_number >= 9 and floor_number <= 11 or floor_number >= 16 and floor_number <= 17 then
			if vm.imod(weather_roll, 8) == 0 then
				event.load_dungeon_map("d03f02r", "d03f02", 6)
				event.set_dungeon_weather(2)
			else
				event.load_dungeon_map("d03f02", "d03f02", 6)
			end
		end
		if floor_number >= 19 and floor_number <= 22 then
			if vm.imod(weather_roll, 8) == 0 then
				event.load_dungeon_map("d03f03r", "d03f03", 6)
				event.set_dungeon_weather(2)
			else
				event.load_dungeon_map("d03f03", "d03f03", 6)
			end
		end
		event.load_dungeon_monster(0)
		event.place_treasure_box_at_event_point(-1)
		event.place_dungeon_monster(-1)
		event.play_music(0)
		if floor_number == 1 and visit_count <= 0 then
			at = 5
			play_floor_entry_scene(0)
		else
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			if floor_number == previous_floor then
				at = 6
				play_floor_entry_scene(0)
			else
				at = 7
				play_floor_entry_scene(1)
			end
		end
		event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
		dungeon.show_floor_title()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				dungeon.increment_floor_counter_skipping(stage_id, floor_number)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		if at <= 7 then
			if at <= 4 then
				at = 5
				play_floor_entry_scene(0)
				return vm.continue_with(function()
					event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
					dungeon.show_floor_title()
					return
				end)
			end
			if at <= 5 then
				at = 6
				play_floor_entry_scene(0)
				return vm.continue_with(function()
					event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
					dungeon.show_floor_title()
					return
				end)
			end
			if at <= 6 then
				at = 7
				play_floor_entry_scene(1)
				return vm.continue_with(function()
					event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
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

--- Resets the minigame state, plays the area music, asks the player to pick a floor on the map and enters it.
local function enter_floor_from_map()
	local music_number: s32 = 0
	local previous_floor: s32 = 0
	local next_floor: s32 = 0
	event.initialize_event()
	event.initialize_sphida()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 17 then
		event.stop_music(0)
		wait.frames(6)
		event.load_music(17)
	end
	event.play_music(0)
	event.load_map_sounds(3601)
	event.open_dungeon_floor_map(2)
	vm.wait(2)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		previous_floor = out2 or previous_floor
		next_floor = out3 or next_floor
	end
	event.set_dungeon_floor(next_floor)
	event.set_dungeon_previous_floor(previous_floor)
	enter_floor()
end

--- Handles the condor perch, letting the player offer meat to be carried to the next floor.
local function use_condor_perch(perch_index: s32)
	local active_character: s32 = 0
	local interaction_stage: s32 = 0
	local use_answer: s32 = 0
	local item: s32 = 0
	local ride_choice: any = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	local next_floor: s32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.get_local_event_flag(perch_index)
	event.set_dungeon_pause_flags(1, 1)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.initialize_event()
		character.reset_action_motion()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_message_bubble_tail(0, 1)
		event.set_dungeon_pause_flags(1, 0)
	else
		interaction_stage = event.get_triggered_event_data_2(6) or interaction_stage
		if interaction_stage == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			event.open_message_window_2(0, "Es ist das Kondor-Nest.\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)")
			use_answer = message.ask_confirmation(0, -1, 5, 256, 208, use_answer)
			event.set_message_bubble_tail(0, 1)
			event.set_message_draw_speed(0, 0)
			if use_answer == 1 then
				interaction_stage = 2
			end
			event.finish_event()
		end
		if interaction_stage == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait.frames(6)
			event.open_use_item_menu(341)
			vm.wait(5)
			item = vmhost.used_item() or item
			if item == 341 then
				event.set_local_event_flag(perch_index, 1)
				event.set_message_window_mode(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(0, "Der Kondor ist [UNI00fc]ber\ndir und sieht hierher.")
				message.show_and_wait(0, -1, 5, 0, 0)
				event.set_message_selection_top_line(0, 0)
				event.set_message_window_mode(0, 5)
				ride_choice = message.ask_choice(0, 10, 8, 256, 208, 2, 1)
				if ride_choice == 0 then
					event.clear_event_battle_monsters(-1)
					minigame.delete_sphida_objects()
					starlight_canyon.play_carried_exit_scene()
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
						vm.wait(10)
						event.fade_out_screen(0)
						event.set_event_sprite_draw_pass(0, 0)
					end
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor_number = event.get_dungeon_floor() or floor_number
					next_floor = event.get_dungeon_next_floor(floor_number, perch_index) or next_floor
					event.set_dungeon_floor(next_floor)
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
					event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
					event.finish_dungeon_floor()
					event.finish_event()
					enter_floor_from_map()
				else
					event.add_inventory_item(341)
				end
			elseif item <= 0 then
				event.finish_event()
			else
				character.shake_head()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
			wait.frames(6)
		end
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Runs the floor clear sequence with the victory scene, medal rewards, seal messages and Sphida prompts.
local function complete_floor()
	local active_character: s32 = 0
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	local save_flag_220: s32 = 0
	local save_flag_317: s32 = 0
	local sub_games: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local fast_clear_result: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local trial_version: s32 = 0
	local floor_status: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_character = event.get_playable_character() or active_character
		character.reset_action_motion()
		event.set_dungeon_pause_flags(512, 1)
		event.show_dungeon_status_bar(0, 0.16666667)
		at = 1
		wait.frames(10)
		event.set_dungeon_pause_flags(16384, 1)
		event.clear_event_battle_monsters(-1)
		if active_character == 0 then
			at = 2
			dungeon.play_max_victory(1)
		end
		if active_character == 1 then
			at = 3
			dungeon.play_monica_victory(1)
		end
		if active_character == 2 or active_character == 3 then
			at = 4
			dungeon.play_finish_banner(active_character)
		end
		event.set_dungeon_pause_flags(16384, 0)
		cutscene.noop()
		event.reset_action_character_motion(0, 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.show_dungeon_status_bar(1, 0.16666667)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor_number = event.get_dungeon_floor() or floor_number
		event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
		event.set_dungeon_floor_info(stage_id, floor_number, 5, 1024)
		save_flag_317 = event.get_save_flag(220) or save_flag_317
		save_flag_317 = event.get_save_flag(317) or save_flag_317
		sub_games = event.get_floor_sub_games() or sub_games
		if (if save_flag_317 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
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
		fast_clear_result = event.record_floor_clear_time() or fast_clear_result
		do
			local out1, out2 = event.get_floor_practice_result(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		at = 5
		spheda.announce_medal_reward(fast_clear_result, cleared, bonus)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		trial_version = event.is_trial_version() or trial_version
		floor_status = event.get_dungeon_floor_status() or floor_status
		if
			(if (if bit32.band(floor_status, 1) ~= 0 then 1 else bit32.band(floor_status, 2)) ~= 0 then 1 else bit32.band(floor_status, 4))
			~= 0
		then
			event.set_dungeon_floor_status_flags(7, 0)
			if bit32.band(floor_status, 1) ~= 0 then
				event.open_message_window_2(0, "Das Rote Siegel wurde ge[UNI00f6]ffnet.")
			end
			if bit32.band(floor_status, 2) ~= 0 then
				event.open_message_window_2(0, "Das Blaue Siegel wurde ge[UNI00f6]ffnet.")
			end
			if bit32.band(floor_status, 4) ~= 0 then
				event.open_message_window_2(0, "Das Wei[UNI00df]e Siegel wurde ge[UNI00f6]ffnet.")
			end
			at = 6
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		at = 7
		message.show_and_wait(0, 2130, 8, 0, 0)
		if trial_version ~= 1 then
			if save_flag_220 == 1 and save_flag_317 == 1 and bit32.band(sub_games, 3) == 3 then
				at = 8
				message.show_and_wait(0, 2120, 8, 0, 0)
				at = 9
				spheda.move_character_to_ball()
			else
				if (if save_flag_220 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
					at = 10
					message.show_and_wait(0, 2110, 8, 0, 0)
				end
				if (if save_flag_317 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
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
					if active_character == 1 then
						at = 3
						dungeon.play_monica_victory(1)
					end
					if active_character == 2 or active_character == 3 then
						at = 4
						dungeon.play_finish_banner(active_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					cutscene.noop()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor_number = event.get_dungeon_floor() or floor_number
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 1024)
					save_flag_317 = event.get_save_flag(220) or save_flag_317
					save_flag_317 = event.get_save_flag(317) or save_flag_317
					sub_games = event.get_floor_sub_games() or sub_games
					if (if save_flag_317 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
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
					fast_clear_result = event.record_floor_clear_time() or fast_clear_result
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					spheda.announce_medal_reward(fast_clear_result, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					trial_version = event.is_trial_version() or trial_version
					floor_status = event.get_dungeon_floor_status() or floor_status
					if
						(
							if (if bit32.band(floor_status, 1) ~= 0 then 1 else bit32.band(floor_status, 2)) ~= 0
								then 1
								else bit32.band(floor_status, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(floor_status, 1) ~= 0 then
							event.open_message_window_2(0, "Das Rote Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(floor_status, 2) ~= 0 then
							event.open_message_window_2(0, "Das Blaue Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(floor_status, 4) ~= 0 then
							event.open_message_window_2(0, "Das Wei[UNI00df]e Siegel wurde ge[UNI00f6]ffnet.")
						end
						at = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					at = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if trial_version ~= 1 then
						if save_flag_220 == 1 and save_flag_317 == 1 and bit32.band(sub_games, 3) == 3 then
							at = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							at = 9
							spheda.move_character_to_ball()
						else
							if (if save_flag_220 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
								at = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if save_flag_317 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
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
					if active_character == 2 or active_character == 3 then
						at = 4
						dungeon.play_finish_banner(active_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					cutscene.noop()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor_number = event.get_dungeon_floor() or floor_number
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 1024)
					save_flag_317 = event.get_save_flag(220) or save_flag_317
					save_flag_317 = event.get_save_flag(317) or save_flag_317
					sub_games = event.get_floor_sub_games() or sub_games
					if (if save_flag_317 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
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
					fast_clear_result = event.record_floor_clear_time() or fast_clear_result
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					spheda.announce_medal_reward(fast_clear_result, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					trial_version = event.is_trial_version() or trial_version
					floor_status = event.get_dungeon_floor_status() or floor_status
					if
						(
							if (if bit32.band(floor_status, 1) ~= 0 then 1 else bit32.band(floor_status, 2)) ~= 0
								then 1
								else bit32.band(floor_status, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(floor_status, 1) ~= 0 then
							event.open_message_window_2(0, "Das Rote Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(floor_status, 2) ~= 0 then
							event.open_message_window_2(0, "Das Blaue Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(floor_status, 4) ~= 0 then
							event.open_message_window_2(0, "Das Wei[UNI00df]e Siegel wurde ge[UNI00f6]ffnet.")
						end
						at = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					at = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if trial_version ~= 1 then
						if save_flag_220 == 1 and save_flag_317 == 1 and bit32.band(sub_games, 3) == 3 then
							at = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							at = 9
							spheda.move_character_to_ball()
						else
							if (if save_flag_220 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
								at = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if save_flag_317 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
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
				dungeon.play_finish_banner(active_character)
				return vm.continue_with(function()
					event.set_dungeon_pause_flags(16384, 0)
					cutscene.noop()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor_number = event.get_dungeon_floor() or floor_number
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 1024)
					save_flag_317 = event.get_save_flag(220) or save_flag_317
					save_flag_317 = event.get_save_flag(317) or save_flag_317
					sub_games = event.get_floor_sub_games() or sub_games
					if (if save_flag_317 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
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
					fast_clear_result = event.record_floor_clear_time() or fast_clear_result
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					spheda.announce_medal_reward(fast_clear_result, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					trial_version = event.is_trial_version() or trial_version
					floor_status = event.get_dungeon_floor_status() or floor_status
					if
						(
							if (if bit32.band(floor_status, 1) ~= 0 then 1 else bit32.band(floor_status, 2)) ~= 0
								then 1
								else bit32.band(floor_status, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(floor_status, 1) ~= 0 then
							event.open_message_window_2(0, "Das Rote Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(floor_status, 2) ~= 0 then
							event.open_message_window_2(0, "Das Blaue Siegel wurde ge[UNI00f6]ffnet.")
						end
						if bit32.band(floor_status, 4) ~= 0 then
							event.open_message_window_2(0, "Das Wei[UNI00df]e Siegel wurde ge[UNI00f6]ffnet.")
						end
						at = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					at = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if trial_version ~= 1 then
						if save_flag_220 == 1 and save_flag_317 == 1 and bit32.band(sub_games, 3) == 3 then
							at = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							at = 9
							spheda.move_character_to_ball()
						else
							if (if save_flag_220 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
								at = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if save_flag_317 == 1 then bit32.band(sub_games, 1) else 0) ~= 0 then
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
				cutscene.noop()
				cutscene.noop_with_arguments(0, -1)
				message.resume_numbered_messages(fast_clear_result, cleared, bonus)
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

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Finishes immediately when no other event is requested.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	event.finish_event()
end

--- Gives the player the starting items and enables the Sphida flags.
function script.grant_starting_items()
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
script[200] = script.grant_starting_items

--- Uses the first condor perch.
function script.use_condor_perch_0()
	use_condor_perch(0)
end
script[300] = script.use_condor_perch_0

--- Uses the second condor perch.
function script.edit_analyze_changed()
	use_condor_perch(1)
end

--- Uses the third condor perch.
function script.use_condor_perch_2()
	use_condor_perch(2)
end
script[320] = script.use_condor_perch_2

--- Uses the fourth condor perch.
function script.use_condor_perch_3()
	use_condor_perch(3)
end
script[330] = script.use_condor_perch_3

--- Event 340, which map data, a script or the engine runs by number.
script[340] = starlight_canyon.use_star_key_door

--- Restores the player, camera and floor monsters when a floor is resumed, then shows the floor title.
function script.resume_floor()
	local origin_x: f32 = 0
	local origin_y: f32 = 0
	local origin_z: f32 = 0
	local origin_angle: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 0)
	event.load_dungeon_monster(0)
	event.place_treasure_box_at_event_point(-1)
	event.place_dungeon_monster(-1)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
		origin_x = out1 or origin_x
		origin_y = out2 or origin_y
		origin_z = out3 or origin_z
		origin_angle = out4 or origin_angle
	end
	event.set_event_world_coordinate(origin_x, origin_y, origin_z, origin_angle)
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
	event.show_dungeon_status_bar(1, 1.0)
	sound.load_event_sound_effects()
	event.fade_in_screen(30)
	vm.wait(1)
	dungeon.show_floor_title()
	event.finish_event()
end
script[500] = script.resume_floor

script.enter_floor_from_map = enter_floor_from_map
script[1000] = script.enter_floor_from_map

script.enter_floor = enter_floor
script[1010] = script.enter_floor

--- The dungeon system event run when the player opens a treasure box.
script.treasure_box = treasure_box.open_nearest

--- Spins a coin over a random circle until the player stops it and applies a good or bad effect depending on the side that faces the camera.
function script.random_circle()
	local active_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local player_angle: f32 = 0
	local ring_x: f32 = 0
	local ring_y: f32 = 0
	local ring_z: f32 = 0
	local circle_sound_id: s32 = 0
	local motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local party_npc_id: s32 = 0
	local circle_kind: s32 = 0
	local frame: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local reference_angle: f32 = 0
	local extra_spin_frames: s32 = 0
	local target_angle: f32 = 0
	local roll: s32 = 0
	local threshold: s32 = 0
	local bright_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_amount: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
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
		player_angle = event.get_direction_angle(circle_x, circle_y, circle_z, player_x, player_y, player_z) or player_angle
		player_x = vm.f32(vm.f32(vm.sin(player_angle) * 25.0) + circle_x)
		player_y = circle_y
		player_z = vm.f32(vm.f32(vm.cos(player_angle) * 25.0) + circle_z)
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
	circle_sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or circle_sound_id
	event.change_directory("event/dng/")
	event.start_background_file_loads_2("ring.gltf", "randomcoin.gltf")
	vm.wait(5)
	wait.background_load()
	motion_frame = event.get_random_circle_motion_frame() or motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, ring_x, ring_y, ring_z)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, motion_frame)
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
	party_npc_id = event.get_party_npc() or party_npc_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, ring_x, ring_y + 40.0, ring_z, 30, 2, 0.5)
	frame = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		if frame == 10 then
			event.play_sound_effect(circle_sound_id, 0)
		end
		if frame == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if frame >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame > 300 then
			event.stop_sound_effect(circle_sound_id, 0)
			event.play_sound_effect(circle_sound_id, 3)
			vm.wait(7)
			break
		else
			frame = frame + 1
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
	reference_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or reference_angle
	extra_spin_frames = 0
	extra_spin_frames = event.get_random_number_int(10) or extra_spin_frames
	extra_spin_frames = vm.i32(extra_spin_frames + 4)
	frame = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		vm.wait(9)
		if frame >= extra_spin_frames then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			target_angle = reference_angle
			target_angle = event.wrap_angle(target_angle) or target_angle
			if coin_angle < target_angle and calc.is_angle_within(coin_angle, target_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, target_angle, 0.0)
				circle_kind = 0
				break
			end
			target_angle = vm.f32(reference_angle - vm.f32(3.1415927))
			target_angle = event.wrap_angle(target_angle) or target_angle
			if coin_angle < target_angle and calc.is_angle_within(coin_angle, target_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, target_angle, 0.0)
				circle_kind = 1
				break
			end
		end
		frame = vm.i32(frame + 1)
	end
	reference_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or reference_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, reference_angle, 1.0) == 0 then
		circle_kind = 0
	else
		circle_kind = 1
	end
	reference_angle = coin_angle
	wait.frames(20)
	roll = event.get_random_number_int(10) or roll
	if party_npc_id == 24 then
		threshold = 100
	else
		threshold = 6
	end
	if roll < threshold then
		roll = event.get_random_number_int(10) or roll
		if circle_kind == 0 then
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
			reference_angle = vm.f32(reference_angle + vm.f32(3.14))
			reference_angle = event.wrap_angle(reference_angle) or reference_angle
			event.rotate_object_sequence(5, 0.0, reference_angle, 0.0, 8)
			if circle_kind == 0 then
				circle_kind = 1
			else
				circle_kind = 0
			end
			wait.frames(10)
		else
			roll = event.get_random_number_int(10) or roll
			if roll < 1 then
				reference_angle = vm.f32(reference_angle + vm.f32(3.14))
				reference_angle = event.wrap_angle(reference_angle) or reference_angle
				event.rotate_object_sequence(5, 0.0, reference_angle, 0.0, 6)
				reference_angle = vm.f32(reference_angle + vm.f32(1.57))
				reference_angle = event.wrap_angle(reference_angle) or reference_angle
				event.rotate_object_sequence(5, 0.0, reference_angle, 0.0, 3)
				reference_angle = vm.f32(reference_angle + vm.f32(1.57))
				reference_angle = event.wrap_angle(reference_angle) or reference_angle
				event.rotate_object_sequence(5, 0.0, reference_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	reference_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or reference_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, reference_angle, 1.0) == 0 then
		circle_kind = 0
	else
		circle_kind = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	bright_rate = 1.0
	frame = 0
	effect_id = event.get_random_circle_effect(circle_kind) or effect_id
	if circle_kind == 0 then
		event.play_sound_effect(circle_sound_id, 1)
		while frame < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate + vm.f32(0.03))
			frame = frame + 1
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
			event.place_treasure_box(ring_x, ring_y, ring_z, reference_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(circle_sound_id, 2)
		while frame < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate - vm.f32(0.03))
			frame = frame + 1
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

--- Plays the scene in which the character holds up the geostone and records its use on the floor.
function script.geostone()
	local active_character: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local sound_id: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local geostone_x: f32 = 0
	local geostone_y: f32 = 0
	local geostone_z: f32 = 0
	local facing_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	local system_sound_id: s32 = 0
	local stage_id: s32 = 0
	local floor_number: s32 = 0
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
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
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
	sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_id
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
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	event.copy_vector(player_x, player_y, player_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		geostone_x = out1 or geostone_x
		geostone_y = out2 or geostone_y
		geostone_z = out3 or geostone_z
	end
	geostone_y = vm.f32(player_y + 18.0)
	event.set_object_handle_position(1, geostone_x, geostone_y, geostone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(geostone_x, geostone_y, geostone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if active_character == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if active_character == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	player_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + geostone_x)
	player_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + geostone_z)
	event.set_character_position(0, player_x, player_y, player_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_character == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(player_x, player_y + 18.0, player_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, player_x, player_y + 36.0, player_z)
	end
	if active_character == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(player_x, player_y + 18.0, player_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		effect_x = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + player_x)
		effect_y = vm.f32(player_y + 18.0)
		effect_z = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + player_z)
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
	event.play_sound_effect(sound_id, 0)
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
	facing_angle = event.get_direction_angle(player_x, player_y, player_z, camera_x, camera_y, camera_z) or facing_angle
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
	event.play_sound_effect(sound_id, 1)
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
	floor_number = event.get_dungeon_floor() or floor_number
	event.set_dungeon_floor_info(stage_id, floor_number, 5, 256)
	event.start_crossfade(10)
	if active_character == 1 then
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

--- Runs a monster defeat sequence without a message.
function script.defeat_monster_silently()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.defeat_monster_silently

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = complete_floor

--- Shows the first-time guide for random stones.
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

--- Shows a help message and waits for the player to dismiss it.
function script.show_guide_2610()
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
script[2510] = script.show_guide_2610

--- Shows the first-time level up guide.
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

--- Shows the first-time guide for driving the ridepod.
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

--- Shows the first-time guide for the magic absorbing sword.
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

--- Runs a full Sphida shot, from aiming and the power gauge through the ball's flight, bouncing and rolling to scoring or a penalty.
function script.sphida_shot()
	local texture_bank: s32 = 0
	local sound_effect_id: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local rotation_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local elevation: f32 = 0
	local power_or_water_flag: f32 = 0
	local club_roll_factor: f32 = 0
	local gauge_result_or_rolling: s32 = 0
	local roll_x: f32 = 0
	local hook_angle: f32 = 0
	local roll_z: f32 = 0
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
	local out_of_bounds_timer: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local hit_normal_x: f32 = 0
	local hit_normal_y: f32 = 0
	local hit_normal_z: f32 = 0
	local probe_x: f32 = 0
	local probe_y: f32 = 0
	local probe_z: f32 = 0
	local remaining_travel: f32 = 0
	local distance: f32 = 0
	local collision_index: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local frame: s32 = 0
	local pin_distance: f32 = 0
	local pin_delta_x: f32 = 0
	local pin_delta_y: f32 = 0
	local pin_delta_z: f32 = 0
	local path_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local yaw: f32 = 0
	local remaining_par: s32 = 0
	local move_answer: any = 0
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
	sound_effect_id = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_effect_id
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
	elevation = 12.5
	event.set_sphida_carry_angle(vm.f32(elevation * vm.f32(3.1415927)) / 180.0)
	power_or_water_flag, club_roll_factor, gauge_result_or_rolling = minigame.get_equipped_club_definition(power_or_water_flag, club_roll_factor, gauge_result_or_rolling)
	event.set_sphida_power_gauge_safe_level(gauge_result_or_rolling)
	do
		local out1, out2, out3 = event.zero_vector()
		roll_x = out1 or roll_x
		hook_angle = out2 or hook_angle
		roll_z = out3 or roll_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_angle, elevation = minigame.aim_sphida_shot(aim_angle, elevation, texture_bank)
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
		t1, power_or_water_flag, aim_angle, hook_angle, roll_x, gauge_result_or_rolling = minigame.run_sphida_power_gauge(power_or_water_flag, texture_bank, aim_angle, hook_angle, roll_x, sound_effect_id, gauge_result_or_rolling)
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
	if gauge_result_or_rolling ~= 1 and gauge_result_or_rolling ~= -1 and gauge_result_or_rolling ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if gauge_result_or_rolling == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if gauge_result_or_rolling == 2 or gauge_result_or_rolling == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if gauge_result_or_rolling == 3 or gauge_result_or_rolling == -3 then
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
	if power_or_water_flag <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.frames(25)
		if gauge_result_or_rolling ~= 4 then
			event.play_sound_effect(sound_effect_id, 3)
		end
	elseif power_or_water_flag <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.frames(34)
		event.play_sound_effect(sound_effect_id, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.frames(39)
		if gauge_result_or_rolling == 0 then
			event.play_sound_effect(sound_effect_id, 12)
		else
			event.play_sound_effect(sound_effect_id, 1)
		end
	end
	if gauge_result_or_rolling == 4 then
		wait.frames(50)
		minigame.consume_sphida_shot(sound_effect_id)
		event.set_sphida_ball_position(start_x, start_y, start_z)
		event.set_character_position(8, start_x, start_y, start_z)
		event.set_character_position(9, start_x, start_y, start_z)
		minigame.finish_sphida_round(0)
		return
	end
	if gauge_result_or_rolling == 0 then
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
	power_or_water_flag = minigame.scale_by_club_power(power_or_water_flag)
	elevation = vm.f32(vm.f32(elevation * vm.f32(3.1415927)) / 180.0)
	power_or_water_flag = vm.f32(power_or_water_flag - vm.f32(power_or_water_flag * elevation))
	velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(power_or_water_flag * vm.cos(elevation)))
	velocity_y = vm.f32(power_or_water_flag * vm.sin(elevation))
	velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(power_or_water_flag * vm.cos(elevation)))
	hook_angle = vm.f32(vm.f32(hook_angle * vm.f32(3.1415927)) / 2.0)
	roll_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_roll_factor) * roll_x) * vm.f32(0.4))
	roll_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_roll_factor) * roll_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	out_of_bounds_timer = 0
	gauge_result_or_rolling = 0
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
		power_or_water_flag = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		power_or_water_flag = 0.0
	end
	frame = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (frame + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_index = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_index
			if gauge_result_or_rolling == 1 and collision_index >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (frame + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + roll_x)
				velocity_z = vm.f32(velocity_z + roll_z)
				roll_x = vm.f32(roll_x * vm.f32(0.8))
				roll_z = vm.f32(roll_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (frame + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if hook_angle ~= 0.0 then
			elevation = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation
			elevation = vm.f32(elevation + hook_angle)
			elevation = event.wrap_angle(elevation) or elevation
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(elevation) / 10.0) * club_roll_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(elevation) / 10.0) * club_roll_factor))
		end
		distance = event.get_vector_length(roll_x, 0.0, roll_z) or distance
		if distance > vm.f32(0.01) then
			speed = event.get_vector_length(roll_x, 0.0, roll_z) or speed
			elevation = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + roll_x, previous_y, previous_z + roll_z) or elevation
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, elevation, rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, elevation, rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			elevation = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, elevation, rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, elevation, rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		remaining_travel = speed
		elevation = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation
		probe_x = vm.f32(vm.sin(vm.f32(elevation - vm.f32(1.5707964))) * 3.0)
		probe_z = vm.f32(vm.cos(vm.f32(elevation - vm.f32(1.5707964))) * 3.0)
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
				event.play_sound_effect(sound_effect_id, 11)
				sound_cooldown = 10
			end
			if power_or_water_flag == 0.0 then
				power_or_water_flag = 1.0
				velocity_x = vm.f32(velocity_x * vm.f32(0.4))
				velocity_y = vm.f32(velocity_y * vm.f32(0.4))
				velocity_z = vm.f32(velocity_z * vm.f32(0.4))
				roll_x = 0.0
				roll_z = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				power_or_water_flag = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + probe_x, ball_y + probe_y, ball_z + probe_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			hit_normal_x = out4 or hit_normal_x
			hit_normal_y = out5 or hit_normal_y
			hit_normal_z = out6 or hit_normal_z
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
					hit_normal_x = out1 or hit_normal_x
					hit_normal_y = out2 or hit_normal_y
					hit_normal_z = out3 or hit_normal_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(hit_normal_x, hit_normal_y, hit_normal_z)
					hit_normal_x = out1 or hit_normal_x
					hit_normal_y = out2 or hit_normal_y
					hit_normal_z = out3 or hit_normal_z
				end
				collision_index = 1
			end
		end
		while collision_index >= 0 do
			hook_angle = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if power_or_water_flag ~= 1.0 and sound_cooldown <= 0 then
				event.play_sound_effect(sound_effect_id, 6)
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
			distance = event.get_vector_length(previous_x, previous_y, previous_z) or distance
			distance = vm.f32(remaining_travel - distance)
			if distance <= 0.0 then
				break
			else
				remaining_travel = distance
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				if velocity_y < 0.0 and hit_normal_y > 0.0 then
					velocity_x = vm.f32(roll_x * 2.0)
					velocity_y = 0.0
					velocity_z = vm.f32(roll_z * 2.0)
					roll_x = vm.f32(roll_x * vm.f32(0.2))
					roll_z = vm.f32(roll_z * vm.f32(0.2))
				else
					if
						velocity_x < 0.0 and hit_normal_x > 0.0
						or velocity_x > 0.0 and hit_normal_x < 0.0
						or velocity_z < 0.0 and hit_normal_z > 0.0
						or velocity_z > 0.0 and hit_normal_z < 0.0
					then
						roll_x = 0.0
						roll_z = 0.0
					end
					velocity_x = 0.0
					velocity_y = 0.0
					velocity_z = 0.0
				end
				if power_or_water_flag == 0.0 then
					velocity_x = vm.f32(vm.f32(vm.f32(hit_normal_x * speed) * vm.f32(0.9)) + velocity_x)
					velocity_y = vm.f32(vm.f32(vm.f32(hit_normal_y * speed) * vm.f32(0.58)) + velocity_y)
					velocity_z = vm.f32(vm.f32(vm.f32(hit_normal_z * speed) * vm.f32(0.9)) + velocity_z)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					velocity_x = vm.f32(vm.f32(vm.f32(hit_normal_x * speed) * vm.f32(0.8)) + velocity_x)
					velocity_y = vm.f32(vm.f32(vm.f32(hit_normal_y * speed) * vm.f32(0.4)) + velocity_y)
					velocity_z = vm.f32(vm.f32(vm.f32(hit_normal_z * speed) * vm.f32(0.8)) + velocity_z)
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
					local out1, out2, out3 = event.scale_vector(hit_normal_x, hit_normal_y, hit_normal_z, distance)
					hit_normal_x = out1 or hit_normal_x
					hit_normal_y = out2 or hit_normal_y
					hit_normal_z = out3 or hit_normal_z
				end
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, hit_normal_x, hit_normal_y, hit_normal_z)
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
					hit_normal_x = out4 or hit_normal_x
					hit_normal_y = out5 or hit_normal_y
					hit_normal_z = out6 or hit_normal_z
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
			hit_normal_x = out4 or hit_normal_x
			hit_normal_y = out5 or hit_normal_y
			hit_normal_z = out6 or hit_normal_z
			collision_index = out7 or collision_index
			surface_type = out8 or surface_type
		end
		if collision_index >= 0 then
			hook_angle = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			distance = event.get_vector_length(velocity_x, 0.0, velocity_z) or distance
			if distance < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				gauge_result_or_rolling = 1
			else
				if power_or_water_flag == 0.0 then
					velocity_x = vm.f32(velocity_x * vm.f32(0.9))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
					velocity_z = vm.f32(velocity_z * vm.f32(0.9))
					velocity_x = vm.f32(velocity_x + vm.f32(roll_x * 2.0))
					velocity_z = vm.f32(velocity_z + vm.f32(roll_z * 2.0))
					roll_x = vm.f32(roll_x * vm.f32(0.2))
					roll_z = vm.f32(roll_z * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					velocity_x = vm.f32(velocity_x * vm.f32(0.8))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.4))
					velocity_z = vm.f32(velocity_z * vm.f32(0.8))
					roll_x = 0.0
					roll_z = 0.0
				end
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if power_or_water_flag ~= 1.0 and sound_cooldown <= 0 then
					event.play_sound_effect(sound_effect_id, 5)
					sound_cooldown = 10
				end
			end
			distance = event.get_vector_length(roll_x, 0.0, roll_z) or distance
			if velocity_y == 0.0 and speed < vm.f32(1.6) and distance < vm.f32(0.4) then
				if surface_type == 6 then
					out_of_bounds_timer = 1
					break
				end
				surface_type = event.get_automap_attribute_status(ball_x, ball_y, ball_z) or surface_type
				if not (surface_type == 1) then
					break
				end
				out_of_bounds_timer = 1
				break
			end
		end
		if ball_y < -500.0 then
			out_of_bounds_timer = 1
			break
		elseif frame >= 480 then
			out_of_bounds_timer = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			pin_delta_x = vm.f32(pin_x - ball_x)
			pin_delta_y = vm.f32(pin_y - ball_y)
			pin_delta_z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(pin_delta_x, pin_delta_y, pin_delta_z) or pin_distance
			if ball_color ~= pin_color then
				path_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or path_distance
				if path_distance >= 0.0 and path_distance <= 30.0 then
					reached_goal = 1
					break
				end
				if pin_distance ~= 0.0 then
					if pin_distance <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(pin_delta_x, pin_delta_y, pin_delta_z, vm.fdiv(vm.f32(0.6), pin_distance))
							pin_delta_x = out1 or pin_delta_x
							pin_delta_y = out2 or pin_delta_y
							pin_delta_z = out3 or pin_delta_z
						end
						do
							local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, pin_delta_x, pin_delta_y, pin_delta_z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, pin_delta_x, pin_delta_y, pin_delta_z)
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
						local out1, out2, out3 = event.scale_vector(pin_delta_x, pin_delta_y, pin_delta_z, vm.fdiv(1.0, pin_distance))
						pin_delta_x = out1 or pin_delta_x
						pin_delta_y = out2 or pin_delta_y
						pin_delta_z = out3 or pin_delta_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, pin_delta_x, pin_delta_y, pin_delta_z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, pin_delta_x, pin_delta_y, pin_delta_z)
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
				if out_of_bounds_timer >= 30 then
					if out_of_bounds_timer >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				out_of_bounds_timer = out_of_bounds_timer + 1
			elseif frame >= 20 then
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
				yaw = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					camera_x,
					camera_y,
					camera_z
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
			frame = frame + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if out_of_bounds_timer == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		remaining_par = event.get_sphida_par() or remaining_par
		if reached_goal == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_effect_id, 17)
			frame = 0
			while frame < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame = frame + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			frame = 0
			while frame < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame = frame + 1
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
			event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, elevation, sound_cooldown, surface_type)
			wait.frames(54)
			wait.frames(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			sound_effect_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_effect_id
			event.stop_music(0)
			event.play_sound_effect(sound_effect_id, 0)
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
		elseif remaining_par >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			move_answer = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(24)
			if move_answer == 0 then
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
					elevation = event.get_random_number(6.2831855) or elevation
					elevation = vm.f32(elevation - vm.f32(3.1415927))
					start_x = vm.f32(start_x + vm.f32(vm.sin(elevation) * 50.0))
					start_z = vm.f32(start_z + vm.f32(vm.cos(elevation) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(start_x, start_y, start_z)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						collision_index = out4 or collision_index
					end
					frame = 0
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
						frame = frame + 1
						if frame > 6 then
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
		event.play_sound_effect(sound_effect_id, 18)
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
		event.set_sphida_ball_position(start_x, start_y, start_z)
		event.set_character_position(8, start_x, start_y, start_z)
		event.set_character_position(9, start_x, start_y, start_z)
		event.release_camera_sequence_follow_object()
	end
	if reached_goal == 1 then
		minigame.consume_sphida_shot(-1)
	else
		minigame.consume_sphida_shot(sound_effect_id)
	end
	minigame.finish_sphida_round(reached_goal)
end

--- Offers to move the Sphida ball to the player when the menu button is pressed near it.
function script.sphida_near_ball()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	answer = message.ask_choice(0, 2004, 8, 0, 0, 2, 1)
	if answer == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.set_sphida_ball_position(player_x, player_y + 3.0, player_z)
		event.set_character_position(8, player_x, player_y + 3.0, player_z)
		event.set_character_position(9, player_x, player_y + 3.0, player_z)
		minigame.consume_sphida_shot(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- Warns that this is the last time the Sphida ball can be moved, then offers to move it to the player.
function script.sphida_near_ball_last()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Das ist das letzte Mal, dass du\ndie Kugel zu dir holen kannst.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Die Kugel zu dir holen?")
	answer = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
	if answer == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.set_sphida_ball_position(player_x, player_y + 3.0, player_z)
		event.set_character_position(8, player_x, player_y + 3.0, player_z)
		event.set_character_position(9, player_x, player_y + 3.0, player_z)
		event.set_sphida_last_challenge(1)
		event.start_crossfade(15)
	end
	vm.wait(3)
	event.finish_event()
end

--- Loads the Sphida course, places the player at the ball and offers to move the ball to a nearby spot.
function script.start_sphida_course()
	local found_point: s32 = 0
	local attempt: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local angle: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local spot_x: f32 = 0
	local spot_y: f32 = 0
	local spot_z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local box_x: f32 = 0
	local box_y: f32 = 0
	local box_z: f32 = 0
	local pin_distance: f32 = 0
	local random_angle: f32 = 0
	local answer: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.set_time_of_day(17.5)
		event.set_time_of_day_advancing(0)
		event.load_dungeon_map("d03f01", "d03f01", 6)
		at = 2
		play_floor_entry_scene(0)
		minigame.set_up_sphida_course_with_draw_distance(0, -1)
		event.add_inventory_item(305, 1)
		do
			local out1, out2, out3 = event.get_sphida_ball_position()
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		event.set_message_window_mode(0, 5)
		event.set_message_selection_top_line(0, 0)
		at = 3
		answer = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
		at = 4
		vm.wait(4)
		if answer == 0 then
			do
				local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
				found_point = out1 or found_point
				spot_x = out2 or spot_x
				spot_y = out3 or spot_y
				spot_z = out4 or spot_z
			end
			if found_point == 0 then
				do
					local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
					spot_x = out1 or spot_x
					spot_y = out2 or spot_y
					spot_z = out3 or spot_z
				end
			end
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			pin_distance = event.get_distance_between(spot_x, spot_y, spot_z, pin_x, pin_y, pin_z) or pin_distance
			if pin_distance < 40.0 then
				random_angle = event.get_random_number(6.2831855) or random_angle
				random_angle = vm.f32(random_angle - vm.f32(3.1415927))
				spot_x = vm.f32(spot_x + vm.f32(vm.sin(random_angle) * 50.0))
				spot_z = vm.f32(spot_z + vm.f32(vm.cos(random_angle) * 50.0))
			else
				do
					local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(spot_x, spot_y, spot_z)
					box_x = out1 or box_x
					box_y = out2 or box_y
					box_z = out3 or box_z
					found_point = out4 or found_point
				end
				attempt = 0
				while found_point >= 0 do
					do
						local out1, out2, out3 = event.copy_vector(spot_x, spot_y, spot_z)
						offset_x = out1 or offset_x
						offset_y = out2 or offset_y
						offset_z = out3 or offset_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(offset_x, offset_y, offset_z, box_x, box_y, box_z)
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
						local out1, out2, out3 = event.scale_vector(offset_x, offset_y, offset_z, 30.1)
						offset_x = out1 or offset_x
						offset_y = out2 or offset_y
						offset_z = out3 or offset_z
					end
					do
						local out1, out2, out3 = event.copy_vector(box_x, box_y, box_z)
						spot_x = out1 or spot_x
						spot_y = out2 or spot_y
						spot_z = out3 or spot_z
					end
					do
						local out1, out2, out3 = event.add_vectors(spot_x, spot_y, spot_z, offset_x, offset_y, offset_z)
						spot_x = out1 or spot_x
						spot_y = out2 or spot_y
						spot_z = out3 or spot_z
					end
					attempt = attempt + 1
					if attempt > 6 then
						break
					end
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(spot_x, spot_y, spot_z)
						box_x = out1 or box_x
						box_y = out2 or box_y
						box_z = out3 or box_z
						found_point = out4 or found_point
					end
				end
			end
			angle = event.get_direction_angle(spot_x, spot_y, spot_z, ball_x, ball_y, ball_z) or angle
			event.set_character_position(0, spot_x, spot_y, spot_z)
			event.set_character_rotation(0, 0.0, angle, 0.0)
			event.set_camera_look_at(spot_x, spot_y + 30.0, spot_z)
			angle = vm.f32(angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			spot_x = vm.f32(vm.f32(vm.sin(angle) * 100.0) + spot_x)
			spot_y = vm.f32(spot_y + 30.0)
			spot_z = vm.f32(vm.f32(vm.cos(angle) * 100.0) + spot_z)
			event.set_camera_position(spot_x, spot_y, spot_z)
			event.reset_follow_camera(0)
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 3 then
				answer = received[1] :: number
			end
			if at <= 1 then
				at = 2
				play_floor_entry_scene(0)
				return vm.continue_with(function()
					minigame.set_up_sphida_course_with_draw_distance(0, -1)
					event.add_inventory_item(305, 1)
					do
						local out1, out2, out3 = event.get_sphida_ball_position()
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					event.set_message_window_mode(0, 5)
					event.set_message_selection_top_line(0, 0)
					at = 3
					answer = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
					at = 4
					vm.wait(4)
					if answer == 0 then
						do
							local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
							found_point = out1 or found_point
							spot_x = out2 or spot_x
							spot_y = out3 or spot_y
							spot_z = out4 or spot_z
						end
						if found_point == 0 then
							do
								local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
								spot_x = out1 or spot_x
								spot_y = out2 or spot_y
								spot_z = out3 or spot_z
							end
						end
						do
							local out1, out2, out3 = event.get_sphida_pin_position()
							pin_x = out1 or pin_x
							pin_y = out2 or pin_y
							pin_z = out3 or pin_z
						end
						pin_distance = event.get_distance_between(spot_x, spot_y, spot_z, pin_x, pin_y, pin_z) or pin_distance
						if pin_distance < 40.0 then
							random_angle = event.get_random_number(6.2831855) or random_angle
							random_angle = vm.f32(random_angle - vm.f32(3.1415927))
							spot_x = vm.f32(spot_x + vm.f32(vm.sin(random_angle) * 50.0))
							spot_z = vm.f32(spot_z + vm.f32(vm.cos(random_angle) * 50.0))
						else
							do
								local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(spot_x, spot_y, spot_z)
								box_x = out1 or box_x
								box_y = out2 or box_y
								box_z = out3 or box_z
								found_point = out4 or found_point
							end
							attempt = 0
							while found_point >= 0 do
								do
									local out1, out2, out3 = event.copy_vector(spot_x, spot_y, spot_z)
									offset_x = out1 or offset_x
									offset_y = out2 or offset_y
									offset_z = out3 or offset_z
								end
								do
									local out1, out2, out3 =
										event.subtract_vectors(offset_x, offset_y, offset_z, box_x, box_y, box_z)
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
									local out1, out2, out3 = event.scale_vector(offset_x, offset_y, offset_z, 30.1)
									offset_x = out1 or offset_x
									offset_y = out2 or offset_y
									offset_z = out3 or offset_z
								end
								do
									local out1, out2, out3 = event.copy_vector(box_x, box_y, box_z)
									spot_x = out1 or spot_x
									spot_y = out2 or spot_y
									spot_z = out3 or spot_z
								end
								do
									local out1, out2, out3 = event.add_vectors(spot_x, spot_y, spot_z, offset_x, offset_y, offset_z)
									spot_x = out1 or spot_x
									spot_y = out2 or spot_y
									spot_z = out3 or spot_z
								end
								attempt = attempt + 1
								if attempt > 6 then
									break
								end
								do
									local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(spot_x, spot_y, spot_z)
									box_x = out1 or box_x
									box_y = out2 or box_y
									box_z = out3 or box_z
									found_point = out4 or found_point
								end
							end
						end
						angle = event.get_direction_angle(spot_x, spot_y, spot_z, ball_x, ball_y, ball_z) or angle
						event.set_character_position(0, spot_x, spot_y, spot_z)
						event.set_character_rotation(0, 0.0, angle, 0.0)
						event.set_camera_look_at(spot_x, spot_y + 30.0, spot_z)
						angle = vm.f32(angle - vm.f32(3.1415927))
						angle = event.wrap_angle(angle) or angle
						spot_x = vm.f32(vm.f32(vm.sin(angle) * 100.0) + spot_x)
						spot_y = vm.f32(spot_y + 30.0)
						spot_z = vm.f32(vm.f32(vm.cos(angle) * 100.0) + spot_z)
						event.set_camera_position(spot_x, spot_y, spot_z)
						event.reset_follow_camera(0)
					end
					return
				end)
			end
			if at <= 2 then
				cutscene.noop_with_arguments(0, -1)
				answer = message.open_choice_skipping(0, 2002, 8, 256, 208, 2, 0)
			end
			random_angle = vm.f32(random_angle - vm.f32(3.1415927))
			spot_x = vm.f32(spot_x + vm.f32(vm.sin(random_angle) * 50.0))
			spot_z = vm.f32(spot_z + vm.f32(vm.cos(random_angle) * 50.0))
			attempt = 0
			attempt = attempt + 1
			angle = vm.f32(angle - vm.f32(3.1415927))
			spot_x = vm.f32(vm.f32(vm.sin(angle) * 100.0) + spot_x)
			spot_y = vm.f32(spot_y + 30.0)
			spot_z = vm.f32(vm.f32(vm.cos(angle) * 100.0) + spot_z)
			return 0
		end
		return nil
	end)
end
script[4000] = script.start_sphida_course

--- Leaves Sphida and plays the thrown entry scene before loading the next story map.
function script.leave_sphida_for_thrown_entry_scene()
	local at: number = 0
	return vm.guard(function()
		at = 1
		minigame.leave_sphida()
		event.load_dungeon_map("d03f01", "d03f01", 6)
		at = 2
		starlight_canyon.play_thrown_entry_scene()
		event.skip_next_music_load()
		event.load_dungeon_map("s46")
		event.load_event_script("s46/s46.stb", 510)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				starlight_canyon.play_thrown_entry_scene()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.load_dungeon_map("s46")
					event.load_event_script("s46/s46.stb", 510)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[13070] = script.leave_sphida_for_thrown_entry_scene

--- Leaves Sphida, clears save flag 308 and loads the s17 scene.
function script.leave_sphida_for_s17_scene_308()
	minigame.leave_sphida()
	event.set_save_flag(308, 0)
	event.load_dungeon_map("s17")
	event.load_event_script("s17/s17.stb", 13080)
end
script[13080] = script.leave_sphida_for_s17_scene_308

--- Leaves Sphida, clears save flag 312 and loads the s17 scene.
function script.leave_sphida_for_s17_scene_312()
	minigame.leave_sphida()
	event.set_save_flag(312, 0)
	event.load_dungeon_map("s17")
	event.load_event_script("s17/s17.stb", 13120)
end
script[13120] = script.leave_sphida_for_s17_scene_312

--- Leaves Sphida, clears save flag 317 and loads the s17 scene.
function script.leave_sphida_for_s17_scene_317()
	minigame.leave_sphida()
	event.set_save_flag(317, 0)
	event.load_dungeon_map("s17")
	event.load_event_script("s17/s17.stb", 13170)
end
script[13170] = script.leave_sphida_for_s17_scene_317

--- Leaves Sphida and loads the s18 scene.
function script.leave_sphida_for_s18_scene_13320()
	minigame.leave_sphida()
	event.load_dungeon_map("s18")
	event.load_event_script("s18/s18.stb", 13320)
end
script[13320] = script.leave_sphida_for_s18_scene_13320

--- Leaves Sphida and loads the s18 scene.
function script.leave_sphida_for_s18_scene_13360()
	minigame.leave_sphida()
	event.load_dungeon_map("s18")
	event.load_event_script("s18/s18.stb", 13360)
end
script[13360] = script.leave_sphida_for_s18_scene_13360

--- Leaves Sphida and loads the s18 scene.
function script.leave_sphida_for_s18_scene_13400()
	minigame.leave_sphida()
	event.load_dungeon_map("s18")
	event.load_event_script("s18/s18.stb", 13400)
end
script[13400] = script.leave_sphida_for_s18_scene_13400

--- Leaves Sphida, clears save flag 348 and loads the s56 scene.
function script.leave_sphida_for_s56_scene_348()
	minigame.leave_sphida()
	event.set_save_flag(348, 0)
	event.load_dungeon_map("s56")
	event.load_event_script("s56/s56.stb", 13480)
end
script[13480] = script.leave_sphida_for_s56_scene_348

--- Leaves Sphida, clears save flag 352 and loads the s56 scene.
function script.leave_sphida_for_s56_scene_352()
	minigame.leave_sphida()
	event.set_save_flag(352, 0)
	event.load_dungeon_map("s56")
	event.load_event_script("s56/s56.stb", 13520)
end
script[13520] = script.leave_sphida_for_s56_scene_352

--- Leaves Sphida, sets the party to early game stats and equipment and loads the s18 scene.
function script.start_s18_scene_with_early_gear()
	local owned_count: s32 = 0
	minigame.leave_sphida()
	event.set_character_max_hp(0, 64)
	event.set_character_max_hp(1, 64)
	event.set_character_defence(0, 16)
	event.set_character_defence(1, 16)
	owned_count = event.get_item_count(270) or owned_count
	if owned_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - owned_count))
	end
	event.add_inventory_item(18)
	event.equip_character_item(0, 18)
	event.add_inventory_item(28)
	event.equip_character_item(0, 28)
	event.add_inventory_item(48)
	event.equip_character_item(1, 48)
	event.add_inventory_item(92)
	event.equip_character_item(1, 92)
	event.load_dungeon_map("s18")
	vm.wait(2)
	event.load_event_script("s18/s18.stb", 23020)
end
script[23020] = script.start_s18_scene_with_early_gear

--- Leaves Sphida and loads the d03b02 boss map.
function script.enter_boss_floor_d03b02()
	minigame.leave_sphida()
	event.load_dungeon_map("d03b02")
	event.load_event_script("d03b02/d03b02.stb", 23030)
end
script[23030] = script.enter_boss_floor_d03b02

--- Leaves Sphida, sets the party to late game stats and equipment and loads the s14 scene.
function script.start_s14_scene_with_late_gear()
	local owned_count: s32 = 0
	minigame.leave_sphida()
	event.set_character_max_hp(0, 160)
	event.set_character_max_hp(1, 160)
	event.set_character_defence(0, 50)
	event.set_character_defence(1, 50)
	owned_count = event.get_item_count(270) or owned_count
	if owned_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - owned_count))
	end
	event.add_inventory_item(16)
	event.equip_character_item(0, 16)
	event.add_inventory_item(27)
	event.equip_character_item(0, 27)
	event.add_inventory_item(71)
	event.equip_character_item(1, 71)
	event.add_inventory_item(100)
	event.equip_character_item(1, 100)
	event.load_dungeon_map("s14")
	vm.wait(2)
	event.load_event_script("s14/s14.stb", 26020)
end
script[26020] = script.start_s14_scene_with_late_gear

return script
