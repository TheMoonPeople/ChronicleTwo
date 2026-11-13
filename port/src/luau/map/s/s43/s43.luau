--!strict
--- Circus tent battle with the opening show and Battle Wrench scene.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

--- Plays the cutscene in which the hero cannot see over the crowd, runs off and climbs a ladder up the tent.
local function play_part1_chapter8_ladder_climb()
	local sound_bank: s32 = 0
	local elapsed_frames: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(1213)
		event.load_music(103)
		event.play_music(0)
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p1/op1ch8.txt")
		sound_bank = event.load_sound_effect_file_2(1213) or sound_bank
		event.load_character_motion_pack(5, "event/opening/p1/p1_mints4.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, -540.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.load_character(5, "event/opening/p1/p1_people.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, 0.0, 0.0, -405.0)
		event.load_character(5, "event/opening/p1/p1_onna1.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, 18.39, 0.0, -421.29)
		event.load_character(5, "event/opening/p1/p1_otoko1.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_position(10, 27.92, 0.0, -433.74)
		event.load_character(5, "event/opening/p1/p1_otoko2.gltf", "info", 11)
		event.set_character_active(11)
		event.set_character_position(11, -25.29, 0.0, -426.67)
		event.load_character(5, "event/opening/p1/p2_macho.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(5, 12)
		event.set_object_handle_frame_visible(5, "sphere1", 0)
		event.set_object_handle_frame_visible(5, "sphere1_1", 0)
		event.set_object_handle_frame_visible(5, "sphere1_2", 0)
		event.set_object_handle_frame_visible(5, "sphere1_3", 0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 0.0, 11.23, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 3.14, 0.0)
		event.set_object_handle_shadow_enabled(5, 0)
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 13)
		event.set_character_active(13)
		event.set_character_motion(13, "回転1", 4)
		event.attach_character_to_frame(12, "sphere1", 13)
		event.copy_character(5, 13, 14)
		event.set_character_active(14)
		event.set_character_motion(14, "回転1", 4)
		event.attach_character_to_frame(12, "sphere1_1", 14)
		event.copy_character(5, 13, 15)
		event.set_character_active(15)
		event.set_character_motion(15, "回転1", 4)
		event.attach_character_to_frame(12, "sphere1_2", 15)
		event.copy_character(5, 13, 16)
		event.set_character_active(16)
		event.set_character_motion(16, "回転1", 4)
		event.attach_character_to_frame(12, "sphere1_3", 16)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 0.0, 0.0, -440.0, 120)
		event.set_object_sequence_motion(5, "投げ4回", 4)
		event.attach_object_handle_to_map_part_2(31, "p01_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p02_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-1")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-2")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-3")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-4")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-5")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-6")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-7")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p05_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p06_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p07_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p08_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p11_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p13_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p14_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p15_i03h02a")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-1")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-2")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-3")
		event.set_object_handle_visible(31, 0)
		event.set_map_lighting(1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 18.72, -581.27)
		event.set_camera_sequence_look_at(0.0, -0.38, -526.54)
		event.move_camera_sequence(0.0, 21.63, -581.27, 0.0, 38.43, -476.49, 120)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		resume_step = 1
		camera.wait_until_done()
		resume_step = 2
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		event.open_voice_stream_wave(1, 10705)
		resume_step = 3
		elapsed_frames = sound.wait_voice_stream_ready_counting(1)
		resume_step = 4
		wait.for_frame_count(vm.i32(30 - elapsed_frames))
		event.set_camera_sequence_position(-17.16, 17.61, -542.92)
		event.set_camera_sequence_look_at(2.33, 20.36, -409.98)
		event.play_voice_stream(1)
		resume_step = 5
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "見えないよ", 2)
		event.queue_object_sequence_next_motion(0, "見えないよL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_bank, 4)
		event.delay_object_sequence_sound_track(0, 110)
		event.play_object_sequence_sound(0, sound_bank, 5)
		resume_step = 6
		wait.for_frame_count(200)
		event.close_voice_stream(1)
		event.play_object_sequence_sound(0, sound_bank, 6)
		resume_step = 7
		message.show_voiced_for_stopping(10710, 50)
		resume_step = 8
		message.show_voiced_for_stopping(10715, 80)
		resume_step = 9
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "見えないよ戻り", 2)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		resume_step = 10
		object.wait_until_done(0)
		resume_step = 11
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		resume_step = 12
		object.wait_until_done(0)
		resume_step = 13
		wait.for_frame_count(10)
		event.open_voice_stream_wave(1, 10716)
		resume_step = 14
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.set_camera_sequence_position(-54.54, 71.63, -344.23)
		event.set_camera_sequence_look_at(5.47, 6.56, -479.98)
		event.set_object_sequence_motion(0, "走り")
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 80)
		event.add_object_sequence_path_point(0, 0.0, 0.0, -440.0)
		event.add_object_sequence_path_point(0, 25.41, 0.0, -505.85)
		event.add_object_sequence_path_point(0, 59.73, 0.0, -569.39)
		event.add_object_sequence_path_point(0, 107.09, 0.0, -622.8)
		event.add_object_sequence_path_point(0, 163.05, 0.0, -656.61)
		event.add_object_sequence_path_point(0, 223.93, 0.0, -656.14)
		event.start_object_sequence_path(0)
		resume_step = 15
		object.wait_until_done(0)
		event.set_map_lighting(0)
		resume_step = 16
		vm.wait(16)
		event.set_camera_sequence_position(385.44, 20.74, -469.02)
		event.set_camera_sequence_look_at(478.52, 20.25, -405.79)
		event.close_voice_stream(1)
		event.set_object_sequence_position(0, 431.02, 0.0, -509.53)
		event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
		event.move_object_sequence(0, 457.0, 0.0, -428.0, 40)
		event.delay_object_sequence_rotation_track(0, 35)
		event.rotate_object_sequence(0, 0.0, 0.72, 0.0, 5)
		resume_step = 17
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		resume_step = 18
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "はしご登り", 2)
		event.open_voice_stream_wave(1, 10718)
		resume_step = 19
		wait.for_frame_count(40)
		resume_step = 20
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.set_object_handle_footstep_sound(0, 9)
		event.move_camera_sequence(385.44, 20.74, -469.02, 478.52, 129.61, -405.79, 180)
		event.wait_object_sequence_motion_end(0)
		resume_step = 21
		object.wait_until_done(0)
		resume_step = 22
		camera.wait_until_done()
		event.set_camera_sequence_position(499.02, 167.79, -314.86)
		event.set_camera_sequence_look_at(424.99, 140.47, -326.88)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.close_voice_stream(1)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_object_sequence_position(0, 441.37, 133.45, -339.86)
		event.set_object_sequence_rotation(0, 0.0, 0.41, 0.0)
		event.move_object_sequence(0, 459.04, 133.45, -308.23, 40)
		event.set_object_handle_shadow_enabled(5, 1)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_sequence_motion(0, "右向き歩き", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "右を向く", 6)
		event.queue_object_sequence_next_motion(0, "右を向くL", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_sound_track(0, 40)
		event.play_object_sequence_sound(0, sound_bank, 9)
		event.move_camera_sequence_eased(499.02, 167.79, -314.86, 407.46, 142.42, -261.94, 60, 2, 0.6)
		resume_step = 23
		message.show_voiced_for_stopping(10720, 60)
		resume_step = 24
		object.wait_until_done(0)
		resume_step = 25
		camera.wait_until_done()
		resume_step = 26
		wait.for_frame_count(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(60)
		resume_step = 27
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if resume_step == 3 then
			elapsed_frames = received[1] :: number
		end
		if resume_step <= 1 then
			cutscene.skip_command(0)
		end
		if resume_step <= 2 then
			elapsed_frames = sound.wait_voice_stream_ready_counting_skipping(1)
		end
		if resume_step <= 3 then
			wait.skip_frame_count(vm.i32(30 - elapsed_frames))
		end
		if resume_step <= 4 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 5 then
			wait.skip_frame_count(200)
		end
		if resume_step <= 6 then
			message.show_voiced_for_stopping_skipping(10710, 50)
		end
		if resume_step <= 7 then
			message.show_voiced_for_stopping_skipping(10715, 80)
		end
		if resume_step <= 8 then
			cutscene.skip_command(0)
		end
		if resume_step <= 9 then
			cutscene.skip_command(0)
		end
		if resume_step <= 10 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 11 then
			cutscene.skip_command(0)
		end
		if resume_step <= 12 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 13 then
			cutscene.skip_command(1)
		end
		if resume_step <= 14 then
			cutscene.skip_command(0)
		end
		if resume_step <= 16 then
			cutscene.skip_command(0)
		end
		if resume_step <= 17 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 18 then
			wait.skip_frame_count(40)
		end
		if resume_step <= 19 then
			cutscene.skip_command(1)
		end
		if resume_step <= 20 then
			cutscene.skip_command(0)
		end
		if resume_step <= 21 then
			wait.background_load_skipping()
		end
		if resume_step <= 22 then
			message.show_voiced_for_stopping_skipping(10720, 60)
		end
		if resume_step <= 23 then
			cutscene.skip_command(0)
		end
		if resume_step <= 24 then
			wait.background_load_skipping()
		end
		if resume_step <= 25 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 26 then
			wait.background_load_skipping()
		end
		return true
	end)
	resume_step = 28
	vm.entry(28)
	event.cancel_drama_scene_skip()
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
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
	event.attach_object_handle_to_map_part_2(31, "p01_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p02_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-1")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-2")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-3")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-4")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-5")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-6")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p04_i03h02a-7")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p05_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p06_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p07_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p08_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p11_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p13_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p14_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p15_i03h02a")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-1")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-2")
	event.set_object_handle_visible(31, 1)
	event.attach_object_handle_to_map_part_2(31, "p10_i03h02a-3")
	event.set_object_handle_visible(31, 1)
	event.set_map_lighting(0)
	event.set_character_active(0)
end

--- Plays the cutscene in which the clown troupe, an elephant and Myrene perform in the circus tent, ending with the trapeze swing act.
local function play_opening_clown_show()
	local sound_bank: s32 = 0
	local index: s32 = 0
	local sink_step: f32 = 0
	local position_y: f32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.set_character_active(0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_map_sounds(1214)
		sound_bank = event.load_sound_effect_file_2(1214) or sound_bank
		event.load_character(5, "event/opening/p2/p2_erephant.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_sound_bank(5, sound_bank)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 279.22, 0.0, 581.89)
		event.set_object_sequence_rotation(5, 0.0, -1.68, 0.0)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.load_character(5, "event/opening/p2/p2_ball.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(6, 14)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, 0.0, -100.0, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(6, "玉持ち上げ", 5)
		event.load_character(5, "event/opening/p2/p2_myrene.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(7, 15)
		event.set_object_handle_sound_bank(7, sound_bank)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 15.06, -111.23, -91.33)
		event.set_object_sequence_rotation(7, 0.0, -1.8, 0.0)
		event.set_object_sequence_texture_animation(7, 0)
		event.load_character(5, "event/opening/p2/p2_erephant_bup.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(8, 16)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_object_sequence_position(8, 6.14, 0.0, 4.14)
		event.set_object_sequence_rotation(8, 0.0, -2.88, 0.0)
		event.load_character(5, "event/opening/p2/p2_kiran.gltf", "info", 17)
		event.set_character_active(0, 17)
		event.attach_object_handle_to_character(9, 17)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.set_object_sequence_position(9, -5.37, 38.44, -29.5)
		event.set_object_sequence_rotation(9, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(9, "キラーン", 5)
		event.load_character(5, "event/opening/p1/p1_people.gltf", "info", 18)
		event.set_character_active(18)
		event.set_character_position(18, 0.0, 0.0, -405.0)
		event.assign_memory_stack(6)
		event.clear_memory_stack(6)
		event.load_character(6, "event/opening/p2/p2_macho.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.set_object_handle_sound_bank(0, sound_bank)
		event.set_object_handle_frame_visible(0, "sphere1", 0)
		event.set_object_handle_frame_visible(0, "sphere1_1", 0)
		event.set_object_handle_frame_visible(0, "sphere1_2", 0)
		event.set_object_handle_frame_visible(0, "sphere1_3", 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 11.23, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.set_object_handle_sound_bank(1, sound_bank)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.copy_character(6, 9, 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.copy_character(6, 9, 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.copy_character(6, 9, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.set_object_handle_sound_bank(4, sound_bank)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "投げ4回", 4)
		event.set_object_sequence_motion(1, "回転1", 4)
		event.attach_character_to_frame(8, "sphere1", 9)
		event.set_object_sequence_motion(2, "回転1", 4)
		event.attach_character_to_frame(8, "sphere1_1", 10)
		event.set_object_sequence_motion(3, "回転1", 4)
		event.attach_character_to_frame(8, "sphere1_2", 11)
		event.set_object_sequence_motion(4, "回転1", 4)
		event.attach_character_to_frame(8, "sphere1_3", 12)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 125.0, -120.0)
		event.set_camera_sequence_look_at(0.0, 125.0, 0.0)
		event.move_camera_sequence(0.0, 30.0, -120.0, 0.0, 30.0, 0.0, 220)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		resume_step = 2
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 30.0, -180.0)
		event.set_camera_sequence_look_at(0.0, 30.0, 0.0)
		event.set_object_sequence_motion(0, "投げ４回からTポーズ", 6)
		event.queue_object_sequence_next_motion(0, "Tポーズ", 4)
		resume_step = 3
		wait.for_frame_count(26)
		event.detach_character_from_frame(9)
		event.detach_character_from_frame(10)
		event.detach_character_from_frame(11)
		event.detach_character_from_frame(12)
		event.set_object_sequence_position(1, -60.0, 11.23, -30.0)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "着地", 5, 0.5)
		event.set_object_handle_shadow_enabled(1, 0)
		event.set_object_sequence_position(2, -20.0, 11.23, -30.0)
		event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(2, "着地", 5, 0.5)
		event.set_object_handle_shadow_enabled(2, 0)
		event.set_object_sequence_position(3, 20.0, 11.23, -30.0)
		event.set_object_sequence_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(3, "着地", 5, 0.5)
		event.set_object_handle_shadow_enabled(3, 0)
		event.set_object_sequence_position(4, 60.0, 11.23, -30.0)
		event.set_object_sequence_rotation(4, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(4, "着地", 5, 0.5)
		event.set_object_handle_shadow_enabled(4, 0)
		event.play_object_sequence_sound(1, sound_bank, 5)
		event.set_object_sequence_motion(1, "着地", 6)
		event.queue_object_sequence_next_motion(1, "着地ループ", 4)
		resume_step = 4
		wait.for_frame_count(10)
		event.set_object_sequence_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "着地ループ", 4)
		resume_step = 5
		wait.for_frame_count(10)
		event.set_object_sequence_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "着地ループ", 4)
		resume_step = 6
		wait.for_frame_count(10)
		event.set_object_sequence_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "着地ループ", 4)
		event.set_object_handle_shadow_enabled(1, 1)
		resume_step = 7
		wait.for_frame_count(12)
		event.set_object_handle_shadow_enabled(2, 1)
		resume_step = 8
		wait.for_frame_count(12)
		event.set_object_handle_shadow_enabled(3, 1)
		resume_step = 9
		wait.for_frame_count(12)
		event.set_object_handle_shadow_enabled(4, 1)
		event.set_object_sequence_motion(0, "Tポーズから決め", 6)
		event.queue_object_sequence_next_motion(0, "決めループ", 6)
		event.wait_object_sequence_motion_end(0)
		resume_step = 10
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "決めからおじぎ", 6)
		event.queue_object_sequence_next_motion(0, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(0, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "着地ループからおじぎ", 6)
		event.queue_object_sequence_next_motion(1, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(1, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "着地ループからおじぎ", 6)
		event.queue_object_sequence_next_motion(2, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(2, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "着地ループからおじぎ", 6)
		event.queue_object_sequence_next_motion(3, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(3, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_object_sequence_motion(4, "着地ループからおじぎ", 6)
		event.queue_object_sequence_next_motion(4, "おじぎループ", 6)
		event.queue_object_sequence_next_motion(4, "おじぎから立ち", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.set_object_sequence_motion(5, "歩き", 4)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 280)
		event.add_object_sequence_path_point(5, 279.22, 0.0, 581.89)
		event.add_object_sequence_path_point(5, 178.82, 0.0, 562.97)
		event.add_object_sequence_path_point(5, 117.49, 0.0, 543.89)
		event.add_object_sequence_path_point(5, 66.41, 0.0, 514.73)
		event.start_object_sequence_path(5)
		event.delay_object_sequence_sound_track(5, 120)
		event.play_object_sequence_sound(5, sound_bank, 6)
		event.delay_object_sequence_sound_track(5, 120)
		event.play_object_sequence_sound(5, sound_bank, 6)
		resume_step = 11
		object.wait_until_done(0)
		resume_step = 12
		object.wait_until_done(1)
		resume_step = 13
		object.wait_until_done(2)
		resume_step = 14
		object.wait_until_done(3)
		resume_step = 15
		object.wait_until_done(4)
		event.set_object_handle_sound_bank(1, -1)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.set_object_handle_sound_bank(4, -1)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -43.35, 11.23, -155.32, 120)
		event.rotate_object_sequence(0, 0.0, -2.9, 0.0, 10)
		event.set_object_sequence_motion(2, "走り")
		event.move_object_sequence(2, -90.31, 11.23, -38.89, 30)
		event.rotate_object_sequence(2, 0.0, -2.18, 0.0, 10)
		resume_step = 16
		wait.for_frame_count(3)
		event.set_object_sequence_motion(3, "走り")
		event.move_object_sequence(3, 90.31, 11.23, -38.89, 30)
		event.rotate_object_sequence(3, 0.0, 2.18, 0.0, 10)
		resume_step = 17
		wait.for_frame_count(2)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -90.31, 11.23, -38.89, 15)
		event.rotate_object_sequence(1, 0.0, -2.18, 0.0, 10)
		event.set_object_sequence_motion(4, "走り")
		event.move_object_sequence(4, 90.31, 11.23, -38.89, 15)
		event.rotate_object_sequence(4, 0.0, 2.18, 0.0, 10)
		resume_step = 18
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 19
		object.wait_until_done(4)
		event.set_object_sequence_motion(4, "立ち")
		resume_step = 20
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "立ち")
		resume_step = 21
		object.wait_until_done(3)
		event.set_object_sequence_motion(3, "立ち")
		resume_step = 22
		object.wait_until_done(5)
		event.set_camera_sequence_position(-107.78, 17.46, -52.75)
		event.set_camera_sequence_look_at(-0.22, 62.14, -20.34)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_object_sequence_position(5, 0.0, 11.23, 80.0)
		event.set_object_sequence_rotation(5, 0.0, 3.14, 0.0)
		event.move_object_sequence(5, 0.0, 11.23, -30.0, 160)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, sound_bank, 6)
		event.delay_object_sequence_sound_track(5, 90)
		event.play_object_sequence_sound(5, sound_bank, 6)
		resume_step = 23
		object.wait_until_done(5)
		event.set_object_sequence_motion(5, "パオーン", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.delay_object_sequence_sound_track(5, 20)
		event.play_object_sequence_sound(5, sound_bank, 7)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, sound_bank, 8)
		resume_step = 24
		wait.for_frame_count(62)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		resume_step = 25
		object.wait_until_done(5)
		resume_step = 26
		camera.wait_until_done()
		event.start_background_file_loads_2("event/opening/p2/p2_bura_pie.gltf", "event/opening/p2/p2_buranko.gltf")
		event.set_object_sequence_motion(7, "歩き", 4)
		event.set_object_sequence_position(7, 15.06, 11.23, -91.33)
		event.set_object_sequence_rotation(7, 0.0, -0.96, 0.0)
		event.delay_object_sequence_rotation_track(7, 80)
		event.rotate_object_sequence(7, 0.0, -1.8, 0.0, 10)
		event.move_object_sequence(7, -68.07, 11.23, -40.78, 90)
		resume_step = 27
		object.wait_until_done(7)
		event.set_object_sequence_motion(7, "登場ポーズ", 2)
		event.wait_object_sequence_motion_end(7)
		event.move_camera_sequence(-131.01, 23.7, -59.75, -0.22, 39.36, -20.34, 143)
		resume_step = 28
		camera.wait_until_done()
		resume_step = 29
		object.wait_until_done(7)
		event.set_object_sequence_motion(7, "歩き")
		event.move_object_sequence(7, -31.47, 11.23, -3.92, 60)
		event.rotate_object_sequence(7, 0.0, 0.72, 0.0, 10)
		resume_step = 30
		object.wait_until_done(7)
		event.set_object_sequence_motion(5, "ごにょごごにょ", 2)
		event.queue_object_sequence_next_motion(5, "ごにょごにょループ", 4)
		event.rotate_object_sequence(7, 0.0, 1.32, 0.0, 20)
		event.set_object_sequence_motion(7, "ごにょごにょ", 2)
		event.queue_object_sequence_next_motion(7, "ごにょごにょL", 6)
		event.wait_object_sequence_motion_end(7)
		event.delay_object_sequence_sound_track(7, 10)
		event.play_object_sequence_sound(7, sound_bank, 9)
		resume_step = 31
		object.wait_until_done(7)
		event.set_camera_sequence_position(-40.25, 30.96, -47.72)
		event.set_camera_sequence_look_at(-5.49, 44.23, -27.58)
		event.set_character_active(0, 13)
		event.set_character_active(1, 16)
		event.play_object_sequence_sound(5, sound_bank, 10)
		resume_step = 32
		wait.for_frame_count(60)
		event.set_camera_sequence_position(0.0, 95.44, -190.42)
		event.set_camera_sequence_look_at(0.0, 62.65, 0.0)
		event.set_character_active(1, 13)
		event.set_character_active(0, 16)
		event.set_object_sequence_motion(5, "玉持ち上げ", 6)
		event.queue_object_sequence_next_motion(5, "玉持ち上げループ", 4)
		event.delay_object_sequence_sound_track(5, 4)
		event.play_object_sequence_sound(5, sound_bank, 11)
		event.set_object_sequence_position(6, 0.0, 11.23, -30.0)
		event.set_object_sequence_motion(6, "玉持ち上げ", 6)
		event.queue_object_sequence_next_motion(6, "玉持ち上げループ", 4)
		event.set_object_sequence_rotation(7, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(7, "歩き", 4)
		event.rotate_object_sequence(7, 0.0, -1.57, 0.0, 20)
		event.move_object_sequence(7, -132.5, 11.23, 0.93, 90)
		resume_step = 33
		object.wait_until_done(7)
		event.set_character_active(0, 15)
		event.set_camera_sequence_position(0.4, 14.44, -179.22)
		event.set_camera_sequence_look_at(0.0, 67.37, 0.0)
		event.set_object_sequence_motion(5, "バイシクルシュート", 6)
		event.set_object_sequence_motion(6, "バイシクルシュート", 6)
		event.delay_object_sequence_sound_track(5, 62)
		event.play_object_sequence_sound(5, sound_bank, 12)
		resume_step = 34
		wait.for_frame_count(70)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		resume_step = 35
		wait.for_frame_count(29)
		event.set_object_sequence_motion(5, "バイシクルシュート", 1)
		event.set_object_sequence_motion(6, "バイシクルシュート", 1)
		event.set_camera_sequence_position(-10.4, 37.62, -49.49)
		event.set_camera_sequence_look_at(-1.23, 39.37, -21.13)
		event.set_character_active(0, 13)
		event.set_character_active(1, 16)
		event.set_object_sequence_position(8, -2.78, -2.07, 15.89)
		event.set_object_sequence_rotation(8, 0.0, 3.02, 0.0)
		index = 0
		sink_step = vm.f32(0.8)
		position_y = vm.f32(-2.07)
		while index < 10 do
			sink_step = vm.f32(sink_step * vm.f32(0.8))
			position_y = vm.f32(position_y - sink_step)
			event.set_object_sequence_position(8, -2.78, position_y, 15.89)
			index = index + 1
			print(vm.float(position_y), "\n")
			resume_step = 36
			vm.wait(36)
		end
		event.set_character_active(17)
		event.set_object_sequence_motion(9, "キラーン", 6)
		event.play_object_sequence_sound(5, sound_bank, 13)
		resume_step = 37
		wait.for_frame_count(10)
		event.set_character_active(0, 17)
		resume_step = 38
		wait.for_frame_count(10)
		event.set_camera_sequence_position(-168.96, 18.9, -103.54)
		event.set_camera_sequence_look_at(-5.14, 75.4, 8.39)
		event.set_character_active(1, 13)
		event.set_character_active(0, 16)
		event.set_object_sequence_motion(5, "バイシクルシュート", 2)
		event.set_object_sequence_motion(6, "バイシクルシュート", 2)
		event.play_object_sequence_sound(5, sound_bank, 14)
		resume_step = 39
		wait.for_frame_count(9)
		event.set_object_sequence_motion_step(5, 0.01)
		event.set_object_sequence_motion_step(6, 0.01)
		event.set_camera_sequence_position(-197.04, 171.4, 0.74)
		event.set_camera_sequence_look_at(0.0, 121.4, 0.0)
		event.move_camera_sequence_angle_height_distance(1.57, 0.0, 197.04, 100)
		event.move_camera_sequence_angle_height_distance(3.14, -25.0, 197.04, 50)
		event.move_camera_sequence_angle_height_distance(-1.57, -50.0, 197.04, 50)
		resume_step = 40
		camera.wait_until_done()
		event.set_object_sequence_motion_step(5, 0.6)
		event.set_object_sequence_motion_step(6, 0.6)
		event.wait_object_sequence_motion_end(5)
		event.play_object_sequence_sound(5, sound_bank, 15)
		resume_step = 41
		wait.for_frame_count(5)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		resume_step = 42
		camera.wait_until_done()
		resume_step = 43
		object.wait_until_done(5)
		event.set_camera_sequence_position(-120.33, 279.87, -18.7)
		event.set_camera_sequence_look_at(138.46, 217.78, 141.95)
		event.set_object_sequence_position(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(6, "右のピエロ", 6)
		event.delay_object_sequence_sound_track(6, 10)
		event.play_object_sequence_sound(6, sound_bank, 16)
		resume_step = 44
		wait.for_frame_count(20)
		event.set_camera_sequence_position(87.54, 42.85, 80.82)
		event.set_camera_sequence_look_at(-204.62, 211.5, 188.69)
		event.set_object_sequence_motion(6, "左のピエロ", 6)
		event.delay_object_sequence_sound_track(6, 10)
		event.play_object_sequence_sound(6, sound_bank, 16)
		resume_step = 45
		wait.for_frame_count(20)
		event.set_camera_sequence_position(37.29, 24.91, -191.53)
		event.set_camera_sequence_look_at(5.05, 69.55, -9.71)
		event.set_object_sequence_motion(5, "キャッチ＆決め入り", 6)
		event.queue_object_sequence_next_motion(5, "決めループ", 4)
		event.delay_object_sequence_sound_track(5, 24)
		event.play_object_sequence_sound(5, sound_bank, 17)
		event.set_object_sequence_position(6, 0.0, 11.23, -30.0)
		event.set_object_sequence_rotation(6, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(6, "キャッチ＆決め入り", 6)
		event.queue_object_sequence_next_motion(6, "決めループ", 4)
		resume_step = 46
		wait.for_frame_count(50)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		resume_step = 47
		object.wait_until_done(5)
		event.play_object_sequence_sound(5, sound_bank, 18)
		event.set_camera_sequence_position(-55.0, 150.0, 230.0)
		event.set_camera_sequence_look_at(0.0, 50.0, -30.0)
		event.move_camera_sequence(55.0, 150.0, 230.0, 0.0, 50.0, -30.0, 120)
		resume_step = 48
		camera.wait_until_done()
		event.set_camera_sequence_position(37.29, 24.91, -191.53)
		event.set_camera_sequence_look_at(5.05, 69.55, -9.71)
		event.set_object_sequence_motion(6, "キャッチ＆決め終わり", 6)
		event.set_object_sequence_motion(5, "キャッチ＆決め終わり", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		resume_step = 49
		wait.for_frame_count(30)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
		resume_step = 50
		camera.wait_until_done()
		resume_step = 51
		object.wait_until_done(5)
		resume_step = 52
		wait.background_load()
		event.set_character_active(0, 14)
		event.play_sound_effect(sound_bank, 19)
		event.move_camera_sequence_eased(245.05, 229.37, -124.72, 308.65, 198.37, -0.0, 90, 0, 0.3)
		event.clear_object_sequence(0)
		event.clear_object_sequence(1)
		event.clear_object_sequence(2)
		event.clear_object_sequence(3)
		event.clear_object_sequence(4)
		event.delete_character(8)
		event.delete_character(9)
		event.delete_character(10)
		event.delete_character(11)
		event.delete_character(12)
		event.clear_memory_stack(6)
		event.load_character(6, "event/opening/p2/p2_bura_pie.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "待機", 4)
		event.load_character(6, "event/opening/p2/p2_buranko.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "待機", 4)
		resume_step = 53
		camera.wait_until_done()
		event.set_character_active(0, 13)
		event.set_camera_sequence_follow_object(0, 0.0, 14.0, 0.0, -2.67, 31.0, 140.0, "skin")
		resume_step = 54
		wait.for_frame_count(60)
		event.stop_sound_effect(sound_bank, 19)
		event.play_sound_effect(sound_bank, 20)
		event.set_object_sequence_motion(0, "ピエロブランコ", 6)
		event.set_object_sequence_motion(1, "ピエロブランコ", 6)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, sound_bank, 21)
		event.delay_object_sequence_sound_track(0, 50)
		event.play_object_sequence_sound(0, sound_bank, 21)
		resume_step = 55
		wait.for_frame_count(60)
		resume_step = 56
		wait.for_frame_count(40)
		event.move_camera_sequence_angle_height_distance(-3.14, 0.0, 140.0, 60)
		resume_step = 57
		wait.for_frame_count(90)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02")
		event.set_object_handle_visible(31, 0)
		event.release_camera_sequence_follow_object()
		event.play_object_sequence_sound(0, sound_bank, 25)
		event.move_camera_sequence(145.04, 229.37, -319.27, -156.54, 156.11, -23.11, 60)
		resume_step = 58
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 237.95, -275.71)
		event.set_camera_sequence_look_at(0.0, 212.96, -32.39)
		event.set_object_sequence_position(0, 170.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 170.0, 0.0, 0.0)
		resume_step = 59
		wait.for_frame_count(20)
		event.set_character_active(1, 15)
		event.set_object_sequence_position(7, 0.0, 11.23, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(7, "ムーンサルト", 6)
		event.queue_object_sequence_next_motion(7, "ムーンサルトL", 4)
		event.delay_object_sequence_sound_track(7, 20)
		event.play_object_sequence_sound(7, sound_bank, 26)
		event.delay_object_sequence_sound_track(7, 45)
		event.play_object_sequence_sound(7, sound_bank, 27)
		resume_step = 60
		wait.for_frame_count(50)
		event.set_object_handle_visible(31, 1)
		resume_step = 61
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 53.51, -115.19)
		event.set_camera_sequence_look_at(0.0, 35.43, 0.41)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		resume_step = 62
		object.wait_until_done(7)
		event.set_camera_sequence_position(-27.17, 57.91, -13.37)
		event.set_camera_sequence_look_at(1.6, 40.06, 1.5)
		event.set_object_sequence_motion(7, "ウィンク", 6)
		event.queue_object_sequence_next_motion(7, "ウィンクL", 4)
		event.set_object_sequence_texture_animation(7, 0)
		event.set_object_sequence_texture_animation(7, 1, "ウインク")
		event.set_object_sequence_texture_animation(7, 1, "決めの口")
		event.play_object_sequence_sound(7, sound_bank, 28)
		event.delay_object_sequence_sound_track(7, 20)
		event.play_object_sequence_sound(7, sound_bank, 29)
		resume_step = 63
		object.wait_until_done(7)
		resume_step = 64
		wait.for_frame_count(30)
		event.move_camera_sequence_eased(-391.9, 285.91, -201.78, 1.6, 40.06, 1.5, 90, 0, 0.2)
		resume_step = 65
		camera.wait_until_done()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		resume_step = 66
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			wait.background_load_skipping()
		end
		if resume_step <= 2 then
			wait.skip_frame_count(26)
		end
		if resume_step <= 3 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 4 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 5 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 6 then
			wait.skip_frame_count(12)
		end
		if resume_step <= 7 then
			wait.skip_frame_count(12)
		end
		if resume_step <= 8 then
			wait.skip_frame_count(12)
		end
		if resume_step <= 9 then
			cutscene.skip_command(0)
		end
		if resume_step <= 10 then
			cutscene.skip_command(0)
		end
		if resume_step <= 11 then
			cutscene.skip_command(1)
		end
		if resume_step <= 12 then
			cutscene.skip_command(2)
		end
		if resume_step <= 13 then
			cutscene.skip_command(3)
		end
		if resume_step <= 14 then
			cutscene.skip_command(4)
		end
		if resume_step <= 15 then
			wait.skip_frame_count(3)
		end
		if resume_step <= 16 then
			wait.skip_frame_count(2)
		end
		if resume_step <= 17 then
			cutscene.skip_command(1)
		end
		if resume_step <= 18 then
			cutscene.skip_command(4)
		end
		if resume_step <= 19 then
			cutscene.skip_command(2)
		end
		if resume_step <= 20 then
			cutscene.skip_command(3)
		end
		if resume_step <= 21 then
			cutscene.skip_command(5)
		end
		if resume_step <= 22 then
			cutscene.skip_command(5)
		end
		if resume_step <= 23 then
			wait.skip_frame_count(62)
		end
		if resume_step <= 24 then
			cutscene.skip_command(5)
		end
		if resume_step <= 25 then
			wait.background_load_skipping()
		end
		if resume_step <= 26 then
			cutscene.skip_command(7)
		end
		if resume_step <= 27 then
			wait.background_load_skipping()
		end
		if resume_step <= 28 then
			cutscene.skip_command(7)
		end
		if resume_step <= 29 then
			cutscene.skip_command(7)
		end
		if resume_step <= 30 then
			cutscene.skip_command(7)
		end
		if resume_step <= 31 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 32 then
			cutscene.skip_command(7)
		end
		if resume_step <= 33 then
			wait.skip_frame_count(70)
		end
		if resume_step <= 34 then
			wait.skip_frame_count(29)
		end
		if resume_step <= 35 then
			index = 0
			sink_step = vm.f32(0.8)
			position_y = vm.f32(-2.07)
			sink_step = vm.f32(sink_step * vm.f32(0.8))
			position_y = vm.f32(position_y - sink_step)
			local _ = index < 10
			index = index + 1
			print(vm.float(position_y), "\n")
		end
		if resume_step <= 36 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 37 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 38 then
			wait.skip_frame_count(9)
		end
		if resume_step <= 39 then
			wait.background_load_skipping()
		end
		if resume_step <= 40 then
			wait.skip_frame_count(5)
		end
		if resume_step <= 41 then
			wait.background_load_skipping()
		end
		if resume_step <= 42 then
			cutscene.skip_command(5)
		end
		if resume_step <= 43 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 44 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 45 then
			wait.skip_frame_count(50)
		end
		if resume_step <= 46 then
			cutscene.skip_command(5)
		end
		if resume_step <= 47 then
			wait.background_load_skipping()
		end
		if resume_step <= 48 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 49 then
			wait.background_load_skipping()
		end
		if resume_step <= 50 then
			cutscene.skip_command(5)
		end
		if resume_step <= 51 then
			wait.background_load_skipping()
		end
		if resume_step <= 52 then
			wait.background_load_skipping()
		end
		if resume_step <= 53 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 54 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 55 then
			wait.skip_frame_count(40)
		end
		if resume_step <= 56 then
			wait.skip_frame_count(90)
		end
		if resume_step <= 57 then
			wait.background_load_skipping()
		end
		if resume_step <= 58 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 59 then
			wait.skip_frame_count(50)
		end
		if resume_step <= 60 then
			wait.background_load_skipping()
		end
		if resume_step <= 61 then
			cutscene.skip_command(7)
		end
		if resume_step <= 62 then
			cutscene.skip_command(7)
		end
		if resume_step <= 63 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 64 then
			wait.background_load_skipping()
		end
		if resume_step <= 65 then
			wait.background_load_skipping()
		end
		return true
	end)
	resume_step = 67
	vm.entry(67)
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
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
	event.stop_sound_effect(sound_bank, 19)
	event.stop_sound_effect(sound_bank, 28)
	event.stop_sound_effect(sound_bank, 29)
end

--- Plays the cutscene where the hero drops onto the stage, then sets up the clown battle and starts the dungeon fight.
local function play_opening_fall_and_start_battle()
	local battle_sound_bank: s32 = 0
	local sound_bank: s32 = 0
	local wait_offset: s32 = 0
	local battle_sound_id: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.set_dungeon_pause_flags(1, 1)
		event.show_dungeon_status_bar(0, 0.033333335)
		resume_step = 1
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		resume_step = 2
		wait.for_frame_count(30)
		event.clear_event_battle_monsters(-1)
		event.set_dungeon_pause_flags(16384, 0)
		event.initialize_event()
		event.show_dungeon_status_bar(0, 1.0)
		event.add_hp_by_rate(1.0, 0)
		event.add_battle_weapon_durability(0, 999)
		sound_bank = event.load_sound_effect_file_2(1216) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p4/op4ch1.txt")
		event.load_character_motion_pack(5, "event/opening/p4/p4_mints3.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 0)
		event.attach_object_handle_to_character(21, 2)
		event.set_object_handle_visible(21, 0)
		event.load_character(5, "event/opening/p4/light.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_frame_visible(2, "kusari", 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character_frame(7, 10, "light_rot")
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.rotate_object_sequence(7, 0.01, 0.0, 0.0, -1)
		event.load_character(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
		event.load_character_motion_pack(5, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.copy_character(5, 11, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.set_object_handle_sound_bank(4, sound_bank)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.copy_character(5, 11, 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_sound_bank(5, sound_bank)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.copy_character(5, 11, 14)
		event.set_character_active(0, 14)
		event.load_character(5, "event/opening/p4/p4_people.gltf", "info", 15)
		event.set_character_active(15)
		event.set_character_position(15, 0.0, 0.0, -405.0)
		event.load_character(5, "event/opening/p4/up_kusari.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_character_to_frame(10, "up_kusari", 18)
		event.load_character(5, "event/opening/p4/shuchusen.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(6, 8)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "event/opening/p4/p4_kemuri.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.set_character_position(20, 0.0, 10.0, 0.0)
		event.set_object_sequence_motion(4, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot2", 12)
		event.set_object_sequence_motion(5, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot3", 13)
		event.set_object_sequence_motion(3, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot1", 11)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.attach_character_to_frame(10, "mints", 0)
		event.set_object_sequence_motion(0, "見上げるL", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.open_voice_stream_wave(1, 40060)
		resume_step = 3
		sound.wait_voice_stream_ready(1)
		event.set_character_motion(10, "落下", 6, 0.3)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 8.0, -0.16, 15.0, 20.0, "bcol00", 2)
		event.play_sound_effect(sound_bank, 33)
		event.keep_character_in_front_of_camera_sequence(8, 60.0, 30)
		event.set_character_active(8)
		event.set_character_active(18)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "落ちるー（３）")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.play_voice_stream(1)
		event.open_message_window_2(0, 40060)
		message.open(0, -1, 8, 0, 0)
		resume_step = 4
		message.wait_voice_stopping_for(0, 30)
		message.close(0)
		event.set_message_bubble_screen_slot(0, 0)
		resume_step = 5
		object.wait_until_done(6)
		event.close_voice_stream(1)
		event.release_camera_sequence_follow_object()
		event.set_character_active(0, 8)
		event.set_camera_sequence_position(0.0, 18.46, -95.54)
		event.set_camera_sequence_look_at(0.0, 194.33, 107.78)
		event.move_camera_sequence(0.0, 18.46, -95.54, 0.0, 66.62, 107.78, 30)
		event.set_character_active(11)
		event.set_character_active(12)
		event.set_character_active(13)
		event.set_character_active(0, 18)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "落下", 6, 0.3)
		event.queue_object_sequence_next_motion(2, "停止", 4)
		event.play_sound_effect(sound_bank, 27)
		resume_step = 6
		wait.for_frame_count(14)
		event.set_object_sequence_motion(0, "飛び降りる", 2)
		event.queue_object_sequence_next_motion(0, "飛び降りるL", 6, 0.2)
		event.queue_object_sequence_next_motion(0, "ライトから着地", 6)
		event.wait_object_sequence_motion_end(0)
		event.delay_object_sequence_motion_track(0, 10)
		resume_step = 7
		wait.for_frame_count(10)
		event.detach_character_from_frame(0)
		event.set_object_sequence_position(0, 0.0, 65.81, 94.16)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.jump_object_sequence(0, 0.0, 10.6, 6.0, -0.2, 30)
		resume_step = 8
		wait.for_frame_count(5)
		event.set_character_active(20)
		event.set_character_motion(20, "けむり", 6)
		resume_step = 9
		sound.play_voice(40062)
		resume_step = 10
		object.wait_until_done(2)
		event.clear_object_sequence(7)
		event.detach_character_from_frame(11)
		event.set_object_sequence_position(3, -46.01, 150.0, 50.48)
		event.set_object_sequence_rotation(3, 0.0, 2.42, 0.0)
		event.detach_character_from_frame(12)
		event.set_object_sequence_position(4, -48.62, 150.0, 60.52)
		event.set_object_sequence_rotation(4, 0.0, -2.42, 0.0)
		event.detach_character_from_frame(13)
		event.set_object_sequence_position(5, -35.87, 150.0, -54.34)
		event.set_object_sequence_rotation(5, 0.0, 0.38, 0.0)
		event.set_character_active(14)
		event.attach_object_handle_to_character(20, 14)
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.set_object_sequence_position(20, 30.12, 150.0, -61.93)
		event.set_object_sequence_rotation(20, 0.0, -0.6, 0.0)
		resume_step = 11
		object.wait_until_done(0)
		event.set_camera_sequence_position(1.17, 26.95, -26.03)
		event.set_camera_sequence_look_at(1.17, 33.68, 4.49)
		event.set_object_sequence_position(0, 0.0, 10.0, 6.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "舞台上キョロキョロ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "拍手喝采（３）")
		event.set_object_sequence_texture_animation(0, 1, "開きからにこり")
		event.play_object_sequence_sound(0, sound_bank, 28)
		event.close_voice_stream(1)
		resume_step = 12
		sound.play_voice(40064)
		resume_step = 13
		object.wait_until_done(0)
		event.set_camera_sequence_look_at(0.0, 33.68, 4.49)
		event.set_camera_sequence_angle_height_distance(0.9, 9.0, 50.0)
		event.move_camera_sequence_angle_height_distance(-0.9, 9.0, 50.0, 180)
		event.set_object_sequence_motion(0, "手を振る", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "感動（３）")
		event.set_object_sequence_texture_animation(0, 1, "うれし口（３）")
		resume_step = 14
		camera.wait_until_done()
		event.set_camera_sequence_position(0.61, 45.86, -150.28)
		event.set_camera_sequence_look_at(0.57, 21.14, 5.95)
		event.set_character_active(0, 10)
		event.set_object_sequence_motion(20, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(20, "着地", 6)
		event.queue_object_sequence_next_motion(20, "立ち", 4)
		event.jump_object_sequence(20, 30.12, 8.8, -61.93, -0.2, 30)
		event.delay_object_sequence_sound_track(20, 30)
		event.play_object_sequence_sound(20, sound_bank, 34)
		resume_step = 15
		wait.for_frame_count(6)
		event.set_object_sequence_motion(3, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.jump_object_sequence(3, -46.01, 8.8, 50.48, -0.2, 30)
		event.delay_object_sequence_sound_track(3, 30)
		event.play_object_sequence_sound(3, sound_bank, 34)
		resume_step = 16
		wait.for_frame_count(4)
		event.set_object_sequence_motion(5, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(5, "着地", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.jump_object_sequence(5, -35.87, 8.8, -54.34, -0.2, 30)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, sound_bank, 34)
		resume_step = 17
		wait.for_frame_count(3)
		event.set_object_sequence_motion(4, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.jump_object_sequence(4, 48.62, 8.8, 60.52, -0.2, 30)
		event.delay_object_sequence_sound_track(4, 30)
		event.play_object_sequence_sound(4, sound_bank, 34)
		resume_step = 18
		wait.for_frame_count(20)
		event.set_object_sequence_motion(0, "キョロキョロ立ち")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		event.close_voice_stream(1)
		resume_step = 19
		message.show_voiced_for_stopping(40080, 30)
		resume_step = 20
		wait.for_frame_count(10)
		event.set_camera_sequence_position(-20.61, 33.01, -18.61)
		event.set_camera_sequence_look_at(1.45, 30.1, 6.28)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_object_sequence_motion(0, "レンチを取り出す", 6)
		event.queue_object_sequence_next_motion(0, "レンチを取り出すL", 4)
		event.close_voice_stream(1)
		event.open_voice_stream_wave(1, 40082)
		resume_step = 21
		wait_offset = sound.wait_voice_stream_ready_counting(1)
		event.play_voice_stream(1)
		resume_step = 22
		wait.for_frame_count(vm.i32(40 - wait_offset))
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 1)
		resume_step = 23
		wait.for_frame_count(46)
		event.play_object_sequence_sound(0, sound_bank, 35)
		resume_step = 24
		object.wait_until_done(0)
		resume_step = 25
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-4.51, 25.29, -32.6)
		event.set_camera_sequence_look_at(1.45, 30.1, 6.28)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.delay_object_sequence_sound_track(0, 4)
		event.play_object_sequence_sound(0, sound_bank, 36)
		event.close_voice_stream(1)
		resume_step = 26
		sound.play_voice(40083)
		resume_step = 27
		object.wait_until_done(0)
		resume_step = 28
		wait.for_frame_count(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		resume_step = 29
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if resume_step == 21 then
			wait_offset = received[1] :: number
		end
		if resume_step <= 1 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 2 then
			cutscene.skip_command(1)
		end
		if resume_step <= 3 then
			message.open_skipping(0, -1, 8, 0, 0)
			message.wait_voice_stopping_for_skipping(0, 30)
		end
		if resume_step <= 4 then
			message.close_skipping(0)
			cutscene.skip_command(6)
		end
		if resume_step <= 5 then
			wait.skip_frame_count(14)
		end
		if resume_step <= 6 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 7 then
			wait.skip_frame_count(5)
		end
		if resume_step <= 8 then
			sound.play_voice_skipping(40062)
		end
		if resume_step <= 9 then
			cutscene.skip_command(2)
		end
		if resume_step <= 10 then
			cutscene.skip_command(0)
		end
		if resume_step <= 11 then
			sound.play_voice_skipping(40064)
		end
		if resume_step <= 12 then
			cutscene.skip_command(0)
		end
		if resume_step <= 13 then
			wait.background_load_skipping()
		end
		if resume_step <= 14 then
			wait.skip_frame_count(6)
		end
		if resume_step <= 15 then
			wait.skip_frame_count(4)
		end
		if resume_step <= 16 then
			wait.skip_frame_count(3)
		end
		if resume_step <= 17 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 18 then
			message.show_voiced_for_stopping_skipping(40080, 30)
		end
		if resume_step <= 19 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 20 then
			wait_offset = sound.wait_voice_stream_ready_counting_skipping(1)
		end
		if resume_step <= 21 then
			wait.skip_frame_count(vm.i32(40 - wait_offset))
		end
		if resume_step <= 22 then
			wait.skip_frame_count(46)
		end
		if resume_step <= 23 then
			cutscene.skip_command(0)
		end
		if resume_step <= 24 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 25 then
			sound.play_voice_skipping(40083)
		end
		if resume_step <= 26 then
			cutscene.skip_command(0)
		end
		if resume_step <= 27 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 28 then
			wait.background_load_skipping()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 33)
	event.stop_sound_effect(sound_bank, 27)
	event.stop_sound_effect(sound_bank, 28)
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
	event.load_map_sounds(1217)
	event.stop_port_sound_effects(4)
	for index = 0, 31 do
		event.clear_object_sequence(index)
	end
	event.set_camera_look_at(0.0, 33.8, 6.0)
	event.set_camera_position(0.0, 38.8, 86.0)
	event.reset_follow_camera(0)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(8)
	event.set_character_active(1, 0)
	event.detach_character_from_frame(0)
	event.set_character_position(0, 0.0, 8.8, 6.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "バトル立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(21, 1)
	event.set_object_handle_visible(21, 1)
	event.attach_object_handle_to_character(21, 2)
	event.set_object_handle_visible(21, 0)
	event.initialize_sound_port(4)
	event.assign_memory_stack(3)
	event.clear_memory_stack(3)
	event.load_dungeon_monster(600, 1)
	event.place_dungeon_monster(600, -46.01, 8.8, 50.48, 0.0, 2.42, 0.0)
	event.place_dungeon_monster(600, 48.62, 8.8, 60.52, 0.0, -2.42, 0.0)
	event.place_dungeon_monster(600, -35.87, 8.8, -54.34, 0.0, 0.38, 0.0)
	event.place_dungeon_monster(600, 30.12, 8.8, -61.93, 0.0, -0.6, 0.0)
	battle_sound_bank = event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json") or battle_sound_bank
	event.play_sound_effect(battle_sound_bank, 0)
	resume_step = 30
	vm.wait(30)
	event.set_dungeon_pause_flags(16384, 1)
	battle_sound_id = event.get_sound_id(4) or battle_sound_id
	event.set_action_character_second_sound_bank(0, battle_sound_id)
	event.copy_action_character_sound_to_parts(0)
	event.set_dungeon_pause_flags(1, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Plays the scene where the wrench becomes the Battle Wrench and the clowns drop in.
local function cutscene_battle_wrench()
	local sound_bank: s32 = 0
	local effect_sound_id: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.show_dungeon_status_bar(0, 0.033333335)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		event.set_character_motion(0, "バトル立ち")
		wait.for_frame_count(30)
		event.stop_music(0)
		event.set_message_window_mode(0, 7)
		event.enable_drama_skip()
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p4/op4ch2.txt")
		event.load_map_sounds(1218)
		sound_bank = event.load_sound_effect_file_2(1216) or sound_bank
		effect_sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or effect_sound_id
		event.load_character_motion_pack(5, "event/opening/p4/p4_mints4.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 10.0, -80.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_motion(0, "かまえるL", 4)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 1)
		event.attach_object_handle_to_character(21, 2)
		event.set_object_handle_visible(21, 0)
		event.load_character(5, "event/opening/p4/p4_people.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, 0.0, 0.0, -405.0)
		event.load_character(5, "event/opening/p4/p4_otoko1.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, 20.0, 0.0, -420.0)
		event.load_character(5, "event/opening/p4/p4_otoko2.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_position(10, -20.0, 0.0, -420.0)
		event.load_character(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
		event.load_character_motion_pack(5, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, -50.82, 150.0, -15.75)
		event.set_object_sequence_rotation(3, 0.0, 2.2, 0.0)
		event.copy_character(5, 11, 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(4, 12)
		event.set_object_handle_sound_bank(4, sound_bank)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 47.49, 150.0, -2.37)
		event.set_object_sequence_rotation(4, 0.0, -2.64, 0.0)
		event.copy_character(5, 11, 13)
		event.set_character_active(0, 13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_sound_bank(5, sound_bank)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, -28.7, 150.0, 70.26)
		event.set_object_sequence_rotation(5, 0.0, 2.8, 0.0)
		event.copy_character(5, 11, 14)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(6, 14)
		event.set_object_handle_sound_bank(6, sound_bank)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, 1.79, 150.0, 28.91)
		event.set_object_sequence_rotation(6, 0.0, 2.92, 0.0)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(7, 15)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 0.0, 42.0, -84.0)
		event.set_object_sequence_rotation(7, 1.57, 0.0, 0.0)
		event.set_object_sequence_motion(7, "発動", 5)
		event.set_camera_sequence_position(-2.8, 29.02, -36.61)
		event.set_camera_sequence_look_at(0.85, 26.87, -88.33)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		event.play_sound_effect(effect_sound_id, 0)
		event.set_object_sequence_motion(0, "かかげる", 6)
		event.queue_object_sequence_next_motion(0, "かかげるL", 4)
		event.play_object_sequence_sound(0, sound_bank, 37)
		wait.for_frame_count(16)
		event.set_object_sequence_motion(7, "発動", 6)
		event.move_camera_sequence_eased(-0.86, 81.13, -64.1, 0.85, 26.87, -88.33, 12, 2, 1.0)
		wait.for_frame_count(20)
		event.play_object_sequence_sound(0, sound_bank, 38)
		wait.for_frame_count(60)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 0)
		event.open_message_window_2(0, 40085)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_draw_speed(0, 1)
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "気がつく", 6)
		event.queue_object_sequence_next_motion(0, "気がつくL", 4)
		object.wait_until_done(0)
		event.set_character_active(11)
		event.set_character_active(12)
		event.set_character_active(13)
		event.set_character_active(14)
		event.set_object_sequence_motion(3, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.jump_object_sequence(3, -50.82, 8.8, -15.75, -0.1, 30)
		event.delay_object_sequence_sound_track(3, 30)
		event.play_object_sequence_sound(3, sound_bank, 29)
		event.delay_object_sequence_motion_track(4, 3)
		event.delay_object_sequence_position_track(4, 3)
		event.delay_object_sequence_sound_track(4, 3)
		event.set_object_sequence_motion(4, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.jump_object_sequence(4, 47.49, 8.8, -2.37, -0.1, 30)
		event.delay_object_sequence_sound_track(4, 30)
		event.play_object_sequence_sound(4, sound_bank, 29)
		event.delay_object_sequence_motion_track(5, 9)
		event.delay_object_sequence_position_track(5, 9)
		event.delay_object_sequence_sound_track(5, 9)
		event.set_object_sequence_motion(5, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(5, "着地", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.jump_object_sequence(5, -28.7, 8.8, 70.26, -0.1, 30)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, sound_bank, 29)
		event.delay_object_sequence_motion_track(6, 15)
		event.delay_object_sequence_position_track(6, 15)
		event.delay_object_sequence_sound_track(6, 15)
		event.set_object_sequence_motion(6, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(6, "着地", 6)
		event.queue_object_sequence_next_motion(6, "立ち", 4)
		event.jump_object_sequence(6, 1.79, 8.8, 28.91, -0.1, 30)
		event.delay_object_sequence_sound_track(6, 30)
		event.play_object_sequence_sound(6, sound_bank, 29)
		wait.for_frame_count(20)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 0)
		event.set_camera_sequence_position(-12.49, 56.75, -150.16)
		event.set_camera_sequence_look_at(-0.59, 13.56, -3.76)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "かまえ立ち", 4, -1.0, 1)
		wait.for_frame_count(40)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.set_camera_sequence_position(-27.38, 36.23, -86.69)
		event.set_camera_sequence_look_at(29.33, 26.13, -60.27)
		event.set_character_cloth_animation_enabled(0, 0)
		event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "かまえ立ち", 4, -1.0, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "落ちるー（３）")
		vm.wait(11)
		event.set_mouth_texture_animations(0, "通常口パク", "怒り口（３）")
		message.show_voiced_for_stopping(40090, 120)
		event.reset_mouth_texture_animations()
		sound.play_voice(40100)
		event.set_object_sequence_motion(0, "出口を見る", 6)
		event.queue_object_sequence_next_motion(0, "出口を見るL", 6)
		wait.for_frame_count(12)
		event.set_object_sequence_motion(0, "→走り", 2)
		event.queue_object_sequence_next_motion(0, "走り", 4)
		wait.for_frame_count(10)
		event.move_object_sequence(0, 0.0, 10.0, -120.0, 20)
		object.wait_until_done(0)
		event.set_camera_sequence_position(0.0, 41.13, -104.26)
		event.set_camera_sequence_look_at(0.0, 20.2, -217.19)
		event.set_object_sequence_position(0, 0.0, 0.0, -200.0)
		event.move_object_sequence(0, 0.0, 0.0, -350.0, 30)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "拍手喝采（３）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		object.wait_until_done(0)
		event.set_camera_sequence_position(-60.96, 9.43, -525.19)
		event.set_camera_sequence_look_at(0.0, 28.11, -410.09)
		event.move_camera_sequence(-60.96, 9.43, -525.19, 0.0, 28.11, -451.39, 35)
		event.set_object_sequence_motion(0, "客を飛び超える", 6)
		event.move_object_sequence(0, 0.0, 0.0, -470.0, 35)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_bank, 30)
		event.set_character_motion(9, "振り向き", 2)
		event.set_character_motion(10, "振り向き", 2)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-107.5, 71.31, -471.79)
		event.set_camera_sequence_look_at(21.82, 28.11, -671.17)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_position(0, -40.33, 0.0, -525.86)
		event.set_object_sequence_rotation(0, 0.0, 2.7, 0.0)
		event.move_object_sequence(0, 29.23, 5.07, -691.14, 50)
		wait.for_frame_count(20)
		event.fade_out_screen(30)
		event.fade_out_music(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_character_cloth_animation_enabled(0, 1)
	event.add_hp_by_rate(1.0, 0)
	event.add_battle_weapon_durability(0, 999)
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.stop_music(0)
	event.stop_environment_music()
	wait.for_frame_count(4)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Chains into the second tent script.
function script.default_event() end

--- Plays the ladder climb and clown show then loads the tent script.
function script.cutscene_opening_show()
	local resume_step: number = 0
	return vm.guard(function()
		event.set_time_of_day_advancing(0)
		event.show_dungeon_status_bar(0, 1.0)
		event.set_save_control_bits(1, 1)
		event.set_dungeon_pause_flags(256, 1)
		resume_step = 1
		play_part1_chapter8_ladder_climb()
		resume_step = 2
		play_opening_clown_show()
		event.load_event_script("s43/s43b.stb", 151)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_opening_clown_show()
				return vm.continue_with(function()
					event.load_event_script("s43/s43b.stb", 151)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[151] = script.cutscene_opening_show

--- Spawns the clown monsters and starts the battle.
function script.start_clown_battle()
	local sound_bank: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(3)
	event.clear_memory_stack(3)
	event.load_dungeon_monster(600, 1)
	event.place_dungeon_monster(600, -46.01, 8.8, 50.48, 0.0, 2.42, 0.0)
	event.place_dungeon_monster(600, 48.62, 8.8, 60.52, 0.0, -2.42, 0.0)
	event.place_dungeon_monster(600, -35.87, 8.8, -54.34, 0.0, 0.38, 0.0)
	event.place_dungeon_monster(600, 30.12, 8.8, -61.93, 0.0, -0.6, 0.0)
	sound_bank = event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json") or sound_bank
	event.play_sound_effect(sound_bank, 0)
	event.set_dungeon_pause_flags(16384, 1)
	event.set_save_counter(5, 2)
	vm.wait(1)
	event.show_dungeon_status_bar(1, 0.033333335)
	event.fade_in_screen(30)
	event.finish_event()
end
script[152] = script.start_clown_battle

--- Event 1200, which map data, a script or the engine runs by number.
script.play_opening_fall_and_start_battle = play_opening_fall_and_start_battle
script[1200] = script.play_opening_fall_and_start_battle

--- Plays the wrench scene and moves to Georama edit once the clowns are defeated.
function script.floor_clear()
	cutscene_battle_wrench()
	event.add_inventory_item(1)
	event.equip_character_item(0, 1)
	event.remove_item(387)
	event.set_save_control_bits(1, 0)
	event.set_dungeon_pause_flags(256, 0)
	event.go_to_georama_edit(17, 153)
end

--- Starts music and plays the opening clown show.
function script.start_clown_show()
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.stop_music(0)
		event.stop_environment_music()
		resume_step = 1
		wait.for_frame_count(6)
		event.load_map_sounds(1213)
		event.load_music(103)
		event.play_music(0)
		event.show_dungeon_status_bar(0, 1.0)
		event.set_save_control_bits(1, 1)
		event.set_dungeon_pause_flags(256, 1)
		resume_step = 2
		play_opening_clown_show()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_opening_clown_show()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[8000] = script.start_clown_show

--- Starts music and reloads the second tent script.
function script.reload_clown_show_script()
	event.initialize_event()
	event.stop_music(0)
	event.stop_environment_music()
	wait.for_frame_count(6)
	event.load_map_sounds(1213)
	event.load_music(103)
	event.play_music(0)
	event.show_dungeon_status_bar(0, 1.0)
	event.set_save_control_bits(1, 1)
	event.set_dungeon_pause_flags(256, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_event_script("s43/s43b.stb", 151)
end
script[8001] = script.reload_clown_show_script

--- Hides the stage objects and reloads the second tent script at event 8000.
function script.reload_stage_script()
	event.initialize_event()
	vm.wait(1)
	event.show_dungeon_status_bar(0, 1.0)
	event.set_save_control_bits(1, 1)
	event.set_dungeon_pause_flags(256, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_event_script("s43/s43b.stb", 8000)
end
script[8002] = script.reload_stage_script

return script
