--!strict
-- map/s/s33/s33.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_6d912f07 = require("@lib/event/helper_6d912f07")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_eac8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(604, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(51)
		event.play_music(0)
		event.load_map_sounds(7803)
		var0 = event.load_sound_effect_file_2(7803) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e600/e604/")
		event.load_message_file(0, 5, "e604.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e604_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e604_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e600/e604/e604_mints.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 33)
			event.load_equipment_model(5, 1, 4, "info", 33)
			event.load_equipment_model(5, 1, 3, "info", 33)
			event.load_equipment_model(5, 1, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e600/e604/e604_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.attach_object_handle_to_map_part_3(2, "p01_s3302-0", "s330208-m0")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_3(3, "p01_s3302-0", "s330208-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_handle_position(0, 14.06, 0.0, -283.76)
		event.set_object_handle_rotation(0, 0.0, -3.09, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -22.57, 0.0, -283.73)
		event.set_object_handle_rotation(1, 0.0, -3.09, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-1409.3, 33.17, 699.45)
		event.set_camera_sequence_look_at(-1317.3, 207.26, 35.03)
		event.set_character_active(0)
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 14.06, 0.0, -588.5, 540, 1)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -22.57, 0.0, -588.26, 540, 1)
		event.fade_in_screen(30)
		event.move_camera_sequence(1340.45, 33.17, 781.09, 1266.94, 207.26, 116.17, 450)
		helper_888ab2a3(60)
		helper_0382f327(6040010, 150)
		helper_0382f327(6040020, 240)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(1, -13.05, 82.65, -581.69)
		event.set_object_sequence_rotation(1, 0.0, -3.09, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 10.82, 82.79, -581.79)
		event.set_object_sequence_rotation(0, 0.0, -3.09, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-1.05, 107.16, -512.55)
		event.set_camera_sequence_look_at(-0.34, 115.06, -632.94)
		event.move_object_sequence(1, -11.66, 140.66, -709.98, 260, 1)
		event.move_object_sequence(0, 11.57, 140.66, -707.0, 260, 1)
		helper_0382f327(6040030, 240)
		helper_888ab2a3(20)
		wait_objects(1)
		event.set_camera_sequence_position(1.24, 142.22, -872.19)
		event.set_camera_sequence_look_at(1.67, 177.22, -765.97)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(1, -8.87, 140.66, -739.81)
		event.set_object_sequence_rotation(1, 0.0, 3.07, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 12.17, 140.66, -739.07)
		event.set_object_sequence_rotation(0, 0.0, -3.09, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(1, -9.09, 140.66, -794.9, 120, 1)
		event.move_object_sequence(0, 11.95, 140.66, -793.78, 120, 1)
		event.delay_object_sequence_motion_track(0, 120)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(1, 120)
		event.set_object_sequence_motion(1, "立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(6040040, -1)
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(6040050)
		wait_objects(1)
		event.set_camera_sequence_position(-0.36, 446.02, 122.03)
		event.set_camera_sequence_look_at(3.18, 151.42, -826.58)
		event.set_object_sequence_position(1, -22.1, 140.66, -908.82)
		event.set_object_sequence_rotation(1, 0.0, 2.95, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(0, 13.59, 140.66, -906.11)
		event.set_object_sequence_rotation(0, 0.0, -2.97, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 0)
		event.rotate_object_sequence(2, 0.0, 0.61, 0.0, 60)
		event.rotate_object_sequence(3, 0.0, -0.61, 0.0, 60)
		helper_888ab2a3(120)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向く会話", 4)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(6040060)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(6040070)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_rotation(2, 0.0, 0.61, 0.0)
	event.set_object_handle_rotation(3, 0.0, -0.61, 0.0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	helper_9dafbc83(0.0, vm.f32(140.7), -770.0, vm.f32(3.14))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_db28()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		var0 = helper_ed4dc120(7, 97)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.fade_out_screen(30)
			at = 2
			helper_888ab2a3(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + var1)
			var5 = var2
			var6 = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + var3)
			event.move_object_sequence(0, var4, var5, var6, 30)
			event.turn_object_sequence_toward(0, var4, var5, var6, 10)
			event.set_object_sequence_motion(0, "歩き")
			var7 = 0
			while var7 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				var2 = vm.f32(var2 + 30.0)
				event.set_camera_look_at(var1, var2, var3)
				var7 = var7 + 1
				at = 3
				vm.wait(3)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_e410()
	local flag: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/e300/e372/e372_waku2.gltf", "info", 32)
		event.attach_object_handle_to_character(0, 32)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_message_file(0, 5, "event/e300/e372/e372.txt")
		flag = event.get_save_flag(43) or flag
		if flag ~= 0 then
			event.stop_music(0)
			helper_888ab2a3(4)
			event.load_music(59)
			event.play_music(0)
			event.set_save_flag(43, 0)
		end
		event.enable_drama_skip()
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.start_crossfade(0, 0, 90)
		event.set_camera_sequence_position(-178.53, 128.12, 2185.49)
		event.set_camera_sequence_look_at(-546.76, 268.24, 1697.27)
		event.set_object_sequence_position(0, -546.76, 268.24, 1697.27)
		event.keep_character_in_front_of_camera_sequence(32, 608.78, 99999999)
		event.move_camera_sequence_eased(1177.44, 128.12, 1162.78, 809.21, 268.24, 674.57, 600, 2, 0.4)
		helper_4116e6bb(3720190)
		helper_4116e6bb(3720200)
		helper_4116e6bb(3720210)
		helper_4116e6bb(3720220)
		event.clear_camera_sequence()
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.delete_character(32)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(600) or flag
	flag_2 = event.get_save_flag(604) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_eac8()
	else
		if flag_2 == 1 then
			event.attach_object_handle_to_map_part_3(0, "p01_s3302-0", "s330208-m0")
			event.attach_object_handle_to_map_part_3(1, "p01_s3302-0", "s330208-m1")
			event.set_object_handle_rotation(0, 0.0, 0.61, 0.0)
			event.set_object_handle_rotation(1, 0.0, -0.61, 0.0)
		end
		helper_9dafbc83(0.0, 0.0, 2300.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_db28() ~= 0 then
		event.skip_next_music_load()
		event.go_to_dungeon(5, -1, 500)
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	if helper_6d912f07() ~= 0 then
		event.jump_to_map_2(-1, "s31")
	end
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_e410()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f02", 510)
	vm.wait(2)
end

--- Event 16040, which map data, a script or the engine runs by number.
script.event_16040 = helper_eac8

return script
