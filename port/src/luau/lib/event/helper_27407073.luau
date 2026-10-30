--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")

--- Helper function.
local function helper_27407073()
	event.set_save_flag(712, 1)
	event.set_character_motion(0, "立ち")
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.change_directory("event/e700/e712/")
	event.start_background_file_loads_1("e712_1.txt")
	vm.wait(1)
	helper_479dc9e9()
	event.load_message_file(0, 5, "e712_1.txt")
	event.change_directory("")
	helper_4116e6bb(7120010)
	helper_4116e6bb(7120015)
	event.load_message_file(0, -1)
	event.finish_event()
end

return helper_27407073
