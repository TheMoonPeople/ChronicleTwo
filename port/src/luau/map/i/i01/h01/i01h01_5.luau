--!strict
-- map/i/i01/h01/i01h01_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_24bece14 = require("@lib/event/helper_24bece14")
local helper_7428e09f = require("@lib/event/helper_7428e09f")
local helper_788a73ff = require("@lib/event/helper_788a73ff")
local helper_99174c56 = require("@lib/event/helper_99174c56")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	print("i01h01--------start event----------\n")
	helper_7428e09f()
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c_1.stb", 151)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	flag = event.get_save_flag(18) or flag
	if flag == 1 then
		flag = event.get_save_flag(17) or flag
		if flag == 0 then
			event.play_music(0)
			event.set_save_flag(17, 1)
		end
	end
	flag_2 = event.get_save_flag(105) or flag_2
	flag_3 = event.get_save_flag(109) or flag_3
	flag = event.get_save_flag(56) or flag
	if flag_2 ~= 0 and flag_3 == 0 and flag == 0 then
		event.skip_next_music_load()
	end
	event.fade_out_screen(1)
	vm.wait(1)
	event.fade_in_screen(30)
	vm.wait(2)
	event.go_to_outside_map(-1, "m01")
	vm.wait(3)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_24bece14()
	event.set_function_point_enabled("", "fc_event_e108c", 0)
	print("e105a i01h01.stb-------------------\n")
	event.load_event_script("i01h01/i01h01b_1.stb", 500)
	vm.wait(1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local at: number = 0
	return vm.guard(function()
		helper_24bece14()
		event.load_character(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.set_character_active(1, 25)
		event.set_character_active(0, 24)
		event.set_character_position(25, -120.88, -13.05, -215.36)
		event.set_character_rotation(25, 0.0, 0.0, 0.0)
		at = 1
		vm.wait(1)
		print("スティーブ読み込んだ-------------\n")
		event.load_event_script("i01h01/i01h01c_1.stb", 510)
		print("いべんとe108b--------------\n")
		at = 2
		vm.wait(2)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				print("スティーブ読み込んだ-------------\n")
				print("いべんとe108b--------------\n")
			end
			return 0
		end
		return nil
	end)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_24bece14()
	event.load_event_script("i01h01/i01h01c_1.stb", 520)
	vm.wait(1)
end

--- Event 590, which map data, a script or the engine runs by number.
function script.event_590()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, var0, var1, var2, 10)
	wait_frames(10)
	helper_f38eabca(386, 1)
	event.add_inventory_item(386)
	helper_a87eb945(1)
	helper_24bece14()
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	print("event_610-------\n")
	helper_24bece14()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
		vm.wait(1)
		at = 2
		helper_99174c56()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_788a73ff()
			end
			return 0
		end
		return nil
	end)
end

--- Event 11051, which map data, a script or the engine runs by number.
function script.event_11051()
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b_1.stb", 500)
	vm.wait(2)
end

--- Event 11052, which map data, a script or the engine runs by number.
function script.event_11052()
	helper_7428e09f()
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b_1.stb", 510)
	vm.wait(2)
end

--- Event 11053, which map data, a script or the engine runs by number.
function script.event_11053()
	helper_7428e09f()
	event.set_save_flag(20, 0)
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b_1.stb", 11053)
	vm.wait(2)
end

--- Event 11060, which map data, a script or the engine runs by number.
function script.event_11060()
	helper_7428e09f()
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c_1.stb", 500)
	vm.wait(2)
end

--- Event 11083, which map data, a script or the engine runs by number.
function script.event_11083()
	event.set_party_member(2, 1)
	event.set_save_flag(25, 1)
	event.set_save_flag(108, 0)
	event.set_save_flag(103, 1)
	event.set_save_flag(107, 1)
	event.set_save_flag(7, 0)
	event.set_save_flag(6, 1)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c_1.stb", 520)
	vm.wait(2)
end

return script
