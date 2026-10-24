--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_93cb8168()
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_888ab2a3(10)
	event.GotoMenu(7)
	vm.wait(2)
	event.SetFadeIn(10)
	helper_888ab2a3(10)
end

return helper_93cb8168
