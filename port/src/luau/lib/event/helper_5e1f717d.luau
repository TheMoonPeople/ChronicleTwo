--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_452267a4 = require("@lib/event/helper_452267a4")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_5e1f717d(arg0: s32, arg1: s32, param: s32)
	event.fade_out_screen(25)
	helper_888ab2a3(30)
	event.open_event_menu(6, param)
	vm.wait(2)
	helper_452267a4(arg0, arg1)
	event.fade_in_screen(30)
end

return helper_5e1f717d
