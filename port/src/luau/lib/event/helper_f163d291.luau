--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bc35b402 = require("@lib/event/helper_bc35b402")
local helper_c3876c9a = require("@lib/event/helper_c3876c9a")

--- Helper function.
local function helper_f163d291(arg0: any, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c3876c9a(1)
		end
		if at <= 2 then
			helper_bc35b402(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_c3876c9a(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_bc35b402(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_f163d291
