--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8a64cd6a = require("@lib/event/helper_8a64cd6a")
local helper_f78c4e0e = require("@lib/event/helper_f78c4e0e")

--- Helper function.
local function helper_d1419c31(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f78c4e0e(1)
		end
		if at <= 2 then
			helper_8a64cd6a(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_f78c4e0e(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_8a64cd6a(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_d1419c31
