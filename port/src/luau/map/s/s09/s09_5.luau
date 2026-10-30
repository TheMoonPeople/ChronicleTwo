--!strict
-- map/s/s09/s09_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_050c9cee = require("@lib/event/helper_050c9cee")
local helper_07039683 = require("@lib/event/helper_07039683")
local helper_1352f985 = require("@lib/event/helper_1352f985")
local helper_13965fb3 = require("@lib/event/helper_13965fb3")
local helper_1edf2b0f = require("@lib/event/helper_1edf2b0f")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_7f0ede20 = require("@lib/event/helper_7f0ede20")
local helper_7f95a402 = require("@lib/event/helper_7f95a402")
local helper_826a3ea7 = require("@lib/event/helper_826a3ea7")
local helper_83f038b5 = require("@lib/event/helper_83f038b5")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_a8de6f45 = require("@lib/event/helper_a8de6f45")
local helper_ad46c277 = require("@lib/event/helper_ad46c277")
local helper_b580d4fc = require("@lib/event/helper_b580d4fc")
local helper_c21b6dfd = require("@lib/event/helper_c21b6dfd")
local helper_c6cfe9e9 = require("@lib/event/helper_c6cfe9e9")
local helper_c99744f1 = require("@lib/event/helper_c99744f1")
local helper_d4129194 = require("@lib/event/helper_d4129194")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local helper_db46662e = require("@lib/event/helper_db46662e")
local helper_e5f03808 = require("@lib/event/helper_e5f03808")
local helper_e6450f0b = require("@lib/event/helper_e6450f0b")
local helper_f10d721b = require("@lib/event/helper_f10d721b")
local helper_f4ec8310 = require("@lib/event/helper_f4ec8310")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_f6012ebc = require("@lib/event/helper_f6012ebc")
local helper_fdad3d3b = require("@lib/event/helper_fdad3d3b")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_2f4d8()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e400/e448/e448_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e400/e448/e448_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "chara/p01_03a.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "chara/p01_06a.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_2(4, "p01_train01")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.load_message_file(0, 5, "event/e400/e448/e448_1.txt")
end

--- Helper function.
local function helper_2f110()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(38)
	event.delete_character(39)
	event.set_character_position(0, -1952.44, 29.22, -304.96)
	event.set_character_rotation(0, 0.0, 1.62, 0.0)
end

--- Helper function.
local function helper_30408()
	local var6: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(4220)
		var6 = event.load_sound_effect_file_2(4220) or var6
		helper_2f4d8()
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(-1979.65, 91.43, -121.02)
		event.set_camera_sequence_look_at(-1941.55, 74.53, -339.62)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.set_object_sequence_position(1, -1838.01, 8.0, -560.01)
		event.set_object_sequence_rotation(1, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(0, -1904.92, 17.42, -503.6)
		event.set_object_sequence_rotation(0, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(2, -2186.89, 29.22, -198.9)
		event.set_object_sequence_rotation(2, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(3, -2223.98, 29.22, -196.3)
		event.set_object_sequence_rotation(3, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(4, -912.1, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
		event.fade_in_screen(30)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 60)
		event.add_object_sequence_path_point(0, -1904.92, 17.42, -503.6)
		event.add_object_sequence_path_point(0, -1985.4, 29.22, -393.12)
		event.start_object_sequence_path(0, 1)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 60)
		event.add_object_sequence_path_point(1, -1838.01, 8.0, -560.01)
		event.add_object_sequence_path_point(1, -1922.88, 29.4, -436.71)
		event.start_object_sequence_path(1, 1)
		wait_objects(0)
		wait_objects(1)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_camera_sequence_position(-2052.02, 160.14, -365.82)
		event.set_camera_sequence_look_at(-2179.63, 74.53, -268.32)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 120)
		event.add_object_sequence_path_point(1, -2199.24, 29.22, -360.0)
		event.add_object_sequence_path_point(1, -2199.24, 29.22, -253.55)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 120)
		event.add_object_sequence_path_point(0, -2216.55, 29.22, -360.0)
		event.add_object_sequence_path_point(0, -2216.55, 29.22, -253.55)
		event.start_object_sequence_path(0)
		wait_objects(0)
		wait_objects(1)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_4116e6bb(4481130)
		event.set_object_sequence_motion(2, "立ち")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		helper_4116e6bb(4481140)
		event.set_object_sequence_motion(3, "会話", 2)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		helper_4116e6bb(4481150)
		event.set_object_sequence_motion(3, "立ち")
		wait_frames(30)
		event.set_object_sequence_position(1, -1935.53, 29.22, -301.43)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(0, -1952.44, 29.22, -304.96)
		event.set_object_sequence_rotation(0, 0.0, 1.08, 0.0)
		event.set_camera_sequence_position(-1949.04, 34.26, -256.22)
		event.set_camera_sequence_look_at(-1934.01, 87.78, -397.48)
		event.set_object_sequence_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4481160)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var6, 25)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(4481170)
		event.reset_mouth_texture_animations()
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait_frames(35)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_2f110()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_3426c()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(14) or var0
		if var0 == 1 then
			at = 1
			return helper_7f0ede20()
		end
		if var0 == 2 then
			at = 2
			helper_c6cfe9e9()
		end
		if var0 == 13 then
			at = 3
			helper_1352f985()
		end
		if var0 == 301 then
			at = 4
			helper_1edf2b0f()
		end
		return 0
	end, function(received: { any })
		if at <= 1 then
			return helper_db46662e()
		end
		if at <= 4 then
			if at <= 2 then
				helper_ad46c277()
			end
			if at <= 3 then
				helper_e5f03808()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var6: s32 = 0
	local at: number = 0
	return vm.guard(function()
		print("START_EVENT----------------------------")
		helper_13965fb3()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, -1820.0, 29.2, -335.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			var2 = event.get_map_type() or var2
			if var2 ~= -1 then
				if old_map_no == 2 or old_map_no == 75 then
					at = 1
					helper_07039683()
				else
					var3 = event.get_save_counter(1) or var3
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and var3 == 4
					then
						helper_946c0402()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						flag = event.get_save_flag(360) or flag
						flag_2 = event.get_save_flag(400) or flag_2
						if flag == 1 and flag_2 == 0 then
							at = 2
							helper_c21b6dfd()
						else
							event.set_character_active(0, 9)
							var6 = event.get_chapter() or var6
							if var6 ~= 6 and var6 ~= 7 then
								at = 3
								helper_a8de6f45()
							else
								at = 4
								helper_f10d721b()
							end
							event.set_character_active(1, 9)
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
			end
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_d7295df9()
				at = 2
				helper_c21b6dfd()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_a8de6f45()
				return vm.continue_with(function()
					event.set_character_active(1, 9)
					return
				end)
			end
			if at <= 3 then
				helper_7f95a402()
			end
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_f10d721b

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	if helper_d4129194() ~= 0 then
		event.jump_to_map_2(-1, "g03")
	end
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_f6012ebc()
		if var0 ~= 1 then
			return
		end
		event.set_save_counter(1, 4)
		var1 = event.get_chapter() or var1
		var2 = event.get_triggered_event_data_2(3) or var2
		if var2 <= 1 then
			if var1 ~= 6 and var1 ~= 7 then
				at = 2
				helper_f4ec8310()
				event.stop_music(0)
				at = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				at = 4
				helper_f4ec8310()
				event.stop_music(0)
				at = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			at = 6
			vm.wait(6)
		elseif var1 ~= 6 and var1 ~= 7 then
			at = 7
			helper_826a3ea7(0)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			at = 8
			helper_fdad3d3b()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			return 0
		end
		if at <= 8 then
			if at <= 3 then
				helper_83f038b5()
			end
			if at <= 6 then
				helper_e6450f0b(0)
			end
			if at <= 7 then
				helper_c99744f1()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_13965fb3()
	helper_30408()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_3426c()
		if var0 == 1 then
			at = 2
			helper_b580d4fc()
			at = 3
			helper_050c9cee(1)
			event.open_event_menu(13, 9)
			at = 4
			vm.wait(4)
			event.skip_next_music_load()
			event.jump_to_map_2(-1, "s10")
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				at = 2
				helper_b580d4fc()
				return vm.continue_with(function()
					at = 3
					helper_050c9cee(1)
					event.open_event_menu(13, 9)
					at = 4
					vm.wait(4)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_050c9cee(1)
				return vm.continue_with(function()
					event.open_event_menu(13, 9)
					at = 4
					vm.wait(4)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 14000, which map data, a script or the engine runs by number.
function script.event_14000()
	helper_13965fb3()
	helper_c21b6dfd()
end

--- Event 14520, which map data, a script or the engine runs by number.
function script.event_14520()
	local at: number = 0
	return vm.guard(function()
		helper_13965fb3()
		at = 1
		helper_b580d4fc()
		at = 2
		helper_050c9cee(1)
		event.open_event_menu(13, 9)
		at = 3
		vm.wait(3)
		event.skip_next_music_load()
		event.jump_to_map_2(-1, "s10")
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_050c9cee(1)
				return vm.continue_with(function()
					event.open_event_menu(13, 9)
					at = 3
					vm.wait(3)
					event.skip_next_music_load()
					event.jump_to_map_2(-1, "s10")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
