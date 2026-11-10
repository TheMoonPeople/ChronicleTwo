--!strict
-- map/s/s33/s33_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_36ebb51a = require("@lib/event/helper_36ebb51a")
local helper_455f6141 = require("@lib/event/helper_455f6141")
local helper_624074bd = require("@lib/event/helper_624074bd")
local helper_942ff222 = require("@lib/event/helper_942ff222")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a0079677 = require("@lib/event/helper_a0079677")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(600) or flag
	flag_2 = event.get_save_flag(604) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_36ebb51a()
	else
		if flag_2 == 1 then
			event.attach_object_handle_to_map_part_3(0, "p01_s3302-0", "s330208-m0")
			event.attach_object_handle_to_map_part_3(1, "p01_s3302-0", "s330208-m1")
			event.set_object_handle_rotation(0, 0.0, 0.61, 0.0)
			event.set_object_handle_rotation(1, 0.0, -0.61, 0.0)
		end
		helper_9dafbc83(0.0, 0.0, 2300.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_455f6141

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_942ff222() ~= 0 then
		event.skip_next_music_load()
		event.go_to_dungeon(5, -1, 500)
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	if helper_624074bd() ~= 0 then
		event.jump_to_map_2(-1, "s31")
	end
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_a0079677()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f02", 510)
	vm.wait(2)
end

--- Event 16040, which map data, a script or the engine runs by number.
script.event_16040 = helper_36ebb51a

return script
