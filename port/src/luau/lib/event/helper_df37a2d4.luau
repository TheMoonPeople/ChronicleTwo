--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")

--- Helper function.
local function helper_df37a2d4()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_100ac525(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_100ac525(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_100ac525(10)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_df37a2d4
