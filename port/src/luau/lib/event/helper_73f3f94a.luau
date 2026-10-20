--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_29a88422 = require("@lib/event/helper_29a88422")
local helper_9d5ade37 = require("@lib/event/helper_9d5ade37")

--- Helper function.
local function helper_73f3f94a(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_29a88422(1)
		end
		if at <= 2 then
			helper_9d5ade37(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_29a88422(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_9d5ade37(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_73f3f94a
