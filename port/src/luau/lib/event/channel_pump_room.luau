--!strict
--- Event helpers specific to the Channel Pump Room.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local channel_pump_room = {}

--- Loops over the given frame count without changing the projection.
function channel_pump_room.count_projection_frames(start_projection: f32, end_projection: f32, frame_count: s32, unused_3: any)
	local frame: s32 = 0
	frame = 0
	local _ = frame < frame_count
	frame = frame + 1
end

--- Interpolates the event projection linearly over the given number of frames.
function channel_pump_room.interpolate_projection(start_projection: f32, end_projection: f32, frame_count: any, unused_3: any)
	local frame: s32 = 0
	local projection_step: any = 0
	frame = 0
	projection_step = vm.fdiv(vm.ftoi(vm.f32(end_projection - start_projection)), frame_count)
	while frame < frame_count do
		event.set_event_projection(start_projection + vm.wrap(projection_step * frame))
		vm.wait(1)
		frame = vm.i32(frame + 1)
	end
end

--- Loads the map sounds of the Channel Pump Room.
function channel_pump_room.load_map_sounds()
	event.load_map_sounds(1684)
end

--- Sets the opening camera view and sweeps the camera across the room while waiting for it to finish.
function channel_pump_room.pan_camera_across_room(sound_bank: any)
	event.set_camera_position(-393.89, 100.04, -2.57)
	event.set_camera_look_at(-194.23, 107.31, -159.8)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.move_camera_sequence_eased(-393.89, 100.04, -2.57, -266.2, 107.31, 189.14, 150, 0, 0.4)
	camera.wait_until_done()
end

--- Places the first character and the enlarged elephant for the scene and waits for them.
function channel_pump_room.place_elephant_scene(unused_argument: any)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -0.79, 50.09, 122.71)
	event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.set_character_active(1, 8)
	event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(1, 1.5, 1.5, 1.5)
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
end

--- Does nothing in place of place_elephant_scene when the event is skipped.
function channel_pump_room.place_elephant_scene_skipping(unused_argument: any)
	cutscene.skip_command(0)
	cutscene.skip_command(1)
	wait.background_load_skipping()
end

--- Plays the skippable Channel Pump Room arrival cutscene with Mints, Polcurse and the elephant, then restores the dungeon state and places the dungeon monster.
function channel_pump_room.play_arrival_cutscene()
	local index: s32 = 0
	local sound_bank: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local part_x: f32 = 0
	local part_y: f32 = 0
	local part_z: f32 = 0
	local image_block: s32 = 0
	local step: number = 0
	vm.section(function()
		event.set_save_flag(103, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_map_sounds(1810)
		sound_bank = event.load_sound_effect_file_2(1810) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.load_message_file(0, 5, "event/e100/e103/e103_1.txt")
		event.load_character_motion_pack(5, "event/e100/e103/e103_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 50.0, 0.0)
		event.attach_object_handle_to_character(5, 1)
		event.set_object_handle_visible(5, 0)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(6, 0)
		event.load_character(5, "event/e100/e103/e103_polcurse.gltf", "info", 9)
		event.set_character_position(9, -4.99, 134.6, -43.13)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(2, 9)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 50.0, 0.0)
		event.load_character(5, "event/e100/e103/e103_erephant.gltf", "info", 8)
		event.set_character_position(8, 0.0, 50.0, 0.0)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 50.0, 0.0)
		event.load_character(5, "event/helpreceiver/helpreceiver.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_character_to_frame(0, "ef00", 10)
		event.attach_object_handle_to_map_part_3(4, "p08_s06", "s06_08-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		do
			local out1, out2, out3 = event.get_object_handle_position(4)
			part_x = out1 or part_x
			part_y = out2 or part_y
			part_z = out3 or part_z
		end
		event.fade_out_screen(0)
		event.stop_music(0)
		step = 1
		wait.frames(4)
		event.load_music(107)
		event.set_object_handle_footstep_sound(0, 3)
		image_block = event.load_event_image_4(5, "textures/event/e100/e107/e107telop01_1.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e107telop01", image_block)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 320, 334)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_scale(0, 1.0, 1.0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.enable_drama_skip()
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(150.75, 339.49, 988.43)
		event.set_camera_sequence_look_at(14.77, 282.74, 1151.7)
		event.set_object_sequence_position(0, 9.04, 262.0, 1196.55)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "下見顔")
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.move_object_sequence(4, 2.90684, 412.375, 1188.04, 30)
		step = 2
		object.wait_until_done(4)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 13.2, 262.0, 1143.62, 50)
		step = 3
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 27)
		event.jump_object_sequence(4, 2.90684, 312.375, 1188.04, -0.2, 10)
		event.jump_object_sequence(4, 2.90684, 312.375, 1188.04, -0.2, 8)
		event.jump_object_sequence(4, 2.90684, 312.375, 1188.04, -0.2, 5)
		step = 4
		wait.frames(40)
		event.set_camera_sequence_position(-23.49, 275.36, 1099.63)
		event.set_camera_sequence_look_at(-3.07, 281.91, 1122.03)
		event.set_object_sequence_position(0, -2.57, 262.0, 1128.46)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 5
		message.show_voiced_for(1030010, 45)
		event.reset_mouth_texture_animations()
		event.open_voice_stream_wave(1, 1030015)
		step = 6
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.set_object_sequence_motion(0, "上を見る", 6, 0.07, 1)
		event.delay_object_sequence_motion_track(0, 42)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "上を見るL", 0, -1.0)
		event.move_camera_sequence_eased(-104.82, 278.13, 1040.91, -24.27, 291.72, 1075.2, 90, 2, 0.4)
		step = 7
		object.wait_until_done(0)
		event.close_voice_stream(1)
		step = 8
		camera.wait_until_done()
		event.set_camera_sequence_position(-2.2, 288.45, 1166.72)
		event.set_camera_sequence_look_at(-2.58, 285.44, 1130.54)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -2.98, 262.0, 1102.83, 60)
		event.move_camera_sequence_eased(-1.51, 288.45, 1196.6, -2.58, 285.44, 1130.54, 60, 2, 0.4)
		step = 9
		wait.frames(60)
		event.set_character_active(1, 10)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.move_object_sequence(0, -25.96, 262.0, 1001.65, 90)
		event.set_camera_sequence_follow_object(0, 0.0, 20.0, 0.0, 1.67, 0.85, 38.91)
		event.set_object_sequence_motion(0, "レシーバーを取り出す(歩き中)", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "レシーバー歩き", 4)
		event.play_sound_effect(sound_bank, 0)
		step = 10
		wait.until_motion_progress_counted(0, vm.f32(0.45), -1.0, 30)
		event.play_sound_effect(sound_bank, 1)
		step = 11
		wait.frames(10)
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "レシーバー立ち", 0, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 12
		message.show_voiced(1030020)
		event.reset_mouth_texture_animations()
		step = 13
		object.wait_until_done(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(-25.76, 295.42, 1049.41)
		event.set_camera_sequence_look_at(-24.18, 286.8, 1002.8)
		step = 14
		message.show_voiced(1030030)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 15
		message.show_voiced(1030031)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 16
		message.show_voiced(1030040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "レシーバーをなおす", 2)
		event.wait_object_sequence_motion_end(0)
		step = 17
		wait.until_motion_progress_counted(0, vm.f32(0.275), -1.0, 30)
		event.play_sound_effect(sound_bank, 2)
		step = 18
		wait.until_motion_progress_counted(0, vm.f32(0.6), -1.0, 30)
		event.play_sound_effect(sound_bank, 3)
		step = 19
		object.wait_until_done(0)
		event.detach_character_from_frame(10)
		event.set_camera_sequence_position(-8.24, 302.09, 593.73)
		event.set_camera_sequence_look_at(18.03, 282.04, 991.15)
		event.set_object_sequence_position(0, 18.03, 262.04, 991.15)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 180)
		event.add_object_sequence_path_point(0, 18.03, 262.04, 991.15)
		event.add_object_sequence_path_point(0, 35.05, 262.04, 991.16)
		event.add_object_sequence_path_point(0, 63.63, 262.04, 998.35)
		event.add_object_sequence_path_point(0, 106.4, 262.04, 1000.0)
		event.add_object_sequence_path_point(0, 141.73, 262.04, 990.16)
		event.add_object_sequence_path_point(0, 155.42, 262.04, 953.13)
		event.add_object_sequence_path_point(0, 152.72, 262.04, 922.35)
		event.add_object_sequence_path_point(0, 131.69, 262.04, 909.25)
		event.add_object_sequence_path_point(0, 116.83, 262.04, 907.18)
		event.add_object_sequence_path_point(0, 65.0, 247.21, 908.16)
		event.add_object_sequence_path_point(0, -16.98, 216.58, 908.0)
		event.add_object_sequence_path_point(0, -72.6, 197.65, 908.51)
		event.add_object_sequence_path_point(0, -145.02, 171.37, 906.89)
		event.start_object_sequence_path(0)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(150)
		event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
		step = 20
		vm.wait(20)
		index = 0
		while index < 180 do
			if index == 50 then
				event.set_object_handle_footstep_sound(0, 6)
			end
			do
				local out1, out2, out3 = event.get_character_position(0)
				character_x = out1 or character_x
				character_y = out2 or character_y
				character_z = out3 or character_z
			end
			event.set_camera_sequence_look_at(character_x, character_y + 20.0, character_z)
			step = 21
			vm.wait(21)
			index = index + 1
		end
		event.set_object_handle_footstep_sound(0, 2)
		event.fade_in_screen(30)
		event.set_camera_sequence_position(-12.28, 87.78, 633.3)
		event.set_camera_sequence_look_at(-12.36, 76.05, 565.41)
		event.set_object_sequence_position(0, -12.17, 50.0, 540.63)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -12.27, 50.0, 462.63, 60)
		index = 0
		while index < 60 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				character_x = out1 or character_x
				character_y = out2 or character_y
				character_z = out3 or character_z
			end
			event.set_camera_sequence_look_at(character_x, character_y + 20, character_z)
			if index == 40 then
				event.play_sound_effect(sound_bank, 4)
			end
			step = 22
			vm.wait(22)
			index = index + 1
		end
		event.set_camera_sequence_position(10.57, 80.17, 211.98)
		event.set_camera_sequence_look_at(-4.39, 74.32, 228.85)
		event.set_object_sequence_position(0, -5.05, 50.0, 232.5)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上を見る", 4, 0.07, 1)
		step = 23
		wait.frames(15)
		event.set_camera_sequence_position(-3.08, 61.16, 277.13)
		event.set_camera_sequence_look_at(-4.35, 72.53, 230.25)
		event.set_object_sequence_position(0, -5.05, 50.0, 232.5)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.move_camera_sequence_eased(-3.08, 61.16, 277.13, -4.35, 103.53, 230.25, 30, 0, 0.2)
		step = 24
		wait.frames(36)
		event.set_character_active(1, 8)
		event.set_camera_sequence_position(-4.16, 185.18, 12.13)
		event.set_camera_sequence_look_at(-2.93, 793.4, -5.89)
		event.set_object_sequence_position(1, 0.0, 704.73, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "落下中", 4)
		event.move_object_sequence(1, 0.0, 30.0, 0.0, 20)
		event.move_camera_sequence(-4.82, 50.61, 21.76, -2.93, 793.4, -5.89, 20)
		step = 25
		wait.frames(14)
		event.set_camera_sequence_position(28.38, 59.5, 119.0)
		event.set_camera_sequence_look_at(15.11, 66.61, 96.74)
		event.set_object_sequence_position(0, -3.97, 50.0, 82.73)
		event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
		event.set_object_sequence_position(1, 0.0, 95.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.move_object_sequence(1, 0.0, 50.0, 0.0, 6)
		event.set_object_sequence_motion(0, "象着地", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "象着地L")
		event.set_object_sequence_motion(1, "着地", 6)
		event.delay_camera_sequence_shake_track(6)
		event.shake_camera_sequence(0.0, 1.5, 0.0, 24)
		step = 26
		wait.frames(6)
		event.play_music(0)
		step = 27
		wait.frames(48)
		event.set_camera_sequence_position(8.34, 76.37, 68.31)
		event.set_camera_sequence_look_at(-3.92, 73.89, 83.97)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "びっくり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 28
		message.show_voiced(1030050)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(8.61, 67.77, 124.88)
		event.set_camera_sequence_look_at(1.17, 71.56, 84.8)
		event.set_object_sequence_rotation(0, 0.0, 2.9, 0.0)
		event.move_camera_sequence_eased(8.61, 67.77, 124.88, 1.17, 77.23, 84.8, 44, 2, 0.4)
		event.set_object_sequence_motion(1, "パオーン", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		step = 29
		wait.frames(15)
		event.play_sound_effect(sound_bank, 5)
		step = 30
		wait.frames(37)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 24)
		step = 31
		wait.frames(42)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(91.06, 185.9, -66.26)
		event.set_camera_sequence_look_at(-6.23, 91.91, 17.07)
		event.set_object_sequence_position(0, -6.67, 50.0, 84.81)
		event.set_object_sequence_rotation(0, 0.0, 2.9, 0.0)
		event.set_object_sequence_position(2, -4.73, 162.38, -24.57)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "浮遊", 4)
		event.move_object_sequence_eased(2, -4.73, 106.52, -24.57, 60, 2, 0.3)
		event.play_sound_effect(sound_bank, 6)
		step = 32
		object.wait_until_done(2)
		event.set_object_sequence_rotation(0, 0.0, 3.02, 0.0)
		event.set_camera_sequence_position(19.38, 59.94, 120.28)
		event.set_camera_sequence_look_at(1.66, 79.89, 71.18)
		event.set_object_sequence_position(2, 11.92, 134.55, -43.71)
		event.set_object_sequence_rotation(2, 0.0, -0.24, 0.0)
		event.set_object_sequence_motion(0, "上を見るL", 6, -1.0, 1)
		event.set_mouth_texture_animations(2, "口パク1")
		step = 33
		message.show_voiced(1030060)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-5.96, 89.53, 73.98)
		event.set_camera_sequence_look_at(-6.81, 73.86, 87.67)
		event.set_object_sequence_motion(0, "ポルカスを見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "ポルカスを見るL")
		event.play_sound_effect(sound_bank, 7)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 34
		message.show_voiced(1030070)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(8.07, 126.01, 28.15)
		event.set_camera_sequence_look_at(8.5, 154.76, -34.87)
		step = 35
		wait.frames(15)
		event.set_mouth_texture_animations(2, "口パク1")
		step = 36
		message.show_voiced(1030080)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク1")
		step = 37
		message.show_voiced(1030081)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(16.03, 156.16, -10.64)
		event.set_camera_sequence_look_at(10.22, 165.33, -37.84)
		event.set_mouth_texture_animations(2, "口パク1")
		step = 38
		message.show_voiced(1030090)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク1")
		step = 39
		message.show_voiced(1030100)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク1")
		step = 40
		message.show_voiced(1030101)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(2, 1, "目とじ")
		event.set_object_sequence_motion(2, "うつむく", 6)
		event.queue_object_sequence_next_motion(2, "うつむくL", 0)
		step = 41
		wait.frames(9)
		event.set_mouth_texture_animations(2, "口パク1")
		step = 42
		message.show_voiced(1030110)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-5.1, 89.1, 58.36)
		event.set_camera_sequence_look_at(-6.56, 75.02, 78.7)
		event.play_sound_effect(sound_bank, 8)
		event.set_object_sequence_motion(0, "なんだって！", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "なんだって！L", 0)
		step = 43
		wait.frames(10)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 44
		message.show_voiced(1030120)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(4.77, 158.81, -12.71)
		event.set_camera_sequence_look_at(14.01, 169.3, -54.18)
		event.set_object_sequence_texture_animation(2, 1, "目こらし")
		event.set_object_sequence_motion(2, "ウフフフ", 4)
		event.set_mouth_texture_animations(2, "口パク1")
		step = 45
		message.show_voiced(1030130)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(30.18, 182.63, -12.61)
		event.set_camera_sequence_look_at(-15.36, 101.5, 68.2)
		event.set_object_sequence_position(0, -6.39, 50.0, 102.82)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_position(2, -1.72, 117.17, 22.1)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.set_object_sequence_motion(2, "浮遊", 4)
		event.play_sound_effect(sound_bank, 9)
		event.set_mouth_texture_animations(2, "口パク1")
		step = 46
		message.show_voiced(1030140)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_rotation(0, 0.0, 3.02, 0.0)
		event.set_object_sequence_position(2, 3.77, 134.08, 27.37)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_camera_sequence_position(9.35, 66.39, 80.83)
		event.set_camera_sequence_look_at(-6.04, 71.48, 99.69)
		event.set_object_sequence_motion(0, "考える", 6)
		event.queue_object_sequence_next_motion(0, "考えるL", 0)
		step = 47
		wait.frames(15)
		step = 48
		message.show_voiced(1030150)
		event.set_camera_sequence_position(1.44, 167.15, 61.09)
		event.set_camera_sequence_look_at(3.34, 165.04, 30.8)
		event.set_object_sequence_motion(2, "腹を突き出す", 4)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "浮遊", 4)
		event.set_mouth_texture_animations(2, "口パク1")
		step = 49
		message.show_voiced(1030160)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-21.79, 178.71, -1.18)
		event.set_camera_sequence_look_at(0.55, 132.61, 42.24)
		event.set_object_sequence_position(2, 2.65, 122.38, 24.68)
		event.set_object_sequence_rotation(2, 0.0, -0.36, 0.0)
		event.play_sound_effect(sound_bank, 10)
		event.set_object_sequence_motion(0, "おことわりだよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "おことわりだよL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 50
		message.show_voiced(1030170)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_position(2, 3.77, 134.08, 27.37)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_camera_sequence_position(-13.53, 78.7, 80.84)
		event.set_camera_sequence_look_at(-6.17, 72.32, 101.95)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 51
		message.show_voiced(1030180)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(1.35, 150.19, 59.87)
		event.set_camera_sequence_look_at(3.64, 164.72, 27.05)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "プルプル", 4)
		event.set_mouth_texture_animations(2, "おこり口パク")
		step = 52
		message.show_voiced(1030190)
		event.reset_mouth_texture_animations()
		event.set_object_handle_visible(5, 1)
		event.set_object_handle_visible(6, 1)
		step = 53
		channel_pump_room.play_elephant_attack_order(sound_bank)
		step = 54
		channel_pump_room.place_elephant_scene(sound_bank)
		event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 0.0, 15)
		event.fade_out_screen(30)
		step = 55
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 1 then
			cutscene.skip_command(4)
		end
		if step <= 2 then
			cutscene.skip_command(0)
		end
		if step <= 3 then
			wait.frames_skipping(40)
		end
		if step <= 4 then
			message.show_voiced_for_skipping(1030010, 45)
		end
		if step <= 5 then
			cutscene.skip_command(1)
		end
		if step <= 6 then
			cutscene.skip_command(0)
		end
		if step <= 7 then
			wait.background_load_skipping()
		end
		if step <= 8 then
			wait.frames_skipping(60)
		end
		if step <= 9 then
			channel_pump_room.skip_motion_wait(0, vm.f32(0.45), -1.0, 30)
		end
		if step <= 10 then
			wait.frames_skipping(10)
		end
		if step <= 11 then
			message.show_voiced_skipping(1030020)
		end
		if step <= 12 then
			cutscene.skip_command(0)
		end
		if step <= 13 then
			message.show_voiced_skipping(1030030)
		end
		if step <= 14 then
			message.show_voiced_skipping(1030031)
		end
		if step <= 15 then
			message.show_voiced_skipping(1030040)
		end
		if step <= 16 then
			channel_pump_room.skip_motion_wait(0, vm.f32(0.275), -1.0, 30)
		end
		if step <= 17 then
			channel_pump_room.skip_motion_wait(0, vm.f32(0.6), -1.0, 30)
		end
		if step <= 18 then
			cutscene.skip_command(0)
		end
		if step <= 20 then
			index = 0
		end
		if step <= 21 then
			local _ = index < 180
			local _ = index == 50
			index = index + 1
			index = 0
		end
		if step <= 22 then
			local _ = index < 60
			local _ = index == 40
			index = index + 1
			wait.frames_skipping(15)
		end
		if step <= 23 then
			wait.frames_skipping(36)
		end
		if step <= 24 then
			wait.frames_skipping(14)
		end
		if step <= 25 then
			wait.frames_skipping(6)
		end
		if step <= 26 then
			wait.frames_skipping(48)
		end
		if step <= 27 then
			message.show_voiced_skipping(1030050)
		end
		if step <= 28 then
			wait.frames_skipping(15)
		end
		if step <= 29 then
			wait.frames_skipping(37)
		end
		if step <= 30 then
			wait.frames_skipping(42)
		end
		if step <= 31 then
			cutscene.skip_command(2)
		end
		if step <= 32 then
			message.show_voiced_skipping(1030060)
		end
		if step <= 33 then
			message.show_voiced_skipping(1030070)
		end
		if step <= 34 then
			wait.frames_skipping(15)
		end
		if step <= 35 then
			message.show_voiced_skipping(1030080)
		end
		if step <= 36 then
			message.show_voiced_skipping(1030081)
		end
		if step <= 37 then
			message.show_voiced_skipping(1030090)
		end
		if step <= 38 then
			message.show_voiced_skipping(1030100)
		end
		if step <= 39 then
			message.show_voiced_skipping(1030101)
		end
		if step <= 40 then
			wait.frames_skipping(9)
		end
		if step <= 41 then
			message.show_voiced_skipping(1030110)
		end
		if step <= 42 then
			wait.frames_skipping(10)
		end
		if step <= 43 then
			message.show_voiced_skipping(1030120)
		end
		if step <= 44 then
			message.show_voiced_skipping(1030130)
		end
		if step <= 45 then
			message.show_voiced_skipping(1030140)
		end
		if step <= 46 then
			wait.frames_skipping(15)
		end
		if step <= 47 then
			message.show_voiced_skipping(1030150)
		end
		if step <= 48 then
			message.show_voiced_skipping(1030160)
		end
		if step <= 49 then
			message.show_voiced_skipping(1030170)
		end
		if step <= 50 then
			message.show_voiced_skipping(1030180)
		end
		if step <= 51 then
			message.show_voiced_skipping(1030190)
		end
		if step <= 52 then
			channel_pump_room.say_attack_command_variant(sound_bank)
		end
		if step <= 53 then
			channel_pump_room.place_elephant_scene_skipping(sound_bank)
		end
		if step <= 54 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.reset_dungeon_timer()
	event.set_object_handle_footstep_sound(0, 0)
	event.attach_object_handle_to_map_part_3(4, "p08_s06", "s06_08-m1")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_position(4, part_x, part_y, part_z)
	step = 56
	vm.wait(56)
	event.attach_object_handle_to_character(5, 1)
	event.set_object_handle_visible(5, 1)
	event.attach_object_handle_to_character(6, 2)
	event.set_object_handle_visible(6, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(8)
	event.delete_character(10)
	event.stop_music(0)
	step = 57
	wait.frames(4)
	event.load_music(195)
	event.play_music(0)
	event.fade_in_screen(15)
	event.set_camera_position(-1.66, 76.3, 205.77)
	event.set_camera_look_at(-0.37, 74.98, 151.36)
	event.set_character_position(0, 0.0, 50.0, 138.0)
	event.set_character_rotation(0, 0.0, 3.02, 0.0)
	event.reset_follow_camera(0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.show_dungeon_status_bar(1)
	event.place_dungeon_monster(614, 0.0, 50.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end

--- Plays the pump room elephant ambush event using the e108c message file.
function channel_pump_room.play_elephant_ambush_event()
	local sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(108, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.allow_next_music_load()
		event.allow_next_map_sound_load()
		event.allow_next_music_play()
		event.load_map_sounds(1825)
		sound_bank = event.load_sound_effect_file_2(1825) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(6.02, 94.24, 399.23)
		event.set_camera_sequence_look_at(-4.96, 118.28, 117.71)
		event.load_character_motion_pack(5, "event/e100/e107/e107_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 9)
		event.set_character_active(1, 9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(1, sound_bank)
		event.load_character(5, "event/e100/e107/e107_erephant.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_shadow_enabled(2, 0)
		event.load_character(5, "event/e100/e107/e107_polcurse.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character(10, 1)
		event.set_object_handle_visible(10, 0)
		event.attach_object_handle_to_character(11, 2)
		event.set_object_handle_visible(11, 0)
		event.fade_out_screen(0)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(105)
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("砂煙e107")
		event.create_effect_work_buffer(5)
		event.load_message_file(0, 5, "event/e100/e108/e108c.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		channel_pump_room.play_steve_walk_and_jump_variant(sound_bank)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "ぱちぱち")
		channel_pump_room.play_elephant_landing_variant(sound_bank)
		cutscene.skip_value_command(sound_bank)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "わらい顔")
		channel_pump_room.play_elephant_conversation(sound_bank)
		event.fade_out_screen(15)
		wait.for_frame_count(15)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 1)
	event.attach_object_handle_to_character(10, 1)
	event.set_object_handle_visible(10, 1)
	event.attach_object_handle_to_character(11, 2)
	event.set_object_handle_visible(11, 1)
	event.clear_effect_manager()
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(11)
	event.reset_follow_camera(0)
	event.switch_dungeon_main_character(2)
	event.set_playable_character(2)
	event.delete_character(10)
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(190)
	event.play_music(0)
	event.set_camera_position(-372.02, 97.7, 1.24)
	event.set_camera_look_at(-275.93, 89.37, -1.57)
	event.reset_follow_camera(0)
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.set_character_active(1, 0)
	event.set_character_position(0, -240.84, 50.0, -5.32)
	event.set_character_rotation(0, 0.0, 1.6, 0.0)
	event.show_dungeon_status_bar(1)
	event.fade_in_screen(30)
	event.place_dungeon_monster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
	event.finish_event()
end

--- Plays the pump room elephant ambush event using the e108c_1 message file and frame waits.
function channel_pump_room.play_elephant_ambush_event_variant()
	local sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(108, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.allow_next_music_load()
		event.allow_next_map_sound_load()
		event.allow_next_music_play()
		event.load_map_sounds(1825)
		sound_bank = event.load_sound_effect_file_2(1825) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(6.02, 94.24, 399.23)
		event.set_camera_sequence_look_at(-4.96, 118.28, 117.71)
		event.load_character_motion_pack(5, "event/e100/e107/e107_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 9)
		event.set_character_active(1, 9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(1, sound_bank)
		event.load_character(5, "event/e100/e107/e107_erephant.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_shadow_enabled(2, 0)
		event.load_character(5, "event/e100/e107/e107_polcurse.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character(10, 1)
		event.set_object_handle_visible(10, 0)
		event.attach_object_handle_to_character(11, 2)
		event.set_object_handle_visible(11, 0)
		event.fade_out_screen(0)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(105)
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("砂煙e107")
		event.create_effect_work_buffer(5)
		event.load_message_file(0, 5, "event/e100/e108/e108c_1.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		channel_pump_room.play_steve_walk_and_jump(sound_bank)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "ぱちぱち")
		channel_pump_room.play_elephant_landing_scene(sound_bank)
		cutscene.skip_value_command(sound_bank)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "わらい顔")
		channel_pump_room.play_polcurse_taunt(sound_bank)
		event.fade_out_screen(15)
		wait.frames(15)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 1)
	event.attach_object_handle_to_character(10, 1)
	event.set_object_handle_visible(10, 1)
	event.attach_object_handle_to_character(11, 2)
	event.set_object_handle_visible(11, 1)
	event.clear_effect_manager()
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(11)
	event.reset_follow_camera(0)
	event.switch_dungeon_main_character(2)
	event.set_playable_character(2)
	event.delete_character(10)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(190)
	event.play_music(0)
	event.set_camera_position(-372.02, 97.7, 1.24)
	event.set_camera_look_at(-275.93, 89.37, -1.57)
	event.reset_follow_camera(0)
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.set_character_active(1, 0)
	event.set_character_position(0, -240.84, 50.0, -5.32)
	event.set_character_rotation(0, 0.0, 1.6, 0.0)
	event.show_dungeon_status_bar(1)
	event.fade_in_screen(30)
	event.place_dungeon_monster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
	event.finish_event()
end

--- Shows Polcurse commanding the elephant to attack while the camera sweeps in.
function channel_pump_room.play_elephant_attack_command(sound_bank: s32)
	event.set_camera_sequence_position(-31.39, 240.49, -36.86)
	event.set_camera_sequence_look_at(21.64, 234.04, -106.15)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -0.79, 50.09, 122.71)
	event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(2, 25.82, 208.06, -111.43)
	event.set_object_sequence_rotation(2, 0.0, -0.96, 0.0)
	event.set_object_sequence_scale(2, 1.0, 1.0, 1.0)
	event.set_character_active(1, 8)
	event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(1, 1.5, 1.5, 1.5)
	event.move_camera_sequence_eased(-256.22, 55.22, 128.24, 76.97, 161.85, -3.41, 24, 1, 0.4)
	event.delay_camera_sequence_position_track(24)
	event.set_camera_sequence_position(3.97, 70.67, 202.31)
	event.set_camera_sequence_look_at(-0.77, 76.22, 76.84)
	event.delay_object_sequence_motion_track(0, 24)
	event.delay_object_sequence_position_track(0, 24)
	event.delay_object_sequence_rotation_track(0, 24)
	event.set_object_sequence_position(0, -0.79, 50.09, 122.71)
	event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.set_object_sequence_motion(2, "殺っておしまい", 2)
	event.queue_object_sequence_next_motion(2, "殺っておしまいL", 0)
	event.set_object_sequence_motion(1, "パオーン", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.delay_camera_sequence_shake_track(52)
	event.shake_camera_sequence(0.0, 1.3, 0.0, 24)
	event.play_sound_effect(sound_bank, 11)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 30)
	event.set_mouth_texture_animations(2, "おこり口パク")
	message.show_voiced_for_stopping(1030200, 100)
	event.reset_mouth_texture_animations()
	camera.wait_until_done()
	object.wait_until_done(2)
end

--- Shows Polcurse ordering the elephant to attack while the elephant trumpets, with a sound effect and a voiced line.
function channel_pump_room.play_elephant_attack_order(sound_bank: s32)
	event.set_camera_sequence_position(-31.39, 240.49, -36.86)
	event.set_camera_sequence_look_at(21.64, 234.04, -106.15)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -0.79, 50.09, 122.71)
	event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(2, 25.82, 208.06, -111.43)
	event.set_object_sequence_rotation(2, 0.0, -0.96, 0.0)
	event.set_object_sequence_scale(2, 1.0, 1.0, 1.0)
	event.set_character_active(1, 8)
	event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(1, 1.5, 1.5, 1.5)
	event.move_camera_sequence_eased(-256.22, 55.22, 128.24, 76.97, 161.85, -3.41, 24, 1, 0.4)
	event.delay_camera_sequence_position_track(24)
	event.set_camera_sequence_position(3.97, 70.67, 202.31)
	event.set_camera_sequence_look_at(-0.77, 76.22, 76.84)
	event.delay_object_sequence_motion_track(0, 24)
	event.delay_object_sequence_position_track(0, 24)
	event.delay_object_sequence_rotation_track(0, 24)
	event.set_object_sequence_position(0, -0.79, 50.09, 122.71)
	event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.set_object_sequence_motion(2, "殺っておしまい", 2)
	event.queue_object_sequence_next_motion(2, "殺っておしまいL", 0)
	event.set_object_sequence_motion(1, "パオーン", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.delay_camera_sequence_shake_track(52)
	event.shake_camera_sequence(0.0, 1.3, 0.0, 24)
	event.play_sound_effect(sound_bank, 11)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 30)
	event.set_mouth_texture_animations(2, "おこり口パク")
	message.show_voiced_for(1030200, 100)
	event.reset_mouth_texture_animations()
	camera.wait_until_done()
	object.wait_until_done(2)
end

--- Stages the elephant's trumpeting and Polcurse's voiced dialogue with camera movement.
function channel_pump_room.play_elephant_conversation(sound_bank: s32)
	event.set_camera_sequence_position(-44.56, 149.8, 16.49)
	event.set_camera_sequence_look_at(29.9, 155.39, 35.57)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_rotation(2, 0.0, -1.32, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.set_object_sequence_motion(2, "立ち", 4)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 35.03, 137.05, 41.92)
	event.set_object_sequence_rotation(3, 0.0, -1.92, 0.0)
	event.play_sound_effect(sound_bank, 6)
	event.set_object_sequence_motion(3, "まわる", 6)
	event.queue_object_sequence_next_motion(3, "会話")
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1080070)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.play_sound_effect(sound_bank, 8)
	event.set_object_sequence_motion(2, "パオーン", 6)
	event.queue_object_sequence_next_motion(2, "立ち", 0)
	event.set_object_sequence_motion(3, "指差す", 6)
	event.move_camera_sequence_eased(-158.84, 98.6, 40.59, 12.88, 114.56, 18.64, 10, 1, 0.3)
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced_for_stopping(1080075, 100)
	event.reset_mouth_texture_animations()
	object.wait_until_done(2)
	object.wait_until_done(3)
end

--- Plays the skippable elephant cutscene with Steve, then restores the dungeon state and places the monster.
function channel_pump_room.play_elephant_cutscene()
	local sound_bank: s32 = 0
	local image_block: s32 = 0
	vm.section(function()
		event.set_save_flag(107, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.fade_out_screen(0)
		event.allow_next_music_load()
		event.allow_next_map_sound_load()
		event.allow_next_music_play()
		event.load_map_sounds(1816)
		sound_bank = event.load_sound_effect_file_2(1816) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(6.02, 94.24, 399.23)
		event.set_camera_sequence_look_at(-4.96, 118.28, 117.71)
		event.load_character_motion_pack(5, "event/e100/e107/e107_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e107/e107_steve.gltf", "info", 9)
		event.set_character_active(1, 9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e107/e107_erephant.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_shadow_enabled(2, 0)
		event.load_character(5, "event/e100/e107/e107_polcurse.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character(10, 1)
		event.set_object_handle_visible(10, 0)
		event.attach_object_handle_to_character(10, 2)
		event.set_object_handle_visible(10, 0)
		event.load_message_file(0, 5, "event/e100/e107/e107_1.txt")
		image_block = event.load_event_image_4(5, "textures/event/e100/e107/e107telop01_1.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e107telop01", image_block)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 320, 318)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_scale(0, 1.0, 1.0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(20, 0)
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("砂煙e107")
		event.create_effect_work_buffer(5)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(105)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		channel_pump_room.play_steve_walk_in(sound_bank)
		channel_pump_room.play_steve_jump_landing(sound_bank)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "ぱちぱち")
		channel_pump_room.play_puzzled_reaction(sound_bank)
		channel_pump_room.pan_camera_across_room(sound_bank)
		channel_pump_room.reset_party_standing(sound_bank)
		channel_pump_room.play_elephant_landing(sound_bank)
		cutscene.skip_value_command(sound_bank)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "びっくり顔")
		event.set_object_sequence_texture_animation(0, 1, "ぱちぱち2")
		channel_pump_room.play_startled_reaction(sound_bank)
		channel_pump_room.play_polcurse_descent(sound_bank)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "わらい顔")
		channel_pump_room.play_polcurse_scolding_variant(sound_bank)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 0.0, 15)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	event.stop_sound_effect(sound_bank, 0)
	event.attach_object_handle_to_character(10, 1)
	event.set_object_handle_visible(10, 1)
	event.attach_object_handle_to_character(11, 2)
	event.set_object_handle_visible(11, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(11)
	event.reset_follow_camera(0)
	event.switch_dungeon_main_character(2)
	event.set_playable_character(2)
	event.set_object_handle_shadow_enabled(2, 1)
	event.delete_character(10)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.set_camera_position(-372.02, 97.7, 1.24)
	event.set_camera_look_at(-275.93, 89.37, -1.57)
	event.reset_follow_camera(0)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(190)
	event.play_music(0)
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.set_character_active(1, 0)
	event.set_character_position(0, -240.84, 50.0, -5.32)
	event.set_character_rotation(0, 0.0, 1.6, 0.0)
	event.fade_in_screen(30)
	event.show_dungeon_status_bar(1)
	event.place_dungeon_monster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
	event.finish_event()
end

--- Plays the skippable elephant cutscene including the elephant landing shot, then restores the dungeon state and places the monster.
function channel_pump_room.play_elephant_cutscene_with_landing()
	local sound_bank: s32 = 0
	local image_block: s32 = 0
	vm.section(function()
		event.set_save_flag(107, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.fade_out_screen(0)
		event.allow_next_music_load()
		event.allow_next_map_sound_load()
		event.allow_next_music_play()
		event.load_map_sounds(1816)
		sound_bank = event.load_sound_effect_file_2(1816) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(6.02, 94.24, 399.23)
		event.set_camera_sequence_look_at(-4.96, 118.28, 117.71)
		event.load_character_motion_pack(5, "event/e100/e107/e107_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e107/e107_steve.gltf", "info", 9)
		event.set_character_active(1, 9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e107/e107_erephant.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_shadow_enabled(2, 0)
		event.load_character(5, "event/e100/e107/e107_polcurse.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character(10, 1)
		event.set_object_handle_visible(10, 0)
		event.attach_object_handle_to_character(10, 2)
		event.set_object_handle_visible(10, 0)
		event.load_message_file(0, 5, "event/e100/e107/e107.txt")
		image_block = event.load_event_image_4(5, "textures/event/e100/e107/e107telop01.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e107telop01", image_block)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 320, 334)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_scale(0, 1.0, 1.0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(20, 0)
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("砂煙e107")
		event.create_effect_work_buffer(5)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(105)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		channel_pump_room.play_party_walk_in(sound_bank)
		channel_pump_room.play_steve_jump_landing_variant(sound_bank)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "ぱちぱち")
		channel_pump_room.play_puzzled_reaction(sound_bank)
		channel_pump_room.pan_camera_across_room(sound_bank)
		channel_pump_room.reset_party_standing(sound_bank)
		channel_pump_room.play_elephant_landing_with_extra_frame(sound_bank)
		cutscene.skip_value_command(sound_bank)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "びっくり顔")
		event.set_object_sequence_texture_animation(0, 1, "ぱちぱち2")
		channel_pump_room.play_startled_reaction(sound_bank)
		channel_pump_room.play_polcurse_descent(sound_bank)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "わらい顔")
		channel_pump_room.play_polcurse_scolding(sound_bank)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 0.0, 15)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	event.stop_sound_effect(sound_bank, 0)
	event.attach_object_handle_to_character(10, 1)
	event.set_object_handle_visible(10, 1)
	event.attach_object_handle_to_character(11, 2)
	event.set_object_handle_visible(11, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(11)
	event.reset_follow_camera(0)
	event.switch_dungeon_main_character(2)
	event.set_playable_character(2)
	event.set_object_handle_shadow_enabled(2, 1)
	event.delete_character(10)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.set_camera_position(-372.02, 97.7, 1.24)
	event.set_camera_look_at(-275.93, 89.37, -1.57)
	event.reset_follow_camera(0)
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(190)
	event.play_music(0)
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.set_character_active(1, 0)
	event.set_character_position(0, -240.84, 50.0, -5.32)
	event.set_character_rotation(0, 0.0, 1.6, 0.0)
	event.fade_in_screen(30)
	event.show_dungeon_status_bar(1)
	event.place_dungeon_monster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
	event.finish_event()
end

--- Fades in on the elephant and plays its death motion with sound.
function channel_pump_room.play_elephant_death(sound_bank: s32)
	event.set_camera_sequence_position(-158.38, 85.25, 3.62)
	event.set_camera_sequence_look_at(-34.81, 85.07, -0.49)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 0.0, 50.0, 0.0)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_scale(2, 1.3, 1.3, 1.3)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.play_sound_effect(sound_bank, 1)
	event.set_object_sequence_motion(2, "死", 6)
	event.wait_object_sequence_motion_end(2)
	object.wait_until_done(2)
end

--- Starts the music and shows the elephant landing with a camera shake.
function channel_pump_room.play_elephant_landing(sound_bank: s32)
	event.play_music(0)
	event.set_camera_sequence_position(-133.46, 84.21, 3.17)
	event.set_camera_sequence_look_at(44.81, 76.82, -5.13)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.play_sound_effect(sound_bank, 3)
	event.set_object_sequence_position(1, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 10.66, 50.0, -0.04)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.delay_camera_sequence_shake_track(6)
	event.shake_camera_sequence(0.0, 1.5, 0.0, 24)
	event.delay_camera_sequence_position_track(30)
	event.set_camera_sequence_position(82.22, 91.62, -68.3)
	event.set_camera_sequence_look_at(-234.51, 58.39, 145.67)
	event.set_object_sequence_motion(2, "着地", 6)
	event.wait_object_sequence_motion_end(2)
	wait.frames(43)
	event.play_sound_effect(sound_bank, 4)
	object.wait_until_done(2)
	camera.wait_until_done()
end

--- Starts the music and shows the elephant landing in front of the hero and Steve with a camera shake and sound effects.
function channel_pump_room.play_elephant_landing_scene(sound_bank: s32)
	event.stop_sound_effect(sound_bank, 1)
	event.play_sound_effect(sound_bank, 4)
	event.set_camera_sequence_position(-133.46, 84.21, 3.17)
	event.set_camera_sequence_look_at(44.81, 76.82, -5.13)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 10.66, 50.0, -0.04)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.play_music(0)
	event.delay_camera_sequence_shake_track(6)
	event.shake_camera_sequence(0.0, 1.5, 0.0, 24)
	event.delay_camera_sequence_position_track(30)
	event.set_camera_sequence_position(82.22, 91.62, -68.3)
	event.set_camera_sequence_look_at(-234.51, 58.39, 145.67)
	event.set_object_sequence_motion(2, "着地", 6)
	event.wait_object_sequence_motion_end(2)
	wait.frames(43)
	event.play_sound_effect(sound_bank, 5)
	object.wait_until_done(2)
	camera.wait_until_done()
end

--- Switches the music and shows the elephant landing with a camera shake.
function channel_pump_room.play_elephant_landing_variant(sound_bank: s32)
	event.stop_sound_effect(sound_bank, 1)
	event.play_sound_effect(sound_bank, 4)
	event.set_camera_sequence_position(-133.46, 84.21, 3.17)
	event.set_camera_sequence_look_at(44.81, 76.82, -5.13)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 10.66, 50.0, -0.04)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.play_music(0)
	event.delay_camera_sequence_shake_track(6)
	event.shake_camera_sequence(0.0, 1.5, 0.0, 24)
	event.delay_camera_sequence_position_track(30)
	event.set_camera_sequence_position(82.22, 91.62, -68.3)
	event.set_camera_sequence_look_at(-234.51, 58.39, 145.67)
	event.set_object_sequence_motion(2, "着地", 6)
	event.wait_object_sequence_motion_end(2)
	wait.for_frame_count(43)
	event.play_sound_effect(sound_bank, 5)
	object.wait_until_done(2)
	camera.wait_until_done()
end

--- Shows Steve standing and the elephant landing with a camera shake and sound effects. It waits one frame more before the landing sound.
function channel_pump_room.play_elephant_landing_with_extra_frame(sound_bank: s32)
	event.play_music(0)
	event.set_camera_sequence_position(-133.46, 84.21, 3.17)
	event.set_camera_sequence_look_at(44.81, 76.82, -5.13)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.play_sound_effect(sound_bank, 3)
	event.set_object_sequence_position(1, -240.84, 50.51, -5.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 10.66, 50.0, -0.04)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.delay_camera_sequence_shake_track(6)
	event.shake_camera_sequence(0.0, 1.5, 0.0, 24)
	event.delay_camera_sequence_position_track(30)
	event.set_camera_sequence_position(82.22, 91.62, -68.3)
	event.set_camera_sequence_look_at(-234.51, 58.39, 145.67)
	event.set_object_sequence_motion(2, "着地", 6)
	event.wait_object_sequence_motion_end(2)
	wait.for_frame_count(43)
	event.play_sound_effect(sound_bank, 4)
	object.wait_until_done(2)
	camera.wait_until_done()
end

--- Runs the short event in which the hero runs into the room while a map part rises, then drops and bounces into place.
function channel_pump_room.play_entrance_event()
	local sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_040.sound.json") or sound_bank
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_camera_position(133.95, 349.85, 995.49)
	event.set_camera_look_at(10.87, 287.26, 1174.06)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 3)
	event.set_character_active(1, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 3.0, 263.17, 1196.78)
	event.set_object_sequence_rotation(0, 0.0, -3.08, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.attach_object_handle_to_map_part_3(10, "p08_s06", "s06_08-m1")
	event.set_object_handle_visible(10, 1)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_object_sequence_position(10, 2.90684, 312.375, 1188.04)
	event.move_object_sequence(10, 2.90684, 412.375, 1188.04, 30)
	event.play_sound_effect(sound_bank, 0)
	event.fade_in_screen(30)
	wait.frames(15)
	event.set_object_sequence_motion(0, "走り")
	event.delay_object_sequence_motion_track(0, 30)
	event.set_object_sequence_motion(0, "立ち")
	event.move_object_sequence(0, 3.0, 263.17, 1131.27, 30)
	object.wait_until_done(0)
	object.wait_until_done(10)
	event.play_sound_effect(sound_bank, 1)
	event.jump_object_sequence(10, 2.90684, 312.375, 1188.04, -0.2, 10)
	event.jump_object_sequence(10, 2.90684, 312.375, 1188.04, -0.2, 8)
	event.jump_object_sequence(10, 2.90684, 312.375, 1188.04, -0.2, 5)
	wait.frames(40)
	event.show_dungeon_status_bar(1, 0.033333335)
	event.set_character_position(0, 3.0, 263.17, 1131.27)
	event.set_object_handle_position(10, 2.90684, 312.375, 1188.04)
	event.set_camera_look_at(3.0, 293.17, 1131.27)
	event.set_camera_position(3.0, 303.17, 1011.27)
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Shows the party looking up and recovering while the camera pulls back.
function channel_pump_room.play_party_look_up(unused_argument: any)
	event.set_camera_sequence_position(-350.38, 95.45, -59.38)
	event.set_camera_sequence_look_at(-418.26, 93.83, -69.21)
	event.set_object_sequence_motion(0, "上見戻り", 6, 0.06)
	event.set_object_sequence_motion(1, "上見戻り", 6, 0.06)
	event.wait_object_sequence_motion_end(0)
	event.wait_object_sequence_motion_end(1)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4, -1.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4, -1.0)
	event.move_camera_sequence_eased(-376.98, 95.45, -63.23, -418.26, 93.83, -69.21, 150, 2, 0.4)
	message.show_voiced(1080030)
	message.show_voiced(1080033)
	camera.wait_until_done()
end

--- Walks the hero and Steve away along the path while the screen fades to black.
function channel_pump_room.play_party_walk_away(unused_argument: any)
	event.set_camera_sequence_position(-501.66, 281.73, -144.66)
	event.set_camera_sequence_look_at(-757.43, 150.05, -3.21)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -739.96, 133.89, -9.49)
	event.set_object_sequence_rotation(0, 0.0, 1.2, 0.0)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -739.96, 133.89, -9.49)
	event.set_object_sequence_rotation(1, 0.0, 1.2, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.rotate_object_sequence(0, 0.0, -1.44, 0.0, 20)
	event.rotate_object_sequence(1, 0.0, -1.44, 0.0, 20)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(100)
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -915.85, 133.64, -6.02, 150)
	event.move_object_sequence(1, -915.85, 133.64, -6.02, 150)
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	camera.wait_until_done()
end

--- Fades in and walks the hero and Steve along the path while the camera pans, then cuts to a closer shot as they come to a stop.
function channel_pump_room.play_party_walk_in(unused_argument: any)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(200, 0.0, 0.0, 0.0)
	event.set_camera_sequence_position(1010.98, 218.14, -55.12)
	event.set_camera_sequence_look_at(-755.14, 237.29, -2.56)
	event.set_object_sequence_position(0, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.move_camera_sequence(64.12, 205.59, -18.9, -755.14, 157.59, -2.56, 120)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 120)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 120)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	wait.for_frame_count(120)
	camera.wait_until_done()
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	vm.wait(3)
	event.set_camera_sequence_position(-667.47, 186.39, -3.73)
	event.set_camera_sequence_look_at(-755.14, 160.61, -2.56)
	event.set_object_sequence_position(0, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 20)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 20)
	wait.for_frame_count(20)
	event.set_object_sequence_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "立ち（スティーブ）")
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	wait.for_frame_count(30)
end

--- Shows the elephant standing and Polcurse floating down into view with a sound effect.
function channel_pump_room.play_polcurse_descent(sound_bank: s32)
	event.set_camera_sequence_position(-185.33, 99.15, 43.77)
	event.set_camera_sequence_look_at(13.63, 115.02, 19.38)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 10.66, 50.0, -0.04)
	event.set_object_sequence_rotation(2, 0.0, -1.32, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.set_object_sequence_motion(2, "立ち", 4)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 35.03, 189.68, 41.92)
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.play_sound_effect(sound_bank, 6)
	event.set_object_sequence_motion(3, "浮遊", 4)
	event.move_object_sequence(3, 35.03, 137.05, 41.92, 100)
	object.wait_until_done(3)
end

--- Plays the pump room event in which Polcurse laughs and Steve jumps away.
function channel_pump_room.play_polcurse_escape_event()
	local sound_bank: s32 = 0
	local unassigned_sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(108, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		sound_bank = event.load_sound_effect_file_2(1822) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.set_camera_position(6.02, 94.24, 399.23)
		event.set_camera_look_at(-4.96, 118.28, 117.71)
		event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 0.0, 50.0, 0.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 9)
		event.set_character_active(1, 9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_position(9, 0.0, 50.0, 0.0)
		event.set_character_rotation(9, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(1, unassigned_sound_bank)
		event.load_character(5, "event/e100/e108/e108_erephant.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_character_position(10, 0.0, 50.0, 0.0)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_polcurse.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_character_position(11, 0.0, 50.0, 0.0)
		event.set_character_rotation(11, 0.0, 0.0, 0.0)
		event.set_character_texture_animation(11, 0, "口パク")
		event.attach_object_handle_to_character(10, 1)
		event.set_object_handle_visible(10, 0)
		event.attach_object_handle_to_character(11, 2)
		event.set_object_handle_visible(11, 0)
		event.load_message_file(0, 5, "event/e100/e108/e108b_1.txt")
		event.stop_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "たかわらい顔")
		event.set_object_handle_sound_bank(1, sound_bank)
		event.enable_drama_skip()
		channel_pump_room.play_polcurse_laugh_intro(sound_bank)
		channel_pump_room.play_polcurse_flee_taunt(sound_bank)
		channel_pump_room.play_steve_flee_jump(sound_bank)
		channel_pump_room.play_party_walk_away(sound_bank)
		cutscene.skip_value_command(sound_bank)
		cutscene.skip_value_command(sound_bank)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(7)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.finish_event()
end

--- Shows Polcurse taunting the party for running away and laughing, with two voiced lines.
function channel_pump_room.play_polcurse_flee_taunt(unused_argument: any)
	event.set_camera_sequence_position(-17.46, 142.28, 29.34)
	event.set_camera_sequence_look_at(1.26, 135.02, 26.5)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 1.21, 102.73, 26.08)
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.set_object_sequence_motion(3, "逃げちゃうの？", 4)
	event.set_object_sequence_texture_animation(3, 0)
	event.set_object_sequence_texture_animation(3, 1, "わらい顔2")
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1080050)
	event.reset_mouth_texture_animations()
	event.set_camera_sequence_position(-17.46, 142.28, 29.34)
	event.set_camera_sequence_look_at(1.26, 135.02, 26.5)
	event.set_object_sequence_texture_animation(3, 0)
	event.set_object_sequence_texture_animation(3, 1, "たかわらい顔")
	event.set_object_sequence_motion(3, "オーッホッホ", 4)
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1080060)
	event.reset_mouth_texture_animations()
	object.wait_until_done(3)
	camera.wait_until_done()
end

--- Shows Polcurse shouting and then flying upward along a spiral path.
function channel_pump_room.play_polcurse_flyaway(sound_bank: s32)
	event.set_camera_position(-480.46, 80.16, -12.91)
	event.set_camera_look_at(-259.64, 146.91, -128.27)
	event.set_character_position(0, -409.26, 50.0, -69.12)
	event.set_character_rotation(0, 0.0, 1.41, 0.0)
	event.set_character_position(9, -409.26, 50.0, -69.12)
	event.set_character_rotation(9, 0.0, 1.41, 0.0)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, -302.17, 113.58, -60.02)
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.set_object_sequence_motion(0, "上見L", 6)
	event.set_object_sequence_motion(1, "上見L", 6)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.play_sound_effect(sound_bank, 2)
	event.set_object_sequence_motion(3, "ウッキー", 4)
	event.set_mouth_texture_animations(3, "おこり口パク")
	message.show_voiced(1080020)
	event.reset_mouth_texture_animations()
	object.wait_until_done(3)
	wait.frames(30)
	event.move_camera_sequence_eased(-491.11, 58.84, -65.59, -180.4, 265.78, -14.82, 75, 2, 0.4)
	event.play_sound_effect(sound_bank, 3)
	event.clear_object_sequence_path(3)
	event.set_object_sequence_path_frames(3, 90)
	event.add_object_sequence_path_point(3, -302.17, 113.58, -60.02)
	event.add_object_sequence_path_point(3, -273.27, 162.52, -91.31)
	event.add_object_sequence_path_point(3, -277.61, 214.43, -63.38)
	event.add_object_sequence_path_point(3, -270.68, 254.99, -10.75)
	event.add_object_sequence_path_point(3, -258.74, 289.17, 32.34)
	event.add_object_sequence_path_point(3, -264.84, 267.38, 91.29)
	event.add_object_sequence_path_point(3, -274.53, 223.84, 104.42)
	event.add_object_sequence_path_point(3, -263.59, 171.46, 62.02)
	event.add_object_sequence_path_point(3, -241.79, 175.34, 11.82)
	event.add_object_sequence_path_point(3, -235.1, 208.28, -15.33)
	event.add_object_sequence_path_point(3, -215.1, 272.95, -30.99)
	event.add_object_sequence_path_point(3, -206.66, 335.24, -34.05)
	event.add_object_sequence_path_point(3, -186.98, 388.24, -30.99)
	event.add_object_sequence_path_point(3, -161.91, 455.92, -27.1)
	event.start_object_sequence_path(3)
	for frame = 0, 89 do
		event.set_object_sequence_rotation(3, 0.0, -1.71, 0.0)
		vm.wait(6)
	end
	object.wait_until_done(3)
	camera.wait_until_done()
	event.stop_sound_effect(sound_bank, 2)
end

--- Fades in on the elephant and Polcurse laughing with three lines of dialogue.
function channel_pump_room.play_polcurse_laugh_intro(sound_bank: s32)
	event.set_camera_sequence_position(-129.32, 99.43, 13.13)
	event.set_camera_sequence_look_at(-44.6, 102.72, 11.17)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_position(2, 9.11, 50.0, -10.14)
	event.set_object_sequence_rotation(2, 0.0, -1.44, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.set_object_sequence_motion(2, "立ち", 4)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 1.54, 105.26, 40.3)
	event.set_object_sequence_rotation(3, 0.0, -1.8, 0.0)
	event.set_object_sequence_motion(3, "オーッホッホ", 4)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.play_sound_effect(sound_bank, 1)
	event.set_object_sequence_motion(2, "パオーン", 6)
	event.queue_object_sequence_next_motion(2, "立ち", 0)
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1080040)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1080041)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1080042)
	event.reset_mouth_texture_animations()
	object.wait_until_done(2)
	object.wait_until_done(3)
end

--- Shows Polcurse laughing, sulking and pointing angrily while the elephant trumpets.
function channel_pump_room.play_polcurse_scolding(sound_bank: s32)
	event.set_camera_sequence_position(-44.56, 149.8, 16.49)
	event.set_camera_sequence_look_at(29.9, 155.39, 35.57)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_rotation(2, 0.0, -1.32, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 35.03, 137.05, 41.92)
	event.set_object_sequence_rotation(3, 0.0, -1.92, 0.0)
	event.play_sound_effect(sound_bank, 7)
	event.set_object_sequence_motion(3, "まわる", 6)
	event.queue_object_sequence_next_motion(3, "会話")
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1070040)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1070041)
	event.reset_mouth_texture_animations()
	event.delay_object_sequence_motion_track(3, 30)
	event.set_object_sequence_motion(3, "ぶぅ～", 6)
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1070042)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.play_sound_effect(sound_bank, 9)
	event.play_sound_effect(sound_bank, 10)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 128.0, 30)
	event.set_object_sequence_motion(2, "パオーン", 6)
	event.queue_object_sequence_next_motion(2, "立ち", 0)
	event.set_object_sequence_motion(3, "指差す", 6)
	event.move_camera_sequence_eased(-158.84, 98.6, 40.59, 12.88, 114.56, 18.64, 18, 1, 0.3)
	event.set_mouth_texture_animations(3, "おこり口パク")
	message.show_voiced_for_stopping(1070050, 120)
	event.reset_mouth_texture_animations()
	object.wait_until_done(2)
	object.wait_until_done(3)
	camera.wait_until_done()
end

--- Shows Polcurse laughing, sulking and pointing angrily while the elephant trumpets.
function channel_pump_room.play_polcurse_scolding_variant(sound_bank: s32)
	event.set_camera_sequence_position(-44.56, 149.8, 16.49)
	event.set_camera_sequence_look_at(29.9, 155.39, 35.57)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_rotation(2, 0.0, -1.32, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 35.03, 137.05, 41.92)
	event.set_object_sequence_rotation(3, 0.0, -1.92, 0.0)
	event.play_sound_effect(sound_bank, 7)
	event.set_object_sequence_motion(3, "まわる", 6)
	event.queue_object_sequence_next_motion(3, "会話")
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1070040)
	event.reset_mouth_texture_animations()
	event.delay_object_sequence_motion_track(3, 60)
	event.set_object_sequence_motion(3, "ぶぅ～", 6)
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1070042)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.play_sound_effect(sound_bank, 9)
	event.play_sound_effect(sound_bank, 10)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 128.0, 30)
	event.set_object_sequence_motion(2, "パオーン", 6)
	event.queue_object_sequence_next_motion(2, "立ち", 0)
	event.set_object_sequence_motion(3, "指差す", 6)
	event.move_camera_sequence_eased(-158.84, 98.6, 40.59, 12.88, 114.56, 18.64, 18, 1, 0.3)
	event.set_mouth_texture_animations(3, "おこり口パク")
	message.show_voiced_for(1070050, 120)
	event.reset_mouth_texture_animations()
	object.wait_until_done(2)
	object.wait_until_done(3)
	camera.wait_until_done()
end

--- Shows Polcurse laughing and pointing while the elephant trumpets.
function channel_pump_room.play_polcurse_taunt(sound_bank: s32)
	event.set_camera_sequence_position(-44.56, 149.8, 16.49)
	event.set_camera_sequence_look_at(29.9, 155.39, 35.57)
	event.set_character_active(0, 0)
	event.set_character_active(0, 9)
	event.set_character_active(1, 10)
	event.set_object_sequence_rotation(2, 0.0, -1.32, 0.0)
	event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
	event.set_object_sequence_motion(2, "立ち", 4)
	event.set_character_active(1, 11)
	event.set_object_sequence_position(3, 35.03, 137.05, 41.92)
	event.set_object_sequence_rotation(3, 0.0, -1.92, 0.0)
	event.play_sound_effect(sound_bank, 6)
	event.set_object_sequence_motion(3, "まわる", 6)
	event.queue_object_sequence_next_motion(3, "会話")
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced(1080070)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
	event.play_sound_effect(sound_bank, 8)
	event.set_object_sequence_motion(2, "パオーン", 6)
	event.queue_object_sequence_next_motion(2, "立ち", 0)
	event.set_object_sequence_motion(3, "指差す", 6)
	event.move_camera_sequence_eased(-158.84, 98.6, 40.59, 12.88, 114.56, 18.64, 10, 1, 0.3)
	event.set_mouth_texture_animations(3, "わらい口パク")
	message.show_voiced_for(1080075, 100)
	event.reset_mouth_texture_animations()
	object.wait_until_done(2)
	object.wait_until_done(3)
end

--- Plays the e103 event in which the hero enters the pump room, an elephant drops in and Polcurse taunts him, then places the dungeon monster.
function channel_pump_room.play_pump_room_intro_event()
	local index: s32 = 0
	local sound_bank: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local map_part_x: f32 = 0
	local map_part_y: f32 = 0
	local map_part_z: f32 = 0
	local telop_image: s32 = 0
	local section_index: number = 0
	vm.section(function()
		event.set_save_flag(103, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_map_sounds(1810)
		sound_bank = event.load_sound_effect_file_2(1810) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.load_message_file(0, 5, "event/e100/e103/e103.txt")
		event.load_character_motion_pack(5, "event/e100/e103/e103_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 50.0, 0.0)
		event.attach_object_handle_to_character(5, 1)
		event.set_object_handle_visible(5, 0)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(6, 0)
		event.load_character(5, "event/e100/e103/e103_polcurse.gltf", "info", 9)
		event.set_character_position(9, -4.99, 134.6, -43.13)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(2, 9)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 50.0, 0.0)
		event.load_character(5, "event/e100/e103/e103_erephant.gltf", "info", 8)
		event.set_character_position(8, 0.0, 50.0, 0.0)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 50.0, 0.0)
		event.load_character(5, "event/helpreceiver/helpreceiver.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_character_to_frame(0, "ef00", 10)
		event.attach_object_handle_to_map_part_3(4, "p08_s06", "s06_08-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		do
			local out1, out2, out3 = event.get_object_handle_position(4)
			map_part_x = out1 or map_part_x
			map_part_y = out2 or map_part_y
			map_part_z = out3 or map_part_z
		end
		event.fade_out_screen(0)
		event.stop_music(0)
		section_index = 1
		wait.for_frame_count(4)
		event.load_music(107)
		event.set_object_handle_footstep_sound(0, 3)
		telop_image = event.load_event_image_4(5, "textures/event/e100/e107/e107telop01.json", 0) or telop_image
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e107telop01", telop_image)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 320, 334)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_scale(0, 1.0, 1.0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.enable_drama_skip()
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(150.75, 339.49, 988.43)
		event.set_camera_sequence_look_at(14.77, 282.74, 1151.7)
		event.set_object_sequence_position(0, 9.04, 262.0, 1196.55)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "下見顔")
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.move_object_sequence(4, 2.90684, 412.375, 1188.04, 30)
		section_index = 2
		object.wait_until_done(4)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 13.2, 262.0, 1143.62, 50)
		section_index = 3
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 27)
		event.jump_object_sequence(4, 2.90684, 312.375, 1188.04, -0.2, 10)
		event.jump_object_sequence(4, 2.90684, 312.375, 1188.04, -0.2, 8)
		event.jump_object_sequence(4, 2.90684, 312.375, 1188.04, -0.2, 5)
		section_index = 4
		wait.for_frame_count(40)
		event.set_camera_sequence_position(-23.49, 275.36, 1099.63)
		event.set_camera_sequence_look_at(-3.07, 281.91, 1122.03)
		event.set_object_sequence_position(0, -2.57, 262.0, 1128.46)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 5
		message.show_voiced_for_stopping(1030010, 30)
		event.reset_mouth_texture_animations()
		event.open_voice_stream_wave(1, 1030015)
		section_index = 6
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.set_object_sequence_motion(0, "上を見る", 6, 0.07, 1)
		event.delay_object_sequence_motion_track(0, 42)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "上を見るL", 0, -1.0)
		event.move_camera_sequence_eased(-104.82, 278.13, 1040.91, -24.27, 291.72, 1075.2, 90, 2, 0.4)
		section_index = 7
		object.wait_until_done(0)
		event.close_voice_stream(1)
		section_index = 8
		camera.wait_until_done()
		event.set_camera_sequence_position(-2.2, 288.45, 1166.72)
		event.set_camera_sequence_look_at(-2.58, 285.44, 1130.54)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -2.98, 262.0, 1102.83, 60)
		event.move_camera_sequence_eased(-1.51, 288.45, 1196.6, -2.58, 285.44, 1130.54, 60, 2, 0.4)
		section_index = 9
		wait.for_frame_count(60)
		event.set_character_active(1, 10)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.move_object_sequence(0, -25.96, 262.0, 1001.65, 90)
		event.set_camera_sequence_follow_object(0, 0.0, 20.0, 0.0, 1.67, 0.85, 38.91)
		event.set_object_sequence_motion(0, "レシーバーを取り出す(歩き中)", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "レシーバー歩き", 4)
		event.play_sound_effect(sound_bank, 0)
		section_index = 10
		wait.until_motion_progress(0, vm.f32(0.45), -1.0, 30)
		event.play_sound_effect(sound_bank, 1)
		section_index = 11
		wait.for_frame_count(10)
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "レシーバー立ち", 0, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 12
		message.show_voiced(1030020)
		event.reset_mouth_texture_animations()
		section_index = 13
		object.wait_until_done(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(-25.76, 295.42, 1049.41)
		event.set_camera_sequence_look_at(-24.18, 286.8, 1002.8)
		section_index = 14
		message.show_voiced(1030030)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 15
		message.show_voiced(1030031)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 16
		message.show_voiced(1030040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "レシーバーをなおす", 2)
		event.wait_object_sequence_motion_end(0)
		section_index = 17
		wait.until_motion_progress(0, vm.f32(0.275), -1.0, 30)
		event.play_sound_effect(sound_bank, 2)
		section_index = 18
		wait.until_motion_progress(0, vm.f32(0.6), -1.0, 30)
		event.play_sound_effect(sound_bank, 3)
		section_index = 19
		object.wait_until_done(0)
		event.detach_character_from_frame(10)
		event.set_camera_sequence_position(-8.24, 302.09, 593.73)
		event.set_camera_sequence_look_at(18.03, 282.04, 991.15)
		event.set_object_sequence_position(0, 18.03, 262.04, 991.15)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 180)
		event.add_object_sequence_path_point(0, 18.03, 262.04, 991.15)
		event.add_object_sequence_path_point(0, 35.05, 262.04, 991.16)
		event.add_object_sequence_path_point(0, 63.63, 262.04, 998.35)
		event.add_object_sequence_path_point(0, 106.4, 262.04, 1000.0)
		event.add_object_sequence_path_point(0, 141.73, 262.04, 990.16)
		event.add_object_sequence_path_point(0, 155.42, 262.04, 953.13)
		event.add_object_sequence_path_point(0, 152.72, 262.04, 922.35)
		event.add_object_sequence_path_point(0, 131.69, 262.04, 909.25)
		event.add_object_sequence_path_point(0, 116.83, 262.04, 907.18)
		event.add_object_sequence_path_point(0, 65.0, 247.21, 908.16)
		event.add_object_sequence_path_point(0, -16.98, 216.58, 908.0)
		event.add_object_sequence_path_point(0, -72.6, 197.65, 908.51)
		event.add_object_sequence_path_point(0, -145.02, 171.37, 906.89)
		event.start_object_sequence_path(0)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(150)
		event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
		section_index = 20
		vm.wait(20)
		index = 0
		while index < 180 do
			if index == 50 then
				event.set_object_handle_footstep_sound(0, 6)
			end
			do
				local out1, out2, out3 = event.get_character_position(0)
				character_x = out1 or character_x
				character_y = out2 or character_y
				character_z = out3 or character_z
			end
			event.set_camera_sequence_look_at(character_x, character_y + 20.0, character_z)
			section_index = 21
			vm.wait(21)
			index = index + 1
		end
		event.set_object_handle_footstep_sound(0, 2)
		event.fade_in_screen(30)
		event.set_camera_sequence_position(-12.28, 87.78, 633.3)
		event.set_camera_sequence_look_at(-12.36, 76.05, 565.41)
		event.set_object_sequence_position(0, -12.17, 50.0, 540.63)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -12.27, 50.0, 462.63, 60)
		index = 0
		while index < 60 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				character_x = out1 or character_x
				character_y = out2 or character_y
				character_z = out3 or character_z
			end
			event.set_camera_sequence_look_at(character_x, character_y + 20, character_z)
			if index == 40 then
				event.play_sound_effect(sound_bank, 4)
			end
			section_index = 22
			vm.wait(22)
			index = index + 1
		end
		event.set_camera_sequence_position(10.57, 80.17, 211.98)
		event.set_camera_sequence_look_at(-4.39, 74.32, 228.85)
		event.set_object_sequence_position(0, -5.05, 50.0, 232.5)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上を見る", 4, 0.07, 1)
		section_index = 23
		wait.for_frame_count(15)
		event.set_camera_sequence_position(-3.08, 61.16, 277.13)
		event.set_camera_sequence_look_at(-4.35, 72.53, 230.25)
		event.set_object_sequence_position(0, -5.05, 50.0, 232.5)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.move_camera_sequence_eased(-3.08, 61.16, 277.13, -4.35, 103.53, 230.25, 30, 0, 0.2)
		section_index = 24
		wait.for_frame_count(36)
		event.set_character_active(1, 8)
		event.set_camera_sequence_position(-4.16, 185.18, 12.13)
		event.set_camera_sequence_look_at(-2.93, 793.4, -5.89)
		event.set_object_sequence_position(1, 0.0, 704.73, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "落下中", 4)
		event.move_object_sequence(1, 0.0, 30.0, 0.0, 20)
		event.move_camera_sequence(-4.82, 50.61, 21.76, -2.93, 793.4, -5.89, 20)
		section_index = 25
		wait.for_frame_count(14)
		event.set_camera_sequence_position(28.38, 59.5, 119.0)
		event.set_camera_sequence_look_at(15.11, 66.61, 96.74)
		event.set_object_sequence_position(0, -3.97, 50.0, 82.73)
		event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
		event.set_object_sequence_position(1, 0.0, 95.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.move_object_sequence(1, 0.0, 50.0, 0.0, 6)
		event.set_object_sequence_motion(0, "象着地", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "象着地L")
		event.set_object_sequence_motion(1, "着地", 6)
		event.delay_camera_sequence_shake_track(6)
		event.shake_camera_sequence(0.0, 1.5, 0.0, 24)
		section_index = 26
		wait.for_frame_count(6)
		event.play_music(0)
		section_index = 27
		wait.for_frame_count(48)
		event.set_camera_sequence_position(8.34, 76.37, 68.31)
		event.set_camera_sequence_look_at(-3.92, 73.89, 83.97)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "びっくり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 28
		message.show_voiced(1030050)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(8.61, 67.77, 124.88)
		event.set_camera_sequence_look_at(1.17, 71.56, 84.8)
		event.set_object_sequence_rotation(0, 0.0, 2.9, 0.0)
		event.move_camera_sequence_eased(8.61, 67.77, 124.88, 1.17, 77.23, 84.8, 44, 2, 0.4)
		event.set_object_sequence_motion(1, "パオーン", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		section_index = 29
		wait.for_frame_count(15)
		event.play_sound_effect(sound_bank, 5)
		section_index = 30
		wait.for_frame_count(37)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 24)
		section_index = 31
		wait.for_frame_count(42)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(91.06, 185.9, -66.26)
		event.set_camera_sequence_look_at(-6.23, 91.91, 17.07)
		event.set_object_sequence_position(0, -6.67, 50.0, 84.81)
		event.set_object_sequence_rotation(0, 0.0, 2.9, 0.0)
		event.set_object_sequence_position(2, -4.73, 162.38, -24.57)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "浮遊", 4)
		event.move_object_sequence_eased(2, -4.73, 106.52, -24.57, 60, 2, 0.3)
		event.play_sound_effect(sound_bank, 6)
		section_index = 32
		object.wait_until_done(2)
		event.set_object_sequence_rotation(0, 0.0, 3.02, 0.0)
		event.set_camera_sequence_position(19.38, 59.94, 120.28)
		event.set_camera_sequence_look_at(1.66, 79.89, 71.18)
		event.set_object_sequence_position(2, 11.92, 134.55, -43.71)
		event.set_object_sequence_rotation(2, 0.0, -0.24, 0.0)
		event.set_object_sequence_motion(0, "上を見るL", 6, -1.0, 1)
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 33
		message.show_voiced(1030060)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-5.96, 89.53, 73.98)
		event.set_camera_sequence_look_at(-6.81, 73.86, 87.67)
		event.set_object_sequence_motion(0, "ポルカスを見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "ポルカスを見るL")
		event.play_sound_effect(sound_bank, 7)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 34
		message.show_voiced(1030070)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(8.07, 126.01, 28.15)
		event.set_camera_sequence_look_at(8.5, 154.76, -34.87)
		section_index = 35
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 36
		message.show_voiced(1030080)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 37
		message.show_voiced(1030081)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(16.03, 156.16, -10.64)
		event.set_camera_sequence_look_at(10.22, 165.33, -37.84)
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 38
		message.show_voiced(1030090)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 39
		message.show_voiced(1030100)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 40
		message.show_voiced(1030101)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(2, 1, "目とじ")
		event.set_object_sequence_motion(2, "うつむく", 6)
		event.queue_object_sequence_next_motion(2, "うつむくL", 0)
		section_index = 41
		wait.for_frame_count(9)
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 42
		message.show_voiced(1030110)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-5.1, 89.1, 58.36)
		event.set_camera_sequence_look_at(-6.56, 75.02, 78.7)
		event.play_sound_effect(sound_bank, 8)
		event.set_object_sequence_motion(0, "なんだって！", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "なんだって！L", 0)
		section_index = 43
		wait.for_frame_count(10)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 44
		message.show_voiced(1030120)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(4.77, 158.81, -12.71)
		event.set_camera_sequence_look_at(14.01, 169.3, -54.18)
		event.set_object_sequence_texture_animation(2, 1, "目こらし")
		event.set_object_sequence_motion(2, "ウフフフ", 4)
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 45
		message.show_voiced(1030130)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(30.18, 182.63, -12.61)
		event.set_camera_sequence_look_at(-15.36, 101.5, 68.2)
		event.set_object_sequence_position(0, -6.39, 50.0, 102.82)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_position(2, -1.72, 117.17, 22.1)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.set_object_sequence_motion(2, "浮遊", 4)
		event.play_sound_effect(sound_bank, 9)
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 46
		message.show_voiced(1030140)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_rotation(0, 0.0, 3.02, 0.0)
		event.set_object_sequence_position(2, 3.77, 134.08, 27.37)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_camera_sequence_position(9.35, 66.39, 80.83)
		event.set_camera_sequence_look_at(-6.04, 71.48, 99.69)
		event.set_object_sequence_motion(0, "考える", 6)
		event.queue_object_sequence_next_motion(0, "考えるL", 0)
		section_index = 47
		wait.for_frame_count(15)
		section_index = 48
		message.show_voiced(1030150)
		event.set_camera_sequence_position(1.44, 167.15, 61.09)
		event.set_camera_sequence_look_at(3.34, 165.04, 30.8)
		event.set_object_sequence_motion(2, "腹を突き出す", 4)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "浮遊", 4)
		event.set_mouth_texture_animations(2, "口パク1")
		section_index = 49
		message.show_voiced(1030160)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-21.79, 178.71, -1.18)
		event.set_camera_sequence_look_at(0.55, 132.61, 42.24)
		event.set_object_sequence_position(2, 2.65, 122.38, 24.68)
		event.set_object_sequence_rotation(2, 0.0, -0.36, 0.0)
		event.play_sound_effect(sound_bank, 10)
		event.set_object_sequence_motion(0, "おことわりだよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "おことわりだよL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 50
		message.show_voiced(1030170)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_position(2, 3.77, 134.08, 27.37)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_camera_sequence_position(-13.53, 78.7, 80.84)
		event.set_camera_sequence_look_at(-6.17, 72.32, 101.95)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 51
		message.show_voiced(1030180)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(1.35, 150.19, 59.87)
		event.set_camera_sequence_look_at(3.64, 164.72, 27.05)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "プルプル", 4)
		event.set_mouth_texture_animations(2, "おこり口パク")
		section_index = 52
		message.show_voiced(1030190)
		event.reset_mouth_texture_animations()
		event.set_object_handle_visible(5, 1)
		event.set_object_handle_visible(6, 1)
		section_index = 53
		channel_pump_room.play_elephant_attack_command(sound_bank)
		section_index = 54
		channel_pump_room.place_elephant_scene(sound_bank)
		event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 0.0, 15)
		event.fade_out_screen(30)
		section_index = 55
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if section_index <= 1 then
			cutscene.skip_command(4)
		end
		if section_index <= 2 then
			cutscene.skip_command(0)
		end
		if section_index <= 3 then
			wait.skip_frame_count(40)
		end
		if section_index <= 4 then
			message.show_voiced_for_stopping_skipping(1030010, 30)
		end
		if section_index <= 5 then
			cutscene.skip_command(1)
		end
		if section_index <= 6 then
			cutscene.skip_command(0)
		end
		if section_index <= 7 then
			wait.background_load_skipping()
		end
		if section_index <= 8 then
			wait.skip_frame_count(60)
		end
		if section_index <= 9 then
			channel_pump_room.replace_unset_rate(0, vm.f32(0.45), -1.0, 30)
		end
		if section_index <= 10 then
			wait.skip_frame_count(10)
		end
		if section_index <= 11 then
			message.show_voiced_skipping(1030020)
		end
		if section_index <= 12 then
			cutscene.skip_command(0)
		end
		if section_index <= 13 then
			message.show_voiced_skipping(1030030)
		end
		if section_index <= 14 then
			message.show_voiced_skipping(1030031)
		end
		if section_index <= 15 then
			message.show_voiced_skipping(1030040)
		end
		if section_index <= 16 then
			channel_pump_room.replace_unset_rate(0, vm.f32(0.275), -1.0, 30)
		end
		if section_index <= 17 then
			channel_pump_room.replace_unset_rate(0, vm.f32(0.6), -1.0, 30)
		end
		if section_index <= 18 then
			cutscene.skip_command(0)
		end
		if section_index <= 20 then
			index = 0
		end
		if section_index <= 21 then
			local _ = index < 180
			local _ = index == 50
			index = index + 1
			index = 0
		end
		if section_index <= 22 then
			local _ = index < 60
			local _ = index == 40
			index = index + 1
			wait.skip_frame_count(15)
		end
		if section_index <= 23 then
			wait.skip_frame_count(36)
		end
		if section_index <= 24 then
			wait.skip_frame_count(14)
		end
		if section_index <= 25 then
			wait.skip_frame_count(6)
		end
		if section_index <= 26 then
			wait.skip_frame_count(48)
		end
		if section_index <= 27 then
			message.show_voiced_skipping(1030050)
		end
		if section_index <= 28 then
			wait.skip_frame_count(15)
		end
		if section_index <= 29 then
			wait.skip_frame_count(37)
		end
		if section_index <= 30 then
			wait.skip_frame_count(42)
		end
		if section_index <= 31 then
			cutscene.skip_command(2)
		end
		if section_index <= 32 then
			message.show_voiced_skipping(1030060)
		end
		if section_index <= 33 then
			message.show_voiced_skipping(1030070)
		end
		if section_index <= 34 then
			wait.skip_frame_count(15)
		end
		if section_index <= 35 then
			message.show_voiced_skipping(1030080)
		end
		if section_index <= 36 then
			message.show_voiced_skipping(1030081)
		end
		if section_index <= 37 then
			message.show_voiced_skipping(1030090)
		end
		if section_index <= 38 then
			message.show_voiced_skipping(1030100)
		end
		if section_index <= 39 then
			message.show_voiced_skipping(1030101)
		end
		if section_index <= 40 then
			wait.skip_frame_count(9)
		end
		if section_index <= 41 then
			message.show_voiced_skipping(1030110)
		end
		if section_index <= 42 then
			wait.skip_frame_count(10)
		end
		if section_index <= 43 then
			message.show_voiced_skipping(1030120)
		end
		if section_index <= 44 then
			message.show_voiced_skipping(1030130)
		end
		if section_index <= 45 then
			message.show_voiced_skipping(1030140)
		end
		if section_index <= 46 then
			wait.skip_frame_count(15)
		end
		if section_index <= 47 then
			message.show_voiced_skipping(1030150)
		end
		if section_index <= 48 then
			message.show_voiced_skipping(1030160)
		end
		if section_index <= 49 then
			message.show_voiced_skipping(1030170)
		end
		if section_index <= 50 then
			message.show_voiced_skipping(1030180)
		end
		if section_index <= 51 then
			message.show_voiced_skipping(1030190)
		end
		if section_index <= 52 then
			channel_pump_room.say_attack_command(sound_bank)
		end
		if section_index <= 53 then
			channel_pump_room.place_elephant_scene_skipping(sound_bank)
		end
		if section_index <= 54 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.reset_dungeon_timer()
	event.set_object_handle_footstep_sound(0, 0)
	event.attach_object_handle_to_map_part_3(4, "p08_s06", "s06_08-m1")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_position(4, map_part_x, map_part_y, map_part_z)
	section_index = 56
	vm.wait(56)
	event.attach_object_handle_to_character(5, 1)
	event.set_object_handle_visible(5, 1)
	event.attach_object_handle_to_character(6, 2)
	event.set_object_handle_visible(6, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(8)
	event.delete_character(10)
	event.stop_music(0)
	section_index = 57
	wait.for_frame_count(4)
	event.load_music(195)
	event.play_music(0)
	event.fade_in_screen(15)
	event.set_camera_position(-1.66, 76.3, 205.77)
	event.set_camera_look_at(-0.37, 74.98, 151.36)
	event.set_character_position(0, 0.0, 50.0, 138.0)
	event.set_character_rotation(0, 0.0, 3.02, 0.0)
	event.reset_follow_camera(0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.show_dungeon_status_bar(1)
	event.place_dungeon_monster(614, 0.0, 50.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end

--- Plays the e104 opening event of the pump room with camera moves, effects and dialogue.
function channel_pump_room.play_pump_room_opening_event()
	local initial_projection: f32 = 0
	local start_projection: f32 = 0
	local index: s32 = 0
	local sound_bank: s32 = 0
	local unused_wait_argument: s32 = 0
	local projection_step: f32 = 0
	local current_projection: f32 = 0
	local frame: s32 = 0
	local frame_count: s32 = 0
	local steve_x: f32 = 0
	local steve_y: f32 = 0
	local steve_z: f32 = 0
	local section_index: number = 0
	vm.section(function()
		section_index = 1
		vm.entry(1)
		event.set_save_flag(104, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		sound_bank = event.load_sound_effect_file_3(4, 1813) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		initial_projection = event.get_event_projection() or initial_projection
		event.load_character_motion_pack(5, "event/e100/e104/e104_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/e100/e104/e104_ste_sta.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_sound_bank(1, sound_bank)
		event.load_character(5, "event/e100/e104/e104_erephant.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(2, 9)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.load_character(5, "event/e100/e104/e104_polcurse.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(3, 10)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e100/e104/e104_iwa.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(4, 11)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/e100/e104/e104_iwakudake.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(7, 12)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_naguru.gltf", "info", 14)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(8, 14)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_object_sequence_position(8, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_naguru_hyaku.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.attach_object_handle_to_character(9, 15)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.set_object_sequence_position(9, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(9, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_naguru_upper.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(10, 16)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_position(10, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_smoke.gltf", "info", 17)
		event.set_character_active(0, 17)
		event.attach_object_handle_to_character(11, 17)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.set_object_sequence_position(11, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_overheat.gltf", "info", 18)
		event.set_character_active(0, 18)
		event.attach_object_handle_to_character(12, 18)
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.set_object_sequence_position(12, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.load_message_file(0, 5, "event/e100/e104/e104.txt")
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("e110ポル回転キラ")
		event.create_effect_work_buffer(5)
		event.stop_music(0)
		section_index = 2
		wait.for_frame_count(4)
		event.load_music(193)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.enable_drama_skip()
		event.set_character_active(1, 0)
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_character(10, 1)
		event.attach_object_handle_to_character(11, 2)
		event.attach_object_handle_to_character(12, 3)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.set_object_handle_visible(12, 1)
		event.set_camera_sequence_position(-20.33, 70.25, 59.65)
		event.set_camera_sequence_look_at(102.39, 53.16, 234.79)
		event.set_object_sequence_position(0, 1.77, 50.0, 89.12)
		event.set_object_sequence_rotation(0, 0.0, -3.0, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		section_index = 3
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 4
		message.show_voiced(1040010)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(2.83, 72.97, 182.21)
		event.set_camera_sequence_look_at(1.93, 81.57, -215.48)
		event.set_object_sequence_position(2, 3.65, 50.0, -40.62)
		event.set_object_sequence_rotation(2, 0.0, -0.03, 0.0)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		start_projection = event.get_event_projection() or start_projection
		event.set_object_sequence_motion(2, "歩き")
		section_index = 5
		vm.wait(5)
		frame_count = 40
		frame = 1
		projection_step = vm.f32(vm.fdiv(vm.f32(vm.f32(867.9) - start_projection), frame_count))
		while frame < frame_count do
			current_projection = vm.f32(projection_step * frame)
			current_projection = vm.f32(start_projection + current_projection)
			event.set_event_projection(current_projection)
			section_index = 6
			vm.wait(6)
			frame = frame + 1
		end
		event.set_event_projection(start_projection)
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(62.56, 161.62, 59.5)
		event.set_camera_sequence_look_at(3.61, 179.88, 37.58)
		event.set_object_sequence_position(3, 1.97, 159.88, 33.85)
		event.set_object_sequence_rotation(3, 0.0, 0.04, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "おこりわらい顔")
		event.set_object_sequence_texture_animation(3, 1, "おこり目パチ")
		event.set_object_sequence_motion(3, "浮遊", 4, -1.0, 1)
		section_index = 7
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 8
		message.show_voiced(1040020)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(15.68, 76.92, 110.24)
		event.set_camera_sequence_look_at(5.46, 70.74, 129.29)
		event.set_object_sequence_position(0, 6.33, 49.45, 128.85)
		event.set_object_sequence_rotation(0, 0.0, 2.44, 0.0)
		event.set_object_sequence_texture_animation(0, 1, "くいしばり")
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		section_index = 9
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 10
		message.show_voiced(1040030)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-97.35, 80.94, 117.92)
		event.set_camera_sequence_look_at(-40.6, 80.11, 79.05)
		event.set_object_sequence_position(0, 4.49, 50.0, 81.42)
		event.set_object_sequence_rotation(0, 0.0, 2.89, 0.0)
		event.set_object_sequence_position(2, -5.42, 50.0, -60.99)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "歩き", 4, -1.0, 1)
		event.move_object_sequence(2, -0.37, 50.0, -5.7, 50)
		event.rotate_object_sequence(2, 0.0, -0.03, 0.0, 20)
		section_index = 11
		channel_pump_room.wait_frame_loop(50, unused_wait_argument)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(15.68, 76.92, 110.24)
		event.set_camera_sequence_look_at(5.46, 70.74, 129.29)
		event.set_object_sequence_position(0, 6.33, 49.45, 128.85)
		event.set_object_sequence_rotation(0, 0.0, 2.44, 0.0)
		event.set_object_sequence_texture_animation(0, 1, "くいしばり")
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		section_index = 12
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 13
		message.show_voiced(1040040)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(2.83, 72.48, 182.21)
		event.set_camera_sequence_look_at(1.93, 128.72, -215.48)
		event.set_object_sequence_position(0, 3.24, 50.0, 118.73)
		event.set_object_sequence_rotation(0, 0.0, -3.0, 0.0)
		event.set_object_sequence_position(2, 3.84, 50.0, 41.34)
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(2, "ふりかぶる", 6)
		event.wait_object_sequence_motion_end(2)
		event.play_sound_effect(sound_bank, 1)
		section_index = 14
		object.wait_until_done(2)
		event.set_character_active(1, 12)
		event.set_character_active(1, 11)
		event.set_object_sequence_position(4, -61.22, 96.72, 70.37)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(7, -61.22, 96.72, 70.37)
		event.set_object_sequence_rotation(7, 0.0, 1.72, 0.0)
		event.set_object_sequence_motion(7, "岩", 4)
		event.set_character_active(0, 11)
		event.jump_object_sequence(7, -17.07, 99.51, 70.08, -0.4, 3)
		section_index = 15
		object.wait_until_done(7)
		event.set_object_sequence_motion(2, "岩があたる", 6)
		event.wait_object_sequence_motion_end(2)
		event.play_sound_effect(sound_bank, 2)
		event.set_object_sequence_motion(7, "砕ける岩", 0)
		section_index = 16
		wait.for_frame_count(28)
		event.set_character_active(0, 12)
		section_index = 17
		object.wait_until_done(2)
		event.set_object_sequence_position(0, 2.81, 50.0, 110.3)
		event.set_object_sequence_rotation(0, 0.0, -3.0, 0.0)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(-17.42, 72.3, 95.02)
		event.set_camera_sequence_look_at(8.94, 73.07, 115.98)
		event.set_character_texture_animation(0, 0, "怒り目")
		event.set_character_texture_animation(0, 0, "怒り口")
		event.set_object_sequence_texture_animation(0, 1, "振り向き顔")
		event.set_object_sequence_motion(0, "左を見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "左を見るL")
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 18
		message.show_voiced_for_stopping(1040050, 12)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-36.29, 169.1, 79.75)
		event.set_camera_sequence_look_at(1.07, 187.01, 33.65)
		event.set_object_sequence_texture_animation(3, 1, "おどろき口")
		event.play_sound_effect(sound_bank, 3)
		event.set_object_sequence_motion(3, "驚く", 6)
		event.queue_object_sequence_next_motion(3, "驚くL")
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 19
		message.show_voiced_for_stopping(1040060, 25)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 8)
		event.set_camera_sequence_position(-472.64, 157.68, -14.51)
		event.set_camera_sequence_look_at(-374.9, 159.09, -138.37)
		event.set_object_sequence_position(1, -698.91, 120.39, -1.62)
		event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
		event.set_object_sequence_scale(1, 1.2, 1.2, 1.2)
		event.play_music(1)
		event.move_camera_sequence(-489.82, 157.68, 2.84, -669.99, 159.09, 0.82, 14)
		event.set_object_sequence_motion(1, "岩抱えL", 4)
		section_index = 20
		camera.wait_until_done()
		section_index = 21
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-649.06, 178.83, 1.06)
		event.set_camera_sequence_look_at(-739.64, 160.75, -2.5)
		event.play_sound_effect(sound_bank, 4)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 22
		message.show_voiced(1040070)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(-16.05, 82.67, 94.68)
		event.set_camera_sequence_look_at(0.78, 74.43, 106.59)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.play_sound_effect(sound_bank, 5)
		event.attach_object_handle_to_character(5, 1)
		event.set_object_handle_visible(5, 0)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(6, 0)
		event.set_object_sequence_motion(0, "すごいよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "すごいよL")
		section_index = 23
		wait.for_frame_count(3)
		event.set_mouth_texture_animations(0, "わらい口パク")
		section_index = 24
		message.show_voiced(1040080)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-595.13, 165.27, -0.58)
		event.set_camera_sequence_look_at(-680.32, 162.11, -0.34)
		event.set_object_sequence_motion(1, "構え", 4)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 25
		message.show_voiced(1040090)
		event.reset_mouth_texture_animations()
		event.stop_sound_effect(sound_bank, 4)
		event.play_sound_effect(sound_bank, 6)
		event.set_camera_sequence_position(-487.31, 136.74, -141.75)
		event.set_camera_sequence_look_at(-782.31, 197.24, 86.51)
		event.set_object_sequence_motion(1, "ジャンプ", 6, 0.4)
		event.queue_object_sequence_next_motion(1, "ジャンプL")
		section_index = 26
		wait.for_frame_count(3)
		event.jump_object_sequence(1, -410.14, 169.27, 125.29, -0.35, 33)
		index = 1
		while index < 33 do
			do
				local out1, out2, out3 = event.get_object_handle_position(1)
				steve_x = out1 or steve_x
				steve_y = out2 or steve_y
				steve_z = out3 or steve_z
			end
			event.set_camera_sequence_look_at(steve_x, steve_y + 60.0, steve_z)
			section_index = 27
			vm.wait(27)
			index = index + 1
		end
		event.set_character_active(1, 9)
		event.clear_camera_sequence()
		event.set_character_active(0, 0)
		event.set_character_active(0, 10)
		event.set_camera_sequence_position(123.01, 102.6, 37.52)
		event.set_camera_sequence_look_at(-195.66, 44.82, 141.63)
		event.set_object_sequence_position(1, 73.03, 63.16, 18.93)
		event.set_object_sequence_rotation(1, 0.0, -0.56, 0.0)
		event.set_object_sequence_position(2, -8.8, 50.0, 120.29)
		event.set_object_sequence_rotation(2, 0.0, 3.13, 0.0)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_object_sequence_position(1, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(1, 0.0, -0.03, 0.0)
		event.set_object_sequence_position(2, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(2, 0.0, -0.03, 0.0)
		event.set_character_active(1, 14)
		event.set_object_sequence_position(8, 73.03, 63.16, 18.93)
		event.set_object_sequence_rotation(8, 0.0, -0.56, 0.0)
		event.set_object_sequence_motion(8, "エフェクト_殴る", 6)
		event.set_object_sequence_motion(1, "殴る", 6)
		event.set_object_sequence_motion(2, "殴る", 6)
		event.wait_object_sequence_motion_end(1)
		event.wait_object_sequence_motion_end(2)
		event.play_sound_effect(sound_bank, 7)
		event.play_sound_effect(sound_bank, 8)
		section_index = 28
		object.wait_until_done(1)
		section_index = 29
		object.wait_until_done(2)
		event.set_character_active(0, 14)
		event.set_character_active(1, 8)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-96.23, 106.65, 44.67)
		event.set_camera_sequence_look_at(-84.09, 104.44, 47.57)
		event.set_object_sequence_position(1, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(1, 0.0, -0.03, 0.0)
		event.set_object_sequence_position(2, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(2, 0.0, -0.03, 0.0)
		event.set_object_sequence_scale(2, 1.0, 1.0, 1.0)
		event.set_character_active(1, 15)
		event.set_object_sequence_position(9, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(9, 0.0, -0.03, 0.0)
		event.set_object_sequence_motion(9, "エフェクト_百烈拳", 6)
		event.set_object_sequence_motion(1, "百烈拳", 6)
		event.set_object_sequence_motion(2, "百烈拳", 6)
		event.queue_object_sequence_next_motion(1, "アッパー", 6)
		event.queue_object_sequence_next_motion(2, "アッパー", 6)
		event.wait_object_sequence_motion_end(1)
		event.wait_object_sequence_motion_end(2)
		event.delay_camera_sequence_position_track(50)
		event.set_camera_sequence_position(-84.59, 72.69, -23.68)
		event.set_camera_sequence_look_at(65.91, 125.55, 145.6)
		event.delay_camera_sequence_position_track(49)
		event.set_camera_sequence_position(49.52, 88.47, 17.44)
		event.set_camera_sequence_look_at(1.9, 49.55, 248.07)
		index = 0
		while index < 75 do
			section_index = 30
			vm.wait(30)
			if index < 55 then
				if vm.imod(index, 4) == 0 then
					event.play_sound_effect(sound_bank, 7)
					event.play_sound_effect(sound_bank, 8)
				end
			end
			if index == 57 then
				event.play_sound_effect(sound_bank, 9)
			end
			index = index + 1
		end
		event.set_character_active(0, 15)
		event.set_character_active(1, 16)
		event.set_character_position(16, 3.84, 50.0, 41.34)
		event.set_character_rotation(16, 0.0, -0.03, 0.0)
		event.set_character_motion(16, "エフェクト_アッパー", 6)
		section_index = 31
		object.wait_until_done(1)
		section_index = 32
		object.wait_until_done(2)
		section_index = 33
		camera.wait_until_done()
		event.set_character_active(0, 16)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(2.43, 89.98, -21.91)
		event.set_camera_sequence_look_at(3.78, 84.72, 87.51)
		event.set_object_sequence_position(1, 2.05, 50.0, 102.48)
		event.set_object_sequence_rotation(1, 0.0, 3.13, 0.0)
		event.set_character_active(1, 17)
		event.set_object_sequence_position(11, 2.05, 50.0, 102.48)
		event.set_character_position(17, 2.05, 50.0, 102.48)
		event.set_character_rotation(17, 0.0, 3.13, 0.0)
		event.set_object_sequence_motion(11, "エフェクト_湯気", 4)
		event.set_object_sequence_motion(1, "どうじゃ！", 4)
		section_index = 34
		wait.for_frame_count(15)
		event.play_sound_effect(sound_bank, 10)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 35
		message.show_voiced(1040100)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 17)
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(-45.51, 69.87, 128.53)
		event.set_camera_sequence_look_at(-45.74, 88.49, 287.42)
		event.set_object_sequence_position(0, -45.61, 50.0, 154.61)
		event.set_object_sequence_rotation(0, 0.0, 2.53, 0.0)
		event.stop_sound_effect(sound_bank, 10)
		event.play_sound_effect(sound_bank, 11)
		event.set_object_sequence_motion(0, "すごいよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "すごいよL")
		section_index = 36
		wait.for_frame_count(3)
		event.set_mouth_texture_animations(0, "わらい口パク")
		section_index = 37
		message.show_voiced(1040110)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(2.48, 180.08, 53.9)
		event.set_camera_sequence_look_at(-2.43, 189.74, -146.57)
		event.set_object_sequence_position(3, -6.54, 165.12, -24.91)
		event.set_object_sequence_rotation(3, 0.0, 0.37, 0.0)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "わらい顔")
		event.set_object_sequence_texture_animation(3, 1, "通常目パチ")
		event.set_object_sequence_motion(3, "光をためるL", 4)
		event.set_object_sequence_motion(3, "光をためるL")
		section_index = 38
		object.wait_until_done(3)
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 39
		message.show_voiced(1040120)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(2.48, 211.26, 53.9)
		event.set_camera_sequence_look_at(-2.43, 150.53, -146.57)
		event.set_object_sequence_motion(3, "光を放つ", 6)
		event.wait_object_sequence_motion_end(3)
		section_index = 40
		object.wait_until_done(3)
		event.play_sound_effect(sound_bank, 12)
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-117.37, 146.51, -35.46)
		event.set_camera_sequence_look_at(103.37, 9.39, 23.71)
		event.set_object_sequence_position(2, -18.78, 50.0, -55.26)
		event.set_object_sequence_rotation(2, 0.0, 0.09, 0.0)
		event.create_effect_2("e110ポル回転キラ", 9)
		event.set_effect_first_vector(160.0, 140.0, 160.0)
		event.set_object_sequence_position(2, 0.86, 50.0, -22.64)
		event.set_object_sequence_rotation(2, 0.0, -0.87, 0.0)
		event.set_object_sequence_motion(2, "復活", 6)
		section_index = 41
		wait.for_frame_count(100)
		event.play_sound_effect(sound_bank, 13)
		event.set_camera_sequence_position(-87.08, 95.61, 51.87)
		event.set_camera_sequence_look_at(83.1, 98.77, -93.27)
		event.set_object_sequence_motion(2, "ブルブル", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		section_index = 42
		wait.for_frame_count(50)
		event.play_sound_effect(sound_bank, 14)
		event.set_camera_sequence_position(-79.4, 118.39, 76.29)
		event.set_camera_sequence_look_at(-11.32, 84.25, -20.1)
		event.set_object_sequence_position(2, -10.22, 50.0, -0.34)
		event.set_object_sequence_rotation(2, 0.0, -0.87, 0.0)
		section_index = 43
		vm.wait(43)
		section_index = 44
		wait.for_frame_count(30)
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(-14.86, 110.63, -24.65)
		event.set_camera_sequence_look_at(-30.63, 87.29, 63.28)
		event.set_object_sequence_position(1, -33.56, 49.19, 71.0)
		event.set_object_sequence_rotation(1, 0.0, 2.93, 0.0)
		event.set_object_sequence_motion(1, "構え", 4)
		event.play_sound_effect(sound_bank, 15)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 45
		message.show_voiced(1040130)
		event.reset_mouth_texture_animations()
		event.set_object_handle_frame_visible(3, "cyl2", 0)
		event.set_camera_sequence_position(29.47, 85.69, 10.08)
		event.set_camera_sequence_look_at(-135.3, 106.15, 168.51)
		event.play_sound_effect(sound_bank, 16)
		event.play_sound_effect(sound_bank, 17)
		event.play_sound_effect(sound_bank, 18)
		event.set_object_sequence_motion(1, "手をまわす", 6)
		event.queue_object_sequence_next_motion(1, "手をまわすL")
		section_index = 46
		object.wait_until_done(1)
		section_index = 47
		camera.wait_until_done()
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 48
		message.show_voiced(1040140)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 18)
		event.set_character_position(18, -33.56, 49.19, 71.0)
		event.set_character_rotation(18, 0.0, 2.93, 0.0)
		event.set_character_scale(18, 1.2, 1.2, 1.2)
		event.set_object_sequence_motion(12, "オーバーヒート\t", 4)
		event.fade_out_music(30)
		event.stop_sound_effect(sound_bank, 15)
		event.play_sound_effect(sound_bank, 19)
		event.set_object_sequence_motion(1, "ガコン", 6)
		event.queue_object_sequence_next_motion(1, "ガコンL")
		section_index = 49
		object.wait_until_done(1)
		event.play_sound_effect(sound_bank, 20)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 50
		message.show_voiced(1040150)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 18)
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(-84.61, 67.09, 17.57)
		event.set_camera_sequence_look_at(46.83, 120.54, 229.76)
		event.set_object_sequence_position(0, -51.32, 49.7, 99.35)
		event.set_object_sequence_rotation(0, 0.0, 1.48, 0.0)
		event.set_character_position(0, -51.32, 49.7, 99.35)
		event.set_character_rotation(0, 0.0, 1.48, 0.0)
		event.set_object_sequence_position(1, -18.48, 49.19, 89.15)
		event.set_object_sequence_rotation(1, 0.0, -2.87, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "ガコンL", 4)
		event.set_object_sequence_motion(0, "上見会話", 2)
		event.queue_object_sequence_next_motion(0, "上見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 51
		message.show_voiced(1040160)
		event.reset_mouth_texture_animations()
		section_index = 52
		message.show_voiced(1040170)
		event.set_object_sequence_motion(1, "ミンツを見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL")
		section_index = 53
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 54
		message.show_voiced(1040171)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 55
		message.show_voiced(1040172)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 56
		message.show_voiced(1040180)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-26.67, 89.04, 100.9)
		event.set_camera_sequence_look_at(-181.84, -8.6, 101.99)
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "ガコンL", 4)
		event.set_object_sequence_motion(0, "上見会話", 2)
		event.queue_object_sequence_next_motion(0, "上見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 57
		message.show_voiced(1040190)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(3.1, 137.71, 121.7)
		event.set_camera_sequence_look_at(-96.45, -19.65, 33.14)
		event.set_object_sequence_position(0, -52.15, 49.3, 100.27)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "ガコンL", 4)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 58
		message.show_voiced(1040200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "ミンツを見る戻り", 6)
		event.play_sound_effect(sound_bank, 21)
		section_index = 59
		wait.for_frame_count(15)
		event.stop_sound_effect(sound_bank, 20)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 60
		message.show_voiced(1040201)
		event.reset_mouth_texture_animations()
		section_index = 61
		object.wait_until_done(1)
		event.set_camera_sequence_position(-35.68, 98.0, 30.68)
		event.set_camera_sequence_look_at(10.9, 100.95, 171.17)
		event.set_object_sequence_position(0, -18.48, 49.19, 89.15)
		event.set_object_sequence_rotation(0, 0.0, -2.87, 0.0)
		event.set_object_sequence_scale(0, 1.2, 1.2, 1.2)
		event.set_object_sequence_position(1, -18.48, 49.19, 89.15)
		event.set_object_sequence_rotation(1, 0.0, -2.87, 0.0)
		event.play_sound_effect(sound_bank, 15)
		event.play_sound_effect(sound_bank, 22)
		event.set_object_sequence_motion(0, "スティーブに乗る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "スティーブに乗るL")
		section_index = 62
		object.wait_until_done(0)
		section_index = 63
		wait.for_frame_count(15)
		event.set_character_active(0, 8)
		event.set_character_active(0, 0)
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(-155.09, 107.3, 7.35)
		event.set_camera_sequence_look_at(-110.59, 116.9, -6.56)
		event.set_object_sequence_position(2, -21.45, 49.19, 21.76)
		event.set_object_sequence_rotation(2, 0.0, -1.87, 0.0)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_object_sequence_position(3, -69.17, 111.79, -20.32)
		event.set_object_sequence_rotation(3, 0.0, -1.75, 0.0)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 64
		message.show_voiced(1040210)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 23)
		event.set_object_sequence_motion(3, "殺っておしまい", 6)
		event.queue_object_sequence_next_motion(3, "殺っておしまいL")
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 65
		message.show_voiced(1040211)
		event.reset_mouth_texture_animations()
		section_index = 66
		object.wait_until_done(3)
		event.set_character_active(0, 10)
		event.set_camera_sequence_position(-166.8, 110.8, 7.81)
		event.set_camera_sequence_look_at(-73.91, 78.74, 3.61)
		event.set_object_sequence_position(2, -20.92, 49.19, 0.18)
		event.set_object_sequence_rotation(2, 0.0, -1.51, 0.0)
		start_projection = event.get_event_projection() or start_projection
		event.set_object_sequence_motion(2, "突進", 4)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 60)
		event.move_camera_sequence(-524.07, 92.61, 14.81, -374.2, 78.74, 8.04, 60)
		event.move_object_sequence(2, -408.03, 50.0, 7.63, 60)
		section_index = 67
		channel_pump_room.tween_projection(start_projection, vm.f32(524.9), 60, unused_wait_argument)
		event.set_event_projection(start_projection)
		event.set_character_active(1, 0)
		event.set_character_active(1, 8)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-289.45, 186.74, -103.76)
		event.set_camera_sequence_look_at(-436.94, 140.81, -26.0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_scale(0, 1.0, 1.0, 1.0)
		event.attach_character_to_frame(8, "mints", 0)
		event.set_object_sequence_position(1, -504.42, 50.21, 25.83)
		event.set_object_sequence_rotation(1, 0.0, 1.48, 0.0)
		event.set_object_sequence_scale(1, 1.0, 1.0, 1.0)
		event.set_object_sequence_position(2, -316.2, 45.22, 44.35)
		event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
		event.set_object_sequence_motion(0, "スティーブに乗るL", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "突進", 4)
		event.delay_object_sequence_motion_track(2, 10)
		event.set_object_sequence_motion(2, "立ち")
		event.move_object_sequence(2, -366.82, 45.22, 14.07, 15)
		event.set_object_sequence_motion(1, "バックジャンプ", 6, 0.4)
		event.play_sound_effect(sound_bank, 24)
		event.jump_object_sequence(1, -744.89, 134.13, 0.74, -0.35, 33)
		section_index = 68
		object.wait_until_done(2)
		section_index = 69
		object.wait_until_done(1)
		event.set_camera_sequence_position(-640.55, 176.56, -6.9)
		event.set_camera_sequence_look_at(-739.25, 169.31, -1.66)
		event.set_object_sequence_position(1, -734.79, 134.97, -2.3)
		event.set_object_sequence_rotation(1, 0.0, 1.64, 0.0)
		event.set_object_sequence_motion(0, "スティーブに乗るL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4)
		section_index = 70
		wait.for_frame_count(15)
		event.set_object_sequence_motion(1, "さらばじゃ", 2)
		event.play_sound_effect(sound_bank, 25)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 71
		message.show_voiced(1040220)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 26)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.rotate_object_sequence(1, 0.0, -1.6, 0.0, 30)
		section_index = 72
		object.wait_until_done(1)
		event.move_object_sequence(1, -937.66, 134.97, -0.71, 60)
		section_index = 73
		object.wait_until_done(1)
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(-326.4, 171.06, 5.03)
		event.set_camera_sequence_look_at(87.54, 136.02, -63.19)
		event.set_object_sequence_position(2, -343.04, 49.6, -15.01)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(3, -286.2, 134.97, -1.83)
		event.set_object_sequence_rotation(3, 0.0, -1.72, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.stop_sound_effect(sound_bank, 15)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "あらあら", 4)
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 74
		message.show_voiced(1040230)
		event.reset_mouth_texture_animations()
		section_index = 75
		object.wait_until_done(3)
		event.set_camera_sequence_position(-584.1, 136.54, 9.53)
		event.set_camera_sequence_look_at(87.54, 80.4, -63.19)
		event.set_object_sequence_position(3, -344.47, 145.98, -65.24)
		event.set_object_sequence_rotation(3, 0.0, -1.36, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.play_sound_effect(sound_bank, 27)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(18)
		event.fade_out_camera_sequence(100, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "パオーン", 6)
		section_index = 76
		object.wait_until_done(2)
		section_index = 77
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if section_index <= 1 then
			wait.skip_frame_count(4)
		end
		if section_index <= 2 then
			wait.skip_frame_count(15)
		end
		if section_index <= 3 then
			message.show_voiced_skipping(1040010)
		end
		if section_index <= 5 then
			frame_count = 40
			frame = 1
			projection_step = vm.f32(vm.fdiv(vm.f32(vm.f32(867.9) - start_projection), frame_count))
			current_projection = vm.f32(projection_step * frame)
			current_projection = vm.f32(start_projection + current_projection)
		end
		if section_index <= 6 then
			local _ = frame < frame_count
			frame = frame + 1
			wait.skip_frame_count(15)
		end
		if section_index <= 7 then
			message.show_voiced_skipping(1040020)
		end
		if section_index <= 8 then
			wait.skip_frame_count(15)
		end
		if section_index <= 9 then
			message.show_voiced_skipping(1040030)
		end
		if section_index <= 10 then
			channel_pump_room.skip_wait_frame_loop_variant(50, unused_wait_argument)
		end
		if section_index <= 11 then
			wait.skip_frame_count(15)
		end
		if section_index <= 12 then
			message.show_voiced_skipping(1040040)
		end
		if section_index <= 13 then
			cutscene.skip_command(2)
		end
		if section_index <= 14 then
			cutscene.skip_command(7)
		end
		if section_index <= 15 then
			wait.skip_frame_count(28)
		end
		if section_index <= 16 then
			cutscene.skip_command(2)
		end
		if section_index <= 17 then
			message.show_voiced_for_stopping_skipping(1040050, 12)
		end
		if section_index <= 18 then
			message.show_voiced_for_stopping_skipping(1040060, 25)
		end
		if section_index <= 19 then
			wait.background_load_skipping()
		end
		if section_index <= 20 then
			wait.skip_frame_count(30)
		end
		if section_index <= 21 then
			message.show_voiced_skipping(1040070)
		end
		if section_index <= 22 then
			wait.skip_frame_count(3)
		end
		if section_index <= 23 then
			message.show_voiced_skipping(1040080)
		end
		if section_index <= 24 then
			message.show_voiced_skipping(1040090)
		end
		if section_index <= 25 then
			wait.skip_frame_count(3)
		end
		if section_index <= 26 then
			index = 1
		end
		if section_index <= 27 then
			local _ = index < 33
			index = index + 1
			cutscene.skip_command(1)
		end
		if section_index <= 28 then
			cutscene.skip_command(2)
		end
		if section_index <= 29 then
			index = 0
		end
		if section_index <= 30 then
			local _ = index < 75
			local _ = index < 55
			local _ = vm.imod(index, 4) == 0
			local _ = index == 57
			index = index + 1
			cutscene.skip_command(1)
		end
		if section_index <= 31 then
			cutscene.skip_command(2)
		end
		if section_index <= 32 then
			wait.background_load_skipping()
		end
		if section_index <= 33 then
			wait.skip_frame_count(15)
		end
		if section_index <= 34 then
			message.show_voiced_skipping(1040100)
		end
		if section_index <= 35 then
			wait.skip_frame_count(3)
		end
		if section_index <= 36 then
			message.show_voiced_skipping(1040110)
		end
		if section_index <= 37 then
			cutscene.skip_command(3)
		end
		if section_index <= 38 then
			message.show_voiced_skipping(1040120)
		end
		if section_index <= 39 then
			cutscene.skip_command(3)
		end
		if section_index <= 40 then
			wait.skip_frame_count(100)
		end
		if section_index <= 41 then
			wait.skip_frame_count(50)
		end
		if section_index <= 43 then
			wait.skip_frame_count(30)
		end
		if section_index <= 44 then
			message.show_voiced_skipping(1040130)
		end
		if section_index <= 45 then
			cutscene.skip_command(1)
		end
		if section_index <= 46 then
			wait.background_load_skipping()
		end
		if section_index <= 47 then
			message.show_voiced_skipping(1040140)
		end
		if section_index <= 48 then
			cutscene.skip_command(1)
		end
		if section_index <= 49 then
			message.show_voiced_skipping(1040150)
		end
		if section_index <= 50 then
			message.show_voiced_skipping(1040160)
		end
		if section_index <= 51 then
			message.show_voiced_skipping(1040170)
		end
		if section_index <= 52 then
			cutscene.skip_command(1)
		end
		if section_index <= 53 then
			message.show_voiced_skipping(1040171)
		end
		if section_index <= 54 then
			message.show_voiced_skipping(1040172)
		end
		if section_index <= 55 then
			message.show_voiced_skipping(1040180)
		end
		if section_index <= 56 then
			message.show_voiced_skipping(1040190)
		end
		if section_index <= 57 then
			message.show_voiced_skipping(1040200)
		end
		if section_index <= 58 then
			wait.skip_frame_count(15)
		end
		if section_index <= 59 then
			message.show_voiced_skipping(1040201)
		end
		if section_index <= 60 then
			cutscene.skip_command(1)
		end
		if section_index <= 61 then
			cutscene.skip_command(0)
		end
		if section_index <= 62 then
			wait.skip_frame_count(15)
		end
		if section_index <= 63 then
			message.show_voiced_skipping(1040210)
		end
		if section_index <= 64 then
			message.show_voiced_skipping(1040211)
		end
		if section_index <= 65 then
			cutscene.skip_command(3)
		end
		if section_index <= 66 then
			channel_pump_room.count_projection_frames(start_projection, vm.f32(524.9), 60, unused_wait_argument)
		end
		if section_index <= 67 then
			cutscene.skip_command(2)
		end
		if section_index <= 68 then
			cutscene.skip_command(1)
		end
		if section_index <= 69 then
			wait.skip_frame_count(15)
		end
		if section_index <= 70 then
			message.show_voiced_skipping(1040220)
		end
		if section_index <= 71 then
			cutscene.skip_command(1)
		end
		if section_index <= 72 then
			cutscene.skip_command(1)
		end
		if section_index <= 73 then
			message.show_voiced_skipping(1040230)
		end
		if section_index <= 74 then
			cutscene.skip_command(3)
		end
		if section_index <= 75 then
			cutscene.skip_command(2)
		end
		if section_index <= 76 then
			wait.background_load_skipping()
		end
		return true
	end)
	section_index = 78
	vm.entry(78)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	section_index = 79
	wait.for_frame_count(4)
	event.clear_effect_manager()
	event.stop_sound_effect(sound_bank, 4)
	event.stop_sound_effect(sound_bank, 10)
	event.stop_sound_effect(sound_bank, 15)
	event.stop_sound_effect(sound_bank, 20)
	event.stop_sound_effect(sound_bank, 28)
	event.set_character_scale(0, 1.0, 1.0, 1.0)
	event.set_event_projection(initial_projection)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
end

--- Plays the e104 event with the hero, Steve, the elephant and Polcurse: a thrown rock, a flurry of punches, the elephant's revival and charge, and Steve's farewell before the fade out.
function channel_pump_room.play_pump_room_opening_event_variant()
	local initial_projection: f32 = 0
	local start_projection: f32 = 0
	local index: s32 = 0
	local sound_bank: s32 = 0
	local unused_wait_argument: s32 = 0
	local projection_step: f32 = 0
	local current_projection: f32 = 0
	local frame: s32 = 0
	local frame_count: s32 = 0
	local steve_x: f32 = 0
	local steve_y: f32 = 0
	local steve_z: f32 = 0
	local section_index: number = 0
	vm.section(function()
		section_index = 1
		vm.entry(1)
		event.set_save_flag(104, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		sound_bank = event.load_sound_effect_file_3(4, 1813) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		initial_projection = event.get_event_projection() or initial_projection
		event.load_character_motion_pack(5, "event/e100/e104/e104_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/e100/e104/e104_ste_sta.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_sound_bank(1, sound_bank)
		event.load_character(5, "event/e100/e104/e104_erephant.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(2, 9)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.load_character(5, "event/e100/e104/e104_polcurse.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(3, 10)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e100/e104/e104_iwa.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(4, 11)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/e100/e104/e104_iwakudake.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(7, 12)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_naguru.gltf", "info", 14)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(8, 14)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_object_sequence_position(8, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_naguru_hyaku.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.attach_object_handle_to_character(9, 15)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.set_object_sequence_position(9, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(9, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_naguru_upper.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(10, 16)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_position(10, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_smoke.gltf", "info", 17)
		event.set_character_active(0, 17)
		event.attach_object_handle_to_character(11, 17)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.set_object_sequence_position(11, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_overheat.gltf", "info", 18)
		event.set_character_active(0, 18)
		event.attach_object_handle_to_character(12, 18)
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.set_object_sequence_position(12, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.load_message_file(0, 5, "event/e100/e104/e104_1.txt")
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("e110ポル回転キラ")
		event.create_effect_work_buffer(5)
		event.stop_music(0)
		section_index = 2
		wait.frames(4)
		event.load_music(193)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.enable_drama_skip()
		event.set_character_active(1, 0)
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_character(10, 1)
		event.attach_object_handle_to_character(11, 2)
		event.attach_object_handle_to_character(12, 3)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.set_object_handle_visible(12, 1)
		event.set_camera_sequence_position(-20.33, 70.25, 59.65)
		event.set_camera_sequence_look_at(102.39, 53.16, 234.79)
		event.set_object_sequence_position(0, 1.77, 50.0, 89.12)
		event.set_object_sequence_rotation(0, 0.0, -3.0, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		section_index = 3
		wait.frames(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 4
		message.show_voiced(1040010)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(2.83, 72.97, 182.21)
		event.set_camera_sequence_look_at(1.93, 81.57, -215.48)
		event.set_object_sequence_position(2, 3.65, 50.0, -40.62)
		event.set_object_sequence_rotation(2, 0.0, -0.03, 0.0)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		start_projection = event.get_event_projection() or start_projection
		event.set_object_sequence_motion(2, "歩き")
		section_index = 5
		vm.wait(5)
		frame_count = 40
		frame = 1
		projection_step = vm.f32(vm.fdiv(vm.f32(vm.f32(867.9) - start_projection), frame_count))
		while frame < frame_count do
			current_projection = vm.f32(projection_step * frame)
			current_projection = vm.f32(start_projection + current_projection)
			event.set_event_projection(current_projection)
			section_index = 6
			vm.wait(6)
			frame = frame + 1
		end
		event.set_event_projection(start_projection)
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(62.56, 161.62, 59.5)
		event.set_camera_sequence_look_at(3.61, 179.88, 37.58)
		event.set_object_sequence_position(3, 1.97, 159.88, 33.85)
		event.set_object_sequence_rotation(3, 0.0, 0.04, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "おこりわらい顔")
		event.set_object_sequence_texture_animation(3, 1, "おこり目パチ")
		event.set_object_sequence_motion(3, "浮遊", 4, -1.0, 1)
		section_index = 7
		wait.frames(15)
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 8
		message.show_voiced(1040020)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(15.68, 76.92, 110.24)
		event.set_camera_sequence_look_at(5.46, 70.74, 129.29)
		event.set_object_sequence_position(0, 6.33, 49.45, 128.85)
		event.set_object_sequence_rotation(0, 0.0, 2.44, 0.0)
		event.set_object_sequence_texture_animation(0, 1, "くいしばり")
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		section_index = 9
		wait.frames(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 10
		message.show_voiced_for(1040030, 30)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-97.35, 80.94, 117.92)
		event.set_camera_sequence_look_at(-40.6, 80.11, 79.05)
		event.set_object_sequence_position(0, 4.49, 50.0, 81.42)
		event.set_object_sequence_rotation(0, 0.0, 2.89, 0.0)
		event.set_object_sequence_position(2, -5.42, 50.0, -60.99)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "歩き", 4, -1.0, 1)
		event.move_object_sequence(2, -0.37, 50.0, -5.7, 50)
		event.rotate_object_sequence(2, 0.0, -0.03, 0.0, 20)
		section_index = 11
		channel_pump_room.wait_for_frames(50, unused_wait_argument)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(15.68, 76.92, 110.24)
		event.set_camera_sequence_look_at(5.46, 70.74, 129.29)
		event.set_object_sequence_position(0, 6.33, 49.45, 128.85)
		event.set_object_sequence_rotation(0, 0.0, 2.44, 0.0)
		event.set_object_sequence_texture_animation(0, 1, "くいしばり")
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		section_index = 12
		wait.frames(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 13
		message.show_voiced_for(1040040, 30)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(2.83, 72.48, 182.21)
		event.set_camera_sequence_look_at(1.93, 128.72, -215.48)
		event.set_object_sequence_position(0, 3.24, 50.0, 118.73)
		event.set_object_sequence_rotation(0, 0.0, -3.0, 0.0)
		event.set_object_sequence_position(2, 3.84, 50.0, 41.34)
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(2, "ふりかぶる", 6)
		event.wait_object_sequence_motion_end(2)
		event.play_sound_effect(sound_bank, 1)
		section_index = 14
		object.wait_until_done(2)
		event.set_character_active(1, 12)
		event.set_character_active(1, 11)
		event.set_object_sequence_position(4, -61.22, 96.72, 70.37)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(7, -61.22, 96.72, 70.37)
		event.set_object_sequence_rotation(7, 0.0, 1.72, 0.0)
		event.set_object_sequence_motion(7, "岩", 4)
		event.set_character_active(0, 11)
		event.jump_object_sequence(7, -17.07, 99.51, 70.08, -0.4, 3)
		section_index = 15
		object.wait_until_done(7)
		event.set_object_sequence_motion(2, "岩があたる", 6)
		event.wait_object_sequence_motion_end(2)
		event.play_sound_effect(sound_bank, 2)
		event.set_object_sequence_motion(7, "砕ける岩", 0)
		section_index = 16
		wait.frames(28)
		event.set_character_active(0, 12)
		section_index = 17
		object.wait_until_done(2)
		event.set_object_sequence_position(0, 2.81, 50.0, 110.3)
		event.set_object_sequence_rotation(0, 0.0, -3.0, 0.0)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(-17.42, 72.3, 95.02)
		event.set_camera_sequence_look_at(8.94, 73.07, 115.98)
		event.set_character_texture_animation(0, 0, "怒り目")
		event.set_character_texture_animation(0, 0, "怒り口")
		event.set_object_sequence_texture_animation(0, 1, "振り向き顔")
		event.set_object_sequence_motion(0, "左を見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "左を見るL")
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 18
		message.show_voiced_for(1040050, 30)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-36.29, 169.1, 79.75)
		event.set_camera_sequence_look_at(1.07, 187.01, 33.65)
		event.set_object_sequence_texture_animation(3, 1, "おどろき口")
		event.play_sound_effect(sound_bank, 3)
		event.set_object_sequence_motion(3, "驚く", 6)
		event.queue_object_sequence_next_motion(3, "驚くL")
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 19
		message.show_voiced_for(1040060, 25)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 8)
		event.set_camera_sequence_position(-472.64, 157.68, -14.51)
		event.set_camera_sequence_look_at(-374.9, 159.09, -138.37)
		event.set_object_sequence_position(1, -698.91, 120.39, -1.62)
		event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
		event.set_object_sequence_scale(1, 1.2, 1.2, 1.2)
		event.play_music(1)
		event.move_camera_sequence(-489.82, 157.68, 2.84, -669.99, 159.09, 0.82, 14)
		event.set_object_sequence_motion(1, "岩抱えL", 4)
		section_index = 20
		camera.wait_until_done()
		section_index = 21
		wait.frames(30)
		event.set_camera_sequence_position(-649.06, 178.83, 1.06)
		event.set_camera_sequence_look_at(-739.64, 160.75, -2.5)
		event.play_sound_effect(sound_bank, 4)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 22
		message.show_voiced(1040070)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(-16.05, 82.67, 94.68)
		event.set_camera_sequence_look_at(0.78, 74.43, 106.59)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.play_sound_effect(sound_bank, 5)
		event.attach_object_handle_to_character(5, 1)
		event.set_object_handle_visible(5, 0)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(6, 0)
		event.set_object_sequence_motion(0, "すごいよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "すごいよL")
		section_index = 23
		wait.frames(3)
		event.set_mouth_texture_animations(0, "わらい口パク")
		section_index = 24
		message.show_voiced(1040080)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-595.13, 165.27, -0.58)
		event.set_camera_sequence_look_at(-680.32, 162.11, -0.34)
		event.set_object_sequence_motion(1, "構え", 4)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 25
		message.show_voiced(1040090)
		event.reset_mouth_texture_animations()
		event.stop_sound_effect(sound_bank, 4)
		event.play_sound_effect(sound_bank, 6)
		event.set_camera_sequence_position(-487.31, 136.74, -141.75)
		event.set_camera_sequence_look_at(-782.31, 197.24, 86.51)
		event.set_object_sequence_motion(1, "ジャンプ", 6, 0.4)
		event.queue_object_sequence_next_motion(1, "ジャンプL")
		section_index = 26
		wait.frames(3)
		event.jump_object_sequence(1, -410.14, 169.27, 125.29, -0.35, 33)
		index = 1
		while index < 33 do
			do
				local out1, out2, out3 = event.get_object_handle_position(1)
				steve_x = out1 or steve_x
				steve_y = out2 or steve_y
				steve_z = out3 or steve_z
			end
			event.set_camera_sequence_look_at(steve_x, steve_y + 60.0, steve_z)
			section_index = 27
			vm.wait(27)
			index = index + 1
		end
		event.set_character_active(1, 9)
		event.clear_camera_sequence()
		event.set_character_active(0, 0)
		event.set_character_active(0, 10)
		event.set_camera_sequence_position(123.01, 102.6, 37.52)
		event.set_camera_sequence_look_at(-195.66, 44.82, 141.63)
		event.set_object_sequence_position(1, 73.03, 63.16, 18.93)
		event.set_object_sequence_rotation(1, 0.0, -0.56, 0.0)
		event.set_object_sequence_position(2, -8.8, 50.0, 120.29)
		event.set_object_sequence_rotation(2, 0.0, 3.13, 0.0)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_object_sequence_position(1, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(1, 0.0, -0.03, 0.0)
		event.set_object_sequence_position(2, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(2, 0.0, -0.03, 0.0)
		event.set_character_active(1, 14)
		event.set_object_sequence_position(8, 73.03, 63.16, 18.93)
		event.set_object_sequence_rotation(8, 0.0, -0.56, 0.0)
		event.set_object_sequence_motion(8, "エフェクト_殴る", 6)
		event.set_object_sequence_motion(1, "殴る", 6)
		event.set_object_sequence_motion(2, "殴る", 6)
		event.wait_object_sequence_motion_end(1)
		event.wait_object_sequence_motion_end(2)
		event.play_sound_effect(sound_bank, 7)
		event.play_sound_effect(sound_bank, 8)
		section_index = 28
		object.wait_until_done(1)
		section_index = 29
		object.wait_until_done(2)
		event.set_character_active(0, 14)
		event.set_character_active(1, 8)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-96.23, 106.65, 44.67)
		event.set_camera_sequence_look_at(-84.09, 104.44, 47.57)
		event.set_object_sequence_position(1, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(1, 0.0, -0.03, 0.0)
		event.set_object_sequence_position(2, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(2, 0.0, -0.03, 0.0)
		event.set_object_sequence_scale(2, 1.0, 1.0, 1.0)
		event.set_character_active(1, 15)
		event.set_object_sequence_position(9, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(9, 0.0, -0.03, 0.0)
		event.set_object_sequence_motion(9, "エフェクト_百烈拳", 6)
		event.set_object_sequence_motion(1, "百烈拳", 6)
		event.set_object_sequence_motion(2, "百烈拳", 6)
		event.queue_object_sequence_next_motion(1, "アッパー", 6)
		event.queue_object_sequence_next_motion(2, "アッパー", 6)
		event.wait_object_sequence_motion_end(1)
		event.wait_object_sequence_motion_end(2)
		event.delay_camera_sequence_position_track(50)
		event.set_camera_sequence_position(-84.59, 72.69, -23.68)
		event.set_camera_sequence_look_at(65.91, 125.55, 145.6)
		event.delay_camera_sequence_position_track(49)
		event.set_camera_sequence_position(49.52, 88.47, 17.44)
		event.set_camera_sequence_look_at(1.9, 49.55, 248.07)
		index = 0
		while index < 75 do
			section_index = 30
			vm.wait(30)
			if index < 55 then
				if vm.imod(index, 4) == 0 then
					event.play_sound_effect(sound_bank, 7)
					event.play_sound_effect(sound_bank, 8)
				end
			end
			if index == 57 then
				event.play_sound_effect(sound_bank, 9)
			end
			index = index + 1
		end
		event.set_character_active(0, 15)
		event.set_character_active(1, 16)
		event.set_character_position(16, 3.84, 50.0, 41.34)
		event.set_character_rotation(16, 0.0, -0.03, 0.0)
		event.set_character_motion(16, "エフェクト_アッパー", 6)
		section_index = 31
		object.wait_until_done(1)
		section_index = 32
		object.wait_until_done(2)
		section_index = 33
		camera.wait_until_done()
		event.set_character_active(0, 16)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(2.43, 89.98, -21.91)
		event.set_camera_sequence_look_at(3.78, 84.72, 87.51)
		event.set_object_sequence_position(1, 2.05, 50.0, 102.48)
		event.set_object_sequence_rotation(1, 0.0, 3.13, 0.0)
		event.set_character_active(1, 17)
		event.set_object_sequence_position(11, 2.05, 50.0, 102.48)
		event.set_character_position(17, 2.05, 50.0, 102.48)
		event.set_character_rotation(17, 0.0, 3.13, 0.0)
		event.set_object_sequence_motion(11, "エフェクト_湯気", 4)
		event.set_object_sequence_motion(1, "どうじゃ！", 4)
		section_index = 34
		wait.frames(15)
		event.play_sound_effect(sound_bank, 10)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 35
		message.show_voiced(1040100)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 17)
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(-45.51, 69.87, 128.53)
		event.set_camera_sequence_look_at(-45.74, 88.49, 287.42)
		event.set_object_sequence_position(0, -45.61, 50.0, 154.61)
		event.set_object_sequence_rotation(0, 0.0, 2.53, 0.0)
		event.stop_sound_effect(sound_bank, 10)
		event.play_sound_effect(sound_bank, 11)
		event.set_object_sequence_motion(0, "すごいよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "すごいよL")
		section_index = 36
		wait.frames(3)
		event.set_mouth_texture_animations(0, "わらい口パク")
		section_index = 37
		message.show_voiced(1040110)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(2.48, 180.08, 53.9)
		event.set_camera_sequence_look_at(-2.43, 189.74, -146.57)
		event.set_object_sequence_position(3, -6.54, 165.12, -24.91)
		event.set_object_sequence_rotation(3, 0.0, 0.37, 0.0)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "わらい顔")
		event.set_object_sequence_texture_animation(3, 1, "通常目パチ")
		event.set_object_sequence_motion(3, "光をためるL", 4)
		event.set_object_sequence_motion(3, "光をためるL")
		section_index = 38
		object.wait_until_done(3)
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 39
		message.show_voiced(1040120)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(2.48, 211.26, 53.9)
		event.set_camera_sequence_look_at(-2.43, 150.53, -146.57)
		event.set_object_sequence_motion(3, "光を放つ", 6)
		event.wait_object_sequence_motion_end(3)
		section_index = 40
		object.wait_until_done(3)
		event.play_sound_effect(sound_bank, 12)
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-117.37, 146.51, -35.46)
		event.set_camera_sequence_look_at(103.37, 9.39, 23.71)
		event.set_object_sequence_position(2, -18.78, 50.0, -55.26)
		event.set_object_sequence_rotation(2, 0.0, 0.09, 0.0)
		event.create_effect_2("e110ポル回転キラ", 9)
		event.set_effect_first_vector(160.0, 140.0, 160.0)
		event.set_object_sequence_position(2, 0.86, 50.0, -22.64)
		event.set_object_sequence_rotation(2, 0.0, -0.87, 0.0)
		event.set_object_sequence_motion(2, "復活", 6)
		section_index = 41
		wait.frames(100)
		event.play_sound_effect(sound_bank, 13)
		event.set_camera_sequence_position(-87.08, 95.61, 51.87)
		event.set_camera_sequence_look_at(83.1, 98.77, -93.27)
		event.set_object_sequence_motion(2, "ブルブル", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		section_index = 42
		wait.frames(50)
		event.play_sound_effect(sound_bank, 14)
		event.set_camera_sequence_position(-79.4, 118.39, 76.29)
		event.set_camera_sequence_look_at(-11.32, 84.25, -20.1)
		event.set_object_sequence_position(2, -10.22, 50.0, -0.34)
		event.set_object_sequence_rotation(2, 0.0, -0.87, 0.0)
		section_index = 43
		vm.wait(43)
		section_index = 44
		wait.frames(30)
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(-14.86, 110.63, -24.65)
		event.set_camera_sequence_look_at(-30.63, 87.29, 63.28)
		event.set_object_sequence_position(1, -33.56, 49.19, 71.0)
		event.set_object_sequence_rotation(1, 0.0, 2.93, 0.0)
		event.set_object_sequence_motion(1, "構え", 4)
		event.play_sound_effect(sound_bank, 15)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 45
		message.show_voiced(1040130)
		event.reset_mouth_texture_animations()
		event.set_object_handle_frame_visible(3, "cyl2", 0)
		event.set_camera_sequence_position(29.47, 85.69, 10.08)
		event.set_camera_sequence_look_at(-135.3, 106.15, 168.51)
		event.play_sound_effect(sound_bank, 16)
		event.play_sound_effect(sound_bank, 17)
		event.play_sound_effect(sound_bank, 18)
		event.set_object_sequence_motion(1, "手をまわす", 6)
		event.queue_object_sequence_next_motion(1, "手をまわすL")
		section_index = 46
		object.wait_until_done(1)
		section_index = 47
		camera.wait_until_done()
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 48
		message.show_voiced(1040140)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 18)
		event.set_character_position(18, -33.56, 49.19, 71.0)
		event.set_character_rotation(18, 0.0, 2.93, 0.0)
		event.set_character_scale(18, 1.2, 1.2, 1.2)
		event.set_object_sequence_motion(12, "オーバーヒート\t", 4)
		event.fade_out_music(30)
		event.stop_sound_effect(sound_bank, 15)
		event.play_sound_effect(sound_bank, 19)
		event.set_object_sequence_motion(1, "ガコン", 6)
		event.queue_object_sequence_next_motion(1, "ガコンL")
		section_index = 49
		object.wait_until_done(1)
		event.play_sound_effect(sound_bank, 20)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 50
		message.show_voiced(1040150)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 18)
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(-84.61, 67.09, 17.57)
		event.set_camera_sequence_look_at(46.83, 120.54, 229.76)
		event.set_object_sequence_position(0, -51.32, 49.7, 99.35)
		event.set_object_sequence_rotation(0, 0.0, 1.48, 0.0)
		event.set_character_position(0, -51.32, 49.7, 99.35)
		event.set_character_rotation(0, 0.0, 1.48, 0.0)
		event.set_object_sequence_position(1, -18.48, 49.19, 89.15)
		event.set_object_sequence_rotation(1, 0.0, -2.87, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "ガコンL", 4)
		event.set_object_sequence_motion(0, "上見会話", 2)
		event.queue_object_sequence_next_motion(0, "上見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 51
		message.show_voiced(1040160)
		event.reset_mouth_texture_animations()
		section_index = 52
		message.show_voiced(1040170)
		event.set_object_sequence_motion(1, "ミンツを見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL")
		section_index = 53
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 54
		message.show_voiced(1040171)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 55
		message.show_voiced(1040172)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 56
		message.show_voiced(1040180)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-26.67, 89.04, 100.9)
		event.set_camera_sequence_look_at(-181.84, -8.6, 101.99)
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "ガコンL", 4)
		event.set_object_sequence_motion(0, "上見会話", 2)
		event.queue_object_sequence_next_motion(0, "上見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		section_index = 57
		message.show_voiced(1040190)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(3.1, 137.71, 121.7)
		event.set_camera_sequence_look_at(-96.45, -19.65, 33.14)
		event.set_object_sequence_position(0, -52.15, 49.3, 100.27)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "ガコンL", 4)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 58
		message.show_voiced(1040200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "ミンツを見る戻り", 6)
		event.play_sound_effect(sound_bank, 21)
		section_index = 59
		wait.frames(15)
		event.stop_sound_effect(sound_bank, 20)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 60
		message.show_voiced(1040201)
		event.reset_mouth_texture_animations()
		section_index = 61
		object.wait_until_done(1)
		event.set_camera_sequence_position(-35.68, 98.0, 30.68)
		event.set_camera_sequence_look_at(10.9, 100.95, 171.17)
		event.set_object_sequence_position(0, -18.48, 49.19, 89.15)
		event.set_object_sequence_rotation(0, 0.0, -2.87, 0.0)
		event.set_object_sequence_scale(0, 1.2, 1.2, 1.2)
		event.set_object_sequence_position(1, -18.48, 49.19, 89.15)
		event.set_object_sequence_rotation(1, 0.0, -2.87, 0.0)
		event.play_sound_effect(sound_bank, 15)
		event.play_sound_effect(sound_bank, 22)
		event.set_object_sequence_motion(0, "スティーブに乗る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "スティーブに乗るL")
		section_index = 62
		object.wait_until_done(0)
		section_index = 63
		wait.frames(15)
		event.set_character_active(0, 8)
		event.set_character_active(0, 0)
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(-155.09, 107.3, 7.35)
		event.set_camera_sequence_look_at(-110.59, 116.9, -6.56)
		event.set_object_sequence_position(2, -21.45, 49.19, 21.76)
		event.set_object_sequence_rotation(2, 0.0, -1.87, 0.0)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_object_sequence_position(3, -69.17, 111.79, -20.32)
		event.set_object_sequence_rotation(3, 0.0, -1.75, 0.0)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 64
		message.show_voiced(1040210)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 23)
		event.set_object_sequence_motion(3, "殺っておしまい", 6)
		event.queue_object_sequence_next_motion(3, "殺っておしまいL")
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 65
		message.show_voiced(1040211)
		event.reset_mouth_texture_animations()
		section_index = 66
		object.wait_until_done(3)
		event.set_character_active(0, 10)
		event.set_camera_sequence_position(-166.8, 110.8, 7.81)
		event.set_camera_sequence_look_at(-73.91, 78.74, 3.61)
		event.set_object_sequence_position(2, -20.92, 49.19, 0.18)
		event.set_object_sequence_rotation(2, 0.0, -1.51, 0.0)
		start_projection = event.get_event_projection() or start_projection
		event.set_object_sequence_motion(2, "突進", 4)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 60)
		event.move_camera_sequence(-524.07, 92.61, 14.81, -374.2, 78.74, 8.04, 60)
		event.move_object_sequence(2, -408.03, 50.0, 7.63, 60)
		section_index = 67
		channel_pump_room.interpolate_projection(start_projection, vm.f32(524.9), 60, unused_wait_argument)
		event.set_event_projection(start_projection)
		event.set_character_active(1, 0)
		event.set_character_active(1, 8)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-289.45, 186.74, -103.76)
		event.set_camera_sequence_look_at(-436.94, 140.81, -26.0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_scale(0, 1.0, 1.0, 1.0)
		event.attach_character_to_frame(8, "mints", 0)
		event.set_object_sequence_position(1, -504.42, 50.21, 25.83)
		event.set_object_sequence_rotation(1, 0.0, 1.48, 0.0)
		event.set_object_sequence_scale(1, 1.0, 1.0, 1.0)
		event.set_object_sequence_position(2, -316.2, 45.22, 44.35)
		event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
		event.set_object_sequence_motion(0, "スティーブに乗るL", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "突進", 4)
		event.delay_object_sequence_motion_track(2, 10)
		event.set_object_sequence_motion(2, "立ち")
		event.move_object_sequence(2, -366.82, 45.22, 14.07, 15)
		event.set_object_sequence_motion(1, "バックジャンプ", 6, 0.4)
		event.play_sound_effect(sound_bank, 24)
		event.jump_object_sequence(1, -744.89, 134.13, 0.74, -0.35, 33)
		section_index = 68
		object.wait_until_done(2)
		section_index = 69
		object.wait_until_done(1)
		event.set_camera_sequence_position(-640.55, 176.56, -6.9)
		event.set_camera_sequence_look_at(-739.25, 169.31, -1.66)
		event.set_object_sequence_position(1, -734.79, 134.97, -2.3)
		event.set_object_sequence_rotation(1, 0.0, 1.64, 0.0)
		event.set_object_sequence_motion(0, "スティーブに乗るL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4)
		section_index = 70
		wait.frames(15)
		event.set_object_sequence_motion(1, "さらばじゃ", 2)
		event.play_sound_effect(sound_bank, 25)
		event.set_mouth_texture_animations(1, "口パク")
		section_index = 71
		message.show_voiced(1040220)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 26)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.rotate_object_sequence(1, 0.0, -1.6, 0.0, 30)
		section_index = 72
		object.wait_until_done(1)
		event.move_object_sequence(1, -937.66, 134.97, -0.71, 60)
		section_index = 73
		object.wait_until_done(1)
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(-326.4, 171.06, 5.03)
		event.set_camera_sequence_look_at(87.54, 136.02, -63.19)
		event.set_object_sequence_position(2, -343.04, 49.6, -15.01)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(3, -286.2, 134.97, -1.83)
		event.set_object_sequence_rotation(3, 0.0, -1.72, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.stop_sound_effect(sound_bank, 15)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "あらあら", 4)
		event.set_mouth_texture_animations(3, "わらい口パク")
		section_index = 74
		message.show_voiced(1040230)
		event.reset_mouth_texture_animations()
		section_index = 75
		object.wait_until_done(3)
		event.set_camera_sequence_position(-584.1, 136.54, 9.53)
		event.set_camera_sequence_look_at(87.54, 80.4, -63.19)
		event.set_object_sequence_position(3, -344.47, 145.98, -65.24)
		event.set_object_sequence_rotation(3, 0.0, -1.36, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.play_sound_effect(sound_bank, 27)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(18)
		event.fade_out_camera_sequence(100, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "パオーン", 6)
		section_index = 76
		object.wait_until_done(2)
		section_index = 77
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if section_index <= 1 then
			wait.frames_skipping(4)
		end
		if section_index <= 2 then
			wait.frames_skipping(15)
		end
		if section_index <= 3 then
			message.show_voiced_skipping(1040010)
		end
		if section_index <= 5 then
			frame_count = 40
			frame = 1
			projection_step = vm.f32(vm.fdiv(vm.f32(vm.f32(867.9) - start_projection), frame_count))
			current_projection = vm.f32(projection_step * frame)
			current_projection = vm.f32(start_projection + current_projection)
		end
		if section_index <= 6 then
			local _ = frame < frame_count
			frame = frame + 1
			wait.frames_skipping(15)
		end
		if section_index <= 7 then
			message.show_voiced_skipping(1040020)
		end
		if section_index <= 8 then
			wait.frames_skipping(15)
		end
		if section_index <= 9 then
			message.show_voiced_for_skipping(1040030, 30)
		end
		if section_index <= 10 then
			channel_pump_room.skip_wait_frame_loop(50, unused_wait_argument)
		end
		if section_index <= 11 then
			wait.frames_skipping(15)
		end
		if section_index <= 12 then
			message.show_voiced_for_skipping(1040040, 30)
		end
		if section_index <= 13 then
			cutscene.skip_command(2)
		end
		if section_index <= 14 then
			cutscene.skip_command(7)
		end
		if section_index <= 15 then
			wait.frames_skipping(28)
		end
		if section_index <= 16 then
			cutscene.skip_command(2)
		end
		if section_index <= 17 then
			message.show_voiced_for_skipping(1040050, 30)
		end
		if section_index <= 18 then
			message.show_voiced_for_skipping(1040060, 25)
		end
		if section_index <= 19 then
			wait.background_load_skipping()
		end
		if section_index <= 20 then
			wait.frames_skipping(30)
		end
		if section_index <= 21 then
			message.show_voiced_skipping(1040070)
		end
		if section_index <= 22 then
			wait.frames_skipping(3)
		end
		if section_index <= 23 then
			message.show_voiced_skipping(1040080)
		end
		if section_index <= 24 then
			message.show_voiced_skipping(1040090)
		end
		if section_index <= 25 then
			wait.frames_skipping(3)
		end
		if section_index <= 26 then
			index = 1
		end
		if section_index <= 27 then
			local _ = index < 33
			index = index + 1
			cutscene.skip_command(1)
		end
		if section_index <= 28 then
			cutscene.skip_command(2)
		end
		if section_index <= 29 then
			index = 0
		end
		if section_index <= 30 then
			local _ = index < 75
			local _ = index < 55
			local _ = vm.imod(index, 4) == 0
			local _ = index == 57
			index = index + 1
			cutscene.skip_command(1)
		end
		if section_index <= 31 then
			cutscene.skip_command(2)
		end
		if section_index <= 32 then
			wait.background_load_skipping()
		end
		if section_index <= 33 then
			wait.frames_skipping(15)
		end
		if section_index <= 34 then
			message.show_voiced_skipping(1040100)
		end
		if section_index <= 35 then
			wait.frames_skipping(3)
		end
		if section_index <= 36 then
			message.show_voiced_skipping(1040110)
		end
		if section_index <= 37 then
			cutscene.skip_command(3)
		end
		if section_index <= 38 then
			message.show_voiced_skipping(1040120)
		end
		if section_index <= 39 then
			cutscene.skip_command(3)
		end
		if section_index <= 40 then
			wait.frames_skipping(100)
		end
		if section_index <= 41 then
			wait.frames_skipping(50)
		end
		if section_index <= 43 then
			wait.frames_skipping(30)
		end
		if section_index <= 44 then
			message.show_voiced_skipping(1040130)
		end
		if section_index <= 45 then
			cutscene.skip_command(1)
		end
		if section_index <= 46 then
			wait.background_load_skipping()
		end
		if section_index <= 47 then
			message.show_voiced_skipping(1040140)
		end
		if section_index <= 48 then
			cutscene.skip_command(1)
		end
		if section_index <= 49 then
			message.show_voiced_skipping(1040150)
		end
		if section_index <= 50 then
			message.show_voiced_skipping(1040160)
		end
		if section_index <= 51 then
			message.show_voiced_skipping(1040170)
		end
		if section_index <= 52 then
			cutscene.skip_command(1)
		end
		if section_index <= 53 then
			message.show_voiced_skipping(1040171)
		end
		if section_index <= 54 then
			message.show_voiced_skipping(1040172)
		end
		if section_index <= 55 then
			message.show_voiced_skipping(1040180)
		end
		if section_index <= 56 then
			message.show_voiced_skipping(1040190)
		end
		if section_index <= 57 then
			message.show_voiced_skipping(1040200)
		end
		if section_index <= 58 then
			wait.frames_skipping(15)
		end
		if section_index <= 59 then
			message.show_voiced_skipping(1040201)
		end
		if section_index <= 60 then
			cutscene.skip_command(1)
		end
		if section_index <= 61 then
			cutscene.skip_command(0)
		end
		if section_index <= 62 then
			wait.frames_skipping(15)
		end
		if section_index <= 63 then
			message.show_voiced_skipping(1040210)
		end
		if section_index <= 64 then
			message.show_voiced_skipping(1040211)
		end
		if section_index <= 65 then
			cutscene.skip_command(3)
		end
		if section_index <= 66 then
			channel_pump_room.skip_interpolation_wait(start_projection, vm.f32(524.9), 60, unused_wait_argument)
		end
		if section_index <= 67 then
			cutscene.skip_command(2)
		end
		if section_index <= 68 then
			cutscene.skip_command(1)
		end
		if section_index <= 69 then
			wait.frames_skipping(15)
		end
		if section_index <= 70 then
			message.show_voiced_skipping(1040220)
		end
		if section_index <= 71 then
			cutscene.skip_command(1)
		end
		if section_index <= 72 then
			cutscene.skip_command(1)
		end
		if section_index <= 73 then
			message.show_voiced_skipping(1040230)
		end
		if section_index <= 74 then
			cutscene.skip_command(3)
		end
		if section_index <= 75 then
			cutscene.skip_command(2)
		end
		if section_index <= 76 then
			wait.background_load_skipping()
		end
		return true
	end)
	section_index = 78
	vm.entry(78)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	section_index = 79
	wait.frames(4)
	event.clear_effect_manager()
	event.stop_sound_effect(sound_bank, 4)
	event.stop_sound_effect(sound_bank, 10)
	event.stop_sound_effect(sound_bank, 15)
	event.stop_sound_effect(sound_bank, 20)
	event.stop_sound_effect(sound_bank, 28)
	event.set_character_scale(0, 1.0, 1.0, 1.0)
	event.set_event_projection(initial_projection)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
end

--- Shows the hero and Steve puzzled by a sight and speaks their voiced line.
function channel_pump_room.play_puzzled_reaction(unused_argument: any)
	event.set_camera_sequence_position(-355.99, 88.75, 12.43)
	event.set_camera_sequence_look_at(-376.3, 90.49, 31.84)
	event.set_character_active(1, 0)
	event.set_character_active(1, 9)
	event.set_object_sequence_motion(0, "あれ？", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(0, "あれ？L")
	event.set_object_sequence_motion(1, "あれ？", 6)
	event.queue_object_sequence_next_motion(1, "あれ？L")
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1070010)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.set_object_sequence_position(0, -348.51, 50.51, -12.26)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -348.51, 50.51, -12.26)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
end

--- Shows the hero and Steve startled and speaks their voiced line.
function channel_pump_room.play_startled_reaction(unused_argument: any)
	event.set_camera_sequence_position(-221.89, 93.35, -18.76)
	event.set_camera_sequence_look_at(-248.13, 94.53, -3.27)
	event.set_object_sequence_position(0, -245.08, 50.51, -6.05)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -245.08, 50.51, -6.05)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_motion(0, "驚く", 6)
	event.set_object_sequence_motion(1, "驚く", 6)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1070030)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
	object.wait_until_done(1)
end

--- Shows Steve trembling and then jumping away while the camera follows.
function channel_pump_room.play_steve_flee_jump(sound_bank: s32)
	event.set_camera_sequence_position(-408.29, 60.12, 94.13)
	event.set_camera_sequence_look_at(-475.86, 71.34, 81.15)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -492.64, 50.09, 76.79)
	event.set_object_sequence_rotation(0, 0.0, 1.2, 0.0)
	event.set_object_sequence_motion(0, "プルプル", 4, -1.0, 1)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -492.64, 50.09, 76.79)
	event.set_object_sequence_rotation(1, 0.0, 1.2, 0.0)
	event.set_object_sequence_motion(1, "プルプル", 4)
	event.play_sound_effect(sound_bank, 0)
	wait.frames(50)
	event.play_sound_effect(sound_bank, 2)
	event.set_object_sequence_motion(0, "ジャンプ", 6, 0.4)
	event.set_object_sequence_motion(1, "ジャンプ", 6, 0.4)
	event.delay_object_sequence_position_track(0, 3)
	event.delay_object_sequence_position_track(1, 3)
	event.jump_object_sequence(0, -739.96, 133.89, -9.49, -0.28, 33)
	event.jump_object_sequence(1, -739.96, 133.89, -9.49, -0.28, 33)
	event.wait_object_sequence_motion_end(0)
	event.wait_object_sequence_motion_end(1)
	event.move_camera_sequence_eased(-408.29, 60.12, 94.13, -709.98, 167.81, 0.97, 25, 0, 0.4)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.stop_sound_effect(sound_bank, 0)
end

--- Makes Steve jump across the gap, spawns dust effects on landing and returns to standing.
function channel_pump_room.play_steve_jump_landing(sound_bank: s32)
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local index: s32 = 0
	local landing_x: f32 = 0
	local landing_y: f32 = 0
	local landing_z: f32 = 0
	event.set_camera_sequence_position(-302.7, 76.94, -10.38)
	event.set_camera_sequence_look_at(-787.0, 134.76, 18.98)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.play_sound_effect(sound_bank, 1)
	event.set_object_sequence_motion(0, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(1, "立ち（スティーブ）")
	event.delay_object_sequence_position_track(0, 3)
	event.delay_object_sequence_position_track(1, 3)
	event.jump_object_sequence(0, -378.73, 50.06, 32.39, -0.35, 31)
	event.jump_object_sequence(1, -378.73, 50.06, 32.39, -0.35, 31)
	index = 0
	wait.frames(2)
	while index < 31 do
		do
			local out1, out2, out3 = event.get_character_position(9)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		event.set_camera_sequence_look_at(character_x - 14.5, character_y + 17.0, character_z + vm.f32(21.3))
		vm.wait(2)
		index = index + 1
	end
	wait.frames(2)
	do
		local out1, out2, out3 = event.get_character_position(9)
		landing_x = out1 or landing_x
		landing_y = out2 or landing_y
		landing_z = out3 or landing_z
	end
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(landing_x, landing_y + 5.0, landing_z)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-378.99, 55.0, 20.63)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-379.65, 55.0, 46.12)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	wait.frames(20)
	event.play_sound_effect(sound_bank, 2)
	event.play_sound_effect(sound_bank, 0)
	event.set_camera_sequence_position(-290.45, 68.57, 35.18)
	event.set_camera_sequence_look_at(-328.09, 70.17, 34.47)
	event.reset_object_sequence_dynamic_animation(0)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4, -1.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4, -1.0)
	wait.frames(30)
end

--- Makes Steve jump across the gap, spawns dust effects on landing and returns to standing.
function channel_pump_room.play_steve_jump_landing_variant(sound_bank: s32)
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local index: s32 = 0
	local landing_x: f32 = 0
	local landing_y: f32 = 0
	local landing_z: f32 = 0
	event.set_camera_sequence_position(-302.7, 76.94, -10.38)
	event.set_camera_sequence_look_at(-787.0, 134.76, 18.98)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.play_sound_effect(sound_bank, 1)
	event.set_object_sequence_motion(0, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(1, "立ち（スティーブ）")
	event.delay_object_sequence_position_track(0, 3)
	event.delay_object_sequence_position_track(1, 3)
	event.jump_object_sequence(0, -378.73, 50.06, 32.39, -0.35, 31)
	event.jump_object_sequence(1, -378.73, 50.06, 32.39, -0.35, 31)
	index = 0
	wait.for_frame_count(2)
	while index < 31 do
		do
			local out1, out2, out3 = event.get_character_position(9)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		event.set_camera_sequence_look_at(character_x - 14.5, character_y + 17.0, character_z + vm.f32(21.3))
		vm.wait(2)
		index = index + 1
	end
	wait.for_frame_count(2)
	do
		local out1, out2, out3 = event.get_character_position(9)
		landing_x = out1 or landing_x
		landing_y = out2 or landing_y
		landing_z = out3 or landing_z
	end
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(landing_x, landing_y + 5.0, landing_z)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-378.99, 55.0, 20.63)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-379.65, 55.0, 46.12)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	wait.for_frame_count(20)
	event.play_sound_effect(sound_bank, 2)
	event.play_sound_effect(sound_bank, 0)
	event.set_camera_sequence_position(-290.45, 68.57, 35.18)
	event.set_camera_sequence_look_at(-328.09, 70.17, 34.47)
	event.reset_object_sequence_dynamic_animation(0)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4, -1.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4, -1.0)
	wait.for_frame_count(30)
end

--- Walks Steve into the room, then makes him jump across the gap with dust effects on landing.
function channel_pump_room.play_steve_walk_and_jump(sound_bank: s32)
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local index: s32 = 0
	local landing_x: f32 = 0
	local landing_y: f32 = 0
	local landing_z: f32 = 0
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(200, 0.0, 0.0, 0.0)
	event.set_camera_sequence_position(1010.98, 218.14, -55.12)
	event.set_camera_sequence_look_at(-755.14, 237.29, -2.56)
	event.set_object_sequence_position(0, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.move_camera_sequence(64.12, 205.59, -18.9, -755.14, 157.59, -2.56, 120)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 120)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 120)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.set_camera_sequence_position(-667.47, 186.39, -3.73)
	event.set_camera_sequence_look_at(-755.14, 160.61, -2.56)
	event.set_object_sequence_position(0, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 20)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 20)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "立ち（スティーブ）")
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	wait.frames(30)
	event.set_camera_sequence_position(-302.7, 76.94, -10.38)
	event.set_camera_sequence_look_at(-787.0, 134.76, 18.98)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.play_sound_effect(sound_bank, 2)
	event.set_object_sequence_motion(0, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(1, "立ち（スティーブ）")
	event.delay_object_sequence_position_track(0, 3)
	event.delay_object_sequence_position_track(1, 3)
	event.jump_object_sequence(0, -378.73, 50.06, 32.39, -0.35, 31)
	event.jump_object_sequence(1, -378.73, 50.06, 32.39, -0.35, 31)
	index = 0
	wait.frames(2)
	while index < 31 do
		do
			local out1, out2, out3 = event.get_character_position(9)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		event.set_camera_sequence_look_at(character_x - 14.5, character_y + 17.0, character_z + vm.f32(21.3))
		vm.wait(11)
		index = index + 1
	end
	do
		local out1, out2, out3 = event.get_character_position(9)
		landing_x = out1 or landing_x
		landing_y = out2 or landing_y
		landing_z = out3 or landing_z
	end
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(landing_x, landing_y + 5.0, landing_z)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-378.99, 55.0, 20.63)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-379.65, 55.0, 46.12)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	wait.frames(22)
	event.play_sound_effect(sound_bank, 3)
	event.play_sound_effect(sound_bank, 1)
	event.set_camera_sequence_position(-261.64, 62.84, 2.96)
	event.set_camera_sequence_look_at(-368.77, 78.25, 5.08)
	event.set_object_sequence_position(0, -377.87, 50.06, 4.42)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -377.87, 50.06, 4.42)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	object.wait_until_done(0)
	object.wait_until_done(1)
	wait.frames(30)
end

--- Walks Steve into the room, then makes him jump across the gap with dust effects on landing.
function channel_pump_room.play_steve_walk_and_jump_variant(sound_bank: s32)
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local index: s32 = 0
	local landing_x: f32 = 0
	local landing_y: f32 = 0
	local landing_z: f32 = 0
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(200, 0.0, 0.0, 0.0)
	event.set_camera_sequence_position(1010.98, 218.14, -55.12)
	event.set_camera_sequence_look_at(-755.14, 237.29, -2.56)
	event.set_object_sequence_position(0, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.move_camera_sequence(64.12, 205.59, -18.9, -755.14, 157.59, -2.56, 120)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 120)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 120)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.set_camera_sequence_position(-667.47, 186.39, -3.73)
	event.set_camera_sequence_look_at(-755.14, 160.61, -2.56)
	event.set_object_sequence_position(0, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 20)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 20)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "立ち（スティーブ）")
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	wait.for_frame_count(30)
	event.set_camera_sequence_position(-302.7, 76.94, -10.38)
	event.set_camera_sequence_look_at(-787.0, 134.76, 18.98)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.play_sound_effect(sound_bank, 2)
	event.set_object_sequence_motion(0, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(1, "立ち（スティーブ）")
	event.delay_object_sequence_position_track(0, 3)
	event.delay_object_sequence_position_track(1, 3)
	event.jump_object_sequence(0, -378.73, 50.06, 32.39, -0.35, 31)
	event.jump_object_sequence(1, -378.73, 50.06, 32.39, -0.35, 31)
	index = 0
	wait.for_frame_count(2)
	while index < 31 do
		do
			local out1, out2, out3 = event.get_character_position(9)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		event.set_camera_sequence_look_at(character_x - 14.5, character_y + 17.0, character_z + vm.f32(21.3))
		vm.wait(11)
		index = index + 1
	end
	do
		local out1, out2, out3 = event.get_character_position(9)
		landing_x = out1 or landing_x
		landing_y = out2 or landing_y
		landing_z = out3 or landing_z
	end
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(landing_x, landing_y + 5.0, landing_z)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-378.99, 55.0, 20.63)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-379.65, 55.0, 46.12)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	wait.for_frame_count(22)
	event.play_sound_effect(sound_bank, 3)
	event.play_sound_effect(sound_bank, 1)
	event.set_camera_sequence_position(-261.64, 62.84, 2.96)
	event.set_camera_sequence_look_at(-368.77, 78.25, 5.08)
	event.set_object_sequence_position(0, -377.87, 50.06, 4.42)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -377.87, 50.06, 4.42)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	object.wait_until_done(0)
	object.wait_until_done(1)
	wait.for_frame_count(30)
end

--- Fades in and walks both Steve objects across the pump room entrance while the camera pans.
function channel_pump_room.play_steve_walk_in(unused_argument: any)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(200, 0.0, 0.0, 0.0)
	event.set_camera_sequence_position(1010.98, 218.14, -55.12)
	event.set_camera_sequence_look_at(-755.14, 237.29, -2.56)
	event.set_object_sequence_position(0, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.move_camera_sequence(64.12, 205.59, -18.9, -755.14, 157.59, -2.56, 120)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 120)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 120)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	wait.frames(120)
	camera.wait_until_done()
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	vm.wait(3)
	event.set_camera_sequence_position(-667.47, 186.39, -3.73)
	event.set_camera_sequence_look_at(-755.14, 160.61, -2.56)
	event.set_object_sequence_position(0, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 20)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 20)
	wait.frames(20)
	event.set_object_sequence_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "立ち（スティーブ）")
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	wait.frames(30)
end

--- Poses both Steve objects in victory while Polcurse laughs and speaks a line.
function channel_pump_room.play_victory_pose(sound_bank: s32)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -167.59, 50.0, 2.86)
	event.set_object_sequence_rotation(0, 0.0, 1.77, 0.0)
	event.set_object_sequence_motion(0, "勝利のポーズ", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -167.59, 50.0, 2.86)
	event.set_object_sequence_rotation(1, 0.0, 1.77, 0.0)
	event.set_object_sequence_motion(1, "勝利のポーズ", 4)
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(1080010)
	event.reset_mouth_texture_animations()
	event.stop_sound_effect(sound_bank, 0)
end

--- Plays a sound effect and shows both characters in the victory pose with a camera move.
function channel_pump_room.play_victory_pose_shot(sound_bank: s32)
	event.play_sound_effect(sound_bank, 0)
	event.set_camera_sequence_position(39.97, 95.45, -42.29)
	event.set_camera_sequence_look_at(-401.26, 72.44, 58.46)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -167.59, 50.0, 2.86)
	event.set_object_sequence_rotation(0, 0.0, 1.77, 0.0)
	event.set_object_sequence_motion(0, "勝利のポーズ", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -167.59, 50.0, 2.86)
	event.set_object_sequence_rotation(1, 0.0, 1.77, 0.0)
	event.set_object_sequence_motion(1, "勝利のポーズ", 4)
	event.set_character_active(0, 10)
	event.move_camera_sequence_eased(-117.38, 95.45, -6.36, -401.26, 72.44, 58.46, 20, 2, 0.4)
	camera.wait_until_done()
end

--- Replaces an unset rate of -1 with a default rate of 0.01.
function channel_pump_room.replace_unset_rate(unused_0: s32, unused_1: f32, rate: f32, unused_3: s32)
	local _ = rate == -1.0
	rate = vm.f32(0.01)
end

--- Puts both Steve objects in a standing pose and speaks the next line.
function channel_pump_room.reset_party_standing(sound_bank: s32)
	event.set_camera_sequence_position(-211.94, 92.54, -16.62)
	event.set_camera_sequence_look_at(-237.74, 91.77, -7.1)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -245.08, 50.51, -6.05)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -245.08, 50.51, -6.05)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.stop_sound_effect(sound_bank, 0)
	message.show_voiced(1070020)
end

--- Speaks the attack-order line, then waits for the camera and for object 2.
function channel_pump_room.say_attack_command(unused_argument: s32)
	message.show_voiced_for_stopping_skipping(1030200, 100)
	wait.background_load_skipping()
	cutscene.skip_command(2)
end

--- Speaks the attack-order line, then waits for the camera and for object 2.
function channel_pump_room.say_attack_command_variant(unused_argument: s32)
	message.show_voiced_for_skipping(1030200, 100)
	wait.background_load_skipping()
	cutscene.skip_command(2)
end

--- Initializes the event and attaches map part handles whose visibility follows the argument.
function channel_pump_room.setup_map_part_handles(is_visible: s32)
	event.initialize_event()
	event.attach_object_handle_to_map_part_3(0, "p01_s06", "s06_02-a0")
	event.attach_object_handle_to_map_part_3(1, "p01_s06", "s06_03-a0")
	if is_visible ~= 0 then
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_visible(1, 1)
	else
		event.set_object_handle_visible(0, 0)
		event.set_object_handle_visible(1, 0)
	end
end

--- Skip-path stand-in for a timed interpolation between two values that only counts frames up to the duration.
function channel_pump_room.skip_interpolation_wait(start_value: f32, end_value: f32, duration: any, extra_value: any)
	local index: s32 = 0
	index = 0
	local _ = index < duration
	index = index + 1
end

--- Skip-path stand-in for waiting on a motion ratio that normalizes the playback speed.
function channel_pump_room.skip_motion_wait(object_index: s32, motion_ratio: f32, speed: f32, frame_count: any)
	local _ = speed == -1.0
	speed = vm.f32(0.01)
	local _ = frame_count > 0
end

--- Does nothing in place of a counted frame-wait loop when the event is skipped.
function channel_pump_room.skip_wait_frame_loop(frame_count: any, unused_argument: any)
	local frame: s32 = 0
	frame = 0
	local _ = frame < frame_count
	frame = frame + 1
end

--- Does nothing in place of a counted frame-wait loop when the event is skipped.
function channel_pump_room.skip_wait_frame_loop_variant(frame_count: s32, unused_argument: any)
	local frame: s32 = 0
	frame = 0
	local _ = frame < frame_count
	frame = frame + 1
end

--- Steps the event projection from a start value to an end value over a number of frames.
function channel_pump_room.tween_projection(start_projection: f32, end_projection: f32, frame_count: s32, unused_argument: any)
	local frame: s32 = 0
	local projection_step: s32 = 0
	frame = 0
	projection_step = vm.idiv(vm.ftoi(vm.f32(end_projection - start_projection)), frame_count)
	while frame < frame_count do
		event.set_event_projection(start_projection + vm.i32(projection_step * frame))
		vm.wait(1)
		frame = frame + 1
	end
end

--- Waits the given number of frames one at a time.
function channel_pump_room.wait_for_frames(frame_count: any, unused_argument: any)
	local frame: s32 = 0
	frame = 0
	while frame < frame_count do
		vm.wait(1)
		frame = vm.i32(frame + 1)
	end
end

--- Waits the given number of frames one frame at a time.
function channel_pump_room.wait_frame_loop(frame_count: s32, unused_1: any)
	for frame = 0, frame_count - 1 do
		vm.wait(1)
	end
end

return channel_pump_room
