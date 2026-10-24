--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b1fa2fcf = require("@lib/event/helper_b1fa2fcf")
local helper_fdd8b5e6 = require("@lib/event/helper_fdd8b5e6")

--- Helper function.
local function helper_fb3ebbea(arg0: any, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fdd8b5e6(1)
		end
		if at <= 2 then
			helper_b1fa2fcf(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_fdd8b5e6(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_b1fa2fcf(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_fb3ebbea
