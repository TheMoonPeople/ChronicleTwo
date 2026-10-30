--!strict
-- map/g/g02/g02_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0311340e = require("@lib/event/helper_0311340e")
local helper_2e69f380 = require("@lib/event/helper_2e69f380")
local helper_45b56d46 = require("@lib/event/helper_45b56d46")
local helper_47df9e39 = require("@lib/event/helper_47df9e39")
local helper_58610e3d = require("@lib/event/helper_58610e3d")
local helper_5d4cb629 = require("@lib/event/helper_5d4cb629")
local helper_660198d9 = require("@lib/event/helper_660198d9")
local helper_6fd68c14 = require("@lib/event/helper_6fd68c14")
local helper_7581838c = require("@lib/event/helper_7581838c")
local helper_8476c032 = require("@lib/event/helper_8476c032")
local helper_981199f4 = require("@lib/event/helper_981199f4")
local helper_a409b6fa = require("@lib/event/helper_a409b6fa")
local helper_a57b0158 = require("@lib/event/helper_a57b0158")
local helper_a80f4eb9 = require("@lib/event/helper_a80f4eb9")
local helper_ebc222ab = require("@lib/event/helper_ebc222ab")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local show_message = require("@lib/event/show_message")

--- Event 210, which map data, a script or the engine runs by number.
local function event_210()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	event.initialize_event()
	helper_a57b0158()
	var0 = event.get_sound_id(2) or var0
	event.play_sound_effect(var0, 61)
	do
		local out1, out2, out3 = event.get_function_point_position("", "func3")
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var4 = event.get_function_point_rotation("", "func3") or var4
	var4 = vm.f32(var4 - vm.f32(3.1415927))
	var4 = event.wrap_angle(var4) or var4
	event.set_character_position(0, var1, var2, var3)
	event.set_character_rotation(0, 0.0, var4, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_22a04()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local flag: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(-2.76)) * 30.0) + var0)
	var4 = var1
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(-2.76)) * 30.0) + var2)
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
	flag = event.get_save_flag(304) or flag
	if flag == 0 then
		event.open_message_window_2(0, "Puede que haya alguien en la [UNI00fa]ltima\ncasa. Vamos a probar.")
	else
		event.open_message_window_2(0, "Ahora no tenemos tiempo.\n[UNI00a1]Tenemos que ayudar a Lin, r[UNI00e1]pido!")
	end
	show_message(0, -1, 5, 256, 208)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_a57b0158

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local old_sub_map_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		helper_a57b0158()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, 1989.0, 0.0, -198.0)
			event.set_character_rotation(0, 0.0, -1.21, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 3.14, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			var2 = event.get_map_type(old_map_no) or var2
			if var2 ~= -1 then
				if var2 == 7 or var2 == 8 then
					at = 1
					helper_47df9e39()
				elseif old_map_no == 26 then
					event.set_camera_position(-741.9, 50.0, -592.0)
					event.set_camera_look_at(-741.9, 30.0, -712.0)
					event.set_character_position(0, -741.9, 0.0, -712.0)
					event.set_character_rotation(0, 0.0, 0.0, 0.0)
					event.fade_in_screen(30)
				else
					flag = event.get_save_flag(300) or flag
					flag_2 = event.get_save_flag(302) or flag_2
					if flag == 1 and flag_2 == 0 then
						at = 2
						helper_2e69f380()
					else
						at = 3
						helper_0311340e()
					end
				end
			else
				old_sub_map_no = event.get_previous_submap() or old_sub_map_no
				if old_sub_map_no == 100 then
					event_210()
				end
				if old_sub_map_no == -1 then
					event_210()
				end
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				print("--- OLD SUBMAP NO = ", old_sub_map_no, "\n")
			end
		end
		at = 4
		helper_5d4cb629(1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				at = 2
				helper_2e69f380()
				return vm.continue_with(function()
					at = 4
					helper_5d4cb629(1)
					return
				end)
			end
			if at <= 2 then
				helper_8476c032()
			end
			if at <= 3 then
				helper_a409b6fa()
				helper_a409b6fa()
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				print("--- OLD SUBMAP NO = ", old_sub_map_no, "\n")
				helper_ebc222ab(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local now_party_chara_id: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		flag = event.get_save_flag(300) or flag
		flag_2 = event.get_save_flag(304) or flag_2
		flag_3 = event.get_save_flag(306) or flag_3
		flag_4 = event.get_save_flag(324) or flag_4
		flag_5 = event.get_save_flag(328) or flag_5
		flag_6 = event.get_save_flag(330) or flag_6
		if flag == 1 then
			now_party_chara_id = event.get_party_npc() or now_party_chara_id
			if
				flag_2 == 0
				or flag_3 == 0 and now_party_chara_id == 6
				or flag_4 == 1 and flag_5 == 0
				or flag_4 == 1 and flag_6 == 0
			then
				if not (flag_4 == 1 and flag_5 == 0) then
					event.skip_next_music_load()
				end
				event.jump_to_map_3(-1, "g02i02", 100)
				at = 1
				vm.wait(1)
				print("--- MAP_JUMP(g02i02) ---\n")
				return
			end
		end
		event.go_to_interior_map(-1, "g02i02", 100)
		at = 2
		vm.wait(2)
		print("--- GOTO_INTERIOR(g02i02) ---\n")
		return
	end, function(received: { any })
		if at <= 1 then
			print("--- MAP_JUMP(g02i02) ---\n")
			return 0
		end
		if at <= 2 then
			print("--- GOTO_INTERIOR(g02i02) ---\n")
			return 0
		end
		return nil
	end)
end

script.event_210 = event_210

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_a80f4eb9(vm.f32(-743.2), 0.0, vm.f32(-708.9), vm.f32(-0.64))
	event.jump_to_map_2(-1, "f02")
	vm.wait(2)
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_5d4cb629(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	if helper_660198d9() ~= 0 then
		event.jump_to_map_2(-1, "s04")
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local flag: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	flag = event.get_save_flag(306) or flag
	if flag == 0 then
		helper_22a04()
	elseif helper_7581838c() ~= 0 then
		event.set_dungeon_stage_id(2)
		event.open_event_menu(3, 2)
		vm.wait(3)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			var3 = out3 or var3
		end
		if var3 == 0 then
			helper_47df9e39()
		else
			flag_2 = event.get_save_flag(307) or flag_2
			flag_3 = event.get_save_flag(344) or flag_3
			if var3 == 2 and flag_2 == 0 or var3 == 21 and flag_3 == 0 or var3 == 22 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(2, var3, 1010)
		end
	end
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_a57b0158()
	helper_58610e3d()
	helper_5d4cb629(1)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	helper_a57b0158()
	helper_45b56d46()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	helper_981199f4()
	helper_6fd68c14()
end

--- Event 13020, which map data, a script or the engine runs by number.
script.event_13020 = helper_2e69f380

return script
