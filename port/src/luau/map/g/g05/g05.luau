--!strict
-- map/g/g05/g05.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_2b32f1e8 = require("@lib/event/helper_2b32f1e8")
local helper_38a7fa45 = require("@lib/event/helper_38a7fa45")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

--- Helper function.
local function helper_dcbc(arg0: s32)
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		var1 = helper_ed4dc120(5, arg0)
		if var1 == 0 then
			event.fade_out_screen(20)
			at = 2
			helper_888ab2a3(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(20)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_e73c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local time: f32 = 0
	vm.section(function()
		event.set_save_flag(700, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.load_map_sounds(7204)
		var1 = event.load_sound_effect_file_2(7204) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e700/")
		event.load_message_file(0, 5, "e700.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e700_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e700_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e700_andrea.gltf", "info", 34)
		event.set_scene_status_flags(1, 34, 8, 1)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e700_a_hikari.gltf", "info", 35)
		event.set_scene_character_type(35, 4)
		event.set_character_active(35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e700/e700/e700_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e700/e700/e700_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 7.0, 0.0, 200.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "上向くL", 4)
		event.set_object_handle_footstep_sound(0, 7)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -7.0, 0.0, 198.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "上向くL", 4)
		event.set_object_handle_footstep_sound(1, 7)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 0.0, 20.0, 160.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_motion(2, "両手開くＬ", 4)
		event.set_object_handle_position(3, 11.0, 40.0, 160.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "後光", 4)
		event.enable_drama_skip()
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(12.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(24.65, 49.97, 163.5)
		event.set_camera_sequence_look_at(-24.72, 49.99, 159.92)
		helper_888ab2a3(30)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目あけ～目とじ２")
		event.set_object_sequence_motion(2, "両手開いて深呼吸", 2)
		event.queue_object_sequence_next_motion(2, "両手開いて深呼吸Ｌ", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(7000140)
		event.set_camera_sequence_position(0.0, 17.98, 252.41)
		event.set_camera_sequence_look_at(0.0, 26.48, 201.7)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あけ３")
		event.set_object_sequence_position(3, 0.0, 40.0, 160.0)
		event.set_object_sequence_motion(2, "両手開く戻り", 6)
		event.queue_object_sequence_next_motion(2, "浮遊立ち", 4)
		event.set_mouth_texture_animations(2, "しんけん口パク")
		helper_4116e6bb(7000150)
		event.set_mouth_texture_animations(2, "しんけん口パク")
		helper_4116e6bb(7000155)
		wait_objects(2)
		event.set_camera_sequence_position(0.0, 48.71, 192.39)
		event.set_camera_sequence_look_at(0.0, 48.68, 135.78)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "しんけん口パク")
		helper_4116e6bb(7000160)
		event.set_mouth_texture_animations(2, "しんけん口パク")
		helper_4116e6bb(7000165)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(2, 1, "目あき～さみし目とじ")
		event.set_mouth_texture_animations(2, "しんけん口パク")
		helper_4116e6bb(7000170)
		event.set_camera_sequence_position(0.0, 39.02, 371.19)
		event.set_camera_sequence_look_at(0.0, 38.99, 314.58)
		event.play_sound_effect(var1, 2)
		event.set_character_visible(34, 0, 1, 0.033333335)
		event.set_object_sequence_motion(3, "消失", 2)
		helper_888ab2a3(30)
		event.move_camera_sequence_eased(0.0, 39.02, 371.19, 0.0, 61.67, 314.58, 60, 0, 0.2)
		wait_camera()
		helper_888ab2a3(20)
		event.set_time_of_day(time)
		event.start_crossfade(60)
		helper_888ab2a3(90)
		event.set_camera_sequence_position(23.26, 26.93, 164.88)
		event.set_camera_sequence_look_at(-0.0, 18.34, 203.74)
		helper_888ab2a3(40)
		event.set_object_sequence_motion(0, "上→左", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var1, 3)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "上から右", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_sound_track(1, 30)
		event.play_object_sequence_sound(1, var1, 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(7000180)
		wait_objects(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(7000190)
		event.set_object_sequence_motion(1, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, var1, 6)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.delay_object_sequence_sound_track(0, 20)
		event.play_object_sequence_sound(0, var1, 5)
		helper_888ab2a3(10)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		helper_888ab2a3(10)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目～おこり目")
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	event_99()
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		helper_9dafbc83(40.0, 0.0, 1400.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
	else
		old_map_no = event.get_previous_map() or old_map_no
		var2 = event.get_map_type(old_map_no) or var2
		if var2 ~= -1 and old_map_no ~= 4 then
			if old_map_no == 109 then
				helper_9dafbc83(0.0, vm.f32(140.7), -1750.0, 0.0)
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			else
				helper_9dafbc83(0.0, 0.0, 1400.0, vm.f32(3.14))
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			end
		end
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_dcbc(155) ~= 0 then
		event.jump_to_map_2(-1, "s34")
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local flag: s32 = 0
	if helper_dcbc(109) ~= 0 then
		flag = event.get_save_flag(702) or flag
		if flag == 0 then
			event.skip_next_music_load()
		end
		event.jump_to_map_2(-1, "d06e01")
	end
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	if (if helper_38a7fa45() ~= 0 then helper_2b32f1e8() else 0) ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_save_flag(744, 1)
		event.set_save_flag(748, 1)
		event.jump_to_map_3(-1, "s44", 570)
		vm.wait(2)
	end
	if helper_38a7fa45() ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_save_flag(744, 1)
		event.jump_to_map_3(-1, "s44", 550)
		vm.wait(4)
	end
	if helper_2b32f1e8() ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_save_flag(748, 1)
		event.jump_to_map_3(-1, "s44", 560)
		vm.wait(6)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_e73c()
	event.set_save_data_value(0, 9)
	event.load_map_sounds(7000)
	helper_9dafbc83(0.0, 0.0, -1000.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, -1000.0)
	event.set_camera_position(0.0, 50.0, -880.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_9dafbc83(0.0, 0.0, -1100.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -1100.0)
	event.set_camera_position(0.0, 50.0, -1220.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	helper_9dafbc83(0.0, 0.0, -1100.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -1100.0)
	event.set_camera_position(0.0, 50.0, -1220.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	helper_888ab2a3(30)
	event.add_inventory_item(198, 1)
	event.add_inventory_item(199, 1)
	helper_f38eabca(198, 1)
	helper_f38eabca(199, 1)
	helper_d61bc810(1)
end

return script
