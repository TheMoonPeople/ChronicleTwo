--!strict
--- Event helpers specific to the Luna Lab maps.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local cutscene = vm.module("@lib/event/cutscene")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local luna_lab = {}

--- Plays the e600 cutscene in which a train pulls out of the station past the platform parts and then flies off, with water-spray, flow and light characters appearing along the way.
function luna_lab.play_train_departure_scene()
	local sound_bank: s32 = 0
	local frame_index: s32 = 0
	local position_z: f32 = 0
	local velocity_z: f32 = 0
	local acceleration_z: f32 = 0
	local position_y: f32 = 0
	local velocity_y: f32 = 0
	local acceleration_y: f32 = 0
	local position_x: f32 = 0
	local velocity_x: f32 = 0
	local acceleration_x: f32 = 0
	local step: number = 0
	vm.section(function()
		event.set_save_flag(600, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		step = 1
		wait.frames(4)
		event.load_music(115)
		event.load_map_sounds(4525)
		sound_bank = event.load_sound_effect_file_2(4525) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.set_character_active(0, 0)
		event.change_directory("event/e600/e600/")
		event.load_character(5, "e600_mizusibuki.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.attach_object_handle_to_character(15, 32)
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		event.load_character(5, "e600_nagare.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_character(16, 33)
		event.clear_object_sequence(16)
		event.set_object_sequence_object(16, 16)
		event.load_character(5, "e600_hikari.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.change_directory("")
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p15_f0301-1")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_2(2, "p15_f0301")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_2(3, "p22_f0301")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_2(4, "p23_f0301")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_2(5, "p24_f0301")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "s3601_10-m")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "s3601_10-m1")
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.attach_object_handle_to_map_part_3(8, "p01_train01", "s3601_10-m2")
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.attach_object_handle_to_map_part_3(9, "p01_train01", "s3601_11-m")
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.attach_object_handle_to_map_part_3(10, "p01_train01", "s3601_11-m1")
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.attach_object_handle_to_map_part_3(11, "p18_f0301", "f030407-m")
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.attach_object_handle_to_map_part_3(12, "p19_f0301", "f030408-m")
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.attach_object_handle_to_map_part_3(13, "p20_f0301", "f030409-m")
		event.clear_object_sequence(13)
		event.set_object_sequence_object(13, 13)
		event.attach_object_handle_to_map_part_3(14, "p21_f0301", "f030410-m")
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.attach_object_handle_to_map_part_2(17, "p25_f0301")
		event.clear_object_sequence(17)
		event.set_object_sequence_object(17, 17)
		event.attach_object_handle_to_map_part_2(18, "p26_f0301")
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.attach_object_handle_to_map_part_2(19, "p27_f0301")
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.set_object_handle_position(0, 0.0, 70.0, -1860.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_position(1, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_position(3, 0.0, -100.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_position(4, 0.0, -400.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_position(5, 0.0, -700.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(11, 0.0, 2.3561945, 0.0)
		event.set_object_handle_rotation(12, 0.0, -0.7853982, 0.0)
		event.set_object_handle_rotation(13, 0.0, 0.7853982, 0.0)
		event.set_object_handle_rotation(14, 0.0, -2.3561945, 0.0)
		event.set_object_handle_visible(17, 1)
		event.set_object_handle_position(17, 0.0, -100.0, 0.0)
		event.set_object_handle_rotation(17, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(18, 1)
		event.set_object_handle_position(18, 0.0, -400.0, 0.0)
		event.set_object_handle_rotation(18, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(19, 1)
		event.set_object_handle_position(19, 0.0, -700.0, 0.0)
		event.set_object_handle_rotation(19, 0.0, 0.0, 0.0)
		event.set_object_handle_position(15, 0.0, 7.0, -1860.0)
		event.set_object_handle_rotation(15, 0.0, 3.14, 0.0)
		event.set_object_handle_position(16, 0.0, 150.0, -1800.0)
		event.set_object_handle_rotation(16, 0.0, 3.14, 0.0)
		event.set_character_position(34, 2566.79, 5880.98, -32029.89)
		event.rotate_object_sequence_eased(11, -0.4, 2.3561945, 0.0, 120, 0, 1.0)
		event.rotate_object_sequence_eased(12, -0.4, -0.7853982, 0.0, 120, 0, 1.0)
		event.rotate_object_sequence_eased(13, -0.4, 0.7853982, 0.0, 120, 0, 1.0)
		event.rotate_object_sequence_eased(14, -0.4, -2.3561945, 0.0, 120, 0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_look_at(0.0, 200.0, -1600.0)
		event.set_camera_sequence_angle_height_distance(2.6, 800.0, 3000.0)
		event.move_camera_sequence_angle_height_distance_eased(-2.6, 800.0, 3000.0, 120, 0, 1.0)
		event.fade_in_screen(30)
		step = 2
		wait.frames(14)
		event.play_music(0)
		step = 3
		wait.frames(66)
		event.play_sound_effect(sound_bank, 0)
		event.rotate_object_sequence_eased(1, 0.0, 0.08, 0.0, 160, 0, 1.0)
		event.rotate_object_sequence_eased(2, 0.0, -0.08, 0.0, 160, 0, 1.0)
		step = 4
		camera.wait_until_done()
		event.set_camera_sequence_position(213.43, 452.11, -5638.41)
		event.set_camera_sequence_look_at(206.97, 452.67, -5520.54)
		event.move_camera_sequence_eased(269.87, 930.16, -6906.42, 250.2, 895.98, -6763.9, 360, 0, 1.0)
		step = 5
		object.wait_until_done(2)
		event.play_sound_effect(sound_bank, 1)
		event.move_object_sequence_eased(3, 0.0, 0.0, 0.0, 100, 2, 1.0)
		event.delay_object_sequence_sound_track(3, 140.0)
		event.play_object_sequence_sound(3, sound_bank, 3)
		event.move_object_sequence_eased(5, 0.0, 0.0, 0.0, 360, 2, 1.0)
		event.delay_object_sequence_sound_track(5, 520.0)
		event.play_object_sequence_sound(5, sound_bank, 3)
		event.move_object_sequence_eased(17, 0.0, 0.0, 0.0, 100, 2, 1.0)
		event.move_object_sequence_eased(19, 0.0, 0.0, 0.0, 360, 2, 1.0)
		step = 6
		wait.frames(40)
		event.move_object_sequence_eased(4, 0.0, 0.0, 0.0, 200, 2, 1.0)
		event.move_object_sequence_eased(18, 0.0, 0.0, 0.0, 200, 2, 1.0)
		event.delay_object_sequence_sound_track(4, 280.0)
		event.play_object_sequence_sound(4, sound_bank, 3)
		step = 7
		object.wait_until_done(5)
		step = 8
		camera.wait_until_done()
		event.set_camera_sequence_position(427.74, 105.92, -3207.97)
		event.set_camera_sequence_look_at(380.62, 117.95, -3117.35)
		event.play_sound_effect(sound_bank, 4)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(17, 0)
		event.set_object_handle_visible(18, 0)
		event.set_object_handle_visible(19, 0)
		step = 9
		wait.frames(30)
		event.play_sound_effect(sound_bank, 5)
		event.move_object_sequence_eased(0, 0.0, 70.0, -2600.0, 120, 1, 1.0)
		event.move_object_sequence_eased(15, 0.0, 70.0, -2600.0, 120, 1, 1.0)
		event.rotate_object_sequence_eased(6, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence_eased(7, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence_eased(8, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence_eased(9, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence_eased(10, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence(6, 0.1, 0.0, 0.0, -1)
		event.rotate_object_sequence(7, 0.1, 0.0, 0.0, -1)
		event.rotate_object_sequence(8, 0.1, 0.0, 0.0, -1)
		event.rotate_object_sequence(9, 0.1, 0.0, 0.0, -1)
		event.rotate_object_sequence(10, 0.1, 0.0, 0.0, -1)
		step = 10
		wait.frames(70)
		event.set_character_active(1, 32)
		event.set_character_visible(32, 1, 1, 0.011111111)
		step = 11
		object.wait_until_done(0)
		event.set_camera_sequence_position(493.85, 133.35, -3161.95)
		event.set_camera_sequence_look_at(192.71, 140.7, -3161.9)
		frame_index = 0
		position_z = -2600.0
		velocity_z = -16.0
		acceleration_z = vm.f32(-0.6)
		while frame_index < 60 do
			event.set_object_sequence_position(0, 0.0, 70.0, position_z)
			event.set_object_sequence_position(15, 0.0, 70.0, position_z)
			position_z = vm.f32(position_z + velocity_z)
			velocity_z = vm.f32(velocity_z + acceleration_z)
			frame_index = frame_index + 1
			step = 12
			vm.wait(12)
		end
		step = 13
		object.wait_until_done(0)
		event.set_camera_sequence_position(-1162.38, 1222.12, -7192.96)
		event.set_camera_sequence_look_at(-630.41, 849.9, -6224.85)
		event.set_object_sequence_rotation(0, -0.209, 3.14, 0.0)
		event.set_object_sequence_rotation(15, -0.209, 3.14, 0.0)
		position_y = 460.0
		velocity_y = 12.5
		acceleration_y = 0.5
		position_z = -5500.0
		velocity_z = -62.5
		acceleration_z = -2.5
		frame_index = 0
		while frame_index < 20 do
			event.set_object_sequence_position(0, 0.0, position_y, position_z)
			event.set_object_sequence_position(15, 0.0, position_y, position_z)
			position_y = vm.f32(position_y + velocity_y)
			velocity_y = vm.f32(velocity_y + acceleration_y)
			position_z = vm.f32(position_z + velocity_z)
			velocity_z = vm.f32(velocity_z + acceleration_z)
			frame_index = frame_index + 1
			step = 14
			vm.wait(14)
		end
		event.set_camera_sequence_position(-563.64, 740.88, -4153.64)
		event.set_camera_sequence_look_at(-529.67, 727.31, -4239.53)
		event.move_camera_sequence_eased(-563.64, 740.88, -4153.64, -539.68, 756.14, -4327.6, 90, 2, 1.0)
		event.rotate_object_sequence_eased(0, -0.209, 2.8, 0.0, 120, 0, 0.4)
		event.set_character_active(0, 32)
		event.set_character_active(1, 33)
		event.set_object_sequence_rotation(16, -0.209, 3.14, 0.0)
		event.rotate_object_sequence_eased(16, -0.209, 2.8, 0.0, 120, 0, 0.4)
		event.set_object_sequence_motion(16, "ループ入り", 6)
		event.queue_object_sequence_next_motion(16, "ループ", 4)
		position_x = 0.0
		velocity_x = 0.0
		acceleration_x = vm.f32(0.6)
		position_y = 655.0
		velocity_y = 40.0
		acceleration_y = vm.f32(0.33333334)
		position_z = -6300.0
		velocity_z = -200.0
		acceleration_z = vm.f32(-1.6666666)
		frame_index = 0
		while frame_index < 110 do
			if frame_index == 30 then
				event.set_character_active(1, 34)
				event.set_character_visible(34, 1, 1, 0.016666668)
			end
			event.set_object_sequence_position(0, position_x, position_y, position_z)
			event.set_object_sequence_position(16, position_x, position_y + 80.0, position_z)
			position_x = vm.f32(position_x + velocity_x)
			velocity_x = vm.f32(velocity_x + acceleration_x)
			position_y = vm.f32(position_y + velocity_y)
			velocity_y = vm.f32(velocity_y + acceleration_y)
			position_z = vm.f32(position_z + velocity_z)
			velocity_z = vm.f32(velocity_z + acceleration_z)
			frame_index = frame_index + 1
			step = 15
			vm.wait(15)
		end
		event.fade_out_screen(10)
		step = 16
		wait.frames(10)
	end, function(received: { any }): boolean
		if step <= 1 then
			wait.frames_skipping(14)
		end
		if step <= 2 then
			wait.frames_skipping(66)
		end
		if step <= 3 then
			wait.background_load_skipping()
		end
		if step <= 4 then
			cutscene.skip_command(2)
		end
		if step <= 5 then
			wait.frames_skipping(40)
		end
		if step <= 6 then
			cutscene.skip_command(5)
		end
		if step <= 7 then
			wait.background_load_skipping()
		end
		if step <= 8 then
			wait.frames_skipping(30)
		end
		if step <= 9 then
			wait.frames_skipping(70)
		end
		if step <= 10 then
			cutscene.skip_command(0)
		end
		if step <= 11 then
			frame_index = 0
			position_z = -2600.0
			velocity_z = -16.0
			acceleration_z = vm.f32(-0.6)
			position_z = vm.f32(position_z + velocity_z)
			velocity_z = vm.f32(velocity_z + acceleration_z)
			local _ = frame_index < 60
			frame_index = frame_index + 1
		end
		if step <= 12 then
			cutscene.skip_command(0)
		end
		if step <= 13 then
			position_y = 460.0
			velocity_y = 12.5
			acceleration_y = 0.5
			position_z = -5500.0
			velocity_z = -62.5
			acceleration_z = -2.5
			frame_index = 0
			position_y = vm.f32(position_y + velocity_y)
			velocity_y = vm.f32(velocity_y + acceleration_y)
			position_z = vm.f32(position_z + velocity_z)
			velocity_z = vm.f32(velocity_z + acceleration_z)
			local _ = frame_index < 20
			frame_index = frame_index + 1
		end
		if step <= 14 then
			position_x = 0.0
			velocity_x = 0.0
			acceleration_x = vm.f32(0.6)
			position_y = 655.0
			velocity_y = 40.0
			acceleration_y = vm.f32(0.33333334)
			position_z = -6300.0
			velocity_z = -200.0
			acceleration_z = vm.f32(-1.6666666)
			frame_index = 0
			position_x = vm.f32(position_x + velocity_x)
			velocity_x = vm.f32(velocity_x + acceleration_x)
			position_y = vm.f32(position_y + velocity_y)
			velocity_y = vm.f32(velocity_y + acceleration_y)
			position_z = vm.f32(position_z + velocity_z)
			velocity_z = vm.f32(velocity_z + acceleration_z)
			local _ = frame_index < 110
			local _ = frame_index == 30
			frame_index = frame_index + 1
		end
		if step <= 15 then
			wait.frames_skipping(10)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 1)
	event.set_character_active(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
end

return luna_lab
