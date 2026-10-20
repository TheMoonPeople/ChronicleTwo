--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b12c5622 = require("@lib/event/helper_b12c5622")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_ce2ff24d(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(30)
		end
		helper_b12c5622(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg2)
	if vm.wait() then
		return skip(3)
	end
	helper_b12c5622(arg0, arg1)
	event.SetFadeIn(30)
end

return helper_ce2ff24d
