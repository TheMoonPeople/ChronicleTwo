--!strict
--- Event script for Barga's Valley, covering the Sphida minigame, its lesson and retry dialogue, and the prize cutscenes.

local vm = require("@lib/vm")
local bargas_valley = require("@lib/event/bargas_valley")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

--- Does nothing when the map is initialised.
local function init_map() end

--- Plays the e312 cutscene where the party lands in Barga's Valley and is introduced to sphida by the boss.
local function play_sphida_intro_cutscene()
	local playable_character: s32 = 0
	local mints_slot: s32 = 0
	local cutscene_sound_bank: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local acceleration_x: f32 = 0
	local acceleration_y: f32 = 0
	local acceleration_z: f32 = 0
	local index: s32 = 0
	local landing_sound: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.set_save_flag(312, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		if playable_character == 0 then
			mints_slot = 0
		else
			mints_slot = 13
		end
		cutscene_sound_bank = event.load_sound_effect_file_2(3806) or cutscene_sound_bank
		minigame.set_up_sphida_course(1)
		event.set_sphida_playing(0)
		event.load_character(4, "chara/c02_base.gltf", "info", 13)
		event.load_equipment_model(4, 1, 4, "info", 13)
		event.load_equipment_model(4, 1, 3, "info", 13)
		event.load_equipment_model(4, 1, 2, "info", 13, 14)
		event.set_scene_character_number(13, 1)
		event.load_character(4, "event/e300/e314/e314_bou.gltf", "info", 15)
		event.set_character_active(15)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e300/e312/")
		event.load_message_file(0, 5, "e312.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e312_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.load_character(5, "e312_boss.gltf", "info", 16)
		event.set_character_active(16)
		event.attach_object_handle_to_character(2, 16)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.load_character(5, "event/d03/p00_26a.gltf", "info", 17)
		event.set_character_active(17)
		event.attach_object_handle_to_character(3, 17)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e312/e312_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/e300/e312/e312_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -355.0, 30.46, 930.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -338.8, 30.26, 950.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(3, -150.0, 230.0, 1600.0)
		event.set_object_handle_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(3, "飛び", 4)
		event.play_object_sequence_sound(3, cutscene_sound_bank, 1)
		event.delay_object_sequence_sound_track(3, 34)
		event.play_object_sequence_sound(3, cutscene_sound_bank, 1)
		event.set_object_handle_position(2, -116.0, 316.0, 235.0)
		event.set_object_handle_rotation(2, 0.0, -0.36, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_frame_draw_flag(2, "hana", 0)
		event.set_character_position(15, 0.0, 0.5, -170.0)
		event.set_character_rotation(15, 0.0, 1.57, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(254.65, 473.72, 1588.47)
		event.set_camera_sequence_look_at(-219.14, 62.76, 1197.82)
		event.play_sound_effect(cutscene_sound_bank, 0)
		event.fade_in_screen(30)
		position_x = -150.0
		position_y = 230.0
		position_z = 1600.0
		velocity_x = 0.0
		velocity_y = -8.0
		velocity_z = -10.0
		acceleration_x = 0.0
		acceleration_y = vm.f32(0.2)
		acceleration_z = 0.0
		index = 0
		while index < 60 do
			do
				local out1, out2, out3 = event.add_vectors(position_x, position_y, position_z, velocity_x, velocity_y, velocity_z)
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			do
				local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, acceleration_x, acceleration_y, acceleration_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			event.set_object_handle_position(3, position_x, position_y, position_z)
			index = index + 1
			resume_step = 1
			vm.wait(1)
		end
		event.set_character_active(0, 17)
		event.set_camera_sequence_position(-303.73, 9.54, 934.94)
		event.set_camera_sequence_look_at(-365.55, 6.21, 927.8)
		if playable_character == 0 then
			event.set_character_active(0)
		else
			event.set_character_active(13)
			event.set_character_active(14)
		end
		event.move_object_sequence(0, -355.0, 0.46, 920.0, 10)
		event.set_object_sequence_motion(0, "d03着地", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		resume_step = 2
		wait.for_frame_count(6)
		if playable_character == 0 then
			event.set_character_active(13)
			event.set_character_active(14)
		else
			event.set_character_active(0)
		end
		event.move_object_sequence(1, -338.5, 0.26, 940.0, 10)
		event.set_object_sequence_motion(1, "d03着地", 6)
		resume_step = 3
		wait.for_frame_count(2)
		landing_sound = event.get_sound_id(1) or landing_sound
		event.play_sound_effect(landing_sound, 3)
		event.play_sound_effect(landing_sound, 2)
		resume_step = 4
		wait.for_frame_count(6)
		event.play_sound_effect(landing_sound, 2)
		resume_step = 5
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-359.26, 22.65, 1003.22)
		event.set_camera_sequence_look_at(-344.39, 18.85, 907.9)
		event.move_camera_sequence_eased(-372.94, 22.65, 1090.93, -287.43, 73.81, 850.46, 60, 0, 1.0)
		event.set_object_sequence_motion(2, "飛び", 6)
		event.queue_object_sequence_next_motion(2, "飛びから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.delay_object_sequence_sound_track(2, 24)
		event.play_object_sequence_sound(2, cutscene_sound_bank, 2)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, cutscene_sound_bank, 2)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, cutscene_sound_bank, 2)
		event.move_object_sequence(1, -338.5, 0.26, 920.0, 30)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "立ち")
		do
			local out1, out2, out3 = event.copy_vector(-116.0, 316.0, 235.0)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = event.copy_vector(-1.6666666, -3.8, 5.0)
			velocity_x = out1 or velocity_x
			velocity_y = out2 or velocity_y
			velocity_z = out3 or velocity_z
		end
		do
			local out1, out2, out3 = event.copy_vector(0.0, 0.03, 0.0)
			acceleration_x = out1 or acceleration_x
			acceleration_y = out2 or acceleration_y
			acceleration_z = out3 or acceleration_z
		end
		index = 0
		while index < 120 do
			do
				local out1, out2, out3 = event.add_vectors(position_x, position_y, position_z, velocity_x, velocity_y, velocity_z)
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			do
				local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, acceleration_x, acceleration_y, acceleration_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			event.set_object_handle_position(2, position_x, position_y, position_z)
			index = index + 1
			resume_step = 6
			vm.wait(6)
		end
		resume_step = 7
		camera.wait_until_done()
		event.set_camera_sequence_position(-344.6, 67.67, 922.14)
		event.set_camera_sequence_look_at(-336.45, 57.21, 848.5)
		event.move_camera_sequence_eased(-344.6, 67.67, 922.14, -336.45, 87.1, 848.5, 30, 2, 1.0)
		event.play_sound_effect(cutscene_sound_bank, 3)
		event.set_object_sequence_position(2, -329.15, 98.27, 784.46)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.move_object_sequence(2, -334.07, 73.0, 828.92, 20)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		resume_step = 8
		camera.wait_until_done()
		resume_step = 9
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-298.63, 146.76, 823.22)
		event.set_camera_sequence_look_at(-350.98, 51.79, 864.8)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 10
		message.show_voiced(3120010)
		resume_step = 11
		object.wait_until_done(0)
		event.set_camera_sequence_position(-353.63, 9.34, 984.37)
		event.set_camera_sequence_look_at(-341.08, 50.88, 864.19)
		event.set_object_sequence_motion(2, "ん？", 2)
		event.queue_object_sequence_next_motion(2, "ん？L", 4)
		resume_step = 12
		message.show_voiced(3120020)
		resume_step = 13
		object.wait_until_done(2)
		event.move_camera_sequence_eased(-357.36, 10.22, 1020.11, -341.08, 44.79, 864.19, 30, 0, 1.0)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 14
		message.show_voiced(3120030)
		resume_step = 15
		camera.wait_until_done()
		resume_step = 16
		object.wait_until_done(0)
		event.set_object_sequence_motion(2, "ん？戻り", 2)
		event.queue_object_sequence_next_motion(2, "上見る", 6)
		event.queue_object_sequence_next_motion(2, "上見るL", 4)
		resume_step = 17
		message.show_voiced(3120040)
		resume_step = 18
		object.wait_until_done(2)
		event.set_camera_sequence_position(-329.49, 29.05, 893.39)
		event.set_camera_sequence_look_at(-347.8, 20.91, 923.24)
		resume_step = 19
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-357.36, 10.22, 1020.11)
		event.set_camera_sequence_look_at(-341.08, 44.79, 864.19)
		event.set_object_sequence_motion(2, "上見る戻り", 2)
		event.queue_object_sequence_next_motion(2, "首ふる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		resume_step = 20
		wait.for_frame_count(10)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "がっかり", 6)
		event.queue_object_sequence_next_motion(0, "がっかりL", 4)
		event.delay_object_sequence_sound_track(0, 48)
		event.play_object_sequence_sound(0, cutscene_sound_bank, 4)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "がっかり", 6)
		event.queue_object_sequence_next_motion(1, "がっかりＬ", 4)
		resume_step = 21
		message.show_voiced(3120045)
		resume_step = 22
		object.wait_until_done(2)
		resume_step = 23
		object.wait_until_done(0)
		resume_step = 24
		object.wait_until_done(1)
		event.set_camera_sequence_position(-321.89, 23.1, 893.12)
		event.set_camera_sequence_look_at(-338.41, 22.0, 915.41)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向く会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 25
		message.show_voiced(3120050)
		resume_step = 26
		object.wait_until_done(1)
		event.set_camera_sequence_position(-304.1, 27.73, 913.73)
		event.set_camera_sequence_look_at(-351.1, 29.34, 911.38)
		event.set_object_sequence_position(2, -334.88, 22.14, 859.84)
		event.move_object_sequence_eased(2, -335.92, 5.76, 880.52, 20, 2, 0.5)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		resume_step = 27
		message.show_voiced(3120060)
		resume_step = 28
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "そっぽ向く", 6)
		event.queue_object_sequence_next_motion(2, "そっぽ向くL", 4)
		resume_step = 29
		message.show_voiced(3120065)
		resume_step = 30
		object.wait_until_done(2)
		event.set_camera_sequence_position(-321.89, 23.1, 893.12)
		event.set_camera_sequence_look_at(-338.41, 22.0, 915.41)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 31
		message.show_voiced(3120070)
		event.set_camera_sequence_position(-306.68, 100.95, 835.19)
		event.set_camera_sequence_look_at(-288.49, 105.02, 752.73)
		event.set_object_sequence_position(2, -334.07, 73.0, 828.92)
		event.set_object_sequence_rotation(2, 0.0, 1.08, 0.0)
		event.set_object_sequence_motion(2, "指さす", 6)
		event.queue_object_sequence_next_motion(2, "指さすL", 4)
		event.delay_object_sequence_sound_track(2, 10)
		event.play_object_sequence_sound(2, cutscene_sound_bank, 5)
		resume_step = 32
		message.show_voiced(3120080)
		resume_step = 33
		object.wait_until_done(2)
		event.play_sound_effect(cutscene_sound_bank, 6)
		event.move_camera_sequence_eased(-74.58, 155.23, -161.7, -56.39, 159.31, -244.16, 60, 2, 1.0)
		resume_step = 34
		message.show_voiced(3120085)
		resume_step = 35
		message.show_voiced(3120090)
		event.stop_sound_effect(cutscene_sound_bank, 6)
		event.set_camera_sequence_position(-338.06, 23.01, 898.47)
		event.set_camera_sequence_look_at(-338.41, 23.92, 922.33)
		event.play_sound_effect(cutscene_sound_bank, 7)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 36
		message.show_voiced(3120100)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 37
		message.show_voiced(3120105)
		resume_step = 38
		object.wait_until_done(1)
		event.move_camera_sequence_eased(-356.43, 23.01, 899.96, -354.36, 23.92, 923.72, 20, 0, 1.0)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 39
		message.show_voiced(3120110)
		resume_step = 40
		object.wait_until_done(0)
		resume_step = 41
		camera.wait_until_done()
		event.set_camera_sequence_position(-354.94, 23.0, 917.61)
		event.set_camera_sequence_look_at(-338.71, 23.0, 919.34)
		event.move_camera_sequence_eased(-365.44, 23.0, 916.48, -338.71, 23.0, 919.34, 40, 2, 1.0)
		event.set_character_active(0, mints_slot)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 42
		message.show_voiced(3120120)
		resume_step = 43
		camera.wait_until_done()
		event.play_sound_effect(cutscene_sound_bank, 8)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 44
		message.show_voiced(3120130)
		resume_step = 45
		object.wait_until_done(1)
		event.set_camera_sequence_position(-326.56, 30.19, 903.79)
		event.set_camera_sequence_look_at(-350.3, 22.41, 925.37)
		event.set_object_sequence_rotation(0, 0.0, 1.7, 0.0)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, -1.82, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_character_active(mints_slot)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 46
		message.show_voiced(3120140)
		event.move_camera_sequence_eased(-305.69, 31.41, 884.81, -350.3, 12.85, 925.37, 40, 0, 1.0)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 47
		message.show_voiced(3120150)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 48
		message.show_voiced(3120155)
		resume_step = 49
		object.wait_until_done(1)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "左上を見る", 6)
		event.queue_object_sequence_next_motion(0, "左上を見るL", 4)
		event.delay_object_sequence_motion_track(1, 18)
		event.set_object_sequence_motion(1, "右上見る", 2)
		event.queue_object_sequence_next_motion(1, "右上見るＬ", 4)
		resume_step = 50
		message.show_voiced(3120160)
		resume_step = 51
		object.wait_until_done(0)
		resume_step = 52
		object.wait_until_done(1)
		event.set_camera_sequence_position(-321.16, 73.7, 923.06)
		event.set_camera_sequence_look_at(-335.4, 87.64, 848.65)
		event.set_object_sequence_position(2, -334.07, 73.0, 828.92)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "会話２", 6, 0.6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		resume_step = 53
		message.show_voiced(3120164)
		resume_step = 54
		object.wait_until_done(2)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		resume_step = 55
		message.show_voiced(3120168)
		event.set_camera_sequence_position(-305.69, 31.41, 884.81)
		event.set_camera_sequence_look_at(-350.3, 12.85, 925.37)
		event.set_mouth_texture_animations(0, "わらい口パク")
		resume_step = 56
		message.show_voiced(3120170)
		event.set_object_sequence_motion(0, "左上を見る戻り", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "右上見るもどり", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 57
		message.show_voiced(3120175)
		resume_step = 58
		object.wait_until_done(0)
		resume_step = 59
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "考えるうつむき", 2)
		event.queue_object_sequence_next_motion(1, "考えるうつむきＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 60
		message.show_voiced(3120180)
		resume_step = 61
		object.wait_until_done(1)
		resume_step = 62
		wait.for_frame_count(60)
		event.set_object_sequence_motion(1, "考えから待ったへ", 2)
		event.queue_object_sequence_next_motion(1, "考えから待ったへＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 63
		message.show_voiced(3120184)
		resume_step = 64
		object.wait_until_done(1)
		event.delay_object_sequence_sound_track(0, 36)
		event.play_object_sequence_sound(0, cutscene_sound_bank, 9)
		event.set_object_sequence_motion(1, "考えから待ったへもどり", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_motion_track(1, 1)
		event.set_object_sequence_motion(1, "歩き")
		resume_step = 65
		object.wait_until_done(1)
		event.move_object_sequence_eased(1, -325.31, 0.52, 964.6, 30, 1, 1.0)
		event.rotate_object_sequence(1, 0.0, 0.1, 0.0, 10)
		resume_step = 66
		object.wait_until_done(1)
		event.set_camera_sequence_position(-344.31, 18.43, 930.21)
		event.set_camera_sequence_look_at(-293.44, 28.21, 993.72)
		event.set_object_sequence_position(1, -323.37, 0.45, 957.16)
		event.set_object_sequence_rotation(1, 0.0, 1.0, 0.0)
		event.move_object_sequence(1, -250.24, 0.82, 1003.33, 60)
		event.reset_object_sequence_dynamic_animation(1)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_motion_track(1, 4)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向く戻り", 4)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		resume_step = 67
		object.wait_until_done(1)
		resume_step = 68
		wait.for_frame_count(4)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.move_object_sequence(1, -253.1, 0.75, 1044.91, 40)
		event.rotate_object_sequence(1, 0.0, -0.07, 0.0, 8)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 160)
		event.add_object_sequence_path_point(1, -253.1, 0.75, 1044.91)
		event.add_object_sequence_path_point(1, -254.79, 5.38, 1089.94)
		event.add_object_sequence_path_point(1, -256.86, 18.37, 1140.0)
		event.add_object_sequence_path_point(1, -237.68, 31.31, 1196.62)
		event.add_object_sequence_path_point(1, -191.4, 36.23, 1217.18)
		event.start_object_sequence_path(1, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 69
		message.show_voiced_for_stopping(3120188, 160)
		resume_step = 70
		object.wait_until_done(1)
		event.set_camera_sequence_position(-147.43, 50.34, 1206.83)
		event.set_camera_sequence_look_at(-186.15, 57.43, 1217.59)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 71
		message.show_voiced(3120190)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -150.87, 40.35, 1232.05, 20)
		resume_step = 72
		object.wait_until_done(1)
		event.set_camera_sequence_position(2.14, 80.3, 1354.88)
		event.set_camera_sequence_look_at(-0.07, 78.68, 1304.82)
		event.move_camera_sequence_eased(0.83, 65.77, 1325.2, -0.07, 67.0, 1304.82, 160, 2, 1.0)
		event.play_sound_effect(cutscene_sound_bank, 10)
		event.set_object_sequence_position(1, 11.14, 63.15, 1259.88)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_object_sequence(1, 11.14, 63.15, 1292.94, 12)
		event.delay_object_sequence_rotation_track(1, 6)
		event.rotate_object_sequence(1, 0.0, -0.81, 0.0, 6)
		event.delay_object_sequence_motion_track(1, 12)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_motion_track(1, 6)
		event.set_object_sequence_motion(1, "下を見る", 6)
		event.queue_object_sequence_next_motion(1, "下を見るL", 4)
		event.set_object_sequence_position(0, -42.37, 55.86, 1225.46)
		event.set_object_sequence_rotation(0, 0.0, 0.5, 0.0)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.move_object_sequence(0, -8.78, 62.88, 1292.68, 30, 1)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "立ち")
		resume_step = 73
		object.wait_until_done(1)
		resume_step = 74
		wait.for_frame_count(6)
		event.set_object_sequence_motion(0, "下を見る", 6)
		event.queue_object_sequence_next_motion(0, "下を見るL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 75
		message.show_voiced_for_stopping(3120195, 40)
		resume_step = 76
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "下を見る会話", 2)
		event.queue_object_sequence_next_motion(1, "下を見るL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 77
		message.show_voiced(3120200)
		resume_step = 78
		object.wait_until_done(1)
		resume_step = 79
		camera.wait_until_done()
		event.stop_sound_effect(cutscene_sound_bank, 10)
		event.set_camera_sequence_position(2.14, 80.3, 1354.88)
		event.set_camera_sequence_look_at(-0.07, 78.68, 1304.82)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 80
		message.show_voiced(3120210)
		event.set_camera_sequence_position(-25.77, 92.07, 1321.59)
		event.set_camera_sequence_look_at(2.71, 81.81, 1288.92)
		event.set_object_sequence_rotation(1, 0.0, -0.09, 0.0)
		event.set_object_sequence_motion(1, "下を見る戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_object_sequence_rotation(0, 0.0, 0.14, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "下を見る戻り", 2)
		event.queue_object_sequence_next_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 81
		message.show_voiced(3120220)
		resume_step = 82
		object.wait_until_done(1)
		event.set_camera_sequence_position(2.14, 80.3, 1354.88)
		event.set_camera_sequence_look_at(-0.07, 78.68, 1304.82)
		event.set_object_sequence_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 83
		message.show_voiced(3120230)
		resume_step = 84
		object.wait_until_done(1)
		event.fade_out_screen(30)
		resume_step = 85
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			wait.skip_frame_count(6)
		end
		if resume_step <= 2 then
			wait.skip_frame_count(2)
		end
		if resume_step <= 3 then
			wait.skip_frame_count(6)
		end
		if resume_step <= 4 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 5 then
			index = 0
			local _ = index < 120
			index = index + 1
		end
		if resume_step <= 6 then
			wait.background_load_skipping()
		end
		if resume_step <= 7 then
			wait.background_load_skipping()
		end
		if resume_step <= 8 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 9 then
			message.show_voiced_skipping(3120010)
		end
		if resume_step <= 10 then
			cutscene.skip_command(0)
		end
		if resume_step <= 11 then
			message.show_voiced_skipping(3120020)
		end
		if resume_step <= 12 then
			cutscene.skip_command(2)
		end
		if resume_step <= 13 then
			message.show_voiced_skipping(3120030)
		end
		if resume_step <= 14 then
			wait.background_load_skipping()
		end
		if resume_step <= 15 then
			cutscene.skip_command(0)
		end
		if resume_step <= 16 then
			message.show_voiced_skipping(3120040)
		end
		if resume_step <= 17 then
			cutscene.skip_command(2)
		end
		if resume_step <= 18 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 19 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 20 then
			message.show_voiced_skipping(3120045)
		end
		if resume_step <= 21 then
			cutscene.skip_command(2)
		end
		if resume_step <= 22 then
			cutscene.skip_command(0)
		end
		if resume_step <= 23 then
			cutscene.skip_command(1)
		end
		if resume_step <= 24 then
			message.show_voiced_skipping(3120050)
		end
		if resume_step <= 25 then
			cutscene.skip_command(1)
		end
		if resume_step <= 26 then
			message.show_voiced_skipping(3120060)
		end
		if resume_step <= 27 then
			cutscene.skip_command(2)
		end
		if resume_step <= 28 then
			message.show_voiced_skipping(3120065)
		end
		if resume_step <= 29 then
			cutscene.skip_command(2)
		end
		if resume_step <= 30 then
			message.show_voiced_skipping(3120070)
		end
		if resume_step <= 31 then
			message.show_voiced_skipping(3120080)
		end
		if resume_step <= 32 then
			cutscene.skip_command(2)
		end
		if resume_step <= 33 then
			message.show_voiced_skipping(3120085)
		end
		if resume_step <= 34 then
			message.show_voiced_skipping(3120090)
		end
		if resume_step <= 35 then
			message.show_voiced_skipping(3120100)
		end
		if resume_step <= 36 then
			message.show_voiced_skipping(3120105)
		end
		if resume_step <= 37 then
			cutscene.skip_command(1)
		end
		if resume_step <= 38 then
			message.show_voiced_skipping(3120110)
		end
		if resume_step <= 39 then
			cutscene.skip_command(0)
		end
		if resume_step <= 40 then
			wait.background_load_skipping()
		end
		if resume_step <= 41 then
			message.show_voiced_skipping(3120120)
		end
		if resume_step <= 42 then
			wait.background_load_skipping()
		end
		if resume_step <= 43 then
			message.show_voiced_skipping(3120130)
		end
		if resume_step <= 44 then
			cutscene.skip_command(1)
		end
		if resume_step <= 45 then
			message.show_voiced_skipping(3120140)
		end
		if resume_step <= 46 then
			message.show_voiced_skipping(3120150)
		end
		if resume_step <= 47 then
			message.show_voiced_skipping(3120155)
		end
		if resume_step <= 48 then
			cutscene.skip_command(1)
		end
		if resume_step <= 49 then
			message.show_voiced_skipping(3120160)
		end
		if resume_step <= 50 then
			cutscene.skip_command(0)
		end
		if resume_step <= 51 then
			cutscene.skip_command(1)
		end
		if resume_step <= 52 then
			message.show_voiced_skipping(3120164)
		end
		if resume_step <= 53 then
			cutscene.skip_command(2)
		end
		if resume_step <= 54 then
			message.show_voiced_skipping(3120168)
		end
		if resume_step <= 55 then
			message.show_voiced_skipping(3120170)
		end
		if resume_step <= 56 then
			message.show_voiced_skipping(3120175)
		end
		if resume_step <= 57 then
			cutscene.skip_command(0)
		end
		if resume_step <= 58 then
			cutscene.skip_command(1)
		end
		if resume_step <= 59 then
			message.show_voiced_skipping(3120180)
		end
		if resume_step <= 60 then
			cutscene.skip_command(1)
		end
		if resume_step <= 61 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 62 then
			message.show_voiced_skipping(3120184)
		end
		if resume_step <= 63 then
			cutscene.skip_command(1)
		end
		if resume_step <= 64 then
			cutscene.skip_command(1)
		end
		if resume_step <= 65 then
			cutscene.skip_command(1)
		end
		if resume_step <= 66 then
			cutscene.skip_command(1)
		end
		if resume_step <= 67 then
			wait.skip_frame_count(4)
		end
		if resume_step <= 68 then
			message.show_voiced_for_stopping_skipping(3120188, 160)
		end
		if resume_step <= 69 then
			cutscene.skip_command(1)
		end
		if resume_step <= 70 then
			message.show_voiced_skipping(3120190)
		end
		if resume_step <= 71 then
			cutscene.skip_command(1)
		end
		if resume_step <= 72 then
			cutscene.skip_command(1)
		end
		if resume_step <= 73 then
			wait.skip_frame_count(6)
		end
		if resume_step <= 74 then
			message.show_voiced_for_stopping_skipping(3120195, 40)
		end
		if resume_step <= 75 then
			cutscene.skip_command(0)
		end
		if resume_step <= 76 then
			message.show_voiced_skipping(3120200)
		end
		if resume_step <= 77 then
			cutscene.skip_command(1)
		end
		if resume_step <= 78 then
			wait.background_load_skipping()
		end
		if resume_step <= 79 then
			message.show_voiced_skipping(3120210)
		end
		if resume_step <= 80 then
			message.show_voiced_skipping(3120220)
		end
		if resume_step <= 81 then
			cutscene.skip_command(1)
		end
		if resume_step <= 82 then
			message.show_voiced_skipping(3120230)
		end
		if resume_step <= 83 then
			cutscene.skip_command(1)
		end
		if resume_step <= 84 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	resume_step = 86
	vm.entry(86)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(cutscene_sound_bank, 0)
	event.stop_sound_effect(cutscene_sound_bank, 6)
	event.stop_sound_effect(cutscene_sound_bank, 10)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.delete_character(16)
	event.delete_character(17)
	event.load_message_file(0, -1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_character_active(0)
	event.set_character_position(0, -25.0, 62.7, 1285.3)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_character_active(13)
	event.set_character_position(13, 68.04, 41.85, 1180.61)
	event.set_character_rotation(13, 0.0, 3.14, 0.0)
	event.set_character_motion(13, "立ち", 4)
	event.update_character_motion(13)
	event.reset_character_cloth_and_hair(13)
	event.set_camera_look_at(-25.0, 92.7, 1285.3)
	event.set_camera_position(-25.0, 102.7, 1385.3)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Plays the d03 cutscene where a party member drops in and lands, then places the party for play.
local function play_dungeon_landing_cutscene()
	local cutscene_sound_bank: s32 = 0
	local playable_character: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local acceleration_x: f32 = 0
	local acceleration_y: f32 = 0
	local acceleration_z: f32 = 0
	local index: s32 = 0
	local landing_sound: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.initialize_event()
		event.show_dungeon_status_bar(0, 1.0)
		cutscene_sound_bank = event.load_sound_effect_file_2(3803) or cutscene_sound_bank
		playable_character = event.get_playable_character() or playable_character
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "event/d03/p00_26a.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if playable_character == 0 then
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
		end
		event.set_character_active(0, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_character(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_position(0, -230.0, 62.1, 1210.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_position(1, -150.0, 230.0, 1600.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "飛び", 4)
		event.play_object_sequence_sound(1, cutscene_sound_bank, 1)
		event.delay_object_sequence_sound_track(1, 34)
		event.play_object_sequence_sound(1, cutscene_sound_bank, 1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(254.65, 473.72, 1588.47)
		event.set_camera_sequence_look_at(-219.14, 62.76, 1197.82)
		event.play_sound_effect(cutscene_sound_bank, 0)
		event.fade_in_screen(30)
		position_x = -150.0
		position_y = 230.0
		position_z = 1600.0
		velocity_x = 0.0
		velocity_y = -8.0
		velocity_z = -10.0
		acceleration_x = 0.0
		acceleration_y = vm.f32(0.2)
		acceleration_z = 0.0
		index = 0
		while index < 60 do
			do
				local out1, out2, out3 = event.add_vectors(position_x, position_y, position_z, velocity_x, velocity_y, velocity_z)
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			do
				local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, acceleration_x, acceleration_y, acceleration_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			event.set_object_handle_position(1, position_x, position_y, position_z)
			index = index + 1
			resume_step = 2
			vm.wait(2)
		end
		event.set_character_active(0, 8)
		event.set_camera_sequence_position(-195.61, 36.44, 1206.2)
		event.set_camera_sequence_look_at(-227.63, 40.13, 1199.12)
		event.set_character_active(1, 0)
		event.move_object_sequence(0, -230.0, 32.1, 1200.0, 10)
		event.set_object_sequence_motion(0, "d03着地", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		resume_step = 3
		wait.for_frame_count(8)
		landing_sound = event.get_sound_id(1) or landing_sound
		event.play_sound_effect(landing_sound, 3)
		event.play_sound_effect(landing_sound, 2)
		resume_step = 4
		object.wait_until_done(0)
		event.fade_out_screen(30)
		resume_step = 5
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			position_x = -150.0
			position_y = 230.0
			position_z = 1600.0
			velocity_x = 0.0
			velocity_y = -8.0
			velocity_z = -10.0
			acceleration_x = 0.0
			acceleration_y = vm.f32(0.2)
			acceleration_z = 0.0
			index = 0
			local _ = index < 60
			index = index + 1
		end
		if resume_step <= 2 then
			wait.skip_frame_count(8)
		end
		if resume_step <= 3 then
			cutscene.skip_command(0)
		end
		if resume_step <= 4 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	resume_step = 6
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(cutscene_sound_bank, 0)
	event.delete_character_extension_packs(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(2, 1)
	event.set_object_handle_visible(3, 1)
	event.set_character_active(1, 0)
	event.set_character_active(1, 8)
	event.set_character_position(8, -316.71, 71.94, 806.78)
	event.set_character_rotation(8, 0.0, 2.06, 0.0)
	event.set_character_motion(8, "立ち", 4)
	event.set_character_position(0, -230.0, 32.1, 1200.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.set_camera_look_at(-230.0, 62.1, 1200.0)
	event.set_camera_position(-230.0, 72.1, 1300.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Plays the cutscene where both characters land and watch a flying creature circle overhead.
local function play_landing_cutscene()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	local creature_x: f32 = 0
	local creature_y: f32 = 0
	local creature_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local acceleration_x: f32 = 0
	local acceleration_y: f32 = 0
	local acceleration_z: f32 = 0
	local index: s32 = 0
	local landing_sound_id: s32 = 0
	vm.section(function()
		event.set_save_flag(308, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		sound_bank = event.load_sound_effect_file_2(3803) or sound_bank
		active_character = event.get_playable_character() or active_character
		event.change_directory("event/e300/e308/")
		event.load_message_file(0, 5, "e308.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e308_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character == 1 then
			event.load_character_motion_pack(5, "e308_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "p00_24a.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_scene_status_flags(1, 10, 8, 1)
		event.change_directory("")
		event.load_character(5, "event/d03/p00_26a.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_scene_status_flags(1, 11, 8, 1)
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e308/e308_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 13)
			event.load_equipment_model(5, 1, 4, "info", 13)
			event.load_equipment_model(5, 1, 3, "info", 13)
			event.load_equipment_model(5, 1, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e308/e308_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		end
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -230.0, 62.1, 1210.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -213.0, 65.619995, 1230.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(3, -150.0, 230.0, 1600.0)
		event.set_object_handle_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(3, "飛び", 4)
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.set_object_handle_frame_draw_flag(2, "hana", 0)
		event.play_object_sequence_sound(3, sound_bank, 1)
		event.delay_object_sequence_sound_track(3, 34)
		event.play_object_sequence_sound(3, sound_bank, 1)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 360)
		event.add_object_sequence_path_point(2, -193.32, 507.72, 144.75)
		event.add_object_sequence_path_point(2, -159.98, 507.72, 220.59)
		event.add_object_sequence_path_point(2, -76.06, 507.72, 268.34)
		event.add_object_sequence_path_point(2, 23.46, 507.72, 253.28)
		event.add_object_sequence_path_point(2, 92.64, 507.72, 174.56)
		event.add_object_sequence_path_point(2, 93.49, 507.72, 66.28)
		event.add_object_sequence_path_point(2, 1.5, 507.72, -7.07)
		event.add_object_sequence_path_point(2, -107.74, 507.72, -27.82)
		event.add_object_sequence_path_point(2, -212.55, 507.72, 43.02)
		event.add_object_sequence_path_point(2, -280.2, 507.72, 145.95)
		event.add_object_sequence_path_point(2, -261.4, 507.72, 250.13)
		event.add_object_sequence_path_point(2, -177.44, 507.72, 302.03)
		event.add_object_sequence_path_point(2, -77.76, 507.72, 299.29)
		event.add_object_sequence_path_point(2, -8.21, 507.72, 209.44)
		event.add_object_sequence_path_point(2, 14.08, 507.72, 94.42)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(254.65, 473.72, 1588.47)
		event.set_camera_sequence_look_at(-219.14, 62.76, 1197.82)
		event.play_sound_effect(sound_bank, 0)
		event.fade_in_screen(30)
		creature_x = -150.0
		creature_y = 230.0
		creature_z = 1600.0
		velocity_x = 0.0
		velocity_y = -8.0
		velocity_z = -10.0
		acceleration_x = 0.0
		acceleration_y = vm.f32(0.2)
		acceleration_z = 0.0
		index = 0
		while index < 60 do
			do
				local out1, out2, out3 = event.add_vectors(creature_x, creature_y, creature_z, velocity_x, velocity_y, velocity_z)
				creature_x = out1 or creature_x
				creature_y = out2 or creature_y
				creature_z = out3 or creature_z
			end
			do
				local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, acceleration_x, acceleration_y, acceleration_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			event.set_object_handle_position(3, creature_x, creature_y, creature_z)
			index = index + 1
			vm.wait(1)
		end
		event.set_character_active(0, 11)
		event.set_camera_sequence_position(-184.07, 43.54, 1216.07)
		event.set_camera_sequence_look_at(-236.95, 39.04, 1208.54)
		if active_character == 0 then
			event.set_character_active(0)
		else
			event.set_character_active(13)
			event.set_character_active(14)
		end
		event.move_object_sequence(0, -230.0, 32.1, 1200.0, 10)
		event.set_object_sequence_motion(0, "d03着地", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		wait.for_frame_count(6)
		if active_character == 0 then
			event.set_character_active(13)
			event.set_character_active(14)
		else
			event.set_character_active(0)
		end
		event.move_object_sequence(1, -213.0, 35.19, 1220.0, 10)
		event.set_object_sequence_motion(1, "d03着地", 6)
		wait.for_frame_count(2)
		landing_sound_id = event.get_sound_id(1) or landing_sound_id
		event.play_sound_effect(landing_sound_id, 3)
		event.play_sound_effect(landing_sound_id, 2)
		wait.for_frame_count(6)
		event.play_sound_effect(landing_sound_id, 2)
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-220.28, 65.74, 1289.9)
		event.set_camera_sequence_look_at(-220.42, 54.04, 1203.57)
		event.move_camera_sequence_eased(-220.21, 65.74, 1327.83, -182.37, 80.44, 1173.66, 60, 0, 1.0)
		event.move_object_sequence(1, -213.0, 33.37, 1200.0, 30)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "立ち")
		camera.wait_until_done()
		event.set_camera_sequence_position(-202.75, 44.94, 1163.67)
		event.set_camera_sequence_look_at(-225.81, 55.17, 1208.79)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3080010)
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(1, 1, "通常目～こまり目とじ")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "こまり目とじ～目あけ")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0, "こまり目とじ～目あけ")
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 1)
		event.play_object_sequence_sound(1, sound_bank, 3)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3080020)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-218.98, 55.74, 1263.48)
		event.set_camera_sequence_look_at(-222.62, 51.36, 1199.73)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3080030)
		event.move_camera_sequence_eased(-218.17, 55.74, 1293.84, -219.13, 76.78, 1199.61, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 14)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(2, "飛び", 4)
		event.start_object_sequence_path(2)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(3080035, 180)
		camera.wait_until_done()
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.set_character_active(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
	event.finish_event()
end

--- Advances the dungeon to its next floor, resets the party and sounds and loads the d03 event script.
local function enter_next_floor_in_d03()
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor = event.get_dungeon_floor() or floor
	next_floor = event.get_dungeon_next_floor(floor, 0) or next_floor
	event.set_dungeon_floor(next_floor)
	event.set_dungeon_floor_info(stage_id, floor, 5, 2)
	event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.initialize_sphida()
	event.set_dungeon_pause_flags(8192, 0)
	event.reset_action_character_motion(0)
	event.set_save_control_bits(1, 0)
	event.set_character_change_unmasked(0, 1)
	event.set_character_change_unmasked(2, 1)
	event.set_character_change_unmasked(1, 1)
	event.set_character_change_unmasked(3, 1)
	event.stop_music(0)
	event.stop_environment_music()
	event.stop_map_object_sounds()
	wait.for_frame_count(6)
	event.load_music(17)
	event.load_map_sounds(3601)
	event.play_music(0)
	event.load_event_script("d03/d03.stb", 1000)
end

--- Plays the Sphida introduction or a landing cutscene on entry depending on the story flags, or places the player at the start when the story has not reached the valley.
local function default_event()
	local flag_300: s32 = 0
	local flag_320: s32 = 0
	local flag_317: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		flag_300 = event.get_save_flag(300) or flag_300
		flag_320 = event.get_save_flag(320) or flag_320
		flag_317 = event.get_save_flag(317) or flag_317
		if flag_300 == 1 then
			if flag_320 == 1 then
				if flag_317 == 0 then
					resume_step = 1
					play_sphida_intro_cutscene()
					event.clear_local_event_counters()
					event.set_dungeon_pause_flags(8192, 1)
					event.set_character_change_unmasked(0, 1)
					event.set_character_change_unmasked(2, 0)
					event.set_character_change_unmasked(1, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_save_control_bits(1, 1)
				else
					resume_step = 2
					play_dungeon_landing_cutscene()
					event.set_function_point_enabled("", "exit", 1)
					event.set_function_point_enabled("", "talk", 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-a0_1")
					event.set_object_handle_visible(0, 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-c0_1")
					event.set_object_handle_visible(0, 0)
					event.set_function_point_enabled("p01_s17", "invent_30001-0", 0)
					event.set_function_point_enabled("", "branch", 0)
					return
				end
			else
				play_landing_cutscene()
				resume_step = 4
				enter_next_floor_in_d03()
				return
			end
		else
			event.initialize_event()
			event.set_character_position(0, 0.0, 62.57, 1305.0)
			event.set_character_rotation(0, 0.0, 3.14, 0.0)
			event.set_camera_position(-0.16, 110.89, 1405.0)
			event.set_camera_look_at(0.0, 92.57, 1305.0)
			event.reset_follow_camera(0)
			event.fade_in_screen(30)
			event.finish_event()
		end
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_dungeon_landing_cutscene()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "exit", 1)
					event.set_function_point_enabled("", "talk", 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-a0_1")
					event.set_object_handle_visible(0, 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-c0_1")
					event.set_object_handle_visible(0, 0)
					event.set_function_point_enabled("p01_s17", "invent_30001-0", 0)
					event.set_function_point_enabled("", "branch", 0)
					return
				end)
			end
			return 0
		end
		if resume_step <= 4 then
			return 0
		end
		return nil
	end)
end

--- Plays the e314 cutscene in which the partner offers a Sphida lesson until the player accepts, then places both characters for practice.
local function play_sphida_lesson_offer()
	local sound_bank: s32 = 0
	local active_character: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local answer: any = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.set_save_flag(314, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		sound_bank = event.load_sound_effect_file_2(3809) or sound_bank
		active_character = event.get_playable_character() or active_character
		event.set_scene_status_flags(1, 0, 256, 1)
		if active_character == 0 then
		else
		end
		event.change_directory("event/e300/e314/")
		event.unlock_memory_stack(4)
		event.load_message_file(0, 4, "e314.txt")
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if active_character == 0 then
			event.load_character_motion_pack(5, "e314_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		block = event.load_event_image_4(5, "e314.json", 1) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e31401", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e31402", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(3, 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e31403", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 1)
		event.attach_object_handle_to_sprite(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e314/e314_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/e300/e314/e314_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(13)
		event.set_character_active(14)
		event.set_object_handle_position(0, 10.0, 40.79, 1150.0)
		event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -10.0, 40.79, 1150.0)
		event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag ~= 0 then
			event.enable_drama_skip()
		end
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 62.86, 1089.96)
		event.set_camera_sequence_look_at(0.0, 52.74, 1185.03)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 2
		message.show_voiced(3140010)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -10.0, 40.79, 1200.0, 40, 1)
		event.rotate_object_sequence(1, 0.0, 0.0, 0.0, 10)
		resume_step = 3
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 10.0, 40.79, 1180.0, 30, 1)
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 10)
		event.fade_out_screen(30)
		resume_step = 4
		wait.for_frame_count(30)
		resume_step = 5
		object.wait_until_done(0)
		while true do
			event.fade_in_screen(30)
			event.set_message_window_mode(0, 7)
			event.set_object_sequence_motion(1, "歩き")
			event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
			event.reset_object_sequence_dynamic_animation(1)
			event.set_object_sequence_motion(0, "立ち", 4)
			event.set_character_active(0, 0)
			resume_step = 6
			bargas_valley.play_sphida_dialogue(sound_bank)
			resume_step = 7
			vm.wait(7)
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, 9000010)
			message.open(0, -1, 5, 0, 0)
			resume_step = 8
			answer = message.choose_option(0, 2, 0, 1)
			event.set_message_bubble_screen_slot(0, 0)
			if answer == 1 then
				resume_step = 9
				vm.wait(9)
				break
			else
				event.fade_out_screen(30)
				resume_step = 10
				wait.for_frame_count(30)
			end
		end
		event.set_message_window_mode(0, 7)
		event.set_object_sequence_motion(1, "がっつ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, sound_bank, 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 11
		message.show_voiced(3140160)
		event.fade_out_screen(30)
		resume_step = 12
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if resume_step == 8 then
			answer = received[1] :: number
		end
		if resume_step <= 1 then
			message.show_voiced_skipping(3140010)
		end
		if resume_step <= 2 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 3 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 4 then
			cutscene.skip_command(0)
		end
		if resume_step <= 5 then
			bargas_valley.play_e314_dialogue(sound_bank)
		end
		if resume_step <= 7 then
			message.open_skipping(0, -1, 5, 0, 0)
			answer = message.resume_choice(0, 2, 0, 1)
		end
		if resume_step <= 9 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 10 then
			message.show_voiced_skipping(3140160)
		end
		if resume_step <= 11 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	resume_step = 13
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.delete_event_image(1)
	event.load_message_file(0, -1)
	event.set_sphida_playing(1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_character_active(0)
	event.set_character_position(0, -25.0, 62.7, 1285.3)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_character_active(13)
	event.set_character_position(13, 68.04, 41.85, 1180.61)
	event.set_character_rotation(13, 0.0, 3.14, 0.0)
	event.set_character_motion(13, "立ち", 4)
	event.update_character_motion(13)
	event.reset_character_cloth_and_hair(13)
	event.set_camera_look_at(-25.0, 92.7, 1285.3)
	event.set_camera_position(-25.0, 102.7, 1385.3)
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Shows the Sphida shot, impact zone and point of impact instructions.
local function show_sphida_tutorial()
	event.initialize_event()
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"「ショットの流れ」\n１・左スティックの上、下、左、右で打ち出す方向を決める。\n２・(O)ボタンを押して、スイング開始。\n３・(O)ボタンを押して、パワー決定。\n４・(O)ボタンを押して、インパクト。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"「インパクトゾーン」\nパワーゲージの下にある赤いバーがインパクトゾーンです。\nインパクトゾーンの真中でインパクトすると、パワーが\nスフィアにうまく伝わり、ナイスショットとなります。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"インパクトゾーンを外れた場所でインパクトすると、\nミスショットとなり、どこに飛ぶか分かりません。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"「打点の変更」\nインパクトの時に、左スティックを任意の方向に\n倒していると、スフィアの打点を変えられます。\n打点の変更による影響は、次のとおりです。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"上・トップスピンがかかり、転がりやすくなる。\n下・バックスピンがかかり、止まりやすくなる。\n左・スライスがかかり、右に曲がる。\n右・フックがかかり、左に曲がる。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"スフィアが運悪く届かない場所に入り込んでしまったら\n(#)ボタンでスフィアを足元へ移動できます。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]メインメニューの『ヘルプ』に\n   「スフィーダ」の項目が追加された。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
end

--- Has the partner tell the player to find a stick before learning to hit the Sphere.
local function say_find_a_stick()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(
		0,
		"その辺で手ごろな棒でも見つけてきて。\nそしたら、やり方教えてあげるから。"
	)
	character.face_each_other_and_talk_primary(13, 9000000)
	event.finish_event()
end

--- Turns the characters toward each other, asks whether to quit the practice and returns 1 when the player quits.
local function confirm_quit_practice()
	local partner_slot: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local partner_x: f32 = 0
	local partner_y: f32 = 0
	local partner_z: f32 = 0
	local player_yaw: f32 = 0
	local partner_yaw: f32 = 0
	local angle_to_partner: f32 = 0
	local angle_to_player: f32 = 0
	local answer: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		partner_slot = 13
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_footstep_sound(0, 1)
		event.attach_object_handle_to_character(1, partner_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_footstep_sound(1, 1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			player_yaw = out2 or player_yaw
		end
		do
			local out1, out2, out3 = event.get_character_position(partner_slot)
			partner_x = out1 or partner_x
			partner_y = out2 or partner_y
			partner_z = out3 or partner_z
		end
		do
			local _, out2, _ = event.get_character_rotation(partner_slot)
			partner_yaw = out2 or partner_yaw
		end
		angle_to_partner = event.get_direction_angle(player_x, player_y, player_z, partner_x, partner_y, partner_z) or angle_to_partner
		angle_to_player = event.get_direction_angle(partner_x, partner_y, partner_z, player_x, player_y, player_z) or angle_to_player
		answer = event.compare_angles(player_yaw, angle_to_partner, 0.1) or answer
		if answer ~= 0 then
			event.rotate_object_sequence(0, 0.0, angle_to_partner, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
		end
		event.set_object_sequence_motion(0, "立ち")
		answer = event.compare_angles(partner_yaw, angle_to_player, 0.1) or answer
		if answer ~= 0 then
			event.rotate_object_sequence(1, 0.0, angle_to_player, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 1
		wait.for_frame_count(20)
		event.set_mouth_motions(1, "会話", 0, "立ち", 0)
		event.open_message_window_2(0, "え？\nもしかして、あきらめるの？")
		resume_step = 2
		message.say_bubble(0, -1, partner_slot, 0, 0)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "はい\nいいえ")
		message.open(0, -1, 5, 0, 0)
		resume_step = 3
		answer = message.choose_option(0, 2, 1, 0)
		event.set_message_bubble_screen_slot(0, 0)
		event.set_message_bubble_tail(0, 1)
		if answer == 0 then
			event.fade_out_screen(30)
			resume_step = 4
			wait.for_frame_count(30)
			return 1
		else
			event.open_message_window_2(0, "そうよね。\nがんばって、ユリス！")
			resume_step = 5
			message.say_bubble(0, -1, partner_slot, 0, 0)
		end
		answer = event.compare_angles(partner_yaw, angle_to_player, 0.1) or answer
		if answer ~= 0 then
			event.rotate_object_sequence(1, 0.0, partner_yaw, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 6
		object.wait_until_done(1)
		return 0
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 3 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				message.show_then_close_variant(0, -1, partner_slot, 0, 0)
			end
			if resume_step <= 2 then
				message.open_skipping(0, -1, 5, 0, 0)
				answer = message.resume_choice(0, 2, 1, 0)
			end
			if resume_step <= 3 then
				local _ = answer ~= 0
				local _ = answer ~= 0
				wait.skip_frame_count(30)
			end
			return 1
		end
		if resume_step <= 6 then
			if resume_step <= 5 then
				cutscene.skip_command(1)
			end
			return 0
		end
		return nil
	end)
end

--- Simulates a struck sphida ball bouncing across the course with camera and sounds until it settles, then plays the pin reaction.
local function simulate_sphida_ball_flight(sound_bank: s32)
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rotation_x: f32 = 0
	local heading_angle: f32 = 0
	local rotation_z: f32 = 0
	local temp_angle: f32 = 0
	local launch_speed: f32 = 0
	local spin_direction: f32 = 0
	local is_grounded: s32 = 0
	local drift_x: f32 = 0
	local curve_strength: f32 = 0
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
	local air_height_limit: f32 = 0
	local fall_limit_y: f32 = 0
	local end_timer: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local hit_normal_x: f32 = 0
	local hit_normal_y: f32 = 0
	local hit_normal_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local previous_speed: f32 = 0
	local temp_length: f32 = 0
	local collision_result: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_kind: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local frame_count: s32 = 0
	local pin_distance: f32 = 0
	local pin_offset_x: f32 = 0
	local pin_offset_y: f32 = 0
	local pin_offset_z: f32 = 0
	local pin_segment_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_yaw: f32 = 0
	heading_angle = vm.f32(-6.051593)
	heading_angle = event.wrap_angle(heading_angle) or heading_angle
	event.set_camera_control_enabled(1)
	event.set_camera_look_at(-11.1, 88.729996, 1309.96)
	ball_x = vm.f32(vm.f32(vm.sin(heading_angle) * 100.0) + vm.f32(-11.1))
	ball_y = vm.f32(93.729996)
	ball_z = vm.f32(vm.f32(vm.cos(heading_angle) * 100.0) + vm.f32(1309.96))
	event.set_camera_position(ball_x, ball_y, ball_z)
	heading_angle = vm.f32(-2.91)
	ball_x = 0.0
	ball_y = vm.f32(65.57)
	ball_z = vm.f32(1305.04)
	spin_direction = -1.0
	do
		local out1, out2, out3 = event.zero_vector()
		drift_x = out1 or drift_x
		curve_strength = out2 or curve_strength
		drift_z = out3 or drift_z
	end
	do
		local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	hit_pin = 0
	event.play_sound_effect(sound_bank, 12)
	launch_speed = vm.f32(41.8)
	temp_angle = vm.f32(0.218166)
	launch_speed = vm.f32(launch_speed - vm.f32(launch_speed * temp_angle))
	velocity_x = vm.f32(vm.sin(heading_angle) * vm.f32(launch_speed * vm.cos(temp_angle)))
	velocity_y = vm.f32(launch_speed * vm.sin(temp_angle))
	velocity_z = vm.f32(vm.cos(heading_angle) * vm.f32(launch_speed * vm.cos(temp_angle)))
	curve_strength = vm.f32(vm.f32(curve_strength * vm.f32(3.1415927)) / 2.0)
	drift_z = vm.f32(vm.f32(vm.f32(-velocity_z * spin_direction) * drift_x) * vm.f32(0.4))
	drift_x = vm.f32(vm.f32(vm.f32(-velocity_x * spin_direction) * drift_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	air_height_limit = 180.0
	fall_limit_y = -50.0
	end_timer = 0
	is_grounded = 0
	sound_cooldown = 0
	frame_count = 0
	while true do
		if ball_y >= air_height_limit then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (frame_count + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_result = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_result
			if is_grounded == 1 and collision_result >= 0 then
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
		if curve_strength ~= 0.0 then
			temp_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or temp_angle
			temp_angle = vm.f32(temp_angle + curve_strength)
			temp_angle = event.wrap_angle(temp_angle) or temp_angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(temp_angle) / 10.0) * spin_direction))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(temp_angle) / 10.0) * spin_direction))
		end
		temp_length = event.get_vector_length(drift_x, 0.0, drift_z) or temp_length
		if temp_length > vm.f32(0.01) then
			speed = event.get_vector_length(drift_x, 0.0, drift_z) or speed
			temp_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + drift_x, previous_y, previous_z + drift_z) or temp_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				heading_angle = out2 or heading_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, temp_angle, rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, temp_angle, rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			temp_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or temp_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				heading_angle = out2 or heading_angle
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, temp_angle, rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, temp_angle, rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		previous_speed = speed
		temp_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or temp_angle
		direction_x = vm.f32(vm.sin(vm.f32(temp_angle - vm.f32(1.5707964))) * 3.0)
		direction_z = vm.f32(vm.cos(vm.f32(temp_angle - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			ball_x - direction_x,
			ball_y,
			ball_z - direction_z,
			vm.f32(ball_x + direction_x) + direction_x,
			ball_y,
			vm.f32(ball_z + direction_z) + direction_z
		)
		do
			local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = event.normalize_vector(direction_x, direction_y, direction_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, 3.0)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		do
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, previous_x, previous_y, previous_z, ball_x + direction_x, ball_y + direction_y, ball_z + direction_z, 0)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			collision_result = out4 or collision_result
			surface_kind = out5 or surface_kind
		end
		if collision_result >= 0 and surface_kind == 1 then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(hit_x, hit_y, hit_z)
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 11)
				sound_cooldown = 20
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + direction_x, ball_y + direction_y, ball_z + direction_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			hit_normal_x = out4 or hit_normal_x
			hit_normal_y = out5 or hit_normal_y
			hit_normal_z = out6 or hit_normal_z
			collision_result = out7 or collision_result
		end
		while collision_result >= 0 do
			curve_strength = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 6)
				sound_cooldown = 20
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
			temp_length = event.get_vector_length(previous_x, previous_y, previous_z) or temp_length
			temp_length = vm.f32(previous_speed - temp_length)
			if temp_length <= 0.0 then
				break
			else
				previous_speed = temp_length
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				if velocity_y < 0.0 and hit_normal_y > 0.0 then
					velocity_x = vm.f32(drift_x * 2.0)
					velocity_y = 0.0
					velocity_z = vm.f32(drift_z * 2.0)
					drift_x = vm.f32(drift_x * vm.f32(0.2))
					drift_z = vm.f32(drift_z * vm.f32(0.2))
				else
					if
						velocity_x < 0.0 and hit_normal_x > 0.0
						or velocity_x > 0.0 and hit_normal_x < 0.0
						or velocity_z < 0.0 and hit_normal_z > 0.0
						or velocity_z > 0.0 and hit_normal_z < 0.0
					then
						drift_x = 0.0
						drift_z = 0.0
					end
					velocity_x = 0.0
					velocity_y = 0.0
					velocity_z = 0.0
				end
				velocity_x = vm.f32(vm.f32(vm.f32(hit_normal_x * speed) * vm.f32(0.9)) + velocity_x)
				velocity_y = vm.f32(vm.f32(vm.f32(hit_normal_y * speed) * vm.f32(0.58)) + velocity_y)
				velocity_z = vm.f32(vm.f32(vm.f32(hit_normal_z * speed) * vm.f32(0.9)) + velocity_z)
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				do
					local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(direction_x, direction_y, direction_z)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, 3.0)
					direction_x = out1 or direction_x
					direction_y = out2 or direction_y
					direction_z = out3 or direction_z
				end
				do
					local out1, out2, out3 = event.scale_vector(hit_normal_x, hit_normal_y, hit_normal_z, temp_length)
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
					local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
						12,
						previous_x,
						previous_y,
						previous_z,
						ball_x + direction_x,
						ball_y + direction_y,
						ball_z + direction_z,
						1
					)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
					hit_normal_x = out4 or hit_normal_x
					hit_normal_y = out5 or hit_normal_y
					hit_normal_z = out6 or hit_normal_z
					collision_result = out7 or collision_result
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
			collision_result = out7 or collision_result
			surface_kind = out8 or surface_kind
		end
		if collision_result >= 0 then
			curve_strength = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			temp_length = event.get_vector_length(velocity_x, 0.0, velocity_z) or temp_length
			if temp_length < vm.f32(2.4) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				is_grounded = 1
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.9))
				velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
				velocity_z = vm.f32(velocity_z * vm.f32(0.9))
				velocity_x = vm.f32(velocity_x + vm.f32(drift_x * 2.0))
				velocity_z = vm.f32(velocity_z + vm.f32(drift_z * 2.0))
				drift_x = vm.f32(drift_x * vm.f32(0.2))
				drift_z = vm.f32(drift_z * vm.f32(0.2))
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if sound_cooldown <= 0 then
					event.play_sound_effect(sound_bank, 5)
					sound_cooldown = 20
				end
			end
			temp_length = event.get_vector_length(drift_x, 0.0, drift_z) or temp_length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and temp_length < vm.f32(0.4) then
				if not (surface_kind == 6) then
					break
				end
				end_timer = 1
				break
			end
		end
		if ball_y < -500.0 then
			end_timer = 1
			break
		elseif frame_count >= 300 then
			end_timer = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			pin_distance = 1.0
			pin_offset_x = vm.f32(pin_x - ball_x)
			pin_offset_y = vm.f32(pin_y - ball_y)
			pin_offset_z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(pin_offset_x, pin_offset_y, pin_offset_z) or pin_distance
			if ball_color ~= pin_color then
				pin_segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or pin_segment_distance
				if pin_segment_distance >= 0.0 and pin_segment_distance <= 30.0 then
					hit_pin = 1
					break
				end
				if pin_distance ~= 0.0 then
					if pin_distance <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(pin_offset_x, pin_offset_y, pin_offset_z, vm.fdiv(vm.f32(0.6), pin_distance))
							pin_offset_x = out1 or pin_offset_x
							pin_offset_y = out2 or pin_offset_y
							pin_offset_z = out3 or pin_offset_z
						end
						do
							local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, pin_offset_x, pin_offset_y, pin_offset_z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, pin_offset_x, pin_offset_y, pin_offset_z)
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
						local out1, out2, out3 = event.scale_vector(pin_offset_x, pin_offset_y, pin_offset_z, vm.fdiv(1.0, pin_distance))
						pin_offset_x = out1 or pin_offset_x
						pin_offset_y = out2 or pin_offset_y
						pin_offset_z = out3 or pin_offset_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, pin_offset_x, pin_offset_y, pin_offset_z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, pin_offset_x, pin_offset_y, pin_offset_z)
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
			if ball_y <= fall_limit_y then
				event.set_follow_camera_following(0)
				if end_timer >= 30 then
					if end_timer >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				end_timer = end_timer + 1
			elseif frame_count >= 20 then
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_camera_speed(6.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				do
					local out1, out2, out3 = event.get_camera_position()
					camera_x = out1 or camera_x
					camera_y = out2 or camera_y
					camera_z = out3 or camera_z
				end
				event.set_follow_camera_height(30.0)
				event.set_follow_camera_distance(200.0)
				camera_yaw = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					camera_x,
					camera_y,
					camera_z
				) or camera_yaw
				event.set_follow_camera_angle(camera_yaw)
				event.set_follow_camera_target_alternate(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z
				)
				event.step_follow_camera(1)
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(1)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			frame_count = frame_count + 1
		end
	end
	if hit_pin ~= 1 then
		wait.for_frame_count(30)
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	vm.wait(3)
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
		vm.wait(4)
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
		vm.wait(5)
	end
	event.set_character_active(0, 11)
	wait.for_frame_count(54)
	event.set_camera_control_enabled(1)
	event.set_follow_camera_following(0)
end

--- Plays the e315 cutscene where Monica takes the club and sinks a sphida shot, with its own sound effects.
local function play_monica_shot_cutscene_with_sounds()
	local cutscene_sound_bank: s32 = 0
	local shot_sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(315, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(57)
		event.play_music(0)
		cutscene_sound_bank = event.load_sound_effect_file_2(3811) or cutscene_sound_bank
		shot_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or shot_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		event.get_playable_character()
		event.change_directory("event/e300/e315/")
		event.load_message_file(0, 5, "e315.txt")
		event.load_character_motion_pack(5, "e315_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.change_directory("")
		event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.delete_character_extension_packs(13)
		event.load_character_motion_pack(5, "event/e300/e312/e312_monica.gltf", "info", 13)
		event.load_character_motion_pack(5, "event/e300/e315/e315_monica.gltf", "info", 13)
		event.attach_object_handle_to_character(1, 13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.create_sword_afterimage(5, 64, 16)
		event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
		event.set_object_handle_position(0, -92.27, 48.63, 1283.9)
		event.set_object_handle_rotation(0, 0.0, 1.34, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_character_active(0, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(13, "sword_hand", 15)
		event.set_object_handle_position(1, 68.04, 41.85, 1180.61)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.set_sphida_ball_position(0.0, 65.57, 1305.04)
		event.set_sphida_ball_color(0)
		event.set_character_position(8, 0.0, 65.57, 1305.04)
		event.set_character_active(0, 8)
		event.set_character_position(9, 0.0, 65.57, 1305.04)
		event.set_character_active(1, 9)
		event.set_character_active(0, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(67.57, 63.38, 1149.74)
		event.set_camera_sequence_look_at(67.85, 63.66, 1179.99)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		event.play_sound_effect(cutscene_sound_bank, 0)
		event.set_object_sequence_motion(1, "貸しなさい", 2)
		event.queue_object_sequence_next_motion(1, "貸しなさいＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3150010)
		object.wait_until_done(1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_camera_sequence_position(65.27, 79.39, 1297.35)
		event.set_camera_sequence_look_at(6.16, 79.67, 1305.48)
		event.set_character_active(1, 0)
		event.set_object_handle_position(0, -92.27, 48.63, 1283.9)
		event.set_object_handle_rotation(0, 0.0, 1.34, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.detach_character_from_frame(15)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(13, "sword_hand", 15)
		event.set_object_handle_position(1, -11.1, 63.73, 1309.96)
		event.set_object_handle_rotation(1, 0.0, 1.8, 0.0)
		event.set_object_handle_motion(1, "かまえゴルフＬ", 4)
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3150020)
		event.set_object_sequence_motion(1, "前方確認", 2)
		event.queue_object_sequence_next_motion(1, "ショット", 6)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, cutscene_sound_bank, 1)
		event.delay_object_sequence_sound_track(1, 44)
		event.play_object_sequence_sound(1, cutscene_sound_bank, 2)
		event.delay_object_sequence_sound_track(1, 42)
		event.play_object_sequence_sound(1, cutscene_sound_bank, 3)
		object.wait_until_done(1)
		wait.for_frame_count(24)
		simulate_sphida_ball_flight(shot_sound_bank)
		event.set_camera_sequence_position(-88.57, 74.62, 1267.26)
		event.set_camera_sequence_look_at(20.74, 79.67, 1276.18)
		event.set_object_sequence_position(0, -18.67, 62.68, 1288.34)
		event.set_object_sequence_rotation(0, 0.0, -2.66, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -1.4, 62.34, 1267.0)
		event.set_object_sequence_rotation(1, 0.0, -2.68, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3150030)
		event.play_sound_effect(cutscene_sound_bank, 5)
		event.set_object_sequence_motion(0, "すごいや", 6)
		event.queue_object_sequence_next_motion(0, "すごいやL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3150040)
		object.wait_until_done(0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(16)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_character_active(0, 12)
	event.detach_character_from_frame(15)
	event.set_character_active(0, 15)
	event.delete_character(12)
	event.load_message_file(0, -1)
	event.finish_event()
end

--- Plays the cutscene in which the boss hands over the reward item and the characters receive it.
local function play_item_reward_cutscene(item_id: s32)
	local spell_sound_bank: s32 = 0
	local boss_sound_bank: s32 = 0
	local active_character: s32 = 0
	local system_sound_id: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(317, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(193)
		event.play_music(1)
		spell_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or spell_sound_bank
		boss_sound_bank = event.load_sound_effect_file_2(3817) or boss_sound_bank
		active_character = event.get_playable_character() or active_character
		event.change_directory("event/e300/e317/")
		event.load_message_file(0, 5, "e317.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e317_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.load_character(5, "e317_boss.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(2, 15)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e317_hana.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(3, 16)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_character_to_frame(0, "item", 16)
		event.change_directory("")
		event.load_item_model(5, item_id, "info", 17)
		event.set_character_active(0, 17)
		event.attach_object_handle_to_character(4, 17)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 18)
		event.set_character_active(0, 18)
		if active_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e317/e317_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/e300/e317/e317_monica.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.delete_character_extension_packs(13)
			event.load_character_motion_pack(5, "event/e300/e317/e317_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(13)
		event.set_character_active(14)
		event.attach_object_handle_to_character(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_position(0, 10.0, 62.79, 1296.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -10.0, 62.79, 1296.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(2, -323.0, 73.0, 801.25)
		event.set_object_handle_rotation(2, 0.0, 2.88, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_shadow_enabled(2, 0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_sound_bank(2, boss_sound_bank)
		event.set_object_handle_frame_draw_flag(2, "hana", 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-270.99, 155.56, 855.04)
		event.set_camera_sequence_look_at(-317.48, 77.29, 790.97)
		event.fade_in_screen(30)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		message.show_voiced(3170010)
		event.play_sound_effect(boss_sound_bank, 0)
		event.set_object_sequence_motion(2, "立ちから飛び", 2)
		event.queue_object_sequence_next_motion(2, "飛び", 4)
		event.delay_object_sequence_position_track(2, 30)
		event.move_object_sequence_eased(2, -292.12, 88.0, 718.16, 40, 1, 1.0)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-173.05, 197.62, 491.25)
		event.set_camera_sequence_look_at(-157.61, 198.62, 397.99)
		event.set_object_sequence_position(2, -257.58, 157.22, 483.43)
		event.move_object_sequence(2, -13.74, 178.47, -571.1, 180)
		wait.for_frame_count(30)
		event.move_camera_sequence_eased(8.44, 86.91, 1369.12, -11.91, 107.25, 1150.24, 120, 0, 0.2)
		camera.wait_until_done()
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-30.54, 63.5, 1250.05)
		event.set_camera_sequence_look_at(1.85, 81.24, 1299.33)
		event.play_sound_effect(boss_sound_bank, 2)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		object.wait_until_done(1)
		object.wait_until_done(0)
		wait.for_frame_count(40)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		wait.for_frame_count(10)
		event.set_camera_sequence_position(8.44, 86.91, 1369.12)
		event.set_camera_sequence_look_at(-11.91, 107.25, 1150.24)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 140)
		event.add_object_sequence_path_point(2, -99.87, 325.67, -377.78)
		event.add_object_sequence_path_point(2, -86.48, 290.88, -92.22)
		event.add_object_sequence_path_point(2, -74.49, 270.46, 99.58)
		event.add_object_sequence_path_point(2, -80.07, 258.98, 356.49)
		event.add_object_sequence_path_point(2, -108.42, 224.24, 515.31)
		event.add_object_sequence_path_point(2, -190.47, 156.03, 662.8)
		event.start_object_sequence_path(2)
		wait.for_frame_count(38)
		event.move_object_sequence(1, -145.57, 26.27, 1125.27, 100, 1)
		event.rotate_object_sequence(1, 0.0, -2.54, 0.0, 10)
		event.set_object_sequence_motion(1, "走り")
		wait.for_frame_count(14)
		event.move_object_sequence(0, -115.45, 30.53, 1131.91, 86, 1)
		event.rotate_object_sequence(0, 0.0, -2.54, 0.0, 10)
		event.set_object_sequence_motion(0, "走り")
		object.wait_until_done(1)
		object.wait_until_done(0)
		object.wait_until_done(2)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-368.06, 55.78, 1062.51)
		event.set_camera_sequence_look_at(-342.12, 43.19, 881.2)
		event.play_sound_effect(boss_sound_bank, 3)
		event.set_object_sequence_motion(2, "飛びから立ち", 6)
		event.set_object_sequence_motion_time(2, 40)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_position(2, -329.15, 98.27, 784.46)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.move_object_sequence(2, -334.07, 73.0, 828.92, 30)
		event.set_object_sequence_position(1, -323.44, 0.56, 979.56)
		event.set_object_sequence_rotation(1, 0.0, -2.9, 0.0)
		event.move_object_sequence(1, -338.5, 0.26, 920.0, 40, 1)
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, -3.02, 0.0, 10)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_motion_track(1, 1)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		wait.for_frame_count(10)
		event.set_object_sequence_position(0, -346.15, 0.78, 1002.45)
		event.set_object_sequence_rotation(0, 0.0, 2.9, 0.0)
		event.move_object_sequence(0, -355.0, 0.46, 920.0, 40, 1)
		event.delay_object_sequence_rotation_track(0, 30)
		event.rotate_object_sequence(0, 0.0, 2.78, 0.0, 10)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		object.wait_until_done(1)
		object.wait_until_done(0)
		object.wait_until_done(2)
		event.move_camera_sequence_angle_height_distance_eased(0.63, 12.59, 190.82, 120, 0, 0.4)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "会話２", 6, 0.6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced(3170020)
		object.wait_until_done(2)
		camera.wait_until_done()
		event.set_object_handle_frame_draw_flag(2, "hana", 1)
		event.set_object_sequence_motion(2, "頭を下げる", 2)
		event.queue_object_sequence_next_motion(2, "頭を下げるL", 4)
		message.show_voiced(3170025)
		object.wait_until_done(2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(0, 1, "口とじ～大口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(1, 1, "口とじ～大口")
		event.set_object_sequence_motion(0, "あーっ！", 6)
		event.queue_object_sequence_next_motion(0, "あーっ！L", 4)
		event.set_object_sequence_motion(1, "上向き指差し", 6)
		event.queue_object_sequence_next_motion(1, "上向き指差しＬ", 4)
		message.show_voiced(3170030)
		object.wait_until_done(1)
		object.wait_until_done(0)
		message.show_voiced(3170040)
		event.set_camera_sequence_position(-354.86, 5.98, 980.21)
		event.set_camera_sequence_look_at(-340.74, 53.89, 881.38)
		event.move_camera_sequence_eased(-312.11, 124.5, 846.08, -346.32, 77.26, 868.46, 30, 0, 1.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3170050)
		camera.wait_until_done()
		event.pause_music()
		event.set_character_active(1, 18)
		event.set_character_position(18, -336.95, 92.55, 866.22)
		event.set_character_rotation(18, 0.6, -0.84, 0.0)
		event.set_character_motion(18, "発動", 6)
		wait.for_frame_count(2)
		event.play_sound_effect(spell_sound_bank, 0)
		wait.for_frame_count(120)
		event.play_sound_effect(boss_sound_bank, 7)
		inventory.show_obtained_message_for_item_id(363, 1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.play_music(1)
		event.set_character_active(0, 18)
		event.set_camera_sequence_position(-265.62, 162.13, 816.12)
		event.set_camera_sequence_look_at(-337.34, 74.97, 859.33)
		event.fade_in_screen(30)
		event.set_object_handle_frame_draw_flag(2, "hana", 0)
		event.set_character_active(1, 16)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(0, "花持ち立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "会話２", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced(3170060)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-362.47, 38.8, 1063.3)
		event.set_camera_sequence_look_at(-337.46, 47.14, 861.71)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		message.show_voiced(3170065)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced(3170070)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3170075)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		message.show_voiced(3170080)
		object.wait_until_done(2)
		event.play_sound_effect(boss_sound_bank, 4)
		event.set_object_sequence_motion(2, "立ちから飛び", 2)
		event.queue_object_sequence_next_motion(2, "飛び", 4)
		event.delay_object_sequence_position_track(2, 30)
		event.move_object_sequence_eased(2, -334.07, 133.0, 828.92, 30, 1, 1.0)
		object.wait_until_done(2)
		message.show_voiced(3170090)
		message.show_voiced(3170095)
		event.play_sound_effect(boss_sound_bank, 5)
		event.set_character_active(17)
		event.set_object_sequence_position(4, -334.07, 133.0, 828.92)
		event.set_object_sequence_rotation(4, 0.0, -1.57, 0.0)
		event.jump_object_sequence(4, -343.64, 25.73, 905.48, -0.2, 30)
		object.wait_until_done(4)
		event.set_camera_sequence_position(-342.47, 55.33, 881.22)
		event.set_camera_sequence_look_at(-346.84, 21.58, 917.8)
		event.play_sound_effect(boss_sound_bank, 6)
		event.set_character_active(0, 16)
		event.attach_character_to_frame(0, "ef00", 17)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "クラブゲット", 6)
		event.queue_object_sequence_next_motion(0, "クラブゲットL", 4)
		object.wait_until_done(0)
		event.pause_music()
		event.set_object_sequence_motion(2, "飛び", 1)
		event.set_character_active(1, 18)
		event.set_character_position(18, -351.31, 30.76, 917.09)
		event.set_character_rotation(18, 0.4, -0.12, 0.0)
		event.set_character_motion(18, "発動", 6, -1.0, 1)
		wait.for_frame_count(2)
		event.play_sound_effect(spell_sound_bank, 0)
		wait.for_frame_count(120)
		event.play_sound_effect(boss_sound_bank, 7)
		system_sound_id = event.get_system_sound_id() or system_sound_id
		event.play_sound_effect(system_sound_id, 18)
		event.set_message_window_mode(0, 4)
		if item_id == 10 then
			event.open_message_window_2(0, 9000020)
			message.show_and_wait(0, -1, 8, 0, 0)
		else
			event.open_message_window_2(0, 9000010)
			message.show_and_wait(0, -1, 8, 0, 0)
		end
		event.set_message_window_mode(0, 7)
		event.play_music(1)
		event.set_character_active(0, 18)
		event.set_object_sequence_motion(2, "飛び", 4)
		event.set_camera_sequence_position(-366.74, 221.09, 968.17)
		event.set_camera_sequence_look_at(-335.68, 196.88, 838.07)
		event.play_sound_effect(boss_sound_bank, 8)
		event.set_object_sequence_rotation(2, 0.0, 2.86, 0.0)
		event.move_object_sequence(2, -211.7, 150.58, 316.36, 120)
		message.show_voiced_line(3170100, 90)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(55)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(spell_sound_bank, 0)
	event.stop_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_visible(5, 1)
	event.set_object_handle_visible(6, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.load_message_file(0, -1)
	inventory.resolve_overflow(0)
	event.finish_event()
end

--- Waits briefly, shows a message of the given kind and waits again.
local function show_delayed_message(message_kind: s32, unused_argument: any)
	wait.skip_frame_count(20)
	message.show_then_close_variant(0, -1, message_kind, 0, 0)
	wait.skip_frame_count(11)
end

--- Plays effect 13 between its standard lead-in and lead-out waits.
local function play_timed_effect()
	show_delayed_message(13, 9000000)
end

--- Plays effect 13 and then effect 5 with waits around them and returns 1.
local function play_timed_effect_sequence()
	local effect_id: s32 = 0
	local unused_result: s32 = 0
	effect_id = 13
	wait.skip_frame_count(20)
	message.show_then_close_variant(0, -1, effect_id, 0, 0)
	message.open_skipping(0, -1, 5, 0, 0)
	local _ = unused_result ~= 0
	local _ = unused_result ~= 0
	unused_result = message.resume_choice(0, 2, 1, 0)
	wait.skip_frame_count(30)
	return 1
end

--- Waits six frames while allowing the event to be skipped.
local function wait_short_delay()
	wait.skip_frame_count(6)
end

--- Returns 1 when the player cannot take a shot because of the wrong character or no handy stick equipped, and otherwise sets the club.
local function is_shot_blocked()
	local active_character: s32 = 0
	local equipped_item: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		active_character = event.get_playable_character() or active_character
		if active_character ~= 0 then
			event.set_message_window_mode(0, 4)
			resume_step = 1
			message.show_and_wait(0, 2000, 8, 0, 0)
			return 1
		end
		equipped_item = event.get_equipped_item(0, 0) or equipped_item
		if equipped_item ~= 9 and equipped_item ~= 10 and equipped_item ~= 11 and equipped_item ~= 12 and equipped_item ~= 13 and equipped_item ~= 14 then
			event.set_message_window_mode(0, 4)
			event.open_message_window_2(0, "『手ごろな枝』を装備してください。")
			resume_step = 2
			message.show_and_wait(0, -1, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(equipped_item)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if resume_step <= 1 then
			return 1
		end
		if resume_step <= 2 then
			return 1
		end
		return nil
	end)
end

--- Restores the player and camera after the round, shows the round-over message and fades out when no par remains, then ends the event and returns the exit mode.
local function finish_round(exit_mode: s32)
	local remaining_par: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		event.set_sphida_status_panel_visible(0)
		event.delete_character(12)
		event.delete_event_image(1)
		event.clear_effect_manager()
		event.delete_character_extension_packs(0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.set_character_active(1, 13)
		event.set_character_active(1, 14)
		event.attach_object_handle_to_character(0, 1)
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_character(0, 2)
		event.set_object_handle_visible(0, 0)
		event.set_camera_control_enabled(1)
		event.delete_sword_afterimage()
		event.show_dungeon_status_bar(0, 1.0)
		if exit_mode ~= 1 then
			event.start_crossfade(15)
		end
		remaining_par = event.get_sphida_par() or remaining_par
		if exit_mode == 0 and remaining_par <= 0 then
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
			event.set_message_window_mode(0, 4)
			progress_step = 1
			message.show_and_wait(0, 2003, 8, 0, 0)
			event.fade_out_screen(30)
			progress_step = 2
			wait.for_frame_count(30)
			exit_mode = 2
			event.reset_follow_camera(0)
		end
		event.run_dungeon_event(-1)
		event.clear_event_running_flag()
		event.finish_event()
		return exit_mode
	end, function(received: { any })
		if progress_step <= 2 then
			if progress_step <= 1 then
				wait.skip_frame_count(30)
			end
			local _ = exit_mode ~= 1
			local _ = exit_mode == 0
			exit_mode = 2
			return exit_mode
		end
		return nil
	end)
end

--- Shows the round-over message, waits 30 frames and returns exit mode 2.
local function show_round_over_message(exit_mode: s32)
	message.show_and_wait_skipping(0, 2003, 8, 0, 0)
	wait.skip_frame_count(30)
	local _ = exit_mode ~= 1
	local _ = exit_mode == 0
	exit_mode = 2
	return exit_mode
end

--- Runs one Sphida shot from aiming and the power gauge through the ball flight and its outcome and returns the round result.
local function play_sphida_shot()
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
	local elevation_angle: f32 = 0
	local shot_power: f32 = 0
	local club_spin_factor: f32 = 0
	local level: s32 = 0
	local drift_x: f32 = 0
	local curve_strength: f32 = 0
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
	local out_of_play_timer: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local hit_normal_x: f32 = 0
	local hit_normal_y: f32 = 0
	local hit_normal_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local remaining_distance: f32 = 0
	local temp_length: f32 = 0
	local collision_result: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_kind: s32 = 0
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
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		resume_step = 1
		if is_shot_blocked() ~= 0 then
			event.finish_event()
			return 0
		end
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.start_background_file_loads_4(
			"dungeon/sphida/c01_golf.gltf",
			"dungeon/chara/c01b_miss.gltf",
			"dungeon/sphida/gool_end.gltf",
			"dungeon/sphida/mizu_eff.gltf"
		)
		resume_step = 2
		vm.wait(2)
		resume_step = 3
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
		event.attach_object_handle_to_character(0, 1)
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_character(0, 2)
		event.set_object_handle_visible(0, 0)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.start_crossfade(15)
		event.reset_sphida_power_gauge()
		do
			local out1, out2, out3 = event.get_sphida_ball_position()
			start_x = out1 or start_x
			start_y = out2 or start_y
			start_z = out3 or start_z
		end
		ball_x, ball_y, ball_z, aim_angle = bargas_valley.place_ball_and_aim(ball_x, ball_y, ball_z, aim_angle)
		camera.place_behind_player(aim_angle)
		event.set_sphida_status_panel_visible(1)
		elevation_angle = 12.5
		event.set_sphida_carry_angle(vm.f32(elevation_angle * vm.f32(3.1415927)) / 180.0)
		shot_power, club_spin_factor, level = minigame.get_equipped_club_definition(shot_power, club_spin_factor, level)
		event.set_sphida_power_gauge_safe_level(level)
		do
			local out1, out2, out3 = event.zero_vector()
			drift_x = out1 or drift_x
			curve_strength = out2 or curve_strength
			drift_z = out3 or drift_z
		end
		while true do
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			resume_step = 4
			local t0: s32
			t0, aim_angle, elevation_angle = bargas_valley.aim_sphida_shot(aim_angle, elevation_angle, tex_bank)
			if t0 ~= 0 then
				event.set_sphida_minimap_scroll_enabled(0)
				event.set_sphida_minimap_shot_line_visible(0)
				event.set_sphida_ball_position(start_x, start_y, start_z)
				event.set_character_position(8, start_x, start_y, start_z)
				event.set_character_position(9, start_x, start_y, start_z)
				resume_step = 5
				return finish_round(0)
			end
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			resume_step = 6
			local t1: s32
			t1, shot_power, aim_angle, curve_strength, drift_x, level = minigame.run_sphida_power_gauge_with_extra_frame(shot_power, tex_bank, aim_angle, curve_strength, drift_x, sound_bank, level)
			if t1 == 0 then
				break
			else
				resume_step = 7
				vm.wait(7)
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
			resume_step = 8
			wait.for_frame_count(10)
		end
		if shot_power <= vm.f32(0.3) then
			event.set_character_motion(0, "小ショット", 2)
			resume_step = 9
			wait.for_frame_count(25)
			if level ~= 4 then
				event.play_sound_effect(sound_bank, 3)
			end
		elseif shot_power <= vm.f32(0.6) then
			event.set_character_motion(0, "中ショット", 2)
			resume_step = 10
			wait.for_frame_count(34)
			event.play_sound_effect(sound_bank, 2)
		else
			event.set_character_motion(0, "大ショット", 2)
			resume_step = 11
			wait.for_frame_count(39)
			if level == 0 then
				event.play_sound_effect(sound_bank, 12)
			else
				event.play_sound_effect(sound_bank, 1)
			end
		end
		if level == 4 then
			resume_step = 12
			wait.for_frame_count(50)
			bargas_valley.consume_par_stroke(sound_bank)
			event.set_sphida_ball_position(start_x, start_y, start_z)
			event.set_character_position(8, start_x, start_y, start_z)
			event.set_character_position(9, start_x, start_y, start_z)
			resume_step = 13
			return finish_round(0)
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
		shot_power = minigame.scale_by_club_power(shot_power)
		elevation_angle = vm.f32(vm.f32(elevation_angle * vm.f32(3.1415927)) / 180.0)
		shot_power = vm.f32(shot_power - vm.f32(shot_power * elevation_angle))
		velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(shot_power * vm.cos(elevation_angle)))
		velocity_y = vm.f32(shot_power * vm.sin(elevation_angle))
		velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(shot_power * vm.cos(elevation_angle)))
		curve_strength = vm.f32(vm.f32(curve_strength * vm.f32(3.1415927)) / 2.0)
		drift_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_spin_factor) * drift_x) * vm.f32(0.4))
		drift_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_spin_factor) * drift_x) * vm.f32(0.4))
		do
			local out1, out2, out3 = event.get_sphida_pin_position()
			pin_x = out1 or pin_x
			pin_y = out2 or pin_y
			pin_z = out3 or pin_z
		end
		out_of_play_timer = 0
		level = 0
		sound_cooldown = 0
		frame_count = 0
		while true do
			if ball_y >= 180.0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (frame_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			else
				collision_result = event.get_segment_collision_9(
					12,
					ball_x,
					ball_y,
					ball_z,
					ball_x,
					vm.f32(ball_y - 3.0) - vm.f32(0.01),
					ball_z,
					0
				) or collision_result
				if level == 1 and collision_result >= 0 then
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
			if curve_strength ~= 0.0 then
				elevation_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation_angle
				elevation_angle = vm.f32(elevation_angle + curve_strength)
				elevation_angle = event.wrap_angle(elevation_angle) or elevation_angle
				velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(elevation_angle) / 10.0) * club_spin_factor))
				velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(elevation_angle) / 10.0) * club_spin_factor))
			end
			temp_length = event.get_vector_length(drift_x, 0.0, drift_z) or temp_length
			if temp_length > vm.f32(0.01) then
				speed = event.get_vector_length(drift_x, 0.0, drift_z) or speed
				elevation_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + drift_x, previous_y, previous_z + drift_z) or elevation_angle
				do
					local out1, out2, out3 = event.get_character_rotation(8)
					rotation_x = out1 or rotation_x
					aim_angle = out2 or aim_angle
					rotation_z = out3 or rotation_z
				end
				event.set_character_rotation(8, rotation_x, elevation_angle, rotation_z)
				event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
				event.set_character_rotation(9, rotation_x, elevation_angle, rotation_z)
				event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
			else
				speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
				elevation_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation_angle
				do
					local out1, out2, out3 = event.get_character_rotation(8)
					rotation_x = out1 or rotation_x
					aim_angle = out2 or aim_angle
					rotation_z = out3 or rotation_z
				end
				event.set_character_rotation(8, rotation_x, elevation_angle, rotation_z)
				event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
				event.set_character_rotation(9, rotation_x, elevation_angle, rotation_z)
				event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
			end
			speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
			remaining_distance = speed
			elevation_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or elevation_angle
			direction_x = vm.f32(vm.sin(vm.f32(elevation_angle - vm.f32(1.5707964))) * 3.0)
			direction_z = vm.f32(vm.cos(vm.f32(elevation_angle - vm.f32(1.5707964))) * 3.0)
			event.add_sword_afterimage_point(
				ball_x - direction_x,
				ball_y,
				ball_z - direction_z,
				vm.f32(ball_x + direction_x) + direction_x,
				ball_y,
				vm.f32(ball_z + direction_z) + direction_z
			)
			do
				local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			do
				local out1, out2, out3 = event.normalize_vector(direction_x, direction_y, direction_z)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			do
				local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, 3.0)
				direction_x = out1 or direction_x
				direction_y = out2 or direction_y
				direction_z = out3 or direction_z
			end
			do
				local out1, out2, out3, out4, out5 =
					event.get_segment_collision_13(0, previous_x, previous_y, previous_z, ball_x + direction_x, ball_y + direction_y, ball_z + direction_z, 0)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
				collision_result = out4 or collision_result
				surface_kind = out5 or surface_kind
			end
			if collision_result >= 0 and (surface_kind == 1 or surface_kind == 7) then
				event.create_effect("足水パシャ")
				event.set_effect_first_vector(hit_x, hit_y, hit_z)
				if sound_cooldown <= 0 then
					event.play_sound_effect(sound_bank, 11)
					sound_cooldown = 20
				end
			end
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + direction_x, ball_y + direction_y, ball_z + direction_z, 1)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
				hit_normal_x = out4 or hit_normal_x
				hit_normal_y = out5 or hit_normal_y
				hit_normal_z = out6 or hit_normal_z
				collision_result = out7 or collision_result
			end
			if collision_result < 0 then
				if ball_y >= 400.0 and velocity_y > 0.0 then
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
					collision_result = 1
				end
			end
			while collision_result >= 0 do
				curve_strength = 0.0
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if sound_cooldown <= 0 then
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
				temp_length = event.get_vector_length(previous_x, previous_y, previous_z) or temp_length
				temp_length = vm.f32(remaining_distance - temp_length)
				if temp_length <= 0.0 then
					break
				else
					remaining_distance = temp_length
					do
						local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
						velocity_x = out1 or velocity_x
						velocity_y = out2 or velocity_y
						velocity_z = out3 or velocity_z
					end
					if velocity_y < 0.0 and hit_normal_y > 0.0 then
						velocity_x = vm.f32(drift_x * 2.0)
						velocity_y = 0.0
						velocity_z = vm.f32(drift_z * 2.0)
						drift_x = vm.f32(drift_x * vm.f32(0.2))
						drift_z = vm.f32(drift_z * vm.f32(0.2))
					else
						if
							velocity_x < 0.0 and hit_normal_x > 0.0
							or velocity_x > 0.0 and hit_normal_x < 0.0
							or velocity_z < 0.0 and hit_normal_z > 0.0
							or velocity_z > 0.0 and hit_normal_z < 0.0
						then
							drift_x = 0.0
							drift_z = 0.0
						end
						velocity_x = 0.0
						velocity_y = 0.0
						velocity_z = 0.0
					end
					velocity_x = vm.f32(vm.f32(vm.f32(hit_normal_x * speed) * vm.f32(0.9)) + velocity_x)
					velocity_y = vm.f32(vm.f32(vm.f32(hit_normal_y * speed) * vm.f32(0.58)) + velocity_y)
					velocity_z = vm.f32(vm.f32(vm.f32(hit_normal_z * speed) * vm.f32(0.9)) + velocity_z)
					do
						local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
						previous_x = out1 or previous_x
						previous_y = out2 or previous_y
						previous_z = out3 or previous_z
					end
					do
						local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
						direction_x = out1 or direction_x
						direction_y = out2 or direction_y
						direction_z = out3 or direction_z
					end
					do
						local out1, out2, out3 = event.normalize_vector(direction_x, direction_y, direction_z)
						direction_x = out1 or direction_x
						direction_y = out2 or direction_y
						direction_z = out3 or direction_z
					end
					do
						local out1, out2, out3 = event.scale_vector(direction_x, direction_y, direction_z, 3.0)
						direction_x = out1 or direction_x
						direction_y = out2 or direction_y
						direction_z = out3 or direction_z
					end
					do
						local out1, out2, out3 = event.scale_vector(hit_normal_x, hit_normal_y, hit_normal_z, temp_length)
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
						local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
							12,
							previous_x,
							previous_y,
							previous_z,
							ball_x + direction_x,
							ball_y + direction_y,
							ball_z + direction_z,
							1
						)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						hit_normal_x = out4 or hit_normal_x
						hit_normal_y = out5 or hit_normal_y
						hit_normal_z = out6 or hit_normal_z
						collision_result = out7 or collision_result
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
				collision_result = out7 or collision_result
				surface_kind = out8 or surface_kind
			end
			if collision_result >= 0 then
				curve_strength = 0.0
				ball_y = vm.f32(hit_y + 3.0)
				temp_length = event.get_vector_length(velocity_x, 0.0, velocity_z) or temp_length
				if temp_length < vm.f32(2.4) or velocity_y >= -1.0 and velocity_y <= 0.0 then
					velocity_y = 0.0
					level = 1
				else
					velocity_x = vm.f32(velocity_x * vm.f32(0.9))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
					velocity_z = vm.f32(velocity_z * vm.f32(0.9))
					velocity_x = vm.f32(velocity_x + vm.f32(drift_x * 2.0))
					velocity_z = vm.f32(velocity_z + vm.f32(drift_z * 2.0))
					drift_x = vm.f32(drift_x * vm.f32(0.2))
					drift_z = vm.f32(drift_z * vm.f32(0.2))
					if speed > 8.0 then
						minigame.toggle_sphida_ball_color()
					end
					if sound_cooldown <= 0 then
						event.play_sound_effect(sound_bank, 5)
						sound_cooldown = 10
					end
				end
				temp_length = event.get_vector_length(drift_x, 0.0, drift_z) or temp_length
				if velocity_y == 0.0 and speed < vm.f32(1.6) and temp_length < vm.f32(0.4) then
					if not (surface_kind == 6) then
						break
					end
					out_of_play_timer = 1
					break
				end
			end
			if ball_y < -500.0 then
				out_of_play_timer = 1
				break
			elseif frame_count >= 300 then
				out_of_play_timer = 1
				break
			else
				pin_color = event.get_sphida_pin_color() or pin_color
				ball_color = event.get_sphida_ball_color() or ball_color
				x = vm.f32(pin_x - ball_x)
				y = vm.f32(pin_y - ball_y)
				z = vm.f32(pin_z - ball_z)
				pin_distance = event.get_vector_length(x, y, z) or pin_distance
				if ball_color ~= pin_color then
					pin_segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z)
						or pin_segment_distance
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
				if ball_y <= -70.0 then
					event.set_follow_camera_following(0)
					if out_of_play_timer >= 30 then
						if out_of_play_timer >= 50 then
							break
						end
					else
						event.set_camera_look_at(ball_x, ball_y, ball_z)
					end
					out_of_play_timer = out_of_play_timer + 1
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
				resume_step = 14
				vm.wait(14)
				if sound_cooldown > 0 then
					sound_cooldown = sound_cooldown - 1
				end
				if shot_power > 0.0 then
					shot_power = vm.f32(shot_power - 1.0)
				end
				frame_count = frame_count + 1
			end
		end
		event.set_character_position(8, ball_x, ball_y, ball_z)
		event.set_character_position(9, ball_x, ball_y, ball_z)
		resume_step = 15
		vm.wait(15)
		event.set_sphida_status_panel_visible(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if out_of_play_timer == 0 then
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			if hit_pin == 1 then
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
					resume_step = 16
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
					resume_step = 17
					vm.wait(17)
				end
				event.set_character_active(0, 11)
				pin_color = event.get_dungeon_stage_id() or pin_color
				ball_color = event.get_dungeon_floor() or ball_color
				collision_result = event.get_dungeon_floor_info(pin_color, ball_color, 4) or collision_result
				do
					local out1, out2 = event.get_sphida_prize(collision_result)
					sound_cooldown = out1 or sound_cooldown
					surface_kind = out2 or surface_kind
				end
				collision_result = vm.i32(collision_result + 1)
				event.set_dungeon_floor_info(pin_color, ball_color, 4, collision_result)
				resume_step = 18
				wait.for_frame_count(54)
				resume_step = 19
				wait.for_frame_count(30)
				event.delete_character(8)
				event.delete_character(9)
				event.delete_character(10)
				event.delete_character(11)
				event.set_sphida_playing(0)
				event.fade_out_screen(30)
				resume_step = 20
				wait.for_frame_count(30)
				event.play_music(0)
				event.release_camera_sequence_follow_object()
				event.set_event_sprite_draw_pass(0, 0)
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
			resume_step = 21
			object.wait_until_done(0)
			resume_step = 22
			wait.for_frame_count(20)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_sphida_ball_position(start_x, start_y, start_z)
			event.set_character_position(8, start_x, start_y, start_z)
			event.set_character_position(9, start_x, start_y, start_z)
			event.release_camera_sequence_follow_object()
		end
		if hit_pin == 1 then
			bargas_valley.consume_par_stroke(-1)
		else
			bargas_valley.consume_par_stroke(sound_bank)
		end
		resume_step = 23
		return finish_round(hit_pin)
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				local _ = received[1] :: number
				local _ = received[1] :: number
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step == 4 then
				local _ = received[1] :: number
				aim_angle = received[2] :: number
				elevation_angle = received[3] :: number
			end
			if resume_step <= 2 then
				wait.background_load_skipping()
			end
			if resume_step <= 3 then
				ball_x, ball_y, ball_z, aim_angle = bargas_valley.probe_clearance_arc(ball_x, ball_y, ball_z, aim_angle)
				bargas_valley.compute_offset_behind_angle(aim_angle)
				elevation_angle = 12.5
				shot_power, club_spin_factor, level = bargas_valley.return_arguments(shot_power, club_spin_factor, level)
				do
					local _: any
					_, aim_angle, elevation_angle = bargas_valley.update_aim_controls(aim_angle, elevation_angle, tex_bank)
				end
			end
			return show_round_over_message(0)
		end
		if resume_step <= 13 then
			if resume_step == 6 then
				local _ = received[1] :: number
				shot_power = received[2] :: number
				aim_angle = received[3] :: number
				curve_strength = received[4] :: number
				drift_x = received[5] :: number
				level = received[6] :: number
			end
			if resume_step <= 7 then
				hit_pin = 0
				wait.skip_frame_count(10)
			end
			if resume_step <= 8 then
				wait.skip_frame_count(25)
			end
			if resume_step <= 9 then
				wait.skip_frame_count(34)
			end
			if resume_step <= 10 then
				wait.skip_frame_count(39)
			end
			if resume_step <= 11 then
				wait.skip_frame_count(50)
			end
			if resume_step <= 12 then
				bargas_valley.decrement_counter(sound_bank)
			end
			return show_round_over_message(0)
		end
		if resume_step <= 23 then
			if resume_step <= 14 then
				local _ = sound_cooldown > 0
				sound_cooldown = sound_cooldown - 1
				local _ = shot_power > 0.0
				shot_power = vm.f32(shot_power - 1.0)
				local _ = frame_count >= 300
				local _ = frame_count >= 20
				frame_count = frame_count + 1
			end
			if resume_step <= 15 then
				frame_count = 0
				local _ = frame_count < 2
				frame_count = frame_count + 1
			end
			if resume_step <= 16 then
				frame_count = 0
				local _ = frame_count < 100
				frame_count = frame_count + 1
			end
			if resume_step <= 17 then
				local _ = collision_result >= 0
				local _ = collision_result >= 0
				collision_result = collision_result + 1
				wait.skip_frame_count(54)
			end
			if resume_step <= 18 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 19 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 20 then
				cutscene.skip_command(0)
			end
			if resume_step <= 21 then
				wait.skip_frame_count(20)
			end
			if resume_step <= 22 then
				bargas_valley.decrement_counter(-1)
				bargas_valley.decrement_counter(sound_bank)
			end
			return show_round_over_message(hit_pin)
		end
		return nil
	end)
end

--- Plays the e316 cutscene where Mints and Monica celebrate the sphida cup-in.
local function play_hole_in_cup_cutscene()
	local cutscene_sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(316, 1)
		event.set_camera_position(-88.57, 74.62, 1267.26)
		event.set_camera_look_at(20.74, 79.67, 1276.18)
		event.stop_music(0)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		cutscene_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or cutscene_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		event.get_playable_character()
		event.load_message_file(0, 5, "event/e300/e316/e316.txt")
		event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
		event.load_character_motion_pack(5, "event/e300/e316/e316_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.delete_character_extension_packs(13)
		event.load_character_motion_pack(5, "event/e300/e316/e316_monica.gltf", "info", 13)
		event.attach_object_handle_to_character(1, 13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(0, -1.4, 62.34, 1267.0)
		event.set_object_handle_rotation(0, 0.0, -2.68, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -18.67, 62.68, 1288.34)
		event.set_object_handle_rotation(1, 0.0, -2.66, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-0.23, 74.74, 1183.98)
		event.set_camera_sequence_look_at(-6.52, 79.67, 1277.87)
		event.move_camera_sequence_eased(-1.7, 74.74, 1206.03, -6.52, 79.67, 1277.87, 90, 2, 0.3)
		event.play_sound_effect(cutscene_sound_bank, 0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "カップインポーズ", 6)
		event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
		wait.for_frame_count(90)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(3160010)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(3160020)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(7)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(cutscene_sound_bank, 0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_character_active(0, 12)
	event.detach_character_from_frame(15)
	event.set_character_active(0, 15)
	event.load_message_file(0, -1)
	event.finish_event()
end

--- Plays the e315 cutscene where Monica takes the club and sinks a sphida shot.
local function play_monica_shot_cutscene()
	local playable_character: s32 = 0
	local shot_sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(315, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(57)
		event.play_music(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e300/e315/")
		event.load_message_file(0, 5, "e315.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e315_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.change_directory("")
		if playable_character == 1 then
		else
			event.delete_character_extension_packs(13)
			event.load_character_motion_pack(5, "event/e300/e312/e312_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/e300/e315/e315_monica.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
		end
		event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
		event.set_character_active(0, 12)
		shot_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or shot_sound_bank
		event.create_sword_afterimage(5, 64, 16)
		event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
		event.set_object_handle_position(0, 0.0, 62.57, 1305.04)
		event.set_object_handle_rotation(0, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(0, "かまえ", 4)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(0, "ef00", 15)
		event.set_object_handle_position(1, 10.18, 60.14, 1220.36)
		event.set_object_handle_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.set_sphida_ball_position(0.0, 65.57, 1305.04)
		event.set_sphida_ball_color(0)
		event.set_character_position(8, 0.0, 65.57, 1305.04)
		event.set_character_active(0, 8)
		event.set_character_position(9, 0.0, 65.57, 1305.04)
		event.set_character_active(1, 9)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(33.53, 98.1, 1193.52)
		event.set_camera_sequence_look_at(-0.29, 79.67, 1298.18)
		event.fade_in_screen(30)
		event.move_object_sequence(1, 5.22, 62.06, 1250.05, 30)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(1)
		wait.for_frame_count(10)
		event.set_camera_sequence_position(1.79, 84.97, 1287.12)
		event.set_camera_sequence_look_at(5.49, 82.83, 1251.39)
		event.set_object_sequence_motion(1, "貸しなさい", 2)
		event.queue_object_sequence_next_motion(1, "貸しなさいＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3150010)
		object.wait_until_done(1)
		event.set_camera_sequence_position(65.27, 79.39, 1297.35)
		event.set_camera_sequence_look_at(6.16, 79.67, 1305.48)
		event.set_object_handle_position(0, -92.27, 48.63, 1283.9)
		event.set_object_handle_rotation(0, 0.0, 1.34, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.detach_character_from_frame(15)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(13, "sword_hand", 15)
		event.set_object_handle_position(1, -11.1, 63.73, 1309.96)
		event.set_object_handle_rotation(1, 0.0, 1.8, 0.0)
		event.set_object_handle_motion(1, "かまえゴルフＬ", 4)
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3150020)
		event.set_object_sequence_motion(1, "前方確認", 2)
		event.queue_object_sequence_next_motion(1, "ショット", 6)
		object.wait_until_done(1)
		wait.for_frame_count(24)
		simulate_sphida_ball_flight(shot_sound_bank)
		event.set_camera_sequence_position(-88.57, 74.62, 1267.26)
		event.set_camera_sequence_look_at(20.74, 79.67, 1276.18)
		event.set_object_sequence_position(0, -18.67, 62.68, 1288.34)
		event.set_object_sequence_rotation(0, 0.0, -2.66, 0.0)
		event.reset_object_sequence_dynamic_animation(0, 0.0, -2.66, 0.0)
		event.set_object_sequence_position(1, -1.4, 62.34, 1267.0)
		event.set_object_sequence_rotation(1, 0.0, -2.68, 0.0)
		event.call_command(454, 1, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3150030)
		event.set_object_sequence_motion(0, "すごいや", 6)
		event.queue_object_sequence_next_motion(0, "すごいやL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3150040)
		object.wait_until_done(0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(14)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_character_active(0, 12)
	event.detach_character_from_frame(15)
	event.set_character_active(0, 15)
	event.delete_character(12)
	event.load_message_file(0, -1)
	event.finish_event()
end

--- Has the partner ask whether to try again after a miss and returns 1 when the player retries.
local function ask_retry_after_miss()
	local sound_bank: s32 = 0
	local answer: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		sound_bank = event.load_sound_effect_file_2(3809) or sound_bank
		event.set_character_active(0, 0)
		event.load_character_motion_pack(5, "dungeon/chara/c02a_miss.gltf", "info", 13)
		event.load_character_motion_pack(5, "event/e300/e315/e315_monica.gltf", "info", 13)
		event.attach_object_handle_to_character(1, 13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(67.57, 63.38, 1149.74)
		event.set_camera_sequence_look_at(67.85, 63.66, 1179.99)
		event.fade_in_screen(30)
		resume_step = 1
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_motion(1, "だめだめ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_voice_stream_wave(1, 3140170)
		resume_step = 2
		sound.wait_voice_stream_ready(1)
		event.open_message_window_2(0, "残念、失敗よ。\nもう一度挑戦する？")
		message.open(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		resume_step = 3
		message.wait_voice_or_button(0)
		message.close(0)
		event.close_voice_stream(1)
		event.set_message_bubble_screen_slot(0, 0)
		event.reset_mouth_texture_animations()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "はい\nいいえ")
		message.open(0, -1, 5, 0, 0)
		resume_step = 4
		answer = message.choose_option(0, 2, 0, 1)
		event.set_message_bubble_screen_slot(0, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if answer == 0 then
			event.delete_character_extension_packs(13)
			event.set_character_active(1, 0)
			return 1
		else
			event.set_object_sequence_motion(1, "貸しなさい", 2)
			event.queue_object_sequence_next_motion(1, "貸しなさいＬ", 4)
			event.set_mouth_texture_animations(1, "通常口パク")
			event.open_voice_stream_wave(1, 3150010)
			resume_step = 5
			sound.wait_voice_stream_ready(1)
			event.open_message_window_2(0, "もう、ユリスへたくそなんだから。\n私に貸してみて。")
			message.open(0, -1, 8, 0, 0)
			event.play_voice_stream(1)
			resume_step = 6
			message.wait_voice_or_button(0)
			message.close(0)
			event.close_voice_stream(1)
			event.set_message_bubble_screen_slot(0, 0)
			event.reset_mouth_texture_animations()
			resume_step = 7
			object.wait_until_done(1)
			event.fade_out_screen(30)
			resume_step = 8
			wait.for_frame_count(30)
			event.set_character_active(1, 0)
			event.delete_character_extension_packs(13)
			return 0
		end
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 4 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				cutscene.skip_command(1)
			end
			if resume_step <= 2 then
				message.open_skipping(0, -1, 8, 0, 0)
				message.wait_voice_or_button_skipping(0)
			end
			if resume_step <= 3 then
				message.close_skipping(0)
				message.open_skipping(0, -1, 5, 0, 0)
				answer = message.resume_choice(0, 2, 0, 1)
			end
			return 1
		end
		if resume_step <= 8 then
			if resume_step <= 5 then
				message.open_skipping(0, -1, 8, 0, 0)
				message.wait_voice_or_button_skipping(0)
			end
			if resume_step <= 6 then
				message.close_skipping(0)
				cutscene.skip_command(1)
			end
			if resume_step <= 7 then
				wait.skip_frame_count(30)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the cutscene in which the player takes a shot and the second character reacts with praise.
local function play_round_clear_cutscene()
	local active_character: s32 = 0
	local enemy_sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(315, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(57)
		event.play_music(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		active_character = event.get_playable_character() or active_character
		event.change_directory("event/e300/e315/")
		event.load_message_file(0, 5, "e315.txt")
		if active_character == 0 then
			event.load_character_motion_pack(5, "e315_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.change_directory("")
		if active_character == 1 then
		else
			event.delete_character_extension_packs(13)
			event.load_character_motion_pack(5, "event/e300/e312/e312_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/e300/e315/e315_monica.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
		event.set_character_active(0, 12)
		enemy_sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or enemy_sound_bank
		event.create_sword_afterimage(5, 64, 16)
		event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
		event.set_object_handle_position(0, -92.27, 48.63, 1283.9)
		event.set_object_handle_rotation(0, 0.0, 1.34, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(13, "sword_hand", 15)
		event.set_object_handle_position(1, -11.1, 63.73, 1309.96)
		event.set_object_handle_rotation(1, 0.0, 1.8, 0.0)
		event.set_object_handle_motion(1, "かまえゴルフＬ", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.set_sphida_ball_position(0.0, 65.57, 1305.04)
		event.set_sphida_ball_color(0)
		event.set_character_position(8, 0.0, 65.57, 1305.04)
		event.set_character_active(0, 8)
		event.set_character_position(9, 0.0, 65.57, 1305.04)
		event.set_character_active(1, 9)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(65.27, 79.39, 1297.35)
		event.set_camera_sequence_look_at(6.16, 79.67, 1305.48)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3150020)
		event.set_object_sequence_motion(1, "前方確認", 2)
		event.queue_object_sequence_next_motion(1, "ショット", 6)
		object.wait_until_done(1)
		wait.for_frame_count(24)
		simulate_sphida_ball_flight(enemy_sound_bank)
		event.set_camera_sequence_position(-88.57, 74.62, 1267.26)
		event.set_camera_sequence_look_at(20.74, 79.67, 1276.18)
		event.set_object_sequence_position(0, -18.67, 62.68, 1288.34)
		event.set_object_sequence_rotation(0, 0.0, -2.66, 0.0)
		event.reset_object_sequence_dynamic_animation(0, 0.0, -2.66, 0.0)
		event.set_object_sequence_position(1, -1.4, 62.34, 1267.0)
		event.set_object_sequence_rotation(1, 0.0, -2.68, 0.0)
		event.call_command(454, 1, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3150030)
		event.set_object_sequence_motion(0, "すごいや", 6)
		event.queue_object_sequence_next_motion(0, "すごいやL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3150040)
		object.wait_until_done(0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(12)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_character_active(0, 12)
	event.detach_character_from_frame(15)
	event.set_character_active(0, 15)
	event.delete_character(12)
	event.load_message_file(0, -1)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

script.init_map = init_map
script[99] = script.init_map

script.default_event = default_event

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.initialize_event()
	minigame.set_up_sphida_course(1)
	vm.wait(1)
	event.finish_event()
end

--- Starts the Sphida lesson on the first talk, and afterwards offers to quit the practice and awards the prize when the player quits.
function script.talk_to_monica()
	local flag: s32 = 0
	local stick_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(314) or flag
		if flag == 0 then
			stick_count = event.get_owned_item_count(9) or stick_count
			if stick_count >= 1 then
				event.set_character_motion(0, "立ち")
				event.fade_out_screen(30)
				resume_step = 1
				wait.for_frame_count(30)
				resume_step = 2
				play_sphida_lesson_offer()
				event.fade_in_screen(30)
				resume_step = 3
				wait.for_frame_count(30)
				resume_step = 4
				show_sphida_tutorial()
			else
				resume_step = 5
				say_find_a_stick()
			end
		elseif (function()
			resume_step = 6
			return confirm_quit_practice()
		end)() ~= 0 then
			resume_step = 7
			play_monica_shot_cutscene_with_sounds()
			event.add_inventory_item(10)
			event.add_inventory_item(363)
			resume_step = 8
			play_item_reward_cutscene(10)
			resume_step = 9
			enter_next_floor_in_d03()
			return
		end
		resume_step = 10
		vm.wait(10)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_step <= 9 then
			if resume_step == 6 then
				local _ = received[1] :: number
			end
			if resume_step <= 1 then
				resume_step = 2
				play_sphida_lesson_offer()
				return vm.continue_with(function()
					event.fade_in_screen(30)
					resume_step = 3
					wait.for_frame_count(30)
					resume_step = 4
					show_sphida_tutorial()
					resume_step = 10
					vm.wait(10)
					event.finish_event()
					return
				end)
			end
			if resume_step <= 2 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 3 then
				bargas_valley.show_blank_messages()
			end
			if resume_step <= 4 then
				play_timed_effect()
			end
			if resume_step <= 5 then
				local _ = play_timed_effect_sequence()
			end
			if resume_step <= 6 then
				resume_step = 7
				play_monica_shot_cutscene_with_sounds()
				return vm.continue_with(function()
					event.add_inventory_item(10)
					event.add_inventory_item(363)
					resume_step = 8
					play_item_reward_cutscene(10)
					resume_step = 9
					enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 7 then
				resume_step = 8
				play_item_reward_cutscene(10)
				return vm.continue_with(function()
					resume_step = 9
					enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 8 then
				wait_short_delay()
			end
			return 0
		end
		if resume_step <= 10 then
			return 0
		end
		return nil
	end)
end
script[500] = script.talk_to_monica

--- Gives the player the handy stick, disables the branch and shows the obtained message.
function script.pick_up_handy_stick()
	event.initialize_event()
	vm.wait(1)
	event.set_character_motion(0, "立ち")
	event.set_function_point_enabled("", "branch", 0)
	event.add_inventory_item(9)
	inventory.show_obtained_message_for_item_id(9, 1)
	event.set_character_active(0, 15)
	inventory.resolve_overflow(1)
	event.finish_event()
end
script[510] = script.pick_up_handy_stick

--- Asks whether to go on to the next floor and descends when the player agrees.
function script.examine_exit()
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
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	answer = message.ask_choice(0, 10, 8, 256, 208, 2, 1)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	if answer == 0 then
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		enter_next_floor_in_d03()
		return
	end
	event.finish_event()
end
script[520] = script.examine_exit

--- Runs the defeat sequence when the party is defeated.
function script.on_party_defeated()
	dungeon.run_defeat_sequence_silent(0)
end
script[1200] = script.on_party_defeated

--- Takes a Sphida shot, then plays the matching prize cutscene, or lets the player retry after a miss.
function script.sphida_shot()
	local shot_result: s32 = 0
	local round_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		shot_result = play_sphida_shot()
		if shot_result == 1 then
			resume_step = 2
			play_hole_in_cup_cutscene()
			event.add_inventory_item(11)
			event.add_inventory_item(363)
			resume_step = 3
			play_item_reward_cutscene(11)
			resume_step = 4
			enter_next_floor_in_d03()
			return
		end
		if shot_result == 2 then
			round_count = event.get_local_event_counter(0) or round_count
			round_count = vm.i32(round_count + 1)
			event.set_local_event_counter(0, round_count)
			if round_count >= 10 then
				resume_step = 5
				play_monica_shot_cutscene()
				event.add_inventory_item(10)
				event.add_inventory_item(363)
				resume_step = 6
				play_item_reward_cutscene(10)
				resume_step = 7
				enter_next_floor_in_d03()
				return
			elseif (function()
				resume_step = 8
				return ask_retry_after_miss()
			end)() == 0 then
				resume_step = 9
				play_round_clear_cutscene()
				event.add_inventory_item(10)
				event.add_inventory_item(363)
				resume_step = 10
				play_item_reward_cutscene(10)
				resume_step = 11
				enter_next_floor_in_d03()
				return
			else
				event.set_character_active(0)
				event.set_character_position(0, -25.0, 62.7, 1285.3)
				event.set_character_rotation(0, 0.0, 3.14, 0.0)
				event.set_character_motion(0, "立ち", 4)
				event.update_character_motion(0)
				event.reset_character_cloth_and_hair(0)
				event.set_sphida_playing(1)
				event.set_sphida_par(3)
				event.set_sphida_ball_position(0.0, 65.57, 1305.04)
				event.set_sphida_ball_color(0)
				event.set_sphida_last_challenge(0)
				event.set_character_position(8, 0.0, 65.57, 1305.04)
				event.set_character_active(0, 8)
				event.set_character_position(9, 0.0, 65.57, 1305.04)
				event.set_character_active(1, 9)
				event.set_camera_look_at(-25.0, 92.7, 1285.3)
				event.set_camera_position(-25.0, 102.7, 1385.3)
				event.reset_follow_camera(0)
				event.finish_event()
			end
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 1 then
				shot_result = received[1] :: number
			end
			if resume_step <= 1 then
				resume_step = 2
				play_hole_in_cup_cutscene()
				return vm.continue_with(function()
					event.add_inventory_item(11)
					event.add_inventory_item(363)
					resume_step = 3
					play_item_reward_cutscene(11)
					resume_step = 4
					enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 2 then
				resume_step = 3
				play_item_reward_cutscene(11)
				return vm.continue_with(function()
					resume_step = 4
					enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 3 then
				wait_short_delay()
			end
			return 0
		end
		if resume_step <= 7 then
			if resume_step <= 5 then
				resume_step = 6
				play_item_reward_cutscene(10)
				return vm.continue_with(function()
					resume_step = 7
					enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 6 then
				wait_short_delay()
			end
			return 0
		end
		if resume_step <= 11 then
			if resume_step <= 8 then
				resume_step = 9
				play_round_clear_cutscene()
				return vm.continue_with(function()
					event.add_inventory_item(10)
					event.add_inventory_item(363)
					resume_step = 10
					play_item_reward_cutscene(10)
					resume_step = 11
					enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 9 then
				resume_step = 10
				play_item_reward_cutscene(10)
				return vm.continue_with(function()
					resume_step = 11
					enter_next_floor_in_d03()
					return
				end)
			end
			if resume_step <= 10 then
				wait_short_delay()
			end
			return 0
		end
		return nil
	end)
end

--- Offers to move the Sphere to the player and charges a stroke for it.
function script.sphida_near_ball()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local debug_flag: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	answer = message.ask_choice(0, 2004, 8, 256, 208, 2, 0)
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
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 0 then
			bargas_valley.consume_par_stroke(-1)
		end
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- Offers the last chance to move the Sphere to the player and marks the final challenge when accepted.
function script.sphida_near_ball_last()
	local answer: any = 0
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

--- Sets the valley story flags for the first visit and runs the default entry.
function script.enter_valley_first_visit()
	init_map()
	event.set_save_flag(300, 1)
	event.set_save_flag(320, 0)
	default_event()
end
script[13080] = script.enter_valley_first_visit

--- Resets the Sphida progress flags and runs the default entry.
function script.reset_sphida_progress()
	init_map()
	event.set_save_flag(300, 1)
	event.set_save_flag(320, 1)
	event.set_save_flag(312, 0)
	event.set_save_flag(314, 0)
	event.set_save_flag(315, 0)
	event.set_save_flag(316, 0)
	event.set_save_flag(317, 0)
	default_event()
end
script[13120] = script.reset_sphida_progress

--- Loads Monica's model and plays the item reward cutscene.
function script.cutscene_item_reward()
	init_map()
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "chara/c02_base.gltf", "info", 13)
	event.load_equipment_model(4, 1, 4, "info", 13)
	event.load_equipment_model(4, 1, 3, "info", 13)
	event.load_equipment_model(4, 1, 2, "info", 13, 14)
	play_item_reward_cutscene(10)
end
script[13170] = script.cutscene_item_reward

return script
