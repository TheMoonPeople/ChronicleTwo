--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bc77b237 = require("@lib/event/helper_bc77b237")

--- Helper function.
local function helper_867cb812(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	argc = event.CheckGetItemLimit() or argc
	argc_2 = event.CheckItemOver() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		if arg0 == 1 then
			event.SetFadeOut(10)
			helper_bc77b237(10)
			if vm.skipping() then
				return skip(1)
			end
		end
		argc_3 = event.GetNowLoopNo() or argc_3
		if argc_3 == 1 then
			event.GotoMenu(16)
			if vm.wait() then
				return skip(2)
			end
		end
		if argc_3 == 2 then
			event.GotoMenu(17)
			if vm.wait() then
				return skip(3)
			end
		end
		if arg0 == 1 then
			event.SetFadeIn(10)
		end
	end
end

return helper_867cb812
