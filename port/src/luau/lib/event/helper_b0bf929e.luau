--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_b0bf929e()
	event.SetFlag(712, 1)
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e700/e712/")
	event.SetLoadbgFile_1("e712_1.txt")
	vm.wait(1)
	helper_479dc9e9()
	event.LoadMes(0, 5, "e712_1.txt")
	event.ChangeDir("")
	helper_e34416e2(7120010)
	helper_e34416e2(7120015)
	event.LoadMes(0, -1)
	event.Finish()
end

return helper_b0bf929e
