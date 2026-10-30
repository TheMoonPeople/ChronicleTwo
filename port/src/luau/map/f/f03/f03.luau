--!strict
-- map/f/f03/f03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_08c337b8 = require("@lib/event/helper_08c337b8")
local helper_13ff22fe = require("@lib/event/helper_13ff22fe")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_47990fb3 = require("@lib/event/helper_47990fb3")
local helper_575b46f3 = require("@lib/event/helper_575b46f3")
local helper_6ac55e60 = require("@lib/event/helper_6ac55e60")
local helper_6be25ed2 = require("@lib/event/helper_6be25ed2")
local helper_72334e82 = require("@lib/event/helper_72334e82")
local helper_72cb617b = require("@lib/event/helper_72cb617b")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_d0e95767 = require("@lib/event/helper_d0e95767")
local helper_d3e304cd = require("@lib/event/helper_d3e304cd")
local helper_fb78ba4a = require("@lib/event/helper_fb78ba4a")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local var0: s32 = 0
	event.attach_object_handle_to_map_part_2(1, "p04_f0301")
	var0 = helper_6be25ed2()
	if var0 == 0 then
		event.set_function_point_enabled("", "event_400", 0)
		event.set_function_point_enabled("", "event_401", 0)
		event.set_function_point_enabled("", "event_402", 0)
		event.set_function_point_enabled("", "event_403", 0)
		event.set_function_point_enabled("", "event_404", 0)
	else
		event.set_object_handle_visible(1, 0)
	end
	if helper_13ff22fe() == 0 then
		event.attach_object_handle_to_map_part_2(1, "p14_f0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p15_f0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p16_f0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p17_f0301")
		event.set_object_handle_visible(1, 0)
	end
	helper_d0e95767()
end

--- Helper function.
local function helper_1d55c()
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(456, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e456/")
		event.load_message_file(0, 5, "e456.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e456_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e456_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e456/e456_mints.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e456/e456_monica.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, -15.0, 190.0, 980.0)
		event.set_object_handle_rotation(0, 0.0, 2.42, 0.0)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 10.0, 190.0, 1010.0)
		event.set_object_handle_rotation(1, 0.0, 2.66, 0.0)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-121.94, 324.32, 1079.66)
		event.set_camera_sequence_look_at(60.51, 330.31, 947.34)
		event.move_camera_sequence_eased(-121.94, 324.32, 1079.66, -127.07, 330.31, 851.61, 60, 0, 1.0)
		event.fade_in_screen(30)
		wait_camera()
		event.set_camera_sequence_position(-43.47, 251.31, 889.38)
		event.set_camera_sequence_look_at(0.73, 198.66, 1005.94)
		event.set_object_sequence_motion(0, "指さし", 6)
		event.queue_object_sequence_next_motion(0, "指さしL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4560010)
		wait_objects(0)
		event.set_object_sequence_motion(0, "指さし戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4560020)
		wait_objects(0)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -15.0, 190.0, 820.0, 60)
		event.rotate_object_sequence(0, 0.0, 3.14, 0.0, 10)
		helper_888ab2a3(4)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, 10.0, 190.0, 870.0, 56)
		event.rotate_object_sequence(1, 0.0, 3.14, 0.0, 10)
		helper_888ab2a3(26)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	helper_9dafbc83(0.0, 190.0, 500.0, vm.f32(-3.14))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1ec20()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(460, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4514)
		var0 = event.load_sound_effect_file_2(4514) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e460/")
		event.load_message_file(0, 5, "e460.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e460_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e460_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e460/e460_mints.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e460/e460_monica.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 10.0, 190.0, 1010.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -15.0, 190.0, 980.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1.18, 274.82, 1359.97)
		event.set_camera_sequence_look_at(120.59, 276.91, 1224.84)
		event.move_camera_sequence_eased(1.18, 274.82, 1359.97, -53.13, 276.91, 1185.49, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 70)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 10.0, 190.0, 950.0, 70)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 80)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, -15.0, 190.0, 900.0, 60)
		event.fade_in_screen(30)
		wait_camera()
		wait_objects(0)
		wait_objects(1)
		event.set_camera_sequence_position(-86.36, 229.97, 864.78)
		event.set_camera_sequence_look_at(-1.3, 198.75, 922.91)
		event.set_object_sequence_rotation(0, 0.0, -2.54, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_rotation(1, 0.0, -2.18, 0.0)
		event.set_object_sequence_motion(1, "遠見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "遠見Ｌ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4600010)
		wait_objects(1)
		event.play_sound_effect(var0, 1)
		event.set_object_sequence_motion(1, "遠見戻り", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4600020)
		wait_objects(1)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -15.0, 190.0, 740.0, 60)
		event.rotate_object_sequence(1, 0.0, 3.14, 0.0, 10)
		helper_888ab2a3(4)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 10.0, 190.0, 790.0, 56)
		event.rotate_object_sequence(0, 0.0, 3.14, 0.0, 10)
		helper_888ab2a3(26)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(12)
	event.cancel_drama_scene_skip()
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	helper_9dafbc83(0.0, 190.0, 500.0, vm.f32(-3.14))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local var1: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local old_sub_map_no: s32 = 0
	local get_old_interior_map_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event_99()
		helper_d0e95767()
		event.get_georama_analysis_percent(2)
		var1 = 0
		if helper_72334e82() ~= 0 then
			var1 = 1
			at = 1
			helper_1d55c()
		end
		if helper_72cb617b() ~= 0 then
			var1 = 1
			at = 2
			helper_1ec20()
		end
		if helper_08c337b8() ~= 0 then
			var1 = 1
			event.skip_next_music_play()
			event.jump_to_map_3(-1, "f03i0301", 504)
			at = 3
			vm.wait(3)
		end
		if var1 == 1 then
			return
		end
		old_map_no = event.get_previous_map() or old_map_no
		if old_map_no == 2 then
			event.initialize_event()
			at = 4
			vm.wait(4)
			helper_7d7eee8f(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
			event.reset_follow_camera(1, 3.14, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 110 then
			event.initialize_event()
			at = 5
			vm.wait(5)
			var3 = event.get_save_counter(2) or var3
			if var3 == 0 then
				helper_7d7eee8f(0.0, 360.0, -755.0, 0.0)
			end
			if var3 == 1 then
				helper_7d7eee8f(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
			end
			if var3 == 2 then
				helper_7d7eee8f(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
			end
			if var3 == 3 then
				helper_7d7eee8f(315.0, 280.0, -1515.0, vm.f32(2.3561945))
			end
			if var3 == 4 then
				helper_7d7eee8f(315.0, 280.0, -885.0, vm.f32(0.7853982))
			end
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 113 then
			event.initialize_event()
			at = 6
			vm.wait(6)
			helper_7d7eee8f(1080.0, 190.0, -120.0, vm.f32(-2.355))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 141 then
			event.initialize_event()
			at = 7
			vm.wait(7)
			helper_7d7eee8f(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 142 then
			event.initialize_event()
			at = 8
			vm.wait(8)
			helper_7d7eee8f(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 114 then
			event.initialize_event()
			at = 9
			vm.wait(9)
			helper_7d7eee8f(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		old_sub_map_no = event.get_previous_submap() or old_sub_map_no
		get_old_interior_map_no = event.get_previous_interior_map() or get_old_interior_map_no
		print("map_no=", old_map_no, "##############\n")
		print("old_submap_no=", old_sub_map_no, "##############\n")
		print("old_interior_map_no=", get_old_interior_map_no, "##############\n")
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				local _ = helper_575b46f3()
				var1 = 1
				at = 2
				helper_1ec20()
				return vm.continue_with(function()
					if helper_08c337b8() ~= 0 then
						var1 = 1
						event.skip_next_music_play()
						event.jump_to_map_3(-1, "f03i0301", 504)
						at = 3
						vm.wait(3)
					end
					if var1 == 1 then
						return
					end
					old_map_no = event.get_previous_map() or old_map_no
					if old_map_no == 2 then
						event.initialize_event()
						at = 4
						vm.wait(4)
						helper_7d7eee8f(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
						event.reset_follow_camera(1, 3.14, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 110 then
						event.initialize_event()
						at = 5
						vm.wait(5)
						var3 = event.get_save_counter(2) or var3
						if var3 == 0 then
							helper_7d7eee8f(0.0, 360.0, -755.0, 0.0)
						end
						if var3 == 1 then
							helper_7d7eee8f(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
						end
						if var3 == 2 then
							helper_7d7eee8f(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
						end
						if var3 == 3 then
							helper_7d7eee8f(315.0, 280.0, -1515.0, vm.f32(2.3561945))
						end
						if var3 == 4 then
							helper_7d7eee8f(315.0, 280.0, -885.0, vm.f32(0.7853982))
						end
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 113 then
						event.initialize_event()
						at = 6
						vm.wait(6)
						helper_7d7eee8f(1080.0, 190.0, -120.0, vm.f32(-2.355))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 141 then
						event.initialize_event()
						at = 7
						vm.wait(7)
						helper_7d7eee8f(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 142 then
						event.initialize_event()
						at = 8
						vm.wait(8)
						helper_7d7eee8f(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 114 then
						event.initialize_event()
						at = 9
						vm.wait(9)
						helper_7d7eee8f(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					old_sub_map_no = event.get_previous_submap() or old_sub_map_no
					get_old_interior_map_no = event.get_previous_interior_map() or get_old_interior_map_no
					print("map_no=", old_map_no, "##############\n")
					print("old_submap_no=", old_sub_map_no, "##############\n")
					print("old_interior_map_no=", get_old_interior_map_no, "##############\n")
					return
				end)
			end
			if at <= 2 then
				local _ = helper_fb78ba4a()
				var1 = 1
			end
			return 0
		end
		if at <= 9 then
			if at <= 4 then
				helper_43f02c95(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
			end
			if at <= 5 then
				helper_43f02c95(0.0, 360.0, -755.0, 0.0)
				helper_43f02c95(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
				helper_43f02c95(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
				helper_43f02c95(315.0, 280.0, -1515.0, vm.f32(2.3561945))
				helper_43f02c95(315.0, 280.0, -885.0, vm.f32(0.7853982))
			end
			if at <= 6 then
				helper_43f02c95(1080.0, 190.0, -120.0, vm.f32(-2.355))
			end
			if at <= 7 then
				helper_43f02c95(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
			end
			if at <= 8 then
				helper_43f02c95(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
			end
			helper_43f02c95(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
			print("map_no=", old_map_no, "##############\n")
			print("old_submap_no=", old_sub_map_no, "##############\n")
			print("old_interior_map_no=", get_old_interior_map_no, "##############\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_6ac55e60(160.0, vm.f32(286.2), 1849.5, 0.0)
	event.jump_to_map_2(-1, "g03")
	vm.wait(2)
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	helper_47990fb3(vm.f32(3.1415927), 1)
	event.set_save_counter(2, 0)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	helper_47990fb3(vm.f32(0.7853982), 0)
	event.set_save_counter(2, 2)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 402, which map data, a script or the engine runs by number.
function script.event_402()
	helper_47990fb3(vm.f32(2.3561945), 0)
	event.set_save_counter(2, 1)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 403, which map data, a script or the engine runs by number.
function script.event_403()
	helper_47990fb3(vm.f32(-2.3561945), 0)
	event.set_save_counter(2, 4)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 404, which map data, a script or the engine runs by number.
function script.event_404()
	helper_47990fb3(vm.f32(-0.7853982), 0)
	event.set_save_counter(2, 3)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 405, which map data, a script or the engine runs by number.
function script.event_405()
	local flag: s32 = 0
	local flag_2: s32 = 0
	helper_47990fb3(vm.f32(0.7853982), 0)
	flag = event.get_save_flag(408) or flag
	flag_2 = event.get_save_flag(412) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.skip_next_music_load()
	end
	event.jump_to_map_3(-1, "f03i0301", 100)
	vm.wait(2)
end

--- Event 406, which map data, a script or the engine runs by number.
function script.event_406()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	flag = event.get_save_flag(400) or flag
	flag_2 = event.get_save_flag(420) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.set_character_motion(0, "立ち")
		set_window_mode(0, 1)
		event.open_message_window_2(0, "開かない。後で来てみよう。")
		show_message(0, -1, 5, 256, 208)
		return
	else
		flag_3 = event.get_save_flag(428) or flag_3
		if flag_3 == 0 then
			event.skip_next_music_load()
		end
	end
	helper_47990fb3(vm.f32(-2.3561945), 0)
	event.jump_to_map_3(-1, "f03i0302", 100)
	vm.wait(3)
end

--- Event 407, which map data, a script or the engine runs by number.
function script.event_407()
	helper_47990fb3(vm.f32(2.3561945), 0)
	event.jump_to_map_3(-1, "f03i0303", 100)
	vm.wait(2)
end

--- Event 408, which map data, a script or the engine runs by number.
function script.event_408()
	helper_47990fb3(vm.f32(-0.7853982), 0)
	event.jump_to_map_3(-1, "f03i0304", 100)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_d3e304cd

--- Event 14560, which map data, a script or the engine runs by number.
function script.event_14560()
	event.set_georama_analyze_flag(2, 2, 0)
	event.set_georama_analyze_flag(2, 3, 0)
	event.set_georama_analyze_flag(2, 4, 0)
	event.set_georama_analyze_flag(2, 5, 0)
	event.set_georama_analyze_flag(2, 6, 0)
	event.set_georama_analyze_flag(2, 7, 0)
	event.set_georama_analyze_flag(2, 8, 0)
	event.set_georama_analyze_flag(2, 9, 0)
	event.set_georama_analyze_flag(2, 0, 1)
	event.set_georama_analyze_flag(2, 1, 1)
	event.set_save_flag(456, 0)
	event.set_save_flag(460, 1)
	event.jump_to_map_3(-1, 82, 100)
	vm.wait(1)
end

--- Event 14600, which map data, a script or the engine runs by number.
function script.event_14600()
	event.set_georama_analyze_flag(2, 3, 0)
	event.set_georama_analyze_flag(2, 4, 0)
	event.set_georama_analyze_flag(2, 5, 0)
	event.set_georama_analyze_flag(2, 6, 0)
	event.set_georama_analyze_flag(2, 7, 0)
	event.set_georama_analyze_flag(2, 8, 0)
	event.set_georama_analyze_flag(2, 9, 0)
	event.set_georama_analyze_flag(2, 0, 1)
	event.set_georama_analyze_flag(2, 1, 1)
	event.set_georama_analyze_flag(2, 2, 1)
	event.set_save_flag(456, 1)
	event.set_save_flag(460, 0)
	event.jump_to_map_3(-1, 82, 100)
	vm.wait(1)
end

return script
