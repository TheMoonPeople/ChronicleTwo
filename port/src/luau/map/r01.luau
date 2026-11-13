--!strict
--- Event script for the debug map r01 that loads a row of test characters.

local vm = require("@lib/vm")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Loads four test characters and lines them up.
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

--- Waits for a button press.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(32)
end

return script
