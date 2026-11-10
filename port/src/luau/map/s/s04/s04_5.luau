--!strict
-- map/s/s04/s04_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c718064 = require("@lib/event/helper_0c718064")
local helper_0d806bce = require("@lib/event/helper_0d806bce")
local helper_1352f985 = require("@lib/event/helper_1352f985")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_1edf2b0f = require("@lib/event/helper_1edf2b0f")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_64a94650 = require("@lib/event/helper_64a94650")
local helper_7f0ede20 = require("@lib/event/helper_7f0ede20")
local helper_7f95a402 = require("@lib/event/helper_7f95a402")
local helper_826a3ea7 = require("@lib/event/helper_826a3ea7")
local helper_83f038b5 = require("@lib/event/helper_83f038b5")
local helper_89d22243 = require("@lib/event/helper_89d22243")
local helper_918c322c = require("@lib/event/helper_918c322c")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_9e09c6bc = require("@lib/event/helper_9e09c6bc")
local helper_ad46c277 = require("@lib/event/helper_ad46c277")
local helper_b79fe662 = require("@lib/event/helper_b79fe662")
local helper_b9d220f5 = require("@lib/event/helper_b9d220f5")
local helper_c6cfe9e9 = require("@lib/event/helper_c6cfe9e9")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_c99744f1 = require("@lib/event/helper_c99744f1")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local helper_d7ee9abb = require("@lib/event/helper_d7ee9abb")
local helper_e2123063 = require("@lib/event/helper_e2123063")
local helper_e5f03808 = require("@lib/event/helper_e5f03808")
local helper_e6450f0b = require("@lib/event/helper_e6450f0b")
local helper_f4ec8310 = require("@lib/event/helper_f4ec8310")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_f6012ebc = require("@lib/event/helper_f6012ebc")
local helper_fab38133 = require("@lib/event/helper_fab38133")
local helper_fdad3d3b = require("@lib/event/helper_fdad3d3b")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_3076c()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 33
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e300/e372/e372_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e372/e372_monica.gltf", "info", global1)
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
		event.load_character_motion_pack(5, "event/e300/e372/e372_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e300/e372/e372_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "chara/p01_03a.gltf", "info", 35)
	event.attach_object_handle_to_character(2, 35)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 35)
	event.load_message_file(0, 5, "event/e300/e372/e372_1.txt")
	event.set_scene_status_flags(1, global0, 256, 1)
	event.set_scene_status_flags(1, global1, 256, 1)
end

--- Helper function.
local function helper_304b8()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(35)
end

--- Helper function.
local function helper_31564()
	vm.section(function()
		event.set_character_active(0, 24)
		event.set_save_flag(372, 1)
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(20, "p01_train01")
		event.set_object_handle_position(20, 0.0, 0.0, 400.0)
		helper_3076c()
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.stop_music(0)
		wait_frames(4)
		event.load_music(49)
		event.play_music(0)
		event.enable_drama_skip()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 35)
		event.set_camera_sequence_position(-940.17, 88.71, -222.08)
		event.set_camera_sequence_look_at(-788.53, 51.39, -202.38)
		event.set_object_sequence_position(0, -802.48, 0.0, -185.61)
		event.set_object_sequence_rotation(0, 0.0, 1.5, 0.0)
		event.set_object_sequence_position(1, -799.79, 0.0, -228.07)
		event.set_object_sequence_rotation(1, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(2, -126.08, 36.0, -149.46)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.fade_in_screen(15)
		event.set_object_sequence_motion(0, "走り", 0)
		event.set_object_sequence_motion(1, "走り", 0)
		event.move_object_sequence(0, -647.07, 0.0, -165.42, 60)
		event.move_object_sequence(1, -636.31, 0.0, -204.74, 60)
		wait_objects(0)
		event.set_camera_sequence_position(-243.89, 55.02, -207.96)
		event.set_camera_sequence_look_at(-152.87, 61.42, -156.97)
		event.set_object_sequence_position(0, -207.98, 36.0, -142.65)
		event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
		event.set_object_sequence_position(1, -209.43, 36.0, -161.14)
		event.set_object_sequence_rotation(1, 0.0, 1.56, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.move_object_sequence(0, -155.54, 36.0, -140.71, 75)
		event.move_object_sequence(1, -153.89, 36.0, -159.09, 75)
		event.set_mouth_texture_animations(2, "口パク")
		helper_1584c528(3720500, 60)
		event.reset_mouth_texture_animations()
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_camera_sequence_position(-196.14, 62.27, -152.87)
		event.set_camera_sequence_look_at(-156.04, 61.42, -151.29)
		event.set_object_sequence_position(0, -155.54, 36.0, -140.71)
		event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
		event.set_object_sequence_position(1, -153.89, 36.0, -159.09)
		event.set_object_sequence_rotation(1, 0.0, 1.56, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "会話2", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "口パク")
		helper_4116e6bb(3720505)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	if global0 == 0 then
		event.set_character_position(0, -155.54, 36.0, -140.71)
	else
		event.set_character_position(0, -153.89, 36.0, -159.09)
	end
	helper_304b8()
	event.set_character_active(1, 24)
	event.fade_in_screen(30)
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
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		helper_fab38133()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, -357.0, 0.0, -206.0)
			event.set_character_rotation(0, 0.0, -1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 3.14, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			var2 = event.get_map_type(old_map_no) or var2
			if var2 ~= -1 then
				if old_map_no == 1 then
					at = 1
					helper_e2123063()
				elseif old_map_no ~= 18 and old_map_no ~= 23 and old_map_no ~= 120 and old_map_no ~= 108 then
					flag = event.get_save_flag(283) or flag
					flag_2 = event.get_save_flag(300) or flag_2
					if flag == 1 and flag_2 == 0 then
						event.set_villager_ai_enabled(0, 24)
						event.set_villager_ai_enabled(0, 25)
						event.set_villager_ai_enabled(0, 26)
						at = 2
						helper_0d806bce()
						helper_b79fe662()
						event.set_villager_ai_enabled(1, 24)
						event.set_villager_ai_enabled(1, 25)
						event.set_villager_ai_enabled(1, 26)
					else
						event.set_character_active(0, 25)
						var5 = event.get_chapter() or var5
						if var5 ~= 6 and var5 ~= 7 then
							at = 3
							helper_9e09c6bc()
						else
							at = 4
							helper_918c322c()
						end
						event.set_character_active(25)
					end
				else
					var6 = event.get_save_counter(1) or var6
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and var6 == 3
					then
						helper_946c0402()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						var7 = event.get_chapter() or var7
						if var7 ~= 6 and var7 ~= 7 then
							at = 5
							helper_9e09c6bc()
						else
							at = 6
							helper_918c322c()
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
			end
		end
		return
	end, function(received: { any })
		if at <= 6 then
			if at <= 1 then
				at = 2
				helper_0d806bce()
				return vm.continue_with(function()
					helper_b79fe662()
					event.set_villager_ai_enabled(1, 24)
					event.set_villager_ai_enabled(1, 25)
					event.set_villager_ai_enabled(1, 26)
					return
				end)
			end
			if at <= 2 then
				helper_1ef0d4b2()
				at = 3
				helper_9e09c6bc()
				return vm.continue_with(function()
					event.set_character_active(25)
					return
				end)
			end
			if at <= 3 then
				helper_7f95a402()
			end
			if at <= 4 then
				helper_d7295df9()
				at = 5
				helper_9e09c6bc()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 5 then
				helper_7f95a402()
			end
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local var0: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_2(3200) or var0
	vm.wait(1)
	helper_c956b4a2(64)
	event.play_sound_effect(var0, 8)
	vm.wait(3)
	helper_c956b4a2(64)
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
		event.set_save_counter(1, 3)
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
	if helper_b9d220f5() ~= 0 then
		event.jump_to_map_3(-1, "g02", 100)
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_fab38133()
	helper_31564()
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_0c718064(3)
	helper_fab38133()
	event.set_villager_ai_enabled(0, 24)
	event.set_villager_ai_enabled(0, 25)
	event.set_villager_ai_enabled(0, 26)
	helper_0d806bce()
	helper_b79fe662()
	event.set_villager_ai_enabled(1, 24)
	event.set_villager_ai_enabled(1, 25)
	event.set_villager_ai_enabled(1, 26)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(14) or var0
		if var0 == 1 then
			at = 1
			var1 = helper_7f0ede20()
			if var1 == 1 then
				at = 2
				helper_d7ee9abb()
				at = 3
				helper_89d22243()
				event.open_event_menu(13, 8)
				at = 4
				vm.wait(4)
				event.jump_to_map_2(-1, "s09")
			end
		end
		if var0 == 2 then
			at = 5
			helper_c6cfe9e9()
		end
		if var0 == 13 then
			at = 6
			helper_1352f985()
		end
		if var0 == 301 then
			at = 7
			helper_1edf2b0f()
		end
		return
	end, function(received: { any })
		if at <= 7 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				at = 2
				helper_d7ee9abb()
				return vm.continue_with(function()
					at = 3
					helper_89d22243()
					event.open_event_menu(13, 8)
					at = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s09")
					if var0 == 2 then
						at = 5
						helper_c6cfe9e9()
					end
					if var0 == 13 then
						at = 6
						helper_1352f985()
					end
					if var0 == 301 then
						at = 7
						helper_1edf2b0f()
					end
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_89d22243()
				return vm.continue_with(function()
					event.open_event_menu(13, 8)
					at = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s09")
					if var0 == 2 then
						at = 5
						helper_c6cfe9e9()
					end
					if var0 == 13 then
						at = 6
						helper_1352f985()
					end
					if var0 == 301 then
						at = 7
						helper_1edf2b0f()
					end
					return
				end)
			end
			if at <= 4 then
				helper_64a94650()
			end
			if at <= 5 then
				helper_ad46c277()
			end
			if at <= 6 then
				helper_e5f03808()
			end
			return 0
		end
		return nil
	end)
end

--- Event 13000, which map data, a script or the engine runs by number.
function script.event_13000()
	helper_fab38133()
	event.set_villager_ai_enabled(0, 24)
	event.set_villager_ai_enabled(0, 25)
	event.set_villager_ai_enabled(0, 26)
	helper_0d806bce()
	helper_b79fe662()
	event.set_villager_ai_enabled(1, 24)
	event.set_villager_ai_enabled(1, 25)
	event.set_villager_ai_enabled(1, 26)
end

--- Event 13600, which map data, a script or the engine runs by number.
function script.event_13600()
	local at: number = 0
	return vm.guard(function()
		helper_fab38133()
		at = 1
		helper_d7ee9abb()
		at = 2
		helper_89d22243()
		event.open_event_menu(13, 8)
		at = 3
		vm.wait(3)
		event.jump_to_map_2(-1, "s09")
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_89d22243()
				return vm.continue_with(function()
					event.open_event_menu(13, 8)
					at = 3
					vm.wait(3)
					event.jump_to_map_2(-1, "s09")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
