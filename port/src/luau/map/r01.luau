--!strict
-- map/r01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.change_directory("chara/")
	event.load_character(4, "c002a.chr", "info", 8)
	event.set_character_active(1, 8)
	event.set_character_position(8, -100.0, 0.0, 0.0)
	event.load_character(4, "c005a.chr", "info", 9)
	event.set_character_active(1, 9)
	event.set_character_position(9, -50.0, 0.0, 0.0)
	event.load_character(4, "sraim.chr", "info", 10)
	event.set_character_active(1, 10)
	event.set_character_position(10, 0.0, 0.0, 0.0)
	event.load_character(4, "a_ku.chr", "info", 11)
	event.set_character_active(1, 11)
	event.set_character_position(11, 50.0, 0.0, 0.0)
	event.change_directory("")
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(32)
end

return script
