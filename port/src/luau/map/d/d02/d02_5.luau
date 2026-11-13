--!strict
--- Floor script for the Rainbow Butterfly Wood dungeon covering floor loading, gates, seals, the random circle, the geostone, guide messages and the Sphida golf mini-game.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local rainbow_butterfly_wood = require("@lib/event/rainbow_butterfly_wood")
local sound = require("@lib/event/sound")
local spheda = require("@lib/event/spanish/spheda")
local sphida_hint = require("@lib/event/spanish/sphida_hint")
local treasure_box = require("@lib/event/spanish/treasure_box")
local wait = require("@lib/event/wait")

--- Plays the walk-in cutscene on arriving at a floor and announces any seals placed on it.
local function play_floor_entry(show_map: s32)
	local sound_bank: s32 = 0
	local entry_x: f32 = 0
	local entry_y: f32 = 0
	local entry_z: f32 = 0
	local entry_angle: f32 = 0
	local floor_status: s32 = 0
	local image_block: s32 = 0
	local floor: s32 = 0
	local previous_floor: s32 = 0
	local playable_character: s32 = 0
	local camera_angle: f32 = 0
	local seal_sound_bank: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_031.sound.json") or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			entry_x = out1 or entry_x
			entry_y = out2 or entry_y
			entry_z = out3 or entry_z
			entry_angle = out4 or entry_angle
		end
		entry_angle = vm.f32(entry_angle + vm.f32(1.5707964))
		entry_angle = event.wrap_angle(entry_angle) or entry_angle
		event.set_event_world_coordinate(entry_x, entry_y, entry_z, entry_angle)
		floor_status = event.get_dungeon_floor_status() or floor_status
		if floor_status ~= 0 then
			if bit32.band(floor_status, 1) ~= 0 then
				event.switch_dungeon_main_character(1)
			end
			if bit32.band(floor_status, 2) ~= 0 then
				event.switch_dungeon_main_character(0)
			end
		end
		if show_map ~= 0 then
			floor = event.get_dungeon_floor() or floor
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			event.load_dungeon_map_display(5, 0, 1, floor, previous_floor)
			event.fade_dungeon_map(1, 30)
		else
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d01_1.json", 0)
			event.set_event_image_texture(0, "logo_d01")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 60)
		end
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 then
			event.load_character_motion_pack(5, "dungeon/chara/mints_01in.gltf", "info", 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "dungeon/chara/monica_01in.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 116.96, 18.76, 19.22)
		event.set_object_sequence_rotation(0, 0.0, -1.96, 0.0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 3)
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(173.18, 55.5, 1.04)
		event.set_camera_sequence_look_at(50.97, 32.07, 20.9)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		if playable_character == 0 then
			event.move_camera_sequence_eased(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 160, 2, 0.4)
			event.move_object_sequence(0, 23.61, 18.53, -17.13, 140)
			event.set_object_sequence_motion(0, "丸太歩き", 4)
			event.delay_object_sequence_rotation_track(0, 130)
			event.rotate_object_sequence(0, 0.0, -1.0, 0.0, 10)
			if show_map ~= 0 then
				resume_step = 2
				wait.frames(30)
				event.set_dungeon_map_piece_moving(1)
			end
			resume_step = 3
			object.wait_until_done(0)
			event.set_object_sequence_motion(0, "ジャンプ", 2)
			event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.3)
			event.queue_object_sequence_next_motion(0, "着地", 6)
		else
			event.move_camera_sequence_eased(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 100, 2, 0.4)
			event.move_object_sequence(0, 23.61, 18.53, -17.13, 60)
			event.set_object_sequence_motion(0, "丸太歩き", 4)
			event.delay_object_sequence_rotation_track(0, 50)
			event.rotate_object_sequence(0, 0.0, -1.0, 0.0, 10)
			if show_map ~= 0 then
				resume_step = 4
				wait.frames(30)
				event.set_dungeon_map_piece_moving(1)
			end
			resume_step = 5
			object.wait_until_done(0)
			event.set_object_sequence_motion(0, "ジャンプ", 2)
			event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.2)
			event.queue_object_sequence_next_motion(0, "着地", 6)
		end
		event.set_object_handle_footstep_sound(0, 16)
		resume_step = 6
		wait.frames(14)
		event.play_sound_effect(sound_bank, 2)
		event.jump_object_sequence(0, -85.0, 0.0, 50.0, -0.25, 30)
		event.delay_object_sequence_rotation_track(0, 10)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 20)
		resume_step = 7
		wait.frames(16)
		if show_map ~= 0 then
			event.fade_dungeon_map(0, 60)
		else
			event.fade_event_image(0, 0, 60)
		end
		resume_step = 8
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 4)
		resume_step = 9
		wait.frames(30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -170.0, 0.0, 50.0, 50)
		resume_step = 10
		camera.wait_until_done()
		event.start_crossfade(30)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			camera_angle = out2 or camera_angle
		end
		event.set_camera_sequence_look_at(-170.0, 30.0, 50.0)
		camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
		camera_angle = event.wrap_angle(camera_angle) or camera_angle
		event.set_camera_sequence_angle_height_distance(camera_angle, 5.0, 100.0)
		event.show_dungeon_status_bar(1)
		resume_step = 11
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		resume_step = 12
		wait.frames(15)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			entry_angle = vm.f32(entry_angle + vm.f32(1.5707964))
			wait.frames_skipping(30)
		end
		if resume_step <= 2 then
			cutscene.skip_command(0)
		end
		if resume_step <= 3 then
			wait.frames_skipping(30)
		end
		if resume_step <= 4 then
			cutscene.skip_command(0)
		end
		if resume_step <= 5 then
			wait.frames_skipping(14)
		end
		if resume_step <= 6 then
			wait.frames_skipping(16)
		end
		if resume_step <= 7 then
			cutscene.skip_command(0)
		end
		if resume_step <= 8 then
			wait.frames_skipping(30)
		end
		if resume_step <= 9 then
			wait.background_load_skipping()
		end
		if resume_step <= 10 then
			camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
			cutscene.skip_command(0)
		end
		if resume_step <= 11 then
			wait.frames_skipping(15)
		end
		return true
	end)
	resume_step = 13
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.fade_in_screen(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_motion(0, "立ち")
	event.set_object_handle_position(0, -170.0, 0.0, 50.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(-170.0, 30.0, 50.0)
	event.set_camera_position(-70.0, 35.0, 50.0)
	event.reset_follow_camera(0)
	event.delete_character_extension_packs(0)
	if show_map ~= 0 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	end
	event.delete_event_image(0)
	event.initialize_event()
	if floor_status ~= 0 then
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if bit32.band(floor_status, 1) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			resume_step = 14
			vm.wait(14)
			resume_step = 15
			wait.background_load()
			image_block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or image_block
			event.set_event_sprite_texture(0, "aka_fuuin", image_block)
		end
		if bit32.band(floor_status, 2) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			resume_step = 16
			vm.wait(16)
			resume_step = 17
			wait.background_load()
			image_block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or image_block
			event.set_event_sprite_texture(0, "ao_fuuin", image_block)
		end
		if bit32.band(floor_status, 4) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			resume_step = 18
			vm.wait(18)
			resume_step = 19
			wait.background_load()
			image_block = event.load_event_image_4(5, "textures/dungeon/image/seal/shiro_fuuin_1.json", 0) or image_block
			event.set_event_sprite_texture(0, "shiro_fuuin", image_block)
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
		if bit32.band(floor_status, 1) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello rojo.")
			resume_step = 20
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "La Atlamillia roja ha elegido a Max.\n[UNI00a1]No puedes cambiarlo!")
			resume_step = 21
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(floor_status, 2) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello azul.")
			resume_step = 22
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "La Atlamillia azul ha elegido a M[UNI00f3]nica.\n[UNI00a1]No puedes cambiarla!")
			resume_step = 23
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(floor_status, 4) ~= 0 then
			event.open_message_window_2(0, "En este suelo parece que hay un Sello blanco.")
			resume_step = 24
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Ya ni podr[UNI00e1]s restablecer la salud ni curar\nestados an[UNI00f3]malos.")
			resume_step = 25
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		event.set_event_sprite_draw_pass(0, 0)
		event.delete_event_image(0)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Plays the scene in which Monica gives Max crystals and Synthesis Points and explains how to upgrade the Wrench.
local function play_monica_crystal_gift()
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	local playable_character: s32 = 0
	local image_block: s32 = 0
	local player_object_handle: s32 = 0
	vm.section(function()
		event.set_save_flag(212, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			event_x = out1 or event_x
			event_y = out2 or event_y
			event_z = out3 or event_z
			event_angle = out4 or event_angle
		end
		event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
		event.set_dungeon_pause_flags(17, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(48)
		event.play_music(0)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e200/e212/")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e212_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e212_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e212_crystal.gltf", "info", 11)
		event.set_character_active(0, 11)
		image_block = event.load_event_image_4(5, "e212_1.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e21201", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 0)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e21202", image_block)
		event.set_event_sprite_color(1, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 0)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_equipment_model(5, 0, 0, "info", 8, 10)
			event.load_character_motion_pack(5, "event/e200/e212/e212_mints.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e200/e212/e212_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(0, 10)
		if playable_character == 0 then
			event.attach_character_to_frame(8, "item", 11)
		else
			event.attach_character_to_frame(0, "item", 11)
		end
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_position(0, 67.73, 0.0, 94.65)
		event.set_object_handle_rotation(0, 0.0, -2.74, 0.0)
		event.call_command(706, 0, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 49.9, 0.0, 78.02)
		event.set_object_handle_rotation(1, 0.0, 0.86, 0.0)
		event.call_command(706, 1, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(67.03, 24.86, 49.63)
		event.set_camera_sequence_look_at(59.75, 21.85, 81.53)
		event.fade_in_screen(30)
		wait.frames(30)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(
			0,
			"No lo s[UNI00e9], Max. Si eso es todo lo que\ntienes para defenderte, te va a resultar\ndif[UNI00ed]cil enfrentarte a los monstruos del bosque."
		)
		message.show_and_wait(0, -1, 8, 512, 0)
		object.wait_until_done(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "[UNI00bf]Eso crees?")
		message.show_and_wait(0, -1, 8, 0, 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "Claro que s[UNI00ed].")
		message.show_and_wait(0, -1, 8, 512, 0)
		event.set_character_active(1, 11)
		event.set_character_visible(11, 1, 1, 0.1)
		event.set_object_sequence_motion(1, "渡す", 6)
		event.queue_object_sequence_next_motion(1, "渡すL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Toma. C[UNI00f3]gelos.")
		message.show_and_wait(0, -1, 8, 512, 0)
		object.wait_until_done(1)
		event.set_camera_sequence_position(56.78, 23.01, 68.1)
		event.set_camera_sequence_look_at(67.82, 21.85, 95.09)
		event.detach_character_from_frame(11)
		if playable_character == 0 then
			event.attach_character_to_frame(0, "item", 11)
		else
			event.attach_character_to_frame(8, "item", 11)
		end
		event.set_object_sequence_motion(0, "クリスタルゲット", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "半口")
		event.open_message_window_2(0, "[UNI00a1]Qu[UNI00e9] son?")
		message.show_and_wait(0, -1, 8, 256, 0)
		event.set_object_sequence_motion(0, "モニカ見る", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見るL", 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"Has recibido 2 Cristales de cazador,\n2 Cristales destructivos,<page>,1 Cristal de viento\ny 1 Cristal drag[UNI00f3]n marino."
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(0, 0, "半口")
		event.set_camera_sequence_position(97.82, 22.3, 89.1)
		event.set_camera_sequence_look_at(34.74, 20.28, 87.84)
		event.set_message_window_mode(0, 1)
		event.set_object_sequence_rotation(0, 0.0, -2.38, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "[UNI00a1]Guau! [UNI00bf]Todos estos?")
		message.show_and_wait(0, -1, 8, 80, 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Jua. Con esos puedes mejorar la Llave\na base de bien.")
		message.show_and_wait(0, -1, 8, 384, 0)
		event.set_camera_sequence_position(84.11, 24.45, 108.87)
		event.set_camera_sequence_look_at(53.38, 24.14, 80.91)
		event.set_character_active(0, 11)
		if playable_character == 0 then
			event.set_character_active(0, 0)
		else
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
		end
		event.set_dungeon_pause_flags(128, 1)
		event.start_crossfade(10)
		event.set_event_sprite_draw_pass(0, 2)
		event.set_object_sequence_motion(1, "指立て", 6)
		event.queue_object_sequence_next_motion(1, "指立て会話", 6)
		event.queue_object_sequence_next_motion(1, "指立てL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Elige un cristal en\nel men[UNI00fa] Objetos y luego diversif[UNI00ed]calo.")
		message.show_and_wait(0, -1, 8, 256, 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Sintet[UNI00ed]zala con\nel arma que quieras mejorar.")
		message.show_and_wait(0, -1, 8, 256, 0)
		object.wait_until_done(1)
		event.start_crossfade(30)
		event.set_event_sprite_draw_pass(1, 2)
		event.set_object_sequence_motion(1, "戻り", 6)
		event.queue_object_sequence_next_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(
			0,
			"Luego, cuando sus caracter[UNI00ed]sticas alcancen\nla siguiente categor[UNI00ed]a, podr[UNI00e1]s usar la opci[UNI00f3]n Mejorar."
		)
		message.show_and_wait(0, -1, 8, 256, 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "[UNI00a1]Eso convertir[UNI00e1] tu Llave\nen una potente arma!")
		message.show_and_wait(0, -1, 8, 256, 0)
		object.wait_until_done(1)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_dungeon_pause_flags(128, 0)
		event.start_crossfade(10)
		event.set_camera_sequence_position(91.98, 18.44, 61.76)
		event.set_camera_sequence_look_at(51.13, 20.11, 92.81)
		if playable_character == 0 then
			event.set_character_active(0)
			event.set_object_handle_visible(2, 1)
		else
			event.set_character_active(8)
			event.set_character_active(9)
			event.set_character_active(10)
		end
		event.set_object_sequence_motion(0, "武器持ち立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "Suena bien.")
		message.show_and_wait(0, -1, 8, 0, 0)
		event.set_object_sequence_motion(1, "カチャカチャ", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "[UNI00a1]Pru[UNI00e9]balo! Y aqu[UNI00ed] tienes\nalgo m[UNI00e1]s de mi parte. [heart].")
		message.show_and_wait(0, -1, 8, 512, 0)
		object.wait_until_done(1)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(0, "La Llave ha conseguido 6 Puntos de S[UNI00ed]ntesis m[UNI00e1]s.")
		message.show_and_wait(0, -1, 8, 0, 0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(25)
	event.cancel_drama_scene_skip()
	event.set_dungeon_pause_flags(145, 0)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(2, 1)
	event.set_character_active(0)
	event.detach_character_from_frame(11)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_event_image(0)
	if playable_character == 0 then
		player_object_handle = 0
	else
		player_object_handle = 1
	end
	event.set_object_handle_motion(player_object_handle, "立ち")
	event.set_object_handle_position(player_object_handle, 50.0, 0.0, 170.0)
	event.set_object_handle_rotation(player_object_handle, 0.0, 0.0, 0.0)
	event.reset_object_handle_dynamic_animation(player_object_handle)
	event.set_camera_look_at(50.0, 30.0, 170.0)
	event.set_camera_position(50.0, 30.0, 70.0)
	event.reset_follow_camera(0)
	event.show_dungeon_status_bar(1, 1.0)
	inventory.resolve_overflow_alt(0)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(16)
	event.play_music(0)
	event.load_dungeon_monster(0)
	event.place_treasure_box_at_event_point(-1)
	event.place_dungeon_monster(-1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Loads the map and monsters for the current floor, sends the player to special floors and plays the floor entry.
local function load_floor()
	local stage_id: s32 = 0
	local floor: s32 = 0
	local visit_count: s32 = 0
	local save_flag_257: s32 = 0
	local save_flag_260: s32 = 0
	local has_received_crystals: s32 = 0
	local random_value: s32 = 0
	local previous_floor: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(0)
		resume_step = 1
		vm.wait(1)
		event.reset_action_character_motion(0)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		visit_count = event.get_dungeon_floor_info(stage_id, floor, 7) or visit_count
		dungeon.increment_floor_counter(stage_id, floor)
		event.initialize_dungeon_floor()
		if floor == 0 then
			event.go_to_georama_edit(16)
			resume_step = 2
			vm.wait(2)
			return
		end
		if floor == 6 then
			event.skip_next_music_play()
			event.go_to_georama_edit(65, 100)
			resume_step = 3
			vm.wait(3)
			return
		end
		if floor == 12 then
			event.skip_next_music_load()
			event.load_dungeon_map("s13")
			event.load_event_script("s13/s13.stb", 100)
			return
		end
		if floor == 15 then
			event.skip_next_music_load()
			save_flag_257 = event.get_save_flag(257) or save_flag_257
			save_flag_260 = event.get_save_flag(260) or save_flag_260
			if save_flag_257 ~= 0 and save_flag_260 == 0 then
				event.load_dungeon_map("d02b02")
				event.load_event_script("d02b02/d02b02.stb", 200)
			else
				event.load_dungeon_map("d02b01")
				event.load_event_script("d02b01/d02b01.stb", 200)
			end
			return
		end
		event.get_equipped_item(0, 0)
		event.get_save_flag(49)
		has_received_crystals = event.get_save_flag(212) or has_received_crystals
		if floor == 2 and has_received_crystals == 0 then
			event.skip_next_music_load()
			event.load_dungeon_map("d02f01", "d02f01", 1)
			event.add_inventory_item(178, 2)
			event.add_inventory_item(180, 2)
			event.add_inventory_item(181, 1)
			event.add_inventory_item(182, 1)
			event.add_weapon_synthesis_points(0, 0, 6)
			resume_step = 4
			play_monica_crystal_gift()
		else
			if floor == 14 then
				event.allow_next_music_load()
				event.stop_music(0)
				resume_step = 5
				wait.frames(6)
				event.load_music(37)
				event.skip_next_music_load()
			end
			if floor >= 9 and floor <= 11 then
				event.load_dungeon_map("d02f01s", "d02f01", 1)
			else
				random_value = event.get_random_number_int(100) or random_value
				if vm.imod(random_value, 8) == 0 then
					event.load_dungeon_map("d02f01r", "d02f01", 1)
					event.set_dungeon_weather(2)
				else
					event.load_dungeon_map("d02f01", "d02f01", 1)
				end
			end
			event.load_dungeon_monster(0)
			event.place_treasure_box_at_event_point(-1)
			event.place_dungeon_monster(-1)
			event.play_music(0)
			if floor == 100 then
				resume_step = 6
				play_floor_entry(0)
			elseif floor == 1 and visit_count <= 0 then
				resume_step = 7
				play_floor_entry(0)
			else
				previous_floor = event.get_dungeon_previous_floor() or previous_floor
				if floor == previous_floor then
					resume_step = 8
					play_floor_entry(0)
				else
					resume_step = 9
					play_floor_entry(1)
				end
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
		if resume_step <= 3 then
			return 0
		end
		if resume_step <= 9 then
			if resume_step <= 4 then
				wait.frames_skipping(6)
			end
			if resume_step <= 5 then
				resume_step = 6
				play_floor_entry(0)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if resume_step <= 6 then
				resume_step = 7
				play_floor_entry(0)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if resume_step <= 7 then
				resume_step = 8
				play_floor_entry(0)
				return vm.continue_with(function()
					sound.load_event_sound_effects()
					dungeon.show_floor_title()
					return
				end)
			end
			if resume_step <= 8 then
				resume_step = 9
				play_floor_entry(1)
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

--- Opens the floor map menu, applies the chosen floor and previous floor, and loads the floor.
local function enter_floor_from_map_menu()
	local music_number: s32 = 0
	local previous_floor: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	event.initialize_sphida()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 16 then
		event.stop_music(0)
		wait.frames(6)
		event.load_music(16)
	end
	event.play_music(0)
	event.load_map_sounds(2601)
	event.set_local_event_flag(0, 0)
	event.set_local_event_flag(1, 0)
	event.set_local_event_flag(2, 0)
	event.set_local_event_flag(3, 0)
	event.set_local_event_flag(4, 0)
	event.open_dungeon_floor_map(1)
	vm.wait(2)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		previous_floor = out2 or previous_floor
		floor = out3 or floor
	end
	event.set_dungeon_floor(floor)
	event.set_dungeon_previous_floor(previous_floor)
	load_floor()
end

--- Handles the player using a gate by asking to use the key item or to jump into the next floor.
local function use_floor_gate(gate_index: s32)
	local is_unlocked: s32 = 0
	local interaction_state: s32 = 0
	local confirmed: s32 = 0
	local used_item: s32 = 0
	local playable_character: s32 = 0
	local choice: any = 0
	local is_trial: s32 = 0
	local practice_result: s32 = 0
	local bonus_type: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	local is_trial_after_exit: s32 = 0
	event.initialize_event()
	character.reset_action_motion()
	is_unlocked = event.get_local_event_flag(gate_index) or is_unlocked
	event.set_dungeon_pause_flags(1, 1)
	if is_unlocked == 0 then
		interaction_state = event.get_triggered_event_data_2(6) or interaction_state
		if interaction_state == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			confirmed = message.ask_confirmation(0, 1, 5, 256, 208, confirmed)
			event.set_message_bubble_tail(0, 1)
			event.set_message_draw_speed(0, 0)
			if confirmed == 1 then
				interaction_state = 2
			end
			event.finish_event()
		end
		if interaction_state == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait.frames(6)
			event.open_use_item_menu(339)
			vm.wait(3)
			used_item = vmhost.used_item() or used_item
			if used_item == 339 then
				event.set_local_event_flag(gate_index, 1)
				rainbow_butterfly_wood.topple_gate_with_key()
			elseif used_item <= 0 then
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
			rainbow_butterfly_wood.jump_into_room()
			is_trial = event.is_trial_version() or is_trial
			if is_trial ~= 1 then
				do
					local out1, out2 = event.get_floor_practice_result(1)
					practice_result = out1 or practice_result
					bonus_type = out2 or bonus_type
				end
				if practice_result == 2 or practice_result == 3 then
					event.reset_event_sprite(0)
					event.set_event_sprite_type(0, 0)
					event.set_event_sprite_position(0, 256, 208)
					event.set_event_sprite_size(0, 512, 416)
					event.set_event_sprite_color(0, 0, 0, 0, 128)
					event.set_event_sprite_draw_pass(0, 1)
					event.fade_in_screen(0)
					spheda.announce_medal_reward(-1, practice_result, bonus_type)
					vm.wait(12)
					event.fade_out_screen(0)
					event.set_event_sprite_draw_pass(0, 0)
				end
			end
			stage_id = event.get_dungeon_stage_id() or stage_id
			floor = event.get_dungeon_floor() or floor
			next_floor = event.get_dungeon_next_floor(floor, gate_index) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			event.finish_dungeon_floor()
			is_trial_after_exit = event.is_trial_version() or is_trial_after_exit
			if is_trial_after_exit == 1 then
				event.set_scene_exit_flag(1)
				return
			else
				event.finish_event()
				enter_floor_from_map_menu()
			end
		else
			event.finish_event()
		end
	end
	event.set_dungeon_pause_flags(1, 0)
end

--- Plays a monster giving the player Sundrops during a conversation.
local function receive_sundrops_from_monster()
	local sound_bank: s32 = 0
	local monster_slot: s32 = 0
	local player_character_slot: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local monster_x: f32 = 0
	local monster_y: f32 = 0
	local monster_z: f32 = 0
	local effect_handle: s32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	event.set_save_flag(290, 1)
	event.set_dungeon_pause_flags(4096, 1)
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_044.sound.json") or sound_bank
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("モニカ魔法－溜め")
	event.create_effect_work_buffer(5)
	do
		local out1, _ = event.get_monster_talk_data_2()
		monster_slot = out1 or monster_slot
	end
	event.set_character_active(monster_slot)
	event.attach_object_handle_to_character(1, monster_slot)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	player_character_slot = event.get_player_character_slot() or player_character_slot
	event.set_character_active(player_character_slot)
	event.attach_object_handle_to_character(2, player_character_slot)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	do
		local out1, out2, out3 = event.get_character_position(monster_slot)
		monster_x = out1 or monster_x
		monster_y = out2 or monster_y
		monster_z = out3 or monster_z
	end
	do
		local out1, out2, out3 = event.get_character_position(player_character_slot)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	cutscene.begin_talk(monster_slot, 0, 0)
	event.set_object_sequence_motion(1, "会話")
	event.set_message_window_mode(0, 7)
	event.open_message_window_2(
		0,
		"He cogido muchas Gotas de Sol.\nTengo tantas que me salen por las orejas.\nLl[UNI00e9]vate unas cuantas, por favor."
	)
	rainbow_butterfly_wood.speak_voice_bubble(2900010, monster_slot, player_character_slot)
	event.set_object_sequence_motion(1, "ガードin", 2)
	event.queue_object_sequence_next_motion(1, "ガード", 4)
	event.open_message_window_2(0, "Toma.")
	rainbow_butterfly_wood.speak_voice_bubble(2900020, monster_slot, player_character_slot)
	event.apply_message_window_preset(0, 0)
	event.set_object_sequence_motion(1, "ガードout", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	effect_handle = event.create_effect_3("モニカ魔法－溜め", monster_slot) or effect_handle
	vector_x = vm.f32(vm.f32(monster_x + player_x) / 2.0)
	vector_y = vm.f32(vm.f32(vm.f32(monster_y + player_y) / 2.0) + 10.0)
	vector_z = vm.f32(vm.f32(monster_z + player_z) / 2.0)
	event.set_effect_first_vector(vector_x, vector_y, vector_z)
	event.set_effect_second_vector(128, 64, 64)
	event.play_sound_effect(sound_bank, 0)
	wait.frames(30)
	event.set_object_sequence_motion(2, "ガードin", 2)
	event.queue_object_sequence_next_motion(2, "ガード", 4)
	wait.frames(30)
	event.finish_effect(monster_slot, effect_handle)
	inventory.show_obtained_message(356, 1)
	event.set_object_sequence_motion(2, "ガードout", 2)
	event.queue_object_sequence_next_motion(2, "立ち", 4)
	wait.frames(30)
	inventory.resolve_overflow_alt(1)
	event.finish_event()
	event.set_dungeon_pause_flags(4096, 0)
end

--- Plays the victory sequence when every monster is defeated and announces seals, rewards and Sphida messages.
local function clear_floor()
	local playable_character: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local unassigned_flag: s32 = 0
	local is_sphida_enabled: s32 = 0
	local sub_game_flags: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local is_new_record: s32 = 0
	local practice_result: s32 = 0
	local bonus_type: s32 = 0
	local is_trial: s32 = 0
	local floor_status: s32 = 0
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
		rainbow_butterfly_wood.restore_opened_key_door()
		event.reset_action_character_motion(0, 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.show_dungeon_status_bar(1, 0.16666667)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		event.set_dungeon_floor_info(stage_id, floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
		is_sphida_enabled = event.get_save_flag(220) or is_sphida_enabled
		is_sphida_enabled = event.get_save_flag(317) or is_sphida_enabled
		sub_game_flags = event.get_floor_sub_games() or sub_game_flags
		if (if is_sphida_enabled == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
		is_new_record = event.record_floor_clear_time() or is_new_record
		do
			local out1, out2 = event.get_floor_practice_result(0)
			practice_result = out1 or practice_result
			bonus_type = out2 or bonus_type
		end
		resume_step = 5
		spheda.announce_medal_reward(is_new_record, practice_result, bonus_type)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		is_trial = event.is_trial_version() or is_trial
		floor_status = event.get_dungeon_floor_status() or floor_status
		if
			(if (if bit32.band(floor_status, 1) ~= 0 then 1 else bit32.band(floor_status, 2)) ~= 0 then 1 else bit32.band(floor_status, 4))
			~= 0
		then
			event.set_dungeon_floor_status_flags(7, 0)
			if bit32.band(floor_status, 1) ~= 0 then
				event.open_message_window_2(0, "Se ha roto el Sello rojo.")
			end
			if bit32.band(floor_status, 2) ~= 0 then
				event.open_message_window_2(0, "Se ha roto el Sello azul.")
			end
			if bit32.band(floor_status, 4) ~= 0 then
				event.open_message_window_2(0, "Se ha roto el Sello blanco.")
			end
			resume_step = 6
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		resume_step = 7
		message.show_and_wait(0, 2130, 8, 0, 0)
		if is_trial ~= 1 then
			if unassigned_flag == 1 and is_sphida_enabled == 1 and bit32.band(sub_game_flags, 3) == 3 then
				resume_step = 8
				message.show_and_wait(0, 2120, 8, 0, 0)
				resume_step = 9
				spheda.move_character_to_ball()
			else
				if (if unassigned_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
					resume_step = 10
					message.show_and_wait(0, 2110, 8, 0, 0)
				end
				if (if is_sphida_enabled == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					rainbow_butterfly_wood.restore_opened_key_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					is_sphida_enabled = event.get_save_flag(220) or is_sphida_enabled
					is_sphida_enabled = event.get_save_flag(317) or is_sphida_enabled
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if is_sphida_enabled == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					is_new_record = event.record_floor_clear_time() or is_new_record
					do
						local out1, out2 = event.get_floor_practice_result(0)
						practice_result = out1 or practice_result
						bonus_type = out2 or bonus_type
					end
					resume_step = 5
					spheda.announce_medal_reward(is_new_record, practice_result, bonus_type)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial = event.is_trial_version() or is_trial
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
							event.open_message_window_2(0, "Se ha roto el Sello rojo.")
						end
						if bit32.band(floor_status, 2) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello azul.")
						end
						if bit32.band(floor_status, 4) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello blanco.")
						end
						resume_step = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_step = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial ~= 1 then
						if unassigned_flag == 1 and is_sphida_enabled == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_step = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_step = 9
							spheda.move_character_to_ball()
						else
							if (if unassigned_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_step = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if is_sphida_enabled == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					rainbow_butterfly_wood.restore_opened_key_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					is_sphida_enabled = event.get_save_flag(220) or is_sphida_enabled
					is_sphida_enabled = event.get_save_flag(317) or is_sphida_enabled
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if is_sphida_enabled == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					is_new_record = event.record_floor_clear_time() or is_new_record
					do
						local out1, out2 = event.get_floor_practice_result(0)
						practice_result = out1 or practice_result
						bonus_type = out2 or bonus_type
					end
					resume_step = 5
					spheda.announce_medal_reward(is_new_record, practice_result, bonus_type)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial = event.is_trial_version() or is_trial
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
							event.open_message_window_2(0, "Se ha roto el Sello rojo.")
						end
						if bit32.band(floor_status, 2) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello azul.")
						end
						if bit32.band(floor_status, 4) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello blanco.")
						end
						resume_step = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_step = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial ~= 1 then
						if unassigned_flag == 1 and is_sphida_enabled == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_step = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_step = 9
							spheda.move_character_to_ball()
						else
							if (if unassigned_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_step = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if is_sphida_enabled == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					rainbow_butterfly_wood.restore_opened_key_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor = event.get_dungeon_floor() or floor
					event.set_dungeon_floor_info(stage_id, floor, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor, 5, 1024)
					is_sphida_enabled = event.get_save_flag(220) or is_sphida_enabled
					is_sphida_enabled = event.get_save_flag(317) or is_sphida_enabled
					sub_game_flags = event.get_floor_sub_games() or sub_game_flags
					if (if is_sphida_enabled == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
					is_new_record = event.record_floor_clear_time() or is_new_record
					do
						local out1, out2 = event.get_floor_practice_result(0)
						practice_result = out1 or practice_result
						bonus_type = out2 or bonus_type
					end
					resume_step = 5
					spheda.announce_medal_reward(is_new_record, practice_result, bonus_type)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial = event.is_trial_version() or is_trial
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
							event.open_message_window_2(0, "Se ha roto el Sello rojo.")
						end
						if bit32.band(floor_status, 2) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello azul.")
						end
						if bit32.band(floor_status, 4) ~= 0 then
							event.open_message_window_2(0, "Se ha roto el Sello blanco.")
						end
						resume_step = 6
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					resume_step = 7
					message.show_and_wait(0, 2130, 8, 0, 0)
					if is_trial ~= 1 then
						if unassigned_flag == 1 and is_sphida_enabled == 1 and bit32.band(sub_game_flags, 3) == 3 then
							resume_step = 8
							message.show_and_wait(0, 2120, 8, 0, 0)
							resume_step = 9
							spheda.move_character_to_ball()
						else
							if (if unassigned_flag == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
								resume_step = 10
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if is_sphida_enabled == 1 then bit32.band(sub_game_flags, 1) else 0) ~= 0 then
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
				cutscene.noop_2()
				cutscene.noop_with_arguments(0, -1)
				message.resume_numbered_messages(is_new_record, practice_result, bonus_type)
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

--- Plays the Monica victory pose as the default event.
function script.default_event()
	dungeon.play_monica_victory(0)
end

--- Reloads the first floor map with its monsters and treasure boxes and plays the floor entry.
function script.reload_floor()
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(0)
		resume_step = 1
		vm.wait(1)
		event.load_dungeon_map("d02f01", "d02f01", 1)
		event.load_dungeon_monster(0)
		event.place_treasure_box_at_event_point(-1)
		event.place_dungeon_monster(-1)
		resume_step = 2
		play_floor_entry(0)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_floor_entry(0)
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[101] = script.reload_floor

--- Switches the main character to the third playable character at the current position.
function script.switch_to_third_character()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	event.initialize_event()
	vm.wait(1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	event.switch_dungeon_main_character(2)
	event.set_playable_character(2)
	event.set_character_position(0, x, y, z)
	vm.wait(2)
	event.finish_event()
end
script[102] = script.switch_to_third_character

--- Grants the starting key items, enables Sphida on the floor and clears battle monsters.
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

--- Handles the first gate by running the shared gate routine.
function script.use_gate_0()
	use_floor_gate(0)
end
script[300] = script.use_gate_0

--- Handles the second gate by running the shared gate routine.
function script.edit_analyze_changed()
	use_floor_gate(1)
end

--- Handles the third gate by running the shared gate routine.
function script.use_gate_2()
	use_floor_gate(2)
end
script[320] = script.use_gate_2

--- Handles the fourth gate by running the shared gate routine.
function script.use_gate_3()
	use_floor_gate(3)
end
script[330] = script.use_gate_3

--- Event 340, which map data, a script or the engine runs by number.
script[340] = rainbow_butterfly_wood.unlock_star_gate

--- Lets the player clear the spider web with a key item or through a party member.
function script.cut_spider_web()
	local party_npc: s32 = 0
	local interaction_state: s32 = 0
	local confirmed: s32 = 0
	local item: s32 = 0
	local playable_character: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 1)
	character.reset_action_motion()
	party_npc = event.get_party_npc() or party_npc
	if party_npc == 4 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "S[UNI00f3]lo tienes que pasar por aqu[UNI00ed], [UNI00bf]entendido?")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.show_dungeon_status_bar(0, 0.16666667)
		event.set_dungeon_pause_flags(16, 1)
		rainbow_butterfly_wood.clear_spider_web()
		event.set_dungeon_pause_flags(16, 0)
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
		confirmed = message.ask_confirmation(0, 2501, 5, 256, 208, confirmed)
		event.set_message_bubble_tail(0, 1)
		event.set_message_draw_speed(0, 0)
		if confirmed == 1 then
			interaction_state = 2
		end
	end
	if interaction_state == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait.frames(6)
		event.open_use_item_menu(340)
		vm.wait(6)
		item = vmhost.used_item() or item
		if item == 340 then
			event.set_dungeon_pause_flags(16, 1)
			playable_character = event.get_playable_character() or playable_character
			if playable_character == 2 or playable_character == 3 then
				rainbow_butterfly_wood.clear_spider_web()
			else
				rainbow_butterfly_wood.cut_spider_web_with_key()
			end
			event.set_dungeon_pause_flags(16, 0)
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
script[348] = script.cut_spider_web

script.enter_floor_from_map_menu = enter_floor_from_map_menu
script[1000] = script.enter_floor_from_map_menu

script.load_floor = load_floor
script[1010] = script.load_floor

--- The dungeon system event run when the player opens a treasure box.
script.treasure_box = treasure_box.open_nearest

--- Spins a ring and coin at a random circle, then applies a good or bad random circle effect.
function script.random_circle()
	local playable_character: s32 = 0
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
	local sound_bank: s32 = 0
	local motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local party_npc: s32 = 0
	local circle_kind: s32 = 0
	local frame_count: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local target_angle: f32 = 0
	local min_spin_frames: s32 = 0
	local angle: f32 = 0
	local random_roll: s32 = 0
	local chance_threshold: s32 = 0
	local brightness_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_amount: f32 = 0
	local restored_camera_x: f32 = 0
	local restored_camera_y: f32 = 0
	local restored_camera_z: f32 = 0
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
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or sound_bank
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
			event.play_sound_effect(sound_bank, 0)
		end
		if frame_count == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if frame_count >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame_count > 300 then
			event.stop_sound_effect(sound_bank, 0)
			event.play_sound_effect(sound_bank, 3)
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
	target_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or target_angle
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
			angle = target_angle
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_kind = 0
				break
			end
			angle = vm.f32(target_angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_kind = 1
				break
			end
		end
		frame_count = vm.i32(frame_count + 1)
	end
	target_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or target_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, target_angle, 1.0) == 0 then
		circle_kind = 0
	else
		circle_kind = 1
	end
	target_angle = coin_angle
	wait.frames(20)
	random_roll = event.get_random_number_int(10) or random_roll
	if party_npc == 24 then
		chance_threshold = 100
	else
		chance_threshold = 6
	end
	if random_roll < chance_threshold then
		random_roll = event.get_random_number_int(10) or random_roll
		if circle_kind == 0 then
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
			target_angle = vm.f32(target_angle + vm.f32(3.14))
			target_angle = event.wrap_angle(target_angle) or target_angle
			event.rotate_object_sequence(5, 0.0, target_angle, 0.0, 8)
			if circle_kind == 0 then
				circle_kind = 1
			else
				circle_kind = 0
			end
			wait.frames(10)
		else
			random_roll = event.get_random_number_int(10) or random_roll
			if random_roll < 1 then
				target_angle = vm.f32(target_angle + vm.f32(3.14))
				target_angle = event.wrap_angle(target_angle) or target_angle
				event.rotate_object_sequence(5, 0.0, target_angle, 0.0, 6)
				target_angle = vm.f32(target_angle + vm.f32(1.57))
				target_angle = event.wrap_angle(target_angle) or target_angle
				event.rotate_object_sequence(5, 0.0, target_angle, 0.0, 3)
				target_angle = vm.f32(target_angle + vm.f32(1.57))
				target_angle = event.wrap_angle(target_angle) or target_angle
				event.rotate_object_sequence(5, 0.0, target_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	target_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or target_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, target_angle, 1.0) == 0 then
		circle_kind = 0
	else
		circle_kind = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness_rate = 1.0
	frame_count = 0
	effect_id = event.get_random_circle_effect(circle_kind) or effect_id
	if circle_kind == 0 then
		event.play_sound_effect(sound_bank, 1)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate + vm.f32(0.03))
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
			event.place_treasure_box(ring_x, ring_y, ring_z, target_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_bank, 2)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate - vm.f32(0.03))
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
		event.spawn_pull_items(ring_x, ring_y, ring_z, 1, 10, effect_amount / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
	do
		local out1, out2, out3 = event.get_previous_camera_next_position()
		restored_camera_x = out1 or restored_camera_x
		restored_camera_y = out2 or restored_camera_y
		restored_camera_z = out3 or restored_camera_z
	end
	event.set_camera_position(restored_camera_x, restored_camera_y, restored_camera_z)
	do
		local out1, out2, out3 = event.get_previous_camera_next_look_at()
		restored_camera_x = out1 or restored_camera_x
		restored_camera_y = out2 or restored_camera_y
		restored_camera_z = out3 or restored_camera_z
	end
	event.set_camera_look_at(restored_camera_x, restored_camera_y, restored_camera_z)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the scene of the character picking up and activating the geostone.
function script.geostone()
	local playable_character: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local sound_bank: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local stone_x: f32 = 0
	local stone_y: f32 = 0
	local stone_z: f32 = 0
	local facing_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	local system_sound_bank: s32 = 0
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
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
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
		stone_x = out1 or stone_x
		stone_y = out2 or stone_y
		stone_z = out3 or stone_z
	end
	stone_y = vm.f32(character_y + 18.0)
	event.set_object_handle_position(1, stone_x, stone_y, stone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(stone_x, stone_y, stone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if playable_character == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if playable_character == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	character_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + stone_x)
	character_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + stone_z)
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
	system_sound_bank = event.get_system_sound_id() or system_sound_bank
	event.play_sound_effect(system_sound_bank, 18)
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

--- Starts a monster conversation or the Sundrops gift scene.
function script.monster_talk()
	local save_value: s32 = 0
	local monster_id: s32 = 0
	local has_received_sundrops: s32 = 0
	save_value = event.get_save_data_value(0) or save_value
	if save_value == 100 then
		dungeon.talk_to_monster()
		return
	end
	do
		local _, out2, _ = event.get_monster_talk_data_3()
		monster_id = out2 or monster_id
	end
	has_received_sundrops = event.get_save_flag(290) or has_received_sundrops
	if has_received_sundrops == 0 and monster_id == 52 then
		event.add_inventory_item(356)
		receive_sundrops_from_monster()
	else
		dungeon.talk_to_monster()
	end
end

--- Runs the party defeat sequence without a voice line.
function script.play_defeat_without_voice()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.play_defeat_without_voice

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = clear_floor

--- Shows the guide message for random stones.
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

--- Shows a tutorial message and waits for the player to dismiss it.
function script.show_tutorial_message()
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
script[2510] = script.show_tutorial_message

--- Shows the level-up guide messages.
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

--- Shows how to drive the buggy.
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

--- Explains the magic-absorb blade.
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

--- Runs one Sphida shot: aiming, power gauge, ball physics, hazards and the cup-in or miss outcome.
function script.sphida_shot()
	local texture_bank: s32 = 0
	local sound_bank: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local rotation_z: f32 = 0
	local origin_x: f32 = 0
	local origin_y: f32 = 0
	local origin_z: f32 = 0
	local launch_angle: f32 = 0
	local shot_power: f32 = 0
	local club_curve: f32 = 0
	local gauge_level: s32 = 0
	local drift_x: f32 = 0
	local curve_amount: f32 = 0
	local drift_z: f32 = 0
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
	local out_of_bounds_state: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local remaining_distance: f32 = 0
	local vector_length: f32 = 0
	local collision_index: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local frame_index: s32 = 0
	local distance_to_pin: f32 = 0
	local to_pin_x: f32 = 0
	local to_pin_y: f32 = 0
	local to_pin_z: f32 = 0
	local pin_segment_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_angle: f32 = 0
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
	texture_bank = event.get_sphida_texture_bank() or texture_bank
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
		origin_x = out1 or origin_x
		origin_y = out2 or origin_y
		origin_z = out3 or origin_z
	end
	ball_x, ball_y, ball_z, aim_angle = minigame.set_up_sphida_shot(ball_x, ball_y, ball_z, aim_angle)
	camera.place_behind_player(aim_angle)
	event.set_sphida_status_panel_visible(1)
	launch_angle = 12.5
	event.set_sphida_carry_angle(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power, club_curve, gauge_level = minigame.get_equipped_club_definition(shot_power, club_curve, gauge_level)
	event.set_sphida_power_gauge_safe_level(gauge_level)
	do
		local out1, out2, out3 = event.zero_vector()
		drift_x = out1 or drift_x
		curve_amount = out2 or curve_amount
		drift_z = out3 or drift_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local was_aim_cancelled: s32
		was_aim_cancelled, aim_angle, launch_angle = minigame.aim_sphida_shot(aim_angle, launch_angle, texture_bank)
		if was_aim_cancelled ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_sphida_ball_position(origin_x, origin_y, origin_z)
			event.set_character_position(8, origin_x, origin_y, origin_z)
			event.set_character_position(9, origin_x, origin_y, origin_z)
			minigame.finish_sphida_round(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local was_gauge_cancelled: s32
		was_gauge_cancelled, shot_power, aim_angle, curve_amount, drift_x, gauge_level = minigame.run_sphida_power_gauge(shot_power, texture_bank, aim_angle, curve_amount, drift_x, sound_bank, gauge_level)
		if was_gauge_cancelled == 0 then
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
	if shot_power <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.frames(25)
		if gauge_level ~= 4 then
			event.play_sound_effect(sound_bank, 3)
		end
	elseif shot_power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.frames(34)
		event.play_sound_effect(sound_bank, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.frames(39)
		if gauge_level == 0 then
			event.play_sound_effect(sound_bank, 12)
		else
			event.play_sound_effect(sound_bank, 1)
		end
	end
	if gauge_level == 4 then
		wait.frames(50)
		minigame.consume_sphida_shot(sound_bank)
		event.set_sphida_ball_position(origin_x, origin_y, origin_z)
		event.set_character_position(8, origin_x, origin_y, origin_z)
		event.set_character_position(9, origin_x, origin_y, origin_z)
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
	shot_power = minigame.scale_by_club_power(shot_power)
	launch_angle = vm.f32(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power = vm.f32(shot_power - vm.f32(shot_power * launch_angle))
	velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(shot_power * vm.cos(launch_angle)))
	velocity_y = vm.f32(shot_power * vm.sin(launch_angle))
	velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(shot_power * vm.cos(launch_angle)))
	curve_amount = vm.f32(vm.f32(curve_amount * vm.f32(3.1415927)) / 2.0)
	drift_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_curve) * drift_x) * vm.f32(0.4))
	drift_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_curve) * drift_x) * vm.f32(0.4))
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
		shot_power = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		shot_power = 0.0
	end
	frame_index = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (frame_index + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_index = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_index
			if gauge_level == 1 and collision_index >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (frame_index + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + drift_x)
				velocity_z = vm.f32(velocity_z + drift_z)
				drift_x = vm.f32(drift_x * vm.f32(0.8))
				drift_z = vm.f32(drift_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (frame_index + 1)))
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
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			launch_angle = vm.f32(launch_angle + curve_amount)
			launch_angle = event.wrap_angle(launch_angle) or launch_angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(launch_angle) / 10.0) * club_curve))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(launch_angle) / 10.0) * club_curve))
		end
		vector_length = event.get_vector_length(drift_x, 0.0, drift_z) or vector_length
		if vector_length > vm.f32(0.01) then
			speed = event.get_vector_length(drift_x, 0.0, drift_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + drift_x, previous_y, previous_z + drift_z) or launch_angle
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
		remaining_distance = speed
		launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
		offset_x = vm.f32(vm.sin(vm.f32(launch_angle - vm.f32(1.5707964))) * 3.0)
		offset_z = vm.f32(vm.cos(vm.f32(launch_angle - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			ball_x - offset_x,
			ball_y,
			ball_z - offset_z,
			vm.f32(ball_x + offset_x) + offset_x,
			ball_y,
			vm.f32(ball_z + offset_z) + offset_z
		)
		do
			local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
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
			local out1, out2, out3 = event.scale_vector(offset_x, offset_y, offset_z, 3.0)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
		end
		do
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, previous_x, previous_y, previous_z, ball_x + offset_x, ball_y + offset_y, ball_z + offset_z, 0)
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
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + offset_x, ball_y + offset_y, ball_z + offset_z, 1)
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
			if shot_power ~= 1.0 and sound_cooldown <= 0 then
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
			vector_length = event.get_vector_length(previous_x, previous_y, previous_z) or vector_length
			vector_length = vm.f32(remaining_distance - vector_length)
			if vector_length <= 0.0 then
				break
			else
				remaining_distance = vector_length
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
					local out1, out2, out3 = event.scale_vector(offset_x, offset_y, offset_z, 3.0)
					offset_x = out1 or offset_x
					offset_y = out2 or offset_y
					offset_z = out3 or offset_z
				end
				do
					local out1, out2, out3 = event.scale_vector(normal_x, normal_y, normal_z, vector_length)
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
						ball_x + offset_x,
						ball_y + offset_y,
						ball_z + offset_z,
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
			vector_length = event.get_vector_length(velocity_x, 0.0, velocity_z) or vector_length
			if vector_length < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				gauge_level = 1
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
					event.play_sound_effect(sound_bank, 5)
					sound_cooldown = 10
				end
			end
			vector_length = event.get_vector_length(drift_x, 0.0, drift_z) or vector_length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and vector_length < vm.f32(0.4) then
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
		elseif frame_index >= 480 then
			out_of_bounds_state = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			to_pin_x = vm.f32(pin_x - ball_x)
			to_pin_y = vm.f32(pin_y - ball_y)
			to_pin_z = vm.f32(pin_z - ball_z)
			distance_to_pin = event.get_vector_length(to_pin_x, to_pin_y, to_pin_z) or distance_to_pin
			if ball_color ~= pin_color then
				pin_segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or pin_segment_distance
				if pin_segment_distance >= 0.0 and pin_segment_distance <= 30.0 then
					is_cup_in = 1
					break
				end
				if distance_to_pin ~= 0.0 then
					if distance_to_pin <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(to_pin_x, to_pin_y, to_pin_z, vm.fdiv(vm.f32(0.6), distance_to_pin))
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
					is_cup_in = 1
					break
				end
			elseif distance_to_pin ~= 0.0 then
				if distance_to_pin <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(to_pin_x, to_pin_y, to_pin_z, vm.fdiv(1.0, distance_to_pin))
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
			elseif frame_index >= 20 then
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
			frame_index = frame_index + 1
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
		par = event.get_sphida_par() or par
		if is_cup_in == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_bank, 17)
			frame_index = 0
			while frame_index < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_index = frame_index + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			frame_index = 0
			while frame_index < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_index = frame_index + 1
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
			event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, launch_angle, sound_cooldown, surface_type)
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
		elseif par >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			choice = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(24)
			if choice == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
					collision_index = out1 or collision_index
					origin_x = out2 or origin_x
					origin_y = out3 or origin_y
					origin_z = out4 or origin_z
				end
				if collision_index == 0 then
					do
						local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
						origin_x = out1 or origin_x
						origin_y = out2 or origin_y
						origin_z = out3 or origin_z
					end
				end
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pin_x = out1 or pin_x
					pin_y = out2 or pin_y
					pin_z = out3 or pin_z
				end
				speed = event.get_distance_between(origin_x, origin_y, origin_z, pin_x, pin_y, pin_z) or speed
				if speed < 40.0 then
					launch_angle = event.get_random_number(6.2831855) or launch_angle
					launch_angle = vm.f32(launch_angle - vm.f32(3.1415927))
					origin_x = vm.f32(origin_x + vm.f32(vm.sin(launch_angle) * 50.0))
					origin_z = vm.f32(origin_z + vm.f32(vm.cos(launch_angle) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(origin_x, origin_y, origin_z)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						collision_index = out4 or collision_index
					end
					frame_index = 0
					while collision_index >= 0 do
						do
							local out1, out2, out3 = event.copy_vector(origin_x, origin_y, origin_z)
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
							origin_x = out1 or origin_x
							origin_y = out2 or origin_y
							origin_z = out3 or origin_z
						end
						do
							local out1, out2, out3 = event.add_vectors(origin_x, origin_y, origin_z, previous_x, previous_y, previous_z)
							origin_x = out1 or origin_x
							origin_y = out2 or origin_y
							origin_z = out3 or origin_z
						end
						frame_index = frame_index + 1
						if frame_index > 6 then
							break
						end
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(origin_x, origin_y, origin_z)
							hit_x = out1 or hit_x
							hit_y = out2 or hit_y
							hit_z = out3 or hit_z
							collision_index = out4 or collision_index
						end
					end
				end
				aim_angle = event.get_direction_angle(origin_x, origin_y, origin_z, ball_x, ball_y, ball_z) or aim_angle
				event.set_character_position(0, origin_x, origin_y, origin_z)
				event.set_character_rotation(0, 0.0, aim_angle, 0.0)
				event.set_camera_look_at(origin_x, origin_y + 30.0, origin_z)
				aim_angle = vm.f32(aim_angle - vm.f32(3.1415927))
				aim_angle = event.wrap_angle(aim_angle) or aim_angle
				origin_x = vm.f32(vm.f32(vm.sin(aim_angle) * 100.0) + origin_x)
				origin_y = vm.f32(origin_y + 30.0)
				origin_z = vm.f32(vm.f32(vm.cos(aim_angle) * 100.0) + origin_z)
				event.set_camera_position(origin_x, origin_y, origin_z)
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
		event.set_sphida_ball_position(origin_x, origin_y, origin_z)
		event.set_character_position(8, origin_x, origin_y, origin_z)
		event.set_character_position(9, origin_x, origin_y, origin_z)
		event.release_camera_sequence_follow_object()
	end
	if is_cup_in == 1 then
		minigame.consume_sphida_shot(-1)
	else
		minigame.consume_sphida_shot(sound_bank)
	end
	minigame.finish_sphida_round(is_cup_in)
end

--- Asks whether to move the ball to the player position.
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

--- Warns that this is the last ball move and asks whether to move the ball to the player.
function script.sphida_near_ball_last()
	local choice: any = 0
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

--- Loads the floor map, plays the floor entry and sets up the Sphida course.
function script.start_sphida_course()
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(0)
		resume_step = 1
		vm.wait(1)
		event.load_dungeon_map("d02f01", "d02f01", 1)
		resume_step = 2
		play_floor_entry(0)
		minigame.set_up_sphida_course_with_draw_distance(0, -1)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_floor_entry(0)
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

--- Leaves Sphida and loads the first boss map to run the same-numbered event.
function script.leave_sphida_for_boss_1_cutscene_a()
	minigame.leave_sphida()
	event.load_dungeon_map("d02b01")
	vm.wait(2)
	event.load_event_script("d02b01/d02b01.stb", 12551)
end
script[12551] = script.leave_sphida_for_boss_1_cutscene_a

--- Leaves Sphida and loads the first boss map to run the same-numbered event.
function script.leave_sphida_for_boss_1_cutscene_b()
	minigame.leave_sphida()
	event.load_dungeon_map("d02b01")
	vm.wait(2)
	event.load_event_script("d02b01/d02b01.stb", 12552)
end
script[12552] = script.leave_sphida_for_boss_1_cutscene_b

--- Leaves Sphida and loads the first boss map to run the same-numbered event.
function script.leave_sphida_for_boss_1_cutscene_c()
	minigame.leave_sphida()
	event.load_dungeon_map("d02b01")
	vm.wait(2)
	event.load_event_script("d02b01/d02b01.stb", 12560)
end
script[12560] = script.leave_sphida_for_boss_1_cutscene_c

--- Leaves Sphida and loads the second boss map to run the same-numbered event.
function script.leave_sphida_for_boss_2_cutscene_a()
	minigame.leave_sphida()
	event.load_dungeon_map("d02b02")
	vm.wait(2)
	event.load_event_script("d02b02/d02b02.stb", 12570)
end
script[12570] = script.leave_sphida_for_boss_2_cutscene_a

--- Leaves Sphida and loads the second boss map to run the same-numbered event.
function script.leave_sphida_for_boss_2_cutscene_b()
	minigame.leave_sphida()
	event.load_dungeon_map("d02b02")
	vm.wait(2)
	event.load_event_script("d02b02/d02b02.stb", 12600)
end
script[12600] = script.leave_sphida_for_boss_2_cutscene_b

--- Sets the party stats and equipment and starts the second boss map.
function script.start_boss_2_with_loadout()
	event.set_character_max_hp(0, 64)
	event.set_character_max_hp(1, 64)
	event.set_character_defence(0, 16)
	event.set_character_defence(1, 16)
	event.add_inventory_item(18)
	event.equip_character_item(0, 18)
	event.add_inventory_item(25)
	event.equip_character_item(0, 25)
	event.add_inventory_item(48)
	event.equip_character_item(1, 48)
	event.add_inventory_item(92)
	event.equip_character_item(1, 92)
	event.load_dungeon_map("d02b02")
	vm.wait(1)
	event.load_event_script("d02b02/d02b02.stb", 200)
end
script[22030] = script.start_boss_2_with_loadout

--- Sets the party stats, equipment and item stock and starts the town map.
function script.start_town_with_loadout()
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
	event.load_dungeon_map("s13")
	vm.wait(1)
	event.load_event_script("s13/s13.stb", 26010)
end
script[26010] = script.start_town_with_loadout

return script
