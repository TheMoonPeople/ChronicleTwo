--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_1565f910()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_aafd6a80(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_1565f910
