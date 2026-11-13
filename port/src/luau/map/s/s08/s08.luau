--!strict
--- Locomotive interior script with the crew scene, car doors and the collapse cutscene.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local inside_of_locomotive = require("@lib/event/inside_of_locomotive")
local map = require("@lib/event/map")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local sound_bank: s32 = 0

--- Plays the locomotive sound effects.
local function play_locomotive_sounds()
	event.play_sound_effect(sound_bank, 2)
	event.play_sound_effect(sound_bank, 8)
end

--- Loads and places the locomotive crew and starts the locomotive sounds.
local function place_locomotive_crew()
	event.initialize_event()
	sound_bank = 0
	event.load_map_sounds(2200)
	sound_bank = event.load_sound_effect_file_2(2200) or sound_bank
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "event/e200/e203/e203_starbre.gltf", "info", 9)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(1, 9)
	event.set_character_position(9, 5.62, 36.1, 39.9)
	event.set_character_rotation(9, 0.0, 3.04, 0.0)
	event.set_character_motion(9, "立ち", 4)
	event.load_character(4, "event/e200/e203/e203_vorneo.gltf", "info", 10)
	event.attach_object_handle_to_character(2, 10)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(1, 10)
	event.set_character_position(10, -38.37, 36.08, 32.88)
	event.set_character_rotation(10, 0.0, 1.48, 0.0)
	event.set_character_motion(10, "立ち", 4)
	event.load_character(4, "event/e200/e203/e203_tom.gltf", "info", 11)
	event.attach_object_handle_to_character(3, 11)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(1, 11)
	event.set_character_position(11, -1.81, 36.1, 72.51)
	event.set_character_rotation(11, 0.0, -0.48, 0.0)
	event.set_character_motion(11, "立ち", 4)
	event.set_object_handle_sound_bank(3, sound_bank)
	event.register_villager(9, 1)
	event.register_villager(10, 2)
	event.register_villager(11, 13, 65)
	event.set_scene_character_number(9, 1)
	event.set_scene_character_number(10, 2)
	event.set_scene_character_number(11, 13)
	play_locomotive_sounds()
end

--- Loads the party, the locomotive crew, the locomotive part, the picture sprites and the message file for the picture scene.
local function load_picture_scene_actors()
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.clear_camera_sequence()
	event.load_character_motion_pack(5, "event/e200/e203/e203_mints.gltf", "info", 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.load_character(5, "event/e200/e203/e203_starbre.gltf", "info", 33)
	event.attach_object_handle_to_character(1, 33)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 33)
	event.load_character(5, "event/e200/e203/e203_vorneo.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e203/e203_tom.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e200/e203/e203_sekitan.gltf", "info", 37)
	event.attach_object_handle_to_character(5, 37)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 37)
	event.attach_object_handle_to_map_part_3(4, "p06_kikan", "kikan_06-m")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 3.1415927, 0.0)
	block = event.load_event_image_4(5, "textures/event/e200/e203/e203.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e20301", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 51.2, 41.6)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e20302", block)
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
	event.set_event_sprite_texture(2, "e20303", block)
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
	event.set_event_sprite_texture(3, "e20304", block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(3, 51.2, 41.6)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(13, 3)
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.load_message_file(0, 5, "event/e200/e203/e203.txt")
	event.set_scene_status_flags(1, 0, 256, 1)
end

--- Fades in on the crew at work and pushes the camera in.
local function play_picture_scene_opening(sound_bank: any)
	event.fade_in_screen(30)
	wait.for_frame_count(30)
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_motion(1, "腰に手", 4)
	event.set_object_sequence_motion(2, "斜め向き立ち", 4)
	event.set_object_sequence_motion(3, "石炭", 4)
	event.move_camera_sequence_eased(41.03, 65.52, -72.49, 1.22, 60.93, 25.12, 60, 0, 1.0)
	camera.wait_until_done()
	wait.for_frame_count(20)
end

--- Plays the crew members speaking their first voiced lines.
local function play_crew_first_lines(sound_bank: any)
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_motion(2, "スコップ立ち", 4)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(2030010)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(2030020)
	event.reset_mouth_texture_animations()
end

--- Fades in the second picture and plays its voiced line.
local function show_second_picture(sound_bank: any)
	event.set_character_active(0, 11)
	event.set_character_active(1, 33)
	event.set_event_sprite_size(1, 512.0, 416.0)
	event.set_event_sprite_draw_pass(1, 1)
	event.set_object_sequence_position(11, 256.0, 208.0, 10.0)
	event.set_object_sequence_color(11, 128.0, 128.0, 128.0, 128.0, 15)
	wait.for_frame_count(15)
	event.set_event_sprite_draw_pass(0, 0)
	message.show_voiced(2030060)
end

--- Fades in the third picture and plays its voiced lines.
local function show_third_picture(sound_bank: any)
	event.set_event_sprite_size(2, 512.0, 416.0)
	event.set_event_sprite_draw_pass(2, 1)
	event.set_object_sequence_position(12, 256.0, 208.0, 10.0)
	event.set_object_sequence_color(12, 128.0, 128.0, 128.0, 128.0, 15)
	wait.for_frame_count(15)
	event.set_event_sprite_draw_pass(1, 0)
	message.show_voiced(2030070)
	message.show_voiced(2030073)
end

--- Fades in the fourth picture and plays its voiced lines.
local function show_fourth_picture(sound_bank: any)
	event.set_event_sprite_size(3, 512.0, 416.0)
	event.set_event_sprite_draw_pass(3, 1)
	event.set_object_sequence_position(13, 256.0, 208.0, 0.0)
	event.set_object_sequence_color(13, 128.0, 128.0, 128.0, 128.0, 15)
	wait.for_frame_count(15)
	event.set_event_sprite_draw_pass(2, 0)
	message.show_voiced(2030080)
	message.show_voiced(2030083)
end

--- Fades out the last picture, plays the closing voiced lines and shakes the camera as the locomotive jolts.
local function play_locomotive_shake(se_id: s32)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "無表情")
	event.set_object_sequence_texture_animation(0, 1, "目パチ")
	event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
	event.set_object_sequence_color(13, 0.0, 0.0, 0.0, 15)
	wait.for_frame_count(15)
	event.set_event_sprite_draw_pass(3, 0)
	event.move_camera_sequence_eased(10.91, 58.61, 33.87, 1.64, 58.99, 18.19, 300, 2, 0.4)
	message.show_voiced(2030090)
	event.set_object_sequence_texture_animation(0, 1, "眉真剣")
	message.show_voiced(2030100)
	event.stop_music(0)
	event.play_sound_effect(se_id, 5)
	event.shake_camera_sequence(0.0, 0.8, 0.0, 45)
	wait.for_frame_count(45)
end

--- Plays the party turning around in surprise.
local function play_party_turn_around(se_id: s32)
	event.set_character_active(0, 11)
	event.set_character_active(1, 35)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
	event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
	event.play_sound_effect(se_id, 6)
	event.set_object_sequence_motion(0, "振り返る", 6)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "振り返るL", 0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_motion(3, "立ち", 4)
	wait.for_frame_count(23)
end

--- Plays the crew reacting in alarm and the closing voiced exchange.
local function play_crew_alarm_dialogue(se_id: s32)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "おこり顔")
	event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.play_sound_effect(se_id, 7)
	event.set_object_sequence_motion(1, "驚く", 6)
	event.queue_object_sequence_next_motion(1, "驚くL", 0)
	event.set_object_sequence_motion(2, "驚く", 6)
	event.queue_object_sequence_next_motion(2, "驚くL", 0)
	event.set_object_sequence_motion(3, "驚く", 6)
	event.queue_object_sequence_next_motion(3, "驚くL", 0)
	wait.for_frame_count(20)
	event.play_sound_effect(se_id, 8)
	event.set_mouth_texture_animations(1, "大口パク")
	message.show_voiced(2030110)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(2, "口パク")
	message.show_voiced(2030120)
	event.reset_mouth_texture_animations()
	event.set_camera_sequence_position(23.44, 65.11, 70.77)
	event.set_camera_sequence_look_at(-17.65, 56.75, -37.19)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.set_object_sequence_motion(1, "会話2", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "大口パク")
	message.show_voiced(2030130)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "大口パク")
	message.show_voiced(2030135)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "うなづく", 2)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	wait.until_motion_progress(0, vm.f32(0.267), -1.0, 30)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(2030140)
	event.reset_mouth_texture_animations()
end

--- Plays the picture scene in the locomotive, with the crew conversation, the pictures and the jolt, then restores the camera.
local function play_picture_scene()
	local sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(203, 1)
		event.initialize_event()
		sound_bank = event.load_sound_effect_file_2(2200) or sound_bank
		load_picture_scene_actors()
		event.set_object_handle_sound_bank(3, sound_bank)
		event.stop_music(0)
		wait.for_frame_count(6)
		event.load_music(105)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目パチ")
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.enable_drama_skip()
		event.set_character_active(1, 0)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(41.03, 65.52, -72.49)
		event.set_camera_sequence_look_at(1.22, 121.98, 25.12)
		event.set_object_sequence_position(0, 2.3, 36.08, 14.12)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 5.62, 36.1, 39.9)
		event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(2, -38.37, 36.08, 32.88)
		event.set_object_sequence_rotation(2, 0.0, 1.48, 0.0)
		event.set_object_sequence_position(3, -1.81, 36.1, 72.51)
		event.set_object_sequence_rotation(3, 0.0, -0.48, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.play_sound_effect(sound_bank, 2)
		play_picture_scene_opening(sound_bank)
		event.set_camera_sequence_position(54.99, 53.17, 1.95)
		event.set_camera_sequence_look_at(-1.12, 50.66, 35.36)
		event.move_camera_sequence_angle_height_distance_eased(2.64, 2.9, 55.5, 140, 0, 1.0)
		event.set_object_sequence_position(0, 2.3, 36.08, 14.12)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		play_crew_first_lines(sound_bank)
		camera.wait_until_done()
		event.set_camera_sequence_position(11.36, 60.35, 36.83)
		event.set_camera_sequence_look_at(-1.48, 59.0, 7.39)
		inside_of_locomotive.play_stunned_dialogue(sound_bank)
		inside_of_locomotive.show_first_picture(sound_bank)
		show_second_picture(sound_bank)
		show_third_picture(sound_bank)
		show_fourth_picture(sound_bank)
		event.set_character_active(1, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(12.55, 58.61, 36.64)
		event.set_camera_sequence_look_at(3.28, 58.99, 20.96)
		play_locomotive_shake(sound_bank)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(3.0, 69.45, -14.12)
		event.set_camera_sequence_look_at(-5.47, 39.58, 58.5)
		play_party_turn_around(sound_bank)
		event.set_camera_sequence_position(29.29, 88.68, -13.52)
		event.set_camera_sequence_look_at(-6.48, 65.74, 32.61)
		event.set_object_sequence_position(0, 6.15, 36.08, -1.68)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(2, -18.35, 36.08, 35.6)
		event.set_object_sequence_rotation(2, 0.0, 1.48, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		play_crew_alarm_dialogue(sound_bank)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	inside_of_locomotive.unload_picture_scene_assets()
	event.set_character_active(1, 9)
	event.set_character_active(1, 10)
	event.set_character_active(1, 11)
	event.stop_sound_effect(sound_bank, 2)
	event.stop_sound_effect(sound_bank, 8)
	event.set_camera_sequence_position(29.29, 88.68, -13.52)
	event.set_camera_sequence_look_at(-6.48, 65.74, 32.61)
	event.reset_follow_camera(0)
end

--- Loads the characters and message file for the collapse scene.
local function load_collapse_scene_actors()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e200/e205/e205_starbre.gltf", "info", 32)
	event.attach_object_handle_to_character(0, 32)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 32)
	event.load_character(5, "event/e200/e205/e205_vorneo.gltf", "info", 33)
	event.attach_object_handle_to_character(1, 33)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 33)
	event.load_character(5, "event/e200/e205/e205_tom.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_message_file(0, 5, "event/e200/e205/e205.txt")
	event.set_character_active(0, 0)
end

--- Plays the crew collapsing and Starbre scolding them, then fades out.
local function play_collapse_scene()
	local sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(205, 1)
		event.initialize_event()
		event.load_map_sounds(2206)
		sound_bank = event.load_sound_effect_file_2(2206) or sound_bank
		load_collapse_scene_actors()
		event.stop_music(0)
		event.fade_in_screen(30)
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(26.2, 66.14, -50.83)
		event.set_camera_sequence_look_at(13.28, 59.7, -9.45)
		event.set_object_sequence_position(0, 24.27, 36.08, -15.66)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(1, -25.76, 36.08, 14.84)
		event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
		event.set_object_sequence_position(2, -5.4, 36.08, 70.48)
		event.set_object_sequence_rotation(2, 0.0, -2.64, 0.0)
		event.set_object_sequence_motion(0, "だめじゃ", 4)
		event.set_object_sequence_motion(1, "気絶", 4)
		event.set_object_sequence_motion(2, "錯乱", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.play_sound_effect(sound_bank, 0)
		event.shake_camera_sequence(0.0, 0.5, 0.1, -1)
		event.set_mouth_texture_animations(0, "大口パク")
		message.show_voiced(2050010)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "口パク")
		message.show_voiced(2050020)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.clear_camera_sequence()
	inside_of_locomotive.delete_collapse_scene_characters()
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing for this map.
function script.setup() end

--- Places the crew and function points for the story state and fades in.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local mc_load: s32 = 0
	inside_of_locomotive.show_characters_by_progress()
	inside_of_locomotive.disable_saving()
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		inside_of_locomotive.set_function_points_enabled(1)
		event.set_save_control_bits(1, 1)
	else
		inside_of_locomotive.set_function_points_enabled(0)
	end
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		event.set_character_position(0, 38.0, 36.1, -100.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
	end
	if flag == 1 and flag_2 == 0 then
		place_locomotive_crew()
	end
	event.fade_in_screen(30)
end

--- Shows the locomotive message after the button is released.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(32)
	message.show(0, 1002, 8, 450, 100)
	event.do_nothing(0)
end

--- Leaves through the front door to the station when the door is usable.
function script.exit_front_door()
	local can_use_door: s32 = 0
	print("-------event_200----------------------\n")
	can_use_door = train.is_door_usable(1)
	if can_use_door ~= 0 then
		event.set_save_control_bits(1, 0)
		event.set_save_counter(15, 1)
		event.fade_out_screen(0)
		event.stop_music(0)
		map.jump_to_station()
	end
end
script[200] = script.exit_front_door

--- Leaves through the rear door to the station when the door is usable.
function script.exit_rear_door()
	local can_use_door: s32 = 0
	print("-------event_201----------------------\n")
	can_use_door = train.is_door_usable(0)
	if can_use_door ~= 0 then
		event.set_save_control_bits(1, 0)
		event.set_save_counter(15, 0)
		event.fade_out_screen(0)
		event.stop_music(0)
		map.jump_to_station()
	end
end
script[201] = script.exit_rear_door

--- Goes back to the passenger car unless the crew scene is active.
function script.go_to_passenger_car()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.set_save_control_bits(1, 0)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_save_counter(0, 1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_character_position(0, 0.0, 36.0, 235.0)
		event.set_character_rotation(0, 0.0, 3.14, 0.0)
		event.jump_to_map_2(-1, "s07")
	end
end
script[203] = script.go_to_passenger_car

--- Leaves the locomotive for the next area during the crew scene.
function script.leave_locomotive_for_s03()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.set_save_control_bits(1, 0)
		event.fade_in_screen(30)
		event.stop_sound_effect(sound_bank, 2)
		event.stop_sound_effect(sound_bank, 8)
		event.jump_to_map_3(-1, "s03", 501)
		vm.wait(1)
	end
end
script[204] = script.leave_locomotive_for_s03

--- Requests the town edit event at the front door when it is not usable.
function script.request_edit_at_front_door()
	local can_use_door: s32 = 0
	print("--------------------------event205-------------------------\n")
	can_use_door = train.is_door_usable(1)
	if can_use_door == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end
script[205] = script.request_edit_at_front_door

--- Requests the town edit event at the rear door when it is not usable.
function script.request_edit_at_rear_door()
	local can_use_door: s32 = 0
	print("--------------------------event206-------------------------\n")
	can_use_door = train.is_door_usable(0)
	if can_use_door == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end
script[206] = script.request_edit_at_rear_door

--- Requests the town edit event during the crew scene.
function script.request_edit_during_crew_scene()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event208-------------------------\n")
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end
script[208] = script.request_edit_during_crew_scene

--- Requests the town edit event outside the crew scene.
function script.request_edit_outside_crew_scene()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event209-------------------------\n")
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end
script[209] = script.request_edit_outside_crew_scene

--- Opens the menu with its save data value set.
function script.open_menu()
	event.set_save_data_value(3, 1)
	menu.open_type_7()
	event.set_save_data_value(3, 0)
end
script[400] = script.open_menu

--- Places the crew and plays the picture scene.
function script.cutscene_picture_scene()
	inside_of_locomotive.disable_saving()
	inside_of_locomotive.set_function_points_enabled(1)
	place_locomotive_crew()
	play_picture_scene()
	event.set_save_control_bits(1, 1)
	play_locomotive_sounds()
	event.fade_in_screen(30)
end
script[501] = script.cutscene_picture_scene

--- Plays the collapse scene and goes to the next area.
function script.cutscene_collapse()
	play_collapse_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s03", 512)
	vm.wait(2)
end
script[502] = script.cutscene_collapse

--- Shows what the crew member says to the player.
function script.talk_to_crew()
	local character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	message.set_window_mode(0, 1)
	if character_slot == 9 then
		event.open_message_window_2(0, "なにをもたもたしとる！\nはやくはしごをのぼるんじゃ。")
	end
	if character_slot == 10 then
		event.open_message_window_2(
			0,
			"今は世界がどうしたとか言ってる場合じゃないな。\nユリス、急いで外の様子を見てきてくれ。"
		)
	end
	if character_slot == 11 then
		event.open_message_window_2(
			0,
			"さっきのゆれ方からすると、\nわりと小さい爆弾と思うっす。<page>でも、当たり所が悪いとヤバいっすよ。"
		)
	end
	cutscene.talk(character_slot, -1, 0, 0)
end
script[1000] = script.talk_to_crew

--- Replays the picture scene.
function script.replay_picture_scene()
	place_locomotive_crew()
	play_picture_scene()
	play_locomotive_sounds()
	event.fade_in_screen(30)
end
script[12030] = script.replay_picture_scene

--- Replays the collapse scene.
function script.replay_collapse_scene()
	play_collapse_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s03", 512)
	vm.wait(2)
end
script[12050] = script.replay_collapse_scene

return script
