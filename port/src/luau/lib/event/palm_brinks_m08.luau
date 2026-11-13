--!strict
--- Cutscenes and scene setup specific to the Palm Brinks (m08 variant) map.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local palm_brinks_m08 = {}

--- Plays the skippable opening cutscene of the hero running through the town after the pierrots, with voiced dialogue, then removes its characters.
function palm_brinks_m08.play_opening_chase_cutscene()
	local voice_load_frames: s32 = 0
	local sound_bank: s32 = 0
	local fall_frame: s32 = 0
	local fall_speed: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.initialize_event()
		event.enable_drama_skip()
		event.set_event_projection(618.0)
		event.set_time_of_day(24.0)
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(1220)
		sound_bank = event.load_sound_effect_file_2(1220) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p5/op5_1.txt")
		event.set_character_shadow_culling_off(0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 2164.03, 0.0, 1594.92)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.load_item_model(5, 1, "info", 9)
		event.set_character_active(0, 9)
		event.attach_character_to_frame(0, "ef00", 9)
		event.load_character(5, "event/opening/p5/p5_halloween.gltf", "p00_10a", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.load_character(5, "event/opening/p5/p5_polcurse.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_frame_visible(3, "sashi", 0)
		event.set_object_handle_frame_visible(3, "cube61_8", 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.attach_character_to_frame(10, "polcurse", 11)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.set_character_position(15, 308.06, 343.64, 99.37)
		event.set_character_motion(15, "発動", 5)
		event.assign_memory_stack(6)
		event.clear_memory_stack(6)
		event.start_background_file_loads_1("event/opening/p5/p5_pierrot.gltf")
		resume_step = 1
		vm.wait(1)
		resume_step = 2
		wait.background_load()
		event.load_character(6, "event/opening/p5/p5_pierrot.gltf", "info", 12)
		event.set_character_shadow_culling_off(12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 2236.22, 0.0, 1698.15)
		event.set_object_sequence_rotation(4, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(4, "走り", 4)
		event.load_character(6, "event/opening/p5/p5_pierrot.gltf", "info", 13)
		event.set_character_active(13)
		event.set_character_shadow_culling_off(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 2135.85, 0.0, 1705.51)
		event.set_object_sequence_rotation(5, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(5, "走り", 4, 0.9)
		event.set_object_sequence_motion_time(5, 4.5)
		event.assign_memory_stack(7)
		event.clear_memory_stack(7)
		event.load_character(7, "event/opening/p5/p5_pierrot.gltf", "info", 14)
		event.set_character_active(14)
		event.set_character_shadow_culling_off(14)
		event.attach_object_handle_to_character(6, 14)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, 2135.85, 0.0, 1705.51)
		event.set_object_sequence_rotation(6, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(6, "走り", 4, 0.9)
		event.set_object_sequence_motion_time(6, 9.9)
		event.attach_object_handle_to_character_frame(7, 10, "cube39")
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.rotate_object_sequence(7, 0.0, -0.02, 0.0, -1)
		event.load_character_motion_pack(7, "event/opening/p5/p5_mints2.gltf", "info", 0)
		event.load_character_motion_pack(7, "event/opening/p5/p5_mints1.gltf", "info", 0)
		event.open_voice_stream_wave(1, 50015)
		resume_step = 3
		sound.wait_voice_stream_ready(1)
		event.set_object_sequence_motion(0, "走り改", 4)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 140)
		event.add_object_sequence_path_point(0, 2164.03, 0.0, 1594.92)
		event.add_object_sequence_path_point(0, 2122.87, 0.0, 1460.45)
		event.add_object_sequence_path_point(0, 2071.67, 0.0, 1410.58)
		event.add_object_sequence_path_point(0, 1985.11, 0.0, 1391.41)
		event.add_object_sequence_path_point(0, 1908.12, 0.0, 1401.38)
		event.add_object_sequence_path_point(0, 1822.53, 0.0, 1420.07)
		event.add_object_sequence_path_point(0, 1735.11, 0.0, 1420.08)
		event.add_object_sequence_path_point(0, 1612.33, 0.0, 1420.08)
		event.add_object_sequence_path_point(0, 1506.42, 0.0, 1420.08)
		event.start_object_sequence_path(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目（常）（１）")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		event.delay_object_sequence_position_track(4, 40)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 130)
		event.add_object_sequence_path_point(4, 2236.22, 0.0, 1698.15)
		event.add_object_sequence_path_point(4, 2139.75, 0.0, 1506.54)
		event.add_object_sequence_path_point(4, 2045.23, 0.0, 1408.76)
		event.add_object_sequence_path_point(4, 1922.9, 0.0, 1402.03)
		event.add_object_sequence_path_point(4, 1825.52, 0.0, 1400.38)
		event.add_object_sequence_path_point(4, 1549.05, 0.0, 1405.64)
		event.start_object_sequence_path(4)
		event.delay_object_sequence_position_track(5, 40)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 130)
		event.add_object_sequence_path_point(5, 2135.85, 0.0, 1705.51)
		event.add_object_sequence_path_point(5, 2129.38, 0.0, 1636.95)
		event.add_object_sequence_path_point(5, 2062.06, 0.0, 1503.78)
		event.add_object_sequence_path_point(5, 2003.76, 0.0, 1459.44)
		event.add_object_sequence_path_point(5, 1907.9, 0.0, 1441.22)
		event.add_object_sequence_path_point(5, 1660.93, 0.0, 1435.68)
		event.start_object_sequence_path(5)
		event.delay_object_sequence_position_track(6, 40)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 130)
		event.add_object_sequence_path_point(6, 2196.65, 0.0, 1808.46)
		event.add_object_sequence_path_point(6, 2196.65, 0.0, 1758.46)
		event.add_object_sequence_path_point(6, 2174.16, 0.0, 1610.78)
		event.add_object_sequence_path_point(6, 2111.42, 0.0, 1507.12)
		event.add_object_sequence_path_point(6, 2029.71, 0.0, 1437.84)
		event.add_object_sequence_path_point(6, 1908.27, 0.0, 1415.33)
		event.add_object_sequence_path_point(6, 1761.97, 0.0, 1416.2)
		event.start_object_sequence_path(6)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1552.66, 36.93, 1420.08)
		event.set_camera_sequence_look_at(2123.16, 3.69, 1420.08)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		resume_step = 4
		object.wait_until_done(4)
		resume_step = 5
		object.wait_until_done(5)
		resume_step = 6
		object.wait_until_done(6)
		event.set_camera_sequence_position(1225.16, 107.56, 716.67)
		event.set_camera_sequence_look_at(1303.88, 28.72, 938.86)
		event.move_camera_sequence(1247.41, 86.29, 779.48, 1303.88, 28.72, 938.86, 100)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 100)
		event.add_object_sequence_path_point(0, 1417.18, 0.0, 1383.41)
		event.add_object_sequence_path_point(0, 1377.2, 0.0, 1303.36)
		event.add_object_sequence_path_point(0, 1332.84, 0.0, 1141.9)
		event.add_object_sequence_path_point(0, 1311.76, 0.0, 966.89)
		event.add_object_sequence_path_point(0, 1294.56, 0.0, 858.68)
		event.start_object_sequence_path(0)
		resume_step = 7
		wait.frames(50)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 50)
		event.add_object_sequence_path_point(4, 1502.4, 0.0, 1397.74)
		event.add_object_sequence_path_point(4, 1418.3, 0.0, 1351.17)
		event.add_object_sequence_path_point(4, 1375.12, 0.0, 1272.42)
		event.start_object_sequence_path(4)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 50)
		event.add_object_sequence_path_point(5, 1547.87, 0.0, 1488.3)
		event.add_object_sequence_path_point(5, 1421.49, 0.0, 1416.47)
		event.add_object_sequence_path_point(5, 1367.47, 0.0, 1333.44)
		event.start_object_sequence_path(5)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 50)
		event.add_object_sequence_path_point(6, 1585.91, 0.0, 1458.95)
		event.add_object_sequence_path_point(6, 1499.65, 0.0, 1453.35)
		event.add_object_sequence_path_point(6, 1430.66, 0.0, 1417.08)
		event.start_object_sequence_path(6)
		resume_step = 8
		object.wait_until_done(0)
		resume_step = 9
		object.wait_until_done(4)
		resume_step = 10
		object.wait_until_done(5)
		resume_step = 11
		object.wait_until_done(6)
		resume_step = 12
		camera.wait_until_done()
		event.play_voice_stream(1)
		event.open_message_window_2(0, 50005)
		event.set_message_button_prompt(0, 0)
		message.open(0, -1, 8, 0, 0)
		event.set_object_sequence_position(0, 1309.0, 0.0, 967.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "走り見回し一連", 6)
		event.move_object_sequence(0, 1309.0, 0.0, 647.0, 64)
		event.move_object_sequence(0, 1309.0, 0.0, 607.0, 10)
		event.move_object_sequence(0, 1309.0, 0.0, 582.0, 10)
		event.move_object_sequence(0, 1309.0, 0.0, 567.0, 10)
		event.move_object_sequence(0, 1309.0, 0.0, 557.0, 10)
		event.delay_object_sequence_texture_animation_track(0, 64)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目（常）（１）")
		event.set_object_sequence_texture_animation(0, 1, "イィー口(1)")
		event.set_object_sequence_position(4, 1502.4, 0.0, 1397.74)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 119)
		event.add_object_sequence_path_point(4, 1502.4, 0.0, 1397.74)
		event.add_object_sequence_path_point(4, 1418.3, 0.0, 1351.17)
		event.add_object_sequence_path_point(4, 1375.12, 0.0, 1272.42)
		event.add_object_sequence_path_point(4, 1348.94, 0.0, 1140.59)
		event.add_object_sequence_path_point(4, 1336.94, 0.0, 1054.42)
		event.add_object_sequence_path_point(4, 1335.18, 0.0, 871.57)
		event.start_object_sequence_path(4)
		event.set_object_sequence_position(5, 1547.87, 0.0, 1488.3)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 119)
		event.add_object_sequence_path_point(5, 1547.87, 0.0, 1488.3)
		event.add_object_sequence_path_point(5, 1421.49, 0.0, 1416.47)
		event.add_object_sequence_path_point(5, 1367.47, 0.0, 1333.44)
		event.add_object_sequence_path_point(5, 1323.19, 0.0, 1228.93)
		event.add_object_sequence_path_point(5, 1303.23, 0.0, 1136.7)
		event.add_object_sequence_path_point(5, 1286.79, 0.0, 976.16)
		event.start_object_sequence_path(5)
		event.set_object_sequence_position(6, 1585.91, 0.0, 1458.95)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 119)
		event.add_object_sequence_path_point(6, 1585.91, 0.0, 1458.95)
		event.add_object_sequence_path_point(6, 1499.65, 0.0, 1453.35)
		event.add_object_sequence_path_point(6, 1430.66, 0.0, 1417.08)
		event.add_object_sequence_path_point(6, 1366.4, 0.0, 1356.62)
		event.add_object_sequence_path_point(6, 1336.79, 0.0, 1255.43)
		event.add_object_sequence_path_point(6, 1321.49, 0.0, 1065.94)
		event.start_object_sequence_path(6)
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, -2.9, 20.0, 70.0)
		event.move_camera_sequence_angle_height_distance(3.14, 20.0, 70.0, 80)
		resume_step = 13
		object.wait_until_done(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(1358.11, 30.53, 762.36)
		event.set_camera_sequence_look_at(1402.76, 30.68, 550.39)
		event.move_camera_sequence(1358.11, 30.53, 762.36, 1402.76, 162.32, 550.39, 30)
		event.set_object_sequence_position(0, 1309.0, 0.0, 597.0)
		event.set_object_sequence_motion(0, "右上向き", 4)
		resume_step = 14
		camera.wait_until_done()
		resume_step = 15
		wait.frames(10)
		event.set_camera_sequence_position(1315.4, 35.92, 559.68)
		event.set_camera_sequence_look_at(1307.34, 19.88, 595.99)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "口パク横大(1)")
		event.delay_object_sequence_texture_animation_track(0, 10)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目(1)")
		event.set_object_sequence_texture_animation(0, 1, "怒り口(1)")
		resume_step = 16
		wait.frames(30)
		message.close(0)
		event.set_message_button_prompt(0, 1)
		event.clear_object_sequence(6)
		event.set_character_active(0, 14)
		event.delete_character(14)
		event.set_camera_sequence_position(1470.95, 53.06, 625.96)
		event.set_camera_sequence_look_at(1414.36, 47.06, 555.98)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目(2)")
		event.set_object_sequence_texture_animation(0, 1, "怒り口(2)")
		event.set_character_active(0, 13)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "のぼり一連", 6, -1.0, 1)
		event.wait_object_sequence_motion_end(0)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, sound_bank, 11)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, sound_bank, 12)
		event.delay_object_sequence_sound_track(0, 60)
		event.play_object_sequence_sound(0, sound_bank, 12)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, sound_bank, 12)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, sound_bank, 12)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, sound_bank, 12)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, sound_bank, 12)
		event.set_object_handle_frame_visible(4, "obj10", 0)
		event.set_object_handle_frame_visible(4, "obj11", 0)
		event.set_object_handle_frame_visible(4, "obj6", 0)
		event.set_object_handle_frame_visible(4, "obj4", 0)
		event.set_object_sequence_motion(4, "飛びついて蹴り落ち", 6)
		event.delay_object_sequence_sound_track(4, 80)
		event.play_object_sequence_sound(4, sound_bank, 13)
		resume_step = 17
		wait.frames(30)
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 0.0, 0.68, 6.0, 90.0, "chara")
		event.set_object_sequence_motion(0, "のぼり一連", 1)
		event.set_object_handle_footstep_sound(0, 6)
		resume_step = 18
		object.wait_until_done(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(1507.85, 274.71, 487.29)
		event.set_camera_sequence_look_at(1400.71, 250.07, 551.81)
		event.move_camera_sequence(1314.65, 274.71, 571.79, 1193.02, 250.07, 591.57, 126)
		event.set_object_sequence_motion(0, "ポールから屋根へ", 6)
		event.wait_object_sequence_motion_end(0)
		event.delay_object_sequence_sound_track(0, 100)
		event.play_object_sequence_sound(0, sound_bank, 14)
		event.set_object_handle_footstep_sound(0, 6)
		resume_step = 19
		wait.frames(30)
		event.set_object_handle_footstep_sound(0, 3)
		resume_step = 20
		wait.frames(50)
		event.set_object_handle_footstep_sound(0, 6)
		resume_step = 21
		wait.frames(20)
		event.set_object_handle_footstep_sound(0, 20)
		resume_step = 22
		object.wait_until_done(0)
		event.set_camera_sequence_position(755.22, 455.36, 770.08)
		event.set_camera_sequence_look_at(863.16, 329.8, 574.01)
		event.move_camera_sequence_eased(787.23, 433.36, 739.6, 785.29, 312.14, 548.14, 60, 0, 1.0)
		event.set_object_handle_footstep_sound(0, 20)
		event.set_object_sequence_motion(0, "屋根上1", 6)
		event.wait_object_sequence_motion_end(0)
		event.delay_object_sequence_sound_track(0, 40)
		event.play_object_sequence_sound(0, sound_bank, 15)
		resume_step = 23
		vm.wait(23)
		resume_step = 24
		wait.frames(120)
		resume_step = 25
		camera.wait_until_done()
		event.close_voice_stream(1)
		event.set_camera_sequence_position(924.31, 255.15, 487.82)
		event.set_camera_sequence_look_at(725.21, 270.97, 431.93)
		event.start_background_file_loads_1("event/opening/p5/p5_mints3.gltf")
		resume_step = 26
		object.wait_until_done(0)
		resume_step = 27
		wait.background_load()
		event.set_camera_sequence_position(587.67, 352.86, 412.66)
		event.set_camera_sequence_look_at(790.95, 282.51, 463.59)
		event.set_object_handle_frame_visible(4, "obj10", 1)
		event.set_object_handle_frame_visible(4, "obj11", 1)
		event.set_object_handle_frame_visible(4, "obj6", 1)
		event.set_object_handle_frame_visible(4, "obj4", 1)
		event.set_object_sequence_position(0, 732.13, 257.21, 443.67)
		event.set_object_sequence_rotation(0, 0.0, 1.8, 0.0)
		event.set_object_sequence_motion(0, "振り返りループ", 4)
		event.set_object_sequence_motion(4, "屋根上手招き", 4)
		event.set_character_active(1, 13)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "屋根すべり", 6)
		event.wait_object_sequence_motion_end(5)
		event.delay_object_sequence_sound_track(5, 20)
		event.play_object_sequence_sound(5, sound_bank, 15)
		resume_step = 28
		object.wait_until_done(5)
		event.clear_memory_stack(7)
		event.delete_character_extension_packs(0)
		event.load_character_motion_pack(7, "event/opening/p5/p5_mints3.gltf", "info", 0)
		event.set_camera_sequence_position(763.09, 272.22, 446.02)
		event.set_camera_sequence_look_at(733.35, 278.11, 441.25)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "会話（帽子）", 6, -1.0, 1)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "困った目(3)")
		resume_step = 29
		vm.wait(29)
		event.set_mouth_texture_animations(0, "通常口パク", "怒り口(3)")
		resume_step = 30
		message.show_voiced_with_button_prompt(50020, -1, 10)
		event.reset_mouth_texture_animations()
		resume_step = 31
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "振り向いて走る", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目（通常）(3)")
		event.set_object_sequence_texture_animation(0, 1, "怒り口(3)")
		resume_step = 32
		object.wait_until_done(0)
		event.set_camera_sequence_position(1140.15, 357.53, 638.69)
		event.set_camera_sequence_look_at(836.46, 316.08, 666.69)
		event.move_camera_sequence(1091.91, 356.61, 646.98, 811.82, 322.28, 732.96, 124)
		event.set_object_sequence_motion(0, "逃げ回るミンツ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_position(4, 806.22, 120.38, 561.57)
		event.set_object_sequence_rotation(4, 0.0, -0.72, 0.0)
		event.move_object_sequence(4, 723.19, 225.42, 754.46, 86)
		event.set_object_sequence_motion(4, "走り", 4)
		event.jump_object_sequence(4, 700.96, 239.38, 798.22, -0.2, 18)
		event.move_object_sequence(4, 676.73, 252.62, 814.2, 20)
		event.delay_object_sequence_rotation_track(4, 86)
		event.rotate_object_sequence(4, 0.0, -1.08, 0.0, 30)
		event.delay_object_sequence_motion_track(4, 86)
		event.set_object_sequence_motion_step(4, 0.2)
		event.delay_object_sequence_motion_track(4, 17)
		event.set_object_sequence_motion_step(4, 0.9)
		event.set_object_sequence_position(5, 816.27, 161.11, 433.68)
		event.set_object_sequence_rotation(5, 0.0, -0.72, 0.0)
		event.set_object_sequence_motion(5, "走り", 4)
		event.move_object_sequence(5, 722.9, 225.66, 567.51, 72)
		event.move_object_sequence(5, 722.9, 225.66, 715.49, 52)
		event.delay_object_sequence_rotation_track(5, 50)
		event.rotate_object_sequence(5, 0.0, 0.0, 0.0, 12)
		resume_step = 33
		object.wait_until_done(0)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_camera_sequence_position(122.6, 376.58, -28.31)
		event.set_camera_sequence_look_at(298.28, 326.93, 63.42)
		event.move_camera_sequence(196.7, 361.64, 10.38, 298.28, 326.93, 63.42, 95)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_sequence_motion(0, "アーム上に", 6)
		event.queue_object_sequence_next_motion(0, "アーム上ループ", 4)
		event.delay_object_sequence_sound_track(0, 46)
		event.play_object_sequence_sound(0, sound_bank, 16)
		resume_step = 34
		wait.frames(46)
		resume_step = 35
		camera.wait_until_done()
		event.set_object_handle_footstep_sound(4, 6)
		event.set_character_active(1, 12)
		event.set_object_sequence_position(4, 306.41, 281.14, 189.26)
		event.set_object_sequence_rotation(4, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(4, "にじりより", 4)
		event.move_object_sequence(4, 306.41, 305.3, 134.35, 60)
		resume_step = 36
		object.wait_until_done(4)
		event.set_camera_sequence_position(306.41, 325.86, 27.66)
		event.set_camera_sequence_look_at(306.25, 328.7, 143.17)
		event.set_character_active(0, 0)
		event.set_object_sequence_motion(4, "にじりより", 4)
		event.move_object_sequence(4, 306.41, 314.03, 121.65, 60)
		resume_step = 37
		object.wait_until_done(4)
		event.set_camera_sequence_position(299.01, 336.06, 82.41)
		event.set_camera_sequence_look_at(304.7, 341.54, 42.89)
		event.set_character_active(1, 0)
		event.set_object_sequence_motion(0, "グラグラループ", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "下向き目（通常）(3)")
		event.set_object_sequence_texture_animation(0, 1, "口ぱく横小(3)")
		event.delay_object_sequence_texture_animation_track(0, 20)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "下向き(3)")
		event.set_object_sequence_texture_animation(0, 1, "口ぱく横小(3)")
		resume_step = 38
		wait.frames(40)
		event.set_camera_sequence_position(306.41, 325.86, 27.66)
		event.set_camera_sequence_look_at(306.25, 328.7, 143.17)
		event.set_character_active(0, 0)
		event.set_object_sequence_motion(4, "にじりより", 4)
		event.move_object_sequence(4, 306.41, 314.94, 82.06, 60)
		resume_step = 39
		object.wait_until_done(4)
		event.set_camera_sequence_position(310.38, 335.43, 87.38)
		event.set_camera_sequence_look_at(308.52, 338.73, 49.68)
		event.set_character_active(1, 0)
		event.set_character_active(0, 12)
		event.set_object_sequence_motion(0, "グラグラからかまえ", 6)
		event.queue_object_sequence_next_motion(0, "かまえ～レンチ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目(3)")
		event.set_object_sequence_texture_animation(0, 1, "怒り口(3)")
		event.delay_object_sequence_texture_animation_track(0, 15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "覚悟～レンチ")
		event.set_object_sequence_texture_animation(0, 1, "覚悟の口")
		resume_step = 40
		wait.frames(45)
		event.delay_camera_sequence_position_track(40)
		event.set_camera_sequence_position(265.28, 340.09, 25.51)
		event.set_camera_sequence_look_at(310.44, 335.75, 45.81)
		resume_step = 41
		message.show_voiced_with_button_prompt(50030, -1, 0)
		resume_step = 42
		camera.wait_until_done()
		resume_step = 43
		wait.frames(30)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(310.38, 335.43, 87.38)
		event.set_camera_sequence_look_at(308.52, 338.73, 49.68)
		resume_step = 44
		wait.frames(5)
		event.play_object_sequence_sound(0, sound_bank, 17)
		resume_step = 45
		object.wait_until_done(0)
		event.set_camera_sequence_position(204.46, 341.45, 61.97)
		event.set_camera_sequence_look_at(312.97, 339.16, 66.9)
		event.set_character_active(1, 12)
		event.set_character_cloth_animation_enabled(0, 0)
		event.start_background_file_loads_2("event/opening/p5/p00_08a.gltf", "event/opening/p5/p5_mints4.gltf")
		event.set_object_sequence_motion(0, "ジャンプ殴り一連", 6)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "殴られピエロ", 6)
		event.delay_object_sequence_sound_track(0, 40)
		event.play_object_sequence_sound(0, sound_bank, 18)
		resume_step = 46
		wait.frames(40)
		event.set_object_sequence_motion_step(0, 0.05)
		event.set_object_sequence_motion_step(4, 0.05)
		resume_step = 47
		wait.frames(65)
		event.set_object_sequence_motion_step(0, 0.55)
		event.set_object_sequence_motion_step(4, 0.55)
		event.play_object_sequence_sound(0, sound_bank, 19)
		resume_step = 48
		wait.frames(20)
		event.set_character_cloth_animation_enabled(0, 1)
		event.set_camera_sequence_position(469.18, 186.58, -162.58)
		event.set_camera_sequence_look_at(318.39, 307.38, 63.85)
		event.fade_out_music(30)
		event.set_object_sequence_position(4, 346.08, 290.76, -2.5)
		event.set_object_sequence_rotation(4, 0.0, 2.66, 0.0)
		event.set_object_sequence_motion(4, "落ちループ", 4)
		event.move_object_sequence(4, 454.18, 290.76, -161.38, 30)
		fall_frame = 0
		fall_speed = 2.0
		while fall_frame < 30 do
			resume_step = 49
			vm.wait(49)
			do
				local out1, out2, out3 = event.get_character_position(12)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			fall_speed = vm.f32(fall_speed + vm.f32(0.1))
			y = vm.f32(y - fall_speed)
			event.set_character_position(12, x, y, z)
			fall_frame = fall_frame + 1
		end
		event.play_object_sequence_sound(0, sound_bank, 20)
		event.set_camera_sequence_position(305.23, 330.85, 172.41)
		event.set_camera_sequence_look_at(307.36, 334.06, 94.37)
		event.set_character_active(0, 12)
		event.set_object_sequence_motion_time(0, 33.0)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_motion(0, "レンチかまえL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, sound_bank, 21)
		resume_step = 50
		object.wait_until_done(0)
		event.stop_music(0)
		resume_step = 51
		wait.frames(30)
		event.set_camera_sequence_position(305.23, 330.85, 172.41)
		event.set_camera_sequence_look_at(307.36, 334.06, 94.37)
		event.set_character_active(0, 15)
		resume_step = 52
		wait.background_load()
		event.clear_object_sequence(4)
		event.set_character_active(0, 12)
		event.delete_character(12)
		event.clear_object_sequence(5)
		event.set_character_active(0, 13)
		event.delete_character(13)
		event.clear_memory_stack(6)
		event.delete_character_extension_packs(0)
		event.load_character_motion_pack(6, "event/opening/p5/p5_mints4.gltf", "info", 0)
		event.assign_memory_stack(7)
		event.clear_memory_stack(7)
		event.load_character(7, "event/opening/p5/p00_08a.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 398.37, 315.2, 97.47)
		event.set_object_sequence_rotation(4, 0.0, -1.57, 0.0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "声に反応", 5)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "声に反応", 6)
		event.queue_object_sequence_next_motion(0, "「なんだ」L", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "上向き目（４）")
		event.set_object_sequence_texture_animation(0, 1, "口パク横小(4)")
		resume_step = 53
		message.show_voiced_with_button_prompt(50040, -1, 10)
		resume_step = 54
		object.wait_until_done(0)
		event.load_music(110)
		event.set_camera_sequence_position(158.34, 284.03, -147.01)
		event.set_camera_sequence_look_at(315.83, 384.57, 166.09)
		event.set_character_active(1, 10)
		event.set_character_active(1, 11)
		event.set_object_sequence_motion(2, "屋根の上にジャンプ", 6)
		event.queue_object_sequence_next_motion(2, "屋根上でのループ", 4)
		event.play_object_sequence_sound(2, sound_bank, 23)
		event.delay_object_sequence_sound_track(2, 40)
		event.play_object_sequence_sound(2, sound_bank, 24)
		resume_step = 55
		wait.frames(40)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 25)
		resume_step = 56
		object.wait_until_done(2)
		resume_step = 57
		camera.wait_until_done()
		event.set_camera_sequence_position(309.79, 330.51, 134.62)
		event.set_camera_sequence_look_at(307.18, 335.35, 97.64)
		event.set_character_active(0, 9)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "上向き目（４）")
		resume_step = 58
		vm.wait(58)
		event.set_mouth_texture_animations(0, "通常口パク", "怒り口")
		resume_step = 59
		message.show_voiced_with_button_prompt(50050, -1, 10)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(330.17, 424.73, 30.18)
		event.set_camera_sequence_look_at(316.71, 427.89, 163.92)
		event.set_object_sequence_motion(3, "会話", 6)
		event.queue_object_sequence_next_motion(3, "立ち")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "怒り目")
		resume_step = 60
		vm.wait(60)
		event.set_mouth_texture_animations(3, "口パク", "怒り口")
		resume_step = 61
		message.show_voiced_with_button_prompt(50060, -1, 10)
		event.reset_mouth_texture_animations()
		resume_step = 62
		object.wait_until_done(3)
		event.set_camera_sequence_position(309.79, 330.51, 134.62)
		event.set_camera_sequence_look_at(307.18, 335.35, 97.64)
		event.set_character_cloth_animation_enabled(0, 0)
		event.set_object_sequence_motion(0, "ペンダント見る", 6)
		event.queue_object_sequence_next_motion(0, "ペンダント見るL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "考え目（下)（４）")
		resume_step = 63
		vm.wait(63)
		event.set_mouth_texture_animations(0, "通常口パク", "怒り口")
		resume_step = 64
		message.show_voiced_with_button_prompt(50070, -1, 10)
		event.reset_mouth_texture_animations()
		resume_step = 65
		object.wait_until_done(0)
		event.set_camera_sequence_position(267.41, 346.68, 117.05)
		event.set_camera_sequence_look_at(331.3, 325.62, 92.25)
		event.set_character_active(1, 12)
		event.set_mouth_texture_animations(4, "口パク")
		resume_step = 66
		message.show_voiced_with_button_prompt(50080, -1, 10)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(309.79, 330.51, 134.62)
		event.set_camera_sequence_look_at(307.18, 335.35, 97.64)
		event.set_object_sequence_motion(0, "「え？」", 6)
		event.queue_object_sequence_next_motion(0, "髪ゆれL", 4)
		event.set_object_sequence_normal_drive(0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "口パク横小(4)")
		resume_step = 67
		message.show_voiced_with_button_prompt(50090, -1, 10)
		resume_step = 68
		object.wait_until_done(0)
		event.set_camera_sequence_position(267.41, 346.68, 117.05)
		event.set_camera_sequence_look_at(331.3, 325.62, 92.25)
		event.clear_object_sequence(4)
		event.set_character_active(0, 12)
		event.delete_character(12)
		event.clear_memory_stack(7)
		resume_step = 69
		wait.frames(60)
		event.set_camera_sequence_position(345.09, 332.09, 125.17)
		event.set_camera_sequence_look_at(307.31, 337.01, 97.3)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "口パク横小(4)")
		resume_step = 70
		wait.frames(60)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "声で振り返る", 6)
		event.queue_object_sequence_next_motion(0, "声で振り返るL", 4)
		event.delay_object_sequence_texture_animation_track(0, 40)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目（目パチ）(4)")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		event.set_mouth_texture_animations(3, "口パク", "怒り口")
		resume_step = 71
		message.show_voiced_with_button_prompt(50100, -1, 10)
		event.reset_mouth_texture_animations()
		resume_step = 72
		object.wait_until_done(0)
		resume_step = 73
		message.show_voiced_with_button_prompt(50110, -1, 10)
		event.start_background_file_loads_2("event/opening/p5/p5_hata.gltf", "event/opening/p5/p5_donnie.gltf")
		resume_step = 74
		vm.wait(74)
		resume_step = 75
		wait.background_load()
		event.load_character(7, "event/opening/p5/p5_hata.gltf", "info", 12)
		event.set_character_active(1, 12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, -172.95, 0.0, -49.1)
		event.set_object_sequence_rotation(4, 0.0, -1.4, 0.0)
		event.set_object_sequence_motion(4, "伸び", 5)
		event.load_character(7, "event/opening/p5/p5_donnie.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		resume_step = 76
		object.wait_until_done(0)
		event.set_camera_sequence_position(158.34, 284.03, -147.01)
		event.set_camera_sequence_look_at(315.83, 384.57, 166.09)
		event.set_object_sequence_motion(3, "会話", 6)
		event.queue_object_sequence_next_motion(3, "立ち")
		event.set_object_sequence_motion(2, "屋根上手招き", 4)
		event.play_object_sequence_sound(2, sound_bank, 25)
		event.delay_object_sequence_sound_track(2, 40)
		event.play_object_sequence_sound(2, sound_bank, 25)
		event.delay_object_sequence_sound_track(2, 40)
		event.play_object_sequence_sound(2, sound_bank, 25)
		event.set_mouth_texture_animations(3, "口パク", "怒り口")
		resume_step = 77
		message.show_voiced_with_button_prompt(50120, -1, 10)
		event.reset_mouth_texture_animations()
		resume_step = 78
		object.wait_until_done(3)
		event.set_camera_sequence_position(308.57, 343.26, 143.54)
		event.set_camera_sequence_look_at(306.87, 327.08, 91.96)
		event.set_object_sequence_motion(0, "これは渡さないよL", 4)
		event.set_object_sequence_normal_drive(0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目追加")
		resume_step = 79
		vm.wait(79)
		event.set_mouth_texture_animations(0, "通常口パク", "怒り口")
		resume_step = 80
		message.show_voiced_with_button_prompt(50130, -1, 10)
		event.reset_mouth_texture_animations()
		event.set_character_cloth_animation_enabled(0, 1)
		event.set_camera_sequence_position(325.39, 421.07, 130.43)
		event.set_camera_sequence_look_at(318.19, 429.82, 166.44)
		event.set_object_sequence_motion(2, "屋根上でのループ", 4)
		event.set_object_sequence_motion(3, "会話2", 6)
		event.queue_object_sequence_next_motion(3, "立ち")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "怒り目（通常）")
		resume_step = 81
		vm.wait(81)
		event.set_mouth_texture_animations(3, "口パク", "にやり口")
		resume_step = 82
		message.show_voiced_with_button_prompt(50140, -1, 10)
		event.reset_mouth_texture_animations()
		resume_step = 83
		object.wait_until_done(3)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "怒り目（通常）")
		event.set_object_sequence_texture_animation(3, 1, "怒り口")
		event.set_camera_sequence_position(339.19, 360.48, -9.14)
		event.set_camera_sequence_look_at(354.68, 418.65, 219.48)
		event.play_music(0)
		event.set_object_sequence_motion(2, "アームにジャンプ", 6, 0.1)
		resume_step = 84
		wait.frames(30)
		event.set_object_sequence_motion_step(2, 0.3)
		event.move_camera_sequence(240.84, 360.48, -368.07, 354.68, 418.65, 219.48, 30)
		event.play_object_sequence_sound(2, sound_bank, 26)
		event.set_object_sequence_motion(0, "アームから飛ぶ", 6)
		event.wait_object_sequence_motion_end(0)
		resume_step = 85
		camera.wait_until_done()
		event.set_camera_sequence_position(76.65, 161.52, -242.26)
		event.set_camera_sequence_look_at(290.86, 295.09, 19.51)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 25)
		event.play_object_sequence_sound(2, sound_bank, 27)
		resume_step = 86
		camera.wait_until_done()
		resume_step = 87
		object.wait_until_done(0)
		event.set_camera_sequence_position(116.51, 186.59, -118.26)
		event.set_camera_sequence_look_at(201.47, 239.72, -54.14)
		event.set_object_sequence_motion(0, "ストリートに向く", 6)
		event.queue_object_sequence_next_motion(0, "ストリートに向くL", 4)
		resume_step = 88
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "アームからジャンプ", 6)
		event.play_object_sequence_sound(2, sound_bank, 26)
		resume_step = 89
		object.wait_until_done(0)
		event.set_camera_sequence_position(159.03, 244.48, -60.67)
		event.set_camera_sequence_look_at(172.64, 209.39, -85.13)
		event.set_object_sequence_motion(2, "アームからジャンプ", 1)
		event.set_object_sequence_motion(0, "上を向く", 6)
		event.queue_object_sequence_next_motion(0, "上を向くL", 6)
		resume_step = 90
		wait.frames(20)
		event.set_object_sequence_motion(0, "右見て顔戻す", 6)
		event.wait_object_sequence_motion_end(0)
		resume_step = 91
		object.wait_until_done(0)
		resume_step = 92
		wait.frames(10)
		event.set_camera_sequence_position(-125.14, 515.89, -280.6)
		event.set_camera_sequence_look_at(167.93, 227.34, -78.38)
		event.set_object_sequence_motion(2, "アームからジャンプ", 2)
		event.wait_object_sequence_motion_end(2)
		event.set_object_sequence_motion(0, "ストリートへ飛ぶ", 6)
		resume_step = 93
		wait.frames(16)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 25)
		event.play_object_sequence_sound(2, sound_bank, 27)
		resume_step = 94
		object.wait_until_done(2)
		event.set_camera_sequence_position(61.35, 203.41, -149.02)
		event.set_camera_sequence_look_at(185.39, 255.7, -89.34)
		event.set_object_sequence_motion(2, "顔回転", 6)
		event.wait_object_sequence_motion_end(2)
		resume_step = 95
		object.wait_until_done(2)
		palm_brinks_m08.set_town_parts_visible(0)
		event.set_camera_sequence_position(-290.5, 112.58, -19.91)
		event.set_camera_sequence_look_at(-175.75, 144.25, -48.85)
		event.move_camera_sequence(-290.5, 18.12, -19.91, -175.75, 24.59, -48.85, 100)
		event.set_object_handle_footstep_sound(0, 2)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "顔回転", 6, 0.07)
		event.set_object_sequence_position(0, -172.95, 0.0, -49.1)
		event.set_object_sequence_rotation(0, 0.0, -1.4, 0.0)
		event.set_object_sequence_motion(0, "ひもぶら下がり", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "下向き目（４）")
		event.set_object_sequence_texture_animation(0, 1, "大きな口(4)")
		event.delay_object_sequence_texture_animation_track(0, 100)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目(4)")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		event.set_object_sequence_motion(4, "ひもぶら下がり", 6)
		event.play_object_sequence_sound(2, sound_bank, 28)
		event.delay_object_sequence_sound_track(2, 25)
		event.play_object_sequence_sound(2, sound_bank, 28)
		event.delay_object_sequence_sound_track(2, 55)
		event.play_object_sequence_sound(2, sound_bank, 28)
		resume_step = 96
		object.wait_until_done(0)
		event.play_object_sequence_sound(0, sound_bank, 29)
		event.set_character_active(0, 12)
		event.set_object_handle_frame_visible(2, "light", 0)
		event.set_object_handle_frame_visible(2, "lay1--c0z0app", 0)
		event.set_object_handle_frame_visible(2, "lay2--c0z0app1", 0)
		event.set_object_handle_frame_visible(2, "lay_s--c0z0appba", 0)
		event.set_object_handle_frame_visible(2, "lay_s22--c0z0appba", 0)
		event.set_object_sequence_position(2, 4.14, 100.0, -94.66)
		event.set_object_sequence_rotation(2, 0.0, -1.4, 0.0)
		event.jump_object_sequence(2, 4.14, 0.0, -94.66, -0.1, 10)
		event.delay_object_sequence_motion_track(2, 2)
		event.set_object_sequence_motion(2, "着地2", 6)
		event.wait_object_sequence_motion_end(2)
		resume_step = 97
		wait.frames(10)
		event.play_object_sequence_sound(0, sound_bank, 30)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 25)
		resume_step = 98
		wait.frames(5)
		event.set_object_sequence_motion(0, "驚き振り向き", 6)
		event.queue_object_sequence_next_motion(0, "かわし走り", 6)
		event.delay_object_sequence_position_track(0, 22)
		event.move_object_sequence(0, -348.2, 0.0, -4.9, 44)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目(4)")
		event.set_object_sequence_texture_animation(0, 1, "イィー口(4)")
		resume_step = 99
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "つかみ歩き", 6)
		event.queue_object_sequence_next_motion(2, "歩き", 4)
		event.move_object_sequence(2, -201.84, 0.0, -54.55, 42)
		event.delay_object_sequence_sound_track(2, 10)
		event.play_object_sequence_sound(2, sound_bank, 31)
		event.delay_object_sequence_sound_track(2, 25)
		event.play_object_sequence_sound(2, sound_bank, 31)
		event.move_camera_sequence(-454.24, 18.12, 21.38, -338.77, 24.59, -7.74, 44)
		resume_step = 100
		object.wait_until_done(0)
		event.set_camera_sequence_follow_object(0, -5.0, 25.0, 0.0, -0.92, -10.0, 50.0)
		event.set_object_handle_shadow_enabled(0, 0)
		event.set_object_handle_shadow_enabled(2, 0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "走り改", 6)
		event.queue_object_sequence_next_motion(0, "こける", 6, 0.8)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_position(0, -407.27, 0.0, 10.0)
		event.move_object_sequence(0, -549.23, 0.0, 41.66, 80)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "追ってくるピエロロボ(目）")
		event.set_object_sequence_texture_animation(0, 1, "追ってくる（口）")
		event.set_object_sequence_position(2, -257.7, 0.0, -32.15)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.move_object_sequence(2, -437.38, 0.0, 11.19, 80)
		resume_step = 101
		wait.frames(20)
		resume_step = 102
		wait.frames(10)
		resume_step = 103
		object.wait_until_done(0)
		event.release_camera_sequence_follow_object()
		event.set_object_handle_shadow_enabled(0, 1)
		event.set_object_handle_shadow_enabled(2, 1)
		event.set_camera_sequence_position(-460.48, 23.67, 35.22)
		event.set_camera_sequence_look_at(-493.63, 8.84, 22.81)
		event.delay_camera_sequence_position_track(30)
		event.move_camera_sequence_eased(-584.45, 23.67, 110.84, -461.07, 39.78, 24.24, 40, 0, 0.3)
		event.set_object_sequence_position(0, -488.16, 0.0, 20.52)
		event.set_object_sequence_rotation(0, 0.0, 1.8, 0.0)
		event.set_object_sequence_motion(0, "うつぶせから倒れに", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "倒れL", 4)
		event.set_object_sequence_position(2, -351.24, 0.0, -5.76)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "手を上げる", 5)
		resume_step = 104
		wait.frames(50)
		event.set_object_sequence_motion(2, "手を上げる", 6)
		event.wait_object_sequence_motion_end(2)
		event.play_object_sequence_sound(2, sound_bank, 32)
		resume_step = 105
		object.wait_until_done(2)
		resume_step = 106
		object.wait_until_done(0)
		event.set_camera_sequence_position(-475.03, 150.78, 109.5)
		event.set_camera_sequence_look_at(-424.67, 158.91, 53.02)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "指差し", 6)
		event.set_object_handle_frame_visible(3, "sashi", 1)
		event.set_object_handle_frame_visible(3, "cube61_8", 0)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "怒り目")
		resume_step = 107
		vm.wait(107)
		event.set_mouth_texture_animations(3, "口パク", "にやり口")
		resume_step = 108
		message.show_voiced_with_button_prompt(50150, -1, 10)
		event.reset_mouth_texture_animations()
		event.set_object_handle_frame_visible(3, "sashi", 0)
		event.set_object_handle_frame_visible(3, "cube61_8", 1)
		event.set_camera_sequence_position(-424.39, 57.37, 104.2)
		event.set_camera_sequence_look_at(-471.89, 25.88, 13.34)
		event.set_object_sequence_position(2, -367.17, 0.0, 9.93)
		event.set_object_sequence_rotation(2, 0.0, -1.4, 0.0)
		event.set_object_sequence_motion(2, "つかみそこなう手", 6)
		event.queue_object_sequence_next_motion(2, "失敗ループ", 4)
		event.play_object_sequence_sound(2, sound_bank, 33)
		event.delay_object_sequence_sound_track(2, 10)
		event.play_object_sequence_sound(2, sound_bank, 27)
		event.set_object_sequence_position(0, -473.32, 0.0, 2.57)
		event.set_object_sequence_rotation(0, 0.0, 1.68, 0.0)
		event.set_object_sequence_motion(0, "かわして前に", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目(4)")
		event.set_object_sequence_texture_animation(0, 1, "口パク横大(4)")
		resume_step = 109
		wait.frames(10)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 25)
		resume_step = 110
		object.wait_until_done(0)
		event.set_camera_sequence_position(-632.86, 81.14, 94.35)
		event.set_camera_sequence_look_at(-452.4, 42.5, 29.14)
		event.set_object_sequence_motion(0, "ハイハイから走りに", 6)
		event.queue_object_sequence_next_motion(0, "走り改", 4)
		event.move_object_sequence(0, -253.41, 0.0, -13.35, 60)
		resume_step = 111
		wait.frames(30)
		event.set_object_sequence_motion(2, "またくぐり", 2)
		resume_step = 112
		object.wait_until_done(0)
		event.set_camera_sequence_position(-530.73, 114.8, 110.26)
		event.set_camera_sequence_look_at(-447.57, 126.89, 72.6)
		event.set_object_sequence_motion(3, "振り向き", 6)
		event.queue_object_sequence_next_motion(3, "振り向きL", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "怒り目（通常）")
		event.set_mouth_texture_animations(3, "口パク", "怒り口")
		resume_step = 113
		message.show_voiced_with_button_prompt(50160, -1, 10)
		event.reset_mouth_texture_animations()
		event.open_voice_stream_wave(1, 50170)
		resume_step = 114
		sound.wait_voice_stream_ready(1)
		event.set_camera_sequence_follow_object(0, 0.0, 20.0, 0.0, 1.66, 10.0, 80.0)
		event.delay_camera_sequence_angle_track(40)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_follow_object(0, 0.0, 23.0, 0.0, 1.66, 1.26, 46.0)
		event.set_object_sequence_position(0, -319.98, 0.0, -5.49)
		event.set_object_sequence_rotation(0, 0.0, 1.68, 0.0)
		event.move_object_sequence(0, -71.09, 0.0, -25.42, 62)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "走り改", 6)
		event.wait_object_sequence_motion_end(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "走り改", 6)
		event.queue_object_sequence_next_motion(0, "走りながら右向く", 6)
		event.queue_object_sequence_next_motion(0, "走り改", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目(4)")
		event.set_object_sequence_texture_animation(0, 1, "口パク横小(4)")
		event.set_object_sequence_position(2, -470.35, 0.0, 7.86)
		event.set_object_sequence_rotation(2, 0.0, -1.52, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.play_voice_stream(1)
		event.open_message_window_2(0, 50170)
		message.open(0, -1, 8, 0, 0)
		resume_step = 115
		message.wait_voice_for(0, 40)
		message.close(0)
		event.close_voice_stream(1)
		event.set_message_bubble_screen_slot(0, 0)
		event.set_object_handle_shadow_enabled(0, 0)
		resume_step = 116
		object.wait_until_done(0)
		event.release_camera_sequence_follow_object()
		event.set_object_handle_shadow_enabled(0, 1)
		palm_brinks_m08.set_town_parts_visible(1)
		event.set_camera_sequence_position(89.31, 53.56, -114.59)
		event.set_camera_sequence_look_at(190.36, 20.0, 127.33)
		event.set_character_active(1, 13)
		event.set_object_sequence_position(5, 203.26, 0.0, 200.92)
		event.set_object_sequence_rotation(5, 0.0, -3.0, 0.0)
		event.set_object_sequence_motion(5, "立ち手招き", 4)
		event.delay_object_sequence_position_track(5, 30)
		event.move_object_sequence(5, 204.92, 0.0, 250.68, 10)
		event.set_object_sequence_motion(0, "走り改", 4)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 40)
		event.add_object_sequence_path_point(0, 95.83, 0.0, -2.57)
		event.add_object_sequence_path_point(0, 137.11, 0.0, 11.63)
		event.add_object_sequence_path_point(0, 164.93, 0.0, 32.86)
		event.add_object_sequence_path_point(0, 185.5, 0.0, 62.2)
		event.add_object_sequence_path_point(0, 202.23, 0.0, 97.29)
		event.start_object_sequence_path(0)
		event.open_voice_stream_wave(1, 50180)
		resume_step = 117
		voice_load_frames = sound.wait_voice_stream_ready_counting(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, 50180)
		message.open(0, -1, 8, 0, 0)
		resume_step = 118
		message.wait_voice_for(0, vm.i32(40 - voice_load_frames))
		message.close(0)
		event.close_voice_stream(1)
		event.set_message_bubble_screen_slot(0, 0)
		resume_step = 119
		object.wait_until_done(0)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(224.56, 13.63, 269.0)
		event.set_camera_sequence_look_at(224.0, 6.84, 324.3)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "手招き", 6)
		event.set_object_sequence_texture_animation(5, 0)
		resume_step = 120
		wait.frames(30)
		event.set_camera_sequence_position(224.14, 19.67, 443.89)
		event.set_camera_sequence_look_at(224.0, 15.17, 324.3)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "待機入り", 6)
		event.queue_object_sequence_next_motion(5, "待機", 6)
		event.queue_object_sequence_next_motion(5, "閉める", 6)
		event.wait_object_sequence_motion_end(5)
		event.set_object_sequence_position(0, 226.8, 0.0, 167.7)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.move_object_sequence(0, 226.8, 0.0, 336.71, 28)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "走り改", 6)
		event.queue_object_sequence_next_motion(0, "マンホールへ", 6)
		event.delay_object_sequence_sound_track(5, 62)
		event.play_object_sequence_sound(5, sound_bank, 36)
		resume_step = 121
		object.wait_until_done(5)
		event.set_camera_sequence_position(-62.55, 67.95, -87.07)
		event.set_camera_sequence_look_at(-318.49, 68.49, -24.03)
		event.set_object_handle_frame_draw_flag(2, "light", 1)
		event.set_object_handle_frame_draw_flag(2, "lay1--c0z0app", 5)
		event.set_object_handle_frame_draw_flag(2, "lay2--c0z0app1", 1)
		event.set_object_handle_frame_draw_flag(2, "lay_s--c0z0appba", 1)
		event.set_object_handle_frame_draw_flag(2, "lay_s22--c0z0appba", 1)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_motion(2, "旋回ジャンプ", 6)
		event.queue_object_sequence_next_motion(2, "歩き")
		event.delay_object_sequence_rotation_track(2, 10)
		event.rotate_object_sequence(2, 0.0, 1.88, 0.0, 25)
		event.delay_object_sequence_position_track(2, 55)
		event.move_object_sequence(2, -296.99, 0.0, -27.41, 30)
		event.play_object_sequence_sound(2, sound_bank, 34)
		event.delay_object_sequence_sound_track(2, 35)
		event.play_object_sequence_sound(2, sound_bank, 35)
		resume_step = 122
		wait.frames(35)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 25)
		resume_step = 123
		object.wait_until_done(2)
		event.set_camera_sequence_position(224.14, 19.67, 443.89)
		event.set_camera_sequence_look_at(224.0, 15.17, 324.3)
		event.fade_out_music(180)
		event.set_object_sequence_motion(5, "覗きあけ", 6)
		event.play_object_sequence_sound(5, sound_bank, 37)
		event.delay_object_sequence_motion_track(5, 50)
		event.set_object_sequence_motion(5, "あせり閉め", 6)
		event.delay_object_sequence_sound_track(5, 50)
		event.play_object_sequence_sound(5, sound_bank, 38)
		event.set_object_sequence_position(2, -48.38, 0.0, -130.23)
		event.set_object_sequence_rotation(2, 0.0, 1.52, 0.0)
		event.move_object_sequence(2, 238.39, 0.0, -72.31, 40)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "立ち＞右むき", 2)
		event.queue_object_sequence_next_motion(2, "立ち＞右むきループ", 6)
		event.queue_object_sequence_next_motion(2, "右＞立ち", 6)
		event.wait_object_sequence_motion_end(2)
		resume_step = 124
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, 454.97, 0.0, -72.57, 40)
		resume_step = 125
		wait.frames(10)
		event.set_object_sequence_motion(5, "覗きあけ", 6)
		resume_step = 126
		object.wait_until_done(2)
		event.set_local_event_flag(0, 1)
	end, function(received: { any }): boolean
		if resume_step == 117 then
			voice_load_frames = received[1] :: number
		end
		if resume_step <= 1 then
			wait.background_load_skipping()
		end
		if resume_step <= 2 then
			cutscene.skip_command(1)
		end
		if resume_step <= 3 then
			cutscene.skip_command(4)
		end
		if resume_step <= 4 then
			cutscene.skip_command(5)
		end
		if resume_step <= 5 then
			cutscene.skip_command(6)
		end
		if resume_step <= 6 then
			wait.frames_skipping(50)
		end
		if resume_step <= 7 then
			cutscene.skip_command(0)
		end
		if resume_step <= 8 then
			cutscene.skip_command(4)
		end
		if resume_step <= 9 then
			cutscene.skip_command(5)
		end
		if resume_step <= 10 then
			cutscene.skip_command(6)
		end
		if resume_step <= 11 then
			wait.background_load_skipping()
		end
		if resume_step <= 12 then
			message.open_skipping(0, -1, 8, 0, 0)
			cutscene.skip_command(0)
		end
		if resume_step <= 13 then
			wait.background_load_skipping()
		end
		if resume_step <= 14 then
			wait.frames_skipping(10)
		end
		if resume_step <= 15 then
			wait.frames_skipping(30)
		end
		if resume_step <= 16 then
			message.close_skipping(0)
			wait.frames_skipping(30)
		end
		if resume_step <= 17 then
			cutscene.skip_command(0)
		end
		if resume_step <= 18 then
			wait.frames_skipping(30)
		end
		if resume_step <= 19 then
			wait.frames_skipping(50)
		end
		if resume_step <= 20 then
			wait.frames_skipping(20)
		end
		if resume_step <= 21 then
			cutscene.skip_command(0)
		end
		if resume_step <= 23 then
			wait.frames_skipping(120)
		end
		if resume_step <= 24 then
			wait.background_load_skipping()
		end
		if resume_step <= 25 then
			cutscene.skip_command(0)
		end
		if resume_step <= 26 then
			wait.background_load_skipping()
		end
		if resume_step <= 27 then
			cutscene.skip_command(5)
		end
		if resume_step <= 29 then
			message.show_voiced_for_frames_skipping(50020, -1, 10)
		end
		if resume_step <= 30 then
			cutscene.skip_command(0)
		end
		if resume_step <= 31 then
			cutscene.skip_command(0)
		end
		if resume_step <= 32 then
			cutscene.skip_command(0)
		end
		if resume_step <= 33 then
			wait.frames_skipping(46)
		end
		if resume_step <= 34 then
			wait.background_load_skipping()
		end
		if resume_step <= 35 then
			cutscene.skip_command(4)
		end
		if resume_step <= 36 then
			cutscene.skip_command(4)
		end
		if resume_step <= 37 then
			wait.frames_skipping(40)
		end
		if resume_step <= 38 then
			cutscene.skip_command(4)
		end
		if resume_step <= 39 then
			wait.frames_skipping(45)
		end
		if resume_step <= 40 then
			message.show_voiced_for_frames_skipping(50030, -1, 0)
		end
		if resume_step <= 41 then
			wait.background_load_skipping()
		end
		if resume_step <= 42 then
			wait.frames_skipping(30)
		end
		if resume_step <= 43 then
			wait.frames_skipping(5)
		end
		if resume_step <= 44 then
			cutscene.skip_command(0)
		end
		if resume_step <= 45 then
			wait.frames_skipping(40)
		end
		if resume_step <= 46 then
			wait.frames_skipping(65)
		end
		if resume_step <= 47 then
			wait.frames_skipping(20)
		end
		if resume_step <= 48 then
			fall_frame = 0
			fall_speed = 2.0
		end
		if resume_step <= 49 then
			fall_speed = vm.f32(fall_speed + vm.f32(0.1))
			y = vm.f32(y - fall_speed)
			local _ = fall_frame < 30
			fall_frame = fall_frame + 1
			cutscene.skip_command(0)
		end
		if resume_step <= 50 then
			wait.frames_skipping(30)
		end
		if resume_step <= 51 then
			wait.background_load_skipping()
		end
		if resume_step <= 52 then
			message.show_voiced_for_frames_skipping(50040, -1, 10)
		end
		if resume_step <= 53 then
			cutscene.skip_command(0)
		end
		if resume_step <= 54 then
			wait.frames_skipping(40)
		end
		if resume_step <= 55 then
			cutscene.skip_command(2)
		end
		if resume_step <= 56 then
			wait.background_load_skipping()
		end
		if resume_step <= 58 then
			message.show_voiced_for_frames_skipping(50050, -1, 10)
		end
		if resume_step <= 60 then
			message.show_voiced_for_frames_skipping(50060, -1, 10)
		end
		if resume_step <= 61 then
			cutscene.skip_command(3)
		end
		if resume_step <= 63 then
			message.show_voiced_for_frames_skipping(50070, -1, 10)
		end
		if resume_step <= 64 then
			cutscene.skip_command(0)
		end
		if resume_step <= 65 then
			message.show_voiced_for_frames_skipping(50080, -1, 10)
		end
		if resume_step <= 66 then
			message.show_voiced_for_frames_skipping(50090, -1, 10)
		end
		if resume_step <= 67 then
			cutscene.skip_command(0)
		end
		if resume_step <= 68 then
			wait.frames_skipping(60)
		end
		if resume_step <= 69 then
			wait.frames_skipping(60)
		end
		if resume_step <= 70 then
			message.show_voiced_for_frames_skipping(50100, -1, 10)
		end
		if resume_step <= 71 then
			cutscene.skip_command(0)
		end
		if resume_step <= 72 then
			message.show_voiced_for_frames_skipping(50110, -1, 10)
		end
		if resume_step <= 74 then
			wait.background_load_skipping()
		end
		if resume_step <= 75 then
			cutscene.skip_command(0)
		end
		if resume_step <= 76 then
			message.show_voiced_for_frames_skipping(50120, -1, 10)
		end
		if resume_step <= 77 then
			cutscene.skip_command(3)
		end
		if resume_step <= 79 then
			message.show_voiced_for_frames_skipping(50130, -1, 10)
		end
		if resume_step <= 81 then
			message.show_voiced_for_frames_skipping(50140, -1, 10)
		end
		if resume_step <= 82 then
			cutscene.skip_command(3)
		end
		if resume_step <= 83 then
			wait.frames_skipping(30)
		end
		if resume_step <= 84 then
			wait.background_load_skipping()
		end
		if resume_step <= 85 then
			wait.background_load_skipping()
		end
		if resume_step <= 86 then
			cutscene.skip_command(0)
		end
		if resume_step <= 87 then
			cutscene.skip_command(2)
		end
		if resume_step <= 88 then
			cutscene.skip_command(0)
		end
		if resume_step <= 89 then
			wait.frames_skipping(20)
		end
		if resume_step <= 90 then
			cutscene.skip_command(0)
		end
		if resume_step <= 91 then
			wait.frames_skipping(10)
		end
		if resume_step <= 92 then
			wait.frames_skipping(16)
		end
		if resume_step <= 93 then
			cutscene.skip_command(2)
		end
		if resume_step <= 94 then
			cutscene.skip_command(2)
		end
		if resume_step <= 95 then
			cutscene.ignore_value(0)
			cutscene.skip_command(0)
		end
		if resume_step <= 96 then
			wait.frames_skipping(10)
		end
		if resume_step <= 97 then
			wait.frames_skipping(5)
		end
		if resume_step <= 98 then
			cutscene.skip_command(2)
		end
		if resume_step <= 99 then
			cutscene.skip_command(0)
		end
		if resume_step <= 100 then
			wait.frames_skipping(20)
		end
		if resume_step <= 101 then
			wait.frames_skipping(10)
		end
		if resume_step <= 102 then
			cutscene.skip_command(0)
		end
		if resume_step <= 103 then
			wait.frames_skipping(50)
		end
		if resume_step <= 104 then
			cutscene.skip_command(2)
		end
		if resume_step <= 105 then
			cutscene.skip_command(0)
		end
		if resume_step <= 107 then
			message.show_voiced_for_frames_skipping(50150, -1, 10)
		end
		if resume_step <= 108 then
			wait.frames_skipping(10)
		end
		if resume_step <= 109 then
			cutscene.skip_command(0)
		end
		if resume_step <= 110 then
			wait.frames_skipping(30)
		end
		if resume_step <= 111 then
			cutscene.skip_command(0)
		end
		if resume_step <= 112 then
			message.show_voiced_for_frames_skipping(50160, -1, 10)
		end
		if resume_step <= 113 then
			cutscene.skip_command(1)
		end
		if resume_step <= 114 then
			message.open_skipping(0, -1, 8, 0, 0)
			message.wait_voice_for_skipping(0, 40)
		end
		if resume_step <= 115 then
			message.close_skipping(0)
			cutscene.skip_command(0)
		end
		if resume_step <= 116 then
			cutscene.ignore_value(1)
			voice_load_frames = sound.wait_voice_stream_ready_counting_skipping(1)
		end
		if resume_step <= 117 then
			message.open_skipping(0, -1, 8, 0, 0)
			message.wait_voice_for_skipping(0, vm.i32(40 - voice_load_frames))
		end
		if resume_step <= 118 then
			message.close_skipping(0)
			cutscene.skip_command(0)
		end
		if resume_step <= 119 then
			wait.frames_skipping(30)
		end
		if resume_step <= 120 then
			cutscene.skip_command(5)
		end
		if resume_step <= 121 then
			wait.frames_skipping(35)
		end
		if resume_step <= 122 then
			cutscene.skip_command(2)
		end
		if resume_step <= 123 then
			cutscene.skip_command(2)
		end
		if resume_step <= 124 then
			wait.frames_skipping(10)
		end
		if resume_step <= 125 then
			cutscene.skip_command(2)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_all_sounds()
	event.close_voice_stream(1)
	resume_step = 127
	wait.frames(4)
	event.clear_object_sequence(7)
	event.set_object_handle_shadow_enabled(0, 1)
	event.set_character_active(1, 0)
	event.set_character_cloth_animation_enabled(0, 1)
	event.set_character_shadow_culling_off(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
end

--- Plays the rooftop camera sweep over the hero, two other characters and Donnie, then waits for a button press before removing them.
function palm_brinks_m08.play_rooftop_camera_sweep()
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.set_time_of_day(24.0)
	event.set_time_of_day_advancing(0)
	event.clear_memory_stack(4)
	event.assign_memory_stack(4)
	event.clear_memory_stack(5)
	event.assign_memory_stack(5)
	event.delete_character_extension_packs(0)
	event.load_character_motion_pack(5, "event/lm/c01ev.gltf", "info", 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "屋根", 5)
	event.load_character(5, "event/lm/p00_02ev.gltf", "info", 9)
	event.set_character_active(9)
	event.attach_object_handle_to_character(1, 9)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(1, "屋根", 5)
	event.load_character(5, "event/lm/p00_03ev.gltf", "info", 10)
	event.set_character_active(10)
	event.attach_object_handle_to_character(2, 10)
	event.set_object_handle_position(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(2, "屋根の上", 5)
	event.load_character(5, "event/opening/p5/p5_donnie.gltf", "info", 11)
	event.set_character_active(11)
	event.set_character_position(11, 0.0, 0.0, 0.0)
	event.set_character_rotation(11, 0.0, 0.0, 0.0)
	event.set_character_motion(11, "閉める", 2)
	event.clear_camera_sequence()
	event.set_camera_sequence_follow_object(0, 5.0, 20.0, 0.0, 2.2, 20.0, 100.0, "ground")
	wait.frames(30)
	event.set_object_handle_motion(0, "屋根", 6)
	event.set_object_handle_motion(1, "屋根", 6)
	event.set_object_handle_motion(2, "屋根の上", 6)
	event.move_camera_sequence_angle_height_distance_eased(-2.2, 40.0, 100.0, 48, 2, 0.4)
	event.move_camera_sequence_angle_height_distance_eased(-2.2, 160.0, 200.0, 20, 0, 0.4)
	event.delay_camera_sequence_angle_track(20)
	event.move_camera_sequence_angle_height_distance_eased(1.57, 5.0, 80.0, 28, 0, 0.4)
	event.move_camera_sequence_angle_height_distance_eased(1.57, 0.0, 30.0, 50, 0, 0.4)
	event.move_camera_sequence_angle_height_distance_eased(-2.84, 150.0, 230.0, 30, 0, 0.2)
	camera.wait_until_done()
	event.release_camera_sequence_follow_object()
	wait.until_button_pressed(64)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.set_character_active(1, 0)
end

--- Plays the skippable cutscene of the hero running through the town along a path with a tracking camera, then jumps to map m06.
function palm_brinks_m08.play_run_to_exit_cutscene()
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(618.0)
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 367.64, 52.0, 143.02)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "走り")
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 430)
		event.add_object_sequence_path_point(0, 367.64, 52.0, 143.02)
		event.add_object_sequence_path_point(0, 437.18, 52.0, 143.7)
		event.add_object_sequence_path_point(0, 525.69, 4.07, 150.85)
		event.add_object_sequence_path_point(0, 592.54, 4.07, 146.54)
		event.add_object_sequence_path_point(0, 662.48, 0.0, 106.25)
		event.add_object_sequence_path_point(0, 724.99, 0.0, 74.39)
		event.add_object_sequence_path_point(0, 815.37, 0.0, 75.89)
		event.add_object_sequence_path_point(0, 949.64, 0.0, 155.14)
		event.add_object_sequence_path_point(0, 1096.43, 0.0, 260.16)
		event.add_object_sequence_path_point(0, 1196.25, 0.0, 375.44)
		event.add_object_sequence_path_point(0, 1279.57, 0.0, 504.31)
		event.add_object_sequence_path_point(0, 1300.41, 0.0, 606.99)
		event.start_object_sequence_path(0)
		event.set_scene_status_flags(1, 0, 8, 1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(665.91, 81.93, -90.96)
		event.set_camera_sequence_look_at(496.81, 61.93, 126.47)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		wait.frames(90)
		event.set_camera_sequence_position(411.47, 70.02, -81.02)
		event.set_camera_sequence_look_at(742.24, 61.93, 120.93)
		event.set_scene_status_flags(1, 0, 8, 0)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(500)
		event.add_camera_sequence_path_point(366.48, 63.99, -74.02, 504.01, 35.91, 19.16)
		event.add_camera_sequence_path_point(376.09, 64.39, -74.07, 513.62, 37.39, 19.11)
		event.add_camera_sequence_path_point(383.64, 65.08, -76.39, 522.12, 39.72, 18.44)
		event.add_camera_sequence_path_point(393.5, 65.72, -75.66, 529.18, 42.2, 17.46)
		event.add_camera_sequence_path_point(397.26, 66.22, -77.95, 534.79, 47.76, 15.23)
		event.add_camera_sequence_path_point(403.26, 66.95, -79.13, 540.79, 58.7, 14.05)
		event.add_camera_sequence_path_point(408.35, 67.87, -80.75, 545.88, 84.01, 12.43)
		event.add_camera_sequence_path_point(409.92, 69.25, -82.46, 547.44, 114.61, 10.72)
		event.add_camera_sequence_path_point(413.71, 70.4, -82.7, 551.24, 185.45, 10.48)
		event.start_camera_sequence_path()
		wait.frames(200)
		wait.frames(270)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 8, 0)
	event.stop_music(0)
	event.stop_environment_music()
	wait.frames(4)
	event.skip_next_map_sound_load()
	event.jump_to_map_3(-1, "m06", 152)
end

--- Shows or hides the houses, windows, doors, lamps, bridges, signs, barrels and other props of the town map.
function palm_brinks_m08.set_town_parts_visible(visible: s32)
	event.attach_object_handle_to_map_part_2(31, "家1")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-8")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-9")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-10")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-11")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-12")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-13")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-14")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-15")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-16")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-17")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-18")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-19")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-20")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-21")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-22")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-23")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-24")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-25")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-26")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家1-27")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-2")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-3")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-4")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-5")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-6")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-7")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-8")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-9")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-10")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-11")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-12")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-13")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-14")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家2-15")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-3")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-4")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-5")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-6")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-7")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-8")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-9")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-10")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-11")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-12")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-13")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-14")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-15")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-16")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家3-17")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(オ)02")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(オ)02-1")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(オ)02-2")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(オ)02-3")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(オ)03")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(オ)03-1")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(ア)01")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(ア)02")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(ア)02-1")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(ア)03")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(キ)01")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家(キ)02")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "看板(ベランダ)")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "看板（ゲート）-2")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "看板-8")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "看板-9")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "橋-2")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "橋-3")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "橋-4")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "橋-5")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ドア-3")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ドア-12")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ドア-13")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ドア-14")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ドア-15")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ドア-16")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ドア-17")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "リアカー")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "車輪")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "車輪-1")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "窓-13")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "窓-14")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "窓-15")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "窓-16")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "窓-19")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "窓-20")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "門-1")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "植木-4")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "植木-5")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "植木-6")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "植木-7")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "植木-8")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "貸し倉庫")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "テント(緑)-4")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "テント(緑)-5")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "家３角")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "街灯-9")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "街灯-13")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "街灯-14")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "街灯-15")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-1")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-2")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-3")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-5")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-6")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-7")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-8")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-9")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-13")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-14")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "タル-15")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ランプ-5")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ランプ-7")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ランプ-11")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ランプ-12")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ランプ-13")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ランプ-14")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ランプ-15")
	event.set_object_handle_visible(31, visible)
	event.attach_object_handle_to_map_part_2(31, "ランプ-19")
	event.set_object_handle_visible(31, visible)
end

return palm_brinks_m08
