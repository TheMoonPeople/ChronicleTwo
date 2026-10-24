--!strict
-- Shared event helper used by 29 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_eac5726b(arg0: s32)
	event.SetFadeOut(15)
	helper_888ab2a3(15)
	event.GotoMenu(6, arg0)
	vm.wait(2)
	event.SetFadeIn(15)
end

return helper_eac5726b
