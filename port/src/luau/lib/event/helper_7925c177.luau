--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_803621f6 = require("@lib/event/helper_803621f6")
local helper_c312db26 = require("@lib/event/helper_c312db26")

--- Helper function.
local function helper_7925c177(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_803621f6(1)
		end
		if at <= 2 then
			helper_c312db26(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_803621f6(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_c312db26(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_7925c177
