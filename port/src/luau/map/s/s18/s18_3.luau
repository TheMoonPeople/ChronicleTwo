--!strict
--- Yordas Valley events: the Lin worry scene on arrival, Lin's crest vision and the monster battle, Lin's recovery and the exits to the dungeon.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")
local yordas_valley = require("@lib/event/yordas_valley")

local max_slot: s32 = 0
local monica_slot: s32 = 0
local worry_max_slot: s32 = 0
local worry_monica_slot: s32 = 0

--- Loads the valley sounds and enables the crest scene trigger point once the rest flag is set and Lin has not yet recovered.
local function initialize_valley()
	local rest_flag: s32 = 0
	local recovery_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(3686)
	event.attach_object_handle_to_map_part_3(30, "p01_s18", "s18_02-a0")
	event.set_object_handle_visible(30, 0)
	rest_flag = event.get_save_flag(330) or rest_flag
	recovery_flag = event.get_save_flag(340) or recovery_flag
	if rest_flag == 1 and recovery_flag == 0 then
		event.set_function_point_enabled("", "e336", 1)
	end
end

--- Loads the party, the flying creature and the message file for the Lin worry scene.
local function prepare_lin_worry_cast()
	local active_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 then
		event.switch_dungeon_main_character(0)
		active_character = 0
	end
	if active_character == 3 then
		event.switch_dungeon_main_character(1)
		active_character = 1
	end
	if active_character == 0 then
		worry_max_slot = 0
		worry_monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", worry_max_slot)
		event.load_character_motion_pack(5, "event/e300/e332/e332_mints.gltf", "info", worry_max_slot)
		event.attach_object_handle_to_character(0, worry_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, worry_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", worry_monica_slot)
		event.load_equipment_model(5, 1, 4, "info", worry_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", worry_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", worry_monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", worry_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e332/e332_monica.gltf", "info", worry_monica_slot)
		event.attach_object_handle_to_character(1, worry_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, worry_monica_slot)
		event.set_character_active(1, 13)
	end
	if active_character == 1 then
		worry_max_slot = 8
		worry_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", worry_max_slot)
		event.load_equipment_model(5, 0, 4, "info", worry_max_slot)
		event.load_equipment_model(5, 0, 3, "info", worry_max_slot)
		event.load_equipment_model(5, 0, 2, "info", worry_max_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", worry_max_slot)
		event.load_character_motion_pack(5, "event/e300/e332/e332_mints.gltf", "info", worry_max_slot)
		event.attach_object_handle_to_character(0, worry_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, worry_max_slot)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", worry_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e332/e332_monica.gltf", "info", worry_monica_slot)
		event.attach_object_handle_to_character(1, worry_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, worry_monica_slot)
	end
	event.load_character(5, "event/d03/p00_26a.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(4, 11)
	event.clear_object_sequence(2, 11)
	event.set_object_sequence_object(2, 4)
	event.set_object_handle_shadow_enabled(4, 0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_message_file(0, 5, "event/e300/e332/e332_1.txt")
end

--- Unloads the Lin worry scene characters and restores the party.
local function restore_lin_worry_cast()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, worry_max_slot)
		event.set_character_active(0, worry_monica_slot)
		event.delete_character_extension_packs(worry_max_slot)
		event.delete_character_extension_packs(worry_monica_slot)
		event.delete_character(worry_monica_slot)
		event.delete_character(13)
	end
	if active_character == 1 then
		event.set_character_active(1, worry_monica_slot)
		event.set_character_active(0, worry_max_slot)
		event.delete_character_extension_packs(worry_max_slot)
		event.delete_character_extension_packs(worry_monica_slot)
		event.delete_character(worry_max_slot)
		event.delete_character(13)
	end
	event.delete_character(11)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

--- Plays the scene in which the flying creature carries the party into the valley and they worry about Lin.
local function play_lin_worry_scene()
	local sound_effect_handle: s32 = 0
	local rest_flag: s32 = 0
	vm.section(function()
		event.set_save_flag(332, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(3820)
		sound_effect_handle = event.load_sound_effect_file_2(3820) or sound_effect_handle
		prepare_lin_worry_cast()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, 11)
		event.set_camera_sequence_position(2137.92, 789.89, -634.43)
		event.set_camera_sequence_look_at(1501.16, 847.03, -450.95)
		event.set_object_sequence_position(2, -169.01, 1296.7, 919.52)
		event.set_object_sequence_rotation(2, 0.0, 2.52, 0.0)
		event.set_object_sequence_position(0, -1308.19, 201.28, -552.77)
		event.set_object_sequence_rotation(0, 0.0, 1.8, 0.0)
		event.set_object_sequence_position(1, -1303.45, 200.12, -532.19)
		event.set_object_sequence_rotation(1, 0.0, 1.92, 0.0)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_effect_handle, 0)
		event.play_sound_effect(sound_effect_handle, 1)
		event.set_object_sequence_motion(2, "肉つかみ飛び", 4)
		event.move_object_sequence(2, -127.0, 1099.81, 692.26, 140)
		object.wait_until_done(2)
		event.set_character_active(1, worry_max_slot)
		event.set_character_active(1, worry_monica_slot)
		event.play_sound_effect(sound_effect_handle, 2)
		event.play_sound_effect(sound_effect_handle, 3)
		event.set_object_sequence_position(2, -1272.85, 225.03, -556.23)
		event.set_object_sequence_rotation(2, 0.0, 1.92, 0.0)
		event.move_object_sequence(2, -1272.85, 267.03, -556.23, 60, 0)
		event.set_object_sequence_motion(0, "着地", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "着地", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_camera_sequence_position(-1178.39, 236.2, -586.84)
		event.set_camera_sequence_look_at(-1272.85, 237.51, -556.23)
		wait.frames(60)
		event.set_camera_sequence_position(-1191.17, 236.2, -746.66)
		event.set_camera_sequence_look_at(-1103.65, 237.51, -660.25)
		event.move_camera_sequence_angle_height_distance_eased(-1.31, -1.31, 104.9, 160, 2, 0.2)
		camera.wait_until_done()
		wait.frames(60)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_camera_sequence_position(-90.5, 14.06, -606.53)
		event.set_camera_sequence_look_at(-64.24, 89.53, -950.56)
		event.set_object_sequence_position(1, -238.89, 0.0, -900.0)
		event.set_object_sequence_rotation(1, 0.0, 1.44, 0.0)
		event.set_object_sequence_position(0, -268.89, 0.0, -900.0)
		event.set_object_sequence_rotation(0, 0.0, 1.44, 0.0)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.fade_in_screen(30)
		event.move_object_sequence(0, -76.82, 0.0, -888.62, 190, 1)
		event.delay_object_sequence_rotation_track(0, 180)
		event.rotate_object_sequence(0, 0.0, 3.1, 0.0, 10)
		event.move_object_sequence(1, -57.31, 0.0, -886.09, 180, 1)
		event.delay_object_sequence_rotation_track(1, 170)
		event.rotate_object_sequence(1, 0.0, -3.04, 0.0, 10)
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		wait.frames(60)
		event.set_camera_sequence_position(-84.25, 9.79, -925.95)
		event.set_camera_sequence_look_at(-68.29, 20.6, -887.75)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		wait.frames(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3320010)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3320020)
		object.wait_until_done(1)
		wait.frames(20)
		event.set_camera_sequence_position(-272.67, 64.11, 813.12)
		event.set_camera_sequence_look_at(-83.25, 1200.0, -897.58)
		event.play_sound_effect(sound_effect_handle, 4)
		event.move_camera_sequence_eased(-272.67, 67.63, 813.15, -83.25, 364.11, -897.58, 200, 0, 0.2)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3320025)
		event.reset_mouth_texture_animations()
		camera.wait_until_done()
		wait.frames(30)
		rest_flag = event.get_save_flag(330) or rest_flag
		if rest_flag == 0 then
			event.fade_out_screen(20)
			wait.frames(20)
			event.set_camera_sequence_position(-85.63, 12.99, -898.44)
			event.set_camera_sequence_look_at(-67.07, 18.64, -859.32)
			event.set_object_handle_position(0, -76.27, 0.0, -854.62)
			event.set_object_handle_rotation(0, 0.0, 2.76, 0.0)
			event.set_object_handle_texture_animation(0, 0)
			event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
			event.set_object_handle_texture_animation(0, 1, "通常目パチ")
			event.set_object_handle_position(1, -55.61, 0.0, -856.61)
			event.set_object_handle_rotation(1, 0.0, 3.0, 0.0)
			event.set_object_handle_texture_animation(1, 0)
			event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
			event.set_object_handle_texture_animation(1, 1, "通常目パチ")
			event.fade_in_screen(20)
			wait.frames(20)
			event.delay_object_sequence_texture_animation_track(0, 12)
			event.set_object_sequence_texture_animation(0, 1, "右向き目")
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 1)
			event.set_object_sequence_motion(1, "左向く", 6)
			event.queue_object_sequence_next_motion(1, "左向くL", 4)
			event.open_message_window_2(0, "Ich sorge mich um Lin.\nWir m[UNI00fc]ssen uns um Lin k[UNI00fc]mmern ...")
			event.set_mouth_texture_animations(1, "通常口パク")
			message.show_and_wait(0, -1, 8, 64, 0)
			object.wait_until_done(1)
			event.set_object_sequence_motion(1, "左向く会話", 6)
			event.queue_object_sequence_next_motion(1, "左向くL", 4)
			event.open_message_window_2(0, "Weiter sollten wir jetzt wohl\nnicht gehen.")
			event.set_mouth_texture_animations(1, "通常口パク")
			message.show_and_wait(0, -1, 8, 64, 0)
			object.wait_until_done(1)
			event.set_object_sequence_motion(0, "うなづく", 6)
			event.queue_object_sequence_next_motion(0, "立ち", 4)
			event.open_message_window_2(0, "Ja, da hast du wohl Recht.")
			event.set_mouth_texture_animations(0, "通常口パク")
			message.show_and_wait(0, -1, 8, 460, 0)
			object.wait_until_done(0)
		end
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	restore_lin_worry_cast()
end

--- Loads the party, Lin, the sprites and the message file for the Lin crest scene.
local function prepare_lin_crest_cast()
	local active_character: s32 = 0
	local image_block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 then
		event.switch_dungeon_main_character(0)
		active_character = 0
	end
	if active_character == 3 then
		event.switch_dungeon_main_character(1)
		active_character = 1
	end
	if active_character == 0 then
		max_slot = 0
		monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e300/e336/e336_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 1, "info", monica_slot, 14)
		event.load_equipment_model(5, 1, 0, "info", monica_slot, 15)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e300/e336/e336_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 13)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
	end
	if active_character == 1 then
		max_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 1, "info", max_slot, 14)
		event.load_equipment_model(5, 0, 0, "info", max_slot, 15)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e300/e336/e336_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 13)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e300/e336/e336_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e336/e336_lin.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(2, 9)
	event.set_object_sequence_object(2, 4)
	image_block = event.load_event_image_4(5, "textures/event/e300/e336/e336.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e33601", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e33602", image_block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(11, 1)
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "e33603", image_block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 416)
	event.set_event_sprite_size(2, 512, 416)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(12, 2)
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "e33604", image_block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(3, 512, 416)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(13, 3)
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "e33605", image_block)
	event.set_event_sprite_color(4, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(4, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(4, 512, 416)
	event.set_event_sprite_position(4, 256, 208)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(14, 4)
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	image_block = event.load_event_image_4(5, "textures/event/e300/e336/e336telop01_1.json", 1) or image_block
	event.reset_event_sprite(5)
	event.set_event_sprite_type(5, 0)
	event.set_event_sprite_texture(5, "e336telop01", image_block)
	event.set_event_sprite_texture_rect(5, 0, 0, 512, 128)
	event.set_event_sprite_size(5, 512, 128)
	event.set_event_sprite_position(5, 320, 334)
	event.set_event_sprite_color(5, 128, 128, 128, 0)
	event.set_event_sprite_scale(5, 1.0, 1.0)
	event.set_event_sprite_draw_pass(5, 0)
	event.attach_object_handle_to_sprite(15, 5)
	event.clear_object_sequence(15)
	event.set_object_sequence_object(15, 15)
	event.load_message_file(0, 5, "event/e300/e336/e336_1.txt")
end

--- Sets the Max and Monica slot globals used by the recovery scene when the scene is skipped.
local function assign_recovery_party_slots()
	local active_character: s32 = 0
	local _ = active_character == 2
	active_character = 0
	local _ = active_character == 3
	active_character = 1
	max_slot = 0
	monica_slot = 8
	max_slot = 8
	monica_slot = 0
end

--- Unloads the Lin crest scene characters and sprites and restores the party.
local function restore_lin_crest_cast()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
	end
	event.delete_character(9)
	event.delete_character(16)
	event.delete_character(10)
	event.delete_character(11)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.set_event_sprite_draw_pass(5, 0)
	event.delete_event_image(0)
	event.delete_event_image(1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	vm.wait(1)
	event.finish_event()
end

--- Plays the scene in which Lin has a vision of the crest, the party talks it over and a monster appears.
local function play_lin_crest_scene()
	local sound_effect_handle: s32 = 0
	local saved_time_of_day: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(336, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		step = 2
		wait.frames(4)
		event.load_music(112)
		event.load_map_sounds(3823)
		sound_effect_handle = event.load_sound_effect_file_2(3823) or sound_effect_handle
		prepare_lin_crest_cast()
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 1, "半口")
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-303.43, 42.35, -704.35)
		event.set_camera_sequence_look_at(-137.93, 52.07, -827.54)
		event.set_object_sequence_position(2, -71.03, 0.0, -852.13)
		event.set_object_sequence_rotation(2, 0.0, -3.312, 0.0)
		event.set_object_sequence_position(0, -51.68, 0.0, -885.58)
		event.set_object_sequence_rotation(0, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(1, -92.78, 0.0, -885.46)
		event.set_object_sequence_rotation(1, 0.0, 2.96, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.fade_in_screen(30)
		step = 3
		wait.frames(120)
		event.start_crossfade(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(-102.49, 15.34, -957.31)
		event.set_camera_sequence_look_at(-71.83, 20.94, -886.5)
		step = 4
		wait.frames(120)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(240)
		event.add_camera_sequence_path_point(-157.91, 17.6, -857.92, 44.13, 27.32, -844.52)
		event.add_camera_sequence_path_point(-109.74, 17.6, -854.73, 44.13, 27.32, -844.52)
		event.start_camera_sequence_path()
		step = 5
		wait.frames(40)
		event.play_sound_effect(sound_effect_handle, 2)
		event.fade_out_screen(5, 255, 255, 255)
		step = 6
		wait.frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 1)
		step = 7
		wait.frames(15)
		event.play_sound_effect(sound_effect_handle, 2)
		event.fade_out_screen(5, 255, 255, 255)
		step = 8
		wait.frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 0)
		step = 9
		wait.frames(40)
		event.play_sound_effect(sound_effect_handle, 2)
		event.fade_out_screen(5, 255, 255, 255)
		step = 10
		wait.frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 1)
		step = 11
		wait.frames(15)
		event.play_sound_effect(sound_effect_handle, 2)
		event.fade_out_screen(5, 255, 255, 255)
		step = 12
		wait.frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 0)
		step = 13
		wait.frames(40)
		event.play_sound_effect(sound_effect_handle, 2)
		event.fade_out_screen(5, 255, 255, 255)
		step = 14
		wait.frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 1)
		step = 15
		wait.frames(15)
		event.play_sound_effect(sound_effect_handle, 2)
		event.fade_out_screen(5, 255, 255, 255)
		step = 16
		wait.frames(5)
		event.fade_in_screen(5)
		event.set_event_sprite_draw_pass(4, 0)
		event.set_camera_sequence_position(-86.68, 23.43, -938.64)
		event.set_camera_sequence_look_at(-64.82, 27.32, -852.79)
		event.set_object_sequence_motion(2, "頭かかえ", 6)
		event.queue_object_sequence_next_motion(2, "頭かかえL", 4)
		event.delay_object_sequence_motion_track(0, 30)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, sound_effect_handle, 3)
		event.set_object_sequence_motion(0, "左・振り返り", 6)
		event.queue_object_sequence_next_motion(0, "左・振り返りL", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "振りかえり", 6)
		event.queue_object_sequence_next_motion(1, "振りかえりL", 4)
		step = 17
		message.show_voiced_for(3360020, -1)
		step = 18
		message.show_voiced_for(3360030, -1)
		event.set_motion_blur(60)
		event.set_camera_sequence_position(-76.1, 46.54, -770.39)
		event.set_camera_sequence_look_at(-70.1, 27.32, -860.66)
		event.set_object_sequence_rotation(0, 0.0, -0.48, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.44, 0.0)
		event.move_camera_sequence(-157.21, 46.54, 449.93, -70.1, 27.32, -860.66, 90)
		event.play_sound_effect(sound_effect_handle, 4)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(0, -54.72, 0.0, -869.17, 15, 1)
		event.move_object_sequence(1, -84.82, 0.0, -874.03, 15, 1)
		step = 19
		object.wait_until_done(0)
		step = 20
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(60)
		event.fade_out_camera_sequence(30, 255.0, 255.0, 255.0)
		step = 21
		camera.wait_until_done()
		event.set_motion_blur(0)
		step = 22
		wait.frames(30)
		event.delete_character(9)
		event.load_character(5, "event/e300/e336/e336_crest.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(6, 11)
		event.clear_object_sequence(4, 11)
		event.set_object_sequence_object(4, 6)
		event.load_character(5, "event/e300/e336/e336_lin2.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(4, 9)
		event.clear_object_sequence(2, 9)
		event.set_object_sequence_object(2, 4)
		event.set_time_of_day(12.0)
		event.set_time_of_day_advancing(0)
		event.play_music(0)
		event.set_camera_sequence_position(-297.31, 603.3, -529.44)
		event.set_camera_sequence_look_at(-114.1, 586.6, -822.33)
		event.move_camera_sequence_eased(-297.31, 51.86, -529.44, -114.1, 35.16, -822.33, 240, 2, 0.2)
		event.set_character_active(0, 13)
		event.set_character_active(0, max_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 9)
		event.set_character_active(1, 11)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(4, "立ち2", 4)
		event.set_object_sequence_position(4, -51.68, 0.0, -885.58)
		event.set_object_sequence_rotation(4, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(2, -76.82, 0.0, -887.22)
		event.set_object_sequence_rotation(2, 0.0, 1.76, 0.0)
		event.fade_in_camera_sequence(60, 255.0, 255.0, 255.0)
		step = 23
		camera.wait_until_done()
		step = 24
		wait.frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(-56.27, 12.94, -955.94)
		event.set_camera_sequence_look_at(-64.49, 18.56, -881.94)
		event.move_camera_sequence_eased(-29.91, 12.94, -940.74, -64.49, 18.56, -881.94, 600, 2, 0.1)
		event.play_sound_effect(sound_effect_handle, 5)
		event.set_object_sequence_motion(2, "右向く", 6)
		event.queue_object_sequence_next_motion(2, "右向くL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		step = 25
		message.show_voiced(3360040)
		step = 26
		object.wait_until_done(2)
		event.set_object_sequence_motion(4, "左を見る", 6)
		event.queue_object_sequence_next_motion(4, "左を見るL", 6)
		event.queue_object_sequence_next_motion(4, "考える", 6)
		event.queue_object_sequence_next_motion(4, "考えるL", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 27
		message.show_voiced(3360050)
		step = 28
		object.wait_until_done(4)
		event.set_object_sequence_motion(4, "考える戻り", 6)
		event.queue_object_sequence_next_motion(4, "左を見るL", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 29
		message.show_voiced(3360055)
		step = 30
		object.wait_until_done(4)
		step = 31
		wait.frames(30)
		event.clear_camera_sequence()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "大わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(-31.38, 30.21, -910.26)
		event.set_camera_sequence_look_at(-87.35, 19.34, -871.43)
		event.move_camera_sequence_eased(-29.12, 30.21, -907.0, -85.09, 19.34, -868.17, 600, 2, 0.1)
		event.set_object_sequence_motion(2, "腰に手", 6)
		event.queue_object_sequence_next_motion(2, "腰に手会話", 2)
		event.queue_object_sequence_next_motion(2, "腰に手L", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		step = 32
		message.show_voiced(3360060)
		event.play_sound_effect(sound_effect_handle, 7)
		event.set_object_sequence_motion(4, "笑い", 6)
		event.queue_object_sequence_next_motion(4, "笑いL", 2)
		event.queue_object_sequence_next_motion(4, "笑い戻り", 6)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "わらい目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目～通常目")
		event.delay_object_sequence_texture_animation_track(30)
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_mouth_texture_animations(6, "わらい口パク")
		step = 33
		message.show_voiced(3360070)
		event.reset_mouth_texture_animations()
		step = 34
		wait.frames(30)
		event.set_object_sequence_motion(4, "会話2", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 35
		message.show_voiced(3360080)
		event.reset_mouth_texture_animations()
		step = 36
		wait.frames(30)
		event.clear_camera_sequence()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-80.0, 6.0, -766.5)
		event.set_camera_sequence_look_at(-80.0, 23.0, -889.39)
		event.move_camera_sequence_eased(-56.0, 6.0, -766.5, -56.0, 23.0, -889.39, 210, 2, 0.1)
		step = 37
		message.show_voiced(3360090)
		event.clear_camera_sequence()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-56.38, 6.57, -939.5)
		event.set_camera_sequence_look_at(-65.1, 23.91, -871.04)
		event.set_object_sequence_rotation(2, 0.0, 2.84, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(4, "会話3", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 38
		message.show_voiced(3360100)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_effect_handle, 6)
		event.set_object_sequence_motion(2, "うーん", 6)
		event.queue_object_sequence_next_motion(2, "うーんL", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "無表情")
		event.set_object_sequence_texture_animation(2, 1, "前向き～左向き")
		event.set_mouth_texture_animations(4, "通常口パク")
		step = 39
		message.show_voiced(3360110)
		event.reset_mouth_texture_animations()
		step = 40
		wait.frames(30)
		event.set_object_sequence_rotation(2, 0.0, 1.76, 0.0)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_camera_sequence_position(-78.92, 13.21, -914.21)
		event.set_camera_sequence_look_at(-33.74, 32.68, -868.91)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(4, "会話3", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 41
		message.show_voiced(3360120)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128, 128, 128, 128, 30)
		event.set_object_sequence_motion(4, "会話3", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 42
		message.show_voiced(3360130)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(11, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 43
		message.show_voiced(3360140)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 44
		message.show_voiced(3360145)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(12, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 45
		message.show_voiced(3360150)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 46
		message.show_voiced(3360155)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 47
		message.show_voiced(3360160)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 48
		message.show_voiced(3360165)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(13, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 49
		message.show_voiced(3360170)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 50
		message.show_voiced(3360175)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 51
		message.show_voiced(3360180)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 52
		message.show_voiced(3360185)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 53
		message.show_voiced(3360190)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 54
		message.show_voiced(3360200)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		step = 55
		message.show_voiced(3360205)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_object_sequence_color(13, 128, 128, 128, 0, 30)
		step = 56
		wait.frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "わらい目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(-2.61, 26.27, -934.98)
		event.set_camera_sequence_look_at(-85.09, 13.74, -868.17)
		event.set_object_sequence_motion(2, "右向くL", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		event.set_object_sequence_motion(4, "会話3", 2)
		event.queue_object_sequence_next_motion(4, "立ち2", 4)
		step = 57
		message.show_voiced(3360210)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		step = 58
		message.show_voiced(3360220)
		event.reset_mouth_texture_animations()
		step = 59
		wait.frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "大わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "わらい目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(-64.24, 26.65, -742.64)
		event.set_camera_sequence_look_at(-63.35, 32.68, -885.22)
		event.move_camera_sequence_eased(-64.42, 26.65, -682.97, -63.35, 32.68, -885.22, 600, 2, 0.1)
		event.set_object_sequence_motion(4, "立ち2", 4)
		event.set_mouth_texture_animations(4, "わらい口パク")
		step = 60
		message.show_voiced(3360230)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "会話2", 2)
		event.queue_object_sequence_next_motion(4, "左を見る", 6)
		event.queue_object_sequence_next_motion(4, "左を見るL", 4)
		event.set_mouth_texture_animations(6, "わらい口パク")
		step = 61
		message.show_voiced(3360240)
		event.set_object_sequence_texture_animation(4, 1, "わらい口パク")
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.play_sound_effect(sound_effect_handle, 7)
		event.set_object_sequence_motion(4, "笑い", 6)
		event.queue_object_sequence_next_motion(4, "笑いL", 4)
		step = 62
		message.show_voiced_for(3360245, -1)
		event.fade_out_camera_sequence(30, 255.0, 255.0, 255.0)
		event.fade_out_music(30)
		step = 63
		wait.frames(30)
		event.stop_music(0)
		event.clear_camera_sequence()
		event.delete_character(9)
		event.set_character_active(0, 11)
		event.load_character(5, "event/e300/e336/e336_me.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(5, 10)
		event.clear_object_sequence(3, 10)
		event.set_object_sequence_object(3, 5)
		event.load_character(5, "event/e300/e336/e336_lin.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(4, 9)
		event.clear_object_sequence(2, 9)
		event.set_object_sequence_object(2, 4)
		event.load_character(5, "event/e300/e336/e336_rin_kemuri.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(7, 16)
		event.clear_object_sequence(7, 16)
		event.set_object_sequence_object(7, 7)
		event.set_time_of_day(saved_time_of_day)
		event.set_time_of_day_advancing(1)
		event.set_camera_sequence_position(-114.47, 17.08, -834.34)
		event.set_camera_sequence_look_at(-71.89, 20.6, -808.25)
		event.set_character_active(1, 13)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 9)
		event.set_character_active(1, 16)
		event.set_character_active(1, 10)
		event.set_object_sequence_scale(3, 0.0, 0.0, 0.0, 0)
		event.set_character_visible(16, 0)
		event.set_object_sequence_position(2, -74.74, 0.0, -806.3)
		event.set_object_sequence_rotation(2, 0.0, -3.312, 0.0)
		event.set_object_sequence_position(7, -74.74, 0.0, -806.3)
		event.set_object_sequence_rotation(7, 0.0, -3.312, 0.0)
		event.set_object_sequence_position(3, -76.09, 22.0, -809.66)
		event.set_object_sequence_rotation(3, 0.0, -3.312, 0.0)
		event.set_object_sequence_position(0, -51.68, 0.0, -885.58)
		event.set_object_sequence_rotation(0, 0.0, -0.32, 0.0)
		event.set_object_sequence_position(1, -92.78, 0.0, -885.46)
		event.set_object_sequence_rotation(1, 0.0, 0.2, 0.0)
		event.set_object_sequence_motion(2, "頭かかえL", 4)
		event.set_object_sequence_motion(7, "頭かかえL", 4)
		event.fade_in_camera_sequence(60, 255.0, 255.0, 255.0)
		event.play_sound_effect(sound_effect_handle, 8)
		step = 64
		wait.frames(15)
		event.set_character_visible(16, 1, 1, 0.0125)
		step = 65
		message.show_voiced(3360250)
		event.move_camera_sequence_eased(-102.78, 34.32, -836.68, -71.89, 27.85, -808.25, 120, 0, 0.4)
		event.play_sound_effect(sound_effect_handle, 9)
		event.set_object_sequence_scale(3, 0.25, 0.25, 0.25, 180)
		step = 66
		wait.frames(150)
		step = 67
		wait.frames(30)
		event.set_object_sequence_scale(3, 1.25, 1.25, 1.25, 240)
		event.set_camera_sequence_position(-64.41, 9.43, -967.48)
		event.set_camera_sequence_look_at(-76.6, 52.07, -819.83)
		event.set_object_sequence_motion(0, "上見驚き", 6)
		event.set_object_sequence_motion(1, "上驚き", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		step = 68
		wait.frames(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 69
		message.show_voiced(3360260)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 70
		message.show_voiced(3360270)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_scale(3, 1.75, 1.75, 1.75, 240)
		step = 71
		wait.frames(30)
		event.set_camera_sequence_position(-224.41, 16.45, -978.74)
		event.set_camera_sequence_look_at(-76.09, 69.2, -809.66)
		step = 72
		wait.frames(15)
		event.move_camera_sequence_eased(-296.34, 16.45, -752.06, -76.09, 69.2, -809.66, 240, 0, 0.4)
		step = 73
		message.show_voiced(3360280)
		step = 74
		message.show_voiced(3360290)
		step = 75
		camera.wait_until_done()
		step = 76
		wait.frames(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-52.97, 41.64, -777.44)
		event.set_camera_sequence_look_at(-80.22, 14.54, -868.17)
		step = 77
		wait.frames(15)
		event.move_object_sequence(3, -76.09, 48.73, -809.66, 5, 0)
		event.play_sound_effect(sound_effect_handle, 10)
		event.set_object_sequence_motion(0, "上見驚き", 6)
		event.set_object_sequence_motion(1, "上驚き", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.stop_sound_effect(sound_effect_handle, 9)
		step = 78
		wait.frames(30)
		event.fade_out_screen(30)
		step = 79
		wait.frames(30)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.delete_character(10)
		event.set_character_active(0, 9)
		event.set_character_active(0, 16)
		event.load_character(5, "dungeon/monster/e220a.gltf", "e220a", 10)
		event.set_character_active(1, 10)
		event.attach_object_handle_to_character(5, 10)
		event.clear_object_sequence(3, 10)
		event.set_object_sequence_object(3, 5)
		event.load_music(190)
		event.set_object_sequence_position(3, -102.77, 0.0, -720.48)
		event.set_object_sequence_rotation(3, 0.0, -3.312, 0.0)
		event.set_object_sequence_motion(3, "攻撃１", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_camera_sequence_position(-164.4, 14.41, -665.54)
		event.set_camera_sequence_look_at(-24.29, 14.54, -859.25)
		step = 80
		wait.frames(15)
		event.fade_in_screen(30)
		step = 81
		wait.frames(15)
		event.play_music(0)
		event.shake_camera_sequence(0.0, 0.3, 0.0, 90)
		event.play_sound_effect(sound_effect_handle, 11)
		step = 82
		wait.frames(90)
		step = 83
		wait.frames(30)
		event.set_camera_sequence_position(-129.58, 12.28, -799.76)
		event.set_camera_sequence_look_at(-95.81, 20.0, -706.37)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.move_camera_sequence_eased(-129.58, 41.07, -799.76, -95.81, 48.78, -706.37, 120, 0, 0.4)
		step = 84
		wait.frames(90)
		event.set_event_sprite_draw_pass(5, 1)
		event.set_object_sequence_color(15, 128, 128, 128, 128, 30)
		event.set_object_sequence_motion(3, "遊び", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.play_sound_effect(sound_effect_handle, 12)
		step = 85
		camera.wait_until_done()
		event.set_object_sequence_color(15, 128, 128, 128, 0, 30)
		step = 86
		wait.frames(30)
		step = 87
		wait.frames(30)
		event.set_character_active(1, 14)
		event.set_character_active(1, 15)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 1)
		event.set_camera_sequence_position(-29.29, 6.3, -834.76)
		event.set_camera_sequence_look_at(-76.21, 19.78, -889.08)
		event.set_object_sequence_motion(0, "バトル立ち", 4)
		event.set_object_sequence_motion(1, "バトル立ち", 4)
		step = 88
		wait.frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 89
		message.show_voiced(3360310)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_effect_handle, 13)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "バトル立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 90
		message.show_voiced(3360320)
		event.reset_mouth_texture_animations()
		step = 91
		wait.frames(60)
	end, function(received: { any }): boolean
		if step <= 1 then
			wait.frames_skipping(4)
		end
		if step <= 2 then
			assign_recovery_party_slots()
			wait.frames_skipping(120)
		end
		if step <= 3 then
			wait.frames_skipping(120)
		end
		if step <= 4 then
			wait.frames_skipping(40)
		end
		if step <= 5 then
			wait.frames_skipping(5)
		end
		if step <= 6 then
			wait.frames_skipping(15)
		end
		if step <= 7 then
			wait.frames_skipping(5)
		end
		if step <= 8 then
			wait.frames_skipping(40)
		end
		if step <= 9 then
			wait.frames_skipping(5)
		end
		if step <= 10 then
			wait.frames_skipping(15)
		end
		if step <= 11 then
			wait.frames_skipping(5)
		end
		if step <= 12 then
			wait.frames_skipping(40)
		end
		if step <= 13 then
			wait.frames_skipping(5)
		end
		if step <= 14 then
			wait.frames_skipping(15)
		end
		if step <= 15 then
			wait.frames_skipping(5)
		end
		if step <= 16 then
			message.show_voiced_for_skipping(3360020, -1)
		end
		if step <= 17 then
			message.show_voiced_for_skipping(3360030, -1)
		end
		if step <= 18 then
			cutscene.skip_command(0)
		end
		if step <= 19 then
			cutscene.skip_command(1)
		end
		if step <= 20 then
			wait.background_load_skipping()
		end
		if step <= 21 then
			wait.frames_skipping(30)
		end
		if step <= 22 then
			wait.background_load_skipping()
		end
		if step <= 23 then
			wait.frames_skipping(30)
		end
		if step <= 24 then
			message.show_voiced_skipping(3360040)
		end
		if step <= 25 then
			cutscene.skip_command(2)
		end
		if step <= 26 then
			message.show_voiced_skipping(3360050)
		end
		if step <= 27 then
			cutscene.skip_command(4)
		end
		if step <= 28 then
			message.show_voiced_skipping(3360055)
		end
		if step <= 29 then
			cutscene.skip_command(4)
		end
		if step <= 30 then
			wait.frames_skipping(30)
		end
		if step <= 31 then
			message.show_voiced_skipping(3360060)
		end
		if step <= 32 then
			message.show_voiced_skipping(3360070)
		end
		if step <= 33 then
			wait.frames_skipping(30)
		end
		if step <= 34 then
			message.show_voiced_skipping(3360080)
		end
		if step <= 35 then
			wait.frames_skipping(30)
		end
		if step <= 36 then
			message.show_voiced_skipping(3360090)
		end
		if step <= 37 then
			message.show_voiced_skipping(3360100)
		end
		if step <= 38 then
			message.show_voiced_skipping(3360110)
		end
		if step <= 39 then
			wait.frames_skipping(30)
		end
		if step <= 40 then
			message.show_voiced_skipping(3360120)
		end
		if step <= 41 then
			message.show_voiced_skipping(3360130)
		end
		if step <= 42 then
			message.show_voiced_skipping(3360140)
		end
		if step <= 43 then
			message.show_voiced_skipping(3360145)
		end
		if step <= 44 then
			message.show_voiced_skipping(3360150)
		end
		if step <= 45 then
			message.show_voiced_skipping(3360155)
		end
		if step <= 46 then
			message.show_voiced_skipping(3360160)
		end
		if step <= 47 then
			message.show_voiced_skipping(3360165)
		end
		if step <= 48 then
			message.show_voiced_skipping(3360170)
		end
		if step <= 49 then
			message.show_voiced_skipping(3360175)
		end
		if step <= 50 then
			message.show_voiced_skipping(3360180)
		end
		if step <= 51 then
			message.show_voiced_skipping(3360185)
		end
		if step <= 52 then
			message.show_voiced_skipping(3360190)
		end
		if step <= 53 then
			message.show_voiced_skipping(3360200)
		end
		if step <= 54 then
			message.show_voiced_skipping(3360205)
		end
		if step <= 55 then
			wait.frames_skipping(30)
		end
		if step <= 56 then
			message.show_voiced_skipping(3360210)
		end
		if step <= 57 then
			message.show_voiced_skipping(3360220)
		end
		if step <= 58 then
			wait.frames_skipping(30)
		end
		if step <= 59 then
			message.show_voiced_skipping(3360230)
		end
		if step <= 60 then
			message.show_voiced_skipping(3360240)
		end
		if step <= 61 then
			message.show_voiced_for_skipping(3360245, -1)
		end
		if step <= 62 then
			wait.frames_skipping(30)
		end
		if step <= 63 then
			wait.frames_skipping(15)
		end
		if step <= 64 then
			message.show_voiced_skipping(3360250)
		end
		if step <= 65 then
			wait.frames_skipping(150)
		end
		if step <= 66 then
			wait.frames_skipping(30)
		end
		if step <= 67 then
			wait.frames_skipping(30)
		end
		if step <= 68 then
			message.show_voiced_skipping(3360260)
		end
		if step <= 69 then
			message.show_voiced_skipping(3360270)
		end
		if step <= 70 then
			wait.frames_skipping(30)
		end
		if step <= 71 then
			wait.frames_skipping(15)
		end
		if step <= 72 then
			message.show_voiced_skipping(3360280)
		end
		if step <= 73 then
			message.show_voiced_skipping(3360290)
		end
		if step <= 74 then
			wait.background_load_skipping()
		end
		if step <= 75 then
			wait.frames_skipping(30)
		end
		if step <= 76 then
			wait.frames_skipping(15)
		end
		if step <= 77 then
			wait.frames_skipping(30)
		end
		if step <= 78 then
			wait.frames_skipping(30)
		end
		if step <= 79 then
			wait.frames_skipping(15)
		end
		if step <= 80 then
			wait.frames_skipping(15)
		end
		if step <= 81 then
			wait.frames_skipping(90)
		end
		if step <= 82 then
			wait.frames_skipping(30)
		end
		if step <= 83 then
			wait.frames_skipping(90)
		end
		if step <= 84 then
			wait.background_load_skipping()
		end
		if step <= 85 then
			wait.frames_skipping(30)
		end
		if step <= 86 then
			wait.frames_skipping(30)
		end
		if step <= 87 then
			wait.frames_skipping(15)
		end
		if step <= 88 then
			message.show_voiced_skipping(3360310)
		end
		if step <= 89 then
			message.show_voiced_skipping(3360320)
		end
		if step <= 90 then
			wait.frames_skipping(60)
		end
		return true
	end)
	step = 92
	vm.entry(92)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	step = 93
	wait.frames(30)
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	event.set_motion_blur(0)
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	step = 94
	vm.wait(94)
	step = 95
	restore_lin_crest_cast()
end

--- Loads the party, Lin, the defeated monster and the message file for the Lin recovery scene.
local function prepare_lin_recovery_cast()
	local active_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 then
		event.switch_dungeon_main_character(0)
		active_character = 0
	end
	if active_character == 3 then
		event.switch_dungeon_main_character(1)
		active_character = 1
	end
	if active_character == 0 then
		max_slot = 0
		monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e300/e340/e340_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 1, "info", monica_slot, 14)
		event.load_equipment_model(5, 1, 0, "info", monica_slot, 15)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e300/e340/e340_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 13)
	end
	if active_character == 1 then
		max_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 1, "info", max_slot, 14)
		event.load_equipment_model(5, 0, 0, "info", max_slot, 15)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e300/e340/e340_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e300/e340/e340_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e300/e340/e340_lin.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(4, 11)
	event.clear_object_sequence(2, 11)
	event.set_object_sequence_object(2, 4)
	event.load_character(5, "dungeon/monster/e220a.gltf", "e220a", 12)
	event.set_character_active(0, 12)
	event.attach_object_handle_to_character(5, 12)
	event.clear_object_sequence(3, 12)
	event.set_object_sequence_object(3, 5)
	event.load_character(5, "event/e300/e340/e340_mem_kieru.gltf", "info", 16)
	event.set_character_active(0, 16)
	event.set_character_active(1, 14)
	event.set_character_active(1, 15)
	event.load_message_file(0, 5, "event/e300/e340/e340_1.txt")
end

--- Sets the Max and Monica slot globals used by the crest scene when the scene is skipped.
local function assign_party_slots()
	local active_character: s32 = 0
	local _ = active_character == 2
	active_character = 0
	local _ = active_character == 3
	active_character = 1
	max_slot = 0
	monica_slot = 8
	max_slot = 8
	monica_slot = 0
end

--- Unloads the Lin recovery scene characters and restores the party.
local function restore_lin_recovery_cast()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
	end
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(16)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
end

--- Plays the scene in which Lin recovers after the battle and the party talks with her.
local function play_lin_recovery_scene()
	local sound_effect_handle: s32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(340, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(0)
		event.stop_music(0)
		step = 2
		vm.wait(2)
		step = 3
		vm.wait(3)
		step = 4
		vm.wait(4)
		step = 5
		vm.wait(5)
		prepare_lin_recovery_cast()
		event.load_map_sounds(3826)
		sound_effect_handle = event.load_sound_effect_file_2(3826) or sound_effect_handle
		event.load_music(49)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "無表情")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 11)
		event.set_character_active(1, 12)
		event.set_camera_sequence_position(-559.26, 65.75, -328.45)
		event.set_camera_sequence_look_at(-142.53, 58.24, -796.93)
		event.set_object_sequence_position(2, -142.0, 0.0, -1031.0)
		event.set_object_sequence_rotation(2, 0.0, -0.36, 0.0)
		event.set_object_sequence_position(3, -296.82, 0.0, -544.32)
		event.set_object_sequence_rotation(3, 0.0, -1.72, 0.0)
		event.set_character_position(16, -296.82, 0.0, -544.32)
		event.set_character_rotation(16, 0.0, -1.72, 0.0)
		event.set_object_sequence_position(0, -439.61, 0.0, -561.58)
		event.set_object_sequence_rotation(0, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(1, -441.56, 0.0, -520.65)
		event.set_object_sequence_rotation(1, 0.0, 0.8, 0.0)
		event.set_object_sequence_motion(0, "バトル立ち", 4)
		event.set_object_sequence_motion(1, "バトル立ち", 4)
		event.set_object_sequence_motion(2, "座り", 4)
		event.set_object_sequence_motion(3, "死に", 2)
		event.set_character_active(1, 16)
		event.fade_in_screen(30)
		step = 6
		wait.frames(15)
		event.play_sound_effect(sound_effect_handle, 2)
		step = 7
		wait.frames(30)
		event.set_character_visible(12, 0, 1, 0.025)
		event.set_character_visible(16, 0, 1, 0.025)
		event.play_sound_effect(sound_effect_handle, 3)
		step = 8
		wait.frames(90)
		event.set_character_active(0, 12)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.set_object_sequence_motion(0, "走り")
		event.set_object_sequence_motion(1, "走り")
		event.set_object_sequence_position(0, -231.36, 0.0, -872.18)
		event.set_object_sequence_rotation(0, 0.0, 2.52, 0.0)
		event.set_object_sequence_position(1, -176.93, 0.0, -859.14)
		event.set_object_sequence_rotation(1, 0.0, 2.96, 0.0)
		event.move_object_sequence(0, -178.43, 0.0, -986.22, 90, 1)
		event.move_object_sequence(1, -152.11, 0.0, -973.42, 90, 1)
		event.set_camera_sequence_position(-198.82, 54.44, -881.4)
		event.set_camera_sequence_look_at(-144.13, 15.05, -1023.93)
		step = 9
		object.wait_until_done(0)
		step = 10
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.set_camera_sequence_position(-76.1, 10.61, -1046.48)
		event.set_camera_sequence_look_at(-132.11, 15.05, -1017.56)
		event.play_music(0)
		step = 11
		wait.frames(60)
		event.set_mouth_texture_animations(4, "通常口パク")
		step = 12
		message.show_voiced(3400010)
		event.reset_mouth_texture_animations()
		step = 13
		wait.frames(60)
		event.set_object_sequence_motion(2, "顔上げ", 6)
		event.queue_object_sequence_next_motion(2, "顔上げL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		step = 14
		message.show_voiced(3400015)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		step = 15
		message.show_voiced(3400020)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		step = 16
		message.show_voiced(3400025)
		event.reset_mouth_texture_animations()
		step = 17
		wait.frames(30)
		event.set_camera_sequence_position(-160.43, 21.01, -1099.02)
		event.set_camera_sequence_look_at(-150.14, 15.05, -994.77)
		step = 18
		wait.frames(15)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 19
		message.show_voiced(3400030)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_object_sequence_motion(0, "右向く会話", 2)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 20
		message.show_voiced(3400040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		step = 21
		message.show_voiced(3400050)
		step = 22
		wait.frames(15)
		event.play_sound_effect(sound_effect_handle, 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "立ちあがる", 1)
		event.set_object_sequence_motion(2, "立ちあがる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_camera_sequence_position(-174.6, 3.67, -986.98)
		event.set_camera_sequence_look_at(-146.07, 14.84, -1024.36)
		step = 23
		message.show_voiced_for(3400060, -1)
		step = 24
		wait.frames(30)
		event.set_camera_sequence_position(-153.96, 18.46, -1073.61)
		event.set_camera_sequence_look_at(-151.84, 23.17, -999.4)
		step = 25
		wait.frames(60)
		event.set_object_sequence_motion(2, "うなづく", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.play_sound_effect(sound_effect_handle, 5)
		event.play_sound_effect(sound_effect_handle, 6)
		step = 26
		message.show_voiced(3400070)
		step = 27
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 5 then
			assign_party_slots()
			wait.frames_skipping(15)
		end
		if step <= 6 then
			wait.frames_skipping(30)
		end
		if step <= 7 then
			wait.frames_skipping(90)
		end
		if step <= 8 then
			cutscene.skip_command(0)
		end
		if step <= 9 then
			cutscene.skip_command(1)
		end
		if step <= 10 then
			wait.frames_skipping(60)
		end
		if step <= 11 then
			message.show_voiced_skipping(3400010)
		end
		if step <= 12 then
			wait.frames_skipping(60)
		end
		if step <= 13 then
			message.show_voiced_skipping(3400015)
		end
		if step <= 14 then
			message.show_voiced_skipping(3400020)
		end
		if step <= 15 then
			message.show_voiced_skipping(3400025)
		end
		if step <= 16 then
			wait.frames_skipping(30)
		end
		if step <= 17 then
			wait.frames_skipping(15)
		end
		if step <= 18 then
			message.show_voiced_skipping(3400030)
		end
		if step <= 19 then
			message.show_voiced_skipping(3400040)
		end
		if step <= 20 then
			message.show_voiced_skipping(3400050)
		end
		if step <= 21 then
			wait.frames_skipping(15)
		end
		if step <= 22 then
			message.show_voiced_for_skipping(3400060, -1)
		end
		if step <= 23 then
			wait.frames_skipping(30)
		end
		if step <= 24 then
			wait.frames_skipping(60)
		end
		if step <= 25 then
			message.show_voiced_skipping(3400070)
		end
		if step <= 26 then
			wait.frames_skipping(30)
		end
		return true
	end)
	step = 28
	vm.entry(28)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	step = 29
	wait.frames(30)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_port_sound_effects(4)
	step = 30
	vm.wait(30)
	step = 31
	restore_lin_recovery_cast()
	event.fade_in_screen(30)
end

--- Asks whether to leave once Lin has recovered, returning 1 when leaving, otherwise steps the player back and shows a remark.
local function confirm_leave_valley()
	local active_character: s32 = 0
	local recovery_flag: s32 = 0
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local retreat_x: f32 = 0
	local retreat_y: f32 = 0
	local retreat_z: f32 = 0
	local i: s32 = 0
	local blocked_player_x: f32 = 0
	local blocked_player_y: f32 = 0
	local blocked_player_z: f32 = 0
	local blocked_retreat_x: f32 = 0
	local blocked_retreat_y: f32 = 0
	local blocked_retreat_z: f32 = 0
	local blocked_index: s32 = 0
	local speaking_character: s32 = 0
	local rest_flag: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				step = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				step = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.fade_out_screen(10)
			step = 3
			wait.frames(10)
			event.set_character_position(0, 951.18, 106.54, 1509.16)
			event.set_character_rotation(0, 0.0, -3.13, 0.0)
			event.set_camera_position(951.95, 133.23, 1642.83)
			event.set_camera_look_at(951.18, 136.54, 1509.16)
			event.reset_follow_camera(0)
			event.fade_in_screen(10)
			event.finish_event()
			return 0
		end
		recovery_flag = event.get_save_flag(340) or recovery_flag
		if recovery_flag == 1 then
			step = 4
			answer = message.ask_yes_no(1, -1)
			event.attach_object_handle_to_character(0, 0)
			event.set_object_handle_footstep_sound(0, 1)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			if answer == 0 then
				event.fade_out_screen(30)
				step = 5
				wait.frames(30)
				return 1
			else
				do
					local out1, out2, out3 = event.get_character_position(0)
					player_x = out1 or player_x
					player_y = out2 or player_y
					player_z = out3 or player_z
				end
				retreat_x = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + player_x)
				retreat_y = player_y
				retreat_z = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + player_z)
				event.move_object_sequence(0, retreat_x, retreat_y, retreat_z, 30, 1)
				event.turn_object_sequence_toward(0, retreat_x, retreat_y, retreat_z, 10)
				event.set_object_sequence_motion(0, "歩き")
				i = 0
				while i < 30 do
					do
						local out1, out2, out3 = event.get_character_position(0)
						player_x = out1 or player_x
						player_y = out2 or player_y
						player_z = out3 or player_z
					end
					player_y = vm.f32(player_y + 30.0)
					event.set_camera_look_at(player_x, player_y, player_z)
					i = i + 1
					step = 6
					vm.wait(6)
				end
				event.reset_follow_camera(0)
				event.finish_event()
			end
		else
			event.attach_object_handle_to_character(0, 0)
			event.set_object_handle_footstep_sound(0, 1)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			do
				local out1, out2, out3 = event.get_character_position(0)
				blocked_player_x = out1 or blocked_player_x
				blocked_player_y = out2 or blocked_player_y
				blocked_player_z = out3 or blocked_player_z
			end
			blocked_retreat_x = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + blocked_player_x)
			blocked_retreat_y = blocked_player_y
			blocked_retreat_z = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + blocked_player_z)
			event.move_object_sequence(0, blocked_retreat_x, blocked_retreat_y, blocked_retreat_z, 30, 1)
			event.turn_object_sequence_toward(0, blocked_retreat_x, blocked_retreat_y, blocked_retreat_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 30)
			event.set_object_sequence_motion(0, "立ち")
			blocked_index = 0
			while blocked_index < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					blocked_player_x = out1 or blocked_player_x
					blocked_player_y = out2 or blocked_player_y
					blocked_player_z = out3 or blocked_player_z
				end
				blocked_player_y = vm.f32(blocked_player_y + 30.0)
				event.set_camera_look_at(blocked_player_x, blocked_player_y, blocked_player_z)
				blocked_index = blocked_index + 1
				step = 7
				vm.wait(7)
			end
			event.reset_follow_camera(0)
			speaking_character = event.get_playable_character() or speaking_character
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
			event.set_message_bubble_tail(0, 0)
			rest_flag = event.get_save_flag(330) or rest_flag
			if rest_flag == 0 then
				if speaking_character == 0 then
					event.open_message_window_2(0, "Ich sorge mich um Lin.\nWir sollten nicht weitergehen.")
				else
					event.open_message_window_2(0, "Ich sorge mich um Lin.\nWir sollten nicht weitergehen.")
				end
			elseif speaking_character == 0 then
				event.open_message_window_2(
					0,
					"Hey, Monica, wollen wir nicht\nam Yorda-Baum etwas ausruhen?\nLin ist sicher auch m[UNI00fc]de."
				)
			else
				event.open_message_window_2(
					0,
					"Sag mal, Max, k[UNI00f6]nnen wir uns\nam Yorda-Baum etwas ausruhen?\nLin ist sicher auch m[UNI00fc]de."
				)
			end
			step = 8
			message.show_and_wait(0, -1, 5, 0, 0)
			event.set_message_bubble_tail(0, 1)
			event.finish_event()
		end
		return 0
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			if step <= 2 then
				wait.frames_skipping(10)
			end
			return 0
		end
		if step <= 5 then
			if step == 4 then
				answer = received[1] :: number
			end
			if step <= 4 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if step <= 8 then
			if step <= 6 then
				blocked_retreat_x = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + blocked_player_x)
				blocked_retreat_y = blocked_player_y
				blocked_retreat_z = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + blocked_player_z)
				blocked_index = 0
				blocked_player_y = vm.f32(blocked_player_y + 30.0)
				local _ = blocked_index < 30
				blocked_index = blocked_index + 1
			end
			if step <= 7 then
				message.show_and_wait_skipping(0, -1, 5, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script loads.
function script.setup() end

script.initialize_valley = initialize_valley
script[99] = script.initialize_valley

--- Starts the valley, playing the Lin worry scene on the first entry.
function script.default_event()
	local valley_arrival_flag: s32 = 0
	local worry_scene_flag: s32 = 0
	event.initialize_event()
	initialize_valley()
	event.fade_out_screen(0)
	valley_arrival_flag = event.get_save_flag(300) or valley_arrival_flag
	worry_scene_flag = event.get_save_flag(332) or worry_scene_flag
	if valley_arrival_flag == 1 then
		if worry_scene_flag == 0 then
			play_lin_worry_scene()
			character.place_standing_and_reset_cloth(0.0, 0.0, -600.0, vm.f32(3.14))
			event.set_camera_look_at(0.0, 30.0, -600.0)
			event.set_camera_position(0.0, 40.0, -480.0)
			event.reset_follow_camera(0)
			yordas_valley.set_reverse_floor_enabled(1)
			event.fade_in_screen(20)
			event.finish_event()
			return
		else
			yordas_valley.play_flying_creature_drop_landing()
		end
	end
	character.place_standing_and_reset_cloth(-1306.0, vm.f32(200.39), -546.0, vm.f32(1.88))
	event.set_camera_position(-1182.17, 240.83, -585.56)
	event.set_camera_look_at(-1306.0, 230.83, -546.0)
	event.reset_follow_camera(0)
	yordas_valley.set_reverse_floor_enabled(1)
	event.fade_in_screen(20)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_lin_crest_scene

--- Ends the battle and plays the Lin recovery scene before returning control.
function script.cutscene_lin_recovery_after_battle()
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(30)
		step = 1
		wait.frames(30)
		event.clear_event_battle_monsters(-1)
		event.set_save_control_bits(1, 0)
		event.attach_object_handle_to_map_part_3(0, "p01_s18", "s18_02-a0")
		event.set_object_handle_visible(0, 0)
		step = 2
		play_lin_recovery_scene()
		event.play_music(0)
		character.place_standing(vm.f32(-65.93), 0.0, vm.f32(-944.95), vm.f32(1.07))
		event.set_camera_position(-175.81, 28.77, -1006.32)
		event.set_camera_look_at(-65.93, 30.0, -944.95)
		event.reset_follow_camera(0)
		yordas_valley.set_reverse_floor_enabled(1)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				step = 2
				play_lin_recovery_scene()
				return vm.continue_with(function()
					event.play_music(0)
					character.place_standing(vm.f32(-65.93), 0.0, vm.f32(-944.95), vm.f32(1.07))
					event.set_camera_position(-175.81, 28.77, -1006.32)
					event.set_camera_look_at(-65.93, 30.0, -944.95)
					event.reset_follow_camera(0)
					yordas_valley.set_reverse_floor_enabled(1)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			cutscene.ignore_coordinates(vm.f32(-65.93), 0.0, vm.f32(-944.95), vm.f32(1.07))
			cutscene.ignore_value(1)
			return 0
		end
		return nil
	end)
end
script[500] = script.cutscene_lin_recovery_after_battle

--- Advances the floor and leaves the valley for the dungeon once the exit is confirmed.
function script.leave_valley_to_next_floor()
	local stage_id: s32 = 0
	local current_floor: s32 = 0
	local next_floor: s32 = 0
	if confirm_leave_valley() ~= 0 then
		yordas_valley.set_reverse_floor_enabled(0)
		stage_id = event.get_dungeon_stage_id() or stage_id
		current_floor = event.get_dungeon_floor() or current_floor
		next_floor = event.get_dungeon_next_floor(current_floor, 0) or next_floor
		event.set_dungeon_floor(next_floor)
		event.set_dungeon_floor_info(stage_id, current_floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
		event.set_character_position(0, 0.0, 0.0, 0.0)
		event.load_event_script("d03/d03.stb", 1000)
		return
	end
end
script[502] = script.leave_valley_to_next_floor

--- Plays the crest scene and starts the monster battle.
function script.start_battle_after_crest_scene()
	local active_character: s32 = 0
	local active_music_number: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(30)
		step = 1
		wait.frames(30)
		yordas_valley.set_reverse_floor_enabled(0)
		event.set_function_point_enabled("", "e336", 0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		step = 2
		play_lin_crest_scene()
		event.set_save_control_bits(1, 1)
		event.attach_object_handle_to_map_part_3(30, "p01_s18", "s18_02-a0")
		event.set_object_handle_visible(30, 1)
		active_music_number = event.get_active_music_number() or active_music_number
		if active_music_number ~= 190 then
			event.stop_music(0)
			step = 3
			wait.frames(4)
			event.load_music(190)
		end
		event.play_music(0)
		event.load_dungeon_monster(68, 1)
		event.place_dungeon_monster(68, 0.0, 0.0, 0.0, 0.0, 3.14, 0.0)
		character.place_standing_and_reset_cloth(0.0, 0.0, -100.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, -100.0)
		event.set_camera_position(0.0, 40.0, -220.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				cutscene.ignore_value(0)
				step = 2
				play_lin_crest_scene()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 1)
					event.attach_object_handle_to_map_part_3(30, "p01_s18", "s18_02-a0")
					event.set_object_handle_visible(30, 1)
					active_music_number = event.get_active_music_number() or active_music_number
					if active_music_number ~= 190 then
						event.stop_music(0)
						step = 3
						wait.frames(4)
						event.load_music(190)
					end
					event.play_music(0)
					event.load_dungeon_monster(68, 1)
					event.place_dungeon_monster(68, 0.0, 0.0, 0.0, 0.0, 3.14, 0.0)
					character.place_standing_and_reset_cloth(0.0, 0.0, -100.0, 0.0)
					event.set_camera_look_at(0.0, 30.0, -100.0)
					event.set_camera_position(0.0, 40.0, -220.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			if step <= 2 then
				wait.frames_skipping(4)
			end
			cutscene.ignore_coordinates(0.0, 0.0, -100.0, 0.0)
			return 0
		end
		return nil
	end)
end
script[510] = script.start_battle_after_crest_scene

--- Asks whether to leave the valley and loads the dungeon when confirmed.
function script.leave_valley_to_dungeon()
	local active_character: s32 = 0
	local answer: any = 0
	event.initialize_event()
	vm.wait(1)
	event.reset_action_character_motion(0)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 22, 5, 256, 208)
		else
			message.show_and_wait(0, 23, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	answer = message.ask_yes_no(2, -1)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	if answer == 0 then
		event.fade_out_screen(30)
		wait.frames(30)
		yordas_valley.set_reverse_floor_enabled(0)
		event.load_event_script("d03/d03.stb", 1000)
		return
	end
	event.finish_event()
end
script[520] = script.leave_valley_to_dungeon

--- Runs the silent defeat sequence when the party is defeated here.
function script.on_defeat()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_defeat

--- Plays the Lin worry scene from a black screen.
function script.cutscene_lin_worry()
	event.fade_out_screen(0)
	play_lin_worry_scene()
end
script[13320] = script.cutscene_lin_worry

--- Plays the Lin crest scene from a black screen.
function script.cutscene_lin_crest()
	event.fade_out_screen(0)
	play_lin_crest_scene()
end
script[13360] = script.cutscene_lin_crest

--- Plays the Lin recovery scene from a black screen.
function script.cutscene_lin_recovery()
	event.fade_out_screen(0)
	play_lin_recovery_scene()
end
script[13400] = script.cutscene_lin_recovery

--- Restarts the monster battle with its music.
function script.restart_monster_battle()
	event.initialize_event()
	event.fade_out_screen(0)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(190)
	event.play_music(0)
	event.load_dungeon_monster(68, 1)
	event.place_dungeon_monster(68, 0.0, 0.0, 0.0, 0.0, 3.14, 0.0)
	character.place_standing_and_reset_cloth(0.0, 0.0, -100.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -100.0)
	event.set_camera_position(0.0, 40.0, -220.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end
script[23020] = script.restart_monster_battle

return script
