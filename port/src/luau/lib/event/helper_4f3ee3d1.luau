--!strict
-- Shared event helper used by 30 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_452267a4 = require("@lib/event/helper_452267a4")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_4f3ee3d1(arg0: s32, arg1: s32, param: s32)
	event.fade_out_screen(25)
	wait_frames(30)
	event.open_event_menu(6, param)
	vm.wait(2)
	helper_452267a4(arg0, arg1)
	event.fade_in_screen(30)
end

return helper_4f3ee3d1
