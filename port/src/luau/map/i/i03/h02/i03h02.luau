--!strict
--- Fishing Town house interior script that plays the opening crowd and clown show scene.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Plays the opening cutscene in which the hero pushes through the circus crowd past a juggling clown, then climbs a ladder to look out over the stage.
local function play_opening_crowd_arrival()
	local sound_bank: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.enable_drama_skip()
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		sound_bank = event.load_sound_effect_file_2(1213) or sound_bank
		event.load_character_motion_pack(5, "event/opening/p1/p1_mints4.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, -540.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/opening/p1/p1_people.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, 0.0, 0.0, -405.0)
		event.load_character(5, "event/opening/p1/p1_onna1.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_position(10, 18.39, 0.0, -421.29)
		event.load_character(5, "event/opening/p1/p1_otoko1.gltf", "info", 11)
		event.set_character_active(11)
		event.set_character_position(11, 27.92, 0.0, -433.74)
		event.load_character(5, "event/opening/p1/p1_otoko2.gltf", "info", 12)
		event.set_character_active(12)
		event.set_character_position(12, -25.29, 0.0, -426.67)
		event.load_character(5, "event/opening/p1/p2_macho.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_frame_visible(5, "sphere1", 0)
		event.set_object_handle_frame_visible(5, "sphere1_1", 0)
		event.set_object_handle_frame_visible(5, "sphere1_2", 0)
		event.set_object_handle_frame_visible(5, "sphere1_3", 0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 0.0, 11.23, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 3.14, 0.0)
		event.set_object_handle_shadow_enabled(5, 0)
		event.start_background_file_loads_1("event/opening/p1/p2_pierrot.gltf")
		vm.wait(1)
		wait.background_load()
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 14)
		event.set_character_active(14)
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 15)
		event.set_character_active(15)
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 16)
		event.set_character_active(16)
		event.load_character(5, "event/opening/p1/p2_pierrot.gltf", "info", 17)
		event.set_character_active(17)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 0.0, 0.0, -440.0, 120)
		event.set_object_sequence_motion(5, "投げ4回", 4)
		event.set_character_motion(14, "回転1", 4)
		event.attach_character_to_frame(13, "sphere1", 14)
		event.set_character_motion(15, "回転1", 4)
		event.attach_character_to_frame(13, "sphere1_1", 15)
		event.set_character_motion(16, "回転1", 4)
		event.attach_character_to_frame(13, "sphere1_2", 16)
		event.set_character_motion(17, "回転1", 4)
		event.attach_character_to_frame(13, "sphere1_3", 17)
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
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 18.72, -581.27)
		event.set_camera_sequence_look_at(0.0, -0.38, -526.54)
		event.move_camera_sequence(0.0, 21.63, -581.27, 0.0, 38.43, -476.49, 120)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		camera.wait_until_done()
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-17.16, 17.61, -542.92)
		event.set_camera_sequence_look_at(2.33, 20.36, -409.98)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "見えないよ", 2)
		event.queue_object_sequence_next_motion(0, "見えないよL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_bank, 4)
		event.delay_object_sequence_sound_track(0, 110)
		event.play_object_sequence_sound(0, sound_bank, 5)
		wait.for_frame_count(200)
		event.play_object_sequence_sound(0, sound_bank, 6)
		message.show_and_wait(0, 1033, 8, 200, 200)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "見えないよ戻り", 2)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		object.wait_until_done(0)
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
		object.wait_until_done(0)
		wait.for_frame_count(10)
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
		object.wait_until_done(0)
		event.set_map_lighting(0)
		vm.wait(15)
		event.set_camera_sequence_position(385.44, 20.74, -469.02)
		event.set_camera_sequence_look_at(478.52, 20.25, -405.79)
		event.set_object_sequence_position(0, 431.02, 0.0, -509.53)
		event.set_object_sequence_rotation(0, 0.0, 0.36, 0.0)
		event.move_object_sequence(0, 457.0, 0.0, -428.0, 40)
		event.delay_object_sequence_rotation_track(0, 35)
		event.rotate_object_sequence(0, 0.0, 0.72, 0.0, 5)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		wait.for_frame_count(10)
		event.set_object_sequence_motion(0, "はしご登り", 2)
		wait.for_frame_count(40)
		event.set_object_handle_footstep_sound(0, 9)
		event.move_camera_sequence(385.44, 20.74, -469.02, 478.52, 129.61, -405.79, 180)
		event.wait_object_sequence_motion_end(0)
		object.wait_until_done(0)
		camera.wait_until_done()
		event.set_camera_sequence_position(490.63, 181.9, -336.25)
		event.set_camera_sequence_look_at(424.28, 114.59, -295.7)
		event.set_object_sequence_position(0, 441.37, 133.45, -339.86)
		event.set_object_sequence_rotation(0, 0.0, 0.41, 0.0)
		event.move_object_sequence(0, 459.04, 133.45, -308.23, 40)
		event.set_object_handle_shadow_enabled(5, 1)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_sequence_motion(0, "右向き歩き", 6)
		event.queue_object_sequence_next_motion(0, "右を向く", 6)
		event.queue_object_sequence_next_motion(0, "右を向くL", 4)
		event.delay_object_sequence_sound_track(0, 40)
		event.play_object_sequence_sound(0, sound_bank, 9)
		message.show_timed_primary(0, 1034, 8, 200, 200, 60)
		object.wait_until_done(0)
		camera.wait_until_done()
		event.move_camera_sequence(492.91, 169.38, -343.35, 431.02, 155.35, -293.19, 200)
		event.slow_down_camera_sequence_position(0.94, 30)
		camera.wait_until_done()
		wait.for_frame_count(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(60)
		camera.wait_until_done()
	end)
	vm.entry(27)
	event.cancel_drama_scene_skip()
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
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

--- Plays the opening cutscene of the clown troupe landing on stage, the elephant's entrance and the bicycle-kick ball finale before the swing act.
local function play_opening_clown_show()
	local sound_bank: s32 = 0
	local index: s32 = 0
	local fall_step: f32 = 0
	local position_y: f32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.set_character_active(0, 0)
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
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
		event.start_background_file_loads_1("event/opening/p2/p2_pierrot.gltf")
		resume_step = 2
		vm.wait(2)
		resume_step = 3
		wait.background_load()
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.set_object_handle_sound_bank(1, sound_bank)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.load_character(6, "event/opening/p2/p2_pierrot.gltf", "info", 12)
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
		resume_step = 4
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 30.0, -180.0)
		event.set_camera_sequence_look_at(0.0, 30.0, 0.0)
		event.set_object_sequence_motion(0, "投げ４回からTポーズ", 6)
		event.queue_object_sequence_next_motion(0, "Tポーズ", 4)
		resume_step = 5
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
		resume_step = 6
		wait.for_frame_count(10)
		event.set_object_sequence_motion(2, "着地", 6)
		event.queue_object_sequence_next_motion(2, "着地ループ", 4)
		resume_step = 7
		wait.for_frame_count(10)
		event.set_object_sequence_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "着地ループ", 4)
		resume_step = 8
		wait.for_frame_count(10)
		event.set_object_sequence_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "着地ループ", 4)
		event.set_object_handle_shadow_enabled(1, 1)
		resume_step = 9
		wait.for_frame_count(12)
		event.set_object_handle_shadow_enabled(2, 1)
		resume_step = 10
		wait.for_frame_count(12)
		event.set_object_handle_shadow_enabled(3, 1)
		resume_step = 11
		wait.for_frame_count(12)
		event.set_object_handle_shadow_enabled(4, 1)
		event.set_object_sequence_motion(0, "Tポーズから決め", 6)
		event.queue_object_sequence_next_motion(0, "決めループ", 6)
		event.wait_object_sequence_motion_end(0)
		resume_step = 12
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
		resume_step = 13
		object.wait_until_done(0)
		resume_step = 14
		object.wait_until_done(1)
		resume_step = 15
		object.wait_until_done(2)
		resume_step = 16
		object.wait_until_done(3)
		resume_step = 17
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
		resume_step = 18
		wait.for_frame_count(3)
		event.set_object_sequence_motion(3, "走り")
		event.move_object_sequence(3, 90.31, 11.23, -38.89, 30)
		event.rotate_object_sequence(3, 0.0, 2.18, 0.0, 10)
		resume_step = 19
		wait.for_frame_count(2)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -90.31, 11.23, -38.89, 15)
		event.rotate_object_sequence(1, 0.0, -2.18, 0.0, 10)
		event.set_object_sequence_motion(4, "走り")
		event.move_object_sequence(4, 90.31, 11.23, -38.89, 15)
		event.rotate_object_sequence(4, 0.0, 2.18, 0.0, 10)
		resume_step = 20
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 21
		object.wait_until_done(4)
		event.set_object_sequence_motion(4, "立ち")
		resume_step = 22
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "立ち")
		resume_step = 23
		object.wait_until_done(3)
		event.set_object_sequence_motion(3, "立ち")
		resume_step = 24
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
		resume_step = 25
		object.wait_until_done(5)
		event.set_object_sequence_motion(5, "パオーン", 2)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.delay_object_sequence_sound_track(5, 20)
		event.play_object_sequence_sound(5, sound_bank, 7)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, sound_bank, 8)
		resume_step = 26
		wait.for_frame_count(62)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		resume_step = 27
		object.wait_until_done(5)
		resume_step = 28
		camera.wait_until_done()
		event.start_background_file_loads_2("event/opening/p2/p2_bura_pie.gltf", "event/opening/p2/p2_buranko.gltf")
		event.set_object_sequence_motion(7, "歩き", 4)
		event.set_object_sequence_position(7, 15.06, 11.23, -91.33)
		event.set_object_sequence_rotation(7, 0.0, -0.96, 0.0)
		event.delay_object_sequence_rotation_track(7, 80)
		event.rotate_object_sequence(7, 0.0, -1.8, 0.0, 10)
		event.move_object_sequence(7, -68.07, 11.23, -40.78, 90)
		resume_step = 29
		object.wait_until_done(7)
		event.set_object_sequence_motion(7, "登場ポーズ", 2)
		event.wait_object_sequence_motion_end(7)
		event.move_camera_sequence(-131.01, 23.7, -59.75, -0.22, 39.36, -20.34, 143)
		resume_step = 30
		camera.wait_until_done()
		resume_step = 31
		object.wait_until_done(7)
		event.set_object_sequence_motion(7, "歩き")
		event.move_object_sequence(7, -31.47, 11.23, -3.92, 60)
		event.rotate_object_sequence(7, 0.0, 0.72, 0.0, 10)
		resume_step = 32
		object.wait_until_done(7)
		event.set_object_sequence_motion(5, "ごにょごごにょ", 2)
		event.queue_object_sequence_next_motion(5, "ごにょごにょループ", 4)
		event.rotate_object_sequence(7, 0.0, 1.32, 0.0, 20)
		event.set_object_sequence_motion(7, "ごにょごにょ", 2)
		event.queue_object_sequence_next_motion(7, "ごにょごにょL", 6)
		event.wait_object_sequence_motion_end(7)
		event.delay_object_sequence_sound_track(7, 10)
		event.play_object_sequence_sound(7, sound_bank, 9)
		resume_step = 33
		object.wait_until_done(7)
		event.set_camera_sequence_position(-40.25, 30.96, -47.72)
		event.set_camera_sequence_look_at(-5.49, 44.23, -27.58)
		event.set_character_active(0, 13)
		event.set_character_active(1, 16)
		event.play_object_sequence_sound(5, sound_bank, 10)
		resume_step = 34
		wait.for_frame_count(60)
		event.set_camera_sequence_position(0.0, 95.44, -190.42)
		event.set_camera_sequence_look_at(0.0, 62.65, 0.0)
		event.set_character_active(1, 13)
		event.set_character_active(0, 16)
		event.set_object_sequence_motion(5, "玉持ち上げ", 6)
		event.queue_object_sequence_next_motion(5, "玉持ち上げループ", 4)
		event.play_object_sequence_sound(5, sound_bank, 11)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, sound_bank, 12)
		event.set_object_sequence_position(6, 0.0, 11.23, -30.0)
		event.set_object_sequence_motion(6, "玉持ち上げ", 6)
		event.queue_object_sequence_next_motion(6, "玉持ち上げループ", 4)
		event.set_object_sequence_rotation(7, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(7, "歩き", 4)
		event.rotate_object_sequence(7, 0.0, -1.57, 0.0, 20)
		event.move_object_sequence(7, -132.5, 11.23, 0.93, 90)
		resume_step = 35
		object.wait_until_done(7)
		event.set_character_active(0, 15)
		event.set_camera_sequence_position(0.4, 14.44, -179.22)
		event.set_camera_sequence_look_at(0.0, 67.37, 0.0)
		event.set_object_sequence_motion(5, "バイシクルシュート", 6)
		event.set_object_sequence_motion(6, "バイシクルシュート", 6)
		resume_step = 36
		wait.for_frame_count(70)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		resume_step = 37
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
		fall_step = vm.f32(0.8)
		position_y = vm.f32(-2.07)
		while index < 10 do
			fall_step = vm.f32(fall_step * vm.f32(0.8))
			position_y = vm.f32(position_y - fall_step)
			event.set_object_sequence_position(8, -2.78, position_y, 15.89)
			index = index + 1
			print(vm.float(position_y), "\n")
			resume_step = 38
			vm.wait(38)
		end
		event.set_character_active(17)
		event.set_object_sequence_motion(9, "キラーン", 6)
		event.play_object_sequence_sound(5, sound_bank, 13)
		resume_step = 39
		wait.for_frame_count(10)
		event.set_character_active(0, 17)
		resume_step = 40
		wait.for_frame_count(10)
		event.set_camera_sequence_position(-168.96, 18.9, -103.54)
		event.set_camera_sequence_look_at(-5.14, 75.4, 8.39)
		event.set_character_active(1, 13)
		event.set_character_active(0, 16)
		event.set_object_sequence_motion(5, "バイシクルシュート", 2)
		event.set_object_sequence_motion(6, "バイシクルシュート", 2)
		event.play_object_sequence_sound(5, sound_bank, 14)
		resume_step = 41
		wait.for_frame_count(9)
		event.set_object_sequence_motion_step(5, 0.01)
		event.set_object_sequence_motion_step(6, 0.01)
		event.set_camera_sequence_position(-197.04, 171.4, 0.74)
		event.set_camera_sequence_look_at(0.0, 121.4, 0.0)
		event.move_camera_sequence_angle_height_distance(1.57, 0.0, 197.04, 100)
		event.move_camera_sequence_angle_height_distance(3.14, -25.0, 197.04, 50)
		event.move_camera_sequence_angle_height_distance(-1.57, -50.0, 197.04, 50)
		resume_step = 42
		camera.wait_until_done()
		event.set_object_sequence_motion_step(5, 0.6)
		event.set_object_sequence_motion_step(6, 0.6)
		event.wait_object_sequence_motion_end(5)
		event.play_object_sequence_sound(5, sound_bank, 15)
		resume_step = 43
		wait.for_frame_count(5)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		resume_step = 44
		camera.wait_until_done()
		resume_step = 45
		object.wait_until_done(5)
		event.set_camera_sequence_position(-120.33, 279.87, -18.7)
		event.set_camera_sequence_look_at(138.46, 217.78, 141.95)
		event.set_object_sequence_position(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(6, "右のピエロ", 6)
		event.delay_object_sequence_sound_track(6, 10)
		event.play_object_sequence_sound(6, sound_bank, 16)
		resume_step = 46
		wait.for_frame_count(20)
		event.set_camera_sequence_position(87.54, 42.85, 80.82)
		event.set_camera_sequence_look_at(-204.62, 211.5, 188.69)
		event.set_object_sequence_motion(6, "左のピエロ", 6)
		event.delay_object_sequence_sound_track(6, 10)
		event.play_object_sequence_sound(6, sound_bank, 16)
		resume_step = 47
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
		resume_step = 48
		wait.for_frame_count(50)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 25)
		resume_step = 49
		object.wait_until_done(5)
		event.play_object_sequence_sound(5, sound_bank, 18)
		event.set_camera_sequence_position(-55.0, 150.0, 230.0)
		event.set_camera_sequence_look_at(0.0, 50.0, -30.0)
		event.move_camera_sequence(55.0, 150.0, 230.0, 0.0, 50.0, -30.0, 120)
		resume_step = 50
		camera.wait_until_done()
		event.set_camera_sequence_position(37.29, 24.91, -191.53)
		event.set_camera_sequence_look_at(5.05, 69.55, -9.71)
		event.set_object_sequence_motion(6, "キャッチ＆決め終わり", 6)
		event.set_object_sequence_motion(5, "キャッチ＆決め終わり", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		resume_step = 51
		wait.for_frame_count(30)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
		resume_step = 52
		camera.wait_until_done()
		resume_step = 53
		object.wait_until_done(5)
		resume_step = 54
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
		resume_step = 55
		camera.wait_until_done()
		event.set_character_active(0, 13)
		event.set_camera_sequence_follow_object(0, 0.0, 14.0, 0.0, -2.67, 31.0, 140.0, "skin")
		resume_step = 56
		wait.for_frame_count(60)
		event.stop_sound_effect(sound_bank, 19)
		event.play_sound_effect(sound_bank, 20)
		event.set_object_sequence_motion(0, "ピエロブランコ", 6)
		event.set_object_sequence_motion(1, "ピエロブランコ", 6)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, sound_bank, 21)
		event.delay_object_sequence_sound_track(0, 50)
		event.play_object_sequence_sound(0, sound_bank, 21)
		resume_step = 57
		wait.for_frame_count(60)
		resume_step = 58
		wait.for_frame_count(40)
		event.move_camera_sequence_angle_height_distance(-3.14, 0.0, 140.0, 60)
		resume_step = 59
		wait.for_frame_count(90)
		event.attach_object_handle_to_map_part_2(31, "p10_i03h02")
		event.set_object_handle_visible(31, 0)
		event.release_camera_sequence_follow_object()
		event.play_object_sequence_sound(0, sound_bank, 25)
		event.move_camera_sequence(145.04, 229.37, -319.27, -156.54, 156.11, -23.11, 60)
		resume_step = 60
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 237.95, -275.71)
		event.set_camera_sequence_look_at(0.0, 212.96, -32.39)
		event.set_object_sequence_position(0, 170.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 170.0, 0.0, 0.0)
		resume_step = 61
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
		resume_step = 62
		wait.for_frame_count(50)
		event.set_object_handle_visible(31, 1)
		resume_step = 63
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 53.51, -115.19)
		event.set_camera_sequence_look_at(0.0, 35.43, 0.41)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		resume_step = 64
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
		resume_step = 65
		object.wait_until_done(7)
		resume_step = 66
		wait.for_frame_count(30)
		event.move_camera_sequence_eased(-391.9, 285.91, -201.78, 1.6, 40.06, 1.5, 90, 0, 0.2)
		resume_step = 67
		camera.wait_until_done()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		resume_step = 68
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if resume_step <= 2 then
			wait.background_load_skipping()
		end
		if resume_step <= 3 then
			wait.background_load_skipping()
		end
		if resume_step <= 4 then
			wait.skip_frame_count(26)
		end
		if resume_step <= 5 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 6 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 7 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 8 then
			wait.skip_frame_count(12)
		end
		if resume_step <= 9 then
			wait.skip_frame_count(12)
		end
		if resume_step <= 10 then
			wait.skip_frame_count(12)
		end
		if resume_step <= 11 then
			cutscene.skip_command(0)
		end
		if resume_step <= 12 then
			cutscene.skip_command(0)
		end
		if resume_step <= 13 then
			cutscene.skip_command(1)
		end
		if resume_step <= 14 then
			cutscene.skip_command(2)
		end
		if resume_step <= 15 then
			cutscene.skip_command(3)
		end
		if resume_step <= 16 then
			cutscene.skip_command(4)
		end
		if resume_step <= 17 then
			wait.skip_frame_count(3)
		end
		if resume_step <= 18 then
			wait.skip_frame_count(2)
		end
		if resume_step <= 19 then
			cutscene.skip_command(1)
		end
		if resume_step <= 20 then
			cutscene.skip_command(4)
		end
		if resume_step <= 21 then
			cutscene.skip_command(2)
		end
		if resume_step <= 22 then
			cutscene.skip_command(3)
		end
		if resume_step <= 23 then
			cutscene.skip_command(5)
		end
		if resume_step <= 24 then
			cutscene.skip_command(5)
		end
		if resume_step <= 25 then
			wait.skip_frame_count(62)
		end
		if resume_step <= 26 then
			cutscene.skip_command(5)
		end
		if resume_step <= 27 then
			wait.background_load_skipping()
		end
		if resume_step <= 28 then
			cutscene.skip_command(7)
		end
		if resume_step <= 29 then
			wait.background_load_skipping()
		end
		if resume_step <= 30 then
			cutscene.skip_command(7)
		end
		if resume_step <= 31 then
			cutscene.skip_command(7)
		end
		if resume_step <= 32 then
			cutscene.skip_command(7)
		end
		if resume_step <= 33 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 34 then
			cutscene.skip_command(7)
		end
		if resume_step <= 35 then
			wait.skip_frame_count(70)
		end
		if resume_step <= 36 then
			wait.skip_frame_count(29)
		end
		if resume_step <= 37 then
			index = 0
			fall_step = vm.f32(0.8)
			position_y = vm.f32(-2.07)
			fall_step = vm.f32(fall_step * vm.f32(0.8))
			position_y = vm.f32(position_y - fall_step)
			local _ = index < 10
			index = index + 1
			print(vm.float(position_y), "\n")
		end
		if resume_step <= 38 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 39 then
			wait.skip_frame_count(10)
		end
		if resume_step <= 40 then
			wait.skip_frame_count(9)
		end
		if resume_step <= 41 then
			wait.background_load_skipping()
		end
		if resume_step <= 42 then
			wait.skip_frame_count(5)
		end
		if resume_step <= 43 then
			wait.background_load_skipping()
		end
		if resume_step <= 44 then
			cutscene.skip_command(5)
		end
		if resume_step <= 45 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 46 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 47 then
			wait.skip_frame_count(50)
		end
		if resume_step <= 48 then
			cutscene.skip_command(5)
		end
		if resume_step <= 49 then
			wait.background_load_skipping()
		end
		if resume_step <= 50 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 51 then
			wait.background_load_skipping()
		end
		if resume_step <= 52 then
			cutscene.skip_command(5)
		end
		if resume_step <= 53 then
			wait.background_load_skipping()
		end
		if resume_step <= 54 then
			wait.background_load_skipping()
		end
		if resume_step <= 55 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 56 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 57 then
			wait.skip_frame_count(40)
		end
		if resume_step <= 58 then
			wait.skip_frame_count(90)
		end
		if resume_step <= 59 then
			wait.background_load_skipping()
		end
		if resume_step <= 60 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 61 then
			wait.skip_frame_count(50)
		end
		if resume_step <= 62 then
			wait.background_load_skipping()
		end
		if resume_step <= 63 then
			cutscene.skip_command(7)
		end
		if resume_step <= 64 then
			cutscene.skip_command(7)
		end
		if resume_step <= 65 then
			wait.skip_frame_count(30)
		end
		if resume_step <= 66 then
			wait.background_load_skipping()
		end
		if resume_step <= 67 then
			wait.background_load_skipping()
		end
		return true
	end)
	resume_step = 69
	vm.entry(69)
	event.cancel_drama_scene_skip()
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
	event.stop_sound_effect(sound_bank, 19)
	event.stop_sound_effect(sound_bank, 28)
	event.stop_sound_effect(sound_bank, 29)
	event.stop_environment_music()
	resume_step = 70
	wait.for_frame_count(6)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the map's default entry behavior is suppressed.
function script.default_event() end

--- Plays the crowd arrival and the clown show and loads the next part of the scene.
function script.cutscene_opening_clown_show()
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		play_opening_crowd_arrival()
		resume_step = 2
		play_opening_clown_show()
		event.load_event_script("i03h02/i03h02_2.stb", 151)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_opening_clown_show()
				return vm.continue_with(function()
					event.load_event_script("i03h02/i03h02_2.stb", 151)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[151] = script.cutscene_opening_clown_show

return script
