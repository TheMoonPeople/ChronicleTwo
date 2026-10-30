--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_93cb8168()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.fade_out_screen(10)
	helper_888ab2a3(10)
	event.open_event_menu(7)
	vm.wait(2)
	event.fade_in_screen(10)
	helper_888ab2a3(10)
end

return helper_93cb8168
