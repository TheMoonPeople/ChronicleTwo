--!strict
-- map/i/i01/h07/i01h07.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4e319702 = require("@lib/event/helper_4e319702")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_bac0dab2 = require("@lib/event/helper_bac0dab2")

--- Helper function.
local function helper_364e0(arg0: s32, arg1: s32)
	event.set_character_motion(0, "立ち")
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-5.74, 133.71, 0.0)
	event.set_camera_sequence_look_at(-143.54, 66.02, 0.0)
	helper_888ab2a3(45)
	helper_bac0dab2(arg0, arg1)
	helper_bac0dab2(vm.i32(arg0 + 1), arg1)
	helper_bac0dab2(vm.i32(arg0 - 1), arg1)
	helper_bac0dab2(arg0, vm.i32(arg1 + 1))
	helper_bac0dab2(arg0, vm.i32(arg1 - 1))
	helper_888ab2a3(45)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local now_map_no: s32 = 0
	local now_sub_map_no: s32 = 0
	now_map_no = event.get_current_map() or now_map_no
	now_sub_map_no = event.get_current_submap() or now_sub_map_no
	print(
		"##########################map_no=",
		now_map_no,
		",submap_no=",
		now_sub_map_no,
		"###########################\n"
	)
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	helper_364e0(0, 5)
end

--- Event 402, which map data, a script or the engine runs by number.
function script.event_402()
	helper_364e0(0, 4)
end

--- Event 403, which map data, a script or the engine runs by number.
function script.event_403()
	helper_364e0(0, 3)
end

--- Event 404, which map data, a script or the engine runs by number.
function script.event_404()
	helper_364e0(0, 2)
end

--- Event 405, which map data, a script or the engine runs by number.
function script.event_405()
	helper_364e0(0, 1)
end

--- Event 406, which map data, a script or the engine runs by number.
function script.event_406()
	helper_364e0(0, 0)
end

--- Event 407, which map data, a script or the engine runs by number.
function script.event_407()
	helper_364e0(1, 6)
end

--- Event 408, which map data, a script or the engine runs by number.
function script.event_408()
	helper_364e0(1, 5)
end

--- Event 409, which map data, a script or the engine runs by number.
function script.event_409()
	helper_364e0(1, 4)
end

--- Event 410, which map data, a script or the engine runs by number.
function script.event_410()
	helper_364e0(1, 3)
end

--- Event 411, which map data, a script or the engine runs by number.
function script.event_411()
	helper_364e0(1, 2)
end

--- Event 412, which map data, a script or the engine runs by number.
function script.event_412()
	helper_364e0(1, 1)
end

--- Event 413, which map data, a script or the engine runs by number.
function script.event_413()
	helper_364e0(1, 0)
end

--- Event 414, which map data, a script or the engine runs by number.
function script.event_414()
	helper_364e0(0, 6)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_4e319702

return script
