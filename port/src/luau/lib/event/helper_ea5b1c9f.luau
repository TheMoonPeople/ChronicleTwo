--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_9a932dc0 = require("@lib/event/helper_9a932dc0")

--- Helper function.
local function helper_ea5b1c9f(arg0: s32)
	event.SetFadeOut(25)
	helper_25abe6d2(30)
	event.GotoMenu(6, arg0)
	vm.wait(2)
	helper_9a932dc0()
	event.SetFadeIn(30)
end

return helper_ea5b1c9f
