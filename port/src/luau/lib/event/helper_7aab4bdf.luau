--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c85a55f2 = require("@lib/event/helper_c85a55f2")

--- Helper function.
local function helper_7aab4bdf()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_c85a55f2(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_c85a55f2(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_c85a55f2(10)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_7aab4bdf
