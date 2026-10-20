--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b534299b = require("@lib/event/helper_b534299b")
local helper_c14e497f = require("@lib/event/helper_c14e497f")

--- Helper function.
local function helper_4a298970()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b534299b()
		end
		if at <= 2 then
			helper_c14e497f(7120010)
		end
		if at <= 3 then
			helper_c14e497f(7120015)
		end
	end
	event.SetFlag(712, 1)
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e700/e712/")
	event.SetLoadbgFile("e712_1.txt")
	if vm.wait() then
		return skip(1)
	end
	helper_b534299b()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadMes(0, 5, "e712_1.txt")
	event.ChangeDir("")
	helper_c14e497f(7120010)
	if vm.skipping() then
		return skip(3)
	end
	helper_c14e497f(7120015)
	if vm.skipping() then
		return skip(4)
	end
	event.LoadMes(0, -1)
	event.Finish()
end

return helper_4a298970
