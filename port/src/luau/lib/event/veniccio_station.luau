--!strict
--- Holds the train-station cutscenes and setup shared by the Veniccio Station maps.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local train = vm.module("@lib/event/train")
local wait = vm.module("@lib/event/wait")

local veniccio_station = {}

--- Asks whether to leave the station and either runs the player out or steps them back into it.
function veniccio_station.confirm_leave_station()
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
		answer = message.ask_yes_no(5, 2)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if answer == 0 then
			event.set_camera_sequence_position(-1925.42, 97.53, -285.93)
			event.set_camera_sequence_look_at(-1921.75, 57.81, -472.01)
			event.set_object_sequence_position(0, -1910.95, 21.58, -466.12)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -1910.95, 21.58, -466.12)
			event.add_object_sequence_path_point(0, -1907.45, 17.42, -496.67)
			event.add_object_sequence_path_point(0, -1898.74, 13.2, -528.24)
			event.add_object_sequence_path_point(0, -1878.93, 9.61, -555.9)
			event.add_object_sequence_path_point(0, -1854.68, 5.12, -580.59)
			event.add_object_sequence_path_point(0, -1828.07, 1.46, -591.28)
			event.start_object_sequence_path(0)
			resume_step = 2
			wait.frames(30)
			event.fade_out_screen(30)
			resume_step = 3
			wait.frames(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			target_x = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + z)
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
		return 0
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				wait.frames_skipping(30)
			end
			if resume_step <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if resume_step <= 4 then
			return 0
		end
		return nil
	end)
end

--- Hides the parked train parts, swaps the building part when its flag is set and spawns the station villagers.
function veniccio_station.initialize_station()
	veniccio_station.swap_building_part()
	train.hide_train02_parts()
	veniccio_station.spawn_villagers()
end

--- Plays the opening cutscene of the party arriving by train and meeting the villagers.
function veniccio_station.play_first_arrival()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(400, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(4200) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e400/e400/")
		event.load_message_file(0, 5, "e400_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e400_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e400_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
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
			event.load_character_motion_pack(5, "event/e400/e400/e400_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e400/e400_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.set_villager_ai_enabled(0, 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(7, 8)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_villager_ai_enabled(0, 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(8, 9)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_villager_ai_enabled(0, 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(9, 10)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.attach_object_handle_to_map_part_2(2, "p01_train01")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m0")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train08-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m0")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m1")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.create_effect("列車煙")
		event.set_effect_value(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(7, 0)
		event.set_object_handle_texture_animation(7, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(7, 1, "通常目パチ")
		event.set_object_handle_position(0, -1494.0, 42.31, -35.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_position(1, -1478.0, 42.31, -35.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_position(7, -1485.0, 45.34, -9.42)
		event.set_object_handle_rotation(7, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(7, "立ち", 4)
		event.set_object_handle_position(2, -2312.1, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1481.05, 64.34, -282.56)
		event.set_camera_sequence_look_at(-1949.42, 59.22, -91.09)
		event.move_camera_sequence_eased(-1481.05, 64.34, -282.56, -1473.02, 59.22, -83.94, 80, 2, 1.0)
		event.move_object_sequence_eased(2, -912.1, 0.0, 0.0, 80, 2, 1.0)
		event.play_sound_effect(sound_bank, 4)
		event.play_sound_effect(sound_bank, 5)
		event.fade_in_screen(30)
		object.wait_until_done(2)
		wait.frames(20)
		event.play_sound_effect(sound_bank, 6)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(8)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		wait.frames(30)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -1493.51, 29.22, -100.0, 60)
		wait.frames(10)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -1478.51, 29.22, -90.0, 50)
		wait.frames(20)
		event.set_object_handle_footstep_sound(0, 3)
		wait.frames(10)
		event.set_object_handle_footstep_sound(1, 3)
		wait.frames(20)
		event.clear_effect_manager()
		event.set_camera_sequence_position(-1510.53, 52.11, -162.67)
		event.set_camera_sequence_look_at(-1480.38, 51.06, -136.4)
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.move_object_sequence(1, -1478.51, 29.22, -145.0, 50)
		event.set_object_sequence_motion(1, "潮歩き", 4)
		event.delay_object_sequence_motion_track(1, 50)
		event.set_object_sequence_motion(1, "潮立ち")
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4000010)
		object.wait_until_done(1)
		event.move_object_sequence(0, -1493.51, 29.22, -135.0, 50)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4000020)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "潮立ちから右", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4000030)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4000040)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4000050)
		event.set_camera_sequence_position(-1482.95, 61.09, -180.61)
		event.set_camera_sequence_look_at(-1483.79, 47.79, -128.26)
		event.set_object_sequence_position(7, -1483.61, 29.22, -91.35)
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_motion(1, "ふりかえり", 6)
		event.queue_object_sequence_next_motion(1, "ふりかえりＬ", 4)
		event.set_object_sequence_motion(0, "振り返り", 6)
		event.queue_object_sequence_next_motion(0, "振り返りL", 4)
		event.set_mouth_texture_animations(7, "口パク")
		message.show_voiced(4000060)
		event.set_camera_sequence_position(-1563.93, 73.34, -118.52)
		event.set_camera_sequence_look_at(-1483.1, 54.11, -118.91)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_position(9, -625.34, 29.22, -99.11)
		event.set_character_position(10, -627.43, 29.22, -126.82)
		event.set_object_sequence_position(7, -1489.0, 29.22, -98.62)
		event.set_object_sequence_rotation(7, 0.0, 1.58, 0.0)
		event.set_object_sequence_position(0, -1496.36, 29.22, -129.63)
		event.set_object_sequence_rotation(0, 0.0, 1.46, 0.0)
		event.set_object_sequence_motion(0, "立ち", 6, -1.0, 1)
		event.set_object_sequence_position(1, -1478.51, 29.22, -145.0)
		event.set_object_sequence_rotation(1, 0.0, 0.98, 0.0)
		event.set_object_sequence_motion(1, "立ち", 6, -1.0, 1)
		message.show_voiced(4000070)
		event.set_object_sequence_motion(1, "手振り", 6)
		event.queue_object_sequence_next_motion(1, "手振りＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4000080)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-1522.27, 54.57, -147.64)
		event.set_camera_sequence_look_at(-1483.82, 49.34, -134.4)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 8)
		event.set_object_sequence_rotation(0, 0.0, 1.82, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(1, "手振りから左", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4000085)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		wait.frames(6)
		event.play_sound_effect(sound_bank, 8)
		object.wait_until_done(0)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(24)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.stop_sound_effect(sound_bank, 4)
	event.stop_sound_effect(sound_bank, 5)
	event.set_object_handle_position(2, -912.1, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	event.set_character_active(8)
	event.set_character_position(8, -2030.0, 30.0, -100.0)
	event.set_character_rotation(8, 0.0, 3.14, 0.0)
	event.set_villager_ai_enabled(1, 8)
	event.set_character_active(9)
	event.set_character_position(9, -1098.0, 29.2, -100.0)
	event.set_character_rotation(9, 0.0, -1.57, 0.0)
	event.set_villager_ai_enabled(1, 9)
	event.set_character_active(10)
	event.set_character_position(10, -707.6, -10.0, -172.5)
	event.set_character_rotation(10, 0.0, 0.0, 0.0)
	event.set_villager_ai_enabled(1, 10)
	event.set_character_active(0)
	event.set_character_position(0, -1880.1, 29.2, -299.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the cutscene where the party talks with Starbre before departing.
function veniccio_station.play_starbre_send_off()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(452, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4223)
		sound_bank = event.load_sound_effect_file_2(4223) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.load_message_file(0, 5, "event/e400/e452/e452_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "event/e400/e452/e452_mints.chr", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "event/e400/e452/e452_monica.chr", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "event/e200/e283/e283_starbre.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e452/e452_mints.chr", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e452/e452_monica.chr", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_object_handle_position(0, -1960.0, 29.22, -120.0)
		event.set_object_handle_rotation(0, 0.0, -0.7853982, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_position(1, -2000.0, 29.22, -120.0)
		event.set_object_handle_rotation(1, 0.0, 0.7853982, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_position(2, -1980.0, 29.22, -100.0)
		event.set_object_handle_rotation(2, 0.0, 3.1415927, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1980.0, 51.24, -291.47)
		event.set_camera_sequence_look_at(-1980.0, 91.37, -49.52)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(34)
		event.fade_in_screen(30)
		wait.frames(45)
		event.set_object_sequence_motion(2, "出発進行", 6)
		event.queue_object_sequence_next_motion(2, "出発進行L", 4)
		event.play_sound_effect(sound_bank, 0)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(4520010)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the cutscene of the steam train pulling in and the player stepping out.
function veniccio_station.play_steam_train_arrival()
	local save_flag: s32 = 0
	local sound_bank: s32 = 0
	local common_sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		save_flag = event.get_save_flag(448) or save_flag
		event.set_character_active(0, 8)
		if save_flag == 0 then
			event.set_character_active(0, 9)
			event.set_character_active(0, 10)
		end
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or sound_bank
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, -1512.1, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 1.57, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.attach_object_handle_to_map_part_2(6, "p01_shadow")
		event.set_object_handle_visible(6, 0)
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m0")
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m1")
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m0")
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m1")
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(8, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 8)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_handle_footstep_sound(0, 6)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-363.94, 121.88, -75.09)
		event.set_camera_sequence_look_at(-643.14, 118.87, -58.01)
		event.fade_in_screen(30)
		event.move_object_sequence_eased(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
		object.wait_until_done(1)
		wait.frames(10)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1664.28, 105.75, -222.05)
		event.set_camera_sequence_look_at(-1452.28, 75.37, -85.42)
		common_sound_bank = event.get_sound_id(2) or common_sound_bank
		event.play_sound_effect(common_sound_bank, 66)
		event.set_object_handle_position(1, -912.1, 0.0, 0.0)
		event.set_character_active(0)
		event.set_object_sequence_position(0, -1460.3, 33.0, -45.39)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		wait.frames(15)
		event.move_object_sequence(0, -1460.3, 29.22, -123.59, 30)
		event.set_object_sequence_motion(0, "走り", 4)
		wait.frames(10)
		event.set_object_handle_footstep_sound(0, 3)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		wait.frames(10)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.clear_effect_manager()
	event.fade_in_screen(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_object_handle_visible(6, 1)
	event.set_character_active(0)
	event.set_character_position(0, -1460.3, 29.22, -123.59)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_character_active(1, 8)
	if save_flag == 0 then
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
	end
	event.reset_follow_camera(1, 3.14, 10.0)
end

--- Plays the cutscene of the steam train pulling out of the station, optionally fading out the music.
function veniccio_station.play_steam_train_departure(should_fade_music: s32)
	local sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.fade_out_screen(30)
		wait.frames(30)
		event.load_map_sounds(4223)
		sound_bank = event.load_sound_effect_file_2(4223) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -912.1, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 1.5707964, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.load_character(5, "event/train/steam/steam_l.gltf", "info", 11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, -120.0, 0.0, -1690.0)
		event.load_character(5, "event/train/steam/steam_r.gltf", "info", 12)
		event.attach_object_handle_to_character(3, 12)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, -120.0, 0.0, -1690.0)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.create_effect("列車煙")
		event.set_effect_value(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p01_shadow")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-480.06, 58.66, -117.78)
		event.set_camera_sequence_look_at(-569.61, 64.12, -98.79)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_bank, 1)
		event.set_character_active(11)
		event.set_object_sequence_position(2, -874.19, 10.0, 30.0)
		event.set_object_sequence_rotation(2, 0.0, 1.5707964, 0.0)
		event.set_object_sequence_motion(2, "ぶしゅー", 6)
		event.set_character_active(12)
		event.set_object_sequence_position(3, -874.19, 10.0, 30.0)
		event.set_object_sequence_rotation(3, 0.0, 1.5707964, 0.0)
		event.set_object_sequence_motion(3, "ぶしゅー", 6)
		wait.frames(60)
		event.move_object_sequence_eased(0, 4000.0, 0.0, 0.0, 180, 1, 1.0)
		event.move_object_sequence_eased(1, 4500.0, 0.0, 0.0, 180, 1, 1.0)
		event.play_sound_effect(sound_bank, 2)
		object.wait_until_done(0)
		if should_fade_music ~= 0 then
			event.fade_out_music(30)
		end
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(6)
	event.cancel_drama_scene_skip()
	if should_fade_music ~= 0 then
		event.stop_music(0)
	end
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.delete_character(11)
	event.delete_character(12)
	event.clear_effect_manager()
	event.set_character_active(0)
end

--- Plays the cutscene of the train pulling in and the player stepping out.
function veniccio_station.play_train_arrival()
	local sound_bank: s32 = 0
	local save_flag: s32 = 0
	local common_sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or sound_bank
	save_flag = event.get_save_flag(448) or save_flag
	event.set_character_active(0, 8)
	if save_flag == 0 then
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
	end
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_2(4, "p01_shadow")
	event.set_object_handle_visible(4, 0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m1")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(1, -1512.1, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 1.57, 0.0)
	event.move_object_sequence_eased(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-363.94, 121.88, -75.09)
	event.set_camera_sequence_look_at(-643.14, 118.87, -58.01)
	event.fade_in_screen(30)
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(1)
	wait.frames(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-1664.28, 105.75, -222.05)
	event.set_camera_sequence_look_at(-1452.28, 75.37, -85.42)
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -1460.3, 33.0, -45.39)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	common_sound_bank = event.get_sound_id(2) or common_sound_bank
	event.play_sound_effect(common_sound_bank, 92)
	wait.frames(15)
	event.move_object_sequence(0, -1460.3, 29.22, -123.59, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 3)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, -912.1, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(4, 1)
	event.set_character_active(1, 8)
	if save_flag == 0 then
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
	end
	event.set_character_active(0)
	event.set_character_position(0, -1460.3, 29.22, -123.59)
	event.set_character_rotation(0, 0.0, -1.57, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(15)
end

--- Runs the player in from the station entrance while the camera looks at them.
function veniccio_station.run_into_station()
	local character_x: f32 = 0
	local look_at_y: f32 = 0
	local character_z: f32 = 0
	local i: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_footstep_sound(0, 3)
	event.set_character_position(0, -1918.94, 29.4, -453.91)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "走り", 4)
	event.set_camera_position(-2033.1, 114.91, -255.29)
	event.fade_in_screen(30)
	event.move_object_sequence(0, -1918.94, 29.22, -379.73, 30)
	i = 0
	while i < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			look_at_y = out2 or look_at_y
			character_z = out3 or character_z
		end
		look_at_y = vm.f32(look_at_y + 30.0)
		event.set_camera_look_at(character_x, look_at_y, character_z)
		i = i + 1
		vm.wait(1)
	end
end

--- Runs a prompt window for the event maps and returns 1 when done.
function veniccio_station.run_prompt_event_map()
	local window: s32 = 0
	local prompt_value: f32 = 0
	local prompt_count: s32 = 0
	message.set_window_mode_stub(0, 1)
	prompt_value = character.interpolate_path(window, 0, 0)
	message.show_then_close(0, -1, window, prompt_count, 0)
	local _ = message.ask_choice_skipping(0, -1, 5, 256, 208, 2, 0)
	message.show_then_close(0, -1, window, prompt_count, 0)
	character.restore_facing_skipping(window, prompt_value, 0, 0)
	return 1
end

--- Runs a prompt window for the station map and returns 1 when done.
function veniccio_station.run_prompt_main_map()
	local window: s32 = 0
	local prompt_value: f32 = 0
	local prompt_count: s32 = 0
	message.set_window_mode_skipping(0, 1)
	prompt_value = character.interpolate_path(window, 0, 0)
	message.show_then_close_variant(0, -1, window, prompt_count, 0)
	local _ = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 0)
	message.show_then_close_variant(0, -1, window, prompt_count, 0)
	character.restore_facing_skipping(window, prompt_value, 0, 0)
	return 1
end

--- Spawns the station villagers, using a different first villager in chapters 6 and 7 and two more while save flag 500 is clear.
function veniccio_station.spawn_villagers()
	local chapter: s32 = 0
	local save_flag: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	chapter = event.get_chapter() or chapter
	if chapter ~= 6 and chapter ~= 7 then
		event.load_character(4, "chara/p01_03a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, -2030.0, 30.0, -100.0)
		event.set_character_rotation(8, 0.0, 3.14, 0.0)
		event.set_scene_character_number(8, 1)
		event.register_villager(8, 1)
	else
		event.load_character(4, "chara/p00_31a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, -2030.0, 30.0, -100.0)
		event.set_character_rotation(8, 0.0, 3.14, 0.0)
		event.set_scene_character_number(8, 301)
		event.register_villager(8, 301)
	end
	save_flag = event.get_save_flag(500) or save_flag
	if save_flag == 0 then
		event.load_character(4, "chara/p01_06a.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, -1045.1, 29.2, -103.3)
		event.set_character_rotation(9, 0.0, 3.1415927, 0.0)
		event.set_scene_character_number(9, 2)
		event.register_villager(9, 2)
		event.load_character(4, "chara/p01_07a.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_position(10, -707.6, -10.0, -172.5)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		event.set_scene_character_number(10, 13)
		event.register_villager(10, 13)
	end
end

--- Replaces the p06_s0901 map part with p07_s0901 once save flag 448 is set.
function veniccio_station.swap_building_part()
	local save_flag: s32 = 0
	save_flag = event.get_save_flag(448) or save_flag
	if save_flag == 1 then
		event.attach_object_handle_to_map_part_2(1, "p06_s0901")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p07_s0901")
		event.set_object_handle_visible(1, 1)
	end
end

return veniccio_station
