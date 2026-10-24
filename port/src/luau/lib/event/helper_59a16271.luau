--!strict
-- Shared event helper used by 145 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Helper function.
local function helper_59a16271(arg0: s32)
	event.SetFadeOut(15)
	helper_25abe6d2(15)
	event.GotoMenu(6, arg0)
	vm.wait(2)
	event.SetFadeIn(15)
end

return helper_59a16271
