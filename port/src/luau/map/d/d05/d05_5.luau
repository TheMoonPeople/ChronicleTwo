--!strict
--- Floor script for the Gundor dungeon floors that handles floor entry, platform and door puzzles, floor clear, random circles, the geostone and the Sphida golf minigame.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local mount_gundor = require("@lib/event/mount_gundor")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local spheda = require("@lib/event/spanish/spheda")
local sphida_hint = require("@lib/event/spanish/sphida_hint")
local treasure_box = require("@lib/event/spanish/treasure_box")
local wait = require("@lib/event/wait")

--- Plays the cutscene of the player jumping down into a lower floor while the title logo or floor map fades, then announces any seal on the floor.
local function play_floor_entry_jump(uses_floor_map: s32)
	local entry_sound_bank: s32 = 0
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_rotation: f32 = 0
	local floor: s32 = 0
	local previous_floor: s32 = 0
	local seal_flags: s32 = 0
	local block: s32 = 0
	local playable_character: s32 = 0
	local seal_sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		entry_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_035.sound.json") or entry_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			event_point_x = out1 or event_point_x
			event_point_y = out2 or event_point_y
			event_point_z = out3 or event_point_z
			event_point_rotation = out4 or event_point_rotation
		end
		event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_rotation)
		if uses_floor_map == 0 then
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d04_1.json", 0)
			event.set_event_image_texture(0, "logo_d04")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 30)
		else
			floor = event.get_dungeon_floor() or floor
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			event.load_dungeon_map_display(5, 0, 4, floor, previous_floor)
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
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 then
			event.load_character_motion_pack(5, "event/dng_inout/c01d05gkey.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/dng_inout/c02d05gkey.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 45.0, -87.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "飛び降りL", 4, -1.0, 1)
		event.set_object_handle_footstep_sound(0, 2)
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-45.56, 38.54, 130.42)
		event.set_camera_sequence_look_at(18.65, 126.57, -83.69)
		event.move_camera_sequence_eased(-45.56, 38.54, 130.42, -1.01, 52.65, 59.09, 60, 0, 1.0)
		event.enable_drama_skip()
		event.play_sound_effect(entry_sound_bank, 3)
		event.fade_in_screen(30)
		if uses_floor_map == 1 then
			event.set_dungeon_map_piece_moving(1)
		end
		event.jump_object_sequence(0, 0.0, 47.7, 25.39, -0.4, 40)
		event.delay_object_sequence_motion_track(0, 39)
		event.set_object_sequence_motion(0, "着地", 6)
		wait.frames(38)
		event.play_sound_effect(entry_sound_bank, 4)
		object.wait_until_done(0)
		wait.frames(20)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 0.0, 36.89, 60.0, 50)
		wait.frames(10)
		event.show_dungeon_status_bar(1)
		wait.frames(20)
		if uses_floor_map == 1 then
			event.fade_dungeon_map(0, 30)
		else
			event.fade_event_image(0, 0, 30)
		end
		wait.frames(42)
		camera.wait_until_done()
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.fade_in_screen(0)
	event.stop_sound_effect(entry_sound_bank, 3)
	event.stop_sound_effect(entry_sound_bank, 4)
	event.show_dungeon_status_bar(1, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_event_image(0)
	if uses_floor_map == 1 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	end
	event.set_object_handle_position(0, 0.0, 36.89, 60.0)
	event.set_object_handle_motion(0, "立ち")
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_object_handle_footstep_sound(0, -1)
	event.set_camera_look_at(0.0, 66.89, 60.0)
	event.set_camera_position(0.0, 86.89, -40.0)
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.reset_follow_camera(0)
	event.initialize_event()
	if seal_flags ~= 0 then
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(10)
			wait.background_load()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "aka_fuuin", block)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(12)
			wait.background_load()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "ao_fuuin", block)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(14)
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
		seal_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_050.sound.json") or seal_sound_bank
		event.play_sound_effect(seal_sound_bank, 0)
		event.set_message_window_mode(0, 4)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello rojo.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "La Atlamillia roja ha elegido a Max.\n[UNI00a1]No puedes cambiarlo!")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello azul.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "La Atlamillia azul ha elegido a M[UNI00f3]nica.\n[UNI00a1]No puedes cambiarla!")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello blanco.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Ya ni podr[UNI00e1]s restablecer la salud ni curar\nestados an[UNI00f3]malos.")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		event.set_event_sprite_draw_pass(0, 0)
		event.delete_event_image(0)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Plays the cutscene of the player sliding down a rope into an upper floor while the title logo or floor map fades, then announces any seal on the floor.
local function play_floor_entry_rope_descent(uses_floor_map: s32)
	local entry_sound_bank: s32 = 0
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_rotation: f32 = 0
	local floor: s32 = 0
	local previous_floor: s32 = 0
	local seal_flags: s32 = 0
	local block: s32 = 0
	local playable_character: s32 = 0
	local seal_sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		entry_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_036.sound.json") or entry_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			event_point_x = out1 or event_point_x
			event_point_y = out2 or event_point_y
			event_point_z = out3 or event_point_z
			event_point_rotation = out4 or event_point_rotation
		end
		event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_rotation)
		if uses_floor_map == 0 then
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d04_1.json", 0)
			event.set_event_image_texture(0, "logo_d04")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 30)
		else
			floor = event.get_dungeon_floor() or floor
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			event.load_dungeon_map_display(5, 0, 4, floor, previous_floor)
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
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 then
			event.load_character_motion_pack(5, "event/dng_inout/c01d05gkey.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/dng_inout/c02d05gkey.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 120.0, 36.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "ロープぶら下がり", 4, -1.0, 1)
		event.set_object_handle_footstep_sound(0, 2)
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-78.19, 39.86, -34.64)
		event.set_camera_sequence_look_at(0.58, 100.44, 38.06)
		event.move_camera_sequence_eased(-78.19, 39.86, -34.64, 0.58, 20.0, 38.06, 30, 2, 1.0)
		event.play_sound_effect(entry_sound_bank, 1)
		event.fade_in_screen(30)
		event.move_object_sequence(0, 0.0, 20.0, 36.0, 30)
		event.move_object_sequence(0, 0.0, 0.0, 50.0, 10)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "着地", 2)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, entry_sound_bank, 2)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, entry_sound_bank, 3)
		wait.frames(10)
		if uses_floor_map ~= 0 then
			event.set_dungeon_map_piece_moving(1)
		end
		object.wait_until_done(0)
		wait.frames(20)
		event.move_object_sequence(0, 0.0, 0.0, 140.0, 60)
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.set_camera_sequence_position(0.0, 50.0, 40.0)
		event.set_camera_sequence_look_at(0.0, 30.0, 140.0)
		wait.frames(10)
		event.show_dungeon_status_bar(1)
		wait.frames(20)
		if uses_floor_map ~= 0 then
			event.fade_dungeon_map(0, 30)
		else
			event.fade_event_image(0, 0, 30)
		end
		wait.frames(30)
		event.set_object_sequence_motion(0, "立ち")
		wait.frames(12)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(entry_sound_bank, 1)
	event.stop_sound_effect(entry_sound_bank, 2)
	event.stop_sound_effect(entry_sound_bank, 3)
	event.delete_character_extension_packs(0)
	event.delete_event_image(0)
	if uses_floor_map == 1 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	end
	event.show_dungeon_status_bar(1, 1.0)
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 50.0, 40.0)
	event.set_camera_sequence_look_at(0.0, 30.0, 140.0)
	vm.wait(10)
	event.fade_in_screen(0)
	event.set_object_handle_position(0, 0.0, 0.0, 140.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち")
	event.step_object_handle_motion(0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_object_handle_footstep_sound(0, -1)
	event.reset_follow_camera(0)
	event.initialize_event()
	if seal_flags ~= 0 then
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(11)
			wait.background_load()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "aka_fuuin", block)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(13)
			wait.background_load()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "ao_fuuin", block)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			vm.wait(15)
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
		seal_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_050.sound.json") or seal_sound_bank
		event.play_sound_effect(seal_sound_bank, 0)
		event.set_message_window_mode(0, 4)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello rojo.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "La Atlamillia roja ha elegido a Max.\n[UNI00a1]No puedes cambiarlo!")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello azul.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "La Atlamillia azul ha elegido a M[UNI00f3]nica.\n[UNI00a1]No puedes cambiarla!")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello blanco.")
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Ya ni podr[UNI00e1]s restablecer la salud ni curar\nestados an[UNI00f3]malos.")
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		event.set_event_sprite_draw_pass(0, 0)
		event.delete_event_image(0)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Loads the map, monsters, music and entry cutscene for the current floor, or hands over to the connected stage when the floor is a special one.
local function start_floor()
	local stage_id: s32 = 0
	local floor: s32 = 0
	local visit_count: s32 = 0
	local previous_floor: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(0)
		resume_step = 1
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
		visit_count = event.get_dungeon_floor_info(stage_id, floor, 7) or visit_count
		dungeon.increment_floor_counter(stage_id, floor)
		event.initialize_dungeon_floor()
		previous_floor = event.get_dungeon_previous_floor() or previous_floor
		if floor == 0 then
			event.go_to_georama_edit(3, 100)
			resume_step = 2
			vm.wait(2)
		end
		if floor == 8 then
			event.skip_next_music_load()
			event.load_dungeon_map("s16")
			event.load_event_script("s16/s16.stb", 100)
			return
		end
		if floor == 16 then
			event.skip_next_music_load()
			event.load_dungeon_map("s20")
			event.load_event_script("s20/s20.stb", 100)
			return
		end
		if floor == 22 then
			event.skip_next_music_load()
			event.load_dungeon_map("d05b01")
			event.load_event_script("d05b01/d05b01.stb", 100)
			return
		end
		if floor >= 1 and floor < 16 and floor ~= 8 then
			if floor >= 5 and floor <= 7 then
				event.load_dungeon_map("d05f01s", "d05f01")
			else
				event.load_dungeon_map("d05f01", "d05f01")
			end
			event.load_dungeon_monster(0)
			event.place_treasure_box_at_event_point(-1)
			event.place_dungeon_monster(-1)
			if floor == 1 and visit_count <= 0 then
				resume_step = 3
				play_floor_entry_jump(0)
			elseif floor == previous_floor then
				resume_step = 4
				play_floor_entry_jump(0)
			else
				resume_step = 5
				play_floor_entry_jump(1)
			end
		end
		if floor > 16 and floor < 22 then
			if floor == 21 then
				event.allow_next_music_load()
				event.stop_music(0)
				resume_step = 6
				wait.frames(6)
				event.load_music(37)
				event.skip_next_music_load()
			end
			event.load_dungeon_map("d05f02", "d05f01")
			event.load_dungeon_monster(0)
			event.place_treasure_box_at_event_point(-1)
			event.place_dungeon_monster(-1)
			event.play_music(0)
			if floor == previous_floor then
				resume_step = 7
				play_floor_entry_rope_descent(0)
			else
				resume_step = 8
				play_floor_entry_rope_descent(1)
			end
		end
		sound.load_event_sound_effects()
		dungeon.show_floor_title()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				dungeon.increment_floor_counter_skipping(stage_id, floor)
			end
			return 0
		end
		if resume_step <= 8 then
			if resume_step <= 3 then
				resume_step = 4
				play_floor_entry_jump(0)
				return vm.continue_with(function()
					if floor > 16 and floor < 22 then
						if floor == 21 then
							event.allow_next_music_load()
							event.stop_music(0)
							resume_step = 6
							wait.frames(6)
							event.load_music(37)
							event.skip_next_music_load()
						end
						event.load_dungeon_map("d05f02", "d05f01")
						event.load_dungeon_monster(0)
						event.place_treasure_box_at_event_point(-1)
						event.place_dungeon_monster(-1)
						event.play_music(0)
						if floor == previous_floor then
							resume_step = 7
							play_floor_entry_rope_descent(0)
						else
							resume_step = 8
							play_floor_entry_rope_descent(1)
						end
					end
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if resume_step <= 4 then
				resume_step = 5
				play_floor_entry_jump(1)
				return vm.continue_with(function()
					if floor > 16 and floor < 22 then
						if floor == 21 then
							event.allow_next_music_load()
							event.stop_music(0)
							resume_step = 6
							wait.frames(6)
							event.load_music(37)
							event.skip_next_music_load()
						end
						event.load_dungeon_map("d05f02", "d05f01")
						event.load_dungeon_monster(0)
						event.place_treasure_box_at_event_point(-1)
						event.place_dungeon_monster(-1)
						event.play_music(0)
						if floor == previous_floor then
							resume_step = 7
							play_floor_entry_rope_descent(0)
						else
							resume_step = 8
							play_floor_entry_rope_descent(1)
						end
					end
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if resume_step <= 5 then
				wait.frames_skipping(6)
			end
			if resume_step <= 6 then
				resume_step = 7
				play_floor_entry_rope_descent(0)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if resume_step <= 7 then
				resume_step = 8
				play_floor_entry_rope_descent(1)
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

--- Opens the floor selection map, stores the chosen floor and previous floor, and starts that floor.
local function enter_floor_from_map()
	local music_number: s32 = 0
	local previous_floor: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 19 then
		event.stop_music(0)
		wait.frames(6)
		event.load_music(19)
	end
	event.play_music(0)
	event.load_map_sounds(5601)
	event.open_dungeon_floor_map(4)
	vm.wait(2)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		previous_floor = out2 or previous_floor
		floor = out3 or floor
	end
	event.set_dungeon_floor(floor)
	event.set_dungeon_previous_floor(previous_floor)
	start_floor()
end

--- Lets the player use the platform key on a floor link, or ride to the next floor once the platform is raised.
local function operate_gundor_platform(link_index: s32)
	local is_raised: s32 = 0
	local scene_kind: s32 = 0
	local trigger_mode: s32 = 0
	local confirmed: s32 = 0
	local key_item: s32 = 0
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
	event.set_dungeon_pause_flags(1, 1)
	is_raised = event.get_local_event_flag(link_index) or is_raised
	scene_kind = event.get_dungeon_floor() or scene_kind
	if scene_kind >= 1 and scene_kind < 16 and scene_kind ~= 8 then
		scene_kind = 0
	else
		scene_kind = 1
	end
	if is_raised == 0 then
		trigger_mode = event.get_triggered_event_data_2(6) or trigger_mode
		if trigger_mode == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if scene_kind == 0 then
				confirmed = message.ask_confirmation(0, 4, 5, 256, 208, confirmed)
			else
				confirmed = message.ask_confirmation(0, 7, 5, 256, 208, confirmed)
			end
			event.set_message_window_mode(0, 7)
			event.set_message_draw_speed(0, 0)
			if confirmed == 1 then
				trigger_mode = 2
			end
			event.finish_event()
		end
		if trigger_mode == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait.frames(6)
			if scene_kind == 0 then
				key_item = 344
			else
				key_item = 345
			end
			event.open_use_item_menu(key_item)
			vm.wait(4)
			item = vmhost.used_item() or item
			if item == key_item then
				event.set_local_event_flag(link_index, 1)
				mount_gundor.raise_platform(scene_kind)
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
			mount_gundor.play_floor_link_scene(scene_kind)
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
				vm.wait(13)
				event.fade_out_screen(0)
				event.set_event_sprite_draw_pass(0, 0)
			end
			stage_id = event.get_dungeon_stage_id() or stage_id
			floor = event.get_dungeon_floor() or floor
			next_floor = event.get_dungeon_next_floor(floor, link_index) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			event.finish_dungeon_floor()
			enter_floor_from_map()
		else
			event.finish_event()
		end
	end
	event.set_dungeon_pause_flags(1, 0)
end

--- Plays the victory sequence when every monster is defeated, records the clear time and medal reward, announces broken seals and offers the Sphida courses.
local function finish_floor_clear()
	local playable_character: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local save_flag_220: s32 = 0
	local save_flag_317: s32 = 0
	local sub_game_flags: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local is_new_record: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local is_trial_version: s32 = 0
	local seal_flags: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		character.reset_action_motion()
		event.set_dungeon_pause_flags(512, 1)
		event.show_dungeon_status_bar(0, 0.16666667)
		resume_step = 1
		wait.frames(10)
		event.set_dungeon_pause_flags(16384, 1)
		event.clear_event_battle_monsters(-1)
		if playable_character == 0 then
			resume_step = 2
			dungeon.play_max_victory(1)
		end
		if playable_character == 1 then
			resume_step = 3
			dungeon.play_monica_victory(1)
		end
		if playable_character == 2 or playable_character == 3 then
			resume_step = 4
			dungeon.play_finish_banner(playable_character)
		end
		event.set_dungeon_pause_flags(16384, 0)
		mount_gundor.set_door_opened()
		event.reset_action_character_motion(0, 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.show_dungeon_status_bar(1, 0.16666667)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		event.set_dungeon_floor_info(stage_id, floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
		save_flag_317 = event.get_save_flag(220) or save_flag_317
		save_flag_317 = event.get_save_flag(317) or save_flag_317
		sub_game_flags = event.get_floor_sub_games() or sub_game_flags
		if (if save_flag_317 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
		is_new_record = event.record_floor_clear_time() or is_new_record
		do
			local out1, out2 = event.get_floor_practice_result(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		resume_step = 5
		spheda.announce_medal_reward(is_new_record, cleared, bonus)
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
				event.open_message_window_2(0, "Se ha roto el Sello rojo.")
			end
			if bit32.band(seal_flags, 2) ~= 0 then
				event.open_message_window_2(0, "Se ha roto el Sello azul.")
			end
			if bit32.band(seal_flags, 4) ~= 0 then
				event.open_message_window_2(0, "Se ha roto el Sello blanco.")
			end
			resume_step = 6
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		resume_step = 7
		message.show_and_wait(0, 2130, 8, 0, 0)
		if is_trial_version ~= 1 then
			if save_flag_220 == 1 and save_flag_317 == 1 and bit32.band(sub_game_flags, 3) == 3 then
				resume_step = 8
				message.show_and_wait(0, 2120, 8, 0, 0)
				resume_step = 9
				spheda.move_character_to_ball()
			else
				if (if save_flag_220 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
					resume_step = 10
					message.show_and_wait(0, 2110, 8, 0, 0)
				end
				if (if save_flag_317 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
					resume_step = 11
					message.show_and_wait(0, 2100, 8, 0, 0)
					resume_step = 12
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
		if resume_step <= 12 then
			if resume_step <= 1 then
				resume_step = 2
				dungeon.play_max_victory(1)
				return vm.continue_with(function()
					if playable_character == 1 then
						resume_step = 3
						dungeon.play_monica_victory(1)
					end
					if playable_character == 2 or playable_character == 3 then
						resume_step = 4
						dungeon.play_finish_banner(playable_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					mount_gundor.set_door_opened()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					save_flag_317 = event.get_save_flag(220) or save_flag_317
					save_flag_317 = event.get_save_flag(317) or save_flag_317
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if save_flag_317 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					is_new_record = event.record_floor_clear_time() or is_new_record
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					resume_step = 5
					spheda.announce_medal_reward(is_new_record, cleared, bonus)
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
							event.open_message_window_2(0, "Se ha roto el Sello rojo.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello azul.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello blanco.")
						end
						resume_step = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_step = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial_version ~= 1 then
						if save_flag_220 == 1 and save_flag_317 == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_step = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_step = 9
							spheda.move_character_to_ball()
						else
							if (if save_flag_220 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_step = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if save_flag_317 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_step = 11
								message.show_and_wait(0, 2100, 8, 0, 0)
								resume_step = 12
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
			if resume_step <= 2 then
				resume_step = 3
				dungeon.play_monica_victory(1)
				return vm.continue_with(function()
					if playable_character == 2 or playable_character == 3 then
						resume_step = 4
						dungeon.play_finish_banner(playable_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					mount_gundor.set_door_opened()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					save_flag_317 = event.get_save_flag(220) or save_flag_317
					save_flag_317 = event.get_save_flag(317) or save_flag_317
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if save_flag_317 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					is_new_record = event.record_floor_clear_time() or is_new_record
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					resume_step = 5
					spheda.announce_medal_reward(is_new_record, cleared, bonus)
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
							event.open_message_window_2(0, "Se ha roto el Sello rojo.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello azul.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello blanco.")
						end
						resume_step = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_step = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial_version ~= 1 then
						if save_flag_220 == 1 and save_flag_317 == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_step = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_step = 9
							spheda.move_character_to_ball()
						else
							if (if save_flag_220 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_step = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if save_flag_317 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_step = 11
								message.show_and_wait(0, 2100, 8, 0, 0)
								resume_step = 12
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
			if resume_step <= 3 then
				resume_step = 4
				dungeon.play_finish_banner(playable_character)
				return vm.continue_with(function()
					event.set_dungeon_pause_flags(16384, 0)
					mount_gundor.set_door_opened()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					save_flag_317 = event.get_save_flag(220) or save_flag_317
					save_flag_317 = event.get_save_flag(317) or save_flag_317
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if save_flag_317 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					is_new_record = event.record_floor_clear_time() or is_new_record
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					resume_step = 5
					spheda.announce_medal_reward(is_new_record, cleared, bonus)
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
							event.open_message_window_2(0, "Se ha roto el Sello rojo.")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello azul.")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello blanco.")
						end
						resume_step = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_step = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial_version ~= 1 then
						if save_flag_220 == 1 and save_flag_317 == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_step = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_step = 9
							spheda.move_character_to_ball()
						else
							if (if save_flag_220 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_step = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if save_flag_317 == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_step = 11
								message.show_and_wait(0, 2100, 8, 0, 0)
								resume_step = 12
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
			if resume_step <= 4 then
				mount_gundor.noop()
				cutscene.noop_with_arguments(0, -1)
				message.resume_numbered_messages(is_new_record, cleared, bonus)
			end
			if resume_step <= 5 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if resume_step <= 6 then
				message.show_and_wait_skipping(0, 2130, 8, 0, 0)
			end
			if resume_step <= 7 then
				message.show_and_wait_skipping(0, 2120, 8, 0, 0)
			end
			if resume_step <= 8 then
				message.open_choice_pair_skipping()
			end
			if resume_step <= 9 then
				message.show_and_wait_skipping(0, 2110, 8, 0, 0)
			end
			if resume_step <= 10 then
				message.show_and_wait_skipping(0, 2100, 8, 0, 0)
			end
			if resume_step <= 11 then
				message.open_choice_pair_skipping()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Gives the player the starting items, sets two save flags and clears battle monsters.
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

--- Operates the floor link platform with index 0.
function script.operate_platform_0()
	operate_gundor_platform(0)
end
script[300] = script.operate_platform_0

--- Operates the floor link platform with index 1 when the edit analysis found changes.
function script.edit_analyze_changed()
	operate_gundor_platform(1)
end

--- Operates the floor link platform with index 2.
function script.operate_platform_2()
	operate_gundor_platform(2)
end
script[320] = script.operate_platform_2

--- Operates the floor link platform with index 3.
function script.operate_platform_3()
	operate_gundor_platform(3)
end
script[330] = script.operate_platform_3

--- Event 340, which map data, a script or the engine runs by number.
script[340] = mount_gundor.use_star_key_door

--- Lets the player open the floor door with the matching key item, or opens it directly when the party partner is present.
function script.unlock_gundor_door()
	local key_item: s32 = 0
	local scene_kind: s32 = 0
	local party_npc_id: s32 = 0
	local trigger_mode: s32 = 0
	local confirmed: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 1)
	character.reset_action_motion()
	scene_kind = event.get_dungeon_floor() or scene_kind
	if scene_kind >= 1 and scene_kind < 16 and scene_kind ~= 8 then
		scene_kind = 0
		key_item = 346
	else
		scene_kind = 1
		key_item = 347
	end
	party_npc_id = event.get_party_npc() or party_npc_id
	if party_npc_id == 4 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "S[UNI00f3]lo tienes que pasar por aqu[UNI00ed], [UNI00bf]entendido?")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.show_dungeon_status_bar(0, 0.16666667)
		mount_gundor.play_door_opening(scene_kind)
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
		if scene_kind == 0 then
			confirmed = message.ask_confirmation(0, 2504, 5, 256, 208, confirmed)
		else
			confirmed = message.ask_confirmation(0, 2507, 5, 256, 208, confirmed)
		end
		event.set_message_bubble_tail(0, 1)
		event.set_message_draw_speed(0, 0)
		if confirmed == 1 then
			trigger_mode = 2
		end
	end
	if trigger_mode == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait.frames(6)
		event.open_use_item_menu(key_item)
		vm.wait(7)
		item = vmhost.used_item() or item
		if item == key_item then
			mount_gundor.play_door_opening(scene_kind)
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
script[348] = script.unlock_gundor_door

script.enter_floor_from_map = enter_floor_from_map
script[1000] = script.enter_floor_from_map

script.start_floor = start_floor
script[1010] = script.start_floor

--- The dungeon system event run when the player opens a treasure box.
script.treasure_box = treasure_box.open_nearest

--- Spins a coin over the random circle until the player stops it, then applies a good or bad circle effect depending on the side it lands on.
function script.random_circle()
	local playable_character: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local yaw: f32 = 0
	local ring_x: f32 = 0
	local ring_y: f32 = 0
	local ring_z: f32 = 0
	local circle_sound_bank: s32 = 0
	local motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local party_npc_id: s32 = 0
	local circle_id: s32 = 0
	local step_count: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local camera_facing_angle: f32 = 0
	local extra_spin_steps: s32 = 0
	local target_angle: f32 = 0
	local outcome_roll: s32 = 0
	local outcome_threshold: s32 = 0
	local brightness_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_amount: f32 = 0
	local restore_camera_x: f32 = 0
	local restore_camera_y: f32 = 0
	local restore_camera_z: f32 = 0
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
			circle_x = out1 or circle_x
			circle_y = out2 or circle_y
			circle_z = out3 or circle_z
		end
		yaw = event.get_direction_angle(circle_x, circle_y, circle_z, character_x, character_y, character_z) or yaw
		character_x = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + circle_x)
		character_y = circle_y
		character_z = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + circle_z)
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
	circle_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or circle_sound_bank
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
	step_count = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		if step_count == 10 then
			event.play_sound_effect(circle_sound_bank, 0)
		end
		if step_count == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if step_count >= 30 then wait.get_button_state(0) else 0) ~= 0 or step_count > 300 then
			event.stop_sound_effect(circle_sound_bank, 0)
			event.play_sound_effect(circle_sound_bank, 3)
			vm.wait(7)
			break
		else
			step_count = step_count + 1
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
	camera_facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_facing_angle
	extra_spin_steps = 0
	extra_spin_steps = event.get_random_number_int(10) or extra_spin_steps
	extra_spin_steps = vm.i32(extra_spin_steps + 4)
	step_count = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		vm.wait(9)
		if step_count >= extra_spin_steps then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			target_angle = camera_facing_angle
			target_angle = event.wrap_angle(target_angle) or target_angle
			if coin_angle < target_angle and calc.is_angle_within(coin_angle, target_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, target_angle, 0.0)
				circle_id = 0
				break
			end
			target_angle = vm.f32(camera_facing_angle - vm.f32(3.1415927))
			target_angle = event.wrap_angle(target_angle) or target_angle
			if coin_angle < target_angle and calc.is_angle_within(coin_angle, target_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, target_angle, 0.0)
				circle_id = 1
				break
			end
		end
		step_count = vm.i32(step_count + 1)
	end
	camera_facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, camera_facing_angle, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	camera_facing_angle = coin_angle
	wait.frames(20)
	outcome_roll = event.get_random_number_int(10) or outcome_roll
	if party_npc_id == 24 then
		outcome_threshold = 100
	else
		outcome_threshold = 6
	end
	if outcome_roll < outcome_threshold then
		outcome_roll = event.get_random_number_int(10) or outcome_roll
		if circle_id == 0 then
			if party_npc_id == 24 then
				outcome_threshold = 0
			else
				outcome_threshold = 2
			end
		elseif party_npc_id == 24 then
			outcome_threshold = 100
		else
			outcome_threshold = 4
		end
		if outcome_roll < outcome_threshold then
			camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(3.14))
			camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
			event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 8)
			if circle_id == 0 then
				circle_id = 1
			else
				circle_id = 0
			end
			wait.frames(10)
		else
			outcome_roll = event.get_random_number_int(10) or outcome_roll
			if outcome_roll < 1 then
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(3.14))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 6)
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(1.57))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 3)
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(1.57))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	camera_facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_facing_angle
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
	brightness_rate = 1.0
	step_count = 0
	effect_id = event.get_random_circle_effect(circle_id) or effect_id
	if circle_id == 0 then
		event.play_sound_effect(circle_sound_bank, 1)
		while step_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate + vm.f32(0.03))
			step_count = step_count + 1
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
			event.place_treasure_box(ring_x, ring_y, ring_z, camera_facing_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(circle_sound_bank, 2)
		while step_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate - vm.f32(0.03))
			step_count = step_count + 1
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
		event.spawn_pull_items(ring_x, ring_y, ring_z, 1, 10, effect_amount / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
	do
		local out1, out2, out3 = event.get_previous_camera_next_position()
		restore_camera_x = out1 or restore_camera_x
		restore_camera_y = out2 or restore_camera_y
		restore_camera_z = out3 or restore_camera_z
	end
	event.set_camera_position(restore_camera_x, restore_camera_y, restore_camera_z)
	do
		local out1, out2, out3 = event.get_previous_camera_next_look_at()
		restore_camera_x = out1 or restore_camera_x
		restore_camera_y = out2 or restore_camera_y
		restore_camera_z = out3 or restore_camera_z
	end
	event.set_camera_look_at(restore_camera_x, restore_camera_y, restore_camera_z)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the cutscene of the character picking up and activating the geostone and marks the floor as having used it.
function script.geostone()
	local playable_character: s32 = 0
	local original_x: f32 = 0
	local original_y: f32 = 0
	local original_z: f32 = 0
	local sound_bank: s32 = 0
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
	local system_sound_id: s32 = 0
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
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_bank
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
	event.play_sound_effect(sound_bank, 0)
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
	event.play_sound_effect(sound_bank, 1)
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

--- Plays the party defeat sequence without a voice line.
function script.play_party_defeat()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.play_party_defeat

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = finish_floor_clear

--- Shows the one-time guide message about random stones and sets its save flag.
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

--- Shows a guide message and waits for the player to dismiss it.
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

--- Shows the first level-up guide messages.
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

--- Shows the controls for driving the ridepod buggy.
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

--- Explains how the Magic-Absorb Blade works.
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

--- Runs a Sphida shot from aiming and the power gauge through the ball physics to the result, which is a hole-in, a miss or a ball left on the course.
function script.sphida_shot()
	local tex_bank: s32 = 0
	local sound_bank: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local rotation_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local loft_angle: f32 = 0
	local shot_power_or_water_flag: f32 = 0
	local club_spin_factor: f32 = 0
	local level: s32 = 0
	local side_velocity_x: f32 = 0
	local curve_amount: f32 = 0
	local side_velocity_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local is_cup_in: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local miss_counter: s32 = 0
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
	local step_count: s32 = 0
	local pin_distance: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local pin_path_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local yaw: f32 = 0
	local par: s32 = 0
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
	sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_bank
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
	loft_angle = 12.5
	event.set_sphida_carry_angle(vm.f32(loft_angle * vm.f32(3.1415927)) / 180.0)
	shot_power_or_water_flag, club_spin_factor, level = minigame.get_equipped_club_definition(shot_power_or_water_flag, club_spin_factor, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		side_velocity_x = out1 or side_velocity_x
		curve_amount = out2 or curve_amount
		side_velocity_z = out3 or side_velocity_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_angle, loft_angle = minigame.aim_sphida_shot(aim_angle, loft_angle, tex_bank)
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
		t1, shot_power_or_water_flag, aim_angle, curve_amount, side_velocity_x, level = minigame.run_sphida_power_gauge(shot_power_or_water_flag, tex_bank, aim_angle, curve_amount, side_velocity_x, sound_bank, level)
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
	if shot_power_or_water_flag <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.frames(25)
		if level ~= 4 then
			event.play_sound_effect(sound_bank, 3)
		end
	elseif shot_power_or_water_flag <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.frames(34)
		event.play_sound_effect(sound_bank, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.frames(39)
		if level == 0 then
			event.play_sound_effect(sound_bank, 12)
		else
			event.play_sound_effect(sound_bank, 1)
		end
	end
	if level == 4 then
		wait.frames(50)
		minigame.consume_sphida_shot(sound_bank)
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
	shot_power_or_water_flag = minigame.scale_by_club_power(shot_power_or_water_flag)
	loft_angle = vm.f32(vm.f32(loft_angle * vm.f32(3.1415927)) / 180.0)
	shot_power_or_water_flag = vm.f32(shot_power_or_water_flag - vm.f32(shot_power_or_water_flag * loft_angle))
	velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(shot_power_or_water_flag * vm.cos(loft_angle)))
	velocity_y = vm.f32(shot_power_or_water_flag * vm.sin(loft_angle))
	velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(shot_power_or_water_flag * vm.cos(loft_angle)))
	curve_amount = vm.f32(vm.f32(curve_amount * vm.f32(3.1415927)) / 2.0)
	side_velocity_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_spin_factor) * side_velocity_x) * vm.f32(0.4))
	side_velocity_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_spin_factor) * side_velocity_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	miss_counter = 0
	level = 0
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
		shot_power_or_water_flag = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		shot_power_or_water_flag = 0.0
	end
	step_count = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (step_count + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_index = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_index
			if level == 1 and collision_index >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (step_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + side_velocity_x)
				velocity_z = vm.f32(velocity_z + side_velocity_z)
				side_velocity_x = vm.f32(side_velocity_x * vm.f32(0.8))
				side_velocity_z = vm.f32(side_velocity_z * vm.f32(0.8))
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
		if curve_amount ~= 0.0 then
			loft_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or loft_angle
			loft_angle = vm.f32(loft_angle + curve_amount)
			loft_angle = event.wrap_angle(loft_angle) or loft_angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(loft_angle) / 10.0) * club_spin_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(loft_angle) / 10.0) * club_spin_factor))
		end
		length = event.get_vector_length(side_velocity_x, 0.0, side_velocity_z) or length
		if length > vm.f32(0.01) then
			speed = event.get_vector_length(side_velocity_x, 0.0, side_velocity_z) or speed
			loft_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + side_velocity_x, previous_y, previous_z + side_velocity_z) or loft_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, loft_angle, rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, loft_angle, rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			loft_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or loft_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_angle = out2 or aim_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, loft_angle, rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, loft_angle, rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		remaining_distance = speed
		loft_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or loft_angle
		probe_x = vm.f32(vm.sin(vm.f32(loft_angle - vm.f32(1.5707964))) * 3.0)
		probe_z = vm.f32(vm.cos(vm.f32(loft_angle - vm.f32(1.5707964))) * 3.0)
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
				event.play_sound_effect(sound_bank, 11)
				sound_cooldown = 10
			end
			if shot_power_or_water_flag == 0.0 then
				shot_power_or_water_flag = 1.0
				velocity_x = vm.f32(velocity_x * vm.f32(0.4))
				velocity_y = vm.f32(velocity_y * vm.f32(0.4))
				velocity_z = vm.f32(velocity_z * vm.f32(0.4))
				side_velocity_x = 0.0
				side_velocity_z = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				shot_power_or_water_flag = 0.0
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
			curve_amount = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if shot_power_or_water_flag ~= 1.0 and sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 6)
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
				if shot_power_or_water_flag == 0.0 then
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
			curve_amount = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			length = event.get_vector_length(velocity_x, 0.0, velocity_z) or length
			if length < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				level = 1
			else
				if shot_power_or_water_flag == 0.0 then
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
				if shot_power_or_water_flag ~= 1.0 and sound_cooldown <= 0 then
					event.play_sound_effect(sound_bank, 5)
					sound_cooldown = 10
				end
			end
			length = event.get_vector_length(side_velocity_x, 0.0, side_velocity_z) or length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and length < vm.f32(0.4) then
				if surface_type == 6 then
					miss_counter = 1
					break
				end
				surface_type = event.get_automap_attribute_status(ball_x, ball_y, ball_z) or surface_type
				if not (surface_type == 1) then
					break
				end
				miss_counter = 1
				break
			end
		end
		if ball_y < -500.0 then
			miss_counter = 1
			break
		elseif step_count >= 480 then
			miss_counter = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			x = vm.f32(pin_x - ball_x)
			y = vm.f32(pin_y - ball_y)
			z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(x, y, z) or pin_distance
			if ball_color ~= pin_color then
				pin_path_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or pin_path_distance
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
				if miss_counter >= 30 then
					if miss_counter >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				miss_counter = miss_counter + 1
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
			step_count = step_count + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if miss_counter == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		par = event.get_sphida_par() or par
		if is_cup_in == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_bank, 17)
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
			collision_index = event.get_dungeon_floor_info(pin_color, ball_color, 4) or collision_index
			do
				local out1, out2 = event.get_sphida_prize(collision_index)
				sound_cooldown = out1 or sound_cooldown
				surface_type = out2 or surface_type
			end
			collision_index = vm.i32(collision_index + 1)
			event.set_dungeon_floor_info(pin_color, ball_color, 4, collision_index)
			event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, loft_angle, sound_cooldown, surface_type)
			wait.frames(54)
			wait.frames(30)
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
		elseif par >= 2 then
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
					loft_angle = event.get_random_number(6.2831855) or loft_angle
					loft_angle = vm.f32(loft_angle - vm.f32(3.1415927))
					start_x = vm.f32(start_x + vm.f32(vm.sin(loft_angle) * 50.0))
					start_z = vm.f32(start_z + vm.f32(vm.cos(loft_angle) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(start_x, start_y, start_z)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						collision_index = out4 or collision_index
					end
					step_count = 0
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
						step_count = step_count + 1
						if step_count > 6 then
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
		minigame.consume_sphida_shot(sound_bank)
	end
	minigame.finish_sphida_round(is_cup_in)
end

--- Offers to move the ball to the player when the menu button is pressed near it.
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

--- Warns that this is the last time the ball can be moved to the player and offers to do so.
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

--- Leaves the Sphida course and continues event 15120 on map s20.
function script.leave_sphida_to_s20_15120()
	minigame.leave_sphida()
	event.load_dungeon_map("s20")
	event.load_event_script("s20/s20.stb", 15120)
end
script[15120] = script.leave_sphida_to_s20_15120

--- Leaves the Sphida course and continues event 15160 on map s20.
function script.leave_sphida_to_s20_15160()
	minigame.leave_sphida()
	event.load_dungeon_map("s20")
	event.load_event_script("s20/s20.stb", 15160)
end
script[15160] = script.leave_sphida_to_s20_15160

--- Leaves the Sphida course and continues event 15200 on map s20.
function script.leave_sphida_to_s20_15200()
	minigame.leave_sphida()
	event.load_dungeon_map("s20")
	event.load_event_script("s20/s20.stb", 15200)
end
script[15200] = script.leave_sphida_to_s20_15200

--- Leaves the Sphida course and continues event 15260 on the d05b01 boss map.
function script.leave_sphida_to_boss_15260()
	minigame.leave_sphida()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 15260)
end
script[15260] = script.leave_sphida_to_boss_15260

--- Leaves the Sphida course and continues event 15280 on the d05b01 boss map.
function script.leave_sphida_to_boss_15280()
	minigame.leave_sphida()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 15280)
end
script[15280] = script.leave_sphida_to_boss_15280

--- Leaves the Sphida course and continues event 15320 on the d05b01 boss map.
function script.leave_sphida_to_boss_15320()
	minigame.leave_sphida()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 15320)
end
script[15320] = script.leave_sphida_to_boss_15320

--- Leaves the Sphida course and continues event 15360 on the d05b01 boss map.
function script.leave_sphida_to_boss_15360()
	minigame.leave_sphida()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 15360)
end
script[15360] = script.leave_sphida_to_boss_15360

return script
