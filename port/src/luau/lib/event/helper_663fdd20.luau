--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a739b05c = require("@lib/event/helper_a739b05c")
local helper_c746120b = require("@lib/event/helper_c746120b")

--- Helper function.
local function helper_663fdd20(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(30)
		end
		helper_a739b05c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg2)
	if vm.wait() then
		return skip(3)
	end
	helper_a739b05c(arg0, arg1)
	event.SetFadeIn(30)
end

return helper_663fdd20
