--!strict
--- Cutscenes of the Moon Flower Palace griffon event sequence in map d06 e01.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local moon_flower_palace_griffon_event = {}

--- Asks the player to confirm entering the dungeon, fades the screen out and returns 1 when accepted, otherwise returns 0.
function moon_flower_palace_griffon_event.confirm_dungeon_entry()
	local answer: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		resume_step = 1
		answer = message.ask_yes_no(5, 97)
		if answer == 0 then
			event.fade_out_screen(30)
			resume_step = 2
			wait.frames(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Asks the player to confirm entering georama editing, fading out and returning 1 on yes, or showing a refusal message and returning 0 when playable character 2 or 3 is active.
function moon_flower_palace_griffon_event.confirm_georama_entry()
	local playable_character: s32 = 0
	local selected_answer: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 or playable_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if playable_character == 2 then
				resume_point = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				resume_point = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.finish_event()
			return 0
		end
		resume_point = 3
		selected_answer = message.ask_yes_no(4, -1)
		if selected_answer == 0 then
			event.fade_out_screen(30)
			resume_point = 4
			wait.frames(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			return 0
		end
		if resume_point <= 4 then
			if resume_point == 3 then
				selected_answer = received[1] :: number
			end
			if resume_point <= 3 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Disables the function points item1 through item22 on the current map.
function moon_flower_palace_griffon_event.disable_item_function_points()
	event.set_function_point_enabled("", "item1", 0)
	event.set_function_point_enabled("", "item2", 0)
	event.set_function_point_enabled("", "item3", 0)
	event.set_function_point_enabled("", "item4", 0)
	event.set_function_point_enabled("", "item5", 0)
	event.set_function_point_enabled("", "item6", 0)
	event.set_function_point_enabled("", "item7", 0)
	event.set_function_point_enabled("", "item8", 0)
	event.set_function_point_enabled("", "item9", 0)
	event.set_function_point_enabled("", "item10", 0)
	event.set_function_point_enabled("", "item11", 0)
	event.set_function_point_enabled("", "item12", 0)
	event.set_function_point_enabled("", "item13", 0)
	event.set_function_point_enabled("", "item14", 0)
	event.set_function_point_enabled("", "item15", 0)
	event.set_function_point_enabled("", "item16", 0)
	event.set_function_point_enabled("", "item17", 0)
	event.set_function_point_enabled("", "item18", 0)
	event.set_function_point_enabled("", "item19", 0)
	event.set_function_point_enabled("", "item20", 0)
	event.set_function_point_enabled("", "item21", 0)
	event.set_function_point_enabled("", "item22", 0)
end

--- Plays the griffon awakening cutscene in which the griffon raises its hands, a glow appears and Mints and Monica recoil in alarm, then returns the playable character to the palace floor.
function moon_flower_palace_griffon_event.play_awakening_cutscene()
	local sound_effect_file: s32 = 0
	local playable_character_id: s32 = 0
	vm.section(function()
		event.set_save_flag(612, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7812)
		sound_effect_file = event.load_sound_effect_file_2(7812) or sound_effect_file
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character_id = event.get_playable_character() or playable_character_id
		event.change_directory("event/e600/e612/")
		event.load_message_file(0, 5, "e612_1.txt")
		if playable_character_id == 0 then
			event.load_character_motion_pack(5, "e612_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character_id == 1 then
			event.load_character_motion_pack(5, "e612_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character_id == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e600/e608/e608_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e600/e612/e612_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.load_character(5, "event/e600/e612/e612_griffon.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2, 10)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e600/e612/e612_ghikari.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5, 13)
		event.set_object_sequence_object(5, 5)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, 16.61, 0.2, 323.16)
		event.set_object_handle_rotation(0, 0.0, 3.11, 0.0)
		event.set_object_handle_motion(0, "かまえるL", 4)
		event.set_object_handle_footstep_sound(0, 4)
		event.set_object_handle_position(1, -19.07, 0.2, 324.55)
		event.set_object_handle_rotation(1, 0.0, 2.99, 0.0)
		event.set_object_handle_motion(1, "身構えL", 4)
		event.set_object_handle_footstep_sound(1, 4)
		event.set_object_handle_position(2, -0.95, 0.2, 164.64)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "両手上げＬ", 4)
		event.set_object_handle_footstep_sound(2, 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(290.66, 22.4, 159.89)
		event.set_camera_sequence_look_at(-25.29, 32.09, 238.0)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_active(0, 13)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		wait.frames(30)
		event.play_sound_effect(sound_effect_file, 0)
		event.set_object_sequence_motion(2, "両手下ろす", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		wait.frames(60)
		event.set_camera_sequence_position(27.47, 43.98, 229.92)
		event.set_camera_sequence_look_at(-0.83, 51.54, 164.19)
		event.set_object_sequence_motion(2, "すばらしい", 4)
		event.delay_object_sequence_motion_track(2, 120)
		event.queue_object_sequence_next_motion(2, "すばらしいＬ", 4)
		message.show_voiced_for(6120340, -1)
		object.wait_until_done(2)
		wait.frames(30)
		event.set_camera_sequence_position(75.01, 95.44, 105.8)
		event.set_camera_sequence_look_at(-40.9, 14.77, 261.94)
		event.set_object_sequence_motion(2, "立ち2", 4)
		event.play_sound_effect(sound_effect_file, 1)
		event.set_object_sequence_motion(1, "何をした？", 6)
		event.queue_object_sequence_next_motion(1, "身構えL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for(6120350, -1)
		wait.frames(30)
		event.set_object_sequence_motion(2, "会話２", 6)
		event.delay_object_sequence_motion_track(2, 60)
		event.queue_object_sequence_next_motion(2, "立ち2", 4)
		message.show_voiced_for(6120360, -1)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-0.97, 16.6, 262.08)
		event.set_camera_sequence_look_at(-1.15, 60.73, 165.4)
		event.set_object_sequence_motion(2, "会話２")
		event.delay_object_sequence_motion_track(2, 240)
		event.queue_object_sequence_next_motion(2, "立ち2", 4)
		message.show_voiced_for(6120365, -1)
		object.wait_until_done(2)
		event.set_camera_sequence_position(17.77, 47.61, 211.35)
		event.set_camera_sequence_look_at(-1.62, 53.0, 164.21)
		event.set_character_active(13)
		event.set_character_visible(13, 1, 1, 0.033333335)
		event.set_object_sequence_position(5, -0.95, 0.2, 164.64)
		event.play_sound_effect(sound_effect_file, 2)
		event.set_object_sequence_motion(2, "両手上げ", 6)
		event.queue_object_sequence_next_motion(2, "両手上げＬ", 4)
		wait.frames(90)
		event.set_camera_sequence_position(-10.24, 9.39, 285.55)
		event.set_camera_sequence_look_at(3.63, 24.57, 346.84)
		event.set_object_sequence_position(0, 10.93, 0.2, 329.45)
		event.set_object_sequence_rotation(0, 0.0, -3.05, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -10.84, 0.2, 327.13)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.shake_camera_sequence_vertically(0.0, 0.2, 0.2, -1)
		event.play_sound_effect(sound_effect_file, 3)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		event.set_object_sequence_motion(0, "びっくり", 6)
		event.queue_object_sequence_next_motion(0, "びっくりL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "ぐらり", 6)
		event.queue_object_sequence_next_motion(1, "ぐらりL", 4)
		wait.frames(90)
		event.set_camera_sequence_position(30.72, 20.08, 266.27)
		event.set_camera_sequence_look_at(-3.69, 16.93, 344.36)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "びっくりキョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "びっくりL", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "きょろきょろ", 6)
		event.queue_object_sequence_next_motion(1, "ぐらりL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for(6120370, 45)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for(6120380, -1)
		event.set_camera_sequence_position(30.39, 12.88, 208.54)
		event.set_camera_sequence_look_at(-1.44, 44.98, 166.69)
		wait.frames(90)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.clear_camera_sequence()
	event.skip_next_music_load()
	event.stop_sound_effect(sound_effect_file, 2)
	event.stop_sound_effect(sound_effect_file, 3)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_active(0)
	event.set_character_position(0, -1.02, 0.2, 111.04)
	event.set_character_rotation(0, 0.0, 3.11, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
end

--- Plays the event 610 cutscene in which a glowing flower shatters in a burst of light.
function moon_flower_palace_griffon_event.play_flower_shatter_scene()
	local sound_effect_file: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(610, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(7809)
		sound_effect_file = event.load_sound_effect_file_2(7809) or sound_effect_file
		event.play_sound_effect(sound_effect_file, 0)
		event.stop_sound_effect(sound_effect_file, 0)
		event.show_dungeon_status_bar(0, 1.0)
		event.set_character_active(0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e600/e610/")
		event.load_message_file(0, 5, "e610_1.txt")
		event.change_directory("")
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(5, 0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "chara/c01_base.gltf", "info", 8)
		event.load_equipment_model(5, 0, 4, "info", 8)
		event.load_equipment_model(5, 0, 3, "info", 8)
		event.load_equipment_model(5, 0, 2, "info", 8, 9)
		event.load_character_motion_pack(5, "event/e600/e610/e610_mints.gltf", "info", 8)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "chara/c02_base.gltf", "info", 10)
		event.load_equipment_model(5, 1, 4, "info", 10)
		event.load_equipment_model(5, 1, 3, "info", 10)
		event.load_equipment_model(5, 1, 2, "info", 10, 11)
		event.load_character_motion_pack(5, "event/e600/e610/e610_monica.gltf", "info", 10)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 10)
		event.attach_object_handle_to_character(1, 10)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "event/e600/e610/e610_hana_sun_ex.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2, 12)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e600/e610/e610_kiran.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(3, 13)
		event.clear_object_sequence(3, 13)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e600/e610/e610_hanakudake.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(4, 14)
		event.clear_object_sequence(4, 14)
		event.set_object_sequence_object(4, 4)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, -36.85, 0.2, 211.1)
		event.set_object_handle_rotation(0, 0.0, -1.13, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 4)
		event.set_object_handle_position(1, 32.44, 0.2, 194.73)
		event.set_object_handle_rotation(1, 0.0, 0.95, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-25.8, 19.87, 265.72)
		event.set_camera_sequence_look_at(-34.35, 19.8, 232.21)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_active(11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.fade_in_screen(30)
		event.set_object_sequence_color(5, 0, 0, 0, 128, 0)
		message.show_voiced(6100010)
		event.set_object_sequence_color(5, 0, 0, 0, 0, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "左向き目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "右向き目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_motion(0, "はっとする", 6)
		event.queue_object_sequence_next_motion(0, "はっとするL", 4)
		object.wait_until_done(0)
		event.play_sound_effect(sound_effect_file, 0)
		event.fade_out_screen(30, 255, 255, 255)
		wait.frames(30)
		event.fade_in_screen(15, 255, 255, 255)
		event.set_camera_sequence_position(24.23, 19.45, 233.89)
		event.set_camera_sequence_look_at(37.75, 19.84, 179.82)
		event.set_object_sequence_motion(1, "ふりかえり", 6)
		event.queue_object_sequence_next_motion(1, "ふりかえりL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for(6100020, 45)
		event.reset_mouth_texture_animations()
		object.wait_until_done(1)
		event.play_sound_effect(sound_effect_file, 1)
		event.fade_out_screen(30, 255, 255, 255)
		wait.frames(30)
		event.play_sound_effect(sound_effect_file, 2)
		event.fade_in_screen(30)
		event.set_object_sequence_color(5, 0, 0, 0, 128, 0)
		wait.frames(30)
		event.fade_out_camera_sequence(0)
		event.set_object_sequence_color(5, 0, 0, 0, 0, 0)
		wait.frames(60)
		event.fade_in_screen(30)
		event.set_dungeon_pause_flags(128, 1)
		event.set_camera_sequence_position(1.98, 6.53, 181.87)
		event.set_camera_sequence_look_at(1.06, 23.97, 120.97)
		event.set_object_sequence_position(1, 12.41, 0.2, 137.08)
		event.set_object_sequence_rotation(1, 0.0, -0.72, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, -9.58, 0.2, 135.04)
		event.set_object_sequence_rotation(0, 0.0, 0.71, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_dungeon_pause_flags(128, 1)
		event.set_event_sprite_draw_pass(0, 0)
		wait.frames(30)
		event.set_character_active(13)
		event.set_object_sequence_position(3, 1.8, 10.3, 168.28)
		event.set_object_sequence_rotation(3, 0.0, 0.48, 0.35)
		event.set_object_sequence_motion(3, "キラン", 4)
		event.set_character_active(14)
		event.set_object_sequence_position(4, 1.24, 13.3, 134.88)
		event.set_object_sequence_motion(4, "現れる", 6)
		event.queue_object_sequence_next_motion(4, "ループ", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "目あき～目とじ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.play_sound_effect(sound_effect_file, 3)
		event.set_object_sequence_motion(0, "光る", 6)
		event.queue_object_sequence_next_motion(0, "下向き立ち", 4)
		event.set_object_sequence_motion(1, "まぶしい", 6)
		event.queue_object_sequence_next_motion(1, "下見立ち", 4)
		wait.frames(15)
		event.set_character_active(12)
		event.set_object_sequence_position(2, 1.24, 13.3, 134.88)
		object.wait_until_done(3)
		event.set_character_active(0, 13)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目とじ～おこり目")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		wait.frames(60)
		event.set_object_sequence_motion(0, "さわろうとする", 6)
		event.queue_object_sequence_next_motion(0, "下向き立ち", 4)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "はじける", 6)
		event.queue_object_sequence_next_motion(1, "下見立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口～大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "まばたき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.delay_object_sequence_motion_track(4, 15)
		event.set_object_sequence_motion(4, "花くだけ", 4)
		event.set_object_sequence_motion_step(4, 0.05)
		wait.frames(30)
		event.set_character_visible(12, 0, 1, 0.1)
		event.play_sound_effect(sound_effect_file, 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口～口とじ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		message.show_voiced_for(6100030, 145)
		message.show_voiced_for(6100040, 60)
		event.fade_out_screen(420, 0, 0, 0)
		message.show_voiced_for(6100050, 240)
		event.set_character_active(0, 14)
		event.set_object_sequence_motion(0, "下→上", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for(6100060, 120)
		wait.frames(60)
		event.fade_in_screen(15, 0, 0, 0)
		event.set_object_sequence_color(5, 0, 0, 0, 128, 0)
		event.set_event_sprite_draw_pass(0, 1)
		message.show_voiced(6100070)
		event.fade_out_screen(30, 255, 255, 255)
		wait.frames(30)
		event.fade_in_screen(15, 255, 255, 255)
		event.set_object_sequence_color(5, 255, 255, 255, 128, 0)
		message.show_voiced(6100080)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(24)
	event.cancel_drama_scene_skip()
	event.load_music(36)
	event.play_music(0)
	event.stop_sound_effect(sound_effect_file, 2)
	event.stop_sound_effect(sound_effect_file, 4)
	event.set_dungeon_pause_flags(128, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_dungeon_pause_flags(128, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
end

--- Plays the event 612 opening cutscene in which the griffon appears before the party, who then run off and fade out.
function moon_flower_palace_griffon_event.play_griffon_appearance_scene()
	local sound_effect_file: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		event.set_save_flag(612, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7814)
		sound_effect_file = event.load_sound_effect_file_2(7814) or sound_effect_file
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e600/e612/")
		event.load_message_file(0, 5, "e612_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e612_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e612_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e600/e608/e608_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e600/e612/e612_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.load_character(5, "event/e600/e612/e612_griffon.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2, 10)
		event.set_object_sequence_object(2, 2)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, 10.61, 0.2, 323.16)
		event.set_object_handle_rotation(0, 0.0, -2.93, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_position(1, -10.07, 0.2, 324.55)
		event.set_object_handle_rotation(1, 0.0, 3.11, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 21)
		event.set_object_handle_position(2, -0.95, 0.2, 164.64)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "両手上げＬ", 4)
		event.set_object_handle_footstep_sound(2, 21)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.19, 19.21, 277.15)
		event.set_camera_sequence_look_at(-0.04, 20.06, 325.14)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		wait.frames(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for(6120390, 60)
		wait.frames(60)
		event.set_camera_sequence_position(-0.94, 45.01, 219.98)
		event.set_camera_sequence_look_at(-0.16, 52.54, 162.81)
		event.play_sound_effect(sound_effect_file, 0)
		event.set_object_sequence_motion(2, "両手下ろす", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced_for(6120400, 75)
		wait.frames(30)
		event.set_object_sequence_motion(2, "ククク", 6)
		event.queue_object_sequence_next_motion(2, "ククク会話", 4)
		event.delay_object_sequence_motion_track(2, 120)
		event.queue_object_sequence_next_motion(2, "クククＬ", 4)
		message.show_voiced_for(6120410, -1)
		object.wait_until_done(2)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(1.81, 6.92, 260.18)
		event.set_camera_sequence_look_at(1.38, 17.89, 324.46)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_object_sequence(0, 12.18, 0.2, 569.18, 60, 1)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(1, -11.66, 0.2, 564.61, 60, 1)
		wait.frames(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.load_message_file(0, -1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.show_dungeon_status_bar(1, 1.0)
end

--- Plays the event 702 cutscene in which the party walks into the palace hall and discusses the painting.
function moon_flower_palace_griffon_event.play_palace_entry_scene()
	local playable_character: s32 = 0
	local sound_effect_file: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_save_flag(702, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.stop_music(0)
		wait.frames(4)
		event.load_music(21)
		event.play_music(0)
		event.load_map_sounds(7816)
		sound_effect_file = event.load_sound_effect_file_2(7816) or sound_effect_file
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e702/")
		event.load_message_file(0, 5, "e702_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e702_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e702_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e700/e702/e702_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e700/e702/e702_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 10.0, 0.0, 600.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -10.0, 0.0, 600.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(1, 21)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.move_object_sequence(0, 8, 0.0, 500, 90)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(1, -8, 0.0, 500, 90)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 44.63, 650.83)
		event.set_camera_sequence_look_at(0.0, 17.43, 579.14)
		event.move_camera_sequence_eased(0.0, 44.63, 650.83, 0.0, 48.22, 579.14, 60, 2, 0.2)
		event.fade_in_screen(30)
		object.wait_until_done(0)
		event.set_camera_sequence_position(25.64, 9.7, 457.81)
		event.set_camera_sequence_look_at(-0.0, 19.0, 494.74)
		event.move_camera_sequence(25.64, 9.7, 357.81, 0.0, 19.0, 394.74, 160)
		event.move_object_sequence(0, 8, 0.0, 400, 160)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4)
		event.move_object_sequence(1, -8, 0.0, 400, 160)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for(7020010, 100)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for(7020020, 30)
		object.wait_until_done(0)
		event.set_camera_sequence_position(0.0, 40.03, 416.7)
		event.set_camera_sequence_look_at(-18.0, 40.45, 363.59)
		event.move_camera_sequence_eased(0.0, 40.03, 416.7, -40.11, 40.45, 389.73, 60, 2, 0.4)
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 40.03, 416.7)
		event.set_camera_sequence_look_at(18.0, 40.45, 363.59)
		event.move_camera_sequence_eased(0.0, 40.03, 416.7, 40.11, 40.45, 389.73, 60, 2, 0.4)
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 18.82, 317.17)
		event.set_camera_sequence_look_at(0.0, 21.57, 360.74)
		event.move_object_sequence(0, 8, 0.0, 360, 40)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "気がつく", 2)
		event.queue_object_sequence_next_motion(0, "そうか！！", 6)
		event.queue_object_sequence_next_motion(0, "そうか！！L", 4)
		event.delay_object_sequence_texture_animation_track(0, 40)
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.delay_object_sequence_texture_animation_track(0, 30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
		event.delay_object_sequence_sound_track(0, 82)
		event.play_object_sequence_sound(0, sound_effect_file, 0)
		event.move_object_sequence(1, -8, 0.0, 350, 56)
		event.delay_object_sequence_rotation_track(1, 46)
		event.rotate_object_sequence(1, 0.0, 2.42, 0.0, 10)
		event.delay_object_sequence_motion_track(1, 56)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_texture_animation_track(1, 50)
		event.set_object_sequence_texture_animation(1, 0, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "前向き～右向き")
		wait.frames(42)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020030)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(7020040)
		event.set_camera_sequence_position(-40.7, 35.07, 417.89)
		event.set_camera_sequence_look_at(-4.43, 24.95, 377.6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "立ち", 4, -1, 1)
		event.set_object_sequence_motion(0, "走り")
		event.rotate_object_sequence(0, 0.0, 2.14, 0.0, 6)
		event.delay_object_sequence_position_track(0, 4)
		event.move_object_sequence(0, 210.81, 0.0, 225.65, 60)
		wait.frames(20)
		event.set_object_handle_footstep_sound(0, 2)
		object.wait_until_done(0)
		event.set_object_sequence_position(0, 718.74, 0.0, -118.54)
		event.set_object_sequence_rotation(0, 0.0, 1.85, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1, 1)
		event.set_camera_sequence_position(24.13, 18.72, 352.73)
		event.set_camera_sequence_look_at(-5.12, 23.16, 345.48)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_sequence_rotation(1, 0.0, 2.06, 0.0)
		wait.frames(20)
		event.move_object_sequence(1, 52.38, 0.0, 313.0, 40)
		event.set_object_sequence_motion(1, "走り")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		event.set_object_handle_texture_animation(1, 1, "口とじ")
		wait.frames(40)
		event.set_camera_sequence_position(757.91, 16.92, -132.45)
		event.set_camera_sequence_look_at(694.19, 20.24, -121.26)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_sequence_rotation(1, 0.0, 1.73, 0.0)
		event.set_object_sequence_position(1, 597.66, 0.0, -109.91)
		event.move_object_sequence(1, 714.6, 0.0, -132.69, 40)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		wait.frames(44)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "前向き～左向き")
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(7020050)
		object.wait_until_done(1)
		event.set_camera_sequence_position(640.61, 12.5, -112.65)
		event.set_camera_sequence_look_at(758.05, 45.97, -133.12)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020060)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(7020070)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020080)
		event.set_camera_sequence_position(757.91, 16.92, -132.45)
		event.set_camera_sequence_look_at(694.19, 20.24, -121.26)
		event.set_object_sequence_rotation(1, 0.0, 0.17, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "ホールを示す", 6)
		event.queue_object_sequence_next_motion(0, "ホールを示すL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020085)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "絵を指す", 6)
		event.queue_object_sequence_next_motion(0, "絵を指すL", 4)
		event.delay_object_sequence_motion_track(1, 24)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020090)
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.set_camera_sequence_position(659.67, 80.0, -113.9)
		event.set_camera_sequence_look_at(778.51, 80.0, -136.24)
		event.move_camera_sequence_eased(659.67, 60.0, -113.9, 778.51, 60.0, -136.24, 200, 2, 0.2)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, 1.73, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020093)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020097)
		camera.wait_until_done()
		event.set_camera_sequence_position(738.56, 22.45, -93.25)
		event.set_camera_sequence_look_at(721.11, 22.0, -138.58)
		event.move_camera_sequence_eased(731.87, 22.45, -90.67, 714.42, 22.0, -136.01, 160, 2, 0.2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020100)
		camera.wait_until_done()
		event.set_camera_sequence_position(640.61, 12.5, -112.65)
		event.set_camera_sequence_look_at(758.05, 45.97, -133.12)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020110)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(7020120)
		event.set_object_sequence_motion(1, "上から右", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "上→左", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(7020130)
		object.wait_until_done(0)
		object.wait_until_done(1)
		event.play_sound_effect(sound_effect_file, 1)
		event.set_object_sequence_motion(1, "面白くなって", 6)
		event.queue_object_sequence_next_motion(1, "面白くなってL", 4)
		event.delay_object_sequence_motion_track(1, 42)
		event.queue_object_sequence_next_motion(1, "面白く_待機", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(7020135)
		event.set_object_sequence_motion(0, "左向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7020140)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
end

--- Plays the long event 612 cutscene in which the griffon and the sun rays appear, with voice lines, wind, motion blur and a camera projection sweep.
function moon_flower_palace_griffon_event.play_sun_ray_griffon_scene()
	local sound_effect_file: s32 = 0
	local special_sound_effect_file: s32 = 0
	local playable_character: s32 = 0
	local wind_direction_x: f32 = 0
	local wind_direction_y: f32 = 0
	local wind_direction_z: f32 = 0
	local frame_index: s32 = 0
	local projection_distance: f32 = 0
	local resume_point: number = 0
	vm.section(function()
		resume_point = 1
		vm.entry(1)
		event.set_save_flag(612, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		resume_point = 2
		wait.frames(4)
		event.load_music(33)
		event.load_map_sounds(7810)
		sound_effect_file = event.load_sound_effect_file_2(7810) or sound_effect_file
		special_sound_effect_file = event.load_sound_effect_file_3(8, "snd2/sp/sp_051.sound.json") or special_sound_effect_file
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e600/e612/")
		event.load_message_file(0, 5, "e612_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e612_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e612_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_equipment_model(5, 0, 0, "info", 8, 10)
			event.load_equipment_model(5, 0, 1, "info", 8, 11)
			event.load_character_motion_pack(5, "event/e600/e612/e612_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_equipment_model(5, 1, 0, "info", 8, 10)
			event.load_equipment_model(5, 1, 1, "info", 8, 11)
			event.load_character_motion_pack(5, "event/e600/e612/e612_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(1, 10)
		event.set_character_active(1, 11)
		event.load_character(5, "event/e600/e612/e612_atora_a.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2, 12)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e600/e612/e612_atora_b.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(3, 13)
		event.clear_object_sequence(3, 13)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e600/e612/e612_sun.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(4, 14)
		event.clear_object_sequence(4, 14)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/e600/e612/e612_griffon.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(5, 15)
		event.clear_object_sequence(5, 15)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "event/e600/e612/e612_sun_ray.gltf", "info", 16)
		event.set_character_active(16)
		event.attach_object_handle_to_character(6, 16)
		event.clear_object_sequence(6, 16)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "event/e600/e612/e612_ghikari.gltf", "info", 17)
		event.set_character_active(17)
		event.attach_object_handle_to_character(7, 17)
		event.clear_object_sequence(7, 17)
		event.set_object_sequence_object(7, 7)
		event.load_character(5, "event/e600/e612/e612_hiraki.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_object_handle_to_character(8, 18)
		event.clear_object_sequence(8, 18)
		event.set_object_sequence_object(8, 8)
		event.load_character(5, "event/e600/e612/e612_sun_eye.gltf", "info", 19)
		event.set_character_active(19)
		event.attach_object_handle_to_character(9, 19)
		event.clear_object_sequence(9, 19)
		event.set_object_sequence_object(9, 9)
		event.set_object_handle_position(0, 18.48, 0.2, 307.68)
		event.set_object_handle_rotation(0, 0.0, -0.53, 0.0)
		event.set_object_handle_motion(0, "戦闘立ち", 4)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_position(1, -23.14, 0.2, 308.89)
		event.set_object_handle_rotation(1, 0.0, 0.23, 0.0)
		event.set_object_handle_motion(1, "剣構え", 4)
		event.set_object_handle_footstep_sound(1, 21)
		event.set_object_handle_position(4, 4.86, 0.2, 441.28)
		event.set_object_handle_rotation(4, 0.0, -3.13, 0.0)
		event.set_object_handle_motion(4, "よろよろ立ち", 4)
		event.set_object_handle_footstep_sound(4, 21)
		event.attach_character_to_frame(14, "hikari", 19)
		event.set_object_handle_visible(9, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-78.74, 78.05, 198.62)
		event.set_camera_sequence_look_at(13.39, 2.21, 381.09)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(14)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "くるし目パチ")
		resume_point = 3
		wait.frames(60)
		event.set_camera_sequence_position(-41.54, 14.05, 496.91)
		event.set_camera_sequence_look_at(12.6, 11.66, 379.4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "くるし目～目とじ")
		event.set_object_sequence_motion(4, "よろよろ会話", 6)
		event.queue_object_sequence_next_motion(4, "よろよろ立ち", 4)
		resume_point = 4
		message.show_voiced_for(6120010, -1)
		event.play_sound_effect(sound_effect_file, 0)
		event.set_object_sequence_motion(4, "倒れる", 6)
		event.queue_object_sequence_next_motion(4, "倒れるＬ", 4)
		resume_point = 5
		object.wait_until_done(4)
		resume_point = 6
		wait.frames(60)
		event.set_camera_sequence_position(-88.01, 116.61, 327.84)
		event.set_camera_sequence_look_at(2.74, 11.66, 406.61)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_object_sequence_position(0, 33.71, 0.2, 365.11)
		event.set_object_sequence_rotation(0, 0.0, -0.17, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -23.96, 0.2, 368.34)
		event.set_object_sequence_rotation(1, 0.0, 0.23, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 28.35, 0.2, 422.7, 60, 1)
		event.delay_object_sequence_rotation_track(0, 30)
		event.rotate_object_sequence(0, 0.0, -0.89, 0.0, 50)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き", 4)
		event.move_object_sequence(1, -23.16, 0.2, 421.62, 70, 1)
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, 0.95, 0.0, 50)
		event.delay_object_sequence_motion_track(1, 70)
		event.set_object_sequence_motion(1, "立ち")
		resume_point = 7
		wait.frames(90)
		resume_point = 8
		message.show_voiced(6120020)
		resume_point = 9
		message.show_voiced(6120030)
		event.set_camera_sequence_position(-36.88, 13.32, 371.24)
		event.set_camera_sequence_look_at(-0.58, 15.51, 433.62)
		event.set_object_sequence_position(0, 24.07, 0.2, 434.14)
		event.set_object_sequence_rotation(0, 0.0, -1.61, 0.0)
		event.set_object_sequence_motion(0, "下見立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -16.95, 0.2, 431.66)
		event.set_object_sequence_rotation(1, 0.0, 1.19, 0.0)
		event.set_object_sequence_motion(1, "下向き立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		resume_point = 10
		wait.frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.play_sound_effect(sound_effect_file, 1)
		event.set_object_sequence_motion(4, "起き上がる", 6)
		event.queue_object_sequence_next_motion(4, "石持ち立ち")
		event.set_object_sequence_motion(0, "のけぞる", 6)
		event.queue_object_sequence_next_motion(0, "のけぞるL", 4)
		event.set_object_sequence_motion(1, "のけぞり", 6)
		event.queue_object_sequence_next_motion(1, "のけぞりL", 4)
		resume_point = 11
		object.wait_until_done(4)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.set_camera_sequence_position(18.01, 15.67, 424.73)
		event.set_camera_sequence_look_at(26.69, 15.51, 433.92)
		event.set_character_active(12)
		event.set_object_sequence_position(4, 9.42, 0.2, 432.34)
		event.set_object_sequence_rotation(4, 0.0, 1.95, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 then
			event.show_atlamillia_frames(0, 0, 0)
		else
			event.show_atlamillia_frames(0, 8, 0)
		end
		event.set_object_sequence_position(2, 25.41, 12.88, 433.35)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.set_object_sequence_motion(4, "ユリスからもぎ取る", 6)
		event.set_object_sequence_motion_step(4, 0.4)
		resume_point = 12
		wait.frames(16)
		event.play_sound_effect(sound_effect_file, 2)
		event.move_object_sequence(2, 24.24, 8.61, 429.7, 3)
		resume_point = 13
		wait.frames(6)
		event.set_character_active(0, 12)
		event.set_camera_sequence_position(-18.72, 20.05, 442.61)
		event.set_camera_sequence_look_at(-16.52, 16.03, 434.01)
		event.set_character_active(1, 13)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			event.show_atlamillia_frames(1, 0, 0)
		else
			event.show_atlamillia_frames(1, 8, 0)
		end
		event.set_object_sequence_position(4, -3.81, 0.2, 442.31)
		event.set_object_sequence_rotation(4, 0.0, -2.33, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_object_sequence_position(3, -15.16, 15.1, 434.91)
		event.set_object_sequence_rotation(3, -0.6, 0.72, 0.0)
		event.set_object_sequence_motion(1, "目で追うL", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(4, "モニカから奪う", 4)
		event.set_object_sequence_motion_step(4, 0.4)
		event.set_scene_status_flags(1, 0, 256, 0)
		resume_point = 14
		wait.frames(10)
		event.play_sound_effect(sound_effect_file, 3)
		event.move_object_sequence(3, -8.89, 18.29, 433.34, 3)
		resume_point = 15
		wait.frames(8)
		event.set_camera_sequence_position(-32.04, 13.37, 229.44)
		event.set_camera_sequence_look_at(23.02, 3.56, 367.15)
		event.set_character_active(1, 12)
		event.set_character_active(1, 13)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(14, "aka_null", 12)
		event.attach_character_to_frame(14, "ao_null", 13)
		event.set_object_sequence_position(0, 24.07, 0.2, 434.14)
		event.set_object_sequence_rotation(0, 0.0, -1.61, 0.0)
		event.set_object_sequence_motion(0, "のけぞるL", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -16.95, 0.2, 431.66)
		event.set_object_sequence_rotation(1, 0.0, 1.19, 0.0)
		event.set_object_sequence_motion(1, "のけぞりL", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(4, 4.86, 0.2, 441.28)
		event.set_object_sequence_rotation(4, 0.0, -3.13, 0.0)
		event.reset_object_sequence_dynamic_animation(4)
		event.set_object_sequence_motion(4, "ジャンプ", 4)
		resume_point = 16
		wait.frames(30)
		event.play_sound_effect(sound_effect_file, 4)
		event.move_object_sequence(4, -4.5, 0.2, 273.3, 30)
		event.delay_object_sequence_motion_track(4, 30)
		event.queue_object_sequence_next_motion(4, "石持ち立ち")
		event.delay_object_sequence_sound_track(4, 30)
		event.play_object_sequence_sound(4, sound_effect_file, 5)
		event.set_object_sequence_motion(0, "しまった！", 6)
		event.queue_object_sequence_next_motion(0, "しまった！L", 4)
		event.set_object_sequence_motion(1, "目で追う", 6)
		event.queue_object_sequence_next_motion(1, "目で追うL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 17
		message.show_voiced_for(6120040, 45)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 18
		message.show_voiced_for(6120050, 70)
		event.play_music(0)
		event.set_camera_sequence_position(-33.83, 58.84, 228.9)
		event.set_camera_sequence_look_at(2.4, 12.62, 165.61)
		event.set_object_sequence_position(4, -0.94, 0.2, 167.47)
		event.reset_object_sequence_dynamic_animation(4)
		event.play_sound_effect(sound_effect_file, 6)
		event.set_object_sequence_motion(4, "振り返る", 6)
		event.rotate_object_sequence(4, 0.0, -0.01, 0.0, 30)
		event.delay_object_sequence_motion_track(4, 30)
		event.queue_object_sequence_next_motion(4, "石持ち立ち")
		resume_point = 19
		object.wait_until_done(4)
		resume_point = 20
		wait.frames(30)
		event.set_object_sequence_motion(4, "不敵に笑う", 6)
		event.queue_object_sequence_next_motion(4, "不敵に笑うＬ", 4)
		event.delay_object_sequence_motion_track(4, 60)
		event.queue_object_sequence_next_motion(4, "不敵に笑う戻り", 4)
		event.queue_object_sequence_next_motion(4, "石持ち立ち", 4)
		resume_point = 21
		message.show_voiced_for(6120060, -1)
		resume_point = 22
		wait.frames(30)
		resume_point = 23
		object.wait_until_done(4)
		event.set_object_sequence_motion(4, "石持ち会話", 6)
		event.queue_object_sequence_next_motion(4, "石持ち立ち", 4)
		resume_point = 24
		message.show_voiced_for(6120065, -1)
		resume_point = 25
		object.wait_until_done(4)
		event.set_camera_sequence_position(-1.12, 3.57, 211.52)
		event.set_camera_sequence_look_at(-1.09, 17.17, 165.43)
		event.set_object_sequence_motion(4, "力を込める", 6)
		event.queue_object_sequence_next_motion(4, "力を込めるＬ", 4)
		resume_point = 26
		wait.frames(60)
		event.set_camera_sequence_position(30.46, 10.46, 194.28)
		event.set_camera_sequence_look_at(-4.46, 14.37, 169.28)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "こわれ目～赤目")
		event.set_object_handle_visible(9, 1)
		event.set_object_sequence_motion(4, "前傾姿勢", 6)
		event.queue_object_sequence_next_motion(4, "前傾姿勢Ｌ", 4)
		event.set_character_active(16)
		event.set_character_visible(16, 1, 1, 0.033333335)
		event.set_object_sequence_position(6, -0.95, 0.2, 164.64)
		event.set_object_sequence_motion(6, "前傾姿勢Ｌ")
		event.shake_camera_sequence_vertically(0.0, 0.2, 0.0, 360)
		event.play_sound_effect(sound_effect_file, 7)
		resume_point = 27
		message.show_voiced_for(6120070, 60)
		event.set_object_sequence_rotation(0, 0.0, -2.81, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		resume_point = 28
		wait.frames(60)
		event.start_crossfade(30)
		event.set_camera_sequence_position(27.23, 15.0, 106.78)
		event.set_camera_sequence_look_at(5.4, 11.56, 187.66)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		resume_point = 29
		wait.frames(90)
		event.set_camera_sequence_position(1.44, 19.01, 221.87)
		event.set_camera_sequence_look_at(-0.86, 15.58, 174.12)
		event.set_object_sequence_motion(6, "アトラミリア光る")
		resume_point = 30
		wait.frames(60)
		event.set_camera_sequence_position(69.6, 17.0, 511.44)
		event.set_camera_sequence_look_at(42.17, 15.58, 462.62)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ")
		event.set_object_sequence_motion(6, "発光")
		event.set_object_sequence_motion_step(6, 0.2)
		resume_point = 31
		wait.frames(15)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "！！", 6)
		event.queue_object_sequence_next_motion(0, "！！L", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "まぶしい", 6)
		event.queue_object_sequence_next_motion(1, "まぶしいL", 4)
		resume_point = 32
		wait.frames(15)
		resume_point = 33
		message.show_voiced_for(6120080, 30)
		event.fade_out_screen(30, 255, 255, 255)
		resume_point = 34
		wait.frames(30)
		event.fade_out_music(30)
		resume_point = 35
		wait.frames(30)
		event.set_character_active(0, 14)
		event.set_character_active(0, 19)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 16)
		event.set_character_active(15)
		event.set_object_sequence_position(5, -0.95, 0.2, 164.64)
		event.set_camera_sequence_position(-1.32, 10.92, 232.98)
		event.set_camera_sequence_look_at(-1.51, 5.74, 176.6)
		event.set_object_sequence_motion(5, "立ち（前傾）")
		resume_point = 36
		wait.frames(30)
		event.fade_in_screen(30, 255, 255, 255)
		event.play_sound_effect(special_sound_effect_file, 0)
		event.move_camera_sequence_eased(-1.32, 10.92, 232.98, -1.51, 45.85, 176.6, 180, 0, 0.5)
		resume_point = 37
		camera.wait_until_done()
		resume_point = 38
		wait.frames(30)
		event.set_camera_sequence_position(83.44, 109.23, 85.27)
		event.set_camera_sequence_look_at(11.63, 44.02, 193.11)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_position(0, 16.61, 0.2, 323.16)
		event.set_object_sequence_rotation(0, 0.0, -2.81, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -19.07, 0.2, 324.55)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(5, "身を起こす", 6)
		event.queue_object_sequence_next_motion(5, "身を起こすＬ", 4)
		event.move_camera_sequence_eased(2.49, 42.34, 46.29, 5.69, 44.02, 193.66, 120, 0, 0.5)
		resume_point = 39
		message.show_voiced_for(6120090, 180)
		resume_point = 40
		camera.wait_until_done()
		event.set_camera_sequence_position(37.69, 39.48, 235.92)
		event.set_camera_sequence_look_at(-1.18, 50.99, 170.42)
		wind_direction_x = vm.f32(-22.54)
		wind_direction_y = vm.f32(20.9)
		wind_direction_z = vm.f32(332.85)
		do
			local out1, out2, out3 = event.subtract_vectors(wind_direction_x, wind_direction_y, wind_direction_z, -8.96, 10.09, 279.73)
			wind_direction_x = out1 or wind_direction_x
			wind_direction_y = out2 or wind_direction_y
			wind_direction_z = out3 or wind_direction_z
		end
		event.set_wind(10, wind_direction_x, wind_direction_y, wind_direction_z)
		event.set_motion_blur(100)
		event.play_sound_effect(sound_effect_file, 8)
		event.set_object_sequence_motion(5, "開く", 6)
		event.queue_object_sequence_next_motion(5, "開くＬ", 4)
		event.set_character_active(18)
		event.delay_object_sequence_motion_track(8, 40)
		event.set_object_sequence_motion(8, "開くＬ", 6)
		event.set_object_sequence_motion(0, "！！L", 4)
		event.set_object_sequence_motion(1, "まぶしいL", 4)
		event.move_camera_sequence_eased(56.18, 9.11, 279.47, -1.71, 41.43, 163.58, 90, 0, 0.5)
		resume_point = 41
		camera.wait_until_done()
		event.set_camera_sequence_position(-63.65, 24.75, 289.98)
		event.set_camera_sequence_look_at(19.98, 11.48, 346.64)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "目とじ")
		event.set_object_sequence_motion(5, "立ち", 4)
		resume_point = 42
		wait.frames(60)
		event.set_character_active(0, 18)
		event.set_camera_sequence_position(45.23, 12.53, 223.31)
		event.set_camera_sequence_look_at(1.37, 42.75, 168.22)
		event.set_wind(-1)
		event.set_motion_blur(0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(5, "会話１")
		resume_point = 43
		message.show_voiced_for(6120100, -1)
		resume_point = 44
		wait.frames(60)
		resume_point = 45
		object.wait_until_done(5)
		event.set_camera_sequence_position(-1.79, 7.56, 386.42)
		event.set_camera_sequence_look_at(-1.26, 25.12, 274.31)
		event.stop_music(0)
		resume_point = 46
		wait.frames(4)
		event.load_music(167)
		event.play_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(5, "立ち１から立ち２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		resume_point = 47
		message.show_voiced(6120110)
		resume_point = 48
		object.wait_until_done(5)
		event.set_camera_sequence_position(-49.43, 5.59, 296.0)
		event.set_camera_sequence_look_at(-7.47, 21.65, 323.75)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "前～左～前")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 49
		message.show_voiced(6120120)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 50
		message.show_voiced(6120125)
		resume_point = 51
		object.wait_until_done(1)
		event.set_camera_sequence_position(-1.79, 7.56, 386.42)
		event.set_camera_sequence_look_at(-1.26, 25.12, 274.31)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		resume_point = 52
		message.show_voiced(6120130)
		event.set_object_sequence_motion(5, "会話２", 4)
		event.delay_object_sequence_motion_track(5, 30)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		resume_point = 53
		message.show_voiced(6120135)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 54
		message.show_voiced(6120140)
		resume_point = 55
		object.wait_until_done(5)
		event.set_camera_sequence_position(45.23, 12.53, 223.31)
		event.set_camera_sequence_look_at(1.37, 42.75, 168.22)
		event.set_object_sequence_motion(5, "会話２", 4)
		event.delay_object_sequence_motion_track(5, 60)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		resume_point = 56
		message.show_voiced_for(6120150, 150)
		resume_point = 57
		object.wait_until_done(5)
		event.set_camera_sequence_position(105.2, 163.52, 42.91)
		event.set_camera_sequence_look_at(-2.23, 23.98, 214.38)
		event.set_object_sequence_motion(5, "会話２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		resume_point = 58
		message.show_voiced_for(6120160, 150)
		event.set_object_sequence_motion(5, "立ち２から立ち１", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		resume_point = 59
		message.show_voiced_for(6120165, 240)
		resume_point = 60
		object.wait_until_done(5)
		event.set_object_sequence_motion(5, "立ち１から立ち２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		event.start_crossfade(30)
		event.set_camera_sequence_position(4.09, 53.77, 197.71)
		event.set_camera_sequence_look_at(12.21, 56.05, 168.85)
		event.set_object_sequence_motion(5, "会話２")
		event.open_voice_stream_wave(1, 6120170)
		resume_point = 61
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.move_camera_sequence(7.33, 53.77, 186.18, 12.21, 56.05, 168.85, 350)
		event.open_message_window_2(0, 6120170)
		message.open(0, -1, 8, 0, 0)
		while frame_index < 350 do
			projection_distance = vm.f32(vm.f32(vm.f32(vm.f32(-224.90002) * frame_index) / 350) + vm.f32(524.9))
			event.set_event_projection(projection_distance)
			frame_index = frame_index + 1
			resume_point = 62
			vm.wait(62)
		end
		message.close(0)
		event.close_voice_stream(1)
		resume_point = 63
		camera.wait_until_done()
		event.set_event_projection(524.9)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-26.16, 2.12, 260.08)
		event.set_camera_sequence_look_at(-0.76, 24.0, 324.82)
		event.set_object_sequence_motion(5, "立ち2", 4)
		resume_point = 64
		message.show_voiced_for(6120180, 240)
		event.start_crossfade(30)
		event.set_camera_sequence_position(52.31, 50.13, 183.8)
		event.set_camera_sequence_look_at(-3.22, 50.82, 166.04)
		event.set_object_sequence_motion(5, "会話２", 6)
		event.delay_object_sequence_motion_track(5, 30)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		resume_point = 65
		message.show_voiced_for(6120185, 130)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.43, 137.04, 56.89)
		event.set_camera_sequence_look_at(-1.45, 10.06, 253.11)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 66
		message.show_voiced_for(6120190, 90)
		event.set_object_sequence_motion(5, "立ち２から立ち１", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.queue_object_sequence_next_motion(5, "会話１", 4)
		resume_point = 67
		message.show_voiced_for(6120200, -1)
		resume_point = 68
		wait.frames(15)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.start_crossfade(30)
		event.set_camera_sequence_position(43.9, 23.5, 203.81)
		event.set_camera_sequence_look_at(-3.91, 54.72, 160.7)
		resume_point = 69
		wait.frames(30)
		event.play_sound_effect(sound_effect_file, 9)
		event.set_object_sequence_motion(5, "握る", 6)
		event.queue_object_sequence_next_motion(5, "会話（握る）")
		event.delay_object_sequence_motion_track(5, 180)
		event.queue_object_sequence_next_motion(5, "握るL", 4)
		resume_point = 70
		message.show_voiced_for(6120210, -1)
		resume_point = 71
		wait.frames(30)
		resume_point = 72
		object.wait_until_done(5)
		event.delay_object_sequence_motion_track(5, 40)
		event.set_object_sequence_motion(5, "振り払う", 6)
		event.queue_object_sequence_next_motion(5, "会話（振り払う）", 4)
		event.delay_object_sequence_motion_track(5, 90)
		event.set_object_sequence_motion(5, "振り払うL")
		event.delay_object_sequence_sound_track(5, 40)
		event.play_object_sequence_sound(5, sound_effect_file, 10)
		event.open_voice_stream_wave(1, 6120220)
		resume_point = 73
		sound.wait_voice_stream_ready(1)
		event.open_message_window_2(0, 6120220)
		message.open(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		resume_point = 74
		wait.frames(40)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.88, 46.09, 208.27)
		event.set_camera_sequence_look_at(-1.11, 54.76, 161.71)
		resume_point = 75
		message.wait_voice_for(0, -1)
		message.close(0)
		event.close_voice_stream(1)
		resume_point = 76
		object.wait_until_done(5)
		resume_point = 77
		wait.frames(30)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.43, 137.04, 56.89)
		event.set_camera_sequence_look_at(-1.45, 10.06, 253.11)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(5)
		resume_point = 78
		wait.frames(15)
		event.set_object_sequence_motion(5, "立ち１から立ち２", 6)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		resume_point = 79
		message.show_voiced_with_button_prompt(6120230, -1, 30)
		resume_point = 80
		object.wait_until_done(5)
		resume_point = 81
		wait.frames(50)
		event.start_crossfade(30)
		event.set_camera_sequence_position(52.31, 50.13, 183.8)
		event.set_camera_sequence_look_at(-3.22, 50.82, 166.04)
		event.set_object_sequence_motion(5, "会話２", 4)
		event.open_voice_stream_wave(1, 6120240)
		resume_point = 82
		sound.wait_voice_stream_ready(1)
		event.open_message_window_2(0, 6120240)
		message.open(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		resume_point = 83
		wait.frames(150)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.16, 53.95, 203.33)
		event.set_camera_sequence_look_at(-0.35, 56.22, 163.1)
		event.move_camera_sequence(-1.0, 53.95, 195.45, -0.35, 56.22, 163.1, 60)
		resume_point = 84
		message.wait_voice_for(0, -1)
		message.close(0)
		event.close_voice_stream(1)
		event.queue_object_sequence_next_motion(5, "立ち2")
		resume_point = 85
		wait.frames(90)
		event.start_crossfade(30)
		event.set_camera_sequence_position(45.23, 12.53, 223.31)
		event.set_camera_sequence_look_at(1.37, 42.75, 168.22)
		event.set_object_sequence_motion(5, "見上げ", 6)
		event.queue_object_sequence_next_motion(5, "見上げＬ", 4)
		resume_point = 86
		message.show_voiced_for(6120250, -1)
		resume_point = 87
		object.wait_until_done(5)
		resume_point = 88
		wait.frames(60)
		event.set_camera_sequence_position(-41.31, 31.65, 268.93)
		event.set_camera_sequence_look_at(5.77, 11.37, 343.93)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.set_object_sequence_motion(1, "なに言ってるの？", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 89
		message.show_voiced_for(6120260, 210)
		resume_point = 90
		object.wait_until_done(1)
		resume_point = 91
		wait.frames(30)
		event.set_camera_sequence_position(-0.97, 16.6, 262.08)
		event.set_camera_sequence_look_at(-1.15, 60.73, 165.4)
		event.set_object_sequence_motion(5, "会話２")
		resume_point = 92
		message.show_voiced_for(6120270, -1)
		resume_point = 93
		wait.frames(20)
		resume_point = 94
		message.show_voiced_for(6120273, -1)
		event.queue_object_sequence_next_motion(5, "立ち2", 4)
		resume_point = 95
		object.wait_until_done(5)
		resume_point = 96
		wait.frames(30)
		event.set_camera_sequence_position(146.05, 155.76, 44.66)
		event.set_camera_sequence_look_at(7.17, 5.69, 214.11)
		event.set_object_sequence_motion(5, "見上げ", 6)
		event.queue_object_sequence_next_motion(5, "見上げＬ", 4)
		resume_point = 97
		message.show_voiced_for(6120280, -1)
		resume_point = 98
		wait.frames(40)
		resume_point = 99
		message.show_voiced_for(6120285, -1)
		resume_point = 100
		wait.frames(30)
		event.set_camera_sequence_position(6.43, 18.29, 287.68)
		event.set_camera_sequence_look_at(16.25, 19.34, 324.59)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.play_sound_effect(sound_effect_file, 11)
		event.set_object_sequence_motion(0, "そんなこと", 6)
		event.queue_object_sequence_next_motion(0, "そんなことL", 4)
		event.delay_object_sequence_motion_track(0, 45)
		event.set_object_sequence_motion(0, "させない", 6)
		event.queue_object_sequence_next_motion(0, "させないL", 4)
		event.delay_object_sequence_sound_track(0, 70)
		event.play_object_sequence_sound(0, sound_effect_file, 12)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_point = 101
		message.show_voiced_for(6120290, 75)
		resume_point = 102
		wait.frames(30)
		event.set_camera_sequence_position(-6.44, 50.54, 216.04)
		event.set_camera_sequence_look_at(-1.0, 48.49, 160.07)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(5, "会話１", 4)
		resume_point = 103
		message.show_voiced_for(6120300, -1)
		resume_point = 104
		wait.frames(30)
		event.set_object_sequence_motion(5, "指す", 2)
		event.queue_object_sequence_next_motion(5, "指す会話", 4)
		resume_point = 105
		message.show_voiced_for(6120305, -1)
		event.queue_object_sequence_next_motion(5, "指すＬ", 4)
		resume_point = 106
		object.wait_until_done(5)
		resume_point = 107
		wait.frames(20)
		event.set_object_sequence_motion(5, "握る２", 6)
		event.queue_object_sequence_next_motion(5, "会話（握る２）", 4)
		event.delay_object_sequence_motion_track(5, 180)
		event.set_object_sequence_motion(5, "振り払う（握る2）", 6)
		event.set_object_sequence_motion(5, "振り払うＬ（握る2）")
		event.delay_object_sequence_sound_track(5, 200)
		event.play_object_sequence_sound(5, sound_effect_file, 10)
		resume_point = 108
		message.show_voiced_for(6120310, -1)
		resume_point = 109
		object.wait_until_done(5)
		resume_point = 110
		wait.frames(30)
		event.set_camera_sequence_position(-1.79, 7.56, 386.42)
		event.set_camera_sequence_look_at(-1.26, 25.12, 274.31)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.reset_object_sequence_dynamic_animation(5)
		resume_point = 111
		wait.frames(20)
		event.set_object_sequence_motion(5, "会話２", 4)
		resume_point = 112
		message.show_voiced_for(6120320, -1)
		event.queue_object_sequence_next_motion(5, "立ち2")
		resume_point = 113
		wait.frames(20)
		event.set_camera_sequence_position(22.17, 49.65, 213.77)
		event.set_camera_sequence_look_at(-1.95, 51.8, 171.81)
		event.set_object_sequence_motion(5, "会話２", 4)
		resume_point = 114
		message.show_voiced_for(6120323, -1)
		event.queue_object_sequence_next_motion(5, "立ち2")
		resume_point = 115
		wait.frames(20)
		event.set_object_sequence_motion(5, "両手ゆっくり", 6)
		event.queue_object_sequence_next_motion(5, "両手ゆっくりＬ", 4)
		resume_point = 116
		message.show_voiced_for(6120327, -1)
		resume_point = 117
		object.wait_until_done(5)
		event.set_camera_sequence_position(27.8, 20.33, 262.64)
		event.set_camera_sequence_look_at(4.57, 15.57, 325.51)
		resume_point = 118
		wait.frames(15)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "身構え", 6)
		event.queue_object_sequence_next_motion(1, "身構えL", 4)
		resume_point = 119
		wait.frames(60)
		event.set_camera_sequence_position(17.33, 128.97, 230.66)
		event.set_camera_sequence_look_at(0.33, 49.98, 168.45)
		event.set_character_active(17)
		event.set_character_visible(17, 1, 1, 0.033333335)
		event.set_object_sequence_position(7, -0.95, 0.2, 164.64)
		event.play_sound_effect(sound_effect_file, 13)
		event.set_object_sequence_motion(5, "天に", 6)
		event.queue_object_sequence_next_motion(5, "天にＬ", 4)
		event.play_sound_effect(sound_effect_file, 14)
		event.play_sound_effect(sound_effect_file, 15)
		resume_point = 120
		wait.frames(30)
		event.shake_camera_sequence_vertically(0.0, 0.3, 0.0, -1)
		event.play_sound_effect(sound_effect_file, 16)
		resume_point = 121
		wait.frames(30)
		event.set_camera_sequence_position(-6.24, 49.19, 375.53)
		event.set_camera_sequence_look_at(-1.83, 51.77, 225.87)
		resume_point = 122
		wait.frames(90)
		event.set_camera_sequence_position(-31.26, 4.98, 277.65)
		event.set_camera_sequence_look_at(0.45, 22.39, 330.46)
		event.set_object_sequence_motion(0, "びっくり", 6)
		event.queue_object_sequence_next_motion(0, "びっくりL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "ぐらり", 6)
		event.queue_object_sequence_next_motion(1, "ぐらりL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		resume_point = 123
		wait.frames(90)
		event.set_camera_sequence_position(57.69, 37.12, 273.28)
		event.set_camera_sequence_look_at(0.0, 49.89, 171.27)
		resume_point = 124
		wait.frames(60)
		event.set_camera_sequence_position(-28.88, 35.65, 295.17)
		event.set_camera_sequence_look_at(-16.06, 17.38, 336.62)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 125
		message.show_voiced_for(6120330, -1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		resume_point = 126
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_point <= 1 then
			wait.frames_skipping(4)
		end
		if resume_point <= 2 then
			wait.frames_skipping(60)
		end
		if resume_point <= 3 then
			message.show_voiced_for_skipping(6120010, -1)
		end
		if resume_point <= 4 then
			cutscene.skip_command(4)
		end
		if resume_point <= 5 then
			wait.frames_skipping(60)
		end
		if resume_point <= 6 then
			wait.frames_skipping(90)
		end
		if resume_point <= 7 then
			message.show_voiced_skipping(6120020)
		end
		if resume_point <= 8 then
			message.show_voiced_skipping(6120030)
		end
		if resume_point <= 9 then
			wait.frames_skipping(30)
		end
		if resume_point <= 10 then
			cutscene.skip_command(4)
		end
		if resume_point <= 11 then
			wait.frames_skipping(16)
		end
		if resume_point <= 12 then
			wait.frames_skipping(6)
		end
		if resume_point <= 13 then
			wait.frames_skipping(10)
		end
		if resume_point <= 14 then
			wait.frames_skipping(8)
		end
		if resume_point <= 15 then
			wait.frames_skipping(30)
		end
		if resume_point <= 16 then
			message.show_voiced_for_skipping(6120040, 45)
		end
		if resume_point <= 17 then
			message.show_voiced_for_skipping(6120050, 70)
		end
		if resume_point <= 18 then
			cutscene.skip_command(4)
		end
		if resume_point <= 19 then
			wait.frames_skipping(30)
		end
		if resume_point <= 20 then
			message.show_voiced_for_skipping(6120060, -1)
		end
		if resume_point <= 21 then
			wait.frames_skipping(30)
		end
		if resume_point <= 22 then
			cutscene.skip_command(4)
		end
		if resume_point <= 23 then
			message.show_voiced_for_skipping(6120065, -1)
		end
		if resume_point <= 24 then
			cutscene.skip_command(4)
		end
		if resume_point <= 25 then
			wait.frames_skipping(60)
		end
		if resume_point <= 26 then
			message.show_voiced_for_skipping(6120070, 60)
		end
		if resume_point <= 27 then
			wait.frames_skipping(60)
		end
		if resume_point <= 28 then
			wait.frames_skipping(90)
		end
		if resume_point <= 29 then
			wait.frames_skipping(60)
		end
		if resume_point <= 30 then
			wait.frames_skipping(15)
		end
		if resume_point <= 31 then
			wait.frames_skipping(15)
		end
		if resume_point <= 32 then
			message.show_voiced_for_skipping(6120080, 30)
		end
		if resume_point <= 33 then
			wait.frames_skipping(30)
		end
		if resume_point <= 34 then
			wait.frames_skipping(30)
		end
		if resume_point <= 35 then
			wait.frames_skipping(30)
		end
		if resume_point <= 36 then
			wait.background_load_skipping()
		end
		if resume_point <= 37 then
			wait.frames_skipping(30)
		end
		if resume_point <= 38 then
			message.show_voiced_for_skipping(6120090, 180)
		end
		if resume_point <= 39 then
			wait.background_load_skipping()
		end
		if resume_point <= 40 then
			wind_direction_x = vm.f32(-22.54)
			wind_direction_y = vm.f32(20.9)
			wind_direction_z = vm.f32(332.85)
			wait.background_load_skipping()
		end
		if resume_point <= 41 then
			wait.frames_skipping(60)
		end
		if resume_point <= 42 then
			message.show_voiced_for_skipping(6120100, -1)
		end
		if resume_point <= 43 then
			wait.frames_skipping(60)
		end
		if resume_point <= 44 then
			cutscene.skip_command(5)
		end
		if resume_point <= 45 then
			wait.frames_skipping(4)
		end
		if resume_point <= 46 then
			message.show_voiced_skipping(6120110)
		end
		if resume_point <= 47 then
			cutscene.skip_command(5)
		end
		if resume_point <= 48 then
			message.show_voiced_skipping(6120120)
		end
		if resume_point <= 49 then
			message.show_voiced_skipping(6120125)
		end
		if resume_point <= 50 then
			cutscene.skip_command(1)
		end
		if resume_point <= 51 then
			message.show_voiced_skipping(6120130)
		end
		if resume_point <= 52 then
			message.show_voiced_skipping(6120135)
		end
		if resume_point <= 53 then
			message.show_voiced_skipping(6120140)
		end
		if resume_point <= 54 then
			cutscene.skip_command(5)
		end
		if resume_point <= 55 then
			message.show_voiced_for_skipping(6120150, 150)
		end
		if resume_point <= 56 then
			cutscene.skip_command(5)
		end
		if resume_point <= 57 then
			message.show_voiced_for_skipping(6120160, 150)
		end
		if resume_point <= 58 then
			message.show_voiced_for_skipping(6120165, 240)
		end
		if resume_point <= 59 then
			cutscene.skip_command(5)
		end
		if resume_point <= 60 then
			cutscene.skip_command(1)
		end
		if resume_point <= 61 then
			message.open_skipping(0, -1, 8, 0, 0)
			projection_distance = vm.f32(vm.f32(vm.f32(vm.f32(-224.90002) * frame_index) / 350) + vm.f32(524.9))
			local _ = frame_index < 350
			frame_index = frame_index + 1
		end
		if resume_point <= 62 then
			message.close_skipping(0)
			wait.background_load_skipping()
		end
		if resume_point <= 63 then
			message.show_voiced_for_skipping(6120180, 240)
		end
		if resume_point <= 64 then
			message.show_voiced_for_skipping(6120185, 130)
		end
		if resume_point <= 65 then
			message.show_voiced_for_skipping(6120190, 90)
		end
		if resume_point <= 66 then
			message.show_voiced_for_skipping(6120200, -1)
		end
		if resume_point <= 67 then
			wait.frames_skipping(15)
		end
		if resume_point <= 68 then
			wait.frames_skipping(30)
		end
		if resume_point <= 69 then
			message.show_voiced_for_skipping(6120210, -1)
		end
		if resume_point <= 70 then
			wait.frames_skipping(30)
		end
		if resume_point <= 71 then
			cutscene.skip_command(5)
		end
		if resume_point <= 72 then
			cutscene.skip_command(1)
		end
		if resume_point <= 73 then
			message.open_skipping(0, -1, 8, 0, 0)
			wait.frames_skipping(40)
		end
		if resume_point <= 74 then
			message.wait_voice_for_skipping(0, -1)
		end
		if resume_point <= 75 then
			message.close_skipping(0)
			cutscene.skip_command(5)
		end
		if resume_point <= 76 then
			wait.frames_skipping(30)
		end
		if resume_point <= 77 then
			wait.frames_skipping(15)
		end
		if resume_point <= 78 then
			message.show_voiced_then_hold_skipping(6120230, -1, 30)
		end
		if resume_point <= 79 then
			cutscene.skip_command(5)
		end
		if resume_point <= 80 then
			wait.frames_skipping(50)
		end
		if resume_point <= 81 then
			cutscene.skip_command(1)
		end
		if resume_point <= 82 then
			message.open_skipping(0, -1, 8, 0, 0)
			wait.frames_skipping(150)
		end
		if resume_point <= 83 then
			message.wait_voice_for_skipping(0, -1)
		end
		if resume_point <= 84 then
			message.close_skipping(0)
			wait.frames_skipping(90)
		end
		if resume_point <= 85 then
			message.show_voiced_for_skipping(6120250, -1)
		end
		if resume_point <= 86 then
			cutscene.skip_command(5)
		end
		if resume_point <= 87 then
			wait.frames_skipping(60)
		end
		if resume_point <= 88 then
			message.show_voiced_for_skipping(6120260, 210)
		end
		if resume_point <= 89 then
			cutscene.skip_command(1)
		end
		if resume_point <= 90 then
			wait.frames_skipping(30)
		end
		if resume_point <= 91 then
			message.show_voiced_for_skipping(6120270, -1)
		end
		if resume_point <= 92 then
			wait.frames_skipping(20)
		end
		if resume_point <= 93 then
			message.show_voiced_for_skipping(6120273, -1)
		end
		if resume_point <= 94 then
			cutscene.skip_command(5)
		end
		if resume_point <= 95 then
			wait.frames_skipping(30)
		end
		if resume_point <= 96 then
			message.show_voiced_for_skipping(6120280, -1)
		end
		if resume_point <= 97 then
			wait.frames_skipping(40)
		end
		if resume_point <= 98 then
			message.show_voiced_for_skipping(6120285, -1)
		end
		if resume_point <= 99 then
			wait.frames_skipping(30)
		end
		if resume_point <= 100 then
			message.show_voiced_for_skipping(6120290, 75)
		end
		if resume_point <= 101 then
			wait.frames_skipping(30)
		end
		if resume_point <= 102 then
			message.show_voiced_for_skipping(6120300, -1)
		end
		if resume_point <= 103 then
			wait.frames_skipping(30)
		end
		if resume_point <= 104 then
			message.show_voiced_for_skipping(6120305, -1)
		end
		if resume_point <= 105 then
			cutscene.skip_command(5)
		end
		if resume_point <= 106 then
			wait.frames_skipping(20)
		end
		if resume_point <= 107 then
			message.show_voiced_for_skipping(6120310, -1)
		end
		if resume_point <= 108 then
			cutscene.skip_command(5)
		end
		if resume_point <= 109 then
			wait.frames_skipping(30)
		end
		if resume_point <= 110 then
			wait.frames_skipping(20)
		end
		if resume_point <= 111 then
			message.show_voiced_for_skipping(6120320, -1)
		end
		if resume_point <= 112 then
			wait.frames_skipping(20)
		end
		if resume_point <= 113 then
			message.show_voiced_for_skipping(6120323, -1)
		end
		if resume_point <= 114 then
			wait.frames_skipping(20)
		end
		if resume_point <= 115 then
			message.show_voiced_for_skipping(6120327, -1)
		end
		if resume_point <= 116 then
			cutscene.skip_command(5)
		end
		if resume_point <= 117 then
			wait.frames_skipping(15)
		end
		if resume_point <= 118 then
			wait.frames_skipping(60)
		end
		if resume_point <= 119 then
			wait.frames_skipping(30)
		end
		if resume_point <= 120 then
			wait.frames_skipping(30)
		end
		if resume_point <= 121 then
			wait.frames_skipping(90)
		end
		if resume_point <= 122 then
			wait.frames_skipping(90)
		end
		if resume_point <= 123 then
			wait.frames_skipping(60)
		end
		if resume_point <= 124 then
			message.show_voiced_for_skipping(6120330, -1)
		end
		if resume_point <= 125 then
			wait.frames_skipping(30)
		end
		return true
	end)
	resume_point = 127
	vm.entry(127)
	event.cancel_drama_scene_skip()
	event.set_motion_blur(0)
	event.set_wind(-1)
	event.stop_music(0)
	event.stop_sound_effect(sound_effect_file, 15)
	event.stop_sound_effect(sound_effect_file, 16)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.show_atlamillia_frames(0, 0, 0)
	else
		event.show_atlamillia_frames(1, 0, 0)
	end
	event.clear_camera_sequence()
	event.skip_next_music_load()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, -1.02, 0.2, 111.04)
	event.set_character_rotation(0, 0.0, 3.11, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the event 608 cutscene in which the party meets the sun figure under a title telop, then restores the field camera and music.
function moon_flower_palace_griffon_event.play_sun_telop_scene()
	local sound_effect_file: s32 = 0
	local playable_character: s32 = 0
	local telop_image: s32 = 0
	vm.section(function()
		event.fade_out_screen(0)
		event.set_save_flag(608, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(51)
		event.play_music(0)
		event.load_map_sounds(7806)
		sound_effect_file = event.load_sound_effect_file_2(7806) or sound_effect_file
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e600/e608/")
		event.load_message_file(0, 5, "e608_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e608_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e608_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		telop_image = event.load_event_image_4(5, "e608telop01_1.json", 0) or telop_image
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e608telop01", telop_image)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(4, 0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 10)
			event.load_character_motion_pack(5, "event/e600/e608/e608_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 10)
			event.load_character_motion_pack(5, "event/e600/e608/e608_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(10)
		event.load_character(5, "event/e600/e608/e608_f_sun.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2, 11)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e600/e608/e608_sun.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(3, 12)
		event.clear_object_sequence(3, 12)
		event.set_object_sequence_object(3, 3)
		event.set_object_handle_position(0, 18.8, 0.2, 627.69)
		event.set_object_handle_rotation(0, 0.0, 3.07, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 21)
		event.set_object_handle_position(1, -18.33, 0.2, 634.43)
		event.set_object_handle_rotation(1, 0.0, 3.11, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 21)
		event.set_object_handle_position(2, -1.11, 280.0, -571.36)
		event.set_object_handle_rotation(2, 0.0, -0.01, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 21)
		event.set_object_handle_position(3, 0.59, 43.94, -81.95)
		event.set_object_handle_rotation(3, 0.0, -0.01, 0.0)
		event.set_object_handle_motion(3, "両手広げるＬ", 4)
		event.set_object_handle_footstep_sound(3, 21)
		event.enable_drama_skip()
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-3.47, 496.82, -690.82)
		event.set_camera_sequence_look_at(-5.22, 214.08, 91.62)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(10)
		event.set_character_active(11)
		event.set_character_active(0, 12)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 18.97, 0.2, 554.51, 90, 1)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -18.13, 0.2, 545.88, 90, 1)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(1)
		wait.frames(30)
		event.set_camera_sequence_position(-2.06, 19.94, 249.02)
		event.set_camera_sequence_look_at(-1.59, 24.2, 291.92)
		event.set_object_sequence_position(1, -9.31, 0.2, 281.32)
		event.set_object_sequence_rotation(1, 0.0, 2.99, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 7.09, 0.2, 282.56)
		event.set_object_sequence_rotation(0, 0.0, -2.97, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 5)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		object.wait_until_done(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		message.show_voiced_for(6080010, -1)
		wait.frames(30)
		event.set_camera_sequence_position(-154.98, 28.42, 533.81)
		event.set_camera_sequence_look_at(-279.55, 40.6, 353.0)
		event.move_camera_sequence(225.39, 28.42, 472.47, 339.8, 36.75, 291.8, 360)
		camera.wait_until_done()
		event.move_camera_sequence(-3.33, 119.35, 266.15, -1.27, 158.81, 55.32, 90)
		camera.wait_until_done()
		wait.frames(30)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.36, 292.54, -536.23)
		event.set_camera_sequence_look_at(-2.12, 298.3, -575.85)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目")
		event.set_object_sequence_position(1, -18.46, 0.2, 55.61)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 14.5, 0.2, 63.44)
		event.reset_object_sequence_dynamic_animation(0)
		wait.frames(60)
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, -1.25, 130.16, -257.23, 400, 1)
		event.delay_object_sequence_motion_track(2, 400)
		event.set_object_sequence_motion(2, "立ち")
		wait.frames(30)
		event.set_camera_sequence_position(-3.6, 35.33, 230.79)
		event.set_camera_sequence_look_at(-2.02, 46.97, 103.92)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上→左", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "上から右", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		object.wait_until_done(1)
		wait.frames(30)
		message.show_voiced_for(6080020, -1)
		event.set_object_sequence_motion(0, "左→上", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "右から上", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		wait.frames(30)
		message.show_voiced_for(6080025, -1)
		object.wait_until_done(2)
		event.set_camera_sequence_position(42.03, 12.5, 8.79)
		event.set_camera_sequence_look_at(-17.69, 20.13, 73.01)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for(6080030, -1)
		wait.frames(15)
		event.set_camera_sequence_position(-1.98, 141.34, -232.47)
		event.set_camera_sequence_look_at(-1.03, 144.72, -259.94)
		message.show_voiced_for(6080040, -1)
		wait.frames(15)
		event.set_object_sequence_motion(2, "笑う", 6)
		event.queue_object_sequence_next_motion(2, "笑うL", 4)
		event.queue_object_sequence_next_motion(2, "笑う戻り", 4)
		event.queue_object_sequence_next_motion(2, "立ち")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目～わらい目")
		message.show_voiced_for(6080045, -1)
		event.set_camera_sequence_position(-3.6, 35.33, 230.79)
		event.set_camera_sequence_look_at(-2.02, 46.97, 103.92)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目")
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, -0.89, 36.96, -59.99, 400, 1)
		event.delay_object_sequence_motion_track(2, 400)
		event.set_object_sequence_motion(2, "立ち")
		message.show_voiced_for(6080050, -1)
		wait.frames(30)
		message.show_voiced_for(6080060, -1)
		wait.frames(15)
		message.show_voiced_for(6080070, -1)
		wait.frames(30)
		message.show_voiced_for(6080075, -1)
		event.play_sound_effect(sound_effect_file, 3)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, sound_effect_file, 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "身構え", 6)
		event.queue_object_sequence_next_motion(1, "身構えL", 4)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "笑う", 6)
		event.queue_object_sequence_next_motion(2, "笑うL", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目～わらい目")
		message.show_voiced_for(6080080, -1)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目")
		wait.frames(15)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.56, 41.19, 0.3)
		event.set_camera_sequence_look_at(-0.5, 43.3, -50.78)
		event.move_camera_sequence_eased(-1.3, 37.59, -12.38, -0.5, 43.3, -50.78, 120, 2, 1.0)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		wait.frames(120)
		event.set_object_sequence_color(4, 128, 128, 128, 0, 30)
		wait.frames(30)
		event.set_camera_sequence_position(13.66, 39.05, 16.1)
		event.set_camera_sequence_look_at(16.97, 18.33, 61.91)
		event.set_object_sequence_motion(2, "立ち")
		event.move_camera_sequence(-16.73, 39.05, 18.35, -15.62, 18.33, 64.27, 120)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for(6080090, -1)
		event.set_camera_sequence_position(1.22, 23.49, 141.64)
		event.set_camera_sequence_look_at(1.34, 25.13, 39.83)
		event.set_object_sequence_motion(2, "フードに手をやる", 6)
		event.queue_object_sequence_next_motion(2, "フードに手をやるL", 4)
		wait.frames(60)
		event.play_sound_effect(sound_effect_file, 5)
		event.set_camera_sequence_position(33.21, 53.76, -44.92)
		event.set_camera_sequence_look_at(3.6, 57.9, -78.66)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目とじ")
		event.set_character_active(0, 11)
		event.set_character_active(12)
		event.set_object_sequence_motion(3, "頭ぶるぶる", 6)
		event.queue_object_sequence_next_motion(3, "両手広げる", 4)
		event.queue_object_sequence_next_motion(3, "両手広げるＬ", 4)
		object.wait_until_done(3)
		event.set_object_sequence_motion(3, "両手広げ会話")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目とじ～目あき")
		message.show_voiced_for(6080100, -1)
		wait.frames(20)
		event.delay_camera_sequence_position_track(60)
		event.set_camera_sequence_position(9.9, 35.11, 33.88)
		event.set_camera_sequence_look_at(15.48, 21.68, 64.42)
		event.move_camera_sequence(11.17, 31.65, 40.85, 15.48, 21.68, 64.42, 60)
		event.set_camera_sequence_position(-14.64, 35.21, 35.6)
		event.set_camera_sequence_look_at(-16.78, 21.68, 60.9)
		event.delay_object_sequence_texture_animation_track(3, 60)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "こわれ目パチ")
		event.move_camera_sequence(-14.36, 32.13, 37.22, -17.13, 20.52, 65.0, 60)
		event.set_camera_sequence_position(0.31, 58.43, -61.11)
		event.set_camera_sequence_look_at(0.74, 63.75, -85.24)
		event.set_object_sequence_motion(3, "両手広げ会話", 4)
		event.delay_object_sequence_motion_track(3, 150)
		event.set_object_sequence_motion(3, "両手広げるＬ", 4)
		event.move_camera_sequence(0.73, 32.94, -12.13, 0.74, 63.75, -85.24, 60)
		message.show_voiced_for(6080105, 150)
		wait.frames(90)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	wait.frames(4)
	event.load_music(36)
	event.play_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	character.place_standing_and_reset_cloth(0.0, vm.f32(0.2), 400.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.2, 400.0)
	event.set_camera_position(0.0, 40.2, 520.0)
	event.reset_follow_camera(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.fade_in_screen(30)
end

--- Shows the wall image selected by index with a fade in, waits for a button press, fades it out and deletes it.
function moon_flower_palace_griffon_event.show_wall_image(wall_index: s32)
	local image_block: s32 = 0
	event.set_character_motion(0, "立ち")
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	if wall_index == 0 then
		event.start_background_file_loads_1("textures/event/etc/heki401.json")
	end
	if wall_index == 1 then
		event.start_background_file_loads_1("textures/event/etc/heki402.json")
	end
	if wall_index == 2 then
		event.start_background_file_loads_1("textures/event/etc/heki403.json")
	end
	if wall_index == 3 then
		event.start_background_file_loads_1("textures/event/etc/heki404.json")
	end
	if wall_index == 4 then
		event.start_background_file_loads_1("textures/event/etc/heki405.json")
	end
	if wall_index == 5 then
		event.start_background_file_loads_1("textures/event/etc/heki406.json")
	end
	if wall_index == 6 then
		event.start_background_file_loads_1("textures/event/etc/heki407.json")
	end
	if wall_index == 7 then
		event.start_background_file_loads_1("textures/event/etc/heki408.json")
	end
	wait.background_load()
	if wall_index == 0 then
		image_block = event.load_event_image_4(5, "textures/event/etc/heki401.json", 0) or image_block
		event.set_event_sprite_texture(0, "heki401", image_block)
	end
	if wall_index == 1 then
		image_block = event.load_event_image_4(5, "textures/event/etc/heki402.json", 0) or image_block
		event.set_event_sprite_texture(0, "heki402", image_block)
	end
	if wall_index == 2 then
		image_block = event.load_event_image_4(5, "textures/event/etc/heki403.json", 0) or image_block
		event.set_event_sprite_texture(0, "heki403", image_block)
	end
	if wall_index == 3 then
		image_block = event.load_event_image_4(5, "textures/event/etc/heki404.json", 0) or image_block
		event.set_event_sprite_texture(0, "heki404", image_block)
	end
	if wall_index == 4 then
		image_block = event.load_event_image_4(5, "textures/event/etc/heki405.json", 0) or image_block
		event.set_event_sprite_texture(0, "heki405", image_block)
	end
	if wall_index == 5 then
		image_block = event.load_event_image_4(5, "textures/event/etc/heki406.json", 0) or image_block
		event.set_event_sprite_texture(0, "heki406", image_block)
	end
	if wall_index == 6 then
		image_block = event.load_event_image_4(5, "textures/event/etc/heki407.json", 0) or image_block
		event.set_event_sprite_texture(0, "heki407", image_block)
	end
	if wall_index == 7 then
		image_block = event.load_event_image_4(5, "textures/event/etc/heki408.json", 0) or image_block
		event.set_event_sprite_texture(0, "heki408", image_block)
	end
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(0, 128.0, 128.0, 128.0, 128.0, 4)
	wait.frames(4)
	wait.until_button_pressed(64)
	event.set_object_sequence_color(0, 128.0, 128.0, 128.0, 0.0, 4)
	wait.frames(4)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

return moon_flower_palace_griffon_event
