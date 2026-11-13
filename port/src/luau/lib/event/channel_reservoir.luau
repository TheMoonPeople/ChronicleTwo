--!strict
--- Event helpers for the Channel Reservoir map, mostly its train departure scenes.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local channel_reservoir = {}

--- Attaches the train car and wheel objects to sequence handles and starts the wheels rotating.
function channel_reservoir.attach_train_wheels()
	event.set_object_sequence_position(2, 0.0, -24.0, -1000.0)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(10, "p01_train01", "train06-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.attach_object_handle_to_map_part_3(11, "p01_train01", "train06-m1")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.attach_object_handle_to_map_part_3(12, "p01_train01", "train05-m10")
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.attach_object_handle_to_map_part_3(13, "p01_train01", "train05-m11")
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.attach_object_handle_to_map_part_3(14, "p01_train01", "train05-m12")
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	event.attach_object_handle_to_map_part_3(15, "p01_train01", "train05-m13")
	event.clear_object_sequence(15)
	event.set_object_sequence_object(15, 15)
	event.attach_object_handle_to_map_part_3(16, "p01_train01", "train05-m14")
	event.clear_object_sequence(16)
	event.set_object_sequence_object(16, 16)
	event.attach_object_handle_to_map_part_3(17, "p01_train01", "train05-m15")
	event.clear_object_sequence(17)
	event.set_object_sequence_object(17, 17)
	event.attach_object_handle_to_map_part_3(18, "p01_train01", "train05-m16")
	event.clear_object_sequence(18)
	event.set_object_sequence_object(18, 18)
	event.attach_object_handle_to_map_part_3(19, "p01_train01", "train05-m17")
	event.clear_object_sequence(19)
	event.set_object_sequence_object(19, 19)
	event.attach_object_handle_to_map_part_3(20, "p01_train01", "train05-m18")
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.attach_object_handle_to_map_part_3(21, "p01_train01", "train05-m19")
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	for index = 0, 11 do
		event.rotate_object_sequence(10 + index, 0.1, 0.0, 0.0, -1)
	end
end

--- Restores the player and removes the temporary train scene characters.
function channel_reservoir.clear_train_scene_characters()
	event.set_character_active(1, 0)
	event.set_character_active(0, 9)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
end

--- Enables the train event trigger until its save flag is set and hides the train afterwards.
function channel_reservoir.initialize_map()
	local flag_202: s32 = 0
	event.initialize_event()
	flag_202 = event.get_save_flag(202) or flag_202
	if flag_202 == 0 then
		event.set_function_point_enabled("", "fc_event_202", 1)
	else
		event.set_function_point_enabled("", "fc_event_202", 0)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.set_object_handle_visible(0, 0)
	end
end

--- Loads the characters, train parts, smoke effect and messages used by the train departure scene.
function channel_reservoir.load_train_scene()
	channel_reservoir.clear_train_scene_characters()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.clear_camera_sequence()
	event.load_character_motion_pack(5, "event/e200/e202/e202_mints.gltf", "info", 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.load_character(5, "event/e200/e202/e202_starbre.gltf", "info", 9)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 9)
	event.load_character(5, "event/e200/e202/e202_train_pika.gltf", "info", 10)
	event.set_character_active(0, 10)
	event.attach_object_handle_to_map_part_2(2, "p01_train01")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "train07-m0")
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "train07-m1")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "train08-m2")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.attach_object_handle_to_map_part_3(6, "p01_train01", "train08-m3")
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.attach_object_handle_to_map_part_3(7, "p01_train01", "train08-m7")
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.attach_object_handle_to_map_part_3(8, "p01_train01", "train08-m6")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_3(9, "p01_train01", "train10-m2")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_3(22, "p01_train01", "train10-m3")
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.attach_object_handle_to_map_part_3(23, "p01_train01", "train10-m7")
	event.clear_object_sequence(23)
	event.set_object_sequence_object(23, 23)
	event.attach_object_handle_to_map_part_3(24, "p01_train01", "train10-m6")
	event.clear_object_sequence(24)
	event.set_object_sequence_object(24, 24)
	channel_reservoir.attach_train_wheels()
	event.initialize_effect_manager(5)
	event.load_effect_base("列車煙")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(2, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 2)
	event.load_message_file(0, 5, "event/e200/e202/e202_1.txt")
end

--- Moves the train object along its track to a position offset from its start over a number of frames with easing.
function channel_reservoir.move_train_eased(offset: f32, frames: s32)
	event.move_object_sequence_eased(2, 0.0, -24.0, -1000.0 + offset, frames, 2, 0.4)
end

--- Plays the cutscene in which Mints walks along the platform and hands control back to the player.
function channel_reservoir.play_mints_walk_intro()
	vm.section(function()
		event.set_save_flag(201, 1)
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_message_window_mode(0, 7)
		event.load_character_motion_pack(5, "event/e200/e201/e201_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.fade_out_screen(0)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(111)
		event.play_music(0)
		event.set_camera_sequence_position(-560.0, 157.51, -568.46)
		event.set_camera_sequence_look_at(-560.0, 157.27, -483.32)
		event.fade_in_screen(30)
		event.enable_drama_skip()
		event.attach_object_handle_to_map_part_2(10, "p01_train01")
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_position(10, 0.0, -24.0, -1000.0)
		event.set_object_sequence_position(0, -560.0, 132.17, -500.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, -560.0, 132.17, -300.0, 270)
		wait.frames(285)
		event.set_object_sequence_position(0, -560.0, 132.17, -300.0)
		event.move_object_sequence(0, -560.0, 132.17, -100.0, 255)
		event.set_camera_sequence_follow_object(0, 0.0, 25.0, 0.0, 0.55, -1.91, 34.9)
		wait.frames(165)
		event.set_object_handle_footstep_sound(0, -1)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(90, 200, 200, 200)
		wait.frames(90)
		event.release_camera_sequence_follow_object()
		event.clear_camera_sequence()
		event.set_camera_sequence_look_at(-567.88, 154.74, -22.62)
		event.set_camera_sequence_angle_height_distance(1.68, -0.34, 88.57)
		event.move_camera_sequence_angle_height_distance_eased(-1.72, -0.34, 88.57, 360, 0, 0.2)
		event.fade_in_camera_sequence(90, 200, 200, 200)
		wait.frames(450)
		event.set_object_sequence_position(0, -560.0, 132.17, -200.0)
		event.move_object_sequence(0, -560.0, 132.17, -100.0, 120)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-785.67, 205.49, 52.24)
		event.set_camera_sequence_look_at(-512.83, 162.33, -212.01)
		wait.frames(30)
		event.move_camera_sequence_eased(-3101.09, 205.49, 1822.12, -512.83, 162.33, -212.01, 210, 0, 0.2)
		wait.frames(90)
		event.set_object_sequence_position(0, -560.0, 132.17, -100.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		wait.frames(190)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.delete_character_extension_packs(0)
	event.release_camera_sequence_follow_object()
	event.set_camera_position(-559.4, 187.73, -249.37)
	event.set_camera_look_at(-556.51, 162.33, -127.3)
	event.set_character_position(0, -557.84, 132.17, -142.95)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	vm.wait(10)
	event.set_object_handle_footstep_sound(0, 0)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(193)
	event.play_music(0)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
end

--- Plays the cutscene in which the party watches the train arrive, talks and boards it.
function channel_reservoir.play_train_boarding_cutscene()
	local sound_bank: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		checkpoint = 1
		vm.entry(1)
		event.set_save_flag(202, 1)
		event.initialize_event()
		sound_bank = event.load_sound_effect_file_2(1837) or sound_bank
		channel_reservoir.load_train_scene()
		event.set_object_handle_footstep_sound(0, 0)
		event.stop_music(0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(-339.31, 136.54, 364.85)
		event.set_camera_sequence_look_at(-238.55, 35.08, 513.89)
		event.set_object_sequence_position(0, -198.33, 13.59, 420.19)
		event.set_object_sequence_rotation(0, 0.0, -0.35, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ぼうぜん顔")
		event.set_object_sequence_texture_animation(0, 1, "つうじょう目パチ")
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 160)
		event.add_object_sequence_path_point(0, -198.33, 13.59, 420.19)
		event.add_object_sequence_path_point(0, -203.12, 13.59, 502.05)
		event.add_object_sequence_path_point(0, -216.28, 13.59, 545.08)
		event.add_object_sequence_path_point(0, -238.62, 13.59, 586.39)
		event.start_object_sequence_path(0)
		event.set_object_handle_footstep_sound(0, 15)
		checkpoint = 2
		wait.frames(30)
		event.set_object_handle_footstep_sound(0, 2)
		checkpoint = 3
		wait.frames(90)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_camera_sequence_position(-157.69, 69.09, 657.85)
		event.set_camera_sequence_look_at(-309.71, 39.39, 635.31)
		event.set_object_sequence_position(0, -218.73, 13.59, 644.79)
		event.set_object_sequence_rotation(0, 0.0, -1.67, 0.0)
		event.move_object_sequence(0, -301.77, 13.77, 637.45, 60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(-157.69, 69.09, 657.85, -309.71, 39.39, 635.31)
		event.add_camera_sequence_path_point(-182.29, 46.57, 654.2, -309.71, 39.39, 635.31)
		event.add_camera_sequence_path_point(-226.21, 39.3, 647.69, -309.71, 39.39, 635.31)
		event.start_camera_sequence_path()
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち", 0)
		checkpoint = 4
		wait.frames(150)
		checkpoint = 5
		message.show_voiced(2020010)
		event.set_camera_sequence_position(-325.02, 31.34, 616.64)
		event.set_camera_sequence_look_at(-305.34, 35.79, 635.58)
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		checkpoint = 6
		message.show_voiced(2020020)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.set_camera_sequence_position(-333.76, 40.57, 633.22)
		event.set_camera_sequence_look_at(-302.99, 37.72, 637.65)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "通常目～うれし目")
		event.set_object_sequence_texture_animation(0, 1, "半口～うれし開き")
		checkpoint = 7
		wait.frames(15)
		event.set_object_sequence_texture_animation(0, 1, "きらきら目")
		event.move_camera_sequence_eased(-326.11, 40.57, 634.32, -302.99, 37.72, 637.65, 90, 2, 0.4)
		checkpoint = 8
		message.show_voiced(2020030)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "まえ向き～左むき")
		event.play_sound_effect(sound_bank, 6)
		event.set_object_sequence_motion(0, "振り返る", 6, -1.0, 1)
		checkpoint = 9
		wait.frames(10)
		event.clear_camera_sequence()
		channel_reservoir.move_train_eased(2200.0, 220)
		event.set_camera_sequence_position(-331.99, 42.11, 682.27)
		event.set_camera_sequence_look_at(-281.67, 40.37, 620.78)
		event.play_sound_effect(sound_bank, 8)
		checkpoint = 10
		wait.frames(50)
		event.set_object_sequence_motion(0, "振り返るL", 6, -1.0, 1)
		checkpoint = 11
		wait.frames(70)
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_motion(0, "列車を見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "列車を見るL", 0)
		checkpoint = 12
		wait.frames(120)
		event.set_camera_sequence_position(-704.28, 74.53, 644.02)
		event.set_camera_sequence_look_at(-229.0, 60.03, 630.45)
		event.set_object_handle_shadow_enabled(0, 0)
		event.set_object_handle_shadow_enabled(1, 0)
		checkpoint = 13
		wait.frames(60)
		event.set_camera_sequence_position(-272.98, 32.08, 611.38)
		event.set_camera_sequence_look_at(-292.01, 32.94, 630.57)
		event.set_object_sequence_rotation(0, 0.0, 1.93, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_motion(0, "キョロキョロ", 4, -1.0, 1)
		checkpoint = 14
		wait.frames(40)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-344.7, 43.98, 674.78)
		event.set_camera_sequence_look_at(-270.62, 44.19, 558.35)
		event.set_object_sequence_rotation(0, 0.0, 1.69, 0.0)
		event.set_object_sequence_position(1, -57.93, 11.86, 130.81)
		event.set_object_sequence_rotation(1, 0.0, -1.55, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_z = vm.f32(pos_z + vm.f32(-517.642))
		event.set_object_sequence_position(4, pos_x - 50.0, pos_y, pos_z)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.08726647)
		event.play_sound_effect(sound_bank, 9)
		event.rotate_object_sequence(8, 0.0, -1.57, 0.0, 30)
		event.rotate_object_sequence(7, 0.0, 1.57, 0.0, 30)
		event.rotate_object_sequence(24, 0.0, -1.57, 0.0, 30)
		event.rotate_object_sequence(23, 0.0, 1.57, 0.0, 30)
		event.set_object_sequence_motion(0, "左を見る", 6)
		event.queue_object_sequence_next_motion(0, "左を見るL", 0)
		checkpoint = 15
		wait.frames(30)
		checkpoint = 16
		wait.frames(30)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 15)
		event.add_object_sequence_path_point(1, -58.2, 12.83, 120.56)
		event.add_object_sequence_path_point(1, -71.49, 12.83, 120.23)
		event.start_object_sequence_path(1)
		checkpoint = 17
		wait.frames(15)
		event.set_object_sequence_position(4, pos_x, pos_y, pos_z)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(24, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(23, 0.0, 0.0, 0.0)
		event.set_character_active(1, 0)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-429.29, 148.18, 653.31)
		event.set_camera_sequence_look_at(-322.93, 59.6, 619.28)
		event.set_object_sequence_rotation(0, 0.0, 2.65, 0.0)
		event.set_object_sequence_position(1, -223.19, 13.78, 510.23)
		event.set_object_sequence_rotation(1, 0.0, -0.5, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.move_object_sequence(1, -268.59, 13.78, 585.68, 75)
		checkpoint = 18
		wait.frames(75)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_camera_sequence_position(-291.41, 39.19, 607.31)
		event.set_camera_sequence_look_at(-299.71, 35.93, 634.94)
		event.set_object_handle_shadow_enabled(0, 1)
		event.set_object_handle_shadow_enabled(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "きらきら目")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 19
		message.show_voiced(2020040)
		event.reset_mouth_texture_animations()
		checkpoint = 20
		object.wait_until_done(0)
		event.set_camera_sequence_position(-315.4, 36.86, 675.88)
		event.set_camera_sequence_look_at(-291.69, 35.93, 632.9)
		event.set_object_sequence_rotation(0, 0.0, 2.29, 0.0)
		event.set_object_sequence_position(1, -271.9, 13.78, 616.69)
		event.set_object_sequence_rotation(1, 0.0, -0.98, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "腰に手", 6)
		event.queue_object_sequence_next_motion(1, "腰に手L", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 21
		message.show_voiced(2020050)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "乗れ", 6)
		event.queue_object_sequence_next_motion(1, "乗れL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 22
		message.show_voiced(2020060)
		event.reset_mouth_texture_animations()
		checkpoint = 23
		object.wait_until_done(1)
		event.set_camera_sequence_position(-264.17, 27.45, 662.14)
		event.set_camera_sequence_look_at(-203.38, 37.55, 662.68)
		event.set_object_sequence_position(0, -269.3, 13.77, 637.92)
		event.set_object_sequence_rotation(0, 0.0, 1.57, 0.0)
		event.set_object_sequence_position(1, -273.23, 13.77, 651.56)
		event.set_object_sequence_rotation(1, 0.0, 1.44, 0.0)
		checkpoint = 24
		channel_reservoir.walk_party_to_train(sound_bank)
		event.set_character_active(0, 0)
		event.set_character_active(0, 9)
		checkpoint = 25
		channel_reservoir.play_train_departure_shots(sound_bank)
		cutscene.skip_value_command(sound_bank)
		cutscene.skip_value_command(sound_bank)
		cutscene.skip_value_command(sound_bank)
		cutscene.skip_value_command(sound_bank)
		cutscene.skip_value_command(sound_bank)
		cutscene.skip_value_command(sound_bank)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			channel_reservoir.skip_load_train_scene()
			wait.frames_skipping(30)
		end
		if checkpoint <= 2 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 3 then
			wait.frames_skipping(150)
		end
		if checkpoint <= 4 then
			message.show_voiced_skipping(2020010)
		end
		if checkpoint <= 5 then
			message.show_voiced_skipping(2020020)
		end
		if checkpoint <= 6 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 7 then
			message.show_voiced_skipping(2020030)
		end
		if checkpoint <= 8 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 9 then
			channel_reservoir.skip_move_train_eased(2200.0, 220)
			wait.frames_skipping(50)
		end
		if checkpoint <= 10 then
			wait.frames_skipping(70)
		end
		if checkpoint <= 11 then
			wait.frames_skipping(120)
		end
		if checkpoint <= 12 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 13 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 14 then
			pos_z = vm.f32(pos_z + vm.f32(-517.642))
			wait.frames_skipping(30)
		end
		if checkpoint <= 15 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 16 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 17 then
			wait.frames_skipping(75)
		end
		if checkpoint <= 18 then
			message.show_voiced_skipping(2020040)
		end
		if checkpoint <= 19 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 20 then
			message.show_voiced_skipping(2020050)
		end
		if checkpoint <= 21 then
			message.show_voiced_skipping(2020060)
		end
		if checkpoint <= 22 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 23 then
			channel_reservoir.skip_walk_party_to_train(sound_bank)
		end
		if checkpoint <= 24 then
			channel_reservoir.skip_train_departure_shots(sound_bank)
		end
		if checkpoint <= 25 then
			cutscene.skip_value_command(sound_bank)
			cutscene.skip_value_command(sound_bank)
			cutscene.skip_value_command(sound_bank)
			cutscene.skip_value_command(sound_bank)
			cutscene.skip_value_command(sound_bank)
			cutscene.skip_value_command(sound_bank)
		end
		return true
	end)
	checkpoint = 26
	vm.entry(26)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.stop_sound_effect(sound_bank, 7)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	channel_reservoir.clear_train_scene_characters()
	event.clear_effect_manager()
	event.reset_follow_camera(1, 0.0, 20.0)
end

--- Plays the camera shots of the train leaving with its headlight flash and fades out.
function channel_reservoir.play_train_departure_shots(sound_effect_id: s32)
	event.set_camera_sequence_position(3.45, 77.44, 1389.54)
	event.set_camera_sequence_look_at(3.0, 63.96, 1261.17)
	for index = 0, 11 do
		event.rotate_object_sequence(10 + index, 0.03, 0.0, 0.0, -1)
	end
	event.play_sound_effect(sound_effect_id, 15)
	event.set_object_sequence_position(2, 0.0, -24.0, 500.0)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.set_character_active(1, 10)
	event.set_character_position(10, 1.55, 41.98, 824.64)
	event.set_character_motion(10, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	wait.frames(30)
	event.set_character_active(0, 10)
	event.move_object_sequence_eased(2, 0.0, -24.0, 5000.0, 360, 1, 0.7)
	event.play_sound_effect(sound_effect_id, 16)
	event.set_camera_sequence_position(-423.7, 77.44, 613.24)
	event.set_camera_sequence_look_at(-149.56, 63.96, 588.35)
	wait.frames(75)
	event.set_camera_sequence_position(3.45, 77.44, 1389.54)
	event.set_camera_sequence_look_at(3.0, 63.96, 1261.17)
	event.move_camera_sequence_eased(4.3, 77.44, 1631.73, 3.0, 63.96, 1261.17, 75, 2, 0.2)
	wait.frames(75)
	event.set_camera_sequence_position(-741.43, 330.34, 349.51)
	event.set_camera_sequence_look_at(-180.96, 187.05, 261.6)
	event.move_camera_sequence_eased(-741.43, 330.34, 349.51, -335.86, 187.05, 767.89, 90, 2, 0.4)
	wait.frames(150)
	event.clear_camera_sequence()
	event.delay_camera_sequence_fade_track(135)
	event.fade_out_camera_sequence(30, 0.0, 0.0)
	event.move_camera_sequence_eased(-1416.81, 608.29, -321.97, -333.28, 187.05, 759.45, 120, 0, 0.4)
	wait.frames(165)
	event.clear_camera_sequence()
	wait.frames(180)
end

--- Plays the opening shot of the train running past while the camera pans along it.
function channel_reservoir.play_train_flyby_opening()
	event.initialize_event()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -215.0, 12.66, 60.0)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "走り")
	event.set_object_sequence_texture_animation(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, -24.0, -1800.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_time_of_day(7.0)
	event.set_time_of_day_advancing(1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-746.57, 16.36, 156.44)
	event.set_camera_sequence_look_at(-199.21, 142.65, 471.29)
	wait.frames(30)
	event.move_camera_sequence(-701.67, 16.36, 428.3, -154.32, 142.65, 743.14, 400)
	event.move_object_sequence(0, -215.0, 12.66, 1700.0, 460)
	event.move_object_sequence(1, 0.0, -24.0, 5000.0, 260)
	camera.wait_until_done()
	wait.until_button_pressed(64)
end

--- Opens the floor menu of the first dungeon, then jumps to map d01e01, resumes play with the player walking back, or enters the chosen floor.
function channel_reservoir.select_dungeon_floor()
	local selection: s32 = 0
	event.set_dungeon_stage_id(0)
	event.open_event_menu(3, 0)
	vm.wait(1)
	do
		local _, _, out3, _ = event.get_menu_results_4()
		selection = out3 or selection
	end
	if selection == 0 then
		event.jump_to_map_2(-1, "d01e01")
		vm.wait(2)
	elseif selection == 8 then
		channel_reservoir.walk_player_back_from_menu()
	else
		event.go_to_dungeon(0, selection, 1010)
	end
end

--- Skip-handler counterpart of load_train_scene that performs no work.
function channel_reservoir.skip_load_train_scene()
	cutscene.noop()
	channel_reservoir.skip_wheel_rotation()
end

--- Skip-handler counterpart of move_train_eased that performs no work.
function channel_reservoir.skip_move_train_eased(offset: f32, frames: s32) end

--- Skip-handler counterpart of play_train_departure_shots that replays its waits.
function channel_reservoir.skip_train_departure_shots(sound_effect_id: s32)
	local index: s32 = 0
	index = 0
	local _ = index < 12
	index = index + 1
	wait.frames_skipping(30)
	wait.frames_skipping(75)
	wait.frames_skipping(75)
	wait.frames_skipping(150)
	wait.frames_skipping(165)
	wait.frames_skipping(180)
end

--- Skip-handler counterpart of walk_party_to_train that replays its waits.
function channel_reservoir.skip_walk_party_to_train(sound_effect_id: s32)
	wait.frames_skipping(72)
	wait.frames_skipping(20)
	wait.frames_skipping(10)
	wait.frames_skipping(15)
	wait.frames_skipping(30)
	wait.frames_skipping(60)
	wait.frames_skipping(15)
end

--- Skip-handler counterpart of the wheel rotation loop.
function channel_reservoir.skip_wheel_rotation()
	local index: s32 = 0
	index = 0
	local _ = index < 12
	index = index + 1
end

--- Walks both party members along paths to the train while the train cars straighten out.
function channel_reservoir.walk_party_to_train(sound_effect_id: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	do
		local out1, out2, out3 = event.get_object_handle_position(3)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_sequence_position(3, pos_x - 50.0, pos_y, pos_z)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.08726647)
	event.set_object_sequence_rotation(5, 0.0, -1.5707964, 0.0)
	event.set_object_sequence_rotation(6, 0.0, 1.5707964, 0.0)
	event.set_object_sequence_rotation(22, 0.0, -1.5707964, 0.0)
	event.set_object_sequence_rotation(9, 0.0, 1.5707964, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.set_object_sequence_motion(1, "歩き", 4)
	event.set_object_handle_footstep_sound(0, 6)
	event.set_object_handle_footstep_sound(1, 6)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 90)
	event.add_object_sequence_path_point(0, -160.36, 2.7, 634.04)
	event.add_object_sequence_path_point(0, -124.87, 2.7, 630.96)
	event.add_object_sequence_path_point(0, -89.31, 4.88, 627.74)
	event.add_object_sequence_path_point(0, -78.59, 9.51, 627.52)
	event.add_object_sequence_path_point(0, -58.26, 12.02, 627.52)
	event.add_object_sequence_path_point(0, -23.27, 22.08, 626.47)
	event.start_object_sequence_path(0)
	event.clear_object_sequence_path(1)
	event.set_object_sequence_path_frames(1, 90)
	event.add_object_sequence_path_point(1, -117.93, 2.01, 644.18)
	event.add_object_sequence_path_point(1, -87.39, 5.06, 643.55)
	event.add_object_sequence_path_point(1, -79.65, 10.25, 643.38)
	event.add_object_sequence_path_point(1, -61.53, 13.02, 643.01)
	event.add_object_sequence_path_point(1, -15.8, 26.38, 642.06)
	event.start_object_sequence_path(1)
	wait.frames(72)
	event.set_object_handle_footstep_sound(0, 4)
	event.set_object_handle_footstep_sound(1, 4)
	event.play_sound_effect(sound_effect_id, 12)
	event.rotate_object_sequence(6, 0.0, 0.0, 0.0, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, 0.0, 30)
	event.rotate_object_sequence(22, 0.0, 0.0, 0.0, 30)
	event.rotate_object_sequence(9, 0.0, 0.0, 0.0, 30)
	wait.frames(20)
	event.rotate_object_sequence(0, 0.0, 3.03, 0.0, 30)
	wait.frames(10)
	wait.frames(15)
	event.play_sound_effect(sound_effect_id, 13)
	event.rotate_object_sequence(3, 0.0, 0.0, 0.0, 30)
	wait.frames(30)
	event.play_sound_effect(sound_effect_id, 14)
	event.move_object_sequence(3, pos_x, pos_y, pos_z, 60)
	wait.frames(60)
	wait.frames(15)
end

--- Fades in and walks the player a few steps before returning control and the follow camera.
function channel_reservoir.walk_player_back_from_menu()
	event.initialize_event()
	vm.wait(1)
	event.fade_in_screen(15)
	event.set_camera_sequence_position(-564.69, 162.76, -362.47)
	event.set_camera_sequence_look_at(-556.95, 162.37, -243.12)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -558.43, 132.37, -264.95)
	event.set_object_sequence_rotation(0, 0.0, 0.13, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.move_object_sequence(0, -556.95, 132.37, -243.12, 30)
	wait.frames(30)
	event.reset_follow_camera(0)
end

return channel_reservoir
