--!strict
-- map/g/g03/g03_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0855dba8 = require("@lib/event/helper_0855dba8")
local helper_0befff3d = require("@lib/event/helper_0befff3d")
local helper_2348941a = require("@lib/event/helper_2348941a")
local helper_379e93c0 = require("@lib/event/helper_379e93c0")
local helper_3e566142 = require("@lib/event/helper_3e566142")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_5bdac642 = require("@lib/event/helper_5bdac642")
local helper_683d6a71 = require("@lib/event/helper_683d6a71")
local helper_6be25ed2 = require("@lib/event/helper_6be25ed2")
local helper_915f68a8 = require("@lib/event/helper_915f68a8")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_b2a07125 = require("@lib/event/helper_b2a07125")
local helper_b2c84d73 = require("@lib/event/helper_b2c84d73")
local helper_b794551c = require("@lib/event/helper_b794551c")
local helper_ca212701 = require("@lib/event/helper_ca212701")
local helper_ebc222ab = require("@lib/event/helper_ebc222ab")
local helper_f20e2c61 = require("@lib/event/helper_f20e2c61")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_1aab4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(-1.39)) * 30.0) + var0)
	var4 = var1
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(-1.39)) * 30.0) + var2)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, var3, var4, var5, 30, 1)
	event.turn_object_sequence_toward(0, var3, var4, var5, 10)
	event.set_object_sequence_motion(0, "歩き")
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.set_camera_look_at(var0, var1, var2)
		var6 = var6 + 1
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Cos'[UNI00e8] stato quel grido?\nIniziamo a cercare nella\ncaverna, d'accordo?")
	show_message(0, -1, 5, 256, 208)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_3e566142

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local old_sub_map_no: s32 = 0
	local var5: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local get_old_interior_map_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		helper_3e566142()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			helper_9dafbc83(vm.f32(1832.4), vm.f32(-5.2), vm.f32(-406.6), vm.f32(-1.16))
			event.reset_follow_camera(1, 0.0, 10.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			var2 = event.get_map_type(old_map_no) or var2
			print("old_map = ", old_map_no, "\n")
			print("old_map_type = ", var2, "\n")
			if var2 ~= -1 then
				if var2 == 7 or var2 == 8 or old_map_no == 84 then
					at = 1
					helper_2348941a()
				else
					var3 = 0
					if old_map_no == 82 then
						helper_9dafbc83(-140.0, 165.0, 1865.0, vm.f32(2.28))
						event.reset_follow_camera(1, 0.0, 10.0)
						event.fade_in_screen(30)
						var3 = 1
					end
					if old_map_no == 75 then
						at = 2
						helper_379e93c0()
						var3 = 1
					end
					old_sub_map_no = event.get_previous_submap() or old_sub_map_no
					var5 = event.get_map_type(old_sub_map_no) or var5
					if var3 == 0 and not (old_map_no == 2 and var5 == 2) then
						flag = event.get_save_flag(402) or flag
						flag_2 = event.get_save_flag(360) or flag_2
						if flag == 0 and flag_2 == 1 then
							at = 3
							helper_683d6a71()
						else
							at = 4
							helper_915f68a8()
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				get_old_interior_map_no = event.get_previous_interior_map() or get_old_interior_map_no
				if 0 <= get_old_interior_map_no then
				else
					at = 5
					helper_915f68a8()
				end
			end
		end
		at = 6
		helper_5bdac642(1)
		return
	end, function(received: { any })
		if at <= 6 then
			if at <= 1 then
				var3 = 0
				helper_43f02c95(-140.0, 165.0, 1865.0, vm.f32(2.28))
				var3 = 1
				helper_0855dba8()
			end
			if at <= 2 then
				var3 = 1
				at = 3
				helper_683d6a71()
				return vm.continue_with(function()
					at = 6
					helper_5bdac642(1)
					return
				end)
			end
			if at <= 3 then
				helper_b2a07125()
			end
			if at <= 4 then
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				helper_b2a07125()
			end
			if at <= 5 then
				helper_ebc222ab(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_915f68a8

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local flag: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var7: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	flag = event.get_save_flag(404) or flag
	if flag == 0 then
		helper_1aab4()
	elseif helper_0befff3d() ~= 0 then
		event.set_dungeon_stage_id(3)
		event.open_event_menu(3, 3)
		vm.wait(3)
		do
			local _, out2, out3, _ = event.get_menu_results_4()
			var2 = out2 or var2
			var3 = out3 or var3
		end
		if var3 == 0 then
			helper_2348941a()
			return
		end
		if var3 == 20 then
			flag_2 = event.get_save_flag(438) or flag_2
			flag_3 = event.get_save_flag(444) or flag_3
			if flag_2 == 1 and flag_3 == 0 then
				event.go_to_dungeon(3, var3, 1010)
			else
				var2 = 3
				var3 = 20
				var7 = event.get_dungeon_floor_info(var2, var3, 7) or var7
				var7 = vm.i32(var7 + 1)
				event.set_dungeon_floor_info(var2, var3, 7, var7)
				event.jump_to_map_3(-1, "d04b01", 100)
			end
		else
			flag_4 = event.get_save_flag(406) or flag_4
			flag_5 = event.get_save_flag(424) or flag_5
			if var3 == 2 and flag_4 == 0 or var3 == 17 and flag_5 == 0 or var3 == 19 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(3, var3, 1010)
		end
	end
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local flag: s32 = 0
	if helper_f20e2c61() ~= 0 then
		flag = event.get_save_flag(404) or flag
		if flag == 0 then
			event.skip_next_music_load()
		end
		event.jump_to_map_2(-1, "s27")
	end
end

--- Event 203, which map data, a script or the engine runs by number.
function script.event_203()
	if helper_ca212701() ~= 0 then
		event.jump_to_map_2(-1, "s09")
	end
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_b2c84d73(vm.f32(-136.7), 165.0, vm.f32(1866.8), 0.0)
	event.jump_to_map_2(-1, "f03")
	vm.wait(2)
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_5bdac642(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_3e566142()
	helper_b794551c()
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_3e566142()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, 1425.7, 0.0, 1034.8)
	event.set_character_rotation(0, 0.0, -2.37, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local var0: s32 = 0
	helper_3e566142()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, -140.0, 165.0, 1800.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	var0 = helper_6be25ed2()
	if var0 == 0 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(0, "[(!)]Soddisfa i requisiti Diorama e attiva il\n   laboratorio Centrale del Lab-lunatica.")
		show_message(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
	end
	helper_5bdac642(1)
end

--- Event 14020, which map data, a script or the engine runs by number.
function script.event_14020()
	helper_3e566142()
	helper_683d6a71()
end

return script
