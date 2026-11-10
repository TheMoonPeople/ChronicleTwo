--!strict
-- map/s/s07/s07_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_5be5f988 = require("@lib/event/helper_5be5f988")
local helper_74085f48 = require("@lib/event/helper_74085f48")
local helper_87af1001 = require("@lib/event/helper_87af1001")
local helper_94e331d8 = require("@lib/event/helper_94e331d8")
local helper_a2b848af = require("@lib/event/helper_a2b848af")
local helper_df4094fb = require("@lib/event/helper_df4094fb")
local show_message = require("@lib/event/show_message")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.initialize_event()
	print("##IN_START_EVENT################################\n")
	helper_a2b848af()
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(1, 3)
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.open_message_window_2(0, "キ(O)ター[l1]ー[r1]ー[l2]ー[r2]ー")
	show_message(0, -1, 8, 0, 0)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	print("--------------------------event200-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.set_save_counter(15, 1)
		event.fade_out_screen(0)
		helper_94e331d8()
		event.stop_music(0)
		helper_5be5f988()
	end
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local var0: s32 = 0
	print("--------------------------event201-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.set_save_counter(15, 0)
		event.fade_out_screen(0)
		helper_94e331d8()
		event.stop_music(0)
		helper_5be5f988()
	end
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local var0: s32 = 0
	print("--------------------------event202-------------------------\n")
	event.fade_out_screen(0)
	helper_94e331d8()
	var0 = event.get_save_counter(0) or var0
	if var0 == 1 then
		event.set_save_counter(0, 0)
		event.set_character_position(0, 0.0, 36.0, -100.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.jump_to_map_2(-1, "s08")
	else
		var0 = vm.i32(var0 - 1)
		event.set_save_counter(0, var0)
		helper_a2b848af()
		event.set_character_position(0, 0.0, 36.0, -235.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.initialize_event()
		event.close_message_window(1)
		event.fade_in_screen(30)
		event.finish_event()
	end
end

--- Event 203, which map data, a script or the engine runs by number.
function script.event_203()
	local var0: s32 = 0
	print("--------------------------event203-------------------------\n")
	var0 = event.get_save_counter(0) or var0
	if var0 ~= 3 then
		event.fade_out_screen(0)
		helper_94e331d8()
		var0 = vm.i32(var0 + 1)
		event.set_save_counter(0, var0)
		helper_a2b848af()
		event.set_character_position(0, 0.0, 36.0, 235.0)
		event.set_character_rotation(0, 0.0, 3.14, 0.0)
		event.initialize_event()
		event.close_message_window(1)
		event.fade_in_screen(30)
		event.finish_event()
	end
end

--- Event 205, which map data, a script or the engine runs by number.
function script.event_205()
	local var0: s32 = 0
	print("--------------------------event205-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 206, which map data, a script or the engine runs by number.
function script.event_206()
	local var0: s32 = 0
	print("--------------------------event206-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 207, which map data, a script or the engine runs by number.
function script.event_207()
	print("--------------------------event207-------------------------\n")
end

--- Event 208, which map data, a script or the engine runs by number.
function script.event_208()
	local var0: s32 = 0
	print("--------------------------event208-------------------------\n")
	var0 = event.get_save_counter(0) or var0
	if var0 == 3 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local argc: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	argc = event.get_local_event_counter(var0) or argc
	if argc == 34 then
		event.set_message_window_option(1, 10, 0)
		helper_87af1001()
		event.set_message_window_option(1, 10, 128)
	else
		helper_74085f48(var0, 0)
	end
end

return script
