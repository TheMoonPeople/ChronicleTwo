--!strict
--- Holds the train-stop cutscenes and setup shared by the Heim Rada Stop maps.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local train = vm.module("@lib/event/train")
local wait = vm.module("@lib/event/wait")

local heim_rada_stop = {}

--- Asks whether to leave the stop and either runs the player out or steps them back into it.
function heim_rada_stop.confirm_leave_stop()
	local answer: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		resume_step = 1
		answer = message.ask_yes_no(5, 3)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
			event.set_camera_sequence_position(2590.33, 108.76, 1218.81)
			event.set_camera_sequence_look_at(2591.54, 130.16, 1030.59)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 70)
			event.add_object_sequence_path_point(0, 2616.58, 125.16, 846.91)
			event.add_object_sequence_path_point(0, 2674.4, 138.96, 765.84)
			event.add_object_sequence_path_point(0, 2730.28, 163.23, 630.94)
			event.start_object_sequence_path(0)
			resume_step = 2
			wait.frames(50)
			event.fade_out_screen(20)
			resume_step = 3
			wait.frames(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(-0.42)) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(-0.42)) * 30.0) + z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					x = out1 or x
					y = out2 or y
					z = out3 or z
				end
				y = vm.f32(y + 30.0)
				event.set_camera_look_at(x, y, z)
				i = i + 1
				resume_step = 4
				vm.wait(4)
			end
		end
		event.set_object_handle_footstep_sound(0, 0)
		return 0
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				wait.frames_skipping(50)
			end
			if resume_step <= 2 then
				wait.frames_skipping(20)
			end
			return 1
		end
		if resume_step <= 4 then
			return 0
		end
		return nil
	end)
end

--- Waits out the transition frames that follow the run into the stop and repositions the player.
function heim_rada_stop.finish_run_into_stop()
	cutscene.skip_command(1)
	wait.frames_skipping(30)
	wait.frames_skipping(20)
	cutscene.skip_command(0)
	wait.frames_skipping(10)
	cutscene.ignore_coordinates(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
end

--- Does nothing.
function heim_rada_stop.noop() end

--- Plays the cutscene of the steam train sliding in and the player stepping off.
function heim_rada_stop.play_steam_train_arrival()
	local sound_bank: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local train_rotation_y: f32 = 0
	local approach_angle: f32 = 0
	local common_sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or sound_bank
	train.level_cars()
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m4")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m5")
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m4")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m5")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_handle_position(0, 2101.51, 40.82, 2060.52)
	event.set_object_handle_rotation(0, 0.0, -2.26, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_footstep_sound(0, 6)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		train_x = out1 or train_x
		train_y = out2 or train_y
		train_z = out3 or train_z
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(1)
		train_rotation_y = out2 or train_rotation_y
	end
	approach_angle = vm.f32(train_rotation_y - vm.f32(3.1415927))
	approach_angle = event.wrap_angle(approach_angle) or approach_angle
	start_x = vm.f32(vm.f32(vm.sin(approach_angle) * 200.0) + train_x)
	start_y = train_y
	start_z = vm.f32(vm.f32(vm.cos(approach_angle) * 200.0) + train_z)
	event.set_object_handle_position(1, start_x, start_y, start_z)
	event.move_object_sequence_eased(1, train_x, train_y, train_z, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1514.63, 208.98, 2402.32)
	event.set_camera_sequence_look_at(1792.39, 155.32, 2165.78)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("列車煙")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 1)
	event.play_sound_effect(sound_bank, 0)
	event.fade_in_screen(30)
	object.wait_until_done(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	train.tilt_cars()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_camera_sequence_position(1899.12, 13.68, 1889.27)
	event.set_camera_sequence_look_at(1958.62, 31.92, 1939.67)
	common_sound_bank = event.get_sound_id(2) or common_sound_bank
	event.play_sound_effect(common_sound_bank, 106)
	event.set_character_active(0)
	event.set_object_handle_position(1, train_x, train_y, train_z)
	event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
	event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
	wait.frames(30)
	event.set_object_sequence_motion(0, "走り")
	event.delay_object_sequence_motion_track(0, 56)
	event.set_object_sequence_motion(0, "立ち")
	event.move_object_sequence(0, 2087.08, 40.82, 2048.3, 14)
	event.move_object_sequence(0, 2037.85, 0.0, 2005.99, 32)
	event.move_object_sequence(0, 2017.4, 0.0, 1988.67, 10)
	wait.frames(46)
	event.set_object_handle_footstep_sound(0, 16)
	event.fade_out_screen(15)
	wait.frames(15)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_character_active(0)
	character.place_standing_and_reset_cloth(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.clear_effect_manager()
	event.fade_in_screen(15)
end

--- Plays the cutscene of the train sliding in and the player stepping off.
function heim_rada_stop.play_train_arrival()
	local sound_bank: s32 = 0
	local carriage_part_x: f32 = 0
	local carriage_part_y: f32 = 0
	local carriage_part_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local train_rotation_y: f32 = 0
	local approach_angle: f32 = 0
	local common_sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or sound_bank
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m5")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m10")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m4")
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m2")
	do
		local out1, out2, out3 = event.get_object_handle_position(5)
		carriage_part_x = out1 or carriage_part_x
		carriage_part_y = out2 or carriage_part_y
		carriage_part_z = out3 or carriage_part_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		train_x = out1 or train_x
		train_y = out2 or train_y
		train_z = out3 or train_z
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(1)
		train_rotation_y = out2 or train_rotation_y
	end
	approach_angle = vm.f32(train_rotation_y - vm.f32(3.1415927))
	approach_angle = event.wrap_angle(approach_angle) or approach_angle
	start_x = vm.f32(vm.f32(vm.sin(approach_angle) * 200.0) + train_x)
	start_y = train_y
	start_z = vm.f32(vm.f32(vm.cos(approach_angle) * 200.0) + train_z)
	event.set_object_handle_position(1, start_x, start_y, start_z)
	event.move_object_sequence_eased(1, train_x, train_y, train_z, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1514.63, 208.98, 2402.32)
	event.set_camera_sequence_look_at(1792.39, 155.32, 2165.78)
	event.fade_in_screen(30)
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(1)
	event.set_camera_sequence_position(1890.88, 13.68, 2033.57)
	event.set_camera_sequence_look_at(1970.25, 31.92, 2037.52)
	event.set_character_active(0)
	event.set_object_handle_position(1, train_x, train_y, train_z)
	event.set_object_sequence_position(0, 2125.0, 40.0, 2080.0)
	event.set_object_sequence_rotation(0, 0.0, -2.26, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, -0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, -0.3926991, 30)
	common_sound_bank = event.get_sound_id(2) or common_sound_bank
	event.play_sound_effect(common_sound_bank, 92)
	wait.frames(30)
	event.move_object_sequence(5, carriage_part_x + 11.25, carriage_part_y - 4.75, carriage_part_z, 30)
	wait.frames(20)
	event.move_object_sequence(0, 2050.0, 0.0, 2015.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, train_x, train_y, train_z)
	event.set_object_handle_rotation(1, 0.0, train_rotation_y, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, carriage_part_x, carriage_part_y, carriage_part_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_character_active(0)
	character.place_standing_and_reset_cloth(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(15)
end

--- Runs the player along a path into the stop with a fade out and in, then repositions them and restores the follow camera.
function heim_rada_stop.run_into_stop()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 70)
	event.add_object_sequence_path_point(0, 2730.28, 163.23, 630.94)
	event.add_object_sequence_path_point(0, 2674.4, 138.96, 765.84)
	event.add_object_sequence_path_point(0, 2616.58, 125.16, 846.91)
	event.start_object_sequence_path(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(2590.33, 108.76, 1218.81)
	event.set_camera_sequence_look_at(2591.54, 130.16, 1030.59)
	event.fade_in_screen(15)
	wait.frames(40)
	event.fade_out_screen(15)
	wait.frames(15)
	event.set_object_handle_footstep_sound(0, 0)
	character.place_standing_and_reset_cloth(vm.f32(2358.3), 0.0, vm.f32(1357.7), vm.f32(0.06))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Spawns the stop villager when save flag 500 is set, using a different villager in chapters 6 and 7.
function heim_rada_stop.spawn_villager()
	local save_flag: s32 = 0
	local chapter: s32 = 0
	save_flag = event.get_save_flag(500) or save_flag
	if save_flag == 0 then
		return
	end
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	chapter = event.get_chapter() or chapter
	if chapter ~= 6 and chapter ~= 7 then
		event.load_character(4, "chara/p01_03a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, 2340.0, 0.0, 1645.0)
		event.set_character_rotation(8, 0.0, 3.14, 0.0)
		event.set_scene_character_number(8, 1)
		event.register_villager(8, 1)
	else
		event.load_character(4, "chara/p00_31a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, 2340.0, 0.0, 1645.0)
		event.set_character_rotation(8, 0.0, 3.14, 0.0)
		event.set_scene_character_number(8, 301)
		event.register_villager(8, 301)
	end
end

return heim_rada_stop
