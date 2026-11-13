--!strict
--- Event helpers for the Sindain Station map: train arrival and departure scenes, villagers and exits.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local train = vm.module("@lib/event/train")
local wait = vm.module("@lib/event/wait")

local sindain_station = {}

--- Asks whether to leave through the dungeon exit, then runs the player out and fades out, or steps the player back; returns 1 when leaving.
function sindain_station.confirm_exit_to_dungeon()
	local choice: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local angle: f32 = 0
	local loop_index: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		checkpoint = 1
		choice = message.ask_yes_no(5, 57)
		if choice == 0 then
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, -836.17, 0.0, -823.5)
			event.set_object_sequence_rotation(0, 0.0, -1.66, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-668.11, 97.09, -886.72)
			event.set_camera_sequence_look_at(-839.94, 44.81, -838.79)
			event.move_object_sequence(0, -1044.71, 0.0, -836.63, 60)
			event.move_camera_sequence(-668.11, 97.09, -886.72, -881.32, 61.14, -861.93, 60)
			checkpoint = 2
			wait.frames(30)
			event.fade_out_screen(30)
			checkpoint = 3
			wait.frames(30)
			return 1
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "歩き", 4)
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = event.get_character_rotation(0)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		angle = vm.f32(vm.f32(3.1415927) + rotation_y)
		angle = event.wrap_angle(angle) or angle
		angle = vm.f32(1.5707964)
		x = vm.f32(x + vm.f32(30.0 * vm.sin(angle)))
		z = vm.f32(z + vm.f32(30.0 * vm.cos(angle)))
		event.rotate_object_sequence(0, rotation_x, angle, rotation_z, 15)
		event.move_object_sequence(0, x, y, z, 45)
		for i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			event.set_camera_sequence_look_at(x, y + 30.0, z)
			checkpoint = 4
			vm.wait(4)
		end
		return 0
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint == 1 then
				choice = received[1] :: number
			end
			if checkpoint <= 1 then
				wait.frames_skipping(30)
			end
			if checkpoint <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if checkpoint <= 4 then
			local _ = loop_index < 45
			loop_index = loop_index + 1
			return 0
		end
		return nil
	end)
end

--- Asks whether to leave through the exit, then runs the player out and fades out, or steps the player back; returns 1 when leaving.
function sindain_station.confirm_exit_to_map()
	local choice: any = 0
	local flag_207: s32 = 0
	local flag_208: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local loop_index: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_motion(0, "立ち", 4)
		checkpoint = 1
		choice = message.ask_yes_no(5, 0)
		if choice == 0 then
			event.set_object_sequence_position(0, -936.47, 0.0, -23.84)
			event.set_object_sequence_rotation(0, 0.0, -1.65, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-751.82, 79.08, -27.15)
			event.set_camera_sequence_look_at(-928.2, 36.53, -26.64)
			flag_207 = event.get_save_flag(207) or flag_207
			flag_208 = event.get_save_flag(208) or flag_208
			if flag_207 == 1 and flag_208 == 0 then
				event.skip_next_music_load()
			end
			event.move_object_sequence(0, -1142.09, 0.0, -28.24, 60)
			event.move_camera_sequence(-751.82, 79.08, -27.15, -921.16, 65.58, -20.12, 60)
			checkpoint = 2
			wait.frames(30)
			event.fade_out_screen(30)
			checkpoint = 3
			wait.frames(30)
			return 1
		end
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		x = vm.f32(x + vm.f32(30.0 * vm.sin(vm.f32(1.57))))
		z = vm.f32(z + vm.f32(30.0 * vm.cos(vm.f32(1.57))))
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, 1.57, 0.0, 15)
		event.move_object_sequence(0, x, y, z, 45)
		for i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			event.set_camera_sequence_look_at(x, y + 30.0, z)
			checkpoint = 4
			vm.wait(4)
		end
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint == 1 then
				choice = received[1] :: number
			end
			if checkpoint <= 1 then
				wait.frames_skipping(30)
			end
			if checkpoint <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if checkpoint <= 4 then
			local _ = loop_index < 45
			loop_index = loop_index + 1
			return 0
		end
		return nil
	end)
end

--- Hides a station map part once its story flag is set.
function sindain_station.hide_station_part_after_event()
	local flag_209: s32 = 0
	event.initialize_event()
	flag_209 = event.get_save_flag(209) or flag_209
	if flag_209 == 1 then
		event.attach_object_handle_to_map_part_2(0, "p09_s0201")
		event.set_object_handle_visible(0, 0)
	end
end

--- Attaches the station building parts to object handles and makes them invisible.
function sindain_station.hide_station_parts()
	event.attach_object_handle_to_map_part_3(0, "p01_s0201", "s0208-m0")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(1, "p01_s0201", "s0208-m1")
	event.set_object_handle_visible(1, 0)
	event.attach_object_handle_to_map_part_3(2, "p01_s0201", "s0208-m2")
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_map_part_3(3, "p01_s0201", "s0208-m3")
	event.set_object_handle_visible(3, 0)
	event.attach_object_handle_to_map_part_3(4, "p01_s0201", "s0213-m0")
	event.set_object_handle_visible(4, 0)
end

--- Deactivates the three station villager characters.
function sindain_station.hide_villagers()
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
end

--- Sets up the station map by hiding parts, spawning villagers and applying story flags.
function sindain_station.initialize_map()
	local flag_280: s32 = 0
	print("map_init-------------------------\n")
	flag_280 = event.get_save_flag(280) or flag_280
	if flag_280 ~= 0 then
		sindain_station.hide_station_parts()
	end
	train.tilt_cars()
	sindain_station.hide_station_part_after_event()
	sindain_station.spawn_villagers()
end

--- Loads the e207 image pack and attaches its four full-screen sprites to sequence objects.
function sindain_station.load_cutscene_sprites_e207()
	local image_block: s32 = 0
	image_block = event.load_event_image_4(5, "textures/event/e200/e207/e207.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e20701", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e20702", image_block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(21, 1)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "e20703", image_block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 416)
	event.set_event_sprite_size(2, 512, 416)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(22, 2)
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "e20704", image_block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416)
	event.set_event_sprite_size(3, 512, 416)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(23, 3)
	event.clear_object_sequence(23)
	event.set_object_sequence_object(23, 23)
end

--- Loads the e207_1 image pack and attaches its four full-screen sprites to sequence objects.
function sindain_station.load_cutscene_sprites_e207_1()
	local image_block: s32 = 0
	image_block = event.load_event_image_4(5, "textures/event/e200/e207/e207_1.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e20701", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e20702", image_block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(21, 1)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "e20703", image_block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 416)
	event.set_event_sprite_size(2, 512, 416)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(22, 2)
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "e20704", image_block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416)
	event.set_event_sprite_size(3, 512, 416)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(23, 3)
	event.clear_object_sequence(23)
	event.set_object_sequence_object(23, 23)
end

--- Loads the characters, train and station parts and message file used by the event 280 cutscene.
function sindain_station.load_event_280_scene()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.change_directory("event/e200/e207/")
	event.load_character(5, "e207_starbre.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(1, 34)
	event.load_character(5, "e207_vorneo.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(1, 35)
	event.attach_object_handle_to_map_part_2(5, "p01_train01")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.change_directory("")
	event.load_character(5, "event/e200/e280/e280_tom.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(1, 36)
	event.attach_object_handle_to_map_part_3(6, "p01_s0201", "s0208-m0")
	event.set_object_handle_visible(6, 0)
	event.attach_object_handle_to_map_part_3(7, "p01_s0201", "s0208-m1")
	event.set_object_handle_visible(7, 0)
	event.attach_object_handle_to_map_part_3(8, "p01_s0201", "s0208-m2")
	event.set_object_handle_visible(8, 0)
	event.attach_object_handle_to_map_part_3(9, "p01_s0201", "s0208-m3")
	event.set_object_handle_visible(9, 0)
	event.attach_object_handle_to_map_part_3(10, "p01_s0201", "s0213-m0")
	event.set_object_handle_visible(10, 0)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.load_message_file(0, 5, "event/e200/e280/e280c.txt")
end

--- Loads the event 280 characters, parts and the alternate message file for the night cutscene.
function sindain_station.load_event_280_scene_alt()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.change_directory("event/e200/e207/")
	event.load_character(5, "e207_starbre.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(1, 34)
	event.load_character(5, "e207_vorneo.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(1, 35)
	event.attach_object_handle_to_map_part_2(5, "p01_train01")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.change_directory("")
	event.load_character(5, "event/e200/e280/e280_tom.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(1, 36)
	event.attach_object_handle_to_map_part_3(6, "p01_s0201", "s0208-m0")
	event.set_object_handle_visible(6, 0)
	event.attach_object_handle_to_map_part_3(7, "p01_s0201", "s0208-m1")
	event.set_object_handle_visible(7, 0)
	event.attach_object_handle_to_map_part_3(8, "p01_s0201", "s0208-m2")
	event.set_object_handle_visible(8, 0)
	event.attach_object_handle_to_map_part_3(9, "p01_s0201", "s0208-m3")
	event.set_object_handle_visible(9, 0)
	event.attach_object_handle_to_map_part_3(10, "p01_s0201", "s0213-m0")
	event.set_object_handle_visible(10, 0)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.load_message_file(0, 5, "event/e200/e280/e280c_1.txt")
end

--- Prints a debug message noting that slope handling is off.
function sindain_station.log_slope_off()
	print("slope-------------------off\t\n")
	cutscene.noop()
end

--- Plays the cutscene of Starbre announcing the departure with the playable character and partner on the platform.
function sindain_station.play_departure_announcement()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(283, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(2237)
		sound_bank = event.load_sound_effect_file_2(2237) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.change_directory("event/e200/e283/")
		event.load_message_file(0, 5, "e283_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e283_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e283_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e283_starbre.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e200/e283/e283_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e200/e283/e283_monica.gltf", "info", 32)
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
		event.set_object_handle_position(0, -160.79, 0.0, -340.48)
		event.set_object_handle_rotation(0, 0.0, 2.9, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_position(1, -187.76, 0.0, -348.73)
		event.set_object_handle_rotation(1, 0.0, 2.18, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_handle_position(2, -143.76, 0.0, -369.25)
		event.set_object_handle_rotation(2, 0.0, -1.46, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-254.7, 9.64, -441.04)
		event.set_camera_sequence_look_at(-145.97, 41.38, -347.02)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(34)
		event.fade_in_screen(30)
		event.stop_music(0)
		wait.frames(45)
		event.set_object_sequence_motion(2, "出発進行", 6)
		event.queue_object_sequence_next_motion(2, "出発進行L", 4)
		event.play_sound_effect(sound_bank, 2)
		message.show_voiced(2830010)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, 2290.27, 0.0, 1646.13)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Plays the night cutscene at the station with Starbre, Vorneo and Tom before restoring the time of day.
function sindain_station.play_event_280_cutscene()
	local time_of_day: f32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(280, 1)
		event.initialize_event()
		sindain_station.load_event_280_scene_alt()
		event.enable_drama_skip()
		time_of_day = event.get_scene_time_of_day() or time_of_day
		if time_of_day > 23.0 or time_of_day < 3.0 then
			event.set_time_of_day(23.5)
		end
		event.set_character_active(0, 0)
		event.set_camera_sequence_position(-345.15, 101.35, 500.91)
		event.set_camera_sequence_look_at(-187.77, 66.45, 754.48)
		event.set_object_sequence_position(5, 1.3, 8.0, 700.0)
		event.set_object_sequence_position(2, -211.51, 0.0, 580.92)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(3, -179.62, 0.0, 849.1)
		event.set_object_sequence_rotation(3, 0.0, -3.04, 0.0)
		event.set_object_sequence_position(4, -127.36, 0.0, 848.26)
		event.set_object_sequence_rotation(4, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(2, "歩き", 0)
		event.set_object_sequence_motion(3, "会話2", 0)
		event.set_object_sequence_motion(4, "喜び", 0)
		event.start_crossfade(30)
		event.move_object_sequence(2, -178.31, 0.0, 745.86, 240, 1)
		message.show_voiced_for(2800410, 210)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "立ち")
		event.set_camera_speed(0)
		event.move_camera_sequence_eased(-345.15, 101.35, 500.91, -393.5, 319.63, 632.81, 240, 0, 0.4)
		message.show_voiced_for(2800420, -1)
		camera.wait_until_done()
		wait.frames(60)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	sindain_station.restore_after_event_280()
	event.set_time_of_day(time_of_day)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Plays the night cutscene at the station using the alternate wait and message helpers.
function sindain_station.play_event_280_cutscene_alt()
	local time_of_day: f32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(280, 1)
		event.initialize_event()
		sindain_station.load_event_280_scene()
		event.enable_drama_skip()
		time_of_day = event.get_scene_time_of_day() or time_of_day
		if time_of_day > 23.0 or time_of_day < 3.0 then
			event.set_time_of_day(23.5)
		end
		event.set_character_active(0, 0)
		event.set_camera_sequence_position(-345.15, 101.35, 500.91)
		event.set_camera_sequence_look_at(-187.77, 66.45, 754.48)
		event.set_object_sequence_position(5, 1.3, 8.0, 700.0)
		event.set_object_sequence_position(2, -211.51, 0.0, 580.92)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(3, -179.62, 0.0, 849.1)
		event.set_object_sequence_rotation(3, 0.0, -3.04, 0.0)
		event.set_object_sequence_position(4, -127.36, 0.0, 848.26)
		event.set_object_sequence_rotation(4, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(2, "歩き", 0)
		event.set_object_sequence_motion(3, "会話2", 0)
		event.set_object_sequence_motion(4, "喜び", 0)
		event.start_crossfade(30)
		event.move_object_sequence(2, -178.31, 0.0, 745.86, 240, 1)
		message.show_voiced_for_stopping(2800410, -1)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "立ち")
		event.set_camera_speed(0)
		event.move_camera_sequence_eased(-345.15, 101.35, 500.91, -393.5, 319.63, 632.81, 240, 0, 0.4)
		message.show_voiced_for_stopping(2800420, -1)
		camera.wait_until_done()
		wait.for_frame_count(60)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	sindain_station.restore_after_event_280()
	event.set_time_of_day(time_of_day)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Plays the skippable cutscene of the train arriving at the station and the player stepping off.
function sindain_station.play_train_arrival_cutscene()
	local flag_30: s32 = 0
	local time_of_day: f32 = 0
	local sound_bank: s32 = 0
	local train_sound: s32 = 0
	local checkpoint: number = 0
	vm.section(function()
		checkpoint = 1
		vm.entry(1)
		event.initialize_event()
		event.set_save_flag(30, 0)
		checkpoint = 2
		train.level_cars()
		sindain_station.hide_villagers()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or sound_bank
		event.play_sound_effect(sound_bank, 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 6)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_active(0, 0)
		time_of_day = event.get_scene_time_of_day() or time_of_day
		if time_of_day > 0.0 and time_of_day < 5.5 then
			event.set_object_handle_shadow_enabled(0, 0)
		end
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 1.3, 8.0, 500.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_2(9, "p01_shadow-0")
		event.set_object_handle_visible(9, 0)
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m6")
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m7")
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m18")
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m19")
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m6")
		event.set_object_sequence_object(6, 6)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "train10-m7")
		event.set_object_sequence_object(7, 7)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(8, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 8)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-185.19, 68.62, 1049.53)
		event.set_camera_sequence_look_at(140.3, 63.52, 109.43)
		event.fade_in_screen(30)
		event.enable_drama_skip()
		event.move_object_sequence_eased(1, 1.3, 8.0, 700.0, 40, 2, 1.0)
		checkpoint = 3
		object.wait_until_done(1)
		checkpoint = 4
		wait.frames(10)
		event.start_crossfade(30)
		event.set_object_handle_position(1, 1.3, 8.0, 700.0)
		train.tilt_cars()
		event.set_save_flag(30, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_camera_sequence_position(-254.85, 60.24, -455.84)
		event.set_camera_sequence_look_at(-89.19, 67.53, -382.63)
		event.set_character_active(1, 0)
		event.set_object_sequence_position(0, -40.0, 45.6, -366.0)
		event.set_object_sequence_rotation(0, 0.0, -1.56, 0.0)
		checkpoint = 5
		wait.frames(15)
		train_sound = event.get_sound_id(2) or train_sound
		event.play_sound_effect(train_sound, 106)
		event.rotate_object_sequence(2, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(7, 0.0, 1.5, 0.0, 30)
		checkpoint = 6
		wait.frames(15)
		event.set_object_sequence_motion(0, "走り", 0, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -68.89, 43.64, -366.0, 10)
		event.move_object_sequence(0, -131.89, 0.0, -366.0, 30)
		checkpoint = 7
		wait.frames(40)
		event.fade_out_screen(10)
		checkpoint = 8
		wait.frames(10)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			sindain_station.log_slope_off()
		end
		if checkpoint <= 2 then
			cutscene.noop()
			cutscene.skip_command(1)
		end
		if checkpoint <= 3 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 4 then
			sindain_station.skip_crossfade_step()
			wait.frames_skipping(15)
		end
		if checkpoint <= 5 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 6 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 7 then
			wait.frames_skipping(10)
		end
		return true
	end)
	checkpoint = 9
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.clear_camera_sequence()
	event.stop_sound_effect(sound_bank, 0)
	event.clear_effect_manager()
	event.set_object_handle_position(1, 1.3, 8.0, 700.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(9, 1)
	event.set_character_active(1, 0)
	character.place_standing_and_reset_cloth(-130.0, 0.0, -366.0, vm.f32(-1.57))
	event.set_camera_look_at(-130.0, 30.0, -366.0)
	event.set_camera_position(-270.0, 40.0, -366.0)
	flag_30 = event.get_save_flag(30) or flag_30
	if flag_30 == 0 then
		train.tilt_cars()
	end
	sindain_station.show_villagers()
	event.fade_in_screen(15)
end

--- Plays the short train arrival cutscene and places the player on the platform.
function sindain_station.play_train_arrival_quick()
	local sound_bank: s32 = 0
	local time_of_day: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local train_sound: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_019.sound.json") or sound_bank
	sindain_station.hide_villagers()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	time_of_day = event.get_scene_time_of_day() or time_of_day
	if time_of_day > 0.0 and time_of_day < 5.5 then
		event.set_object_handle_shadow_enabled(0, 0)
	end
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 1.3, 8.0, 500.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_2(6, "p01_shadow-0")
	event.set_object_handle_visible(6, 0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m4")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m2")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_16-m2")
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_17-m3")
	do
		local out1, out2, out3 = event.get_object_handle_position(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-185.19, 68.62, 1049.53)
	event.set_camera_sequence_look_at(140.3, 63.52, 109.43)
	event.fade_in_screen(30)
	event.move_object_sequence_eased(1, 1.3, 8.0, 700.0, 40, 2, 1.0)
	event.play_sound_effect(sound_bank, 0)
	object.wait_until_done(1)
	wait.frames(10)
	event.start_crossfade(30)
	event.set_camera_sequence_position(-254.85, 60.24, -455.84)
	event.set_camera_sequence_look_at(-89.19, 67.53, -382.63)
	event.set_object_handle_position(1, 1.3, 8.0, 700.0)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -20.0, 40.0, -365.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, -1.5707964, 30)
	event.rotate_object_sequence(4, 0.0, 0.0, 0.3926991, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, 0.3926991, 30)
	train_sound = event.get_sound_id(2) or train_sound
	event.play_sound_effect(train_sound, 92)
	wait.frames(30)
	event.move_object_sequence(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	wait.frames(20)
	event.move_object_sequence(0, -130.0, 0.0, -365.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	object.wait_until_done(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, 1.3, 8.0, 700.0)
	event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_position(5, pos_x, pos_y, pos_z)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(6, 1)
	event.set_character_active(0)
	character.place_standing_and_reset_cloth(-130.0, 0.0, -365.0, vm.f32(-1.57))
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_camera_look_at(-130.0, 30.0, -366.0)
	event.set_camera_position(-270.0, 40.0, -366.0)
	sindain_station.show_villagers()
	event.fade_in_screen(15)
end

--- Plays the train arriving with sparks and steam hissing from its brakes.
function sindain_station.play_train_braking_sequence(sound_effect_id: s32)
	event.change_directory("event/e500/e500/")
	event.load_character(5, "steam_slow_l.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(19, 39)
	event.clear_object_sequence(19)
	event.set_object_sequence_object(19, 19)
	event.set_object_sequence_position(19, -120.0, 0.0, -1690.0)
	event.load_character(5, "steam_slow_r.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(20, 40)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.set_object_sequence_position(20, -120.0, 0.0, -1690.0)
	event.load_character(5, "train_hibana.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(21, 41)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	event.copy_character(5, 41, 42)
	event.set_character_active(0, 42)
	event.attach_object_handle_to_character(22, 42)
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.change_directory("")
	event.attach_object_handle_to_map_part_2(7, "p01_train01")
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.attach_object_handle_to_map_part_3(8, "p01_train01", "train08-m0")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_3(9, "p01_train01", "train08-m1")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_3(10, "p01_train01", "train10-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.attach_object_handle_to_map_part_3(11, "p01_train01", "train10-m1")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.attach_object_handle_to_map_part_3(12, "p01_train01", "train07-m3")
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.attach_object_handle_to_map_part_3(13, "p01_train01", "train07-m4")
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.attach_object_handle_to_map_part_3(14, "p01_train01", "train07-m5")
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	event.attach_object_handle_to_map_part_3(15, "p01_train01", "train05-m17")
	event.clear_object_sequence(15)
	event.set_object_sequence_object(15, 15)
	event.attach_object_handle_to_map_part_3(16, "p01_train01", "train05-m16")
	event.clear_object_sequence(16)
	event.set_object_sequence_object(16, 16)
	event.attach_object_handle_to_map_part_3(17, "p01_train01", "train06-m1")
	event.clear_object_sequence(17)
	event.set_object_sequence_object(17, 17)
	event.attach_object_handle_to_map_part_3(18, "p01_train01", "train06-m0")
	event.clear_object_sequence(18)
	event.set_object_sequence_object(18, 18)
	event.set_object_handle_position(7, 1.3, 8.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(8, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(10, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(11, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(15, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(16, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(17, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(18, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(12, 0)
	event.set_object_handle_visible(13, 0)
	event.set_object_handle_visible(14, 0)
	event.set_object_handle_position(19, 1.3, 8.0, 0.0)
	event.set_object_handle_position(20, 1.3, 8.0, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-517.4, 241.51, -79.15)
	event.set_camera_sequence_look_at(-261.58, 188.2, 229.96)
	event.set_object_sequence_position(19, -21.58, 30.57, -7.66)
	event.set_object_sequence_rotation(19, 0.0, 5.5815926, 0.0)
	event.set_object_sequence_position(20, 9.76, 21.970001, 2.36)
	event.set_object_sequence_rotation(20, 0.0, 5.5815926, 0.0)
	event.set_object_sequence_rotation(21, 0.0, 5.5815926, 0.0)
	event.set_object_sequence_position(21, 9.76, 21.970001, 2.36)
	event.set_object_sequence_rotation(21, 0.0, 5.5815926, 0.0)
	event.set_object_sequence_position(22, 9.76, 21.970001, 2.36)
	event.set_object_sequence_rotation(22, 0.0, 5.341593, 0.0)
	event.move_object_sequence_eased(7, 1.3, 8.0, 700.0, 90, 2, 1.0)
	event.call_command(488, 19, -21.58, 30.57, 707.66, 2, 1.0) -- retail: the handler rejects 6 arguments
	event.move_object_sequence_eased(20, 9.76, 21.970001, 702.36, 90, 2, 1.0)
	event.move_object_sequence_eased(21, -25.34, 18.05, 631.96, 90, 2, 1.0)
	event.move_object_sequence_eased(22, -71.6, 18.05, 719.36, 90, 2, 1.0)
	event.delay_object_sequence_rotation_track(15, 70)
	event.rotate_object_sequence_eased(15, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.delay_object_sequence_rotation_track(16, 70)
	event.rotate_object_sequence_eased(16, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.delay_object_sequence_rotation_track(17, 70)
	event.rotate_object_sequence_eased(17, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.delay_object_sequence_rotation_track(18, 70)
	event.rotate_object_sequence_eased(18, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.initialize_effect_manager(5)
	event.load_effect_base("列車煙")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(7, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 7)
	event.fade_in_screen(30)
	event.play_sound_effect(sound_effect_id, 8)
	wait.frames(90)
	event.set_object_handle_visible(21, 1)
	event.set_object_handle_visible(22, 1)
	event.set_character_active(41)
	event.set_character_active(42)
	event.set_object_sequence_motion(21, "ｴﾌｪｸﾄ_火花", 4)
	event.set_object_sequence_motion(22, "ｴﾌｪｸﾄ_火花", 4)
	wait.frames(30)
	event.set_character_visible(41, 0, 1, 0.1)
	event.set_character_visible(42, 0, 1, 0.1)
	event.set_character_active(39)
	event.set_character_active(40)
	event.set_object_handle_visible(19, 1)
	event.set_object_handle_visible(20, 1)
	event.set_object_sequence_motion(19, "ぶしゅー", 6)
	event.set_object_sequence_motion(20, "ぶしゅー", 6)
	event.wait_object_sequence_motion_end(19)
	object.wait_until_done(7)
	wait.frames(75)
	event.set_character_active(0, 39)
	event.set_character_active(0, 40)
end

--- Plays the train arriving with sparks and steam using the alternate wait helper.
function sindain_station.play_train_braking_sequence_alt(sound_effect_id: s32)
	event.change_directory("event/e500/e500/")
	event.load_character(5, "steam_slow_l.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(19, 39)
	event.clear_object_sequence(19)
	event.set_object_sequence_object(19, 19)
	event.set_object_sequence_position(19, -120.0, 0.0, -1690.0)
	event.load_character(5, "steam_slow_r.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(20, 40)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.set_object_sequence_position(20, -120.0, 0.0, -1690.0)
	event.load_character(5, "train_hibana.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(21, 41)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	event.copy_character(5, 41, 42)
	event.set_character_active(0, 42)
	event.attach_object_handle_to_character(22, 42)
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.change_directory("")
	event.attach_object_handle_to_map_part_2(7, "p01_train01")
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.attach_object_handle_to_map_part_3(8, "p01_train01", "train08-m0")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_3(9, "p01_train01", "train08-m1")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_3(10, "p01_train01", "train10-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.attach_object_handle_to_map_part_3(11, "p01_train01", "train10-m1")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.attach_object_handle_to_map_part_3(12, "p01_train01", "train07-m3")
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.attach_object_handle_to_map_part_3(13, "p01_train01", "train07-m4")
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.attach_object_handle_to_map_part_3(14, "p01_train01", "train07-m5")
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
	event.attach_object_handle_to_map_part_3(15, "p01_train01", "train05-m17")
	event.clear_object_sequence(15)
	event.set_object_sequence_object(15, 15)
	event.attach_object_handle_to_map_part_3(16, "p01_train01", "train05-m16")
	event.clear_object_sequence(16)
	event.set_object_sequence_object(16, 16)
	event.attach_object_handle_to_map_part_3(17, "p01_train01", "train06-m1")
	event.clear_object_sequence(17)
	event.set_object_sequence_object(17, 17)
	event.attach_object_handle_to_map_part_3(18, "p01_train01", "train06-m0")
	event.clear_object_sequence(18)
	event.set_object_sequence_object(18, 18)
	event.set_object_handle_position(7, 1.3, 8.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(8, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(10, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(11, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(15, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(16, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(17, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(18, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(12, 0)
	event.set_object_handle_visible(13, 0)
	event.set_object_handle_visible(14, 0)
	event.set_object_handle_position(19, 1.3, 8.0, 0.0)
	event.set_object_handle_position(20, 1.3, 8.0, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-517.4, 241.51, -79.15)
	event.set_camera_sequence_look_at(-261.58, 188.2, 229.96)
	event.set_object_sequence_position(19, -21.58, 30.57, -7.66)
	event.set_object_sequence_rotation(19, 0.0, 5.5815926, 0.0)
	event.set_object_sequence_position(20, 9.76, 21.970001, 2.36)
	event.set_object_sequence_rotation(20, 0.0, 5.5815926, 0.0)
	event.set_object_sequence_rotation(21, 0.0, 5.5815926, 0.0)
	event.set_object_sequence_position(21, 9.76, 21.970001, 2.36)
	event.set_object_sequence_rotation(21, 0.0, 5.5815926, 0.0)
	event.set_object_sequence_position(22, 9.76, 21.970001, 2.36)
	event.set_object_sequence_rotation(22, 0.0, 5.341593, 0.0)
	event.move_object_sequence_eased(7, 1.3, 8.0, 700.0, 90, 2, 1.0)
	event.call_command(488, 19, -21.58, 30.57, 707.66, 2, 1.0) -- retail: the handler rejects 6 arguments
	event.move_object_sequence_eased(20, 9.76, 21.970001, 702.36, 90, 2, 1.0)
	event.move_object_sequence_eased(21, -25.34, 18.05, 631.96, 90, 2, 1.0)
	event.move_object_sequence_eased(22, -71.6, 18.05, 719.36, 90, 2, 1.0)
	event.delay_object_sequence_rotation_track(15, 70)
	event.rotate_object_sequence_eased(15, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.delay_object_sequence_rotation_track(16, 70)
	event.rotate_object_sequence_eased(16, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.delay_object_sequence_rotation_track(17, 70)
	event.rotate_object_sequence_eased(17, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.delay_object_sequence_rotation_track(18, 70)
	event.rotate_object_sequence_eased(18, 6.108652, 0.0, 0.0, 40, 2, 1.0)
	event.initialize_effect_manager(5)
	event.load_effect_base("列車煙")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(7, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 7)
	event.fade_in_screen(30)
	event.play_sound_effect(sound_effect_id, 8)
	wait.for_frame_count(90)
	event.set_object_handle_visible(21, 1)
	event.set_object_handle_visible(22, 1)
	event.set_character_active(41)
	event.set_character_active(42)
	event.set_object_sequence_motion(21, "ｴﾌｪｸﾄ_火花", 4)
	event.set_object_sequence_motion(22, "ｴﾌｪｸﾄ_火花", 4)
	wait.for_frame_count(30)
	event.set_character_visible(41, 0, 1, 0.1)
	event.set_character_visible(42, 0, 1, 0.1)
	event.set_character_active(39)
	event.set_character_active(40)
	event.set_object_handle_visible(19, 1)
	event.set_object_handle_visible(20, 1)
	event.set_object_sequence_motion(19, "ぶしゅー", 6)
	event.set_object_sequence_motion(20, "ぶしゅー", 6)
	event.wait_object_sequence_motion_end(19)
	object.wait_until_done(7)
	wait.for_frame_count(75)
	event.set_character_active(0, 39)
	event.set_character_active(0, 40)
end

--- Plays the skippable cutscene of the train steaming away from the station and fading out.
function sindain_station.play_train_departure_cutscene()
	local sound_bank: s32 = 0
	local checkpoint: number = 0
	vm.section(function()
		checkpoint = 1
		vm.entry(1)
		event.initialize_event()
		event.fade_out_screen(30)
		checkpoint = 2
		wait.frames(30)
		event.load_map_sounds(2237)
		sound_bank = event.load_sound_effect_file_2(2237) or sound_bank
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		sindain_station.hide_station_parts()
		checkpoint = 3
		train.level_cars()
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 400.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.attach_object_handle_to_map_part_2(1, "p01_shadow-0")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/train/steam/steam_l.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.attach_object_handle_to_character(2, 32)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/train/steam/steam_r.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_character(3, 33)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-304.68, 110.91, -288.45)
		event.set_camera_sequence_look_at(-158.49, 89.18, -46.7)
		event.fade_in_screen(30)
		checkpoint = 4
		wait.frames(30)
		event.set_character_active(1, 32)
		event.set_object_sequence_position(2, 30.0, 20.0, 380.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "ぶしゅー", 6)
		event.set_character_active(1, 33)
		event.set_object_sequence_position(3, -30.0, 20.0, 380.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "ぶしゅー", 6)
		event.move_object_sequence_eased(0, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(1, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(2, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.move_object_sequence_eased(3, 0.0, 0.0, 6000.0, 210, 1, 1.0)
		event.play_sound_effect(sound_bank, 3)
		checkpoint = 5
		object.wait_until_done(0)
		event.fade_out_screen(30)
		checkpoint = 6
		wait.frames(30)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 2 then
			cutscene.noop()
			sindain_station.log_slope_off()
		end
		if checkpoint <= 3 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 4 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 5 then
			wait.frames_skipping(30)
		end
		return true
	end)
	checkpoint = 7
	vm.entry(7)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.clear_effect_manager()
	event.delete_character(32)
	event.delete_character(33)
	event.set_object_handle_shadow_enabled(0, 1)
	event.set_character_active(0)
end

--- Returns the player to the platform and removes the event 280 characters and hidden parts.
function sindain_station.restore_after_event_280()
	event.set_character_active(1, 0)
	event.set_character_position(0, -687.4, 0.0, -77.8)
	event.set_character_rotation(0, 0.0, 1.62, 0.0)
	event.delete_character(34)
	event.delete_character(36)
	event.delete_character(35)
	event.set_object_handle_visible(6, 1)
	event.set_object_handle_visible(7, 1)
	event.set_object_handle_visible(8, 1)
	event.set_object_handle_visible(9, 1)
	event.set_object_handle_visible(10, 1)
	event.set_character_active(1, 8)
	event.set_character_active(1, 9)
	event.set_character_active(1, 10)
end

--- Runs the player into the map from the west while the camera fades in.
function sindain_station.run_player_in_with_fade()
	event.initialize_event()
	event.fade_out_screen(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-971.07, 66.21, -121.97)
	event.set_camera_sequence_look_at(-826.79, 21.3, 58.4)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -949.3, 0.0, 34.7)
	event.set_object_sequence_rotation(0, 0.0, 1.36, 0.0)
	event.set_object_sequence_motion(0, "走り", 4)
	event.move_object_sequence(0, -806.69, 0.0, 85.01, 60)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait.frames(60)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.reset_follow_camera(0)
end

--- Opens the floor menu of the second dungeon, then resumes play with the player walking back, jumps to map s05 or enters the chosen floor.
function sindain_station.select_dungeon_floor()
	local selection: s32 = 0
	local flag_212: s32 = 0
	event.set_dungeon_stage_id(1)
	event.open_event_menu(3, 1)
	vm.wait(1)
	do
		local _, _, out3, _ = event.get_menu_results_4()
		selection = out3 or selection
	end
	vm.wait(2)
	if selection == 0 then
		sindain_station.walk_player_back_from_menu()
	else
		if selection == 6 then
			event.jump_to_map_3(-1, "s05", 100)
			vm.wait(4)
			return
		end
		flag_212 = event.get_save_flag(212) or flag_212
		if selection == 2 and flag_212 == 0 or selection == 14 then
			event.skip_next_music_load()
		end
		event.go_to_dungeon(1, selection, 1010)
	end
end

--- Activates the three station villager characters.
function sindain_station.show_villagers()
	event.set_character_active(1, 8)
	event.set_character_active(1, 9)
	event.set_character_active(1, 10)
end

--- Skip-handler step for the crossfade stage that performs no work.
function sindain_station.skip_crossfade_step() end

--- Skip-handler counterpart of the train arrival cutscene that replays its waits.
function sindain_station.skip_train_arrival_quick()
	cutscene.noop()
	cutscene.skip_command(1)
	wait.frames_skipping(10)
	wait.frames_skipping(30)
	wait.frames_skipping(20)
	cutscene.skip_command(0)
	wait.frames_skipping(10)
	cutscene.ignore_coordinates(-130.0, 0.0, -365.0, vm.f32(-1.57))
	cutscene.noop()
end

--- Skip-handler counterpart of the braking sequence that replays its waits.
function sindain_station.skip_train_braking_sequence(sound_effect_id: s32)
	wait.frames_skipping(90)
	wait.frames_skipping(30)
	cutscene.skip_command(7)
	wait.frames_skipping(75)
end

--- Skip-handler counterpart of the alternate braking sequence that replays its waits.
function sindain_station.skip_train_braking_sequence_alt(sound_effect_id: s32)
	wait.skip_frame_count(90)
	wait.skip_frame_count(30)
	cutscene.skip_command(7)
	wait.skip_frame_count(75)
end

--- Loads and registers the station villagers according to the chapter and story flags.
function sindain_station.spawn_villagers()
	local chapter: s32 = 0
	local flag_500: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	chapter = event.get_chapter() or chapter
	if chapter ~= 6 and chapter ~= 7 then
		event.load_character(4, "chara/p01_03a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, -150.0, 0.0, -300.0)
		event.set_character_rotation(8, 0.0, -1.57, 0.0)
		event.set_scene_character_number(8, 1)
		event.register_villager(8, 1)
	else
		event.load_character(4, "chara/p00_31a.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, -150.0, 0.0, -300.0)
		event.set_character_rotation(8, 0.0, -1.57, 0.0)
		event.set_scene_character_number(8, 301)
		event.register_villager(8, 301)
	end
	flag_500 = event.get_save_flag(500) or flag_500
	if flag_500 == 0 then
		event.load_character(4, "chara/p01_06a.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, -189.1, 0.0, 1119.1)
		event.set_character_rotation(9, 0.0, -2.46, 0.0)
		event.set_scene_character_number(9, 2)
		event.register_villager(9, 2)
		event.load_character(4, "chara/p01_07a.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_position(10, -127.5, 0.0, 645.0)
		event.set_character_rotation(10, 0.0, -2.94, 0.0)
		event.set_scene_character_number(10, 13)
		event.register_villager(10, 13)
	end
end

--- Starts the first-visit event script when its save flag has not been set.
function sindain_station.start_first_visit_event()
	local flag_207: s32 = 0
	flag_207 = event.get_save_flag(207) or flag_207
	if flag_207 == 0 then
		vm.wait(1)
		event.load_event_script("s02/s02b_1.stb", 501)
		return
	end
end

--- Fades in and walks the player in from the west before returning control and the follow camera.
function sindain_station.walk_player_back_from_menu()
	event.initialize_event()
	event.set_camera_sequence_position(-625.66, 104.24, -868.06)
	event.set_camera_sequence_look_at(-903.96, 23.48, -831.72)
	event.set_character_active(1, 0)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -1023.6, 0.0, -838.96)
	event.set_object_sequence_rotation(0, 0.0, 1.58, 0.0)
	event.fade_in_screen(30)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.move_object_sequence(0, -778.4, 0.0, -836.7, 60)
	event.move_camera_sequence_eased(-625.66, 104.24, -868.06, -778.4, 20.0, -836.7, 48, 2, 0.4)
	wait.frames(60)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.reset_follow_camera(0)
end

return sindain_station
