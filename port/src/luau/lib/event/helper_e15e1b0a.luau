--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_514aa6a3 = require("@lib/event/helper_514aa6a3")

--- Helper function.
local function helper_e15e1b0a(arg0: s32, arg1: s32, arg2: s32)
	event.SetFadeOut(25)
	helper_25abe6d2(30)
	event.GotoMenu(6, arg2)
	vm.wait(2)
	helper_514aa6a3(arg0, arg1)
	event.SetFadeIn(30)
end

return helper_e15e1b0a
