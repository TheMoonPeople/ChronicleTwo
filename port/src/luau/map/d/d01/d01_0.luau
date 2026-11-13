--!strict
--- Event script for the Underground Water Channel dungeon: floor entry cutscenes, water gate and key door, floor clear, random circle, geostone, tutorials and the Sphida minigame.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local dungeon_finish = require("@lib/event/japanese/dungeon_finish")
local dungeon_victory = require("@lib/event/japanese/dungeon_victory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local spheda = require("@lib/event/japanese/spheda")
local sphida_setup = require("@lib/event/japanese/sphida_setup")
local treasure_box = require("@lib/event/japanese/treasure_box")
local underground_water_channel = require("@lib/event/underground_water_channel")
local wait = require("@lib/event/wait")

--- Plays the cutscene of the character walking up to the water gate and fading out as the gate opens.
local function walk_to_gate()
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	local map_part: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
		object.get_trigger_placement(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 11)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, -20.0, 100.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.move_object_sequence(0, 0.0, -20.0, 37.0, 40)
	event.move_object_sequence(0, 0.0, 0.0, 0.0, 40)
	event.move_object_sequence(0, 0.0, 0.0, -30.0, 40)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 120)
	event.set_object_sequence_motion(0, "立ち")
	event.delay_object_sequence_sound_track(0, 1)
	event.reset_object_sequence_dynamic_animation(0)
	event.start_crossfade(30)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(44.65, 9.01, 185.68)
	event.set_camera_sequence_look_at(9.77, 32.28, 31.49)
	wait.for_frame_count(60)
	event.set_object_handle_footstep_sound(0, 2)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(60)
	camera.wait_until_done()
	object.wait_until_done(0)
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_map_part_3(0, map_part, "d01w10_4-m0")
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
end

--- Plays the opening cutscene of the dungeon's first visit, in which Mints runs in and takes out a receiver, then shows the floor clearing tutorial.
local function play_first_visit_intro()
	local map_part: s32 = 0
	local receiver_sound_bank: s32 = 0
	local gate_sound_bank: s32 = 0
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	local language_code: s32 = 0
	local texture_block: s32 = 0
	local rotation_y: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(100, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		event.fade_out_screen(0)
		step = 2
		vm.wait(2)
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		map_part = event.get_triggered_event_data_2(9) or map_part
		event.attach_object_handle_to_map_part_3(31, map_part, "d01w09_3-m0")
		event.set_object_handle_position(31, 0.0, 0.0, 0.0)
		receiver_sound_bank = event.load_sound_effect_file_2(1803) or receiver_sound_bank
		gate_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or gate_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			event_x = out1 or event_x
			event_y = out2 or event_y
			event_z = out3 or event_z
			event_angle = out4 or event_angle
		end
		event_angle = vm.f32(event_angle + vm.f32(1.5707964))
		if event_angle > vm.f32(3.1415927) then
			event_angle = vm.f32(event_angle - vm.f32(6.2831855))
		end
		event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
		language_code = event.get_language() or language_code
		if language_code == 0 then
			event.load_message_file(0, 5, "event/e100/e100/e100.txt")
		else
			event.load_message_file(0, 5, "event/e100/e100/eng_e100.txt")
		end
		event.load_character_motion_pack(5, "event/e100/e100/e100_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_item_model(5, 359, "info", 8)
		event.set_character_active(0, 8)
		event.attach_character_to_frame(0, "ef00", 8)
		texture_block = event.load_event_image_4(5, "textures/event/e100/e100/e100_2d.json", 0) or texture_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e100_2d01", texture_block)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(4, 0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e100_2d02", texture_block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 208)
		event.set_event_sprite_alpha_blend(1, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.attach_object_handle_to_sprite(5, 1)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		map_part = event.get_triggered_event_data_2(9) or map_part
		event.attach_object_handle_to_map_part_3(1, map_part, "d01w09_3-m0")
		event.set_object_handle_visible(1, 1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.open_voice_stream_wave(1, 1000030)
		step = 3
		sound.wait_voice_stream_ready(1)
		event.set_object_sequence_position(0, 130.0, 100.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.move_object_sequence(1, 0.0, 80.0, 0.0, 60)
		event.play_sound_effect(gate_sound_bank, 1)
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		event.set_camera_sequence_position(-58.59, 100.6, -45.13)
		event.set_camera_sequence_look_at(32.99, 106.26, -19.26)
		event.delay_camera_sequence_position_track(30)
		event.move_camera_sequence_eased(-287.61, 29.51, -60.44, -89.85, 28.2, -4.59, 60, 0, 0.4)
		step = 4
		wait.for_frame_count(30)
		event.move_object_sequence(0, 87.0, 100.0, 0.0, 20)
		event.move_object_sequence(0, -80.0, 0.0, 0.0, 50)
		event.set_object_sequence_motion(0, "走り")
		step = 5
		wait.for_frame_count(30)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.2, 10)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.8, 8)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.4, 5)
		step = 6
		wait.for_frame_count(40)
		event.set_object_handle_footstep_sound(0, 6)
		step = 7
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		step = 8
		camera.wait_until_done()
		step = 9
		wait.for_frame_count(20)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			rotation_y = out2 or rotation_y
		end
		event.set_camera_sequence_look_at(-175.0, 30.0, 0.0)
		event.set_camera_sequence_angle_height_distance(-rotation_y, 47.61, 160.0)
		event.set_object_sequence_position(0, -100.0, 0.0, 0.0)
		event.move_object_sequence(0, -150.0, 0.0, 0.0, 90)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4)
		step = 10
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_camera_sequence_follow_object(0, 0.0, 20.0, 0.0, -1.07, -4.02, 40.0)
		event.open_message_window_2(0, 1000030)
		message.open(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		step = 11
		message.wait_voice_stopping_for(0, 60)
		message.close(0)
		event.close_voice_stream(1)
		event.set_message_bubble_screen_slot(0, 0)
		step = 12
		object.wait_until_done(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(-150.27, 25.12, -3.38)
		event.set_camera_sequence_look_at(-229.26001, 21.67, 10.04)
		event.move_camera_sequence_look_at(-229.26001, 21.67, -10.04, 60)
		event.set_object_sequence_motion(0, "立ち", 4)
		step = 13
		wait.for_frame_count(40)
		event.play_sound_effect(receiver_sound_bank, 0)
		step = 14
		camera.wait_until_done()
		event.set_camera_sequence_position(-212.99, 26.89, 0.0)
		event.set_camera_sequence_look_at(-147.45, 15.75, 0.0)
		event.set_object_sequence_motion(0, "レシーバーを取り出す", 6)
		event.queue_object_sequence_next_motion(0, "レシーバー立ち", 4)
		event.play_sound_effect(receiver_sound_bank, 1)
		step = 15
		wait.for_frame_count(30)
		event.set_character_active(1, 8)
		step = 16
		wait.for_frame_count(20)
		event.stop_sound_effect(receiver_sound_bank, 0)
		event.play_sound_effect(receiver_sound_bank, 2)
		step = 17
		object.wait_until_done(0)
		event.set_camera_sequence_position(-177.01, 19.91, -6.56)
		event.set_camera_sequence_look_at(-150.48, 23.15, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		step = 18
		message.show_voiced(1000040)
		event.set_object_sequence_motion(0, "レシーバーキョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "レシーバー立ち", 4)
		step = 19
		vm.wait(19)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, 1000050)
		step = 20
		message.show_voiced(1000050)
		step = 21
		object.wait_until_done(0)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-176.71, 19.55, 0.0)
		event.set_camera_sequence_look_at(-147.45, 22.68, 0.0)
		event.set_object_sequence_texture_animation(0, 1, "右向き目パチ")
		step = 22
		message.show_voiced(1000060)
		step = 23
		message.show_voiced(1000080)
		step = 24
		message.show_voiced(1000090)
		event.move_camera_sequence_eased(-210.04, 24.27, -6.23, -147.11, 26.71, 10.92, 30, 0, 0.4)
		event.set_object_sequence_motion(0, "腰に手(レシーバー)", 6)
		event.queue_object_sequence_next_motion(0, "腰に手L(レシーバー)", 4)
		event.set_object_sequence_texture_animation(0, 0, "右向き目パチ")
		event.start_crossfade(30)
		event.set_dungeon_pause_flags(128, 1)
		event.set_event_sprite_draw_pass(0, 2)
		step = 25
		message.show_voiced(1000100)
		step = 26
		message.show_voiced(1000110)
		event.set_object_sequence_color(4, 128.0, 128.0, 128.0, 0.0, 30)
		event.set_event_sprite_draw_pass(1, 2)
		event.set_object_sequence_color(5, 128.0, 128.0, 128.0, 128.0, 30)
		step = 27
		message.show_voiced(1000120)
		step = 28
		message.show_voiced(1000125)
		event.start_crossfade(30)
		event.set_dungeon_pause_flags(128, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_object_sequence_motion(0, "腰に手戻り(レシーバー)", 6)
		event.queue_object_sequence_next_motion(0, "レシーバー立ち", 4)
		step = 29
		wait.for_frame_count(30)
		step = 30
		object.wait_until_done(0)
		event.set_camera_sequence_position(-172.33, 19.91, 18.9)
		event.set_camera_sequence_look_at(-150.48, 23.15, 0.0)
		event.set_object_sequence_motion(0, "うなづく(レシーバー)", 6)
		event.queue_object_sequence_next_motion(0, "レシーバー立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		step = 31
		vm.wait(31)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 32
		message.show_voiced(1000130)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "レシーバーをなおす", 6)
		event.queue_object_sequence_next_motion(0, "レシーバーをなおすL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		step = 33
		wait.for_frame_count(20)
		event.play_sound_effect(receiver_sound_bank, 3)
		step = 34
		wait.for_frame_count(30)
		event.play_sound_effect(receiver_sound_bank, 4)
		event.set_character_active(0, 8)
		step = 35
		object.wait_until_done(0)
		event.set_camera_sequence_position(-189.46, 10.19, -2.57)
		event.set_camera_sequence_look_at(-147.45, 16.24, -2.57)
		event.set_object_handle_visible(2, 1)
		event.set_object_handle_visible(3, 1)
		step = 36
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		step = 37
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if step <= 2 then
			event_angle = vm.f32(event_angle + vm.f32(1.5707964))
			local _ = event_angle > vm.f32(3.1415927)
			event_angle = vm.f32(event_angle - vm.f32(6.2831855))
			cutscene.skip_command(1)
		end
		if step <= 3 then
			wait.skip_frame_count(30)
		end
		if step <= 4 then
			wait.skip_frame_count(30)
		end
		if step <= 5 then
			wait.skip_frame_count(40)
		end
		if step <= 6 then
			cutscene.skip_command(0)
		end
		if step <= 7 then
			wait.background_load_skipping()
		end
		if step <= 8 then
			wait.skip_frame_count(20)
		end
		if step <= 9 then
			wait.skip_frame_count(30)
		end
		if step <= 10 then
			message.open_skipping(0, -1, 8, 0, 0)
			message.wait_voice_stopping_for_skipping(0, 60)
		end
		if step <= 11 then
			message.close_skipping(0)
			cutscene.skip_command(0)
		end
		if step <= 12 then
			wait.skip_frame_count(40)
		end
		if step <= 13 then
			wait.background_load_skipping()
		end
		if step <= 14 then
			wait.skip_frame_count(30)
		end
		if step <= 15 then
			wait.skip_frame_count(20)
		end
		if step <= 16 then
			cutscene.skip_command(0)
		end
		if step <= 17 then
			message.show_voiced_skipping(1000040)
		end
		if step <= 19 then
			message.show_voiced_skipping(1000050)
		end
		if step <= 20 then
			cutscene.skip_command(0)
		end
		if step <= 21 then
			message.show_voiced_skipping(1000060)
		end
		if step <= 22 then
			message.show_voiced_skipping(1000080)
		end
		if step <= 23 then
			message.show_voiced_skipping(1000090)
		end
		if step <= 24 then
			message.show_voiced_skipping(1000100)
		end
		if step <= 25 then
			message.show_voiced_skipping(1000110)
		end
		if step <= 26 then
			message.show_voiced_skipping(1000120)
		end
		if step <= 27 then
			message.show_voiced_skipping(1000125)
		end
		if step <= 28 then
			wait.skip_frame_count(30)
		end
		if step <= 29 then
			cutscene.skip_command(0)
		end
		if step <= 31 then
			message.show_voiced_skipping(1000130)
		end
		if step <= 32 then
			wait.skip_frame_count(20)
		end
		if step <= 33 then
			wait.skip_frame_count(30)
		end
		if step <= 34 then
			cutscene.skip_command(0)
		end
		if step <= 35 then
			wait.skip_frame_count(30)
		end
		if step <= 36 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	step = 38
	vm.entry(38)
	event.cancel_drama_scene_skip()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, -1)
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_map_part_3(31, map_part, "d01w09_3-m0")
	event.set_object_handle_position(31, 0.0, 0.0, 0.0)
	event.stop_sound_effect(gate_sound_bank, 1)
	event.stop_sound_effect(receiver_sound_bank, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_event_image(0)
	event.clear_camera_sequence()
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.clear_object_sequence(2)
	event.clear_object_sequence(3)
	event.clear_object_sequence(4)
	event.clear_object_sequence(5)
	event.set_dungeon_pause_flags(128, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_position(0, -140.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_texture_animation(0, 0)
	event.set_object_handle_texture_animation(0, "目パチ")
	event.set_camera_position(20.0, 75.0, 0.0)
	event.set_camera_look_at(-140.0, 30.0, 0.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	step = 39
	wait.for_frame_count(20)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, 9000010)
	step = 40
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, 9000020)
	step = 41
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, 9000030)
	step = 42
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, 9000040)
	step = 43
	message.show_and_wait(0, -1, 8, 0, 0)
	step = 44
	vm.wait(44)
	step = 45
	vm.wait(45)
	event.load_message_file(0, -1)
	sound.load_event_sound_effects()
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Plays the cutscene of the character running onto a floor, showing either the floor map or the dungeon logo and announcing any floor seals.
local function play_floor_entry_cutscene(is_map_display: s32)
	local gate_sound_bank: s32 = 0
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	local current_floor: s32 = 0
	local previous_floor: s32 = 0
	local seal_flags: s32 = 0
	local texture_block: s32 = 0
	local map_part: s32 = 0
	local rotation_y: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		gate_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or gate_sound_bank
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			event_x = out1 or event_x
			event_y = out2 or event_y
			event_z = out3 or event_z
			event_angle = out4 or event_angle
		end
		event_angle = vm.f32(event_angle + vm.f32(1.5707964))
		if event_angle > vm.f32(3.1415927) then
			event_angle = vm.f32(event_angle - vm.f32(6.2831855))
		end
		event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
		if is_map_display ~= 0 then
			current_floor = event.get_dungeon_floor() or current_floor
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			event.load_dungeon_map_display(5, 0, 0, current_floor, previous_floor)
		else
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d00.json", 0)
			event.set_event_image_texture(0, "logo_d00")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_visible(1, 0)
			event.set_event_image_color(0, 128, 128, 128, 0)
		end
		seal_flags = event.get_dungeon_floor_status() or seal_flags
		if seal_flags ~= 0 then
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			if bit32.band(seal_flags, 1) ~= 0 then
				event.switch_dungeon_main_character(1)
				texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin.json", 1) or texture_block
				event.set_event_sprite_texture(0, "aka_fuuin", texture_block)
			end
			if bit32.band(seal_flags, 2) ~= 0 then
				event.switch_dungeon_main_character(0)
				texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin.json", 1) or texture_block
				event.set_event_sprite_texture(0, "ao_fuuin", texture_block)
			end
			if bit32.band(seal_flags, 4) ~= 0 then
				texture_block = event.load_event_image_4(5, "textures/dungeon/image/seal/shiro_fuuin.json", 1) or texture_block
				event.set_event_sprite_texture(0, "shiro_fuuin", texture_block)
			end
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
			event.set_event_sprite_size(0, 512, 128)
			event.set_event_sprite_position(0, 256, 208)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(30, 0)
			event.clear_object_sequence(30)
			event.set_object_sequence_object(30, 30)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 130.0, 100.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		map_part = event.get_triggered_event_data_2(9) or map_part
		event.attach_object_handle_to_map_part_3(1, map_part, "d01w09_3-m0")
		event.set_object_handle_visible(1, 1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.move_object_sequence(1, 0.0, 80.0, 0.0, 60)
		event.play_sound_effect(gate_sound_bank, 1)
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		event.set_camera_sequence_position(-58.59, 100.6, -45.13)
		event.set_camera_sequence_look_at(32.99, 106.26, -19.26)
		event.delay_camera_sequence_position_track(30)
		event.move_camera_sequence_eased(-287.61, 29.51, -60.44, -89.85, 28.2, -4.59, 60, 0, 0.4)
		step = 2
		wait.for_frame_count(30)
		if is_map_display ~= 0 then
			event.fade_dungeon_map(1, 15)
		end
		event.move_object_sequence(0, 87.0, 100.0, 0.0, 20)
		event.move_object_sequence(0, -80.0, 0.0, 0.0, 50)
		event.move_object_sequence(0, -130.0, 0.0, 0.0, 20)
		event.set_object_sequence_motion(0, "走り")
		step = 3
		wait.for_frame_count(20)
		if is_map_display ~= 0 then
			event.set_dungeon_map_piece_moving(1)
		else
			event.fade_event_image(0, 1, 60)
		end
		if seal_flags ~= 0 then
			event.set_object_sequence_color(30, 128, 128, 128, 128, 60)
		end
		step = 4
		wait.for_frame_count(10)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.2, 10)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.8, 8)
		event.jump_object_sequence(1, 0.0, 0.0, 0.0, -0.4, 5)
		step = 5
		wait.for_frame_count(40)
		event.set_object_handle_footstep_sound(0, 6)
		step = 6
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		step = 7
		camera.wait_until_done()
		step = 8
		wait.for_frame_count(10)
		event.start_crossfade(30)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			rotation_y = out2 or rotation_y
		end
		event.set_camera_sequence_look_at(-175.0, 30.0, 0.0)
		event.set_camera_sequence_angle_height_distance(-rotation_y, 47.61, 160.0)
		event.show_dungeon_status_bar(1)
		event.set_object_sequence_position(0, -130.0, 0.0, 0.0)
		event.move_object_sequence(0, -175.0, 0.0, 0.0, 40)
		event.set_object_sequence_motion(0, "歩き")
		step = 9
		wait.for_frame_count(10)
		if is_map_display ~= 0 then
			event.fade_dungeon_map(0, 30)
		else
			event.fade_event_image(0, 0, 30)
		end
		if seal_flags ~= 0 then
			event.set_object_sequence_color(30, 128, 128, 128, 0, 30)
		end
		step = 10
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		step = 11
		wait.for_frame_count(10)
	end, function(received: { any }): boolean
		if step <= 1 then
			event_angle = vm.f32(event_angle + vm.f32(1.5707964))
			local _ = event_angle > vm.f32(3.1415927)
			event_angle = vm.f32(event_angle - vm.f32(6.2831855))
			wait.skip_frame_count(30)
		end
		if step <= 2 then
			wait.skip_frame_count(20)
		end
		if step <= 3 then
			wait.skip_frame_count(10)
		end
		if step <= 4 then
			wait.skip_frame_count(40)
		end
		if step <= 5 then
			cutscene.skip_command(0)
		end
		if step <= 6 then
			wait.background_load_skipping()
		end
		if step <= 7 then
			wait.skip_frame_count(10)
		end
		if step <= 8 then
			wait.skip_frame_count(10)
		end
		if step <= 9 then
			cutscene.skip_command(0)
		end
		if step <= 10 then
			wait.skip_frame_count(10)
		end
		return true
	end)
	step = 12
	vm.entry(12)
	event.cancel_drama_scene_skip()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, -1)
	event.fade_in_screen(0)
	event.show_dungeon_status_bar(1, 1.0)
	if is_map_display ~= 0 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	else
		event.delete_event_image(0)
	end
	if seal_flags ~= 0 then
		event.delete_event_image(1)
		event.set_event_sprite_draw_pass(0, 0)
	end
	event.stop_sound_effect(gate_sound_bank, 1)
	event.set_object_handle_position(0, -175.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_position(-15.0, 77.61, 0.13)
	event.set_camera_look_at(-175.0, 30.0, 0.0)
	event.reset_follow_camera(0)
	event.attach_object_handle_to_map_part_3(1, map_part, "d01w09_3-m0")
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.initialize_event()
	sound.load_event_sound_effects()
	if seal_flags ~= 0 then
		event.set_message_window_mode(0, 4)
		if bit32.band(seal_flags, 1) ~= 0 then
			event.open_message_window_2(0, "このフロアには『赤の封印』が\nかけられているようだ。")
			step = 13
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"赤のアトラミリアに選ばれた\n「ユリス」には、チェンジできない！"
			)
			step = 14
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 2) ~= 0 then
			event.open_message_window_2(0, "このフロアには『青の封印』が\nかけられているようだ。")
			step = 15
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"青のアトラミリアに選ばれた\n「モニカ」には、チェンジできない！"
			)
			step = 16
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		if bit32.band(seal_flags, 4) ~= 0 then
			event.open_message_window_2(0, "このフロアには『白の封印』が\nかけられているようだ。")
			step = 17
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "「体力、ステータス異常」を\n回復することができなくなった。")
			step = 18
			message.show_and_wait(0, -1, 8, 0, 0)
		end
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Loads the current dungeon floor, sending special floors to their own maps, and plays the matching entry cutscene.
local function start_dungeon_floor()
	local floor_number: s32 = 0
	local stage_id: s32 = 0
	local visit_count: s32 = 0
	local boss_room_flag: s32 = 0
	local floor_8_flag: s32 = 0
	local receiver_flag: s32 = 0
	local intro_flag: s32 = 0
	local previous_floor: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		minigame.clear_sphida_state()
		event.fade_out_screen(1)
		step = 1
		vm.wait(1)
		event.reset_action_character_motion(0)
		floor_number = event.get_dungeon_floor() or floor_number
		if floor_number == 20 then
			event.skip_next_music_load()
			event.load_dungeon_map("s51")
			event.load_event_script("s51/s51.stb", 500)
			return
		end
		if floor_number == 21 then
			event.skip_next_music_load()
			event.skip_next_map_sound_load()
			event.load_dungeon_map("s43")
			event.load_event_script("s43/s43.stb", 151)
			return
		end
		event.set_local_event_flag(0, 0)
		event.set_local_event_flag(1, 0)
		event.set_local_event_flag(2, 0)
		event.set_local_event_flag(3, 0)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor_number = event.get_dungeon_floor() or floor_number
		visit_count = event.get_dungeon_floor_info(stage_id, floor_number, 7) or visit_count
		dungeon.increment_floor_counter(stage_id, floor_number)
		event.initialize_dungeon_floor()
		if floor_number == 0 then
			event.set_current_map_number(55)
			event.go_to_georama_edit(22, 100)
			step = 2
			vm.wait(2)
			return
		end
		if floor_number == 4 then
			event.load_dungeon_map("s06")
			event.load_event_script("s06/s06.stb", 500)
			return
		end
		if floor_number == 7 then
			boss_room_flag = event.get_save_flag(110) or boss_room_flag
			if boss_room_flag == 0 then
				event.skip_next_music_load()
			end
			event.load_dungeon_map("d01b01")
			event.load_event_script("d01b01/d01b01.stb", 500)
			return
		end
		if floor_number == 8 then
			event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
			floor_8_flag = event.get_save_flag(201) or floor_8_flag
			if floor_8_flag == 0 then
				event.skip_next_music_load()
			end
			event.go_to_georama_edit(15, 100)
			return
		end
		if floor_number == 3 then
			receiver_flag = event.get_save_flag(102) or receiver_flag
			if receiver_flag == 0 then
				event.set_dungeon_pause_flags(2048, 1)
				event.stop_music(0)
				event.skip_next_music_play()
				event.go_to_georama_edit(41, 500)
				return
			end
		end
		if floor_number == 6 then
			event.allow_next_music_load()
			event.stop_music(0)
			step = 3
			wait.for_frame_count(6)
			event.load_music(37)
			event.play_music(0)
			event.skip_next_music_load()
		end
		event.set_dungeon_map_effect(0)
		event.load_dungeon_map("d01f01", "d01f01")
		event.load_dungeon_monster(0)
		event.place_treasure_box_at_event_point(-1)
		event.place_dungeon_monster(-1)
		intro_flag = event.get_save_flag(100) or intro_flag
		if floor_number == 1 and intro_flag == 0 then
			step = 4
			play_first_visit_intro()
		elseif floor_number == 1 and visit_count <= 0 then
			step = 5
			play_floor_entry_cutscene(0)
		else
			previous_floor = event.get_dungeon_previous_floor() or previous_floor
			if floor_number == previous_floor then
				step = 6
				play_floor_entry_cutscene(0)
			else
				step = 7
				play_floor_entry_cutscene(1)
			end
		end
		dungeon.show_floor_title()
		return
	end, function(received: { any })
		if step <= 1 then
			return 0
		end
		if step <= 2 then
			return 0
		end
		if step <= 7 then
			if step <= 3 then
				step = 4
				play_first_visit_intro()
				return vm.continue_with(function()
					dungeon.show_floor_title()
					return
				end)
			end
			if step <= 4 then
				step = 5
				play_floor_entry_cutscene(0)
				return vm.continue_with(function()
					dungeon.show_floor_title()
					return
				end)
			end
			if step <= 5 then
				step = 6
				play_floor_entry_cutscene(0)
				return vm.continue_with(function()
					dungeon.show_floor_title()
					return
				end)
			end
			if step <= 6 then
				step = 7
				play_floor_entry_cutscene(1)
				return vm.continue_with(function()
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

--- Opens the dungeon floor map, applies the floor and previous floor it returns and starts that floor.
local function select_floor_from_map()
	local music_number: s32 = 0
	local previous_floor: s32 = 0
	local selected_floor: s32 = 0
	event.initialize_event()
	event.initialize_sphida()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 15 then
		event.stop_music(0)
		wait.for_frame_count(6)
		event.load_music(15)
	end
	event.play_music(0)
	event.load_map_sounds(1601)
	event.open_dungeon_floor_map(0)
	vm.wait(2)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		previous_floor = out2 or previous_floor
		selected_floor = out3 or selected_floor
	end
	event.set_dungeon_floor(selected_floor)
	event.set_dungeon_previous_floor(previous_floor)
	start_dungeon_floor()
end

--- Raises the gate with its key item the first time and afterwards asks whether to leave the floor through it.
local function operate_water_gate(index: s32)
	local is_gate_raised: s32 = 0
	local trigger_mode: s32 = 0
	local confirmed: s32 = 0
	local used_item: s32 = 0
	local playable_character: s32 = 0
	local choice: any = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local stage_id: s32 = 0
	local current_floor: s32 = 0
	local next_floor: s32 = 0
	local save_flag: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	is_gate_raised = event.get_local_event_flag(index) or is_gate_raised
	event.set_dungeon_pause_flags(1, 1)
	if is_gate_raised == 0 then
		trigger_mode = event.get_triggered_event_data_2(6) or trigger_mode
		if trigger_mode == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.set_message_draw_speed(0, 1)
			confirmed = message.ask_confirmation(0, 0, 5, 256, 208, confirmed)
			event.set_message_bubble_tail(0, 1)
			event.set_message_draw_speed(0, 0)
			if confirmed == 1 then
				trigger_mode = 2
			end
			event.finish_event()
		end
		if trigger_mode == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait.for_frame_count(6)
			event.open_use_item_menu(337)
			vm.wait(3)
			used_item = vmhost.used_item() or used_item
			if used_item == 337 then
				event.set_local_event_flag(index, 1)
				underground_water_channel.raise_gate()
			elseif used_item <= 0 then
				event.finish_event()
			else
				character.shake_head()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
			wait.for_frame_count(6)
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
			walk_to_gate()
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
			current_floor = event.get_dungeon_floor() or current_floor
			next_floor = event.get_dungeon_next_floor(current_floor, 0) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, current_floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			event.finish_dungeon_floor()
			if current_floor == 1 then
				save_flag = event.get_save_flag(101) or save_flag
				if save_flag == 0 then
					event.set_dungeon_pause_flags(2048, 1)
					event.skip_next_music_load()
					event.skip_next_map_sound_load()
					event.go_to_georama_edit(43, 151)
					vm.wait(13)
					return
				end
			end
			if current_floor == 5 then
				save_flag = event.get_save_flag(9) or save_flag
				if save_flag == 0 then
					event.set_dungeon_pause_flags(2048, 1)
					event.fade_out_music(30)
					wait.for_frame_count(30)
					event.skip_next_music_load()
					event.set_save_flag(9, 1)
					event.skip_villager_loading()
					event.go_to_georama_edit(38, 510)
					vm.wait(15)
					return
				end
			end
			event.finish_event()
			select_floor_from_map()
		else
			event.finish_event()
		end
	end
	event.set_dungeon_pause_flags(1, 0)
end

--- Plays the flash of light and the receiver conversation in which Mints is told how to clear the floor.
local function play_receiver_dialogue(se_id: s32)
	event.set_camera_sequence_position(-151.46, 20.36, 7.26)
	event.set_camera_sequence_look_at(-125.08, 23.15, -0.98)
	event.set_object_sequence_position(0, -123.65, -0.41, -1.34)
	event.set_object_sequence_rotation(0, 0.0, -1.53, 0.0)
	event.fade_out_screen(0, 255, 255, 255)
	event.play_sound_effect(se_id, 0)
	wait.for_frame_count(30)
	event.fade_in_camera_sequence(30, 255.0, 255.0, 255.0)
	camera.wait_until_done()
	event.stop_sound_effect(se_id, 0)
	event.set_object_sequence_motion(0, "我に返る", 6)
	event.set_object_sequence_texture_animation(0, 1, "ぱちぱち")
	event.set_object_sequence_texture_animation(0, 1, "はっとする")
	message.show_voiced(1020050)
	event.open_voice_stream_wave(1, 1020055)
	sound.wait_voice_stream_ready(1)
	event.play_voice_stream(1)
	wait.for_frame_count(45)
	event.close_voice_stream(1)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "無表情")
	event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
	event.set_character_active(1, 8)
	event.set_object_sequence_motion(0, "レシーバーを取り出す", 6)
	event.queue_object_sequence_next_motion(0, "レシーバーを取り出すL")
	object.wait_until_done(0)
	message.show_voiced(1020060)
	event.set_object_sequence_motion(0, "耳に当てる", 6)
	event.queue_object_sequence_next_motion(0, "レシーバーキョロキョロ", 6)
	event.queue_object_sequence_next_motion(0, "レシーバー立ち")
	wait.until_motion_progress(0, vm.f32(0.356), -1.0, 41)
	event.stop_sound_effect(se_id, 0)
	event.play_sound_effect(se_id, 2)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1020070)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
	message.show_voiced(1020080)
	event.set_object_sequence_motion(0, "うなづく(レシーバー)", 6)
	event.queue_object_sequence_next_motion(0, "レシーバー立ち")
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1020090)
	event.reset_mouth_texture_animations()
	message.show_voiced(1020100)
	message.show_voiced(1020101)
	message.show_voiced(1020110)
	message.show_voiced(1020111)
	message.show_voiced(1020120)
	message.show_voiced(1020121)
	message.show_voiced(1020130)
	event.set_object_sequence_motion(0, "うなづく(レシーバー)", 6)
	event.queue_object_sequence_next_motion(0, "レシーバー立ち")
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1020140)
	event.reset_mouth_texture_animations()
	message.show_voiced(1020150)
	event.set_object_sequence_motion(0, "レシーバーをなおす", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	wait.until_motion_progress(0, 0.25, -1.0, 90)
	event.play_sound_effect(se_id, 3)
	wait.until_motion_progress(0, vm.f32(0.637), -1.0, 90)
	event.play_sound_effect(se_id, 4)
	wait.until_motion_finished(0)
	event.fade_out_screen(30)
	object.wait_until_done(0)
end

--- Sets up the character and receiver, then plays the skippable receiver conversation on the first floor.
local function play_receiver_cutscene()
	local receiver_sound_bank: s32 = 0
	local event_x: f32 = 0
	local event_y: f32 = 0
	local event_z: f32 = 0
	local event_angle: f32 = 0
	vm.section(function()
		event.set_save_flag(102, 1)
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		event.set_message_window_mode(0, 7)
		receiver_sound_bank = event.load_sound_effect_file_2(1807) or receiver_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			event_x = out1 or event_x
			event_y = out2 or event_y
			event_z = out3 or event_z
			event_angle = out4 or event_angle
		end
		event_angle = vm.f32(event_angle + vm.f32(1.5707964))
		if event_angle > vm.f32(3.1415927) then
			event_angle = vm.f32(event_angle - vm.f32(6.2831855))
		end
		event.set_event_world_coordinate(event_x, event_y, event_z, event_angle)
		event.load_character_motion_pack(5, "event/e100/e102/e102_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 130.0, 100.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.load_item_model(5, 359, "info", 8)
		event.set_character_active(0, 8)
		event.attach_character_to_frame(0, "ef00", 8)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.load_message_file(0, 5, "event/e100/e102/e102.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.fade_out_screen(0, 128, 128, 128)
		vm.wait(1)
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		play_receiver_dialogue(receiver_sound_bank)
	end)
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	sound.load_event_sound_effects()
	event.stop_sound_effect(receiver_sound_bank, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_dungeon_pause_flags(1, 0)
	event.set_object_handle_position(0, -175.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_camera_position(-15.0, 77.61, 0.13)
	event.set_camera_look_at(-175.0, 30.0, 0.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Plays the victory sequence when every monster is defeated, records the clear, announces medal rewards and broken seals, then offers moving to the Sphida ball.
local function clear_floor()
	local playable_character: s32 = 0
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	local unassigned_flag: s32 = 0
	local sub_game_flag: s32 = 0
	local sub_game_mask: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local record_status: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local is_trial_version: s32 = 0
	local seal_flags: s32 = 0
	local step: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		character.reset_action_motion()
		event.set_dungeon_pause_flags(512, 1)
		event.show_dungeon_status_bar(0, 0.16666667)
		step = 1
		wait.for_frame_count(10)
		event.set_dungeon_pause_flags(16384, 1)
		event.clear_event_battle_monsters(-1)
		if playable_character == 0 then
			step = 2
			dungeon_finish.play_victory_pose(1)
		end
		if playable_character == 1 then
			step = 3
			dungeon_victory.play_victory_finish(1)
		end
		if playable_character == 2 or playable_character == 3 then
			step = 4
			dungeon_finish.show_finish_banner(playable_character)
		end
		event.set_dungeon_pause_flags(16384, 0)
		underground_water_channel.restore_opened_key_door()
		event.reset_action_character_motion(0, 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.show_dungeon_status_bar(1, 0.16666667)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor_number = event.get_dungeon_floor() or floor_number
		event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
		event.set_dungeon_floor_info(stage_id, floor_number, 5, 1024)
		sub_game_flag = event.get_save_flag(220) or sub_game_flag
		sub_game_flag = event.get_save_flag(317) or sub_game_flag
		sub_game_mask = event.get_floor_sub_games() or sub_game_mask
		if (if sub_game_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
			event.clear_random_stones()
			sphida_setup.load_course(0, -1)
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
		record_status = event.record_floor_clear_time() or record_status
		do
			local out1, out2 = event.get_floor_practice_result(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		step = 5
		spheda.announce_medal_reward(record_status, cleared, bonus)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		is_trial_version = event.is_trial_version() or is_trial_version
		if is_trial_version ~= 1 then
			if unassigned_flag == 1 and sub_game_flag == 1 and bit32.band(sub_game_mask, 3) == 3 then
				step = 6
				message.show_and_wait(0, 2120, 8, 0, 0)
			else
				if (if unassigned_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
					step = 7
					message.show_and_wait(0, 2110, 8, 0, 0)
				end
				if (if sub_game_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
					step = 8
					message.show_and_wait(0, 2100, 8, 0, 0)
				end
			end
		end
		seal_flags = event.get_dungeon_floor_status() or seal_flags
		if
			(if (if bit32.band(seal_flags, 1) ~= 0 then 1 else bit32.band(seal_flags, 2)) ~= 0 then 1 else bit32.band(seal_flags, 4))
			~= 0
		then
			event.set_dungeon_floor_status_flags(7, 0)
			if bit32.band(seal_flags, 1) ~= 0 then
				event.open_message_window_2(0, "『赤の封印』が解けました。")
			end
			if bit32.band(seal_flags, 2) ~= 0 then
				event.open_message_window_2(0, "『青の封印』が解けました。")
			end
			if bit32.band(seal_flags, 4) ~= 0 then
				event.open_message_window_2(0, "『白の封印』が解けました。")
			end
			step = 9
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		step = 10
		message.show_and_wait(0, 2130, 8, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(512, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if step <= 10 then
			if step <= 1 then
				step = 2
				dungeon_finish.play_victory_pose(1)
				return vm.continue_with(function()
					if playable_character == 1 then
						step = 3
						dungeon_victory.play_victory_finish(1)
					end
					if playable_character == 2 or playable_character == 3 then
						step = 4
						dungeon_finish.show_finish_banner(playable_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					underground_water_channel.restore_opened_key_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor_number = event.get_dungeon_floor() or floor_number
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 1024)
					sub_game_flag = event.get_save_flag(220) or sub_game_flag
					sub_game_flag = event.get_save_flag(317) or sub_game_flag
					sub_game_mask = event.get_floor_sub_games() or sub_game_mask
					if (if sub_game_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
						event.clear_random_stones()
						sphida_setup.load_course(0, -1)
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
					record_status = event.record_floor_clear_time() or record_status
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					step = 5
					spheda.announce_medal_reward(record_status, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial_version = event.is_trial_version() or is_trial_version
					if is_trial_version ~= 1 then
						if unassigned_flag == 1 and sub_game_flag == 1 and bit32.band(sub_game_mask, 3) == 3 then
							step = 6
							message.show_and_wait(0, 2120, 8, 0, 0)
						else
							if (if unassigned_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
								step = 7
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if sub_game_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
								step = 8
								message.show_and_wait(0, 2100, 8, 0, 0)
							end
						end
					end
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
							event.open_message_window_2(0, "『赤の封印』が解けました。")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "『青の封印』が解けました。")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "『白の封印』が解けました。")
						end
						step = 9
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					step = 10
					message.show_and_wait(0, 2130, 8, 0, 0)
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if step <= 2 then
				step = 3
				dungeon_victory.play_victory_finish(1)
				return vm.continue_with(function()
					if playable_character == 2 or playable_character == 3 then
						step = 4
						dungeon_finish.show_finish_banner(playable_character)
					end
					event.set_dungeon_pause_flags(16384, 0)
					underground_water_channel.restore_opened_key_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor_number = event.get_dungeon_floor() or floor_number
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 1024)
					sub_game_flag = event.get_save_flag(220) or sub_game_flag
					sub_game_flag = event.get_save_flag(317) or sub_game_flag
					sub_game_mask = event.get_floor_sub_games() or sub_game_mask
					if (if sub_game_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
						event.clear_random_stones()
						sphida_setup.load_course(0, -1)
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
					record_status = event.record_floor_clear_time() or record_status
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					step = 5
					spheda.announce_medal_reward(record_status, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial_version = event.is_trial_version() or is_trial_version
					if is_trial_version ~= 1 then
						if unassigned_flag == 1 and sub_game_flag == 1 and bit32.band(sub_game_mask, 3) == 3 then
							step = 6
							message.show_and_wait(0, 2120, 8, 0, 0)
						else
							if (if unassigned_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
								step = 7
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if sub_game_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
								step = 8
								message.show_and_wait(0, 2100, 8, 0, 0)
							end
						end
					end
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
							event.open_message_window_2(0, "『赤の封印』が解けました。")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "『青の封印』が解けました。")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "『白の封印』が解けました。")
						end
						step = 9
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					step = 10
					message.show_and_wait(0, 2130, 8, 0, 0)
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if step <= 3 then
				step = 4
				dungeon_finish.show_finish_banner(playable_character)
				return vm.continue_with(function()
					event.set_dungeon_pause_flags(16384, 0)
					underground_water_channel.restore_opened_key_door()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					floor_number = event.get_dungeon_floor() or floor_number
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
					event.set_dungeon_floor_info(stage_id, floor_number, 5, 1024)
					sub_game_flag = event.get_save_flag(220) or sub_game_flag
					sub_game_flag = event.get_save_flag(317) or sub_game_flag
					sub_game_mask = event.get_floor_sub_games() or sub_game_mask
					if (if sub_game_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
						event.clear_random_stones()
						sphida_setup.load_course(0, -1)
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
					record_status = event.record_floor_clear_time() or record_status
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					step = 5
					spheda.announce_medal_reward(record_status, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					is_trial_version = event.is_trial_version() or is_trial_version
					if is_trial_version ~= 1 then
						if unassigned_flag == 1 and sub_game_flag == 1 and bit32.band(sub_game_mask, 3) == 3 then
							step = 6
							message.show_and_wait(0, 2120, 8, 0, 0)
						else
							if (if unassigned_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
								step = 7
								message.show_and_wait(0, 2110, 8, 0, 0)
							end
							if (if sub_game_flag == 1 then bit32.band(sub_game_mask, 1) else 0) ~= 0 then
								step = 8
								message.show_and_wait(0, 2100, 8, 0, 0)
							end
						end
					end
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
							event.open_message_window_2(0, "『赤の封印』が解けました。")
						end
						if bit32.band(seal_flags, 2) ~= 0 then
							event.open_message_window_2(0, "『青の封印』が解けました。")
						end
						if bit32.band(seal_flags, 4) ~= 0 then
							event.open_message_window_2(0, "『白の封印』が解けました。")
						end
						step = 9
						message.show_and_wait(0, -1, 8, 0, 0)
					end
					step = 10
					message.show_and_wait(0, 2130, 8, 0, 0)
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if step <= 4 then
				cutscene.noop_2()
				cutscene.noop_with_arguments(0, -1)
				message.resume_numbered_messages(record_status, cleared, bonus)
			end
			if step <= 5 then
				message.show_and_wait_skipping(0, 2120, 8, 0, 0)
			end
			if step <= 6 then
				message.show_and_wait_skipping(0, 2110, 8, 0, 0)
			end
			if step <= 7 then
				message.show_and_wait_skipping(0, 2100, 8, 0, 0)
			end
			if step <= 8 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if step <= 9 then
				message.show_and_wait_skipping(0, 2130, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script is loaded.
function script.setup() end

--- Plays the Max victory sequence when no event number is given.
function script.default_event()
	dungeon_finish.play_victory_pose(0)
end

--- Gives the Sphida items if the player lacks them, sets the Sphida save flags and clears the battle monsters.
function script.grant_sphida_equipment()
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
script[200] = script.grant_sphida_equipment

--- Runs the gate interaction for the first gate.
function script.examine_water_gate()
	operate_water_gate(0)
end
script[300] = script.examine_water_gate

--- Opens the key door automatically for the party companion, or asks the player to use the key item on it.
function script.examine_key_door()
	local party_npc_id: s32 = 0
	local trigger_mode: s32 = 0
	local confirmed: s32 = 0
	local used_item: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 1)
	character.reset_action_motion()
	party_npc_id = event.get_party_npc() or party_npc_id
	if party_npc_id == 4 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "ドニー「ここを通れるようにすればいいんだな？」")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.open_message_window_2(0, "ドニー「よっと！」")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.show_dungeon_status_bar(0, 0.16666667)
		underground_water_channel.open_key_door()
		event.show_dungeon_status_bar(1, 0.16666667)
		wait.for_frame_count(6)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	trigger_mode = event.get_triggered_event_data_2(6) or trigger_mode
	if trigger_mode == 1 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_draw_speed(0, 1)
		confirmed = message.ask_confirmation(0, 2500, 5, 256, 208, confirmed)
		event.set_message_bubble_tail(0, 1)
		event.set_message_draw_speed(0, 0)
		if confirmed == 1 then
			trigger_mode = 2
		end
	end
	if trigger_mode == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait.for_frame_count(6)
		event.open_use_item_menu(338)
		vm.wait(7)
		used_item = vmhost.used_item() or used_item
		if used_item == 338 then
			underground_water_channel.open_key_door()
		elseif used_item <= 0 then
		else
			character.shake_head()
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		wait.for_frame_count(6)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end
script[348] = script.examine_key_door

--- Loads the dungeon floor, plays the receiver cutscene and shows the floor title.
function script.enter_floor_with_receiver_cutscene()
	event.initialize_event()
	event.load_dungeon_map("d01f01", "d01f01")
	event.load_dungeon_monster(0)
	event.place_treasure_box_at_event_point(-1)
	event.place_dungeon_monster(-1)
	play_receiver_cutscene()
	dungeon.show_floor_title()
end
script[500] = script.enter_floor_with_receiver_cutscene

--- Fades out and loads the s06 map with its entry event.
function script.leave_for_s06()
	event.initialize_event()
	event.clear_camera_sequence()
	event.fade_out_screen(0)
	event.skip_next_music_play()
	event.load_dungeon_map("s06")
	event.load_event_script("s06/s06.stb", 500)
	vm.wait(1)
end
script[520] = script.leave_for_s06

script.select_floor_from_map = select_floor_from_map
script[1000] = script.select_floor_from_map

script.start_dungeon_floor = start_dungeon_floor
script[1010] = script.start_dungeon_floor

--- The dungeon system event run when the player opens a treasure box.
script.treasure_box = treasure_box.open_nearest

--- Spins a coin over a random circle, stops it on a button press and applies the good or bad circle effect with its messages, or pushes the player aside when playing a companion character.
function script.random_circle()
	local playable_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local push_angle: f32 = 0
	local ring_x: f32 = 0
	local ring_y: f32 = 0
	local ring_z: f32 = 0
	local sound_bank: s32 = 0
	local motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local party_npc_id: s32 = 0
	local coin_side: s32 = 0
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
	local random_roll: s32 = 0
	local chance_threshold: s32 = 0
	local brightness_rate: f32 = 0
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
		push_angle = event.get_direction_angle(circle_x, circle_y, circle_z, player_x, player_y, player_z) or push_angle
		player_x = vm.f32(vm.f32(vm.sin(push_angle) * 25.0) + circle_x)
		player_y = circle_y
		player_z = vm.f32(vm.f32(vm.cos(push_angle) * 25.0) + circle_z)
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
	party_npc_id = event.get_party_npc() or party_npc_id
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
			minigame.show_stop_hint()
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
				coin_side = 0
				break
			end
			target_angle = vm.f32(facing_angle - vm.f32(3.1415927))
			target_angle = event.wrap_angle(target_angle) or target_angle
			if coin_angle < target_angle and calc.is_angle_within(coin_angle, target_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, target_angle, 0.0)
				coin_side = 1
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
		coin_side = 0
	else
		coin_side = 1
	end
	facing_angle = coin_angle
	wait.for_frame_count(20)
	random_roll = event.get_random_number_int(10) or random_roll
	if party_npc_id == 24 then
		chance_threshold = 100
	else
		chance_threshold = 6
	end
	if random_roll < chance_threshold then
		random_roll = event.get_random_number_int(10) or random_roll
		if coin_side == 0 then
			if party_npc_id == 24 then
				chance_threshold = 0
			else
				chance_threshold = 2
			end
		elseif party_npc_id == 24 then
			chance_threshold = 100
		else
			chance_threshold = 4
		end
		if random_roll < chance_threshold then
			facing_angle = vm.f32(facing_angle + vm.f32(3.14))
			facing_angle = event.wrap_angle(facing_angle) or facing_angle
			event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 8)
			if coin_side == 0 then
				coin_side = 1
			else
				coin_side = 0
			end
			wait.for_frame_count(10)
		else
			random_roll = event.get_random_number_int(10) or random_roll
			if random_roll < 1 then
				facing_angle = vm.f32(facing_angle + vm.f32(3.14))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 6)
				facing_angle = vm.f32(facing_angle + vm.f32(1.57))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 3)
				facing_angle = vm.f32(facing_angle + vm.f32(1.57))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 3)
				wait.for_frame_count(20)
			end
		end
	end
	facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, facing_angle, 1.0) == 0 then
		coin_side = 0
	else
		coin_side = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness_rate = 1.0
	frame_count = 0
	effect_id = event.get_random_circle_effect(coin_side) or effect_id
	if coin_side == 0 then
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
			event.place_treasure_box(ring_x, ring_y, ring_z, facing_angle, 294)
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

--- Plays the scene of the playable character taking the geostone and shows its message.
function script.geostone()
	local playable_character: s32 = 0
	local saved_x: f32 = 0
	local saved_y: f32 = 0
	local saved_z: f32 = 0
	local sound_bank: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local stand_x: f32 = 0
	local stand_y: f32 = 0
	local stand_z: f32 = 0
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
		saved_x = out1 or saved_x
		saved_y = out2 or saved_y
		saved_z = out3 or saved_z
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
		stand_x = out1 or stand_x
		stand_y = out2 or stand_y
		stand_z = out3 or stand_z
	end
	event.copy_vector(stand_x, stand_y, stand_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		geostone_x = out1 or geostone_x
		geostone_y = out2 or geostone_y
		geostone_z = out3 or geostone_z
	end
	geostone_y = vm.f32(stand_y + 18.0)
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
	stand_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + geostone_x)
	stand_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + geostone_z)
	event.set_character_position(0, stand_x, stand_y, stand_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if playable_character == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(stand_x, stand_y + 18.0, stand_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, stand_x, stand_y + 36.0, stand_z)
	end
	if playable_character == 1 then
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
	wait.for_frame_count(16)
	event.play_sound_effect(sound_bank, 0)
	wait.for_frame_count(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait.for_frame_count(10)
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
	wait.for_frame_count(20)
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
	floor_number = event.get_dungeon_floor() or floor_number
	event.set_dungeon_floor_info(stage_id, floor_number, 5, 256)
	event.start_crossfade(10)
	if playable_character == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(529, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, saved_x, saved_y, saved_z)
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

--- Runs the defeat sequence without a message.
function script.on_player_defeated()
	dungeon.run_defeat_sequence_silent(0)
end
script[1200] = script.on_player_defeated

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = clear_floor

--- Event 2000, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, overriding the default event.
function script.do_nothing() end
script[2000] = script.do_nothing

--- Shows the random stone tutorial message and records it as seen.
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
	wait.for_frame_count(30)
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

--- Shows the level up tutorial messages.
function script.level_up_guide()
	local answer: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.open(0, 2620, 8, 0, 0)
	wait.for_frame_count(30)
	do
		local _: any
		_, answer = message.wait_answer(0, 0, answer)
	end
	message.close(0)
	message.show_and_wait(0, 2621, 8, 0, 0)
	message.show_and_wait(0, 2622, 8, 0, 0)
	message.show_and_wait(0, 2623, 8, 0, 0)
	event.open_message_window_2(0, "詳しくは、メインメニューの\n『ヘルプ』を参照してください。")
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Shows the ridepod buggy driving controls tutorial.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]「バギー」パーツでの移動方法\n   (L)↑で加速、(L)↓で減速。\n   (L)←→でハンドル、[l1]＋(L)←→でクイックターン。"
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
	event.open_message_window_2(0, "[(!)]「吸収魔法剣」を使えるようになった。")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"「吸収魔法剣」とは、炎などの属性を持った攻撃を\nガードすることによって吸収し、剣の振りと共に\n魔法として放出する技です。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"同じ属性なら連続して吸収することが可能で\n途中一度でも違う属性を吸収すると\nそれまで吸収した属性は無効になります。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"一度に吸収できる量は装備している\n武器の耐久力によって変化します。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"吸収した属性を魔法として放つには、\n[r1]でガード中に[l1]を押して放出します。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Aims and takes a Sphida shot, simulates the ball's flight, bounces and hazards, and handles holing out, going out of bounds and the prize.
function script.sphida_shot()
	local texture_bank: s32 = 0
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
	local launch_angle: f32 = 0
	local shot_power: f32 = 0
	local club_spin_factor: f32 = 0
	local shot_quality: s32 = 0
	local drift_x: f32 = 0
	local curve_amount: f32 = 0
	local drift_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local is_pin_hit: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local out_of_bounds_counter: s32 = 0
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
	local vector_length: f32 = 0
	local collision_index: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local frame_count: s32 = 0
	local pin_distance: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local pin_segment_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_angle: f32 = 0
	local par_remaining: s32 = 0
	local relocate_choice: any = 0
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
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	ball_x, ball_y, ball_z, aim_angle = minigame.set_up_sphida_shot(ball_x, ball_y, ball_z, aim_angle)
	camera.place_behind_player(aim_angle)
	event.set_sphida_status_panel_visible(1)
	launch_angle = 12.5
	event.set_sphida_carry_angle(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power, club_spin_factor, shot_quality = minigame.get_equipped_club_definition(shot_power, club_spin_factor, shot_quality)
	event.set_sphida_power_gauge_safe_level(shot_quality)
	do
		local out1, out2, out3 = event.zero_vector()
		drift_x = out1 or drift_x
		curve_amount = out2 or curve_amount
		drift_z = out3 or drift_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local aim_cancelled: s32
		aim_cancelled, aim_angle, launch_angle = minigame.aim_sphida_shot(aim_angle, launch_angle, texture_bank)
		if aim_cancelled ~= 0 then
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
		local gauge_cancelled: s32
		gauge_cancelled, shot_power, aim_angle, curve_amount, drift_x, shot_quality = minigame.run_sphida_power_gauge_with_extra_frame(shot_power, texture_bank, aim_angle, curve_amount, drift_x, sound_bank, shot_quality)
		if gauge_cancelled == 0 then
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
	is_pin_hit = 0
	if shot_quality ~= 1 and shot_quality ~= -1 and shot_quality ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if shot_quality == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if shot_quality == 2 or shot_quality == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if shot_quality == 3 or shot_quality == -3 then
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
		if shot_quality ~= 4 then
			event.play_sound_effect(sound_bank, 3)
		end
	elseif shot_power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.for_frame_count(34)
		event.play_sound_effect(sound_bank, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.for_frame_count(39)
		if shot_quality == 0 then
			event.play_sound_effect(sound_bank, 12)
		else
			event.play_sound_effect(sound_bank, 1)
		end
	end
	if shot_quality == 4 then
		wait.for_frame_count(50)
		minigame.consume_sphida_shot(sound_bank)
		event.set_sphida_ball_position(start_x, start_y, start_z)
		event.set_character_position(8, start_x, start_y, start_z)
		event.set_character_position(9, start_x, start_y, start_z)
		minigame.finish_sphida_round(0)
		return
	end
	if shot_quality == 0 then
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
	drift_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_spin_factor) * drift_x) * vm.f32(0.4))
	drift_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_spin_factor) * drift_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	out_of_bounds_counter = 0
	shot_quality = 0
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
	frame_count = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (frame_count + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_index = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_index
			if shot_quality == 1 and collision_index >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (frame_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + drift_x)
				velocity_z = vm.f32(velocity_z + drift_z)
				drift_x = vm.f32(drift_x * vm.f32(0.8))
				drift_z = vm.f32(drift_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (frame_count + 1)))
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
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(launch_angle) / 10.0) * club_spin_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(launch_angle) / 10.0) * club_spin_factor))
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
			vector_length = event.get_vector_length(velocity_x, 0.0, velocity_z) or vector_length
			if vector_length < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				shot_quality = 1
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
					out_of_bounds_counter = 1
					break
				end
				surface_type = event.get_automap_attribute_status(ball_x, ball_y, ball_z) or surface_type
				if not (surface_type == 1) then
					break
				end
				out_of_bounds_counter = 1
				break
			end
		end
		if ball_y < -500.0 then
			out_of_bounds_counter = 1
			break
		elseif frame_count >= 480 then
			out_of_bounds_counter = 1
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
					is_pin_hit = 1
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
					is_pin_hit = 1
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
				if out_of_bounds_counter >= 30 then
					if out_of_bounds_counter >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				out_of_bounds_counter = out_of_bounds_counter + 1
			elseif frame_count >= 20 then
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
			frame_count = frame_count + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if out_of_bounds_counter == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		par_remaining = event.get_sphida_par() or par_remaining
		if is_pin_hit == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_bank, 17)
			frame_count = 0
			while frame_count < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_count = frame_count + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			frame_count = 0
			while frame_count < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_count = frame_count + 1
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
			wait.for_frame_count(90)
			vm.wait(22)
			event.play_music(0)
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		elseif par_remaining >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			relocate_choice = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(24)
			if relocate_choice == 0 then
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
						collision_index = out4 or collision_index
					end
					frame_count = 0
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
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(start_x, start_y, start_z)
							hit_x = out1 or hit_x
							hit_y = out2 or hit_y
							hit_z = out3 or hit_z
							collision_index = out4 or collision_index
						end
						frame_count = frame_count + 1
						if frame_count > 6 then
							break
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
		wait.for_frame_count(20)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_sphida_ball_position(start_x, start_y, start_z)
		event.set_character_position(8, start_x, start_y, start_z)
		event.set_character_position(9, start_x, start_y, start_z)
		event.release_camera_sequence_follow_object()
	end
	if is_pin_hit == 1 then
		minigame.consume_sphida_shot(-1)
	else
		minigame.consume_sphida_shot(sound_bank)
	end
	minigame.finish_sphida_round(is_pin_hit)
end

--- Asks whether to move the Sphida ball to the player and moves it if confirmed.
function script.sphida_near_ball()
	local choice: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	choice = message.ask_choice(0, 2004, 8, 0, 0, 2, 1)
	if choice == 0 then
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

--- Warns that this is the last time the Sphida ball can be moved to the player and moves it if confirmed.
function script.sphida_near_ball_last()
	local choice: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "スフィアを足元へ移動できるのは\nこれが最後になります。")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "スフィアを足元へ移動しますか？")
	choice = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
	if choice == 0 then
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

--- Switches to the main character and loads the boss room.
function script.enter_boss_room()
	event.initialize_event()
	event.fade_out_screen(0)
	event.set_playable_character(0)
	event.skip_next_music_load()
	event.set_save_flag(10, 0)
	event.load_dungeon_map("d01b01")
	event.load_event_script("d01b01/d01b01.stb", 500)
	vm.wait(1)
end
script[5000] = script.enter_boss_room

--- Leaves Sphida and loads the s43 map at its event 8000.
function script.leave_sphida_to_s43_event_8000()
	minigame.leave_sphida()
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	event.load_dungeon_map("s43")
	event.load_event_script("s43/s43.stb", 8000)
end
script[10030] = script.leave_sphida_to_s43_event_8000

--- Leaves Sphida and loads the s43 map at its event 8001.
function script.leave_sphida_to_s43_event_8001()
	minigame.leave_sphida()
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	event.load_dungeon_map("s43")
	event.load_event_script("s43/s43.stb", 8001)
end
script[10040] = script.leave_sphida_to_s43_event_8001

--- Leaves Sphida and loads the s43 map at its event 8002.
function script.leave_sphida_to_s43_event_8002()
	minigame.leave_sphida()
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	event.load_dungeon_map("s43")
	event.load_event_script("s43/s43.stb", 8002)
end
script[10050] = script.leave_sphida_to_s43_event_8002

--- Leaves Sphida, stops the music and loads the s51 map.
function script.leave_sphida_to_s51()
	minigame.leave_sphida()
	event.stop_music(0)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	event.load_dungeon_map("s51")
	event.load_event_script("s51/s51.stb", 10500)
end
script[10500] = script.leave_sphida_to_s51

--- Leaves Sphida, reloads the floor and plays the first visit intro.
function script.leave_sphida_to_floor_intro()
	local step: number = 0
	return vm.guard(function()
		step = 1
		minigame.leave_sphida()
		event.load_dungeon_map("d01f01", "d01f01")
		step = 2
		play_first_visit_intro()
		event.finish_event()
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				step = 2
				play_first_visit_intro()
				return vm.continue_with(function()
					event.finish_event()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[11000] = script.leave_sphida_to_floor_intro

--- Leaves Sphida and loads the s06 map with the s06b entry event.
function script.leave_sphida_to_s06b_entry()
	event.set_save_data_value(0, 3)
	minigame.leave_sphida()
	event.load_dungeon_map("s06")
	vm.wait(2)
	event.load_event_script("s06/s06b.stb", 500)
end
script[11030] = script.leave_sphida_to_s06b_entry

--- Leaves Sphida and loads the s06 map with the s06c entry event.
function script.leave_sphida_to_s06c_entry()
	event.set_save_data_value(0, 3)
	minigame.leave_sphida()
	event.load_dungeon_map("s06")
	vm.wait(2)
	event.load_event_script("s06/s06c.stb", 500)
end
script[11040] = script.leave_sphida_to_s06c_entry

--- Leaves Sphida and loads the s06 map with the s06b event 510.
function script.leave_sphida_to_s06b_event_510()
	event.set_save_data_value(0, 3)
	minigame.leave_sphida()
	event.load_dungeon_map("s06")
	vm.wait(2)
	event.load_event_script("s06/s06b.stb", 510)
end
script[11070] = script.leave_sphida_to_s06b_event_510

--- Leaves Sphida and loads the s06 map at its event 11081.
function script.leave_sphida_to_s06_event_11081()
	event.set_save_data_value(0, 3)
	minigame.leave_sphida()
	event.load_dungeon_map("s06")
	vm.wait(2)
	event.load_event_script("s06/s06.stb", 11081)
end
script[11081] = script.leave_sphida_to_s06_event_11081

--- Leaves Sphida and loads the s06 map at its event 11082.
function script.leave_sphida_to_s06_event_11082()
	event.set_save_data_value(0, 3)
	minigame.leave_sphida()
	event.load_dungeon_map("s06")
	vm.wait(2)
	event.load_event_script("s06/s06.stb", 11082)
end
script[11082] = script.leave_sphida_to_s06_event_11082

--- Leaves Sphida, clears the boss room flag and loads the boss room at its entry event.
function script.leave_sphida_to_boss_room()
	minigame.leave_sphida()
	event.set_save_flag(10, 0)
	event.skip_next_music_load()
	event.load_dungeon_map("d01b01")
	event.load_event_script("d01b01/d01b01.stb", 500)
	event.finish_event()
end
script[11100] = script.leave_sphida_to_boss_room

--- Leaves Sphida and loads the boss room at its event 600.
function script.leave_sphida_to_boss_room_event_600()
	minigame.leave_sphida()
	event.load_dungeon_map("d01b01")
	event.load_event_script("d01b01/d01b01.stb", 600)
	event.finish_event()
end
script[11110] = script.leave_sphida_to_boss_room_event_600

--- Leaves Sphida and loads the s06 map at its event 21010.
function script.leave_sphida_to_s06_event_21010()
	minigame.leave_sphida()
	event.skip_next_music_load()
	event.load_dungeon_map("s06")
	event.load_event_script("s06/s06.stb", 21010)
	event.finish_event()
end
script[21010] = script.leave_sphida_to_s06_event_21010

--- Leaves Sphida and loads the boss room at its event 21020.
function script.leave_sphida_to_boss_room_event_21020()
	minigame.leave_sphida()
	event.skip_next_music_load()
	event.load_dungeon_map("d01b01")
	event.load_event_script("d01b01/d01b01.stb", 21020)
	event.finish_event()
end
script[21020] = script.leave_sphida_to_boss_room_event_21020

return script
