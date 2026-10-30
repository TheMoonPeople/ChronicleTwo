--!strict
-- map/d/d04/b01/d04b01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_240f7986 = require("@lib/event/helper_240f7986")
local helper_36b01e20 = require("@lib/event/helper_36b01e20")
local helper_47084b1b = require("@lib/event/helper_47084b1b")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7d755610 = require("@lib/event/helper_7d755610")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_80ad60c2 = require("@lib/event/helper_80ad60c2")
local helper_97d79c37 = require("@lib/event/helper_97d79c37")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a7f38474 = require("@lib/event/helper_a7f38474")
local helper_a9347261 = require("@lib/event/helper_a9347261")
local helper_baeaba52 = require("@lib/event/helper_baeaba52")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_cafda747 = require("@lib/event/helper_cafda747")
local helper_ee5ecb83 = require("@lib/event/helper_ee5ecb83")
local helper_f0ee9a01 = require("@lib/event/helper_f0ee9a01")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_f86d86cb = require("@lib/event/helper_f86d86cb")
local helper_fd86b417 = require("@lib/event/helper_fd86b417")
local helper_fe7a8356 = require("@lib/event/helper_fe7a8356")
local interpolate = require("@lib/event/interpolate")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.stop_music(0)
	helper_f86d86cb()
	flag = event.get_save_flag(438) or flag
	flag_2 = event.get_save_flag(444) or flag_2
	event.attach_object_handle_to_map_part_2(0, "p01_battleship")
	if flag == 1 and flag_2 == 0 then
		event.set_object_handle_visible(0, 1)
	else
		event.set_object_handle_visible(0, 0)
	end
end

--- Helper function.
local function helper_31e24(arg0: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local player_chara: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local angle: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local angle_2: f32 = 0
	local angle_3: f32 = 0
	local angle_4: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local rot_y: f32 = 0
	local rot_y_2: f32 = 0
	local var29: s32 = 0
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	player_chara = event.get_player_character_slot() or player_chara
	do
		local out1, out2, out3 = event.get_character_position(player_chara)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, _, out3 = event.get_character_position(arg0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local _, out2, _ = event.get_character_rotation(player_chara)
		var17 = out2 or var17
	end
	var18 = event.get_look_angle(var11 - var8, var13 - var10) or var18
	angle = vm.f32(var18 - var17)
	angle = event.wrap_angle(angle) or angle
	do
		local _, out2, _ = event.get_character_rotation(arg0)
		var20 = out2 or var20
	end
	var21 = event.get_look_angle(var8 - var11, var10 - var13) or var21
	angle_2 = vm.f32(var21 - var20)
	angle_2 = event.wrap_angle(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.set_character_motion(player_chara, "立ち")
	else
		event.set_character_motion(player_chara, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.set_character_motion(arg0, "歩き")
	end
	event.clear_camera_sequence()
	if arg0 == 13 or arg0 == 14 or arg0 == 15 then
		event.set_camera_sequence_look_at(var8, var9 + 63.0, var10)
		angle_3 = vm.f32(var21 - vm.f32(0.73))
		angle_3 = event.wrap_angle(angle_3) or angle_3
		event.set_camera_sequence_angle_height_distance(angle_3, 41.5, 179.0)
	else
		event.set_camera_sequence_look_at(var8, var9 + 130.0, var10)
		angle_4 = vm.f32(var21 - vm.f32(0.73))
		angle_4 = event.wrap_angle(angle_4) or angle_4
		event.set_camera_sequence_angle_height_distance(angle_4, 45.0, 468.0)
	end
	var25 = 0.0
	var26 = vm.f32(helper_baeaba52(helper_05ce8bed(angle), helper_05ce8bed(angle_2)) * 8.0)
	while var25 < var26 do
		rot_y = interpolate(0.0, angle, var25, var26)
		rot_y = vm.f32(rot_y + var17)
		event.set_character_rotation(player_chara, 0.0, rot_y, 0.0)
		rot_y_2 = interpolate(0.0, angle_2, var25, var26)
		rot_y_2 = vm.f32(rot_y_2 + var20)
		event.set_character_rotation(arg0, 0.0, rot_y_2, 0.0)
		var25 = vm.f32(var25 + 1.0)
		vm.wait(1)
	end
	event.set_character_rotation(player_chara, 0.0, var18, 0.0)
	event.set_character_motion(player_chara, "立ち")
	event.attach_object_handle_to_character(0, arg0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_rotation(0, 0.0, var21, 0.0)
	event.set_object_sequence_motion(0, "会話入り", 6)
	event.queue_object_sequence_next_motion(0, "会話L", 4)
	wait_objects(0)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	if arg0 == 8 then
		event.open_message_window_2(0, "Das k[UNI00f6]nnte bei meinen\nWunden auch helfen.\nNa komm, hilf mir mal!")
	end
	if arg0 == 9 then
		event.open_message_window_2(0, "Willkommen im Shigura-Dorf.\nEinen sch[UNI00f6]nen Aufenthalt!")
	end
	if arg0 == 10 then
		event.open_message_window_2(0, "Das ist unser Dorf[UNI00e4]ltester.\nZeig dein bestes Benehmen, bitte.")
	end
	if arg0 == 11 then
		event.open_message_window_2(0, "Wir sind ein Wandervolk,\njedes Jahr machen wir die lange\nReise, um hierher zu kommen.")
	end
	if arg0 == 12 then
		event.open_message_window_2(
			0,
			"Hier erholen wir uns von den\nStrapazen unserer Reise.\nSei also bitte sch[UNI00f6]n leise."
		)
	end
	if arg0 == 13 or arg0 == 14 or arg0 == 15 then
		var29 = vm.float_bits(event.get_random_number(10)) or var29
		if var29 == 0 then
			event.open_message_window_2(0, "Aiaaiii!!")
		end
		if var29 == 1 then
			event.open_message_window_2(0, "Aaiiiii")
		end
		if var29 == 2 then
			event.open_message_window_2(0, "Erraaah")
		end
		if var29 == 3 then
			event.open_message_window_2(0, "Aaaai!")
		end
		if var29 == 4 then
			event.open_message_window_2(0, "Au au aaaauuuuu!")
		end
		if var29 == 5 then
			event.open_message_window_2(0, "Raaaaaahr")
		end
		if var29 == 6 then
			event.open_message_window_2(0, "Rauuuoooo")
		end
		if var29 == 7 then
			event.open_message_window_2(0, "Raaauuu")
		end
		if var29 == 8 then
			event.open_message_window_2(0, "Raaaahr?")
		end
		if var29 == 9 then
			event.open_message_window_2(0, "Raaaahr!")
		end
	end
	helper_75684dd8(0, -1, 6, 170, 0)
	event.set_object_sequence_motion(0, "会話戻り", 2)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	wait_objects(0)
	event.finish_event()
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.start_crossfade(10)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local argc: s32 = 0
	event_99()
	event.fade_out_screen(0)
	event.set_save_control_bits(16, 1)
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		helper_7d7eee8f(1900.0, 0.0, -330.0, 0.0)
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
		return
	end
	flag = event.get_save_flag(400) or flag
	if flag == 1 then
		flag_2 = event.get_save_flag(438) or flag_2
		flag_3 = event.get_save_flag(432) or flag_3
		flag_4 = event.get_save_flag(436) or flag_4
		flag_5 = event.get_save_flag(444) or flag_5
		if flag_2 == 0 and (flag_3 == 0 and flag_4 == 0) then
			argc = event.get_owned_item_count(373) or argc
			if argc >= 1 then
				helper_36b01e20()
				return
			else
				helper_cafda747()
				return
			end
		end
		if flag_2 == 1 and flag_5 == 0 then
			event.set_save_control_bits(16, 0)
			helper_ee5ecb83()
			vm.wait(4)
			event.set_save_control_bits(1, 1)
			event.load_dungeon_monster(514, 1)
			event.load_dungeon_monster(522, 0)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
				0.0,
				0.5235988,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
				0.0,
				1.5707964,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
				0.0,
				2.617994,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
				0.0,
				-2.617994,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
				0.0,
				-1.5707964,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
				0.0,
				-0.5235988,
				0.0
			)
			event.place_dungeon_monster(522, 186.17, 130.0, 141.45)
			helper_9dafbc83(250.0, 0.0, 250.0, 0.0)
			event.set_camera_look_at(250.0, 30.0, 250.0)
			event.set_camera_position(250.0, 40.0, 130.0)
			event.reset_follow_camera(0)
			event.fade_in_screen(30)
			event.finish_event()
			return
		end
	end
	helper_a9347261()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_36b01e20

--- Event 170, which map data, a script or the engine runs by number.
function script.event_170()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var2: s32 = 0
	if helper_fe7a8356() ~= 0 then
		event.set_dungeon_stage_id(3)
		event.open_event_menu(3, 3)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			var2 = out3 or var2
		end
		if var2 == 20 then
			event.fade_in_screen(30)
			return
		end
		helper_7d755610()
		event.set_save_control_bits(16, 0)
		if var2 == 0 then
			event.jump_to_map_3(-1, "g03", 100)
		else
			event.go_to_dungeon(3, var2, 1010)
		end
		vm.wait(3)
		return
	end
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.clear_event_battle_monsters(-1)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var1 = event.get_dungeon_floor() or var1
		event.set_dungeon_floor_info(stage_id, var1, 5, 2)
		at = 2
		helper_240f7986()
		event.remove_item(373)
		event.set_save_control_bits(16, 0)
		event.set_save_control_bits(1, 0)
		event.go_to_georama_edit(2, 520)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_240f7986()
				return vm.continue_with(function()
					event.remove_item(373)
					event.set_save_control_bits(16, 0)
					event.set_save_control_bits(1, 0)
					event.go_to_georama_edit(2, 520)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_a7f38474()
	event.set_character_position(0, 400.0, 0.0, 30.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(0)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local flag: s32 = 0
	var0 = 0
	var1 = event.get_triggered_event_data_2(9) or var1
	var2 = event.compare_map_parts_place_name(var1, "p01_otona") or var2
	if var2 == 0 then
		var0 = 8
	end
	var2 = event.compare_map_parts_place_name(var1, "p01_otona-1") or var2
	if var2 == 0 then
		var0 = 9
	end
	var2 = event.compare_map_parts_place_name(var1, "p01_otona-2") or var2
	if var2 == 0 then
		var0 = 10
	end
	var2 = event.compare_map_parts_place_name(var1, "p01_otona-3") or var2
	if var2 == 0 then
		var0 = 11
	end
	var2 = event.compare_map_parts_place_name(var1, "p01_otona-4") or var2
	if var2 == 0 then
		var0 = 12
	end
	var2 = event.compare_map_parts_place_name(var1, "p01_kodomo") or var2
	if var2 == 0 then
		var0 = 13
	end
	var2 = event.compare_map_parts_place_name(var1, "p01_kodomo-1") or var2
	if var2 == 0 then
		var0 = 14
	end
	var2 = event.compare_map_parts_place_name(var1, "p01_kodomo-2") or var2
	if var2 == 0 then
		var0 = 15
	end
	if var0 == 0 then
		return
	end
	argc = event.get_owned_item_count(373) or argc
	if argc <= 0 then
		helper_fd86b417(var0)
		return
	end
	if var0 == 8 then
		flag = event.get_save_flag(434) or flag
		if flag == 0 then
			event.add_inventory_item(375)
			helper_97d79c37()
			return
		end
	end
	helper_31e24(var0)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(440) or flag
		flag_2 = event.get_save_flag(444) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var2 = vm.float_bits(event.get_random_number(100)) or var2
			if var2 < 50 then
				at = 1
				helper_47084b1b(0, 8620060)
			else
				at = 2
				helper_47084b1b(0, 8620070)
			end
			return
		end
		at = 3
		helper_f0ee9a01(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_80ad60c2(0, 8620070)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 14400, which map data, a script or the engine runs by number.
function script.event_14400()
	event.set_save_flag(438, 1)
	event_99()
	helper_ee5ecb83()
end

--- Event 14440, which map data, a script or the engine runs by number.
function script.event_14440()
	helper_240f7986()
	event.go_to_georama_edit(2, 520)
	vm.wait(2)
end

--- Event 24020, which map data, a script or the engine runs by number.
function script.event_24020()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(34)
	event.play_music(0)
	event.load_dungeon_monster(514, 1)
	event.load_dungeon_monster(522, 0)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
		0.0,
		0.5235988,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
		0.0,
		1.5707964,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
		0.0,
		2.617994,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
		0.0,
		-2.617994,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
		0.0,
		-1.5707964,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
		0.0,
		-0.5235988,
		0.0
	)
	event.place_dungeon_monster(522, 186.17, 130.0, 141.45)
	vm.wait(3)
	event.finish_event()
end

return script
