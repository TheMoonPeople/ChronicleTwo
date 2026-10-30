--!strict
-- map/s/s37/s37_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2388e346 = require("@lib/event/helper_2388e346")
local helper_3300e99f = require("@lib/event/helper_3300e99f")
local helper_5be5f988 = require("@lib/event/helper_5be5f988")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_6bc323e2 = require("@lib/event/helper_6bc323e2")
local helper_788101d6 = require("@lib/event/helper_788101d6")
local helper_cd753c35 = require("@lib/event/helper_cd753c35")
local helper_df4094fb = require("@lib/event/helper_df4094fb")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_788101d6

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	local var1: s32 = 0
	print("--------------------------event200-------------------------\n")
	helper_3300e99f(vm.f32(-1.5707964))
	var0 = event.get_sound_id(2) or var0
	var1 = helper_df4094fb(1)
	if var1 ~= 0 then
		event.set_character_motion(0, "立ち")
		event.play_sound_effect(var0, 94)
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_save_counter(15, 1)
		event.stop_music(0)
		helper_5be5f988()
	else
		event.play_sound_effect(var0, 108)
		helper_5fb66cb1()
	end
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local var0: s32 = 0
	local var1: s32 = 0
	print("--------------------------event201-------------------------\n")
	helper_3300e99f(vm.f32(1.5707964))
	var0 = event.get_sound_id(2) or var0
	var1 = helper_df4094fb(0)
	if var1 ~= 0 then
		event.set_character_motion(0, "立ち")
		event.play_sound_effect(var0, 94)
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_save_counter(15, 0)
		event.stop_music(0)
		helper_5be5f988()
	else
		event.play_sound_effect(var0, 108)
		helper_5fb66cb1()
	end
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local var0: s32 = 0
	print("--------------------------event202-------------------------\n")
	helper_3300e99f(vm.f32(3.1415927))
	event.set_character_motion(0, "立ち")
	var0 = event.get_sound_id(2) or var0
	event.play_sound_effect(var0, 94)
	event.fade_out_screen(30)
	wait_frames(30)
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.set_save_counter(0, 1)
	event.set_character_position(0, 0.0, -14.0, 235.0)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	event.stop_music(0)
	event.jump_to_map_2(-1, "s38")
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_6bc323e2()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s59", 500)
	vm.wait(2)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_cd753c35()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s58", 500)
	vm.wait(2)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_2388e346()
	event.jump_to_map_3(-1, "s11", 520)
	vm.wait(2)
end

--- Event 530, which map data, a script or the engine runs by number.
function script.event_530()
	helper_788101d6()
	event.jump_to_map_3(-1, "s11", 599)
	vm.wait(2)
end

--- Event 16480, which map data, a script or the engine runs by number.
function script.event_16480()
	helper_2388e346()
	event.jump_to_map_3(-1, "s11", 520)
	vm.wait(2)
end

return script
