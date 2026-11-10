--!strict
-- map/m/m01/m01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_18d9c3c9 = require("@lib/event/helper_18d9c3c9")
local helper_240a0227 = require("@lib/event/helper_240a0227")
local helper_2a9040b5 = require("@lib/event/helper_2a9040b5")
local helper_4bb05a47 = require("@lib/event/helper_4bb05a47")
local helper_4f6571ec = require("@lib/event/helper_4f6571ec")
local helper_6082cadd = require("@lib/event/helper_6082cadd")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a3a848ae = require("@lib/event/helper_a3a848ae")
local helper_a981053a = require("@lib/event/helper_a981053a")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_b8d9d9d0 = require("@lib/event/helper_b8d9d9d0")
local helper_e6998a9e = require("@lib/event/helper_e6998a9e")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_f9b4fb5f = require("@lib/event/helper_f9b4fb5f")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Event 248, which map data, a script or the engine runs by number.
local function event_248()
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	show_message(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 1)
end

--- Helper function.
local function helper_4604c()
	local var0: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local at: number = 0
	return vm.guard(function()
		print("00000000000000000000000000\n")
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_motion(0, "立ち", 4)
		event.set_message_window_mode(0, 5)
		var0 = event.get_menu_value_2(1) or var0
		if var0 == 1 then
			event.open_message_window_2(0, "Aller au Tournoi de p[UNI00ea]che ?")
		else
			event.open_message_window_2(0, "Aller aux Meilleures nageoires ?")
		end
		print("11111111111111111111111111111111\n")
		at = 1
		var1 = helper_ac02d4a5(0, -1, 8, 256, 208, 2, 1)
		if var1 == 0 then
			event.set_camera_sequence_position(1332.56, 67.86, 1494.1)
			event.set_camera_sequence_look_at(1508.0, 12.6, 1425.04)
			event.move_camera_sequence_eased(1332.56, 97.86, 1494.1, 1508.0, 42.6, 1425.04, 48, 2, 0.4)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			do
				local out1, out2, _ = event.get_character_position(0)
				var2 = out1 or var2
				var3 = out2 or var3
			end
			event.set_object_sequence_position(0, var2, var3, 1415.0)
			event.set_object_sequence_rotation(0, 0.0, 1.57, 0.0)
			event.move_object_sequence(0, 1800.0, var3, 1415.0, 90)
			at = 2
			wait_frames(15)
			event.fade_out_screen(30)
			at = 3
			wait_frames(30)
			return 1
		end
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 15)
		at = 4
		wait_frames(15)
		do
			local _, out2, out3 = event.get_character_position(0)
			var6 = out2 or var6
			var7 = out3 or var7
		end
		event.move_object_sequence(0, 1480.0, var6, var7, 45)
		at = 5
		wait_frames(45)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				wait_frames_skipping(15)
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			return 1
		end
		if at <= 5 then
			if at <= 4 then
				wait_frames_skipping(45)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_23b80()
	local var0: s32 = 0
	local var1: s32 = 0
	var0 = event.get_quest_request_status(0, 8) or var0
	if var0 == 1 then
		var1 = event.get_save_counter(12) or var1
		if 0 < var1 then
			if var1 == 1 then
				event.set_save_counter(12, 2)
			end
			helper_18d9c3c9(0, vm.f32(-1.57))
			set_window_mode(0, 1)
			event.open_message_window_2(
				0,
				'Il y a un petit mot :<page>"La soir[UNI00e9]e est annul[UNI00e9]e parce\n que le fromage n\'est pas assez [UNI00e9]pais.\n                          Ferdinand"'
			)
			show_message(0, -1, 5, 256, 208)
			event.request_town_edit_event(1)
			vm.wait(3)
		end
	end
end

--- Event 530, which map data, a script or the engine runs by number.
local function event_530()
	event.set_function_point_enabled("p01_e01g01-0", "invent_36-0", 1)
	helper_a3a848ae()
	event.set_camera_position(345.12, 84.74, -31.95)
	event.set_camera_look_at(351.66, 70.52, 137.18)
	event.set_character_position(0, 350.13, 52.0, 148.02)
	event.set_character_rotation(0, 0.0, -3.12, 0.0)
	event.skip_next_music_play()
	vm.wait(2)
	event.go_to_interior_map(-1, "i01h01", 500, 1)
	vm.wait(3)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_b8d9d9d0

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local var8: s32 = 0
	local old_map_no: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local flag_6: s32 = 0
	local get_old_interior_map_no: s32 = 0
	helper_b8d9d9d0()
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		flag = event.get_save_flag(736) or flag
		flag_2 = event.get_save_flag(800) or flag_2
		if flag == 1 and flag_2 == 0 then
			event.fade_out_screen(0)
			helper_4f6571ec()
			event.set_save_data_value(0, 10)
			event.stop_all_sounds()
			event.set_sound_reverb_enabled(0)
			event.show_chapter_title(8)
			vm.wait(2)
			event.set_sound_reverb_enabled(1)
			event.load_map_sounds(1000)
			var3 = event.get_default_music_number(10) or var3
			event.load_music(var3)
			event.play_music(0)
			event.set_music_volume_follows_time_of_day(1)
			event.set_character_position(0, 1640.0, -48.8, -1700.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.reset_follow_camera(1, 0.0, 10.0)
			event.fade_in_screen(30)
			return
		end
		var4 = event.get_save_counter(4) or var4
		if var4 == 0 then
			event.set_character_position(0, 560.0, 4.1, 120.0)
			event.set_character_rotation(0, 0.0, 3.14, 0.0)
		end
		if var4 == 1 then
			event.set_character_position(0, 2095.0, 0.0, 2100.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
		end
		if var4 == 2 then
			event.set_character_position(0, -4260.0, 350.0, 2810.0)
			event.set_character_rotation(0, 0.0, 2.86, 0.0)
		end
		if var4 == 3 then
			event.set_character_position(0, -3770.0, 359.4, -1640.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
		end
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0, 20.0)
	else
		flag_3 = event.get_save_flag(105) or flag_3
		flag_4 = event.get_save_flag(109) or flag_4
		flag_5 = event.get_save_flag(56) or flag_5
		if flag_3 ~= 0 and flag_4 == 0 and flag_5 == 0 then
			event.get_active_music_number(var8)
			event.get_music_master_volume()
			if var8 ~= 10 then
				event.fade_out_screen(0)
				event.load_map_sounds(1000)
				var8 = event.get_default_music_number(10) or var8
				event.stop_music(0)
				wait_frames(4)
				event.load_music(var8)
				event.play_music(0)
				event.set_save_flag(56, 1)
				event.set_music_volume_follows_time_of_day(1)
				event.fade_in_screen(30)
			end
		end
		old_map_no = event.get_previous_map() or old_map_no
		var11 = event.get_map_type(old_map_no) or var11
		if var11 ~= -1 then
			if var11 == 7 or var11 == 8 then
				helper_9dafbc83(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
				event.reset_follow_camera(1, 0.0, 10.0)
			else
				var12 = 1
				flag_6 = event.get_save_flag(40) or flag_6
				if flag_6 == 1 then
					if old_map_no == 34 then
						var12 = 0
						event.set_character_position(0, 1645.1, -41.3, -1812.6)
						event.set_character_rotation(0, 0.0, -0.09, 0.0)
						event.reset_follow_camera(1)
					end
					if old_map_no == 22 then
						var12 = 0
						helper_6082cadd()
					end
				end
				get_old_interior_map_no = event.get_previous_interior_map() or get_old_interior_map_no
				if 0 <= get_old_interior_map_no then
					var12 = 0
				elseif old_map_no == 121 then
					var12 = 0
					event.set_character_position(0, 1450.0, 0.0, 1420.0)
					event.set_character_rotation(0, 0.0, -1.57, 0.0)
					event.reset_follow_camera(1, 3.1415927)
				end
				if var12 ~= 0 then
					helper_e6998a9e()
				end
			end
		end
	end
	event.set_save_flag(40, 0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_f9b4fb5f

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
		return
	end
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	vm.wait(3)
	event.go_to_interior_map(-1, "i01h01", 100, 1)
	vm.wait(4)
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local at: number = 0
	return vm.guard(function()
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n")
		at = 1
		if helper_4604c() ~= 0 then
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			event.fade_out_screen(0)
			at = 2
			vm.wait(2)
			event.jump_to_map_2(-1, "s45")
			return
		end
		print("ccccccccccccccccccccccccccc\n")
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				local _ = received[1] :: number
			end
			if at <= 1 then
				print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			end
			return 0
		end
		return nil
	end)
end

--- Event 204, which map data, a script or the engine runs by number.
function script.event_204()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
		return
	end
	event.jump_to_map_2(-1, "i02h01")
	vm.wait(3)
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 211, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_211() end

--- Event 212, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_212() end

--- Event 213, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_213() end

--- Event 214, which map data, a script or the engine runs by number.
function script.event_214()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 215, which map data, a script or the engine runs by number.
function script.event_215()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 216, which map data, a script or the engine runs by number.
function script.event_216()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 217, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_217() end

--- Event 218, which map data, a script or the engine runs by number.
function script.event_218()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 219, which map data, a script or the engine runs by number.
function script.event_219()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 220, which map data, a script or the engine runs by number.
function script.event_220()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 221, which map data, a script or the engine runs by number.
function script.event_221()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 222, which map data, a script or the engine runs by number.
function script.event_222()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	else
		helper_23b80()
	end
end

--- Event 223, which map data, a script or the engine runs by number.
function script.event_223()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
	flag = event.get_save_flag(304) or flag
	flag_2 = event.get_save_flag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.skip_next_music_load()
	end
end

script.event_248 = event_248

--- Event 290, which map data, a script or the engine runs by number.
function script.event_290()
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(800) or flag
	if flag == 0 then
		return
	end
	if helper_4bb05a47() ~= 0 then
		event.set_dungeon_stage_id(6)
		event.open_event_menu(3, 6)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			var3 = out3 or var3
		end
		if var3 == 0 then
			event.fade_in_screen(30)
			return
		else
			if var3 == 37 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(6, var3, 1010)
		end
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(15) or var0
	event.set_save_counter(4, var0)
	helper_f57795f8()
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	var1 = event.get_save_counter(7) or var1
	if active_chr_no == 0 and var1 == 1 then
		event.set_save_counter(7, 2)
		event.open_message_window_2(0, "OK ! Retourne vite voir\nle Sh[UNI00e9]rif Blinkhorn.")
	else
		event.open_message_window_2(0, "Si je monte dedans sans permission,\nje me demande si j'aurai des\nprobl[UNI00e8]mes ?")
	end
	show_message(0, -1, 5, 256, 208)
	event.set_message_bubble_tail(0, 1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	if helper_240a0227() ~= 0 then
		event.jump_to_map_3(-1, "d01e01", 100)
	end
end

script.event_530 = event_530

--- Event 531, which map data, a script or the engine runs by number.
function script.event_531()
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.set_camera_position(345.12, 84.74, -31.95)
		event.set_camera_look_at(351.66, 70.52, 137.18)
		event.set_character_position(0, 350.13, 52.0, 148.02)
		event.set_character_rotation(0, 0.0, -3.12, 0.0)
		print("ぞうにまけた---------------------\n")
		at = 1
		vm.wait(1)
		event.go_to_interior_map(-1, "i01h01", 510, 1)
		at = 2
		vm.wait(2)
		print("じゃんぷ------------------\n")
		return
	end, function(received: { any })
		if at <= 2 then
			print("じゃんぷ------------------\n")
			return 0
		end
		return nil
	end)
end

--- Event 540, which map data, a script or the engine runs by number.
function script.event_540()
	helper_a981053a()
	event.skip_villager_loading()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i03h01a", 500)
	vm.wait(2)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local var0: s32 = 0
	local var1: s32 = 0
	local chara_no: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		return
	end
	event.set_camera_position(1300.0, 50.0, 763.0)
	event.set_camera_look_at(1300.0, 30.0, 968.18)
	event.set_character_motion(0, "立ち")
	var1 = event.find_scene_character_slot(50) or var1
	chara_no = vm.i32(var1 + 1)
	event.set_villager_ai_enabled(0, chara_no)
	event.set_villager_ai_enabled(0, var1)
	event.open_message_window_2(0, "H[UNI00e9] ! Il est interdit d'avancer\nau-del[UNI00e0] de la limite.")
	helper_70e4ac93(var1, -1, 0, 0)
	event.open_message_window_2(0, "Si tu ne veux pas avoir d'ennuis,\ntu ferais mieux de faire demi-tour.")
	helper_70e4ac93(chara_no, -1, 0, 0)
	event.fade_out_screen(20)
	wait_frames(20)
	event.set_character_position(0, 1302, 0, 951)
	event.set_character_rotation(0, 0, 3.14, 0)
	event.set_villager_ai_enabled(1, chara_no)
	event.set_villager_ai_enabled(1, var1)
	event.fade_in_screen(20)
end

--- Event 560, which map data, a script or the engine runs by number.
script.event_560 = helper_b8d9d9d0

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		return
	end
	helper_2a9040b5()
end

--- Event 11051, which map data, a script or the engine runs by number.
script.event_11051 = event_530

--- Event 11052, which map data, a script or the engine runs by number.
function script.event_11052()
	event.set_save_flag(105, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11052, 1)
	vm.wait(2)
end

--- Event 11053, which map data, a script or the engine runs by number.
function script.event_11053()
	event.set_save_flag(105, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11053, 1)
	vm.wait(2)
end

--- Event 11060, which map data, a script or the engine runs by number.
function script.event_11060()
	event.set_save_flag(103, 1)
	event.set_save_flag(106, 0)
	event.set_save_flag(107, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11060, 1)
	vm.wait(2)
end

--- Event 11091, which map data, a script or the engine runs by number.
function script.event_11091()
	helper_a981053a()
	event.skip_villager_loading()
	vm.wait(2)
	event.jump_to_map_3(-1, "i03h01a", 500)
	vm.wait(3)
end

--- Event 18000, which map data, a script or the engine runs by number.
function script.event_18000()
	helper_4f6571ec()
	event.set_save_data_value(0, 10)
	event.stop_all_sounds()
	event.set_sound_reverb_enabled(0)
	event.show_chapter_title(8)
	vm.wait(2)
	event.set_sound_reverb_enabled(1)
	event.load_music(0)
	event.load_map_sounds(1000)
	event.play_music(0)
	event.set_character_position(0, 1640.0, -48.8, -1700.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

return script
