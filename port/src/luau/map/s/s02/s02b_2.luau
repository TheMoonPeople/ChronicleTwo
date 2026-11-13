--!strict
--- Event script for Sindain Station covering the arrival cutscene that adds Monica to the party, Conda's wine gift and the night cutscene.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sindain_station = require("@lib/event/sindain_station")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local mints_character: s32 = 0
local monica_character: s32 = 0

--- Loads the characters, train parts, motions and messages used by the station arrival cutscene.
local function load_station_arrival_scene()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_character = 0
		monica_character = 33
		event.load_character_motion_pack(5, "event/e200/e207/e207_mints.gltf", "info", mints_character)
		event.attach_object_handle_to_character(0, mints_character)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_character)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_character)
		event.load_equipment_model(5, 1, 4, "info", monica_character)
		event.load_equipment_model(5, 1, 3, "info", monica_character)
		event.load_equipment_model(5, 1, 2, "info", monica_character, 37)
		event.load_character_motion_pack(5, "event/e200/e207/e207_monica.gltf", "info", monica_character)
		event.attach_object_handle_to_character(1, monica_character)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_character)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_character = 32
		monica_character = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_character)
		event.load_equipment_model(5, 0, 4, "info", mints_character)
		event.load_equipment_model(5, 0, 3, "info", mints_character)
		event.load_equipment_model(5, 0, 2, "info", mints_character, 37)
		event.load_character_motion_pack(5, "event/e200/e207/e207_mints.gltf", "info", mints_character)
		event.attach_object_handle_to_character(0, mints_character)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_character)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e207/e207_monica.gltf", "info", monica_character)
		event.attach_object_handle_to_character(1, monica_character)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_character)
	end
	event.change_directory("event/e200/e207/")
	event.load_character(5, "e207_starbre.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "e207_vorneo.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "e207_tom.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_map_part_2(5, "p01_train01")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.change_directory("")
	event.load_message_file(0, 5, "event/e200/e207/e207_1.txt")
	event.set_scene_status_flags(1, mints_character, 256, 1)
	event.set_scene_status_flags(1, monica_character, 256, 1)
end

--- Assigns the two party character slots to the values used after the arrival cutscene is skipped.
local function assign_skipped_party_slots()
	mints_character = 0
	monica_character = 33
	mints_character = 32
	monica_character = 0
end

--- Deletes the characters and sprites loaded for the station arrival cutscene and restores the party.
local function unload_station_arrival_scene()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_character)
		event.set_character_active(0, monica_character)
		event.delete_character_extension_packs(mints_character)
		event.delete_character_extension_packs(monica_character)
		event.delete_character(monica_character)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_character)
		event.set_character_active(0, mints_character)
		event.delete_character_extension_packs(monica_character)
		event.delete_character_extension_packs(mints_character)
		event.delete_character(mints_character)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.set_event_sprite_draw_pass(5, 0)
	event.delete_event_image(0)
end

--- Plays the cutscene in which the train arrives, Monica meets the party and train travel is explained.
local function play_monica_joins_scene()
	local sound_bank: s32 = 0
	local saved_window_mode: s32 = 0
	local checkpoint: number = 0
	vm.section(function()
		checkpoint = 1
		vm.entry(1)
		event.set_save_flag(207, 1)
		event.initialize_event()
		sound_bank = event.load_sound_effect_file_2(2211) or sound_bank
		load_station_arrival_scene()
		event.stop_music(0)
		checkpoint = 2
		wait.frames(4)
		event.load_music(59)
		event.set_object_handle_sound_bank(0, sound_bank)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.set_object_handle_sound_bank(4, sound_bank)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.enable_drama_skip()
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.fade_in_screen(30)
		event.set_camera_sequence_position(-434.98, 136.35, -416.59)
		event.set_camera_sequence_look_at(-204.96, 128.86, -33.25)
		checkpoint = 3
		sindain_station.play_train_braking_sequence(sound_bank)
		event.set_object_handle_shadow_enabled(2, 0)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(-186.23, 38.08, 632.43)
		event.set_camera_sequence_look_at(-133.81, 42.89, 555.58)
		event.set_object_sequence_position(5, 1.3, 8.0, 707.604)
		event.set_object_sequence_position(2, -7.85, 43.32, 488.75)
		event.set_object_sequence_rotation(2, 0.0, -1.2, 0.0)
		event.play_sound_effect(sound_bank, 9)
		event.attach_object_handle_to_map_part_3(10, "p01_train01", "train11-m1")
		event.attach_object_handle_to_map_part_3(11, "p01_train01", "train12-m1")
		event.attach_object_handle_to_map_part_3(12, "p01_train01", "train12-m3")
		event.clear_object_sequence(10)
		event.clear_object_sequence(11)
		event.clear_object_sequence(12)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_object(11, 11)
		event.set_object_sequence_object(12, 12)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
		event.rotate_object_sequence(10, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(11, 0.0, -1.8, 0.0, 30)
		event.rotate_object_sequence(12, 0.0, -1.8, 0.0, 30)
		checkpoint = 4
		wait.frames(30)
		event.set_object_handle_footstep_sound(2, 6)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.move_object_sequence(2, -60.41, 43.32, 482.53, 90)
		checkpoint = 5
		wait.frames(90)
		event.set_object_handle_footstep_sound(2, -1)
		event.play_sound_effect(sound_bank, 10)
		event.set_object_sequence_motion(2, "降りL", 4)
		event.jump_object_sequence(2, -121.4, 0.0, 519.8, -0.3, 16)
		checkpoint = 6
		wait.frames(16)
		checkpoint = 7
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "着地", 6)
		event.set_object_sequence_motion(2, "立ち", 0)
		checkpoint = 8
		wait.frames(16)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
		event.set_object_handle_shadow_enabled(2, 1)
		event.clear_effect_manager()
		sindain_station.load_cutscene_sprites_e207_1()
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_character_active(1, mints_character)
		event.set_camera_sequence_position(-173.15, 24.27, 496.1)
		event.set_camera_sequence_look_at(-105.11, 33.85, 689.64)
		event.set_object_sequence_position(0, -115.15, 2.18, 481.7)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(2, -137.2, 0.0, 503.69)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(2, 0)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(2, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -116.24, 1.91, 584.2, 120)
		event.move_object_sequence(2, -136.14, 0.0, 621.84, 120)
		checkpoint = 9
		wait.frames(120)
		event.set_character_active(1, monica_character)
		event.set_camera_sequence_position(-148.61, 19.95, 659.05)
		event.set_camera_sequence_look_at(-138.99, 22.93, 629.2)
		event.set_object_sequence_position(0, -141.01, 0.0, 578.41)
		event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
		event.set_object_sequence_position(1, -158.87, 0.0, 543.98)
		event.set_object_sequence_rotation(1, 0.0, 0.48, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.24, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "頭をかく", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		checkpoint = 10
		message.show_voiced(2070010)
		event.reset_mouth_texture_animations()
		event.set_effect_value(1, 0)
		event.set_camera_sequence_position(-157.72, 20.49, 508.51)
		event.set_camera_sequence_look_at(-155.0, 20.82, 540.27)
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 15)
		event.set_object_sequence_motion(0, "振り返る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "振り返るL", 0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 11
		message.show_voiced(2070020)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-204.87, 17.59, 518.8)
		event.set_camera_sequence_look_at(-167.74, 18.98, 537.69)
		event.set_object_sequence_position(0, -141.01, 0.0, 578.41)
		event.set_object_sequence_rotation(0, 0.0, 0.72, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, -0.48, 0.0)
		event.set_object_sequence_motion(1, "振り返る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "振り返るL", 0)
		event.play_sound_effect(sound_bank, 11)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 12
		message.show_voiced_for(2070030, 90)
		event.reset_mouth_texture_animations()
		event.play_music(0)
		checkpoint = 13
		wait.frames(3)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 14
		message.show_voiced_for(2070035, 75)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 34)
		event.set_object_sequence_rotation(1, 0.0, -2.16, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_camera_sequence_position(-145.56, 14.05, 606.56)
		event.set_camera_sequence_look_at(-171.06, 25.18, 536.36)
		event.move_camera_sequence_angle_height_distance_eased(1.58, -11.13, 75.72, 180, 2, 0.4)
		checkpoint = 15
		wait.frames(30)
		checkpoint = 16
		message.show_voiced_for(2070040, 120)
		checkpoint = 17
		wait.frames(30)
		event.start_crossfade(30)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.clear_camera_sequence()
		event.set_object_sequence_rotation(0, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_camera_sequence_position(-172.35, 21.82, 561.72)
		event.set_camera_sequence_look_at(-139.13, 21.22, 572.94)
		event.move_camera_sequence_eased(-195.67, 21.82, 534.13, -163.38, 21.22, 544.2, 300, 2, 0.4)
		checkpoint = 18
		wait.frames(45)
		checkpoint = 19
		message.show_voiced_for(2070045, 240)
		checkpoint = 20
		wait.frames(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-98.17, 22.89, 602.25)
		event.set_camera_sequence_look_at(-133.12, 23.35, 577.23)
		event.set_object_sequence_rotation(1, 0.0, 0.48, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -2.68, 0.0)
		event.move_camera_sequence_eased(-115.83, 22.89, 589.95, -133.03, 23.35, 577.11, 510, 2, 0.4)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "振り返る2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "指差し会話", 2)
		event.queue_object_sequence_next_motion(1, "振り返る2戻り", 2)
		event.queue_object_sequence_next_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 2)
		event.queue_object_sequence_next_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_object_sequence_texture_animation(1, 1, "通常口パク")
		checkpoint = 21
		message.show_voiced_for(2070050, 120)
		checkpoint = 22
		message.show_voiced_for(2070055, 210)
		checkpoint = 23
		message.show_voiced_for(2070060, 180)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 24
		message.show_voiced(2070070)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 25
		message.show_voiced(2070075)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-185.14, 25.41, 532.33)
		event.set_camera_sequence_look_at(-163.43, 22.64, 546.85)
		event.set_object_sequence_rotation(0, 0.0, -2.68, 0.0)
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 26
		message.show_voiced(2070080)
		event.reset_mouth_texture_animations()
		checkpoint = 27
		object.wait_until_done(0)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 128.0, 15)
		checkpoint = 28
		wait.frames(45)
		event.set_character_active(0, mints_character)
		event.set_camera_sequence_position(-143.73, 21.02, 571.76)
		event.set_camera_sequence_look_at(-159.34, 21.71, 544.14)
		event.set_object_sequence_motion(1, "説明", 4, -1.0, 1)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 0.0, 15)
		checkpoint = 29
		wait.frames(15)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 30
		message.show_voiced(2070090)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(21, 128.0, 128.0, 128.0, 128.0, 30)
		checkpoint = 31
		message.show_voiced(2070100)
		checkpoint = 32
		message.show_voiced(2070110)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(22, 128.0, 128.0, 128.0, 128.0, 15)
		checkpoint = 33
		wait.frames(15)
		event.set_event_sprite_draw_pass(1, 0)
		checkpoint = 34
		message.show_voiced(2070120)
		checkpoint = 35
		object.wait_until_done(21)
		event.set_character_active(1, mints_character)
		event.set_camera_sequence_position(-147.89, 29.16, 595.33)
		event.set_camera_sequence_look_at(-145.3, 19.8, 562.12)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常口パク")
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_object_sequence_color(22, 128.0, 128.0, 128.0, 0.0, 15)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 36
		message.show_voiced(2070130)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 37
		message.show_voiced(2070140)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 38
		message.show_voiced(2070145)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(23, 128.0, 128.0, 128.0, 128.0, 30)
		checkpoint = 39
		message.show_voiced(2070150)
		checkpoint = 40
		message.show_voiced(2070160)
		event.set_camera_sequence_position(-62.39, 11.55, 592.64)
		event.set_camera_sequence_look_at(-144.81, 34.83, 558.99)
		event.set_object_sequence_position(0, -162.09, 0.0, 562.18)
		event.set_object_sequence_rotation(0, 0.0, -1.84, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.move_camera_sequence_eased(-93.73, 11.55, 579.85, -176.14, 34.83, 546.2, 300, 2, 0.4)
		event.set_object_sequence_color(23, 128.0, 128.0, 128.0, 0.0, 15)
		checkpoint = 41
		wait.frames(15)
		event.set_event_sprite_draw_pass(3, 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 42
		message.show_voiced(2070170)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 43
		message.show_voiced(2070175)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-199.01, 15.5, 557.14)
		event.set_camera_sequence_look_at(-160.33, 20.46, 548.43)
		event.set_object_sequence_motion(0, "右・モニカ見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右・モニカ見L", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 44
		message.show_voiced(2070180)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.set_object_sequence_motion(1, "下を向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "下を向くL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 45
		message.show_voiced(2070190)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 46
		message.show_voiced(2070200)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, mints_character)
		event.set_camera_sequence_position(-189.08, 26.03, 532.05)
		event.set_camera_sequence_look_at(-156.88, 20.88, 545.17)
		event.set_object_sequence_position(1, -158.87, 0.0, 543.98)
		event.set_object_sequence_rotation(1, 0.0, -2.04, 0.0)
		event.move_camera_sequence_eased(-186.83, 24.76, 532.98, -156.88, 20.88, 545.17, 90, 0, 0.4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 47
		message.show_voiced(2070210)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 48
		message.show_voiced(2070220)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 49
		message.show_voiced(2070230)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence()
		event.set_character_active(1, mints_character)
		event.set_camera_sequence_position(-184.15, 26.9, 520.44)
		event.set_camera_sequence_look_at(-163.12, 22.81, 547.31)
		event.set_object_sequence_rotation(0, 0.0, 3.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -0.12, 0.0)
		event.play_sound_effect(sound_bank, 12)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "にぎりこぶし", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "にぎりこぶしL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 50
		message.show_voiced(2070240)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 51
		message.show_voiced(2070250)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_camera_sequence_position(-192.2, 14.16, 580.57)
		event.set_camera_sequence_look_at(-164.89, 19.98, 558.98)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 52
		message.show_voiced(2070260)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 53
		message.show_voiced(2070270)
		event.reset_mouth_texture_animations()
		checkpoint = 54
		wait.frames(45)
		event.set_object_sequence_motion(0, "うなづく（モニカ見）", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 0)
		checkpoint = 55
		wait.frames(37)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 56
		message.show_voiced(2070280)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 14)
		event.set_object_sequence_motion(1, "喜ぶ", 6)
		event.queue_object_sequence_next_motion(1, "喜ぶL", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 57
		message.show_voiced(2070290)
		event.reset_mouth_texture_animations()
		checkpoint = 58
		object.wait_until_done(1)
		event.set_character_active(0, mints_character)
		event.set_camera_sequence_position(-161.91, 19.72, 571.63)
		event.set_camera_sequence_look_at(-157.59, 24.08, 543.43)
		event.play_sound_effect(sound_bank, 19)
		event.set_object_sequence_motion(1, "握手", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "握手L", 0)
		checkpoint = 59
		wait.frames(30)
		checkpoint = 60
		wait.frames(30)
		event.fade_out_music(30)
		event.set_character_active(1, mints_character)
		event.set_character_active(0, monica_character)
		if mints_character == 0 then
			event.set_character_active(0, 37)
		end
		event.set_camera_sequence_position(-158.1, 29.71, 533.72)
		event.set_camera_sequence_look_at(-162.0, 22.25, 561.36)
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.move_camera_sequence_eased(-158.94, 29.71, 539.69, -162.85, 22.25, 567.33, 48, 2, 0.4)
		checkpoint = 61
		camera.wait_until_done()
		checkpoint = 62
		wait.frames(75)
		event.set_character_active(1, monica_character)
		event.set_character_active(1, 37)
		event.set_camera_sequence_position(-189.24, 15.33, 545.99)
		event.set_camera_sequence_look_at(-154.0, 23.32, 554.62)
		event.set_object_sequence_rotation(0, 0.0, 2.88, 0.0)
		event.set_object_sequence_motion(0, "握手", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "握手L", 0)
		checkpoint = 63
		wait.frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.init_sepia_effect(-1, 0)
		event.start_crossfade(30)
		event.start_sepia_effect()
		checkpoint = 64
		wait.frames(30)
		checkpoint = 65
		message.show_voiced_for(2070300, 330)
		event.fade_out_screen(15)
		checkpoint = 66
		wait.frames(15)
		event.end_sepia_effect()
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			assign_skipped_party_slots()
			wait.frames_skipping(4)
		end
		if checkpoint <= 2 then
			sindain_station.skip_train_braking_sequence(sound_bank)
		end
		if checkpoint <= 3 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 4 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 5 then
			wait.frames_skipping(16)
		end
		if checkpoint <= 6 then
			cutscene.skip_command(2)
		end
		if checkpoint <= 7 then
			wait.frames_skipping(16)
		end
		if checkpoint <= 8 then
			wait.background_load_skipping()
			wait.frames_skipping(120)
		end
		if checkpoint <= 9 then
			message.show_voiced_skipping(2070010)
		end
		if checkpoint <= 10 then
			message.show_voiced_skipping(2070020)
		end
		if checkpoint <= 11 then
			message.show_voiced_for_skipping(2070030, 90)
		end
		if checkpoint <= 12 then
			wait.frames_skipping(3)
		end
		if checkpoint <= 13 then
			message.show_voiced_for_skipping(2070035, 75)
		end
		if checkpoint <= 14 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 15 then
			message.show_voiced_for_skipping(2070040, 120)
		end
		if checkpoint <= 16 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 17 then
			wait.frames_skipping(45)
		end
		if checkpoint <= 18 then
			message.show_voiced_for_skipping(2070045, 240)
		end
		if checkpoint <= 19 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 20 then
			message.show_voiced_for_skipping(2070050, 120)
		end
		if checkpoint <= 21 then
			message.show_voiced_for_skipping(2070055, 210)
		end
		if checkpoint <= 22 then
			message.show_voiced_for_skipping(2070060, 180)
		end
		if checkpoint <= 23 then
			message.show_voiced_skipping(2070070)
		end
		if checkpoint <= 24 then
			message.show_voiced_skipping(2070075)
		end
		if checkpoint <= 25 then
			message.show_voiced_skipping(2070080)
		end
		if checkpoint <= 26 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 27 then
			wait.frames_skipping(45)
		end
		if checkpoint <= 28 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 29 then
			message.show_voiced_skipping(2070090)
		end
		if checkpoint <= 30 then
			message.show_voiced_skipping(2070100)
		end
		if checkpoint <= 31 then
			message.show_voiced_skipping(2070110)
		end
		if checkpoint <= 32 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 33 then
			message.show_voiced_skipping(2070120)
		end
		if checkpoint <= 34 then
			cutscene.skip_command(21)
		end
		if checkpoint <= 35 then
			message.show_voiced_skipping(2070130)
		end
		if checkpoint <= 36 then
			message.show_voiced_skipping(2070140)
		end
		if checkpoint <= 37 then
			message.show_voiced_skipping(2070145)
		end
		if checkpoint <= 38 then
			message.show_voiced_skipping(2070150)
		end
		if checkpoint <= 39 then
			message.show_voiced_skipping(2070160)
		end
		if checkpoint <= 40 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 41 then
			message.show_voiced_skipping(2070170)
		end
		if checkpoint <= 42 then
			message.show_voiced_skipping(2070175)
		end
		if checkpoint <= 43 then
			message.show_voiced_skipping(2070180)
		end
		if checkpoint <= 44 then
			message.show_voiced_skipping(2070190)
		end
		if checkpoint <= 45 then
			message.show_voiced_skipping(2070200)
		end
		if checkpoint <= 46 then
			message.show_voiced_skipping(2070210)
		end
		if checkpoint <= 47 then
			message.show_voiced_skipping(2070220)
		end
		if checkpoint <= 48 then
			message.show_voiced_skipping(2070230)
		end
		if checkpoint <= 49 then
			message.show_voiced_skipping(2070240)
		end
		if checkpoint <= 50 then
			message.show_voiced_skipping(2070250)
		end
		if checkpoint <= 51 then
			message.show_voiced_skipping(2070260)
		end
		if checkpoint <= 52 then
			message.show_voiced_skipping(2070270)
		end
		if checkpoint <= 53 then
			wait.frames_skipping(45)
		end
		if checkpoint <= 54 then
			wait.frames_skipping(37)
		end
		if checkpoint <= 55 then
			message.show_voiced_skipping(2070280)
		end
		if checkpoint <= 56 then
			message.show_voiced_skipping(2070290)
		end
		if checkpoint <= 57 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 58 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 59 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 60 then
			wait.background_load_skipping()
		end
		if checkpoint <= 61 then
			local _ = mints_character == 0
			wait.frames_skipping(75)
		end
		if checkpoint <= 62 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 63 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 64 then
			message.show_voiced_for_skipping(2070300, 330)
		end
		if checkpoint <= 65 then
			wait.frames_skipping(15)
		end
		return true
	end)
	vm.section(function()
		checkpoint = 67
		vm.entry(67)
		event.cancel_drama_scene_skip()
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_object_handle_shadow_enabled(2, 1)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_draw_pass(3, 0)
		event.set_event_sprite_draw_pass(4, 0)
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_position(4, 256, 208)
		event.set_event_sprite_size(4, 512, 416)
		event.set_event_sprite_color(4, 0, 0, 0, 128)
		event.set_event_sprite_draw_pass(4, 0)
		event.attach_object_handle_to_sprite(14, 4)
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.clear_camera_sequence()
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(1, mints_character)
		event.set_character_active(1, monica_character)
		event.set_character_active(0, 34)
		event.set_character_active(0, 36)
		event.set_character_active(0, 35)
		event.set_character_active(0, 39)
		event.set_character_active(0, 40)
		event.set_character_active(0, 41)
		event.set_character_active(0, 42)
		event.set_object_sequence_position(0, -162.09, 0.0, 562.18)
		event.set_object_sequence_position(1, -158.87, 0.0, 543.98)
		event.set_object_sequence_position(5, 1.3, 8.0, 700.0)
		event.stop_all_sounds()
		event.stop_music(0)
		event.show_chapter_title(2)
		checkpoint = 68
		vm.wait(68)
		checkpoint = 69
		wait.frames(4)
		event.set_camera_sequence_position(-189.24, 15.33, 545.99)
		event.set_camera_sequence_look_at(-167.18, -44.79, 516.47)
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(14, 0, 0, 0, 128, 0)
		event.fade_in_screen(0)
		checkpoint = 70
		vm.wait(70)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(
			0,
			"[(!)]Monica t'a rejoint. Pour changer de\n   personnage, choisis Personnages (Menu\n   principal) ou appuie sur (L3)."
		)
		checkpoint = 71
		message.show(0, -1, 8, 0, 0)
		checkpoint = 72
		inventory.announce_received(352, 5)
		event.set_message_window_mode(0, 7)
		event.set_camera_sequence_position(-114.91, 26.7, 585.59)
		event.set_camera_sequence_look_at(-547.13, 5.01, 284.33)
		event.set_object_sequence_position(0, -154.04, 0.0, 565.84)
		event.set_object_sequence_rotation(0, 0.0, -2.44, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.48, 0.0)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "指差し立ち", 4, -1.0, 1)
		event.stop_music(0)
		checkpoint = 73
		wait.frames(4)
		event.load_music(1)
		event.play_music(0)
		event.enable_drama_skip()
		event.set_object_sequence_color(14, 0, 0, 0, 0, 30)
		checkpoint = 74
		wait.frames(30)
		event.set_event_sprite_draw_pass(4, 0)
		event.set_object_sequence_motion(1, "指差し会話", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 75
		message.show_voiced_for(2070320, 75)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(-201.47, 17.91, 568.45)
		event.set_camera_sequence_look_at(-154.0, 21.06, 552.83)
		event.set_object_sequence_position(0, -162.09, 0.0, 562.18)
		event.set_object_sequence_rotation(0, 0.0, -1.96, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -1.68, 0.0)
		event.set_object_sequence_position(2, -72.39, 9.71, 707.79)
		event.set_object_sequence_rotation(2, 0.0, -2.64, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 76
		message.show_voiced(2070330)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "振り返る2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "振り返る2L", 0)
		event.set_object_sequence_motion(1, "振り返る3", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "振り返る3L", 0)
		event.set_object_sequence_motion(2, "立ち", 0)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.move_camera_sequence(-217.49, 21.55, 521.2, -180.22, 20.7, 546.04, 33)
		checkpoint = 77
		wait.frames(33)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		event.set_mouth_texture_animations(2, "わらい口パク")
		checkpoint = 78
		message.show_voiced(2070340)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "わらい口パク")
		checkpoint = 79
		message.show_voiced(2070345)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(-171.0, 27.48, 601.08)
		event.set_camera_sequence_look_at(-147.93, 29.07, 706.46)
		event.set_object_sequence_position(3, -154.92, 0.0, 741.22)
		event.set_object_sequence_rotation(3, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(4, -183.74, 0.0, 742.29)
		event.set_object_sequence_rotation(4, 0.0, 2.92, 0.0)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目パチ")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "目パチ")
		event.set_object_sequence_motion(3, "会話2", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 0)
		event.set_object_sequence_motion(4, "立ち", 0)
		event.set_mouth_texture_animations(3, "口パク")
		checkpoint = 80
		message.show_voiced(2070350)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		checkpoint = 81
		message.show_voiced(2070360)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(3, "口パク")
		checkpoint = 82
		message.show_voiced(2070370)
		event.reset_mouth_texture_animations()
		checkpoint = 83
		object.wait_until_done(3)
		event.set_object_sequence_motion(4, "スコップ会話2", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		event.set_mouth_texture_animations(4, "口パク")
		checkpoint = 84
		message.show_voiced(2070380)
		event.reset_mouth_texture_animations()
		checkpoint = 85
		object.wait_until_done(4)
		event.set_object_handle_footstep_sound(3, 1)
		event.set_object_handle_footstep_sound(4, 1)
		event.set_object_sequence_motion(3, "歩き", 0)
		event.rotate_object_sequence(3, 0.0, 0.16, 0.0, 20)
		checkpoint = 86
		wait.frames(10)
		event.set_object_sequence_motion(4, "スコップ歩き", 0)
		event.rotate_object_sequence(4, 0.0, 0.04, 0.0, 20)
		event.delay_object_sequence_position_track(3, 10)
		event.set_object_sequence_motion(3, "走り", 0)
		event.move_object_sequence(3, -107.08, 0.0, 959.69, 45, 1)
		event.delay_object_sequence_position_track(4, 10)
		event.set_object_sequence_motion(4, "スコップ走り", 0)
		event.move_object_sequence(4, -137.0, 0.0, 955.7, 60, 1)
		checkpoint = 87
		wait.frames(60)
		event.set_camera_sequence_position(-182.22, 15.16, 581.8)
		event.set_camera_sequence_look_at(-151.21, 22.1, 543.01)
		event.set_object_sequence_position(0, -141.55, 0.0, 545.23)
		event.set_object_sequence_rotation(0, 0.0, -0.4, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.12, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "手をふる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_motion(4, "スコップ立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 88
		message.show_voiced(2070390)
		event.reset_mouth_texture_animations()
		checkpoint = 89
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 90
		message.show_voiced(2070400)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "うなづく（モニカ見）", 6, -1.0, 1)
		checkpoint = 91
		wait.frames(38)
		event.set_camera_sequence_position(-105.67, 24.06, 557.69)
		event.set_camera_sequence_look_at(-158.84, 23.49, 525.23)
		event.set_object_sequence_position(0, -173.5, 0.0, 515.39)
		event.set_object_sequence_rotation(0, 0.0, -2.0, 0.0)
		event.set_object_sequence_position(1, -158.87, 0.0, 543.98)
		event.set_object_sequence_rotation(1, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.move_object_sequence(1, -170.41, 0.0, 526.61, 45)
		checkpoint = 92
		wait.frames(15)
	end)
	checkpoint = 93
	vm.entry(93)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.clear_effect_manager()
	event.fade_out_screen(30)
	checkpoint = 94
	wait.frames(30)
	event.set_character_position(0, -245.13, 0.0, -21.46)
	event.set_character_rotation(0, 0.0, -1.52, 0.0)
	unload_station_arrival_scene()
	event.reset_follow_camera(1, 0.0, 20.0)
	event.set_camera_position(-300.47, 19.23, -22.1)
	event.set_camera_look_at(-236.15, 23.49, -21.6)
	event.fade_in_screen(30)
	checkpoint = 95
	wait.frames(30)
	saved_window_mode = event.get_message_window_frame() or saved_window_mode
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]Tu peux maintenant te d[UNI00e9]placer en train.\n   Pour retourner [UNI00e0] Palm Brinks faire des\n   courses, choisis Partir dans le menu\n   de la porte du train."
	)
	checkpoint = 96
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)][UNI00c0] mesure que des gens se joignent [UNI00e0] toi,\n   envoie-les dans le train. Tous ceux qui\n   sont dans le train peuvent [UNI00e9]migrer vers<page>les r[UNI00e9]gions de G[UNI00e9]orama ou t'accompagner\ndans les d[UNI00e9]dales pour\nt'assister."
	)
	checkpoint = 97
	message.show(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, saved_window_mode)
end

--- Loads the characters, effects and messages used by the Conda wine cutscene.
local function load_conda_scene()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_character = 0
		monica_character = 32
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", mints_character)
		event.attach_object_handle_to_character(0, mints_character)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_character)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_character)
		event.load_equipment_model(5, 1, 4, "info", monica_character)
		event.load_equipment_model(5, 1, 3, "info", monica_character)
		event.load_equipment_model(5, 1, 2, "info", monica_character, 33)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", monica_character)
		event.attach_object_handle_to_character(1, monica_character)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_character)
		event.set_character_active(1, 33)
	end
	if playable_character == 1 then
		mints_character = 32
		monica_character = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_character)
		event.load_equipment_model(5, 0, 4, "info", mints_character)
		event.load_equipment_model(5, 0, 3, "info", mints_character)
		event.load_equipment_model(5, 0, 2, "info", mints_character, 33)
		event.load_character_motion_pack(5, "event/e200/e209/e209_mints.gltf", "info", mints_character)
		event.attach_object_handle_to_character(0, mints_character)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_character)
		event.set_character_active(1, 33)
		event.load_character_motion_pack(5, "event/e200/e209/e209_monica.gltf", "info", monica_character)
		event.attach_object_handle_to_character(1, monica_character)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_character)
	end
	event.load_character(5, "event/e200/e209/e209_conda.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e209/wine.gltf", "info", 37)
	event.attach_object_handle_to_character(5, 37)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 37)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
	for index = 0, 4 do
		event.load_character(5, "event/e200/e209/e209_magic1.gltf", "info", 41 + index)
		event.attach_object_handle_to_character(10 + index, 41 + index)
		event.clear_object_sequence(10 + index)
		event.set_object_sequence_object(10 + index, 10 + index)
		event.set_character_active(0, 41 + index)
	end
	event.load_character(5, "event/e200/e209/e209_magic2.gltf", "info", 42)
	event.attach_object_handle_to_character(8, 42)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.set_character_active(0, 42)
	event.load_character(5, "event/e200/e209/e209_flower.gltf", "info", 40)
	event.set_character_active(1, 40)
	event.attach_object_handle_to_character(9, 40)
	event.clear_object_sequence(9, 9)
	event.set_object_sequence_object(9, 9)
	event.set_object_sequence_position(9, -885.352, 134.434, -841.894)
	event.set_object_sequence_rotation(9, 2.340434, -0.9010716, 1.0717125)
	print("sync obj------------------------------------------\n")
	event.attach_object_handle_to_map_part_2(11, "p09_s0201")
	event.set_object_handle_visible(11, 0)
	event.initialize_effect_manager(5)
	event.load_effect_base("e209魔法")
	event.create_effect_work_buffer(5)
	event.load_message_file(0, 5, "event/e200/e209/e209_1.txt")
end

--- Deletes the characters loaded for the Conda wine cutscene and restores the party.
local function unload_conda_scene()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_character)
		event.set_character_active(0, monica_character)
		event.delete_character_extension_packs(mints_character)
		event.delete_character_extension_packs(monica_character)
		event.delete_character(monica_character)
		event.delete_character(33)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_character)
		event.set_character_active(0, mints_character)
		event.delete_character_extension_packs(mints_character)
		event.delete_character_extension_packs(monica_character)
		event.delete_character(mints_character)
		event.delete_character(33)
	end
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_character(40)
	for index = 0, 4 do
		event.delete_character(41 + index)
	end
	event.delete_character(42)
end

--- Plays the cutscene in which Conda conjures magic at a flower, then hands the party a bottle of wine.
local function play_conda_wine_scene()
	local sound_bank: s32 = 0
	local item_sound_bank: s32 = 0
	local spawn_x: f32 = 0
	local spawn_y: f32 = 0
	local spawn_z: f32 = 0
	local flower_x: f32 = 0
	local flower_y: f32 = 0
	local flower_z: f32 = 0
	local index: s32 = 0
	local radius: f32 = 0
	local angle: f32 = 0
	local scale: f32 = 0
	local alpha: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.set_save_flag(209, 1)
		event.initialize_event()
		sound_bank = event.load_sound_effect_file_2(2223) or sound_bank
		item_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or item_sound_bank
		load_conda_scene()
		event.stop_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_scene_status_flags(1, mints_character, 256, 1)
		event.set_scene_status_flags(1, monica_character, 256, 1)
		event.stop_music(0)
		checkpoint = 1
		wait.frames(4)
		event.load_music(50)
		event.play_music(0)
		event.enable_drama_skip()
		event.set_character_active(1, mints_character)
		event.set_character_active(1, monica_character)
		event.set_character_active(1, 36)
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(-511.68, 40.04, -655.39)
		event.set_camera_sequence_look_at(-435.03, 32.29, -719.93)
		event.set_object_sequence_position(0, -633.03, 0.0, -833.81)
		event.set_object_sequence_rotation(0, 0.0, -1.44, 0.0)
		event.set_object_sequence_position(1, -635.79, 0.0, -814.6)
		event.set_object_sequence_rotation(1, 0.0, -1.92, 0.0)
		event.set_object_sequence_position(4, -661.7, 0.0, -828.21)
		event.set_object_sequence_rotation(4, 0.0, 1.48, 0.0)
		event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "小人見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(-531.23, 25.72, -753.68)
		event.set_camera_sequence_look_at(-442.13, 24.48, -788.67)
		event.move_camera_sequence_eased(-531.23, 25.72, -753.68, -619.77, 24.48, -800.56, 120, 2, 0.4)
		checkpoint = 2
		camera.wait_until_done()
		event.set_camera_sequence_position(-587.85, 29.47, -818.63)
		event.set_camera_sequence_look_at(-648.63, 21.46, -826.79)
		event.set_camera_sequence_position(-587.85, 29.47, -818.63)
		event.set_camera_sequence_look_at(-648.63, 21.46, -826.79)
		checkpoint = 3
		message.show_voiced(2090620)
		event.play_sound_effect(sound_bank, 15)
		event.set_object_sequence_motion(4, "振り返る", 6)
		event.queue_object_sequence_next_motion(4, "振り返るL", 0)
		checkpoint = 4
		wait.frames(45)
		if mints_character ~= 0 then
			event.set_character_active(0, 33)
		end
		event.set_character_active(0, mints_character)
		event.set_camera_sequence_position(-695.85, 6.37, -803.15)
		event.set_camera_sequence_look_at(-677.57, 12.04, -825.79)
		event.play_sound_effect(sound_bank, 16)
		event.set_object_sequence_motion(4, "杖を振る", 6)
		event.set_object_sequence_motion(4, "杖を振るL", 0)
		do
			local out1, out2, out3 = event.get_character_position(40)
			flower_x = out1 or flower_x
			flower_y = out2 or flower_y
			flower_z = out3 or flower_z
		end
		index = 0
		while index < 10 do
			angle = 0.0
			radius = 0.0
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(4, "tue_saki")
				spawn_x = out1 or spawn_x
				spawn_y = out2 or spawn_y
				spawn_z = out3 or spawn_z
			end
			spawn_x = vm.f32(-694.77)
			spawn_z = vm.f32(-857.66)
			angle = event.get_random_number(1.5707964) or angle
			radius = event.get_random_number(20.0) or radius
			radius = vm.f32(radius + 15.0)
			spawn_x = vm.f32(spawn_x + vm.f32(vm.sin(angle) * radius))
			spawn_z = vm.f32(spawn_z + vm.f32(vm.cos(angle) * radius))
			event.create_effect("e209魔法")
			event.set_effect_first_vector(spawn_x, spawn_y, spawn_z)
			event.set_effect_second_vector(flower_x, flower_y, flower_z)
			checkpoint = 5
			vm.wait(5)
			index = index + 1
		end
		checkpoint = 6
		message.show_voiced(2090630)
		event.set_character_active(0, 41)
		event.set_character_active(1, 42)
		event.set_camera_sequence_position(-620.39, 17.91, -830.69)
		event.set_camera_sequence_look_at(-657.47, 26.12, -833.22)
		event.set_object_sequence_position(8, -763.76, -38.88, -840.29)
		event.set_object_sequence_rotation(8, 0.0, 1.68, 0.0)
		event.play_sound_effect(sound_bank, 17)
		event.set_object_sequence_motion(8, "キラキラ", 4)
		checkpoint = 7
		wait.frames(30)
		event.set_object_sequence_motion(8, "消える", 6)
		event.wait_object_sequence_motion_end(8)
		event.set_character_model_lighting(40, 0)
		event.set_motion_blur(1)
		alpha = 128.0
		scale = 1.0
		while index < 82 do
			if alpha < vm.f32(2.1333334) then
				alpha = 0.0
			else
				alpha = vm.f32(alpha - vm.f32(2.1333334))
			end
			event.set_character_model_color(40, 128.0, 128.0, 128.0, alpha)
			event.set_character_scale(40, scale, scale, scale)
			scale = vm.f32(scale - vm.f32(0.01))
			checkpoint = 8
			vm.wait(8)
			index = index + 1
		end
		checkpoint = 9
		object.wait_until_done(8)
		if mints_character ~= 0 then
			event.set_character_active(1, 33)
		end
		event.set_character_active(1, mints_character)
		event.set_character_active(0, 36)
		event.set_camera_sequence_position(-671.41, 16.73, -811.28)
		event.set_camera_sequence_look_at(-644.75, 19.15, -824.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_motion(0, "驚く", 6, -1.0, 1)
		checkpoint = 10
		wait.frames(23)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(-607.66, 36.8, -768.32)
		event.set_camera_sequence_look_at(-624.43, 27.66, -792.8)
		event.set_camera_sequence_position(-620.75, 27.66, -778.33)
		event.set_camera_sequence_look_at(-631.0, 24.74, -796.76)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
		event.play_sound_effect(sound_bank, 18)
		event.set_object_sequence_motion(4, "振り返る2", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		checkpoint = 11
		wait.frames(36)
		event.set_object_sequence_motion(4, "会話", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		checkpoint = 12
		message.show_voiced(2090640)
		checkpoint = 13
		message.show_voiced(2090650)
		checkpoint = 14
		message.show_voiced(2090660)
		event.set_object_sequence_motion(4, "会話", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		checkpoint = 15
		message.show_voiced(2090670)
		event.set_camera_sequence_position(-686.13, 14.37, -802.47)
		event.set_camera_sequence_look_at(-665.83, 15.3, -815.79)
		event.set_camera_sequence_position(-683.22, 14.18, -807.51)
		event.set_camera_sequence_look_at(-662.33, 17.31, -817.61)
		event.set_object_sequence_rotation(0, 0.0, -1.32, 0.0)
		event.set_object_sequence_rotation(1, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "小人見会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "小人見立ち", 0)
		event.set_object_sequence_motion(0, "もっともだ", 6)
		event.queue_object_sequence_next_motion(0, "小人見立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 16
		message.show_voiced(2090680)
		event.reset_mouth_texture_animations()
		checkpoint = 17
		object.wait_until_done(1)
		checkpoint = 18
		message.show_voiced(2090690)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 19
		message.show_voiced(2090700)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-618.98, 20.59, -766.84)
		event.set_camera_sequence_look_at(-645.79, 21.42, -821.23)
		event.set_camera_sequence_position(-620.75, 27.66, -778.33)
		event.set_camera_sequence_look_at(-631.0, 24.74, -796.76)
		event.reset_object_sequence_dynamic_animation(0)
		checkpoint = 20
		message.show_voiced(2090710)
		event.set_object_sequence_texture_animation(1, 1, "目あき～目あきれ")
		event.play_sound_effect(sound_bank, 19)
		event.set_object_sequence_motion(1, "はぁ？", 6)
		event.queue_object_sequence_next_motion(1, "はぁ？L", 4)
		checkpoint = 21
		message.show_voiced(2090720)
		event.set_object_sequence_motion(1, "う・・・", 2)
		event.queue_object_sequence_next_motion(1, "う・・・L", 0)
		checkpoint = 22
		message.show_voiced(2090730)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(4, "会話", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 0)
		checkpoint = 23
		message.show_voiced(2090740)
		event.set_character_active(1, 37)
		event.attach_character_to_frame(36, "wine", 37)
		event.set_object_sequence_motion(4, "ぶどう酒を渡す", 6)
		event.queue_object_sequence_next_motion(4, "ぶどう酒を渡すL", 0)
		checkpoint = 24
		wait.frames(27)
		event.set_object_sequence_motion(0, "小人見会話", 6)
		event.queue_object_sequence_next_motion(0, "小人見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 25
		message.show_voiced(2090750)
		event.reset_mouth_texture_animations()
		checkpoint = 26
		object.wait_until_done(0)
		checkpoint = 27
		message.show_voiced(2090760)
		checkpoint = 28
		message.show_voiced(2090765)
		event.set_character_active(1, 38)
		event.detach_character_from_frame(37)
		event.attach_character_to_frame(mints_character, "item", 37)
		event.set_camera_sequence_position(-665.1, 35.16, -841.27)
		event.set_camera_sequence_look_at(-637.33, 29.85, -838.63)
		event.set_object_sequence_position(6, -644.57, 33.56, -840.23)
		event.set_object_sequence_rotation(6, 0.0, -1.08, 0.0)
		event.stop_music(0)
		event.play_sound_effect(sound_bank, 20)
		event.play_sound_effect(item_sound_bank, 0)
		event.set_object_sequence_motion(6, "発動", 6)
		event.set_object_sequence_motion(0, "ぶどう酒ゲット", 4, -1.0, 1)
		checkpoint = 29
		inventory.announce_received(370, 1)
		event.set_character_active(0, 37)
		event.set_character_active(0, 38)
		event.play_music(0)
		event.set_object_sequence_motion(1, "小人見立ち", 4, -1.0, 1)
		event.set_camera_sequence_position(-609.41, 36.37, -779.33)
		event.set_camera_sequence_look_at(-630.67, 25.71, -807.05)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(0, "小人見会話", 6)
		event.queue_object_sequence_next_motion(0, "小人見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 30
		message.show_voiced(2090770)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "会話", 6)
		event.queue_object_sequence_next_motion(4, "立ち")
		checkpoint = 31
		message.show_voiced(2090780)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		checkpoint = 32
		wait.frames(30)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			wait.background_load_skipping()
		end
		if checkpoint <= 2 then
			message.show_voiced_skipping(2090620)
		end
		if checkpoint <= 3 then
			wait.frames_skipping(45)
		end
		if checkpoint <= 4 then
			index = 0
			angle = 0.0
			radius = 0.0
			spawn_x = vm.f32(-694.77)
			spawn_z = vm.f32(-857.66)
			radius = vm.f32(radius + 15.0)
			spawn_x = vm.f32(spawn_x + vm.f32(vm.sin(angle) * radius))
			spawn_z = vm.f32(spawn_z + vm.f32(vm.cos(angle) * radius))
		end
		if checkpoint <= 5 then
			local _ = index < 10
			index = index + 1
			message.show_voiced_skipping(2090630)
		end
		if checkpoint <= 6 then
			local _ = mints_character ~= 0
			wait.frames_skipping(30)
		end
		if checkpoint <= 7 then
			alpha = 128.0
			scale = 1.0
			local _ = alpha < vm.f32(2.1333334)
			alpha = 0.0
			alpha = vm.f32(alpha - vm.f32(2.1333334))
			scale = vm.f32(scale - vm.f32(0.01))
		end
		if checkpoint <= 8 then
			local _ = index < 82
			index = index + 1
			cutscene.skip_command(8)
		end
		if checkpoint <= 9 then
			wait.frames_skipping(23)
		end
		if checkpoint <= 10 then
			local _ = mints_character ~= 0
			wait.frames_skipping(36)
		end
		if checkpoint <= 11 then
			message.show_voiced_skipping(2090640)
		end
		if checkpoint <= 12 then
			message.show_voiced_skipping(2090650)
		end
		if checkpoint <= 13 then
			message.show_voiced_skipping(2090660)
		end
		if checkpoint <= 14 then
			message.show_voiced_skipping(2090670)
		end
		if checkpoint <= 15 then
			message.show_voiced_skipping(2090680)
		end
		if checkpoint <= 16 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 17 then
			message.show_voiced_skipping(2090690)
		end
		if checkpoint <= 18 then
			message.show_voiced_skipping(2090700)
		end
		if checkpoint <= 19 then
			message.show_voiced_skipping(2090710)
		end
		if checkpoint <= 20 then
			message.show_voiced_skipping(2090720)
		end
		if checkpoint <= 21 then
			message.show_voiced_skipping(2090730)
		end
		if checkpoint <= 22 then
			message.show_voiced_skipping(2090740)
		end
		if checkpoint <= 23 then
			wait.frames_skipping(27)
		end
		if checkpoint <= 24 then
			message.show_voiced_skipping(2090750)
		end
		if checkpoint <= 25 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 26 then
			message.show_voiced_skipping(2090760)
		end
		if checkpoint <= 27 then
			message.show_voiced_skipping(2090765)
		end
		if checkpoint <= 28 then
			inventory.skip_announce_received(370, 1)
		end
		if checkpoint <= 29 then
			message.show_voiced_skipping(2090770)
		end
		if checkpoint <= 30 then
			message.show_voiced_skipping(2090780)
		end
		if checkpoint <= 31 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	unload_conda_scene()
	event.stop_music(0)
	checkpoint = 33
	wait.frames(4)
	event.load_music(1)
	event.play_music(0)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the engine runs no default event.
function script.default_event() end

--- Plays the arrival cutscene, adds Monica to the party, gives five of item 352 and loads the station script.
function script.cutscene_monica_joins()
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		checkpoint = 1
		train.level_cars()
		sindain_station.hide_villagers()
		checkpoint = 2
		play_monica_joins_scene()
		event.set_npc_party_status(1, 128)
		event.set_npc_party_status(2, 128)
		event.set_npc_party_status(13, 128)
		event.set_save_data_value(0, 4)
		event.set_party_member(1, 1)
		event.set_character_change_enabled(1, 1)
		event.set_character_change_unmasked(1, 1)
		event.add_inventory_item(352, 5)
		checkpoint = 3
		inventory.open_overflow_menu()
		event.fade_in_screen(30)
		event.initialize_event()
		train.tilt_cars()
		sindain_station.show_villagers()
		checkpoint = 4
		vm.wait(4)
		event.load_event_script("s02/s02_1.stb", -1)
		return
	end, function(received: { any })
		if checkpoint <= 4 then
			if checkpoint <= 1 then
				cutscene.noop()
				checkpoint = 2
				play_monica_joins_scene()
				return vm.continue_with(function()
					event.set_npc_party_status(1, 128)
					event.set_npc_party_status(2, 128)
					event.set_npc_party_status(13, 128)
					event.set_save_data_value(0, 4)
					event.set_party_member(1, 1)
					event.set_character_change_enabled(1, 1)
					event.set_character_change_unmasked(1, 1)
					event.add_inventory_item(352, 5)
					checkpoint = 3
					inventory.open_overflow_menu()
					event.fade_in_screen(30)
					event.initialize_event()
					train.tilt_cars()
					sindain_station.show_villagers()
					checkpoint = 4
					vm.wait(4)
					event.load_event_script("s02/s02_1.stb", -1)
					return
				end)
			end
			if checkpoint <= 2 then
				cutscene.skip_step()
			end
			if checkpoint <= 3 then
				sindain_station.skip_crossfade_step()
				cutscene.noop()
			end
			return 0
		end
		return nil
	end)
end
script[501] = script.cutscene_monica_joins

--- Plays Conda's wine cutscene, adds item 370 to the inventory and loads the station script.
function script.cutscene_conda_gives_wine()
	play_conda_wine_scene()
	event.initialize_event()
	event.add_inventory_item(370, 1)
	inventory.open_overflow_menu()
	event.fade_in_screen(30)
	event.attach_object_handle_to_map_part_2(0, "p09_s0201")
	event.set_object_handle_visible(0, 0)
	sindain_station.spawn_villagers()
	train.tilt_cars()
	vm.wait(3)
	event.load_event_script("s02/s02_1.stb", -1)
end
script[502] = script.cutscene_conda_gives_wine

--- Plays the night cutscene at the station and loads the station script at event 504.
function script.cutscene_night_at_station()
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		checkpoint = 1
		train.level_cars()
		sindain_station.hide_villagers()
		checkpoint = 2
		sindain_station.play_event_280_cutscene()
		event.initialize_event()
		train.tilt_cars()
		sindain_station.show_villagers()
		checkpoint = 3
		vm.wait(3)
		event.load_event_script("s02/s02_1.stb", 504)
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				cutscene.noop()
				checkpoint = 2
				sindain_station.play_event_280_cutscene()
				return vm.continue_with(function()
					event.initialize_event()
					train.tilt_cars()
					sindain_station.show_villagers()
					checkpoint = 3
					vm.wait(3)
					event.load_event_script("s02/s02_1.stb", 504)
					return
				end)
			end
			if checkpoint <= 2 then
				sindain_station.skip_crossfade_step()
				cutscene.noop()
			end
			return 0
		end
		return nil
	end)
end
script[503] = script.cutscene_night_at_station

return script
