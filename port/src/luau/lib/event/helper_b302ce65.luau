--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2bd00f1e = require("@lib/event/helper_2bd00f1e")
local helper_b5f02d99 = require("@lib/event/helper_b5f02d99")

--- Helper function.
local function helper_b302ce65(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b5f02d99(1)
		end
		if at <= 2 then
			helper_2bd00f1e(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_b5f02d99(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_2bd00f1e(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_b302ce65
