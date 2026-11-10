--!strict
-- map/s/s01/s01_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c718064 = require("@lib/event/helper_0c718064")
local helper_1214600e = require("@lib/event/helper_1214600e")
local helper_21e37ba4 = require("@lib/event/helper_21e37ba4")
local helper_2fce1ae3 = require("@lib/event/helper_2fce1ae3")
local helper_72a5f155 = require("@lib/event/helper_72a5f155")
local helper_bac19723 = require("@lib/event/helper_bac19723")
local helper_ce837ecc = require("@lib/event/helper_ce837ecc")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	flag = event.get_save_flag(202) or flag
	if flag == 0 then
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.set_object_handle_position(0, 0.0, 0.0, -2000.0)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	event_99()
	flag = event.get_save_flag(201) or flag
	if flag == 0 then
		event.set_dungeon_floor_info(0, 8, 7, 1)
		event.set_dungeon_floor_info(0, 8, 5, 2)
		helper_2fce1ae3()
	else
		helper_ce837ecc()
	end
	helper_21e37ba4()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_72a5f155

--- Event 160, which map data, a script or the engine runs by number.
function script.event_160()
	event.fade_out_screen(30, 255.0, 255.0, 255.0)
	wait_frames(30)
	event.jump_to_map_2(-1, "g02")
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		at = 2
		helper_bac19723()
		event.skip_next_music_load()
		event.jump_to_map_3(-1, "s08", 501)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_bac19723()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s08", 501)
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
	helper_0c718064(2)
	helper_2fce1ae3()
	helper_21e37ba4()
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_motion(0, "立ち", 4)
	var1 = helper_ed4dc120(5, 55)
	if var1 == 0 then
		event.set_camera_sequence_position(-637.75, 234.47, 94.15)
		event.set_camera_sequence_look_at(-573.29, 154.14, -234.77)
		event.set_object_sequence_position(0, -571.45, 132.37, -243.31)
		event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_camera_sequence(-637.75, 234.47, 94.15, -561.56, 145.42, -381.61, 45)
		event.move_object_sequence(0, -570.49, 132.37, -362.93, 45)
		wait_frames(15)
		event.fade_out_screen(30)
		wait_frames(30)
		helper_1214600e()
		return 1
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	var2 = vm.f32(var2 + vm.f32(30.0 * vm.sin(0.0)))
	var4 = vm.f32(var4 + vm.f32(30.0 * vm.cos(0.0)))
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 15)
	event.move_object_sequence(0, var2, var3, var4, 45)
	for var5 = 0, 44 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.set_camera_sequence_look_at(var2, var3 + 30.0, var4)
		vm.wait(5)
	end
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	return 0
end

--- Event 601, which map data, a script or the engine runs by number.
function script.event_601()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var0 = vm.f32(var0 + vm.f32(30.0 * vm.sin(vm.f32(3.1415927))))
	var2 = vm.f32(var2 + vm.f32(30.0 * vm.cos(vm.f32(3.1415927))))
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.rotate_object_sequence(0, 0.0, 3.1415927, 0.0, 15)
	event.move_object_sequence(0, var0, var1, var2, 45)
	for var3 = 0, 44 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		event.set_camera_sequence_look_at(var0, var1 + 30.0, var2)
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "[UNI00c8] pericoloso andare oltre.\nPrendiamo il treno.")
	show_message(0, -1, 5, 0, 0)
	event.set_message_bubble_tail(0, 1)
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		at = 2
		helper_bac19723()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_bac19723()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 12010, which map data, a script or the engine runs by number.
script.event_12010 = helper_2fce1ae3

--- Event 12020, which map data, a script or the engine runs by number.
function script.event_12020()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		at = 2
		helper_bac19723()
		event.fade_out_screen(30)
		at = 3
		wait_frames(30)
		event.skip_next_music_load()
		event.jump_to_map_3(-1, "s08", 501)
		at = 4
		vm.wait(4)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				at = 2
				helper_bac19723()
				return vm.continue_with(function()
					event.fade_out_screen(30)
					at = 3
					wait_frames(30)
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s08", 501)
					at = 4
					vm.wait(4)
					return
				end)
			end
			if at <= 2 then
				wait_frames_skipping(30)
			end
			return 0
		end
		return nil
	end)
end

return script
