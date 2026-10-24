--!strict
-- Shared event helper used by 55 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Helper function.
local function helper_f57795f8()
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_25abe6d2(10)
	event.GotoMenu(7)
	vm.wait(2)
	event.SetFadeIn(10)
	helper_25abe6d2(10)
end

return helper_f57795f8
