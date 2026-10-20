--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")

--- Helper function.
local function helper_0f1c5378()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_ff0edc1d(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_0f1c5378
