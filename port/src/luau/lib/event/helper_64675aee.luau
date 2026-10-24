--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31a3b707 = require("@lib/event/helper_31a3b707")
local helper_ee3beaa9 = require("@lib/event/helper_ee3beaa9")

--- Helper function.
local function helper_64675aee(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_31a3b707(1)
		end
		if at <= 2 then
			helper_ee3beaa9(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_31a3b707(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_ee3beaa9(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_64675aee
