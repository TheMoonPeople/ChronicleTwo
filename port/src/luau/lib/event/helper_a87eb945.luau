--!strict
-- Shared event helper used by 130 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Helper function.
local function helper_a87eb945(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	argc = event.CheckGetItemLimit() or argc
	argc_2 = event.CheckItemOver() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		if arg0 == 1 then
			event.SetFadeOut(10)
			helper_25abe6d2(10)
		end
		argc_3 = event.GetNowLoopNo() or argc_3
		if argc_3 == 1 then
			event.GotoMenu(16)
			vm.wait(2)
		end
		if argc_3 == 2 then
			event.GotoMenu(17)
			vm.wait(3)
		end
		if arg0 == 1 then
			event.SetFadeIn(10)
		end
	end
end

return helper_a87eb945
