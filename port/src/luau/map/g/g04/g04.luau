--!strict
-- map/g/g04/g04.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_10d6108d = require("@lib/event/helper_10d6108d")
local helper_5a735084 = require("@lib/event/helper_5a735084")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8c87ba09 = require("@lib/event/helper_8c87ba09")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_981c86d9 = require("@lib/event/helper_981c86d9")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_9e1e3514 = require("@lib/event/helper_9e1e3514")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d622cd71 = require("@lib/event/helper_d622cd71")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

--- Helper function.
local function helper_189a8()
	event.initialize_event()
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-1356.86, 83.9, -1168.92)
	event.set_camera_sequence_look_at(-1484.75, 27.8, -1316.45)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -1627.77, 0.0, -1432.14)
	event.set_object_sequence_rotation(0, 0.0, 1.12, 0.0)
	event.set_object_sequence_motion(0, "走り", 4)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 60)
	event.add_object_sequence_path_point(0, -1627.77, 0.0, -1432.14)
	event.add_object_sequence_path_point(0, -1529.23, 0.0, -1370.02)
	event.add_object_sequence_path_point(0, -1477.71, 0.0, -1329.77)
	event.start_object_sequence_path(0)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	helper_888ab2a3(60)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

--- Helper function.
local function helper_16f40()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 16)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 2123.53, 0.0, -172.9)
	event.set_object_sequence_rotation(0, 0.0, -1.54, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(2113.85, 58.0, -172.0)
	event.set_camera_sequence_look_at(1961.18, 30.0, -219.86)
	event.set_object_sequence_position(0, 2084.3, 0.0, -181.26)
	event.set_object_sequence_rotation(0, 0.0, -1.87, 0.0)
	event.move_object_sequence(0, 1961.18, 0.0, -219.86, 40)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.delay_object_sequence_motion_track(0, 40)
	event.set_object_sequence_motion(0, "立ち")
	event.fade_in_screen(15)
	helper_888ab2a3(50)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(0)
end

--- Helper function.
local function helper_1742c()
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
		var0 = helper_ed4dc120(5, 87)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(1741.43, 158.18, -323.48)
			event.set_camera_sequence_look_at(1987.85, 77.48, -185.67)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 70)
			event.add_object_sequence_path_point(0, 2073.86, 0.0, -146.5)
			event.add_object_sequence_path_point(0, 2172.98, -1.14, -140.36)
			event.add_object_sequence_path_point(0, 2239.86, -9.63, -132.92)
			event.add_object_sequence_path_point(0, 2337.56, -22.03, -101.25)
			event.start_object_sequence_path(0)
			at = 2
			helper_888ab2a3(50)
			event.fade_out_screen(20)
			at = 3
			helper_888ab2a3(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(-1.57)) * 30.0) + var1)
			var5 = 0.0
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(-1.57)) * 30.0) + var3)
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
				at = 4
				vm.wait(4)
			end
		end
		event.set_object_handle_footstep_sound(0, 0)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(50)
			end
			if at <= 2 then
				helper_038a2e4d(20)
			end
			return 1
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_17edc()
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
		var0 = helper_ed4dc120(5, 79)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-1344.5, 29.04, -1202.39)
			event.set_camera_sequence_look_at(-1454.01, 30.0, -1310.84)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.delay_object_sequence_motion_track(0, 60)
			event.set_object_sequence_motion(0, "立ち")
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, -1491.32, 0.0, -1347.87)
			event.add_object_sequence_path_point(0, -1566.57, 0.0, -1398.85)
			event.add_object_sequence_path_point(0, -1646.11, 0.0, -1452.77)
			event.start_object_sequence_path(0)
			at = 2
			helper_888ab2a3(40)
			event.fade_out_screen(20)
			at = 3
			helper_888ab2a3(20)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(0.9)) * 30.0) + var1)
			var5 = 0.0
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(0.9)) * 30.0) + var3)
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
				at = 4
				vm.wait(4)
			end
		end
		event.set_object_handle_footstep_sound(0, 0)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(40)
			end
			if at <= 2 then
				helper_038a2e4d(20)
			end
			return 1
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local old_map_no: s32 = 0
	local var1: s32 = 0
	local mc_load: s32 = 0
	event.initialize_event()
	event_99()
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		event.set_character_position(0, -1349.6, 0.0, -1351.7)
		event.set_character_rotation(0, 0.0, 1.03, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0, 20.0)
	else
		old_map_no = event.get_previous_map() or old_map_no
		var1 = event.get_map_type(old_map_no) or var1
		if var1 ~= -1 then
			if old_map_no ~= 3 then
				if var1 == 7 or var1 == 8 then
					helper_189a8()
				elseif old_map_no == 102 then
					helper_9dafbc83(vm.f32(1773.7), 0.0, -418.0, vm.f32(-1.22))
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(15)
				else
					helper_16f40()
				end
			end
		end
	end
	helper_9e1e3514(1)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_8c87ba09(vm.f32(1773.7), 0.0, -418.0, vm.f32(-1.22))
	if (if helper_d622cd71() == 0 and helper_10d6108d() == 0 then helper_981c86d9() else 0) ~= 0 then
		event.skip_next_music_play()
	end
	if helper_5a735084() ~= 0 then
		event.jump_to_map_2(-1, "s39")
		vm.wait(2)
		return
	end
	event.jump_to_map_2(-1, "f04")
	vm.wait(3)
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_9e1e3514(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event.initialize_event()
	event_99()
	helper_9dafbc83(1680.0, 0.0, -420.0, vm.f32(1.57))
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	vm.wait(1)
	helper_9e1e3514(1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	event.initialize_event()
	helper_9dafbc83(vm.f32(1982.08), 0.0, vm.f32(-201.51), vm.f32(-1.58))
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	vm.wait(1)
end

--- Event 551, which map data, a script or the engine runs by number.
function script.event_551()
	if helper_1742c() ~= 0 then
		event.jump_to_map_2(-1, "s10")
		vm.wait(2)
	end
end

--- Event 552, which map data, a script or the engine runs by number.
function script.event_552()
	local var2: s32 = 0
	if helper_17edc() ~= 0 then
		event.set_dungeon_stage_id(4)
		event.open_event_menu(3, 4)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			var2 = out3 or var2
		end
		if var2 == 0 then
			helper_189a8()
		else
			if var2 == 21 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(4, var2, 1010)
		end
	end
end

return script
