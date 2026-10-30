--!strict
-- map/i/i01/h07/i01h07_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_02d91c01 = require("@lib/event/helper_02d91c01")
local helper_e3fbd10f = require("@lib/event/helper_e3fbd10f")

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
	helper_e3fbd10f(0, 5)
end

--- Event 402, which map data, a script or the engine runs by number.
function script.event_402()
	helper_e3fbd10f(0, 4)
end

--- Event 403, which map data, a script or the engine runs by number.
function script.event_403()
	helper_e3fbd10f(0, 3)
end

--- Event 404, which map data, a script or the engine runs by number.
function script.event_404()
	helper_e3fbd10f(0, 2)
end

--- Event 405, which map data, a script or the engine runs by number.
function script.event_405()
	helper_e3fbd10f(0, 1)
end

--- Event 406, which map data, a script or the engine runs by number.
function script.event_406()
	helper_e3fbd10f(0, 0)
end

--- Event 407, which map data, a script or the engine runs by number.
function script.event_407()
	helper_e3fbd10f(1, 6)
end

--- Event 408, which map data, a script or the engine runs by number.
function script.event_408()
	helper_e3fbd10f(1, 5)
end

--- Event 409, which map data, a script or the engine runs by number.
function script.event_409()
	helper_e3fbd10f(1, 4)
end

--- Event 410, which map data, a script or the engine runs by number.
function script.event_410()
	helper_e3fbd10f(1, 3)
end

--- Event 411, which map data, a script or the engine runs by number.
function script.event_411()
	helper_e3fbd10f(1, 2)
end

--- Event 412, which map data, a script or the engine runs by number.
function script.event_412()
	helper_e3fbd10f(1, 1)
end

--- Event 413, which map data, a script or the engine runs by number.
function script.event_413()
	helper_e3fbd10f(1, 0)
end

--- Event 414, which map data, a script or the engine runs by number.
function script.event_414()
	helper_e3fbd10f(0, 6)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_02d91c01

return script
