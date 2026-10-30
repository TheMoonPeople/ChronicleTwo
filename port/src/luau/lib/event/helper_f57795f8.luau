--!strict
-- Shared event helper used by 125 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_f57795f8()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.fade_out_screen(10)
	wait_frames(10)
	event.open_event_menu(7)
	vm.wait(2)
	event.fade_in_screen(10)
	wait_frames(10)
end

return helper_f57795f8
