--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8bec73c7 = require("@lib/event/helper_8bec73c7")
local helper_c7af224d = require("@lib/event/helper_c7af224d")

--- Helper function.
local function helper_5a9e3714(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c7af224d(1)
		end
		if at <= 2 then
			helper_8bec73c7(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_c7af224d(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_8bec73c7(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_5a9e3714
