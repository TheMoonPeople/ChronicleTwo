--!strict
--- Train Town Cedric's train house script that handles entry, boarding the train and villager dialogue.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local map = require("@lib/event/map")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local npc = require("@lib/event/npc")
local object = require("@lib/event/object")
local train = require("@lib/event/train")
local train_town_cedric_train = require("@lib/event/train_town_cedric_train")
local wait = require("@lib/event/wait")

--- Sets up the train, swings its door parts open and has the player run out onto the platform.
local function play_train_arrival_scene()
	local sound_bank: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 6)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.set_object_sequence_position(0, -150.0, 35.8, -1260.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, -119.0, 0.0, -2000.0)
	event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m0")
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m1")
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m0")
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m1")
	event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m12")
	event.attach_object_handle_to_map_part_3(7, "p01_train01", "train10-m13")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(6, 6)
	event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(7, 7)
	event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
	sound_bank = event.get_sound_id(2) or sound_bank
	event.play_sound_effect(sound_bank, 66)
	event.set_camera_sequence_position(-286.2, 99.77, -1363.38)
	event.set_camera_sequence_look_at(-195.75, 74.39, -1275.17)
	event.set_object_sequence_position(1, -119.0, 0.0, -1800.0)
	event.fade_in_screen(30)
	event.set_character_active(0)
	event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
	event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
	event.rotate_object_sequence(6, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(7, 0.0, -1.5, 0.0, 30)
	wait.for_frame_count(20)
	event.set_object_sequence_motion(0, "走り")
	event.move_object_sequence(0, -232.0, 35.8, -1260.0, 30)
	wait.for_frame_count(20)
	event.set_object_handle_footstep_sound(0, 2)
	wait.for_frame_count(10)
	event.set_object_sequence_motion(0, "立ち")
	wait.for_frame_count(10)
	event.set_character_active(0)
	event.set_character_position(0, -232.0, 35.8, -1260.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_object_handle_position(1, -119.0, 0.0, -1800.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(1, 3.14, 28.0)
end

--- Fades in on the train, opens two of its parts and has the player run out onto the platform in chapters 6 and 7.
local function play_late_chapter_train_arrival_scene()
	local sound_bank: s32 = 0
	event.initialize_event()
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m6")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(1, -119.0, 0.0, -1800.0)
	event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-286.2, 99.77, -1363.38)
	event.set_camera_sequence_look_at(-195.75, 74.39, -1275.17)
	event.fade_in_screen(30)
	wait.for_frame_count(60)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -150.0, 35.8, -1260.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	sound_bank = event.get_sound_id(2) or sound_bank
	event.play_sound_effect(sound_bank, 92)
	wait.for_frame_count(15)
	event.move_object_sequence(0, -232.0, 35.8, -1260.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.for_frame_count(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, -119.0, 0.0, -1800.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_character_active(0)
	event.set_character_position(0, -232.0, 35.8, -1260.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 28.0)
	event.fade_in_screen(15)
end

--- Crossfades to a sky camera pan and switches the music.
local function play_sky_pan_scene(sound_bank: any)
	event.start_crossfade(1, 1, 60)
	event.set_camera_sequence_position(14.46, 268.16, 737.45)
	event.set_camera_sequence_look_at(-30.4, 237.84, 510.02)
	event.move_camera_sequence_eased(-72.53, 268.16, 754.61, -117.4, 237.84, 527.18, 120, 2, 0.4)
	camera.wait_until_done()
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(193)
end

--- Fades in on the train lights flashing and steam venting.
local function play_train_lights_and_steam_scene(se_id: s32)
	event.set_camera_sequence_position(-130.02, 67.35, -2138.26)
	event.set_camera_sequence_look_at(-120.37, 83.46, -1843.2)
	event.set_character_active(0, 33)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.stop_sound_effect(se_id, 6)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.play_sound_effect(se_id, 9)
	event.play_sound_effect(se_id, 10)
	event.set_character_active(1, 40)
	event.set_character_position(40, -116.18, 50.38, -1787.14)
	event.set_character_motion(40, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	wait.for_frame_count(30)
	event.set_character_active(1, 38)
	event.set_character_active(1, 39)
	event.attach_object_handle_to_map_part_2(8, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 8)
	event.set_object_sequence_motion(6, "ぶしゅー", 6)
	event.set_object_sequence_motion(7, "ぶしゅー", 6)
	event.set_object_sequence_position(6, -114.25, 13.26, -1653.54)
	event.set_object_sequence_rotation(6, 0.0, 3.04, 0.0)
	event.set_object_sequence_position(7, -126.53, 32.32, -1662.93)
	event.set_object_sequence_rotation(7, 0.0, -3.12, 0.0)
	event.play_sound_effect(se_id, 11)
	wait.for_frame_count(45)
	event.set_character_active(0, 40)
end

--- Slides the two station gate parts apart with a sound effect.
local function play_station_gate_opening_scene(se_id: s32)
	event.set_camera_sequence_position(-326.52, 113.91, -1579.31)
	event.set_camera_sequence_look_at(-22.58, 118.56, -2134.59)
	event.set_character_active(0, 33)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.stop_sound_effect(se_id, 10)
	event.play_sound_effect(se_id, 12)
	event.move_object_sequence(11, -200.0, 0.0, 0.0, 285)
	event.move_object_sequence(12, 200.0, 0.0, 0.0, 285)
	object.wait_until_done(11)
	object.wait_until_done(12)
	wait.for_frame_count(30)
end

--- Sets the train moving with the departure sound.
local function play_train_start_scene(se_id: s32)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.set_camera_sequence_position(-333.13, 124.81, -2141.66)
	event.set_camera_sequence_look_at(-142.51, 84.44, -1891.87)
	event.set_character_active(0, 33)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.play_sound_effect(se_id, 13)
	event.move_object_sequence_eased(10, -120.0, 0.0, -2100.0, 60, 1, 1.0)
	wait.for_frame_count(60)
end

--- Accelerates the train past the camera.
local function play_train_acceleration_scene(sound_bank: any)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-127.04, 86.04, -2182.12)
	event.set_camera_sequence_look_at(-120.48, 84.44, -1718.57)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_object_sequence_position(10, -120.0, 0.0, -1690.0)
	event.move_camera_sequence_eased(-126.85, 86.09, -2262.29, -120.48, 84.44, -1718.57, 20, 2, 0.4)
	event.move_object_sequence(10, -120.0, 0.0, -2100.0, 45)
	wait.for_frame_count(45)
end

--- Moves the train along the track with the camera watching from above.
local function play_train_departure_scene(sound_bank: any)
	event.set_camera_sequence_position(-292.76, 173.19, -1582.23)
	event.set_camera_sequence_look_at(-228.24, 151.8, -1773.02)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_object_sequence_position(10, -120.0, 0.0, -1690.0)
	event.move_object_sequence(10, -120.0, 0.0, -3050.0, 90)
	wait.for_frame_count(90)
end

--- Shows the train speeding into the distance and stops the engine sound.
local function play_train_far_view_scene(se_id: s32)
	event.set_camera_sequence_position(57.23, 251.57, 242.48)
	event.set_camera_sequence_look_at(21.23, 241.82, 43.83)
	event.set_character_active(1, 36)
	event.set_character_position(36, 266.91, 197.74, 696.65)
	event.set_character_rotation(36, 0.0, -3.12, 0.0)
	event.set_object_sequence_motion(4, "前を見るL", 4)
	event.move_object_sequence(10, -120.0, 0.0, -6000.0, 120)
	wait.for_frame_count(30)
	event.move_camera_sequence_angle_height_distance_eased(-2.57, 9.27, 80.0, 120, 0, 0.4)
	camera.wait_until_done()
	event.stop_sound_effect(se_id, 9)
end

--- Runs the whole train departure event, loading its characters, playing its scenes and cleaning up.
local function play_train_departure_event()
	local sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(109, 1)
		event.set_save_flag(9, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(1246)
		sound_bank = event.load_sound_effect_file_2(1246) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.load_character(5, "event/e100/e109/e109_starbre.gltf", "info", 33)
		event.set_character_active(1, 33)
		event.attach_object_handle_to_character(1, 33)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_position(33, -251.33, 36.72, -1629.09)
		event.set_character_rotation(33, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e109/e109_vorneo.gltf", "info", 34)
		event.set_character_active(1, 34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_character_position(34, -251.33, 36.72, -1629.09)
		event.set_character_rotation(34, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e109/e109_tom.gltf", "info", 35)
		event.set_character_active(1, 35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_character_position(35, -251.33, 36.72, -1629.09)
		event.set_character_rotation(35, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e109/e109_need.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_character_position(36, -251.33, 36.72, -1629.09)
		event.set_character_rotation(36, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e200/e202/e202_train_pika.gltf", "info", 40)
		event.set_character_active(0, 40)
		event.load_character(5, "event/train/steam/steam_l.gltf", "info", 38)
		event.set_character_active(0, 38)
		event.attach_object_handle_to_character(6, 38)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, -120.0, 0.0, -1690.0)
		event.load_character(5, "event/train/steam/steam_r.gltf", "info", 39)
		event.set_character_active(0, 39)
		event.attach_object_handle_to_character(7, 39)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, -120.0, 0.0, -1690.0)
		event.attach_object_handle_to_map_part_2(10, "p01_train01")
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_position(10, -120.0, 0.0, -1690.0)
		event.attach_object_handle_to_map_part_3(11, "p41_i02h01", "i02h01_41-m")
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.set_object_sequence_position(11, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(12, "p42_i02h01", "i02h01_42-m")
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.set_object_sequence_position(12, 0.0, 0.0, 0.0)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.load_message_file(0, 5, "event/e100/e109/e109b.txt")
		event.stop_music(0)
		event.play_sound_effect(sound_bank, 6)
		event.set_object_handle_sound_bank(1, sound_bank)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目パチ")
		event.enable_drama_skip()
		play_sky_pan_scene(sound_bank)
		train_town_cedric_train.play_departure_briefing_scene(sound_bank)
		train_town_cedric_train.play_crew_response_scene(sound_bank)
		train_town_cedric_train.play_departure_shout_scene(sound_bank)
		train_town_cedric_train.play_crew_run_scene(sound_bank)
		play_train_lights_and_steam_scene(sound_bank)
		play_station_gate_opening_scene(sound_bank)
		play_train_start_scene(sound_bank)
		play_train_acceleration_scene(sound_bank)
		play_train_departure_scene(sound_bank)
		play_train_far_view_scene(sound_bank)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		train_town_cedric_train.play_final_remark_scene(sound_bank)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_music(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.stop_sound_effect(sound_bank, 6)
	event.stop_sound_effect(sound_bank, 9)
	event.stop_sound_effect(sound_bank, 10)
	event.set_character_active(1, 0)
	event.clear_effect_manager()
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.fade_in_screen(30)
end

--- Asks whether to go inside the train, returning 1 for the first option and 0 when cancelled or after the second option opens its event menu.
local function ask_to_board_train()
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.initialize_event()
		message.set_window_mode(0, 4)
		event.open_message_window_2(0, "中に入る\n出発する")
		resume_step = 1
		choice = message.open_and_ask_choice(0, -1, 5, 256, 208, 2, 0)
		if choice == -1 then
			message.set_window_mode(0, 1)
			return 0
		end
		if choice == 1 then
			event.fade_out_screen(15)
			resume_step = 2
			wait.for_frame_count(15)
			event.open_event_menu(19, 0)
			resume_step = 3
			vm.wait(3)
			event.fade_in_screen(15)
			resume_step = 4
			wait.for_frame_count(15)
			return 0
		end
		return 1
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			message.set_window_mode_skipping(0, 1)
			return 0
		end
		if resume_step <= 4 then
			if resume_step <= 3 then
				wait.skip_frame_count(15)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = train_town_cedric_train.initialize_train_house

--- Places the player and starts the train arrival scene depending on where they came from and the chapter.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_number: s32 = 0
	local previous_map_type: s32 = 0
	local save_counter: s32 = 0
	local chapter: s32 = 0
	event.initialize_event()
	train_town_cedric_train.initialize_train_house()
	print("start_event--------------------------------------------\n")
	memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
	if memory_card_load_state == 1 then
		event.set_character_position(0, -240.0, 35.8, 140.0)
		event.set_character_rotation(0, 0.0, 3.14, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 3.14, 20.0)
	else
		previous_map_number = event.get_previous_map() or previous_map_number
		previous_map_type = event.get_map_type(previous_map_number) or previous_map_type
		if previous_map_type ~= -1 then
			if previous_map_number == 10 or previous_map_number == 22 or previous_map_number == 121 then
				event.set_character_position(0, 0.0, 198.8, 1450.0)
				event.set_character_rotation(0, 0.0, 3.14, 0.0)
				event.reset_follow_camera(1, 3.14)
				event.fade_in_screen(30)
			else
				save_counter = event.get_save_counter(1) or save_counter
				if (previous_map_number == 18 or previous_map_number == 23 or previous_map_number == 120 or previous_map_number == 108) and save_counter == 1 then
					train.place_player_at_saved_platform()
					event.fade_in_screen(15)
					event.reset_follow_camera(1, 0.0)
				else
					chapter = event.get_chapter() or chapter
					if chapter ~= 6 and chapter ~= 7 then
						play_train_arrival_scene()
					else
						play_late_chapter_train_arrival_scene()
					end
				end
			end
		end
		event.set_character_motion(0, "立ち")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_late_chapter_train_arrival_scene

--- Event 151, which map data, a script or the engine runs by number.
script.play_train_departure_event = play_train_departure_event
script[151] = script.play_train_departure_event

--- Shows the train from a fixed camera until a button is pressed, then moves the train away and restores the follow camera.
function script.cutscene_view_train()
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		resume_step = 1
		vm.wait(1)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			train_x = out1 or train_x
			train_y = out2 or train_y
			train_z = out3 or train_z
		end
		print("pos[0]=", vm.float(train_x), "-----------\n")
		print("pos[1]=", vm.float(train_y), "-----------\n")
		print("pos[2]=", vm.float(train_z), "-----------\n")
		event.set_object_handle_position(0, train_x, train_y, 0.0)
		event.set_character_active(0, 122)
		event.set_character_active(0, 123)
		event.set_character_active(0, 0)
		event.set_camera_position(-345.21, 89.08, 234.02)
		event.set_camera_look_at(-238.57, 83.73, 148.63)
		resume_step = 2
		vm.wait(2)
		resume_step = 3
		wait.until_button_pressed(32)
		event.set_character_active(1, 122)
		event.set_character_active(1, 123)
		event.set_character_active(1, 0)
		event.set_object_handle_position(0, train_x, train_y, -1800.0)
		event.set_object_handle_rotation(0, 0.0, 3.1415927, 0.0)
		event.reset_follow_camera(0)
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				print("pos[0]=", vm.float(train_x), "-----------\n")
				print("pos[1]=", vm.float(train_y), "-----------\n")
				print("pos[2]=", vm.float(train_z), "-----------\n")
			end
			if resume_step <= 2 then
				wait.until_button_pressed_skipping(32)
			end
			return 0
		end
		return nil
	end)
end
script[160] = script.cutscene_view_train

--- Leaves the train house by jumping to map m02.
function script.leave_train_house()
	vm.wait(1)
	event.jump_to_map_2(-1, "m02")
	vm.wait(2)
	event.call_command(103, 1645.1, -41.3, -1812.6) -- retail: the handler rejects 3 arguments
	event.call_command(104, 0, -0.09, 0) -- retail: the handler rejects 3 arguments
end
script[200] = script.leave_train_house

--- Shows Max thinking about the train until a save flag is set, then asks to board and sends the player to the destination for the chapter and trigger data.
function script.examine_train()
	local train_intro_flag: s32 = 0
	local boarding_choice: s32 = 0
	local chapter: s32 = 0
	local trigger_data: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		train_intro_flag = event.get_save_flag(202) or train_intro_flag
		if train_intro_flag == 0 then
			resume_step = 1
			character.turn_to_rotation(0, vm.f32(1.57))
			message.set_window_mode(0, 1)
			event.open_message_window_2(
				0,
				"これは「列車」という機械だと\nスターブルは言ってたっけ・・・<page>今はトムとボルネオさんのお家に\nなってるけど、ボクが生まれる前は\n動いてたんだって。ホントかな？"
			)
			resume_step = 2
			message.show_and_wait(0, -1, 5, 256, 208)
			event.open_message_window_2(0, "本当にこんな大きな物が\n動くなら、見てみたいな。")
			resume_step = 3
			message.show_and_wait(0, -1, 5, 256, 208)
			return
		end
		resume_step = 4
		boarding_choice = ask_to_board_train()
		if boarding_choice ~= 1 then
			return
		end
		event.set_save_counter(1, 1)
		chapter = event.get_chapter() or chapter
		trigger_data = event.get_triggered_event_data_2(3) or trigger_data
		if trigger_data <= 1 then
			if chapter ~= 6 and chapter ~= 7 then
				resume_step = 5
				train.board_short_train_primary()
				event.stop_music(0)
				resume_step = 6
				vm.wait(6)
				event.jump_to_map_2(-1, "s08")
			else
				resume_step = 7
				train.board_short_train_primary()
				event.stop_music(0)
				resume_step = 8
				vm.wait(8)
				event.jump_to_map_2(-1, "s37")
			end
			resume_step = 9
			vm.wait(9)
		elseif chapter ~= 6 and chapter ~= 7 then
			resume_step = 10
			train.board_train_primary(0)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			resume_step = 11
			train.board_train_via_gangway_primary()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				message.set_window_mode_skipping(0, 1)
				message.show_and_wait_skipping(0, -1, 5, 256, 208)
			end
			if resume_step <= 2 then
				message.show_and_wait_skipping(0, -1, 5, 256, 208)
			end
			return 0
		end
		if resume_step <= 4 then
			if resume_step == 4 then
				boarding_choice = received[1] :: number
			end
			return 0
		end
		if resume_step <= 11 then
			if resume_step <= 6 then
				map.run_train_interval_waits()
			end
			if resume_step <= 9 then
				map.print_train_debug_info(0)
			end
			if resume_step <= 10 then
				train.board_train_via_gangway_skipping_primary()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.examine_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_type_7

--- Plays the train departure scene and enters the dungeon.
function script.cutscene_train_departure_then_enter_dungeon()
	local scene_character_slot: s32 = 0
	scene_character_slot = event.find_scene_character_slot(2) or scene_character_slot
	event.set_character_active(0, scene_character_slot)
	event.set_villager_ai_enabled(0, scene_character_slot)
	play_train_departure_event()
	event.go_to_dungeon(0, -1, 1000)
end
script[500] = script.cutscene_train_departure_then_enter_dungeon

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = npc.talk_to_villager

return script
